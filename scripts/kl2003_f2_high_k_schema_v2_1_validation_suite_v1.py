#!/usr/bin/env python3
"""Run the KL2003 high-k schema v2/v2.1 positive and negative validation suite.

This is a schema/format test only.  It does not verify KL2003 mathematics,
does not implement the row28 generator, does not generate k=3 data, does not
solve an LP, and does not open Lean.
"""

from __future__ import annotations

import copy
import csv
import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_HIGH_K_SCHEMA_V2_1_VALIDATION_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
NEGATIVE_DIR = OUT_DIR / "negative_inputs"

SUMMARY_PATH = OUT_DIR / "validation_summary.json"
ARTIFACT_MATRIX_PATH = OUT_DIR / "artifact_validation_matrix.csv"
NEGATIVE_RESULTS_PATH = OUT_DIR / "negative_test_results.csv"
ERRORS_PATH = OUT_DIR / "schema_validation_errors.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

K3_FIXTURE_V2 = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K3_CERTIFICATE_FIXTURE_v1"
    / "kl2003_k3_certificate.fixture.json"
)
K2_REGRESSION_V2 = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K2_REGRESSION_GENERATOR_SKELETON_v1"
    / "kl2003_k2_regression_certificate.generated.json"
)
ROW25_V2 = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW25_MICROGENERATOR_v1" / "row25.generated.json"
ROW22_V2 = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW22_MICROGENERATOR_v1" / "row22.generated.json"
NESTED_FIXTURE_V21 = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K3_CERTIFICATE_FIXTURE_v1"
    / "kl2003_k2_row28_nested_certificate.fixture.json"
)
ROW28_PROPOSAL_V21 = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_ROW28_NESTED_SCHEMA_CHECK_v1"
    / "row28_nested_representation_proposal.json"
)


sys.path.insert(0, str(REPO_ROOT / "scripts"))
import kl2003_f2_k3_certificate_schema_validator_v1 as schema_validator  # noqa: E402


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
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"{path} is not a JSON object")
    return data


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
                if isinstance(value, (list, dict, set, tuple)):
                    encoded[field] = json.dumps(value, sort_keys=True)
                else:
                    encoded[field] = value
            writer.writerow(encoded)


def write_manifest(paths: list[Path]) -> None:
    rows = []
    for path in paths:
        rows.append(
            {
                "path": repo_rel(path),
                "sha256": sha256(path),
                "artifact_kind": "validation_output" if path.parent == OUT_DIR else "negative_test_input",
            }
        )
    write_csv(MANIFEST_PATH, rows, ["path", "sha256", "artifact_kind"])


def issue_rows(test_id: str, expected_outcome: str, issues: list[schema_validator.ValidationIssue]) -> list[dict[str, Any]]:
    return [
        {
            "test_id": test_id,
            "expected_outcome": expected_outcome,
            "severity": issue.severity,
            "path": issue.path,
            "code": issue.code,
            "message": issue.message,
        }
        for issue in issues
    ]


def validate_path(test_id: str, path: Path, expected_outcome: str) -> tuple[dict[str, Any], list[dict[str, Any]], set[str]]:
    if not path.exists():
        row = {
            "test_id": test_id,
            "input_path": repo_rel(path),
            "expected_outcome": expected_outcome,
            "schema_version": "",
            "input_kind": "missing",
            "schema_ok": False,
            "error_count": 1,
            "warning_count": 0,
            "expected_pass": expected_outcome == "pass",
            "verdict": "MISSING_INPUT",
        }
        return row, [
            {
                "test_id": test_id,
                "expected_outcome": expected_outcome,
                "severity": "error",
                "path": repo_rel(path),
                "code": "VALIDATION_SUITE_INPUT_MISSING",
                "message": "Required validation input is missing.",
            }
        ], {"VALIDATION_SUITE_INPUT_MISSING"}

    data = read_json(path)
    issues, stats = schema_validator.validate_data(data, path)
    error_codes = {issue.code for issue in issues if issue.severity == "error"}
    error_count = sum(1 for issue in issues if issue.severity == "error")
    warning_count = sum(1 for issue in issues if issue.severity == "warning")
    schema_ok = error_count == 0
    row = {
        "test_id": test_id,
        "input_path": repo_rel(path),
        "expected_outcome": expected_outcome,
        "schema_version": schema_validator.schema_version(data) or "",
        "input_kind": stats.get("input_kind", ""),
        "schema_ok": schema_ok,
        "error_count": error_count,
        "warning_count": warning_count,
        "expected_pass": expected_outcome == "pass",
        "verdict": "PASS" if schema_ok == (expected_outcome == "pass") else "FAIL",
    }
    return row, issue_rows(test_id, expected_outcome, issues), error_codes


def find_block(data: dict[str, Any], block_id: str) -> dict[str, Any]:
    blocks = data.get("nested_blocks", [])
    if not isinstance(blocks, list):
        raise ValueError("nested_blocks is not a list")
    for block in blocks:
        if isinstance(block, dict) and block.get("block_id") == block_id:
            return block
    raise ValueError(f"missing block {block_id}")


