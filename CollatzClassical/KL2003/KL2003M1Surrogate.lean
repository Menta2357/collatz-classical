import CollatzClassical.KL2003.KL2003ConcretePhiRealization

namespace CollatzClassical
namespace KL2003

/-!
# KL2003 k=2 M1-surrogate lower bound

This module packages the concrete M0D conclusion into the calibrated
`M1-surrogate` statement for the current concrete window
`concreteWindow y a = ceil (2^y * a)`.

It does not state a global Collatz theorem and does not replace the current
`ceil` window by a `floor` window.
-/

noncomputable def gammaK2 : Real :=
  Real.logb 2 lambdaR

theorem gammaK2_eq_logb :
    gammaK2 = Real.logb 2 (27 / 20 : Real) := by
  norm_num [gammaK2, lambdaR]

theorem gammaK2_gt_three_sevenths :
    (3 / 7 : Real) < gammaK2 := by
  have hpow_nat : (2 : Real) ^ 3 < lambdaR ^ 7 := by
    norm_num [lambdaR]
  have hpow7 :
      ((2 : Real) ^ (3 / 7 : Real)) ^ (7 : Real) <
        lambdaR ^ (7 : Real) := by
    calc
      ((2 : Real) ^ (3 / 7 : Real)) ^ (7 : Real)
          = (2 : Real) ^ ((3 / 7 : Real) * (7 : Real)) := by
            rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
      _ = (2 : Real) ^ 3 := by norm_num
      _ < lambdaR ^ 7 := hpow_nat
      _ = lambdaR ^ (7 : Real) := by norm_num
  have hpow :
      (2 : Real) ^ (3 / 7 : Real) < lambdaR := by
    exact
      (Real.rpow_lt_rpow_iff
        (Real.rpow_nonneg (by norm_num : 0 <= (2 : Real)) _)
        lambdaR_pos.le
        (by norm_num : 0 < (7 : Real))).1 hpow7
  dsimp [gammaK2]
  exact
    (Real.lt_logb_iff_rpow_lt
      (b := (2 : Real)) (x := (3 / 7 : Real)) (y := lambdaR)
      (by norm_num : (1 : Real) < 2) lambdaR_pos).2 hpow

theorem two_rpow_gammaK2 :
    (2 : Real) ^ gammaK2 = lambdaR := by
  dsimp [gammaK2]
  exact
    Real.rpow_logb
      (by norm_num : 0 < (2 : Real))
      (by norm_num : (2 : Real) ≠ 1)
      lambdaR_pos

theorem lambdaR_rpow_eq_two_rpow_rpow_gammaK2 (y : Real) :
    lambdaR ^ y = ((2 : Real) ^ y) ^ gammaK2 := by
  calc
    lambdaR ^ y = ((2 : Real) ^ gammaK2) ^ y := by
      rw [two_rpow_gammaK2]
    _ = (2 : Real) ^ (gammaK2 * y) := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]
    _ = (2 : Real) ^ (y * gammaK2) := by
      rw [mul_comm]
    _ = ((2 : Real) ^ y) ^ gammaK2 := by
      rw [Real.rpow_mul (by norm_num : 0 <= (2 : Real))]

theorem DeltaV2_mul_lambdaR_rpow_le_component
    {m : Nat} {y : Real} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (hy14 : 14 <= y) :
    DeltaV2 * lambdaR ^ y <= concretePhiComponent m y := by
  have hnonneg : 0 <= DeltaV2 * lambdaR ^ y :=
    mul_nonneg DeltaV2_pos.le (Real.rpow_pos_of_pos lambdaR_pos _).le
  rcases hm with rfl | rfl | rfl
  · have hcoeff : (1 : Real) <= c22R := by norm_num [c22R]
    have htarget : DeltaV2 * c22R * lambdaR ^ y <= concretePhi.phi22 y :=
      (concretePhi_retarded_lower_bound y hy14).1
    calc
      DeltaV2 * lambdaR ^ y = (DeltaV2 * lambdaR ^ y) * 1 := by ring
      _ <= (DeltaV2 * lambdaR ^ y) * c22R :=
          mul_le_mul_of_nonneg_left hcoeff hnonneg
      _ = DeltaV2 * c22R * lambdaR ^ y := by ring
      _ <= concretePhiComponent 2 y := htarget
  · have hcoeff : (1 : Real) <= c25R := by norm_num [c25R]
    have htarget : DeltaV2 * c25R * lambdaR ^ y <= concretePhi.phi25 y :=
      (concretePhi_retarded_lower_bound y hy14).2.1
    calc
      DeltaV2 * lambdaR ^ y = (DeltaV2 * lambdaR ^ y) * 1 := by ring
      _ <= (DeltaV2 * lambdaR ^ y) * c25R :=
          mul_le_mul_of_nonneg_left hcoeff hnonneg
      _ = DeltaV2 * c25R * lambdaR ^ y := by ring
      _ <= concretePhiComponent 5 y := htarget
  · have hcoeff : (1 : Real) <= c28R := by norm_num [c28R]
    have htarget : DeltaV2 * c28R * lambdaR ^ y <= concretePhi.phi28 y :=
      (concretePhi_retarded_lower_bound y hy14).2.2
    calc
      DeltaV2 * lambdaR ^ y = (DeltaV2 * lambdaR ^ y) * 1 := by ring
      _ <= (DeltaV2 * lambdaR ^ y) * c28R :=
          mul_le_mul_of_nonneg_left hcoeff hnonneg
      _ = DeltaV2 * c28R * lambdaR ^ y := by ring
      _ <= concretePhiComponent 8 y := htarget

