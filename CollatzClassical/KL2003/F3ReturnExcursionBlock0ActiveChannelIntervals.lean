import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveWeight
import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrixChannelBounds

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Exact rational intervals for the three F3 channel coefficients used by the
active Block0 carrier.

The upper estimate is deliberately split into two integer certificates:
`3^41 < 2^65`, which bounds `log 3 / log 2`, and
`(9/5)^24 < (1413/1000)^41`, which bounds the remaining real power.  Thus no
decimal approximation or native evaluator enters the public proof.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveChannelIntervals

noncomputable section

open F3ChannelBounds
open F3ExactCoreMatrix
open F3CoreArithmeticCodecPilotRepair
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3Block0ActiveWeight
open F3ForwardFormulaRightCertificate

theorem alpha_upper_bound_65_41 :
    alphaF3 < (65 / 41 : ℝ) := by
  have key : Real.log ((3 : ℝ) ^ 41) < Real.log ((2 : ℝ) ^ 65) :=
    Real.log_lt_log (by positivity) (by norm_num)
  rw [Real.log_pow, Real.log_pow] at key
  have hscaled :
      Real.log (3 : ℝ) < (65 / 41 : ℝ) * Real.log (2 : ℝ) := by
    calc
      Real.log (3 : ℝ) =
          ((41 : ℝ) * Real.log (3 : ℝ)) / 41 := by ring
      _ < ((65 : ℝ) * Real.log (2 : ℝ)) / 41 :=
        (div_lt_div_iff_of_pos_right (by norm_num : (0 : ℝ) < 41)).2 key
      _ = (65 / 41 : ℝ) * Real.log (2 : ℝ) := by ring
  unfold alphaF3
  exact
    (div_lt_iff₀ (Real.log_pos (by norm_num : (1 : ℝ) < 2))).2 hscaled

theorem rhoStar_rpow_twentyfour_fortyone_upper :
    Real.rpow rhoStarF3 (24 / 41 : ℝ) < (1413 / 1000 : ℝ) := by
  have hpow_nat :
      rhoStarF3 ^ 24 < (1413 / 1000 : ℝ) ^ 41 := by
    norm_num [rhoStarF3]
  have hpow :
      (Real.rpow rhoStarF3 (24 / 41 : ℝ)) ^ (41 : ℝ) <
        (1413 / 1000 : ℝ) ^ (41 : ℝ) := by
    calc
      (Real.rpow rhoStarF3 (24 / 41 : ℝ)) ^ (41 : ℝ) =
          Real.rpow rhoStarF3 ((24 / 41 : ℝ) * 41) := by
            exact (Real.rpow_mul rhoStar_pos_f3.le _ _).symm
      _ = rhoStarF3 ^ 24 := by norm_num
      _ < (1413 / 1000 : ℝ) ^ 41 := hpow_nat
      _ = (1413 / 1000 : ℝ) ^ (41 : ℝ) := by norm_num
  exact
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg rhoStar_pos_f3.le _)
      (by positivity : 0 ≤ (1413 / 1000 : ℝ))
      (by norm_num : 0 < (41 : ℝ))).1 hpow

theorem channelWeight_one_upper :
    channelWeightF3 1 < (471 / 1000 : ℝ) := by
  have hexp : alphaF3 - 1 < (24 / 41 : ℝ) := by
    linarith [alpha_upper_bound_65_41]
  have hmono :=
    Real.rpow_lt_rpow_of_exponent_lt rhoStar_gt_one_f3 hexp
  have hpow :
      Real.rpow rhoStarF3 (alphaF3 - 1) < (1413 / 1000 : ℝ) :=
    lt_trans hmono rhoStar_rpow_twentyfour_fortyone_upper
  have hscaled :=
    div_lt_div_of_pos_right hpow (by norm_num : (0 : ℝ) < 3)
  have htarget :
      (471 / 1000 : ℝ) = (1413 / 1000 : ℝ) / 3 := by norm_num
  dsimp [channelWeightF3]
  rw [htarget]
  exact hscaled

theorem channelWeight_two_upper :
    channelWeightF3 2 < (157 / 600 : ℝ) := by
  rw [channelWeight_two_eq_channelWeight_one_div_rho]
  have hdiv :=
    div_lt_div_of_pos_right channelWeight_one_upper rhoStar_pos_f3
  norm_num [rhoStarF3] at hdiv ⊢
  exact hdiv

theorem exact_channelWeight_one_upper :
    channelWeight 1 < (471 / 1000 : ℝ) := by
  simpa [channelWeight, rhoStar, alpha, channelWeightF3, rhoStarF3, alphaF3] using
    channelWeight_one_upper

theorem exact_channelWeight_two_upper :
    channelWeight 2 < (157 / 600 : ℝ) := by
  simpa [channelWeight, rhoStar, alpha, channelWeightF3, rhoStarF3, alphaF3] using
    channelWeight_two_upper

/-- Frozen rational lower endpoint for a formula channel. -/
def channelLo : Nat → ℝ
  | 0 => 25 / 81
  | 1 => 469 / 1000
  | 2 => 13 / 50
  | _ => 0

/-- Frozen rational upper endpoint for a formula channel. -/
def channelHi : Nat → ℝ
  | 0 => 25 / 81
  | 1 => 471 / 1000
  | 2 => 157 / 600
  | _ => 0

