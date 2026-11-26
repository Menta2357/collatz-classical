#!/usr/bin/env python3
"""Check both disjoint A72 receipts without running either projection."""

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PINS = {
    "../TERRAS89_A72_LOW_GAPS/RECIBO.json":
        "78dd03630c530bbc9e19bc806a4d8c9d8563e6369d959c77af93d1ee69a521ae",
    "RECIBO.json":
        "1acd4bb416e741d1cb7c00ce37b523d5b268adfb5896c7ed09bf732877688cab",
}


def require(condition, context):
    if not condition:
        raise ArithmeticError(context)


def main():
    receipts = []
    for relative, hash_ in PINS.items():
        path = HERE / relative
        data = path.read_bytes()
        require(sha256(data).hexdigest() == hash_, ("receipt SHA256", relative))
        receipt = json.loads(data)
        require(receipt["status"] == "PASS" and receipt["elapsed_seconds"] < 20
                and receipt["time_limit_seconds"] == 20 and not receipt["H146_executed"],
                ("PASS within budget", relative))
        for file, key in (("check.py", "verifier_sha256"), ("PREREGISTRO.md", "preregistration_sha256")):
            require(sha256(path.with_name(file).read_bytes()).hexdigest() == receipt[key],
                    ("preregistration or verifier SHA256", relative, file))
        receipts.append(receipt)
    low, high = receipts
    require(low["scope"] == {"H": 92, "a1": 72, "b1_inclusive": [1, 2]} and
            high["scope"] == {"H": 92, "a1": 72, "b1_minimum": 3}, "disjoint intervals")
    require(low["parent_sha256"] == high["parent_sha256"] and
            not (low["root_b1_ge_3_executed"] or high["root_b1_le_2_executed"]), "separate execution")
    projections = [receipt["counters"]["projections"] for receipt in receipts]
    require(projections == [receipt["projection_limit"] for receipt in receipts] == [7004, 8826],
            "projection budgets")
    groups = {}
    for receipt, in_scope in ((low, lambda gap: 1 <= gap <= 2), (high, lambda gap: gap >= 3)):
        local = receipt["retained_domains_by_physical_first_gap"]
        require(all(in_scope(int(gap)) for gap in local) and not groups.keys() & local.keys(),
                "retained sources belong to disjoint physical gaps")
        require(sum(value for counts in local.values() for value in counts.values())
                == receipt["independently_replayed_sources"], "physical source count")
        groups.update(local)
    totals = {key: sum(group[key] for group in groups.values())
              for key in ("D3_gt_H", "D3_le_H_lt_D4")}
    maximum = max(receipt["max_D5_when_D4_gt_H"] for receipt in receipts)
    require(totals == {"D3_gt_H": 8, "D3_le_H_lt_D4": 96} and maximum == 104,
            "union counts and maximum")
    require(2**maximum <= 6**92 and sum(projections) == 15_830, "union certificate")
    print(json.dumps({
        "status": "PASS_FULL_A72",
        "scope": {"H": 92, "a1": 72, "b1_minimum": 1},
        "certified_conclusion": "2^D5 <= 6^92",
        "D4_le_H": "analytic recurrence",
        "D4_gt_H": "two disjoint physical first-gap shards",
        "projections_by_shard": projections,
        "total_projections": sum(projections),
        "retained_sources": sum(totals.values()),
        **totals,
        "max_D5_when_D4_gt_H": maximum,
        "read_only_aggregation": True,
        "pending": ["H92, a1<=71, D3<=92<D4", "H146 or equivalent rank floor", "Terras89 Q0 Delta=1"],
        "receipt_sha256": PINS,
    }, indent=2))


if __name__ == "__main__":
    main()
