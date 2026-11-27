"""Exhaust the early affine boundary and replay exact late inverse substitutions."""

from itertools import product
from os import environ
from pathlib import Path
import sys


ROW = Path(__file__).resolve().parents[2] / "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper"
sys.path.insert(0, environ.get("FRONT4B_ROW_PAPER", str(ROW)))
from verificar import Affine, FIRST, ORIGIN, PIVOT, follow, require, valuations_book


def binary_phase(entry, word):
    h, s, cost = valuations_book(word)
    modulus = 2 ** (s + 1)
    target = (2**s - cost) * pow(3**h, -1, modulus) % modulus
    if modulus <= 8:
        require(entry.base % modulus == target, "small prefix phase")
        return 0, 1
    require((target - entry.base) % 8 == 0, "physical prefix phase")
    period = modulus // 8
    t = ((target - entry.base) // 8) * pow(entry.step // 8, -1, period) % period
    return t, period


def scale(x, a, c=0):
    return Affine(a * x.base + c, a * x.step)


def divide(x, d):
    require(x.base % d == 0 and x.step % d == 0, "exact affine division")
    return Affine(x.base // d, x.step // d)


def inverse(x, a):
    prior = divide(scale(x, 2**a, -1), 3)
    require(prior.base > 0 and prior.base % 2 == 1 and prior.step % 2 == 0, "physical inverse")
    return prior


def residue(x):
    require(x.step % 3 == 0, "uniform residue in entire affine family")
    return x.base % 3


def low_value(x):
    r = residue(x)
    require(r != 0, "a multiple of 3 has no inverse")
    return 1 if r == 2 else 2


def above(x, bound):
    require(x.base > bound.base and x.step >= bound.step, "strict height over origin or earlier pivot")


def affine_tree(N, X):
    """Both choices at a unit, for at most two highs. All leaves must die."""
    stack = [(X, 0, 0)]
    count, deepest = 0, 0
    while stack:
        current, used, depth = stack.pop()
        count += 1
        deepest = max(deepest, depth)
        above(current, N)
        if residue(current) == 0:
            continue
        require(depth < 60, "boundary tree did not terminate")
        a = low_value(current)
        stack.append((inverse(current, a), used, depth + 1))
        if used < 2:
            stack.append((inverse(current, a + 2), used + 1, depth + 1))
    return count, deepest


def verify_early():
    words = sorted({
        ((1, 1, 2, b) + (1, 1, 2, d))[:k]
        for b, d in product((1, 2), repeat=2) for k in range(9)
    }, key=lambda word: (len(word), word))
    for c, u, m in ((3, 18, 32), (5, 10, 128)):
        seed = ORIGIN.restrict(u, m)
        entry = follow(PIVOT.restrict(u, m), FIRST + (2,) * ((c - 3) // 2))
        total, deepest = 0, 0
        for word in words:
            t, period = binary_phase(entry, word)
            N = seed.restrict(t, period)
            terminal = follow(entry.restrict(t, period), word)
            states, depth = affine_tree(N, terminal)
            total += states
            deepest = max(deepest, depth)
        print(f"Early c={c}: {len(words)} affine targets, {total} inverse states, depth {deepest}, all leaves die")


def low_chain(start, exponents, bound):
    above(start, bound)
    for a in exponents:
        require(low_value(start) == a, "exact low inverse valuation")
        start = inverse(start, a)
        above(start, bound)
    require(residue(start) == 0, "no further inverse")
    return start


def verify_late():
    for is_multiple in (False, True):
        Q = Affine(15, 18) if is_multiple else Affine(1, 6)
        J = scale(Q, 8, -1)
        x = scale(Q, 54, -1)
        cases = (scale(Q, 144, -3), scale(Q, 96, -3), scale(Q, 64, -3))
        if is_multiple:
            cases += (scale(divide(Q, 3), 128, -3),)
        for second_high in cases:
            above(x, J)
            require(low_value(x) == 1, "between highs only a one")
            require(inverse(x, 3) == second_high, "exact second high inversion")
            above(second_high, J)
            x = inverse(x, 1)
        require(residue(x) == 0, "all-ones inverse limit after first high")
        above(x, J)

    q = Affine(1, 2)
    low_chain(scale(q, 81, 4), (2, 1), scale(q, 8, -1))
    for old_b in (1, 2):
        D = 2 ** (4 + old_b)
        c = 2 ** (old_b + 1) - 1
        p = Affine((D - c) * pow(81, -1, 2 * D) % (2 * D), 2 * D)
        q = divide(scale(p, 81, c), D)
        exponents = (2, 2, 2, 2) if old_b == 1 else (2, 2, 2, 1, 2, 2)
        low_chain(scale(q, 108, 1), exponents, scale(p, 8, -1))

    q = Affine(9, 16)
    A = divide(scale(q, 81, 1), 2)
    J = scale(q, 8, -1)
    low_chain(A, (1,), J)
    require(inverse(A, 3) == scale(q, 108, 1), "first-one departure after double two")
    print("Late affine substitutions, exact inverse valuations, prices and blocking residues PASS")


if __name__ == "__main__":
    verify_early()
    verify_late()
