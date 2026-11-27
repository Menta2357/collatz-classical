import Mathlib.Data.Real.Basic
import Mathlib.Algebra.BigOperators.Group.List.Basic
import Terras90ClockTable

namespace Terras90Reciprocal

open Terras90Lattice

private theorem ceilScore_spec {denominator : Nat} (pos : 0<denominator) :
    budgetScale≤ceilScore denominator*denominator := by
  have scalePos : 0<budgetScale := by decide
  have rem := Nat.mod_lt (budgetScale-1) pos
  have split := Nat.mod_add_div (budgetScale-1) denominator
  unfold ceilScore
  rw [Nat.add_mul,Nat.one_mul,Nat.mul_comm ((budgetScale-1)/denominator)]
  omega

private theorem termBound {x e : Nat}
    (boundary : sourceBoundary≤x) (floor : 2^e-1≤x) :
    (budgetScale:ℝ)*(1/(x:ℝ))≤(reciprocalBound e:ℝ) := by
  let denom := max sourceBoundary (2^e-1)
  have denomPos : 0<denom :=
    Nat.lt_of_lt_of_le (by decide : 0<sourceBoundary) (Nat.le_max_left _ _)
  have below : denom≤x := Nat.max_le.mpr ⟨boundary,floor⟩
  have whole := Nat.le_trans (ceilScore_spec denomPos)
    (Nat.mul_le_mul_left (ceilScore denom) below)
  have positive : 0<(x:ℝ) := by exact_mod_cast Nat.lt_of_lt_of_le denomPos below
  have comparison : (budgetScale:ℝ)≤(ceilScore denom:ℝ)*(x:ℝ) := by exact_mod_cast whole
  have divided := (div_le_iff₀ positive).2 comparison
  simpa [reciprocalBound,denom,div_eq_mul_inv] using divided

def rankScores (d : Nat) : List Nat :=
  (List.range 89).map (fun i => reciprocalBound (min 180 (d/roundedCapacity (i+2))))

set_option maxRecDepth 8000 in
private theorem tailPositive :
    (List.range 73).all (fun i => decide (0<roundedCapacity (i+18)))=true := by decide

private theorem tailSaturates {d i : Nat} (dLower : basisD≤d) (iSmall : i<73) :
    min 180 (d/roundedCapacity (i+18))=180 := by
  have appears := List.mem_range.mpr iSmall
  have positive := of_decide_eq_true (List.all_eq_true.mp tailPositive i appears)
  have bound := of_decide_eq_true (List.all_eq_true.mp capacitiesChecked.2 i appears)
  exact Nat.min_eq_left ((Nat.le_div_iff_mul_le positive).2 (Nat.le_trans bound dLower))

theorem exactRankBudget {d : Nat} (dLower : basisD≤d) :
    ordinaryBudget d = ceilScore (sourceBoundary*(sourceBoundary+1))+(rankScores d).sum := by
  have shape : List.range 89 = List.range 16 ++ (List.range 73).map (fun i => i+16) := by decide
  have front :
      ((List.range 16).map (fun i => reciprocalBound (min 180 (d/roundedCapacity (i+2))))).sum =
        (capacityCeilings.map (fun cap => reciprocalBound (min 180 (d/cap)))).sum := by
    rw [← capacitiesChecked.1,List.map_map]
    rfl
  have last :
      (List.range 73).map (fun i => reciprocalBound (min 180 (d/roundedCapacity (i+16+2)))) =
        List.replicate 73 (reciprocalBound 180) := by
    calc
      _ = (List.range 73).map (Function.const Nat (reciprocalBound 180)) := by
        apply List.map_congr_left
        intro i hi
        change reciprocalBound (min 180 (d/roundedCapacity (i+18)))=reciprocalBound 180
        rw [tailSaturates dLower (List.mem_range.mp hi)]
      _ = _ := by rw [List.map_const,List.length_range]
  simp only [rankScores,shape,List.map_append,List.map_map,Function.comp_def,List.sum_append]
  rw [front,last,List.sum_const_nat]
  unfold ordinaryBudget
  omega

private theorem sum_le_by_index {xs ys : List ℝ} (same : xs.length=ys.length)
    (bound : ∀ (i : Nat) (hi : i<xs.length), xs[i]≤ys[i]'(by omega)) :
    xs.sum≤ys.sum := by
  induction xs generalizing ys with
  | nil =>
    have empty := List.eq_nil_of_length_eq_zero same.symm
    simp [empty]
  | cons x xs ih =>
    cases ys with
    | nil => simp at same
    | cons y ys =>
      have head := bound 0 (by simp)
      have restLen : xs.length=ys.length := by simpa using same
      have rest := ih restLen (fun i h => bound (i+1) (by simpa using h))
      exact add_le_add head rest

private theorem distributeScale (xs : List Nat) :
    (xs.map (fun x : Nat => (budgetScale:ℝ)*(1/(x:ℝ)))).sum =
      (budgetScale:ℝ)*(xs.map (fun x : Nat => (1:ℝ)/(x:ℝ))).sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp only [List.map_cons,List.sum_cons,ih,mul_add]

private theorem realSum (xs : List Nat) :
    (xs.map (fun x : Nat => (x:ℝ))).sum=(xs.sum:ℝ) := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih]

/-- Convert every indexed valley floor to its exact rounded reciprocal
weight, and sum the same 89 occurrences as the clock sieve. -/
theorem ordinaryReciprocalBound {xs : List Nat} {d : Nat}
    (len : xs.length=90) (all : ∀ x ∈ xs, sourceBoundary≤x)
    (dLower : basisD≤d)
    (floors : ∀ (i : Nat) (ih : i<xs.length),
      1≤i → 2^(min 180 (d/roundedCapacity (i+1)))-1≤xs[i]) :
    (budgetScale:ℝ)*((xs.drop 1).map (fun x : Nat => (1:ℝ)/(x:ℝ))).sum≤(ordinaryBudget d:ℝ) := by
  let entries := (xs.drop 1).map (fun x : Nat => (budgetScale:ℝ)*(1/(x:ℝ)))
  let weights := (rankScores d).map (fun n : Nat => (n:ℝ))
  have same : entries.length=weights.length := by
    simp [entries,weights,rankScores,len]
  have terms : entries.sum≤weights.sum := by
    apply sum_le_by_index same
    intro i hi
    have inOriginal : 1+i<xs.length := by
      simp [entries,List.length_drop,len] at hi
      omega
    have height := floors (1+i) inOriginal (by omega)
    have boundary := all xs[1+i] (List.getElem_mem inOriginal)
    simp only [entries,weights,rankScores,List.getElem_map,List.getElem_drop,List.getElem_range]
    rw [show 1+i+1=i+2 by omega] at height
    exact termBound boundary height
  have whole : (rankScores d).sum≤ordinaryBudget d := by
    rw [exactRankBudget dLower]
    exact Nat.le_add_left _ _
  calc
    _ = entries.sum := (distributeScale _).symm
    _ ≤ weights.sum := terms
    _ = ((rankScores d).sum:ℝ) := realSum _
    _ ≤ _ := by exact_mod_cast whole

end Terras90Reciprocal
