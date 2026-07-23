import Mathlib.Algebra.Order.BigOperators.Ring.Finset

import CollatzClassical.KL2003.F3ReturnExcursionFiberAccounting
import CollatzClassical.KL2003.F3ReturnExcursionSemanticBridge

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3PiStarAggregateBridge

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

end F3PiStarAggregateBridge
end KL2003
end CollatzClassical
