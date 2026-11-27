import Terras90Reciprocal

namespace Terras90UniformReciprocal

noncomputable section

open Terras90Lattice
set_option exponentiation.threshold 512

private def reciprocalTerms (xs : List Nat) : ℝ :=
  (xs.map (fun x : Nat => (1 : ℝ) / (x : ℝ))).sum

private theorem reciprocalNonneg (xs : List Nat) : 0 ≤ reciprocalTerms xs := by
  induction xs with
  | nil => simp [reciprocalTerms]
  | cons x xs ih =>
    have term : (0 : ℝ) ≤ 1 / (x : ℝ) := div_nonneg zero_le_one (Nat.cast_nonneg x)
    exact add_nonneg term ih

/-- Extend only the list of terms in the reciprocal comparison. The
added values participate in neither the physical prefix nor its ranks. -/
theorem ordinaryReciprocalBound {xs : List Nat} {d : Nat}
    (nonempty : 1≤xs.length) (len : xs.length≤90) (all : ∀ x∈xs, sourceBoundary≤x)
    (dLower : basisD≤d)
    (floors : ∀ (i : Nat) (ih : i < xs.length) (_after : 1 ≤ i),
      2 ^ (min 180 (d / roundedCapacity (i + 1))) - 1 ≤ xs[i]'ih) :
    (budgetScale:ℝ)*((xs.drop 1).map (fun x : Nat => (1:ℝ)/(x:ℝ))).sum≤
      (ordinaryBudget d:ℝ) := by
  let padding := List.replicate (90-xs.length) ((2:Nat)^180)
  let filled := xs++padding
  have full : filled.length=90 := by
    simp only [filled,padding,List.length_append,List.length_replicate]
    omega
  have fullBound : ∀ x∈filled, sourceBoundary≤x := by
    intro x mem
    rw [show filled=xs++padding from rfl,List.mem_append] at mem
    rcases mem with original | added
    · exact all x original
    · rw [(List.mem_replicate.mp added).2]
      decide
  have fullFloors : ∀ (i : Nat) (hi : i < filled.length) (_ : 1 ≤ i),
      2 ^ (min 180 (d / roundedCapacity (i + 1))) - 1 ≤ filled[i]'hi := by
    intro i hi start
    by_cases real : i < xs.length
    · rw [show filled[i]'hi = xs[i] by exact List.getElem_append_left real]
      exact floors i real start
    · have added : filled[i]'hi = (2 : Nat) ^ 180 := by
        dsimp only [filled]
        rw [List.getElem_append_right (by omega),List.getElem_replicate]
      rw [added]
      exact Nat.le_trans (Nat.sub_le _ _)
        (Nat.pow_le_pow_right (by decide) (Nat.min_le_left _ _))
  have upper := Terras90Reciprocal.ordinaryReciprocalBound full fullBound dLower fullFloors
  have extra : 0 ≤ (budgetScale : ℝ) * reciprocalTerms padding :=
    mul_nonneg (Nat.cast_nonneg budgetScale) (reciprocalNonneg padding)
  have drop : filled.drop 1=xs.drop 1++padding := List.drop_append_of_le_length nonempty
  rw [drop,List.map_append,List.sum_append,mul_add] at upper
  exact (le_add_of_nonneg_right extra).trans upper

end
end Terras90UniformReciprocal

#print axioms Terras90UniformReciprocal.ordinaryReciprocalBound
