#!/usr/bin/env python3
"""Project only H92/A71, b1>=5 and D3<=92<D4."""

from collections import Counter
from hashlib import sha256
import inspect
import json
from pathlib import Path
from runpy import run_path
import signal
import sys
from time import monotonic


HERE = Path(__file__).resolve().parent
LOW_CHECK = HERE.parent / "check.py"
LOW_CHECK_SHA256 = "8723d6483d8509de112c923f02f14a1a8a653c1867dc67b7ebea67291eccccb6"
HEIGHT, FIRST, FIRST_GAP = 92, 71, 5
PROJECTION_LIMIT, TIME_LIMIT = 6_415, 20


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def project_high(pinned, low):
    def in_shard(cofactor):
        return low["v2"](3**FIRST * cofactor - 1) >= FIRST_GAP

    code = inspect.getsource(pinned["scan"])
    edits = {
        "            for gap in range(1, min(gap_upper, gap_tail - 1) + 1):\n":
            "            start_gap = FIRST_GAP if run == 1 else 1\n"
            "            for gap in range(start_gap, min(gap_upper, gap_tail - 1) + 1):\n",
        "            if record[1] > HEIGHT:\n": "            if record is not None:\n",
        "            seen.add(u)\n":
            "            if not in_shard(u):\n"
            "                stats['outside_root_shard'] += 1\n"
            "                return\n"
            "            seen.add(u)\n",
    }
    for anchor, replacement in edits.items():
        require(code.count(anchor) == 1, ("projector anchor", anchor))
        code = code.replace(anchor, replacement)
    namespace = dict(pinned, FIRST=FIRST, FIRST_GAP=FIRST_GAP, PROJECTION_LIMIT=PROJECTION_LIMIT,
                     in_shard=in_shard, replay=low["replay_residual"])
    exec(compile(code, low["PROJECTOR"], "exec"), namespace)
    return namespace["scan"]


def main():
    require(sha256(LOW_CHECK.read_bytes()).hexdigest() == LOW_CHECK_SHA256, "pinned low verifier")
    sys.dont_write_bytecode = True
    low = run_path(str(LOW_CHECK))
    experiments = low["EXPERIMENTS"]
    for path, expected in low["PINS"].items():
        require(sha256((experiments / path).read_bytes()).hexdigest() == expected, ("parent SHA256", path))
    cost = run_path(str(experiments / low["COST"]))
    width = HEIGHT - FIRST
    tail_cost = 1 + sum(cost["explicit_gap_count"](1, width, b) for b in range(FIRST_GAP, width))
    require(tail_cost == PROJECTION_LIMIT and cost["projection_count"](1, width) == 20_712, "cost")
    require(2**237 <= 6**HEIGHT < 2**238, "integer refutation threshold")
    pinned = run_path(str(experiments / low["PROJECTOR"]))
    require((pinned["HEIGHT"], pinned["FIRST"]) == (HEIGHT, 75), "projector source parameters")
    scan = project_high(pinned, low)
    replay_five = run_path(str(experiments / low["REPLAY"]))["replay_five"]
    literal_book = run_path(str(experiments / low["BOOK"]))["literal_book"]
    counts, physical, bands = Counter(), {}, []
    result = {
        "scope": {"H": HEIGHT, "a1": FIRST, "b1_minimum": FIRST_GAP, "residual": "D3<=92<D4"},
        "first_gap_tail_b1_ge": width,
        "projection_limit": PROJECTION_LIMIT,
        "time_limit_seconds": TIME_LIMIT,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "pinned_low_verifier_sha256": LOW_CHECK_SHA256,
        "parent_sha256": low["PINS"],
    }

    def audit(source, expected):
        require(source > 0 and source % 2 and source + 1 < 2**HEIGHT, ("seed domain", source))
        runs = replay_five(source)
        totals = tuple(sum(rise for rise, _ in runs[:j]) for j in (3, 4, 5))
        require(runs[0][0] == FIRST and runs[0][1] >= FIRST_GAP and totals == tuple(expected)
                and totals[0] <= HEIGHT < totals[1], ("independent physical domain and clocks", source))
        return runs, literal_book(source, runs)

    def alarm(_signal, _frame):
        raise pinned["Stop"]("20-second time limit")

    started = monotonic()
    signal.signal(signal.SIGALRM, alarm)
    signal.alarm(TIME_LIMIT)
    try:
        scan(counts, physical, bands)
        require([band["a1"] for band in bands] == [FIRST] and counts["projections"] == PROJECTION_LIMIT,
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
                      retained_domains_by_physical_first_gap=dict(sorted(by_gap.items())),
                      max_D5_on_residual=maximum,
                      maximizing_sources=[row for row in records if row["D3_D4_D5"][2] == maximum],
                      parent_projection_records_sha256=pinned["digest_records"](physical),
                      independent_physical_records_sha256=low["digest"](records))
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
                  root_b1_le_4_executed=False, A70_executed=False, H146_executed=False)
    print(json.dumps(result, indent=2))
    return 0 if result["status"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
