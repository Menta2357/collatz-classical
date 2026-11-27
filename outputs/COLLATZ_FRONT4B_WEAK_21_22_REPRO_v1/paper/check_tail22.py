"""Exact integer audit of the two quarter-source tails and their actual E1 phases."""

from pathlib import Path
import os
import sys


DEFAULT_ROW = Path(__file__).resolve().parents[2] / "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper"
ROW = Path(os.environ.get("FRONT4B_ROW_PAPER", DEFAULT_ROW))
sys.path.insert(0, str(ROW))

import verificar as ROW_ARITH
from verificar_inversas import main as earlier_inverse_exclusion


PHASES = (
    (7585, 16384, (2, 2, 10), (2, 4, 3, 2, 1), 16414),
    (56225, 65536, (2, 2, 6, 6), (2, 4, 3, 1, 3, 1), 68698),
)
ENTRIES = ((3, 18, 32), (5, 10, 128))


def valuation(numerator):
    return (numerator & -numerator).bit_length() - 1


def choose_parameter(entry, length, phase, modulus):
    q = phase * pow(3, -length, modulus) % modulus
    target = 2 ** (length + 1) * q
    period = modulus * 2 ** (length - 2)
    correction = (target - (entry.base + 1)) // 8
    return correction * pow(entry.step // 8, -1, period) % period, period


def check_tail(seed, entry, length, phase, modulus, original_head, source_head, constant):
    r, p = choose_parameter(entry, length, phase, modulus)
    original = entry.restrict(r, p)
    origin = seed.restrict(r, p)
    source = ROW_ARITH.Affine((original.base - 3) // 4, original.step // 4)
    ROW_ARITH.require(source.base > 0 and source.base < origin.base and source.step <= origin.step,
                      "positive paid quarter")
    actual = ROW_ARITH.follow(original, (1,) * length + original_head)
    auxiliary = ROW_ARITH.follow(source, (1,) * (length - 2) + source_head)
    ROW_ARITH.require(auxiliary.base == 4 * actual.base + 1 and auxiliary.step == 4 * actual.step,
                      "exact terminal match")
    for t in (0, 3):
        N, Z, W = origin.evaluate(t), actual.evaluate(t), auxiliary.evaluate(t)
        gamma = valuation(3 * Z + 1)
        ROW_ARITH.require(valuation(3 * W + 1) == gamma + 2, "physical final divisions")
        finish = (3 * Z + 1) // 2**gamma
        ROW_ARITH.require(finish == (3 * W + 1) // 2 ** (gamma + 2), "physical final meeting")
        o_book = ROW_ARITH.valuations_book((1,) * length + original_head + (gamma,))
        s_book = ROW_ARITH.valuations_book((1,) * (length - 2) + source_head + (gamma + 2,))
        ROW_ARITH.require(o_book[0] == s_book[0], "separate return counts agree")
        ROW_ARITH.require(o_book[2] == 3**o_book[0] + constant * 2**length, "original cost")
        ROW_ARITH.require(s_book[2] == 3**s_book[0] + constant * 2 ** (length - 2), "source cost")
        j = original.evaluate(t)
        w = source.evaluate(t)
        ROW_ARITH.require(0 < w < N and w % 2 == 1, "strict price")
        ROW_ARITH.require(2**o_book[1] * finish == 3**o_book[0] * j + o_book[2], "original ledger")
        ROW_ARITH.require(2**s_book[1] * finish == 3**s_book[0] * w + s_book[2], "source ledger")


def main():
    earlier_inverse_exclusion()
    for c, r, p in ENTRIES:
        seed = ROW_ARITH.ORIGIN.restrict(r, p)
        pivot = ROW_ARITH.PIVOT.restrict(r, p)
        entry = ROW_ARITH.follow(pivot, ROW_ARITH.FIRST + (2,) * ((c - 3) // 2))
        check = ROW_ARITH.require
        check(entry.base % 3 == 1 and entry.step % 3 == 0, "mirror predecessor obstruction")
        check(64 * (8 * entry.base + 6) > 729 * (seed.base + 1), "inverse margin base")
        check(64 * 8 * entry.step >= 729 * seed.step, "inverse margin slope")
        for length in (2, 7, 48):
            for phase in PHASES:
                check_tail(seed, entry, length, *phase)
    print("PASS: twelve affine physical tails and the second terminal inverse margin")


if __name__ == "__main__":
    main()
