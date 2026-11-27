"""Independently replay the seven strict product bounds using exact fractions."""

from ast import literal_eval
from fractions import Fraction
from math import floor
from pathlib import Path
import re


LEAN = Path(__file__).resolve().parents[1] / "lean"
SCALE = 2**256


def check(condition, description):
    if not condition:
        raise ArithmeticError(description)


def source(module):
    return (LEAN / f"{module}.lean").read_text()


def extract(pattern, text):
    matched = re.search(pattern, text, re.DOTALL)
    if matched is None:
        raise ValueError(f"Missing Lean table or constant matching {pattern}")
    return matched[1]


def add_clock(left, right):
    return left[0] + right[0], left[1] + right[1]


def upper_ratio(clock, text, prefix):
    k, d = clock
    mantissa, exponent = SCALE, 0
    trace = []
    for digit in f"{d:b}":
        bit = int(digit)
        unscaled = Fraction(mantissa, SCALE)**2 * 3**bit
        shift = max(i for i in range(4) if 2**i <= unscaled)
        mantissa = floor(unscaled * Fraction(SCALE, 2**shift)) + 1
        exponent = 2*exponent + shift
        trace.append((bit, shift))
    expected_trace = literal_eval(extract(rf"def {prefix}Trace .*? :=\s*(\[.*?\])", text))
    expected_mantissa = int(extract(rf"def {prefix}Bound .*? :=\s*(\d+)", text))
    check(trace == expected_trace, f"{prefix} binary normalization trace")
    check(mantissa == expected_mantissa, f"{prefix} upward-rounded mantissa")
    check(exponent == k-1, f"{prefix} dyadic exponent")
    return Fraction(mantissa, 2*SCALE)


def factor(height):
    return Fraction(height+1, height)


def main():
    terras88 = source("Terras88")
    q0, q1, j = (
        literal_eval(extract(rf"def {key} : Nat × Nat := (\(\d+,\d+\))", terras88))
        for key in ("q0Clock", "q1Clock", "lastClock")
    )
    twice_q0, twice_q1 = add_clock(q0, q0), add_clock(q1, q1)
    clocks = [add_clock(q0, q1), add_clock(twice_q1, q1), add_clock(twice_q1, twice_q1),
              j, add_clock(j, q1), add_clock(j, twice_q1), add_clock(j, j)]
    lattice_rows = literal_eval(extract(r"def survivors .*? :=\s*(\[.*?\])",
                                        source("Terras90ClockTable")))
    excluded = {q0, q1, twice_q0, twice_q1}
    check(clocks == [pair for pair in lattice_rows if pair not in excluded],
          "seven lattice clocks after the four earlier exclusions")

    low_factors = [3, 1, 0, 0, 0, 0, 0]
    numeric = source("Terras90FinalNumeric")
    rows = literal_eval(extract(r"rows=(\[.*?\]) := by decide", numeric))
    check(rows == list(zip(clocks, low_factors)), "Lean residual rows and floor multiplicities")

    r0 = upper_ratio(q0, source("Terras90Q0Ratio"), "q0")
    r1 = upper_ratio(q1, source("Terras90Q1Numeric"), "q1")
    rj = upper_ratio(j, numeric, "j")
    ratios = [r0*r1, r1**3, r1**4, rj, rj*r1, rj*r1**2, rj**2]
    base = int(extract(r"def verifiedHeight : Nat := (\d+)", terras88))
    q0_price = int(extract(r"def q0Price : Nat := (\d+)", terras88))
    q1_price = int(extract(r"priceEnvelope (\d+)", numeric))
    h92, h146 = 2**92-1, 2**146-1
    old_q0 = factor(base)**4 * factor(q0_price)**4 * factor(h92) * factor(h146)**80
    old_q1 = factor(q1_price)**5 * factor(h146)**84
    check(r0*old_q0 < 1 and r1*old_q1 < 1, "inherited Q0 and Q1 product comparisons")
    targets = [factor(base)**n * factor(h92)**(89-n) for n in low_factors]
    for target, inherited in zip(targets[:3], [old_q0*old_q1, old_q1**3, old_q1**4]):
        check(target < inherited, "strict bound by the inherited product envelope")

    for clock, ratio, target in zip(clocks, ratios, targets):
        margin = floor(10**50 * (1-ratio*target))
        check(margin > 0, f"strict product comparison for {clock}")
        print(f"{clock}: floor of scaled lower bound on discounted margin = {margin}")


if __name__ == "__main__":
    main()
