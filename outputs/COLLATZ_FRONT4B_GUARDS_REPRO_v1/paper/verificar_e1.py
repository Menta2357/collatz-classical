"""Exact affine audit of the E1 entries, ternary captures and adaptive obstruction."""

from pathlib import Path
import os
import sys


DEFAULT_ROW = Path(__file__).resolve().parents[2] / "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper"
ROW = Path(os.environ.get("FRONT4B_ROW_PAPER", DEFAULT_ROW))
sys.path.insert(0, str(ROW))

from verificar import (Affine, FIRST, HEADER, ORIGIN, PIVOT, check_book,
                       follow, require, valuations_book)
from verificar_inversas import main as audit_initial_inverse_exclusion


ENTRIES = ((3, 18, 32, 5), (5, 10, 128, 4))
CAPTURES = ((3, 6, 58578, 65536), (5, 7, 79114, 524288))


def above(x, y):
    return x.base > y.base and x.step >= y.step


def entry_word(c):
    return FIRST + (2,) * ((c - 3) // 2)


def check_ternary_price(seed, entry, length, scale, paid):
    denominator = 2 ** (length + 5) * scale
    base = denominator * (seed.base + 1) - 3**length * (entry.base + 1) - 7 * (denominator // 16)
    slope = denominator * seed.step - 3**length * entry.step
    require(paid * base > 0 and paid * slope >= 0, (length, scale, "exact source-price boundary"))


def check_entry(c, residue, period, extra):
    seed = ORIGIN.restrict(residue, period)
    pivot = PIVOT.restrict(residue, period)
    entry = follow(pivot, entry_word(c))
    require(above(entry, seed), (c, "J>N"))
    require((entry.base + 1) % 8 == 0 and entry.step % 8 == 0, (c, "entry phase"))
    require((entry.step // 8) % 2 == 1, (c, "unique dyadic lifting"))
    check_book(seed, entry, valuations_book(HEADER + entry_word(c)))
    half = Affine((entry.base - 1) // 2, entry.step // 2)
    if c == 3:
        require(above(half, seed), (c, "half not paid"))
    else:
        require(above(seed, half), (c, "half paid"))
    paid_bound = 6 if c == 3 else 7
    check_ternary_price(seed, entry, paid_bound, 1, 1)
    check_ternary_price(seed, entry, paid_bound + 1, 1, -1)
    if c == 3:
        check_ternary_price(seed, entry, 9, 3, 1)
        check_ternary_price(seed, entry, 10, 3, -1)
    for a in range(1, extra + 1):
        intercept = 2**a * (4 * entry.base + 2) - 3**a * (seed.base + 1)
        slope = 2**a * 4 * entry.step - 3**a * seed.step
        require(intercept > 0 and slope >= 0, (c, a, "deviation barrier"))
    for length in (2, 6, 48):
        q = 3 * pow(3, -(length + 1), 4) % 4
        target = 2 ** (length + 1) * q
        modulus = 2 ** length
        parameter = ((target - entry.base - 1) // 8) * pow(entry.step // 8, -1, modulus) % modulus
        run_entry = entry.restrict(parameter, modulus)
        local = (1,) * length + (2,)
        finish = follow(run_entry, local)
        require(above(finish, run_entry), (c, length, "expanding rupture"))
        check_book(run_entry, finish, valuations_book(local))
    print(f"c={c}: exact entry, half-source comparison and deviation bound k≤{extra}")


def check_capture(c, length, residue, period):
    seed = ORIGIN.restrict(residue, period)
    pivot = PIVOT.restrict(residue, period)
    entry_row = next(row for row in ENTRIES if row[0] == c)
    require(residue % entry_row[2] == entry_row[1] and period % entry_row[2] == 0,
            (c, "inside the residual"))
    word = entry_word(c) + (1,) * length + (2, 5)
    terminal = follow(pivot, word)
    check_book(seed, terminal, valuations_book(HEADER + word))
    require(terminal.base % 3 == 2 and terminal.step % 3 == 0, (c, "minimum inverse exponent 1"))
    require((terminal.base + 1) % 9 == 0 and terminal.step % 9 == 0, (c, "ternary source"))
    one = Affine((2 * terminal.base - 1) // 3, 2 * terminal.step // 3)
    source = Affine(4 * (terminal.base + 1) // 9 - 1, 4 * terminal.step // 9)
    require(follow(one, (1,)) == terminal, (c, "single-return minimum"))
    require(source.base > 0 and follow(source, (1, 1)) == terminal, (c, "physical capture"))
    check_book(source, terminal, (2, 2, 5))
    require(above(terminal, seed) and above(one, seed) and above(seed, source), (c, "strict margins"))
    print(f"c={c}: u={residue} mod {period}, original={valuations_book(HEADER + word)}, source=(2,2,5)")


def main():
    audit_initial_inverse_exclusion()
    for case in ENTRIES:
        check_entry(*case)
    for case in CAPTURES:
        check_capture(*case)
    print("PASS: exact complement data and two physical affine depth-two captures")


if __name__ == "__main__":
    main()
