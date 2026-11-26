#!/usr/bin/env python3
"""One authorized H92/A73 band, with independent physical clocks and books."""

from collections import Counter
from hashlib import sha256
import json
from math import comb
from pathlib import Path
from runpy import run_path
import signal
import sys
from time import monotonic

HEIGHT, FIRST = 92, 73
TIME_LIMIT, PROJECTION_LIMIT = 20, 15_000
HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
PROJECTOR = EXPERIMENTS / "COLLATZ_Q39_20261125/TERRAS89_D5_H92_A75/check.py"
PHYSICAL = EXPERIMENTS / "COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/check.py"
A74 = EXPERIMENTS / "COLLATZ_Q44_20261125/TERRAS89_D5_H92_A74/RECIBO.json"
D3_HIGH = EXPERIMENTS / "COLLATZ_Q44_20261125/TERRAS89_D3_HIGH/RECIBO.json"
PINS = {
    PROJECTOR: "13d35385ed17685cb05c1d75e617e507ccd263044ead8938cec9057f79e21c1e",
    PHYSICAL: "e9b8b62a5c0dbbe62d573638a542619efde0bddf92317a30d1ba6f20a4a1b01d",
    A74: "a8d91903857fe3dce88131be74e6bb59c88c26f719505db283cf42ee7be308ab",
    D3_HIGH: "354a8fba34f152b00c54f595713ebec5360a8ca051816ed75ab241e700a65a8c",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def literal_book(source, runs):
    value, steps, odds, additive = source, 0, 0, 0
    checkpoints = []
    for number, (rise, gap) in enumerate(runs, 1):
        for _ in range(rise):
            require(value % 2 == 1, ("odd phase", source, number))
            value = (3 * value + 1) // 2
            additive = 3 * additive + (1 << steps)
            steps += 1
            odds += 1
            require((1 << steps) * value == 3**odds * source + additive,
                    ("odd same-source book", source, steps))
        require(value % 2 == 0, ("maximal odd run", source, number))
        for _ in range(gap):
            require(value % 2 == 0, ("even phase", source, number))
            value //= 2
            steps += 1
            require((1 << steps) * value == 3**odds * source + additive,
                    ("even same-source book", source, steps))
        require(value % 2 == 1, ("maximal even gap", source, number))
        checkpoints.append({"run": number, "state": value, "k": steps,
                            "d": odds, "C": additive})
    return checkpoints


def main():
    for path, digest in PINS.items():
        require(sha256(path.read_bytes()).hexdigest() == digest,
                ("sealed parent SHA256", str(path)))
    require(json.loads(A74.read_text())["status"] == "PASS", "sealed A74")
    require(json.loads(D3_HIGH.read_text())["status"] == "PASS", "sealed D3 high")
    explicit = sum(comb(HEIGHT - FIRST - 1, j) for j in (1, 3, 5))
    tail = sum(comb(HEIGHT - FIRST - 1, j) for j in (0, 2, 4))
    require((explicit, tail) == (9402, 3214) and explicit + tail <= PROJECTION_LIMIT,
            "predeclared cost before scan")
    require(2**237 <= 6**HEIGHT < 2**238, "integer refutation threshold")

    sys.dont_write_bytecode = True
    projector = run_path(str(PROJECTOR))  # Its main is not executed.
    scan = projector["scan"]
    globals_ = scan.__globals__
    require((globals_["HEIGHT"], globals_["FIRST"], globals_["TIME_LIMIT"],
             globals_["PROJECTION_LIMIT"]) == (HEIGHT, 75, TIME_LIMIT, PROJECTION_LIMIT),
            "Q39 dimensions")
    globals_["FIRST"] = FIRST  # The only projector parameter change.
    replay_five = run_path(str(PHYSICAL))["replay_five"]  # No census is run.
    counts, physical, bands = Counter(), {}, []
    result = {
        "H": HEIGHT, "a1_inclusive": [FIRST, FIRST],
        "projection_limit": PROJECTION_LIMIT, "time_limit_seconds": TIME_LIMIT,
        "explicit_projection_bound": explicit, "tail_projection_bound": tail,
        "combinatorial_projection_bound": explicit + tail,
        "projector_parameter_changes": {"FIRST": [75, FIRST]},
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "preregistration_sha256": sha256((HERE / "PREREGISTRO.md").read_bytes()).hexdigest(),
        "parent_sha256": {str(p.relative_to(EXPERIMENTS)): h for p, h in PINS.items()},
        "prior_bands_executed": False, "general_D3_high_census_executed": False,
        "H146_executed": False, "lean_executed": False,
    }

    def alarm(_signal, _frame):
        raise projector["Stop"]("20-second time limit")

    started = monotonic()
    signal.signal(signal.SIGALRM, alarm)
    signal.alarm(TIME_LIMIT)
    try:
        scan(counts, physical, bands)
        require([band["a1"] for band in bands] == [FIRST], "complete A73 coverage")
        require(counts["projections"] <= explicit + tail, "projection bound")
        rows, book_rows = [], []
        for source, expected in sorted(physical.items()):
            require(source > 0 and source % 2 and source + 1 < 2**HEIGHT,
                    ("source domain", source))
            runs = replay_five(source)
            totals = tuple(sum(a for a, _ in runs[:j]) for j in (3, 4, 5))
            require(runs[0][0] == FIRST and totals == expected and totals[1] > HEIGHT,
                    ("independent physical replay", source, runs, expected))
            require(2**totals[2] <= 6**HEIGHT, ("fifth-run bound", source, runs))
            books = literal_book(source, runs)
            require(books[-1]["d"] == totals[2], "fifth-run physical clock")
            rows.append((source, runs))
            book_rows.append((source, books))
        high = sum(d3 > HEIGHT for d3, d4, d5 in physical.values())
        maximum = max((d5 for d3, d4, d5 in physical.values()), default=None)
        maximum_new = max((d5 for d3, d4, d5 in physical.values() if d3 <= HEIGHT), default=None)
        witness_books = {source: books for source, books in book_rows
                         if physical[source][2] == maximum}
        result.update(
            status="PASS", D3_gt_H=high, D3_le_H_lt_D4=len(physical) - high,
            independently_replayed_sources=len(rows),
            max_D5_when_D4_gt_H=maximum, max_D5_on_new_residual=maximum_new,
            maximizing_sources=[{"source": source, "D3_D4_D5": physical[source],
                                 "rise_gap_pairs": runs, "same_source_books": witness_books[source]}
                                for source, runs in rows if physical[source][2] == maximum],
            parent_summaries_sha256=projector["digest_records"](physical),
            independent_physical_records_sha256=sha256(
                json.dumps(rows, separators=(",", ":")).encode()).hexdigest(),
            independent_same_source_books_sha256=sha256(
                json.dumps(book_rows, separators=(",", ":")).encode()).hexdigest())
    except projector["Stop"] as failure:
        result.update(status="STOP", reason=str(failure))
    except projector["Refutation"] as failure:
        witness = failure.args[0]
        runs = replay_five(witness["x"])
        require(sum(a for a, _ in runs) >= 238, ("physical refutation", witness))
        result.update(status="REFUTED", witness=dict(witness, rise_gap_pairs=runs,
                                                     same_source_books=literal_book(witness["x"], runs)))
    except ArithmeticError as failure:
        result.update(status="ERROR", reason=str(failure))
    finally:
        signal.alarm(0)
    result.update(elapsed_seconds=round(monotonic() - started, 6), counters=dict(counts),
                  complete_first_rise_bands=bands, TERRAS89_Q0_DELTA1="PENDING")
    print(json.dumps(result, indent=2))
    return 0 if result["status"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
