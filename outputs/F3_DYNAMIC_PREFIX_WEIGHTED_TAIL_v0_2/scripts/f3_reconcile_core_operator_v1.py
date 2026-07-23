#!/usr/bin/env python3
"""Independently reconcile the frozen M0-a split list with the Lean core list.

This is a data audit, not a Lean or rho certificate.  The M0-a CSV is filtered
to the 243 state IDs present in ``frozen_w_split_core.csv`` and remapped to
the local indices emitted by ``F3ReturnExcursionExactCoreMatrix.lean``.  The
generated Lean edge sequence is parsed and compared entry-by-entry so that a
future Lean theorem has a frozen finite relation to prove rather than an
implicit generator convention.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
RESULT = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
MATRIX = ROOT / "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.lean"
OUT = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_OPERATOR_DATA_RECONCILIATION_v1"

CHANNELS = {
    "retarded": 0,
    "advanced_direct_c2": 1,
    "advanced_parity_lift_c1": 2,
}
EDGE_RE = re.compile(
    r"\{ source := ⟨(\d+), by decide⟩, "
    r"target := ⟨(\d+), by decide⟩, channel := (\d+) \}"
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    with (RESULT / "frozen_w_split_core.csv").open(newline="") as handle:
        weights = list(csv.DictReader(handle))
    with (RESULT / "split_edges.csv").open(newline="") as handle:
        split_edges = list(csv.DictReader(handle))

    local = {int(row["state_id"]): int(row["core_local_id"]) for row in weights}
    if len(local) != 243 or sorted(local.values()) != list(range(243)):
        raise SystemExit("selected core-state map is not a permutation of 0..242")

    expected = []
    for row in split_edges:
        source = int(row["source_id"])
        target = int(row["target_id"])
        channel = CHANNELS.get(row["channel"])
        if source in local and target in local:
            if channel is None:
                raise SystemExit(f"unexpected internal channel: {row['channel']}")
            expected.append((local[source], local[target], channel))

    generated = [tuple(map(int, match)) for match in EDGE_RE.findall(MATRIX.read_text())]
    sequence_match = expected == generated
    counts_expected = Counter(channel for _, _, channel in expected)
    counts_generated = Counter(channel for _, _, channel in generated)

    state_ids_path = OUT / "core_state_ids.csv"
    with state_ids_path.open("w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["core_local_id", "state_id"])
        for row in sorted(weights, key=lambda item: int(item["core_local_id"])):
            writer.writerow([row["core_local_id"], row["state_id"]])

    edge_identity_path = OUT / "core_edge_identity.csv"
    with edge_identity_path.open("w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["ordinal", "source_local", "target_local", "channel"])
        for ordinal, edge in enumerate(expected):
            writer.writerow([ordinal, *edge])

    summary = {
        "status": "OFFLINE_DATA_IDENTITY_PASS_LEAN_THEOREM_OPEN"
        if sequence_match
        else "OFFLINE_DATA_IDENTITY_FAIL",
        "m0a_split_edges": len(split_edges),
        "selected_core_states": len(local),
        "filtered_internal_edges": len(expected),
        "generated_lean_edges": len(generated),
        "sequence_match": sequence_match,
        "expected_channel_counts": dict(sorted(counts_expected.items())),
        "generated_channel_counts": dict(sorted(counts_generated.items())),
        "state_ids_sha256": sha256(state_ids_path),
        "edge_identity_sha256": sha256(edge_identity_path),
        "lean_obligation": (
            "formalize the finite filter/remap equality and the transposed "
            "left-certificate orientation before using the Real operator"
        ),
    }
    (OUT / "summary_v1.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(json.dumps(summary, indent=2))
    if not sequence_match:
        raise SystemExit("CORE OPERATOR DATA IDENTITY FAILED")


if __name__ == "__main__":
    main()
