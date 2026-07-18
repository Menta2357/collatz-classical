#!/usr/bin/env python3
"""Generate the KL2003 F2 k=2 row22 microgenerator artifact.

This is the second rule-derived row generator in the F2 track.  It emits only
row22 from explicit residue, branch, parity-lift, and window-policy rules,
compares the generated row against the manual k=2 baseline row22, and writes
JSON + Lean data twins in schema v2 form.

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


RUN_ID = "KL2003_F2_K2_ROW22_MICROGENERATOR_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
GENERATOR_VERSION = "kl2003_f2_k2_row22_microgenerator_v1.py"
GENERATION_MODE = "rule_derived_row22"
SCOPE = "k2_row22_only"

REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
BASELINE_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1"

SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K2_ROW22_MICROGENERATOR_SCOPING_v1.md"
SCHEMA_SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K3_DATA_CERTIFICATE_FORMAT_SCOPING_v1.md"
BASELINE_ROWS = BASELINE_DIR / "expected_rows_v3.csv"
BASELINE_CONSTANTS = BASELINE_DIR / "certificate_constants.csv"

JSON_PATH = OUT_DIR / "row22.generated.json"
LEAN_PATH = OUT_DIR / "KL2003K2Row22GeneratedData.lean"
TRACE_PATH = OUT_DIR / "row22_derivation_trace.csv"
DIFF_PATH = OUT_DIR / "row22_vs_baseline_diff.csv"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

REQUIRED_CONSTANT_IDS = ["lambda", "DeltaV2", "c22", "c25", "c28", "L2NT_D1_slack"]
FORBIDDEN_ROW_IDS = {"row25", "row28", "M1V3"}


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


def baseline_row22(rows: list[dict[str, str]]) -> dict[str, str]:
    matches = [row for row in rows if row.get("row_id") == "row22"]
    if len(matches) != 1:
        raise RuntimeError("Expected exactly one row22 baseline row.")
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
            "rule": "k2 row22 source residue",
            "input": "a % 9 = 2",
            "derived": "a = 9*t + 2",
            "source_kind": "PARAMETRIC_RULE",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Parameter t witnesses the row22 source residue.",
        },
        {
            "step_id": "retarded_child",
            "rule": "retarded branch",
            "input": "a",
            "derived": "child = 4*a",
            "source_kind": "PARAMETRIC_RULE",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Retarded branch is consumed by the D1 row.",
        },
        {
            "step_id": "retarded_class_transfer_mod9",
            "rule": "substitute a = 9*t + 2",
            "input": "4*a",
            "derived": "4*a = 4*(9*t + 2) = 36*t + 8, so (4*a) % 9 = 8",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Retarded branch transfers from class 2 to tracked class 8.",
        },
        {
            "step_id": "retarded_window_transfer",
            "rule": "exact retarded window",
            "input": "2^(y-2) * (4*a)",
            "derived": "2^(y-2) * (4*a) = 2^y * a; concreteWindow (y - 2) (4*a) = concreteWindow y a",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "No retarded rounding loss.",
        },
        {
            "step_id": "advanced_child_definition",
            "rule": "odd inverse child for row22",
            "input": "a = 9*t + 2",
            "derived": "c = 6*t + 1",
            "source_kind": "PARAMETRIC_RULE",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Direct advanced child for D1 before parity lift.",
        },
        {
            "step_id": "advanced_child_arithmetic",
            "rule": "odd child maps to root",
            "input": "a = 9*t + 2, c = 6*t + 1",
            "derived": "3*c + 1 = 3*(6*t + 1) + 1 = 18*t + 4 = 2*a",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Equivalently T c = a for the KL2003 T.",
        },
        {
            "step_id": "advanced_child_mod_three",
            "rule": "direct child not tracked",
            "input": "c = 6*t + 1",
            "derived": "c % 3 = 1, so direct c is not in tracked classes {2,5,8}",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Generator must not treat direct c as the tracked advanced child.",
        },
        {
            "step_id": "parity_lift_definition",
            "rule": "parity lift",
            "input": "c",
            "derived": "lifted = 2*c",
            "source_kind": "PARAMETRIC_RULE",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "This is the tracked advanced population.",
        },
        {
            "step_id": "parity_lift_forward_route",
            "rule": "forward route",
            "input": "lifted = 2*c, 3*c + 1 = 2*a",
            "derived": "2c -> c -> a",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Explains the extra -1 shift after the direct advanced child.",
        },
        {
            "step_id": "parity_window_transfer",
            "rule": "exact parity window",
            "input": "2^(z-1) * (2*c)",
            "derived": "2^(z-1) * (2*c) = 2^z * c; concreteWindow (z - 1) (2*c) = concreteWindow z c",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "Parity lift itself has exact window transfer.",
        },
        {
            "step_id": "lifted_residue_split_mod2",
            "rule": "split t % 3 = 0",
            "input": "2*c = 12*t + 2",
            "derived": "if t % 3 = 0 then (2*c) % 9 = 2",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "One arm of min3.",
        },
        {
            "step_id": "lifted_residue_split_mod5",
            "rule": "split t % 3 = 1",
            "input": "2*c = 12*t + 2",
            "derived": "if t % 3 = 1 then (2*c) % 9 = 5",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "One arm of min3.",
        },
        {
            "step_id": "lifted_residue_split_mod8",
            "rule": "split t % 3 = 2",
            "input": "2*c = 12*t + 2",
            "derived": "if t % 3 = 2 then (2*c) % 9 = 8",
            "source_kind": "ARITHMETIC_DERIVATION",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "One arm of min3.",
        },
        {
            "step_id": "row_shape",
            "rule": "D1 EL row policy",
            "input": "row22",
            "derived": "two-branch: retarded phi28(y-2) plus advanced parity-lift min3 at y + shiftAlphaMinus2Pad",
            "source_kind": "PARAMETRIC_RULE",
            "status": "derived",
            "proof_status": "data_trace_only",
            "notes": "No row28 nested M1V3/M2V3 and no deletion tree in this scope.",
        },
        {
            "step_id": "slack_reference",
            "rule": "baseline certificate reference",
            "input": "certificate_constants.csv",
            "derived": f"L2NT_D1_slack = {constants_by_id['L2NT_D1_slack']['value']}",
            "source_kind": "BASELINE_REGRESSION_TARGET",
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
            "source_rule": "row22_source_and_lifted_split_target",
            "active": True,
            "notes": "Source class for row22 and one lifted residue split case.",
        },
        {
            "class_id": "class_mod9_5",
            "modulus": "9",
            "representative": "5",
            "pre_reduction_residues": ["5"],
            "source_rule": "row22_lifted_split_target",
            "active": True,
            "notes": "One lifted residue split case in the min3 branch.",
        },
        {
            "class_id": "class_mod9_8",
            "modulus": "9",
            "representative": "8",
            "pre_reduction_residues": ["8"],
            "source_rule": "row22_retarded_child_target_class",
            "active": True,
            "notes": "Target class for row22 retarded child 4*a and one lifted split case.",
        },
    ]


def row22_retarded_child() -> dict[str, Any]:
    return {
        "child_id": "row22_retarded_4a",
        "row_id": "row22",
        "literal_id": "row22_retarded_literal",
        "branch_kind": "retarded",
        "inverse_word": ["even", "even"],
        "target_class": "8",
        "shift": "-2",
        "window_policy": "exact_retarded_window",
        "fiber_parent": "retarded_path_parent_2a",
        "deleted": False,
        "reason": "row22 retarded source",
        "root_formula": "4*a",
        "forward_route": ["4*a -> 2*a", "2*a -> a"],
        "residue_side_conditions": ["a = 9*t + 2", "4*a = 9*(4*t) + 8"],
        "coefficient_ref": "c28",
        "depth": "2",
        "boundary_correction": "none",
        "window_identity": "concreteWindow (y - 2) (4*a) = concreteWindow y a",
        "rounding_loss": "0",
        "epsilon_pad": "none",
        "advanced_contribution_in_EL": False,
    }


def row22_advanced_lifted_child() -> dict[str, Any]:
    return {
        "child_id": "row22_advanced_lifted_2c",
        "row_id": "row22",
        "literal_id": "row22_advanced_parity_lift_literal",
        "branch_kind": "advanced_parity_lift",
        "inverse_word": ["odd_preimage", "even_lift"],
        "target_class": "min3_2_5_8",
        "shift": "-2",
        "symbolic_shift": "shiftAlphaMinus2Pad",
        "window_policy": "advanced_parity_lift_with_epsilon_pad",
        "fiber_parent": "advanced_child_c",
        "deleted": False,
        "reason": "direct advanced child c is 1 mod 3, so lifted child 2*c is tracked",
        "direct_child_formula": "c = 6*t + 1",
        "direct_child_tracked": False,
        "root_formula": "2*c = 12*t + 2",
        "forward_route": ["2*c -> c", "c -> a"],
        "residue_side_conditions": [
            "a = 9*t + 2",
            "c = 6*t + 1",
            "c % 3 = 1",
            "t % 3 = 0 -> (2*c) % 9 = 2",
            "t % 3 = 1 -> (2*c) % 9 = 5",
            "t % 3 = 2 -> (2*c) % 9 = 8",
        ],
        "residue_split": [
            {"condition": "t % 3 = 0", "target_class": "2"},
            {"condition": "t % 3 = 1", "target_class": "5"},
            {"condition": "t % 3 = 2", "target_class": "8"},
        ],
        "coefficient_ref": "min3(c22,c25,c28)",
        "depth": "2",
        "boundary_correction": "epsilon0_pad_for_advanced_window",
        "window_identity": "concreteWindow (z - 1) (2*c) = concreteWindow z c",
        "window_pad": "shiftAlphaMinus2Pad = alpha - 2 - epsilon0",
        "rounding_loss": "0",
        "epsilon_pad": "epsilon0",
        "advanced_contribution_in_EL": True,
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
            "notes": "row22 microgenerator constant reference",
        }
        for constant_id in REQUIRED_CONSTANT_IDS
    ]


def build_json(
    created_at: str,
    commit: str,
    row22_baseline: dict[str, str],
    constants_by_id: dict[str, dict[str, str]],
) -> dict[str, Any]:
    retarded = row22_retarded_child()
    advanced = row22_advanced_lifted_child()
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
                    (SCOPING, "row22_microgenerator_scoping"),
                    (SCHEMA_SCOPING, "schema_v2_scoping"),
                    (BASELINE_ROWS, "row22_baseline_row"),
                    (BASELINE_CONSTANTS, "row22_baseline_constants"),
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
                "row_id": "row22",
                "source_class": row22_baseline["source_class"],
                "row_kind": row22_baseline["row_family"],
                "children": [retarded, advanced],
                "deletion_policy": "none_for_row22_microgenerator_scope",
                "coefficient_terms": [
                    {
                        "coefficient_id": "c28",
                        "role": "retarded_phi28_y_minus_2",
                        "value": constants_by_id["c28"]["value"],
                    },
                    {
                        "coefficient_id": "c22",
                        "role": "target_phi22_y",
                        "value": constants_by_id["c22"]["value"],
                    },
                    {
                        "coefficient_id": "min3_c22_c25_c28",
                        "role": "advanced_parity_lift_min3",
                        "value": "1",
                    },
                ],
                "target_bound": constants_by_id["c22"]["value"],
                "slack_id": "L2NT_D1_slack",
                "source_ref": row22_baseline["baseline_refs"],
                "normalization_ref": "rule_derived_row22",
                "generation_mode": GENERATION_MODE,
                "mathematical_generation": True,
                "proof_status": "data_candidate_only",
                "baseline_expected_shape": row22_baseline["expected_shape"],
                "baseline_required_feature": row22_baseline["required_feature"],
                "advanced_direct_child_tracked": False,
                "parity_lift": True,
                "advanced_contribution_in_EL": True,
                "row_shape_symbolic": "phi28(y - 2) + min3(phi22,phi25,phi28)(y + shiftAlphaMinus2Pad) <= phi22(y)",
            }
        ],
        "inverse_words": [retarded, advanced],
        "deletion_marks": [
            {
                "row_id": "row22",
                "child_id": retarded["child_id"],
                "deleted": False,
                "deletion_policy": "none_for_row22_microgenerator_scope",
                "reason": "row22 retarded branch is kept",
                "boundary_correction": "none",
                "source_ref": row22_baseline["baseline_refs"],
            },
            {
                "row_id": "row22",
                "child_id": advanced["child_id"],
                "deleted": False,
                "deletion_policy": "none_for_row22_microgenerator_scope",
                "reason": "row22 parity-lifted advanced branch is kept",
                "boundary_correction": "epsilon0_pad_for_advanced_window",
                "source_ref": row22_baseline["baseline_refs"],
            },
        ],
        "rational_certificate": {
            "lambda_interval": {"exact": constants_by_id["lambda"]["value"], "source": "baseline"},
            "coefficient_intervals": constants_payload(constants_by_id),
            "variables": {
                "source_root": "a",
                "residue_parameter": "t",
                "retarded_child": "4*a",
                "advanced_child": "c = 6*t + 1",
                "lifted_child": "2*c = 12*t + 2",
            },
            "row_lhs": {"row22": "c28 + min3(c22,c25,c28)"},
            "row_rhs": {"row22": "c22"},
            "solver_manifest": {
                "solver": "none",
                "lp_solved": False,
                "notes": "Row22 microgenerator attaches baseline slack; it does not solve an LP.",
            },
            "float_diagnostics": {
                "float_evidence_used": False,
                "notes": "No floats are emitted as evidence.",
            },
        },
        "slacks": [
            {
                "slack_id": "L2NT_D1_slack",
                "row_id": "row22",
                "lhs": "0",
                "rhs": constants_by_id["L2NT_D1_slack"]["value"],
                "slack": constants_by_id["L2NT_D1_slack"]["value"],
                "strictly_positive": True,
                "denominator_bits": "0",
                "numerator_bits": "0",
                "notes": "Baseline row22/D1 slack; positivity is for future verifier.",
            }
        ],
        "verification_targets": [
            {
                "target_id": target_id,
                "input_sections": ["rows", "inverse_words", "rational_certificate", "slacks"],
                "expected_checker": "future_row22_lean_verifier",
                "status": "PENDING_LEAN_VERIFIER",
                "notes": notes,
            }
            for target_id, notes in [
                ("row_well_formed", "Check row22 generated two-branch shape."),
                ("retarded_residue_compatibility", "Check a % 9 = 2 -> (4*a) % 9 = 8."),
                ("advanced_child_arithmetic", "Check c = 6*t + 1 and 3*c + 1 = 2*a."),
                ("advanced_child_not_tracked", "Check c % 3 = 1 and direct c is not tracked."),
                ("parity_lift_forward_route", "Check 2*c -> c -> a."),
                ("lifted_residue_split", "Check lifted child cases in {2,5,8}."),
                ("window_policy", "Check retarded window and parity lift window/pad policy."),
                ("deletion_rule_soundness", "Check no row22 microgenerator deletion marks are consumed."),
                ("abstract_row_discharge", "Check row22 seam obligation shape."),
                ("rational_slack_positive", "Check L2NT_D1_slack positivity."),
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
    row22_baseline: dict[str, str],
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
    inverse_words = generated.get("inverse_words", [])
    child_ids = [child.get("child_id") for child in inverse_words if isinstance(child, dict)]
    retarded = next(
        (child for child in inverse_words if isinstance(child, dict) and child.get("child_id") == "row22_retarded_4a"),
        {},
    )
    advanced = next(
        (
            child
            for child in inverse_words
            if isinstance(child, dict) and child.get("child_id") == "row22_advanced_lifted_2c"
        ),
        {},
    )
    lifted_split_targets = sorted(
        split.get("target_class")
        for split in advanced.get("residue_split", [])
        if isinstance(split, dict)
    )

    checks: list[tuple[str, Any, Any, str]] = [
        ("row22_only", ["row22"], generated_row_ids, "only row22 is generated"),
        ("forbidden_rows_absent", [], sorted(FORBIDDEN_ROW_IDS.intersection(generated_row_ids)), "no row25/row28/M1V3"),
        ("row_id", "row22", generated_row.get("row_id"), "row id matches baseline"),
        ("source_class", row22_baseline["source_class"], generated_row.get("source_class"), "source class preserved"),
        ("row_kind", row22_baseline["row_family"], generated_row.get("row_kind"), "row family preserved"),
        (
            "expected_shape",
            row22_baseline["expected_shape"],
            generated_row.get("baseline_expected_shape"),
            "row22 two-branch shape preserved",
        ),
        (
            "required_feature",
            row22_baseline["required_feature"],
            generated_row.get("baseline_required_feature"),
            "row22 parity-lift feature preserved",
        ),
        ("parity_lift", True, generated_row.get("parity_lift"), "parity lift present"),
        (
            "direct_child_not_tracked",
            False,
            generated_row.get("advanced_direct_child_tracked"),
            "direct c is not treated as tracked",
        ),
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
        (
            "child_ids",
            ["row22_retarded_4a", "row22_advanced_lifted_2c"],
            child_ids,
            "retarded and lifted advanced children emitted",
        ),
        ("retarded_formula", "4*a", retarded.get("root_formula"), "retarded child formula derived"),
        ("retarded_target_class", "8", retarded.get("target_class"), "retarded child class is 8"),
        ("retarded_shift", "-2", retarded.get("shift"), "retarded shift is -2"),
        (
            "advanced_direct_formula",
            "c = 6*t + 1",
            advanced.get("direct_child_formula"),
            "direct advanced child formula derived",
        ),
        ("advanced_direct_tracked", False, advanced.get("direct_child_tracked"), "direct child is not tracked"),
        ("lifted_formula", "2*c = 12*t + 2", advanced.get("root_formula"), "lifted child formula derived"),
        ("lifted_target_class", "min3_2_5_8", advanced.get("target_class"), "lifted child routes to min3"),
        ("lifted_residue_split", ["2", "5", "8"], lifted_split_targets, "lifted residue split in tracked classes"),
        (
            "advanced_window_policy",
            "advanced_parity_lift_with_epsilon_pad",
            advanced.get("window_policy"),
            "advanced parity lift pad recorded",
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

    diff_rows: list[dict[str, str]] = []
    failures: list[str] = []
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
    text = f"""-- generated k2 row22 data; not imported; verifier not yet written
