#!/usr/bin/env python3
"""Generate the exact finite core-state matrix representation for Lean."""

from __future__ import annotations

import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
RESULT = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
OUT = ROOT / "CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.lean"
SUMMARY = ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_EXACT_CORE_MATRIX_SUMMARY_v1.json"


def main() -> None:
    with (RESULT / "frozen_w_split_core.csv").open(newline="") as handle:
        weights = list(csv.DictReader(handle))
    with (RESULT / "split_edges.csv").open(newline="") as handle:
        edges = list(csv.DictReader(handle))
    local = {int(row["state_id"]): int(row["core_local_id"]) for row in weights}
    core_edges = []
    for row in edges:
        source = int(row["source_id"])
        target = int(row["target_id"])
        if source in local and target in local:
            channel = {
                "retarded": 0,
                "advanced_direct_c2": 1,
                "advanced_parity_lift_c1": 2,
            }.get(row["channel"])
            if channel is None:
                raise SystemExit(f"unexpected core channel {row['channel']}")
            core_edges.append((local[source], local[target], channel))
    if len(weights) != 243 or len(core_edges) != 729:
        raise SystemExit(f"expected 243 weights/729 edges, got {len(weights)}/{len(core_edges)}")
    source = """import Mathlib

set_option maxRecDepth 100000

/-!
Exact finite representation of the frozen 243-state F3 core in `Real`.

The matrix entries use exact channel expressions with `Real.rpow`; no decimal
float is promoted to an equality.  The member-wise inequality is deliberately
left as a separate certificate obligation.
-/

noncomputable section
open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3ExactCoreMatrix

structure CoreEdge where
  source : Fin 243
  target : Fin 243
  channel : Nat
  deriving DecidableEq, Repr

def coreEdges : List CoreEdge :=
  [
"""
    source += ",\n".join(
        f"    {{ source := ⟨{s}, by decide⟩, target := ⟨{t}, by decide⟩, channel := {c} }}"
        for s, t, c in core_edges
    )
    source += """
  ]

def integerWeights : Vector Nat 243 :=
  ⟨#[
"""
    source += ",\n".join(f"    {int(row['integer_weight_over_D'])}" for row in weights)
    source += """
  ], by decide⟩

def rhoStar : ℝ := 9 / 5

def alpha : ℝ := Real.log 3 / Real.log 2

def channelWeight : Nat → ℝ
  | 0 => Real.rpow rhoStar (-2)
  | 1 => Real.rpow rhoStar (alpha - 1) / 3
  | 2 => Real.rpow rhoStar (alpha - 2) / 3
  | _ => 0

def coreMatrix (s t : Fin 243) : ℝ :=
  (coreEdges.filter (fun e => e.source = s ∧ e.target = t)).foldr
    (fun e acc => channelWeight e.channel + acc) 0

def frozenWeight (s : Fin 243) : ℝ :=
  (integerWeights.get s : ℝ) / 1000000

theorem core_edge_count : coreEdges.length = 729 := by
  native_decide

theorem frozen_weight_count : integerWeights.toList.length = 243 := by
  native_decide

theorem core_edges_have_valid_channels :
    coreEdges.all (fun e => e.channel < 3) = true := by
  native_decide

theorem channelWeight_nonneg (c : Nat) : 0 ≤ channelWeight c := by
  cases c with
  | zero =>
      dsimp [channelWeight]
      exact Real.rpow_nonneg (by norm_num [rhoStar]) _
  | succ c =>
      cases c with
      | zero =>
          dsimp [channelWeight]
          exact div_nonneg (Real.rpow_nonneg (by norm_num [rhoStar]) _) (by norm_num)
      | succ c =>
          cases c with
          | zero =>
              dsimp [channelWeight]
              exact div_nonneg (Real.rpow_nonneg (by norm_num [rhoStar]) _) (by norm_num)
          | succ c => simp [channelWeight]

theorem coreMatrix_nonneg (s t : Fin 243) : 0 ≤ coreMatrix s t := by
  have list_nonneg : ∀ xs : List CoreEdge,
      0 ≤ xs.foldr (fun e acc => channelWeight e.channel + acc) 0 := by
    intro xs
    induction xs with
    | nil => simp
    | cons e es ih =>
        simp only [List.foldr]
        exact add_nonneg (channelWeight_nonneg e.channel) ih
  simpa [coreMatrix] using
    list_nonneg (coreEdges.filter (fun e => e.source = s ∧ e.target = t))

theorem frozenWeight_nonneg (s : Fin 243) : 0 ≤ frozenWeight s := by
  unfold frozenWeight
  exact div_nonneg (by positivity) (by norm_num)

def rowCertificate : Prop :=
  ∀ s : Fin 243, (101 / 100 : ℝ) * frozenWeight s ≤
    ∑ t : Fin 243, coreMatrix s t * frozenWeight t

theorem rowCertificate_is_explicit_obligation :
    rowCertificate ↔
      ∀ s : Fin 243, (101 / 100 : ℝ) * frozenWeight s ≤
        ∑ t : Fin 243, coreMatrix s t * frozenWeight t := by
  rfl

end F3ExactCoreMatrix
end KL2003
end CollatzClassical
"""
    OUT.write_text(source)
    SUMMARY.write_text(
        json.dumps(
            {
                "core_states": len(weights),
                "core_edges": len(core_edges),
                "channels": {"retarded": 243, "advanced_direct_c2": 243, "advanced_parity_lift_c1": 243},
                "rho_star": "9/5",
                "alpha": "log(3)/log(2)",
                "decimal_promotion": False,
                "row_certificate_status": "EXPLICIT_OBLIGATION_NOT_CLAIMED",
                "non_claims": ["NO_RHO_CERTIFICATE", "NO_DENSITY_THEOREM", "NO_GLOBAL_COLLATZ_CLAIM"],
            },
            indent=2,
        )
        + "\n"
    )


if __name__ == "__main__":
    main()
