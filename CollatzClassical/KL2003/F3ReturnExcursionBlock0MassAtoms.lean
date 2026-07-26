import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveChannelIntervals

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
The owner-preserving mass atomization for the active Block0 carrier.

Each active occurrence `p` is split into exactly `ceil (qHi p)` equal atoms.
This module does not select retained atoms, define boundary atoms, or inspect
any semantic predecessor or first-hit fibre.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0MassAtoms

noncomputable section

open F3Block0ActiveCarrier
open F3Block0ActiveWeight
open F3Block0ActiveChannelIntervals

/-- The exact integral demand attached to one active occurrence. -/
def massDemand (p : Active0Occurrence) : Nat :=
  Nat.ceil (qHi p)

theorem one_le_massDemand (p : Active0Occurrence) :
    1 ≤ massDemand p := by
  exact Nat.ceil_pos.2 (qHi_pos p)

theorem massDemand_pos (p : Active0Occurrence) :
    0 < massDemand p :=
  Nat.zero_lt_of_lt (one_le_massDemand p)

theorem qHi_le_massDemand (p : Active0Occurrence) :
    qHi p ≤ (massDemand p : ℝ) := by
  exact Nat.le_ceil (qHi p)

theorem activeContribution_le_massDemand (p : Active0Occurrence) :
    activeContribution p ≤ (massDemand p : ℝ) :=
  (activeContribution_le_qHi p).trans (qHi_le_massDemand p)

/-- Owner-tagged equal atoms.  The owner remains part of the type. -/
abbrev MassAtom0 :=
  Sigma (fun p : Active0Occurrence => Fin (massDemand p))

/-- The equal share carried by one atom of its owner's contribution. -/
def atomMass (a : MassAtom0) : ℝ :=
  activeContribution a.1 / (massDemand a.1 : ℝ)

theorem atomMass_pos (a : MassAtom0) :
    0 < atomMass a := by
  exact div_pos (activeContribution_pos a.1) (by
    exact_mod_cast massDemand_pos a.1)

theorem atomMass_nonneg (a : MassAtom0) :
    0 ≤ atomMass a :=
  (atomMass_pos a).le

theorem atomMass_le_one (a : MassAtom0) :
    atomMass a ≤ 1 := by
  apply (div_le_one (by exact_mod_cast massDemand_pos a.1)).2
  exact activeContribution_le_massDemand a.1

/-- Splitting an owner into its demanded number of equal atoms preserves its
contribution exactly. -/
theorem sum_atomMass_owner (p : Active0Occurrence) :
    (∑ k : Fin (massDemand p), atomMass ⟨p, k⟩) =
      activeContribution p := by
  have hne : (massDemand p : ℝ) ≠ 0 := by
    exact_mod_cast (massDemand_pos p).ne'
  simpa [atomMass] using
    (mul_div_cancel₀ (activeContribution p) hne)

end

/-!
No atom is classified as retained or boundary here.  In particular, this
module contains no orbit execution, predecessor enumeration, first-hit
statement, or semantic capacity claim.
-/

end F3Block0MassAtoms
end KL2003
end CollatzClassical
