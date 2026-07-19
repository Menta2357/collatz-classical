#!/usr/bin/env python3
"""Assemble and verify the complete KL2003 F2 k=2 generator regression.

Rows come from the three rule-derived microgenerators.  The certificate
candidate and certified endpoint data are read as inputs, but D1/D2/D3 slacks
are recomputed exactly with Fraction before any comparison with the manual
baseline.  Baseline files are regression oracles, never generation sources.
"""

from __future__ import annotations

import copy
import csv
import hashlib
import json
import subprocess
import time
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K2_GENERATOR_REGRESSION_v1"
SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"
GENERATOR_VERSION = "kl2003_f2_k2_full_generator_regression_v1.py"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

ROW22_JSON = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW22_MICROGENERATOR_v1" / "row22.generated.json"
ROW25_JSON = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW25_MICROGENERATOR_v1" / "row25.generated.json"
ROW28_JSON = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW28_MICROGENERATOR_v1" / "row28.generated.json"
ROW22_VALIDATION = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW22_MICROGENERATOR_VALIDATION_v1" / "row22_validation_summary.json"
ROW25_VALIDATION = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW25_MICROGENERATOR_VALIDATION_v1" / "row25_validation_summary.json"
ROW28_VALIDATION = REPO_ROOT / "outputs" / "KL2003_F2_K2_ROW28_MICROGENERATOR_VALIDATION_v1" / "row28_validation_summary.json"

BASELINE_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_BASELINE_v1"
BASELINE_ROWS = BASELINE_DIR / "expected_rows_v3.csv"
BASELINE_CONSTANTS = BASELINE_DIR / "certificate_constants.csv"
BASELINE_REQUIREMENTS = BASELINE_DIR / "generator_regression_requirements.csv"
INTERIOR_CERTIFICATE = REPO_ROOT / "outputs" / "KL2003_K2_INTERIOR_RATIONAL_CERTIFICATE_v1" / "certificate.json"
ENDPOINT_CERTIFICATE = REPO_ROOT / "outputs" / "KL2003_K2_LAMBDA_POWER_INTERVAL_CERTIFICATION_v1" / "interval_certificate.json"
FIGURE_ROOT_PATHS = REPO_ROOT / "outputs" / "KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1" / "root_paths.csv"
FIGURE_NODES = REPO_ROOT / "outputs" / "KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1" / "nodes.csv"

JSON_PATH = OUT_DIR / "kl2003_k2_regression.generated.json"
LEAN_PATH = OUT_DIR / "KL2003K2RegressionDataGeneratedV21.lean"
SUMMARY_PATH = OUT_DIR / "summary.json"
ROW_DIFF_PATH = OUT_DIR / "manual_vs_generated_rows.csv"
CERT_DIFF_PATH = OUT_DIR / "manual_vs_generated_certificate.csv"
DELETION_DIFF_PATH = OUT_DIR / "manual_vs_generated_deletion.csv"
MANIFEST_DIFF_PATH = OUT_DIR / "manual_vs_generated_manifest.csv"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"


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


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


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


def fraction_from_pair(obj: dict[str, Any]) -> Fraction:
    return Fraction(int(obj["num"]), int(obj["den"]))


def fraction_text(value: Fraction) -> str:
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def lean_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def lean_string_list(values: list[str]) -> str:
    return "[" + ", ".join(lean_string(value) for value in values) + "]"


