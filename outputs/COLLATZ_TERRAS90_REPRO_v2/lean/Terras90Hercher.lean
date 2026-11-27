import TerrasCycleOfCrossing
import Terras90Final

namespace Terras90Hercher

/-- The corrected cycle exclusion fills the exact equality premise of the
at-most-ninety first-descent theorem. -/
theorem noEqual90 (hercher : Hercher91) : Terras90Final.NoEqual90 := by
  intro N k base first runs
  exact noEqualOfAtMost91 hercher (Nat.lt_trans (by decide) base) first (by omega)

end Terras90Hercher

#print axioms Terras90Hercher.LeastReturn.indexInjective
#print axioms Terras90Hercher.cycleLocalMinima_eq_valleyTimes
#print axioms Terras90Hercher.cycleOfFirstCrossingReturn
#print axioms Terras90Hercher.noEqualOfAtMost91
#print axioms Terras90Hercher.noEqual88
#print axioms Terras90Hercher.noEqual90
