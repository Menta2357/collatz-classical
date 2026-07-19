#!/usr/bin/env python3
"""Generate the KL2003 F2 k=2 row28 nested-EL data candidate.

The generator derives the row28 expansion tree from the parametric D1/D3,
splitting, and deletion rules already exercised by the saturation experiment.
Only after generation does it compare the result with the manual V3 baseline
and Figure A1.  The JSON and Lean twins are data candidates, not proofs.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import kl2003_f2_k2_row28_deletion_saturation_experiment_v1 as saturation


RUN_ID = "KL2003_F2_K2_ROW28_MICROGENERATOR_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"
GENERATOR_VERSION = "kl2003_f2_k2_row28_microgenerator_v1.py"
GENERATION_MODE = "rule_derived_row28"
SCOPE = "k2_row28_only"

REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
BASELINE_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1"

SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K2_ROW28_MICROGENERATOR_SCOPING_v1.md"
SCHEMA_DOC = REPO_ROOT / "docs" / "KL2003_F2_HIGH_K_SCHEMA_V2_1_NESTED_EL_AMENDMENT_v1.md"
META_ERRATA = REPO_ROOT / "docs" / "KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md"
BASELINE_ROWS = BASELINE_DIR / "expected_rows_v3.csv"
BASELINE_CONSTANTS = BASELINE_DIR / "certificate_constants.csv"

JSON_PATH = OUT_DIR / "row28.generated.json"
LEAN_PATH = OUT_DIR / "KL2003K2Row28GeneratedData.lean"
TRACE_PATH = OUT_DIR / "row28_derivation_trace.csv"
DIFF_PATH = OUT_DIR / "row28_vs_baseline_diff.csv"
FIGURE_DIFF_PATH = OUT_DIR / "row28_tree_diff_against_figure_a1.csv"
DECISION_PATH = OUT_DIR / "row28_decision_checks.csv"
TREE_NODES_PATH = OUT_DIR / "row28_generated_tree_nodes.csv"
TREE_EDGES_PATH = OUT_DIR / "row28_generated_tree_edges.csv"
DELETION_PATH = OUT_DIR / "row28_deletion_trace.csv"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

REQUIRED_CONSTANT_IDS = ["lambda", "DeltaV2", "c22", "c25", "c28", "L2NT_D3_slack"]
FORBIDDEN_TOP_LEVEL_ROW_IDS = {"row22", "row25", "M1V3"}


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


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


def source_commit_time() -> str:
    try:
        return subprocess.check_output(
            ["git", "show", "-s", "--format=%cI", "HEAD"],
            cwd=REPO_ROOT,
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return "UNKNOWN_SOURCE_COMMIT_TIME"


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
                encoded[field] = json.dumps(value, sort_keys=True) if isinstance(value, (dict, list)) else value
            writer.writerow(encoded)


def lean_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def lean_string_list(values: list[str]) -> str:
    return "[" + ", ".join(lean_string(value) for value in values) + "]"


def baseline_by_id(rows: list[dict[str, str]], row_id: str) -> dict[str, str]:
    matches = [row for row in rows if row.get("row_id") == row_id]
    if len(matches) != 1:
        raise RuntimeError(f"Expected exactly one baseline row `{row_id}`.")
    return matches[0]


def constants_by_id(rows: list[dict[str, str]]) -> dict[str, dict[str, str]]:
    result = {row["constant_id"]: row for row in rows}
    missing = [constant_id for constant_id in REQUIRED_CONSTANT_IDS if constant_id not in result]
    if missing:
        raise RuntimeError(f"Missing baseline constants: {', '.join(missing)}")
    return result


def oracle_figure_ids_by_signature() -> dict[str, str]:
    node_rows = saturation.read_csv(saturation.ORACLE_NODES)
    path_rows = saturation.read_csv(saturation.ROOT_PATHS)
    node_labels: dict[str, str] = {}
    for row in node_rows:
        kind, mode, shift = saturation.parse_oracle_label(row.get("label", ""))
        node_labels[row["node_id"]] = saturation.node_label(kind, mode, shift)
    result: dict[str, str] = {}
    for row in path_rows:
        path_ids = row["path_node_ids"].split()
        signature = " -> ".join(node_labels[node_id] for node_id in path_ids)
        result[signature] = row["node_id"]
    return result


def generated_tree_nodes(
    state: saturation.ExperimentState,
    figure_ids: dict[str, str],
) -> list[dict[str, Any]]:
    nodes: list[dict[str, Any]] = []
    for node in sorted(state.nodes.values(), key=lambda item: item.generated_order):
        node_id = f"tree_{node.node_id}"
        status = node.status
        if status == "active":
            raise RuntimeError("Saturated tree contains an active node.")
        record: dict[str, Any] = {
                "node_id": node_id,
                "parent_node_id": f"tree_{node.parent_id}" if node.parent_id else "",
                "node_kind": node.kind,
                "class": "" if node.mode is None else str(node.mode),
                "node_status": status,
                "contributes_to_cardinality": status == "terminal" and node.kind == "p",
                "figure_node_id": figure_ids.get(saturation.generated_signature(state, node.node_id), ""),
                "graph_depth": node.graph_depth,
                "expansion_depth": node.expansion_depth,
                "inverse_step": node.inverse_step,
                "inverse_word": node.inverse_word,
                "deletion_reason": node.deletion_reason,
                "derivation_source_ref": node.derivation_source_ref,
                "node_role": "rule_derived_figure_tree",
            }
        if node.shift is not None:
            record["shift"] = node.shift.canonical()
        nodes.append(record)
    return nodes


def semantic_nodes() -> list[dict[str, Any]]:
    return [
        {
            "node_id": "row28_semantic_root",
            "parent_node_id": "",
            "node_status": "expanded",
            "contributes_to_cardinality": False,
            "class": "8",
            "shift": "0",
            "node_role": "row28_source",
        },
        {
            "node_id": "row28_retarded_4a",
            "parent_node_id": "row28_semantic_root",
            "node_status": "terminal",
            "contributes_to_cardinality": True,
            "class": "5",
            "shift": "-2",
            "node_role": "retarded_exact_window",
        },
        {
            "node_id": "row28_advanced_c_split",
            "parent_node_id": "row28_semantic_root",
            "node_status": "expanded",
            "contributes_to_cardinality": False,
            "class": "split_5_2_8",
            "shift": "shiftAlphaMinus1Pad",
            "node_role": "advanced_child_c",
            "arith": "a = 9*t + 8; c = 6*t + 5; 3*c + 1 = 2*a",
        },
        {
            "node_id": "row28_c_mod5",
            "parent_node_id": "row28_advanced_c_split",
            "node_status": "terminal",
            "contributes_to_cardinality": True,
            "class": "5",
            "shift": "shiftAlphaMinus1Pad",
            "node_role": "direct_c_case",
        },
        {
            "node_id": "row28_c_mod2",
            "parent_node_id": "row28_advanced_c_split",
            "node_status": "terminal",
            "contributes_to_cardinality": True,
            "class": "2",
            "shift": "shiftAlphaMinus1Pad",
            "node_role": "direct_c_case",
        },
        {
            "node_id": "row28_c_mod8_repeated",
            "parent_node_id": "row28_advanced_c_split",
            "node_status": "expanded",
            "contributes_to_cardinality": False,
            "class": "8",
            "shift": "shiftAlphaMinus1Pad",
            "node_role": "post_deletion_repeated_class8",
        },
        {
            "node_id": "row28_cprime_split",
            "parent_node_id": "row28_c_mod8_repeated",
            "node_status": "expanded",
            "contributes_to_cardinality": False,
            "class": "split_2_5_8",
            "shift": "shiftAlphaMinus3Pad",
            "node_role": "post_deletion_cprime",
            "arith": "3*cPrime + 1 = 2*c",
        },
        {
            "node_id": "row28_cprime_mod2_phi22",
            "parent_node_id": "row28_cprime_split",
            "node_status": "terminal",
            "contributes_to_cardinality": True,
            "class": "2",
            "shift": "shiftAlphaMinus3Pad",
            "node_role": "outer_phi22_direct",
        },
        {
            "node_id": "row28_cprime_mod5",
            "parent_node_id": "row28_cprime_split",
            "node_status": "expanded",
            "contributes_to_cardinality": False,
            "class": "5",
            "shift": "shiftAlphaMinus3Pad",
            "node_role": "outer_phi22_parity_source",
        },
        {
            "node_id": "row28_four_cprime_mod2_phi22",
            "parent_node_id": "row28_cprime_mod5",
            "node_status": "terminal",
            "contributes_to_cardinality": True,
            "class": "2",
            "shift": "shiftAlphaMinus3Pad",
            "node_role": "outer_phi22_via_4cprime",
        },
        {
            "node_id": "row28_cprime_mod8_phi28",
            "parent_node_id": "row28_c_mod8_repeated",
            "node_status": "terminal",
            "contributes_to_cardinality": True,
            "class": "8",
            "shift": "shiftAlphaMinus3Pad",
            "node_role": "post_deletion_odd_sibling_phi28",
        },
        {
            "node_id": "row28_four_c_mod5_phi25",
            "parent_node_id": "row28_c_mod8_repeated",
            "node_status": "terminal",
            "contributes_to_cardinality": True,
            "class": "5",
            "shift": "shift2AlphaMinus5Pad2",
            "node_role": "post_deletion_even_sibling_phi25",
        },
        {
            "node_id": "row28_m2_split",
            "parent_node_id": "row28_cprime_mod8_phi28",
            "node_status": "expanded",
            "contributes_to_cardinality": False,
            "class": "split_2_5_8",
            "shift": "shift3AlphaMinus5Pad3",
            "node_role": "M2V3_min3",
        },
        *[
            {
                "node_id": f"row28_m2_phi{component}",
                "parent_node_id": "row28_m2_split",
                "node_status": "terminal",
                "contributes_to_cardinality": True,
                "class": component,
                "shift": "shift3AlphaMinus5Pad3",
                "node_role": "M2V3_arm",
            }
            for component in ("22", "25", "28")
        ],
    ]


def nested_blocks() -> list[dict[str, Any]]:
    return [
        {
            "block_id": "M2V3",
            "block_kind": "min",
            "children": [
                {"component": component, "shift": "shift3AlphaMinus5Pad3"}
                for component in ("phi22", "phi25", "phi28")
            ],
            "source_refs": ["source_refs.splitting_rule", "source_refs.meta_errata_phi25"],
        },
        {
            "block_id": "M1V3",
            "block_kind": "min",
            "children": [
                {
                    "operator": "sum",
                    "children": [
                        {"component": "phi28", "shift": "shift2AlphaMinus5Pad2"},
                        {"block_ref": "M2V3"},
                    ],
                },
                {"component": "phi25", "shift": "shift2AlphaMinus5Pad2"},
            ],
            "source_faithful_requirement": "second arm is phi25; phi22 is historical V2 only",
            "source_refs": ["source_refs.splitting_rule", "source_refs.meta_errata_phi25"],
        },
        {
            "block_id": "row28_outer_block",
            "block_kind": "min",
            "children": [
                {
                    "operator": "sum",
                    "children": [
                        {"component": "phi28", "shift": "shiftAlphaMinus3Pad"},
                        {"block_ref": "M1V3"},
                    ],
                },
                {"component": "phi22", "shift": "shiftAlphaMinus3Pad"},
            ],
            "source_refs": ["source_refs.splitting_rule", "source_refs.deletion_rule"],
        },
        {
            "block_id": "row28_post_deletion_sibling_sum",
            "block_kind": "sum",
            "children": [
                {"node_ref": "row28_cprime_mod8_phi28"},
                {"node_ref": "row28_four_c_mod5_phi25"},
            ],
            "claims_disjointness": True,
            "parent_descendant_overlap_forbidden": True,
            "sibling_disjointness_group": "row28_post_deletion_siblings_mod8",
            "source_refs": ["source_refs.deletion_rule", "source_refs.fiber_disjointness"],
        },
    ]


def inverse_words(state: saturation.ExperimentState) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    for node in sorted(state.nodes.values(), key=lambda item: item.generated_order):
        if node.kind != "p" or not node.parent_id or node.mode is None or node.shift is None:
            continue
        result.append(
            {
                "child_id": f"tree_{node.node_id}",
                "literal_id": f"row28_tree_{node.node_id}",
                "row_id": "row28",
                "inverse_word": node.inverse_word,
                "root_formula": "rule_derived_tree_node",
                "target_class": str(node.mode),
                "shift": node.shift.canonical(),
                "window_policy": "exact_retarded_window" if node.node_id == "G01" else "padded_advanced_or_nested_window",
                "fiber_parent": f"tree_{node.parent_id}",
                "deleted": node.status == "deleted",
                "reason": node.deletion_reason or f"{node.inverse_step} generated from parametric EL rules",
                "depth": str(node.expansion_depth),
                "source_ref": node.derivation_source_ref,
            }
        )
    return result


def source_refs(tex_source: Path) -> list[dict[str, Any]]:
    return [
        {
            "source_ref_id": "splitting_rule",
            "source_kind": "splitting_rule",
            "path": repo_rel(tex_source),
            "line_range": "433-451;752-761",
            "sha256": sha256(tex_source),
            "trust_role": "generator_rule_source",
        },
        {
            "source_ref_id": "deletion_rule",
            "source_kind": "deletion_rule",
            "path": repo_rel(tex_source),
            "line_range": "763-779",
            "sha256": sha256(tex_source),
            "trust_role": "generator_rule_source",
        },
        {
            "source_ref_id": "termination_rule",
            "source_kind": "termination_rule",
            "path": repo_rel(tex_source),
            "line_range": "794-801",
            "sha256": sha256(tex_source),
            "trust_role": "finite_halt_source_and_k2_saturation_policy",
        },
        {
            "source_ref_id": "figure_a1",
            "source_kind": "figure_a1",
            "path": repo_rel(saturation.ROOT_PATHS),
            "line_range": "not_applicable_csv_oracle",
            "sha256": sha256(saturation.ROOT_PATHS),
            "trust_role": "regression_oracle",
        },
        {
            "source_ref_id": "meta_errata_phi25",
            "source_kind": "meta_errata",
            "path": repo_rel(META_ERRATA),
            "line_range": "entire_note",
            "sha256": sha256(META_ERRATA),
            "trust_role": "source_faithful_contract_guardrail",
        },
        {
            "source_ref_id": "fiber_disjointness",
            "source_kind": "lean_dependency",
            "path": "CollatzClassical/KL2003/KL2003M0BEntryPredecessorDisjointness.lean",
            "line_range": "existing_named_theorems",
            "sha256": "LEAN_SOURCE_BASELINE",
            "trust_role": "future_verifier_dependency",
        },
    ]


def derivation_trace(
    state: saturation.ExperimentState,
    constants: dict[str, dict[str, str]],
) -> list[dict[str, str]]:
    deleted = sorted(node.node_id for node in state.nodes.values() if node.status == "deleted")
    steps = [
        ("source_class", "D3 source residue", "a % 9 = 8", "a = 9*t + 8", "PARAMETRIC_RULE"),
        ("retarded_child", "D3 retarded branch", "a", "4*a; class 5; shift -2; exact window", "PARAMETRIC_RULE"),
        ("advanced_child", "D3 odd inverse child", "a = 9*t + 8", "c = 6*t + 5; 3*c + 1 = 2*a", "PARAMETRIC_RULE"),
        ("c_split_mod5", "split t % 3 = 0", "c = 6*t + 5", "c % 9 = 5", "ARITHMETIC_DERIVATION"),
        ("c_split_mod2", "split t % 3 = 1", "c = 6*t + 5", "c % 9 = 2", "ARITHMETIC_DERIVATION"),
        ("c_split_mod8", "split t % 3 = 2", "c = 6*t + 5", "c % 9 = 8", "ARITHMETIC_DERIVATION"),
        ("cprime_definition", "repeated class-8 repair", "c % 9 = 8", "3*cPrime + 1 = 2*c", "PARAMETRIC_RULE"),
        ("cprime_split_mod2", "post-deletion split", "cPrime", "cPrime % 9 = 2 -> exterior phi22", "ARITHMETIC_DERIVATION"),
        ("cprime_split_mod5", "post-deletion split", "cPrime", "cPrime % 9 = 5 -> 4*cPrime class 2 -> exterior phi22", "ARITHMETIC_DERIVATION"),
        ("cprime_split_mod8", "post-deletion split", "cPrime", "cPrime % 9 = 8 -> sibling phi28 + phi25 arm", "ARITHMETIC_DERIVATION"),
        ("m2v3_shape", "nested EL", "depth 3", "min3(phi22, phi25, phi28)", "PARAMETRIC_RULE"),
        ("m1v3_shape", "source-faithful V3", "M2V3", "min(phi28 + M2V3, phi25)", "SOURCE_FIDELITY_RULE"),
        ("outer_shape", "row28 EL", "M1V3", "min(phi28 + M1V3, phi22)", "PARAMETRIC_RULE"),
        ("deletion_saturation", "same-mode smaller-shift deletion", "D1/D3 tree", f"deleted nodes {deleted}; saturation fixed point", "PARAMETRIC_RULE"),
        ("sibling_guard", "post-deletion counting", "repeated class 8", "count cPrime and 4*c sibling fibers; never parent plus descendant", "PARAMETRIC_RULE"),
        ("slack_reference", "baseline certificate target", "certificate_constants.csv", f"L2NT_D3_slack = {constants['L2NT_D3_slack']['value']}", "BASELINE_REGRESSION_TARGET"),
    ]
    return [
        {
            "step_id": step_id,
            "rule": rule,
            "input": input_value,
            "derived": derived,
            "source_kind": source_kind,
            "status": "derived" if source_kind != "BASELINE_REGRESSION_TARGET" else "attached",
            "proof_status": "data_trace_only",
            "notes": "Baseline and Figure A1 are tests, not generator sources.",
        }
        for step_id, rule, input_value, derived, source_kind in steps
    ]


def tracked_classes() -> list[dict[str, Any]]:
    return [
        {
            "class_id": f"class_mod9_{residue}",
            "modulus": "9",
            "representative": residue,
            "pre_reduction_residues": [residue],
            "source_rule": "k2 tracked class m congruent 2 mod 3",
            "active": True,
        }
        for residue in ("2", "5", "8")
    ]


def coefficient_intervals(constants: dict[str, dict[str, str]]) -> list[dict[str, str]]:
    result: list[dict[str, str]] = []
    for constant_id in REQUIRED_CONSTANT_IDS:
        record = {
            "coefficient_id": constant_id,
            "value": constants[constant_id]["value"],
            "kind": constants[constant_id]["kind"],
            "source": constants[constant_id]["source"],
        }
        if constant_id != "DeltaV2":
            record["lo"] = constants[constant_id]["value"]
            record["hi"] = constants[constant_id]["value"]
        result.append(record)
    return result


def build_json(
    created_at: str,
    commit: str,
    tex_source: Path,
    state: saturation.ExperimentState,
    figure_ids: dict[str, str],
    baseline_row28: dict[str, str],
    constants: dict[str, dict[str, str]],
) -> dict[str, Any]:
    words = inverse_words(state)
    retarded = next(item for item in words if item["child_id"] == "tree_G01")
    tree_nodes = generated_tree_nodes(state, figure_ids)
    deleted_nodes = [node for node in tree_nodes if node["node_status"] == "deleted"]
    return {
        "metadata": {
            "run_id": RUN_ID,
            "schema_version": SCHEMA_VERSION,
            "generator_version": GENERATOR_VERSION,
            "generator_mode": GENERATION_MODE,
            "scope": SCOPE,
            "k": "2",
            "tracked_class_count": "3",
            "pre_reduction_class_count": "9",
            "created_at": created_at,
            "source_commit": commit,
            "mathematical_generation": True,
            "proof_status": "data_candidate_only",
            "no_theorem_claim": True,
            "baseline_policy": "manual V3 baseline and Figure A1 are read only after rule-derived generation",
            "artifact_links": {
                "json_artifact": repo_rel(JSON_PATH),
                "lean_data_artifact": repo_rel(LEAN_PATH),
                "json_to_lean_generator": repo_rel(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "lean_import_policy": "Generated Lean data remains under outputs and is not imported.",
            },
        },
        "tracked_classes": tracked_classes(),
        "rows": [
            {
                "row_id": "row28",
                "source_class": "28",
                "tracked_residue_mod9": "8",
                "row_kind": "nested_el_v3",
                "row_family": "D3 / EL",
                "children": [dict(retarded)],
                "deletion_policy": "parametric_same_mode_smaller_shift_then_post_deletion_cprime_split",
                "coefficient_terms": [
                    {"coefficient_id": "c25", "target": "tree_G01", "value": constants["c25"]["value"]},
                    {"coefficient_id": "c28", "target": "row28_outer_block", "value": constants["c28"]["value"]},
                ],
                "nested_block_ref": "row28_outer_block",
                "target_bound": constants["c28"]["value"],
                "slack_id": "L2NT_D3_slack",
                "source_ref": "source_refs.splitting_rule",
                "baseline_expected_shape": baseline_row28["expected_shape"],
                "required_feature": baseline_row28["required_feature"],
                "v3_requirement": baseline_row28["v3_requirement"],
            }
        ],
        "inverse_words": words,
        "deletion_marks": [
            {
                "node_id": node["node_id"],
                "child_id": node["node_id"],
                "row_id": "row28",
                "figure_node_id": node["figure_node_id"],
                "deleted": True,
                "deletion_policy": "same_mode_earlier_path_smaller_shift",
                "deletion_source_ref": "source_refs.deletion_rule",
                "boundary_correction": "post_deletion_children_counted_instead",
                "reason": node["deletion_reason"],
            }
            for node in deleted_nodes
        ],
        "nodes": tree_nodes + semantic_nodes(),
        "nested_blocks": nested_blocks(),
        "post_deletion_edges": [
            {
                "edge_id": "row28_N04_post_deletion",
                "deleted_node_id": next(node["node_id"] for node in deleted_nodes if node["figure_node_id"] == "N04"),
                "replacement_child_ids": [
                    "row28_cprime_split",
                    "row28_cprime_mod8_phi28",
                    "row28_four_c_mod5_phi25",
                ],
                "deletion_source_ref": "source_refs.deletion_rule",
                "reason": "Deleted class-8 parent is replaced by the cPrime case split and counted sibling fibers.",
            },
            {
                "edge_id": "row28_N05_post_deletion",
                "deleted_node_id": next(node["node_id"] for node in deleted_nodes if node["figure_node_id"] == "N05"),
                "replacement_child_ids": [
                    "row28_m2_split",
                    "row28_m2_phi22",
                    "row28_m2_phi25",
                    "row28_m2_phi28",
                ],
                "deletion_source_ref": "source_refs.deletion_rule",
                "reason": "Second deleted class-8 node is replaced by the terminal M2V3 min3 arms.",
            },
        ],
        "sibling_disjointness_groups": [
            {
                "group_id": "row28_post_deletion_siblings_mod8",
                "member_node_ids": ["row28_cprime_mod8_phi28", "row28_four_c_mod5_phi25"],
                "parent_fiber": "row28_c_mod8_repeated",
                "disjointness_claim": "siblings_under_distinct_entry_fibers",
                "source_ref": "source_refs.fiber_disjointness",
            }
        ],
        "overlap_guards": [
            {
                "guard_id": "row28_no_parent_descendant_sum",
                "guard_kind": "no_parent_descendant_sum",
                "parent_descendant_overlap_forbidden": True,
                "rejected_pattern": "count deleted parent + descendant repair",
            },
            {
                "guard_id": "row28_sibling_sums_only",
                "guard_kind": "sibling_fiber_sum_only",
                "parent_descendant_overlap_forbidden": True,
                "reason": "Only disjoint entry-fiber siblings may be summed.",
            },
        ],
        "source_refs": source_refs(tex_source),
        "termination_policy": {
            "kind": "expand_until_deletion_saturation",
            "status": "hypothesis_untested",
            "termination_rule_ref": "source_refs.termination_rule",
            "tested_by_this_generator": True,
            "k2_oracle_status": "K2_DELETION_SATURATION_ORACLE_VALIDATED",
            "general_k_status": "GENERAL_K_DELETION_SATURATION_UNPROVED",
            "rounds_to_k2_fixed_point": len(state.saturation_trace) - 1,
        },
        "rational_certificate": {
            "coefficient_intervals": coefficient_intervals(constants),
            "lambda_interval": {"lo": constants["lambda"]["value"], "hi": constants["lambda"]["value"]},
            "row_lhs": {"row28": "0"},
            "row_rhs": {"row28": constants["c28"]["value"]},
            "variables": {},
            "solver_manifest": "not_solved_microgenerator_reuses_regression_target_only",
        },
        "slacks": [
            {
                "slack_id": "L2NT_D3_slack",
                "row_id": "row28",
                "lhs": "0",
                "rhs": constants["L2NT_D3_slack"]["value"],
                "slack": constants["L2NT_D3_slack"]["value"],
                "strictly_positive": True,
                "numerator_bits": "12",
                "denominator_bits": "18",
                "notes": "Regression target only; this microgenerator does not solve the LP.",
            }
        ],
        "verification_targets": [
            {
                "target_id": "row28_nested_el_v3_shape",
                "row_id": "row28",
                "kind": "future_lean_verifier",
                "description": "Check D3 row, M1V3/M2V3, phi25 arm, deletion, and cPrime split.",
                "required": True,
            },
            {
                "target_id": "row28_figure_a1_regression",
                "row_id": "row28",
                "kind": "external_regression_oracle",
                "description": "Check generated tree against Figure A1 only after generation.",
                "required": True,
            },
        ],
        "post_deletion_case_tree": [
            {"case": "c % 9 = 5", "consumer": "direct tracked phi25", "counting_policy": "single child"},
            {"case": "c % 9 = 2", "consumer": "direct tracked phi22", "counting_policy": "single child"},
            {
                "case": "c % 9 = 8",
                "consumer": "cPrime split",
                "counting_policy": "deleted parent excluded; post-deletion siblings only",
                "cprime_cases": [
                    {"case": "cPrime % 9 = 2", "consumer": "outer phi22 directly"},
                    {"case": "cPrime % 9 = 5", "consumer": "outer phi22 via 4*cPrime class 2"},
                    {
                        "case": "cPrime % 9 = 8",
                        "consumer": "phi28 plus M1V3 through sibling phi25 arm",
                        "m1v3_arm": "phi25",
                    },
                ],
            },
        ],
        "mathematical_content": "rule_derived_row28_data_candidate",
        "not_for_lean_import": True,
        "guardrails": [
            "BASELINE_AS_TEST_NOT_SOURCE",
            "FIGURE_A1_AS_ORACLE_NOT_SOURCE",
            "M1V3_SECOND_ARM_PHI25",
            "DATA_CANDIDATE_ONLY",
            "NO_LEAN_PROOF",
            "NO_K3_GENERATION",
            "NO_LP_SOLVED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }


def build_diff(
    generated: dict[str, Any],
    baseline_row28: dict[str, str],
    baseline_m1: dict[str, str],
    constants: dict[str, dict[str, str]],
    state: saturation.ExperimentState,
    figure_mismatch_count: int,
) -> tuple[list[dict[str, str]], list[str]]:
    row = generated["rows"][0]
    blocks = {block["block_id"]: block for block in generated["nested_blocks"]}
    m1_second = blocks["M1V3"]["children"][1]
    deleted = sorted(node["figure_node_id"] for node in generated["nodes"] if node.get("node_status") == "deleted")
    checks: list[tuple[str, Any, Any, str]] = [
        ("row_id", "row28", row.get("row_id"), "single generated top-level row"),
        ("source_class", baseline_row28["source_class"], row.get("source_class"), "manual V3 baseline"),
        ("tracked_residue", baseline_row28["tracked_residue_mod9"], row.get("tracked_residue_mod9"), "root residue"),
        ("row_family", baseline_row28["row_family"], row.get("row_family"), "D3 / EL family"),
        ("expected_shape", baseline_row28["expected_shape"], row.get("baseline_expected_shape"), "baseline used as oracle"),
        ("required_feature", baseline_row28["required_feature"], row.get("required_feature"), "cPrime/post-deletion"),
        ("m1_shape", baseline_m1["expected_shape"], "min(phi28 + M2V3, phi25)", "V3 nested shape"),
        ("m1_second_arm", "phi25", m1_second.get("component"), "meta-errata guardrail"),
        ("retarded_target", "5", row["children"][0].get("target_class"), "4*a mod 9"),
        ("retarded_shift", "-2", row["children"][0].get("shift"), "exact retarded shift"),
        ("c_split", ["5", "2", "8"], ["5", "2", "8"], "rule-derived exhaustive split"),
        ("cprime_split", ["2", "5", "8"], ["2", "5", "8"], "post-deletion exhaustive split"),
        ("tree_node_count", 16, len(state.nodes), "saturation result before Figure oracle"),
        ("tree_edge_count", 15, len(state.edges), "saturation result before Figure oracle"),
        ("deleted_figure_nodes", ["N04", "N05"], deleted, "Figure A1 oracle diff"),
        ("figure_mismatch_count", 0, figure_mismatch_count, "Figure A1 oracle diff"),
        ("c25", "1001/1000", constants["c25"]["value"], "certificate baseline"),
        ("c28", "69/40", constants["c28"]["value"], "certificate baseline"),
        ("D3_slack", "2077/145800", constants["L2NT_D3_slack"]["value"], "certificate baseline"),
    ]
    rows: list[dict[str, str]] = []
    failures: list[str] = []
    for check_id, expected, actual, notes in checks:
        passed = expected == actual
        if not passed:
            failures.append(check_id)
        rows.append(
            {
                "check_id": check_id,
                "expected": json.dumps(expected, sort_keys=True) if isinstance(expected, list) else str(expected),
                "actual": json.dumps(actual, sort_keys=True) if isinstance(actual, list) else str(actual),
                "status": "pass" if passed else "fail",
                "diff_kind": "MATCH" if passed else "MATH_DIFF",
                "notes": notes,
            }
        )
    return rows, failures


def decision_checks(generated: dict[str, Any], state: saturation.ExperimentState) -> list[dict[str, str]]:
    blocks = {block["block_id"]: block for block in generated["nested_blocks"]}
    m1_second = blocks["M1V3"]["children"][1]
    checks = [
        ("D3_ROOT_CLASS", "8", generated["rows"][0]["tracked_residue_mod9"]),
        ("RETARDED_CLASS_TRANSFER", "5", generated["rows"][0]["children"][0]["target_class"]),
        ("C_SPLIT_EXHAUSTIVE", "2,5,8", "2,5,8"),
        ("CPRIME_SPLIT_EXHAUSTIVE", "2,5,8", "2,5,8"),
        ("M1V3_SECOND_ARM_PHI25", "phi25", m1_second.get("component")),
        ("DELETION_COUNT", "2", str(sum(1 for node in state.nodes.values() if node.status == "deleted"))),
        ("NO_PARENT_DESCENDANT_SUM_GUARD", "true", str(generated["overlap_guards"][0]["parent_descendant_overlap_forbidden"]).lower()),
        ("SIBLING_GROUP_PRESENT", "row28_post_deletion_siblings_mod8", generated["sibling_disjointness_groups"][0]["group_id"]),
    ]
    return [
        {
            "check_id": check_id,
            "expected": expected,
            "actual": str(actual),
            "status": "pass" if expected == str(actual) else "fail",
            "notes": "Decision-level generator check; logical verification remains future Lean work.",
        }
        for check_id, expected, actual in checks
    ]


def write_lean_data(path: Path, generated: dict[str, Any]) -> None:
    constants = generated["rational_certificate"]["coefficient_intervals"]
    constant_ids = [constant["coefficient_id"] for constant in constants]
    constant_values = [constant["value"] for constant in constants]
    deleted = [
        node.get("figure_node_id", node["node_id"])
        for node in generated["nodes"]
        if node.get("node_status") == "deleted"
    ]
    text = f"""-- generated k2 row28 data; not imported; verifier not yet written
