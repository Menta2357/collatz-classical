import Terras90Lattice
import Terras90ClockTable

namespace Terras90Lattice

/-- The finite clock sieve after the analytic and physical envelope
premises have been scaled outwards. This is a statement about clock
pairs, independent of the displacement-specific exclusions. -/
theorem clocksOfScaledEnvelope {k d : Nat}
    (oddBound : d<maxOdds)
    (global : lowGap k d<globalGap)
    (positive : 0<highGap k d)
    (ordinary : lowGap k d<100000*(ordinaryBudget d:Int)) :
    (k,d)∈survivors := by
  obtain ⟨h,j,hpos,hmax,jlo,jhi,clock⟩ := admitCoordinates oddBound global positive
  have small : (toClock h j).2<maxOdds := by rw [clock]; exact oddBound
  have allowed : (h:Int)*basisLow-(j:Int)*epsilonHigh<
      100000*(ordinaryBudget (toClock h j).2:Int) := by
    rw [← (gapSplit h j).1,clock]
    exact ordinary
  rw [← clock]
  exact tableCovers hpos hmax jlo jhi small allowed

end Terras90Lattice
