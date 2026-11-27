import Terras90Hercher
import Terras90PublishedCapacity
import Terras90WeaverEvidence

namespace Terras90SourceBridge

open TerrasClock
open Terras88 (verifiedHeight)
open Terras90Physical (gap RhinBound)
open Terras90PublishedCapacity (CompletedRunBound GuardedH146Replay sixRunCapacities)
open Terras90WeaverEvidence (ReachesHighValley noWindow)

/-- Rhin's printed estimate uses the maximum absolute integer coefficient
of the two logarithms, including an arbitrary integer constant term. -/
def PrintedRhin : Prop :=
  ∀ u₀ u₁ u₂ : ℤ, let H := max u₁.natAbs u₂.natAbs
    2 ≤ H → (H : ℝ)^(-(133/10 : ℝ)) ≤
      |(u₀ : ℝ) + (u₁ : ℝ)*Real.log 2 + (u₂ : ℝ)*Real.log 3|

theorem rhinBoundOfPrinted (external : PrintedRhin) : RhinBound := by
  intro k d large small positive
  have height : max (k : ℤ).natAbs (-(d : ℤ)).natAbs = k := by
    simpa using max_eq_left small
  have value : |((0 : ℤ) : ℝ) + ((k : ℤ) : ℝ)*Real.log 2 + (-(d : ℤ) : ℤ)*Real.log 3| =
      gap k d := by
    rw [← abs_of_pos positive]
    congr 1
    simp [gap, sub_eq_add_neg]
  have bound := external 0 (k : ℤ) (-(d : ℤ))
  dsimp only at bound
  rw [height, value] at bound
  exact bound large

/-- Rozier–Terracol's finite agreement, expressed at the first coefficient crossing. -/
def VerifiedFiniteRange : Prop :=
  ∀ N k, 2 ≤ N → N ≤ verifiedHeight → FirstContraction N k → orbit N k < N

/-- Source statements for the new, exactly-ninety branch. The earlier
rank and clock obligations are not needed for this branch. -/
structure Inputs : Prop where
  finiteRange : VerifiedFiniteRange
  linearForms : PrintedRhin
  hercher : Terras90Hercher.Hercher91
  weaver : ¬ ReachesHighValley Terras88.q0Price (2^146-1) 5
  sevenRuns : CompletedRunBound 7 100 156
  fiveRuns : CompletedRunBound 5 229 254
  guardedH146 : GuardedH146Replay

/-- Fractions and products concern this same `N,k`, including the original
additive correction. No older bounded-run theorem is consumed here. -/
theorem firstDescentAtExactly90 (inputs : Inputs) {N k : Nat} (seed : 2 ≤ N)
    (first : FirstContraction N k) (runs : oddRuns N k = 90) :
    orbit N k < N ∧ (∀ j < k, N ≤ orbit N j) ∧
      2^k*orbit N k = 3^(oddCount N k)*N + additive N k := by
  refine ⟨?_, fun _ h => prior_no_descent first h, exact_book N k⟩
  by_cases small : N ≤ verifiedHeight
  · exact inputs.finiteRange N k seed small first
  have large : verifiedHeight < N := Nat.lt_of_not_ge small
  obtain ⟨six92,six146⟩ := sixRunCapacities inputs.sevenRuns inputs.fiveRuns inputs.guardedH146
  have weak := Terras90Final.noPositiveShift90 (rhinBoundOfPrinted inputs.linearForms)
    large first runs six92 six146 (noWindow inputs.weaver N k)
  exact Nat.lt_of_le_of_ne weak (Terras90Hercher.noEqual90 inputs.hercher N k large first runs)

/-- The inherited branch is separate from the source-level proof at ninety. -/
def PreviousCoverage : Prop :=
  ∀ N k, 2 ≤ N → FirstContraction N k → oddRuns N k ≤ 89 → orbit N k < N

theorem firstDescentAtMost90 (inputs : Inputs) (older : PreviousCoverage)
    {N k : Nat} (seed : 2 ≤ N) (first : FirstContraction N k) (runs : oddRuns N k ≤ 90) :
    orbit N k < N ∧ (∀ j < k, N ≤ orbit N j) ∧
      2^k*orbit N k = 3^(oddCount N k)*N + additive N k := by
  by_cases previous : oddRuns N k ≤ 89
  · exact ⟨older N k seed first previous, fun _ h => prior_no_descent first h, exact_book N k⟩
  exact firstDescentAtExactly90 inputs seed first (by omega)

end Terras90SourceBridge

#print axioms Terras90SourceBridge.rhinBoundOfPrinted
#print axioms Terras90SourceBridge.firstDescentAtExactly90
#print axioms Terras90SourceBridge.firstDescentAtMost90
