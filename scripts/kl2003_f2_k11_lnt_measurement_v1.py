#!/usr/bin/env python3
"""Generate and exactly recheck a flat KL2003 L_11^NT data candidate."""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
import time
from decimal import Decimal, getcontext
from fractions import Fraction
from pathlib import Path
from typing import Any

import numpy as np


RUN_ID = "KL2003_F2_K11_LNT_MEASUREMENT_v1"
GENERATOR_VERSION = "kl2003_f2_k11_lnt_measurement_v1.py"
REPO_ROOT = Path(__file__).resolve().parents[1]
BUDGET_DOC = REPO_ROOT / "docs" / "KL2003_K11_REAL_CERTIFICATE_METRICS_GATE_v1.md"
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
JSON_PATH = OUT_DIR / "kl2003_k11_lnt_certificate.candidate.json"
ROWS_PATH = OUT_DIR / "l11nt_rows.csv"
AUXILIARY_PATH = OUT_DIR / "l10nt_auxiliary.csv"
SLACKS_PATH = OUT_DIR / "exact_slacks.csv"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"
SOURCE_PATH = Path(
    "/Users/MoiTam/Documents/Codex/2026-07-05/"
    "tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/"
    "kl2003_src/30apr02.tex"
)

K = 11
MODULUS = 3**K
CLASS_STEP = 3 ** (K - 1)
TRACKED = np.arange(2, MODULUS, 3, dtype=np.int64)
AUXILIARY_MODES = np.arange(2, CLASS_STEP, 3, dtype=np.int64)

LAMBDA = Fraction(71_689, 40_000)
ALPHA_LOWER = Fraction(569, 359)
B_LOWER = Fraction(784_931_055_601, 1_000_000_000_000)
D_LOWER = LAMBDA * B_LOWER
A_COEFF = 1 / (LAMBDA**2)
ROUNDING_SCALE = 100_000_000

SOURCE_LAMBDA11 = Decimal("1.7922310")
SOURCE_GAMMA11 = Decimal("0.8417560")
SOURCE_CMAX11 = Decimal("98.4009647")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def fraction_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def row_kind(mode: int) -> str:
    return {2: "D1", 5: "D2", 8: "D3"}[mode % 9]


