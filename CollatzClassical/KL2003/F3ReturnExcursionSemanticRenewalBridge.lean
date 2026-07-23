import CollatzClassical.KL2003.F3ReturnExcursionPiStarAggregateBridge
import CollatzClassical.KL2003.F3ReturnExcursionRealIterateBridge

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3SemanticRenewalBridge

open F3PiStarAggregateBridge
open F3RealOperatorBridge
open F3RealIterateBridge

/-!
Conditional conversion from the frozen Real operator to actual `piStar`
mass.  The semantic lower hook is intentionally explicit: it is the only
F3-specific hypothesis still missing after the first-hit fibre construction.
The theorem below does not manufacture this hook from holdout data.
-/

structure PiStarOperatorWitness (ι : Type*) [Fintype ι]
    [DecidableEq ι] where
  matrix : ι → ι → ℝ
  weight : ι → ℝ
  initial : ι → ℝ
  delta : ℝ
  roots : Nat → Finset Nat
  index : Nat → Nat → Finset ι
  fiber : Nat → Nat → ι → Finset Nat
  window : Nat → Nat
  row_lower : ∀ s,
    (1 + delta) * weight s ≤ ∑ t, matrix s t * weight t
  matrix_nonneg : ∀ s t, 0 ≤ matrix s t
  initial_nonneg : ∀ s, 0 ≤ initial s
  fibre_disjoint : ∀ n a,
    ((index n a : Set ι).PairwiseDisjoint (fiber n a))
  fibre_subset : ∀ n a i, i ∈ index n a →
    fiber n a i ⊆ piStarFinset a (window n)
  operator_to_fibres : ∀ n,
    weightedMass weight (iteratePush matrix initial n) ≤
      (((∑ a ∈ roots n, ∑ i ∈ index n a,
          (fiber n a i).card) : Nat) : ℝ)

theorem operator_mass_le_piStar_mass
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (witness : PiStarOperatorWitness ι) (n : Nat) :
    weightedMass witness.weight
        (iteratePush witness.matrix witness.initial n) ≤
      (((∑ a ∈ witness.roots n,
          (piStarFinset a (witness.window n)).card) : Nat) : ℝ) := by
  calc
    weightedMass witness.weight
        (iteratePush witness.matrix witness.initial n) ≤
        (((∑ a ∈ witness.roots n, ∑ i ∈ witness.index n a,
            (witness.fiber n a i).card) : Nat) : ℝ) :=
      witness.operator_to_fibres n
    _ ≤ (((∑ a ∈ witness.roots n,
          (piStarFinset a (witness.window n)).card) : Nat) : ℝ) := by
      have hnat := aggregate_piStar_card_bound
        (witness.roots n) (witness.window n)
        (witness.index n) (witness.fiber n)
        (fun a => witness.fibre_disjoint n a)
        (fun a i hi => witness.fibre_subset n a i hi)
      exact_mod_cast hnat

theorem operator_mass_le_piStar_mass_of_firstHit
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (matrix : ι → ι → ℝ) (weight initial : ι → ℝ)
    (roots : Nat → Finset Nat)
    (index : Nat → Nat → Finset ι)
    (parent child xChild : Nat → ι → Nat)
    (kind : ι → F3AdvancedDisjointness.AdvancedSourceKind)
    (window : Nat → Nat) (n : Nat)
    (hparent : ∀ a i, i ∈ index n a → parent n i = a)
    (hax : ∀ a, a ≤ window n)
    (hcarith : ∀ a i, i ∈ index n a →
      3 * child n i + 1 = 2 * parent n i)
    (hxChild : ∀ a i, i ∈ index n a → xChild n i ≤ window n)
    (hdistinct : ∀ a i, i ∈ index n a → ∀ j, j ∈ index n a →
      i ≠ j → child n i ≠ child n j)
    (hsemantic : weightedMass weight (iteratePush matrix initial n) ≤
      (((∑ a ∈ roots n, ∑ i ∈ index n a,
        (F3FirstHitFibers.firstHitSource (kind i) (parent n i)
          (child n i) (xChild n i)).card) : Nat) : ℝ)) :
    weightedMass weight (iteratePush matrix initial n) ≤
      (((∑ a ∈ roots n,
        (piStarFinset a (window n)).card) : Nat) : ℝ) := by
  calc
    weightedMass weight (iteratePush matrix initial n) ≤
        (((∑ a ∈ roots n, ∑ i ∈ index n a,
          (F3FirstHitFibers.firstHitSource (kind i) (parent n i)
            (child n i) (xChild n i)).card) : Nat) : ℝ) := hsemantic
    _ ≤ (((∑ a ∈ roots n,
        (piStarFinset a (window n)).card) : Nat) : ℝ) := by
      have hnat := aggregate_firstHit_piStar_card_bound
        (roots n) (window n) (index n)
        (parent n) (child n) (xChild n) kind
        (fun a i hi => hparent a i hi)
        hax
        (fun a i hi => hcarith a i hi)
        (fun a i hi => hxChild a i hi)
        (fun a i hi j hj hij => hdistinct a i hi j hj hij)
      exact_mod_cast hnat

theorem exponential_piStar_mass_lower_bound
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (witness : PiStarOperatorWitness ι)
    (hdelta : 0 ≤ 1 + witness.delta) :
    ∀ n,
      (1 + witness.delta) ^ n *
          weightedMass witness.weight witness.initial ≤
        (((∑ a ∈ witness.roots n,
            (piStarFinset a (witness.window n)).card) : Nat) : ℝ) := by
  intro n
  exact le_trans
    (weighted_mass_iterate_lower_bound
      witness.matrix witness.weight witness.initial
      hdelta witness.row_lower witness.matrix_nonneg
      witness.initial_nonneg n)
    (operator_mass_le_piStar_mass witness n)

end F3SemanticRenewalBridge
end KL2003
end CollatzClassical
