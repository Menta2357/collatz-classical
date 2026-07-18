#!/usr/bin/env python3
"""Emit a syntax-only fixture for the KL2003 F2 k=3 certificate format.

This script deliberately creates a fixture, not a mathematical certificate.
It uses dummy data only, validates basic schema/rational-string rules, and
hashes the emitted artifacts.  It does not generate k=3 rows, solve an LP, or
open Lean.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
import subprocess
from datetime import datetime, timezone
from math import gcd
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K3_CERTIFICATE_FIXTURE_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
SCHEMA_VERSION_V21 = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"
GENERATOR_VERSION = "kl2003_f2_k3_certificate_fixture_v1.py"
REPO_ROOT = Path(__file__).resolve().parents[1]
SCOPING = REPO_ROOT / "docs" / "KL2003_F2_K3_DATA_CERTIFICATE_FORMAT_SCOPING_v1.md"
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
FIXTURE_PATH = OUT_DIR / "kl2003_k3_certificate.fixture.json"
LEAN_FIXTURE_PATH = OUT_DIR / "KL2003K3CertificateDataFixture.lean"
NESTED_FIXTURE_PATH = OUT_DIR / "kl2003_k2_row28_nested_certificate.fixture.json"
NESTED_LEAN_FIXTURE_PATH = OUT_DIR / "KL2003K2Row28NestedCertificateDataFixture.lean"
SUMMARY_PATH = OUT_DIR / "schema_check_summary.json"
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

METADATA_REQUIRED = [
    "run_id",
    "schema_version",
    "k",
    "tracked_class_convention",
    "pre_reduction_class_count",
    "tracked_class_count",
    "artifact_links",
    "generator_version",
    "created_at",
    "source_commit",
    "source_inputs",
    "guardrails",
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
    "source_ref",
    "normalization_ref",
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

RATIONAL_CERTIFICATE_REQUIRED = [
    "lambda_interval",
    "coefficient_intervals",
    "variables",
    "row_lhs",
    "row_rhs",
    "solver_manifest",
    "float_diagnostics",
]

SLACK_REQUIRED = [
    "slack_id",
    "row_id",
    "lhs",
    "rhs",
    "slack",
    "strictly_positive",
    "denominator_bits",
    "numerator_bits",
    "notes",
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


def build_fixture(created_at: str, commit: str) -> dict[str, Any]:
    child = {
        "child_id": "dummy_child_0",
        "inverse_word": ["e"],
        "target_class": "dummy_class_0",
        "shift": "0",
        "window_policy": "fixture_window_policy",
        "fiber_parent": "dummy_fiber_parent",
        "deleted": False,
        "reason": "fixture_only_no_math",
        "row_id": "dummy_row_0",
        "literal_id": "dummy_literal_0",
        "root_formula": "fixture_root",
        "forward_route": ["fixture_route_step"],
        "residue_side_conditions": [],
        "coefficient_ref": "dummy_coeff_0",
        "depth": "0",
        "boundary_correction": "none",
    }

    return {
        "fixture_only": True,
        "mathematical_content": False,
        "not_for_lean_import": True,
        "metadata": {
            "run_id": RUN_ID,
            "schema_version": SCHEMA_VERSION,
            "k": "3",
            "tracked_class_convention": "fixture_dummy_single_class",
            "pre_reduction_class_count": "27",
            "tracked_class_count": "9",
            "format_scope": "high_k_parametric",
            "artifact_links": {
                "json_artifact": "kl2003_k3_certificate.fixture.json",
                "lean_data_artifact": "KL2003K3CertificateDataFixture.lean",
                "json_to_lean_generator": "scripts/kl2003_f2_k3_certificate_fixture_v1.py",
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": "RECORDED_IN_MANIFEST",
                "lean_import_policy": "Lean consumes generated .lean data, not JSON.",
            },
            "generator_version": GENERATOR_VERSION,
            "created_at": created_at,
            "source_commit": commit,
            "source_inputs": [
                {
                    "path": repo_rel(SCOPING),
                    "sha256": sha256(SCOPING) if SCOPING.exists() else "MISSING",
                    "role": "format_scoping",
                }
            ],
            "guardrails": [
                "FIXTURE_ONLY",
                "NO_MATHEMATICAL_CONTENT",
                "NOT_FOR_LEAN_IMPORT",
                "NO_K3_ROWS_GENERATED",
                "NO_LP_SOLVED",
                "NO_HIGH_K_CLAIM",
                "NO_GLOBAL_COLLATZ_CLAIM",
            ],
            "fixture_only": True,
            "mathematical_content": False,
            "not_for_lean_import": True,
        },
        "tracked_classes": [
            {
                "class_id": "dummy_class_0",
                "modulus": "27",
                "representative": "1",
                "pre_reduction_residues": ["1"],
                "source_rule": "fixture_only_no_source_rule",
                "active": True,
                "notes": "Dummy class for schema validation only.",
            }
        ],
        "rows": [
            {
                "row_id": "dummy_row_0",
                "source_class": "dummy_class_0",
                "row_kind": "fixture",
                "children": [child],
                "deletion_policy": "fixture_no_deletion_policy",
                "coefficient_terms": [
                    {
                        "coefficient_id": "dummy_coeff_0",
                        "value": "1",
                        "target": "dummy_child_0",
                    }
                ],
                "target_bound": "1",
                "slack_id": "dummy_slack_0",
                "source_ref": "fixture_no_source_ref",
                "normalization_ref": "fixture_no_normalization_ref",
            }
        ],
        "inverse_words": [child],
        "deletion_marks": [
            {
                "row_id": "dummy_row_0",
                "child_id": "dummy_child_0",
                "deleted": False,
                "deletion_policy": "fixture_no_deletion_policy",
                "reason": "fixture_only_no_math",
                "boundary_correction": "none",
                "source_ref": "fixture_no_source_ref",
            }
        ],
        "rational_certificate": {
            "lambda_interval": {"lo": "1", "hi": "1"},
            "coefficient_intervals": [
                {
                    "coefficient_id": "dummy_coeff_0",
                    "lo": "1",
                    "hi": "1",
                }
            ],
            "variables": {"dummy_var": "1/2"},
            "row_lhs": {"dummy_row_0": "0"},
            "row_rhs": {"dummy_row_0": "1"},
            "solver_manifest": {
                "solver": "none_fixture_only",
                "lp_solved": False,
            },
            "float_diagnostics": [],
        },
        "slacks": [
            {
                "slack_id": "dummy_slack_0",
                "row_id": "dummy_row_0",
                "lhs": "0",
                "rhs": "1",
                "slack": "1",
                "strictly_positive": True,
                "denominator_bits": "1",
                "numerator_bits": "1",
                "notes": "Dummy positive slack for schema validation only.",
            }
        ],
        "verification_targets": [
            {
                "target_id": "row_well_formed",
                "input_sections": ["rows"],
                "expected_checker": "future_lean_or_schema_checker",
                "status": "PENDING_LEAN_VERIFIER",
                "notes": "Fixture target only.",
            }
        ],
    }


def build_nested_v21_fixture(created_at: str, commit: str) -> dict[str, Any]:
    child = {
        "child_id": "row28_retarded_4a",
        "node_id": "row28_retarded_4a",
        "inverse_word": ["even", "even"],
        "target_class": "5",
        "shift": "-2",
        "window_policy": "exact_retarded_window",
        "fiber_parent": "row28_root",
        "deleted": False,
        "reason": "fixture_retarded_branch",
        "row_id": "row28",
        "literal_id": "row28_retarded_literal",
        "root_formula": "4*a",
        "forward_route": ["4*a -> 2*a", "2*a -> a"],
        "residue_side_conditions": ["a % 9 = 8", "(4*a) % 9 = 5"],
        "coefficient_ref": "c25",
        "depth": "2",
        "boundary_correction": "none",
        "branch_role": "retarded",
        "node_status": "counted",
        "contributes_to_cardinality": True,
    }
    return {
        "fixture_only": True,
        "mathematical_content": False,
        "not_for_lean_import": True,
        "metadata": {
            "run_id": "KL2003_F2_K2_ROW28_NESTED_CERTIFICATE_FIXTURE_v1",
            "schema_version": SCHEMA_VERSION_V21,
            "k": "2",
            "tracked_class_convention": "k2_nested_fixture_classes_mod9_2_5_8",
            "pre_reduction_class_count": "9",
            "tracked_class_count": "3",
            "format_scope": "high_k_parametric_nested_el",
            "artifact_links": {
                "json_artifact": "kl2003_k2_row28_nested_certificate.fixture.json",
                "lean_data_artifact": "KL2003K2Row28NestedCertificateDataFixture.lean",
                "json_to_lean_generator": "scripts/kl2003_f2_k3_certificate_fixture_v1.py",
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": "RECORDED_IN_MANIFEST",
                "lean_import_policy": "Nested fixture Lean data remains in outputs and is not imported.",
            },
            "generator_version": GENERATOR_VERSION,
            "created_at": created_at,
            "source_commit": commit,
            "source_inputs": [
                {
                    "path": repo_rel(SCOPING),
                    "sha256": sha256(SCOPING) if SCOPING.exists() else "MISSING",
                    "role": "format_scoping",
                }
            ],
            "guardrails": [
                "FIXTURE_ONLY",
                "NO_MATHEMATICAL_CONTENT",
                "NOT_FOR_LEAN_IMPORT",
                "NO_ROW28_GENERATOR_IMPLEMENTATION",
                "NO_K3_ROWS_GENERATED",
                "NO_LP_SOLVED",
                "NO_HIGH_K_CLAIM",
                "NO_GLOBAL_COLLATZ_CLAIM",
            ],
            "fixture_only": True,
            "mathematical_content": False,
            "not_for_lean_import": True,
        },
        "tracked_classes": [
            {
                "class_id": "class_mod9_2",
                "modulus": "9",
                "representative": "2",
                "pre_reduction_residues": ["2"],
                "source_rule": "fixture_nested",
                "active": True,
                "notes": "Nested fixture class.",
            },
            {
                "class_id": "class_mod9_5",
                "modulus": "9",
                "representative": "5",
                "pre_reduction_residues": ["5"],
                "source_rule": "fixture_nested",
                "active": True,
                "notes": "Nested fixture class.",
            },
            {
                "class_id": "class_mod9_8",
                "modulus": "9",
                "representative": "8",
                "pre_reduction_residues": ["8"],
                "source_rule": "fixture_nested",
                "active": True,
                "notes": "Nested fixture class.",
            },
        ],
        "rows": [
            {
                "row_id": "row28",
                "source_class": "28",
                "row_kind": "D3 / EL nested fixture",
                "children": [child],
                "deletion_policy": "fixture_deletion_policy",
                "coefficient_terms": [
                    {"coefficient_id": "c25", "value": "1001/1000", "target": "row28_retarded_4a"},
                    {"coefficient_id": "c28", "value": "69/40", "target": "row28"},
                ],
                "target_bound": "69/40",
                "slack_id": "L2NT_D3_slack",
                "source_ref": "fixture_v2_1_nested_el",
                "normalization_ref": "fixture_v2_1_nested_el",
                "nested_block_ref": "row28_outer_block",
            }
        ],
        "inverse_words": [child],
        "deletion_marks": [
            {
                "row_id": "row28",
                "child_id": "row28_deleted_N04",
                "deleted": True,
                "deletion_policy": "same_mode_earlier_smaller_shift",
                "reason": "fixture Figure A1 crossed node N04",
                "boundary_correction": "post_deletion_replacement",
                "source_ref": "deletion_rule_source",
                "figure_node_id": "N04",
                "node_status": "deleted",
            }
        ],
        "rational_certificate": {
            "lambda_interval": {"lo": "27/20", "hi": "27/20"},
            "coefficient_intervals": [
                {"coefficient_id": "c25", "lo": "1001/1000", "hi": "1001/1000"},
                {"coefficient_id": "c28", "lo": "69/40", "hi": "69/40"},
                {"coefficient_id": "L2NT_D3_slack", "lo": "2077/145800", "hi": "2077/145800"},
            ],
            "variables": {"fixture_var": "1"},
            "row_lhs": {"row28": "0"},
            "row_rhs": {"row28": "69/40"},
            "solver_manifest": {"solver": "none_fixture_only", "lp_solved": False},
            "float_diagnostics": [],
        },
        "slacks": [
            {
                "slack_id": "L2NT_D3_slack",
                "row_id": "row28",
                "lhs": "0",
                "rhs": "2077/145800",
                "slack": "2077/145800",
                "strictly_positive": True,
                "denominator_bits": "18",
                "numerator_bits": "12",
                "notes": "Fixture D3 slack reference only.",
            }
        ],
        "verification_targets": [
            {
                "target_id": "nested_el_well_formed",
                "input_sections": ["nested_blocks", "nodes", "post_deletion_edges"],
                "expected_checker": "schema_v2_1_validator",
                "status": "PENDING_SCHEMA_VALIDATOR",
                "notes": "Fixture target only.",
            }
        ],
        "nodes": [
            {
                "node_id": "row28_root",
                "figure_node_id": "N09",
                "node_status": "expanded",
                "class": "8",
                "shift": "0",
                "branch_role": "row_root",
                "contributes_to_cardinality": False,
                "source_ref": "figure_a1_oracle",
            },
            {
                "node_id": "row28_retarded_4a",
                "parent_node_id": "row28_root",
                "node_status": "counted",
                "class": "5",
                "shift": "-2",
                "branch_role": "retarded",
                "contributes_to_cardinality": True,
                "source_ref": "splitting_rule_source",
            },
            {
                "node_id": "row28_deleted_N04",
                "parent_node_id": "row28_root",
                "figure_node_id": "N04",
                "node_status": "deleted",
                "class": "8",
                "shift": "0",
                "branch_role": "advanced",
                "contributes_to_cardinality": False,
                "source_ref": "deletion_rule_source",
            },
            {
                "node_id": "row28_post_child_phi28",
                "parent_node_id": "row28_deleted_N04",
                "node_status": "counted",
                "class": "8",
                "shift": "0",
                "branch_role": "post_deletion",
                "contributes_to_cardinality": True,
                "source_ref": "deletion_rule_source",
            },
            {
                "node_id": "row28_post_child_phi25",
                "parent_node_id": "row28_deleted_N04",
                "node_status": "counted",
                "class": "5",
                "shift": "0",
                "branch_role": "post_deletion",
                "contributes_to_cardinality": True,
                "source_ref": "deletion_rule_source",
            },
        ],
        "nested_blocks": [
            {
                "block_id": "M2V3",
                "block_kind": "min",
                "children": [
                    {"component": "phi22", "shift": "shift3AlphaMinus5Pad3"},
                    {"component": "phi25", "shift": "shift3AlphaMinus5Pad3"},
                    {"component": "phi28", "shift": "shift3AlphaMinus5Pad3"},
                ],
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
            },
            {
                "block_id": "row28_post_deletion_sibling_sum",
                "block_kind": "sum",
                "claims_disjointness": True,
                "sibling_disjointness_group": "row28_post_deletion_siblings_N04",
                "parent_descendant_overlap_forbidden": True,
                "children": [
                    {"node_ref": "row28_post_child_phi28"},
                    {"node_ref": "row28_post_child_phi25"},
                ],
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
            },
        ],
        "post_deletion_edges": [
            {
                "edge_id": "post_delete_N04",
                "deleted_node_id": "row28_deleted_N04",
                "replacement_child_ids": ["row28_post_child_phi28", "row28_post_child_phi25"],
                "reason": "fixture post-deletion edge",
                "source_ref": "deletion_rule_source",
            }
        ],
        "case_splits": [
            {
                "split_id": "row28_c_split",
                "variable": "c",
                "modulus": "9",
                "exhaustive_cases": ["5", "2", "8"],
            },
            {
                "split_id": "row28_cprime_split",
                "variable": "cPrime",
                "modulus": "9",
                "exhaustive_cases": ["2", "5", "8"],
            },
        ],
        "sibling_disjointness_groups": [
            {
                "group_id": "row28_post_deletion_siblings_N04",
                "parent_fiber": "row28_deleted_N04",
                "member_node_ids": ["row28_post_child_phi28", "row28_post_child_phi25"],
                "reason": "fixture sibling group for post-deletion counted children",
            }
        ],
        "overlap_guards": [
            {
                "guard_id": "row28_no_parent_descendant_sum",
                "guard_kind": "no_parent_descendant_sum",
                "scope": "row28",
                "reason": "fixture guard against parent+descendant counting",
            }
        ],
        "source_refs": [
            {
                "source_ref_id": "splitting_rule_source",
                "source_kind": "splitting_rule",
                "path": "work/sources/kl2003_src/30apr02.tex",
                "line_range": "TBD_BEFORE_IMPLEMENTATION",
                "sha256": "04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd",
                "trust_role": "generator_rule_source",
            },
            {
                "source_ref_id": "deletion_rule_source",
                "source_kind": "deletion_rule",
                "path": "work/sources/kl2003_src/30apr02.tex",
                "line_range": "763-779",
                "sha256": "04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd",
                "trust_role": "generator_rule_source",
            },
            {
                "source_ref_id": "figure_a1_oracle",
                "source_kind": "figure_a1",
                "path": "outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/root_paths.csv",
                "line_range": "N04/N05",
                "sha256": "RECORDED_IN_ROW28_SCHEMA_CHECK_MANIFEST",
                "trust_role": "regression_oracle",
            },
            {
                "source_ref_id": "termination_rule_source_tbd",
                "source_kind": "termination_rule",
                "path": "work/sources/kl2003_src/30apr02.tex",
                "line_range": "TBD_BEFORE_ROW28_IMPLEMENTATION",
                "sha256": "04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd",
                "trust_role": "hypothesis_source_pending",
            },
        ],
        "termination_policy": {
            "kind": "expand_until_deletion_saturation",
            "status": "hypothesis_untested",
            "source_ref": "termination_rule_source_tbd",
            "notes": "Fixture representability only; not a proof.",
        },
    }


def missing_fields(obj: dict[str, Any], fields: list[str], prefix: str) -> list[str]:
    return [f"{prefix}.{field}" for field in fields if field not in obj]


def count_floats(obj: Any) -> int:
    if isinstance(obj, float):
        return 1
    if isinstance(obj, dict):
        return sum(count_floats(value) for value in obj.values())
    if isinstance(obj, list):
        return sum(count_floats(value) for value in obj)
    return 0


def canonical_rational_string_ok(value: str) -> bool:
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


def rational_string_errors(obj: Any, path: str = "$") -> list[str]:
    errors: list[str] = []
    rational_key_tokens = {
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
    if isinstance(obj, dict):
        for key, value in obj.items():
            child_path = f"{path}.{key}"
            if key in rational_key_tokens:
                if not isinstance(value, str) or not canonical_rational_string_ok(value):
                    errors.append(child_path)
            errors.extend(rational_string_errors(value, child_path))
    elif isinstance(obj, list):
        for idx, value in enumerate(obj):
            errors.extend(rational_string_errors(value, f"{path}[{idx}]"))
    return errors


def validate_fixture(fixture: dict[str, Any]) -> dict[str, Any]:
    missing: list[str] = []
    missing.extend(missing_fields(fixture, TOP_LEVEL_REQUIRED, "$"))
    metadata = fixture.get("metadata", {})
    if isinstance(metadata, dict):
        missing.extend(missing_fields(metadata, METADATA_REQUIRED, "$.metadata"))
    else:
        missing.append("$.metadata")

    for idx, row in enumerate(fixture.get("rows", [])):
        if isinstance(row, dict):
            missing.extend(missing_fields(row, ROW_REQUIRED, f"$.rows[{idx}]"))
            for child_idx, child in enumerate(row.get("children", [])):
                if isinstance(child, dict):
                    missing.extend(
                        missing_fields(child, CHILD_REQUIRED, f"$.rows[{idx}].children[{child_idx}]")
                    )
                else:
                    missing.append(f"$.rows[{idx}].children[{child_idx}]")
        else:
            missing.append(f"$.rows[{idx}]")

    for idx, child in enumerate(fixture.get("inverse_words", [])):
        if isinstance(child, dict):
            missing.extend(missing_fields(child, CHILD_REQUIRED, f"$.inverse_words[{idx}]"))
        else:
            missing.append(f"$.inverse_words[{idx}]")

    rational_certificate = fixture.get("rational_certificate", {})
    if isinstance(rational_certificate, dict):
        missing.extend(
            missing_fields(rational_certificate, RATIONAL_CERTIFICATE_REQUIRED, "$.rational_certificate")
        )
    else:
        missing.append("$.rational_certificate")

    for idx, slack in enumerate(fixture.get("slacks", [])):
        if isinstance(slack, dict):
            missing.extend(missing_fields(slack, SLACK_REQUIRED, f"$.slacks[{idx}]"))
        else:
            missing.append(f"$.slacks[{idx}]")

    flag_errors = []
    if fixture.get("fixture_only") is not True:
        flag_errors.append("$.fixture_only")
    if fixture.get("mathematical_content") is not False:
        flag_errors.append("$.mathematical_content")
    if fixture.get("not_for_lean_import") is not True:
        flag_errors.append("$.not_for_lean_import")
    if metadata.get("fixture_only") is not True:
        flag_errors.append("$.metadata.fixture_only")
    if metadata.get("mathematical_content") is not False:
        flag_errors.append("$.metadata.mathematical_content")
    if metadata.get("not_for_lean_import") is not True:
        flag_errors.append("$.metadata.not_for_lean_import")

    float_count = count_floats(fixture)
    rational_errors = rational_string_errors(fixture)

    return {
        "missing_required_fields": missing,
        "flag_errors": flag_errors,
        "float_count": float_count,
        "rational_string_errors": rational_errors,
        "schema_ok": not missing and not flag_errors and float_count == 0 and not rational_errors,
    }


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_lean_fixture(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\n".join(
            [
                "/-",
                "KL2003 k=3 certificate data fixture.",
                "",
                "fixture only; not imported; no mathematical content.",
                "Generated deterministically from the JSON fixture shape.",
                "-/",
                "",
                "namespace KL2003K3CertificateDataFixture",
                "",
                "def fixtureOnly : Bool := true",
                "def mathematicalContent : Bool := false",
                "def notForLeanImport : Bool := true",
                f'def schemaVersion : String := "{SCHEMA_VERSION}"',
                "def k : Nat := 3",
                "def trackedClassCount : Nat := 9",
                "def preReductionClassCount : Nat := 27",
                "",
                "end KL2003K3CertificateDataFixture",
                "",
            ]
        ),
        encoding="utf-8",
    )


def write_nested_lean_fixture(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\n".join(
            [
                "/-",
                "KL2003 k=2 row28 nested certificate data fixture.",
                "",
                "fixture only; not imported; no mathematical content.",
                "Generated deterministically from the JSON fixture shape.",
                "-/",
                "",
                "namespace KL2003K2Row28NestedCertificateDataFixture",
                "",
                "def fixtureOnly : Bool := true",
                "def mathematicalContent : Bool := false",
                "def notForLeanImport : Bool := true",
                f'def schemaVersion : String := "{SCHEMA_VERSION_V21}"',
                "def k : Nat := 2",
                "def trackedClassCount : Nat := 3",
                "def preReductionClassCount : Nat := 9",
                "def rowId : String := \"row28\"",
                "def m1v3SecondArm : String := \"phi25\"",
                "",
                "end KL2003K2Row28NestedCertificateDataFixture",
                "",
            ]
        ),
        encoding="utf-8",
    )


def write_manifest(rows: list[dict[str, str]]) -> None:
    with MANIFEST_PATH.open("w", newline="", encoding="utf-8") as handle:
        fieldnames = [
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
        ]
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    if not SCOPING.exists():
        raise FileNotFoundError(f"Missing format scoping note: {SCOPING}")

    created_at = datetime.now(timezone.utc).isoformat()
    commit = source_commit()
    fixture = build_fixture(created_at, commit)
    nested_fixture = build_nested_v21_fixture(created_at, commit)
    validation = validate_fixture(fixture)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    write_json(FIXTURE_PATH, fixture)
    write_lean_fixture(LEAN_FIXTURE_PATH)
    write_json(NESTED_FIXTURE_PATH, nested_fixture)
    write_nested_lean_fixture(NESTED_LEAN_FIXTURE_PATH)

    json_sha = sha256(FIXTURE_PATH)
    lean_sha = sha256(LEAN_FIXTURE_PATH)
    nested_json_sha = sha256(NESTED_FIXTURE_PATH)
    nested_lean_sha = sha256(NESTED_LEAN_FIXTURE_PATH)
    generator_sha = sha256(Path(__file__).resolve())

    manifest_targets = [
        (FIXTURE_PATH, "fixture_certificate", "Syntax-only fixture; not a mathematical certificate."),
        (LEAN_FIXTURE_PATH, "fixture_lean_data", "Fixture-only generated Lean data file; not imported."),
        (NESTED_FIXTURE_PATH, "fixture_nested_certificate_v21", "Nested row28 fixture; not a mathematical certificate."),
        (NESTED_LEAN_FIXTURE_PATH, "fixture_nested_lean_data_v21", "Nested fixture Lean data file; not imported."),
        (SUMMARY_PATH, "summary", "Schema check summary for the fixture."),
    ]

    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "schema_version": SCHEMA_VERSION,
        "nested_schema_version": SCHEMA_VERSION_V21,
        "fixture_path": repo_rel(FIXTURE_PATH),
        "lean_fixture_path": repo_rel(LEAN_FIXTURE_PATH),
        "nested_fixture_path": repo_rel(NESTED_FIXTURE_PATH),
        "nested_lean_fixture_path": repo_rel(NESTED_LEAN_FIXTURE_PATH),
        "json_sha256": json_sha,
        "lean_data_sha256": lean_sha,
        "nested_json_sha256": nested_json_sha,
        "nested_lean_data_sha256": nested_lean_sha,
        "json_to_lean_generator_sha256": generator_sha,
        "fixture_only": True,
        "mathematical_content": False,
        "not_for_lean_import": True,
        "schema_ok": validation["schema_ok"],
        "float_count": validation["float_count"],
        "missing_required_fields": validation["missing_required_fields"],
        "flag_errors": validation["flag_errors"],
        "rational_string_errors": validation["rational_string_errors"],
        "manifest_file_count": len(manifest_targets),
        "verdict": "FIXTURE_FORMAT_ONLY",
        "guardrails": [
            "NO_K3_CERTIFICATE_GENERATED",
            "NO_K3_ROWS_GENERATED",
            "NO_LP_SOLVED",
            "NO_LEAN_OPENED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "K3_CERTIFICATE_FIXTURE_CREATED",
            "K3_FIXTURE_UPDATED_TO_SCHEMA_V2",
            "K2_ROW28_NESTED_FIXTURE_V21_CREATED",
            "JSON_LEAN_TWIN_ARTIFACT_POLICY_DEFINED",
            "CANONICAL_RATIONAL_FORMAT_DEFINED",
            "FORMAT_ONLY_FIXTURE",
            "NO_MATHEMATICAL_CONTENT",
            "NOT_FOR_LEAN_IMPORT",
            "NO_K3_CERTIFICATE_GENERATED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)

    manifest_rows = [
        {
            "path": repo_rel(path),
            "sha256": sha256(path),
            "artifact_kind": kind,
            "generator_version": GENERATOR_VERSION,
            "schema_version": SCHEMA_VERSION,
            "created_at": created_at,
            "source_commit": commit,
            "json_sha256": json_sha,
            "lean_data_sha256": lean_sha,
            "json_to_lean_generator_sha256": generator_sha,
            "notes": notes,
        }
        for path, kind, notes in manifest_targets
    ]
    for row in manifest_rows:
        if row["path"] == repo_rel(NESTED_FIXTURE_PATH):
            row["json_sha256"] = nested_json_sha
            row["lean_data_sha256"] = nested_lean_sha
        if row["path"] == repo_rel(NESTED_LEAN_FIXTURE_PATH):
            row["json_sha256"] = nested_json_sha
            row["lean_data_sha256"] = nested_lean_sha
    write_manifest(manifest_rows)

    if not validation["schema_ok"]:
        raise SystemExit("Fixture schema check failed; see schema_check_summary.json")

    print(f"run_id={RUN_ID}")
    print(f"fixture={repo_rel(FIXTURE_PATH)}")
    print(f"lean_fixture={repo_rel(LEAN_FIXTURE_PATH)}")
    print(f"nested_fixture={repo_rel(NESTED_FIXTURE_PATH)}")
    print(f"nested_lean_fixture={repo_rel(NESTED_LEAN_FIXTURE_PATH)}")
    print(f"summary={repo_rel(SUMMARY_PATH)}")
    print(f"manifest={repo_rel(MANIFEST_PATH)}")
    print("verdict=FIXTURE_FORMAT_ONLY")
    print("fixture_only=true mathematical_content=false not_for_lean_import=true")


if __name__ == "__main__":
    main()
