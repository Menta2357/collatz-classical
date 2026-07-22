#!/usr/bin/env python3
"""Audit the matrix-orientation convention against the frozen left vector."""

from __future__ import annotations

import csv
import hashlib
import json
import math
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
SPLIT = ROOT / "results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = ROOT / "results/F3_ORIENTATION_AUDIT_v1"
RHO = 9 / 5
DELTA = 1 / 100


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    h.update(path.read_bytes())
    return h.hexdigest()


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    with (SPLIT / "frozen_w_split_core.csv").open(newline="") as handle:
        weights = list(csv.DictReader(handle))
    with (SPLIT / "split_edges.csv").open(newline="") as handle:
        edges = list(csv.DictReader(handle))
    local = {int(row["state_id"]): int(row["core_local_id"]) for row in weights}
    w = np.array(
        [int(row["integer_weight_over_D"]) / 1_000_000 for row in sorted(weights, key=lambda r: int(r["core_local_id"]))],
        dtype=float,
    )
    alpha = math.log(3, 2)
    channel_weight = {
        "retarded": RHO ** -2,
        "advanced_direct_c2": RHO ** (alpha - 1) / 3,
        "advanced_parity_lift_c1": RHO ** (alpha - 2) / 3,
    }
    matrix = np.zeros((len(w), len(w)), dtype=float)
    for row in edges:
        source = int(row["source_id"])
        target = int(row["target_id"])
        if source in local and target in local:
            matrix[local[source], local[target]] += channel_weight[row["channel"]]

    right = matrix @ w
    left = w @ matrix
    rhs = (1 + DELTA) * w
    right_ratio = right / rhs
    left_ratio = left / rhs
    rows = []
    for i, row in enumerate(sorted(weights, key=lambda r: int(r["core_local_id"]))):
        rows.append(
            {
                "core_local_id": i,
                "state": row["state"],
                "weight": f"{w[i]:.18e}",
                "right_Mw_ratio": f"{right_ratio[i]:.18e}",
                "left_wM_ratio": f"{left_ratio[i]:.18e}",
                "right_pass": "yes" if right_ratio[i] >= 1 else "no",
                "left_pass": "yes" if left_ratio[i] >= 1 else "no",
            }
        )
    rows_path = OUT / "orientation_rows.csv"
    with rows_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    summary = {
        "status": "ORIENTATION_CONVENTION_REOPENED",
        "matrix_definition": "source_to_target M[source,target]",
        "paper_and_bridge_required_action": "right M*w",
        "frozen_csv_action": "left w^T*M",
        "state_count": len(w),
        "right_min_ratio": float(np.min(right_ratio)),
        "right_fail_count": int(np.sum(right_ratio < 1)),
        "left_min_ratio": float(np.min(left_ratio)),
        "left_fail_count": int(np.sum(left_ratio < 1)),
        "transpose_repair_equivalence": "(M.T)*w = w^T*M",
        "no_claims": ["NO_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_GLOBAL_COLLATZ_CLAIM", "NO_F3_THEOREM"],
    }
    summary_path = OUT / "summary.json"
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    manifest_path = OUT / "manifest_sha256.csv"
    with manifest_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256"], lineterminator="\n")
        writer.writeheader()
        for path in (rows_path, summary_path):
            writer.writerow({"path": path.name, "sha256": sha256(path)})
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
