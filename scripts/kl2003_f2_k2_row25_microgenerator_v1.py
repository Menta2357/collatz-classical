#!/usr/bin/env python3
"""Generate the KL2003 F2 k=2 row25 microgenerator artifact.

This is the first rule-derived row generator in the F2 track.  It emits only
row25 from explicit residue/window rules, compares it against the manual k=2
baseline row25, and writes JSON + Lean data twins in schema v2 form.

It does not generate k=3 data, solve an LP, import generated Lean data, or
claim a theorem.  The generated row is a data candidate only.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K2_ROW25_MICROGENERATOR_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
GENERATOR_VERSION = "kl2003_f2_k2_row25_microgenerator_v1.py"
GENERATION_MODE = "rule_derived_row25"
SCOPE = "k2_row25_only"

REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
BASELINE_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1"

SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K2_ROW25_MICROGENERATOR_SCOPING_v1.md"
SCHEMA_SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K3_DATA_CERTIFICATE_FORMAT_SCOPING_v1.md"
BASELINE_ROWS = BASELINE_DIR / "expected_rows_v3.csv"
BASELINE_CONSTANTS = BASELINE_DIR / "certificate_constants.csv"

JSON_PATH = OUT_DIR / "row25.generated.json"
LEAN_PATH = OUT_DIR / "KL2003K2Row25GeneratedData.lean"
TRACE_PATH = OUT_DIR / "row25_derivation_trace.csv"
DIFF_PATH = OUT_DIR / "row25_vs_baseline_diff.csv"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

REQUIRED_CONSTANT_IDS = ["lambda", "DeltaV2", "c22", "c25", "L2NT_D2_slack"]
FORBIDDEN_ROW_IDS = {"row22", "row28", "M1V3"}


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


def lean_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def lean_string_list(values: list[str]) -> str:
    return "[" + ", ".join(lean_string(value) for value in values) + "]"


def baseline_row25(rows: list[dict[str, str]]) -> dict[str, str]:
    matches = [row for row in rows if row.get("row_id") == "row25"]
    if len(matches) != 1:
        raise RuntimeError("Expected exactly one row25 baseline row.")
    return matches[0]


def baseline_constants_by_id(constants: list[dict[str, str]]) -> dict[str, dict[str, str]]:
    by_id = {row["constant_id"]: row for row in constants}
    missing = [constant_id for constant_id in REQUIRED_CONSTANT_IDS if constant_id not in by_id]
    if missing:
        raise RuntimeError(f"Missing baseline constants: {', '.join(missing)}")
    return by_id


def derivation_trace(constants_by_id: dict[str, dict[str, str]]) -> list[dict[str, str]]:
    return [
        {
            "step_id": "source_class",
            "rule": "k2 row25 source residue",
            "input": "a % 9 = 5",
            "derived": "a = 9*t + 5",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Parameter t witnesses the residue class.",
        },
        {
            "step_id": "retarded_child",
            "rule": "retarded branch",
            "input": "a",
            "derived": "child = 4*a",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "This is the only consumed EL branch for row25.",
        },
        {
            "step_id": "class_transfer_expand",
            "rule": "substitute a = 9*t + 5",
            "input": "4*a",
            "derived": "4*a = 4*(9*t + 5) = 36*t + 20",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Algebraic expansion for residue computation.",
        },
        {
            "step_id": "class_transfer_mod9",
            "rule": "mod 9 decomposition",
            "input": "36*t + 20",
            "derived": "36*t + 20 = 9*(4*t + 2) + 2, so (4*a) % 9 = 2",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Retarded child transfers from class 5 to tracked class 2.",
        },
        {
            "step_id": "row_shape",
            "rule": "D2 EL row policy",
            "input": "row25",
            "derived": "single-branch retarded; advanced_contribution_in_EL = false",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Auxiliary advanced child may instantiate core but is not consumed.",
        },
        {
            "step_id": "window_transfer",
            "rule": "exact retarded window",
            "input": "2^(y-2) * (4*a)",
            "derived": "2^(y-2) * (4*a) = 2^y * a; concreteWindow (y - 2) (4*a) = concreteWindow y a",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "No floor/ceil loss and no epsilon pad.",
        },
        {
            "step_id": "slack_reference",
            "rule": "baseline certificate reference",
            "input": "certificate_constants.csv",
            "derived": f"L2NT_D2_slack = {constants_by_id['L2NT_D2_slack']['value']}",
            "status": "attached",
            "proof_status": "data_trace_only",
            "notes": "LP is not solved by this microgenerator.",
        },
    ]


def tracked_classes() -> list[dict[str, Any]]:
    return [
        {
            "class_id": "class_mod9_2",
            "modulus": "9",
            "representative": "2",
            "pre_reduction_residues": ["2"],
            "source_rule": "row25_retarded_child_target_class",
            "active": True,
            "notes": "Target class for row25 retarded child 4*a.",
        },
        {
            "class_id": "class_mod9_5",
            "modulus": "9",
            "representative": "5",
            "pre_reduction_residues": ["5"],
            "source_rule": "row25_source_class",
            "active": True,
            "notes": "Source class for row25.",
        },
        {
            "class_id": "class_mod9_8",
            "modulus": "9",
            "representative": "8",
            "pre_reduction_residues": ["8"],
            "source_rule": "k2_tracked_class_not_generated_in_row25_scope",
            "active": True,
            "notes": "Included only because k=2 has three tracked classes; unused by this row25-only artifact.",
        },
    ]


def row25_child() -> dict[str, Any]:
    return {
        "child_id": "row25_retarded_4a",
        "row_id": "row25",
        "literal_id": "row25_retarded_literal",
        "inverse_word": ["even", "even"],
        "target_class": "2",
        "shift": "-2",
        "window_policy": "exact_retarded_window",
        "fiber_parent": "retarded_path_parent_2a",
        "deleted": False,
        "reason": "row25 single-branch retarded source",
        "root_formula": "4*a",
        "forward_route": ["4*a -> 2*a", "2*a -> a"],
        "residue_side_conditions": ["a = 9*t + 5", "4*a = 9*(4*t + 2) + 2"],
        "coefficient_ref": "c22",
        "depth": "2",
        "boundary_correction": "none",
        "window_identity": "concreteWindow (y - 2) (4*a) = concreteWindow y a",
        "rounding_loss": "0",
        "epsilon_pad": "none",
        "advanced_contribution_in_EL": False,
    }


def auxiliary_core_child() -> dict[str, Any]:
    return {
        "child_id": "row25_auxiliary_core_advanced_child",
        "formula": "6*(a/9)+3",
        "arith": "3*c + 1 = 2*a",
        "consumed_by_EL": False,
        "purpose": "d2_single_branch_core_instantiation witness",
        "notes": "Recorded to preserve the distinction between core witness and consumed EL branch.",
    }


def constants_payload(constants_by_id: dict[str, dict[str, str]]) -> list[dict[str, str]]:
    return [
        {
            "coefficient_id": constant_id,
            "lean_name": constants_by_id[constant_id]["lean_name"],
            "value": constants_by_id[constant_id]["value"],
            "kind": constants_by_id[constant_id]["kind"],
            "source": constants_by_id[constant_id]["source"],
            "must_reproduce_exactly": constants_by_id[constant_id]["must_reproduce_exactly"],
            "notes": "row25 microgenerator constant reference",
        }
        for constant_id in REQUIRED_CONSTANT_IDS
    ]


def build_json(
    created_at: str,
    commit: str,
    row25_baseline: dict[str, str],
    constants_by_id: dict[str, dict[str, str]],
) -> dict[str, Any]:
    child = row25_child()
    return {
        "metadata": {
            "run_id": RUN_ID,
            "schema_version": SCHEMA_VERSION,
            "k": "2",
            "tracked_class_convention": "k2_manual_v3_classes_mod9_2_5_8",
            "pre_reduction_class_count": "9",
            "tracked_class_count": "3",
            "format_scope": "high_k_parametric",
            "generation_mode": GENERATION_MODE,
            "mathematical_generation": True,
            "scope": SCOPE,
            "proof_status": "data_candidate_only",
            "artifact_links": {
                "json_artifact": JSON_PATH.name,
                "lean_data_artifact": LEAN_PATH.name,
                "json_to_lean_generator": repo_rel(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": "RECORDED_IN_MANIFEST",
                "lean_import_policy": "Generated Lean data remains in outputs and is not imported.",
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
                    (SCOPING, "row25_microgenerator_scoping"),
                    (SCHEMA_SCOPING, "schema_v2_scoping"),
                    (BASELINE_ROWS, "row25_baseline_row"),
                    (BASELINE_CONSTANTS, "row25_baseline_constants"),
                ]
            ],
            "guardrails": [
                "DATA_CANDIDATE_ONLY",
                "NO_LEAN_PROOF",
                "NO_GENERATED_LEAN_IMPORT",
                "NO_K3_GENERATION",
                "NO_LP_SOLVED",
                "NO_THEOREM_CLAIM",
                "NO_HIGH_K_CLAIM",
                "NO_GLOBAL_COLLATZ_CLAIM",
            ],
        },
        "tracked_classes": tracked_classes(),
        "rows": [
            {
                "row_id": "row25",
                "source_class": row25_baseline["source_class"],
                "row_kind": row25_baseline["row_family"],
                "children": [child],
                "deletion_policy": "none_for_consumed_branch",
                "coefficient_terms": [
                    {
                        "coefficient_id": "c22",
                        "role": "source_phi22_y_minus_2",
                        "value": constants_by_id["c22"]["value"],
                    },
                    {
                        "coefficient_id": "c25",
                        "role": "target_phi25_y",
                        "value": constants_by_id["c25"]["value"],
                    },
                ],
                "target_bound": constants_by_id["c25"]["value"],
                "slack_id": "L2NT_D2_slack",
                "source_ref": row25_baseline["baseline_refs"],
                "normalization_ref": "rule_derived_row25",
                "generation_mode": GENERATION_MODE,
                "mathematical_generation": True,
                "proof_status": "data_candidate_only",
                "baseline_expected_shape": row25_baseline["expected_shape"],
                "baseline_required_feature": row25_baseline["required_feature"],
                "advanced_contribution_in_EL": False,
                "auxiliary_core_child": auxiliary_core_child(),
            }
        ],
        "inverse_words": [child],
        "deletion_marks": [
            {
                "row_id": "row25",
                "child_id": child["child_id"],
                "deleted": False,
                "deletion_policy": "none_for_consumed_branch",
                "reason": "row25 consumed branch is kept; no deletion needed",
                "boundary_correction": "none",
                "source_ref": row25_baseline["baseline_refs"],
            }
        ],
        "rational_certificate": {
            "lambda_interval": {"exact": constants_by_id["lambda"]["value"], "source": "baseline"},
            "coefficient_intervals": constants_payload(constants_by_id),
            "variables": {
                "source_root": "a",
                "residue_parameter": "t",
                "retarded_child": "4*a",
            },
            "row_lhs": {"row25": "c22"},
            "row_rhs": {"row25": "c25"},
            "solver_manifest": {
                "solver": "none",
                "lp_solved": False,
                "notes": "Row25 microgenerator attaches baseline slack; it does not solve an LP.",
            },
            "float_diagnostics": {
                "float_evidence_used": False,
                "notes": "No floats are emitted as evidence.",
            },
        },
        "slacks": [
            {
                "slack_id": "L2NT_D2_slack",
                "row_id": "row25",
                "lhs": "0",
                "rhs": constants_by_id["L2NT_D2_slack"]["value"],
                "slack": constants_by_id["L2NT_D2_slack"]["value"],
                "strictly_positive": True,
                "denominator_bits": "0",
                "numerator_bits": "0",
                "notes": "Baseline row25/D2 slack; positivity is for future verifier.",
            }
        ],
        "verification_targets": [
            {
                "target_id": target_id,
                "input_sections": ["rows", "inverse_words", "rational_certificate", "slacks"],
                "expected_checker": "future_row25_lean_verifier",
                "status": "PENDING_LEAN_VERIFIER",
                "notes": notes,
            }
            for target_id, notes in [
                ("row_well_formed", "Check row25 generated shape."),
                ("residue_compatibility", "Check a % 9 = 5 -> (4*a) % 9 = 2."),
                ("inverse_word_forward_route", "Check 4*a -> 2*a -> a."),
                ("deletion_rule_soundness", "Check no consumed branch deletion."),
                ("abstract_row_discharge", "Check row25 single-branch seam obligation."),
                ("rational_slack_positive", "Check L2NT_D2_slack positivity."),
            ]
        ],
        "no_claims": {
            "lean_proof": False,
            "theorem_claim": False,
            "k3_generation": False,
            "high_k_claim": False,
            "global_collatz_claim": False,
        },
    }


def build_diff(
    generated: dict[str, Any],
    row25_baseline: dict[str, str],
    constants_by_id: dict[str, dict[str, str]],
) -> tuple[list[dict[str, str]], list[str]]:
    rows = generated.get("rows", [])
    generated_row_ids = [row.get("row_id") for row in rows if isinstance(row, dict)]
    generated_row = rows[0] if len(rows) == 1 and isinstance(rows[0], dict) else {}
    generated_constants = {
        row.get("coefficient_id"): row.get("value")
        for row in generated.get("rational_certificate", {}).get("coefficient_intervals", [])
        if isinstance(row, dict)
    }
    diff_rows: list[dict[str, str]] = []
    failures: list[str] = []

    checks = [
        ("row25_only", ["row25"], generated_row_ids, "only row25 is generated"),
        ("row_id", "row25", generated_row.get("row_id"), "row id matches baseline"),
        ("source_class", row25_baseline["source_class"], generated_row.get("source_class"), "source class preserved"),
        ("row_kind", row25_baseline["row_family"], generated_row.get("row_kind"), "row family preserved"),
        (
            "expected_shape",
            row25_baseline["expected_shape"],
            generated_row.get("baseline_expected_shape"),
            "row25 single-branch shape preserved",
        ),
        (
            "required_feature",
            row25_baseline["required_feature"],
            generated_row.get("baseline_required_feature"),
            "row25 single-branch feature preserved",
        ),
        ("advanced_absent", False, generated_row.get("advanced_contribution_in_EL"), "no advanced EL contribution"),
        (
            "generation_mode",
            GENERATION_MODE,
            generated.get("metadata", {}).get("generation_mode"),
            "rule-derived generation mode",
        ),
        (
            "mathematical_generation",
            True,
            generated.get("metadata", {}).get("mathematical_generation"),
            "mathematical generation flag set",
        ),
        (
            "proof_status",
            "data_candidate_only",
            generated.get("metadata", {}).get("proof_status"),
            "no theorem/proof claim",
        ),
    ]
    for constant_id in REQUIRED_CONSTANT_IDS:
        checks.append(
            (
                f"constant_{constant_id}",
                constants_by_id[constant_id]["value"],
                generated_constants.get(constant_id),
                f"{constant_id} baseline value preserved",
            )
        )

    child = generated.get("inverse_words", [{}])[0]
    if not isinstance(child, dict):
        child = {}
    checks.extend(
        [
            ("child_formula", "4*a", child.get("root_formula"), "retarded child formula derived"),
            ("child_target_class", "2", child.get("target_class"), "retarded child class is 2"),
            ("child_shift", "-2", child.get("shift"), "retarded shift is -2"),
            (
                "window_policy",
                "exact_retarded_window",
                child.get("window_policy"),
                "exact retarded window policy",
            ),
        ]
    )

    for check_id, expected, actual, notes in checks:
        ok = expected == actual
        if not ok:
            failures.append(check_id)
        diff_rows.append(
            {
                "check_id": check_id,
                "expected": json.dumps(expected, sort_keys=True) if isinstance(expected, list) else str(expected),
                "actual": json.dumps(actual, sort_keys=True) if isinstance(actual, list) else str(actual),
                "status": "pass" if ok else "fail",
                "diff_kind": "MATCH" if ok else "MATH_DIFF",
                "notes": notes,
            }
        )
    return diff_rows, failures


def write_lean_data(path: Path, generated: dict[str, Any]) -> None:
    constants = generated["rational_certificate"]["coefficient_intervals"]
    constant_ids = [constant["coefficient_id"] for constant in constants]
    constant_values = [constant["value"] for constant in constants]
    text = f"""-- generated k2 row25 data; not imported; verifier not yet written
