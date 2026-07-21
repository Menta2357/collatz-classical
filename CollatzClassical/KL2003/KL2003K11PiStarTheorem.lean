import CollatzClassical.KL2003.KL2003K11LNTCertificate
import CollatzClassical.KL2003.KL2003K11ClassRoots
import CollatzClassical.KL2003.KL2003GeneralKDynamicRetardedLowerBound

namespace CollatzClassical
namespace KL2003
namespace K11PiStarTheorem

open GeneralKDynamicRetardedLowerBound
open K11ClassRoots
open K11EndpointBounds
open K11LNTCertificate

noncomputable def gammaK11 : Real := Real.logb 2 lambdaR11

theorem gammaK11_gt_four_fifths : (4 / 5 : Real) < gammaK11 := by
  have hpowNat : (2 : Real) ^ 4 < lambdaR11 ^ 5 := by
    norm_num [lambdaR11, K11CertificateMatch.lambda]
  have hpow5 :
      ((2 : Real) ^ (4 / 5 : Real)) ^ (5 : Real) <
        lambdaR11 ^ (5 : Real) := by
    calc
      ((2 : Real) ^ (4 / 5 : Real)) ^ (5 : Real) =
          (2 : Real) ^ ((4 / 5 : Real) * (5 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 4 := by norm_num
      _ < lambdaR11 ^ 5 := hpowNat
      _ = lambdaR11 ^ (5 : Real) := by norm_num
  have hpow : (2 : Real) ^ (4 / 5 : Real) < lambdaR11 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      lambdaR11_pos.le
      (by norm_num : 0 < (5 : Real))).1 hpow5
  dsimp [gammaK11]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (4 / 5 : Real)) (y := lambdaR11)
      (by norm_num : (1 : Real) < 2) lambdaR11_pos).2 hpow

theorem gammaK11_gt_forty_nine_sixtieths :
    (49 / 60 : Real) < gammaK11 := by
  have hpowNat : (2 : Real) ^ 49 < lambdaR11 ^ 60 := by
    norm_num [lambdaR11, K11CertificateMatch.lambda]
  have hpow60 :
      ((2 : Real) ^ (49 / 60 : Real)) ^ (60 : Real) <
        lambdaR11 ^ (60 : Real) := by
    calc
      ((2 : Real) ^ (49 / 60 : Real)) ^ (60 : Real) =
          (2 : Real) ^ ((49 / 60 : Real) * (60 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 49 := by norm_num
      _ < lambdaR11 ^ 60 := hpowNat
      _ = lambdaR11 ^ (60 : Real) := by norm_num
  have hpow : (2 : Real) ^ (49 / 60 : Real) < lambdaR11 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      lambdaR11_pos.le
      (by norm_num : 0 < (60 : Real))).1 hpow60
  dsimp [gammaK11]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (49 / 60 : Real)) (y := lambdaR11)
      (by norm_num : (1 : Real) < 2) lambdaR11_pos).2 hpow

/-- Named exact comparison with the rational benchmark `0.81`. -/
theorem gammaK11_gt_eighty_one_hundredths :
    (81 / 100 : Real) < gammaK11 := by
  have hpowNat : (2 : Real) ^ 81 < lambdaR11 ^ 100 := by
    norm_num [lambdaR11, K11CertificateMatch.lambda]
  have hpow100 :
      ((2 : Real) ^ (81 / 100 : Real)) ^ (100 : Real) <
        lambdaR11 ^ (100 : Real) := by
    calc
      ((2 : Real) ^ (81 / 100 : Real)) ^ (100 : Real) =
          (2 : Real) ^ ((81 / 100 : Real) * (100 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 81 := by norm_num
      _ < lambdaR11 ^ 100 := hpowNat
      _ = lambdaR11 ^ (100 : Real) := by norm_num
  have hpow : (2 : Real) ^ (81 / 100 : Real) < lambdaR11 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      lambdaR11_pos.le
      (by norm_num : 0 < (100 : Real))).1 hpow100
  dsimp [gammaK11]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (81 / 100 : Real)) (y := lambdaR11)
      (by norm_num : (1 : Real) < 2) lambdaR11_pos).2 hpow

/-- Named exact comparison with the KL2003 `0.84` table benchmark. -/
theorem gammaK11_gt_twenty_one_twenty_fifths :
    (21 / 25 : Real) < gammaK11 := by
  have hpowNat : (2 : Real) ^ 21 < lambdaR11 ^ 25 := by
    norm_num [lambdaR11, K11CertificateMatch.lambda]
  have hpow25 :
      ((2 : Real) ^ (21 / 25 : Real)) ^ (25 : Real) <
        lambdaR11 ^ (25 : Real) := by
    calc
      ((2 : Real) ^ (21 / 25 : Real)) ^ (25 : Real) =
          (2 : Real) ^ ((21 / 25 : Real) * (25 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 21 := by norm_num
      _ < lambdaR11 ^ 25 := hpowNat
      _ = lambdaR11 ^ (25 : Real) := by norm_num
  have hpow : (2 : Real) ^ (21 / 25 : Real) < lambdaR11 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      lambdaR11_pos.le
      (by norm_num : 0 < (25 : Real))).1 hpow25
  dsimp [gammaK11]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (21 / 25 : Real)) (y := lambdaR11)
      (by norm_num : (1 : Real) < 2) lambdaR11_pos).2 hpow

