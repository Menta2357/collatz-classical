#!/usr/bin/env python3
"""Validate the KL2003 F2 k=2 row25 microgenerator artifact.

This is a second-layer validation for the row25 generated data candidate.  It
checks schema-level facts, row25-only scope, derivation trace content, and a
semantic diff against the manual row25 baseline.  It does not open Lean, import
generated Lean data, solve an LP, generate k=3 data, or claim any theorem.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from math import gcd
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K2_ROW25_MICROGENERATOR_VALIDATION_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

ROW25_JSON = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW25_MICROGENERATOR_v1" / "row25.generated.json"
ROW25_TRACE = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW25_MICROGENERATOR_v1" / "row25_derivation_trace.csv"
BASELINE_ROWS = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1" / "expected_rows_v3.csv"
BASELINE_CONSTANTS = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1" / "certificate_constants.csv"
SCHEMA_VALIDATOR = REPO_ROOT / "scripts" / "kl2003_f2_k3_certificate_schema_validator_v1.py"

SUMMARY_PATH = OUT_DIR / "row25_validation_summary.json"
SCHEMA_SUMMARY_PATH = OUT_DIR / "row25_schema_validation_summary.json"
SEMANTIC_DIFF_PATH = OUT_DIR / "row25_semantic_diff.csv"
TRACE_CHECK_PATH = OUT_DIR / "row25_derivation_trace_check.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

RATIONAL_RE = re.compile(r"^-?(0|[1-9][0-9]*)(/([1-9][0-9]*))?$")
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
    "rounding_loss",
}
REQUIRED_TOP_LEVEL = [
    "metadata",
    "tracked_classes",
    "rows",
    "inverse_words",
    "deletion_marks",
    "rational_certificate",
    "slacks",
    "verification_targets",
]
REQUIRED_TRACE_TOKENS = {
    "source_class": ["a % 9 = 5"],
    "retarded_child": ["child = 4*a"],
    "class_transfer_mod9": ["(4*a) % 9 = 2"],
    "window_transfer": ["concreteWindow (y - 2) (4*a) = concreteWindow y a"],
    "row_shape": ["single-branch", "advanced_contribution_in_EL = false"],
    "slack_reference": ["271/729000"],
}


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


def source_commit() -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            cwd=REPO_ROOT,
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return "UNKNOWN_UNCOMMITTED"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            encoded: dict[str, Any] = {}
            for field in fieldnames:
                value = row.get(field, "")
                if isinstance(value, (dict, list)):
                    encoded[field] = json.dumps(value, sort_keys=True)
                else:
                    encoded[field] = value
            writer.writerow(encoded)


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
    if denominator <= 0 or numerator == 0 or denominator == 1:
        return False
    return gcd(abs(numerator), denominator) == 1


def count_floats(obj: Any) -> int:
    if isinstance(obj, float):
        return 1
    if isinstance(obj, dict):
        return sum(count_floats(value) for value in obj.values())
    if isinstance(obj, list):
        return sum(count_floats(value) for value in obj)
    return 0


def check_rational_strings(obj: Any, errors: list[str], path: str = "$") -> None:
    if isinstance(obj, dict):
        for key, value in obj.items():
            child_path = f"{path}.{key}"
            symbolic_ok = key == "value" and isinstance(value, str) and "^" in value
            if key in RATIONAL_KEY_TOKENS and not symbolic_ok:
                if not isinstance(value, str):
                    errors.append(f"{child_path}: rational-like field is not a string")
                elif not rational_string_ok(value):
                    errors.append(f"{child_path}: non-canonical rational string `{value}`")
            check_rational_strings(value, errors, child_path)
    elif isinstance(obj, list):
        for idx, value in enumerate(obj):
            check_rational_strings(value, errors, f"{path}[{idx}]")


def baseline_row25() -> dict[str, str]:
    rows = read_csv(BASELINE_ROWS)
    matches = [row for row in rows if row.get("row_id") == "row25"]
    if len(matches) != 1:
        raise RuntimeError("Expected exactly one row25 baseline row.")
    return matches[0]


def baseline_constants() -> dict[str, dict[str, str]]:
    return {row["constant_id"]: row for row in read_csv(BASELINE_CONSTANTS)}


def constants_by_id(data: dict[str, Any]) -> dict[str, dict[str, Any]]:
    constants = data.get("rational_certificate", {}).get("coefficient_intervals", [])
    if not isinstance(constants, list):
        return {}
    return {
        row["coefficient_id"]: row
        for row in constants
        if isinstance(row, dict) and isinstance(row.get("coefficient_id"), str)
    }


def check_schema(data: dict[str, Any]) -> tuple[dict[str, Any], list[str]]:
    errors: list[str] = []
    for field in REQUIRED_TOP_LEVEL:
        if field not in data:
            errors.append(f"missing top-level field {field}")

    metadata = data.get("metadata", {})
    if not isinstance(metadata, dict):
        errors.append("metadata is not an object")
        metadata = {}
    expected_metadata = {
        "schema_version": SCHEMA_VERSION,
        "k": "2",
        "tracked_class_count": "3",
        "pre_reduction_class_count": "9",
        "generation_mode": "rule_derived_row25",
        "mathematical_generation": True,
        "proof_status": "data_candidate_only",
        "scope": "k2_row25_only",
    }
    for key, expected in expected_metadata.items():
        actual = metadata.get(key)
        if actual != expected:
            errors.append(f"metadata.{key}: expected {expected!r}, got {actual!r}")

    links = metadata.get("artifact_links", {})
    if not isinstance(links, dict):
        errors.append("metadata.artifact_links is not an object")
        links = {}
    for key in [
        "json_artifact",
        "lean_data_artifact",
        "json_to_lean_generator",
        "json_sha256",
        "lean_data_sha256",
        "json_to_lean_generator_sha256",
    ]:
        if not links.get(key):
            errors.append(f"metadata.artifact_links.{key}: missing")

    float_count = count_floats(data)
    if float_count:
        errors.append(f"float_count={float_count}")
    check_rational_strings(data, errors)

    rows = data.get("rows", [])
    row_ids = [row.get("row_id") for row in rows if isinstance(row, dict)] if isinstance(rows, list) else []
    if "row25" not in row_ids:
        errors.append("row25 missing")
    for forbidden in ["row22", "row28", "M1V3"]:
        if forbidden in row_ids:
            errors.append(f"forbidden row present: {forbidden}")

    summary = {
        "schema_version": metadata.get("schema_version"),
        "k": metadata.get("k"),
        "generation_mode": metadata.get("generation_mode"),
        "mathematical_generation": metadata.get("mathematical_generation"),
        "proof_status": metadata.get("proof_status"),
        "scope": metadata.get("scope"),
        "json_parseable": True,
        "float_count": float_count,
        "row_count": len(row_ids),
        "row_ids": row_ids,
        "has_json_lean_twin_links": all(
            bool(links.get(key))
            for key in [
                "json_artifact",
                "lean_data_artifact",
                "json_sha256",
                "lean_data_sha256",
                "json_to_lean_generator_sha256",
            ]
        ),
        "schema_ok": not errors,
        "error_count": len(errors),
        "errors": errors,
    }
    return summary, errors


def run_external_schema_validator() -> tuple[dict[str, Any], list[str]]:
    """Run the shared schema validator v2 and return its summary.

    The row25 validator adds row-specific checks, but the shared high-k schema
    validator remains the canonical format checker.  Its named manifest warning
    is accepted here because this layer also writes its own validation manifest.
    """
    with tempfile.TemporaryDirectory(prefix="kl2003_row25_schema_") as tmp:
        tmp_dir = Path(tmp)
        proc = subprocess.run(
            [
                sys.executable,
                str(SCHEMA_VALIDATOR),
                str(ROW25_JSON),
                "--out-dir",
                str(tmp_dir),
            ],
            cwd=REPO_ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        summary_path = tmp_dir / "schema_validation_summary.json"
        if proc.returncode != 0:
            return (
                {
                    "schema_ok": False,
                    "returncode": proc.returncode,
                    "stdout": proc.stdout,
                    "stderr": proc.stderr,
                },
                ["external_schema_validator_failed"],
            )
        try:
            summary = json.loads(summary_path.read_text(encoding="utf-8"))
        except (FileNotFoundError, json.JSONDecodeError) as exc:
            return (
                {
                    "schema_ok": False,
                    "returncode": proc.returncode,
                    "stdout": proc.stdout,
                    "stderr": proc.stderr,
                    "parse_error": str(exc),
                },
                ["external_schema_validator_summary_missing_or_invalid"],
            )
        errors: list[str] = []
        if not summary.get("schema_ok"):
            errors.append("external_schema_validator_schema_not_ok")
        return summary, errors


def check_trace() -> tuple[list[dict[str, str]], list[str]]:
    trace_rows = read_csv(ROW25_TRACE)
    by_step = {row["step_id"]: row for row in trace_rows}
    failures: list[str] = []
    checks: list[dict[str, str]] = []
    for step_id, tokens in REQUIRED_TRACE_TOKENS.items():
        row = by_step.get(step_id)
        text = json.dumps(row, sort_keys=True) if row else ""
        missing = [token for token in tokens if token not in text]
        status = "pass" if row is not None and not missing else "fail"
        if status == "fail":
            failures.append(step_id)
        checks.append(
            {
                "step_id": step_id,
                "required_tokens": "; ".join(tokens),
                "present": "yes" if row is not None else "no",
                "missing_tokens": "; ".join(missing),
                "status": status,
                "notes": "trace requirement satisfied" if status == "pass" else "trace requirement failed",
            }
        )
    return checks, failures


def check_semantic_diff(data: dict[str, Any]) -> tuple[list[dict[str, str]], list[str]]:
    row25 = baseline_row25()
    constants = baseline_constants()
    rows = data.get("rows", [])
    generated_row = rows[0] if isinstance(rows, list) and len(rows) == 1 and isinstance(rows[0], dict) else {}
    generated_constants = constants_by_id(data)
    child = data.get("inverse_words", [{}])[0]
    if not isinstance(child, dict):
        child = {}

    checks: list[tuple[str, Any, Any, str]] = [
        ("row_id", "row25", generated_row.get("row_id"), "row25 exists"),
        ("row_shape", row25["expected_shape"], generated_row.get("baseline_expected_shape"), "row25 shape matches baseline"),
        ("source_class", row25["source_class"], generated_row.get("source_class"), "source class matches"),
        ("row_kind", row25["row_family"], generated_row.get("row_kind"), "row family matches"),
        ("no_advanced_branch", False, generated_row.get("advanced_contribution_in_EL"), "no advanced contribution"),
        ("child_formula", "4*a", child.get("root_formula"), "retarded child formula"),
        ("child_target_class", "2", child.get("target_class"), "class transfer target"),
        ("window_policy", "exact_retarded_window", child.get("window_policy"), "exact window transfer"),
        ("c25", constants["c25"]["value"], generated_constants.get("c25", {}).get("value"), "c25 matches baseline"),
        (
            "L2NT_D2_slack",
            constants["L2NT_D2_slack"]["value"],
            generated_constants.get("L2NT_D2_slack", {}).get("value"),
            "row25 slack matches baseline",
        ),
    ]

    rows_out: list[dict[str, str]] = []
    failures: list[str] = []
    for check_id, expected, actual, notes in checks:
        ok = expected == actual
        if not ok:
            failures.append(check_id)
        rows_out.append(
            {
                "check_id": check_id,
                "expected": str(expected),
                "actual": str(actual),
                "status": "pass" if ok else "fail",
                "diff_kind": "MATCH" if ok else "MATH_DIFF",
                "notes": notes,
            }
        )
    return rows_out, failures


def write_manifest(created_at: str, commit: str) -> None:
    paths = [
        SUMMARY_PATH,
        SCHEMA_SUMMARY_PATH,
        SEMANTIC_DIFF_PATH,
        TRACE_CHECK_PATH,
        REPO_ROOT / "scripts" / "kl2003_f2_k2_row25_microgenerator_validation_v1.py",
        ROW25_JSON,
        ROW25_TRACE,
        BASELINE_ROWS,
        BASELINE_CONSTANTS,
    ]
    rows = [
        {
            "path": repo_rel(path),
            "sha256": sha256(path) if path.exists() and path.is_file() else "MISSING",
            "artifact_kind": "validation_output" if path.parent == OUT_DIR else "validation_input",
            "created_at": created_at,
            "source_commit": commit,
            "notes": "row25 microgenerator validation; no Lean proof",
        }
        for path in paths
    ]
    write_csv(
        MANIFEST_PATH,
        rows,
        ["path", "sha256", "artifact_kind", "created_at", "source_commit", "notes"],
    )


def main() -> int:
    created_at = datetime.now(timezone.utc).isoformat()
    commit = source_commit()
    try:
        data = json.loads(ROW25_JSON.read_text(encoding="utf-8"))
        parse_errors: list[str] = []
    except (FileNotFoundError, json.JSONDecodeError) as exc:
        data = {}
        parse_errors = [str(exc)]

    if parse_errors:
        schema_summary, schema_errors = {}, parse_errors
        external_schema_summary, external_schema_errors = {}, parse_errors
    else:
        schema_summary, local_schema_errors = check_schema(data)
        external_schema_summary, external_schema_errors = run_external_schema_validator()
        schema_errors = local_schema_errors + external_schema_errors
    trace_checks, trace_failures = check_trace()
    semantic_checks, semantic_failures = check_semantic_diff(data)

    schema_ok = not schema_errors and not parse_errors
    trace_ok = not trace_failures
    semantic_ok = not semantic_failures
    verdict = (
        "ROW25_MICROGENERATOR_VALIDATION_PASS"
        if schema_ok and trace_ok and semantic_ok
        else "ROW25_MICROGENERATOR_VALIDATION_FAIL"
    )

    write_json(
        SCHEMA_SUMMARY_PATH,
        schema_summary
        | {
            "parse_errors": parse_errors,
            "external_schema_validator": {
                "script": repo_rel(SCHEMA_VALIDATOR),
                "schema_ok": external_schema_summary.get("schema_ok"),
                "verdict": external_schema_summary.get("verdict"),
                "warning_count": external_schema_summary.get("warning_count", 0),
                "warning_codes": external_schema_summary.get("warning_codes", []),
                "known_warning_policy": external_schema_summary.get("known_warning_policy", {}),
            },
        },
    )
    write_csv(
        TRACE_CHECK_PATH,
        trace_checks,
        ["step_id", "required_tokens", "present", "missing_tokens", "status", "notes"],
    )
    write_csv(
        SEMANTIC_DIFF_PATH,
        semantic_checks,
        ["check_id", "expected", "actual", "status", "diff_kind", "notes"],
    )

    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": commit,
        "input_json": repo_rel(ROW25_JSON),
        "schema_ok": schema_ok,
        "trace_ok": trace_ok,
        "semantic_ok": semantic_ok,
        "schema_error_count": len(schema_errors) + len(parse_errors),
        "trace_failure_count": len(trace_failures),
        "semantic_failure_count": len(semantic_failures),
        "trace_failures": trace_failures,
        "semantic_failures": semantic_failures,
        "verdict": verdict,
        "guardrails": [
            "DATA_CANDIDATE_ONLY",
            "NO_LEAN_PROOF",
            "NO_THEOREM_CLAIM",
            "NO_K3_GENERATION",
            "NO_LP_SOLVED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "ROW25_MICROGENERATOR_VALIDATION_CREATED",
            "ROW25_MICROGENERATOR_VALIDATION_PASS" if verdict.endswith("PASS") else verdict,
            "ROW25_SCHEMA_AND_SEMANTIC_DIFF_CHECKED",
            "DATA_CANDIDATE_ONLY",
            "NO_LEAN_PROOF",
            "NO_K3_GENERATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    write_manifest(created_at, commit)

    print(f"run_id={RUN_ID}")
    print(f"verdict={verdict}")
    print(f"schema_ok={str(schema_ok).lower()}")
    print(f"trace_ok={str(trace_ok).lower()}")
    print(f"semantic_ok={str(semantic_ok).lower()}")
    print("no Lean proof, no theorem claim, no k=3 generation, no high-k claim, no global Collatz claim")
    return 0 if verdict == "ROW25_MICROGENERATOR_VALIDATION_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
