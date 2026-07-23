#!/usr/bin/env python3
"""Generate nine Lean filter/remap identity shards for the frozen core.

Each shard keeps the source-local block small while retaining the original
M0-a `splitEdges` and `supersolutionRows` definitions.  The theorem in each
generated file is a finite `native_decide` equality; it is not generated from
the observed result and does not claim a renewal or density theorem.
"""

from __future__ import annotations

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
SHARDS = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_OPERATOR_DATA_RECONCILIATION_v1/shards"
OUT = ROOT / "CollatzClassical/KL2003"
BLOCKS = 9
BLOCK_SIZE = 27


def read_block(block: int) -> list[tuple[int, int, int]]:
    path = SHARDS / f"core_edges_block_{block:02d}.csv"
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    return [(int(r["source_local"]), int(r["target_local"]), int(r["channel"])) for r in rows]


def render(block: int, edges: list[tuple[int, int, int]]) -> str:
    lo = block * BLOCK_SIZE
    hi = lo + BLOCK_SIZE
    expected = ",\n".join(
        f"    {{ source := ⟨{s}, by decide⟩, target := ⟨{t}, by decide⟩, channel := {c} }}"
        for s, t, c in edges
    )
    return f'''import CollatzClassical.KL2003.F3ReturnExcursionM0ACertificate
import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrix

set_option maxRecDepth 100000

namespace CollatzClassical
namespace KL2003
namespace F3CoreIdentityShard{block:02d}

open F3ReturnExcursionM0A
open F3ExactCoreMatrix

def stateToLocalNat (state : Nat) : Option Nat :=
  supersolutionRows.find? (fun row => row.stateId = state) |>.map (fun row => row.coreLocalId)

def mapCoreEdge (e : SplitEdge) : Option CoreEdge :=
  match stateToLocalNat e.source, stateToLocalNat e.target with
  | some s, some t =>
      if hs : s < 243 then
        if ht : t < 243 then
          some {{ source := ⟨s, hs⟩, target := ⟨t, ht⟩, channel := e.channel }}
        else none
      else none
  | _, _ => none

def blockEdges : List CoreEdge :=
  (splitEdges.filter (fun e =>
    match stateToLocalNat e.source with
    | some s => {lo} ≤ s ∧ s < {hi}
    | none => False)).filterMap mapCoreEdge

def expectedBlock : List CoreEdge :=
  [
{expected}
  ]

theorem block_identity : blockEdges = expectedBlock := by
  native_decide

theorem block_edge_count : blockEdges.length = {len(edges)} := by
  rw [block_identity]
  native_decide

end F3CoreIdentityShard{block:02d}
end KL2003
end CollatzClassical
'''


def main() -> None:
    for block in range(BLOCKS):
        edges = read_block(block)
        if len(edges) != 81:
            raise SystemExit(f"block {block} has {len(edges)} edges, expected 81")
        path = OUT / f"F3ReturnExcursionCoreIdentityShard{block:02d}.lean"
        path.write_text(render(block, edges), encoding="utf-8")
        print(path)


if __name__ == "__main__":
    main()
