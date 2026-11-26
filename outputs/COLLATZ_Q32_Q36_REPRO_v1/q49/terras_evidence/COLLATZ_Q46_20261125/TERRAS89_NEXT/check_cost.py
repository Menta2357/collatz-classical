#!/usr/bin/env python3
"""Count Q39 control-flow projections without executing an orbital search."""

from functools import cache
from hashlib import sha256
import json
from math import comb
from pathlib import Path


EXPERIMENTS = Path(__file__).resolve().parents[2]
Q39_PROJECTOR = "COLLATZ_Q39_20261125/TERRAS89_D5_H92_A75/check.py"
Q45_RECEIPT = "COLLATZ_Q45_20261125/TERRAS89_D5_H92_A73/RECIBO.json"
PINS = {
    Q39_PROJECTOR:
        "13d35385ed17685cb05c1d75e617e507ccd263044ead8938cec9057f79e21c1e",
    Q45_RECEIPT:
        "7d609bdfe558357de4797bf5ddb4c903508217aa5cbbfa87f7ff64f4702f5db5",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


@cache
def projection_count(run, remaining_width):
    if run == 3:
        return remaining_width
    return 1 + sum(explicit_gap_count(run, remaining_width, gap)
                   for gap in range(1, remaining_width))


def explicit_gap_count(run, remaining_width, gap):
    return 1 + sum(projection_count(run + 1, remaining_width - gap - rise)
                   for rise in range(1, remaining_width - gap - 1))


def main():
    for path, digest in PINS.items():
        require(sha256((EXPERIMENTS / path).read_bytes()).hexdigest() == digest, ("sha", path))
    prior = json.loads((EXPERIMENTS / Q45_RECEIPT).read_text())
    require(prior["status"] == "PASS" and prior["a1_inclusive"] == [73, 73], "prior scope")
    require(projection_count(1, 19) == prior["counters"]["projections"] == 11_919, "A73 count")
    require(projection_count(1, 18) == 8_826 and projection_count(1, 17) == 6_415,
            "previous calibration")

    height, first = 92, 72
    width = height - first
    coarse = sum(comb(width - 1, j) for j in range(6))
    per_gap = {gap: explicit_gap_count(1, width, gap) for gap in range(1, width)}
    tail_cost = 1
    full = projection_count(1, width)
    low = per_gap[1] + per_gap[2]
    high = tail_cost + sum(per_gap[b] for b in range(3, width))
    upper_half = tail_cost + sum(per_gap[b] for b in range(10, width))
    require((coarse, full, low, high, upper_half) == (16_664, 15_830, 7_004, 8_826, 545),
            "exact count and partition")
    require(full == 1 + sum(per_gap.values()) == low + high, "tail belongs once")
    require(max(low, high) < 15_000 < full, "budget")

    # At all recursive nodes p <= E-2 and c=D >= first. Before the
    # size divide at run 3, peak_upper >= 2*3**first - 1. Its denominator
    # can be at most 2**(H+1-first)-1, so the size caps never bind at E=20.
    minimal_peak_upper = 2 * 3**first - 1
    max_size_divisor = (1 << (height + 1 - first)) - 1
    require(minimal_peak_upper // max_size_divisor >= 2**width, "no gap guard reduces count")
    require(3**first >= 2**width, "no next-rise size guard reduces count")
    require(2**237 <= 6**height < 2**238, "integer D5 threshold")
    print(json.dumps({
        "status": "STOP_FULL_BAND_WITHIN_CURRENT_PROJECTION_CAP",
        "H": height,
        "a1": first,
        "projection_cap": 15_000,
        "coarse_combinatorial_bound": coarse,
        "unchanged_projector_projections_if_complete_without_refutation": full,
        "first_even_gap_explicit_costs": per_gap,
        "tail_b1_ge_20_cost": tail_cost,
        "proposed_shards": {"1<=b1<=2": low, "b1>=3": high},
        "optional_upper_half_b1_ge_10": upper_half,
        "A73_projections_calibrated": prior["counters"]["projections"],
        "projector_executed": False,
        "physical_sources_replayed": 0,
        "H146_executed": False,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }, indent=2))


if __name__ == "__main__":
    main()
