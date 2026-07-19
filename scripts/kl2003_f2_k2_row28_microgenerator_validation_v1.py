#!/usr/bin/env python3
"""Validate the k=2 row28 nested-EL microgenerator data candidate.

This layer independently checks the shared v2.1 schema, V3 nested shape,
Figure A1 diff, derivation trace, and finite member-wise c/cPrime routes.  It
does not import generated Lean data or turn diagnostics into a proof.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K2_ROW28_MICROGENERATOR_VALIDATION_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

GEN_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW28_MICROGENERATOR_v1"
ROW28_JSON = GEN_DIR / "row28.generated.json"
ROW28_TRACE = GEN_DIR / "row28_derivation_trace.csv"
ROW28_DIFF = GEN_DIR / "row28_vs_baseline_diff.csv"
ROW28_FIGURE_DIFF = GEN_DIR / "row28_tree_diff_against_figure_a1.csv"
BASELINE_ROWS = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1" / "expected_rows_v3.csv"
BASELINE_CONSTANTS = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1" / "certificate_constants.csv"
SCHEMA_VALIDATOR = REPO_ROOT / "scripts" / "kl2003_f2_k3_certificate_schema_validator_v1.py"

SUMMARY_PATH = OUT_DIR / "row28_validation_summary.json"
SCHEMA_SUMMARY_PATH = OUT_DIR / "row28_schema_validation_summary.json"
SEMANTIC_PATH = OUT_DIR / "row28_semantic_diff.csv"
TRACE_PATH = OUT_DIR / "row28_trace_check.csv"
DECISION_PATH = OUT_DIR / "row28_decision_checks.csv"
MEMBERWISE_PATH = OUT_DIR / "row28_memberwise_hook.csv"
FIGURE_PATH = OUT_DIR / "row28_figure_a1_check.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

REQUIRED_TRACE_TOKENS = {
    "source_class": ["a % 9 = 8"],
    "retarded_child": ["class 5", "shift -2"],
    "advanced_child": ["c = 6*t + 5", "3*c + 1 = 2*a"],
    "c_split_mod5": ["c % 9 = 5"],
    "c_split_mod2": ["c % 9 = 2"],
    "c_split_mod8": ["c % 9 = 8"],
    "cprime_definition": ["3*cPrime + 1 = 2*c"],
    "cprime_split_mod2": ["cPrime % 9 = 2"],
    "cprime_split_mod5": ["cPrime % 9 = 5"],
    "cprime_split_mod8": ["cPrime % 9 = 8"],
    "m2v3_shape": ["min3(phi22, phi25, phi28)"],
    "m1v3_shape": ["min(phi28 + M2V3, phi25)"],
    "deletion_saturation": ["G04", "G10"],
    "slack_reference": ["2077/145800"],
}
MEMBERWISE_T_VALUES = list(range(30))


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


def T(n: int) -> int:
    return n // 2 if n % 2 == 0 else (3 * n + 1) // 2


def expected_c_mod9(t_mod3: int) -> int:
    return {0: 5, 1: 2, 2: 8}[t_mod3]


def expected_cprime_mod9(u_mod3: int) -> int:
    return {0: 2, 1: 5, 2: 8}[u_mod3]


def run_external_schema_validator() -> tuple[dict[str, Any], list[str]]:
    with tempfile.TemporaryDirectory(prefix="kl2003_row28_schema_") as tmp:
        proc = subprocess.run(
            [
                sys.executable,
                str(SCHEMA_VALIDATOR),
                str(ROW28_JSON),
                "--out-dir",
                tmp,
            ],
            cwd=REPO_ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        summary_path = Path(tmp) / "schema_validation_summary.json"
        if proc.returncode != 0 or not summary_path.exists():
            return {
                "schema_ok": False,
                "returncode": proc.returncode,
                "stdout": proc.stdout,
                "stderr": proc.stderr,
            }, ["external_schema_validator_failed"]
        summary = json.loads(summary_path.read_text(encoding="utf-8"))
        failures = [] if summary.get("schema_ok") else ["external_schema_validator_schema_not_ok"]
        if summary.get("schema_version") != SCHEMA_VERSION:
            failures.append("schema_version_not_v2_1")
        unexpected_warnings = set(summary.get("warning_codes", [])) - {"EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED"}
        if unexpected_warnings:
            failures.append("unexpected_schema_warnings:" + ",".join(sorted(unexpected_warnings)))
        return summary, failures


def check_trace() -> tuple[list[dict[str, str]], list[str]]:
    by_step = {row["step_id"]: row for row in read_csv(ROW28_TRACE)}
    rows: list[dict[str, str]] = []
    failures: list[str] = []
    for step_id, tokens in REQUIRED_TRACE_TOKENS.items():
        record = by_step.get(step_id)
        text = json.dumps(record, sort_keys=True) if record else ""
        missing = [token for token in tokens if token not in text]
        passed = record is not None and not missing
        if not passed:
            failures.append(step_id)
        rows.append(
            {
                "step_id": step_id,
                "required_tokens": "; ".join(tokens),
                "present": "yes" if record else "no",
                "missing_tokens": "; ".join(missing),
                "status": "pass" if passed else "fail",
                "notes": "Rule-derived trace token check.",
            }
        )
    return rows, failures


def check_semantics(data: dict[str, Any]) -> tuple[list[dict[str, str]], list[str]]:
    baseline_rows = {row["row_id"]: row for row in read_csv(BASELINE_ROWS)}
    baseline_constants = {row["constant_id"]: row for row in read_csv(BASELINE_CONSTANTS)}
    generated_rows = data.get("rows", [])
    row = generated_rows[0] if isinstance(generated_rows, list) and len(generated_rows) == 1 else {}
    blocks = {
        block.get("block_id"): block
        for block in data.get("nested_blocks", [])
        if isinstance(block, dict)
    }
    constants = {
        item.get("coefficient_id"): item
        for item in data.get("rational_certificate", {}).get("coefficient_intervals", [])
        if isinstance(item, dict)
    }
    deleted = sorted(
        node.get("figure_node_id")
        for node in data.get("nodes", [])
        if isinstance(node, dict) and node.get("node_status") == "deleted"
    )
    m1_children = blocks.get("M1V3", {}).get("children", [])
    m1_second = m1_children[1] if isinstance(m1_children, list) and len(m1_children) > 1 else {}
    m2_children = blocks.get("M2V3", {}).get("children", [])
    m2_components = [child.get("component") for child in m2_children if isinstance(child, dict)]
    top_ids = [item.get("row_id") for item in generated_rows if isinstance(item, dict)]
    sibling_groups = data.get("sibling_disjointness_groups", [])
    siblings = sibling_groups[0].get("member_node_ids", []) if sibling_groups else []

    checks: list[tuple[str, Any, Any, str]] = [
        ("row28_only", ["row28"], top_ids, "M1V3 is nested, not a top-level row"),
        ("source_class", baseline_rows["row28"]["source_class"], row.get("source_class"), "manual V3 oracle"),
        ("row_shape", baseline_rows["row28"]["expected_shape"], row.get("baseline_expected_shape"), "manual V3 oracle"),
        ("required_feature", baseline_rows["row28"]["required_feature"], row.get("required_feature"), "cPrime/post-deletion"),
        ("m1_second_arm", "phi25", m1_second.get("component"), "source-faithful V3"),
        ("m2_components", ["phi22", "phi25", "phi28"], m2_components, "depth-3 min3"),
        ("deleted_figure_nodes", ["N04", "N05"], deleted, "Figure A1 oracle"),
        (
            "post_deletion_siblings",
            ["row28_cprime_mod8_phi28", "row28_four_c_mod5_phi25"],
            siblings,
            "only sibling fibers are summed",
        ),
        ("lambda", baseline_constants["lambda"]["value"], constants.get("lambda", {}).get("value"), "baseline constant"),
        ("DeltaV2", baseline_constants["DeltaV2"]["value"], constants.get("DeltaV2", {}).get("value"), "baseline constant"),
        ("c25", baseline_constants["c25"]["value"], constants.get("c25", {}).get("value"), "phi25 coefficient"),
        ("c28", baseline_constants["c28"]["value"], constants.get("c28", {}).get("value"), "row28 coefficient"),
        (
            "D3_slack",
            baseline_constants["L2NT_D3_slack"]["value"],
            constants.get("L2NT_D3_slack", {}).get("value"),
            "D3 regression target",
        ),
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


def check_figure_diff() -> tuple[list[dict[str, str]], list[str]]:
    rows = read_csv(ROW28_FIGURE_DIFF)
    failures = [
        f"{row.get('diff_kind')}:{row.get('signature')}"
        for row in rows
        if row.get("status") != "match"
    ]
    return rows, failures


def build_memberwise_hook() -> tuple[list[dict[str, Any]], list[str]]:
    rows: list[dict[str, Any]] = []
    failures: list[str] = []
    for t in MEMBERWISE_T_VALUES:
        a = 9 * t + 8
        c = 6 * t + 5
        c_mod9 = c % 9
        c_expected = expected_c_mod9(t % 3)
        direct_route_ok = 3 * c + 1 == 2 * a and T(c) == a
        repeated = c_mod9 == 8
        cprime = ""
        cprime_mod9 = ""
        cprime_expected = ""
        cprime_route_ok = True
        counted_populations: list[int] = [c]
        parent_counted = not repeated
        sibling_route_ok = True
        branch = f"c_mod{c_mod9}"

        if repeated:
            u = (t - 2) // 3
            numerator = 2 * c - 1
            cprime_value = numerator // 3
            cprime = cprime_value
            cprime_mod9 = cprime_value % 9
            cprime_expected = expected_cprime_mod9(u % 3)
            cprime_route_ok = numerator % 3 == 0 and 3 * cprime_value + 1 == 2 * c and T(cprime_value) == c
            branch = f"c_mod8_cprime_mod{cprime_mod9}"
            parent_counted = False
            if cprime_mod9 == 2:
                counted_populations = [cprime_value]
            elif cprime_mod9 == 5:
                counted_populations = [4 * cprime_value]
                sibling_route_ok = (4 * cprime_value) % 9 == 2 and T(T(4 * cprime_value)) == cprime_value
            else:
                counted_populations = [cprime_value, 4 * c]
                sibling_route_ok = (
                    cprime_value % 9 == 8
                    and (4 * c) % 9 == 5
                    and T(cprime_value) == c
                    and T(T(4 * c)) == c
                    and cprime_value != 4 * c
                )

        parent_descendant_double_count = repeated and c in counted_populations
        passed = (
            a % 9 == 8
            and c_mod9 == c_expected
            and direct_route_ok
            and cprime_route_ok
            and (not repeated or cprime_mod9 == cprime_expected)
            and sibling_route_ok
            and not parent_descendant_double_count
        )
        if not passed:
            failures.append(f"t={t}:{branch}")
        rows.append(
            {
                "t": t,
                "a": a,
                "a_mod9": a % 9,
                "c": c,
                "c_mod9": c_mod9,
                "expected_c_mod9": c_expected,
                "direct_route_ok": direct_route_ok,
                "repeated_class8": repeated,
                "cprime": cprime,
                "cprime_mod9": cprime_mod9,
                "expected_cprime_mod9": cprime_expected,
                "cprime_route_ok": cprime_route_ok,
                "branch": branch,
                "counted_populations": counted_populations,
                "deleted_parent_counted": parent_counted if repeated else False,
                "sibling_route_ok": sibling_route_ok,
                "parent_descendant_double_count": parent_descendant_double_count,
                "status": "pass" if passed else "fail",
                "diagnostic_only": True,
                "not_part_of_logical_base": True,
            }
        )
    return rows, failures


def build_decision_checks(
    data: dict[str, Any],
    memberwise_rows: list[dict[str, Any]],
    memberwise_failures: list[str],
) -> tuple[list[dict[str, str]], list[str]]:
    direct_classes = {row["c_mod9"] for row in memberwise_rows if row["status"] == "pass"}
    cprime_classes = {
        row["cprime_mod9"]
        for row in memberwise_rows
        if row["status"] == "pass" and row["repeated_class8"]
    }
    repeated_rows = [row for row in memberwise_rows if row["repeated_class8"]]
    blocks = {block["block_id"]: block for block in data.get("nested_blocks", [])}
    m1_second = blocks.get("M1V3", {}).get("children", [{}, {}])[1]
    deleted_nodes = [node for node in data.get("nodes", []) if node.get("node_status") == "deleted"]
    raw = [
        (
            "decision_A_direct_c_split",
            direct_classes == {2, 5, 8},
            f"observed direct classes {sorted(direct_classes)}",
        ),
        (
            "decision_B_repeated_cprime_split",
            cprime_classes == {2, 5, 8},
            f"observed cPrime classes {sorted(cprime_classes)}",
        ),
        (
            "decision_C_phi25_meta_errata",
            m1_second.get("component") == "phi25",
            f"M1V3 second arm = {m1_second.get('component')}",
        ),
        (
            "decision_D_deletion_excludes_parents",
            len(deleted_nodes) == 2
            and all(node.get("contributes_to_cardinality") is False for node in deleted_nodes)
            and all(not row["deleted_parent_counted"] for row in repeated_rows),
            "two deleted tree nodes contribute false; repeated class-8 parent omitted member-wise",
        ),
        (
            "decision_E_sibling_sum_only",
            all(row["sibling_route_ok"] and not row["parent_descendant_double_count"] for row in repeated_rows)
            and not memberwise_failures,
            "all repeated branches use valid child/sibling routes without parent-descendant sums",
        ),
    ]
    rows: list[dict[str, str]] = []
    failures: list[str] = []
    for check_id, passed, evidence in raw:
        if not passed:
            failures.append(check_id)
        rows.append(
            {
                "check_id": check_id,
                "status": "pass" if passed else "fail",
                "evidence": evidence,
                "memberwise_failures": "; ".join(memberwise_failures),
                "notes": "Decision check is diagnostic; future Lean verifier remains authoritative.",
            }
        )
    return rows, failures


def write_manifest(created_at: str, commit: str) -> None:
    paths = [
        SUMMARY_PATH,
        SCHEMA_SUMMARY_PATH,
        SEMANTIC_PATH,
        TRACE_PATH,
        DECISION_PATH,
        MEMBERWISE_PATH,
        FIGURE_PATH,
        REPO_ROOT / "scripts" / "kl2003_f2_k2_row28_microgenerator_validation_v1.py",
        ROW28_JSON,
        ROW28_TRACE,
        ROW28_DIFF,
        ROW28_FIGURE_DIFF,
        BASELINE_ROWS,
        BASELINE_CONSTANTS,
    ]
    write_csv(
        MANIFEST_PATH,
        [
            {
                "path": repo_rel(path),
                "sha256": sha256(path) if path.exists() and path.is_file() else "MISSING",
                "artifact_kind": "validation_output" if path.parent == OUT_DIR else "validation_input",
                "created_at": created_at,
                "source_commit": commit,
                "notes": "row28 microgenerator validation; no Lean proof",
            }
            for path in paths
        ],
        ["path", "sha256", "artifact_kind", "created_at", "source_commit", "notes"],
    )


def main() -> int:
    created_at = datetime.now(timezone.utc).isoformat()
    commit = source_commit()
    try:
        data = json.loads(ROW28_JSON.read_text(encoding="utf-8"))
        parse_failures: list[str] = []
    except (FileNotFoundError, json.JSONDecodeError) as exc:
        data = {}
        parse_failures = [str(exc)]

    schema_summary, schema_failures = run_external_schema_validator() if not parse_failures else ({}, parse_failures)
    trace_rows, trace_failures = check_trace()
    semantic_rows, semantic_failures = check_semantics(data)
    figure_rows, figure_failures = check_figure_diff()
    memberwise_rows, memberwise_failures = build_memberwise_hook()
    decision_rows, decision_failures = build_decision_checks(data, memberwise_rows, memberwise_failures)

    schema_ok = not parse_failures and not schema_failures
    trace_ok = not trace_failures
    semantic_ok = not semantic_failures
    figure_ok = not figure_failures
    memberwise_ok = not memberwise_failures
    decision_ok = not decision_failures
    passed = schema_ok and trace_ok and semantic_ok and figure_ok and memberwise_ok and decision_ok
    verdict = "ROW28_MICROGENERATOR_VALIDATION_PASS" if passed else "ROW28_MICROGENERATOR_VALIDATION_FAIL"

    write_json(
        SCHEMA_SUMMARY_PATH,
        {
            "input": repo_rel(ROW28_JSON),
            "schema_ok": schema_ok,
            "schema_version": schema_summary.get("schema_version"),
            "external_verdict": schema_summary.get("verdict"),
            "error_count": schema_summary.get("error_count", len(schema_failures)),
            "warning_count": schema_summary.get("warning_count", 0),
            "warning_codes": schema_summary.get("warning_codes", []),
            "known_warning_policy": schema_summary.get("known_warning_policy", {}),
            "failures": schema_failures + parse_failures,
        },
    )
    write_csv(
        TRACE_PATH,
        trace_rows,
        ["step_id", "required_tokens", "present", "missing_tokens", "status", "notes"],
    )
    write_csv(
        SEMANTIC_PATH,
        semantic_rows,
        ["check_id", "expected", "actual", "status", "diff_kind", "notes"],
    )
    write_csv(
        FIGURE_PATH,
        figure_rows,
        ["diff_kind", "direction", "signature", "status"],
    )
    write_csv(
        DECISION_PATH,
        decision_rows,
        ["check_id", "status", "evidence", "memberwise_failures", "notes"],
    )
    write_csv(
        MEMBERWISE_PATH,
        memberwise_rows,
        [
            "t",
            "a",
            "a_mod9",
            "c",
            "c_mod9",
            "expected_c_mod9",
            "direct_route_ok",
            "repeated_class8",
            "cprime",
            "cprime_mod9",
            "expected_cprime_mod9",
            "cprime_route_ok",
            "branch",
            "counted_populations",
            "deleted_parent_counted",
            "sibling_route_ok",
            "parent_descendant_double_count",
            "status",
            "diagnostic_only",
            "not_part_of_logical_base",
        ],
    )
    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": commit,
        "input_json": repo_rel(ROW28_JSON),
        "schema_ok": schema_ok,
        "trace_ok": trace_ok,
        "semantic_ok": semantic_ok,
        "figure_a1_ok": figure_ok,
        "decision_ok": decision_ok,
        "memberwise_ok": memberwise_ok,
        "schema_failures": schema_failures + parse_failures,
        "trace_failures": trace_failures,
        "semantic_failures": semantic_failures,
        "figure_failures": figure_failures,
        "decision_failures": decision_failures,
        "memberwise_failures": memberwise_failures,
        "memberwise_sample_count": len(memberwise_rows),
        "direct_c_classes_seen": sorted({row["c_mod9"] for row in memberwise_rows}),
        "cprime_classes_seen": sorted(
            {row["cprime_mod9"] for row in memberwise_rows if row["repeated_class8"]}
        ),
        "verdict": verdict,
        "guardrails": [
            "DATA_CANDIDATE_ONLY",
            "DIAGNOSTIC_MEMBERWISE_HOOK_ONLY",
            "NO_LEAN_PROOF",
            "NO_K3_GENERATION",
            "NO_LP_SOLVED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "classifications": [
            "ROW28_MICROGENERATOR_VALIDATION_CREATED",
            verdict,
            "ROW28_SCHEMA_V21_PASS" if schema_ok else "ROW28_SCHEMA_V21_FAIL",
            "ROW28_SEMANTIC_DIFF_PASS" if semantic_ok else "ROW28_SEMANTIC_DIFF_FAIL",
            "FIGURE_A1_TREE_DIFF_PASS" if figure_ok else "FIGURE_A1_TREE_DIFF_FAIL",
            "ROW28_DECISION_CHECKS_PASS" if decision_ok else "ROW28_DECISION_CHECKS_FAIL",
            "ROW28_MEMBERWISE_HOOK_PASS" if memberwise_ok else "ROW28_MEMBERWISE_HOOK_FAIL",
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
    print(f"figure_a1_ok={str(figure_ok).lower()}")
    print(f"decision_ok={str(decision_ok).lower()}")
    print(f"memberwise_ok={str(memberwise_ok).lower()}")
    print(f"memberwise_sample_count={len(memberwise_rows)}")
    print("no Lean proof, no k=3 generation, no high-k/global claim")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
