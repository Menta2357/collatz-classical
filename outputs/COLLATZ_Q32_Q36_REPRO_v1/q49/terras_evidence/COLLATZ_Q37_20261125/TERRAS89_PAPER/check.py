#!/usr/bin/env python3
"""Exact arithmetic for the remaining case of the Terras 89 extension."""

from fractions import Fraction
from functools import cache
from hashlib import sha256
import json
from math import ceil, floor
from pathlib import Path
import sys


EXPERIMENTS = Path(__file__).resolve().parents[2]
TERRAS88 = EXPERIMENTS / "COLLATZ_ECO_20261125"
TERRAS87 = EXPERIMENTS / "COLLATZ_TERRAS_87_RUNS_20261125"
WEAVER_REPLAY = TERRAS87 / "WEAVER_REPLAY_20261125" / "RECIBO.json"
PINS = {
    TERRAS88 / "TERRAS88_CIERRE_RECIBO.json": "5eabced486b6f05d06605b9adb29f77e936932133e4cc634e11aff1cec8f1293",
    TERRAS88 / "TERRAS88_check.py": "eb2beb2ef97361c11c235a4fa92d689fb4048ed431014baf62caf68e97aa95b0",
    TERRAS87 / "verify_ranked_path.py": "0cb9ea11853a66423ba5a3d84af1c5171879f75fa80f5690350987cdee4c27dc",
    WEAVER_REPLAY: "306389681bf20b6c7f004ff413b28963e0d9659929ea5bb9c6b3f3a0f0d19b40",
}


def require(condition, context):
    if not condition:
        raise ValueError(context)


for path, digest in PINS.items():
    require(sha256(path.read_bytes()).hexdigest() == digest, ("parent digest", path.name))

sys.dont_write_bytecode = True
sys.path.insert(0, str(TERRAS88))
from TERRAS88_check import (  # noqa: E402
    ALPHA, B, D0, DOUBLE, FOUR_RUN_BITS, K0, NEW_PAIR, P, Q, QUERIES,
    SOURCE_CORRECTION, THREE_RUN_BITS, gap_interval, geometric_sum, log_interval,
    rank_capacity, reciprocal_bound, scale_floor,
)


RUNS = 89
ODD_LIMIT = 2**70
Q0 = QUERIES[0][:2]
Q1 = QUERIES[1][:2]
PAIRS = {
    "Q0": Q0,
    "2Q0": (2 * Q0[0], 2 * Q0[1]),
    "Q1": Q1,
    "P": (7_984_791_619_272_937_798, 5_037_842_608_667_313_239),
    "2Q1": DOUBLE,
    "3Q1": (3 * Q1[0], 3 * Q1[1]),
    "J": NEW_PAIR,
}