def find_node(data: dict[str, Any], node_id: str) -> dict[str, Any]:
    nodes = data.get("nodes", [])
    if not isinstance(nodes, list):
        raise ValueError("nodes is not a list")
    for node in nodes:
        if isinstance(node, dict) and node.get("node_id") == node_id:
            return node
    raise ValueError(f"missing node {node_id}")


def nested_block_children(block: dict[str, Any]) -> list[Any]:
    children = block.get("children", [])
    if isinstance(children, list):
        return children
    raise ValueError(f"block {block.get('block_id')} has no children list")


def write_negative_input(test_id: str, data: dict[str, Any]) -> Path:
    NEGATIVE_DIR.mkdir(parents=True, exist_ok=True)
    path = NEGATIVE_DIR / f"{test_id}.fixture.json"
    write_json(path, data)
    return path


def negative_cases(base: dict[str, Any]) -> list[tuple[str, str, dict[str, Any]]]:
    cases: list[tuple[str, str, dict[str, Any]]] = []

    m1_phi22 = copy.deepcopy(base)
    nested_block_children(find_block(m1_phi22, "M1V3"))[1]["component"] = "phi22"
    cases.append(("negative_m1v3_phi22", "V21_M1V3_SECOND_ARM_NOT_PHI25", m1_phi22))

    missing_ref = copy.deepcopy(base)
    nested_block_children(find_block(missing_ref, "M1V3"))[0]["children"].append(
        {"block_ref": "MISSING_BLOCK_REF_FOR_NEGATIVE_TEST"}
    )
    cases.append(("negative_missing_ref", "V21_UNRESOLVED_BLOCK_REF", missing_ref))

    cycle = copy.deepcopy(base)
    nested_block_children(find_block(cycle, "M2V3")).append({"block_ref": "M1V3"})
    cases.append(("negative_block_cycle", "V21_BLOCK_GRAPH_CYCLE", cycle))

    deleted_counted = copy.deepcopy(base)
    find_node(deleted_counted, "row28_deleted_N04")["contributes_to_cardinality"] = True
    cases.append(("negative_deleted_counted", "V21_DELETED_NODE_CONTRIBUTES", deleted_counted))

    parent_descendant = copy.deepcopy(base)
    parent_descendant.setdefault("sibling_disjointness_groups", []).append(
        {
            "group_id": "negative_parent_descendant_group",
            "parent_fiber": "row28_root",
            "member_node_ids": ["row28_root", "row28_retarded_4a"],
            "source_ref": "negative_test",
            "disjointness_claim": "intentionally_bad_parent_descendant_sum",
        }
    )
    parent_descendant.setdefault("nested_blocks", []).append(
        {
            "block_id": "negative_parent_descendant_sum",
            "block_kind": "sum",
            "claims_disjointness": True,
            "sibling_disjointness_group": "negative_parent_descendant_group",
            "parent_descendant_overlap_forbidden": True,
            "children": [
                {"node_ref": "row28_root"},
                {"node_ref": "row28_retarded_4a"},
            ],
        }
    )
    cases.append(("negative_parent_descendant_sum", "V21_PARENT_DESCENDANT_SUM", parent_descendant))

    return cases


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    positive_inputs = [
        ("positive_fixture_v2", K3_FIXTURE_V2),
        ("positive_k2_regression_v2", K2_REGRESSION_V2),
        ("positive_row25_v2", ROW25_V2),
        ("positive_row22_v2", ROW22_V2),
        ("positive_nested_fixture_v21", NESTED_FIXTURE_V21),
        ("positive_row28_proposal_v21", ROW28_PROPOSAL_V21),
    ]

    artifact_rows: list[dict[str, Any]] = []
    error_rows: list[dict[str, Any]] = []
    positive_ok_count = 0
    warning_codes: set[str] = set()
    for test_id, path in positive_inputs:
        row, issues, _ = validate_path(test_id, path, "pass")
        artifact_rows.append(row)
        error_rows.extend(issues)
        warning_codes.update(issue["code"] for issue in issues if issue["severity"] == "warning")
        if row["schema_ok"] is True:
            positive_ok_count += 1

    negative_rows: list[dict[str, Any]] = []
    negative_ok_count = 0
    negative_input_paths: list[Path] = []
    if NESTED_FIXTURE_V21.exists():
        base = read_json(NESTED_FIXTURE_V21)
        for test_id, expected_error_code, payload in negative_cases(base):
            path = write_negative_input(test_id, payload)
            negative_input_paths.append(path)
            row, issues, error_codes = validate_path(test_id, path, "fail")
            warning_codes.update(issue["code"] for issue in issues if issue["severity"] == "warning")
            expected_seen = expected_error_code in error_codes
            rejected = row["schema_ok"] is False
            verdict = "PASS" if rejected and expected_seen else "FAIL"
            negative_rows.append(
                {
                    "test_id": test_id,
                    "input_path": repo_rel(path),
                    "expected_error_code": expected_error_code,
                    "rejected": rejected,
                    "expected_code_seen": expected_seen,
                    "actual_error_codes": sorted(error_codes),
                    "verdict": verdict,
                }
            )
            error_rows.extend(issues)
            if verdict == "PASS":
                negative_ok_count += 1
    else:
        negative_rows.append(
            {
                "test_id": "negative_suite_not_run",
                "input_path": repo_rel(NESTED_FIXTURE_V21),
                "expected_error_code": "NESTED_FIXTURE_INPUT_MISSING",
                "rejected": False,
                "expected_code_seen": False,
                "actual_error_codes": ["NESTED_FIXTURE_INPUT_MISSING"],
                "verdict": "FAIL",
            }
        )

    positive_pass = positive_ok_count == len(positive_inputs)
    negative_pass = negative_ok_count == 5
    summary = {
        "run_id": RUN_ID,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "source_commit": source_commit(),
        "schema_versions_tested": [
            schema_validator.SCHEMA_V2,
            schema_validator.SCHEMA_V21,
        ],
        "positive_artifact_count": len(positive_inputs),
        "positive_pass_count": positive_ok_count,
        "negative_test_count": 5,
        "negative_pass_count": negative_ok_count,
        "positive_validations_pass": positive_pass,
        "negative_schema_tests_pass": negative_pass,
        "warning_codes": sorted(warning_codes),
        "all_warnings_named": all(bool(code) for code in warning_codes),
        "row28_nested_representation_schema_validated": any(
            row["test_id"] == "positive_row28_proposal_v21" and row["schema_ok"] is True
            for row in artifact_rows
        ),
        "deletion_saturation_hypothesis": "RECORDED_NOT_TESTED",
        "verdict": (
            "HIGH_K_SCHEMA_V2_1_VALIDATION_PASS"
            if positive_pass and negative_pass
            else "HIGH_K_SCHEMA_V2_1_VALIDATION_FAIL"
        ),
        "outputs": {
            "validation_summary": repo_rel(SUMMARY_PATH),
            "artifact_validation_matrix": repo_rel(ARTIFACT_MATRIX_PATH),
            "negative_test_results": repo_rel(NEGATIVE_RESULTS_PATH),
            "schema_validation_errors": repo_rel(ERRORS_PATH),
            "manifest": repo_rel(MANIFEST_PATH),
        },
        "classifications": [
            "HIGH_K_SCHEMA_V2_1_DEFINED",
            "NESTED_EL_SCHEMA_FIELDS_DEFINED",
            "SCHEMA_V2_BACKWARD_COMPATIBILITY_PRESERVED",
            "ROW28_NESTED_REPRESENTATION_SCHEMA_VALIDATED"
            if positive_pass
            else "ROW28_NESTED_REPRESENTATION_SCHEMA_VALIDATION_ATTEMPTED",
            "NEGATIVE_SCHEMA_TESTS_PASS" if negative_pass else "NEGATIVE_SCHEMA_TESTS_FAIL",
            "FORMAT_WARNINGS_NAMED",
            "DELETION_SATURATION_HYPOTHESIS_RECORDED_NOT_TESTED",
            "ROW28_GENERATOR_NOT_STARTED",
            "NO_K3_GENERATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "guardrails": [
            "NO_ROW28_GENERATOR_IMPLEMENTATION",
            "NO_TERMINATION_BY_SATURATION_PROOF",
            "NO_K3_GENERATION",
            "NO_LP",
            "NO_LEAN_BUILD",
            "NO_THEOREM_CHANGE",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }

    write_json(SUMMARY_PATH, summary)
    write_csv(
        ARTIFACT_MATRIX_PATH,
        artifact_rows,
        [
            "test_id",
            "input_path",
            "expected_outcome",
            "schema_version",
            "input_kind",
            "schema_ok",
            "error_count",
            "warning_count",
            "expected_pass",
            "verdict",
        ],
    )
    write_csv(
        NEGATIVE_RESULTS_PATH,
        negative_rows,
        [
            "test_id",
            "input_path",
            "expected_error_code",
            "rejected",
            "expected_code_seen",
            "actual_error_codes",
            "verdict",
        ],
    )
    write_csv(
        ERRORS_PATH,
        error_rows,
        ["test_id", "expected_outcome", "severity", "path", "code", "message"],
    )
    manifest_inputs = [SUMMARY_PATH, ARTIFACT_MATRIX_PATH, NEGATIVE_RESULTS_PATH, ERRORS_PATH] + negative_input_paths
    write_manifest(manifest_inputs)

    print(json.dumps({"verdict": summary["verdict"], "out_dir": repo_rel(OUT_DIR)}, sort_keys=True))
    return 0 if summary["verdict"] == "HIGH_K_SCHEMA_V2_1_VALIDATION_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
