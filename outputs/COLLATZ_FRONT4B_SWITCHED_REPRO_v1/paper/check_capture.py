"""Exact affine witnesses for the switched price windows and the adaptive twos."""

import os
from pathlib import Path
import sys


DEFAULT_ROW = Path(__file__).resolve().parents[2] / "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper"
ROW = Path(os.environ.get("FRONT4B_ROW_PAPER", DEFAULT_ROW))
sys.path.insert(0, str(ROW))
import verificar as row


def choose_parameter(entry, word):
    h, s, book = row.valuations_book(word)
    modulus = 2 ** (s + 1)
    wanted = (2**s - book) * pow(3**h, -1, modulus) % modulus
    row.require((wanted - entry.base) % 8 == 0 and entry.step % 8 == 0, "compatible E1 entry")
    period = modulus // 8
    t = ((wanted - entry.base) // 8) * pow(entry.step // 8, -1, period) % period
    return t, period


def check_growth(J, Z, length, next_length):
    q = (J.base + 1) // 2 ** (length + 1)
    new = (Z.base + 1) // 2 ** (next_length + 1)
    q_step = J.step // 2 ** (length + 1)
    new_step = Z.step // 2 ** (next_length + 1)
    row.require(new > q and new_step >= q_step, "strict cofactor growth")


def check_price(entry, seed, length, next_length, branch, original_tail, source_tail):
    first = (1,) * length + (2, branch)
    word = first + (1,) * next_length + original_tail
    r, p = choose_parameter(entry, word)
    N, J = seed.restrict(r, p), entry.restrict(r, p)
    R = row.follow(J, first[:-1])
    Z = row.follow(J, first)
    height = R if branch == 1 else Z
    row.require(height.base < 4 * N.base + 1 and height.step < 4 * N.step, "paid start height")
    w = row.Affine((height.base - 3) // 4, height.step // 4)
    row.require(0 < w.base < N.base and w.step < N.step, "strict quarter-source price")
    source_ones = next_length - 1 if branch == 1 else next_length - 2
    meeting = row.follow(J, word)
    row.require(row.follow(w, (1,) * source_ones + source_tail) == meeting, "exact switched meeting")
    check_growth(J, Z, length, next_length)
    row.check_book(J, meeting, row.valuations_book(word))


def priced_twos(entry, seed, prefix):
    h, s = len(prefix), sum(prefix)
    num, den = entry.step * 3**h, seed.step * 2**s
    r = 0
    while num >= 4 * den:
        num *= 3
        den *= 4
        r += 1
    row.require(r > 0 and 3 * den < num < 4 * den, "strict slope interval")
    return r


def check_delayed(entry, seed, length, next_length, branch):
    first = (1,) * length + (2, branch)
    prefix = first + (1,) * next_length + (2, 3 - branch)
    twos = priced_twos(entry, seed, prefix)
    word = prefix + (2,) * twos + (3,)
    r, p = choose_parameter(entry, word)
    N, J = seed.restrict(r, p), entry.restrict(r, p)
    X = row.follow(J, word[:-1])
    lower = X.step - 3 * N.step
    upper = 4 * N.step - X.step
    reserve = 1 + max(0, (3 * N.base - X.base) // lower, (X.base - 4 * N.base) // upper)
    N, J = N.restrict(reserve, 1), J.restrict(reserve, 1)
    X = row.follow(J, word[:-1])
    for valuation in word:
        J = row.exact_edge(J, valuation)
        row.require(J.base > N.base and J.step >= N.step, "all original states above N")
    w = row.Affine((X.base - 1) // 4, X.step // 4)
    row.require(0 < w.base < N.base and w.step < N.step, "delayed source price")
    row.require(row.follow(w, (1,)) == J, "delayed physical meeting")
    start = entry.restrict(r + p * reserve, p)
    check_growth(start, row.follow(start, first), length, next_length)
    row.check_book(start, J, row.valuations_book(word))
    return twos


def main():
    windows = {
        3: ((2, 1, 3), (2, 2, 2), (3, 2, 3)),
        5: ((2, 1, 3), (3, 1, 4), (2, 2, 2), (3, 2, 3)),
    }
    for c, u, modulus in ((3, 18, 32), (5, 10, 128)):
        seed = row.ORIGIN.restrict(u, modulus)
        pivot = row.PIVOT.restrict(u, modulus)
        entry = row.follow(pivot, row.FIRST + (2,) * ((c - 3) // 2))
        for length, branch, max_h in windows[c]:
            for H in range(2, max_h + 1):
                if branch == 1:
                    check_price(entry, seed, length, H, branch, (2, 2, 10, 1), (2, 4, 3, 2, 1, 3))
                    check_price(entry, seed, length, H, branch, (2, 2, 6, 6, 1), (2, 4, 3, 1, 3, 1, 3))
                else:
                    check_price(entry, seed, length, H, branch, (2, 1, 6, 1), (2, 1, 1, 2, 1, 3))
        for length, H in ((2, 2), (4, 3), (12, 12), (37, 37)):
            for b in (1, 2):
                twos = check_delayed(entry, seed, length, H, b)
                print(f"c={c}, L={length}, H={H}, b={b}: paid after {twos} additional twos")
    print("PASS: switched paid source families, strict growth, exact clocks and no earlier descent")


if __name__ == "__main__":
    main()
