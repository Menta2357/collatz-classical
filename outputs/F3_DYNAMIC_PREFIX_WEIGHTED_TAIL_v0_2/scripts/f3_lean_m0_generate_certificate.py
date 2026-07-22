#!/usr/bin/env python3
"""Generate the frozen F3 M0-a data/checker source from custody CSVs.

The generated Lean file is deliberately a finite certificate checker.  It
does not define a density theorem, a rho certificate, or the renewal
conversion.  Inputs are read from the frozen split-edge result only.
"""

from __future__ import annotations

import csv
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
RESULT = (
    ROOT
    / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results"
    / "F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
)
OUT = ROOT / "CollatzClassical/KL2003/F3ReturnExcursionM0ACertificate.lean"
SUMMARY = (
    ROOT
    / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2"
    / "F3_LEAN_M0A_GENERATION_SUMMARY_v1.json"
)


def nat(value: str) -> str:
    return str(int(value))


def read_rows() -> tuple[list[dict[str, str]], list[dict[str, str]], dict]:
    with (RESULT / "tilted_supersolution_v1.csv").open(newline="") as handle:
        supers = list(csv.DictReader(handle))
    with (RESULT / "split_edges.csv").open(newline="") as handle:
        edges = list(csv.DictReader(handle))
    with (RESULT / "summary.json").open() as handle:
        summary = json.load(handle)
    return supers, edges, summary


def lean_supers(row: dict[str, str]) -> str:
    return (
        "{ coreLocalId := %s, stateId := %s, vInteger := %s, "
        "vDenominator := %s, lhsNum := %s, lhsDen := %s, "
        "rhsNum := %s, rhsDen := %s }"
        % (
            nat(row["core_local_id"]),
            nat(row["state_id"]),
            nat(row["v_integer"]),
            nat(row["v_denominator"]),
            nat(row["lhs_num"]),
            nat(row["lhs_den"]),
            nat(row["rhs_num"]),
            nat(row["rhs_den"]),
        )
    )


def lean_edge(row: dict[str, str]) -> str:
    channel = {
        "retarded": 0,
        "advanced_direct_c2": 1,
        "advanced_parity_lift_c1": 2,
        "advanced_sterile_tail_c0": 3,
    }[row["channel"]]
    return "{ source := %s, target := %s, channel := %s }" % (
        nat(row["source_id"]),
        nat(row["target_id"]),
        channel,
    )


def main() -> None:
    supers, edges, summary = read_rows()
    if len(supers) != 243:
        raise SystemExit(f"expected 243 supersolution rows, got {len(supers)}")
    if len(edges) != 1215:
        raise SystemExit(f"expected 1215 split edges, got {len(edges)}")
    source = """import Mathlib.Data.List.Basic
import Mathlib.Tactic.NormNum

set_option maxRecDepth 100000

/-!
F3 M0-a finite certificate checker, generated from frozen custody data.

This is data + exact finite verification only.  It deliberately does not
formalize the renewal conversion and does not claim a rho certificate,
density theorem, almost-all result, or global Collatz result.
-/

namespace CollatzClassical
namespace KL2003
namespace F3ReturnExcursionM0A

structure SupersolutionRow where
  coreLocalId : Nat
  stateId : Nat
  vInteger : Nat
  vDenominator : Nat
  lhsNum : Nat
  lhsDen : Nat
  rhsNum : Nat
  rhsDen : Nat
  deriving DecidableEq, Repr

structure SplitEdge where
  source : Nat
  target : Nat
  channel : Nat
  deriving DecidableEq, Repr

def supersolutionRows : List SupersolutionRow :=
  [
"""
    source += ",\n".join(f"    {lean_supers(row)}" for row in supers)
    source += """
  ]

def splitEdges : List SplitEdge :=
  [
"""
    source += ",\n".join(f"    {lean_edge(row)}" for row in edges)
    source += """
  ]

def supersolutionPass (r : SupersolutionRow) : Bool :=
  decide (r.lhsNum * r.rhsDen ≤ r.rhsNum * r.lhsDen)

def positiveVectorRow (r : SupersolutionRow) : Bool :=
  decide (0 < r.vInteger ∧ 0 < r.vDenominator)

def validEdge (e : SplitEdge) : Bool :=
  decide (e.source < 729 ∧ e.target < 729 ∧ e.channel < 4)

def nBlock : Nat := 3 ^ 5

def frozenVectorSha256 : String :=
  "55b2288824dccfe56fcb3a951bdfb47583ac7d4abd00576ed7c273448b2a777a"

def frozenWeightSha256 : String :=
  "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40"

theorem nBlock_eq_243 : nBlock = 243 := by
  norm_num [nBlock]

theorem supersolution_row_count : supersolutionRows.length = 243 := by
  decide

def supersolutionRowsPositive : Bool :=
  supersolutionRows.all positiveVectorRow

theorem supersolution_rows_positive : supersolutionRowsPositive = true := by
  decide

def supersolutionRowsPass : Bool :=
  supersolutionRows.all supersolutionPass

theorem supersolution_rows_pass : supersolutionRowsPass = true := by
  decide

theorem split_edge_count : splitEdges.length = 1215 := by
  decide

def splitEdgesValid : Bool :=
  splitEdges.all validEdge

theorem split_edges_valid : splitEdgesValid = true := by
  decide

def channelCount (channel : Nat) : Nat :=
  (splitEdges.filter (fun e => e.channel = channel)).length

theorem channel_count_retarded : channelCount 0 = 729 := by
  decide

theorem channel_count_advanced_direct : channelCount 1 = 243 := by
  decide

theorem channel_count_advanced_lift : channelCount 2 = 243 := by
  decide

theorem channel_count_sterile_tail : channelCount 3 = 0 := by
  decide

theorem channel_count_total :
    channelCount 0 + channelCount 1 + channelCount 2 + channelCount 3 = 1215 := by
  decide

theorem frozen_vector_hash_is_recorded :
    frozenVectorSha256 =
      "55b2288824dccfe56fcb3a951bdfb47583ac7d4abd00576ed7c273448b2a777a" := by
  rfl

theorem frozen_weight_hash_is_recorded :
    frozenWeightSha256 =
      "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40" := by
  rfl

end F3ReturnExcursionM0A
end KL2003
end CollatzClassical
"""
    OUT.write_text(source)
    SUMMARY.write_text(
        json.dumps(
            {
                "generator": str(Path(__file__).relative_to(ROOT)),
                "source": str(OUT.relative_to(ROOT)),
                "supersolution_rows": len(supers),
                "split_edges": len(edges),
                "expected_channel_counts": {
                    "retarded": 729,
                    "advanced_direct_c2": 243,
                    "advanced_parity_lift_c1": 243,
                    "advanced_sterile_tail_c0": 0,
                },
                "n_block": 243,
                "frozen_vector_sha256": "55b2288824dccfe56fcb3a951bdfb47583ac7d4abd00576ed7c273448b2a777a",
                "frozen_weight_sha256": "580e7abd8740342e52b3712aea5aaf9e2affc50888e5535e4c3bd697ed5dbb40",
                "source_summary_edge_count": summary["edge_count"],
                "non_claims": [
                    "NO_RHO_CERTIFICATE",
                    "NO_DENSITY_THEOREM",
                    "NO_ALMOST_ALL",
                    "NO_GLOBAL_COLLATZ_CLAIM",
                    "NO_RENEWAL_CONVERSION",
                ],
            },
            indent=2,
        )
        + "\n"
    )


if __name__ == "__main__":
    main()
