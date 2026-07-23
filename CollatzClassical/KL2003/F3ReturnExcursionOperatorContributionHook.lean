import CollatzClassical.KL2003.F3ReturnExcursionLayerNormalization
import CollatzClassical.KL2003.F3ReturnExcursionPiStarAggregateBridge
import CollatzClassical.KL2003.F3ReturnExcursionRealIterateBridge

/-!
Row-wise operator-to-`piStar` contribution hook.

The previous semantic witness exposed one aggregate obligation: operator mass
must be bounded by a sum of fibre cardinalities.  This file factors that
obligation into the form an eventual F3 proof must actually supply: a
row-wise Real contribution bound, followed by the already proved finite fibre
normalization and aggregate `piStar` accounting.  No contribution hook is
invented from the numeric certificate here.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3OperatorContributionHook

open F3LayerNormalization
open F3PiStarAggregateBridge
open F3RealIterateBridge
open F3RealOperatorBridge

theorem operator_mass_le_piStar_of_row_contribution
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (operatorMass : ℝ)
    (roots : Finset Nat) (x : Nat)
    (index : Nat → Finset ι)
    (contribution : Nat → ι → ℝ)
    (fiber : Nat → ι → Finset Nat)
    (hoperator : operatorMass ≤
      ∑ a ∈ roots, ∑ i ∈ index a, contribution a i)
    (hrow : ∀ a i, i ∈ index a →
      contribution a i ≤ (fiber a i).card)
    (hdisj : ∀ a,
      (index a : Set ι).PairwiseDisjoint (fiber a))
    (hsub : ∀ a i, i ∈ index a →
      fiber a i ⊆ piStarFinset a x) :
    operatorMass ≤
      (((∑ a ∈ roots, (piStarFinset a x).card) : Nat) : ℝ) := by
  have hcontrib := sum_contribution_le_sum_fibre_card
    roots index contribution fiber hrow
  have hfibres := sum_fibre_card_cast_eq roots index fiber
  have haggregate := aggregate_piStar_card_bound
    roots x index fiber hdisj hsub
  have haggregateReal :
      (((∑ a ∈ roots, ∑ i ∈ index a, (fiber a i).card) : Nat) : ℝ) ≤
        (((∑ a ∈ roots, (piStarFinset a x).card) : Nat) : ℝ) := by
    exact_mod_cast haggregate
  calc
    operatorMass ≤ ∑ a ∈ roots, ∑ i ∈ index a, contribution a i := hoperator
    _ ≤ ∑ a ∈ roots, ∑ i ∈ index a, ((fiber a i).card : ℝ) := hcontrib
    _ = (((∑ a ∈ roots, ∑ i ∈ index a,
        (fiber a i).card) : Nat) : ℝ) := hfibres.symm
    _ ≤ (((∑ a ∈ roots, (piStarFinset a x).card) : Nat) : ℝ) :=
      haggregateReal

theorem weighted_iterate_mass_le_piStar_of_row_contribution
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (M : ι → ι → ℝ) (weight initial : ι → ℝ) (n : Nat)
    (roots : Finset Nat) (x : Nat)
    (index : Nat → Finset ι)
    (contribution : Nat → ι → ℝ)
    (fiber : Nat → ι → Finset Nat)
    (hoperator : weightedMass weight (iteratePush M initial n) ≤
      ∑ a ∈ roots, ∑ i ∈ index a, contribution a i)
    (hrow : ∀ a i, i ∈ index a →
      contribution a i ≤ (fiber a i).card)
    (hdisj : ∀ a,
      (index a : Set ι).PairwiseDisjoint (fiber a))
    (hsub : ∀ a i, i ∈ index a →
      fiber a i ⊆ piStarFinset a x) :
    weightedMass weight (iteratePush M initial n) ≤
      (((∑ a ∈ roots, (piStarFinset a x).card) : Nat) : ℝ) :=
  operator_mass_le_piStar_of_row_contribution
    (weightedMass weight (iteratePush M initial n))
    roots x index contribution fiber hoperator hrow hdisj hsub

end F3OperatorContributionHook
end KL2003
end CollatzClassical