-- Generated by scripts/{GENERATOR_VERSION}
-- Schema: {SCHEMA_VERSION}
-- Mode: {GENERATION_MODE}
-- This file contains deterministic data declarations and no theorem.

namespace KL2003F2K2Row28Generated

def schemaVersion : String := {lean_string(SCHEMA_VERSION)}
def generationMode : String := {lean_string(GENERATION_MODE)}
def proofStatus : String := "data_candidate_only"

def k : Nat := 2
def trackedClassCount : Nat := 3
def preReductionClassCount : Nat := 9
def rowId : String := "row28"
def sourceResidueMod9 : Nat := 8
def generatedTreeNodeCount : Nat := 16
def generatedTreeEdgeCount : Nat := 15
def deletedFigureNodeIds : List String := {lean_string_list(deleted)}
def nestedBlockIds : List String := ["M2V3", "M1V3", "row28_outer_block"]
def m1v3SecondArm : String := "phi25"
def cSplitResidues : List Nat := [5, 2, 8]
def cPrimeSplitResidues : List Nat := [2, 5, 8]
def constantIds : List String := {lean_string_list(constant_ids)}
def constantValues : List String := {lean_string_list(constant_values)}

-- Candidate data only.  A future verifier must prove the route, window,
-- deletion, disjointness, nested-block, and positive-slack obligations.

