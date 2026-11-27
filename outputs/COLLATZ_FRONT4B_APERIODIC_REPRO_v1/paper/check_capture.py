"""Directed dyadic and ternary checks for the paid subprogression."""

from pathlib import Path
import os
import sys


ROW = Path(os.environ.get("FRONT4B_ROW_PAPER", str(Path(__file__).resolve().parents[2] /
    "COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1/paper")))
sys.path.insert(0, str(ROW))
import verificar as row


def binary_phase(entry, word):
    h, s, cost = row.valuations_book(word)
    modulus = 2 ** (s + 1)
    needed = (2**s - cost) * pow(3**h, -1, modulus) % modulus
    row.require((needed - entry.base) % 8 == 0, "entry phase")
    period = modulus // 8
    t = ((needed - entry.base) // 8) * pow(entry.step // 8, -1, period) % period
    return t, period


def exponent_lift(terminal, K):
    a = 2 if terminal % 3 == 1 else 3
    modulus = 3
    row.require((pow(2, a, modulus) * terminal + 2) % modulus == 0, "base exponent")
    for _ in range(K - 1):
        period = 2 * (modulus // 3)
        modulus *= 3
        good = [a + d * period for d in range(3)
                if (pow(2, a + d * period, modulus) * terminal + 2) % modulus == 0]
        row.require(len(good) == 1, "unique higher exponent digit")
        a = good[0]
    return a


def slope_factors(step):
    e = (step & -step).bit_length() - 1
    q, K = step // 2**e, 0
    while q % 3 == 0:
        q //= 3
        K += 1
    row.require(e > 0 and K > 0 and q == 1, "physical endpoint slope")
    return e, K


def check_real_words():
    for c, u, m in ((3, 18, 32), (5, 10, 128)):
        seed = row.ORIGIN.restrict(u, m)
        entry = row.follow(row.PIVOT.restrict(u, m), row.FIRST + (2,) * ((c - 3) // 2))
        for schedule in (((2, 1), (3, 2)), ((5, 2), (2, 1), (4, 2)), ((2, 2), (7, 1), (3, 1), (6, 2))):
            word = tuple(a for length, b in schedule for a in ((1,) * length + (2, b)))
            for refinement in ((), (1, 1, 1, 2)):
                t, p = binary_phase(entry, word + refinement)
                current = entry.restrict(t, p)
                endpoint = row.follow(current, word)
                row.check_book(current, endpoint, row.valuations_book(word))
                row.follow(endpoint, refinement)
                N = seed.restrict(t, p)
                row.require(endpoint.base > N.base and endpoint.step > N.step, "weak height")
                e, K = slope_factors(endpoint.step)
                a = exponent_lift(endpoint.base, K)
                row.require((pow(2, a, 3**K) * endpoint.base + 2) % 3**K == 0, "source valuation lift")
                print(f"c={c}, episodes={len(schedule)}, extra={len(refinement)}, slope=2^{e}·3^{K}, "
                      f"source terminal valuation uses {a.bit_length()} bits")


def check_materialized():
    # A small affine history permits materializing the whole ternary period.
    J = row.Affine(7, 8)
    word = (1, 1, 2, 1, 1, 1, 1, 2, 2)
    t, p = binary_phase(J, word)
    N = J.restrict(t, p)
    X = row.follow(N, word)
    e, K = slope_factors(X.step)
    a = exponent_lift(X.base, K)
    h = 2 * (a + e + 2 * K + 1)
    power_two_a = 2**a
    normalized_base = (power_two_a * X.base + 2) // 3**K
    period = 3 ** (h + 1 - K)
    select = -normalized_base * pow(2 ** (a + e), -1, period) % period
    cutoff = 2**h * (power_two_a * X.base + 2) + 1
    t0 = select + max(0, (cutoff - select + period - 1) // period) * period
    for t in (t0, t0 + period):
        n, x = N.evaluate(t), X.evaluate(t)
        first = (power_two_a * x - 1) // 3
        q = (first + 1) // (2 * 3**h)
        w = 2 ** (h + 1) * q - 1
        row.require(w % 2 == 1 and 0 < w < n < x, "strict price and high meeting")
        row.require(2 * 3**h * q - 1 == first, "exact all-ones factor")
        row.require(3 * first + 1 == power_two_a * x, "physical terminal valuation")
        row.require(2 ** (h + a) * x == 3 ** (h + 1) * w + 3 ** (h + 1) - 2 ** (h + 1), "source book")
    print(f"Materialized weak affine test: h={h}, a={a}, two paid sources with exact separate books")


def main():
    check_real_words()
    check_materialized()
    print("PASS")


if __name__ == "__main__":
    main()
