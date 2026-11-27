#!/usr/bin/env python3
"""Independently enumerate the full integer strip and audit the product rows."""

from fractions import Fraction
from pathlib import Path
import re


LEAN = Path(__file__).resolve().parents[1] / "lean"
LOG_SCALE = 10**60
BUDGET_SCALE = 10**55
SEED_FLOOR = 28 * 10**18
Q0_PRICE = 453027402666008300866
LOG2 = 693147180559945309417232121458176568075500134360255254120680
LOG3 = 1098612288668109691395245236922525704647490557822749451734694
BASIS_K, BASIS_D = 206745572560704147, 130441933147714940
OTHER_K, OTHER_D = 423372672964960618, 267118416222671843
Q0 = (630118245525664765, 397560349370386783)
Q1 = (7354673373747273033, 4640282259296926456)
TWICE_Q1 = (2 * Q1[0], 2 * Q1[1])


def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)


def ceil(value):
    return -(-value.numerator // value.denominator)


def enumerate_strip():
    require(OTHER_D * BASIS_K - OTHER_K * BASIS_D == 1, "Basis determinant")
    low = BASIS_K * LOG2 - BASIS_D * (LOG3 + 1)
    high = BASIS_K * (LOG2 + 1) - BASIS_D * LOG3
    epsilon_low = OTHER_D * LOG3 - OTHER_K * (LOG2 + 1)
    epsilon_high = OTHER_D * (LOG3 + 1) - OTHER_K * LOG2
    strip = ceil(Fraction(91 * LOG_SCALE, SEED_FLOOR))
    cap = 2**72
    max_index = (OTHER_D * strip + cap * epsilon_high) // LOG2
    require(max_index == 11185 and epsilon_low > 0, "Strip range and orientation")

    alpha = Fraction(317, 200)
    capacities = [ceil(sum(alpha**i for i in range(92 - r)) + r - 1)
                  for r in range(2, 92)]
    prices = [ceil(Fraction(BUDGET_SCALE, max(SEED_FLOOR, 2**i - 1)))
              for i in range(181)]
    discount_price = ceil(Fraction(BUDGET_SCALE, SEED_FLOOR * (SEED_FLOOR + 1)))

    eligible = 0
    survivors = []
    for h in range(1, max_index + 1):
        lower_j = max(0, (h * low - strip) // epsilon_high + 1)
        upper_j = (h * high - 1) // epsilon_low
        for j in range(lower_j, upper_j + 1):
            k, d = h * BASIS_K + j * OTHER_K, h * BASIS_D + j * OTHER_D
            if d >= cap:
                continue
            eligible += 1
            budget = discount_price + sum(prices[min(180, d // c)] for c in capacities)
            if h * low - j * epsilon_high < 100000 * budget:
                survivors.append((k, d))
    require(eligible == 22145 and len(survivors) == 18, "Wrong strip cardinality")
    return survivors


def rank_capacity(runs):
    lower = runs - 1 if runs >= 6 else min(runs, 4)
    alpha = Fraction(485, 306)
    if lower <= 2:
        return (0, 1, Fraction(3, 2))[lower]
    if lower <= 4:
        return 1 + alpha
    return sum(alpha**j for j in range(lower - 3))


def check_row(clock, rank, height, seed_price):
    k, d = clock
    require(2 <= rank and 5 * rank < 91, f"Invalid rank: {clock}")
    capacity = rank_capacity(92-rank) + (rank-1)*rank_capacity(1) + 2*rank
    require(height * capacity < d, f"Rank comparison failed: {clock}")
    payment = Fraction(rank - 2, seed_price) + Fraction(92 - rank, 2**height - 1)
    gap = Fraction(k * LOG2 - d * (LOG3 + 1), LOG_SCALE)
    require(payment < gap, f"Strict gap comparison failed: {clock}")


def main():
    sieve = (LEAN / "Terras91ClockSieve.lean").read_text().split("def survivors", 1)[1]
    sieve = sieve.split("private def permits", 1)[0]
    declared = [tuple(map(int, row)) for row in re.findall(r"\((\d+),(\d+)\)", sieve)]
    require(enumerate_strip() == declared, "Independent enumeration differs from Lean table")

    products = (LEAN / "Terras91Products.lean").read_text().split("def directRows", 1)[1]
    products = products.split("def windowRows", 1)[0]
    direct = [tuple(map(int, row)) for row in re.findall(r"\(\((\d+),(\d+)\),(\d+)\)", products)]
    require(len(direct) == 15 and set(declared) == {(k,d) for k,d,_ in direct} |
            {Q0,Q1,TWICE_Q1}, "Missing or overlapping closure row")
    for k, d, rank in direct:
        check_row((k, d), rank, 92, SEED_FLOOR)
    for clock, rank in ((Q1, 7), (TWICE_Q1, 6)):
        check_row(clock, rank, 146, Q0_PRICE)
        require(rank-1 < 2+5 and 5*(rank-1) < 91, "Window count comparison")
    print("PASS: full 22,145-pair enumeration, 18 survivors, 15 exclusions and two Weaver windows.")


if __name__ == "__main__":
    main()