theorem m1_surrogate_member_ceil_window_lower_bound
    {m : Nat} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (a : ClassRoots m) {y : Real} (hy14 : 14 <= y) :
    DeltaV2 * lambdaR ^ y <=
      (piStar a.1 (concreteWindow y a.1) : Real) := by
  have hy0 : 0 <= y := by linarith
  exact
    (DeltaV2_mul_lambdaR_rpow_le_component hm hy14).trans
      (concretePhiComponent_le_piStar_of_classRoot
        (m := m) (y := y) hy0 a)

theorem m1_surrogate_member_ceil_window_lower_bound_gamma
    {m : Nat} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (a : ClassRoots m) {y : Real} (hy14 : 14 <= y) :
    DeltaV2 * (((2 : Real) ^ y) ^ gammaK2) <=
      (piStar a.1 (concreteWindow y a.1) : Real) := by
  rw [← lambdaR_rpow_eq_two_rpow_rpow_gammaK2 y]
  exact m1_surrogate_member_ceil_window_lower_bound hm a hy14

theorem x_pos_of_pow14_mul_root_le {a x : Nat}
    (ha : 0 < a) (hx : ((2 : Nat)^14) * a <= x) :
    0 < x := by
  have hprod : 0 < ((2 : Nat)^14) * a :=
    Nat.mul_pos (by norm_num) ha
  exact lt_of_lt_of_le hprod hx

theorem two_rpow_logb_ratio_mul_root_eq_x {a x : Nat}
    (ha : 0 < a) (hx : 0 < x) :
    (2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real))) * (a : Real)
      = (x : Real) := by
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hx
  have haR_ne : (a : Real) ≠ 0 := ne_of_gt haR_pos
  have hratio_pos : 0 < (x : Real) / (a : Real) :=
    div_pos hxR_pos haR_pos
  calc
    (2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real))) * (a : Real)
        = ((x : Real) / (a : Real)) * (a : Real) := by
          rw [Real.rpow_logb
            (by norm_num : 0 < (2 : Real))
            (by norm_num : (2 : Real) ≠ 1)
            hratio_pos]
    _ = (x : Real) := by
      exact div_mul_cancel₀ (x : Real) haR_ne

theorem concreteWindow_logb_eq_self {a x : Nat}
    (ha : 0 < a) (hx : 0 < x) :
    concreteWindow (Real.logb 2 ((x : Real) / (a : Real))) a = x := by
  unfold concreteWindow
  rw [two_rpow_logb_ratio_mul_root_eq_x ha hx]
  exact Nat.ceil_natCast x

theorem fourteen_le_logb_ratio_of_pow14_mul_root_le {a x : Nat}
    (ha : 0 < a) (hx : ((2 : Nat)^14) * a <= x) :
    (14 : Real) <= Real.logb 2 ((x : Real) / (a : Real)) := by
  have hx_pos : 0 < x := x_pos_of_pow14_mul_root_le ha hx
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hx_pos
  have hratio_pos : 0 < (x : Real) / (a : Real) :=
    div_pos hxR_pos haR_pos
  rw [Real.le_logb_iff_rpow_le
    (b := (2 : Real))
    (x := (14 : Real))
    (y := (x : Real) / (a : Real))
    (by norm_num : (1 : Real) < 2)
    hratio_pos]
  have hxR : (((2 : Nat)^14) * a : Real) <= (x : Real) := by
    exact_mod_cast hx
  have hpow : ((2 : Real) ^ (14 : Real)) = (((2 : Nat)^14 : Nat) : Real) := by
    norm_num
  rw [hpow]
  rw [le_div_iff₀ haR_pos]
  norm_num [Nat.cast_mul] at hxR ⊢
  exact hxR

