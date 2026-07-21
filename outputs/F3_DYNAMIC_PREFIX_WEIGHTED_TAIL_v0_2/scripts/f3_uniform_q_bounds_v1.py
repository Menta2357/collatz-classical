#!/usr/bin/env python3
"""Audit the two uniform counting bounds required for Q.

The sterile ray is counted exactly.  Boundary fragments are controlled by the
three fine residue classes modulo 4*3^6: counts in an interval differ by at
most one, so after taking three-way complete blocks the remainder is at most
two roots per core state.
"""

from __future__ import annotations

import csv
import json
import math
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "uniform_q_bounds_v1.json"
FINE_PERIOD = 4 * (3**6)
RHO_STAR = 9.0 / 5.0
Y0 = 8
Y_MAX_AUDIT = 128
INTERVALS = ((3, 10_369), (41_473, 82_945))


def parity(n: int) -> str:
    return "even" if n % 2 == 0 else "odd"


def bucket(n: int) -> int:
    return 0 if n % 2 else (1 if n % 4 else 2)


def state_label(n: int) -> str:
    return f"d5:r{n % 243}:p{parity(n)}:b{bucket(n)}"


def sterile_count(y: int) -> int:
    # The ray contains c, 2c, ..., below 3*2^(y-1)c.
    return (3 * (2 ** (y - 1))).bit_length()


def lift_counts(lower: int, upper: int, state: str) -> tuple[int, int, int]:
    counts = Counter()
    residue = int(state.split(":")[1][1:])
    for root in range(lower, upper):
        if root <= 2 or root % 3 != 2 or root % 243 != residue:
            continue
        fine_lift = ((root % FINE_PERIOD) - residue) // 243 % 3
        counts[fine_lift] += 1
    return counts[0], counts[1], counts[2]


def main() -> None:
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        core_states = [row["state"] for row in csv.DictReader(handle)]

    sterile_rows = []
    for y in range(Y0, Y_MAX_AUDIT + 1):
        count = sterile_count(y)
        sterile_rows.append(
            {
                "y": y,
                "exact_count": count,
                "normalized_count": (y + 1) / (RHO_STAR**y),
                "exact_formula_holds": count == y + 1,
            }
        )
    normalized_max = max(sterile_rows, key=lambda row: row["normalized_count"])

    boundary_checks = []
    max_boundary = 0
    all_boundary_pass = True
    for lower, upper in INTERVALS:
        interval_max = 0
        for state in core_states:
            c0, c1, c2 = lift_counts(lower, upper, state)
            complete_each = min(c0, c1, c2)
            boundary = c0 + c1 + c2 - 3 * complete_each
            interval_max = max(interval_max, boundary)
            all_boundary_pass &= boundary <= 2
        max_boundary = max(max_boundary, interval_max)
        boundary_checks.append(
            {
                "interval": [lower, upper],
                "max_boundary_roots_per_state": interval_max,
                "bound_pass": interval_max <= 2,
            }
        )

    payload = {
        "table": "F3_UNIFORM_Q_BOUNDS_v1",
        "fine_period": FINE_PERIOD,
        "y0": Y0,
        "sterile_formula": "count(y)=floor(log2(3*2^(y-1)))+1=y+1",
        "sterile_monotonicity_check": "((y+2)/(y+1))/rho_star < 1 for y>=8",
        "sterile_normalized_max_y8": normalized_max,
        "sterile_all_formula_checks_pass": all(row["exact_formula_holds"] for row in sterile_rows),
        "boundary_formula": "three fine residue counts differ by at most one; remainder <= 2 per core state",
        "boundary_max_roots_per_state": max_boundary,
        "boundary_checks": boundary_checks,
        "boundary_all_pass": all_boundary_pass,
        "uniform_counting_verdict": "PASS_UNIFORM_COUNTING_LEMMAS" if all_boundary_pass else "STOP_UNIFORM_Q",
        "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
        "status": "FINITE_ARITHMETIC_COUNTING_AUDIT",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
