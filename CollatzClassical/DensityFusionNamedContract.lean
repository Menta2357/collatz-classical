import CollatzClassical.DensityFusionParametric

namespace CollatzClassical

open Filter

/-!
# Named density-fusion contract

This module records the three concrete obligations that the eventual-ratio
fusion must consume: a finite base segment, the Syracuse-to-reaches-one
bridge, and the odd-to-all bridge.  The propositions are intentionally
abstract here; the contract is not a source theorem and does not assert that
any of them has already been proved.
-/

structure NamedDensityFusionContract
    (R : Type) [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R] where
  badRatio : Nat → R
  goodRatio : Nat → R
  rho : R
  q : R
  baseBelow : Prop
  syracuseToReachesOne : Prop
  oddToAll : Prop
  baseBelow_proof : baseBelow
  syracuseToReachesOne_proof : syracuseToReachesOne
  oddToAll_proof : oddToAll
  nd31 : ∀ᶠ X : Nat in atTop, badRatio X ≤ q
  cover_of_bridges :
    baseBelow → syracuseToReachesOne → oddToAll →
      ∀ᶠ X : Nat in atTop, rho - badRatio X ≤ goodRatio X
  positive : 0 < rho - q

theorem NamedDensityFusionContract.eventual_lower_bound
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    (contract : NamedDensityFusionContract R) :
    0 < contract.rho - contract.q ∧
      EventuallyRatioLowerBound contract.goodRatio
        (contract.rho - contract.q) := by
  exact nd31_fusion_eventual_lower_bound
    contract.nd31
    (contract.cover_of_bridges
      contract.baseBelow_proof contract.syracuseToReachesOne_proof
      contract.oddToAll_proof)
    contract.positive

theorem NamedDensityFusionContract.positive_eventual_ratio_lower_bound
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    (contract : NamedDensityFusionContract R) :
    HasPositiveEventuallyRatioLowerBound contract.goodRatio := by
  exact nd31_fusion_positive_eventual_ratio
    contract.nd31
    (contract.cover_of_bridges
      contract.baseBelow_proof contract.syracuseToReachesOne_proof
      contract.oddToAll_proof)
    contract.positive

end CollatzClassical
