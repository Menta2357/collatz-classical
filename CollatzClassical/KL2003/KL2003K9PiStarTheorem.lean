import CollatzClassical.KL2003.KL2003K9LNTCertificate
import CollatzClassical.KL2003.KL2003K9ClassRoots
import CollatzClassical.KL2003.KL2003GeneralKDynamicRetardedLowerBound

namespace CollatzClassical
namespace KL2003
namespace K9PiStarTheorem

open GeneralKDynamicRetardedLowerBound
open K9ClassRoots
open K9EndpointBounds
open K9LNTCertificate

noncomputable def gammaK9 : Real := Real.logb 2 lambdaR9

theorem gammaK9_gt_four_fifths : (4 / 5 : Real) < gammaK9 := by
  have hpowNat : (2 : Real) ^ 4 < lambdaR9 ^ 5 := by
    norm_num [lambdaR9, K9CertificateMatch.lambda]
  have hpow5 :
      ((2 : Real) ^ (4 / 5 : Real)) ^ (5 : Real) <
        lambdaR9 ^ (5 : Real) := by
    calc
      ((2 : Real) ^ (4 / 5 : Real)) ^ (5 : Real) =
          (2 : Real) ^ ((4 / 5 : Real) * (5 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 4 := by norm_num
      _ < lambdaR9 ^ 5 := hpowNat
      _ = lambdaR9 ^ (5 : Real) := by norm_num
  have hpow : (2 : Real) ^ (4 / 5 : Real) < lambdaR9 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      lambdaR9_pos.le
      (by norm_num : 0 < (5 : Real))).1 hpow5
  dsimp [gammaK9]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (4 / 5 : Real)) (y := lambdaR9)
      (by norm_num : (1 : Real) < 2) lambdaR9_pos).2 hpow

theorem gammaK9_gt_forty_nine_sixtieths :
    (49 / 60 : Real) < gammaK9 := by
  have hpowNat : (2 : Real) ^ 49 < lambdaR9 ^ 60 := by
    norm_num [lambdaR9, K9CertificateMatch.lambda]
  have hpow60 :
      ((2 : Real) ^ (49 / 60 : Real)) ^ (60 : Real) <
        lambdaR9 ^ (60 : Real) := by
    calc
      ((2 : Real) ^ (49 / 60 : Real)) ^ (60 : Real) =
          (2 : Real) ^ ((49 / 60 : Real) * (60 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 49 := by norm_num
      _ < lambdaR9 ^ 60 := hpowNat
      _ = lambdaR9 ^ (60 : Real) := by norm_num
  have hpow : (2 : Real) ^ (49 / 60 : Real) < lambdaR9 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      lambdaR9_pos.le
      (by norm_num : 0 < (60 : Real))).1 hpow60
  dsimp [gammaK9]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (49 / 60 : Real)) (y := lambdaR9)
      (by norm_num : (1 : Real) < 2) lambdaR9_pos).2 hpow

/-- Named exact comparison with the rational benchmark `0.81`. -/
theorem gammaK9_gt_eighty_one_hundredths :
    (81 / 100 : Real) < gammaK9 := by
  have hpowNat : (2 : Real) ^ 81 < lambdaR9 ^ 100 := by
    norm_num [lambdaR9, K9CertificateMatch.lambda]
  have hpow100 :
      ((2 : Real) ^ (81 / 100 : Real)) ^ (100 : Real) <
        lambdaR9 ^ (100 : Real) := by
    calc
      ((2 : Real) ^ (81 / 100 : Real)) ^ (100 : Real) =
          (2 : Real) ^ ((81 / 100 : Real) * (100 : Real)) := by
        rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 81 := by norm_num
      _ < lambdaR9 ^ 100 := hpowNat
      _ = lambdaR9 ^ (100 : Real) := by norm_num
  have hpow : (2 : Real) ^ (81 / 100 : Real) < lambdaR9 :=
    (Real.rpow_lt_rpow_iff
      (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
      lambdaR9_pos.le
      (by norm_num : 0 < (100 : Real))).1 hpow100
  dsimp [gammaK9]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (81 / 100 : Real)) (y := lambdaR9)
      (by norm_num : (1 : Real) < 2) lambdaR9_pos).2 hpow

