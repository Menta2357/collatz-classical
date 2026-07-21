import CollatzClassical.KL2003.KL2003K11CertificateMatchAggregate
import CollatzClassical.KL2003.KL2003K11EndpointBounds
import CollatzClassical.KL2003.KL2003GeneralKLNTFeasibilityTransfer
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

namespace CollatzClassical
namespace KL2003
namespace K11LNTCertificate

open GeneralKLNTFeasibilityTransfer
open K11EndpointBounds
open K11CertificateMatch

def modeIndex {k : Nat} (mode : TrackedMode k) : Nat :=
  (mode.1.1 - 2) / 3

theorem mode_value_eq_index {k : Nat} (mode : TrackedMode k) :
    mode.1.1 = 3 * modeIndex mode + 2 := by
  have h := Nat.mod_add_div mode.1.1 3
  simp only [modeIndex]
  omega

theorem modeAt_modeIndex {k : Nat} (mode : TrackedMode k) :
    modeAt (modeIndex mode) = mode.1.1 := by
  rw [mode_value_eq_index mode]
  simp [modeAt]

theorem principal_modeIndex_lt (mode : TrackedMode 11) :
    modeIndex mode < 59049 := by
  have hlt := mode.1.2
  norm_num [generalKModulus] at hlt
  rw [mode_value_eq_index mode] at hlt
  omega

theorem auxiliary_modeIndex_lt (mode : TrackedMode 10) :
    modeIndex mode < 19683 := by
  have hlt := mode.1.2
  norm_num [generalKModulus] at hlt
  rw [mode_value_eq_index mode] at hlt
  omega

theorem four_modeIndex (mode : TrackedMode 11) :
    modeIndex (fourTrackedMode (by norm_num) mode) =
      retardedIndex (modeIndex mode) := by
  simp only [modeIndex, fourTrackedMode_value, retardedIndex]
  have hmode : modeAt ((mode.1.1 - 2) / 3) = mode.1.1 := by
    simpa [modeIndex] using modeAt_modeIndex mode
  rw [hmode]
  norm_num [generalKModulus]

theorem d1LowerTrackedMode_value (mode : TrackedMode 11)
    (hm : mode.1.1 % 9 = 2) :
    (d1LowerTrackedMode (by norm_num) mode hm).1.1 =
      d1RawLowerModeValue mode.1.1 % 59049 := by
  rfl

theorem d1_modeIndex (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 2) :
    modeIndex (d1LowerTrackedMode (by norm_num) mode hm) =
      d1AuxiliaryIndex (modeIndex mode) := by
  simp only [modeIndex, d1LowerTrackedMode_value, d1AuxiliaryIndex,
    d1RawLowerModeValue]
  have hmode : modeAt ((mode.1.1 - 2) / 3) = mode.1.1 := by
    simpa [modeIndex] using modeAt_modeIndex mode
  rw [hmode]

theorem d3LowerTrackedMode_value (mode : TrackedMode 11)
    (hm : mode.1.1 % 9 = 8) :
    (d3LowerTrackedMode (by norm_num) mode hm).1.1 =
      d3RawLowerModeValue mode.1.1 % 59049 := by
  rfl

theorem d3_modeIndex (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 8) :
    modeIndex (d3LowerTrackedMode (by norm_num) mode hm) =
      d3AuxiliaryIndex (modeIndex mode) := by
  simp only [modeIndex, d3LowerTrackedMode_value, d3AuxiliaryIndex,
    d3RawLowerModeValue]
  have hmode : modeAt ((mode.1.1 - 2) / 3) = mode.1.1 := by
    simpa [modeIndex] using modeAt_modeIndex mode
  rw [hmode]

theorem lift_modeIndex (mode : TrackedMode 10) (j : Fin 3) :
    modeIndex (liftTrackedMode (by norm_num) mode j) =
      modeIndex mode + j.1 * 19683 := by
  have hmode := mode_value_eq_index mode
  rcases j with ⟨j, hj⟩
  simp only [modeIndex, liftTrackedMode_value, generalKModulus]
  norm_num at hj ⊢
  omega

noncomputable def k11Principal (mode : TrackedMode 11) : Real :=
  ((principalAt (modeIndex mode) : Rat) : Real)

noncomputable def k11Auxiliary (mode : TrackedMode 10) : Real :=
  ((auxiliaryAt (modeIndex mode) : Rat) : Real)

theorem k11Principal_one_le (mode : TrackedMode 11) :
    1 <= k11Principal mode := by
  have h := (k11_all_rows_valid (modeIndex mode) (principal_modeIndex_lt mode)).1
  change (1 : Real) <= ((principalAt (modeIndex mode) : Rat) : Real)
  exact_mod_cast h

