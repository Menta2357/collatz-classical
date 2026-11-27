import TerrasDisplacement

namespace Terras90Hercher

open TerrasClock
open Terras88 (valleyTimes valleyTimes_length verifiedHeight)

/-- The first positive return of the original shortcut orbit. -/
structure LeastReturn (N k : Nat) : Prop where
  periodPositive : 0<k
  returns : orbit N k=N
  noEarlier : ∀ i, 0<i → i<k → orbit N i≠N

/-- The orbit values in one least period occur only once. -/
theorem LeastReturn.indexInjective {N k : Nat} (period : LeastReturn N k)
    {i j : Nat} (insideI : i<k) (insideJ : j<k)
    (same : orbit N i=orbit N j) : i=j := by
  have distinctOrder : ∀ a b, a<b → b<k → orbit N a≠orbit N b := by
    intro a b order inside eq
    have right : b+(k-b)=k := by omega
    have early : orbit N (a+(k-b))=N := by
      rw [orbit_add,eq,←orbit_add,right,period.returns]
    exact period.noEarlier _ (by omega) (by omega) early
  rcases Nat.lt_trichotomy i j with before | equal | after
  · exact (distinctOrder i j before insideJ same).elim
  · exact equal
  · exact (distinctOrder j i after insideI same.symm).elim

def cyclicPredecessor (k i : Nat) : Nat := if i=0 then k-1 else i-1

def cyclicSuccessor (k i : Nat) : Nat := if i+1=k then 0 else i+1

abbrev IsCycleLocalMin (N k i : Nat) : Prop :=
  orbit N i<orbit N (cyclicPredecessor k i) ∧
    orbit N i<orbit N (cyclicSuccessor k i)

/-- The indices of the strict local minima of one closed period. -/
def cycleLocalMinima (N k : Nat) : List Nat :=
  (List.range k).filter (fun i => decide (IsCycleLocalMin N k i))

/-- External statement of Hercher's Theorem 23 with the 2026 corrigendum,
on the identical shortcut map. The hypothesis excludes the cycle through 1. -/
def Hercher91 : Prop :=
  ∀ N k, 2<N → LeastReturn N k → 92≤(cycleLocalMinima N k).length

private theorem step_ascends_iff_odd {x : Nat} (positive : 0<x) :
    x<shortcut x ↔ x%2=1 := by
  rcases Nat.mod_two_eq_zero_or_one x with even | odd
  · have step := shortcut_even even
    omega
  · have step := shortcut_odd odd
    omega

private theorem step_descends_iff_even {x : Nat} (positive : 0<x) :
    shortcut x<x ↔ x%2=0 := by
  rcases Nat.mod_two_eq_zero_or_one x with even | odd
  · have step := shortcut_even even
    omega
  · have step := shortcut_odd odd
    omega

private theorem cyclicSteps {N k i : Nat} (period : LeastReturn N k) (inside : i<k) :
    cyclicPredecessor k i<k ∧
      orbit N i=shortcut (orbit N (cyclicPredecessor k i)) ∧
      orbit N (cyclicSuccessor k i)=shortcut (orbit N i) := by
  have positive := period.periodPositive
  refine ⟨?_,?_,?_⟩
  · unfold cyclicPredecessor
    split <;> omega
  · by_cases zero : i=0
    · subst i
      simp only [cyclicPredecessor,if_true]
      rw [←orbit_succ,show k-1+1=k by omega,period.returns]
      rfl
    · simp only [cyclicPredecessor,if_neg zero]
      rw [←orbit_succ,show i-1+1=i by omega]
  · calc
      _ = orbit N (i+1) := by
        by_cases last : i+1=k
        · have nextReturn := (congrArg (orbit N) last).trans period.returns
          simpa only [cyclicSuccessor,if_pos last,orbit] using nextReturn.symm
        · simp [cyclicSuccessor,last]
      _ = _ := orbit_succ _ _

