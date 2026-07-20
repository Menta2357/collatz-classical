import CollatzClassical.KL2003.KL2003GeneralKDynamicRetardedLowerBound
import CollatzClassical.KL2003.KL2003K3CertificateVerifier

namespace CollatzClassical
namespace KL2003
namespace K3LNTCertificate

open GeneralKLNTFeasibilityTransfer

noncomputable def k3Principal (mode : TrackedMode 3) : Real :=
  match mode.1.1 with
  | 2 => (GeneratedK3.c3_2 : Real)
  | 5 => (GeneratedK3.c3_5 : Real)
  | 8 => (GeneratedK3.c3_8 : Real)
  | 11 => (GeneratedK3.c3_11 : Real)
  | 14 => (GeneratedK3.c3_14 : Real)
  | 17 => (GeneratedK3.c3_17 : Real)
  | 20 => (GeneratedK3.c3_20 : Real)
  | 23 => (GeneratedK3.c3_23 : Real)
  | 26 => (GeneratedK3.c3_26 : Real)
  | _ => 1

noncomputable def k3Auxiliary (mode : TrackedMode 2) : Real :=
  match mode.1.1 with
  | 2 => (GeneratedK3.c2_2 : Real)
  | 5 => (GeneratedK3.c2_5 : Real)
  | 8 => (GeneratedK3.c2_8 : Real)
  | _ => 1

theorem k3Principal_pos (mode : TrackedMode 3) : 0 < k3Principal mode := by
  rcases mode with ⟨⟨n, hn⟩, hnmod⟩
  norm_num [generalKModulus] at hn
  interval_cases n <;>
    norm_num [k3Principal, GeneratedK3.c3_2, GeneratedK3.c3_5,
      GeneratedK3.c3_8, GeneratedK3.c3_11, GeneratedK3.c3_14,
      GeneratedK3.c3_17, GeneratedK3.c3_20, GeneratedK3.c3_23,
      GeneratedK3.c3_26] at hnmod ⊢

theorem k3Auxiliary_pos (mode : TrackedMode 2) : 0 < k3Auxiliary mode := by
  rcases mode with ⟨⟨n, hn⟩, hnmod⟩
  norm_num [generalKModulus] at hn
  interval_cases n <;>
    norm_num [k3Auxiliary, GeneratedK3.c2_2, GeneratedK3.c2_5,
      GeneratedK3.c2_8] at hnmod ⊢

theorem k3Auxiliary_le_lift (mode : TrackedMode 2) (j : Fin 3) :
    k3Auxiliary mode <= k3Principal (liftTrackedMode (by norm_num) mode j) := by
  rcases mode with ⟨⟨n, hn⟩, hnmod⟩
  rcases j with ⟨j, hj⟩
  norm_num [generalKModulus] at hn
  interval_cases n <;> interval_cases j <;>
    norm_num [k3Auxiliary, k3Principal, liftTrackedMode,
      generalKModulus, GeneratedK3.c2_2, GeneratedK3.c2_5,
      GeneratedK3.c2_8, GeneratedK3.c3_2, GeneratedK3.c3_5,
      GeneratedK3.c3_8, GeneratedK3.c3_11, GeneratedK3.c3_14,
      GeneratedK3.c3_17, GeneratedK3.c3_20, GeneratedK3.c3_23,
      GeneratedK3.c3_26] at hnmod ⊢

theorem aCoeff_real_eq_lambda_neg_two :
    (GeneratedK3.aCoeff : Real) = K3Verifier.lambdaR3 ^ (-2 : Real) := by
  norm_num [GeneratedK3.aCoeff, K3Verifier.lambdaR3, GeneratedK3.lambda,
    Real.rpow_neg (by norm_num : (0 : Real) <= 152759 / 100000)]

theorem row_of_bLower
    {current retarded auxiliary : Real}
    (hrow : current <= (GeneratedK3.aCoeff : Real) * retarded +
      (GeneratedK3.bLower : Real) * auxiliary)
    (hauxiliary : 0 <= auxiliary) :
    current <= retarded * K3Verifier.lambdaR3 ^ (-2 : Real) +
      auxiliary * K3Verifier.lambdaR3 ^ (alpha - 2) := by
  calc
    current <= (GeneratedK3.aCoeff : Real) * retarded +
        (GeneratedK3.bLower : Real) * auxiliary := hrow
    _ <= K3Verifier.lambdaR3 ^ (-2 : Real) * retarded +
        K3Verifier.bReal3 * auxiliary := by
      apply add_le_add
      · rw [aCoeff_real_eq_lambda_neg_two]
      · exact mul_le_mul_of_nonneg_right K3Verifier.bReal3_lower hauxiliary
    _ = retarded * K3Verifier.lambdaR3 ^ (-2 : Real) +
        auxiliary * K3Verifier.lambdaR3 ^ (alpha - 2) := by
      rw [K3Verifier.bReal3]
      ring

