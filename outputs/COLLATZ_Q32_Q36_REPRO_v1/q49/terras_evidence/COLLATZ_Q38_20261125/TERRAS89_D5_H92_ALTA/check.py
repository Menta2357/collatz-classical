#!/usr/bin/env python3
"""Exact D5 enumeration in the pre-approved upper first-rise band only."""

from collections import Counter
from hashlib import sha256
import json
from math import comb
from pathlib import Path
import signal
import sys
from time import monotonic


PILOT = Path(__file__).resolve().parent.parent / "TERRAS89_D5_PILOTO"
PINS = {
    PILOT / "check.py": "00f0d29625217a0e3dc998d3b6ded67d38372a446354da5f9cb93995bbe4d083",
    PILOT / "RECIBO.json": "60b8b01cde792ffbcf1027d85d2dd4c201377e8cd534d72fd004205e92e96505",
    PILOT / "SHA256SUMS": "55dec3ffb75439544f4a8c14b491aa44eabcc1a8e891cb0ad3697ec90c62501f",
}
HEIGHT = 92
FIRST = 76
TIME_LIMIT = 20
PROJECTION_LIMIT = 15_000

for path, digest in PINS.items():
    if sha256(path.read_bytes()).hexdigest() != digest:
        raise ValueError(("pilot digest", path.name))

sys.dont_write_bytecode = True
sys.path.insert(0, str(PILOT))
from check import replay, require  # noqa: E402


class Stop(Exception):
    pass


class Refutation(Exception):
    pass


def digest_records(records):
    payload = json.dumps(sorted(records.items()), separators=(",", ":")).encode()
    return sha256(payload).hexdigest()


def scan(stats, physical, by_first):
    powers3 = [3**d for d in range(HEIGHT + 1)]
    inverse_bits = 2 * HEIGHT
    inverses = [pow(base, -1, 1 << inverse_bits) for base in powers3]
    threshold = 6**HEIGHT
    for first in range(FIRST, HEIGHT):
        width = HEIGHT - first
        limit = 1 << width
        seen = set()
        records = {}
        initial_projections = stats["projections"]

        def inspect(u):
            stats["lifts"] += 1
            if not (1 <= u < limit and u % 2) or u in seen:
                return
            seen.add(u)
            stats["physical_replays"] += 1
            x = (u << first) - 1
            record = replay(x)
            if record[1] > HEIGHT:
                physical[x] = record
                records[x] = record
                if (1 << record[2]) > threshold:
                    raise Refutation({"x": x, "a1": first, "cofactor": u, "D3_D4_D5": record})

        def project(numerator, inv, bits, kind):
            if stats["projections"] >= PROJECTION_LIMIT:
                raise Stop("projection limit")
            stats["projections"] += 1
            stats[kind] += 1
            return (numerator * inv) & ((1 << bits) - 1)

        def visit(run, odds, prefix, offset):
            peak_upper = ((powers3[odds] * (limit - 1) + offset) >> prefix) - 1
            enough = HEIGHT + 1 - odds
            if run == 3:
                peak_upper //= (1 << enough) - 1
            gap_upper = peak_upper.bit_length() - 1
            gap_tail = width - prefix
            inv = inverses[odds]
            plain = 1 << prefix
            if gap_tail <= gap_upper:
                inspect(project(plain - offset, inv, width, "gap_tail"))
            for gap in range(1, min(gap_upper, gap_tail - 1) + 1):
                after_gap = prefix + gap
                gap_power = 1 << gap
                if after_gap + 1 >= width:
                    inspect(project(plain * (gap_power + 1) - offset, inv, width, "exact_gap"))
                    continue

                next_offset = offset + plain * (gap_power - 1)
                if run == 3:
                    inspect(project(-next_offset, inv, after_gap + enough, "fourth_long"))
                    continue

                # The omitted long run and both exact-rise frontiers share
                # a residue mod 2^(width-1). Replay its two width-bit lifts.
                lower_width = width - 1
                u = project(-next_offset, inv, lower_width, "joint_rise")
                inspect(u)
                inspect(u + (1 << lower_width))
                next_plus_one_upper = (powers3[odds] * (limit - 1) + next_offset) >> after_gap
                next_upper = min(HEIGHT - odds, next_plus_one_upper.bit_length() - 1,
                                 width - after_gap - 2)
                for rise in range(1, next_upper + 1):
                    visit(run + 1, odds + rise, after_gap + rise, next_offset * powers3[rise])

        visit(1, first, 0, 0)
        old = sum(record[0] > HEIGHT for record in records.values())
        by_first.append({"a1": first, "projections": stats["projections"] - initial_projections,
                         "D3_gt_92": old, "D3_le_92_lt_D4": len(records) - old,
                         "max_D5": max((r[2] for r in records.values()), default=None)})


def main():
    def interrupt(_signal, _frame):
        raise Stop("20-second time limit")

    explicit_bound = sum(comb(HEIGHT - FIRST, j) for j in (2, 4, 6))
    tail_bound = sum(comb(HEIGHT - FIRST, j) for j in (1, 3, 5))
    require((explicit_bound, tail_bound) == (9948, 4944) and
            explicit_bound + tail_bound <= PROJECTION_LIMIT, "preregistered bound")
    stats, physical, by_first = Counter(), {}, []
    result = {"H": HEIGHT, "a1_inclusive": [FIRST, HEIGHT - 1],
              "time_limit_seconds": TIME_LIMIT, "projection_limit": PROJECTION_LIMIT,
              "combinatorial_projection_bound": explicit_bound + tail_bound}
    started = monotonic()
    signal.signal(signal.SIGALRM, interrupt)
    signal.alarm(TIME_LIMIT)
    try:
        scan(stats, physical, by_first)
        result["status"] = "PASS"
    except Stop as failure:
        result.update(status="STOP", reason=str(failure))
    except Refutation as failure:
        result.update(status="REFUTED", witness=failure.args[0])
    finally:
        signal.alarm(0)

    old = sum(record[0] > HEIGHT for record in physical.values())
    maximum = max((r[2] for r in physical.values()), default=None)
    result.update(elapsed_seconds=round(monotonic() - started, 6), counters=dict(stats),
                  complete_first_rise_bands=by_first, D3_gt_92=old, D3_le_92_lt_D4=len(physical) - old,
                  retained_sources=len(physical), max_D5=maximum,
                  max_D5_sources=[x for x, r in sorted(physical.items()) if r[2] == maximum],
                  records_sha256=digest_records(physical))
    if result["status"] == "PASS":
        require(tuple(band["a1"] for band in by_first) == tuple(range(FIRST, HEIGHT)), "coverage")
        require(stats["projections"] <= explicit_bound + tail_bound and old > 0 and len(physical) > old,
                "both branches and projection bound")
    print(json.dumps(result, indent=2))
    return 0 if result["status"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