/-- At a cyclic boundary the final even source supplies the predecessor
condition for the start at index zero. At every other index this is the
ordinary even-to-odd transition. -/
theorem cycleLocalMinima_eq_valleyTimes {N k : Nat}
    (period : LeastReturn N k) (positive : ∀ i<k, 0<orbit N i)
    (finalEven : orbit N (k-1)%2=0) :
    cycleLocalMinima N k=valleyTimes N k := by
  unfold cycleLocalMinima valleyTimes
  apply List.filter_congr
  intro i mem
  have inside := List.mem_range.mp mem
  obtain ⟨prevIn,prev,next⟩ := cyclicSteps period inside
  have goesUp : orbit N i<orbit N (cyclicSuccessor k i) ↔ orbit N i%2=1 := by
    rw [next]
    exact step_ascends_iff_odd (positive i inside)
  have cameDown : orbit N i<orbit N (cyclicPredecessor k i) ↔
      orbit N (cyclicPredecessor k i)%2=0 := by
    rw [prev]
    exact step_descends_iff_even (positive _ prevIn)
  have matchStart : IsCycleLocalMin N k i ↔ startsOddRun N i=true := by
    unfold IsCycleLocalMin
    rw [goesUp,cameDown,startsOddRun_iff]
    by_cases zero : i=0
    · subst i
      simp [cyclicPredecessor,finalEven]
    · simp [cyclicPredecessor,zero,and_comm]
  cases start : startsOddRun N i
  · have absent : ¬IsCycleLocalMin N k i := by simp [matchStart,start]
    simp [absent]
  · exact decide_eq_true (matchStart.mpr start)

private theorem oddSeedOfReturn {N k : Nat} (positive : 0<N)
    (first : FirstContraction N k) (returned : orbit N k=N) : N%2=1 := by
  by_cases odd : N%2=1
  · exact odd
  have periodPositive := first_contraction_pos first
  have short : k≤1 := by
    by_cases short : k≤1
    · exact short
    have prior := first.2 1 (by omega)
    simp [oddCount,orbit,odd] at prior
  have one : k=1 := by omega
  rw [one] at returned
  change shortcut N=N at returned
  have evenStep := shortcut_even (show N%2=0 by omega)
  omega

/-- A return at the physical first contraction is a least period. Its
physical run count is precisely the number of cyclic strict minima. -/
theorem cycleOfFirstCrossingReturn {N k : Nat} (positive : 0<N)
    (first : FirstContraction N k) (returned : orbit N k=N) :
    LeastReturn N k ∧ N%2=1 ∧ orbit N (k-1)%2=0 ∧
      (cycleLocalMinima N k).length=oddRuns N k := by
  have prePositive := first_contraction_pos first
  have odd := oddSeedOfReturn positive first returned
  have period : LeastReturn N k := ⟨prePositive,returned,fun i pos earlier =>
    Nat.ne_of_gt (TerrasDisplacement.prior_strict odd first pos earlier)⟩
  have finalEven : orbit N (k-1)%2=0 := by
    apply first_contraction_last_even
    simpa only [Nat.sub_add_cancel (show 1≤k by omega)] using first
  have allPositive : ∀ i<k, 0<orbit N i := fun i earlier =>
    Nat.lt_of_lt_of_le positive (prior_no_descent first earlier)
  refine ⟨period,odd,finalEven,?_⟩
  rw [cycleLocalMinima_eq_valleyTimes period allPositive finalEven,valleyTimes_length]

theorem noEqualOfAtMost91 (hercher : Hercher91) {N k : Nat} (big : 2<N)
    (first : FirstContraction N k) (runs : oddRuns N k≤91) : orbit N k≠N := by
  intro returned
  obtain ⟨period,_,_,minima⟩ :=
    cycleOfFirstCrossingReturn (by omega) first returned
  have lower := hercher N k big period
  rw [minima] at lower
  omega

theorem noEqual88 (hercher : Hercher91) {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=88) : orbit N k≠N := by
  exact noEqualOfAtMost91 hercher (Nat.lt_trans (by decide) base) first (by omega)

end Terras90Hercher
