#!/usr/bin/env python3
"""Generate the finite rule-to-state semantic inventory for F3 split edges."""

from __future__ import annotations

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
RESULT = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = ROOT / "CollatzClassical/KL2003/F3ReturnExcursionFrozenSemanticInventory.lean"
SUMMARY = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_SEMANTIC_INVENTORY_SUMMARY_v1.json"

D = 5
MODULUS = 3**D


def parity(n: int) -> int:
    return 0 if n % 2 else 1


def bucket(n: int) -> int:
    if n % 2:
        return 0
    return 2 if n % 4 == 0 else 1


def state_id(n: int) -> int:
    return (n % MODULUS) * 3 + bucket(n)


def parse_state(label: str) -> tuple[int, int, int]:
    parts = label.split(":")
    residue = int(parts[1][1:])
    parity_code = 0 if parts[2] == "podd" else 1
    b = int(parts[3][1:])
    return residue, parity_code, b


def representative(label: str, lift: int) -> int:
    residue, parity_code, b = parse_state(label)
    n = residue + lift * MODULUS
    step = 3 * MODULUS
    while n <= 0 or parity(n) != parity_code or bucket(n) != b:
        n += step
    return n


def main() -> None:
    with (RESULT / "split_edges.csv").open(newline="") as handle:
        rows = list(csv.DictReader(handle))
    if len(rows) != 1215:
        raise SystemExit(f"expected 1215 rows, got {len(rows)}")
    frozen_keys = {
        (int(row["source_id"]), int(row["target_id"]), row["channel"])
        for row in rows
    }
    if len(frozen_keys) != len(rows):
        raise SystemExit("frozen split-edge rows are not unique")
    entries = []
    for row in rows:
        source_id = int(row["source_id"])
        target_id = int(row["target_id"])
        channel = row["channel"]
        lift = 0 if row["deep_lift"] == "" else int(row["deep_lift"])
        a = representative(row["source"], lift)
        if channel == "retarded":
            kind = 0
            c = 0
            if source_id != state_id(a) or target_id != state_id(4 * a):
                raise SystemExit(f"retarded state mismatch at row {row['source_id']}")
        elif channel == "advanced_direct_c2":
            kind = 1
            c = (2 * a - 1) // 3
            if not (3 * c + 1 == 2 * a and c % 3 == 2):
                raise SystemExit(f"direct arithmetic mismatch at row {row['source_id']}")
            if source_id != state_id(a) or target_id != state_id(c):
                raise SystemExit(f"direct state mismatch at row {row['source_id']}")
        elif channel == "advanced_parity_lift_c1":
            kind = 2
            c = (2 * a - 1) // 3
            if not (3 * c + 1 == 2 * a and c % 3 == 1):
                raise SystemExit(f"lift arithmetic mismatch at row {row['source_id']}")
            if source_id != state_id(a) or target_id != state_id(2 * c):
                raise SystemExit(f"lift state mismatch at row {row['source_id']}")
        else:
            raise SystemExit(f"unexpected channel in frozen edge file: {channel}")
        entries.append((source_id, target_id, kind, a, c))

    source = """import Mathlib

import CollatzClassical.KL2003.F3ReturnExcursionM0ACertificate
import CollatzClassical.KL2003.F3ReturnExcursionSemanticBridge

/-!
Generated finite semantic inventory for the frozen F3 split-edge rows.

The Python generator checks the same arithmetic and state-ID equations before
emitting this table.  Lean rechecks every row with finite boolean predicates.
The table is a bridge inventory, not a density theorem or rho certificate.
-/

namespace CollatzClassical
namespace KL2003
namespace F3SemanticInventory

open F3ReturnExcursionM0A
open F3SemanticBridge

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

inductive SemanticKind where
  | retarded
  | advancedDirect
  | parityLift
  deriving DecidableEq, Repr

structure SemanticEdge where
  edge : SplitEdge
  kind : SemanticKind
  a : Nat
  c : Nat
  deriving DecidableEq, Repr

def semanticEdges : List SemanticEdge :=
  [
"""
    def lit(entry: tuple[int, int, int, int, int]) -> str:
        source_id, target_id, kind, a, c = entry
        kind_name = ["retarded", "advancedDirect", "parityLift"][kind]
        return f"    {{ edge := {{ source := {source_id}, target := {target_id}, channel := {kind} }}, kind := .{kind_name}, a := {a}, c := {c} }}"
    source += ",\n".join(lit(entry) for entry in entries)
    semantic_keys = {
        (source_id, target_id,
         ["retarded", "advanced_direct_c2", "advanced_parity_lift_c1"][kind])
        for source_id, target_id, kind, _a, _c in entries
    }
    if semantic_keys != frozen_keys:
        raise SystemExit("semantic inventory does not cover frozen split-edge keys exactly")
    source += """
  ]

def stateIdOfNumber (n : Nat) : Nat :=
  (n % 243) * 3 + if n % 2 = 1 then 0 else if n % 4 = 0 then 2 else 1

def targetNumber : SemanticEdge → Nat
  | { kind := .retarded, a := a, .. } => 4 * a
  | { kind := .advancedDirect, c := c, .. } => c
  | { kind := .parityLift, c := c, .. } => 2 * c

def semanticEdgeValid (e : SemanticEdge) : Bool :=
  e.edge.source < 729 && e.edge.target < 729 &&
  e.edge.source = stateIdOfNumber e.a &&
  e.edge.target = stateIdOfNumber (targetNumber e) &&
  match e.kind with
  | .retarded => e.edge.channel = 0
  | .advancedDirect =>
      e.edge.channel = 1 && 3 * e.c + 1 = 2 * e.a && e.c % 3 = 2
  | .parityLift =>
      e.edge.channel = 2 && 3 * e.c + 1 = 2 * e.a && e.c % 3 = 1

def semanticEdgesFrozen (e : SemanticEdge) : Bool := e.edge ∈ splitEdges

theorem semantic_edge_count : semanticEdges.length = 1215 := by
  native_decide

theorem semantic_edges_valid :
    semanticEdges.all semanticEdgeValid = true := by
  native_decide

theorem semantic_edges_are_frozen :
    semanticEdges.all semanticEdgesFrozen = true := by
  native_decide

theorem semantic_rule_piStar
    (kind : SemanticKind) (a c x xChild n : Nat) :
    match kind with
    | .retarded =>
        xChild ≤ x → n ∈ piStarFinset (4 * a) xChild →
          n ∈ piStarFinset a x
    | .advancedDirect =>
        T c = a → a ≤ x → xChild ≤ x →
          n ∈ piStarFinset c xChild → n ∈ piStarFinset a x
    | .parityLift =>
        T c = a → a ≤ x → xChild ≤ x →
          n ∈ piStarFinset (2 * c) xChild → n ∈ piStarFinset a x := by
  cases kind with
  | retarded =>
      intro hx hmem
      exact two_branch_retarded_injection
        (a := a) (x := x) (xRet := xChild) (n := n) hx hmem
  | advancedDirect =>
      intro hc hax hx hmem
      exact two_branch_advanced_injection
        (a := a) (c := c) (x := x) (xAdv := xChild) (n := n)
        hc hax hx hmem
  | parityLift =>
      intro hc hax hx hmem
      exact two_branch_parity_lift_injection
        (a := a) (c := c) (x := x) (xLift := xChild) (n := n)
        hc hax hx hmem

end F3SemanticInventory
end KL2003
end CollatzClassical
"""
    OUT.write_text(source)
    SUMMARY.write_text(
        "{\n  \"rows\": %d,\n  \"retarded\": %d,\n  \"advanced_direct\": %d,\n  \"parity_lift\": %d,\n  \"python_state_and_rule_checks\": \"PASS\",\n  \"python_bidirectional_edge_coverage\": \"PASS\",\n  \"coverage_status\": \"FINITE_INVENTORY_READY_FOR_LEAN\",\n  \"non_claims\": [\"NO_RHO_CERTIFICATE\", \"NO_DENSITY_THEOREM\", \"NO_GLOBAL_COLLATZ_CLAIM\"]\n}\n" % (len(entries), sum(e[2] == 0 for e in entries), sum(e[2] == 1 for e in entries), sum(e[2] == 2 for e in entries))
    )


if __name__ == "__main__":
    main()