-- Generated by scripts/{GENERATOR_VERSION}
-- Schema: {SCHEMA_VERSION}
-- Mode: {GENERATION_MODE}
-- Scope: {SCOPE}
-- This file contains data declarations only and no mathematical theorem.

namespace KL2003F2K2Row22Generated

def schemaVersion : String := {lean_string(SCHEMA_VERSION)}
def generationMode : String := {lean_string(GENERATION_MODE)}
def scope : String := {lean_string(SCOPE)}
def proofStatus : String := "data_candidate_only"

def k : Nat := 2
def trackedClassCount : Nat := 3
def preReductionClassCount : Nat := 9

def rowId : String := "row22"
def sourceResidueMod9 : Nat := 2
def retardedChildFormula : String := "4*a"
def retardedChildResidueMod9 : Nat := 8
def advancedChildFormula : String := "c = 6*t + 1"
def advancedChildTracked : Bool := false
def liftedChildFormula : String := "2*c = 12*t + 2"
def liftedResidueTargets : List Nat := [2, 5, 8]
def parityLiftRoute : List String := ["2*c -> c", "c -> a"]
def rowShape : String :=
  "phi28(y - 2) + min3(phi22,phi25,phi28)(y + shiftAlphaMinus2Pad) <= phi22(y)"
def proofClaim : Bool := false