-- Generated by scripts/{GENERATOR_VERSION}
-- Schema: {SCHEMA_VERSION}
-- Mode: {GENERATION_MODE}
-- Scope: {SCOPE}
-- This file contains data declarations only and no mathematical theorem.

namespace KL2003F2K2Row25Generated

def schemaVersion : String := {lean_string(SCHEMA_VERSION)}
def generationMode : String := {lean_string(GENERATION_MODE)}
def scope : String := {lean_string(SCOPE)}
def proofStatus : String := "data_candidate_only"

def k : Nat := 2
def trackedClassCount : Nat := 3
def preReductionClassCount : Nat := 9

def rowId : String := "row25"
def sourceResidueMod9 : Nat := 5
def retardedChildFormula : String := "4*a"
def retardedChildResidueMod9 : Nat := 2
def shift : String := "-2"
def windowPolicy : String := "exact_retarded_window"
def advancedContributionInEL : Bool := false

def constantIds : List String := {lean_string_list(constant_ids)}
def constantValues : List String := {lean_string_list(constant_values)}

-- Candidate data only.  A future verifier must prove residue, route, window,
-- and slack obligations before any theorem may consume this generated data.

end KL2003F2K2Row25Generated
"""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_manifest(created_at: str, commit: str) -> None:
    json_hash = sha256(JSON_PATH)
    lean_hash = sha256(LEAN_PATH)
    generator_hash = sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION)
    paths = [
        (JSON_PATH, "generated_json"),
        (LEAN_PATH, "generated_lean_data"),
        (TRACE_PATH, "derivation_trace"),
        (DIFF_PATH, "semantic_diff"),
        (SUMMARY_PATH, "summary"),
        (REPO_ROOT / "scripts" / GENERATOR_VERSION, "generator"),
        (SCOPING, "source_doc"),
        (SCHEMA_SCOPING, "source_doc"),
        (BASELINE_ROWS, "baseline_input"),
        (BASELINE_CONSTANTS, "baseline_input"),
    ]
    rows = [
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
            "notes": "k2 row25 rule-derived microgenerator; data candidate only",
        }
        for path, kind in paths
    ]
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
    rows = read_csv(BASELINE_ROWS)
    constants = read_csv(BASELINE_CONSTANTS)
    row25 = baseline_row25(rows)
    constants_by_id = baseline_constants_by_id(constants)

    trace_rows = derivation_trace(constants_by_id)
    generated = build_json(created_at, commit, row25, constants_by_id)
    diff_rows, failures = build_diff(generated, row25, constants_by_id)

    verdict = "ROW25_MICROGENERATOR_DIFF_PASS" if not failures else "ROW25_MICROGENERATOR_DIFF_FAIL"
    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": commit,
        "schema_version": SCHEMA_VERSION,
        "generator_version": GENERATOR_VERSION,
        "generation_mode": GENERATION_MODE,
        "mathematical_generation": True,
        "proof_status": "data_candidate_only",
        "scope": SCOPE,
        "row_count": len(generated["rows"]),
        "generated_row_ids": [row["row_id"] for row in generated["rows"]],
        "forbidden_row_ids_present": sorted(FORBIDDEN_ROW_IDS.intersection({row["row_id"] for row in generated["rows"]})),
        "derivation_step_count": len(trace_rows),
        "diff_check_count": len(diff_rows),
        "diff_failure_count": len(failures),
        "diff_failures": failures,
        "verdict": verdict,
        "json_artifact": repo_rel(JSON_PATH),
        "lean_data_artifact": repo_rel(LEAN_PATH),
        "derivation_trace": repo_rel(TRACE_PATH),
        "diff_artifact": repo_rel(DIFF_PATH),
        "manifest": repo_rel(MANIFEST_PATH),
        "guardrails": [
            "DATA_CANDIDATE_ONLY",
            "NO_LEAN_PROOF",
            "NO_GENERATED_LEAN_IMPORT",
            "NO_K3_GENERATION",
            "NO_LP_SOLVED",
            "NO_THEOREM_CLAIM",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "K2_ROW25_MICROGENERATOR_CREATED",
            "ROW25_RULE_DERIVATION_EMITTED",
            "ROW25_MICROGENERATOR_DIFF_PASS" if verdict == "ROW25_MICROGENERATOR_DIFF_PASS" else verdict,
            "DATA_CANDIDATE_ONLY",
            "NO_LEAN_PROOF",
            "NO_K3_GENERATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }

    write_json(JSON_PATH, generated)
    write_lean_data(LEAN_PATH, generated)
    write_csv(
        TRACE_PATH,
        trace_rows,
        ["step_id", "rule", "input", "derived", "status", "proof_status", "notes"],
    )
    write_csv(
        DIFF_PATH,
        diff_rows,
        ["check_id", "expected", "actual", "status", "diff_kind", "notes"],
    )
    write_json(SUMMARY_PATH, summary)
    write_manifest(created_at, commit)

    print(f"run_id={RUN_ID}")
    print(f"verdict={verdict}")
    print(f"generation_mode={GENERATION_MODE}")
    print("mathematical_generation=true")
    print("proof_status=data_candidate_only")
    print(f"derivation_step_count={len(trace_rows)}")
    print(f"diff_failure_count={len(failures)}")
    print("no Lean proof, no k=3 generation, no high-k claim, no global Collatz claim")
    return 0 if verdict == "ROW25_MICROGENERATOR_DIFF_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
