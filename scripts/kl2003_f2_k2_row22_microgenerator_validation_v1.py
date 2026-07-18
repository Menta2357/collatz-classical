#!/usr/bin/env python3
"""Validate the KL2003 F2 k=2 row22 microgenerator artifact.

This is a second-layer validation for the row22 generated data candidate.  It
checks schema-level facts, row22-only scope, parity-lift content, derivation
trace content, and a semantic diff against the manual row22 baseline.  It does
not open Lean, import generated Lean data, solve an LP, generate k=3 data, or
claim any theorem.
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


RUN_ID = "KL2003_F2_K2_ROW22_MICROGENERATOR_VALIDATION_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

ROW22_JSON = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW22_MICROGENERATOR_v1" / "row22.generated.json"
ROW22_TRACE = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW22_MICROGENERATOR_v1" / "row22_derivation_trace.csv"
BASELINE_ROWS = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1" / "expected_rows_v3.csv"
BASELINE_CONSTANTS = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1" / "certificate_constants.csv"
SCHEMA_VALIDATOR = REPO_ROOT / "scripts" / "kl2003_f2_k3_certificate_schema_validator_v1.py"

SUMMARY_PATH = OUT_DIR / "row22_validation_summary.json"
SCHEMA_SUMMARY_PATH = OUT_DIR / "row22_schema_validation_summary.json"
SEMANTIC_DIFF_PATH = OUT_DIR / "row22_semantic_diff.csv"
DECISION_CHECKS_PATH = OUT_DIR / "row22_decision_checks.csv"
MEMBERWISE_HOOK_PATH = OUT_DIR / "row22_memberwise_hook.csv"
TRACE_CHECK_PATH = OUT_DIR / "row22_derivation_trace_check.csv"
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
    "source_class": ["a % 9 = 2"],
    "retarded_child": ["child = 4*a"],
    "retarded_class_transfer_mod9": ["(4*a) % 9 = 8"],
    "advanced_child_arithmetic": ["3*c + 1", "2*a"],
    "advanced_child_mod_three": ["c % 3 = 1"],
    "parity_lift_definition": ["lifted = 2*c"],
    "parity_lift_forward_route": ["2c -> c -> a"],
    "parity_window_transfer": ["concreteWindow (z - 1) (2*c) = concreteWindow z c"],
    "row_shape": ["two-branch", "shiftAlphaMinus2Pad"],
    "slack_reference": ["29/9720"],
}
MEMBERWISE_T_VALUES = list(range(12))


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


def baseline_row22() -> dict[str, str]:
    rows = read_csv(BASELINE_ROWS)
    matches = [row for row in rows if row.get("row_id") == "row22"]
    if len(matches) != 1:
        raise RuntimeError("Expected exactly one row22 baseline row.")
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


def inverse_words_by_id(data: dict[str, Any]) -> dict[str, dict[str, Any]]:
    children = data.get("inverse_words", [])
    if not isinstance(children, list):
        return {}
    return {
        child["child_id"]: child
        for child in children
        if isinstance(child, dict) and isinstance(child.get("child_id"), str)
    }


def row_ids(data: dict[str, Any]) -> list[str]:
    rows = data.get("rows", [])
    if not isinstance(rows, list):
        return []
    return [row.get("row_id") for row in rows if isinstance(row, dict)]


def T(n: int) -> int:
    if n % 2 == 0:
        return n // 2
    return (3 * n + 1) // 2


def tracked_residues_from_artifact(data: dict[str, Any]) -> set[int]:
    residues: set[int] = set()
    classes = data.get("tracked_classes", [])
    if not isinstance(classes, list):
        return residues
    for cls in classes:
        if not isinstance(cls, dict):
            continue
        modulus = cls.get("modulus")
        representative = cls.get("representative")
        if modulus == "9" and isinstance(representative, str) and representative.isdecimal():
            residues.add(int(representative))
    return residues


def is_tracked_by_general_mod9_criterion(n: int, tracked_residues: set[int]) -> bool:
    return n % 9 in tracked_residues


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
        "generation_mode": "rule_derived_row22",
        "mathematical_generation": True,
        "proof_status": "data_candidate_only",
        "scope": "k2_row22_only",
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

    ids = row_ids(data)
    if "row22" not in ids:
        errors.append("row22 missing")
    for forbidden in ["row25", "row28", "M1V3"]:
        if forbidden in ids:
            errors.append(f"forbidden row present: {forbidden}")

    children = inverse_words_by_id(data)
    advanced = children.get("row22_advanced_lifted_2c", {})
    residue_split = advanced.get("residue_split", []) if isinstance(advanced, dict) else []
    split_targets = sorted(
        split.get("target_class")
        for split in residue_split
        if isinstance(split, dict)
    )

    summary = {
        "schema_version": metadata.get("schema_version"),
        "k": metadata.get("k"),
        "generation_mode": metadata.get("generation_mode"),
        "mathematical_generation": metadata.get("mathematical_generation"),
        "proof_status": metadata.get("proof_status"),
        "scope": metadata.get("scope"),
        "json_parseable": True,
        "float_count": float_count,
        "row_count": len(ids),
        "row_ids": ids,
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
        "parity_lift_present": bool(advanced),
        "direct_child_tracked": advanced.get("direct_child_tracked") if isinstance(advanced, dict) else None,
        "lifted_residue_split": split_targets,
        "schema_ok": not errors,
        "error_count": len(errors),
        "errors": errors,
    }
    return summary, errors


def run_external_schema_validator() -> tuple[dict[str, Any], list[str]]:
    """Run the shared schema validator v2 and return its summary."""
    with tempfile.TemporaryDirectory(prefix="kl2003_row22_schema_") as tmp:
        tmp_dir = Path(tmp)
        proc = subprocess.run(
            [
                sys.executable,
                str(SCHEMA_VALIDATOR),
                str(ROW22_JSON),
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
    trace_rows = read_csv(ROW22_TRACE)
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
    row22 = baseline_row22()
    constants = baseline_constants()
    generated_rows = data.get("rows", [])
    generated_row = (
        generated_rows[0]
        if isinstance(generated_rows, list) and len(generated_rows) == 1 and isinstance(generated_rows[0], dict)
        else {}
    )
    generated_constants = constants_by_id(data)
    children = inverse_words_by_id(data)
    retarded = children.get("row22_retarded_4a", {})
    advanced = children.get("row22_advanced_lifted_2c", {})
    advanced_route = advanced.get("forward_route", []) if isinstance(advanced, dict) else []
    route_nodes: list[str] = []
    for item in advanced_route:
        if not isinstance(item, str):
            continue
        parts = [part.replace("*", "") for part in item.split(" -> ")]
        for part in parts:
            if not route_nodes or route_nodes[-1] != part:
                route_nodes.append(part)
    route_text = " -> ".join(route_nodes)
    split_targets = sorted(
        split.get("target_class")
        for split in advanced.get("residue_split", [])
        if isinstance(advanced, dict) and isinstance(split, dict)
    )
    ids = row_ids(data)

    checks: list[tuple[str, Any, Any, str]] = [
        ("row22_only", ["row22"], ids, "artifact contains only row22"),
        ("row25_absent", False, "row25" in ids, "row25 is not generated"),
        ("row28_absent", False, "row28" in ids, "row28 is not generated"),
        ("M1V3_absent", False, "M1V3" in ids, "M1V3 is not generated"),
        ("row_id", "row22", generated_row.get("row_id"), "row22 exists"),
        ("row_shape", row22["expected_shape"], generated_row.get("baseline_expected_shape"), "row22 shape matches baseline"),
        ("source_class", row22["source_class"], generated_row.get("source_class"), "source class matches"),
        ("row_kind", row22["row_family"], generated_row.get("row_kind"), "row family matches"),
        ("parity_lift", True, generated_row.get("parity_lift"), "parity lift is present"),
        (
            "direct_child_not_tracked",
            False,
            generated_row.get("advanced_direct_child_tracked"),
            "direct advanced child is not tracked",
        ),
        ("retarded_formula", "4*a", retarded.get("root_formula"), "retarded branch formula"),
        ("retarded_target_class", "8", retarded.get("target_class"), "retarded class transfer target"),
        ("advanced_direct_formula", "c = 6*t + 1", advanced.get("direct_child_formula"), "direct child formula"),
        ("advanced_direct_tracked", False, advanced.get("direct_child_tracked"), "direct child marked untracked"),
        ("lifted_formula", "2*c = 12*t + 2", advanced.get("root_formula"), "lifted child formula"),
        ("lifted_target_class", "min3_2_5_8", advanced.get("target_class"), "lifted child routes to min3"),
        ("lifted_residue_split", ["2", "5", "8"], split_targets, "lifted residue split"),
        ("parity_route", "2c -> c -> a", route_text, "route 2c -> c -> a is represented"),
        ("advanced_window_policy", "advanced_parity_lift_with_epsilon_pad", advanced.get("window_policy"), "window pad policy"),
        ("c22", constants["c22"]["value"], generated_constants.get("c22", {}).get("value"), "c22 matches baseline"),
        ("c28", constants["c28"]["value"], generated_constants.get("c28", {}).get("value"), "c28 matches baseline"),
        (
            "L2NT_D1_slack",
            constants["L2NT_D1_slack"]["value"],
            generated_constants.get("L2NT_D1_slack", {}).get("value"),
            "row22 slack matches baseline",
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
                "expected": json.dumps(expected, sort_keys=True) if isinstance(expected, list) else str(expected),
                "actual": json.dumps(actual, sort_keys=True) if isinstance(actual, list) else str(actual),
                "status": "pass" if ok else "fail",
                "diff_kind": "MATCH" if ok else "MATH_DIFF",
                "notes": notes,
            }
        )
    return rows_out, failures


def build_memberwise_hook(data: dict[str, Any]) -> tuple[list[dict[str, Any]], list[str]]:
    tracked_residues = tracked_residues_from_artifact(data)
    children = inverse_words_by_id(data)
    advanced = children.get("row22_advanced_lifted_2c", {})
    split_targets = {
        split.get("condition"): split.get("target_class")
        for split in advanced.get("residue_split", [])
        if isinstance(advanced, dict) and isinstance(split, dict)
    }
    expected_by_t_mod = {0: 2, 1: 5, 2: 8}

    rows: list[dict[str, Any]] = []
    failures: list[str] = []
    seen_lifted_classes: set[int] = set()
    for t in MEMBERWISE_T_VALUES:
        a = 9 * t + 2
        c = (2 * a - 1) // 3
        lifted = 2 * c
        t_mod = t % 3
        expected_lifted_mod9 = expected_by_t_mod[t_mod]
        split_condition = f"t % 3 = {t_mod}"
        direct_child_arith_ok = 3 * c + 1 == 2 * a
        direct_child_mod3_ok = c % 3 == 1
        direct_child_tracked = is_tracked_by_general_mod9_criterion(c, tracked_residues)
        t_lifted = T(lifted)
        t_c = T(c)
        route_ok = t_lifted == c and t_c == a
        lifted_mod9 = lifted % 9
        lifted_class_tracked = is_tracked_by_general_mod9_criterion(lifted, tracked_residues)
        split_case_present = split_targets.get(split_condition) == str(expected_lifted_mod9)
        row_ok = (
            a % 9 == 2
            and c == 6 * t + 1
            and direct_child_arith_ok
            and direct_child_mod3_ok
            and not direct_child_tracked
            and route_ok
            and lifted_mod9 == expected_lifted_mod9
            and lifted_class_tracked
            and split_case_present
        )
        if row_ok:
            seen_lifted_classes.add(lifted_mod9)
        else:
            failures.append(f"memberwise_t_{t}")
        rows.append(
            {
                "t": t,
                "a": a,
                "a_mod9": a % 9,
                "c": c,
                "c_formula_ok": c == 6 * t + 1,
                "c_mod3": c % 3,
                "direct_child_arith_ok": direct_child_arith_ok,
                "direct_child_tracked_by_general_criterion": direct_child_tracked,
                "lifted": lifted,
                "T_lifted": t_lifted,
                "T_c": t_c,
                "route_ok": route_ok,
                "t_mod3": t_mod,
                "lifted_mod9": lifted_mod9,
                "expected_lifted_mod9": expected_lifted_mod9,
                "lifted_class_tracked": lifted_class_tracked,
                "split_case_present": split_case_present,
                "status": "pass" if row_ok else "fail",
                "proof_status": "diagnostic_only_not_proof",
                "notes": "member-wise hook for row22 parity lift",
            }
        )

    if seen_lifted_classes != {2, 5, 8}:
        failures.append("memberwise_missing_lifted_class_coverage")
    return rows, failures


def build_decision_checks(
    data: dict[str, Any],
    memberwise_rows: list[dict[str, Any]],
    memberwise_failures: list[str],
) -> tuple[list[dict[str, str]], list[str]]:
    children = inverse_words_by_id(data)
    rows = data.get("rows", [])
    generated_row = rows[0] if isinstance(rows, list) and len(rows) == 1 and isinstance(rows[0], dict) else {}
    advanced = children.get("row22_advanced_lifted_2c", {})
    tracked_residues = tracked_residues_from_artifact(data)

    all_direct_mod3_one = all(row["c_mod3"] == 1 for row in memberwise_rows)
    no_direct_child_tracked = all(
        not row["direct_child_tracked_by_general_criterion"] for row in memberwise_rows
    )
    all_routes_ok = all(row["route_ok"] for row in memberwise_rows)
    all_three_lifted_classes = {
        row["lifted_mod9"] for row in memberwise_rows if row["status"] == "pass"
    } == {2, 5, 8}
    split_targets = sorted(
        split.get("target_class")
        for split in advanced.get("residue_split", [])
        if isinstance(advanced, dict) and isinstance(split, dict)
    )
    exponent_bookkeeping_ok = (
        isinstance(advanced, dict)
        and advanced.get("symbolic_shift") == "shiftAlphaMinus2Pad"
        and advanced.get("window_pad") == "shiftAlphaMinus2Pad = alpha - 2 - epsilon0"
        and advanced.get("window_identity") == "concreteWindow (z - 1) (2*c) = concreteWindow z c"
    )

    raw_checks: list[tuple[str, bool, str, str]] = [
        (
            "decision_A_direct_child_not_tracked",
            isinstance(advanced, dict)
            and advanced.get("direct_child_formula") == "c = 6*t + 1"
            and advanced.get("direct_child_tracked") is False
            and all_direct_mod3_one
            and no_direct_child_tracked
            and tracked_residues == {2, 5, 8},
            "direct c = 6*t+1 has c % 3 = 1 and is outside tracked classes by the artifact's general mod9 criterion",
            "Fail if direct c is treated as tracked or if tracked class criterion is not {2,5,8}.",
        ),
        (
            "decision_B_parity_lift",
            generated_row.get("parity_lift") is True
            and isinstance(advanced, dict)
            and advanced.get("root_formula") == "2*c = 12*t + 2"
            and advanced.get("forward_route") == ["2*c -> c", "c -> a"]
            and all_routes_ok
            and exponent_bookkeeping_ok,
            "lifted = 2*c; T(2c)=c; T(c)=a; alpha - 2 is recorded as (alpha - 1) - 1 with epsilon pad",
            "Fail if parity lift is absent or recorded as an unexplained constant.",
        ),
        (
            "decision_C_lifted_residue_split",
            split_targets == ["2", "5", "8"]
            and all_three_lifted_classes
            and not memberwise_failures,
            "t % 3 cases produce lifted residues 2, 5, and 8, each observed in the hook sample",
            "Fail if any lifted residue arm is missing.",
        ),
    ]

    rows_out: list[dict[str, str]] = []
    failures: list[str] = []
    for check_id, ok, evidence, notes in raw_checks:
        if not ok:
            failures.append(check_id)
        rows_out.append(
            {
                "check_id": check_id,
                "status": "pass" if ok else "fail",
                "evidence": evidence,
                "tracked_residues": json.dumps(sorted(tracked_residues)),
                "memberwise_failures": "; ".join(memberwise_failures),
                "notes": notes,
            }
        )
    return rows_out, failures


def write_manifest(created_at: str, commit: str) -> None:
    paths = [
        SUMMARY_PATH,
        SCHEMA_SUMMARY_PATH,
        SEMANTIC_DIFF_PATH,
        DECISION_CHECKS_PATH,
        MEMBERWISE_HOOK_PATH,
        TRACE_CHECK_PATH,
        REPO_ROOT / "scripts" / "kl2003_f2_k2_row22_microgenerator_validation_v1.py",
        ROW22_JSON,
        ROW22_TRACE,
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
            "notes": "row22 microgenerator validation; no Lean proof",
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
        data = json.loads(ROW22_JSON.read_text(encoding="utf-8"))
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
    memberwise_rows, memberwise_failures = build_memberwise_hook(data)
    decision_checks, decision_failures = build_decision_checks(data, memberwise_rows, memberwise_failures)

    schema_ok = not schema_errors and not parse_errors
    trace_ok = not trace_failures
    semantic_ok = not semantic_failures
    memberwise_ok = not memberwise_failures
    decision_ok = not decision_failures
    verdict = (
        "ROW22_MICROGENERATOR_VALIDATION_PASS"
        if schema_ok and trace_ok and semantic_ok and memberwise_ok and decision_ok
        else "ROW22_MICROGENERATOR_VALIDATION_FAIL"
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
    write_csv(
        DECISION_CHECKS_PATH,
        decision_checks,
        ["check_id", "status", "evidence", "tracked_residues", "memberwise_failures", "notes"],
    )
    write_csv(
        MEMBERWISE_HOOK_PATH,
        memberwise_rows,
        [
            "t",
            "a",
            "a_mod9",
            "c",
            "c_formula_ok",
            "c_mod3",
            "direct_child_arith_ok",
            "direct_child_tracked_by_general_criterion",
            "lifted",
            "T_lifted",
            "T_c",
            "route_ok",
            "t_mod3",
            "lifted_mod9",
            "expected_lifted_mod9",
            "lifted_class_tracked",
            "split_case_present",
            "status",
            "proof_status",
            "notes",
        ],
    )

    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": commit,
        "input_json": repo_rel(ROW22_JSON),
        "schema_ok": schema_ok,
        "trace_ok": trace_ok,
        "semantic_ok": semantic_ok,
        "decision_ok": decision_ok,
        "memberwise_ok": memberwise_ok,
        "schema_error_count": len(schema_errors) + len(parse_errors),
        "trace_failure_count": len(trace_failures),
        "semantic_failure_count": len(semantic_failures),
        "decision_failure_count": len(decision_failures),
        "memberwise_failure_count": len(memberwise_failures),
        "trace_failures": trace_failures,
        "semantic_failures": semantic_failures,
        "decision_failures": decision_failures,
        "memberwise_failures": memberwise_failures,
        "memberwise_sample_count": len(memberwise_rows),
        "memberwise_t_values": MEMBERWISE_T_VALUES,
        "memberwise_lifted_classes_seen": sorted(
            {row["lifted_mod9"] for row in memberwise_rows if row["status"] == "pass"}
        ),
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
            "ROW22_MICROGENERATOR_VALIDATION_CREATED",
            "ROW22_MICROGENERATOR_VALIDATION_PASS" if verdict.endswith("PASS") else verdict,
            "ROW22_DECISION_CHECKS_PASS" if decision_ok else "ROW22_DECISION_CHECKS_FAIL",
            "ROW22_SCHEMA_AND_SEMANTIC_DIFF_CHECKED",
            "PARITY_LIFT_VALIDATED" if verdict.endswith("PASS") else "PARITY_LIFT_VALIDATION_FAILED",
            "ROW22_MEMBERWISE_HOOK_PASS" if memberwise_ok else "ROW22_MEMBERWISE_HOOK_FAIL",
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
    print(f"decision_ok={str(decision_ok).lower()}")
    print(f"memberwise_ok={str(memberwise_ok).lower()}")
    print("parity_lift_validated=" + str(verdict.endswith("PASS")).lower())
    print("no Lean proof, no theorem claim, no k=3 generation, no high-k claim, no global Collatz claim")
    return 0 if verdict == "ROW22_MICROGENERATOR_VALIDATION_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
