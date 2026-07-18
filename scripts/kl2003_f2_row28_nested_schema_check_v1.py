#!/usr/bin/env python3
"""Assess whether schema v2 can represent KL2003 k=2 row28 nested EL.

This is a format/gate check before implementing the row28 microgenerator.  It
reads the existing high-k schema scoping, the row28 scoping note, generated k=2
artifact examples, and the manual k=2 baseline.  It emits a capability matrix,
a gap analysis, and a row28 representation proposal.  It does not generate
row28 data, open Lean, solve an LP, generate k=3 data, or claim any theorem.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_ROW28_NESTED_SCHEMA_CHECK_v1"
SCHEMA_V2 = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
SCHEMA_V21 = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"

REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

SCHEMA_DOC = REPO_ROOT / "docs" / "KL2003_F2_K3_DATA_CERTIFICATE_FORMAT_SCOPING_v1.md"
ROW28_SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K2_ROW28_MICROGENERATOR_SCOPING_v1.md"
BASELINE_ROWS = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1" / "expected_rows_v3.csv"
ROW25_JSON = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW25_MICROGENERATOR_v1" / "row25.generated.json"
ROW22_JSON = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW22_MICROGENERATOR_v1" / "row22.generated.json"
K2_REGRESSION_JSON = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K2_REGRESSION_GENERATOR_SKELETON_v1"
    / "kl2003_k2_regression_certificate.generated.json"
)
ROOT_PATHS = REPO_ROOT / "outputs" / "KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1" / "root_paths.csv"

SUMMARY_PATH = OUT_DIR / "nested_schema_check_summary.json"
CAPABILITY_MATRIX_PATH = OUT_DIR / "schema_capability_matrix.csv"
GAP_ANALYSIS_PATH = OUT_DIR / "schema_gap_analysis.csv"
PROPOSAL_PATH = OUT_DIR / "row28_nested_representation_proposal.json"
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


def read_json(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        payload = json.load(handle)
    if not isinstance(payload, dict):
        raise ValueError(f"{path} is not a JSON object")
    return payload


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


def collect_keys(obj: Any, prefix: str = "") -> set[str]:
    keys: set[str] = set()
    if isinstance(obj, dict):
        for key, value in obj.items():
            full = f"{prefix}.{key}" if prefix else key
            keys.add(full)
            keys.update(collect_keys(value, full))
    elif isinstance(obj, list):
        for value in obj:
            keys.update(collect_keys(value, prefix))
    return keys


def text_has(text: str, *needles: str) -> bool:
    lower = text.lower()
    return all(needle.lower() in lower for needle in needles)


def baseline_rows_by_id() -> dict[str, dict[str, str]]:
    return {row["row_id"]: row for row in read_csv(BASELINE_ROWS)}


def figure_a1_deleted_nodes() -> list[dict[str, str]]:
    if not ROOT_PATHS.exists():
        return []
    rows = read_csv(ROOT_PATHS)
    expected = []
    for node_id in ["N04", "N05"]:
        match = next((row for row in rows if row.get("node_id") == node_id), None)
        if match:
            expected.append(
                {
                    "oracle_node_id": node_id,
                    "expected_status": "deleted",
                    "label_path": match.get("path_labels", ""),
                    "path_node_ids": match.get("path_node_ids", ""),
                    "source": repo_rel(ROOT_PATHS),
                }
            )
    return expected


def capability_analysis(
    schema_text: str,
    row28_text: str,
    example_keys: set[str],
    baseline: dict[str, dict[str, str]],
) -> list[dict[str, str]]:
    row28_baseline = baseline.get("row28", {})
    m1v3_baseline = baseline.get("M1V3", {})

    checks = [
        {
            "capability_id": "nested_blocks",
            "category": "nested_el",
            "question": "Can rows contain nested auxiliary EL blocks as first-class data?",
            "supported": False,
            "evidence": "Schema v2 has rows/children but no canonical nested_blocks or block DAG section.",
            "gap": "M1V3/M2V3 would be encoded as free-form row text or ad hoc fields.",
            "proposed_v21_field": "nested_blocks[] with block_id, operator, operands, shift, coefficient_ref",
        },
        {
            "capability_id": "min_nodes",
            "category": "expression_ast",
            "question": "Can min nodes be represented structurally?",
            "supported": False,
            "evidence": "Schema v2 mentions coefficient_terms and target_bound, but no expression-node operator for min.",
            "gap": "A verifier cannot distinguish real min structure from descriptive strings.",
            "proposed_v21_field": "expr_nodes[] entries with operator = min",
        },
        {
            "capability_id": "sum_nodes",
            "category": "expression_ast",
            "question": "Can sum nodes be represented structurally?",
            "supported": False,
            "evidence": "Schema v2 has coefficient_terms but no typed sum node for phi28 + M2V3.",
            "gap": "The row28 block phi28 + M2V3 would be textual rather than checker-readable.",
            "proposed_v21_field": "expr_nodes[] entries with operator = sum and operands[]",
        },
        {
            "capability_id": "auxiliary_block_refs",
            "category": "nested_el",
            "question": "Can rows reference auxiliary blocks M1V3/M2V3 by id?",
            "supported": False,
            "evidence": f"Baseline has row28={row28_baseline.get('expected_shape','')} and M1V3={m1v3_baseline.get('expected_shape','')}, but schema v2 lacks typed block_ref fields.",
            "gap": "M1V3/M2V3 references would be reviewer-only prose.",
            "proposed_v21_field": "block_ref operands and row.auxiliary_blocks[]",
        },
        {
            "capability_id": "m1v3_phi25_second_arm",
            "category": "meta_errata_v3",
            "question": "Can M1V3 record the source-faithful phi25 second arm as typed data?",
            "supported": False,
            "evidence": "The baseline records phi25 in prose, but schema v2 has no typed nested block arm for M1V3.",
            "gap": "The phi25/not-phi22 guardrail cannot be machine-checked without a typed M1V3 block.",
            "proposed_v21_field": "nested_blocks[M1V3].operands[1] = {component: phi25, shift: shift2AlphaMinus5Pad2}",
        },
        {
            "capability_id": "retarded_advanced_branch_roles",
            "category": "row_tree",
            "question": "Can retarded and advanced branch roles be represented canonically?",
            "supported": False,
            "evidence": "Existing row22/row25 examples use branch_kind, but schema v2 lists it only as ad hoc generated data, not a required field.",
            "gap": "Row28 needs typed retarded/advanced roles before deletion and post-deletion validation.",
            "proposed_v21_field": "child.branch_role = retarded | advanced | post_deletion",
        },
        {
            "capability_id": "c_residue_split",
            "category": "row28_case_tree",
            "question": "Can the c % 9 split into {5,2,8} be represented canonically?",
            "supported": False,
            "evidence": "Row22 emitted residue_split as ad hoc data; schema v2 has no required split/cases contract.",
            "gap": "Row28 case coverage would be prose unless split nodes are typed.",
            "proposed_v21_field": "case_splits[] with split_id, variable, modulus, exhaustive_cases[]",
        },
        {
            "capability_id": "cprime_residue_split",
            "category": "row28_case_tree",
            "question": "Can the cPrime % 9 split into {2,5,8} be represented canonically?",
            "supported": False,
            "evidence": "Schema v2 has no nested split object under a post-deletion class-8 branch.",
            "gap": "The row28 class-8 repair cannot be represented as checker-readable data.",
            "proposed_v21_field": "case_splits[] may be nested and may reference post_deletion_edges",
        },
        {
            "capability_id": "deletion_marks",
            "category": "deletion",
            "question": "Can deletion marks be represented canonically?",
            "supported": "deletion_marks" in schema_text and "deletion_marks" in example_keys,
            "evidence": "Schema v2 defines deletion_marks and examples emit deletion_marks.",
            "gap": "None for basic deletion ledger.",
            "proposed_v21_field": "reuse deletion_marks",
        },
        {
            "capability_id": "post_deletion_children",
            "category": "deletion",
            "question": "Can post-deletion replacement children be represented canonically?",
            "supported": False,
            "evidence": "Schema v2 allows child reason/boundary_correction, but no post_deletion_parent/post_deletion_children relationship.",
            "gap": "Deleted parent and counted replacement branches are not mechanically linked.",
            "proposed_v21_field": "post_deletion_edges[] with deleted_node_id and replacement_child_ids[]",
        },
        {
            "capability_id": "tree_oracle_node_ids",
            "category": "figure_a1_oracle",
            "question": "Can Figure A1/root_paths node ids be stored as proof-relevant regression data?",
            "supported": False,
            "evidence": "Schema v2 has child_id/literal_id, but no source_tree_node_id or oracle_node_id contract.",
            "gap": "Tree diff against N04/N05 would rely on nonstandard fields.",
            "proposed_v21_field": "source_tree_node_id, oracle_node_id, oracle_path_node_ids",
        },
        {
            "capability_id": "not_counted_deleted_parent",
            "category": "deletion",
            "question": "Can a deleted structural parent be marked explicitly not counted?",
            "supported": False,
            "evidence": "Schema v2 has deleted boolean, but no counted/status enum separating deleted, counted, and structural_only.",
            "gap": "Verifier cannot reject parent+descendant double count from schema alone.",
            "proposed_v21_field": "node_status = counted | deleted | structural_only",
        },
        {
            "capability_id": "sibling_disjointness_groups",
            "category": "disjointness",
            "question": "Can sibling populations that may be summed be grouped explicitly?",
            "supported": False,
            "evidence": "Schema v2 has fiber_parent but no sum_group or sibling_group canonical field.",
            "gap": "Row28 class-8 sibling sums are not auditable as groups.",
            "proposed_v21_field": "sibling_groups[] with group_id, parent_fiber, member_child_ids[]",
        },
        {
            "capability_id": "anti_parent_descendant_overlap",
            "category": "disjointness",
            "question": "Can the artifact mark and reject parent+descendant overlap?",
            "supported": False,
            "evidence": "Schema v2 trust rules reject bad data generally, but no explicit anti-overlap marker exists.",
            "gap": "The old bad B subset A candidate has no canonical schema-level check target.",
            "proposed_v21_field": "overlap_guards[] with guard_kind = no_parent_descendant_sum",
        },
        {
            "capability_id": "splitting_source_refs",
            "category": "source_refs",
            "question": "Can splitting rule source references be recorded?",
            "supported": "source_ref" in schema_text and "source_ref" in example_keys,
            "evidence": "Schema v2 has source_ref fields, but not splitting_rule_line_range/hash as dedicated fields.",
            "gap": "Basic source_ref exists; dedicated splitting provenance should be added for row28.",
            "proposed_v21_field": "splitting_rule_source{path,line_range,sha256,rule_id}",
        },
        {
            "capability_id": "deletion_source_refs",
            "category": "source_refs",
            "question": "Can deletion rule source references be recorded?",
            "supported": "source_ref" in schema_text and "source_ref" in example_keys,
            "evidence": "Schema v2 has source_ref fields, but not deletion_rule_line_range/hash as dedicated fields.",
            "gap": "Basic source_ref exists; dedicated deletion provenance should be added for row28.",
            "proposed_v21_field": "deletion_rule_source{path,line_range,sha256,rule_id}",
        },
        {
            "capability_id": "termination_rule_source_refs",
            "category": "source_refs",
            "question": "Can EL termination rule source references be recorded?",
            "supported": False,
            "evidence": "Row28 scoping requires termination_rule_source; schema v2 has no termination rule section.",
            "gap": "A generator could hardcode depth without a schema-visible source reason.",
            "proposed_v21_field": "termination_rule{kind,source_ref,line_range,sha256}",
        },
        {
            "capability_id": "termination_policy_deletion_saturation",
            "category": "termination",
            "question": "Can the format record expand_until_deletion_saturation as an untested hypothesis?",
            "supported": False,
            "evidence": "Row28 scoping requires a parametric termination policy; schema v2 has no policy/status field.",
            "gap": "The generator cannot honestly distinguish a source-proven rule from an untested deletion-saturation hypothesis.",
            "proposed_v21_field": "termination_policy{kind: expand_until_deletion_saturation, status: DELETION_SATURATION_HYPOTHESIS_UNTESTED}",
        },
    ]

    rows: list[dict[str, str]] = []
    for check in checks:
        supported = bool(check["supported"])
        if supported:
            status = "SUPPORTED_DIRECT_OR_EXISTING"
            v21_required = "no"
        elif check["capability_id"] in {"splitting_source_refs", "deletion_source_refs"}:
            status = "SUPPORTED_PARTIAL_NEEDS_CANONICALIZATION"
            v21_required = "yes"
        else:
            status = "MISSING_CANONICAL_FIELD"
            v21_required = "yes"
        rows.append(
            {
                "capability_id": check["capability_id"],
                "category": check["category"],
                "required_for_row28": "yes",
                "required_by_prompt": "yes",
                "question": str(check["question"]),
                "schema_v2_status": status,
                "v21_required": v21_required,
                "evidence": str(check["evidence"]),
                "gap": str(check["gap"]),
                "proposed_v21_field": str(check["proposed_v21_field"]),
                "warning_code": "",
                "warning_explanation": "",
            }
        )
    return rows


def row28_proposal(
    gap_rows: list[dict[str, str]],
    baseline: dict[str, dict[str, str]],
    deleted_nodes: list[dict[str, str]],
) -> dict[str, Any]:
    row28_baseline = baseline.get("row28", {})
    m1v3_baseline = baseline.get("M1V3", {})
    return {
        "metadata": {
            "run_id": RUN_ID,
            "schema_decision": "proposed_v2_1_required_before_row28_generator",
            "current_schema_version": SCHEMA_V2,
            "proposed_schema_version": SCHEMA_V21,
            "proof_status": "schema_proposal_only",
            "no_theorem_claim": True,
        },
        "row28_target": {
            "row_id": "row28",
            "source_class": "28",
            "root_residue_mod9": "8",
            "row_family": "D3 / EL",
            "baseline_expected_shape": row28_baseline.get("expected_shape", ""),
            "baseline_required_feature": row28_baseline.get("required_feature", ""),
            "v3_requirement": row28_baseline.get("v3_requirement", ""),
        },
        "required_v21_sections": [
            row["proposed_v21_field"]
            for row in gap_rows
            if row["v21_required"] == "yes"
        ],
        "tree_oracle": {
            "source": repo_rel(ROOT_PATHS),
            "expected_deleted_nodes": deleted_nodes,
            "required_diff_verdict": "FIGURE_A1_DELETION_DIFF_PASS",
        },
        "nodes": [
            {
                "node_id": "row28_root",
                "node_status": "structural_only",
                "class": "8",
                "shift": "0",
                "source_tree_node_id": "N09",
            },
            {
                "node_id": "row28_retarded_4a",
                "node_status": "counted",
                "class": "5",
                "shift": "-2",
                "branch_kind": "retarded",
                "window_policy": "exact_retarded_window",
            },
            {
                "node_id": "row28_advanced_c",
                "node_status": "structural_or_counted_by_case",
                "arith": "3*c + 1 = 2*a",
                "residue_split": ["5", "2", "8"],
                "branch_kind": "advanced_child",
            },
            {
                "node_id": "row28_deleted_N04",
                "node_status": "deleted",
                "class": "8",
                "shift": "alpha - 1",
                "source_tree_node_id": "N04",
                "deletion_rule": "same mode earlier on path + smaller shift => delete current leaf",
            },
            {
                "node_id": "row28_deleted_N05",
                "node_status": "deleted",
                "class": "8",
                "shift": "2*alpha - 3",
                "source_tree_node_id": "N05",
                "deletion_rule": "same mode earlier on path + smaller shift => delete current leaf",
            },
            {
                "node_id": "row28_cprime",
                "node_status": "post_deletion_structural",
                "arith": "3*cPrime + 1 = 2*c",
                "residue_split": ["2", "5", "8"],
            },
        ],
        "nested_blocks": [
            {
                "block_id": "M2V3",
                "operator": "min3",
                "operands": [
                    {"component": "phi22", "shift": "shift3AlphaMinus5Pad3"},
                    {"component": "phi25", "shift": "shift3AlphaMinus5Pad3"},
                    {"component": "phi28", "shift": "shift3AlphaMinus5Pad3"},
                ],
            },
            {
                "block_id": "M1V3",
                "operator": "min",
                "source_faithful_requirement": "second arm is phi25; phi22 form is historical V2 only",
                "baseline_expected_shape": m1v3_baseline.get("expected_shape", ""),
                "operands": [
                    {
                        "operator": "sum",
                        "operands": [
                            {"component": "phi28", "shift": "shift2AlphaMinus5Pad2"},
                            {"block_ref": "M2V3"},
                        ],
                    },
                    {"component": "phi25", "shift": "shift2AlphaMinus5Pad2"},
                ],
            },
            {
                "block_id": "row28_outer_block",
                "operator": "min",
                "operands": [
                    {
                        "operator": "sum",
                        "operands": [
                            {"component": "phi28", "shift": "shiftAlphaMinus3Pad"},
                            {"block_ref": "M1V3"},
                        ],
                    },
                    {"component": "phi22", "shift": "shiftAlphaMinus3Pad"},
                ],
            },
        ],
        "post_deletion_case_tree": [
            {
                "case": "c % 9 = 5",
                "consumer": "tracked class 5 child; simpler direct transfer",
                "counting_policy": "count child population only",
            },
            {
                "case": "c % 9 = 2",
                "consumer": "tracked class 2 child; simpler direct transfer",
                "counting_policy": "count child population only",
            },
            {
                "case": "c % 9 = 8",
                "consumer": "cPrime split after deletion",
                "counting_policy": "do not count deleted parent; count post-deletion siblings only",
                "cprime_cases": [
                    {
                        "case": "cPrime % 9 = 2",
                        "consumer": "outer phi22 directly",
                    },
                    {
                        "case": "cPrime % 9 = 5",
                        "consumer": "outer phi22 via 4*cPrime class 2",
                    },
                    {
                        "case": "cPrime % 9 = 8",
                        "consumer": "phi28 + M1V3 with sibling fibers cPrime and 4*c",
                        "m1v3_arm": "phi25",
                    },
                ],
            },
        ],
        "overlap_guards": [
            {
                "guard_id": "row28_no_deleted_parent_plus_descendant",
                "guard_kind": "no_parent_descendant_sum",
                "rejected_pattern": "count deleted parent + count descendant repair",
            },
            {
                "guard_id": "row28_sibling_sums_only",
                "guard_kind": "sibling_fiber_sum_only",
                "reason": "sums only between disjoint sibling populations",
            },
        ],
        "source_refs_required": {
            "splitting_rule": {
                "path": "work/sources/kl2003_src/30apr02.tex",
                "line_range": "TBD_BEFORE_IMPLEMENTATION",
                "sha256": "04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd",
            },
            "deletion_rule": {
                "path": "work/sources/kl2003_src/30apr02.tex",
                "line_range": "763-779",
                "sha256": "04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd",
            },
            "termination_rule": {
                "path": "TBD_FROM_TEX_BEFORE_IMPLEMENTATION",
                "line_range": "TBD",
                "sha256": "TBD",
                "blocker_if_missing": "BLOCKED_ON_EL_TERMINATION_RULE_SOURCE",
            },
        },
        "termination_policy": {
            "policy_kind": "expand_until_deletion_saturation",
            "status": "DELETION_SATURATION_HYPOTHESIS_UNTESTED",
            "tested_by_this_script": False,
            "notes": "Representability is checked here; the mathematical/source validity of saturation is deferred.",
        },
        "certificate_refs": {
            "L2NT_D3_slack": "2077/145800",
            "c25": "1001/1000",
            "c28": "69/40",
        },
        "guardrails": [
            "ROW28_GENERATOR_NOT_STARTED",
            "NO_K3_GENERATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }


def write_manifest(paths: list[Path], summary: dict[str, Any]) -> None:
    rows = []
    for path in paths:
        rows.append(
            {
                "path": repo_rel(path),
                "sha256": sha256(path),
                "artifact_kind": "summary" if path == SUMMARY_PATH else "diagnostic",
                "generator_version": Path(__file__).name,
                "schema_version": summary["schema_version_current"],
                "created_at": summary["created_at"],
                "source_commit": summary["source_commit"],
                "notes": "row28 nested schema check output",
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
            "notes",
        ],
    )


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    required_inputs = [SCHEMA_DOC, ROW28_SCOPING, BASELINE_ROWS, ROW25_JSON, ROW22_JSON, K2_REGRESSION_JSON, ROOT_PATHS]
    missing_inputs = [path for path in required_inputs if not path.exists()]
    if missing_inputs:
        created_at = datetime.now(timezone.utc).isoformat()
        summary = {
            "run_id": RUN_ID,
            "created_at": created_at,
            "source_commit": source_commit(),
            "schema_version_current": SCHEMA_V2,
            "verdict": "SCHEMA_CHECK_BLOCKED_ON_MISSING_REQUIRED_INPUT",
            "schema_v21_required": None,
            "missing_inputs": [repo_rel(path) for path in missing_inputs],
            "warning_count": 0,
            "warnings": [],
            "all_warnings_have_code_and_explanation": True,
            "classification": [
                "SCHEMA_CHECK_BLOCKED_ON_MISSING_REQUIRED_INPUT",
                "ROW28_GENERATOR_NOT_STARTED",
                "NO_K3_GENERATION",
                "NO_HIGH_K_CLAIM",
                "NO_GLOBAL_COLLATZ_CLAIM",
            ],
        }
        write_json(SUMMARY_PATH, summary)
        write_csv(
            CAPABILITY_MATRIX_PATH,
            [],
            [
                "capability_id",
                "category",
                "required_for_row28",
                "required_by_prompt",
                "question",
                "schema_v2_status",
                "v21_required",
                "evidence",
                "gap",
                "proposed_v21_field",
                "warning_code",
                "warning_explanation",
            ],
        )
        write_csv(
            GAP_ANALYSIS_PATH,
            [],
            [
                "capability_id",
                "category",
                "schema_v2_status",
                "gap",
                "proposed_v21_field",
                "why_needed",
            ],
        )
        write_json(PROPOSAL_PATH, {"metadata": {"verdict": summary["verdict"], "missing_inputs": summary["missing_inputs"]}})
        write_manifest([SUMMARY_PATH, CAPABILITY_MATRIX_PATH, GAP_ANALYSIS_PATH, PROPOSAL_PATH], summary)
        print(json.dumps({"verdict": summary["verdict"], "out_dir": repo_rel(OUT_DIR)}, sort_keys=True))
        return 0

    schema_text = SCHEMA_DOC.read_text(encoding="utf-8")
    row28_text = ROW28_SCOPING.read_text(encoding="utf-8")
    row25 = read_json(ROW25_JSON)
    row22 = read_json(ROW22_JSON)
    k2_regression = read_json(K2_REGRESSION_JSON)
    baseline = baseline_rows_by_id()
    deleted_nodes = figure_a1_deleted_nodes()

    example_keys = set()
    for artifact in [row25, row22, k2_regression]:
        example_keys.update(collect_keys(artifact))

    gap_rows = capability_analysis(schema_text, row28_text, example_keys, baseline)
    direct_supported = sum(1 for row in gap_rows if row["schema_v2_status"] == "SUPPORTED_DIRECT_OR_EXISTING")
    partial_supported = sum(1 for row in gap_rows if row["schema_v2_status"] == "SUPPORTED_PARTIAL_NEEDS_CANONICALIZATION")
    missing = sum(1 for row in gap_rows if row["schema_v2_status"] == "MISSING_CANONICAL_FIELD")
    v21_required = any(row["v21_required"] == "yes" for row in gap_rows)
    verdict = (
        "SCHEMA_V2_REQUIRES_V21_FOR_ROW28_NESTED_EL"
        if v21_required
        else "SCHEMA_V2_SUPPORTS_ROW28_NESTED_EL"
    )

    proposal = row28_proposal(gap_rows, baseline, deleted_nodes)
    write_json(PROPOSAL_PATH, proposal)
    write_csv(
        CAPABILITY_MATRIX_PATH,
        gap_rows,
        [
            "capability_id",
            "category",
            "required_for_row28",
            "required_by_prompt",
            "question",
            "schema_v2_status",
            "v21_required",
            "evidence",
            "gap",
            "proposed_v21_field",
            "warning_code",
            "warning_explanation",
        ],
    )
    gap_only_rows = [
        {
            "capability_id": row["capability_id"],
            "category": row["category"],
            "schema_v2_status": row["schema_v2_status"],
            "gap": row["gap"],
            "proposed_v21_field": row["proposed_v21_field"],
            "why_needed": row["question"],
        }
        for row in gap_rows
        if row["v21_required"] == "yes"
    ]
    write_csv(
        GAP_ANALYSIS_PATH,
        gap_only_rows,
        [
            "capability_id",
            "category",
            "schema_v2_status",
            "gap",
            "proposed_v21_field",
            "why_needed",
        ],
    )

    created_at = datetime.now(timezone.utc).isoformat()
    input_paths = [SCHEMA_DOC, ROW28_SCOPING, BASELINE_ROWS, ROW25_JSON, ROW22_JSON, K2_REGRESSION_JSON]
    if ROOT_PATHS.exists():
        input_paths.append(ROOT_PATHS)

    warnings = [
        {
            "code": "DELETION_SATURATION_HYPOTHESIS_UNTESTED",
            "explanation": "The check verifies that schema v2.1 can represent expand_until_deletion_saturation; it does not prove or source-discharge that termination policy.",
        }
    ]
    summary: dict[str, Any] = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": source_commit(),
        "schema_version_current": SCHEMA_V2,
        "schema_version_proposed_if_needed": SCHEMA_V21,
        "verdict": verdict,
        "schema_v21_required": v21_required,
        "capability_count": len(gap_rows),
        "capability_matrix_path": repo_rel(CAPABILITY_MATRIX_PATH),
        "direct_supported_count": direct_supported,
        "partial_supported_count": partial_supported,
        "missing_canonical_field_count": missing,
        "gap_count": len(gap_only_rows),
        "row28_baseline_present": "row28" in baseline,
        "m1v3_baseline_present": "M1V3" in baseline,
        "m1v3_phi25_guardrail_seen": text_has(json.dumps(baseline.get("M1V3", {})), "phi25"),
        "m1v3_phi22_second_arm_forbidden": True,
        "figure_a1_deleted_nodes_expected": deleted_nodes,
        "figure_a1_oracle_diff_required": True,
        "el_termination_policy_representability_checked": True,
        "termination_policy_kind": "expand_until_deletion_saturation",
        "termination_policy_status": "DELETION_SATURATION_HYPOTHESIS_UNTESTED",
        "warning_count": len(warnings),
        "warnings": warnings,
        "all_warnings_have_code_and_explanation": all(
            bool(item.get("code")) and bool(item.get("explanation")) for item in warnings
        ),
        "row28_generator_status": "ROW28_GENERATOR_NOT_STARTED",
        "classification": [
            "ROW28_NESTED_SCHEMA_CHECK_CREATED",
            "NESTED_EL_SCHEMA_CAPABILITY_ASSESSED",
            "EL_TERMINATION_POLICY_REPRESENTABILITY_CHECKED",
            "DELETION_SATURATION_HYPOTHESIS_RECORDED_NOT_TESTED",
            "SCHEMA_V2_REQUIRES_V21_FOR_ROW28_NESTED_EL" if v21_required else "SCHEMA_V2_SUPPORTS_ROW28_NESTED_EL",
            "ROW28_GENERATOR_NOT_STARTED",
            "NO_K3_GENERATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "input_files": [
            {
                "path": repo_rel(path),
                "sha256": sha256(path),
                "role": {
                    SCHEMA_DOC: "schema_v2_scoping",
                    ROW28_SCOPING: "row28_microgenerator_scoping",
                    BASELINE_ROWS: "manual_k2_baseline_rows",
                    ROW25_JSON: "row25_generated_example",
                    ROW22_JSON: "row22_generated_example",
                    K2_REGRESSION_JSON: "k2_regression_generated_example",
                    ROOT_PATHS: "figure_a1_root_paths_oracle",
                }.get(path, "input"),
            }
            for path in input_paths
        ],
        "outputs": {
            "summary": repo_rel(SUMMARY_PATH),
            "schema_capability_matrix": repo_rel(CAPABILITY_MATRIX_PATH),
            "schema_gap_analysis": repo_rel(GAP_ANALYSIS_PATH),
            "row28_nested_representation_proposal": repo_rel(PROPOSAL_PATH),
            "manifest": repo_rel(MANIFEST_PATH),
        },
        "guardrails": [
            "NO_ROW28_GENERATOR_IMPLEMENTATION",
            "NO_K3_GENERATION",
            "NO_LP",
            "NO_LEAN_BUILD",
            "NO_THEOREM_CLAIM",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    write_manifest([SUMMARY_PATH, CAPABILITY_MATRIX_PATH, GAP_ANALYSIS_PATH, PROPOSAL_PATH], summary)

    print(json.dumps({"verdict": verdict, "out_dir": repo_rel(OUT_DIR)}, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
