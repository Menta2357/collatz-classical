#!/usr/bin/env python3
"""Exact arithmetic for the second-valley coefficient split."""

from fractions import Fraction
from hashlib import sha256
import json
from math import floor
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
    p, q = parent["P"], parent["Q"]
    require((k, d, p, q) == (630_118_245_525_664_765, 397_560_349_370_386_783,
                            423_372_672_964_960_618, 267_118_416_222_671_843), "fixed pairs")
    require(q*k-p*d == 1 and q < d < 2*q, "unimodularity and denominator ordering")
    logs = [parent["log_interval"](base) for base in (2, 3)]
    lambda_lower, _ = parent["gap_interval"](k, d, *logs)
    _, negative_delta_upper = parent["gap_interval"](p, q, *logs)
    delta_lower = -negative_delta_upper
    require(lambda_lower > 0 and delta_lower > 0, "logarithmic signs")
    b = parent["B"]
    distances = [b*beta + Fraction(5, 9) for beta in (delta_lower, 2*delta_lower+lambda_lower)]
    even_lower = [2*(floor(value/2)+1) for value in distances]
    print(json.dumps({
        "status": "PASS_SECOND_VALLEY_SPLIT_CONSTANTS",
        "global_Q0": {"steps": k, "odds": d},
        "lower_basis_pair": {"steps": p, "odds": q},
        "determinant": q*k-p*d,
        "unique_first_case_suffix": {"steps": k-p, "odds": d-q},
        "floor_1e30_log_gap_lower_bounds": [floor(10**30*gap) for gap in (delta_lower, lambda_lower)],
        "even_distance_lower_bounds": {"unique_lower_basis_pair": even_lower[0], "other_split": even_lower[1]},
        "floor_1e12_distance_thresholds_before_even_rounding": [floor(10**12*value) for value in distances],
        "clock_enumerations": 0, "orbit_runs": 0,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE/"RECORD_PREREGISTRO.md").read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }, indent=2))


if __name__ == "__main__":
    main()
