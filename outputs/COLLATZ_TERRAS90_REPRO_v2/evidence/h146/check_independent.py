"""Recompute the H146 high-rise scan by exact first-run strata."""

import json
from functools import cache
from pathlib import Path


@cache
def triple_power(exponent):
    return 3**exponent


def twos(n):
    return (n ^ (n - 1)).bit_length() - 1


def main():
    first_run_counts = []
    maximum = 0
    least_witness = None
    for first in range(124, 146):
        odd_bound = 2**(146 - first)
        factor = triple_power(first)
        count = 0
        for odd in range(1, odd_bound, 2):
            peak = factor * odd - 1
            x = peak >> twos(peak)
            total = first
            for _ in range(5):
                length = twos(x + 1)
                next_peak = triple_power(length) * ((x + 1) >> length) - 1
                x = next_peak >> twos(next_peak)
                total += length
            if total > maximum:
                maximum = total
                least_witness = odd << (first - 124)
            elif total == maximum:
                least_witness = min(least_witness, odd << (first - 124))
            count += 1
        first_run_counts.append(count)

    receipt = Path(__file__).with_name("RECIBO.json")
    expected = json.loads(receipt.read_text())["H146_long_first_rise"]
    got = (first_run_counts, sum(first_run_counts), maximum, least_witness)
    recorded = (
        expected["counts_by_a1"],
        expected["cofactors_checked"],
        expected["maximum_D6"],
        expected["minimum_cofactor_at_maximum"],
    )
    if got != recorded:
        raise ArithmeticError(f"independent enumeration differs: {got}")
    print(json.dumps({
        "status": "PASS",
        "cofactors_checked": sum(first_run_counts),
        "maximum_D6": maximum,
        "minimum_cofactor_at_maximum": least_witness,
    }, indent=2))


if __name__ == "__main__":
    main()
