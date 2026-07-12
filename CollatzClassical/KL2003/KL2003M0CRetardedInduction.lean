import CollatzClassical.KL2003.KL2003K2CertificateVerifier
import CollatzClassical.KL2003.KL2003K2TranscendentalEndpoints
import Mathlib.Analysis.Convex.SpecificFunctions.Basic
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

noncomputable def epsilon0 : Real := (1 / 10000 : Real)

noncomputable def shiftAlphaMinus2Pad : Real := alpha - 2 - epsilon0
noncomputable def shiftAlphaMinus1Pad : Real := alpha - 1 - epsilon0
noncomputable def shiftAlphaMinus3Pad : Real := alpha - 3 - epsilon0
noncomputable def shift2AlphaMinus5Pad2 : Real := 2 * alpha - 5 - 2 * epsilon0
noncomputable def shift3AlphaMinus5Pad3 : Real := 3 * alpha - 5 - 3 * epsilon0

def min3 (a b c : Real) : Real := min a (min b c)

theorem le_min3 {a b c t : Real} (ha : t <= a) (hb : t <= b) (hc : t <= c) :
    t <= min3 a b c := by
  dsimp [min3]
  exact le_min ha (le_min hb hc)

noncomputable def M2 (Phi : K2PhiSystem) (y : Real) : Real :=
  min3
    (Phi.phi22 (y + 3 * alpha - 5))
    (Phi.phi25 (y + 3 * alpha - 5))
    (Phi.phi28 (y + 3 * alpha - 5))

noncomputable def M1 (Phi : K2PhiSystem) (y : Real) : Real :=
  min
    (Phi.phi28 (y + 2 * alpha - 5) + M2 Phi y)
    (Phi.phi22 (y + 2 * alpha - 5))

noncomputable def M2V2 (Phi : K2PhiSystem) (y : Real) : Real :=
  min3
    (Phi.phi22 (y + shift3AlphaMinus5Pad3))
    (Phi.phi25 (y + shift3AlphaMinus5Pad3))
    (Phi.phi28 (y + shift3AlphaMinus5Pad3))

noncomputable def M1V2 (Phi : K2PhiSystem) (y : Real) : Real :=
  min
    (Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V2 Phi y)
    (Phi.phi22 (y + shift2AlphaMinus5Pad2))

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

/--
Seam-compatible epsilon-padded EL rows.  This contract is kept beside the
ideal/continuous `I2ELAbstractRows`; the main M0C input has not been switched
to V2 in this module.
-/
structure I2ELAbstractRowsV2 (Phi : K2PhiSystem) : Prop where
  row22 :
    forall y, 14 <= y ->
      Phi.phi28 (y - 2)
        + min3
            (Phi.phi22 (y + shiftAlphaMinus2Pad))
            (Phi.phi25 (y + shiftAlphaMinus2Pad))
            (Phi.phi28 (y + shiftAlphaMinus2Pad))
        <= Phi.phi22 y
  row25 :
    forall y, 14 <= y ->
      Phi.phi22 (y - 2) <= Phi.phi25 y
  row28EL :
    forall y, 14 <= y ->
      Phi.phi25 (y - 2)
        + min
            (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
            (Phi.phi22 (y + shiftAlphaMinus3Pad))
        <= Phi.phi28 y

def BaseSegmentLowerBound (Phi : K2PhiSystem) : Prop :=
  forall y, 0 <= y -> y < 14 ->
    DeltaV2 * lambdaR ^ y <= Phi.phi22 y /\
    DeltaV2 * lambdaR ^ y <= Phi.phi25 y /\
    DeltaV2 * lambdaR ^ y <= Phi.phi28 y

def BaseSegmentUnitLowerBound (Phi : K2PhiSystem) : Prop :=
  forall y, 0 <= y -> y <= 14 ->
    1 <= Phi.phi22 y /\
    1 <= Phi.phi25 y /\
    1 <= Phi.phi28 y

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

structure K2RetardedInductionInputs (Phi : K2PhiSystem) : Prop where
  certificate :
    K2InteriorCertificateData.ValidData k2CertificateData
  endpointsB :
    (119 / 135 : Real) <= BReal /\ BReal <= (8 / 9 : Real)
  endpointsD :
    (119 / 100 : Real) <= DReal /\ DReal <= (6 / 5 : Real)
  zeroExtension :
    K2PhiZeroExtension Phi
  weightedBase :
    BaseSegmentWeightedLowerBound Phi
  rows :
    I2ELAbstractRows Phi

structure K2RetardedInductionInputsV2 (Phi : K2PhiSystem) : Prop where
  certificate :
    K2InteriorCertificateData.ValidData k2CertificateData
  endpointsB :
    (119 / 135 : Real) <= BReal /\ BReal <= (8 / 9 : Real)
  endpointsD :
    (119 / 100 : Real) <= DReal /\ DReal <= (6 / 5 : Real)
  zeroExtension :
    K2PhiZeroExtension Phi
  weightedBase :
    BaseSegmentWeightedLowerBound Phi
  rowsV2 :
    I2ELAbstractRowsV2 Phi

theorem k2_retarded_inputs_from_closed_certificate
    (Phi : K2PhiSystem)
    (hzero : K2PhiZeroExtension Phi)
    (hweightedBase : BaseSegmentWeightedLowerBound Phi)
    (hrows : I2ELAbstractRows Phi) :
    K2RetardedInductionInputs Phi := by
  exact
    { certificate := k2CertificateData_valid
      endpointsB := BReal_within_strong_interval
      endpointsD := DReal_within_target_interval
      zeroExtension := hzero
      weightedBase := hweightedBase
      rows := hrows }

theorem k2_retarded_inputs_v2_from_closed_certificate
    (Phi : K2PhiSystem)
    (hzero : K2PhiZeroExtension Phi)
    (hweightedBase : BaseSegmentWeightedLowerBound Phi)
    (hrows : I2ELAbstractRowsV2 Phi) :
    K2RetardedInductionInputsV2 Phi := by
  exact
    { certificate := k2CertificateData_valid
      endpointsB := BReal_within_strong_interval
      endpointsD := DReal_within_target_interval
      zeroExtension := hzero
      weightedBase := hweightedBase
      rowsV2 := hrows }

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

theorem weightedBaseSegment_phi22
    {Phi : K2PhiSystem} (hbase : BaseSegmentWeightedLowerBound Phi)
    {y : Real} (hy0 : 0 <= y) (hy14 : y < 14) :
    Phi22LowerBoundAt Phi y := by
  exact (hbase y hy0 hy14).1

theorem weightedBaseSegment_phi25
    {Phi : K2PhiSystem} (hbase : BaseSegmentWeightedLowerBound Phi)
    {y : Real} (hy0 : 0 <= y) (hy14 : y < 14) :
    Phi25LowerBoundAt Phi y := by
  exact (hbase y hy0 hy14).2.1

theorem weightedBaseSegment_phi28
    {Phi : K2PhiSystem} (hbase : BaseSegmentWeightedLowerBound Phi)
    {y : Real} (hy0 : 0 <= y) (hy14 : y < 14) :
    Phi28LowerBoundAt Phi y := by
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

theorem c22R_le_two : c22R <= 2 := by
  norm_num [c22R]

theorem c25R_le_two : c25R <= 2 := by
  norm_num [c25R]

theorem c28R_le_two : c28R <= 2 := by
  norm_num [c28R]

theorem c12R_eq_one : c12R = 1 := by
  rfl

theorem lambdaR_rpow_le_pow_fourteen
    {y : Real} (hy14 : y <= 14) :
    lambdaR ^ y <= lambdaR ^ (14 : Real) := by
  exact Real.rpow_le_rpow_of_exponent_le lambdaR_gt_one.le hy14

theorem DeltaV2_mul_two_mul_lambdaR_pow_fourteen :
    DeltaV2 * 2 * lambdaR ^ (14 : Real) = 1 := by
  dsimp [DeltaV2]
  have hpow : lambdaR ^ (14 : Real) ≠ 0 :=
    (Real.rpow_pos_of_pos lambdaR_pos _).ne'
  have hden : 2 * lambdaR ^ (14 : Real) ≠ 0 := by
    exact mul_ne_zero (by norm_num) hpow
  calc
    (1 / (2 * lambdaR ^ (14 : Real))) * 2 * lambdaR ^ (14 : Real)
        = (1 / (2 * lambdaR ^ (14 : Real))) *
            (2 * lambdaR ^ (14 : Real)) := by ring
    _ = 1 := by
      simpa using (div_mul_cancel₀ (1 : Real) hden)

theorem DeltaV2_mul_coeff_mul_lambdaR_rpow_le_one
    {c y : Real}
    (_hc0 : 0 <= c) (hc2 : c <= 2)
    (_hy0 : 0 <= y) (hy14 : y <= 14) :
    DeltaV2 * c * lambdaR ^ y <= 1 := by
  have hD0 : 0 <= DeltaV2 := DeltaV2_pos.le
  have hpow_y0 : 0 <= lambdaR ^ y :=
    (Real.rpow_pos_of_pos lambdaR_pos _).le
  have hpow_le : lambdaR ^ y <= lambdaR ^ (14 : Real) :=
    lambdaR_rpow_le_pow_fourteen hy14
  calc
    DeltaV2 * c * lambdaR ^ y
        <= DeltaV2 * 2 * lambdaR ^ y := by
          exact mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_left hc2 hD0) hpow_y0
    _ <= DeltaV2 * 2 * lambdaR ^ (14 : Real) := by
          exact mul_le_mul_of_nonneg_left hpow_le
            (mul_nonneg hD0 (by norm_num))
    _ = 1 := DeltaV2_mul_two_mul_lambdaR_pow_fourteen