theorem k11Principal_pos (mode : TrackedMode 11) :
    0 < k11Principal mode :=
  lt_of_lt_of_le (by norm_num) (k11Principal_one_le mode)

theorem k11Auxiliary_one_le (mode : TrackedMode 10) :
    1 <= k11Auxiliary mode := by
  have h :=
    (k11_all_auxiliary_valid (modeIndex mode) (auxiliary_modeIndex_lt mode)).1
  change (1 : Real) <= ((auxiliaryAt (modeIndex mode) : Rat) : Real)
  exact_mod_cast h

theorem k11Auxiliary_pos (mode : TrackedMode 10) :
    0 < k11Auxiliary mode :=
  lt_of_lt_of_le (by norm_num) (k11Auxiliary_one_le mode)

theorem k11Auxiliary_le_lift (mode : TrackedMode 10) (j : Fin 3) :
    k11Auxiliary mode <=
      k11Principal (liftTrackedMode (by norm_num) mode j) := by
  have h :=
    k11_all_auxiliary_valid (modeIndex mode) (auxiliary_modeIndex_lt mode)
  rcases j with ⟨j, hj⟩
  interval_cases j
  · change ((auxiliaryAt (modeIndex mode) : Rat) : Real) <=
      ((principalAt (modeIndex (liftTrackedMode (by norm_num) mode ⟨0, by omega⟩)) : Rat) : Real)
    rw [lift_modeIndex]
    norm_num
    exact_mod_cast h.2.1
  · change ((auxiliaryAt (modeIndex mode) : Rat) : Real) <=
      ((principalAt (modeIndex (liftTrackedMode (by norm_num) mode ⟨1, by omega⟩)) : Rat) : Real)
    rw [lift_modeIndex]
    norm_num
    exact_mod_cast h.2.2.1
  · change ((auxiliaryAt (modeIndex mode) : Rat) : Real) <=
      ((principalAt (modeIndex (liftTrackedMode (by norm_num) mode ⟨2, by omega⟩)) : Rat) : Real)
    rw [lift_modeIndex]
    norm_num
    exact_mod_cast h.2.2.2

theorem row_of_bLower
    {current retarded auxiliary : Real}
    (hrow : current <= ((aCoeff : Rat) : Real) * retarded +
      ((bLower : Rat) : Real) * auxiliary)
    (hauxiliary : 0 <= auxiliary) :
    current <= retarded * lambdaR11 ^ (-2 : Real) +
      auxiliary * lambdaR11 ^ (alpha - 2) := by
  calc
    current <= ((aCoeff : Rat) : Real) * retarded +
        ((bLower : Rat) : Real) * auxiliary := hrow
    _ <= lambdaR11 ^ (-2 : Real) * retarded + bReal11 * auxiliary := by
      apply add_le_add
      · rw [aCoeff_real_eq_lambda_neg_two]
      · exact mul_le_mul_of_nonneg_right bReal11_lower hauxiliary
    _ = retarded * lambdaR11 ^ (-2 : Real) +
        auxiliary * lambdaR11 ^ (alpha - 2) := by
      rw [bReal11]
      ring

theorem row_of_dLower
    {current retarded auxiliary : Real}
    (hrow : current <= ((aCoeff : Rat) : Real) * retarded +
      ((dLower : Rat) : Real) * auxiliary)
    (hauxiliary : 0 <= auxiliary) :
    current <= retarded * lambdaR11 ^ (-2 : Real) +
      auxiliary * lambdaR11 ^ (alpha - 1) := by
  calc
    current <= ((aCoeff : Rat) : Real) * retarded +
        ((dLower : Rat) : Real) * auxiliary := hrow
    _ <= lambdaR11 ^ (-2 : Real) * retarded + dReal11 * auxiliary := by
      apply add_le_add
      · rw [aCoeff_real_eq_lambda_neg_two]
      · exact mul_le_mul_of_nonneg_right dReal11_lower hauxiliary
    _ = retarded * lambdaR11 ^ (-2 : Real) +
        auxiliary * lambdaR11 ^ (alpha - 1) := by
      rw [dReal11]
      ring

theorem row_of_aCoeff {current retarded : Real}
    (hrow : current <= ((aCoeff : Rat) : Real) * retarded) :
    current <= retarded * lambdaR11 ^ (-2 : Real) := by
  rw [aCoeff_real_eq_lambda_neg_two] at hrow
  simpa [mul_comm] using hrow

