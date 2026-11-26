#!/usr/bin/env python3
"""Exact source cutoff for Terras89, Q0 and terminal N+1."""

from fractions import Fraction
from hashlib import sha256
import json
from pathlib import Path
from runpy import run_path
import sys


HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
Q37 = "COLLATZ_Q37_20261125/TERRAS89_PAPER/check.py"
PINS = {
    Q37: "70da49e25ded08f542ee969d1e2d8b243dc7d5fe5650e9e43ef765fa28a1233d",
    "COLLATZ_Q37_20261125/TERRAS89_PAPER/RECIBO.json":
        "e678a72f91a885b7ea150c96a8f249829b1b525d8ffcc0487fb4e060729fc99d",
}


def require(condition, name):
    if not condition:
        raise ArithmeticError(name)


def main():
    for path, digest in PINS.items():
        require(sha256((EXPERIMENTS / path).read_bytes()).hexdigest() == digest, ("SHA256", path))
    sys.dont_write_bytecode = True
    parents = run_path(str(EXPERIMENTS / Q37))
    b = parents["B"]
    runs = parents["RUNS"]
    k, d, weaver_low, weaver_start, weaver_rank, u, height = parents["QUERIES"][0]
    require((k, d, u, height) == (630_118_245_525_664_765, 397_560_349_370_386_783,
                                 453_027_402_666_008_300_866, 146), "exact query Q0")
    require((k, d) == parents["Q0"] and weaver_rank - weaver_low == 5, "five blocks")
    low, start, rank = 7, 11, 12
    require(rank == low + (weaver_rank - weaver_low) and runs == 89 and runs > low * (rank - low),
            "chronological extraction")
    floors, _ = parents["ordered_bounds"](d)
    require(floors[11] == 92 and floors[12] == height and 2*b < 2**floors[11]-1, "available floors")
    logs = [parents["log_interval"](base) for base in (2, 3)]
    lambda_lower = parents["gap_interval"](k, d, *logs)[0]
    denominators = [2**floors[i]-1 for i in range(start, runs + 1)]
    require(all(den > 2*b for den in denominators), "constant tail on bisection interval")
    tail = sum(Fraction(1, den) for den in denominators)

    def margin(lower_source):
        correction = Fraction(1, lower_source*(lower_source+1))
        eta = lambda_lower - correction - Fraction(low-2, lower_source) - tail
        return u*eta-(start-low)

    require(margin(b) < 0 <= margin(2*b), "preregistered transition")
    left, right, iterations = b, 2*b, 0
    while right-left > 1:
        mid = (left + right)//2
        if margin(mid) < 0:
            left = mid
        else:
            right = mid
        iterations += 1
    require(left == right-1 and margin(left) < 0 <= margin(right), "consecutive threshold values")
    require(b < right < 2**65, "height of remaining original source")

    receipt = {
        "status": "PASS_EXACT_Q0_DELTA1_UPPER_SOURCE_CUTOFF",
        "scope": {"shortcut_steps": k, "odd_departures": d, "maximal_odd_runs": runs, "delta": 1},
        "source_lower_bound_inherited_strict": b,
        "excluded_original_N_greater_equal": right,
        "necessary_original_N_strict_upper": right,
        "necessary_first_odd_run_upper": 64,
        "rank_extraction": {"low": low, "tail_starts": start, "target_rank": rank,
                            "target_minimum": 2**height-1, "blocks_at_most": rank-low},
        "weaver_strict_source_upper": u,
        "tail_floors_at_start": floors[start:start+6],
        "floor_1e30_budget_margins": [
            {"L": lower_source, "floor": (10**30*margin(lower_source)).__floor__()}
            for lower_source in (left, right)
        ],
        "bisection_iterations": iterations,
        "orbit_runs": 0,
        "weaver_enumerations": 0,
        "uses_new_five_run_capacities": False,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }
    print(json.dumps(receipt, indent=2))


if __name__ == "__main__":
    main()
