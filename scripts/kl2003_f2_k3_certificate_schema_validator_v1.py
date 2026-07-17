#!/usr/bin/env python3
"""Validate the KL2003 F2 k=3 certificate JSON schema.

This is a format checker only.  It does not verify KL2003 mathematics, does
not solve an LP, does not generate k=3 rows, and does not open Lean.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from math import gcd
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K3_CERTIFICATE_SCHEMA_VALIDATION_v1"
EXPECTED_SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_INPUT = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K3_CERTIFICATE_FIXTURE_v1"
    / "kl2003_k3_certificate.fixture.json"
)
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
SUMMARY_PATH = OUT_DIR / "schema_validation_summary.json"
ERRORS_PATH = OUT_DIR / "schema_validation_errors.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

RATIONAL_RE = re.compile(r"^-?(0|[1-9][0-9]*)(/([1-9][0-9]*))?$")

TOP_LEVEL_REQUIRED = [
    "metadata",
    "tracked_classes",
    "rows",
    "inverse_words",
    "deletion_marks",
    "rational_certificate",
    "slacks",
    "verification_targets",
]

METADATA_FLAGS_REQUIRED = [
    "schema_version",
    "k",
    "tracked_class_count",
    "pre_reduction_class_count",
    "artifact_links",
    "fixture_only",
    "mathematical_content",
    "not_for_lean_import",
]

ROW_REQUIRED = [
    "row_id",
    "source_class",
    "row_kind",
    "children",
    "deletion_policy",
    "coefficient_terms",
    "target_bound",
    "slack_id",
]

CHILD_REQUIRED = [
    "child_id",
    "inverse_word",
    "target_class",
    "shift",
    "window_policy",
    "fiber_parent",
    "deleted",
    "reason",
]

RATIONAL_KEY_TOKENS = {
    "value",
    "target_bound",
    "lo",
    "hi",
    "lhs",
    "rhs",
    "slack",
    "shift",
    "k",
    "modulus",
    "representative",
    "pre_reduction_class_count",
    "tracked_class_count",
    "denominator_bits",
    "numerator_bits",
    "depth",
}


@dataclass
class ValidationIssue:
    severity: str
    path: str
    code: str
    message: str


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def add_issue(
    issues: list[ValidationIssue],
    severity: str,
    path: str,
    code: str,
    message: str,
) -> None:
    issues.append(ValidationIssue(severity=severity, path=path, code=code, message=message))


def count_floats(obj: Any) -> int:
    if isinstance(obj, float):
        return 1
    if isinstance(obj, dict):
        return sum(count_floats(value) for value in obj.values())
    if isinstance(obj, list):
        return sum(count_floats(value) for value in obj)
    return 0


def rational_string_ok(value: str) -> bool:
    if not RATIONAL_RE.fullmatch(value):
        return False
    if value == "-0":
        return False
    if "/" not in value:
        return True
    numerator_text, denominator_text = value.split("/", 1)
    numerator = int(numerator_text)
    denominator = int(denominator_text)
    if denominator <= 0:
        return False
    if numerator == 0:
        return False
    if denominator == 1:
        return False
    return gcd(abs(numerator), denominator) == 1


def check_required_fields(
    obj: Any,
    fields: list[str],
    prefix: str,
    issues: list[ValidationIssue],
) -> None:
    if not isinstance(obj, dict):
        add_issue(issues, "error", prefix, "TYPE_NOT_OBJECT", "Expected object.")
        return
    for field in fields:
        if field not in obj:
            add_issue(issues, "error", f"{prefix}.{field}", "MISSING_REQUIRED_FIELD", "Required field is missing.")


def parse_canonical_nonnegative_int(value: Any) -> int | None:
    if not isinstance(value, str):
        return None
    if not rational_string_ok(value):
        return None
    if "/" in value or value.startswith("-"):
        return None
    return int(value)


def check_metadata_version_and_counts(metadata: Any, issues: list[ValidationIssue]) -> None:
    if not isinstance(metadata, dict):
        return
    schema_version = metadata.get("schema_version")
    if schema_version != EXPECTED_SCHEMA_VERSION:
        add_issue(
            issues,
            "error",
            "$.metadata.schema_version",
            "SCHEMA_VERSION_UNSUPPORTED",
            f"Expected `{EXPECTED_SCHEMA_VERSION}`.",
        )

    k = parse_canonical_nonnegative_int(metadata.get("k"))
    tracked = parse_canonical_nonnegative_int(metadata.get("tracked_class_count"))
    pre_reduction = parse_canonical_nonnegative_int(metadata.get("pre_reduction_class_count"))
    if k is None or k < 1:
        add_issue(issues, "error", "$.metadata.k", "K_INVALID", "Expected positive canonical integer string.")
        return
    if tracked is None:
        add_issue(
            issues,
            "error",
            "$.metadata.tracked_class_count",
            "TRACKED_CLASS_COUNT_INVALID",
            "Expected canonical integer string.",
        )
    elif tracked != 3 ** (k - 1):
        add_issue(
            issues,
            "error",
            "$.metadata.tracked_class_count",
            "TRACKED_CLASS_COUNT_MISMATCH",
            f"Expected 3^(k-1) = {3 ** (k - 1)} for k={k}.",
        )
    if pre_reduction is None:
        add_issue(
            issues,
            "error",
            "$.metadata.pre_reduction_class_count",
            "PRE_REDUCTION_CLASS_COUNT_INVALID",
            "Expected canonical integer string.",
        )
    elif pre_reduction != 3**k:
        add_issue(
            issues,
            "error",
            "$.metadata.pre_reduction_class_count",
            "PRE_REDUCTION_CLASS_COUNT_MISMATCH",
            f"Expected 3^k = {3**k} for k={k}.",
        )


def check_artifact_links(metadata: Any, issues: list[ValidationIssue]) -> None:
    if not isinstance(metadata, dict):
        return
    links = metadata.get("artifact_links")
    if not isinstance(links, dict):
        add_issue(issues, "error", "$.metadata.artifact_links", "ARTIFACT_LINKS_INVALID", "Expected object.")
        return
    required = [
        "json_artifact",
        "lean_data_artifact",
        "json_to_lean_generator",
        "json_sha256",
        "lean_data_sha256",
        "json_to_lean_generator_sha256",
    ]
    for key in required:
        if key not in links:
            add_issue(
                issues,
                "error",
                f"$.metadata.artifact_links.{key}",
                "MISSING_ARTIFACT_LINK_FIELD",
                "Required artifact-link field is missing.",
            )


def check_rational_strings(obj: Any, issues: list[ValidationIssue], path: str = "$") -> None:
    if isinstance(obj, dict):
        for key, value in obj.items():
            child_path = f"{path}.{key}"
            if key in RATIONAL_KEY_TOKENS:
                if not isinstance(value, str):
                    add_issue(
                        issues,
                        "error",
                        child_path,
                        "RATIONAL_NOT_STRING",
                        "Rational-like field must be encoded as a string.",
                    )
                elif not rational_string_ok(value):
                    add_issue(
                        issues,
                        "error",
                        child_path,
                        "RATIONAL_BAD_FORMAT",
                        "Expected integer string or num/den with nonzero denominator.",
                    )
            check_rational_strings(value, issues, child_path)
    elif isinstance(obj, list):
        for idx, value in enumerate(obj):
            check_rational_strings(value, issues, f"{path}[{idx}]")


def collect_ids(items: Any, id_key: str, prefix: str, issues: list[ValidationIssue]) -> dict[str, str]:
    ids: dict[str, str] = {}
    if not isinstance(items, list):
        add_issue(issues, "error", prefix, "TYPE_NOT_ARRAY", "Expected array.")
        return ids
    for idx, item in enumerate(items):
        path = f"{prefix}[{idx}]"
        if not isinstance(item, dict):
            add_issue(issues, "error", path, "TYPE_NOT_OBJECT", "Expected object.")
            continue
        value = item.get(id_key)
        if not isinstance(value, str) or not value:
            add_issue(issues, "error", f"{path}.{id_key}", "MISSING_ID", f"Missing string id field `{id_key}`.")
            continue
        if value in ids:
            add_issue(issues, "error", f"{path}.{id_key}", "DUPLICATE_ID", f"Duplicate id `{value}`.")
        else:
            ids[value] = path
    return ids


def child_signature(child: dict[str, Any]) -> tuple[Any, ...]:
    return tuple((key, json.dumps(child.get(key), sort_keys=True)) for key in CHILD_REQUIRED)


def artifact_hash_fields(data: Any) -> dict[str, Any]:
    if not isinstance(data, dict):
        return {}
    metadata = data.get("metadata")
    if not isinstance(metadata, dict):
        return {}
    links = metadata.get("artifact_links")
    if not isinstance(links, dict):
        return {}
    keys = [
        "json_artifact",
        "lean_data_artifact",
        "json_to_lean_generator",
        "json_sha256",
        "lean_data_sha256",
        "json_to_lean_generator_sha256",
    ]
    return {key: links.get(key) for key in keys if key in links}


def validate_data(data: Any, input_path: Path) -> tuple[list[ValidationIssue], dict[str, int | bool]]:
    issues: list[ValidationIssue] = []
    if not isinstance(data, dict):
        add_issue(issues, "error", "$", "TOP_LEVEL_NOT_OBJECT", "Top-level JSON value must be an object.")
        return issues, {
            "float_count": count_floats(data),
            "row_count": 0,
            "child_count": 0,
            "slack_count": 0,
            "is_fixture": input_path.name.endswith(".fixture.json"),
        }

    check_required_fields(data, TOP_LEVEL_REQUIRED, "$", issues)

    metadata = data.get("metadata", {})
    check_required_fields(metadata, METADATA_FLAGS_REQUIRED, "$.metadata", issues)
    check_metadata_version_and_counts(metadata, issues)
    check_artifact_links(metadata, issues)

    is_fixture = input_path.name.endswith(".fixture.json")
    if is_fixture and isinstance(metadata, dict):
        if metadata.get("fixture_only") is not True:
            add_issue(issues, "error", "$.metadata.fixture_only", "FIXTURE_FLAG_INVALID", "Fixture file requires fixture_only=true.")
        if metadata.get("mathematical_content") is not False:
            add_issue(
                issues,
                "error",
                "$.metadata.mathematical_content",
                "FIXTURE_FLAG_INVALID",
                "Fixture file requires mathematical_content=false.",
            )
        if metadata.get("not_for_lean_import") is not True:
            add_issue(
                issues,
                "error",
                "$.metadata.not_for_lean_import",
                "FIXTURE_FLAG_INVALID",
                "Fixture file requires not_for_lean_import=true.",
            )

    rows = data.get("rows", [])
    if isinstance(rows, list):
        for idx, row in enumerate(rows):
            row_path = f"$.rows[{idx}]"
            check_required_fields(row, ROW_REQUIRED, row_path, issues)
            if isinstance(row, dict):
                children = row.get("children", [])
                if not isinstance(children, list):
                    add_issue(issues, "error", f"{row_path}.children", "TYPE_NOT_ARRAY", "Expected children array.")
                else:
                    for child_idx, child in enumerate(children):
                        check_required_fields(child, CHILD_REQUIRED, f"{row_path}.children[{child_idx}]", issues)
    else:
        add_issue(issues, "error", "$.rows", "TYPE_NOT_ARRAY", "Expected rows array.")

    inverse_words = data.get("inverse_words", [])
    if isinstance(inverse_words, list):
        for idx, child in enumerate(inverse_words):
            check_required_fields(child, CHILD_REQUIRED, f"$.inverse_words[{idx}]", issues)
    else:
        add_issue(issues, "error", "$.inverse_words", "TYPE_NOT_ARRAY", "Expected inverse_words array.")

    check_rational_strings(data, issues)

    float_count = count_floats(data)
    if float_count:
        add_issue(issues, "error", "$", "FLOAT_VALUES_PRESENT", f"JSON contains {float_count} float value(s).")

    slack_ids = collect_ids(data.get("slacks", []), "slack_id", "$.slacks", issues)
    child_ids = collect_ids(data.get("inverse_words", []), "child_id", "$.inverse_words", issues)
    row_ids = collect_ids(data.get("rows", []), "row_id", "$.rows", issues)

    if isinstance(rows, list):
        for idx, row in enumerate(rows):
            if not isinstance(row, dict):
                continue
            row_path = f"$.rows[{idx}]"
            row_id = row.get("row_id")
            if isinstance(row_id, str) and row_ids.get(row_id) != row_path:
                pass
            slack_id = row.get("slack_id")
            if isinstance(slack_id, str) and slack_id not in slack_ids:
                add_issue(issues, "error", f"{row_path}.slack_id", "MISSING_SLACK_REF", f"Unknown slack_id `{slack_id}`.")
            children = row.get("children", [])
            if isinstance(children, list):
                for child_idx, child in enumerate(children):
                    child_path = f"{row_path}.children[{child_idx}]"
                    if not isinstance(child, dict):
                        continue
                    child_id = child.get("child_id")
                    if not isinstance(child_id, str):
                        continue
                    if child_id not in child_ids:
                        add_issue(
                            issues,
                            "error",
                            f"{child_path}.child_id",
                            "MISSING_CHILD_REF",
                            f"Inline child `{child_id}` does not appear in inverse_words.",
                        )
                    else:
                        inverse_child = next(
                            (
                                item
                                for item in data.get("inverse_words", [])
                                if isinstance(item, dict) and item.get("child_id") == child_id
                            ),
                            None,
                        )
                        if isinstance(inverse_child, dict) and child_signature(child) != child_signature(inverse_child):
                            add_issue(
                                issues,
                                "error",
                                child_path,
                                "INLINE_CHILD_MISMATCH",
                                f"Inline child `{child_id}` is not consistent with inverse_words entry.",
                            )

    manifest_candidate = input_path.parent / "manifest_sha256.csv"
    if manifest_candidate.exists():
        add_issue(
            issues,
            "warning",
            repo_rel(manifest_candidate),
            "EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED",
            "External artifact manifest exists but this schema validator only reports its presence.",
        )
    else:
        add_issue(
            issues,
            "warning",
            repo_rel(manifest_candidate),
            "EXTERNAL_MANIFEST_NOT_FOUND",
            "No sibling artifact manifest found to report.",
        )

    row_count = len(rows) if isinstance(rows, list) else 0
    child_count = len(inverse_words) if isinstance(inverse_words, list) else 0
    slack_count = len(data.get("slacks", [])) if isinstance(data.get("slacks", []), list) else 0
    return issues, {
        "float_count": float_count,
        "row_count": row_count,
        "child_count": child_count,
        "slack_count": slack_count,
        "is_fixture": is_fixture,
    }


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_errors(path: Path, issues: list[ValidationIssue]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["severity", "path", "code", "message"], lineterminator="\n")
        writer.writeheader()
        for issue in issues:
            writer.writerow(
                {
                    "severity": issue.severity,
                    "path": issue.path,
                    "code": issue.code,
                    "message": issue.message,
                }
            )


def write_manifest(paths: list[Path]) -> None:
    with MANIFEST_PATH.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256"], lineterminator="\n")
        writer.writeheader()
        for path in paths:
            writer.writerow({"path": repo_rel(path), "sha256": sha256(path)})


def main(argv: list[str]) -> int:
    input_path = Path(argv[1]).expanduser() if len(argv) > 1 else DEFAULT_INPUT
    if not input_path.is_absolute():
        input_path = (REPO_ROOT / input_path).resolve()

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    issues: list[ValidationIssue] = []
    data: Any = None
    parse_ok = False

    try:
        data = json.loads(input_path.read_text(encoding="utf-8"))
        parse_ok = True
    except FileNotFoundError:
        add_issue(issues, "error", str(input_path), "INPUT_NOT_FOUND", "Input JSON file does not exist.")
    except json.JSONDecodeError as exc:
        add_issue(issues, "error", str(input_path), "JSON_PARSE_ERROR", f"{exc.msg} at line {exc.lineno} column {exc.colno}.")

    stats: dict[str, Any] = {
        "float_count": 0,
        "row_count": 0,
        "child_count": 0,
        "slack_count": 0,
        "is_fixture": input_path.name.endswith(".fixture.json"),
    }
    if parse_ok:
        validation_issues, stats = validate_data(data, input_path)
        issues.extend(validation_issues)

    error_count = sum(1 for issue in issues if issue.severity == "error")
    warning_count = sum(1 for issue in issues if issue.severity == "warning")
    warning_records = [
        {
            "code": issue.code,
            "path": issue.path,
            "message": issue.message,
            "disposition": (
                "ACCEPTED_NAMED_WARNING"
                if issue.code == "EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED"
                else "REVIEW_REQUIRED"
            ),
        }
        for issue in issues
        if issue.severity == "warning"
    ]
    schema_ok = parse_ok and error_count == 0
    summary = {
        "run_id": RUN_ID,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "input_path": repo_rel(input_path),
        "input_sha256": sha256(input_path) if input_path.exists() and input_path.is_file() else None,
        "json_parseable": parse_ok,
        "expected_schema_version": EXPECTED_SCHEMA_VERSION,
        "schema_ok": schema_ok,
        "is_fixture": stats["is_fixture"],
        "float_count": stats["float_count"],
        "error_count": error_count,
        "warning_count": warning_count,
        "warning_codes": sorted({record["code"] for record in warning_records}),
        "warnings": warning_records,
        "known_warning_policy": {
            "EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED": (
                "Accepted for schema validation v1: the validator reports sibling manifest presence "
                "but does not yet verify external artifact manifests."
            )
        },
        "row_count": stats["row_count"],
        "child_count": stats["child_count"],
        "slack_count": stats["slack_count"],
        "reported_artifact_hash_fields": artifact_hash_fields(data) if parse_ok else {},
        "verdict": "FORMAT_CHECK_ONLY" if schema_ok else "FORMAT_CHECK_FAILED",
        "guardrails": [
            "NO_MATHEMATICAL_VERIFICATION",
            "NO_K3_ROWS_GENERATED",
            "NO_LP_SOLVED",
            "NO_LEAN_OPENED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "K3_CERTIFICATE_SCHEMA_VALIDATOR_CREATED",
            "SCHEMA_VALIDATOR_UPDATED",
            "K_PARAMETRIC_CERTIFICATE_SCHEMA_DEFINED",
            "JSON_LEAN_TWIN_ARTIFACT_POLICY_DEFINED",
            "CANONICAL_RATIONAL_FORMAT_DEFINED",
            "FIXTURE_SCHEMA_VALIDATED" if schema_ok and stats["is_fixture"] else "SCHEMA_VALIDATION_ATTEMPTED",
            "FORMAT_WARNING_NAMED_OR_RESOLVED",
            "FORMAT_CHECK_ONLY",
            "NO_MATHEMATICAL_VERIFICATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }

    write_json(SUMMARY_PATH, summary)
    write_errors(ERRORS_PATH, issues)
    write_manifest([SUMMARY_PATH, ERRORS_PATH])

    print(f"run_id={RUN_ID}")
    print(f"input_path={repo_rel(input_path)}")
    print(f"schema_ok={str(schema_ok).lower()}")
    print(f"error_count={error_count}")
    print(f"warning_count={warning_count}")
    print(f"verdict={summary['verdict']}")
    return 0 if schema_ok else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
