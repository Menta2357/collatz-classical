import Terras90
import Terras90Q0PhysicalPrice
import TerrasLocalProfiles

set_option exponentiation.threshold 512

namespace Terras90RankAssembly

open TerrasClock
open Terras88 (RankCut valleyTimes q0Price verifiedHeight)
open Terras90 (DeltaOneQ0)
open Terras90Q0Price (floor92 floor146)

def valleyHeights (N k : Nat) : List Nat := (valleyTimes N k).map (orbit N)

def sortedHeights (N k : Nat) : List Nat :=
  (valleyHeights N k).mergeSort (fun a b => decide (a≤b))

theorem sortedHeights_perm (N k : Nat) :
    (sortedHeights N k).Perm (valleyHeights N k) := List.mergeSort_perm _ _

theorem sortedHeights_ordered (N k : Nat) : (sortedHeights N k).Pairwise (·≤·) := by
  unfold sortedHeights
  simpa only [decide_eq_true_eq] using
    List.sorted_mergeSort (le:=fun a b : Nat => decide (a≤b))
      (by intro a b c ab bc; simp only [decide_eq_true_eq] at *; omega)
      (by intro a b; apply Bool.or_eq_true_iff.mpr; simp only [decide_eq_true_eq]; omega)
      (valleyHeights N k)

theorem sortedHeights_length {N k : Nat} (base : DeltaOneQ0 N k) :
    (sortedHeights N k).length=90 := by
  rw [(sortedHeights_perm N k).length_eq, valleyHeights, List.length_map,
      Terras88.valleyTimes_length, base.runs]

theorem sortedFloorOfCount {N k rank floor : Nat}
    (within : rank<(sortedHeights N k).length)
    (count : (valleyHeights N k).countP (fun x => decide (x<floor))≤rank) :
    floor≤(sortedHeights N k)[rank] := by
  by_cases low : floor≤(sortedHeights N k)[rank]
  · exact low
  · have ranks := Terras90Q0Price.rank_count_of_price
      (sortedHeights_ordered N k) within (by omega : (sortedHeights N k)[rank]<floor)
    rw [(sortedHeights_perm N k).countP_eq] at ranks
    omega

private theorem countMono {xs : List Nat} {p q : Nat → Bool}
    (implies : ∀ x, p x=true → q x=true) :
    xs.countP p ≤ xs.countP q := by
  induction xs with
  | nil => simp
  | cons x tail ih =>
    cases hp : p x with
    | false => cases hq : q x <;> simp [hp,hq] <;> omega
    | true => have hq := implies x hp; simp [hp,hq,ih]

private theorem startsAtZero {N k : Nat} (base : DeltaOneQ0 N k) :
    ∃ tail : List Nat, valleyTimes N k=0::tail := by
  have kEq := congrArg Prod.fst base.clock
  change k=630118245525664765 at kEq
  have odd : N%2=1 := by
    by_cases h : N%2=1
    · exact h
    · have before := base.first.2 1 (by omega)
      simp [oddCount, orbit, h] at before
  cases k with
  | zero => omega
  | succ j =>
    rw [valleyTimes, List.range_succ_eq_map, List.filter_cons]
    have start : startsOddRun N 0=true := (startsOddRun_iff N 0).2 ⟨odd, Or.inl rfl⟩
    simp [start]

/-- A statutory threshold suffices for the set of low starts. It keeps
ties and chronological multiplicities, and avoids choosing six winners. -/
theorem cutOfCounts {N k : Nat} (base : DeltaOneQ0 N k)
    (cheap : 6≤(valleyHeights N k).countP (fun x => decide (x<q0Price)))
    (high : (valleyHeights N k).countP (fun x => decide (x<floor146))≤10) :
    Nonempty (RankCut N k q0Price floor146 5) := by
  let low := fun i => decide (orbit N i<q0Price)
  let below := fun i => decide (orbit N i<floor146)
  have cheapCount : 6≤(valleyTimes N k).countP low := by
    simpa only [valleyHeights,List.countP_map,Function.comp_def,low] using cheap
  have highCount : (valleyTimes N k).countP below≤10 := by
    simpa only [valleyHeights,List.countP_map,Function.comp_def,below] using high
  have price_order : q0Price≤floor146 := by decide
  have countBound : (valleyTimes N k).countP low≤(valleyTimes N k).countP below :=
    countMono (by intro i hi; simp only [low,below,decide_eq_true_eq] at *; omega)
  have seedCheap : N<q0Price := by
    by_cases h : N<q0Price
    · exact h
    · have zero : (valleyTimes N k).countP low=0 := by
        apply List.countP_eq_zero.mpr
        intro i hi pi
        have after := prior_no_descent base.first (Terras88.valleyTimes_mem hi).1
        simp only [low, decide_eq_true_eq] at pi
        omega
      omega
  have head : TerrasValleyExtraction.StartsLow low (valleyTimes N k) := by
    obtain ⟨tail, shape⟩ := startsAtZero base
    rw [shape]
    simpa [TerrasValleyExtraction.StartsLow,low,orbit] using seedCheap
  refine ⟨⟨low, ?_, ?_, head, ?_, ?_⟩⟩
  · intro i hi
    simpa only [low,decide_eq_true_eq] using hi
  · intro i _ j _ hi hj
    have iv : orbit N i<q0Price := by simpa only [low,decide_eq_true_eq] using hi
    have jv : ¬orbit N j<q0Price := fun price => by simp [low,price] at hj
    omega
  · rw [base.runs]
    omega
  · change (valleyTimes N k).countP below < (valleyTimes N k).countP low+5
    omega

