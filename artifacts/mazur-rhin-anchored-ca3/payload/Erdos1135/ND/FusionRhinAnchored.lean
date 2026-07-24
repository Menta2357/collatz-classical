import Erdos1135.ND.FusionParametric
import Erdos1135.ND.RhinUnconditional

/-
Local addition notice (2026-07-24): this anchored corollary module was added by
the local weak-fusion extension. It is not presented as part of the pinned ca3
upstream package.
-/

/-!
# Rhin-anchored weak fixed-target fusion

This module removes the free `ND31Bounds` premise from the weak-fusion
interface by consuming the exact rational same-`d` endpoint already present
in the pinned upstream package. The strict prefactor gate and finite-base
certificate remain explicit hypotheses.
-/

namespace Erdos1135
namespace ND

noncomputable section

/-- The exact upstream Rhin endpoint supplies the ND-3.1 input at
`d = 6993 / 200000`. The strict quantitative gate and finite base remain
undischarged. -/
theorem fusion_of_rhin_6993_200000_of_finiteBaseVerified
    {N0 T : ℕ} (hN0 : 2 ≤ N0)
    (hsmall :
      ndRhinRate_sameD_6993_200000.2.1.choose *
          Real.rpow (Real.log (N0 : ℝ))
            (-(6993 / 200000 : ℝ)) <
        (1 / 2 : ℝ))
    (hfinite : FiniteBaseVerified N0 T) :
    HasPositiveLowerNatDensity collatzReachesOneSet := by
  exact fusion_of_nd31Bounds_of_finiteBaseVerified
    ndRhinRate_sameD_6993_200000.2.1 hN0 hsmall hfinite

end

end ND
end Erdos1135