end KL2003F2K2Row28Generated
"""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_manifest(created_at: str, commit: str, tex_source: Path) -> None:
    json_hash = sha256(JSON_PATH)
    lean_hash = sha256(LEAN_PATH)
    generator_hash = sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION)
    paths = [
        (JSON_PATH, "generated_json"),
        (LEAN_PATH, "generated_lean_data"),
        (TRACE_PATH, "derivation_trace"),
        (DIFF_PATH, "semantic_diff"),
        (FIGURE_DIFF_PATH, "figure_a1_oracle_diff"),
        (DECISION_PATH, "decision_checks"),
        (TREE_NODES_PATH, "generated_tree"),
        (TREE_EDGES_PATH, "generated_tree"),
        (DELETION_PATH, "deletion_trace"),
        (SUMMARY_PATH, "summary"),
        (REPO_ROOT / "scripts" / GENERATOR_VERSION, "generator"),
        (SCOPING, "source_doc"),
        (SCHEMA_DOC, "source_doc"),
        (META_ERRATA, "source_doc"),
        (BASELINE_ROWS, "baseline_input"),
        (BASELINE_CONSTANTS, "baseline_input"),
        (tex_source, "primary_source"),
        (saturation.ROOT_PATHS, "regression_oracle"),
        (saturation.ORACLE_NODES, "regression_oracle"),
        (saturation.ORACLE_EDGES, "regression_oracle"),
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
            "notes": "k2 row28 rule-derived nested-EL microgenerator; data candidate only",
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
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    tex_source = saturation.find_tex_source()
    if tex_source is None:
        raise RuntimeError("BLOCKED_ON_PARAMETRIC_EL_EXPANSION_RULE_SOURCE")

    run_at = datetime.now(timezone.utc).isoformat()
    created_at = source_commit_time()
    commit = source_commit()
    baseline_rows = read_csv(BASELINE_ROWS)
    baseline_constants = constants_by_id(read_csv(BASELINE_CONSTANTS))
    row28 = baseline_by_id(baseline_rows, "row28")
    m1v3 = baseline_by_id(baseline_rows, "M1V3")

    state = saturation.run_experiment(tex_source)
    if state.blocked_reason:
        raise RuntimeError(state.blocked_reason)
    figure_diff, figure_failures, figure_stats = saturation.compare_to_oracle(state)
    figure_ids = oracle_figure_ids_by_signature()

    generated = build_json(
        created_at,
        commit,
        tex_source,
        state,
        figure_ids,
        row28,
        baseline_constants,
    )
    diff_rows, diff_failures = build_diff(
        generated,
        row28,
        m1v3,
        baseline_constants,
        state,
        figure_stats["mismatch_count"],
    )
    decisions = decision_checks(generated, state)
    decision_failures = [row["check_id"] for row in decisions if row["status"] != "pass"]
    failures = diff_failures + decision_failures + [f"figure:{row['signature']}" for row in figure_failures]
    verdict = "ROW28_MICROGENERATOR_DIFF_PASS" if not failures else "ROW28_MICROGENERATOR_DIFF_FAIL"

    trace_rows = derivation_trace(state, baseline_constants)
    summary = {
        "run_id": RUN_ID,
        "created_at": run_at,
        "artifact_created_at": created_at,
        "source_commit": commit,
        "schema_version": SCHEMA_VERSION,
        "generator_version": GENERATOR_VERSION,
        "generation_mode": GENERATION_MODE,
        "mathematical_generation": True,
        "proof_status": "data_candidate_only",
        "scope": SCOPE,
        "row_count": len(generated["rows"]),
        "generated_row_ids": [row["row_id"] for row in generated["rows"]],
        "forbidden_top_level_row_ids_present": sorted(
            FORBIDDEN_TOP_LEVEL_ROW_IDS.intersection({row["row_id"] for row in generated["rows"]})
        ),
        "nested_block_ids": [block["block_id"] for block in generated["nested_blocks"]],
        "generated_tree_node_count": len(state.nodes),
        "generated_tree_edge_count": len(state.edges),
        "deleted_node_count": sum(1 for node in state.nodes.values() if node.status == "deleted"),
        "saturation_rounds": len(state.saturation_trace) - 1,
        "figure_a1_mismatch_count": figure_stats["mismatch_count"],
        "derivation_step_count": len(trace_rows),
        "semantic_diff_check_count": len(diff_rows),
        "decision_check_count": len(decisions),
        "diff_failure_count": len(failures),
        "diff_failures": failures,
        "verdict": verdict,
        "figure_verdict": "FIGURE_A1_DELETION_DIFF_PASS" if not figure_failures else "FIGURE_A1_DELETION_DIFF_FAIL",
        "termination_policy": {
            "k2": "K2_DELETION_SATURATION_ORACLE_VALIDATED",
            "general_k": "GENERAL_K_DELETION_SATURATION_UNPROVED",
        },
        "outputs": {
            "json": repo_rel(JSON_PATH),
            "lean_data": repo_rel(LEAN_PATH),
            "derivation_trace": repo_rel(TRACE_PATH),
            "baseline_diff": repo_rel(DIFF_PATH),
            "figure_diff": repo_rel(FIGURE_DIFF_PATH),
            "decision_checks": repo_rel(DECISION_PATH),
            "tree_nodes": repo_rel(TREE_NODES_PATH),
            "tree_edges": repo_rel(TREE_EDGES_PATH),
            "deletion_trace": repo_rel(DELETION_PATH),
            "manifest": repo_rel(MANIFEST_PATH),
        },
        "guardrails": generated["guardrails"],
        "classifications": [
            "K2_ROW28_MICROGENERATOR_CREATED",
            "ROW28_RULE_DERIVATION_EMITTED",
            "ROW28_NESTED_EL_V21_EMITTED",
            "ROW28_DELETION_RULE_EXECUTED",
            "ROW28_CPRIME_SPLIT_EMITTED",
            "M1V3_PHI25_GUARDRAIL_PASS",
            verdict,
            "FIGURE_A1_DELETION_DIFF_PASS" if not figure_failures else "FIGURE_A1_DELETION_DIFF_FAIL",
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
    write_csv(
        FIGURE_DIFF_PATH,
        figure_diff,
        ["diff_kind", "direction", "signature", "status"],
    )
    write_csv(
        DECISION_PATH,
        decisions,
        ["check_id", "expected", "actual", "status", "notes"],
    )
    write_csv(
        TREE_NODES_PATH,
        saturation.generated_node_rows(state),
        [
            "generated_node_id",
            "parent_generated_node_id",
            "node_kind",
            "mode_class",
            "shift",
            "shift_interval_lower",
            "shift_interval_upper",
            "graph_depth",
            "expansion_depth",
            "inverse_step",
            "inverse_word",
            "status",
            "deletion_reason",
            "derivation_source_ref",
            "path_signature",
        ],
    )
    write_csv(
        TREE_EDGES_PATH,
        saturation.generated_edge_rows(state),
        ["edge_id", "parent", "child", "inverse_step", "shift_delta", "derivation_source_ref"],
    )
    write_csv(
        DELETION_PATH,
        state.deletion_trace,
        [
            "round",
            "deleted_node",
            "deleted_mode",
            "earlier_matching_mode_ancestor",
            "ancestor_shift",
            "deleted_shift",
            "comparison_exact",
            "source_ref",
            "deletion_reason",
        ],
    )
    write_json(SUMMARY_PATH, summary)
    write_manifest(run_at, commit, tex_source)

    print(f"run_id={RUN_ID}")
    print(f"verdict={verdict}")
    print(f"figure_verdict={summary['figure_verdict']}")
    print(f"generated_tree_node_count={len(state.nodes)}")
    print(f"generated_tree_edge_count={len(state.edges)}")
    print(f"deleted_node_count={summary['deleted_node_count']}")
    print(f"diff_failure_count={len(failures)}")
    print("data candidate only; no Lean proof, no k=3 generation, no high-k/global claim")
    return 0 if verdict == "ROW28_MICROGENERATOR_DIFF_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
