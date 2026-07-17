#!/usr/bin/env python3
"""Emit a KL2003 F2 k=2 regression generator skeleton artifact.

This script tests the high-k certificate emission architecture in
`k2_regression` mode by re-emitting the already-proved manual k=2 baseline as
JSON plus deterministic Lean data.  It does not reconstruct inverse words,
does not solve an LP, does not generate k=3 rows, and does not open Lean.
The emitted data is baseline reemission only; a future verifier must still
check mathematical obligations from generated Lean data.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K2_REGRESSION_GENERATOR_SKELETON_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
GENERATOR_VERSION = "kl2003_f2_k2_regression_generator_skeleton_v1.py"
GENERATOR_MODE = "k2_regression"
MATHEMATICAL_CONTENT = "baseline_reemission_only"
SLACK_IDS_BY_ROW = {
    "row22": "L2NT_D1_slack",
    "row25": "L2NT_D2_slack",
    "row28": "L2NT_D3_slack",
    "M1V3": "M1V3_baseline_auxiliary_placeholder_slack",
}

REPO_ROOT = Path(__file__).resolve().parents[1]
BASELINE_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1"
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K2_GENERATOR_REGRESSION_SCOPING_v1.md"
SCHEMA_SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K3_DATA_CERTIFICATE_FORMAT_SCOPING_v1.md"

BASELINE_SUMMARY = BASELINE_DIR / "summary.json"
BASELINE_ROWS = BASELINE_DIR / "expected_rows_v3.csv"
BASELINE_CONSTANTS = BASELINE_DIR / "certificate_constants.csv"
BASELINE_THEOREMS = BASELINE_DIR / "theorem_baseline.csv"
BASELINE_REQUIREMENTS = BASELINE_DIR / "generator_regression_requirements.csv"
BASELINE_INVENTORY = BASELINE_DIR / "manual_baseline_inventory.csv"

JSON_PATH = OUT_DIR / "kl2003_k2_regression_certificate.generated.json"
LEAN_PATH = OUT_DIR / "KL2003K2RegressionCertificateDataGenerated.lean"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
DIFF_PATH = OUT_DIR / "manual_vs_generated_baseline_diff.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"


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


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def lean_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def lean_string_list(values: list[str]) -> str:
    return "[" + ", ".join(lean_string(value) for value in values) + "]"


def child_for_row(row: dict[str, str]) -> dict[str, Any]:
    row_id = row["row_id"]
    return {
        "child_id": f"{row_id}_baseline_child_placeholder",
        "row_id": row_id,
        "literal_id": f"{row_id}_baseline_literal_placeholder",
        "inverse_word": [],
        "target_class": row.get("tracked_residue_mod9", ""),
        "shift": "0",
        "window_policy": "baseline_reemission_no_window_generated",
        "fiber_parent": "baseline_reemission_no_fiber_generated",
        "deleted": False,
        "reason": "skeleton_reemits_manual_baseline_without_reconstructing_inverse_words",
        "root_formula": "not_generated_in_skeleton",
        "forward_route": [],
        "residue_side_conditions": [],
        "coefficient_ref": f"{row_id}_baseline_coefficient_placeholder",
        "depth": "0",
        "boundary_correction": "not_generated_in_skeleton",
        "baseline_expected_shape": row.get("expected_shape", ""),
        "baseline_required_feature": row.get("required_feature", ""),
        "baseline_refs": row.get("baseline_refs", ""),
    }


def generated_row(row: dict[str, str], child: dict[str, Any]) -> dict[str, Any]:
    return {
        "row_id": row["row_id"],
        "source_class": row["source_class"],
        "row_kind": row["row_family"],
        "children": [child],
        "deletion_policy": row.get("required_feature", ""),
        "coefficient_terms": [
            {
                "coefficient_id": f"{row['row_id']}_baseline_coefficient_placeholder",
                "value": "1",
                "target": child["child_id"],
                "notes": "placeholder coefficient; certificate constants are reemitted separately",
            }
        ],
        "target_bound": "1",
        "slack_id": SLACK_IDS_BY_ROW[row["row_id"]],
        "source_ref": row.get("baseline_refs", ""),
        "normalization_ref": "manual_k2_v3_baseline_reemission",
        "baseline": row,
    }


def tracked_classes() -> list[dict[str, Any]]:
    return [
        {
            "class_id": "class_mod9_2",
            "modulus": "9",
            "representative": "2",
            "pre_reduction_residues": ["2"],
            "source_rule": "manual_k2_tracked_class",
            "active": True,
            "notes": "k=2 tracked class for row22 / phi22",
        },
        {
            "class_id": "class_mod9_5",
            "modulus": "9",
            "representative": "5",
            "pre_reduction_residues": ["5"],
            "source_rule": "manual_k2_tracked_class",
            "active": True,
            "notes": "k=2 tracked class for row25 / phi25",
        },
        {
            "class_id": "class_mod9_8",
            "modulus": "9",
            "representative": "8",
            "pre_reduction_residues": ["8"],
            "source_rule": "manual_k2_tracked_class",
            "active": True,
            "notes": "k=2 tracked class for row28 / phi28",
        },
    ]


def build_certificate(
    created_at: str,
    commit: str,
    baseline_summary: dict[str, Any],
    rows: list[dict[str, str]],
    constants: list[dict[str, str]],
    theorems: list[dict[str, str]],
    requirements: list[dict[str, str]],
    inventory: list[dict[str, str]],
) -> dict[str, Any]:
    children = [child_for_row(row) for row in rows]
    generated_rows = [generated_row(row, child) for row, child in zip(rows, children)]

    slack_constants = [constant for constant in constants if constant.get("kind") == "slack"]
    slack_row_ids = {
        "L2NT_D1_slack": "row22",
        "L2NT_D2_slack": "row25",
        "L2NT_D3_slack": "row28",
    }
    slacks = [
        {
            "slack_id": constant["constant_id"],
            "row_id": slack_row_ids.get(constant["constant_id"], "unknown_row"),
            "lhs": "0",
            "rhs": constant["value"],
            "slack": constant["value"],
            "strictly_positive": True,
            "denominator_bits": "0",
            "numerator_bits": "0",
            "notes": "Baseline slack reemitted from manual k=2 data; bit sizes are not recomputed by skeleton.",
        }
        for constant in slack_constants
    ]
    slacks.append(
        {
            "slack_id": SLACK_IDS_BY_ROW["M1V3"],
            "row_id": "M1V3",
            "lhs": "0",
            "rhs": "0",
            "slack": "0",
            "strictly_positive": False,
            "denominator_bits": "0",
            "numerator_bits": "0",
            "notes": "Auxiliary EL row placeholder for schema linkage only; not a mathematical slack.",
        }
    )

    return {
        "metadata": {
            "run_id": RUN_ID,
            "schema_version": SCHEMA_VERSION,
            "k": "2",
            "tracked_class_convention": "k2_manual_v3_regression_classes_mod9_2_5_8",
            "pre_reduction_class_count": "9",
            "tracked_class_count": "3",
            "format_scope": "high_k_parametric",
            "generator_mode": GENERATOR_MODE,
            "mathematical_content": MATHEMATICAL_CONTENT,
            "source_faithful_contract": "V3",
            "v2_status": "ABSTRACT_ONLY_NOT_SOURCE_FAITHFUL",
            "artifact_links": {
                "json_artifact": JSON_PATH.name,
                "lean_data_artifact": LEAN_PATH.name,
                "json_to_lean_generator": repo_rel(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": "RECORDED_IN_MANIFEST",
                "lean_import_policy": "Lean consumes generated .lean data, not JSON; this generated data is not imported yet.",
            },
            "generator_version": GENERATOR_VERSION,
            "created_at": created_at,
            "source_commit": commit,
            "source_inputs": [
                {
                    "path": repo_rel(path),
                    "sha256": sha256(path) if path.exists() and path.is_file() else "MISSING",
                    "role": role,
                }
                for path, role in [
                    (BASELINE_SUMMARY, "baseline_summary"),
                    (BASELINE_ROWS, "baseline_rows_v3"),
                    (BASELINE_CONSTANTS, "baseline_certificate_constants"),
                    (BASELINE_THEOREMS, "baseline_theorems"),
                    (BASELINE_REQUIREMENTS, "baseline_generator_requirements"),
                    (BASELINE_INVENTORY, "baseline_manual_inventory"),
                    (SCOPING, "k2_regression_scoping"),
                    (SCHEMA_SCOPING, "schema_v2_scoping"),
                ]
            ],
            "guardrails": [
                "BASELINE_REEMISSION_ONLY",
                "NO_INVERSE_WORD_RECONSTRUCTION",
                "NO_LP_SOLVED",
                "NO_K3_GENERATION",
                "NO_LEAN_BUILD",
                "NO_NEW_THEOREM_CLAIM",
                "NO_HIGH_K_CLAIM",
                "NO_GLOBAL_COLLATZ_CLAIM",
            ],
        },
        "tracked_classes": tracked_classes(),
        "rows": generated_rows,
        "inverse_words": children,
        "deletion_marks": [
            {
                "row_id": row["row_id"],
                "child_id": child["child_id"],
                "deleted": False,
                "deletion_policy": row.get("required_feature", ""),
                "reason": row.get("v3_requirement", ""),
                "boundary_correction": "baseline_reemission_only",
                "source_ref": row.get("baseline_refs", ""),
            }
            for row, child in zip(rows, children)
        ],
        "rational_certificate": {
            "lambda_interval": {"exact": "27/20", "source": "manual_k2_baseline"},
            "coefficient_intervals": [
                {
                    "coefficient_id": constant["constant_id"],
                    "lean_name": constant["lean_name"],
                    "value": constant["value"],
                    "kind": constant["kind"],
                    "source": constant["source"],
                    "must_reproduce_exactly": constant["must_reproduce_exactly"],
                    "notes": constant["notes"],
                }
                for constant in constants
            ],
            "variables": {},
            "row_lhs": {},
            "row_rhs": {},
            "solver_manifest": {
                "solver": "none",
                "lp_solved": False,
                "mode": GENERATOR_MODE,
                "notes": "Skeleton reemits manual baseline constants only.",
            },
            "float_diagnostics": {
                "float_evidence_used": False,
                "notes": "No floats are emitted as evidence.",
            },
        },
        "slacks": slacks,
        "verification_targets": [
            {
                "target_id": requirement["requirement_id"],
                "input_sections": ["rows", "rational_certificate", "slacks"],
                "expected_checker": "future_lean_verifier",
                "status": "PENDING_LEAN_VERIFIER",
                "notes": requirement.get("pass_condition", ""),
            }
            for requirement in requirements
        ],
        "manual_baseline": {
            "summary": baseline_summary,
            "theorems": theorems,
            "requirements": requirements,
            "inventory": inventory,
        },
        "no_claims": {
            "new_theorem_claim": False,
            "k3_generation": False,
            "high_k_claim": False,
            "global_collatz_claim": False,
        },
    }


def build_diff_rows(
    certificate: dict[str, Any],
    baseline_rows: list[dict[str, str]],
    baseline_constants: list[dict[str, str]],
) -> tuple[list[dict[str, str]], bool]:
    diff_rows: list[dict[str, str]] = []

    generated_row_ids = [row["row_id"] for row in certificate["rows"]]
    baseline_row_ids = [row["row_id"] for row in baseline_rows]
    row_ids_match = generated_row_ids == baseline_row_ids
    diff_rows.append(
        {
            "check_id": "rows_v3_ids",
            "baseline_source": "expected_rows_v3.csv",
            "generated_field": "rows[*].row_id",
            "expected_value": ";".join(baseline_row_ids),
            "generated_value": ";".join(generated_row_ids),
            "diff_kind": "FORMAT_REEMISSION_ONLY" if row_ids_match else "MATH_DIFF",
            "status": "pass" if row_ids_match else "fail",
            "blocker_if_fail": "K2_REGRESSION_SKELETON_FAIL",
            "notes": "Generated rows preserve manual V3 row ids.",
        }
    )

    baseline_constant_pairs = [(constant["constant_id"], constant["value"]) for constant in baseline_constants]
    generated_constant_pairs = [
        (constant["coefficient_id"], constant["value"])
        for constant in certificate["rational_certificate"]["coefficient_intervals"]
    ]
    constants_match = baseline_constant_pairs == generated_constant_pairs
    diff_rows.append(
        {
            "check_id": "certificate_constants",
            "baseline_source": "certificate_constants.csv",
            "generated_field": "rational_certificate.coefficient_intervals",
            "expected_value": json.dumps(baseline_constant_pairs, sort_keys=True),
            "generated_value": json.dumps(generated_constant_pairs, sort_keys=True),
            "diff_kind": "FORMAT_REEMISSION_ONLY" if constants_match else "MATH_DIFF",
            "status": "pass" if constants_match else "fail",
            "blocker_if_fail": "K2_REGRESSION_SKELETON_FAIL",
            "notes": "Generated constants preserve exact manual k=2 baseline values.",
        }
    )

    m1_rows = [row for row in certificate["rows"] if row["row_id"] == "M1V3"]
    m1_text = json.dumps(m1_rows, sort_keys=True)
    phi25_ok = "phi25" in m1_text and "second arm is phi25" in m1_text
    diff_rows.append(
        {
            "check_id": "m1v3_phi25_arm",
            "baseline_source": "expected_rows_v3.csv",
            "generated_field": "rows[row_id=M1V3]",
            "expected_value": "M1V3 second arm is phi25, not phi22.",
            "generated_value": m1_text,
            "diff_kind": "FORMAT_REEMISSION_ONLY" if phi25_ok else "MATH_DIFF",
            "status": "pass" if phi25_ok else "fail",
            "blocker_if_fail": "K2_REGRESSION_SKELETON_FAIL",
            "notes": "Meta-errata baseline is preserved.",
        }
    )

    metadata = certificate["metadata"]
    metadata_ok = (
        metadata.get("schema_version") == SCHEMA_VERSION
        and metadata.get("k") == "2"
        and metadata.get("tracked_class_count") == "3"
        and metadata.get("pre_reduction_class_count") == "9"
        and metadata.get("generator_mode") == GENERATOR_MODE
        and metadata.get("mathematical_content") == MATHEMATICAL_CONTENT
    )
    diff_rows.append(
        {
            "check_id": "metadata_v2_k2_regression",
            "baseline_source": "schema v2 + k2 regression prompt",
            "generated_field": "metadata",
            "expected_value": "schema=v2;k=2;tracked=3;pre_reduction=9;mode=k2_regression;content=baseline_reemission_only",
            "generated_value": json.dumps(
                {
                    key: metadata.get(key)
                    for key in [
                        "schema_version",
                        "k",
                        "tracked_class_count",
                        "pre_reduction_class_count",
                        "generator_mode",
                        "mathematical_content",
                    ]
                },
                sort_keys=True,
            ),
            "diff_kind": "FORMAT_REEMISSION_ONLY" if metadata_ok else "MATH_DIFF",
            "status": "pass" if metadata_ok else "fail",
            "blocker_if_fail": "K2_REGRESSION_SKELETON_FAIL",
            "notes": "Metadata declares this as k=2 baseline reemission in schema v2.",
        }
    )

    all_pass = all(row["status"] == "pass" for row in diff_rows)
    return diff_rows, all_pass


def write_lean_data(path: Path, certificate: dict[str, Any]) -> None:
    constants = certificate["rational_certificate"]["coefficient_intervals"]
    row_ids = [row["row_id"] for row in certificate["rows"]]
    constant_ids = [constant["coefficient_id"] for constant in constants]
    constant_values = [constant["value"] for constant in constants]

    text = f"""-- generated k2 regression data; not imported; verifier not yet written
