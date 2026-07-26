import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassAtoms

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Exact rational-envelope core of the Block0 mass-demand profile.

The real upper envelope `qHi` has one of three rational coefficients.  This
module records those coefficients as natural numerators and denominators,
proves that the resulting fraction is exactly `qHi`, and reduces its ceiling
to a two-valued finite shadow.  The constructor histograms and their assembly
live in separately named successor modules.

No first-hit fibre, orbit search, retained-set choice, or capacity assertion
enters this module.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0MassDemandProfile

noncomputable section

open F3CoreArithmeticCodecPilotRepair
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3Block0ActiveWeight
open F3Block0ActiveChannelIntervals
open F3Block0MassAtoms
open F3ForwardFormulaRightCertificate

/-! ## An exact natural fraction for `qHi` -/

/-- Numerator of the rational coefficient obtained after incorporating the
active advanced-channel multiplicity. -/
def qHiCoeffNum : FormulaEdge → Nat
  | .retarded _ => 25
  | .advancedDirect _ _ => 1413
  | .advancedParityLift _ _ => 157

/-- Denominator of the rational coefficient obtained after incorporating the
active advanced-channel multiplicity. -/
def qHiCoeffDen : FormulaEdge → Nat
  | .retarded _ => 81
  | .advancedDirect _ _ => 1000
  | .advancedParityLift _ _ => 200

/-- Natural numerator of the exact upper-envelope fraction attached to a
formula edge. -/
def qHiNumerator (e : FormulaEdge) : Nat :=
  qHiCoeffNum e * forwardRightWeightNat (formulaTarget e)

/-- Positive natural denominator of the exact upper-envelope fraction
attached to a formula edge. -/
def qHiDenominator (e : FormulaEdge) : Nat :=
  qHiCoeffDen e * forwardRightWeightNat (formulaSource e)

theorem qHiCoeffDen_pos (e : FormulaEdge) :
    0 < qHiCoeffDen e := by
  cases e <;> norm_num [qHiCoeffDen]

theorem qHiDenominator_pos (e : FormulaEdge) :
    0 < qHiDenominator e := by
  exact Nat.mul_pos (qHiCoeffDen_pos e)
    (forwardRightWeightNat_pos (formulaSource e))

/-- The natural fraction is not an approximation: it is definitionally the
same rational upper envelope after the three constructors are separated. -/
theorem qHi_eq_natural_fraction (p : Active0Occurrence) :
    qHi p =
      (qHiNumerator (occurrenceFormulaEdge p.1) : ℝ) /
        (qHiDenominator (occurrenceFormulaEdge p.1) : ℝ) := by
  let e := occurrenceFormulaEdge p.1
  change
    activeMultiplicity e * channelHi (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) /
        (forwardRightWeightNat (formulaSource e) : ℝ) =
      (qHiNumerator e : ℝ) / (qHiDenominator e : ℝ)
  have hsource :
      (forwardRightWeightNat (formulaSource e) : ℝ) ≠ 0 := by
    exact_mod_cast (forwardRightWeightNat_pos (formulaSource e)).ne'
  cases e <;>
    norm_num [qHiNumerator, qHiDenominator, qHiCoeffNum, qHiCoeffDen,
      activeMultiplicity, channelHi, formulaChannelNat] at hsource ⊢ <;>
    field_simp [hsource] <;>
    ring

/-! ## Uniform two-atom bound -/

/-- Complete finite arithmetic certificate behind the bound `qHi ≤ 2`.
It ranges over the 729 formula edges, before any root multiplicity is added. -/
theorem qHiNumerator_le_two_mul_denominator :
    ∀ e : FormulaEdge,
      qHiNumerator e ≤ 2 * qHiDenominator e := by
  decide

theorem qHi_le_two (p : Active0Occurrence) :
    qHi p ≤ 2 := by
  rw [qHi_eq_natural_fraction]
  have hden :
      (0 : ℝ) < qHiDenominator (occurrenceFormulaEdge p.1) := by
    exact_mod_cast qHiDenominator_pos (occurrenceFormulaEdge p.1)
  apply (div_le_iff₀ hden).2
  exact_mod_cast
    qHiNumerator_le_two_mul_denominator (occurrenceFormulaEdge p.1)

/-- Every active Block0 owner needs at most two equal mass atoms. -/
theorem massDemand_le_two (p : Active0Occurrence) :
    massDemand p ≤ 2 := by
  unfold massDemand
  exact (Nat.ceil_le).2 (qHi_le_two p)

/-! ## Computable two-valued shadow -/

/-- The exact ceiling can only be one or two.  Comparing the natural
numerator and denominator decides which value occurs without evaluating a
real number. -/
def massDemandShadow (e : FormulaEdge) : Nat :=
  if qHiNumerator e ≤ qHiDenominator e then 1 else 2

theorem qHi_le_one_of_numerator_le_denominator
    (p : Active0Occurrence)
    (h : qHiNumerator (occurrenceFormulaEdge p.1) ≤
      qHiDenominator (occurrenceFormulaEdge p.1)) :
    qHi p ≤ 1 := by
  rw [qHi_eq_natural_fraction]
  have hden :
      (0 : ℝ) < qHiDenominator (occurrenceFormulaEdge p.1) := by
    exact_mod_cast qHiDenominator_pos (occurrenceFormulaEdge p.1)
  exact (div_le_one hden).2 (by exact_mod_cast h)

theorem one_lt_qHi_of_denominator_lt_numerator
    (p : Active0Occurrence)
    (h : qHiDenominator (occurrenceFormulaEdge p.1) <
      qHiNumerator (occurrenceFormulaEdge p.1)) :
    1 < qHi p := by
  rw [qHi_eq_natural_fraction]
  have hden :
      (0 : ℝ) < qHiDenominator (occurrenceFormulaEdge p.1) := by
    exact_mod_cast qHiDenominator_pos (occurrenceFormulaEdge p.1)
  exact (one_lt_div hden).2 (by exact_mod_cast h)

/-- The two-valued natural shadow agrees exactly with the real ceiling in
`MassAtoms`. -/
theorem massDemand_eq_shadow (p : Active0Occurrence) :
    massDemand p = massDemandShadow (occurrenceFormulaEdge p.1) := by
  by_cases h : qHiNumerator (occurrenceFormulaEdge p.1) ≤
      qHiDenominator (occurrenceFormulaEdge p.1)
  · rw [massDemandShadow, if_pos h]
    unfold massDemand
    apply (Nat.ceil_eq_iff (by norm_num : (1 : Nat) ≠ 0)).2
    constructor
    · simpa using qHi_pos p
    · simpa only [Nat.cast_one] using
        qHi_le_one_of_numerator_le_denominator p h
  · rw [massDemandShadow, if_neg h]
    unfold massDemand
    apply (Nat.ceil_eq_iff (by norm_num : (2 : Nat) ≠ 0)).2
    constructor
    · simpa using one_lt_qHi_of_denominator_lt_numerator p
        (Nat.lt_of_not_ge h)
    · exact qHi_le_two p

end

/-!
Scope: this file proves only the exact rational-envelope core inherited by
the sharded demand profile.  It contains no histogram and does not show that
any demanded atom is served by a first-hit fibre.
-/

end F3Block0MassDemandProfile
end KL2003
end CollatzClassical
