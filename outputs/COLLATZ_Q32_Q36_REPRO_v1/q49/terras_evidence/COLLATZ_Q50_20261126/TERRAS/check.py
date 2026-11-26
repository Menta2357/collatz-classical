#!/usr/bin/env python3
"""Check one H92/A70 first-gap shard with D3<=92 and D4>=95."""

from argparse import ArgumentParser
from collections import Counter
from hashlib import sha256
import inspect
import json
from pathlib import Path
from runpy import run_path
import signal
import sys
from time import monotonic


HEIGHT, FIRST, FOURTH_MINIMUM = 92, 70, 95
SPLIT, TIME_LIMIT = 3, 20
HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
PREVIOUS_CHECK = "COLLATZ_Q49_20261125/TERRAS/check.py"
A71 = "COLLATZ_Q49_20261125/TERRAS/A71_HIGH_GAPS/RECIBO_UNION.json"
ORDINAL = "COLLATZ_Q49_20261125/TERRAS_A70_ORDINAL_ENVELOPE/RECIBO_COROLARIO94.json"
PINS = {
    PREVIOUS_CHECK: "8723d6483d8509de112c923f02f14a1a8a653c1867dc67b7ebea67291eccccb6",
    A71: "af39a42368204b9b0d8e96d20d7bd58e97acd9ce7139d3d489e9f0ca5035c776",
    ORDINAL: "5404e36eff859e47b1cf20a92b853047c0554eb131e5aeb14c2763f2bfcc61fb",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def v2(value):
    return (value & -value).bit_length() - 1


def residual_replay(source):
    total = 0
    for index in range(4):
        rise = v2(source + 1)
        total += rise
        if index == 2:
            d3 = total
            if d3 > HEIGHT:
                return None
        if index == 3 and total < FOURTH_MINIMUM:
            return None
        peak = 3**rise * ((source + 1) >> rise) - 1
        source = peak >> v2(peak)
    return d3, total, total + v2(source + 1)


def shard_projection(pinned, low, cap, gap_allowed):
    original = inspect.getsource(pinned["scan"])
    edits = {
        "            if gap_tail <= gap_upper:\n":
            "            if (run != 1 or not LOW) and gap_tail <= gap_upper:\n",
        "            for gap in range(1, min(gap_upper, gap_tail - 1) + 1):\n":
            "            start_gap = SPLIT + 1 if run == 1 and not LOW else 1\n"
            "            last_gap = min(gap_upper, gap_tail - 1)\n"
            "            if run == 1 and LOW:\n"
            "                last_gap = min(last_gap, SPLIT)\n"
            "            for gap in range(start_gap, last_gap + 1):\n",
        # Only the third-node size guard and fourth-run congruence consume
        # enough. All saturation lifts remain unchanged.
        "            enough = HEIGHT + 1 - odds\n":
            "            enough = FOURTH_MINIMUM - odds\n",
        "            if record[1] > HEIGHT:\n": "            if record is not None:\n",
        "            seen.add(u)\n":
            "            if not GAP_ALLOWED(v2(3**FIRST * u - 1)):\n"
            "                stats['outside_root_shard'] += 1\n"
            "                return\n"
            "            seen.add(u)\n",
    }
    for anchor, replacement in edits.items():
        require(original.count(anchor) == 1, ("projector anchor", anchor))
        original = original.replace(anchor, replacement)
    namespace = dict(pinned, FIRST=FIRST, SPLIT=SPLIT, LOW=low, FOURTH_MINIMUM=FOURTH_MINIMUM,
                     PROJECTION_LIMIT=cap, GAP_ALLOWED=gap_allowed, v2=v2, replay=residual_replay)
    exec(compile(original, str(EXPERIMENTS / "Q39-pinned-projector"), "exec"), namespace)
    return namespace["scan"]


def main(shard):
    for path, expected in PINS.items():
        require(sha256((EXPERIMENTS / path).read_bytes()).hexdigest() == expected, ("parent SHA256", path))
    a71 = json.loads((EXPERIMENTS / A71).read_text())
    ordinal = json.loads((EXPERIMENTS / ORDINAL).read_text())
    require(a71["status"] == "PASS_FULL_A71" and a71["scope"] == {"H": HEIGHT, "a1": 71}, "prior band")
    require(ordinal["status"] == "PASS" and ordinal["H"] == HEIGHT and
            ordinal["a1_bounds"][0] <= FIRST <= ordinal["a1_bounds"][1] and
            ordinal["D4_upper"] + 1 == FOURTH_MINIMUM and ordinal["D5_upper"] == 237,
            "ordinal cutoff")
    require(2**237 <= 6**HEIGHT < 2**238, "integer refutation threshold")

    sys.dont_write_bytecode = True
    previous = run_path(str(EXPERIMENTS / PREVIOUS_CHECK))
    for path, expected in previous["PINS"].items():
        require(sha256((EXPERIMENTS / path).read_bytes()).hexdigest() == expected, ("inherited SHA256", path))
    cost = run_path(str(EXPERIMENTS / previous["COST"]))
    width = HEIGHT - FIRST
    low_cap = sum(cost["explicit_gap_count"](1, width, b) for b in range(1, SPLIT + 1))
    high_cap = 1 + sum(cost["explicit_gap_count"](1, width, b) for b in range(SPLIT + 1, width))
    require((low_cap, high_cap) == (14_817, 11_919) and
            low_cap + high_cap == cost["projection_count"](1, width) == 26_736, "predeclared budgets")
    low = shard == "low"
    cap = low_cap if low else high_cap

    def gap_allowed(gap):
        return 1 <= gap <= SPLIT if low else gap > SPLIT

    pinned = run_path(str(EXPERIMENTS / previous["PROJECTOR"]))
    require((pinned["HEIGHT"], pinned["FIRST"]) == (HEIGHT, 75), "source projector parameters")
    scan = shard_projection(pinned, low, cap, gap_allowed)
    replay_five = run_path(str(EXPERIMENTS / previous["REPLAY"]))["replay_five"]
    literal_book = run_path(str(EXPERIMENTS / previous["BOOK"]))["literal_book"]
    counts, physical, bands = Counter(), {}, []
    result = {
        "scope": {"H": HEIGHT, "a1": FIRST, "D3_upper": HEIGHT, "D4_lower": FOURTH_MINIMUM,
                  "b1": "1..3" if low else ">=4"},
        "first_gap_tail_projected": not low,
        "projection_limit": cap,
        "time_limit_seconds": TIME_LIMIT,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }

    def audit(source, expected):
        require(source > 0 and source % 2 and source + 1 < 2**HEIGHT, ("seed domain", source))
        runs = replay_five(source)
        totals = tuple(sum(rise for rise, _ in runs[:j]) for j in (3, 4, 5))
        require(runs[0][0] == FIRST and gap_allowed(runs[0][1]) and totals == tuple(expected)
                and totals[0] <= HEIGHT and totals[1] >= FOURTH_MINIMUM,
                ("independent physical domain and clocks", source, runs))
        return runs, literal_book(source, runs)

    def alarm(_signal, _frame):
        raise pinned["Stop"]("20-second time limit")

    started = monotonic()
    signal.signal(signal.SIGALRM, alarm)
    signal.alarm(TIME_LIMIT)
    try:
        scan(counts, physical, bands)
        require([band["a1"] for band in bands] == [FIRST] and counts["projections"] <= cap,
                "complete root projection tree")
        by_gap, records = Counter(), []
        for source, totals in sorted(physical.items()):
            runs, books = audit(source, totals)
            require(2**totals[2] <= 6**HEIGHT, ("fifth-run bound", source, runs))
            by_gap[runs[0][1]] += 1
            records.append({"source": source, "D3_D4_D5": totals, "rise_gap_pairs": runs,
                            "same_source_books": books})
        maximum = max((totals[2] for totals in physical.values()), default=None)
        result.update(status="PASS", independently_replayed_sources=len(records),
                      retained_by_physical_first_gap=dict(sorted(by_gap.items())),
                      max_D5_on_residual=maximum,
                      maximizing_sources=[row for row in records if row["D3_D4_D5"][2] == maximum],
                      parent_projection_records_sha256=pinned["digest_records"](physical),
                      independent_physical_records_sha256=previous["digest"](records))
    except pinned["Stop"] as failure:
        result.update(status="STOP", reason=str(failure))
    except pinned["Refutation"] as failure:
        witness = failure.args[0]
        runs, books = audit(witness["x"], witness["D3_D4_D5"])
        require(sum(rise for rise, _ in runs) >= 238, ("fifth-run refutation", witness))
        result.update(status="REFUTED", witness=dict(witness, rise_gap_pairs=runs, same_source_books=books))
    finally:
        signal.alarm(0)

    result.update(elapsed_seconds=round(monotonic() - started, 6), counters=dict(counts),
                  A69_executed=False, H146_executed=False)
    print(json.dumps(result, indent=2))
    return 0 if result["status"] == "PASS" else 1


if __name__ == "__main__":
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("shard", choices=("low", "high"))
    sys.exit(main(parser.parse_args().shard))
