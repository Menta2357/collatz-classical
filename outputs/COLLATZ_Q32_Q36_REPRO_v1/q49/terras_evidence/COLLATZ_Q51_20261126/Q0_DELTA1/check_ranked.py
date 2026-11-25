#!/usr/bin/env python3
"""Cotejo de una suma necesaria de recíprocos, sin repetir la bisección."""

from fractions import Fraction
from hashlib import sha256
import json
from math import floor
from pathlib import Path
from runpy import run_path
import sys


HERE = Path(__file__).resolve().parent
PINS = {
    "RECIBO.json": "00a375c544b79651d6b23157b50a7c3dc70342396454eea12beedcab67668e7b",
    "check.py": "fb67b6bc180dd8182c4a4cb216180b56283aa085fc86f86fb836aca6a2fac516",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def main():
    for name, digest in PINS.items():
        require(sha256((HERE / name).read_bytes()).hexdigest() == digest, ("SHA256", name))
    source_cut = json.loads((HERE / "RECIBO.json").read_text())
    sys.dont_write_bytecode = True
    setup = run_path(str(HERE / "check.py"))
    for path, expected in setup["PINS"].items():
        require(sha256((setup["EXPERIMENTS"] / path).read_bytes()).hexdigest() == expected,
                ("inherited SHA256", path))
    q37 = run_path(str(setup["EXPERIMENTS"] / setup["Q37"]))
    b = q37["B"]
    k, d = q37["Q0"]
    u = q37["QUERIES"][0][-2]
    h, _ = q37["ordered_bounds"](d)
    start, rank, low = 11, 12, 7
    require((h[start], h[rank]) == (92, 146) and 2**h[start]-1 > b, "rank floors")
    logs = [q37["log_interval"](base) for base in (2, 3)]
    lambda_lower = q37["gap_interval"](k, d, *logs)[0]
    tail = sum(Fraction(1, 2**h[i]-1) for i in range(start, q37["RUNS"]+1))
    critical = Fraction(4, b)
    margin = u*(lambda_lower-Fraction(1, b*(b+1))-critical-tail)-(start-low)
    require(margin > 0, "reciprocal cut at 4/B")
    bounds = {i: Fraction((7-i)*b, 6-i) for i in range(2, 6)}
    require(bounds[2] == source_cut["necessary_original_N_strict_upper"], "second valley cut")
    for i, bound in bounds.items():
        require(Fraction(i-2, b)+(7-i)/bound == critical, ("rank bound", i))
    print(json.dumps({
        "status": "PASS_Q0_DELTA1_FIVE_RECIPROCAL_NECESSITY",
        "scope": source_cut["scope"],
        "critical_five_reciprocal_sum_strict_lower": [critical.numerator, critical.denominator],
        "valley_rank_strict_upper_rational": {str(i): [r.numerator, r.denominator] for i, r in bounds.items()},
        "floor_1e30_positive_budget_margin": floor(10**30*margin),
        "previous_bisection_reexecuted": False,
        "orbit_runs": 0, "weaver_enumerations": 0,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }, indent=2))


if __name__ == "__main__":
    main()
