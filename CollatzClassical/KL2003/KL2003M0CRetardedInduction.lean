import CollatzClassical.KL2003.KL2003K2CertificateVerifier
import CollatzClassical.KL2003.KL2003K2TranscendentalEndpoints
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.Order.Floor.Semiring
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

namespace CollatzClassical
namespace KL2003

/-!
Abstract retarded-induction layer for the KL2003 k=2 M0C step.

This file deliberately does not import the counting semantics, M0B tree
semantics, the scaling seam, or a rounding ledger.  It formalizes the abstract
Phi-system contract, seam-v2 parameters, EL row hypotheses, and the elementary
rank/shift facts that a later induction proof will consume.
-/

structure K2PhiSystem where
  phi22 : Real -> Real
  phi25 : Real -> Real
  phi28 : Real -> Real

noncomputable def c22R : Real := (73 / 40 : Real)
noncomputable def c25R : Real := (1001 / 1000 : Real)
noncomputable def c28R : Real := (69 / 40 : Real)
def c12R : Real := (1 : Real)

noncomputable def deltaM0C : Real := 5 - 3 * alpha

noncomputable def DeltaV2 : Real := 1 / (2 * lambdaR ^ (14 : Real))

noncomputable def retardedRank (y : Real) : Nat :=
  Nat.ceil (y / deltaM0C)

def shiftMinusTwo : Real := -2
noncomputable def shiftAlphaMinusTwo : Real := alpha - 2
noncomputable def shiftAlphaMinusThree : Real := alpha - 3
noncomputable def shiftTwoAlphaMinusFive : Real := 2 * alpha - 5
noncomputable def shiftThreeAlphaMinusFive : Real := 3 * alpha - 5

def min3 (a b c : Real) : Real := min a (min b c)

noncomputable def M2 (Phi : K2PhiSystem) (y : Real) : Real :=
  min3
    (Phi.phi22 (y + 3 * alpha - 5))
    (Phi.phi25 (y + 3 * alpha - 5))
    (Phi.phi28 (y + 3 * alpha - 5))

noncomputable def M1 (Phi : K2PhiSystem) (y : Real) : Real :=
  min
    (Phi.phi28 (y + 2 * alpha - 5) + M2 Phi y)
    (Phi.phi22 (y + 2 * alpha - 5))

def K2PhiZeroExtension (Phi : K2PhiSystem) : Prop :=
  forall y, y < 0 ->
    Phi.phi22 y = 0 /\
    Phi.phi25 y = 0 /\
    Phi.phi28 y = 0

structure I2ELAbstractRows (Phi : K2PhiSystem) : Prop where
  row22 :
    forall y,
      Phi.phi28 (y - 2)
        + min3
            (Phi.phi22 (y + alpha - 2))
            (Phi.phi25 (y + alpha - 2))
            (Phi.phi28 (y + alpha - 2))
        <= Phi.phi22 y
  row25 :
    forall y,
      Phi.phi22 (y - 2) <= Phi.phi25 y
  row28EL :
    forall y,
      Phi.phi25 (y - 2)
        + min
            (Phi.phi28 (y + alpha - 3) + M1 Phi y)
            (Phi.phi22 (y + alpha - 3))
        <= Phi.phi28 y

def BaseSegmentLowerBound (Phi : K2PhiSystem) : Prop :=
  forall y, 0 <= y -> y < 14 ->
    DeltaV2 * lambdaR ^ y <= Phi.phi22 y /\
    DeltaV2 * lambdaR ^ y <= Phi.phi25 y /\
    DeltaV2 * lambdaR ^ y <= Phi.phi28 y

structure K2RetardedInductionInputs (Phi : K2PhiSystem) : Prop where
  certificate :
    K2InteriorCertificateData.ValidData k2CertificateData
  endpointsB :
    (119 / 135 : Real) <= BReal /\ BReal <= (8 / 9 : Real)
  endpointsD :
    (119 / 100 : Real) <= DReal /\ DReal <= (6 / 5 : Real)
  zeroExtension :
    K2PhiZeroExtension Phi
  base :
    BaseSegmentLowerBound Phi
  rows :
    I2ELAbstractRows Phi

def Phi22LowerBoundAt (Phi : K2PhiSystem) (y : Real) : Prop :=
  DeltaV2 * c22R * lambdaR ^ y <= Phi.phi22 y

