import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Data.Real.Basic

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3LayerNormalization

/-!
Pure Real normalization for a finite semantic layer.  This lemma is
independent of the F3 matrix and of `piStar`: once each row/channel
contribution is bounded by the cardinality of its retained fibre, the whole
layer inequality follows by finite summation.  The denominator remains the
sum of fibre cardinalities, not a root-count surrogate.
-/

theorem sum_contribution_le_sum_fibre_card
    {ι : Type*} [DecidableEq ι]
    (roots : Finset Nat) (index : Nat → Finset ι)
    (contribution : Nat → ι → ℝ)
    (fiber : Nat → ι → Finset Nat)
    (hrow : ∀ a i, i ∈ index a →
      contribution a i ≤ (fiber a i).card) :
    (∑ a ∈ roots, ∑ i ∈ index a, contribution a i) ≤
      ∑ a ∈ roots, ∑ i ∈ index a, ((fiber a i).card : ℝ) := by
  apply Finset.sum_le_sum
  intro a ha
  apply Finset.sum_le_sum
  intro i hi
  exact hrow a i hi

theorem sum_fibre_card_cast_eq
    {ι : Type*} [DecidableEq ι]
    (roots : Finset Nat) (index : Nat → Finset ι)
    (fiber : Nat → ι → Finset Nat) :
    (((∑ a ∈ roots, ∑ i ∈ index a, (fiber a i).card : Nat) : Nat) : ℝ) =
      ∑ a ∈ roots, ∑ i ∈ index a, ((fiber a i).card : ℝ) := by
  norm_num [Nat.cast_sum]

end F3LayerNormalization
end KL2003
end CollatzClassical
