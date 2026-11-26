#!/usr/bin/env python3
"""Check the two closed capacities and their transfer to the Q0 exclusion."""

from argparse import ArgumentParser
from contextlib import redirect_stdout
from fractions import Fraction
from hashlib import sha256
from io import StringIO
import json
from pathlib import Path
from runpy import run_path
import subprocess
import sys


EXPERIMENTS = Path(__file__).resolve().parents[2]
Q51 = EXPERIMENTS/"COLLATZ_Q51_20261126"
Q37 = EXPERIMENTS/"COLLATZ_Q37_20261125"/"TERRAS89_PAPER"/"check.py"
WEAVER = EXPERIMENTS/"COLLATZ_TERRAS_87_RUNS_20261125"/"WEAVER_REPLAY_20261125"/"RECIBO.json"
CAPACITY_RECEIPTS = {
    (92, "low"): (Q51/"H92_TERMINAL_INVERSE"/"RECIBO.json",
                  "bd44e054ffb513be0a233d03f773e9a6df379b7f8a841db06351f4d8ca460544"),
    (92, "high"): (EXPERIMENTS/"COLLATZ_Q44_20261125"/"TERRAS89_D3_HIGH"/"RECIBO.json",
                   "354a8fba34f152b00c54f595713ebec5360a8ca051816ed75ab241e700a65a8c"),
    (146, "low"): (Q51/"H146_TERMINAL_INVERSE"/"RECIBO.json",
                   "5aba3a349cd19f2b67d18e42b107411691a074498242e29ddbe52df00f69baa9"),
    (146, "high"): (Q51/"H146_D3_HIGH"/"RECIBO.json",
                    "49dfaab73a7b07a9b3ea3f296bba107fb03292d2b7089b52674a4d8a3e576a92"),
}
Q37_PIN = "70da49e25ded08f542ee969d1e2d8b243dc7d5fe5650e9e43ef765fa28a1233d"


def require(test, detail):
    if not test:
        raise ArithmeticError(detail)


def pin(path, expected):
    data = path.read_bytes()
    require(sha256(data).hexdigest() == expected, ("SHA256", str(path.relative_to(EXPERIMENTS))))
    return data


def capacities(replay):
    limits = {92: 237, 146: 377}
    caps = {}
    for (height, case), (path, digest) in CAPACITY_RECEIPTS.items():
        evidence = json.loads(pin(path, digest))
        require(evidence["height"] == height, ("height", height))
        if case == "low":
            for filename, expected in evidence["scripts_sha256"].items():
                pin(path.parent/filename, expected)
            require(evidence["status"] == f"PASS_H{height}_D3_AT_MOST_{height}"
                    and evidence["D3_at_most"] == height
                    and evidence["D5_at_most"] == limits[height]
                    and evidence["full_seed_replays"] == 0, ("terminal cover", height))
            stats = {"candidates": len(evidence["candidates"]), **evidence["counters"]}
        else:
            pin(path.parent/"check.py", evidence["verifier_sha256"])
            require(evidence["status"] == "PASS"
                    and evidence["scope"] == f"x positive odd; x+1 < 2^{height}; D3(x) > {height}"
                    and evidence["new_max_D5"] <= limits[height]
                    and evidence["source_count"] == evidence["D2_gt_H"] + evidence["D2_le_H_lt_D3"],
                    ("forward cover", height))
            stats = {"physical_sources": evidence["source_count"], "D5_max": evidence["new_max_D5"]}
        if replay:
            completed = subprocess.run([sys.executable, "-B", str(path.parent/"check.py")],
                                       capture_output=True, text=True, check=True, timeout=240)
            require(json.loads(completed.stdout) == evidence, ("reproduction", height, case))
        caps.setdefault(height, {})[case] = stats
    for height, maximum in limits.items():
        require(2**maximum <= 6**height < 2**(maximum+1), ("integer threshold", height))
        caps[height]["D5_bound"] = maximum
    return caps


def main(replay):
    caps = capacities(replay)
    pin(Q37, Q37_PIN)
    sys.dont_write_bytecode = True
    prior = run_path(str(Q37))
    ln2, ln3 = (prior["log_interval"](base) for base in (2,3))
    with redirect_stdout(StringIO()):
        prior["clock_sieve"](ln2, ln3)
        prior["replay_caps"]()
        prior["exclusions"](ln2, ln3)

    weaver = json.loads(pin(WEAVER, prior["PINS"][WEAVER]))
    k,d = prior["Q0"]
    gap = prior["gap_interval"](k,d,ln2,ln3)[0]
    ranks = prior["ordered_bounds"](d, tuple(sorted(caps)))
    transfer = prior["transfer"](gap,1,ranks,0,6,10)
    u = 453_027_402_666_008_300_866
    require(transfer == (6,10,11,146,u), "Q0 delta=1 covered")
    require(ranks[0][10:16] == [92,146,146,170,231,256], "last ranked floors")
    require(89 > 6*5 and all(89>4*r for r in (10,11)), "chronology and absorption")
    margin = u*prior["slack"](gap,1,6,10,ranks[1])-4
    require(margin>0, "strict price margin")
    query = weaver["q0_domain"]
    require(query["candidate"] == [k,d] and
            query["source_lower"] == prior["B"]+1 and query["source_upper"] == u-1
            and query["target"] == 2**146-1 and query["blocks"] == 5
            and query["intermediate_valleys_at_least_source"], "exact Weaver domain")
    records = [row for row in weaver["runs"] if row["query_index"]==0]
    require({row["method"] for row in records} == {"progression","affine"}
            and all(row["with_witness"]==0 and row["same_stats_per_shard"] for row in records),
            "both archived Weaver Q0 reruns")

    print(json.dumps(dict(status="PASS_TERRAS89_PAPER_WITH_EXACT_CERTIFICATES",
                          scope="finite first coefficient crossing, at most 89 maximal odd runs",
                          capacities=caps, q0_delta1="excluded",
                          q0_clocks=[k,d], rank_floors=ranks[0][10:16],
                          rank_cut=transfer, price_margin_floor_1e30=(margin*10**30).__floor__(),
                          source_inclusive=[query["source_lower"],query["source_upper"]],
                          target_at_least=query["target"], blocks_at_most=query["blocks"],
                          archived_weaver_shards=sum(row["all_shards_reexecuted"] for row in records),
                          local_five_run_proofs=True, requires_freelan_b5=False,
                          all_proofs_formalized_in_lean=False,
                          universal_first_crossing_proved=False), indent=2))


if __name__ == "__main__":
    cli=ArgumentParser(description=__doc__)
    cli.add_argument("--replay",action="store_true",help="rerun all four height certificates")
    main(cli.parse_args().replay)
