import Terras91Q0Floors
import Terras91Q0Product
import Terras90WeaverEvidence
import Terras90PublishedCapacity
import TerrasCycleOfCrossing

namespace Terras91Q0

open TerrasClock
open Terras88 (q0Clock q0Price HasWindow)
open Terras90Q0Price (floor146)
open Terras90PublishedCapacity (CompletedRunBound GuardedH146Replay sixRunCapacities)

/-- The exact Q0 window excludes every positive displacement at 91 runs,
on the same seed, prefix and coefficient clock. -/
theorem excludesPositiveShift {N k : Nat} (record : Terras91Delay.OrdinaryDelay2480)
    (noWeaver : ¬HasWindow N k q0Price floor146 5)
    (six92 : Terras90.SixRunCapacity 92) (six146 : Terras90.SixRunCapacity 146)
    (seed : 2≤N) (first : FirstContraction N k) (runs : oddRuns N k=91)
    (clock : (k,oddCount N k)=q0Clock) (shift : N+1≤orbit N k) : False := by
  obtain ⟨h92,h146⟩ := Terras91Q0Floors.q0RankFloors first runs clock six92 six146
  exact noWeaver (Terras91Q0Product.windowOfPositiveShift record seed first runs clock shift h92 h146)

/-- Named numerical and published source statements for the 91-run Q0 case. -/
structure Inputs : Prop where
  delay : Terras91Delay.OrdinaryDelay2480
  weaver : ¬Terras90WeaverEvidence.ReachesHighValley q0Price floor146 5
  hercher : Terras90Hercher.Hercher91
  sevenRuns : CompletedRunBound 7 100 156
  fiveRuns : CompletedRunBound 5 229 254
  guardedH146 : GuardedH146Replay

theorem excludesDeltaOne {N k : Nat} (input : Inputs) (seed : 2≤N)
    (first : FirstContraction N k) (runs : oddRuns N k=91)
    (clock : (k,oddCount N k)=q0Clock) (shift : orbit N k=N+1) : False := by
  obtain ⟨h92,h146⟩ := sixRunCapacities input.sevenRuns input.fiveRuns input.guardedH146
  exact excludesPositiveShift input.delay (Terras90WeaverEvidence.noWindow input.weaver N k)
    h92 h146 seed first runs clock (by omega)

/-- When the first contraction has exactly 91 runs and clock Q0, it is
the first strict descent, with the original additive book unchanged. -/
theorem firstDescentAtQ0 {N k : Nat} (input : Inputs) (seed : 2≤N)
    (first : FirstContraction N k) (runs : oddRuns N k=91)
    (clock : (k,oddCount N k)=q0Clock) :
    orbit N k<N ∧ (∀ j<k, N≤orbit N j) ∧
      2^k*orbit N k=3^(oddCount N k)*N+additive N k := by
  refine ⟨?_,fun j hj => prior_no_descent first hj,exact_book N k⟩
  by_cases descent : orbit N k<N
  · exact descent
  have large := Terras91Delay.aboveRecordAtQ0 input.delay seed first clock
  have ne := Terras90Hercher.noEqualOfAtMost91 input.hercher
    (Nat.lt_trans (by decide) large) first (Nat.le_of_eq runs)
  obtain ⟨s92,s146⟩ := sixRunCapacities input.sevenRuns input.fiveRuns input.guardedH146
  exact (excludesPositiveShift input.delay (Terras90WeaverEvidence.noWindow input.weaver N k)
    s92 s146 seed first runs clock (by omega)).elim

end Terras91Q0

#print axioms Terras91Q0.excludesPositiveShift
#print axioms Terras91Q0.excludesDeltaOne
#print axioms Terras91Q0.firstDescentAtQ0
