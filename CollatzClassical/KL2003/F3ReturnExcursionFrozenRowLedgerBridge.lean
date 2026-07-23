import CollatzClassical.KL2003.F3ReturnExcursionSemanticBridge
import CollatzClassical.KL2003.F3ReturnExcursionOperatorContributionHook

/-!
Semantic ledger bridge for frozen rule rows.

The rule object itself determines the child population and the parent window.
This module turns those rule-level fibres into the generic row-contribution
hook.  It does not assert coverage of the 1215 frozen rows or manufacture the
operator-to-contribution inequality; those remain explicit hypotheses.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3FrozenRowLedgerBridge

open F3SemanticBridge
open F3OperatorContributionHook

def parentRoot : FrozenRule → Nat
  | .retarded a _ _ => a
  | .advancedDirect a _ _ _ => a
  | .parityLift a _ _ _ => a

def parentWindow : FrozenRule → Nat
  | .retarded _ x _ => x
  | .advancedDirect _ _ x _ => x
  | .parityLift _ _ x _ => x

def childFiber : FrozenRule → Finset Nat
  | .retarded a _ xRet => piStarFinset (4 * a) xRet
  | .advancedDirect _ c _ xAdv => piStarFinset c xAdv
  | .parityLift _ c _ xLift => piStarFinset (2 * c) xLift

theorem childFiber_subset_parent (rule : FrozenRule) :
    match rule with
    | .retarded a x xRet =>
        xRet ≤ x → childFiber rule ⊆ piStarFinset a x
    | .advancedDirect a c x xAdv =>
        T c = a → a ≤ x → xAdv ≤ x →
          childFiber rule ⊆ piStarFinset a x
    | .parityLift a c x xLift =>
        T c = a → a ≤ x → xLift ≤ x →
          childFiber rule ⊆ piStarFinset a x := by
  cases rule with
  | retarded a x xRet =>
      intro hx
      exact frozen_rule_piStar_subset (.retarded a x xRet) hx
  | advancedDirect a c x xAdv =>
      intro hc hax hx
      exact frozen_rule_piStar_subset
        (.advancedDirect a c x xAdv) hc hax hx
  | parityLift a c x xLift =>
      intro hc hax hx
      exact frozen_rule_piStar_subset
        (.parityLift a c x xLift) hc hax hx

def ledgerFiber
    {ι : Type*} (rules : ι → FrozenRule)
    (a : Nat) (i : ι) : Finset Nat :=
  if parentRoot (rules i) = a then childFiber (rules i) else ∅

theorem operator_mass_le_piStar_of_frozen_rule_ledger
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (operatorMass : ℝ) (roots : Finset Nat) (x : Nat)
    (rules : ι → FrozenRule) (index : Nat → Finset ι)
    (contribution : Nat → ι → ℝ)
    (hoperator : operatorMass ≤
      ∑ a ∈ roots, ∑ i ∈ index a, contribution a i)
    (hrow : ∀ a i, i ∈ index a →
      contribution a i ≤ (ledgerFiber rules a i).card)
    (hparent : ∀ a i, i ∈ index a → parentRoot (rules i) = a)
    (hwindow : ∀ a i, i ∈ index a → parentWindow (rules i) = x)
    (hrule : ∀ i, i ∈ index (parentRoot (rules i)) →
      match rules i with
      | .retarded _a x' xRet => xRet ≤ x'
      | .advancedDirect a c x' xAdv => T c = a ∧ a ≤ x' ∧ xAdv ≤ x'
      | .parityLift a c x' xLift => T c = a ∧ a ≤ x' ∧ xLift ≤ x')
    (hdisj : ∀ a,
      (index a : Set ι).PairwiseDisjoint (ledgerFiber rules a)) :
    operatorMass ≤
      (((∑ a ∈ roots, (piStarFinset a x).card) : Nat) : ℝ) := by
  have hsub : ∀ a i, i ∈ index a →
      ledgerFiber rules a i ⊆ piStarFinset a x := by
    intro a i hi
    have hroot := hparent a i hi
    have hwin := hwindow a i hi
    have hrule_i := hrule i
      (by simpa [hroot] using hi)
    rw [show ledgerFiber rules a i = childFiber (rules i) by
      simp [ledgerFiber, hroot]]
    cases h : rules i with
    | retarded a' x' xRet =>
        simp only [h, parentRoot, parentWindow] at hroot hwin hrule_i ⊢
        simpa [hroot, hwin] using
          (childFiber_subset_parent (.retarded a' x' xRet) hrule_i)
    | advancedDirect a' c' x' xAdv =>
        simp only [h, parentRoot, parentWindow] at hroot hwin hrule_i ⊢
        simpa [hroot, hwin] using
          (childFiber_subset_parent (.advancedDirect a' c' x' xAdv)
            hrule_i.1 hrule_i.2.1 hrule_i.2.2)
    | parityLift a' c' x' xLift =>
        simp only [h, parentRoot, parentWindow] at hroot hwin hrule_i ⊢
        simpa [hroot, hwin] using
          (childFiber_subset_parent (.parityLift a' c' x' xLift)
            hrule_i.1 hrule_i.2.1 hrule_i.2.2)
  exact operator_mass_le_piStar_of_row_contribution
    operatorMass roots x index contribution
    (ledgerFiber rules)
    hoperator hrow hdisj hsub

end F3FrozenRowLedgerBridge
end KL2003
end CollatzClassical
