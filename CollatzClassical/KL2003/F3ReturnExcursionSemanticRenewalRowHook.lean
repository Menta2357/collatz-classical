import CollatzClassical.KL2003.F3ReturnExcursionOperatorContributionHook
import CollatzClassical.KL2003.F3ReturnExcursionRealIterateBridge

/-!
End-to-end conditional renewal conversion.

The theorem below is the exact mathematical bridge requested by F3: a frozen
Real row inequality gives exponential weighted operator mass, and a
row-wise stopped-fibre contribution hook transports that mass to actual
`piStar` populations.  The path contribution and disjointness hypotheses are
parameters, not empirical claims.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3SemanticRenewalRowHook

open F3OperatorContributionHook
open F3RealIterateBridge
open F3RealOperatorBridge

theorem exponential_piStar_lower_bound_of_row_hook
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (matrix : ι → ι → ℝ) (weight initial : ι → ℝ) (delta : ℝ)
    (roots : Nat → Finset Nat) (index : Nat → Nat → Finset ι)
    (contribution : Nat → Nat → ι → ℝ)
    (fiber : Nat → Nat → ι → Finset Nat)
    (window : Nat → Nat)
    (hdelta : 0 ≤ 1 + delta)
    (hrow : ∀ s, (1 + delta) * weight s ≤
      ∑ t, matrix s t * weight t)
    (hmatrix : ∀ s t, 0 ≤ matrix s t)
    (hinitial : ∀ s, 0 ≤ initial s)
    (hoperator : ∀ n,
      weightedMass weight (iteratePush matrix initial n) ≤
        ∑ a ∈ roots n, ∑ i ∈ index n a, contribution n a i)
    (hcontribution : ∀ n a i, i ∈ index n a →
      contribution n a i ≤ (fiber n a i).card)
    (hdisj : ∀ n a,
      (index n a : Set ι).PairwiseDisjoint (fiber n a))
    (hsub : ∀ n a i, i ∈ index n a →
      fiber n a i ⊆ piStarFinset a (window n)) :
    ∀ n,
      (1 + delta) ^ n * weightedMass weight initial ≤
        (((∑ a ∈ roots n,
          (piStarFinset a (window n)).card) : Nat) : ℝ) := by
  intro n
  have hrenewal := weighted_mass_iterate_lower_bound
    matrix weight initial hdelta hrow hmatrix hinitial n
  have hsemantic := operator_mass_le_piStar_of_row_contribution
    (weightedMass weight (iteratePush matrix initial n))
    (roots n) (window n)
    (index n)
    (contribution n)
    (fiber n)
    (hoperator n)
    (fun a i hi => hcontribution n a i hi)
    (fun a => hdisj n a)
    (fun a i hi => hsub n a i hi)
  exact hrenewal.trans hsemantic

end F3SemanticRenewalRowHook
end KL2003
end CollatzClassical
