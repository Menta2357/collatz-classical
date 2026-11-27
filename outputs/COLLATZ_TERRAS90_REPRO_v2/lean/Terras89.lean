import Terras88

namespace Terras89

open TerrasClock
open Terras88 (Inputs HasWindow RankCut physical_window verifiedHeight q0Clock q0Price)

/-- Universal five-run upper bound on physical prefixes from small odd starts.
A completed five-run bound implies this prefix bound, including a truncated
last run. -/
def FiveRunBound (height bound : Nat) : Prop :=
  ∀ x k, 0<x → x%2=1 → x<2^height → oddRuns x k=5 → oddCount x k≤bound

/-- The capacity needed by the ranked-path reduction of Q0. -/
def FiveRunCapacity (height : Nat) : Prop :=
  ∀ x k, 0<x → x%2=1 → x+1<2^height → oddRuns x k=5 → 2^(oddCount x k)≤6^height

theorem capacities_of_universal_bound (external : FiveRunBound 193 217) :
    FiveRunCapacity 92 ∧ FiveRunCapacity 146 := by
  have transfer {H : Nat} (window : H≤193) (size : 2^217≤6^H) :
      FiveRunCapacity H := by
    intro x k pos odd small runs
    have hpower : (2:Nat)^H≤2^193 := Nat.pow_le_pow_right (by decide) window
    have hx : x<2^193 := by omega
    have upper := external x k pos odd hx runs
    exact Nat.le_trans (Nat.pow_le_pow_right (by decide) upper) size
  exact ⟨transfer (by decide) (by decide),transfer (by decide) (by decide)⟩

/-- The only surviving endpoint in the independent seven-clock reduction. -/
structure DeltaOneQ0 (N k : Nat) : Prop where
  base : verifiedHeight<N
  first : FirstContraction N k
  runs : oddRuns N k=89
  clock : (k,oddCount N k)=q0Clock
  delta : orbit N k=N+1

/-- The exact reduction and the rank calculation from the paper remain
separate from the universal five-run computation. -/
structure Inputs89 : Prop where
  reducedToQ0 : ∀ N k, 2≤N → FirstContraction N k → oddRuns N k=89 →
    N≤orbit N k → DeltaOneQ0 N k
  q0Ranks : FiveRunCapacity 92 → FiveRunCapacity 146 → ∀ N k,
    DeltaOneQ0 N k → Nonempty (RankCut N k q0Price (2^146-1) 5)

theorem first_descent89_from_capacities (previous : Inputs) (c : Inputs89)
    (cap92 : FiveRunCapacity 92) (cap146 : FiveRunCapacity 146) {N k : Nat}
    (big : 2≤N) (first : FirstContraction N k) (runs : oddRuns N k≤89) :
    orbit N k<N ∧ ∀ j, j<k → N≤orbit N j := by
  refine ⟨?_,fun _ earlier => prior_no_descent first earlier⟩
  by_cases smaller : oddRuns N k≤88
  · exact Terras88.descent88 previous big first smaller
  · have exact89 : oddRuns N k=89 := by omega
    by_cases h : orbit N k<N
    · exact h
    · have above : N≤orbit N k := by omega
      have caseQ0 := c.reducedToQ0 N k big first exact89 above
      obtain ⟨cut⟩ := c.q0Ranks cap92 cap146 N k caseQ0
      exact (previous.noWeaverQ0 N k
        (physical_window caseQ0.base first (by decide) cut)).elim

theorem first_descent89 (previous : Inputs) (c : Inputs89)
    (external : FiveRunBound 193 217) {N k : Nat}
    (big : 2≤N) (first : FirstContraction N k) (runs : oddRuns N k≤89) :
    orbit N k<N ∧ ∀ j, j<k → N≤orbit N j := by
  obtain ⟨cap92,cap146⟩ := capacities_of_universal_bound external
  exact first_descent89_from_capacities previous c cap92 cap146 big first runs

private theorem oddRuns_mono (x : Nat) {p q : Nat} (budget : p≤q) :
    oddRuns x p≤oddRuns x q := by
  induction q with
  | zero =>
    have e : p=0 := by omega
    subst p
    exact Nat.le_refl _
  | succ q ih =>
    by_cases h : p≤q
    · exact Nat.le_trans (ih h) (Nat.le_add_right _ _)
    · have e : p=q+1 := by omega
      rw [e]
      exact Nat.le_refl _

private theorem find_first (x k : Nat) (strict : 3^(oddCount x k)<2^k) :
    ∃ i, i≤k ∧ FirstContraction x i := by
  induction k using Nat.strongRecOn with
  | ind k ih =>
    by_cases old : ∃ j, j<k ∧ 3^(oddCount x j)<2^j
    · obtain ⟨j,early,h⟩ := old
      obtain ⟨i,atMost,first⟩ := ih j early h
      exact ⟨i,by omega,first⟩
    · exact ⟨k,Nat.le_refl _,strict,fun j hj =>
        Nat.le_of_not_gt (fun h => old ⟨j,hj,h⟩)⟩

/-- Reuse Terras 88 at a physical suffix whose first descent is known.
The prefix continues to use the original N and the shortcut clock p+q. -/
theorem suffix_crossing_at_descent (previous : Inputs) {N p q : Nat}
    (big : 2≤orbit N p)
    (descends : orbit N (p+q)<orbit N p)
    (prior : ∀ j, j<q → orbit N p≤orbit N (p+j))
    (runs : oddRuns (orbit N p) q≤88) :
    FirstContraction (orbit N p) q := by
  let M := orbit N p
  have descent : orbit M q<M := by simpa only [M,orbit_add] using descends
  have strict : 3^(oddCount M q)<2^q := by
    by_cases h : 3^(oddCount M q)<2^q
    · exact h
    · exact ((Nat.not_le_of_gt descent) (no_descent_of_coefficient (Nat.le_of_not_gt h))).elim
  obtain ⟨i,bounded,first⟩ := find_first M q strict
  have notEarly : ¬i<q := by
    intro early
    have reached := Terras88.descent88 previous big first
      (Nat.le_trans (oddRuns_mono M bounded) runs)
    have before := prior i early
    rw [orbit_add] at before
    exact (Nat.not_le_of_gt reached) before
  have eq : i=q := by omega
  rw [eq] at first
  exact first

end Terras89