theorem row_of_dLower
    {current retarded auxiliary : Real}
    (hrow : current <= (GeneratedK3.aCoeff : Real) * retarded +
      (GeneratedK3.dLower : Real) * auxiliary)
    (hauxiliary : 0 <= auxiliary) :
    current <= retarded * K3Verifier.lambdaR3 ^ (-2 : Real) +
      auxiliary * K3Verifier.lambdaR3 ^ (alpha - 1) := by
  calc
    current <= (GeneratedK3.aCoeff : Real) * retarded +
        (GeneratedK3.dLower : Real) * auxiliary := hrow
    _ <= K3Verifier.lambdaR3 ^ (-2 : Real) * retarded +
        K3Verifier.dReal3 * auxiliary := by
      apply add_le_add
      · rw [aCoeff_real_eq_lambda_neg_two]
      · exact mul_le_mul_of_nonneg_right K3Verifier.dReal3_lower hauxiliary
    _ = retarded * K3Verifier.lambdaR3 ^ (-2 : Real) +
        auxiliary * K3Verifier.lambdaR3 ^ (alpha - 1) := by
      rw [K3Verifier.dReal3]
      ring

theorem row_of_aCoeff {current retarded : Real}
    (hrow : current <= (GeneratedK3.aCoeff : Real) * retarded) :
    current <= retarded * K3Verifier.lambdaR3 ^ (-2 : Real) := by
  rw [aCoeff_real_eq_lambda_neg_two] at hrow
  simpa [mul_comm] using hrow

theorem k3_row2 :
    (GeneratedK3.c3_2 : Real) <=
      (GeneratedK3.c3_8 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) +
        (GeneratedK3.c2_2 : Real) * K3Verifier.lambdaR3 ^ (alpha - 2) := by
  apply row_of_bLower
  · norm_num [GeneratedK3.aCoeff, GeneratedK3.bLower, GeneratedK3.c3_2,
      GeneratedK3.c3_8, GeneratedK3.c2_2]
  · norm_num [GeneratedK3.c2_2]

theorem k3_row5 :
    (GeneratedK3.c3_5 : Real) <=
      (GeneratedK3.c3_20 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) := by
  apply row_of_aCoeff
  norm_num [GeneratedK3.aCoeff, GeneratedK3.c3_5, GeneratedK3.c3_20]

theorem k3_row8 :
    (GeneratedK3.c3_8 : Real) <=
      (GeneratedK3.c3_5 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) +
        (GeneratedK3.c2_5 : Real) * K3Verifier.lambdaR3 ^ (alpha - 1) := by
  apply row_of_dLower
  · norm_num [GeneratedK3.aCoeff, GeneratedK3.dLower, GeneratedK3.c3_8,
      GeneratedK3.c3_5, GeneratedK3.c2_5]
  · norm_num [GeneratedK3.c2_5]

theorem k3_row11 :
    (GeneratedK3.c3_11 : Real) <=
      (GeneratedK3.c3_17 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) +
        (GeneratedK3.c2_5 : Real) * K3Verifier.lambdaR3 ^ (alpha - 2) := by
  apply row_of_bLower
  · norm_num [GeneratedK3.aCoeff, GeneratedK3.bLower, GeneratedK3.c3_11,
      GeneratedK3.c3_17, GeneratedK3.c2_5]
  · norm_num [GeneratedK3.c2_5]

theorem k3_row14 :
    (GeneratedK3.c3_14 : Real) <=
      (GeneratedK3.c3_2 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) := by
  apply row_of_aCoeff
  norm_num [GeneratedK3.aCoeff, GeneratedK3.c3_14, GeneratedK3.c3_2]

theorem k3_row17 :
    (GeneratedK3.c3_17 : Real) <=
      (GeneratedK3.c3_14 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) +
        (GeneratedK3.c2_2 : Real) * K3Verifier.lambdaR3 ^ (alpha - 1) := by
  apply row_of_dLower
  · norm_num [GeneratedK3.aCoeff, GeneratedK3.dLower, GeneratedK3.c3_17,
      GeneratedK3.c3_14, GeneratedK3.c2_2]
  · norm_num [GeneratedK3.c2_2]

