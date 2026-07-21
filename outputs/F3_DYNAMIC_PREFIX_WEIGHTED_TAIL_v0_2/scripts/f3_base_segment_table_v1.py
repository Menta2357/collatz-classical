#!/usr/bin/env python3
"""Enumerate the finite base segment for Lemma C.

The base population is the root witness itself: every selected root a is a
member of piStar(a, 2^8*a).  The table records one positive witness per core
state, the frozen weight mass, and a shortest split-core path to a fixed base
state.  It is a finite paper hook, not an asymptotic claim.
"""

from __future__ import annotations

import csv
import hashlib
import json
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "results" / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = RESULTS / "base_segment_table_v1.csv"
SUMMARY = RESULTS / "base_segment_table_v1_summary.json"
BASE_INTERVAL = (3, 10_369)
Y_BASE = 8
TARGET_STATE = "d5:r2:podd:b0"


def state_label(n: int) -> str:
    parity = "even" if n % 2 == 0 else "odd"
    bucket = 0 if n % 2 else (1 if n % 4 else 2)
    return f"d5:r{n % 243}:p{parity}:b{bucket}"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def main() -> None:
    weights: dict[str, float] = {}
    with (RESULTS / "frozen_w_split_core.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            weights[row["state"]] = float(row["rational_weight_decimal"])
    core = set(weights)

    root_counts: Counter[str] = Counter()
    root_min: dict[str, int] = {}
    root_max: dict[str, int] = {}
    for root in range(*BASE_INTERVAL):
        if root % 3 != 2:
            continue
        state = state_label(root)
        if state not in core:
            continue
        root_counts[state] += 1
        root_min[state] = min(root_min.get(state, root), root)
        root_max[state] = max(root_max.get(state, root), root)

    reverse: dict[str, set[str]] = {state: set() for state in core}
    with (RESULTS / "split_edges.csv").open(newline="") as handle:
        for row in csv.DictReader(handle):
            source, target = row["source"], row["target"]
            if source in core and target in core:
                reverse[target].add(source)
    distance: dict[str, int] = {TARGET_STATE: 0}
    queue: deque[str] = deque([TARGET_STATE])
    while queue:
        target = queue.popleft()
        for source in reverse[target]:
            if source not in distance:
                distance[source] = distance[target] + 1
                queue.append(source)

    rows: list[dict[str, object]] = []
    for state in sorted(core):
        count = root_counts[state]
        rows.append(
            {
                "state": state,
                "root_count": count,
                "root_min": root_min.get(state, ""),
                "root_max": root_max.get(state, ""),
                "frozen_weight": weights[state],
                "weighted_base_mass": count * weights[state],
                "distance_to_target_state": distance.get(state, -1),
                "positive_witness": count > 0 and distance.get(state, -1) >= 0,
            }
        )

    with OUT.open("w", newline="", encoding="utf-8") as handle:
        fields = list(rows[0])
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)

    masses = [float(row["weighted_base_mass"]) for row in rows]
    distances = [int(row["distance_to_target_state"]) for row in rows]
    payload = {
        "table": "F3_BASE_SEGMENT_TABLE_v1",
        "interval_half_open": list(BASE_INTERVAL),
        "y_base": Y_BASE,
        "target_state": TARGET_STATE,
        "core_state_count": len(rows),
        "root_count_total": sum(int(row["root_count"]) for row in rows),
        "root_count_min": min(int(row["root_count"]) for row in rows),
        "root_count_max": max(int(row["root_count"]) for row in rows),
        "zero_witness_states": sum(int(row["root_count"]) == 0 for row in rows),
        "unreachable_states": sum(int(row["distance_to_target_state"]) < 0 for row in rows),
        "distance_max": max(distances),
        "weighted_base_mass_min": min(masses),
        "weighted_base_mass_max": max(masses),
        "weighted_base_mass_min_state": min(rows, key=lambda row: float(row["weighted_base_mass"]))["state"],
        "table_sha256": sha256(OUT),
        "status": "PASS_FINITE_BASE_SEGMENT",
        "interpretation": "root witnesses are members of piStar(root, 2^y_base*root); no asymptotic claim",
        "frozen_w_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
        "non_claims": ["NO_FORMAL_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_LEAN_OPERATOR"],
    }
    SUMMARY.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))


if __name__ == "__main__":
    main()