def Phi25LowerBoundAt (Phi : K2PhiSystem) (y : Real) : Prop :=
  DeltaV2 * c25R * lambdaR ^ y <= Phi.phi25 y

def Phi28LowerBoundAt (Phi : K2PhiSystem) (y : Real) : Prop :=
  DeltaV2 * c28R * lambdaR ^ y <= Phi.phi28 y

def RetardedLowerBoundConclusion (Phi : K2PhiSystem) : Prop :=
  forall y, 14 <= y ->
    Phi22LowerBoundAt Phi y /\
    Phi25LowerBoundAt Phi y /\
    Phi28LowerBoundAt Phi y

def BaseSegmentWeightedLowerBound (Phi : K2PhiSystem) : Prop :=
  forall y, 0 <= y -> y < 14 ->
    Phi22LowerBoundAt Phi y /\
    Phi25LowerBoundAt Phi y /\
    Phi28LowerBoundAt Phi y

theorem k2_retarded_inputs_from_closed_certificate
    (Phi : K2PhiSystem)
    (hzero : K2PhiZeroExtension Phi)
    (hbase : BaseSegmentLowerBound Phi)
    (hrows : I2ELAbstractRows Phi) :
    K2RetardedInductionInputs Phi := by
  exact
    { certificate := k2CertificateData_valid
      endpointsB := BReal_within_strong_interval
      endpointsD := DReal_within_target_interval
      zeroExtension := hzero
      base := hbase
      rows := hrows }

theorem baseSegment_phi22
    {Phi : K2PhiSystem} (hbase : BaseSegmentLowerBound Phi)
    {y : Real} (hy0 : 0 <= y) (hy14 : y < 14) :
    DeltaV2 * lambdaR ^ y <= Phi.phi22 y := by
  exact (hbase y hy0 hy14).1

theorem baseSegment_phi25
    {Phi : K2PhiSystem} (hbase : BaseSegmentLowerBound Phi)
    {y : Real} (hy0 : 0 <= y) (hy14 : y < 14) :
    DeltaV2 * lambdaR ^ y <= Phi.phi25 y := by
  exact (hbase y hy0 hy14).2.1

theorem baseSegment_phi28
    {Phi : K2PhiSystem} (hbase : BaseSegmentLowerBound Phi)
    {y : Real} (hy0 : 0 <= y) (hy14 : y < 14) :
    DeltaV2 * lambdaR ^ y <= Phi.phi28 y := by
  exact (hbase y hy0 hy14).2.2

theorem DeltaV2_pos : 0 < DeltaV2 := by
  dsimp [DeltaV2]
  have hpow : 0 < lambdaR ^ (14 : Real) := Real.rpow_pos_of_pos lambdaR_pos _
  positivity

theorem c22R_pos : 0 < c22R := by
  norm_num [c22R]

theorem c25R_pos : 0 < c25R := by
  norm_num [c25R]

theorem c28R_pos : 0 < c28R := by
  norm_num [c28R]

theorem c12R_eq_one : c12R = 1 := by
  rfl

theorem deltaM0C_pos : 0 < deltaM0C := by
  dsimp [deltaM0C]
  linarith [alpha_upper_bound]

theorem one_fifth_lt_deltaM0C : (1 / 5 : Real) < deltaM0C := by
  dsimp [deltaM0C]
  linarith [alpha_upper_bound]

theorem deltaM0C_le_two : deltaM0C <= 2 := by
  dsimp [deltaM0C]
  linarith [alpha_lower_bound]

theorem alpha_pos : 0 < alpha := by
  linarith [alpha_lower_bound]

theorem alpha_nonneg : 0 <= alpha := by
  exact alpha_pos.le

theorem one_le_alpha : (1 : Real) <= alpha := by
  linarith [alpha_lower_bound]

theorem three_halves_le_alpha : (3 / 2 : Real) <= alpha := by
  linarith [alpha_lower_bound]

theorem shift_minus_two_le_neg_deltaM0C :
    shiftMinusTwo <= -deltaM0C := by
  dsimp [shiftMinusTwo, deltaM0C]
  linarith [one_le_alpha]

