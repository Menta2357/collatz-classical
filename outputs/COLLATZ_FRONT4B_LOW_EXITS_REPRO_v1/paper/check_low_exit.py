"""Exact guards and inverse-source obstructions for the first low ShortExit."""

from fractions import Fraction
from os import environ
from pathlib import Path
import sys


ROW = Path(__file__).resolve().parents[2] / "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper"
sys.path.insert(0, environ.get("FRONT4B_ROW_PAPER", str(ROW)))
from verificar import Affine, FIRST, ORIGIN, PIVOT, follow, require, valuations_book


WORD = (1, 1, 1, 2, 2, 1, 1, 1, 2, 1)
BOUNDS = {
    (3, 3): (2, 4, 6), (5, 3): (1, 3, 5),
    (3, 4): (0, 2, 4), (5, 4): (0, 1, 3),
}


def phase(J, word):
    h, s, B = valuations_book(word)
    modulus = 2 ** (s + 1)
    r = (2**s - B) * pow(3**h, -1, modulus) % modulus
    require((r - J.base) % 8 == 0, "phase on entry progression")
    period = modulus // 8
    t = ((r - J.base) // 8) * pow(J.step // 8, -1, period) % period
    return t, period


def above(x, bound):
    require(x.base > bound.base and x.step >= bound.step, "strict affine height")


def eligible_residue(x):
    require(x.step % 3 == 0, "uniform ternary residue across the affine family")
    return x.base % 3


def inverse(x, a):
    numerator = 2**a * x.base - 1
    require(numerator > 0 and numerator % 3 == 0 and (2**a * x.step) % 3 == 0, "inverse divisibility")
    y = Affine(numerator // 3, 2**a * x.step // 3)
    require(y.base % 2 == 1 and y.step % 2 == 0, "physical inverse parity")
    return y


def audit_small_high(N, X):
    stack, count, last = [(X, 0, 0)], 0, 0
    while stack:
        Y, used, depth = stack.pop()
        above(Y, N)
        count += 1
        last = max(depth, last)
        r = eligible_residue(Y)
        if r == 0:
            continue
        require(depth < 60, "small-high tree did not terminate")
        a = 1 if r == 2 else 2
        stack.append((inverse(Y, a), used, depth + 1))
        if used < 2:
            stack.append((inverse(Y, a + 2), used + 1, depth + 1))
    return count, last


def audit_depth(N, X, max_depth):
    two, three = [2**i for i in range(2 * max_depth + 10)], [3**i for i in range(max_depth + 1)]
    stack, visited = [(X, 0)], set()
    while stack:
        Y, h = stack.pop()
        key = (Y, h)
        if key in visited:
            continue
        visited.add(key)
        require(Y.base >= N.base and Y.step >= N.step, "paid source in depth search")
        if h == max_depth:
            continue
        r = eligible_residue(Y)
        if r == 0:
            continue
        a, remain = (1 if r == 2 else 2), max_depth - h
        bound_base, bound_step = three[remain] * (N.base + 1), three[remain] * N.step
        base_scale = two[remain - 1]
        while (base_scale * (two[a] * Y.base + 2) < bound_base
               or base_scale * two[a] * Y.step < bound_step):
            stack.append((inverse(Y, a), h + 1))
            a += 2
    return len(visited)


def two_state(Y, r):
    slope = Fraction(3**r, 4**r)
    return Affine(1 + slope * (Y.base - 1), slope * Y.step)


def price_window(Y, N, k, offset, r):
    upper = Affine(k * N.base + offset, k * N.step)
    above(upper, two_state(Y, r))
    if r > 0:
        above(two_state(Y, r - 1), upper)


def odd_reserves(Y, rmax, t0, period):
    out = []
    for r in range(rmax):
        m = 2 ** (2 * r + 2)
        target = 1 + m // 2
        require((target - Y.base) % 2 == 0 and Y.step % 4 == 2, "odd reserve lift")
        z = ((target - Y.base) // 2) * pow(Y.step // 2, -1, m // 2) % (m // 2)
        out.append((r, t0 + period * z, period * m // 2))
    return out


def first_crossing(J, N, V, band, exit_word, expected_book):
    word = WORD + exit_word
    t, m = phase(J, word)
    root, pivot = N.restrict(t, m), V.restrict(t, m)
    whole = FIRST + (2,) * ((band - 3) // 2) + word
    at = pivot
    for e in whole[:-1]:
        at = follow(at, (e,))
        above(at, pivot)
    at = follow(at, whole[-1:])
    above(at, root)
    above(pivot, at)
    require(valuations_book(whole) == expected_book, "complete crossing book")
    print(f"Band {band} exit {exit_word}: t={t} mod {m}, first crossing below V, terminal > N")


def main():
    require(valuations_book(WORD) == (10, 13, 84217), "two weak episodes")
    for band, u, m in ((3, 18, 32), (5, 10, 128)):
        N, V = ORIGIN.restrict(u, m), PIVOT.restrict(u, m)
        J = follow(V, FIRST + (2,) * ((band - 3) // 2))
        for c in (3, 4):
            r_quarter, r_half, r_desc = BOUNDS[band, c]
            for extra in ((), (1,), (2,)):
                full = WORD + (c,) + extra
                t, p = phase(J, full)
                Y, Z = follow(J.restrict(t, p), full), N.restrict(t, p)
                print(f"Band {band}, exit {c}, further {extra}: phase {t}/{p}, "
                      f"restricted tree {audit_small_high(Z, Y)}, arbitrary depth 42 nodes {audit_depth(Z, Y, 42)}")
                if not extra:
                    price_window(Y, Z, 4, 1, r_quarter)
                    price_window(Y, Z, 2, 1, r_half)
                    price_window(Y, Z, 1, 0, r_desc)
                    above(Affine(8 * Z.base + 5, 8 * Z.step), Y)
                    if c == 3:
                        for r in range(r_quarter):
                            U = two_state(Y, r)
                            d = 5 if band == 3 and r == 0 else 4
                            after = Affine(Fraction(3 * U.base + 1, 2**d), Fraction(3 * U.step, 2**d))
                            above(Z, after)
                    print("  Odd-reserve residual (r,t,modulus):", odd_reserves(Y, r_desc, t, p))
        if band == 3:
            first_crossing(J, N, V, band, (3, 4), (15, 24, 23666419))
            first_crossing(J, N, V, band, (4, 2, 2, 2), (17, 27, 281155211))
        else:
            first_crossing(J, N, V, band, (4, 2, 2), (17, 27, 325351403))
    print("PASS")


if __name__ == "__main__":
    main()
