#!/usr/bin/env python3
"""Verify the portable Terras 88 arithmetic and retained evidence."""

import argparse
import ast
from collections import Counter
from contextlib import redirect_stdout
from fractions import Fraction
from hashlib import sha256
from io import StringIO
import json
from pathlib import Path
import re
import subprocess
import sys
from tempfile import TemporaryDirectory
from time import monotonic
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parent
EVIDENCE = ROOT / "evidence"
NIGHT = EVIDENCE / "experiments" / "COLLATZ_ECO_20261125"
PREVIOUS = EVIDENCE / "experiments" / "COLLATZ_TERRAS_87_RUNS_20261125"
REPLAY = PREVIOUS / "WEAVER_REPLAY_20261125"


def require(condition, evidence):
    if not condition:
        raise ValueError(evidence)


def load(path):
    return json.loads(path.read_bytes())


def check_manifest(directory):
    pins = {}
    for line in (directory / "SHA256SUMS").read_text().splitlines():
        digest, name = line.split(maxsplit=1)
        name = name.removeprefix("*").removeprefix("./")
        path = (directory / name).resolve()
        require(path.is_relative_to(directory) and name not in pins, ("manifest path", name))
        require(sha256(path.read_bytes()).hexdigest() == digest, ("digest", name))
        pins[name] = digest
    require(pins, "empty manifest")
    return pins


def check_receipts(pins):
    closure = load(NIGHT / "TERRAS88_CIERRE_RECIBO.json")
    require(closure["grade"] == "PAPER_WITH_EXACT_COMPUTATIONAL_CERTIFICATES", "receipt grade")
    require(not closure["leanFormallyVerified"], "Lean scope")
    for name, digest in closure["inputs_sha256"].items():
        require(pins.get(f"evidence/{name}") == digest, ("closure pin", name))
    capacities = {row["H"]: row for row in closure["capacity"]}
    height146 = load(NIGHT / "TERRAS88_FOUR_RUNS_H146_RECEIPT.json")
    require(height146["height"] == 146 and height146["status"] == "PASS" and
            height146["exitCode"] == 0 and
            height146["sha256"] == pins[(NIGHT / height146["source"]).relative_to(ROOT).as_posix()],
            "H146 receipt source pin")
    for field in ("long_pairs", "other_long_triples"):
        require(height146[field] == capacities[146][field], ("H146 receipt", field))
    require(height146["max_D4_for_D3_gt_H"] == capacities[146]["max_D4_when_D3_gt_H"],
            "H146 maximum in D3 > H")
    print(f"PINNED: {len(pins)} portable files, including {len(closure['inputs_sha256'])} closure inputs")
    print(f"ARCHIVED ELSEWHERE: {len(closure['auxiliary_files_not_bundled_sha256'])} auxiliary pins")
    return closure, capacities


def check_capacities(capacities, replay_all):
    from TERRAS88_four_runs_107_170 import mask_certificate
    from TERRAS88_four_runs_66_67 import run_certificate

    short_heights = (66, 67, 92)
    heights = tuple(sorted(capacities)) if replay_all else short_heights
    for height in heights:
        row = capacities[height]
        use_mask = row["algorithm"] == "full masked projections" or not replay_all
        output = StringIO()
        with redirect_stdout(output):
            search = mask_certificate if use_mask else run_certificate
            search(height)
        lines = output.getvalue().splitlines()
        if use_mask:
            counts = ast.literal_eval(lines[1].strip())
            observed = counts["long_pairs"], counts["other_long_triples"]
        else:
            bounded, pairs, triples = map(int, re.findall(r"\d+", lines[1]))
            observed = pairs, triples
            if height == 146:
                receipt = load(NIGHT / "TERRAS88_FOUR_RUNS_H146_RECEIPT.json")
                require(bounded == receipt["bounded_tuples"], "H146 tuple count")
        maximum = int(re.search(r"max D4 on D3>H: (\d+)", lines[2]).group(1))
        require(observed == (row["long_pairs"], row["other_long_triples"]) and
                maximum == row["max_D4_when_D3_gt_H"], ("four-run replay", height))
        print(f"RECOMPUTED: H={height}, counts {observed}, max D4 on D3>H = {maximum}")
    if not replay_all:
        print("RECEIPTS ONLY: four-run enumeration at H=107,146,170")