theorem notInCycle_eight :
    NotInCycle 8 := by
  intro q hq hcycle
  by_cases hsmall : q < 4
  · interval_cases q <;> norm_num [T] at hcycle
  · have hq4 : 4 <= q := by omega
    have hle : T^[q] 8 <= 2 := by
      calc
        T^[q] 8 = T^[(q - 4) + 4] 8 := by
          have hidx : (q - 4) + 4 = q := by omega
          rw [hidx]
        _ = T^[q - 4] (T^[4] 8) := by
          rw [Function.iterate_add_apply]
        _ = T^[q - 4] 2 := by norm_num [T]
        _ <= 2 := iterate_two_le_two (q - 4)
    have h8_le_two : 8 <= 2 := by
      rw [hcycle] at hle
      exact hle
    omega

def classRoot_eight : ClassRoots 8 :=
  ⟨8, by norm_num, notInCycle_eight, by norm_num⟩

theorem kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
    {m : Nat} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (a : ClassRoots m) {x : Nat}
    (hx : ((2 : Nat)^14) * a.1 <= x) :
    DeltaV2 * (((x : Real) / (a.1 : Real)) ^ gammaK2)
      <= (piStar a.1 x : Real) := by
  let y : Real := Real.logb 2 ((x : Real) / (a.1 : Real))
  have ha_pos : 0 < a.1 := by omega
  have hx_pos : 0 < x := x_pos_of_pow14_mul_root_le ha_pos hx
  have hy14 : 14 <= y :=
    fourteen_le_logb_ratio_of_pow14_mul_root_le ha_pos hx
  have hwin : concreteWindow y a.1 = x :=
    concreteWindow_logb_eq_self ha_pos hx_pos
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hx_pos
  have haR_pos : 0 < (a.1 : Real) := by exact_mod_cast ha_pos
  have hratio_pos : 0 < (x : Real) / (a.1 : Real) :=
    div_pos hxR_pos haR_pos
  have hrpow :
      (2 : Real) ^ y = (x : Real) / (a.1 : Real) := by
    dsimp [y]
    exact
      Real.rpow_logb
        (by norm_num : 0 < (2 : Real))
        (by norm_num : (2 : Real) ≠ 1)
        hratio_pos
  have hmain :
      DeltaV2 * (((2 : Real) ^ y) ^ gammaK2) <=
        (piStar a.1 (concreteWindow y a.1) : Real) :=
    m1_surrogate_member_ceil_window_lower_bound_gamma hm a hy14
  calc
    DeltaV2 * (((x : Real) / (a.1 : Real)) ^ gammaK2)
        = DeltaV2 * (((2 : Real) ^ y) ^ gammaK2) := by
          rw [hrpow]
    _ <= (piStar a.1 (concreteWindow y a.1) : Real) := hmain
    _ = (piStar a.1 x : Real) := by rw [hwin]

theorem kl2003_k2_m1_surrogate_arbitrary_x_lower_bound
    {m : Nat} (hm : m = 2 ∨ m = 5 ∨ m = 8)
    (a : ClassRoots m) {x : Nat}
    (hx : ((2 : Nat)^14) * a.1 <= x) :
    DeltaV2 * (((x : Real) / (a.1 : Real)) ^ gammaK2)
      <= (piStar a.1 x : Real) :=
  kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component hm a hx

theorem kl2003_k2_m1_surrogate_root8_lower_bound
    {x : Nat} (hx : ((2 : Nat)^17) <= x) :
    DeltaV2 * (((x : Real) / 8) ^ gammaK2)
      <= (piStar 8 x : Real) := by
  have hx_component : ((2 : Nat)^14) * classRoot_eight.1 <= x := by
    norm_num [classRoot_eight] at hx ⊢
    exact hx
  simpa [classRoot_eight] using
    kl2003_k2_m1_surrogate_arbitrary_x_lower_bound_component
      (m := 8) (Or.inr (Or.inr rfl)) classRoot_eight hx_component

def M1SurrogateK2CeilWindowStatement : Prop :=
  0 < DeltaV2 ∧
    (3 / 7 : Real) < gammaK2 ∧
      forall {m : Nat}, m = 2 ∨ m = 5 ∨ m = 8 ->
        forall (a : ClassRoots m) {y : Real}, 14 <= y ->
          DeltaV2 * (((2 : Real) ^ y) ^ gammaK2) <=
            (piStar a.1 (concreteWindow y a.1) : Real)

theorem kl2003_k2_m1_surrogate_ceil_window_lower_bound :
    M1SurrogateK2CeilWindowStatement := by
  exact
    ⟨DeltaV2_pos, gammaK2_gt_three_sevenths, by
      intro m hm a y hy14
      exact m1_surrogate_member_ceil_window_lower_bound_gamma hm a hy14⟩

end KL2003
end CollatzClassical