/-- Transport rank evidence back from a sorted list to the chronological
physical history. Permutation preserves occurrences with equal value. -/
theorem cutOfSorted {N k : Nat} (base : DeltaOneQ0 N k)
    (xs : List Nat) (perm : xs.Perm (valleyHeights N k)) (sorted : xs.Pairwise (·≤·))
    (len : xs.length=90) (cheap : xs[5]'(by omega)<q0Price)
    (tall : floor146≤xs[10]'(by omega)) :
    Nonempty (RankCut N k q0Price floor146 5) := by
  apply cutOfCounts base
  · rw [← perm.countP_eq (fun x => decide (x<q0Price))]
    exact Terras90Q0Price.rank_count_of_price sorted (by omega) cheap
  · rw [← perm.countP_eq (fun x => decide (x<floor146))]
    exact Terras90Q0Price.count_below_of_rank_floor sorted (by omega) tall

theorem physicalMinSorted {N k : Nat} (base : DeltaOneQ0 N k) :
    ∀ x ∈ sortedHeights N k, verifiedHeight≤x := by
  intro x hit
  have hm := (sortedHeights_perm N k).mem_iff.mp hit
  obtain ⟨i,hi,rfl⟩ := List.mem_map.mp hm
  exact Nat.le_trans (Nat.le_of_lt base.base)
    (prior_no_descent base.first (Terras88.valleyTimes_mem hi).1)

/-- Construct the RankCut from the two valley-count bounds. The price is
obtained from the original Q0 trajectory itself. -/
theorem ranksFromValleyFloors {N k : Nat} (base : DeltaOneQ0 N k)
    (nine : (valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<10)
    (ten : (valleyTimes N k).countP (fun i => decide (orbit N i<2^146-1))<11) :
    Nonempty (RankCut N k q0Price floor146 5) := by
  have count92 : (valleyHeights N k).countP (fun x => decide (x<floor92))≤9 := by
    simp only [valleyHeights,List.countP_map,Function.comp_def,floor92]
    omega
  have count146 : (valleyHeights N k).countP (fun x => decide (x<floor146))≤10 := by
    simp only [valleyHeights,List.countP_map,Function.comp_def,floor146]
    omega
  have len := sortedHeights_length base
  have floor10 := sortedFloorOfCount (N:=N) (k:=k) (rank:=9) (by omega) count92
  have floor11 := sortedFloorOfCount (N:=N) (k:=k) (rank:=10) (by omega) count146
  have cheap := Terras90Q0Price.q0_sixth_lt_price base (sortedHeights N k) len
    (sortedHeights_ordered N k) (sortedHeights_perm N k) floor10 floor11
  exact cutOfSorted base _ (sortedHeights_perm N k) (sortedHeights_ordered N k)
    len cheap floor11

theorem ranksFromProfiles {N k : Nat} (base : DeltaOneQ0 N k)
    (at92 : TerrasCuts.LocalSixProfile 92) (at146 : TerrasCuts.LocalSixProfile 146) :
    Nonempty (RankCut N k q0Price floor146 5) := by
  obtain ⟨nine,ten⟩ := TerrasCuts.q0RankFloors base at92 at146
  exact ranksFromValleyFloors base nine ten

theorem windowFromProfiles {N k : Nat} (base : DeltaOneQ0 N k)
    (at92 : TerrasCuts.LocalSixProfile 92) (at146 : TerrasCuts.LocalSixProfile 146) :
    Terras88.HasWindow N k q0Price floor146 5 := by
  obtain ⟨cut⟩ := ranksFromProfiles base at92 at146
  exact Terras88.physical_window base.base base.first (by decide) cut

/-- Discharge exactly the q0Ranks field of Terras90.Inputs90. -/
theorem q0Ranks (six92 : Terras90.SixRunCapacity 92)
    (six146 : Terras90.SixRunCapacity 146) (N k : Nat) (base : DeltaOneQ0 N k) :
    Nonempty (RankCut N k q0Price (2^146-1) 5) := by
  obtain ⟨nine,ten⟩ := TerrasLocalProfiles.q0RankFloorsOfSix base six92 six146
  exact ranksFromValleyFloors base nine ten

/-- The arithmetic sieve is the remaining input of Inputs90. -/
theorem inputs90OfSieve
    (sieve : ∀ N k, 2≤N → FirstContraction N k → oddRuns N k=90 →
      N≤orbit N k → DeltaOneQ0 N k) :
    Terras90.Inputs90 :=
  ⟨sieve,q0Ranks⟩

end Terras90RankAssembly