theorem k3_row20 :
    (GeneratedK3.c3_20 : Real) <=
      (GeneratedK3.c3_26 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) +
        (GeneratedK3.c2_8 : Real) * K3Verifier.lambdaR3 ^ (alpha - 2) := by
  apply row_of_bLower
  · norm_num [GeneratedK3.aCoeff, GeneratedK3.bLower, GeneratedK3.c3_20,
      GeneratedK3.c3_26, GeneratedK3.c2_8]
  · norm_num [GeneratedK3.c2_8]

theorem k3_row23 :
    (GeneratedK3.c3_23 : Real) <=
      (GeneratedK3.c3_11 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) := by
  apply row_of_aCoeff
  norm_num [GeneratedK3.aCoeff, GeneratedK3.c3_23, GeneratedK3.c3_11]

theorem k3_row26 :
    (GeneratedK3.c3_26 : Real) <=
      (GeneratedK3.c3_23 : Real) * K3Verifier.lambdaR3 ^ (-2 : Real) +
        (GeneratedK3.c2_8 : Real) * K3Verifier.lambdaR3 ^ (alpha - 1) := by
  apply row_of_dLower
  · norm_num [GeneratedK3.aCoeff, GeneratedK3.dLower, GeneratedK3.c3_26,
      GeneratedK3.c3_23, GeneratedK3.c2_8]
  · norm_num [GeneratedK3.c2_8]

theorem k3_d1 (mode : TrackedMode 3) (hm : mode.1.1 % 9 = 2) :
    k3Principal mode <=
      k3Principal (fourTrackedMode (by norm_num) mode) *
          K3Verifier.lambdaR3 ^ (-2 : Real) +
        k3Auxiliary (d1LowerTrackedMode (by norm_num) mode hm) *
          K3Verifier.lambdaR3 ^ (alpha - 2) := by
  rcases mode with ⟨⟨n, hn⟩, hnmod⟩
  norm_num [generalKModulus] at hn
  interval_cases n <;> norm_num at hnmod hm
  all_goals
    simp only [k3Principal, k3Auxiliary, fourTrackedMode,
      d1LowerTrackedMode, d1RawLowerModeValue, generalKModulus,
      Nat.reducePow, Nat.reduceMod, Nat.reduceMul, Nat.reduceSub,
      Nat.reduceDiv]
  · exact k3_row2
  · exact k3_row11
  · exact k3_row20

theorem k3_d2 (mode : TrackedMode 3) (hm : mode.1.1 % 9 = 5) :
    k3Principal mode <=
      k3Principal (fourTrackedMode (by norm_num) mode) *
        K3Verifier.lambdaR3 ^ (-2 : Real) := by
  rcases mode with ⟨⟨n, hn⟩, hnmod⟩
  norm_num [generalKModulus] at hn
  interval_cases n <;> norm_num at hnmod hm
  all_goals
    simp only [k3Principal, fourTrackedMode, generalKModulus,
      Nat.reducePow, Nat.reduceMod, Nat.reduceMul]
  · exact k3_row5
  · exact k3_row14
  · exact k3_row23

theorem k3_d3 (mode : TrackedMode 3) (hm : mode.1.1 % 9 = 8) :
    k3Principal mode <=
      k3Principal (fourTrackedMode (by norm_num) mode) *
          K3Verifier.lambdaR3 ^ (-2 : Real) +
        k3Auxiliary (d3LowerTrackedMode (by norm_num) mode hm) *
          K3Verifier.lambdaR3 ^ (alpha - 1) := by
  rcases mode with ⟨⟨n, hn⟩, hnmod⟩
  norm_num [generalKModulus] at hn
  interval_cases n <;> norm_num at hnmod hm
  all_goals
    simp only [k3Principal, k3Auxiliary, fourTrackedMode,
      d3LowerTrackedMode, d3RawLowerModeValue, generalKModulus,
      Nat.reducePow, Nat.reduceMod, Nat.reduceMul, Nat.reduceSub,
      Nat.reduceDiv]
  · exact k3_row8
  · exact k3_row17
  · exact k3_row26

noncomputable def k3LNTCertificate : LNTCertificate (by norm_num : 1 <= 2) where
  lambda := K3Verifier.lambdaR3
  principal := k3Principal
  auxiliary := k3Auxiliary
  lambda_pos := K3Verifier.lambdaR3_pos
  principal_pos := k3Principal_pos
  auxiliary_pos := k3Auxiliary_pos
  auxiliary_le_lift := k3Auxiliary_le_lift
  d1 := k3_d1
  d2 := k3_d2
  d3 := k3_d3

