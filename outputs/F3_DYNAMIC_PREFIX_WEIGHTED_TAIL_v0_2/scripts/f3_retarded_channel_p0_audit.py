#!/usr/bin/env python3
"""Audit the minimum retarded-channel share on the frozen split core.

The denominator is the frozen row value (w^T M_split)_s and the numerator is
the retarded edge contribution only.  This is a diagnostic input to the
paper proof; it is not itself a renewal theorem.
"""

from __future__ import annotations

import csv
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "retarded_channel_p0_audit.json"


def main() -> None:
    weights: dict[int, float] = {}
    frozen_rows: dict[int, dict[str, str]] = {}
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            state_id = int(row["state_id"])
            weights[state_id] = float(row["rational_weight_decimal"])
            frozen_rows[state_id] = row

    retarded_edges: dict[int, list[dict[str, str]]] = {}
    with (RESULTS / "split_edges.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            if row["channel"] == "retarded":
                retarded_edges.setdefault(int(row["source_id"]), []).append(row)

    ratios: list[dict[str, object]] = []
    for source_id, source_weight in weights.items():
        edges = retarded_edges.get(source_id, [])
        if len(edges) != 1:
            raise RuntimeError(f"expected one retarded edge for core state {source_id}")
        edge = edges[0]
        target_id = int(edge["target_id"])
        numerator = float(edge["weight_decimal"]) * weights[target_id]
        denominator = float(frozen_rows[source_id]["lhs_wM_decimal"])
        ratios.append(
            {
                "source_id": source_id,
                "target_id": target_id,
                "retarded_contribution": numerator,
                "frozen_row_lhs_wM": denominator,
                "retarded_share": numerator / denominator,
            }
        )

    minimum = min(ratios, key=lambda row: float(row["retarded_share"]))
    payload = {
        "definition": "p0 = min_s (retarded contribution to (w^T M_split)_s) / (w^T M_split)_s",
        "core_state_count": len(ratios),
        "p0_decimal": minimum["retarded_share"],
        "argmin_source_id": minimum["source_id"],
        "argmin_target_id": minimum["target_id"],
        "argmin_retarded_contribution": minimum["retarded_contribution"],
        "argmin_frozen_row_lhs_wM": minimum["frozen_row_lhs_wM"],
        "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
        "status": "DIAGNOSTIC_INPUT_TO_LEMMA_B",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
