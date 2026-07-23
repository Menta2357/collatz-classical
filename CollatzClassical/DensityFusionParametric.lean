import Mathlib.Algebra.Order.Group.Defs
import Mathlib.Order.Filter.AtTopBot.Basic

/-!
# Parametric density-fusion algebra

This module contains only the order-theoretic core of the proposed
ND31/base-below-threshold assembly.  It deliberately does not import the
external Mazur/ProofAtlas namespace: the concrete `ND31Bounds` statement,
Syracuse-to-Collatz bridge, and odd-to-all-natural bridge remain separate
integration obligations.
-/

namespace CollatzClassical

open Filter

/-- An eventual lower bound for a counting-ratio function. -/
def EventuallyRatioLowerBound {R : Type} [AddCommGroup R] [LinearOrder R]
    [IsOrderedAddMonoid R]
    (ratio : Nat -> R) (delta : R) : Prop :=
  ∀ᶠ X : Nat in atTop, delta ≤ ratio X

/-- A positive eventual lower bound, without asserting existence of a density
limit.  This is the weakest notion needed by the fusion gate. -/
def HasPositiveEventuallyRatioLowerBound {R : Type} [AddCommGroup R] [LinearOrder R]
    [IsOrderedAddMonoid R] (ratio : Nat -> R) : Prop :=
  ∃ delta : R, 0 < delta ∧ EventuallyRatioLowerBound ratio delta

/--
The basic complement estimate used by the density-fusion plan.

`rho` is the ambient limiting mass of the source domain (for example `1 / 2`
for odd inputs), `badRatio` is the exceptional-set ratio, and `goodRatio` is
the ratio of the target set.  No claim about Syracuse, Collatz, or natural
density existence is made here; this is an eventual lower-density statement.
-/
theorem eventually_ratio_lower_bound_of_subtraction
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    {goodRatio badRatio : Nat -> R} {rho q : R}
    (hcover : ∀ᶠ X : Nat in atTop, rho - badRatio X ≤ goodRatio X)
    (hbad : ∀ᶠ X : Nat in atTop, badRatio X ≤ q) :
    EventuallyRatioLowerBound goodRatio (rho - q) := by
  unfold EventuallyRatioLowerBound
  filter_upwards [hcover, hbad] with X hcoverX hbadX
  exact (sub_le_sub_left hbadX rho).trans hcoverX

/--
Parametric ND31 fusion at the ratio level.

The first hypothesis is the fixed-target quantitative estimate supplied by an
ND31 implementation.  The second hypothesis packages the finite base theorem
and all dynamics/domain bridges: after removing the bad inputs, the remaining
source mass contributes to `goodRatio`.  The theorem intentionally leaves
`C`, `N0`, and `d` universally parameterized.

For the external ND31 statement, instantiate `badRatio` with the odd Syracuse
bad ratio and `rho` with `1 / 2`; the resulting lower bound is ambient-density
normalization.  A separate odd-to-all-natural bridge is still required before
interpreting `goodRatio` as a set of all natural starts reaching one.
-/
theorem nd31_fusion_eventual_lower_bound
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    {goodRatio badRatio : Nat -> R} {rho q : R}
    (hnd31 : ∀ᶠ X : Nat in atTop, badRatio X ≤ q)
    (hcover : ∀ᶠ X : Nat in atTop, rho - badRatio X ≤ goodRatio X)
    (hpositive : 0 < rho - q) :
    0 < rho - q ∧ EventuallyRatioLowerBound goodRatio (rho - q) := by
  refine ⟨hpositive, ?_⟩
  exact eventually_ratio_lower_bound_of_subtraction
    (q := q)
    hcover hnd31

/-- Package the parametric fusion result as positive eventual lower density. -/
theorem nd31_fusion_positive_eventual_ratio
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    {goodRatio badRatio : Nat -> R} {rho q : R}
    (hnd31 : ∀ᶠ X : Nat in atTop, badRatio X ≤ q)
    (hcover : ∀ᶠ X : Nat in atTop, rho - badRatio X ≤ goodRatio X)
    (hpositive : 0 < rho - q) :
    HasPositiveEventuallyRatioLowerBound goodRatio := by
  refine ⟨rho - q, hpositive, ?_⟩
  exact (nd31_fusion_eventual_lower_bound hnd31 hcover hpositive).2

/-- Transfer an eventual lower bound from an odd-supported ratio to an
all-natural ratio once the concrete odd-to-all bridge has been proved. -/
theorem eventually_ratio_lower_bound_of_odd_to_all_bridge
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    {oddRatio allRatio : Nat -> R} {delta : R}
    (hodd : EventuallyRatioLowerBound oddRatio delta)
    (hbridge : ∀ᶠ X : Nat in atTop, oddRatio X ≤ allRatio X) :
    EventuallyRatioLowerBound allRatio delta := by
  unfold EventuallyRatioLowerBound at hodd ⊢
  filter_upwards [hodd, hbridge] with X hoddX hbridgeX
  exact hoddX.trans hbridgeX

end CollatzClassical
