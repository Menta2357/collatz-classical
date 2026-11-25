#!/usr/bin/env python3
"""Small D5 projection pilot, compared with literal shortcut-map runs."""

from collections import Counter
from hashlib import sha256
import json
from math import comb
from pathlib import Path
import signal
import sys


EXPERIMENTS = Path(__file__).resolve().parents[2]
TERRAS88 = EXPERIMENTS / "COLLATZ_ECO_20261125"
PINS = {
    TERRAS88 / "TERRAS88_four_runs_66_67.py": "b170d1c8810209779d6d58efe0cc907d05f30dbfea2ce24b9aee5d187a61fa06",
    TERRAS88 / "TERRAS88_four_runs_107_170.py": "6ba30af9548240c470a7a4f61f3970566b473cdf8033a6653f6a61badba2b745",
    EXPERIMENTS / "COLLATZ_Q37_20261125" / "TERRAS89_PAPER" / "RECIBO.json": "e678a72f91a885b7ea150c96a8f249829b1b525d8ffcc0487fb4e060729fc99d",
}
HEIGHTS = (12, 16)


def require(condition, context):
    if not condition:
        raise ValueError(context)


for path, digest in PINS.items():
    require(sha256(path.read_bytes()).hexdigest() == digest, ("parent digest", path.name))

sys.dont_write_bytecode = True
sys.path.insert(0, str(TERRAS88))
from TERRAS88_four_runs_66_67 import four_runs, v2  # noqa: E402


def replay(x):
    """D3, D4 and D5 at the same seed, using the four-run parent."""
    widths = four_runs(x)
    total = sum(rise for rise, _ in widths)
    for rise, gap in widths:
        x = (3**rise * ((x + 1) >> rise) - 1) >> gap
    return total - widths[-1][0], total, total + v2(x + 1)


def projection(height):
    powers3 = [3**d for d in range(height + 1)]
    wide_bits = 3 * powers3[-1].bit_length() + height + 1
    inverses = [pow(base, -1, 1 << wide_bits) for base in powers3]
    seen = set()
    records = {}
    stats = Counter()

    for first in range(1, height):
        width = height - first
        limit = 1 << width

        def inspect(u, reason):
            stats[reason] += 1
            if not (1 <= u < limit and u % 2):
                return
            x = (u << first) - 1
            if x in seen:
                return
            seen.add(x)
            physical = replay(x)
            if physical[1] > height:
                records[x] = physical

        def residue(numerator, inv, bits):
            return (numerator * inv) & ((1 << bits) - 1)

        def visit(run, odds, prefix, offset):
            """Post-rise numerator before the next even gap is (3^odds u+offset)/2^prefix - 1."""
            stats[f"prefix_after_{run}_odd_runs"] += 1
            peak_upper = ((powers3[odds] * (limit - 1) + offset) >> prefix) - 1
            enough = height + 1 - odds
            if run == 3:
                peak_upper //= (1 << enough) - 1
            gap_upper = peak_upper.bit_length() - 1
            gap_tail = width - prefix
            inv = inverses[odds]
            plain = 1 << prefix

            # A whole tail of exact gaps has the same residue at source width.
            if gap_tail <= gap_upper:
                inspect(residue(plain - offset, inv, width), "gap_tail_projection")
            for gap in range(1, min(gap_upper, gap_tail - 1) + 1):
                after_gap = prefix + gap
                gap_power = 1 << gap
                if after_gap + 1 >= width:
                    inspect(residue(plain * (gap_power + 1) - offset, inv, width), "gap_projection")
                    continue

                next_offset = offset + plain * (gap_power - 1)
                # The first odd count above H can occur after 2, 3 or 4 rises.
                inspect(residue(-next_offset, inv, after_gap + enough), "long_next_projection")
                if run == 3:
                    continue

                next_plus_one_upper = ((powers3[odds] * (limit - 1) + next_offset) >> after_gap)
                next_upper = min(height - odds, next_plus_one_upper.bit_length() - 1)
                rise_tail = width - after_gap
                if rise_tail <= next_upper:
                    inspect(residue(-next_offset, inv, width), "rise_tail_projection")
                for rise in range(1, min(next_upper, rise_tail - 1) + 1):
                    next_prefix = after_gap + rise
                    if next_prefix + 1 >= width:
                        inspect(residue((1 << next_prefix) - next_offset, inv, width), "rise_projection")
                    else:
                        visit(run + 1, odds + rise, next_prefix, next_offset * powers3[rise])

        visit(1, first, 0, 0)
    return records, stats


def literal_reference(height):
    records = {}
    for source in range(1, (1 << height) - 1, 2):
        x, odds = source, 0
        cumulatives = []
        for _ in range(5):
            while x % 2:
                x = (3 * x + 1) // 2
                odds += 1
            cumulatives.append(odds)
            while x % 2 == 0:
                x //= 2
        if cumulatives[3] > height:
            records[source] = tuple(cumulatives[2:])
    return records


def prefix_bounds(height):
    gaps = sum(comb(height - 1, length) for length in (2, 4, 6))
    prefixes = sum(comb(height - 1, length) for length in (1, 3, 5))
    return gaps, prefixes


def main():
    def stop(_signal, _frame):
        raise TimeoutError("the 20-second pilot budget elapsed")

    signal.signal(signal.SIGALRM, stop)
    signal.alarm(20)
    try:
        for height in HEIGHTS:
            found, stats = projection(height)
            require(found == literal_reference(height), ("physical source set and D3/D4/D5", height))
            old = sum(record[0] > height for record in found.values())
            added = len(found) - old
            require(old > 0 and added > 0, ("both D4 > H branches exercised", height))
            require(all((1 << record[2]) <= 6**height for record in found.values()), ("pilot D5 bound", height))
            payload = json.dumps(sorted(found.items()), separators=(",", ":")).encode()
            max_d5 = max(record[2] for record in found.values())
            print(f"H={height} PASS: {len(found)} seeds, {old} D3>H, {added} D3<=H<D4, max D5={max_d5}")
            print(f"  sha256={sha256(payload).hexdigest()}")
            print(f"  projection counts={dict(sorted(stats.items()))}")
        gaps, prefixes = prefix_bounds(92)
        print(f"H=92 NOT EXECUTED: crude explicit gap slots <= {gaps}; gap tails <= {prefixes}")
        print("Pilot only. H=92 and H=146 five-run capacities remain open.")
    finally:
        signal.alarm(0)


if __name__ == "__main__":
    main()