theorem DeltaV2_mul_c22R_mul_lambdaR_rpow_le_one
    {y : Real} (hy0 : 0 <= y) (hy14 : y <= 14) :
    DeltaV2 * c22R * lambdaR ^ y <= 1 := by
  exact DeltaV2_mul_coeff_mul_lambdaR_rpow_le_one
    c22R_pos.le c22R_le_two hy0 hy14

theorem DeltaV2_mul_c25R_mul_lambdaR_rpow_le_one
    {y : Real} (hy0 : 0 <= y) (hy14 : y <= 14) :
    DeltaV2 * c25R * lambdaR ^ y <= 1 := by
  exact DeltaV2_mul_coeff_mul_lambdaR_rpow_le_one
    c25R_pos.le c25R_le_two hy0 hy14

theorem DeltaV2_mul_c28R_mul_lambdaR_rpow_le_one
    {y : Real} (hy0 : 0 <= y) (hy14 : y <= 14) :
    DeltaV2 * c28R * lambdaR ^ y <= 1 := by
  exact DeltaV2_mul_coeff_mul_lambdaR_rpow_le_one
    c28R_pos.le c28R_le_two hy0 hy14

theorem base_weighted_of_unit
    {Phi : K2PhiSystem}
    (hunit : BaseSegmentUnitLowerBound Phi) :
    BaseSegmentWeightedLowerBound Phi := by
  intro y hy0 hy14
  have hy14le : y <= 14 := le_of_lt hy14
  have hunit_y := hunit y hy0 hy14le
  exact
    ⟨ (DeltaV2_mul_c22R_mul_lambdaR_rpow_le_one hy0 hy14le).trans hunit_y.1,
      (DeltaV2_mul_c25R_mul_lambdaR_rpow_le_one hy0 hy14le).trans hunit_y.2.1,
      (DeltaV2_mul_c28R_mul_lambdaR_rpow_le_one hy0 hy14le).trans hunit_y.2.2 ⟩

theorem epsilon0_pos : 0 < epsilon0 := by
  norm_num [epsilon0]

theorem epsilon0_nonneg : 0 <= epsilon0 :=
  epsilon0_pos.le

theorem epsilon0_lt_one : epsilon0 < 1 := by
  norm_num [epsilon0]

theorem lambdaR_cube_lt_four : lambdaR ^ (3 : Real) < 4 := by
  norm_num [lambdaR]

theorem pad_inv_power_ge_four :
    (4 : Real) <= (10000 / 9997 : Real) ^ (10000 : Real) := by
  have hbern :
      (1 : Real) + (10000 : Real) * (3 / 9997 : Real) <=
        ((1 : Real) + (3 / 9997 : Real)) ^ (10000 : Real) :=
    one_add_mul_self_le_rpow_one_add
      (s := (3 / 9997 : Real))
      (p := (10000 : Real))
      (by norm_num)
      (by norm_num)
  calc
    (4 : Real) <= (1 : Real) + (10000 : Real) * (3 / 9997 : Real) := by
      norm_num
    _ <= ((1 : Real) + (3 / 9997 : Real)) ^ (10000 : Real) := hbern
    _ = (10000 / 9997 : Real) ^ (10000 : Real) := by
      norm_num