def check_arithmetic(closure):
    from TERRAS88_check import (
        ALPHA, ODD_LIMIT, RUNS, check_double, check_new_pair, check_queries,
        gap_interval, geometric_sum, log_interval, rank_height, sieve, tail_bound,
    )
    from TERRAS88_four_runs_66_67 import check_double_from_67
    from TERRAS88_four_runs_107_170 import check_q1
    from verify_ranked_path import B, QUERIES
    from verify_three_independent import HEIGHTS, verify

    for height in HEIGHTS:
        require(verify(height)["H"] == height, ("two/three-run replay", height))
    print("RECOMPUTED: eight inherited two/three-run windows via the global source coordinate")

    ln2, ln3 = log_interval(2), log_interval(3)
    require(1 < ln3[0] / ln2[1] < ln3[1] / ln2[0] < ALPHA, "log enclosure")
    require(geometric_sum(RUNS) * (7 + Fraction(133, 10) * 72) < ODD_LIMIT, "Rhin cutoff")
    sieve(ln2, ln3)
    check_new_pair(ln2, ln3)
    with redirect_stdout(StringIO()):
        check_queries(ln2, ln3)
        check_double(ln2, ln3)
    check_double_from_67()
    check_q1()
    for index, query in enumerate(QUERIES):
        k, d, low, tail, target, source, target_height = query
        row = closure[f"Q{index}_delta1"]
        for rank, height in row["rank_floors"].items():
            require(rank_height(d, int(rank), 4) == height, ("rank floor", index, rank))
        gap = gap_interval(k, d, ln2, ln3)[0]
        slack = gap - Fraction(low - 2, B) - Fraction(1, B * (B + 1)) - tail_bound(d, tail, 4)
        require(slack > 0 and (source - 1) * slack < tail - low <= source * slack and
                source == row["strict_source_cap"] and
                rank_height(d, target, 4) == target_height and
                target - low == row["max_complete_blocks"], ("query receipt", index))
        print(f"RECOMPUTED: Q{index}, z < {source}, target >= 2^{target_height}-1, at most {target - low} blocks")
    print("RECOMPUTED: lattice sieve, double exclusion, rank bounds and strict Q0/Q1 transfers")
    return B, QUERIES


def weaver_run(read, names, record, base, queries, check_hash):
    index, method, identity = (record[k] for k in ("query_index", "method", "identity"))
    prefix = f"results/cst_paths/m86_q{index}/{method}_{identity[:12]}"
    result_path = f"{prefix}/result.json"
    data = read(result_path)
    if check_hash:
        require(sha256(data).hexdigest() == record["result_sha256"], ("result digest", prefix))
    result = json.loads(data)
    require(result["complete"] and result["excluded"] and result["witnesses"] == [] and
            result["identity"] == identity, ("completed exclusion", prefix))
    require(result["aggregate_stats"] == record["aggregate_stats"], ("aggregate statistics", prefix))
    k, d, low, tail, target, cap, exponent = queries[index]
    query = result["identity_data"]["query"]
    expected = dict(candidate=[k, d], low_rank=low, tail_rank=tail, target_rank=target,
                    source_lower=base + 1, source_upper=cap - 1, target=2**exponent - 1,
                    target_power=exponent, blocks=target - low, intermediate_valleys_at_least_source=True)
    require(all(query[key] == value for key, value in expected.items()), ("query domain", prefix))
    shard_names = [name for name in names if name.startswith(f"{prefix}/shards/")]
    require(len(shard_names) == result["shards"] == record["all_shards_reexecuted"] and
            record["with_witness"] == record["fresh_cached"] == 0 and
            record["same_stats_per_shard"], ("archived partition coverage", prefix))
    stats = Counter()
    shards = {}
    for name in shard_names:
        shard = json.loads(read(name))
        key = Path(name).stem
        require(shard["complete"] and shard["witness"] is None and shard["identity"] == identity and
                str(shard["shard"]) == key and key not in shards, ("completed shard", name))
        shards[key] = shard["stats"]
        stats.update(shard["stats"])
    require(dict(stats) == result["aggregate_stats"], ("sum of shard statistics", prefix))
    print(f"{'RETAINED' if check_hash else 'REPLAYED'}: Q{index} {method}, {len(shards)} shards, zero witnesses")
    return shards


