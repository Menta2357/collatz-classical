#!/usr/bin/env python3
"""One Terras89 shard, H92 A72 with first even gap one or two."""

from collections import Counter
from hashlib import sha256
import inspect
import json
from pathlib import Path
from runpy import run_path
import signal
import sys
from time import monotonic


HEIGHT, FIRST = 92, 72
LAST_GAP = 2
PROJECTION_LIMIT, TIME_LIMIT = 7_004, 20
HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
PROJECTOR = "COLLATZ_Q39_20261125/TERRAS89_D5_H92_A75/check.py"
REPLAY = "COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/check.py"
BOOK = "COLLATZ_Q45_20261125/TERRAS89_D5_H92_A73/check.py"
COST = "COLLATZ_Q46_20261125/TERRAS89_NEXT/RECIBO.json"
PINS = {
    PROJECTOR: "13d35385ed17685cb05c1d75e617e507ccd263044ead8938cec9057f79e21c1e",
    REPLAY: "e9b8b62a5c0dbbe62d573638a542619efde0bddf92317a30d1ba6f20a4a1b01d",
    BOOK: "ccf6da7369a64c7bce23e309c5277919759f03676b91e7e6aa2dee464fe05739",
    COST: "88eae231a985c81f827b0a28bc669e1d91c6709b9c70c23702b8dde116be7786",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def digest(records):
    return sha256(json.dumps(records, separators=(",", ":")).encode()).hexdigest()


def in_shard(cofactor):
    peak = 3**FIRST * cofactor - 1
    gap = (peak & -peak).bit_length() - 1
    return 1 <= gap <= LAST_GAP


def shard_projection(pinned):
    original = inspect.getsource(pinned["scan"])
    edits = {
        "            if gap_tail <= gap_upper:\n":
            "            if run != 1 and gap_tail <= gap_upper:\n",
        "            for gap in range(1, min(gap_upper, gap_tail - 1) + 1):\n":
            "            last_gap = min(gap_upper, gap_tail - 1)\n"
            "            if run == 1:\n"
            "                last_gap = min(last_gap, LAST_GAP)\n"
            "            for gap in range(1, last_gap + 1):\n",
        "            seen.add(u)\n":
            "            if not in_shard(u):\n"
            "                stats['outside_root_shard'] += 1\n"
            "                return\n"
            "            seen.add(u)\n",
    }
    for anchor, replacement in edits.items():
        require(original.count(anchor) == 1, ("projector anchor", anchor))
        original = original.replace(anchor, replacement)
    namespace = dict(pinned, FIRST=FIRST, LAST_GAP=LAST_GAP, PROJECTION_LIMIT=PROJECTION_LIMIT,
                     in_shard=in_shard)
    exec(compile(original, PROJECTOR, "exec"), namespace)
    return namespace["scan"]


def main():
    for path, expected in PINS.items():
        require(sha256((EXPERIMENTS / path).read_bytes()).hexdigest() == expected, ("parent SHA256", path))
    prior_cost = json.loads((EXPERIMENTS / COST).read_text())
    require(prior_cost["proposed_shards"]["1<=b1<=2"] == PROJECTION_LIMIT, "preregistered budget")
    require(2**237 <= 6**HEIGHT < 2**238, "integer refutation threshold")

    sys.dont_write_bytecode = True
    pinned = run_path(str(EXPERIMENTS / PROJECTOR))
    require((pinned["HEIGHT"], pinned["FIRST"]) == (HEIGHT, 75), "source projector parameters")
    scan = shard_projection(pinned)
    replay_five = run_path(str(EXPERIMENTS / REPLAY))["replay_five"]
    literal_book = run_path(str(EXPERIMENTS / BOOK))["literal_book"]
    counts, physical, bands = Counter(), {}, []
    result = {
        "scope": {"H": HEIGHT, "a1": FIRST, "b1_inclusive": [1, LAST_GAP]},
        "projection_limit": PROJECTION_LIMIT,
        "time_limit_seconds": TIME_LIMIT,
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }

    def audit(source, expected):
        require(source > 0 and source % 2 and source + 1 < 2**HEIGHT, ("seed domain", source))
        runs = replay_five(source)
        totals = tuple(sum(rise for rise, _ in runs[:j]) for j in (3, 4, 5))
        require(runs[0][0] == FIRST and 1 <= runs[0][1] <= LAST_GAP and totals == tuple(expected)
                and totals[1] > HEIGHT, ("independent physical domain and clocks", source, runs, totals))
        return runs, literal_book(source, runs)

    def alarm(_signal, _frame):
        raise pinned["Stop"]("20-second time limit")

    started = monotonic()
    signal.signal(signal.SIGALRM, alarm)
    signal.alarm(TIME_LIMIT)
    try:
        scan(counts, physical, bands)
        require(counts["projections"] == PROJECTION_LIMIT, "complete root projection tree")
        require([band["a1"] for band in bands] == [FIRST], "complete first-run domain")
        verified = {str(gap): {"D3_gt_H": 0, "D3_le_H_lt_D4": 0} for gap in range(1, LAST_GAP + 1)}
        records = []
        for source, totals in sorted(physical.items()):
            runs, books = audit(source, totals)
            require(2**totals[2] <= 6**HEIGHT, ("fifth-run bound", source, runs))
            verified[str(runs[0][1])]["D3_gt_H" if totals[0] > HEIGHT else "D3_le_H_lt_D4"] += 1
            records.append({"source": source, "D3_D4_D5": totals, "rise_gap_pairs": runs,
                            "same_source_books": books})
        maximum = max((totals[2] for totals in physical.values()), default=None)
        result.update(status="PASS", independently_replayed_sources=len(records),
                      retained_domains_by_physical_first_gap=verified,
                      max_D5_when_D4_gt_H=maximum,
                      maximizing_sources=[row for row in records if row["D3_D4_D5"][2] == maximum],
                      parent_projection_records_sha256=pinned["digest_records"](physical),
                      independent_physical_records_sha256=digest(records))
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
                  root_b1_ge_3_executed=False, H146_executed=False)
    print(json.dumps(result, indent=2))
    return 0 if result["status"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