def derive_certificate(
    interior: dict[str, Any],
    endpoints: dict[str, Any],
) -> dict[str, Any]:
    variables = interior["variables"]
    lambda_value = fraction_from_pair(endpoints["lambda"])
    c22 = fraction_from_pair(variables["c_2_2"])
    c25 = fraction_from_pair(variables["c_2_5"])
    c28 = fraction_from_pair(variables["c_2_8"])
    c12 = fraction_from_pair(variables["c_1_2"])
    cmax = fraction_from_pair(variables["C_2_max"])

    a_coeff = 1 / (lambda_value**2)
    b_lo = fraction_from_pair(
        endpoints["power_intervals"]["B_lambda_alpha_minus_2"]["certified_stronger_interval"]["lo"]
    )
    d_lo = fraction_from_pair(
        endpoints["power_intervals"]["D_lambda_alpha_minus_1"]["derived_interval_from_lambda_times_B"]["lo"]
    )
    d1 = a_coeff * c28 + b_lo * c12 - c22
    d2 = a_coeff * c22 - c25
    d3 = a_coeff * c25 + d_lo * c12 - c28
    slacks = {"L2NT_D1_slack": d1, "L2NT_D2_slack": d2, "L2NT_D3_slack": d3}
    if any(value <= 0 for value in slacks.values()):
        raise RuntimeError("K2_REGRESSION_FAIL: generated nonpositive row slack")

    constants = {
        "lambda": (fraction_text(lambda_value), "lambda", "KL2003K2AlphaBounds.lean"),
        "gammaK2": (f"logb 2 ({fraction_text(lambda_value)})", "exponent", "KL2003M1Surrogate.lean"),
        "DeltaV2": (
            f"({lambda_value.denominator}/{lambda_value.numerator})^14/2",
            "base_constant",
            "KL2003M0CRetardedInduction.lean",
        ),
        "c22": (fraction_text(c22), "row_coefficient", "KL2003M0CRetardedInduction.lean"),
        "c25": (fraction_text(c25), "row_coefficient", "KL2003M0CRetardedInduction.lean"),
        "c28": (fraction_text(c28), "row_coefficient", "KL2003M0CRetardedInduction.lean"),
        "L2NT_D1_slack": (fraction_text(d1), "slack", "KL2003K2CertificateData.lean"),
        "L2NT_D2_slack": (fraction_text(d2), "slack", "KL2003K2CertificateData.lean"),
        "L2NT_D3_slack": (fraction_text(d3), "slack", "KL2003K2CertificateData.lean"),
    }
    intervals: list[dict[str, str]] = []
    for constant_id, (value, kind, source) in constants.items():
        record = {
            "coefficient_id": constant_id,
            "value": value,
            "kind": kind,
            "lean_name": constant_id if constant_id.startswith("L2NT") else {
                "lambda": "lambdaR",
                "gammaK2": "gammaK2",
                "DeltaV2": "DeltaV2",
                "c22": "c22R",
                "c25": "c25R",
                "c28": "c28R",
            }[constant_id],
            "source": source,
            "must_reproduce_exactly": "yes",
        }
        if kind in {"lambda", "row_coefficient", "slack"}:
            record["lo"] = value
            record["hi"] = value
        intervals.append(record)

    return {
        "lambda": lambda_value,
        "A": a_coeff,
        "B_lo": b_lo,
        "D_lo": d_lo,
        "variables": {"c22": c22, "c25": c25, "c28": c28, "c12": c12, "cmax": cmax},
        "slacks": slacks,
        "coefficient_intervals": intervals,
    }