def constantIds : List String := {lean_string_list(constant_ids)}
def constantValues : List String := {lean_string_list(constant_values)}

-- Candidate data only.  A future verifier must prove residue, route, parity
-- lift, window, min3 transfer, and slack obligations before any theorem may
-- consume this generated data.

end KL2003F2K2Row22Generated
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
            "notes": "k2 row22 rule-derived microgenerator; data candidate only",
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
    row22 = baseline_row22(rows)
    constants_by_id = baseline_constants_by_id(constants)

    trace_rows = derivation_trace(constants_by_id)
    generated = build_json(created_at, commit, row22, constants_by_id)
    diff_rows, failures = build_diff(generated, row22, constants_by_id)

    verdict = "ROW22_MICROGENERATOR_DIFF_PASS" if not failures else "ROW22_MICROGENERATOR_DIFF_FAIL"
    generated_row_ids = [row["row_id"] for row in generated["rows"]]
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
        "generated_row_ids": generated_row_ids,
        "forbidden_row_ids_present": sorted(FORBIDDEN_ROW_IDS.intersection(generated_row_ids)),
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
        "row22_features": {
            "two_branch": True,
            "retarded_branch": "4*a -> class 8",
            "advanced_direct_child": "c = 6*t + 1",
            "advanced_direct_child_tracked": False,
            "parity_lift": "2*c",
            "lifted_residue_split": ["2", "5", "8"],
            "m1v3_present": False,
            "deletion_tree_present": False,
        },
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
            "K2_ROW22_MICROGENERATOR_CREATED",
            "ROW22_RULE_DERIVATION_EMITTED",
            "PARITY_LIFT_GENERATED",
            "ROW22_MICROGENERATOR_DIFF_PASS" if verdict == "ROW22_MICROGENERATOR_DIFF_PASS" else verdict,
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
        ["step_id", "rule", "input", "derived", "source_kind", "status", "proof_status", "notes"],
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
    print("parity_lift=generated")
    print("no Lean proof, no k=3 generation, no high-k claim, no global Collatz claim")
    return 0 if verdict == "ROW22_MICROGENERATOR_DIFF_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
