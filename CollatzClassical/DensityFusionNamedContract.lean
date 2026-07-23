import CollatzClassical.DensityFusionParametric
import Mathlib.Logic.Function.Iterate

namespace CollatzClassical

open Filter

/-!
# Named density-fusion contract

This module records typed obligations for the eventual-ratio fusion: an
inclusive finite base segment, the semantics of a bounded Syracuse hit, a
Syracuse-to-reaches-one bridge, finite counting, and odd-to-all transport.
It is not a source theorem and does not assert that any concrete instance has
already been proved.
-/

/-- Every positive value through the inclusive endpoint `N0` reaches one. -/
def BaseThrough (N0 : Nat) (reachesOne : Nat → Prop) : Prop :=
  ∀ n, 0 < n → n ≤ N0 → reachesOne n

/-- The source semantics of hitting at most `N0`: an iterate is at most the
inclusive endpoint.  The Syracuse map stays a parameter until the external
source namespace is imported. -/
def SyracuseHitsAtMostSemantics
    (syracuse : Nat → Nat) (N N0 : Nat) : Prop :=
  ∃ m, (syracuse^[m]) N ≤ N0

/-- Positivity of all iterates from positive Syracuse inputs. -/
def SyracusePositive (syracuse : Nat → Nat) : Prop :=
  ∀ N m, 0 < N → 0 < (syracuse^[m]) N

/-- The still-external dynamic bridge.  It is typed by `N0` and may only be
used after an actual iterate has entered the inclusive base segment. -/
def SyracuseToReachesOneThrough
    (N0 : Nat) (syracuse : Nat → Nat) (reachesOne : Nat → Prop) : Prop :=
  ∀ N m, 0 < N → (syracuse^[m]) N ≤ N0 →
    reachesOne ((syracuse^[m]) N) → reachesOne N

/-- Pointwise coverage of the positive odd source domain by a bounded
Syracuse hit and the target reaches-one predicate. -/
def OddSourceCoverage
    (N0 : Nat) (syracuse : Nat → Nat) (reachesOne : Nat → Prop) : Prop :=
  ∀ N, 0 < N → N % 2 = 1 →
    SyracuseHitsAtMostSemantics syracuse N N0 → reachesOne N

theorem reachesOne_of_syracuseHitsAtMostSemantics
    {N0 N : Nat} {syracuse : Nat → Nat} {reachesOne : Nat → Prop}
    (hbase : BaseThrough N0 reachesOne)
    (hpositive : SyracusePositive syracuse)
    (hbridge : SyracuseToReachesOneThrough N0 syracuse reachesOne)
    (hN : 0 < N)
    (hhit : SyracuseHitsAtMostSemantics syracuse N N0) :
    reachesOne N := by
  rcases hhit with ⟨m, hm⟩
  have hiteratePositive : 0 < (syracuse^[m]) N := hpositive N m hN
  have hbaseHit : reachesOne ((syracuse^[m]) N) :=
    hbase ((syracuse^[m]) N) hiteratePositive hm
  exact hbridge N m hN hm hbaseHit

theorem oddSourceCoverage_of_baseThrough
    {N0 : Nat} {syracuse : Nat → Nat} {reachesOne : Nat → Prop}
    (hbase : BaseThrough N0 reachesOne)
    (hpositive : SyracusePositive syracuse)
    (hbridge : SyracuseToReachesOneThrough N0 syracuse reachesOne) :
    OddSourceCoverage N0 syracuse reachesOne := by
  intro N hN _hOdd hhit
  exact reachesOne_of_syracuseHitsAtMostSemantics
    hbase hpositive hbridge hN hhit

structure NamedDensityFusionContract
    (R : Type) [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R] where
  N0 : Nat
  syracuse : Nat → Nat
  reachesOne : Nat → Prop
  badRatio : Nat → R
  oddGoodRatio : Nat → R
  goodRatio : Nat → R
  rho : R
  q : R
  baseThrough : BaseThrough N0 reachesOne
  syracusePositive : SyracusePositive syracuse
  syracuseToReachesOne :
    SyracuseToReachesOneThrough N0 syracuse reachesOne
  nd31 : ∀ᶠ X : Nat in atTop, badRatio X ≤ q
  coverage_to_odd_ratio :
    OddSourceCoverage N0 syracuse reachesOne →
      ∀ᶠ X : Nat in atTop, rho - badRatio X ≤ oddGoodRatio X
  odd_to_all : ∀ᶠ X : Nat in atTop, oddGoodRatio X ≤ goodRatio X
  positive : 0 < rho - q

theorem NamedDensityFusionContract.odd_source_coverage
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    (contract : NamedDensityFusionContract R) :
    OddSourceCoverage contract.N0 contract.syracuse contract.reachesOne := by
  exact oddSourceCoverage_of_baseThrough
    contract.baseThrough contract.syracusePositive
    contract.syracuseToReachesOne

theorem NamedDensityFusionContract.eventual_cover
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    (contract : NamedDensityFusionContract R) :
    ∀ᶠ X : Nat in atTop,
      contract.rho - contract.badRatio X ≤ contract.goodRatio X := by
  have hodd := contract.coverage_to_odd_ratio contract.odd_source_coverage
  filter_upwards [hodd, contract.odd_to_all] with X hoddX hallX
  exact hoddX.trans hallX

theorem NamedDensityFusionContract.eventual_lower_bound
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    (contract : NamedDensityFusionContract R) :
    0 < contract.rho - contract.q ∧
      EventuallyRatioLowerBound contract.goodRatio
        (contract.rho - contract.q) := by
  exact nd31_fusion_eventual_lower_bound
    contract.nd31
    contract.eventual_cover
    contract.positive

theorem NamedDensityFusionContract.positive_eventual_ratio_lower_bound
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    (contract : NamedDensityFusionContract R) :
    HasPositiveEventuallyRatioLowerBound contract.goodRatio := by
  exact nd31_fusion_positive_eventual_ratio
    contract.nd31
    contract.eventual_cover
    contract.positive

end CollatzClassical