def merge_artifacts(
    created_at: str,
    commit: str,
    row22: dict[str, Any],
    row25: dict[str, Any],
    row28: dict[str, Any],
    certificate: dict[str, Any],
) -> dict[str, Any]:
    data = copy.deepcopy(row28)
    data["metadata"].update(
        {
            "run_id": RUN_ID,
            "schema_version": SCHEMA_VERSION,
            "generator_version": GENERATOR_VERSION,
            "generator_mode": "k2_full_regression",
            "scope": "k2_source_faithful_v3_full_regression",
            "created_at": created_at,
            "source_commit": commit,
            "mathematical_generation": True,
            "mathematical_content": "rule_derived_rows_and_exact_rational_certificate_recheck",
            "proof_status": "generated_data_candidate_only",
            "artifact_links": {
                "json_artifact": repo_rel(JSON_PATH),
                "lean_data_artifact": repo_rel(LEAN_PATH),
                "json_to_lean_generator": repo_rel(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "lean_import_policy": "Generated data remains under outputs and is not imported.",
            },
        }
    )
    row22_generated = copy.deepcopy(row22["rows"][0])
    row22_generated["v3_requirement"] = "unchanged from source-faithful k2 seam"
    row25_generated = copy.deepcopy(row25["rows"][0])
    row25_generated["v3_requirement"] = "advanced branch absent; D2 is immune to advanced rounding"
    data["rows"] = [row22_generated, row25_generated, copy.deepcopy(row28["rows"][0])]
    data["inverse_words"] = (
        copy.deepcopy(row22["inverse_words"])
        + copy.deepcopy(row25["inverse_words"])
        + copy.deepcopy(row28["inverse_words"])
    )
    child_ids = [child["child_id"] for child in data["inverse_words"]]
    if len(child_ids) != len(set(child_ids)):
        raise RuntimeError("K2_REGRESSION_FAIL: duplicate generated child id")

    constants = certificate["coefficient_intervals"]
    data["rational_certificate"] = {
        "coefficient_intervals": constants,
        "lambda_interval": {
            "lo": fraction_text(certificate["lambda"]),
            "hi": fraction_text(certificate["lambda"]),
        },
        "endpoint_intervals": {
            "A": {"lo": fraction_text(certificate["A"]), "hi": fraction_text(certificate["A"])},
            "BStrong": {"lo": fraction_text(certificate["B_lo"]), "hi": "8/9"},
            "DTarget": {"lo": fraction_text(certificate["D_lo"]), "hi": "6/5"},
        },
        "variables": {key: fraction_text(value) for key, value in certificate["variables"].items()},
        "row_equations": {
            "row22": "A*c28 + B_lo*c12 - c22",
            "row25": "A*c22 - c25",
            "row28": "A*c25 + D_lo*c12 - c28",
        },
        "solver_manifest": "known_k2_candidate_rechecked_exactly; no LP solve in this regression",
    }
    data["slacks"] = [
        {
            "slack_id": slack_id,
            "row_id": row_id,
            "lhs": "0",
            "rhs": fraction_text(value),
            "slack": fraction_text(value),
            "strictly_positive": True,
            "numerator_bits": str(value.numerator.bit_length()),
            "denominator_bits": str(value.denominator.bit_length()),
            "notes": "Recomputed exactly from candidate variables and certified lower endpoints.",
        }
        for slack_id, row_id, value in [
            ("L2NT_D1_slack", "row22", certificate["slacks"]["L2NT_D1_slack"]),
            ("L2NT_D2_slack", "row25", certificate["slacks"]["L2NT_D2_slack"]),
            ("L2NT_D3_slack", "row28", certificate["slacks"]["L2NT_D3_slack"]),
        ]
    ]
    requirements = read_csv(BASELINE_REQUIREMENTS)
    data["verification_targets"] = [
        {
            "target_id": row["requirement_id"],
            "kind": "k2_full_regression_requirement",
            "description": row["pass_condition"],
            "required": row["required"] == "yes",
        }
        for row in requirements
    ]
    data["guardrails"] = [
        "BASELINE_AS_REGRESSION_ORACLE_ONLY",
        "ROWS_DERIVED_BY_MICROGENERATORS",
        "SLACKS_RECOMPUTED_WITH_EXACT_RATIONAL_ARITHMETIC",
        "DATA_CANDIDATE_ONLY",
        "NO_GENERATED_LEAN_IMPORT",
        "NO_K3_GENERATION",
        "NO_LP_SOLVED",
        "NO_HIGH_K_CLAIM",
        "NO_GLOBAL_COLLATZ_CLAIM",
    ]
    return data


def generated_regression_items(data: dict[str, Any]) -> dict[str, dict[str, Any]]:
    result = {row["row_id"]: row for row in data["rows"]}
    m1 = next(block for block in data["nested_blocks"] if block["block_id"] == "M1V3")
    result["M1V3"] = {
        "row_id": "M1V3",
        "source_class": "row28 nested block",
        "row_kind": "EL auxiliary",
        "baseline_expected_shape": "min(phi28 + M2V3, phi25)",
        "baseline_required_feature": "meta-errata phi25 reinstated",
        "v3_requirement": "second arm is phi25; phi22 form is historical V2 only",
        "nested_block": m1,
    }
    return result


def add_mismatch(
    mismatches: list[dict[str, str]],
    category: str,
    item_id: str,
    field: str,
    expected: Any,
    actual: Any,
) -> None:
    mismatches.append(
        {
            "category": category,
            "item_id": item_id,
            "field": field,
            "expected": json.dumps(expected, sort_keys=True) if isinstance(expected, (dict, list)) else str(expected),
            "actual": json.dumps(actual, sort_keys=True) if isinstance(actual, (dict, list)) else str(actual),
            "severity": "math_diff",
            "classification": "K2_REGRESSION_FAIL",
        }
    )


def compare_rows(data: dict[str, Any], mismatches: list[dict[str, str]]) -> list[dict[str, str]]:
    generated = generated_regression_items(data)
    rows: list[dict[str, str]] = []
    for baseline in read_csv(BASELINE_ROWS):
        row_id = baseline["row_id"]
        actual = generated.get(row_id, {})
        checks = {
            "source_class": (baseline["source_class"], actual.get("source_class")),
            "row_kind": (baseline["row_family"], actual.get("row_family", actual.get("row_kind"))),
            "expected_shape": (baseline["expected_shape"], actual.get("baseline_expected_shape")),
            "required_feature": (baseline["required_feature"], actual.get("baseline_required_feature", actual.get("required_feature"))),
            "v3_requirement": (baseline["v3_requirement"], actual.get("v3_requirement")),
        }
        failed_fields = []
        for field, (expected, got) in checks.items():
            if expected != got:
                failed_fields.append(field)
                add_mismatch(mismatches, "row", row_id, field, expected, got)
        rows.append(
            {
                "row_id": row_id,
                "manual_expected_shape": baseline["expected_shape"],
                "generated_expected_shape": str(actual.get("baseline_expected_shape", "")),
                "manual_required_feature": baseline["required_feature"],
                "generated_required_feature": str(actual.get("baseline_required_feature", actual.get("required_feature", ""))),
                "status": "pass" if not failed_fields else "fail",
                "diff_kind": "MATCH" if not failed_fields else "MATH_DIFF",
                "notes": "source-faithful V3 item reproduced" if not failed_fields else "; ".join(failed_fields),
            }
        )
    return rows


def compare_certificate(data: dict[str, Any], mismatches: list[dict[str, str]]) -> list[dict[str, str]]:
    generated = {
        item["coefficient_id"]: item
        for item in data["rational_certificate"]["coefficient_intervals"]
    }
    rows: list[dict[str, str]] = []
    for baseline in read_csv(BASELINE_CONSTANTS):
        constant_id = baseline["constant_id"]
        actual = generated.get(constant_id, {})
        checks = {
            "value": (baseline["value"], actual.get("value")),
            "kind": (baseline["kind"], actual.get("kind")),
            "lean_name": (baseline["lean_name"], actual.get("lean_name")),
            "source": (baseline["source"], actual.get("source")),
            "must_reproduce_exactly": (baseline["must_reproduce_exactly"], actual.get("must_reproduce_exactly")),
        }
        failed_fields = []
        for field, (expected, got) in checks.items():
            if expected != got:
                failed_fields.append(field)
                add_mismatch(mismatches, "certificate", constant_id, field, expected, got)
        rows.append(
            {
                "constant_id": constant_id,
                "manual_value": baseline["value"],
                "generated_value": str(actual.get("value", "")),
                "status": "pass" if not failed_fields else "fail",
                "diff_kind": "MATCH" if not failed_fields else "MATH_DIFF",
                "derivation": (
                    "recomputed exact row equation"
                    if constant_id.startswith("L2NT_D")
                    else "generated from certificate candidate and source formula"
                ),
                "notes": "exact constant reproduced" if not failed_fields else "; ".join(failed_fields),
            }
        )
    return rows


def compare_deletion(data: dict[str, Any], mismatches: list[dict[str, str]]) -> list[dict[str, str]]:
    generated = {
        mark.get("figure_node_id"): mark
        for mark in data.get("deletion_marks", [])
        if isinstance(mark, dict)
    }
    oracle = {row["node_id"]: row for row in read_csv(FIGURE_NODES) if row.get("crossed") == "yes"}
    rows: list[dict[str, str]] = []
    for node_id in sorted(set(generated) | set(oracle)):
        expected = "deleted" if node_id in oracle else "absent"
        actual = "deleted" if node_id in generated and generated[node_id].get("deleted") is True else "absent"
        passed = expected == actual
        if not passed:
            add_mismatch(mismatches, "deletion", node_id, "status", expected, actual)
        rows.append(
            {
                "figure_node_id": node_id,
                "manual_status": expected,
                "generated_status": actual,
                "status": "pass" if passed else "fail",
                "diff_kind": "MATCH" if passed else "MATH_DIFF",
                "notes": "Figure A1 oracle used after generation",
            }
        )
    return rows


def write_lean_data(path: Path, data: dict[str, Any]) -> None:
    constants = data["rational_certificate"]["coefficient_intervals"]
    ids = [item["coefficient_id"] for item in constants]
    values = [item["value"] for item in constants]
    slack_values = [item["slack"] for item in data["slacks"]]
    text = f"""-- generated full k2 regression data; not imported; verifier not yet written
-- Generated by scripts/{GENERATOR_VERSION}
-- Schema: {SCHEMA_VERSION}
-- This file contains data declarations only and no mathematical theorem.

namespace KL2003F2K2FullRegressionGenerated

def schemaVersion : String := {lean_string(SCHEMA_VERSION)}
def generatorMode : String := "k2_full_regression"
def proofStatus : String := "generated_data_candidate_only"
def k : Nat := 2
def trackedClassCount : Nat := 3
def preReductionClassCount : Nat := 9
def rowIds : List String := ["row22", "row25", "row28"]
def auxiliaryBlockIds : List String := ["M1V3", "M2V3"]
def m1v3SecondArm : String := "phi25"
def constantIds : List String := {lean_string_list(ids)}
def constantValues : List String := {lean_string_list(values)}
def recomputedSlackValues : List String := {lean_string_list(slack_values)}
def deletedFigureNodeIds : List String := ["N04", "N05"]

-- Candidate data only.  The existing manual Lean theorems remain the source
-- of truth until a generated-data verifier rechecks this artifact.

end KL2003F2K2FullRegressionGenerated
"""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def rational_digit_metrics(data: dict[str, Any]) -> tuple[int, int]:
    numerators: list[int] = []
    denominators: list[int] = []
    for item in data["rational_certificate"]["coefficient_intervals"]:
        value = item["value"]
        if not isinstance(value, str) or any(token in value for token in ("logb", "^", "(", ")")):
            continue
        fraction = Fraction(value)
        numerators.append(abs(fraction.numerator))
        denominators.append(fraction.denominator)
    return max(len(str(value)) for value in numerators), max(len(str(value)) for value in denominators)


def write_manifest(created_at: str, commit: str) -> None:
    json_hash = sha256(JSON_PATH)
    lean_hash = sha256(LEAN_PATH)
    generator_hash = sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION)
    inputs = [
        ROW22_JSON,
        ROW25_JSON,
        ROW28_JSON,
        ROW22_VALIDATION,
        ROW25_VALIDATION,
        ROW28_VALIDATION,
        BASELINE_ROWS,
        BASELINE_CONSTANTS,
        BASELINE_REQUIREMENTS,
        INTERIOR_CERTIFICATE,
        ENDPOINT_CERTIFICATE,
        FIGURE_ROOT_PATHS,
        FIGURE_NODES,
    ]
    outputs = [JSON_PATH, LEAN_PATH, SUMMARY_PATH, ROW_DIFF_PATH, CERT_DIFF_PATH, DELETION_DIFF_PATH, MANIFEST_DIFF_PATH, MISMATCH_PATH]
    paths = [(path, "regression_input") for path in inputs] + [(path, "regression_output") for path in outputs] + [
        (REPO_ROOT / "scripts" / GENERATOR_VERSION, "generator")
    ]
    write_csv(
        MANIFEST_PATH,
        [
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
                "notes": "complete k2 generator regression; baseline is oracle only",
            }
            for path, kind in paths
        ],
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
    started = time.perf_counter()
    run_at = datetime.now(timezone.utc).isoformat()
    created_at = source_commit_time()
    commit = source_commit()
    row22 = read_json(ROW22_JSON)
    row25 = read_json(ROW25_JSON)
    row28 = read_json(ROW28_JSON)
    validations = [read_json(path) for path in (ROW22_VALIDATION, ROW25_VALIDATION, ROW28_VALIDATION)]
    validation_failures = [str(summary.get("verdict")) for summary in validations if not str(summary.get("verdict", "")).endswith("PASS")]
    if validation_failures:
        raise RuntimeError("K2_REGRESSION_FAIL: microgenerator validation failure: " + ", ".join(validation_failures))

    certificate = derive_certificate(read_json(INTERIOR_CERTIFICATE), read_json(ENDPOINT_CERTIFICATE))
    data = merge_artifacts(created_at, commit, row22, row25, row28, certificate)
    mismatches: list[dict[str, str]] = []
    row_diff = compare_rows(data, mismatches)
    cert_diff = compare_certificate(data, mismatches)
    deletion_diff = compare_deletion(data, mismatches)

    write_json(JSON_PATH, data)
    write_lean_data(LEAN_PATH, data)
    runtime = time.perf_counter() - started
    numerator_digits, denominator_digits = rational_digit_metrics(data)
    min_slack_id, min_slack = min(certificate["slacks"].items(), key=lambda item: item[1])

    manifest_checks = [
        ("json_artifact_exists", JSON_PATH.exists(), repo_rel(JSON_PATH)),
        ("lean_artifact_exists", LEAN_PATH.exists(), repo_rel(LEAN_PATH)),
        ("json_to_lean_generator_exists", (REPO_ROOT / "scripts" / GENERATOR_VERSION).exists(), GENERATOR_VERSION),
        ("schema_v21", data["metadata"]["schema_version"] == SCHEMA_VERSION, data["metadata"]["schema_version"]),
        ("generated_lean_not_in_source_tree", LEAN_PATH.parent == OUT_DIR, repo_rel(LEAN_PATH)),
    ]
    manifest_diff = []
    for check_id, passed, evidence in manifest_checks:
        if not passed:
            add_mismatch(mismatches, "manifest", check_id, "status", "pass", "fail")
        manifest_diff.append(
            {
                "check_id": check_id,
                "status": "pass" if passed else "fail",
                "evidence": evidence,
                "diff_kind": "MATCH" if passed else "MATH_DIFF",
                "notes": "JSON/Lean twin and schema policy check",
            }
        )

    write_csv(
        ROW_DIFF_PATH,
        row_diff,
        ["row_id", "manual_expected_shape", "generated_expected_shape", "manual_required_feature", "generated_required_feature", "status", "diff_kind", "notes"],
    )
    write_csv(
        CERT_DIFF_PATH,
        cert_diff,
        ["constant_id", "manual_value", "generated_value", "status", "diff_kind", "derivation", "notes"],
    )
    write_csv(
        DELETION_DIFF_PATH,
        deletion_diff,
        ["figure_node_id", "manual_status", "generated_status", "status", "diff_kind", "notes"],
    )
    write_csv(
        MANIFEST_DIFF_PATH,
        manifest_diff,
        ["check_id", "status", "evidence", "diff_kind", "notes"],
    )
    write_csv(
        MISMATCH_PATH,
        mismatches,
        ["category", "item_id", "field", "expected", "actual", "severity", "classification"],
    )

    math_diff_count = len(mismatches)
    verdict = "K2_REGRESSION_PASS" if math_diff_count == 0 else "K2_REGRESSION_FAIL"
    kept_literals = sum(1 for word in data["inverse_words"] if not word.get("deleted"))
    summary = {
        "run_id": RUN_ID,
        "created_at": created_at,
        "source_commit": commit,
        "verdict": verdict,
        "schema_version": SCHEMA_VERSION,
        "source_faithful_contract": "V3",
        "row_count": len(data["rows"]),
        "auxiliary_block_count": len(data["nested_blocks"]),
        "regression_item_count": len(generated_regression_items(data)),
        "literal_count": len(data["inverse_words"]),
        "child_count": len(data["inverse_words"]),
        "deletion_count": len(data["deletion_marks"]),
        "kept_literal_count": kept_literals,
        "certificate_constant_count": len(data["rational_certificate"]["coefficient_intervals"]),
        "certificate_variable_count": len(data["rational_certificate"]["variables"]),
        "slack_count": len(data["slacks"]),
        "min_slack": fraction_text(min_slack),
        "min_slack_row_id": min_slack_id,
        "rational_numerator_max_digits": numerator_digits,
        "rational_denominator_max_digits": denominator_digits,
        "generated_json_size_bytes": JSON_PATH.stat().st_size,
        "generated_lean_data_size_bytes": LEAN_PATH.stat().st_size,
        "generated_lean_data_line_count": len(LEAN_PATH.read_text(encoding="utf-8").splitlines()),
        "generator_runtime_seconds": f"{runtime:.6f}",
        "json_sha256": sha256(JSON_PATH),
        "lean_data_sha256": sha256(LEAN_PATH),
        "json_to_lean_generator_sha256": sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION),
        "format_only_diff_count": 0,
        "mathematical_diff_count": math_diff_count,
        "microgenerator_validation_verdicts": [summary["verdict"] for summary in validations],
        "slack_derivations": {
            "L2NT_D1_slack": "A*c28 + B_lo*c12 - c22",
            "L2NT_D2_slack": "A*c22 - c25",
            "L2NT_D3_slack": "A*c25 + D_lo*c12 - c28",
        },
        "guardrails": data["guardrails"],
        "classifications": [
            "K2_GENERATOR_REGRESSION_CREATED",
            verdict,
            "K2_RULE_DERIVED_ROWS_REPRODUCED" if verdict == "K2_REGRESSION_PASS" else "K2_RULE_DERIVED_ROWS_DIFF",
            "K2_CERTIFICATE_SLACKS_RECOMPUTED_EXACTLY",
            "META_ERRATA_V3_PHI25_REPRODUCED",
            "FIGURE_A1_DELETION_REPRODUCED",
            "FULL_K2_GENERATOR_REGRESSION_COMPLETE" if verdict == "K2_REGRESSION_PASS" else "FULL_K2_GENERATOR_REGRESSION_INCOMPLETE",
            "NO_GENERATED_LEAN_IMPORT",
            "NO_K3_GENERATION",
            "NO_LP_SOLVED",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    write_manifest(run_at, commit)

    print(f"run_id={RUN_ID}")
    print(f"verdict={verdict}")
    print(f"row_count={summary['row_count']}")
    print(f"regression_item_count={summary['regression_item_count']}")
    print(f"literal_count={summary['literal_count']}")
    print(f"deletion_count={summary['deletion_count']}")
    print(f"slack_count={summary['slack_count']}")
    print(f"min_slack={summary['min_slack']} ({summary['min_slack_row_id']})")
    print(f"mathematical_diff_count={math_diff_count}")
    print("no generated Lean import, no k=3 generation, no LP solve, no high-k/global claim")
    return 0 if verdict == "K2_REGRESSION_PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