def clock_sieve(ln2, ln3):
    require(1 < ln3[0] / ln2[1] < ln3[1] / ln2[0] < ALPHA, "log enclosure")
    increment = Fraction(133, 10)
    bracket = 7 + increment * 72
    require(increment < bracket and geometric_sum(RUNS) * bracket < ODD_LIMIT, "Rhin cutoff")
    require(Q * K0 - P * D0 == 1, "unimodular basis")
    error_lo = Q * ln3[0] - P * ln2[1]
    error_hi = Q * ln3[1] - P * ln2[0]
    basis_lo, basis_hi = gap_interval(K0, D0, ln2, ln3)
    max_gap = Fraction(RUNS, B)
    require(error_lo > 0 and basis_lo > 0 and basis_lo + error_lo > max_gap, "basis signs")
    h_max = floor((Q * max_gap + ODD_LIMIT * error_hi) / ln2[0])
    scale, cap = 10**55, 180
    reciprocals = [ceil(scale * reciprocal_bound(H)) for H in range(cap + 1)]
    source = ceil(scale * SOURCE_CORRECTION)
    capacities = [rank_capacity(RUNS, r) for r in range(2, RUNS + 1)]
    visited = 0
    survivors = set()
    for h in range(1, h_max + 1):
        j_min = max(0, 1 + floor((h * basis_lo - max_gap) / error_hi))
        j_max = floor(h * basis_hi / error_lo)
        for j in range(j_min, j_max + 1):
            k, d = h * K0 + j * P, h * D0 + j * Q
            if d >= ODD_LIMIT:
                continue
            gap_lo = h * basis_lo - j * error_hi
            gap_hi = h * basis_hi - j * error_lo
            if gap_hi <= 0 or gap_lo >= max_gap:
                continue
            visited += 1
            envelope = source + sum(reciprocals[min(cap, d * g.denominator // g.numerator)]
                                    for g in capacities)
            if gap_lo * scale < envelope:
                survivors.add((k, d))
    require((h_max, visited) == (2797, 5413) and survivors == set(PAIRS.values()), "clock sieve")
    print(f"Clock sieve: h <= {h_max}, {visited} pairs, {len(survivors)} survivors")
    for name, pair in PAIRS.items():
        print(f"  {name}: {pair}")


@cache
def capacity(runs, rank):
    return rank_capacity(runs, rank)


@cache
def ordered_bounds(d, five_rises=()):
    """Optional heights are premises, not results of this checker."""
    floors = [0]
    for rank in range(1, RUNS + 1):
        height = max(floors[-1], scale_floor(d, rank, runs=RUNS))
        if rank <= RUNS - 2:
            height = max(height, *(H for H in THREE_RUN_BITS if H * capacity(RUNS - 1, rank) < d), 0)
        if RUNS > 3 * rank:
            height = max(height, *(H for H in FOUR_RUN_BITS if H * capacity(RUNS - 2, rank) < d), 0)
        if five_rises and RUNS > 4 * rank:
            height = max(height, *(H for H in five_rises if H * capacity(RUNS - 3, rank) < d), 0)
        floors.append(height)
    tail = [Fraction(0)] * (RUNS + 2)
    for rank in range(RUNS, 0, -1):
        tail[rank] = tail[rank + 1] + reciprocal_bound(floors[rank])
    return floors, tail


def replay_caps():
    closure = json.loads((TERRAS88 / "TERRAS88_CIERRE_RECIBO.json").read_text())
    require(tuple(row["H"] for row in closure["capacity"]) == FOUR_RUN_BITS, "four-rise parent heights")
    replay = json.loads(WEAVER_REPLAY.read_text())
    require(replay["independent_reexecution_of_published_engines"] and
            {(r["query_index"], r["method"]) for r in replay["runs"]} ==
            {(i, method) for i in range(2) for method in ("progression", "affine")} and
            all(r["with_witness"] == 0 and r["same_stats_per_shard"] for r in replay["runs"]),
            "inherited Weaver exclusions")
    print("Imported: six four-rise capacities and both Weaver queries from the pinned receipts")


def slack(gap, q, low, end, tail):
    credit = SOURCE_CORRECTION if q == 1 else 0
    return gap - credit - Fraction(low - q - 1, B) - tail[end]


def transfer(gap, q, bounds, weaver, low, end):
    floors, tail = bounds
    published = QUERIES[weaver]
    blocks = published[4] - published[2]
    source_cap, target_height = published[5:]
    required_rank = low + blocks
    if not (q + 1 <= low < end <= RUNS + 1 and RUNS > low * blocks and
            floors[required_rank] >= target_height and source_cap < 2**target_height - 1):
        return None
    budget = slack(gap, q, low, end, tail)
    if budget <= 0 or source_cap * budget < end - low:
        return None
    return (low, end, required_rank, floors[required_rank], ceil((end - low) / budget))


def has_transfer(gap, q, bounds):
    for index, published in enumerate(QUERIES):
        blocks = published[4] - published[2]
        for low in range(q + 1, (RUNS - 1) // blocks + 1):
            for end in range(low + 1, RUNS + 2):
                if transfer(gap, q, bounds, index, low, end) is not None:
                    return True
    return False


def exclusions(ln2, ln3):
    rows = {name: (gap_interval(k, d, ln2, ln3)[0], d) for name, (k, d) in PAIRS.items()}
    for name in ("2Q0", "P", "3Q1", "J"):
        gap, d = rows[name]
        _, tail = ordered_bounds(d)
        require(gap >= SOURCE_CORRECTION + tail[2], ("direct reciprocal contradiction", name))
        print(f"{name}, all Delta >= 1: direct reciprocal contradiction")

    for name, end, expected in (
        ("Q1", 6, (2, 6, 7, 170, 148_321_243_831_049_467_988)),
        ("2Q1", 4, (2, 4, 7, 170, 42_408_176_569_367_664_067)),
    ):
        gap, d = rows[name]
        proof = transfer(gap, 1, ordered_bounds(d), 0, 2, end)
        require(proof == expected, ("inclusion in Weaver Q0", name, proof))
        print(f"{name}, all Delta >= 1: Weaver Q0, (low, tail, target, height, cap) = {proof}")

    gap, d = rows["Q0"]
    require(1 + RUNS / gap < 2**72 and Fraction(4, B + 2) < Fraction(2, 3)**72,
            "same-origin endpoint credit at Delta >= 2")
    proof = transfer(gap, 2, ordered_bounds(d), 0, 7, 11)
    require(proof == (7, 11, 12, 146, 453_027_402_666_008_300_801), "Q0 at Delta >= 2")
    print(f"Q0, Delta >= 2: Weaver Q0, (low, tail, target, height, cap) = {proof}")

    baseline, tail = ordered_bounds(d)
    require((baseline[10], baseline[11]) == (23, 92), "available Q0 delta=1 ranks")
    require(slack(gap, 1, 6, 10, tail) <= 0, "Q0 delta=1, tail at rank 10 is underfunded")
    require(gap < SOURCE_CORRECTION + tail[2] and not has_transfer(gap, 1, (baseline, tail)),
            "no remaining inclusion by the fixed-budget transfer")
    for single in (69, 92, 146):
        trial = ordered_bounds(d, (single,))
        require(gap < SOURCE_CORRECTION + trial[1][2] and not has_transfer(gap, 1, trial),
                ("one-window failure", single))
    print("Q0, Delta = 1: OPEN; rank floors 10,11 have heights 23,92")
    print("Hypothetical D5 at H=69 alone, at H=92 alone, or at H=146 alone: no transfer")

    conditional_bounds = ordered_bounds(d, (92, 146))
    proof = transfer(gap, 1, conditional_bounds, 0, 6, 10)
    require(proof == (6, 10, 11, 146, 453_027_402_666_008_300_866), "conditional Q0 inclusion")
    heights = conditional_bounds[0]
    require(heights[10:16] == [92, 146, 146, 170, 231, 256], "conditional tail heights")
    print(f"CONDITIONAL on D5 at H=92 and 146: Weaver Q0, (low, tail, target, height, cap) = {proof}")


def main():
    ln2, ln3 = log_interval(2), log_interval(3)
    clock_sieve(ln2, ln3)
    replay_caps()
    exclusions(ln2, ln3)
    print("PASS: exact partial reduction; Terras 89 remains open in Q0 with Delta = 1")


if __name__ == "__main__":
    main()
