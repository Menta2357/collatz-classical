import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveCarrier
import CollatzClassical.KL2003.F3ReturnExcursionForwardFormulaRightCertificate

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Positive normalization and the one-layer contribution attached to the active
Block0 carrier.

The finite positivity certificate below checks only the 81 explicit entries
of the forward right vector.  The advanced multiplicity `3` is defined in one
place and is not part of the carrier cardinality or of the matrix itself.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveWeight

noncomputable section

open F3ExactCoreMatrix
open F3CoreArithmeticCodecPilotRepair
open F3Block0CarrierFibers
open F3Block0CarrierStateCards
open F3Block0ActiveCarrier
open F3ForwardFormulaRightCertificate

theorem forwardRightWeights81_get_pos :
    ∀ j : Fin 81, 0 < forwardRightWeights81.get j := by
  decide

theorem forwardRightWeightNat_pos (s : Fin 243) :
    0 < forwardRightWeightNat s := by
  exact forwardRightWeights81_get_pos (forwardRightBlock s)

theorem forwardRightWeight_pos (s : Fin 243) :
    0 < forwardRightWeight s := by
  unfold forwardRightWeight
  exact_mod_cast forwardRightWeightNat_pos s

theorem stateFiber_card_pos (s : Fin 243) :
    0 < (stateFiber s).card := by
  rw [stateFiber_card]
  split <;> omega

/-- One concrete root is normalized to one unit of initial weighted mass. -/
def initialUnitMass (s : Fin 243) : ℝ :=
  ((stateFiber s).card : ℝ) / forwardRightWeight s

theorem initialUnitMass_pos (s : Fin 243) :
    0 < initialUnitMass s := by
  apply div_pos
  · exact_mod_cast stateFiber_card_pos s
  · exact forwardRightWeight_pos s

/-- The unique compensation for retaining one of the three advanced
fine-lift occurrences attached to a concrete root. -/
def activeMultiplicity : FormulaEdge → ℝ
  | .retarded _ => 1
  | .advancedDirect _ _ => 3
  | .advancedParityLift _ _ => 3

@[simp] theorem activeMultiplicity_retarded (s : Fin 243) :
    activeMultiplicity (.retarded s) = 1 := rfl

@[simp] theorem activeMultiplicity_advancedDirect
    (s : DirectSource) (ell : Fin 3) :
    activeMultiplicity (.advancedDirect s ell) = 3 := rfl

@[simp] theorem activeMultiplicity_advancedParityLift
    (s : LiftSource) (ell : Fin 3) :
    activeMultiplicity (.advancedParityLift s ell) = 3 := rfl

theorem activeMultiplicity_pos (e : FormulaEdge) :
    0 < activeMultiplicity e := by
  cases e <;> norm_num [activeMultiplicity]

theorem formulaChannelWeight_pos (e : FormulaEdge) :
    0 < channelWeight (formulaChannelNat e) := by
  cases e with
  | retarded s =>
      have h := lowerChannelCoeff_le_channelWeight 0
      norm_num [lowerChannelCoeff, formulaChannelNat] at h ⊢
      linarith
  | advancedDirect s ell =>
      have h := lowerChannelCoeff_le_channelWeight 1
      norm_num [lowerChannelCoeff, formulaChannelNat] at h ⊢
      linarith
  | advancedParityLift s ell =>
      have h := lowerChannelCoeff_le_channelWeight 2
      norm_num [lowerChannelCoeff, formulaChannelNat] at h ⊢
      linarith

/-- Contribution of one active root-tagged formula occurrence.  The literal
advanced factor enters exactly once, through `activeMultiplicity`. -/
def activeContribution (p : Active0Occurrence) : ℝ :=
  let e := occurrenceFormulaEdge p.1
  activeMultiplicity e *
      channelWeight (formulaChannelNat e) *
      forwardRightWeight (formulaTarget e) /
      forwardRightWeight (formulaSource e)

theorem activeContribution_pos (p : Active0Occurrence) :
    0 < activeContribution p := by
  unfold activeContribution
  exact div_pos
    (mul_pos
      (mul_pos
        (activeMultiplicity_pos (occurrenceFormulaEdge p.1))
        (formulaChannelWeight_pos (occurrenceFormulaEdge p.1)))
      (forwardRightWeight_pos
        (formulaTarget (occurrenceFormulaEdge p.1))))
    (forwardRightWeight_pos
      (formulaSource (occurrenceFormulaEdge p.1)))

end

/-!
This module proves only positivity and defines the audited one-layer summand.
It does not assert that the active sum equals an operator output, nor that an
active occurrence has a first-hit fibre.
-/

end F3Block0ActiveWeight
end KL2003
end CollatzClassical