theorem rational_d1_row (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 2) :
    principalAt (modeIndex mode) <=
      aCoeff * principalAt (retardedIndex (modeIndex mode)) +
        bLower * auxiliaryAt (d1AuxiliaryIndex (modeIndex mode)) := by
  have h := k11_all_rows_valid (modeIndex mode) (principal_modeIndex_lt mode)
  have hclass : modeAt (modeIndex mode) % 9 = 2 := by
    rw [modeAt_modeIndex]
    exact hm
  simp only [K11RowValid] at h
  simp [rowRhs, hclass] at h
  linarith

theorem rational_d2_row (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 5) :
    principalAt (modeIndex mode) <=
      aCoeff * principalAt (retardedIndex (modeIndex mode)) := by
  have h := k11_all_rows_valid (modeIndex mode) (principal_modeIndex_lt mode)
  have hclass : modeAt (modeIndex mode) % 9 = 5 := by
    rw [modeAt_modeIndex]
    exact hm
  simp only [K11RowValid] at h
  simp [rowRhs, hclass] at h
  linarith

theorem rational_d3_row (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 8) :
    principalAt (modeIndex mode) <=
      aCoeff * principalAt (retardedIndex (modeIndex mode)) +
        dLower * auxiliaryAt (d3AuxiliaryIndex (modeIndex mode)) := by
  have h := k11_all_rows_valid (modeIndex mode) (principal_modeIndex_lt mode)
  have hclass : modeAt (modeIndex mode) % 9 = 8 := by
    rw [modeAt_modeIndex]
    exact hm
  simp only [K11RowValid] at h
  simp [rowRhs, hclass] at h
  linarith

theorem k11_d1 (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 2) :
    k11Principal mode <=
      k11Principal (fourTrackedMode (by norm_num) mode) *
          lambdaR11 ^ (-2 : Real) +
        k11Auxiliary (d1LowerTrackedMode (by norm_num) mode hm) *
          lambdaR11 ^ (alpha - 2) := by
  apply row_of_bLower
  · change ((principalAt (modeIndex mode) : Rat) : Real) <=
      ((aCoeff : Rat) : Real) *
          ((principalAt (modeIndex (fourTrackedMode (by norm_num) mode)) : Rat) : Real) +
        ((bLower : Rat) : Real) *
          ((auxiliaryAt (modeIndex (d1LowerTrackedMode (by norm_num) mode hm)) : Rat) : Real)
    rw [four_modeIndex, d1_modeIndex]
    exact_mod_cast rational_d1_row mode hm
  · exact (k11Auxiliary_pos _).le

theorem k11_d2 (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 5) :
    k11Principal mode <=
      k11Principal (fourTrackedMode (by norm_num) mode) *
        lambdaR11 ^ (-2 : Real) := by
  apply row_of_aCoeff
  change ((principalAt (modeIndex mode) : Rat) : Real) <=
    ((aCoeff : Rat) : Real) *
      ((principalAt (modeIndex (fourTrackedMode (by norm_num) mode)) : Rat) : Real)
  rw [four_modeIndex]
  exact_mod_cast rational_d2_row mode hm

theorem k11_d3 (mode : TrackedMode 11) (hm : mode.1.1 % 9 = 8) :
    k11Principal mode <=
      k11Principal (fourTrackedMode (by norm_num) mode) *
          lambdaR11 ^ (-2 : Real) +
        k11Auxiliary (d3LowerTrackedMode (by norm_num) mode hm) *
          lambdaR11 ^ (alpha - 1) := by
  apply row_of_dLower
  · change ((principalAt (modeIndex mode) : Rat) : Real) <=
      ((aCoeff : Rat) : Real) *
          ((principalAt (modeIndex (fourTrackedMode (by norm_num) mode)) : Rat) : Real) +
        ((dLower : Rat) : Real) *
          ((auxiliaryAt (modeIndex (d3LowerTrackedMode (by norm_num) mode hm)) : Rat) : Real)
    rw [four_modeIndex, d3_modeIndex]
    exact_mod_cast rational_d3_row mode hm
  · exact (k11Auxiliary_pos _).le

noncomputable def k11LNTCertificate : LNTCertificate (by norm_num : 1 <= 10) where
  lambda := lambdaR11
  principal := k11Principal
  auxiliary := k11Auxiliary
  lambda_pos := lambdaR11_pos
  principal_pos := k11Principal_pos
  auxiliary_pos := k11Auxiliary_pos
  auxiliary_le_lift := k11Auxiliary_le_lift
  d1 := k11_d1
  d2 := k11_d2
  d3 := k11_d3

theorem k11LNTCertificate_lambda_gt_one :
    1 < k11LNTCertificate.lambda := lambdaR11_gt_one

end K11LNTCertificate
end KL2003
end CollatzClassical
