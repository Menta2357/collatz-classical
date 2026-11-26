#!/usr/bin/env python3
"""Reproduce the Terras89 fifth-run bound only on H=146, D3>146."""

from contextlib import redirect_stdout
from hashlib import sha256
from io import StringIO
import inspect
import json
from pathlib import Path
import sys


HEIGHT = 146
PARENT = Path(__file__).resolve().parents[2] / "COLLATZ_ECO_20261125"
PINS = {
    "TERRAS88_four_runs_107_170.py": "6ba30af9548240c470a7a4f61f3970566b473cdf8033a6653f6a61badba2b745",
    "TERRAS88_four_runs_66_67.py": "b170d1c8810209779d6d58efe0cc907d05f30dbfea2ce24b9aee5d187a61fa06",
    "TERRAS88_CIERRE_RECIBO.json": "5eabced486b6f05d06605b9adb29f77e936932133e4cc634e11aff1cec8f1293",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def replay_five(source):
    """Read physical run and gap lengths by shortcut steps, independently of the affine recoder."""
    records = []
    for _ in range(5):
        rise = 0
        while source % 2:
            source = (3 * source + 1) // 2
            rise += 1
        gap = 0
        while not source % 2:
            source //= 2
            gap += 1
        records.append((rise, gap))
    return tuple(records)


def accepted_sources():
    sys.dont_write_bytecode = True
    sys.path.insert(0, str(PARENT))
    import TERRAS88_four_runs_107_170 as parent

    starts = {}

    def record(source, runs):
        require(starts.setdefault(source, runs) == runs, ("inconsistent repeat", source))

    # The pinned verifier does not expose its physical sources. Capture them
    # immediately after its domain, branch and prefix guards, in memory only.
    implementation = inspect.getsource(parent.mask_certificate)
    anchor = "        total = sum(pair[0] for pair in runs)"
    require(implementation.count(anchor) == 1, "ambiguous verifier attachment")
    instrumented = implementation.replace(anchor, "        record(x, runs)\n" + anchor)
    namespace = dict(vars(parent), record=record)
    exec(compile(instrumented, str(Path(parent.__file__).resolve()), "exec"), namespace)
    with redirect_stdout(StringIO()):
        namespace["mask_certificate"](HEIGHT)
    return starts


def main():
    for name, digest in PINS.items():
        require(sha256((PARENT / name).read_bytes()).hexdigest() == digest, ("parent SHA256", name))
    closure = json.loads((PARENT / "TERRAS88_CIERRE_RECIBO.json").read_text())
    expected = next(line for line in closure["capacity"] if line["H"] == HEIGHT)

    starts = accepted_sources()
    counts = [0, 0]
    rows = []
    max_d4 = 0
    max_d5 = (0, 0, ())
    for source, inherited_runs in sorted(starts.items()):
        require(source > 0 and source % 2 and source + 1 < 2**HEIGHT, ("seed domain", source))
        runs = replay_five(source)
        require(runs[:4] == inherited_runs, ("four physical runs", source, runs))
        require(all(rise > 0 and gap > 0 for rise, gap in runs), ("run and gap", source, runs))
        d2 = sum(rise for rise, gap in runs[:2])
        d3 = sum(rise for rise, gap in runs[:3])
        d4 = sum(rise for rise, gap in runs[:4])
        d5 = sum(rise for rise, gap in runs)
        require(d3 > HEIGHT and 2**d5 <= 6**HEIGHT, ("fifth-run bound", source, runs))
        counts[d2 <= HEIGHT] += 1
        max_d4 = max(max_d4, d4)
        max_d5 = max(max_d5, (d5, source, runs))
        rows.append((source, runs))

    require(counts == [expected["long_pairs"], expected["other_long_triples"]] == [60, 5157],
            ("distinct source counts", counts))
    require(max_d4 == expected["max_D4_when_D3_gt_H"] == 162, ("old maximum D4", max_d4))
    require(max_d5[0] <= 377, ("new maximum D5", max_d5))

    receipt = {
        "status": "PASS",
        "scope": "x positive odd; x+1 < 2^146; D3(x) > 146",
        "height": HEIGHT,
        "old_coverage": "Pinned exact Terras88 projection, retaining accepted physical sources",
        "new_replay": "Five runs and their even gaps by the shortcut map",
        "source_count": sum(counts),
        "D2_gt_H": counts[0],
        "D2_le_H_lt_D3": counts[1],
        "old_max_D4": max_d4,
        "new_max_D5": max_d5[0],
        "maximizer_witness": {"source": max_d5[1], "rise_gap_pairs": max_d5[2]},
        "sorted_physical_records_sha256": sha256(json.dumps(rows, separators=(",", ":")).encode()).hexdigest(),
        "verifier_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
        "parent_sha256": PINS,
    }
    print(json.dumps(receipt, indent=2))


if __name__ == "__main__":
    main()