theorem k3LNTCertificate_lambda_gt_one :
    1 < k3LNTCertificate.lambda := K3Verifier.lambdaR3_gt_one

theorem one_le_k3Principal (mode : TrackedMode 3) : 1 <= k3Principal mode := by
  rcases mode with ⟨⟨n, hn⟩, hnmod⟩
  norm_num [generalKModulus] at hn
  interval_cases n <;>
    norm_num [k3Principal, GeneratedK3.c3_2, GeneratedK3.c3_5,
      GeneratedK3.c3_8, GeneratedK3.c3_11, GeneratedK3.c3_14,
      GeneratedK3.c3_17, GeneratedK3.c3_20, GeneratedK3.c3_23,
      GeneratedK3.c3_26] at hnmod ⊢

noncomputable def gammaK3 : Real := Real.logb 2 K3Verifier.lambdaR3

theorem gammaK3_gt_three_fifths : (3 / 5 : Real) < gammaK3 := by
  have hpow_nat : (2 : Real) ^ 3 < K3Verifier.lambdaR3 ^ 5 := by
    norm_num [K3Verifier.lambdaR3, GeneratedK3.lambda]
  have hpow5 :
      ((2 : Real) ^ (3 / 5 : Real)) ^ (5 : Real) <
        K3Verifier.lambdaR3 ^ (5 : Real) := by
    calc
      ((2 : Real) ^ (3 / 5 : Real)) ^ (5 : Real) =
          (2 : Real) ^ ((3 / 5 : Real) * (5 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 3 := by norm_num
      _ < K3Verifier.lambdaR3 ^ 5 := hpow_nat
      _ = K3Verifier.lambdaR3 ^ (5 : Real) := by norm_num
  have hpow : (2 : Real) ^ (3 / 5 : Real) < K3Verifier.lambdaR3 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      K3Verifier.lambdaR3_pos.le
      (by norm_num : 0 < (5 : Real))).1 hpow5
  dsimp [gammaK3]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (3 / 5 : Real))
      (y := K3Verifier.lambdaR3)
      (by norm_num : (1 : Real) < 2) K3Verifier.lambdaR3_pos).2 hpow

theorem two_rpow_gammaK3 : (2 : Real) ^ gammaK3 = K3Verifier.lambdaR3 := by
  dsimp [gammaK3]
  exact Real.rpow_logb
    (by norm_num : 0 < (2 : Real))
    (by norm_num : (2 : Real) ≠ 1)
    K3Verifier.lambdaR3_pos

theorem lambdaR3_rpow_eq_two_rpow_rpow_gammaK3 (y : Real) :
    K3Verifier.lambdaR3 ^ y = ((2 : Real) ^ y) ^ gammaK3 := by
  calc
    K3Verifier.lambdaR3 ^ y = ((2 : Real) ^ gammaK3) ^ y := by
      rw [two_rpow_gammaK3]
    _ = (2 : Real) ^ (gammaK3 * y) := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
    _ = (2 : Real) ^ (y * gammaK3) := by rw [mul_comm]
    _ = ((2 : Real) ^ y) ^ gammaK3 := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]

theorem exists_k3_sourcePhiK_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 3) (y : Real), 0 <= y ->
        Delta * K3Verifier.lambdaR3 ^ y <= sourcePhiK mode y := by
  obtain ⟨Delta, hDelta, hbound⟩ :=
    GeneralKDynamicRetardedLowerBound.exists_sourcePhiK_retarded_lower_bound
      k3_classRoots_nonempty k3LNTCertificate
        k3LNTCertificate_lambda_gt_one.le
  refine ⟨Delta, hDelta, ?_⟩
  intro mode y hy
  have hcoeff :
      Delta * K3Verifier.lambdaR3 ^ y <=
        Delta * k3Principal mode * K3Verifier.lambdaR3 ^ y := by
    have hnonneg : 0 <= Delta * K3Verifier.lambdaR3 ^ y :=
      mul_nonneg hDelta.le (Real.rpow_nonneg K3Verifier.lambdaR3_pos.le y)
    calc
      Delta * K3Verifier.lambdaR3 ^ y =
          (Delta * K3Verifier.lambdaR3 ^ y) * 1 := by ring
      _ <= (Delta * K3Verifier.lambdaR3 ^ y) * k3Principal mode :=
        mul_le_mul_of_nonneg_left (one_le_k3Principal mode) hnonneg
      _ = Delta * k3Principal mode * K3Verifier.lambdaR3 ^ y := by ring
  exact hcoeff.trans (hbound mode y hy)