def topology() -> dict[str, np.ndarray]:
    retarded = (((4 * TRACKED) % MODULUS) - 2) // 3
    kinds = TRACKED % 9
    lifts = np.stack(
        [((AUXILIARY_MODES + index * CLASS_STEP) - 2) // 3 for index in range(3)],
        axis=1,
    )
    auxiliary_index = np.full(len(TRACKED), -1, dtype=np.int64)
    for index, mode_value in enumerate(TRACKED):
        mode = int(mode_value)
        if mode % 9 == 2:
            auxiliary_mode = ((4 * mode - 2) // 3) % CLASS_STEP
            auxiliary_index[index] = (auxiliary_mode - 2) // 3
        elif mode % 9 == 8:
            auxiliary_mode = ((2 * mode - 1) // 3) % CLASS_STEP
            auxiliary_index[index] = (auxiliary_mode - 2) // 3
    return {
        "retarded": retarded,
        "kinds": kinds,
        "lifts": lifts,
        "auxiliary_index": auxiliary_index,
    }


def topology_checks(data: dict[str, np.ndarray]) -> dict[str, bool]:
    tracked_set = set(int(value) for value in TRACKED)
    retarded_modes = [2 + 3 * int(index) for index in data["retarded"]]
    return {
        "tracked_class_count": len(TRACKED) == 59_049,
        "auxiliary_class_count": len(AUXILIARY_MODES) == 19_683,
        "d1_count": int(np.sum(data["kinds"] == 2)) == 19_683,
        "d2_count": int(np.sum(data["kinds"] == 5)) == 19_683,
        "d3_count": int(np.sum(data["kinds"] == 8)) == 19_683,
        "retarded_targets_tracked": all(mode in tracked_set for mode in retarded_modes),
        "auxiliary_indices_in_range": bool(
            np.all(
                data["auxiliary_index"][data["auxiliary_index"] >= 0]
                < len(AUXILIARY_MODES)
            )
        ),
        "three_lifts_per_auxiliary": data["lifts"].shape == (19_683, 3),
    }


def power_candidate(
    data: dict[str, np.ndarray],
    *,
    tolerance: float = 1e-14,
    max_iterations: int = 20_000,
) -> tuple[np.ndarray, int, float, float, float]:
    started = time.perf_counter()
    principal = np.ones(len(TRACKED), dtype=np.float64)
    a_float = float(A_COEFF)
    b_float = float(B_LOWER)
    d_float = float(D_LOWER)
    rho = 0.0
    relative_change = float("inf")
    for iteration in range(1, max_iterations + 1):
        auxiliary = principal[data["lifts"]].min(axis=1)
        image = a_float * principal[data["retarded"]]
        d1 = data["kinds"] == 2
        d3 = data["kinds"] == 8
        image[d1] += b_float * auxiliary[data["auxiliary_index"][d1]]
        image[d3] += d_float * auxiliary[data["auxiliary_index"][d3]]
        rho = float(image.min())
        next_principal = image / rho
        relative_change = float(
            np.max(np.abs(next_principal - principal) / (1 + np.abs(principal)))
        )
        principal = next_principal
        if relative_change < tolerance:
            break
    else:
        raise RuntimeError("K11_POWER_ITERATION_DID_NOT_CONVERGE")
    return principal, iteration, rho, relative_change, time.perf_counter() - started


def rationalize_and_verify(
    candidate: np.ndarray, data: dict[str, np.ndarray]
) -> dict[str, Any]:
    principal = [
        Fraction(round(float(value) * ROUNDING_SCALE), ROUNDING_SCALE)
        for value in candidate
    ]
    auxiliary = [
        min(principal[int(index)] for index in lift_row)
        for lift_row in data["lifts"]
    ]
    slacks: list[Fraction] = []
    rhs_values: list[Fraction] = []
    for index, mode_value in enumerate(TRACKED):
        rhs = A_COEFF * principal[int(data["retarded"][index])]
        mode = int(mode_value)
        auxiliary_index = int(data["auxiliary_index"][index])
        if mode % 9 == 2:
            rhs += B_LOWER * auxiliary[auxiliary_index]
        elif mode % 9 == 8:
            rhs += D_LOWER * auxiliary[auxiliary_index]
        rhs_values.append(rhs)
        slacks.append(rhs - principal[index])
    lift_slacks = [
        principal[int(principal_index)] - auxiliary[aux_index]
        for aux_index, lift_row in enumerate(data["lifts"])
        for principal_index in lift_row
    ]
    relative_slacks = [slack / principal[index] for index, slack in enumerate(slacks)]
    exact_checks = {
        "principal_box_lower": all(value >= 1 for value in principal),
        "auxiliary_box_lower": all(value >= 1 for value in auxiliary),
        "lift_slacks_nonnegative": all(value >= 0 for value in lift_slacks),
        "all_row_slacks_positive": all(value > 0 for value in slacks),
        "B_lower_integer_power_witness": B_LOWER**359 * LAMBDA**149 <= 1,
        "D_lower_integer_power_witness": D_LOWER**359 <= LAMBDA**210,
    }
    return {
        "principal": principal,
        "auxiliary": auxiliary,
        "slacks": slacks,
        "rhs_values": rhs_values,
        "lift_slacks": lift_slacks,
        "relative_slacks": relative_slacks,
        "exact_checks": exact_checks,
    }


def decimal_metrics(certificate: dict[str, Any]) -> dict[str, str]:
    getcontext().prec = 70
    lambda_decimal = Decimal(LAMBDA.numerator) / Decimal(LAMBDA.denominator)
    gamma = lambda_decimal.ln() / Decimal(2).ln()
    cmax = max(certificate["principal"])
    cmax_decimal = Decimal(cmax.numerator) / Decimal(cmax.denominator)
    return {
        "lambda": str(lambda_decimal),
        "source_lambda11": str(SOURCE_LAMBDA11),
        "lambda_safe_gap": str(SOURCE_LAMBDA11 - lambda_decimal),
        "gamma": str(gamma),
        "source_gamma11": str(SOURCE_GAMMA11),
        "gamma_safe_gap": str(SOURCE_GAMMA11 - gamma),
        "cmax": str(cmax_decimal),
        "source_cmax11": str(SOURCE_CMAX11),
        "cmax_abs_diff": str(abs(SOURCE_CMAX11 - cmax_decimal)),
    }


def main() -> int:
    if not SOURCE_PATH.exists():
        raise FileNotFoundError("BLOCKED_ON_KL2003_TEX_SOURCE")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    total_started = time.perf_counter()

    topology_started = time.perf_counter()
    data = topology()
    topology_runtime = time.perf_counter() - topology_started
    checks = topology_checks(data)
    if not all(checks.values()):
        raise RuntimeError("K11_FLAT_TOPOLOGY_CHECK_FAILED")

    candidate, iterations, rho, relative_change, search_runtime = power_candidate(data)
    exact_started = time.perf_counter()
    certificate = rationalize_and_verify(candidate, data)
    exact_runtime = time.perf_counter() - exact_started
    if not all(certificate["exact_checks"].values()):
        raise RuntimeError("K11_EXACT_FRACTION_RECHECK_FAILED")

    metrics = decimal_metrics(certificate)
    min_slack = min(certificate["slacks"])
    min_slack_index = certificate["slacks"].index(min_slack)
    min_relative = min(certificate["relative_slacks"])
    min_relative_index = certificate["relative_slacks"].index(min_relative)
    all_values = (
        certificate["principal"]
        + certificate["auxiliary"]
        + certificate["slacks"]
        + certificate["lift_slacks"]
    )
    max_numerator_digits = max(len(str(abs(value.numerator))) for value in all_values)
    max_denominator_digits = max(len(str(value.denominator)) for value in all_values)

    rows: list[dict[str, Any]] = []
    for index, mode_value in enumerate(TRACKED):
        mode = int(mode_value)
        auxiliary_index = int(data["auxiliary_index"][index])
        rows.append(
            {
                "mode": mode,
                "row_kind": row_kind(mode),
                "retarded_index": int(data["retarded"][index]),
                "auxiliary_index": auxiliary_index if auxiliary_index >= 0 else None,
                "target": fraction_text(certificate["principal"][index]),
                "rhs": fraction_text(certificate["rhs_values"][index]),
                "slack": fraction_text(certificate["slacks"][index]),
                "relative_slack": fraction_text(certificate["relative_slacks"][index]),
            }
        )

    auxiliary_rows: list[dict[str, Any]] = []
    for index, mode_value in enumerate(AUXILIARY_MODES):
        lifts = [int(item) for item in data["lifts"][index]]
        lift_slacks = [
            certificate["principal"][lift] - certificate["auxiliary"][index]
            for lift in lifts
        ]
        auxiliary_rows.append(
            {
                "mode": int(mode_value),
                "value": fraction_text(certificate["auxiliary"][index]),
                "lift_indices": lifts,
                "lift_slacks": [fraction_text(value) for value in lift_slacks],
            }
        )

    payload = {
        "metadata": {
            "run_id": RUN_ID,
            "k": K,
            "generator_version": GENERATOR_VERSION,
            "source_commit": subprocess.run(
                ["git", "rev-parse", "HEAD"], cwd=REPO_ROOT, check=True,
                capture_output=True, text=True,
            ).stdout.strip(),
            "source_path": str(SOURCE_PATH),
            "source_lines": "1543-1578",
            "proof_status": "exact_python_fraction_recheck_pending_lean",
            "real_k11_certificate_candidate": True,
            "k11_theorem_claimed": False,
        },
        "constants": {
            "lambda": fraction_text(LAMBDA),
            "alpha_lower": fraction_text(ALPHA_LOWER),
            "A_lambda_minus_2": fraction_text(A_COEFF),
            "B_lower": fraction_text(B_LOWER),
            "D_lower": fraction_text(D_LOWER),
            "rounding_scale": str(ROUNDING_SCALE),
        },
        "dimensions": {
            "modulus": MODULUS,
            "tracked_class_count": len(TRACKED),
            "auxiliary_class_count": len(AUXILIARY_MODES),
        },
        "exact_checks": certificate["exact_checks"],
        "decimal_diagnostics_as_strings": metrics,
        "rows": rows,
        "auxiliary": auxiliary_rows,
        "guardrails": [
            "DATA_CANDIDATE_ONLY",
            "LEAN_KERNEL_RECHECK_REQUIRED",
            "NO_K11_THEOREM_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(JSON_PATH, payload)
    write_csv(
        ROWS_PATH,
        rows,
        [
            "mode", "row_kind", "retarded_index", "auxiliary_index",
            "target", "rhs", "slack", "relative_slack",
        ],
    )
    write_csv(
        AUXILIARY_PATH,
        [
            {
                "mode": row["mode"],
                "value": row["value"],
                "lift_indices": ";".join(str(item) for item in row["lift_indices"]),
                "lift_slacks": ";".join(row["lift_slacks"]),
            }
            for row in auxiliary_rows
        ],
        ["mode", "value", "lift_indices", "lift_slacks"],
    )
    write_csv(
        SLACKS_PATH,
        [
            {
                "mode": row["mode"],
                "slack": row["slack"],
                "relative_slack": row["relative_slack"],
                "strictly_positive": "true",
            }
            for row in rows
        ],
        ["mode", "slack", "relative_slack", "strictly_positive"],
    )
    write_csv(MISMATCH_PATH, [], ["category", "index", "detail"])

    total_runtime = time.perf_counter() - total_started
    json_size = JSON_PATH.stat().st_size
    gamma_gap = Decimal(metrics["gamma_safe_gap"])
    cmax_gap = Decimal(metrics["cmax_abs_diff"])
    if max(max_numerator_digits, max_denominator_digits) > 70:
        verdict = "K11_REAL_CERTIFICATE_METRICS_FAIL"
    elif json_size > 500_000_000 or total_runtime > 300 or gamma_gap <= 0:
        verdict = "K11_REAL_CERTIFICATE_METRICS_FAIL"
    elif (
        max(max_numerator_digits, max_denominator_digits) > 50
        or json_size > 250_000_000
        or total_runtime > 120
        or gamma_gap > Decimal("0.00001")
        or cmax_gap > Decimal("0.1")
    ):
        verdict = "K11_REAL_CERTIFICATE_METRICS_OPTIMIZATION_REQUIRED"
    else:
        verdict = "K11_REAL_CERTIFICATE_METRICS_PASS"

    summary = {
        "run_id": RUN_ID,
        "verdict": verdict,
        "budget_doc": repo_rel(BUDGET_DOC),
        "budget_doc_sha256": sha256(BUDGET_DOC),
        "k": K,
        "tracked_class_count": len(TRACKED),
        "auxiliary_class_count": len(AUXILIARY_MODES),
        "row_counts": {
            "D1": int(np.sum(data["kinds"] == 2)),
            "D2": int(np.sum(data["kinds"] == 5)),
            "D3": int(np.sum(data["kinds"] == 8)),
        },
        "lambda": fraction_text(LAMBDA),
        "source_lambda11": str(SOURCE_LAMBDA11),
        "gamma_diagnostic": metrics["gamma"],
        "source_gamma11": str(SOURCE_GAMMA11),
        "gamma_safe_gap": metrics["gamma_safe_gap"],
        "cmax": fraction_text(max(certificate["principal"])),
        "source_cmax11": str(SOURCE_CMAX11),
        "cmax_abs_diff": metrics["cmax_abs_diff"],
        "minimum_row_slack": fraction_text(min_slack),
        "minimum_row_slack_decimal": str(
            Decimal(min_slack.numerator) / Decimal(min_slack.denominator)
        ),
        "minimum_row_slack_mode": int(TRACKED[min_slack_index]),
        "minimum_relative_slack": fraction_text(min_relative),
        "minimum_relative_slack_decimal": str(
            Decimal(min_relative.numerator) / Decimal(min_relative.denominator)
        ),
        "minimum_relative_slack_mode": int(TRACKED[min_relative_index]),
        "rational_numerator_max_digits": max_numerator_digits,
        "rational_denominator_max_digits": max_denominator_digits,
        "power_iterations": iterations,
        "power_rho": format(rho, ".17g"),
        "power_relative_change": format(relative_change, ".17g"),
        "topology_runtime_seconds": format(topology_runtime, ".6f"),
        "search_runtime_seconds": format(search_runtime, ".6f"),
        "exact_recheck_runtime_seconds": format(exact_runtime, ".6f"),
        "total_generator_runtime_seconds": format(total_runtime, ".6f"),
        "json_bytes": json_size,
        "rows_csv_bytes": ROWS_PATH.stat().st_size,
        "auxiliary_csv_bytes": AUXILIARY_PATH.stat().st_size,
        "mismatch_count": 0,
        "topology_checks": checks,
        "exact_checks": certificate["exact_checks"],
        "lean_checker_status": "NOT_STARTED",
        "real_k11_certificate_generated": True,
        "k11_theorem_claimed": False,
        "global_collatz_claimed": False,
    }
    write_json(SUMMARY_PATH, summary)
    manifest_inputs = [
        BUDGET_DOC,
        Path(__file__),
        JSON_PATH,
        ROWS_PATH,
        AUXILIARY_PATH,
        SLACKS_PATH,
        SUMMARY_PATH,
        MISMATCH_PATH,
    ]
    write_csv(
        MANIFEST_PATH,
        [
            {
                "path": repo_rel(path),
                "sha256": sha256(path),
                "bytes": path.stat().st_size,
            }
            for path in manifest_inputs
        ],
        ["path", "sha256", "bytes"],
    )
    print(
        json.dumps(
            {
                "verdict": verdict,
                "row_count": len(TRACKED),
                "minimum_row_slack": summary["minimum_row_slack"],
                "minimum_relative_slack": summary["minimum_relative_slack"],
                "max_digits": max(max_numerator_digits, max_denominator_digits),
                "json_bytes": json_size,
                "runtime_seconds": summary["total_generator_runtime_seconds"],
            },
            sort_keys=True,
        )
    )
    return 0 if verdict == "K11_REAL_CERTIFICATE_METRICS_PASS" else 2


if __name__ == "__main__":
    raise SystemExit(main())
