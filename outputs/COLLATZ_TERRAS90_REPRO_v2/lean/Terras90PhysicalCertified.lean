import Terras90PhysicalAdmission
import Terras90LogBrackets

namespace Terras90Physical

open TerrasClock
open Terras88 (verifiedHeight)

/-- The logarithm endpoints are proved in Lean. Only Rhin's uniform
estimate is supplied for the passage from a physical crossing to the sieve. -/
theorem admissionWithRhin {N k : Nat} (rhin : RhinBound)
    (base : verifiedHeight<N) (first : FirstContraction N k)
    (runs : oddRuns N k=90) (shift : N+1≤orbit N k) :
    ScaledAdmission k (oddCount N k) :=
  admissionFromPhysical Terras90LogBrackets.certified rhin base first runs shift

/-- The physical candidate and its exact affine book survive only in the
seven distinct clocks left after all four certified exclusions. -/
theorem sevenClocksWithRhin {N k : Nat} (rhin : RhinBound)
    (base : verifiedHeight<N) (first : FirstContraction N k)
    (runs : oddRuns N k=90) (shift : N+1≤orbit N k)
    (six92 : Terras90.SixRunCapacity 92) (six146 : Terras90.SixRunCapacity 146)
    (noWeaver : ¬Terras88.HasWindow N k Terras88.q0Price Terras90Q0Price.floor146 5) :
    (k,oddCount N k)∈Terras90TwiceQ0.remaining ∧
      2^k*orbit N k=3^(oddCount N k)*N+additive N k :=
  remainingFromPhysical Terras90LogBrackets.certified rhin base first runs shift six92 six146 noWeaver

end Terras90Physical

#print axioms Terras90Physical.admissionWithRhin
#print axioms Terras90Physical.sevenClocksWithRhin