theorem exists_k3_piStar_sourceWindow_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 3) (a : ClassRootsK 3 mode)
        (y : Real), 0 <= y ->
        Delta * (((2 : Real) ^ y) ^ gammaK3) <=
          (piStar a.1 (sourceWindow y a.1) : Real) := by
  obtain ⟨Delta, hDelta, hbound⟩ := exists_k3_sourcePhiK_lower_bound
  refine ⟨Delta, hDelta, ?_⟩
  intro mode a y hy
  rw [← lambdaR3_rpow_eq_two_rpow_rpow_gammaK3 y]
  exact (hbound mode y hy).trans (sourcePhiK_le_piStar hy a)

theorem x_pos_of_root_le {a x : Nat} (ha : 1 <= a) (hx : a <= x) :
    0 < x := lt_of_lt_of_le (by omega) hx

theorem two_rpow_logb_ratio_mul_root_eq_x
    {a x : Nat} (ha : 1 <= a) (hx : a <= x) :
    (2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real))) * (a : Real) =
      (x : Real) := by
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxPos := x_pos_of_root_le ha hx
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hxPos
  have hratio_pos : 0 < (x : Real) / (a : Real) := div_pos hxR_pos haR_pos
  calc
    (2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real))) * (a : Real) =
        ((x : Real) / (a : Real)) * (a : Real) := by
      rw [Real.rpow_logb
        (by norm_num : 0 < (2 : Real))
        (by norm_num : (2 : Real) ≠ 1) hratio_pos]
    _ = (x : Real) := by field_simp

theorem sourceWindow_logb_eq_self
    {a x : Nat} (ha : 1 <= a) (hx : a <= x) :
    sourceWindow (Real.logb 2 ((x : Real) / (a : Real))) a = x := by
  unfold sourceWindow
  rw [two_rpow_logb_ratio_mul_root_eq_x ha hx]
  exact Nat.floor_natCast x

theorem logb_ratio_nonneg_of_root_le
    {a x : Nat} (ha : 1 <= a) (hx : a <= x) :
    0 <= Real.logb 2 ((x : Real) / (a : Real)) := by
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxR : (a : Real) <= (x : Real) := by exact_mod_cast hx
  have hratio : (1 : Real) <= (x : Real) / (a : Real) := by
    exact (le_div_iff₀ haR_pos).2 (by simpa using hxR)
  exact Real.logb_nonneg (by norm_num) hratio

theorem two_rpow_logb_ratio_rpow_gammaK3
    {a x : Nat} (ha : 1 <= a) (hx : a <= x) :
    (((2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real)))) ^ gammaK3) =
      (((x : Real) / (a : Real)) ^ gammaK3) := by
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxPos := x_pos_of_root_le ha hx
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hxPos
  have hratio_pos : 0 < (x : Real) / (a : Real) := div_pos hxR_pos haR_pos
  rw [Real.rpow_logb
    (by norm_num : 0 < (2 : Real))
    (by norm_num : (2 : Real) ≠ 1) hratio_pos]

theorem exists_k3_piStar_arbitrary_x_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 3) (a : ClassRootsK 3 mode) (x : Nat),
        a.1 <= x ->
        Delta * (((x : Real) / (a.1 : Real)) ^ gammaK3) <=
          (piStar a.1 x : Real) := by
  obtain ⟨Delta, hDelta, hwindow⟩ := exists_k3_piStar_sourceWindow_lower_bound
  refine ⟨Delta, hDelta, ?_⟩
  intro mode a x hx
  let y := Real.logb 2 ((x : Real) / (a.1 : Real))
  have hy : 0 <= y := logb_ratio_nonneg_of_root_le a.2.2.2 hx
  have hbound := hwindow mode a y hy
  have hwindowEq : sourceWindow y a.1 = x :=
    sourceWindow_logb_eq_self a.2.2.2 hx
  have hrpow : (((2 : Real) ^ y) ^ gammaK3) =
      (((x : Real) / (a.1 : Real)) ^ gammaK3) :=
    two_rpow_logb_ratio_rpow_gammaK3 a.2.2.2 hx
  simpa [hwindowEq, hrpow] using hbound

end K3LNTCertificate
end KL2003
end CollatzClassical
