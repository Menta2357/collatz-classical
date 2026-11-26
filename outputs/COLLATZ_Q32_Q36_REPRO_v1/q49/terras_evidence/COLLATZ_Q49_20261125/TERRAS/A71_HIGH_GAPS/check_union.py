#!/usr/bin/env python3
"""Verify the disjoint A71 receipts without projecting again."""

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PINS = {
    "../RECIBO.json": "868ec1f123af8f9768a8ea882110e4dd2afe9d8bb4965cb8fcd03a0fae3ffef1",
    "RECIBO.json": "8da426ec685ab0a97574a02859b8f1d12aacc342e2bda6609e7d426eaed6ea5e",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def read_receipt(relative):
    path = HERE / relative
    data = path.read_bytes()
    require(sha256(data).hexdigest() == PINS[relative], ("pinned receipt", relative))
    receipt = json.loads(data)
    require(receipt["status"] == "PASS" and receipt["elapsed_seconds"] < receipt["time_limit_seconds"] == 20
            and not receipt["H146_executed"], ("execution", relative))
    for file, key in (("check.py", "verifier_sha256"), ("PREREGISTRO.md", "preregistration_sha256")):
        require(sha256(path.with_name(file).read_bytes()).hexdigest() == receipt[key],
                ("source and preregistration pins", relative, file))
    return receipt


def main():
    low, high = map(read_receipt, PINS)
    base = {"H": 92, "a1": 71, "residual": "D3<=92<D4"}
    require(low["scope"] == dict(base, b1_inclusive=[1, 4]) and high["scope"] == dict(base, b1_minimum=5),
            "physical first-gap partition")
    require(not (low["root_b1_ge_5_executed"] or high["root_b1_le_4_executed"] or high["A70_executed"]),
            "separate execution")
    require(low["parent_sha256"] == high["parent_sha256"] and
            low["verifier_sha256"] == high["pinned_low_verifier_sha256"], "common pinned method")
    low_counts = low["retained_domains_by_physical_first_gap"]
    high_counts = high["retained_domains_by_physical_first_gap"]
    require(all(1 <= int(gap) <= 4 for gap in low_counts) and all(int(gap) >= 5 for gap in high_counts),
            "disjoint retained sources")
    sizes = [sum(low_counts.values()), sum(high_counts.values())]
    require(sizes == [low["independently_replayed_sources"], high["independently_replayed_sources"]] == [103, 4],
            "physical counts")
    costs = [low["counters"]["projections"], high["counters"]["projections"]]
    require(costs == [low["projection_limit"], high["projection_limit"]] == [14_297, 6_415], "projection caps")
    maximum = max(low["max_D5_on_residual"], high["max_D5_on_residual"])
    require(maximum == 102 and 2**maximum <= 6**92, "advertised bound")
    print(json.dumps({
        "status": "PASS_FULL_A71",
        "scope": {"H": 92, "a1": 71},
        "certified_conclusion": "2^D5 <= 6^92",
        "coverage": {"D4<=92": "analytic recurrence", "D3>92": "sealed Q44 certificate",
                     "D3<=92<D4": "two disjoint physical first-gap shards"},
        "projections_by_shard": costs,
        "total_projections": sum(costs),
        "retained_residual_sources": sum(sizes),
        "max_D5_on_residual": maximum,
        "read_only_aggregation": True,
        "pending_from_this_certificate": ["H92, a1<=70, D3<=92<D4", "H146 or equivalent rank floor",
                                          "Terras89 Q0 Delta=1"],
        "receipt_sha256": PINS,
    }, indent=2))


if __name__ == "__main__":
    main()