-- Generated by scripts/{GENERATOR_VERSION}
-- Schema: {SCHEMA_VERSION}
-- Mode: {GENERATOR_MODE}
-- Mathematical content: {MATHEMATICAL_CONTENT}
-- Guardrails: no k=3 generation, no LP solving, no theorem claim.

namespace KL2003F2K2RegressionGenerated

def schemaVersion : String := {lean_string(SCHEMA_VERSION)}
def generatorMode : String := {lean_string(GENERATOR_MODE)}
def mathematicalContent : String := {lean_string(MATHEMATICAL_CONTENT)}

def k : Nat := 2
def trackedClassCount : Nat := 3
def preReductionClassCount : Nat := 9

def sourceFaithfulContract : String := "V3"
def v2Status : String := "ABSTRACT_ONLY_NOT_SOURCE_FAITHFUL"
def m1v3SecondArm : String := "phi25"

def rowIds : List String := {lean_string_list(row_ids)}
def constantIds : List String := {lean_string_list(constant_ids)}
def constantValues : List String := {lean_string_list(constant_values)}

-- The generated data above is a regression artifact only.  It contains no
-- theorem and is not imported by the trusted verifier yet.

end KL2003F2K2RegressionGenerated
"""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_manifest(created_at: str, commit: str) -> None:
    json_hash = sha256(JSON_PATH)
    lean_hash = sha256(LEAN_PATH)
    generator_hash = sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION)
    rows: list[dict[str, str]] = []
    manifest_inputs = [
        (JSON_PATH, "certificate"),
        (LEAN_PATH, "lean_data"),
        (SUMMARY_PATH, "summary"),
        (DIFF_PATH, "diagnostic"),
        (REPO_ROOT / "scripts" / GENERATOR_VERSION, "json_to_lean_generator"),
        (BASELINE_SUMMARY, "baseline_input"),
        (BASELINE_ROWS, "baseline_input"),
        (BASELINE_CONSTANTS, "baseline_input"),
        (BASELINE_THEOREMS, "baseline_input"),
        (BASELINE_REQUIREMENTS, "baseline_input"),
        (BASELINE_INVENTORY, "baseline_input"),
        (SCOPING, "source_doc"),
        (SCHEMA_SCOPING, "source_doc"),
    ]
    for path, kind in manifest_inputs:
        rows.append(
            {
                "path": repo_rel(path),
                "sha256": sha256(path) if path.exists() and path.is_file() else "MISSING",
                "artifact_kind": kind,
                "generator_version": GENERATOR_VERSION,
                "schema_version": SCHEMA_VERSION,
                "created_at": created_at,
                "source_commit": commit,
                "json_sha256": json_hash,
                "lean_data_sha256": lean_hash,
                "json_to_lean_generator_sha256": generator_hash,
                "notes": "k2 regression skeleton baseline reemission",
            }
        )
    write_csv(
        MANIFEST_PATH,
        rows,
        [
            "path",
            "sha256",
            "artifact_kind",
            "generator_version",
            "schema_version",
            "created_at",
            "source_commit",
            "json_sha256",
            "lean_data_sha256",
            "json_to_lean_generator_sha256",
            "notes",
        ],
    )


def main() -> int:
    created_at = datetime.now(timezone.utc).isoformat()
    commit = source_commit()

    baseline_summary = json.loads(BASELINE_SUMMARY.read_text(encoding="utf-8"))
    rows = read_csv(BASELINE_ROWS)
    constants = read_csv(BASELINE_CONSTANTS)
    theorems = read_csv(BASELINE_THEOREMS)
    requirements = read_csv(BASELINE_REQUIREMENTS)
    inventory = read_csv(BASELINE_INVENTORY)

    certificate = build_certificate(
        created_at=created_at,
        commit=commit,
        baseline_summary=baseline_summary,
        rows=rows,
        constants=constants,
        theorems=theorems,
        requirements=requirements,
        inventory=inventory,
    )
    diff_rows, diff_pass = build_diff_rows(certificate, rows, constants)

    write_json(JSON_PATH, certificate)
    write_lean_data(LEAN_PATH, certificate)
    write_csv(
        DIFF_PATH,
        diff_rows,
        [
            "check_id",
            "baseline_source",
            "generated_field",
            "expected_value",
            "generated_value",
            "diff_kind",
            "status",
            "blocker_if_fail",
            "notes",
        ],
    )

    verdict = "FORMAT_REEMISSION_DIFF_PASS" if diff_pass else "K2_REGRESSION_SKELETON_FAIL"
    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": commit,
        "schema_version": SCHEMA_VERSION,
        "generator_version": GENERATOR_VERSION,
        "generator_mode": GENERATOR_MODE,
        "mathematical_content": MATHEMATICAL_CONTENT,
        "source_faithful_contract": "V3",
        "v2_status": "ABSTRACT_ONLY_NOT_SOURCE_FAITHFUL",
        "k": 2,
        "tracked_class_count": 3,
        "pre_reduction_class_count": 9,
        "row_count": len(rows),
        "constant_count": len(constants),
        "theorem_reference_count": len(theorems),
        "diff_check_count": len(diff_rows),
        "diff_pass": diff_pass,
        "verdict": verdict,
        "json_artifact": repo_rel(JSON_PATH),
        "lean_data_artifact": repo_rel(LEAN_PATH),
        "diff_artifact": repo_rel(DIFF_PATH),
        "manifest": repo_rel(MANIFEST_PATH),
        "guardrails": [
            "BASELINE_REEMISSION_ONLY",
            "NO_MATHEMATICAL_GENERATION",
            "NO_INVERSE_WORD_RECONSTRUCTION",
            "NO_LP_SOLVED",
            "NO_K3_GENERATION",
            "NO_LEAN_BUILD",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    write_manifest(created_at, commit)

    print(f"run_id={RUN_ID}")
    print(f"verdict={verdict}")
    print(f"generator_mode={GENERATOR_MODE}")
    print(f"mathematical_content={MATHEMATICAL_CONTENT}")
    print(f"row_count={len(rows)}")
    print(f"constant_count={len(constants)}")
    print(f"output_dir={repo_rel(OUT_DIR)}")
    print("no inverse-word reconstruction, no LP, no k=3 generation, no high-k claim, no global Collatz claim")
    return 0 if diff_pass else 1


if __name__ == "__main__":
    raise SystemExit(main())