theorem formulaChannel_interval (e : FormulaEdge) :
    channelLo (formulaChannelNat e) ≤
        channelWeight (formulaChannelNat e) ∧
      channelWeight (formulaChannelNat e) ≤
        channelHi (formulaChannelNat e) := by
  cases e with
  | retarded s =>
      simp [formulaChannelNat, channelLo, channelHi,
        exact_channelWeight_zero_eq]
  | advancedDirect s ell =>
      constructor
      · simpa [formulaChannelNat, channelLo] using exact_channelWeight_one_lower
      · exact le_of_lt (by
          simpa [formulaChannelNat, channelHi] using exact_channelWeight_one_upper)
  | advancedParityLift s ell =>
      constructor
      · simpa [formulaChannelNat, channelLo] using exact_channelWeight_two_lower
      · exact le_of_lt (by
          simpa [formulaChannelNat, channelHi] using exact_channelWeight_two_upper)

theorem formulaChannelLo_pos (e : FormulaEdge) :
    0 < channelLo (formulaChannelNat e) := by
  cases e <;> norm_num [formulaChannelNat, channelLo]

/-- Rational lower bound for one active contribution, expressed only using
the finite Nat right vector and the frozen channel endpoint. -/
def qLo (p : Active0Occurrence) : ℝ :=
  let e := occurrenceFormulaEdge p.1
  activeMultiplicity e * channelLo (formulaChannelNat e) *
      (forwardRightWeightNat (formulaTarget e) : ℝ) /
      (forwardRightWeightNat (formulaSource e) : ℝ)

/-- Rational upper bound for one active contribution, expressed only using
the finite Nat right vector and the frozen channel endpoint. -/
def qHi (p : Active0Occurrence) : ℝ :=
  let e := occurrenceFormulaEdge p.1
  activeMultiplicity e * channelHi (formulaChannelNat e) *
      (forwardRightWeightNat (formulaTarget e) : ℝ) /
      (forwardRightWeightNat (formulaSource e) : ℝ)

theorem qLo_le_activeContribution (p : Active0Occurrence) :
    qLo p ≤ activeContribution p := by
  let e := occurrenceFormulaEdge p.1
  have hchannel := (formulaChannel_interval e).1
  have hfactor : 0 ≤ activeMultiplicity e := (activeMultiplicity_pos e).le
  have htarget :
      0 ≤ (forwardRightWeightNat (formulaTarget e) : ℝ) := by positivity
  have hnum :
      activeMultiplicity e * channelLo (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) ≤
        activeMultiplicity e * channelWeight (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) := by
    exact mul_le_mul_of_nonneg_right
      (mul_le_mul_of_nonneg_left hchannel hfactor) htarget
  have hden :
      0 ≤ (forwardRightWeightNat (formulaSource e) : ℝ) := by positivity
  unfold qLo activeContribution
  change
    activeMultiplicity e * channelLo (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) /
        (forwardRightWeightNat (formulaSource e) : ℝ) ≤
      activeMultiplicity e * channelWeight (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) /
        (forwardRightWeightNat (formulaSource e) : ℝ)
  exact div_le_div_of_nonneg_right hnum hden

theorem qLo_pos (p : Active0Occurrence) : 0 < qLo p := by
  let e := occurrenceFormulaEdge p.1
  have htarget :
      0 < (forwardRightWeightNat (formulaTarget e) : ℝ) := by
    exact_mod_cast forwardRightWeightNat_pos (formulaTarget e)
  have hsource :
      0 < (forwardRightWeightNat (formulaSource e) : ℝ) := by
    exact_mod_cast forwardRightWeightNat_pos (formulaSource e)
  unfold qLo
  change
    0 < activeMultiplicity e * channelLo (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) /
        (forwardRightWeightNat (formulaSource e) : ℝ)
  exact div_pos
    (mul_pos
      (mul_pos (activeMultiplicity_pos e) (formulaChannelLo_pos e))
      htarget)
    hsource

theorem activeContribution_le_qHi (p : Active0Occurrence) :
    activeContribution p ≤ qHi p := by
  let e := occurrenceFormulaEdge p.1
  have hchannel := (formulaChannel_interval e).2
  have hfactor : 0 ≤ activeMultiplicity e := (activeMultiplicity_pos e).le
  have htarget :
      0 ≤ (forwardRightWeightNat (formulaTarget e) : ℝ) := by positivity
  have hnum :
      activeMultiplicity e * channelWeight (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) ≤
        activeMultiplicity e * channelHi (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) := by
    exact mul_le_mul_of_nonneg_right
      (mul_le_mul_of_nonneg_left hchannel hfactor) htarget
  have hden :
      0 ≤ (forwardRightWeightNat (formulaSource e) : ℝ) := by positivity
  unfold qHi activeContribution
  change
    activeMultiplicity e * channelWeight (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) /
        (forwardRightWeightNat (formulaSource e) : ℝ) ≤
      activeMultiplicity e * channelHi (formulaChannelNat e) *
          (forwardRightWeightNat (formulaTarget e) : ℝ) /
        (forwardRightWeightNat (formulaSource e) : ℝ)
  exact div_le_div_of_nonneg_right hnum hden

theorem q_interval (p : Active0Occurrence) :
    qLo p ≤ activeContribution p ∧ activeContribution p ≤ qHi p :=
  ⟨qLo_le_activeContribution p, activeContribution_le_qHi p⟩

theorem qLo_le_qHi (p : Active0Occurrence) : qLo p ≤ qHi p :=
  le_trans (qLo_le_activeContribution p) (activeContribution_le_qHi p)

theorem qHi_pos (p : Active0Occurrence) : 0 < qHi p :=
  lt_of_lt_of_le (activeContribution_pos p) (activeContribution_le_qHi p)

end

end F3Block0ActiveChannelIntervals
end KL2003
end CollatzClassical
