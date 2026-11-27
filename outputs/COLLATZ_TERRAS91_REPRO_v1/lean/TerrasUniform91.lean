import Terras91ClockClosure
import Terras91Physical
import TerrasUniformFirstDescent

namespace TerrasUniform91

open TerrasClock
open Terras88 (verifiedHeight)

/-- External statements from the uniform 90-run proof, and the delay
coverage used to price the 91-run Q0 window. -/
structure Inputs : Prop where
  base : Terras90SourceBridge.Inputs
  delay : Terras91Delay.OrdinaryDelay2480

private theorem q0Inputs (input : Inputs) : Terras91Q0.Inputs :=
  ⟨input.delay,input.base.weaver,input.base.hercher,input.base.sevenRuns,
    input.base.fiveRuns,input.base.guardedH146⟩

/-- At exactly 91 actual odd runs, the first coefficient crossing is the
first descent below the original seed, with its exact additive history. -/
theorem firstDescentAtExactly91 {N k : Nat} (input : Inputs)
    (seed : 2≤N) (first : FirstContraction N k) (runs : oddRuns N k=91) :
    orbit N k<N ∧ (∀ j<k, N≤orbit N j) ∧
      2^k*orbit N k=3^(oddCount N k)*N+additive N k := by
  refine ⟨?_,fun _ h => prior_no_descent first h,exact_book N k⟩
  by_cases small : N≤verifiedHeight
  · exact input.base.finiteRange N k seed small first
  have large : verifiedHeight<N := by omega
  have noCycle := Terras90Hercher.noEqualOfAtMost91 input.base.hercher
    (Nat.lt_trans (by decide) large) first (Nat.le_of_eq runs)
  by_contra failure
  have shift : N+1≤orbit N k := by omega
  have listed := Terras91Physical.clocksFromPhysical
    (Terras90SourceBridge.rhinBoundOfPrinted input.base.linearForms) large first runs shift
  exact Terras91ClockClosure.excludesListedPositiveShift (q0Inputs input)
    large seed first runs shift listed

/-- Discharge the 87–91 range, consuming only Weaver's term through 86
and the displayed source premises. Existence of the crossing is assumed. -/
theorem firstDescentAtMost91FromWeaver {N k : Nat} (input : Inputs)
    (weaver86 : TerrasUniformFirstDescent.Weaver86) (seed : 2≤N)
    (first : FirstContraction N k) (runs : oddRuns N k≤91) :
    orbit N k<N ∧ (∀ j<k, N≤orbit N j) ∧
      2^k*orbit N k=3^(oddCount N k)*N+additive N k := by
  by_cases old : oddRuns N k≤90
  · exact TerrasUniformFirstDescent.firstDescentAtMost90FromWeaver input.base weaver86 seed first old
  exact firstDescentAtExactly91 input seed first (by omega)

end TerrasUniform91

#print axioms TerrasUniform91.firstDescentAtExactly91
#print axioms TerrasUniform91.firstDescentAtMost91FromWeaver