theorem two_rpow_gammaK11 : (2 : Real) ^ gammaK11 = lambdaR11 := by
  dsimp [gammaK11]
  exact Real.rpow_logb
    (by norm_num : 0 < (2 : Real))
    (by norm_num : (2 : Real) ≠ 1)
    lambdaR11_pos

theorem lambdaR11_rpow_eq_two_rpow_rpow_gammaK11 (y : Real) :
    lambdaR11 ^ y = ((2 : Real) ^ y) ^ gammaK11 := by
  calc
    lambdaR11 ^ y = ((2 : Real) ^ gammaK11) ^ y := by
      rw [two_rpow_gammaK11]
    _ = (2 : Real) ^ (gammaK11 * y) := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
    _ = (2 : Real) ^ (y * gammaK11) := by rw [mul_comm]
    _ = ((2 : Real) ^ y) ^ gammaK11 := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]

theorem exists_k11_sourcePhiK_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 11) (y : Real), 0 <= y ->
        Delta * lambdaR11 ^ y <= sourcePhiK mode y := by
  obtain ⟨Delta, hDelta, hbound⟩ :=
    exists_sourcePhiK_retarded_lower_bound
      k11_classRoots_nonempty k11LNTCertificate
        k11LNTCertificate_lambda_gt_one.le
  refine ⟨Delta, hDelta, ?_⟩
  intro mode y hy
  have hcoeff :
      Delta * lambdaR11 ^ y <=
        Delta * k11Principal mode * lambdaR11 ^ y := by
    have hnonneg : 0 <= Delta * lambdaR11 ^ y :=
      mul_nonneg hDelta.le (Real.rpow_nonneg lambdaR11_pos.le y)
    calc
      Delta * lambdaR11 ^ y = (Delta * lambdaR11 ^ y) * 1 := by ring
      _ <= (Delta * lambdaR11 ^ y) * k11Principal mode :=
        mul_le_mul_of_nonneg_left (k11Principal_one_le mode) hnonneg
      _ = Delta * k11Principal mode * lambdaR11 ^ y := by ring
  exact hcoeff.trans (hbound mode y hy)

theorem exists_k11_piStar_sourceWindow_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 11) (a : ClassRootsK 11 mode)
        (y : Real), 0 <= y ->
        Delta * (((2 : Real) ^ y) ^ gammaK11) <=
          (piStar a.1 (sourceWindow y a.1) : Real) := by
  obtain ⟨Delta, hDelta, hbound⟩ := exists_k11_sourcePhiK_lower_bound
  refine ⟨Delta, hDelta, ?_⟩
  intro mode a y hy
  rw [← lambdaR11_rpow_eq_two_rpow_rpow_gammaK11 y]
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

theorem two_rpow_logb_ratio_rpow_gammaK11
    {a x : Nat} (ha : 1 <= a) (hx : a <= x) :
    (((2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real)))) ^ gammaK11) =
      (((x : Real) / (a : Real)) ^ gammaK11) := by
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxPos := x_pos_of_root_le ha hx
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hxPos
  have hratio_pos : 0 < (x : Real) / (a : Real) := div_pos hxR_pos haR_pos
  rw [Real.rpow_logb
    (by norm_num : 0 < (2 : Real))
    (by norm_num : (2 : Real) ≠ 1) hratio_pos]

theorem exists_k11_piStar_arbitrary_x_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 11) (a : ClassRootsK 11 mode) (x : Nat),
        a.1 <= x ->
        Delta * (((x : Real) / (a.1 : Real)) ^ gammaK11) <=
          (piStar a.1 x : Real) := by
  obtain ⟨Delta, hDelta, hwindow⟩ :=
    exists_k11_piStar_sourceWindow_lower_bound
  refine ⟨Delta, hDelta, ?_⟩
  intro mode a x hx
  let y := Real.logb 2 ((x : Real) / (a.1 : Real))
  have hy : 0 <= y := logb_ratio_nonneg_of_root_le a.2.2.2 hx
  have hbound := hwindow mode a y hy
  have hwindowEq : sourceWindow y a.1 = x :=
    sourceWindow_logb_eq_self a.2.2.2 hx
  have hrpow : (((2 : Real) ^ y) ^ gammaK11) =
      (((x : Real) / (a.1 : Real)) ^ gammaK11) :=
    two_rpow_logb_ratio_rpow_gammaK11 a.2.2.2 hx
  simpa [hwindowEq, hrpow] using hbound

end K11PiStarTheorem
end KL2003
end CollatzClassical
