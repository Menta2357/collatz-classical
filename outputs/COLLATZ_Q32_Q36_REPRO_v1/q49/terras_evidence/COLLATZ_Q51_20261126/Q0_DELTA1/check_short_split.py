#!/usr/bin/env python3
"""Cotejo algebraico del tramo corto y de su separación física."""

from fractions import Fraction
from hashlib import sha256
import json
from math import ceil, floor
from pathlib import Path
from runpy import run_path
import sys


HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
Q37 = "COLLATZ_Q37_20261125/TERRAS89_PAPER/check.py"
PINS = {Q37: "70da49e25ded08f542ee969d1e2d8b243dc7d5fe5650e9e43ef765fa28a1233d"}


def require(condition, label):
    if not condition:
        raise ArithmeticError(label)


def main():
    for path, digest in PINS.items():
        require(sha256((EXPERIMENTS / path).read_bytes()).hexdigest() == digest, ("SHA256", path))
    sys.dont_write_bytecode = True
    parent = run_path(str(EXPERIMENTS / Q37))
    k, d = parent["Q0"]
    b, m = parent["B"], parent["RUNS"]
    alpha, g = parent["ALPHA"], parent["geometric_sum"]
    logs = [parent["log_interval"](base) for base in (2, 3)]
    gap = parent["gap_interval"]
    require(m == 89 and 35*10**18 < 2**65 and 66 in parent["FOUR_RUN_BITS"], "rank domain")
    require(logs[1][1]/logs[0][0] < alpha, "rational upper bound for alpha")
    base = 66*(1+alpha)

    def capacity(runs):
        steps = max(0, runs-4)
        return ceil(65*g(steps)+base*alpha**steps)-1

    half = capacity(m//2)
    long_min = 80
    require((half, capacity(long_min-1), capacity(long_min)) ==
            (28_221_897_930, 282_651_257_440_574_721, 447_991_643_824_992_910), "run capacities")
    require(d-half > capacity(long_min-1), "one part has at least eighty runs")
    short_runs = m-long_min
    short = capacity(short_runs)
    require((short_runs, short) == (9, 2706), "final short part")
    p_big, q_big = parent["P"], parent["Q"]
    require(min(q_big,d-q_big) > short, "exclude the global lower-neighbor split")

    p, q = 1054, 665
    p_upper, q_upper = 485, 306
    require(p_upper*q-p*q_upper == 1, "short unimodular basis")
    require((short-q_upper)//q == 3, "small clock restriction")
    lower_gap, upper_gap = gap(p, q, *logs)
    delta_lower, delta_upper = -upper_gap, -lower_gap
    up_lower, _ = gap(p_upper, q_upper, *logs)
    global_lower, global_upper = gap(k, d, *logs)
    require(delta_lower > 0 and global_lower > 0, "logarithmic signs")
    suffix_gap_lower = up_lower-3*delta_upper
    require(suffix_gap_lower > global_upper > 0, "one-sided gap of the short suffix")
    distance_lower = {
        side: 2*(floor((b*value+Fraction(5,9))/2)+1)
        for side,value in (("prefix_short",delta_lower),("suffix_short",suffix_gap_lower-global_upper))
    }
    print(json.dumps({
        "status": "PASS_TWO_VALLEY_SHORT_SPLIT",
        "scope": {"steps": k, "odds": d, "runs": m, "delta": 1},
        "half_odds_upper": half,
        "long_part_runs_lower": long_min,
        "short_part_runs_upper": short_runs,
        "short_part_odds_upper": short,
        "short_part_basis": [[p,q], [p_upper,q_upper]],
        "smallest_possible_even_distance_lower_by_side": distance_lower,
        "global_lower_neighbor_split_excluded": [p_big, q_big],
        "orbital_runs": 0, "clock_enumerations": 0,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }, indent=2))


if __name__ == "__main__":
    main()