theorem lambdaR_three_epsilon_le_pad_inv :
    lambdaR ^ (3 * epsilon0) <= (10000 / 9997 : Real) := by
  have hpow :
      (lambdaR ^ (3 * epsilon0)) ^ (10000 : Real) <=
        (10000 / 9997 : Real) ^ (10000 : Real) := by
    calc
      (lambdaR ^ (3 * epsilon0)) ^ (10000 : Real)
          = lambdaR ^ ((3 * epsilon0) * (10000 : Real)) := by
            rw [← Real.rpow_mul lambdaR_pos.le]
      _ = lambdaR ^ (3 : Real) := by
            congr 1
            norm_num [epsilon0]
      _ <= (10000 / 9997 : Real) ^ (10000 : Real) :=
            (le_of_lt lambdaR_cube_lt_four).trans pad_inv_power_ge_four
  exact
    (Real.rpow_le_rpow_iff
      (Real.rpow_nonneg lambdaR_pos.le _)
      (by norm_num : 0 <= (10000 / 9997 : Real))
      (by norm_num : 0 < (10000 : Real))).1 hpow

theorem lambda_neg_three_epsilon_ge :
    (9997 / 10000 : Real) <= lambdaR ^ (-(3 * epsilon0)) := by
  have hpos : 0 < lambdaR ^ (3 * epsilon0) :=
    Real.rpow_pos_of_pos lambdaR_pos _
  calc
    (9997 / 10000 : Real) = (10000 / 9997 : Real)⁻¹ := by
      norm_num
    _ <= (lambdaR ^ (3 * epsilon0))⁻¹ :=
      inv_anti₀ hpos lambdaR_three_epsilon_le_pad_inv
    _ = lambdaR ^ (-(3 * epsilon0)) := by
      rw [← Real.rpow_neg lambdaR_pos.le]

theorem lambda_neg_epsilon_ge :
    (9997 / 10000 : Real) <= lambdaR ^ (-epsilon0) := by
  have hmono :
      lambdaR ^ (-(3 * epsilon0)) <= lambdaR ^ (-epsilon0) := by
    exact Real.rpow_le_rpow_of_exponent_le lambdaR_gt_one.le (by
      nlinarith [epsilon0_nonneg])
  exact lambda_neg_three_epsilon_ge.trans hmono

theorem lambdaR_rpow_sub_two_eq (y : Real) :
    lambdaR ^ (y - 2) = lambdaR ^ y * (400 / 729 : Real) := by
  calc
    lambdaR ^ (y - 2) = lambdaR ^ y / lambdaR ^ (2 : Real) := by
      rw [Real.rpow_sub lambdaR_pos]
    _ = lambdaR ^ y * (400 / 729 : Real) := by
      norm_num [lambdaR]
      field_simp

theorem padded_row22_slack_eq :
    (400 / 729 : Real) * c28R
      + (119 / 135 : Real) * (9997 / 10000 : Real) * c12R
      - c22R
      = 33037 / 12150000 := by
  norm_num [c28R, c12R, c22R]

theorem padded_row22_arithmetic :
    c22R <=
      (400 / 729 : Real) * c28R
        + (119 / 135 : Real) * (9997 / 10000 : Real) * c12R := by
  have h := padded_row22_slack_eq
  linarith

theorem row25_no_advanced_pad_arithmetic :
    c25R <= (400 / 729 : Real) * c22R := by
  norm_num [c25R, c22R]

theorem padded_row28_slack_eq :
    (400 / 729 : Real) * c25R
      + (119 / 100 : Real) * (9997 / 10000 : Real) * c12R
      - c28R
      = 10124747 / 729000000 := by
  norm_num [c25R, c12R, c28R]

theorem padded_row28_arithmetic :
    c28R <=
      (400 / 729 : Real) * c25R
        + (119 / 100 : Real) * (9997 / 10000 : Real) * c12R := by
  have h := padded_row28_slack_eq
  linarith

theorem c12R_le_c22R : c12R <= c22R := by
  norm_num [c12R, c22R]

theorem c12R_le_c25R : c12R <= c25R := by
  norm_num [c12R, c25R]

theorem c12R_le_c28R : c12R <= c28R := by
  norm_num [c12R, c28R]

theorem EL_A : c12R * lambdaR ^ (2 : Real) <= c22R := by
  norm_num [c12R, lambdaR, c22R]

theorem EL_C : c12R <= min3 c22R c25R c28R := by
  exact le_min3 c12R_le_c22R c12R_le_c25R c12R_le_c28R

theorem same_shift_c12_term_le_component
    {z coeff target : Real}
    (hcoeff : c12R <= coeff)
    (hbound : DeltaV2 * coeff * lambdaR ^ z <= target) :
    DeltaV2 * c12R * lambdaR ^ z <= target := by
  have hnonneg : 0 <= DeltaV2 * lambdaR ^ z :=
    mul_nonneg DeltaV2_pos.le (Real.rpow_pos_of_pos lambdaR_pos _).le
  have hscaled :
      (DeltaV2 * lambdaR ^ z) * c12R <=
        (DeltaV2 * lambdaR ^ z) * coeff :=
    mul_le_mul_of_nonneg_left hcoeff hnonneg
  have hscaled' :
      DeltaV2 * c12R * lambdaR ^ z <= DeltaV2 * coeff * lambdaR ^ z := by
    simpa [mul_assoc, mul_left_comm, mul_comm] using hscaled
  exact hscaled'.trans hbound

theorem lambdaR_shiftAlphaMinus2Pad_factor_lower (y : Real) :
    (119 / 135 : Real) * (9997 / 10000 : Real) * lambdaR ^ y <=
      lambdaR ^ (y + shiftAlphaMinus2Pad) := by
  have hshift :
      lambdaR ^ shiftAlphaMinus2Pad =
        BReal * lambdaR ^ (-epsilon0) := by
    dsimp [shiftAlphaMinus2Pad, BReal]
    rw [show alpha - 2 - epsilon0 = (alpha - 2) + (-epsilon0) by ring]
    rw [Real.rpow_add lambdaR_pos]
  have hfactor :
      (119 / 135 : Real) * (9997 / 10000 : Real) <=
        lambdaR ^ shiftAlphaMinus2Pad := by
    rw [hshift]
    exact mul_le_mul BReal_lower lambda_neg_epsilon_ge
      (by norm_num)
      (by exact (by norm_num : (0 : Real) <= 119 / 135).trans BReal_lower)
  calc
    (119 / 135 : Real) * (9997 / 10000 : Real) * lambdaR ^ y
        <= lambdaR ^ shiftAlphaMinus2Pad * lambdaR ^ y := by
          exact mul_le_mul_of_nonneg_right hfactor
            (Real.rpow_pos_of_pos lambdaR_pos _).le
    _ = lambdaR ^ (y + shiftAlphaMinus2Pad) := by
          rw [Real.rpow_add lambdaR_pos]
          ring

