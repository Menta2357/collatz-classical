#!/usr/bin/env python3
"""Build and recheck a rational supersolution for the tilted core.

The published edge decimals are rounded upward to a predeclared base
denominator, and the irrational scale factors are replaced by predeclared
decimal upper envelopes.  The resulting 243 inequalities are exact Fraction
inequalities for that rational envelope.  This is a certificate audit, not yet
a proof that the envelope equals the underlying real operator.
"""

from __future__ import annotations

import csv
import hashlib
import json
import math
from decimal import Decimal, ROUND_CEILING, getcontext
from fractions import Fraction
from pathlib import Path

import numpy as np


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
VECTOR_OUT = RESULTS / "tilted_supersolution_v1.csv"
SUMMARY_OUT = RESULTS / "tilted_supersolution_v1_summary.json"
RHO_STAR = 9.0 / 5.0
RHO_PRIME = 2.5
D_VECTOR = 1_000_000
BASE_DENOMINATOR = 10**24
SCALE_DENOMINATOR = 10**18
LAMBDA_PRIME = Fraction(49, 50)
LAMBDA_LIMIT = Fraction(100, 101)  # 1/(1+delta)


def ceil_fraction(value: Fraction, denominator: int) -> Fraction:
    numerator = (value.numerator * denominator + value.denominator - 1) // value.denominator
    return Fraction(numerator, denominator)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def main() -> None:
    getcontext().prec = 80
    state_ids: list[int] = []
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            state_ids.append(int(row["state_id"]))
    index = {state_id: i for i, state_id in enumerate(state_ids)}
    n = len(state_ids)

    # Numerical eigenvector is used only to choose a nearby integer vector;
    # every final inequality below is rechecked as an exact Fraction.
    numeric_matrix = np.zeros((n, n), dtype=float)
    edges: list[tuple[int, int, Fraction, str]] = []
    alpha_float = math.log2(3.0)
    shifts_float = {
        "retarded": -2.0,
        "advanced_direct_c2": alpha_float - 1.0,
        "advanced_parity_lift_c1": alpha_float - 2.0,
    }
    with (RESULTS / "split_edges.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            channel = row["channel"]
            if channel not in shifts_float:
                continue
            source = int(row["source_id"])
            target = int(row["target_id"])
            if source not in index or target not in index:
                continue
            frozen_weight = Fraction(row["weight_decimal"])
            edges.append((index[source], index[target], frozen_weight, channel))
            numeric_matrix[index[source], index[target]] += float(frozen_weight) * (
                RHO_PRIME / RHO_STAR
            ) ** shifts_float[channel]

    values, vectors = np.linalg.eig(numeric_matrix)
    dominant = int(np.argmax(values.real))
    vector = np.abs(vectors[:, dominant].real)
    vector /= vector.min()
    integer_vector = np.ceil(vector * D_VECTOR).astype(np.int64)

    ratio = Decimal(25) / Decimal(18)
    alpha = Decimal(3).ln() / Decimal(2).ln()
    scale_upper: dict[str, Fraction] = {"retarded": Fraction(324, 625)}
    for channel, exponent in (
        ("advanced_direct_c2", alpha - 1),
        ("advanced_parity_lift_c1", alpha - 2),
    ):
        value = (ratio.ln() * exponent).exp()
        numerator = int(
            (value * Decimal(SCALE_DENOMINATOR)).to_integral_value(rounding=ROUND_CEILING)
        )
        scale_upper[channel] = Fraction(numerator, SCALE_DENOMINATOR)

    matrix_upper = [[Fraction(0) for _ in range(n)] for _ in range(n)]
    for source, target, frozen_weight, channel in edges:
        base_upper = ceil_fraction(frozen_weight, BASE_DENOMINATOR)
        matrix_upper[source][target] += base_upper * scale_upper[channel]

    rows: list[dict[str, object]] = []
    bad = 0
    ratios: list[float] = []
    for source_id, source in enumerate(state_ids):
        lhs = sum(matrix_upper[source_id][target] * int(integer_vector[target]) for target in range(n))
        rhs = LAMBDA_PRIME * int(integer_vector[source_id])
        slack = rhs - lhs
        ratio_value = float(lhs / rhs)
        ratios.append(ratio_value)
        if slack < 0:
            bad += 1
        rows.append(
            {
                "core_local_id": source_id,
                "state_id": source,
                "v_integer": int(integer_vector[source_id]),
                "v_denominator": D_VECTOR,
                "lhs_num": lhs.numerator,
                "lhs_den": lhs.denominator,
                "rhs_num": rhs.numerator,
                "rhs_den": rhs.denominator,
                "slack_num": slack.numerator,
                "slack_den": slack.denominator,
                "lhs_over_rhs_decimal": ratio_value,
                "passes": slack >= 0,
            }
        )

    with VECTOR_OUT.open("w", newline="", encoding="utf-8") as handle:
        fields = list(rows[0])
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)

    payload = {
        "certificate": "F3_TILTED_SUPERSOLUTION_v1",
        "core_state_count": n,
        "lambda_prime": "49/50",
        "lambda_prime_decimal": float(LAMBDA_PRIME),
        "lambda_limit_1_over_1_plus_delta": "100/101",
        "lambda_limit_check": LAMBDA_PRIME < LAMBDA_LIMIT,
        "vector_denominator_D": D_VECTOR,
        "base_edge_upper_denominator": BASE_DENOMINATOR,
        "scale_upper_denominator": SCALE_DENOMINATOR,
        "scale_upper": {key: f"{value.numerator}/{value.denominator}" for key, value in scale_upper.items()},
        "bad_row_count": bad,
        "min_slack_decimal": min(float(row["slack_num"]) / float(row["slack_den"]) for row in rows),
        "max_lhs_over_rhs_decimal": max(ratios),
        "min_lhs_over_rhs_decimal": min(ratios),
        "vector_min_integer": int(integer_vector.min()),
        "vector_max_integer": int(integer_vector.max()),
        "vector_sha256": sha256(VECTOR_OUT),
        "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
        "local_verdict": "PASS_RATIONAL_SUPERSOLUTION" if bad == 0 else "STOP_SUPERSOLUTION",
        "status": "DIAGNOSTIC_RATIONAL_ENVELOPE",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    SUMMARY_OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