theorem two_rpow_gammaK9 : (2 : Real) ^ gammaK9 = lambdaR9 := by
  dsimp [gammaK9]
  exact Real.rpow_logb
    (by norm_num : 0 < (2 : Real))
    (by norm_num : (2 : Real) ≠ 1)
    lambdaR9_pos

theorem lambdaR9_rpow_eq_two_rpow_rpow_gammaK9 (y : Real) :
    lambdaR9 ^ y = ((2 : Real) ^ y) ^ gammaK9 := by
  calc
    lambdaR9 ^ y = ((2 : Real) ^ gammaK9) ^ y := by
      rw [two_rpow_gammaK9]
    _ = (2 : Real) ^ (gammaK9 * y) := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
    _ = (2 : Real) ^ (y * gammaK9) := by rw [mul_comm]
    _ = ((2 : Real) ^ y) ^ gammaK9 := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]

theorem exists_k9_sourcePhiK_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 9) (y : Real), 0 <= y ->
        Delta * lambdaR9 ^ y <= sourcePhiK mode y := by
  obtain ⟨Delta, hDelta, hbound⟩ :=
    exists_sourcePhiK_retarded_lower_bound
      k9_classRoots_nonempty k9LNTCertificate
        k9LNTCertificate_lambda_gt_one.le
  refine ⟨Delta, hDelta, ?_⟩
  intro mode y hy
  have hcoeff :
      Delta * lambdaR9 ^ y <=
        Delta * k9Principal mode * lambdaR9 ^ y := by
    have hnonneg : 0 <= Delta * lambdaR9 ^ y :=
      mul_nonneg hDelta.le (Real.rpow_nonneg lambdaR9_pos.le y)
    calc
      Delta * lambdaR9 ^ y = (Delta * lambdaR9 ^ y) * 1 := by ring
      _ <= (Delta * lambdaR9 ^ y) * k9Principal mode :=
        mul_le_mul_of_nonneg_left (k9Principal_one_le mode) hnonneg
      _ = Delta * k9Principal mode * lambdaR9 ^ y := by ring
  exact hcoeff.trans (hbound mode y hy)

theorem exists_k9_piStar_sourceWindow_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 9) (a : ClassRootsK 9 mode)
        (y : Real), 0 <= y ->
        Delta * (((2 : Real) ^ y) ^ gammaK9) <=
          (piStar a.1 (sourceWindow y a.1) : Real) := by
  obtain ⟨Delta, hDelta, hbound⟩ := exists_k9_sourcePhiK_lower_bound
  refine ⟨Delta, hDelta, ?_⟩
  intro mode a y hy
  rw [← lambdaR9_rpow_eq_two_rpow_rpow_gammaK9 y]
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

theorem two_rpow_logb_ratio_rpow_gammaK9
    {a x : Nat} (ha : 1 <= a) (hx : a <= x) :
    (((2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real)))) ^ gammaK9) =
      (((x : Real) / (a : Real)) ^ gammaK9) := by
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxPos := x_pos_of_root_le ha hx
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hxPos
  have hratio_pos : 0 < (x : Real) / (a : Real) := div_pos hxR_pos haR_pos
  rw [Real.rpow_logb
    (by norm_num : 0 < (2 : Real))
    (by norm_num : (2 : Real) ≠ 1) hratio_pos]

theorem exists_k9_piStar_arbitrary_x_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 9) (a : ClassRootsK 9 mode) (x : Nat),
        a.1 <= x ->
        Delta * (((x : Real) / (a.1 : Real)) ^ gammaK9) <=
          (piStar a.1 x : Real) := by
  obtain ⟨Delta, hDelta, hwindow⟩ :=
    exists_k9_piStar_sourceWindow_lower_bound
  refine ⟨Delta, hDelta, ?_⟩
  intro mode a x hx
  let y := Real.logb 2 ((x : Real) / (a.1 : Real))
  have hy : 0 <= y := logb_ratio_nonneg_of_root_le a.2.2.2 hx
  have hbound := hwindow mode a y hy
  have hwindowEq : sourceWindow y a.1 = x :=
    sourceWindow_logb_eq_self a.2.2.2 hx
  have hrpow : (((2 : Real) ^ y) ^ gammaK9) =
      (((x : Real) / (a.1 : Real)) ^ gammaK9) :=
    two_rpow_logb_ratio_rpow_gammaK9 a.2.2.2 hx
  simpa [hwindowEq, hrpow] using hbound

end K9PiStarTheorem
end KL2003
end CollatzClassical
