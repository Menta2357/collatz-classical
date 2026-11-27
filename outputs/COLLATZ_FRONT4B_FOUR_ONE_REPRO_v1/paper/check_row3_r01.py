"""Exact affine verification for the two short readmissions and the new first crossing."""

from os import environ
from pathlib import Path
import sys


ROW = Path(__file__).resolve().parents[2] / "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper"
sys.path.insert(0, environ.get("FRONT4B_ROW_PAPER", str(ROW)))
from verificar import Affine, FIRST, HEADER, ORIGIN, PIVOT, follow, require, valuations_book


WORD = (1, 1, 1, 2, 2, 1, 1, 1, 2, 1, 4)
EXPECTED = {
    (1, 2, 2, 2): (2901944, 4194304, (80, 126, 1197101608222418270618232455065949759425)),
    (2, 1, 2, 2): (509880, 4194304, (80, 126, 1209064660184482513474366718608472860609)),
    (1, 1, 4): (477112, 2097152, (79, 125, 389286197438383373804782899913260726251)),
}


def phase(J, tail):
    h, s, B = valuations_book(tail)
    modulus = 2 ** (s + 1)
    wanted = (2**s - B) * pow(3**h, -1, modulus) % modulus
    require((wanted - J.base) % 8 == 0, "phase compatible with two ones")
    period = modulus // 8
    return ((wanted - J.base) // 8) * pow(J.step // 8, -1, period) % period, period


def scaled(x, a, b=0):
    return Affine(a * x.base + b, a * x.step)


def below(x, y):
    require(x.base < y.base and x.step <= y.step, "strict affine inequality")


def verify_cut(N, V, J, continuation):
    prefix = WORD + continuation
    t, period = phase(J, prefix)
    t_expected, p_expected, book = EXPECTED[continuation]
    require((t, period) == (t_expected, p_expected), "exact family")
    n, v, j = [a.restrict(t, period) for a in (N, V, J)]
    U = follow(j, WORD + ((2,) if continuation[0] == 2 else ()))
    X = follow(j, prefix)
    below(n, X)
    below(X, U)
    require(valuations_book(HEADER + FIRST + prefix) == book, "absolute exact book")
    if continuation == (1, 1, 4):
        below(X, v)
        reached = v
        for a in (FIRST + prefix)[:-1]:
            reached = follow(reached, (a,))
            below(v, reached)
    else:
        below(X, scaled(n, 2, 1))
    print(f"{continuation}: t={t} mod {period}, original clock and cost {book}")


def verify_splits(N, J):
    for r in (0, 1):
        leading = WORD + (2,) * r
        t, p = phase(J, leading + (1,))
        U, n = follow(J.restrict(t, p), leading), N.restrict(t, p)
        below(scaled(U, 1, 1), scaled(n, 3, 1))
        below(scaled(U, 9, 5), scaled(n, 32))
        if r == 0:
            below(scaled(U, 27, 19), scaled(n, 128))
        else:
            below(scaled(U, 27, 19), scaled(n, 64, 32))
        for tail in ((1, 2, 1), (1, 2, 2, 1), (1, 1, 2)):
            t, p = phase(J, leading + tail)
            follow(J.restrict(t, p), leading + tail)
            print(f"r={r}, remaining prefix {tail}: t={t} mod {p}")


def main():
    N, V = ORIGIN.restrict(18, 32), PIVOT.restrict(18, 32)
    J = follow(V, FIRST)
    for continuation in EXPECTED:
        verify_cut(N, V, J, continuation)
    verify_splits(N, J)
    require(3 * 3**2 <= 2 * 2**4 and 3 * 3**4 <= 2 * 2**7, "adapted high thresholds")
    print("PASS")


if __name__ == "__main__":
    main()
