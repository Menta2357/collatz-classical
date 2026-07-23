#!/usr/bin/env python3
"""Generate the V3 pair-table finite identity pilot."""

from __future__ import annotations

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
DATA = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_OPERATOR_DATA_RECONCILIATION_v1"
SPLIT = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/split_edges.csv"
OUT = ROOT / "CollatzClassical/KL2003"


def load_states() -> dict[int, int]:
    with (DATA / "core_state_ids.csv").open(newline="", encoding="utf-8") as handle:
        return {int(r["state_id"]): int(r["core_local_id"]) for r in csv.DictReader(handle)}


def load_edges() -> list[dict[str, int]]:
    with (DATA / "core_edge_identity.csv").open(newline="", encoding="utf-8") as handle:
        return [{k: int(v) for k, v in r.items()} for r in csv.DictReader(handle)]


def write_remap(states: dict[int, int]) -> None:
    pairs = ",\n".join(f"    ({state}, {local})" for state, local in sorted(states.items()))
    text = f'''import CollatzClassical.KL2003.F3ReturnExcursionM0ACertificate

namespace CollatzClassical
namespace KL2003
namespace F3CoreStateRemapV3

def stateToLocalPairs : List (Nat × Nat) :=
  [
{pairs}
  ]

def stateToLocalNat (state : Nat) : Option Nat :=
  stateToLocalPairs.find? (fun p => p.1 = state) |>.map Prod.snd

end F3CoreStateRemapV3
end KL2003
end CollatzClassical
'''
    (OUT / "F3ReturnExcursionCoreStateRemapV3.lean").write_text(text, encoding="utf-8")


def render(block: int, states: dict[int, int], edges: list[dict[str, int]]) -> str:
    lo, hi = block * 27, (block + 1) * 27
    selected = [e for e in edges if lo <= e["source_local"] < hi]
    global_by_local = {local: state for state, local in states.items()}
    raw = [(global_by_local[e["source_local"]], global_by_local[e["target_local"]], e["channel"]) for e in selected]
    source_states = sorted({s for s, _, _ in raw})
    source_text = ", ".join(str(s) for s in source_states)
    raw_text = ",\n".join(f"    {{ source := {s}, target := {t}, channel := {c} }}" for s, t, c in raw)
    expected_text = ",\n".join(
        f"    {{ source := ⟨{e['source_local']}, by decide⟩, target := ⟨{e['target_local']}, by decide⟩, channel := {e['channel']} }}"
        for e in selected
    )
    return f'''import CollatzClassical.KL2003.F3ReturnExcursionM0ACertificate
import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrix
import CollatzClassical.KL2003.F3ReturnExcursionCoreStateRemapV3

set_option maxRecDepth 100000

namespace CollatzClassical
namespace KL2003
namespace F3CoreIdentityShardV3{block:02d}

open F3ReturnExcursionM0A
open F3ExactCoreMatrix
open F3CoreStateRemapV3

def blockSourceStates : List Nat := [{source_text}]

def rawBlock : List SplitEdge :=
  splitEdges.filter (fun e => e.source ∈ blockSourceStates)

def expectedRawBlock : List SplitEdge :=
  [
{raw_text}
  ]

theorem raw_block_identity : rawBlock = expectedRawBlock := by
  native_decide

def remap (e : SplitEdge) : Option CoreEdge :=
  match stateToLocalNat e.source, stateToLocalNat e.target with
  | some s, some t =>
      if hs : s < 243 then
        if ht : t < 243 then
          some {{ source := ⟨s, hs⟩, target := ⟨t, ht⟩, channel := e.channel }}
        else none
      else none
  | _, _ => none

def remappedBlock : List CoreEdge := rawBlock.filterMap remap

def expectedBlock : List CoreEdge :=
  [
{expected_text}
  ]

theorem remapped_block_identity : remappedBlock = expectedBlock := by
  rw [raw_block_identity]
  native_decide

theorem remapped_block_count : remappedBlock.length = 81 := by
  rw [remapped_block_identity]
  native_decide

end F3CoreIdentityShardV3{block:02d}
end KL2003
end CollatzClassical
'''


def main() -> None:
    states = load_states()
    edges = load_edges()
    with SPLIT.open(newline="", encoding="utf-8") as handle:
        split_count = sum(1 for _ in csv.DictReader(handle))
    if len(states) != 243 or len(edges) != 729 or split_count != 1215:
        raise SystemExit("frozen input sizes do not match 243/729/1215")
    write_remap(states)
    (OUT / "F3ReturnExcursionCoreIdentityShardV300.lean").write_text(
        render(0, states, edges), encoding="utf-8"
    )
    print("generated V3 pair table and pilot shard 00")


if __name__ == "__main__":
    main()
