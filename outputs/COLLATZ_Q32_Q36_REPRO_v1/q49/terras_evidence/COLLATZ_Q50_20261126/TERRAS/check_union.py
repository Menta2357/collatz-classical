#!/usr/bin/env python3
"""Verify the two A70 receipts and the pinned analytic complement."""

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
EXPERIMENTS = HERE.parents[1]
PINS = {
    "RECIBO_LOW.json": "ae327ace53193b0a9d41d5a45820c4faf287c01a64a8db856f0255e7c623c745",
    "RECIBO_HIGH.json": "fb650cac4a52827c951ec517bf97e2d4e29a0fb5eedb81a6b31d2740c88ec935",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def read_receipt(item):
    name, expected = item
    data = (HERE / name).read_bytes()
    require(sha256(data).hexdigest() == expected, ("receipt SHA256", name))
    receipt = json.loads(data)
    require(receipt["status"] == "PASS" and receipt["elapsed_seconds"] < receipt["time_limit_seconds"] == 20
            and not (receipt["A69_executed"] or receipt["H146_executed"]), ("execution scope", name))
    for file, key in (("check.py", "verifier_sha256"), ("PREREGISTRO.md", "preregistration_sha256")):
        require(sha256((HERE / file).read_bytes()).hexdigest() == receipt[key], ("implementation pin", file))
    for path, digest in receipt["parent_sha256"].items():
        require(sha256((EXPERIMENTS / path).read_bytes()).hexdigest() == digest, ("parent pin", path))
    return receipt


def main():
    low, high = map(read_receipt, PINS.items())
    scope = {"H": 92, "a1": 70, "D3_upper": 92, "D4_lower": 95}
    require(low["scope"] == dict(scope, b1="1..3") and high["scope"] == dict(scope, b1=">=4"),
            "disjoint complete partition")
    require(not low["first_gap_tail_projected"] and high["first_gap_tail_projected"] and
            low["parent_sha256"] == high["parent_sha256"], "one root tail and common parents")
    groups = [receipt["retained_by_physical_first_gap"] for receipt in (low, high)]
    require(all(1 <= int(gap) <= 3 for gap in groups[0]) and all(int(gap) >= 4 for gap in groups[1]),
            "disjoint physical source groups")
    sources = [sum(group.values()) for group in groups]
    require(sources == [receipt["independently_replayed_sources"] for receipt in (low, high)] == [28, 9],
            "residual source counts")
    costs = [receipt["counters"]["projections"] for receipt in (low, high)]
    require(costs == [receipt["projection_limit"] for receipt in (low, high)] == [14_817, 11_919],
            "projection budgets")
    maxima = [receipt["max_D5_on_residual"] for receipt in (low, high)]
    require(maxima == [101, 100] and 2**max(maxima) <= 6**92, "fifth-run bounds")
    print(json.dumps({
        "status": "PASS_FULL_A70",
        "scope": {"H": 92, "a1": 70},
        "certified_conclusion": "2^D5 <= 6^92",
        "coverage": {"D3>92": "sealed Q44 source family", "D4<=94": "audited Q49 ordinal corollary",
                     "D3<=92 and D4>=95": "two disjoint Q50 physical first-gap shards"},
        "projections_by_shard": costs,
        "total_projections": sum(costs),
        "retained_residual_sources": sum(sources),
        "max_D5_on_residual": max(maxima),
        "pending_H92": ["a1<=2 with D3<=92<D4", "3<=a1<=69 with D3<=92 and D4>=95"],
        "H146_executed": False,
        "receipt_sha256": PINS,
    }, indent=2))


if __name__ == "__main__":
    main()
