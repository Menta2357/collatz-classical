import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity
import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrixChannelBounds
import CollatzClassical.KL2003.F3ReturnExcursionRealOperatorBridge

set_option maxHeartbeats 2000000
set_option maxRecDepth 100000

/-!
Forward right-vector certificate for the formula-generated F3 core.

Unlike the historical left certificate, this module follows the arithmetic
parent-to-child orientation of `FormulaEdge`.  The finite checker is entirely
Nat-valued.  Its transfer to `Real` uses only the already proved lower bounds
for the three channel weights.
-/

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3ForwardFormulaRightCertificate

open F3ExactCoreMatrix
open F3CoreArithmeticCodecPilotRepair
open F3CoreArithmeticCodecFullCoreIdentity
open F3RealOperatorBridge

def forwardRightWeights81 : Vector Nat 81 :=
  ⟨#[
    136, 81, 131, 80, 50, 129, 270, 26, 195,
    99, 40, 47, 147, 48, 132, 142, 25, 85,
    166, 78, 76, 105, 30, 212, 129, 31, 166,
    94, 62, 93, 86, 73, 127, 207, 30, 411,
    87, 49, 53, 100, 41, 190, 132, 44, 141,
    244, 39, 92, 71, 26, 412, 190, 21, 404,
    159, 122, 72, 100, 41, 156, 408, 24, 275,
    81, 43, 68, 83, 28, 269, 164, 30, 122,
    137, 57, 72, 90, 24, 270, 260, 27, 484
  ], by decide⟩

def forwardRightBlock (s : Fin 243) : Fin 81 :=
  ⟨s.1 / 3, by omega⟩

def forwardRightWeightNat (s : Fin 243) : Nat :=
  forwardRightWeights81.get (forwardRightBlock s)

def forwardRightWeight (s : Fin 243) : ℝ :=
  (forwardRightWeightNat s : ℝ)

def lowerChannelCoeff : Nat → Nat
  | 0 => 25000
  | 1 => 37989
  | 2 => 21060
  | _ => 0

def lowerForwardRowNat (s : Fin 243) : Nat :=
  (formulaCoreList.filter (fun e => e.source = s)).foldr
    (fun e acc =>
      lowerChannelCoeff e.channel * forwardRightWeightNat e.target + acc) 0

def forwardRightNatCertificate : Prop :=
  ∀ s : Fin 243,
    82500 * forwardRightWeightNat s ≤ lowerForwardRowNat s

theorem forwardRightNatCertificate_proved : forwardRightNatCertificate := by
  decide

theorem lowerChannelCoeff_le_channelWeight (c : Nat) :
    (lowerChannelCoeff c : ℝ) / 81000 ≤ channelWeight c := by
  cases c with
  | zero =>
      rw [exact_channelWeight_zero_eq]
      norm_num [lowerChannelCoeff]
  | succ c =>
      cases c with
      | zero =>
          convert exact_channelWeight_one_lower using 1 <;>
            norm_num [lowerChannelCoeff]
      | succ c =>
          cases c with
          | zero =>
              convert exact_channelWeight_two_lower using 1 <;>
                norm_num [lowerChannelCoeff]
          | succ c => simp [lowerChannelCoeff, channelWeight]

theorem forwardRightWeight_nonneg (s : Fin 243) :
    0 ≤ forwardRightWeight s := by
  unfold forwardRightWeight
  positivity

def listRowAction
    (edges : List CoreEdge) (s : Fin 243) (w : Fin 243 → ℝ) : ℝ :=
  (edges.filter (fun e => e.source = s)).foldr
    (fun e acc => channelWeight e.channel * w e.target + acc) 0

def listMatrix
    (edges : List CoreEdge) (s t : Fin 243) : ℝ :=
  (edges.filter (fun e => e.source = s ∧ e.target = t)).foldr
    (fun e acc => channelWeight e.channel + acc) 0

theorem listRowAction_eq_matrix_sum
    (edges : List CoreEdge) (s : Fin 243) (w : Fin 243 → ℝ) :
    listRowAction edges s w =
      ∑ t : Fin 243, listMatrix edges s t * w t := by
  classical
  induction edges with
  | nil => simp [listRowAction, listMatrix]
  | cons e es ih =>
      by_cases hs : e.source = s
      · have hrow :
          listRowAction (e :: es) s w =
            channelWeight e.channel * w e.target + listRowAction es s w := by
          simp [listRowAction, hs]
        have hmatrix (t : Fin 243) :
            listMatrix (e :: es) s t =
              (if e.target = t then channelWeight e.channel else 0) +
                listMatrix es s t := by
          by_cases ht : e.target = t <;>
            simp [listMatrix, hs, ht]
        rw [hrow, ih]
        simp_rw [hmatrix, add_mul]
        rw [Finset.sum_add_distrib]
        simp
      · simpa [listRowAction, listMatrix, hs] using ih

