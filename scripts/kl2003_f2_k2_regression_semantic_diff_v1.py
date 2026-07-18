#!/usr/bin/env python3
"""Compare generated k=2 regression JSON against the manual baseline.

This is a semantic data diff, not a Lean proof.  It checks that the skeleton
artifact reemits the source-faithful manual k=2 V3 baseline: row shapes,
meta-errata phi25, exact constants, and regression requirements.  It does not
import generated Lean data, solve an LP, generate k=3 rows, or claim any
high-k theorem.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K2_REGRESSION_SEMANTIC_DIFF_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
BASELINE_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1"
GENERATED_JSON = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K2_REGRESSION_GENERATOR_SKELETON_v1"
    / "kl2003_k2_regression_certificate.generated.json"
)
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

BASELINE_ROWS = BASELINE_DIR / "expected_rows_v3.csv"
BASELINE_CONSTANTS = BASELINE_DIR / "certificate_constants.csv"
BASELINE_REQUIREMENTS = BASELINE_DIR / "generator_regression_requirements.csv"
BASELINE_SUMMARY = BASELINE_DIR / "summary.json"

SUMMARY_PATH = OUT_DIR / "semantic_diff_summary.json"
ROW_DIFF_PATH = OUT_DIR / "row_shape_diff.csv"
CONSTANT_DIFF_PATH = OUT_DIR / "constant_diff.csv"
REQUIREMENT_DIFF_PATH = OUT_DIR / "requirement_diff.csv"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

REQUIRED_ROW_FEATURES = {
    "row22": ["parity lift"],
    "row25": ["single-branch"],
    "row28": ["c-prime split", "post-deletion"],
    "M1V3": ["phi25"],
}
FORBIDDEN_ROW_FEATURES = {
    "M1V3": ["min(phi28 + M2V3, phi22)", "second arm is phi22"],
}
REQUIRED_REQUIREMENTS = [
    "reproduce_rows_v3",
    "reproduce_meta_errata_phi25",
    "reproduce_deletion_behavior",
    "reproduce_certificate_constants",
    "emit_json_lean_twin_artifacts_v2",
    "any_math_diff_is_generator_blocker",
]


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


def generated_rows_by_id(generated: dict[str, Any]) -> dict[str, dict[str, Any]]:
    rows = generated.get("rows", [])
    if not isinstance(rows, list):
        return {}
    result: dict[str, dict[str, Any]] = {}
    for row in rows:
        if isinstance(row, dict) and isinstance(row.get("row_id"), str):
            result[row["row_id"]] = row
    return result


def generated_constants_by_id(generated: dict[str, Any]) -> dict[str, dict[str, Any]]:
    rational_certificate = generated.get("rational_certificate", {})
    constants = rational_certificate.get("coefficient_intervals", []) if isinstance(rational_certificate, dict) else []
    result: dict[str, dict[str, Any]] = {}
    if isinstance(constants, list):
        for constant in constants:
            if isinstance(constant, dict) and isinstance(constant.get("coefficient_id"), str):
                result[constant["coefficient_id"]] = constant
    return result


def generated_requirement_ids(generated: dict[str, Any]) -> set[str]:
    targets = generated.get("verification_targets", [])
    if not isinstance(targets, list):
        return set()
    return {
        target["target_id"]
        for target in targets
        if isinstance(target, dict) and isinstance(target.get("target_id"), str)
    }


def add_mismatch(
    mismatches: list[dict[str, str]],
    category: str,
    item_id: str,
    field: str,
    expected: Any,
    actual: Any,
    severity: str = "math_diff",
) -> None:
    mismatches.append(
        {
            "category": category,
            "item_id": item_id,
            "field": field,
            "expected": json.dumps(expected, sort_keys=True) if isinstance(expected, (dict, list)) else str(expected),
            "actual": json.dumps(actual, sort_keys=True) if isinstance(actual, (dict, list)) else str(actual),
            "severity": severity,
            "classification": "K2_REGRESSION_FAIL" if severity == "math_diff" else "K2_REGRESSION_FORMAT_DIFF_ONLY",
        }
    )


def check_rows(
    baseline_rows: list[dict[str, str]],
    generated_rows: dict[str, dict[str, Any]],
    mismatches: list[dict[str, str]],
) -> list[dict[str, str]]:
    diff_rows: list[dict[str, str]] = []
    for baseline in baseline_rows:
        row_id = baseline["row_id"]
        generated = generated_rows.get(row_id)
        generated_text = json.dumps(generated, sort_keys=True) if generated is not None else ""
        status = "pass"
        notes: list[str] = []

        if generated is None:
            status = "fail"
            add_mismatch(mismatches, "row", row_id, "exists", "present", "missing")
            notes.append("row missing")
        else:
            for field in ["source_class", "row_kind"]:
                expected = baseline["source_class"] if field == "source_class" else baseline["row_family"]
                actual = generated.get(field)
                if actual != expected:
                    status = "fail"
                    add_mismatch(mismatches, "row", row_id, field, expected, actual)
                    notes.append(f"{field} mismatch")

            baseline_expected_shape = baseline.get("expected_shape", "")
            baseline_required_feature = baseline.get("required_feature", "")
            baseline_v3_requirement = baseline.get("v3_requirement", "")
            generated_baseline = generated.get("baseline") if isinstance(generated, dict) else {}
            if not isinstance(generated_baseline, dict):
                generated_baseline = {}
            for field, expected in [
                ("expected_shape", baseline_expected_shape),
                ("required_feature", baseline_required_feature),
                ("v3_requirement", baseline_v3_requirement),
            ]:
                actual = generated_baseline.get(field)
                if actual != expected:
                    status = "fail"
                    add_mismatch(mismatches, "row", row_id, f"baseline.{field}", expected, actual)
                    notes.append(f"baseline.{field} mismatch")

            for token in REQUIRED_ROW_FEATURES.get(row_id, []):
                if token not in generated_text:
                    status = "fail"
                    add_mismatch(mismatches, "row", row_id, "required_feature_token", token, generated_text)
                    notes.append(f"missing token {token}")
            for token in FORBIDDEN_ROW_FEATURES.get(row_id, []):
                if token in generated_text:
                    status = "fail"
                    add_mismatch(mismatches, "row", row_id, "forbidden_feature_token", f"not {token}", token)
                    notes.append(f"forbidden token {token}")

            if row_id == "M1V3":
                expected_shape = str(generated_baseline.get("expected_shape", ""))
                if "phi25" not in expected_shape:
                    status = "fail"
                    add_mismatch(mismatches, "row", row_id, "M1V3_phi25", "phi25 present", expected_shape)
                    notes.append("M1V3 phi25 missing")
                if "min(phi28 + M2V3, phi22)" in expected_shape:
                    status = "fail"
                    add_mismatch(
                        mismatches,
                        "row",
                        row_id,
                        "M1V3_phi22_replacement",
                        "phi25 arm retained",
                        expected_shape,
                    )
                    notes.append("M1V3 replaced by phi22")

        diff_rows.append(
            {
                "row_id": row_id,
                "baseline_expected_shape": baseline.get("expected_shape", ""),
                "baseline_required_feature": baseline.get("required_feature", ""),
                "generated_present": "yes" if generated is not None else "no",
                "generated_source_class": str(generated.get("source_class", "")) if generated else "",
                "generated_row_kind": str(generated.get("row_kind", "")) if generated else "",
                "status": status,
                "diff_kind": "MATCH" if status == "pass" else "MATH_DIFF",
                "notes": "; ".join(notes) if notes else "row baseline preserved",
            }
        )
    return diff_rows


def check_constants(
    baseline_constants: list[dict[str, str]],
    generated_constants: dict[str, dict[str, Any]],
    mismatches: list[dict[str, str]],
) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for baseline in baseline_constants:
        constant_id = baseline["constant_id"]
        generated = generated_constants.get(constant_id)
        status = "pass"
        notes: list[str] = []
        if generated is None:
            status = "fail"
            add_mismatch(mismatches, "constant", constant_id, "exists", "present", "missing")
            notes.append("constant missing")
        else:
            for field, generated_field in [
                ("value", "value"),
                ("kind", "kind"),
                ("lean_name", "lean_name"),
                ("source", "source"),
                ("must_reproduce_exactly", "must_reproduce_exactly"),
            ]:
                expected = baseline[field]
                actual = generated.get(generated_field)
                if actual != expected:
                    status = "fail"
                    add_mismatch(mismatches, "constant", constant_id, field, expected, actual)
                    notes.append(f"{field} mismatch")

        rows.append(
            {
                "constant_id": constant_id,
                "baseline_value": baseline.get("value", ""),
                "generated_value": str(generated.get("value", "")) if generated else "",
                "baseline_kind": baseline.get("kind", ""),
                "generated_kind": str(generated.get("kind", "")) if generated else "",
                "status": status,
                "diff_kind": "MATCH" if status == "pass" else "MATH_DIFF",
                "notes": "; ".join(notes) if notes else "constant baseline preserved",
            }
        )
    return rows


def check_requirements(
    baseline_requirements: list[dict[str, str]],
    generated_requirement_ids_set: set[str],
    mismatches: list[dict[str, str]],
) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    baseline_ids = {row["requirement_id"] for row in baseline_requirements}
    for requirement_id in REQUIRED_REQUIREMENTS:
        baseline_present = requirement_id in baseline_ids
        generated_present = requirement_id in generated_requirement_ids_set
        status = "pass" if baseline_present and generated_present else "fail"
        if not baseline_present:
            add_mismatch(mismatches, "requirement", requirement_id, "baseline_present", "yes", "no")
        if not generated_present:
            add_mismatch(mismatches, "requirement", requirement_id, "generated_present", "yes", "no")
        rows.append(
            {
                "requirement_id": requirement_id,
                "baseline_present": "yes" if baseline_present else "no",
                "generated_present": "yes" if generated_present else "no",
                "status": status,
                "diff_kind": "MATCH" if status == "pass" else "MATH_DIFF",
                "notes": "requirement preserved" if status == "pass" else "requirement missing",
            }
        )
    return rows


def write_manifest(created_at: str, commit: str) -> None:
    paths = [
        SUMMARY_PATH,
        ROW_DIFF_PATH,
        CONSTANT_DIFF_PATH,
        REQUIREMENT_DIFF_PATH,
        MISMATCH_PATH,
        REPO_ROOT / "scripts" / "kl2003_f2_k2_regression_semantic_diff_v1.py",
        BASELINE_ROWS,
        BASELINE_CONSTANTS,
        BASELINE_REQUIREMENTS,
        BASELINE_SUMMARY,
        GENERATED_JSON,
    ]
    rows = [
        {
            "path": repo_rel(path),
            "sha256": sha256(path) if path.exists() and path.is_file() else "MISSING",
            "artifact_kind": "semantic_diff_output" if path.parent == OUT_DIR else "semantic_diff_input",
            "created_at": created_at,
            "source_commit": commit,
            "notes": "k2 regression semantic data diff; no Lean proof",
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

    baseline_rows = read_csv(BASELINE_ROWS)
    baseline_constants = read_csv(BASELINE_CONSTANTS)
    baseline_requirements = read_csv(BASELINE_REQUIREMENTS)
    baseline_summary = json.loads(BASELINE_SUMMARY.read_text(encoding="utf-8"))
    generated = json.loads(GENERATED_JSON.read_text(encoding="utf-8"))

    mismatches: list[dict[str, str]] = []
    row_diff = check_rows(baseline_rows, generated_rows_by_id(generated), mismatches)
    constant_diff = check_constants(baseline_constants, generated_constants_by_id(generated), mismatches)
    requirement_diff = check_requirements(
        baseline_requirements,
        generated_requirement_ids(generated),
        mismatches,
    )

    math_mismatch_count = sum(1 for mismatch in mismatches if mismatch["severity"] == "math_diff")
    format_diff_count = sum(1 for mismatch in mismatches if mismatch["severity"] == "format_diff")
    if math_mismatch_count:
        verdict = "K2_REGRESSION_FAIL"
    elif format_diff_count:
        verdict = "K2_REGRESSION_FORMAT_DIFF_ONLY"
    else:
        verdict = "K2_REGRESSION_SEMANTIC_DIFF_PASS"

    write_csv(
        ROW_DIFF_PATH,
        row_diff,
        [
            "row_id",
            "baseline_expected_shape",
            "baseline_required_feature",
            "generated_present",
            "generated_source_class",
            "generated_row_kind",
            "status",
            "diff_kind",
            "notes",
        ],
    )
    write_csv(
        CONSTANT_DIFF_PATH,
        constant_diff,
        [
            "constant_id",
            "baseline_value",
            "generated_value",
            "baseline_kind",
            "generated_kind",
            "status",
            "diff_kind",
            "notes",
        ],
    )
    write_csv(
        REQUIREMENT_DIFF_PATH,
        requirement_diff,
        [
            "requirement_id",
            "baseline_present",
            "generated_present",
            "status",
            "diff_kind",
            "notes",
        ],
    )
    write_csv(
        MISMATCH_PATH,
        mismatches,
        ["category", "item_id", "field", "expected", "actual", "severity", "classification"],
    )

    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": commit,
        "baseline_dir": repo_rel(BASELINE_DIR),
        "generated_json": repo_rel(GENERATED_JSON),
        "baseline_verdict": baseline_summary.get("verdict"),
        "row_check_count": len(row_diff),
        "constant_check_count": len(constant_diff),
        "requirement_check_count": len(requirement_diff),
        "mismatch_count": len(mismatches),
        "math_mismatch_count": math_mismatch_count,
        "format_diff_count": format_diff_count,
        "verdict": verdict,
        "guardrails": [
            "NO_LEAN_BUILD",
            "NO_GENERATED_LEAN_IMPORT",
            "NO_K3_GENERATION",
            "NO_LP_SOLVED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "K2_REGRESSION_SEMANTIC_DIFF_CREATED",
            "K2_REGRESSION_SEMANTIC_DIFF_PASS"
            if verdict == "K2_REGRESSION_SEMANTIC_DIFF_PASS"
            else verdict,
            "META_ERRATA_PHI25_DIFF_CHECKED",
            "CERTIFICATE_CONSTANTS_DIFF_CHECKED",
            "FORMAT_ONLY_PIPELINE_READY" if verdict == "K2_REGRESSION_SEMANTIC_DIFF_PASS" else "FORMAT_PIPELINE_NEEDS_REVIEW",
            "NO_MATHEMATICAL_PROOF",
            "NO_K3_GENERATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    write_manifest(created_at, commit)

    print(f"run_id={RUN_ID}")
    print(f"verdict={verdict}")
    print(f"row_check_count={len(row_diff)}")
    print(f"constant_check_count={len(constant_diff)}")
    print(f"requirement_check_count={len(requirement_diff)}")
    print(f"mismatch_count={len(mismatches)}")
    print("no Lean build, no generated Lean import, no k=3 generation, no high-k claim, no global Collatz claim")
    return 0 if verdict in {"K2_REGRESSION_SEMANTIC_DIFF_PASS", "K2_REGRESSION_FORMAT_DIFF_ONLY"} else 1


if __name__ == "__main__":
    raise SystemExit(main())
