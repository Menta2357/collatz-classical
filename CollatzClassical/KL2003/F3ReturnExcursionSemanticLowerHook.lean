import CollatzClassical.KL2003.F3ReturnExcursionSemanticRenewalBridge
import CollatzClassical.KL2003.F3ReturnExcursionLayerNormalization

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3SemanticLowerHook

open F3PiStarAggregateBridge
open F3RealOperatorBridge
open F3RealIterateBridge

/-!
The semantic lower hook is split into two independent obligations:

* `operator_to_contribution` compares the frozen Real operator with explicit
  row contributions; this is the genuinely F3-specific analytic obligation.
* `contribution_le_fibre` is a member-wise finite accounting statement.  The
  layer-normalization brick turns it into a sum of fibre cardinalities, and
  the existing disjoint/subset bridge turns those fibres into `piStar` mass.

This file proves only the second conversion.  It does not infer the first
comparison from empirical data and makes no growth, rho, density, almost-all,
or global-Collatz claim.
-/

theorem operator_mass_le_piStar_mass_of_contribution_hook
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (matrix : ι → ι → ℝ) (weight initial : ι → ℝ)
    (roots : Nat → Finset Nat)
    (index : Nat → Nat → Finset ι)
    (fiber : Nat → Nat → ι → Finset Nat)
    (window : Nat → Nat)
    (contribution : Nat → Nat → ι → ℝ)
    (fibre_disjoint : ∀ n a,
      ((index n a : Set ι).PairwiseDisjoint (fiber n a)))
    (fibre_subset : ∀ n a i, i ∈ index n a →
      fiber n a i ⊆ piStarFinset a (window n))
    (operator_to_contribution : ∀ n,
      weightedMass weight (iteratePush matrix initial n) ≤
        ∑ a ∈ roots n, ∑ i ∈ index n a, contribution n a i)
    (contribution_le_fibre : ∀ n a i, i ∈ index n a →
      contribution n a i ≤ (fiber n a i).card) :
    ∀ n,
      weightedMass weight (iteratePush matrix initial n) ≤
        (((∑ a ∈ roots n,
            (piStarFinset a (window n)).card) : Nat) : ℝ) := by
  intro n
  have hcontrib :
      (∑ a ∈ roots n, ∑ i ∈ index n a, contribution n a i) ≤
        ∑ a ∈ roots n, ∑ i ∈ index n a, ((fiber n a i).card : ℝ) := by
    exact F3LayerNormalization.sum_contribution_le_sum_fibre_card
      (roots n) (index n) (fun a i => contribution n a i)
        (fun a i => fiber n a i) (contribution_le_fibre n)
  have hcard_cast :
      (((∑ a ∈ roots n, ∑ i ∈ index n a,
          (fiber n a i).card) : Nat) : ℝ) =
        ∑ a ∈ roots n, ∑ i ∈ index n a, ((fiber n a i).card : ℝ) := by
    exact F3LayerNormalization.sum_fibre_card_cast_eq
      (roots n) (index n) (fun a i => fiber n a i)
  have hfibres :
      (((∑ a ∈ roots n, ∑ i ∈ index n a,
          (fiber n a i).card) : Nat) : ℝ) ≤
        (((∑ a ∈ roots n,
            (piStarFinset a (window n)).card) : Nat) : ℝ) := by
    have hnat := aggregate_piStar_card_bound
      (roots n) (window n) (index n) (fiber n)
      (fun a => fibre_disjoint n a)
      (fun a i hi => fibre_subset n a i hi)
    exact_mod_cast hnat
  calc
    weightedMass weight (iteratePush matrix initial n) ≤
        ∑ a ∈ roots n, ∑ i ∈ index n a, contribution n a i :=
      operator_to_contribution n
    _ ≤ ∑ a ∈ roots n, ∑ i ∈ index n a, ((fiber n a i).card : ℝ) :=
      hcontrib
    _ = (((∑ a ∈ roots n, ∑ i ∈ index n a,
        (fiber n a i).card) : Nat) : ℝ) := hcard_cast.symm
    _ ≤ (((∑ a ∈ roots n,
        (piStarFinset a (window n)).card) : Nat) : ℝ) := hfibres

end F3SemanticLowerHook
end KL2003
end CollatzClassical