theorem shift_alpha_minus_two_le_neg_deltaM0C :
    shiftAlphaMinusTwo <= -deltaM0C := by
  dsimp [shiftAlphaMinusTwo, deltaM0C]
  linarith [three_halves_le_alpha]

theorem shift_alpha_minus_three_le_neg_deltaM0C :
    shiftAlphaMinusThree <= -deltaM0C := by
  dsimp [shiftAlphaMinusThree, deltaM0C]
  linarith [one_le_alpha]

theorem shift_two_alpha_minus_five_le_neg_deltaM0C :
    shiftTwoAlphaMinusFive <= -deltaM0C := by
  dsimp [shiftTwoAlphaMinusFive, deltaM0C]
  linarith [alpha_nonneg]

theorem shift_three_alpha_minus_five_eq_neg_deltaM0C :
    shiftThreeAlphaMinusFive = -deltaM0C := by
  dsimp [shiftThreeAlphaMinusFive, deltaM0C]
  ring_nf

theorem retardedRank_drop
    {y beta : Real}
    (hbeta : beta <= -deltaM0C)
    (hpos : 0 < retardedRank y) :
    retardedRank (y + beta) < retardedRank y := by
  dsimp [retardedRank]
  have hdelta : 0 < deltaM0C := deltaM0C_pos
  have hnum : y + beta <= y - deltaM0C := by
    linarith
  have hdiv0 :
      (y + beta) / deltaM0C <= (y - deltaM0C) / deltaM0C :=
    (div_le_div_iff_of_pos_right hdelta).2 hnum
  have hdiv_eq :
      (y - deltaM0C) / deltaM0C = y / deltaM0C - 1 := by
    field_simp [hdelta.ne']
  have hdiv :
      (y + beta) / deltaM0C <= y / deltaM0C - 1 := by
    simpa [hdiv_eq] using hdiv0
  have hceil :
      Nat.ceil ((y + beta) / deltaM0C) <=
        Nat.ceil (y / deltaM0C - 1) :=
    Nat.ceil_mono hdiv
  rw [Nat.ceil_sub_one] at hceil
  exact lt_of_le_of_lt hceil (Nat.sub_lt hpos (by norm_num))

theorem retardedRank_drop_minus_two
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y - 2) < retardedRank y := by
  simpa [sub_eq_add_neg] using
    (retardedRank_drop (y := y) (beta := (-2 : Real))
      (by simpa [shiftMinusTwo] using shift_minus_two_le_neg_deltaM0C) hpos)

theorem retardedRank_drop_alpha_minus_two
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + alpha - 2) < retardedRank y := by
  simpa [sub_eq_add_neg, add_assoc] using
    (retardedRank_drop (y := y) (beta := alpha - 2)
      (by simpa [shiftAlphaMinusTwo] using shift_alpha_minus_two_le_neg_deltaM0C) hpos)

theorem retardedRank_drop_alpha_minus_three
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + alpha - 3) < retardedRank y := by
  simpa [sub_eq_add_neg, add_assoc] using
    (retardedRank_drop (y := y) (beta := alpha - 3)
      (by simpa [shiftAlphaMinusThree] using shift_alpha_minus_three_le_neg_deltaM0C) hpos)

theorem retardedRank_drop_two_alpha_minus_five
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + 2 * alpha - 5) < retardedRank y := by
  simpa [sub_eq_add_neg, add_assoc] using
    (retardedRank_drop (y := y) (beta := 2 * alpha - 5)
      (by simpa [shiftTwoAlphaMinusFive] using shift_two_alpha_minus_five_le_neg_deltaM0C) hpos)

theorem retardedRank_drop_three_alpha_minus_five
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + 3 * alpha - 5) < retardedRank y := by
  have hle : 3 * alpha - 5 <= -deltaM0C := by
    simpa [shiftThreeAlphaMinusFive] using
      le_of_eq shift_three_alpha_minus_five_eq_neg_deltaM0C
  simpa [sub_eq_add_neg, add_assoc] using
    (retardedRank_drop (y := y) (beta := 3 * alpha - 5) hle hpos)

/-!
The full weighted conclusion needs a weighted base segment (or a semantic
root-count lemma strong enough to derive it).  The seam-v2 base hypothesis
above is intentionally the weaker documented input, so this module stops after
the abstract system and rank-descent layer.
-/

end KL2003
end CollatzClassical