def check_weaver_archive(path, digest, directory):
    require(sha256(path.read_bytes()).hexdigest() == digest, "published Weaver archive digest")
    with ZipFile(path) as archive:
        for name in archive.namelist():
            require((directory / name).resolve().is_relative_to(directory), ("archive path", name))
        archive.extractall(directory)
    require(len(check_manifest(directory)) == 19, "published Weaver manifest count")


def check_weaver(closure, base, queries, args):
    source = load(REPLAY / "RECIBO.json")
    records = source["runs"]
    require({(r["query_index"], r["method"]) for r in records} ==
            {(i, method) for i in range(2) for method in ("progression", "affine")} and
            len(records) == 4, "four Weaver runs")
    for inherited, record in zip(closure["imported_Weaver_reexecution"], records, strict=True):
        require((inherited["query"], inherited["method"], inherited["partitions"],
                 inherited["matching_statistics"], inherited["witnesses"]) ==
                (record["query_index"], record["method"], record["all_shards_reexecuted"],
                 record["same_stats_per_shard"], record["with_witness"]), "closure replay reference")
    with ZipFile(REPLAY / "WEAVER_SHARDS.zip") as archive:
        names = archive.namelist()
        require(len(set(names)) == len(names) == 1763, "retained result and shard count")
        archived = [weaver_run(archive.read, names, run, base, queries, True) for run in records]

    if args.weaver_archive is None:
        print("RECEIPTS ONLY: 1,759 Weaver shards checked as records, with no cylinder searches run")
        return
    with TemporaryDirectory(prefix="terras88-weaver-") as temp:
        directory = Path(temp).resolve()
        check_weaver_archive(args.weaver_archive, source["attachment_sha256"], directory)
        for run, expected_shards in zip(records, archived, strict=True):
            command = [sys.executable, "-B", "experiments/cst_path_search.py", "--queries",
                       "results/cst_86_queries.json", "--index", str(run["query_index"]), "--method",
                       run["method"], "--fresh", "--workers", str(args.weaver_workers),
                       "--seconds", str(args.weaver_seconds)]
            subprocess.run(command, cwd=directory, check=True, timeout=args.weaver_seconds + 30)
            fresh_names = [path.relative_to(directory).as_posix()
                           for path in (directory / "results/cst_paths").rglob("*.json")]
            fresh = weaver_run(lambda name: (directory / name).read_bytes(), fresh_names,
                               run, base, queries, False)
            require(fresh == expected_shards, ("same statistics per shard", run["identity"]))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--full-capacities", action="store_true",
                        help="replay all four-run searches (reference time about 3 min)")
    parser.add_argument("--weaver-archive", type=Path,
                        help="replay all four Weaver runs from the original pinned ZIP (may take an hour)")
    parser.add_argument("--weaver-workers", type=int, default=1)
    parser.add_argument("--weaver-seconds", type=int, default=3600, help="time limit per Weaver search")
    args = parser.parse_args()
    if not __debug__:
        parser.error("run Python without -O so inherited assertions stay active")
    if args.weaver_workers < 1 or args.weaver_seconds < 1:
        parser.error("Weaver workers and seconds must be positive")
    if args.weaver_archive is not None and not args.weaver_archive.is_file():
        parser.error("the supplied Weaver archive is missing")

    started = monotonic()
    closure, capacities = check_receipts(check_manifest(ROOT))
    sys.dont_write_bytecode = True
    sys.path[:0] = [str(NIGHT), str(PREVIOUS)]
    check_capacities(capacities, args.full_capacities)
    base, queries = check_arithmetic(closure)
    check_weaver(closure, base, queries, args)
    print(f"PASS: arithmetic and evidence checks in {monotonic() - started:.2f}s")
    print("SCOPE: paper proof with external inputs, finite first crossing and at most 88 odd runs")


if __name__ == "__main__":
    main()
