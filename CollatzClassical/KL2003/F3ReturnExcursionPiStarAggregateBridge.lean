import Mathlib.Algebra.Order.BigOperators.Ring.Finset

import CollatzClassical.KL2003.F3ReturnExcursionFiberAccounting
import CollatzClassical.KL2003.F3ReturnExcursionSemanticBridge

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3PiStarAggregateBridge

open F3SemanticBridge

/-!
Aggregate semantic bridge for a finite root block.

The right-hand side is a sum of actual `piStar` populations, one per root.
The left-hand side is a sum of frozen source fibres.  The theorem keeps
disjointness and inclusion as explicit hypotheses; no projection of tagged
members and no empirical holdout is silently used to justify them.
-/

theorem aggregate_piStar_card_bound
    {ι : Type*} [DecidableEq ι]
    (A : Finset Nat) (x : Nat)
    (I : Nat → Finset ι)
    (fiber : Nat → ι → Finset Nat)
    (hdisj : ∀ a,
      (I a : Set ι).PairwiseDisjoint (fiber a))
    (hsub : ∀ a i, i ∈ I a → fiber a i ⊆ piStarFinset a x) :
    (∑ a ∈ A, ∑ i ∈ I a, (fiber a i).card) ≤
      ∑ a ∈ A, (piStarFinset a x).card := by
  apply Finset.sum_le_sum
  intro a ha
  exact F3FiberAccounting.sum_fiber_card_le_root_card
    (I a) (fiber a) (piStarFinset a x) (hdisj a)
    (fun i hi => hsub a i hi)

/-!
The next corollary is the exact form used when the frozen rule list is
partitioned by its parent root.  `ruleSource` and `ruleParent` are supplied by
the caller because the frozen table may contain multiple rule encodings for a
single root.  The semantic rule theorem supplies `hsub`; the advanced
disjointness module supplies `hdisj` for the nontrivial rows.
-/

theorem aggregate_piStar_card_bound_of_frozen_rules
    {ι : Type*} [DecidableEq ι]
    (A : Finset Nat) (x : Nat)
    (I : Nat → Finset ι)
    (ruleParent : ι → Nat)
    (ruleSource : ι → Finset Nat)
    (fiber : Nat → ι → Finset Nat)
    (hparent : ∀ a i, i ∈ I a → ruleParent i = a)
    (hfiber : ∀ a i, i ∈ I a → fiber a i = ruleSource i)
    (hdisj : ∀ a,
      (I a : Set ι).PairwiseDisjoint (fiber a))
    (hsource : ∀ i, ruleSource i ⊆ piStarFinset (ruleParent i) x) :
    (∑ a ∈ A, ∑ i ∈ I a, (fiber a i).card) ≤
      ∑ a ∈ A, (piStarFinset a x).card := by
  apply aggregate_piStar_card_bound A x I fiber hdisj
  intro a i hi
  rw [hfiber a i hi]
  have hsource' := hsource i
  rw [hparent a i hi] at hsource'
  exact hsource'

def frozenRuleParent : FrozenRule → Nat
  | .retarded a _ _ => a
  | .advancedDirect a _ _ _ => a
  | .parityLift a _ _ _ => a

def frozenRuleWindow : FrozenRule → Nat
  | .retarded _ x _ => x
  | .advancedDirect _ _ x _ => x
  | .parityLift _ _ x _ => x

def frozenRuleSource : FrozenRule → Finset Nat
  | .retarded a _ xRet => piStarFinset (4 * a) xRet
  | .advancedDirect _ c _ xAdv => piStarFinset c xAdv
  | .parityLift _ c _ xLift => piStarFinset (2 * c) xLift

def frozenRuleValid : FrozenRule → Prop
  | .retarded _ x xRet => xRet ≤ x
  | .advancedDirect a c x xAdv => T c = a ∧ a ≤ x ∧ xAdv ≤ x
  | .parityLift a c x xLift => T c = a ∧ a ≤ x ∧ xLift ≤ x

theorem frozenRuleSource_subset_parent
    (rule : FrozenRule) (hvalid : frozenRuleValid rule) :
    frozenRuleSource rule ⊆
      piStarFinset (frozenRuleParent rule) (frozenRuleWindow rule) := by
  cases rule with
  | retarded a x xRet =>
      exact frozen_rule_piStar_subset (.retarded a x xRet) hvalid
  | advancedDirect a c x xAdv =>
      exact frozen_rule_piStar_subset (.advancedDirect a c x xAdv)
        hvalid.1 hvalid.2.1 hvalid.2.2
  | parityLift a c x xLift =>
      exact frozen_rule_piStar_subset (.parityLift a c x xLift)
        hvalid.1 hvalid.2.1 hvalid.2.2

theorem aggregate_frozen_rule_piStar_card_bound
    (A : Finset Nat) (x : Nat)
    (I : Nat → Finset FrozenRule)
    (hparent : ∀ a rule, rule ∈ I a → frozenRuleParent rule = a)
    (hwindow : ∀ a rule, rule ∈ I a → frozenRuleWindow rule = x)
    (hvalid : ∀ a rule, rule ∈ I a → frozenRuleValid rule)
    (hdisj : ∀ a,
      (I a : Set FrozenRule).PairwiseDisjoint frozenRuleSource) :
    (∑ a ∈ A, ∑ rule ∈ I a, (frozenRuleSource rule).card) ≤
      ∑ a ∈ A, (piStarFinset a x).card := by
  apply aggregate_piStar_card_bound A x I
    (fun _ rule => frozenRuleSource rule) hdisj
  intro a rule hmem
  have hsource := frozenRuleSource_subset_parent rule (hvalid a rule hmem)
  rw [hparent a rule hmem, hwindow a rule hmem] at hsource
  exact hsource

end F3PiStarAggregateBridge
end KL2003
end CollatzClassical
