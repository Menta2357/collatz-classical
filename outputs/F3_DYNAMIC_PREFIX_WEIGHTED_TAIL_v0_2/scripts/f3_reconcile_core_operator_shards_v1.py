#!/usr/bin/env python3
"""Create deterministic, auditable shards of the frozen 243-state core.

This is an offline data partition.  It does not prove the Lean filter/remap
identity and must not be reported as a formal theorem.
"""

from __future__ import annotations

import csv
import hashlib
import json
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
BASE = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_OPERATOR_DATA_RECONCILIATION_v1"
EDGE_FILE = BASE / "core_edge_identity.csv"
STATE_FILE = BASE / "core_state_ids.csv"
OUT = BASE / "shards"
BLOCKS = 9
BLOCK_SIZE = 243 // BLOCKS


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    states = []
    with STATE_FILE.open(newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            states.append({"core_local_id": int(row["core_local_id"]), "state_id": int(row["state_id"])})
    if len(states) != 243 or [r["core_local_id"] for r in states] != list(range(243)):
        raise SystemExit("expected ordered core_local_id 0..242")

    edges = []
    with EDGE_FILE.open(newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            edges.append({
                "ordinal": int(row["ordinal"]),
                "source_local": int(row["source_local"]),
                "target_local": int(row["target_local"]),
                "channel": int(row["channel"]),
            })
    if len(edges) != 729 or [r["ordinal"] for r in edges] != list(range(729)):
        raise SystemExit("expected ordered 729-edge core sequence")

    OUT.mkdir(parents=True, exist_ok=True)
    by_block: dict[int, list[dict[str, int]]] = defaultdict(list)
    for edge in edges:
        block = edge["source_local"] // BLOCK_SIZE
        if not 0 <= block < BLOCKS:
            raise SystemExit(f"invalid source block: {edge}")
        by_block[block].append(edge)

    records = []
    for block in range(BLOCKS):
        block_edges = by_block[block]
        expected_sources = list(range(block * BLOCK_SIZE, (block + 1) * BLOCK_SIZE))
        if sorted({e["source_local"] for e in block_edges}) != expected_sources:
            raise SystemExit(f"block {block} does not cover its 27 sources")
        path = OUT / f"core_edges_block_{block:02d}.csv"
        with path.open("w", newline="", encoding="utf-8") as handle:
            writer = csv.DictWriter(handle, fieldnames=["ordinal", "source_local", "target_local", "channel"])
            writer.writeheader()
            writer.writerows(block_edges)
        records.append({
            "block": block,
            "source_min": min(expected_sources),
            "source_max": max(expected_sources),
            "edge_count": len(block_edges),
            "channel_counts": dict(sorted(Counter(e["channel"] for e in block_edges).items())),
            "sha256": sha256(path),
            "path": str(path.relative_to(ROOT)),
        })

    summary = {
        "status": "OFFLINE_SHARDS_READY_LEAN_FILTER_REMAP_OPEN",
        "base_sequence_sha256": sha256(EDGE_FILE),
        "state_sequence_sha256": sha256(STATE_FILE),
        "blocks": BLOCKS,
        "block_size_states": BLOCK_SIZE,
        "total_edges": sum(r["edge_count"] for r in records),
        "channel_totals": dict(sorted(Counter(e["channel"] for e in edges).items())),
        "records": records,
        "budget_reference": "F3_LEAN_M0B_FULL_BUDGET_v1.md",
        "formal_status": "NO_LEAN_THEOREM_CLAIM",
    }
    (OUT / "shard_summary_v1.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