theorem lowerListRow_le_actual
    (edges : List CoreEdge) :
    (((edges.foldr
      (fun e acc =>
        lowerChannelCoeff e.channel * forwardRightWeightNat e.target + acc)
      0 : Nat) : ℝ) / 81000) ≤
      edges.foldr
        (fun e acc =>
          channelWeight e.channel * forwardRightWeight e.target + acc) 0 := by
  induction edges with
  | nil => norm_num
  | cons e es ih =>
      simp only [List.foldr]
      have hc := lowerChannelCoeff_le_channelWeight e.channel
      have hw := forwardRightWeight_nonneg e.target
      calc
        ((↑(lowerChannelCoeff e.channel * forwardRightWeightNat e.target +
              es.foldr
                (fun e acc => lowerChannelCoeff e.channel *
                  forwardRightWeightNat e.target + acc) 0) : ℝ) /
            81000) =
            ((lowerChannelCoeff e.channel : ℝ) / 81000) *
                forwardRightWeight e.target +
              ((es.foldr
                (fun e acc => lowerChannelCoeff e.channel *
                  forwardRightWeightNat e.target + acc) 0 : Nat) : ℝ) /
                81000 := by
                  simp only [Nat.cast_add, Nat.cast_mul]
                  unfold forwardRightWeight
                  ring
        _ ≤ channelWeight e.channel * forwardRightWeight e.target +
              es.foldr
                (fun e acc =>
                  channelWeight e.channel * forwardRightWeight e.target + acc)
                0 := by
                  exact add_le_add (mul_le_mul_of_nonneg_right hc hw) ih

theorem forward_target_le_lower_row (s : Fin 243) :
    (55 / 54 : ℝ) * forwardRightWeight s ≤
      (lowerForwardRowNat s : ℝ) / 81000 := by
  have hcert : ∀ s : Fin 243,
      82500 * forwardRightWeightNat s ≤ lowerForwardRowNat s := by
    simpa only [forwardRightNatCertificate] using
      forwardRightNatCertificate_proved
  have hnat := hcert s
  have hcast :
      ((82500 * forwardRightWeightNat s : Nat) : ℝ) ≤
        (lowerForwardRowNat s : ℝ) := by
    exact_mod_cast hnat
  have hdiv :=
    (div_le_div_iff_of_pos_right (by norm_num : (0 : ℝ) < 81000)).2 hcast
  calc
    (55 / 54 : ℝ) * forwardRightWeight s =
        ((82500 * forwardRightWeightNat s : Nat) : ℝ) /
          81000 := by
            simp only [Nat.cast_mul, Nat.cast_ofNat]
            unfold forwardRightWeight
            ring
    _ ≤ (lowerForwardRowNat s : ℝ) / 81000 := hdiv

def formulaForwardMatrix (s t : Fin 243) : ℝ :=
  fullFormulaMatrix s t

theorem coreMatrix_eq_formulaForwardMatrix (s t : Fin 243) :
    coreMatrix s t = formulaForwardMatrix s t := by
  exact coreMatrix_eq_fullFormulaMatrix s t

theorem formulaForwardMatrix_nonneg (s t : Fin 243) :
    0 ≤ formulaForwardMatrix s t := by
  rw [← coreMatrix_eq_formulaForwardMatrix]
  exact coreMatrix_nonneg s t

theorem formulaForwardMatrix_row_action_identity
    (s : Fin 243) (w : Fin 243 → ℝ) :
    listRowAction formulaCoreList s w =
      ∑ t : Fin 243, formulaForwardMatrix s t * w t := by
  simpa [formulaForwardMatrix, fullFormulaMatrix, listMatrix] using
    listRowAction_eq_matrix_sum formulaCoreList s w

theorem forwardFormula_row_certificate (s : Fin 243) :
    (55 / 54 : ℝ) * forwardRightWeight s ≤
      ∑ t : Fin 243, formulaForwardMatrix s t * forwardRightWeight t := by
  have hlower := lowerListRow_le_actual
    (formulaCoreList.filter (fun e => e.source = s))
  have htarget := forward_target_le_lower_row s
  calc
    (55 / 54 : ℝ) * forwardRightWeight s ≤
        (lowerForwardRowNat s : ℝ) / 81000 := htarget
    _ ≤ listRowAction formulaCoreList s forwardRightWeight := by
      simpa [lowerForwardRowNat, listRowAction] using hlower
    _ = ∑ t : Fin 243,
        formulaForwardMatrix s t * forwardRightWeight t := by
      exact formulaForwardMatrix_row_action_identity s forwardRightWeight

theorem forward_weighted_mass_step
    (μ : Fin 243 → ℝ) (hμ : ∀ s, 0 ≤ μ s) :
    (55 / 54 : ℝ) * weightedMass forwardRightWeight μ ≤
      weightedMass forwardRightWeight (push formulaForwardMatrix μ) := by
  have hstep := weighted_mass_push_lower_bound
    (δ := (1 / 54 : ℝ)) formulaForwardMatrix forwardRightWeight μ
    (fun s => by
      norm_num
      exact forwardFormula_row_certificate s)
    hμ
  norm_num at hstep ⊢
  exact hstep

/-!
Scope: this is a forward operator certificate only.  It proves no first-hit
inequality, boundary estimate, F3 exponent, density theorem or Collatz claim.
-/

end F3ForwardFormulaRightCertificate
end KL2003
end CollatzClassical