theorem lambdaR_shiftAlphaMinus3Pad_DAq_factor_lower (y : Real) :
    (119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
        lambdaR ^ y <=
      lambdaR ^ (y + shiftAlphaMinus3Pad) := by
  have hshift :
      lambdaR ^ shiftAlphaMinus3Pad =
        DReal * lambdaR ^ (-2 : Real) * lambdaR ^ (-epsilon0) := by
    dsimp [shiftAlphaMinus3Pad, DReal]
    rw [show alpha - 3 - epsilon0 = (alpha - 1) + (-2 : Real) + (-epsilon0) by ring]
    rw [Real.rpow_add lambdaR_pos]
    rw [Real.rpow_add lambdaR_pos]
  have hA : lambdaR ^ (-2 : Real) = (400 / 729 : Real) := by
    norm_num [lambdaR]
  have hfactor :
      (119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) <=
        lambdaR ^ shiftAlphaMinus3Pad := by
    rw [hshift, hA]
    have hDq :
        (119 / 100 : Real) * (9997 / 10000 : Real) <=
          DReal * lambdaR ^ (-epsilon0) :=
      mul_le_mul DReal_lower lambda_neg_epsilon_ge
        (by norm_num)
        (by exact (by norm_num : (0 : Real) <= 119 / 100).trans DReal_lower)
    nlinarith
      [hDq, Real.rpow_pos_of_pos lambdaR_pos (-epsilon0), DReal_lower]
  calc
    (119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
        lambdaR ^ y
        <= lambdaR ^ shiftAlphaMinus3Pad * lambdaR ^ y := by
          exact mul_le_mul_of_nonneg_right hfactor
            (Real.rpow_pos_of_pos lambdaR_pos _).le
    _ = lambdaR ^ (y + shiftAlphaMinus3Pad) := by
          rw [Real.rpow_add lambdaR_pos]
          ring

theorem lambdaR_shiftAlphaMinus3Pad_c22_factor_lower (y : Real) :
    (119 / 100 : Real) * (9997 / 10000 : Real) * c12R * lambdaR ^ y <=
      c22R * lambdaR ^ (y + shiftAlphaMinus3Pad) := by
  have hshift :
      lambdaR ^ shiftAlphaMinus3Pad =
        DReal * lambdaR ^ (-2 : Real) * lambdaR ^ (-epsilon0) := by
    dsimp [shiftAlphaMinus3Pad, DReal]
    rw [show alpha - 3 - epsilon0 = (alpha - 1) + (-2 : Real) + (-epsilon0) by ring]
    rw [Real.rpow_add lambdaR_pos]
    rw [Real.rpow_add lambdaR_pos]
  have hA : lambdaR ^ (-2 : Real) = (400 / 729 : Real) := by
    norm_num [lambdaR]
  have hcoeff :
      (119 / 100 : Real) * (9997 / 10000 : Real) * c12R <=
        c22R * lambdaR ^ shiftAlphaMinus3Pad := by
    rw [hshift, hA]
    have hDq :
        (119 / 100 : Real) * (9997 / 10000 : Real) <=
          DReal * lambdaR ^ (-epsilon0) :=
      mul_le_mul DReal_lower lambda_neg_epsilon_ge
        (by norm_num)
        (by exact (by norm_num : (0 : Real) <= 119 / 100).trans DReal_lower)
    have hAcoef : (1 : Real) <= c22R * (400 / 729 : Real) := by
      norm_num [c22R]
    nlinarith [hDq, hAcoef, c12R_eq_one, DReal_lower,
      Real.rpow_pos_of_pos lambdaR_pos (-epsilon0)]
  calc
    (119 / 100 : Real) * (9997 / 10000 : Real) * c12R * lambdaR ^ y
        <= (c22R * lambdaR ^ shiftAlphaMinus3Pad) * lambdaR ^ y := by
          exact mul_le_mul_of_nonneg_right hcoeff
            (Real.rpow_pos_of_pos lambdaR_pos _).le
    _ = c22R * lambdaR ^ (y + shiftAlphaMinus3Pad) := by
          rw [Real.rpow_add lambdaR_pos]
          ring

theorem lambda_neg_two_epsilon_ge :
    (9997 / 10000 : Real) <= lambdaR ^ (-(2 * epsilon0)) := by
  have hmono :
      lambdaR ^ (-(3 * epsilon0)) <= lambdaR ^ (-(2 * epsilon0)) := by
    exact Real.rpow_le_rpow_of_exponent_le lambdaR_gt_one.le (by
      nlinarith [epsilon0_nonneg])
  exact lambda_neg_three_epsilon_ge.trans hmono

theorem lambdaR_shift2AlphaMinus5Pad2_BDAq_factor_lower (y : Real) :
    (119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
        (9997 / 10000 : Real) * lambdaR ^ y <=
      lambdaR ^ (y + shift2AlphaMinus5Pad2) := by
  have hshift :
      lambdaR ^ shift2AlphaMinus5Pad2 =
        BReal * DReal * lambdaR ^ (-2 : Real) * lambdaR ^ (-(2 * epsilon0)) := by
    dsimp [shift2AlphaMinus5Pad2, BReal, DReal]
    rw [show 2 * alpha - 5 - 2 * epsilon0 =
        (alpha - 2) + (alpha - 1) + (-2 : Real) + (-(2 * epsilon0)) by ring]
    rw [Real.rpow_add lambdaR_pos]
    rw [Real.rpow_add lambdaR_pos]
    rw [Real.rpow_add lambdaR_pos]
  have hA : lambdaR ^ (-2 : Real) = (400 / 729 : Real) := by
    norm_num [lambdaR]
  have hBD :
      (119 / 135 : Real) * (119 / 100 : Real) <= BReal * DReal := by
    have hBnonneg : 0 <= BReal := by nlinarith [BReal_lower]
    have hstep1 :
        (119 / 135 : Real) * (119 / 100 : Real) <=
          BReal * (119 / 100 : Real) :=
      mul_le_mul_of_nonneg_right BReal_lower (by norm_num)
    have hstep2 :
        BReal * (119 / 100 : Real) <= BReal * DReal :=
      mul_le_mul_of_nonneg_left DReal_lower hBnonneg
    exact hstep1.trans hstep2
  have hfactor :
      (119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
          (9997 / 10000 : Real) <= lambdaR ^ shift2AlphaMinus5Pad2 := by
    rw [hshift, hA]
    have hBnonneg : 0 <= BReal := by nlinarith [BReal_lower]
    have hDnonneg : 0 <= DReal := by nlinarith [DReal_lower]
    have hBDnonneg : 0 <= BReal * DReal := mul_nonneg hBnonneg hDnonneg
    have hBDq :
        ((119 / 135 : Real) * (119 / 100 : Real)) * (9997 / 10000 : Real) <=
          (BReal * DReal) * lambdaR ^ (-(2 * epsilon0)) := by
      have hstep1 :
          ((119 / 135 : Real) * (119 / 100 : Real)) *
              (9997 / 10000 : Real) <=
            (BReal * DReal) * (9997 / 10000 : Real) :=
        mul_le_mul_of_nonneg_right hBD (by norm_num)
      have hstep2 :
          (BReal * DReal) * (9997 / 10000 : Real) <=
            (BReal * DReal) * lambdaR ^ (-(2 * epsilon0)) :=
        mul_le_mul_of_nonneg_left lambda_neg_two_epsilon_ge hBDnonneg
      exact hstep1.trans hstep2
    have hmul := mul_le_mul_of_nonneg_right hBDq (by norm_num : (0 : Real) <= 400 / 729)
    nlinarith [hmul]
  calc
    (119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
        (9997 / 10000 : Real) * lambdaR ^ y
        <= lambdaR ^ shift2AlphaMinus5Pad2 * lambdaR ^ y := by
          exact mul_le_mul_of_nonneg_right hfactor
            (Real.rpow_pos_of_pos lambdaR_pos _).le
    _ = lambdaR ^ (y + shift2AlphaMinus5Pad2) := by
          rw [Real.rpow_add lambdaR_pos]
          ring

theorem row25_target_le_shifted22 (y : Real) :
    DeltaV2 * c25R * lambdaR ^ y <=
      DeltaV2 * c22R * lambdaR ^ (y - 2) := by
  have hL0 : 0 <= DeltaV2 * lambdaR ^ y :=
    mul_nonneg DeltaV2_pos.le (Real.rpow_pos_of_pos lambdaR_pos _).le
  calc
    DeltaV2 * c25R * lambdaR ^ y
        = (DeltaV2 * lambdaR ^ y) * c25R := by ring
    _ <= (DeltaV2 * lambdaR ^ y) * ((400 / 729 : Real) * c22R) := by
          exact mul_le_mul_of_nonneg_left row25_no_advanced_pad_arithmetic hL0
    _ = DeltaV2 * c22R * lambdaR ^ (y - 2) := by
          rw [lambdaR_rpow_sub_two_eq]
          ring

theorem row25_assembly
    {Phi : K2PhiSystem} {y : Real}
    (hrow : Phi.phi22 (y - 2) <= Phi.phi25 y)
    (h22 : Phi22LowerBoundAt Phi (y - 2)) :
    Phi25LowerBoundAt Phi y := by
  exact (row25_target_le_shifted22 y).trans (h22.trans hrow)

theorem alpha2pad_c12_term_le_component
    {y coeff target : Real}
    (hcoeff : c12R <= coeff)
    (hbound :
      DeltaV2 * coeff * lambdaR ^ (y + shiftAlphaMinus2Pad) <= target) :
    DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <= target := by
  have hfactor := lambdaR_shiftAlphaMinus2Pad_factor_lower y
  have hpow0 : 0 <= lambdaR ^ (y + shiftAlphaMinus2Pad) :=
    (Real.rpow_pos_of_pos lambdaR_pos _).le
  have hcoeff_factor :
      ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) * lambdaR ^ y <=
        coeff * lambdaR ^ (y + shiftAlphaMinus2Pad) := by
    calc
      ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) * lambdaR ^ y
          = c12R * ((119 / 135 : Real) * (9997 / 10000 : Real) * lambdaR ^ y) := by
            ring
      _ <= c12R * lambdaR ^ (y + shiftAlphaMinus2Pad) := by
            exact mul_le_mul_of_nonneg_left hfactor (by norm_num [c12R])
      _ <= coeff * lambdaR ^ (y + shiftAlphaMinus2Pad) := by
            exact mul_le_mul_of_nonneg_right hcoeff hpow0
  have hscaled :
      DeltaV2 *
          (((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) * lambdaR ^ y)
        <= DeltaV2 * (coeff * lambdaR ^ (y + shiftAlphaMinus2Pad)) :=
    mul_le_mul_of_nonneg_left hcoeff_factor DeltaV2_pos.le
  have hscaled' :
      DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
          lambdaR ^ y
        <= DeltaV2 * coeff * lambdaR ^ (y + shiftAlphaMinus2Pad) := by
    simpa [mul_assoc, mul_left_comm, mul_comm] using hscaled
  exact hscaled'.trans hbound

theorem row22_target_le_coeff_sum (y : Real) :
    DeltaV2 * c22R * lambdaR ^ y <=
      DeltaV2 * c28R * lambdaR ^ (y - 2)
        + DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
            lambdaR ^ y := by
  have hL0 : 0 <= DeltaV2 * lambdaR ^ y :=
    mul_nonneg DeltaV2_pos.le (Real.rpow_pos_of_pos lambdaR_pos _).le
  have harith := padded_row22_arithmetic
  calc
    DeltaV2 * c22R * lambdaR ^ y
        = (DeltaV2 * lambdaR ^ y) * c22R := by ring
    _ <= (DeltaV2 * lambdaR ^ y) *
          ((400 / 729 : Real) * c28R
            + (119 / 135 : Real) * (9997 / 10000 : Real) * c12R) := by
          exact mul_le_mul_of_nonneg_left harith hL0
    _ = DeltaV2 * c28R * lambdaR ^ (y - 2)
          + DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
            lambdaR ^ y := by
          rw [lambdaR_rpow_sub_two_eq]
          ring

theorem row22_assembly
    {Phi : K2PhiSystem} {y : Real}
    (hrow : Phi.phi28 (y - 2)
        + min3
            (Phi.phi22 (y + shiftAlphaMinus2Pad))
            (Phi.phi25 (y + shiftAlphaMinus2Pad))
            (Phi.phi28 (y + shiftAlphaMinus2Pad))
        <= Phi.phi22 y)
    (h28ret : Phi28LowerBoundAt Phi (y - 2))
    (h22adv : Phi22LowerBoundAt Phi (y + shiftAlphaMinus2Pad))
    (h25adv : Phi25LowerBoundAt Phi (y + shiftAlphaMinus2Pad))
    (h28adv : Phi28LowerBoundAt Phi (y + shiftAlphaMinus2Pad)) :
    Phi22LowerBoundAt Phi y := by
  have hadv22 :
      DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <= Phi.phi22 (y + shiftAlphaMinus2Pad) :=
    alpha2pad_c12_term_le_component c12R_le_c22R h22adv
  have hadv25 :
      DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <= Phi.phi25 (y + shiftAlphaMinus2Pad) :=
    alpha2pad_c12_term_le_component c12R_le_c25R h25adv
  have hadv28 :
      DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <= Phi.phi28 (y + shiftAlphaMinus2Pad) :=
    alpha2pad_c12_term_le_component c12R_le_c28R h28adv
  have hadv :
      DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <=
        min3
          (Phi.phi22 (y + shiftAlphaMinus2Pad))
          (Phi.phi25 (y + shiftAlphaMinus2Pad))
          (Phi.phi28 (y + shiftAlphaMinus2Pad)) :=
    le_min3 hadv22 hadv25 hadv28
  have hsum :
      DeltaV2 * c28R * lambdaR ^ (y - 2)
        + DeltaV2 * ((119 / 135 : Real) * (9997 / 10000 : Real) * c12R) *
            lambdaR ^ y
      <= Phi.phi28 (y - 2)
        + min3
            (Phi.phi22 (y + shiftAlphaMinus2Pad))
            (Phi.phi25 (y + shiftAlphaMinus2Pad))
            (Phi.phi28 (y + shiftAlphaMinus2Pad) ) :=
    add_le_add h28ret hadv
  exact (row22_target_le_coeff_sum y).trans (hsum.trans hrow)

theorem m2v2_c12_shift3_lower
    {Phi : K2PhiSystem} {y : Real}
    (h22 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    DeltaV2 * c12R * lambdaR ^ (y + shift3AlphaMinus5Pad3) <=
      M2V2 Phi y := by
  dsimp [M2V2]
  exact le_min3
    (same_shift_c12_term_le_component c12R_le_c22R h22)
    (same_shift_c12_term_le_component c12R_le_c25R h25)
    (same_shift_c12_term_le_component c12R_le_c28R h28)

theorem m2v2_nonneg
    {Phi : K2PhiSystem} {y : Real}
    (h22 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    0 <= M2V2 Phi y := by
  have hbase : 0 <= DeltaV2 * c12R * lambdaR ^ (y + shift3AlphaMinus5Pad3) := by
    exact mul_nonneg
      (mul_nonneg DeltaV2_pos.le (by norm_num [c12R]))
      (Real.rpow_pos_of_pos lambdaR_pos _).le
  exact hbase.trans (m2v2_c12_shift3_lower h22 h25 h28)

theorem M2V2_lower
    {Phi : K2PhiSystem} {y : Real}
    (h22 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    DeltaV2 * c12R * lambdaR ^ (y + shift3AlphaMinus5Pad3) <=
      M2V2 Phi y := by
  have _hbox : c12R <= min3 c22R c25R c28R := EL_C
  exact m2v2_c12_shift3_lower h22 h25 h28

theorem m1v2_c12_shift2_lower
    {Phi : K2PhiSystem} {y : Real}
    (h22s2 : Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h28s2 : Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h22s3 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25s3 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28s3 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) <=
      M1V2 Phi y := by
  have hm2_nonneg := m2v2_nonneg h22s3 h25s3 h28s3
  have h28_lower :
      DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) <=
        Phi.phi28 (y + shift2AlphaMinus5Pad2) :=
    same_shift_c12_term_le_component c12R_le_c28R h28s2
  have h22_lower :
      DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) <=
        Phi.phi22 (y + shift2AlphaMinus5Pad2) :=
    same_shift_c12_term_le_component c12R_le_c22R h22s2
  have hfirst :
      DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) <=
        Phi.phi28 (y + shift2AlphaMinus5Pad2) + M2V2 Phi y := by
    have hpad :
        DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) <=
          DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) + M2V2 Phi y := by
      linarith
    exact hpad.trans (add_le_add_right h28_lower (M2V2 Phi y))
  dsimp [M1V2]
  exact le_min hfirst h22_lower

theorem M1V2_lower
    {Phi : K2PhiSystem} {y : Real}
    (h22s2 : Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h28s2 : Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h22s3 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25s3 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28s3 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) <=
      M1V2 Phi y := by
  have _hA : c12R * lambdaR ^ (2 : Real) <= c22R := EL_A
  exact m1v2_c12_shift2_lower h22s2 h28s2 h22s3 h25s3 h28s3

theorem row28_second_branch_lower
    {Phi : K2PhiSystem} {y : Real}
    (h22a3 : Phi22LowerBoundAt Phi (y + shiftAlphaMinus3Pad)) :
    DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <=
      Phi.phi22 (y + shiftAlphaMinus3Pad) := by
  have _hA : c12R * lambdaR ^ (2 : Real) <= c22R := EL_A
  have hfactor := lambdaR_shiftAlphaMinus3Pad_c22_factor_lower y
  have hscaled :
      DeltaV2 *
          (((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
            lambdaR ^ y)
        <= DeltaV2 * (c22R * lambdaR ^ (y + shiftAlphaMinus3Pad)) :=
    mul_le_mul_of_nonneg_left hfactor DeltaV2_pos.le
  have hscaled' :
      DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
          lambdaR ^ y
        <= DeltaV2 * c22R * lambdaR ^ (y + shiftAlphaMinus3Pad) := by
    simpa [mul_assoc, mul_left_comm, mul_comm] using hscaled
  exact hscaled'.trans h22a3

theorem row28_phi28_alpha3_block_lower
    {Phi : K2PhiSystem} {y : Real}
    (h28a3 : Phi28LowerBoundAt Phi (y + shiftAlphaMinus3Pad)) :
    DeltaV2 *
        ((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
          c28R) * lambdaR ^ y <=
      Phi.phi28 (y + shiftAlphaMinus3Pad) := by
  have hfactor := lambdaR_shiftAlphaMinus3Pad_DAq_factor_lower y
  have hcoeff :
      ((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
          c28R) * lambdaR ^ y <=
        c28R * lambdaR ^ (y + shiftAlphaMinus3Pad) := by
    calc
      ((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
          c28R) * lambdaR ^ y
          = c28R *
              (((119 / 100 : Real) * (9997 / 10000 : Real) *
                (400 / 729 : Real)) * lambdaR ^ y) := by ring
      _ <= c28R * lambdaR ^ (y + shiftAlphaMinus3Pad) := by
            exact mul_le_mul_of_nonneg_left hfactor c28R_pos.le
  have hscaled :
      DeltaV2 *
          (((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
            c28R) * lambdaR ^ y)
        <= DeltaV2 * (c28R * lambdaR ^ (y + shiftAlphaMinus3Pad)) :=
    mul_le_mul_of_nonneg_left hcoeff DeltaV2_pos.le
  have hscaled' :
      DeltaV2 *
          ((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
            c28R) * lambdaR ^ y
        <= DeltaV2 * c28R * lambdaR ^ (y + shiftAlphaMinus3Pad) := by
    simpa [mul_assoc, mul_left_comm, mul_comm] using hscaled
  exact hscaled'.trans h28a3

theorem row28_m1_block_lower
    {Phi : K2PhiSystem} {y : Real}
    (h22s2 : Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h28s2 : Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h22s3 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25s3 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28s3 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    DeltaV2 *
        ((119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
          (9997 / 10000 : Real) * c12R) * lambdaR ^ y <=
      M1V2 Phi y := by
  have hfactor := lambdaR_shift2AlphaMinus5Pad2_BDAq_factor_lower y
  have hcoeff :
      ((119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
          (9997 / 10000 : Real) * c12R) * lambdaR ^ y <=
        c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) := by
    calc
      ((119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
          (9997 / 10000 : Real) * c12R) * lambdaR ^ y
          = c12R *
              (((119 / 135 : Real) * (119 / 100 : Real) *
                (400 / 729 : Real) * (9997 / 10000 : Real)) *
                  lambdaR ^ y) := by ring
      _ <= c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) := by
            exact mul_le_mul_of_nonneg_left hfactor (by norm_num [c12R])
  have hscaled :
      DeltaV2 *
          (((119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
            (9997 / 10000 : Real) * c12R) * lambdaR ^ y)
        <= DeltaV2 * (c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2)) :=
    mul_le_mul_of_nonneg_left hcoeff DeltaV2_pos.le
  have hscaled' :
      DeltaV2 *
          ((119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
            (9997 / 10000 : Real) * c12R) * lambdaR ^ y
        <= DeltaV2 * c12R * lambdaR ^ (y + shift2AlphaMinus5Pad2) := by
    simpa [mul_assoc, mul_left_comm, mul_comm] using hscaled
  exact hscaled'.trans
    (M1V2_lower h22s2 h28s2 h22s3 h25s3 h28s3)

theorem row28_dq_split_arithmetic :
    (119 / 100 : Real) * (9997 / 10000 : Real) * c12R <=
      (119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
        c28R
        + (119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
          (9997 / 10000 : Real) * c12R := by
  norm_num [c12R, c28R]

theorem row28_dq_split_scaled (y : Real) :
    DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <=
      DeltaV2 *
          ((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
            c28R) * lambdaR ^ y
        + DeltaV2 *
          ((119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
            (9997 / 10000 : Real) * c12R) * lambdaR ^ y := by
  have hL0 : 0 <= DeltaV2 * lambdaR ^ y :=
    mul_nonneg DeltaV2_pos.le (Real.rpow_pos_of_pos lambdaR_pos _).le
  calc
    DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y
        = (DeltaV2 * lambdaR ^ y) *
            ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) := by ring
    _ <= (DeltaV2 * lambdaR ^ y) *
          ((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
            c28R
            + (119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
              (9997 / 10000 : Real) * c12R) := by
          exact mul_le_mul_of_nonneg_left row28_dq_split_arithmetic hL0
    _ = DeltaV2 *
          ((119 / 100 : Real) * (9997 / 10000 : Real) * (400 / 729 : Real) *
            c28R) * lambdaR ^ y
        + DeltaV2 *
          ((119 / 135 : Real) * (119 / 100 : Real) * (400 / 729 : Real) *
            (9997 / 10000 : Real) * c12R) * lambdaR ^ y := by
          ring

theorem row28_first_branch_lower
    {Phi : K2PhiSystem} {y : Real}
    (h28a3 : Phi28LowerBoundAt Phi (y + shiftAlphaMinus3Pad))
    (h22s2 : Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h28s2 : Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h22s3 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25s3 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28s3 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <=
      Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y := by
  have hphi28 := row28_phi28_alpha3_block_lower h28a3
  have hm1 := row28_m1_block_lower h22s2 h28s2 h22s3 h25s3 h28s3
  exact (row28_dq_split_scaled y).trans (add_le_add hphi28 hm1)

theorem row28_padded_block_lower
    {Phi : K2PhiSystem} {y : Real}
    (h22a3 : Phi22LowerBoundAt Phi (y + shiftAlphaMinus3Pad))
    (h28a3 : Phi28LowerBoundAt Phi (y + shiftAlphaMinus3Pad))
    (h22s2 : Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h28s2 : Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h22s3 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25s3 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28s3 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <=
      min
        (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
        (Phi.phi22 (y + shiftAlphaMinus3Pad)) := by
  exact le_min
    (row28_first_branch_lower h28a3 h22s2 h28s2 h22s3 h25s3 h28s3)
    (row28_second_branch_lower h22a3)

theorem row28_target_le_coeff_sum (y : Real) :
    DeltaV2 * c28R * lambdaR ^ y <=
      DeltaV2 * c25R * lambdaR ^ (y - 2)
        + DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
            lambdaR ^ y := by
  have hL0 : 0 <= DeltaV2 * lambdaR ^ y :=
    mul_nonneg DeltaV2_pos.le (Real.rpow_pos_of_pos lambdaR_pos _).le
  calc
    DeltaV2 * c28R * lambdaR ^ y
        = (DeltaV2 * lambdaR ^ y) * c28R := by ring
    _ <= (DeltaV2 * lambdaR ^ y) *
          ((400 / 729 : Real) * c25R
            + (119 / 100 : Real) * (9997 / 10000 : Real) * c12R) := by
          exact mul_le_mul_of_nonneg_left padded_row28_arithmetic hL0
    _ = DeltaV2 * c25R * lambdaR ^ (y - 2)
          + DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
            lambdaR ^ y := by
          rw [lambdaR_rpow_sub_two_eq]
          ring

theorem row28_assembly
    {Phi : K2PhiSystem} {y : Real}
    (hrow : Phi.phi25 (y - 2)
        + min
            (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
            (Phi.phi22 (y + shiftAlphaMinus3Pad))
        <= Phi.phi28 y)
    (h25ret : Phi25LowerBoundAt Phi (y - 2))
    (h22a3 : Phi22LowerBoundAt Phi (y + shiftAlphaMinus3Pad))
    (h28a3 : Phi28LowerBoundAt Phi (y + shiftAlphaMinus3Pad))
    (h22s2 : Phi22LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h28s2 : Phi28LowerBoundAt Phi (y + shift2AlphaMinus5Pad2))
    (h22s3 : Phi22LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h25s3 : Phi25LowerBoundAt Phi (y + shift3AlphaMinus5Pad3))
    (h28s3 : Phi28LowerBoundAt Phi (y + shift3AlphaMinus5Pad3)) :
    Phi28LowerBoundAt Phi y := by
  have hblock :
      DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
        lambdaR ^ y <=
      min
        (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
        (Phi.phi22 (y + shiftAlphaMinus3Pad)) :=
    row28_padded_block_lower h22a3 h28a3 h22s2 h28s2 h22s3 h25s3 h28s3
  have hsum :
      DeltaV2 * c25R * lambdaR ^ (y - 2)
        + DeltaV2 * ((119 / 100 : Real) * (9997 / 10000 : Real) * c12R) *
            lambdaR ^ y
      <= Phi.phi25 (y - 2)
        + min
            (Phi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 Phi y)
            (Phi.phi22 (y + shiftAlphaMinus3Pad)) :=
    add_le_add h25ret hblock
  exact (row28_target_le_coeff_sum y).trans (hsum.trans hrow)

theorem deltaM0C_pos : 0 < deltaM0C := by
  dsimp [deltaM0C]
  linarith [alpha_upper_bound]

theorem retardedRank_pos_of_fourteen_le
    {y : Real} (hy : 14 <= y) :
    0 < retardedRank y := by
  dsimp [retardedRank]
  have hypos : 0 < y := by linarith
  have hdiv : 0 < y / deltaM0C := div_pos hypos deltaM0C_pos
  exact Nat.ceil_pos.2 hdiv

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

theorem shift_alpha_minus2_pad_le_shift_alpha_minus_two :
    shiftAlphaMinus2Pad <= shiftAlphaMinusTwo := by
  dsimp [shiftAlphaMinus2Pad, shiftAlphaMinusTwo]
  linarith [epsilon0_nonneg]

theorem shift_alpha_minus3_pad_le_shift_alpha_minus_three :
    shiftAlphaMinus3Pad <= shiftAlphaMinusThree := by
  dsimp [shiftAlphaMinus3Pad, shiftAlphaMinusThree]
  linarith [epsilon0_nonneg]

theorem shift2_alpha_minus5_pad2_le_shift_two_alpha_minus_five :
    shift2AlphaMinus5Pad2 <= shiftTwoAlphaMinusFive := by
  dsimp [shift2AlphaMinus5Pad2, shiftTwoAlphaMinusFive]
  linarith [epsilon0_nonneg]

theorem shift3_alpha_minus5_pad3_le_shift_three_alpha_minus_five :
    shift3AlphaMinus5Pad3 <= shiftThreeAlphaMinusFive := by
  dsimp [shift3AlphaMinus5Pad3, shiftThreeAlphaMinusFive]
  linarith [epsilon0_nonneg]

theorem shift_alpha_minus2_pad_le_neg_deltaM0C :
    shiftAlphaMinus2Pad <= -deltaM0C :=
  shift_alpha_minus2_pad_le_shift_alpha_minus_two.trans
    shift_alpha_minus_two_le_neg_deltaM0C

theorem shift_alpha_minus3_pad_le_neg_deltaM0C :
    shiftAlphaMinus3Pad <= -deltaM0C :=
  shift_alpha_minus3_pad_le_shift_alpha_minus_three.trans
    shift_alpha_minus_three_le_neg_deltaM0C

theorem shift2_alpha_minus5_pad2_le_neg_deltaM0C :
    shift2AlphaMinus5Pad2 <= -deltaM0C :=
  shift2_alpha_minus5_pad2_le_shift_two_alpha_minus_five.trans
    shift_two_alpha_minus_five_le_neg_deltaM0C

theorem shift3_alpha_minus5_pad3_le_neg_deltaM0C :
    shift3AlphaMinus5Pad3 <= -deltaM0C :=
  shift3_alpha_minus5_pad3_le_shift_three_alpha_minus_five.trans
    (le_of_eq shift_three_alpha_minus_five_eq_neg_deltaM0C)

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

theorem retardedRank_drop_shiftAlphaMinus2Pad
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + shiftAlphaMinus2Pad) < retardedRank y :=
  retardedRank_drop shift_alpha_minus2_pad_le_neg_deltaM0C hpos

theorem retardedRank_drop_shiftAlphaMinus3Pad
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + shiftAlphaMinus3Pad) < retardedRank y :=
  retardedRank_drop shift_alpha_minus3_pad_le_neg_deltaM0C hpos

theorem retardedRank_drop_shift2AlphaMinus5Pad2
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + shift2AlphaMinus5Pad2) < retardedRank y :=
  retardedRank_drop shift2_alpha_minus5_pad2_le_neg_deltaM0C hpos

theorem retardedRank_drop_shift3AlphaMinus5Pad3
    {y : Real} (hpos : 0 < retardedRank y) :
    retardedRank (y + shift3AlphaMinus5Pad3) < retardedRank y :=
  retardedRank_drop shift3_alpha_minus5_pad3_le_neg_deltaM0C hpos

/-!
The weighted base segment is now the explicit M0C contract.  A later
seam/base bridge should derive it from the weak base/root-count input plus
the `Cmax = 2` coefficient envelope; this module does not prove that bridge.
-/

end KL2003
end CollatzClassical
