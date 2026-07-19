import CollatzClassical.KL2003.KL2003K2AlphaBounds
import Mathlib.Algebra.Order.Floor.Semiring
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace CollatzClassical
namespace KL2003

/-!
Source-faithful floor-window traffic for the future general-k chain.

The paper counts integers below the real bound `2^y * a`; `sourceWindow`
therefore uses `Nat.floor`.  This module is independent of the existing k=2
`concreteWindow`, which intentionally uses `Nat.ceil` and remains unchanged.
-/

noncomputable def sourceWindow (y : Real) (a : Nat) : Nat :=
  Nat.floor ((2 : Real) ^ y * (a : Real))

theorem sourceWindow_mono_y {y1 y2 : Real} {a : Nat}
    (hy : y1 <= y2) :
    sourceWindow y1 a <= sourceWindow y2 a := by
  unfold sourceWindow
  apply Nat.floor_mono
  have hpow : (2 : Real) ^ y1 <= (2 : Real) ^ y2 :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : Real) <= 2) hy
  exact mul_le_mul_of_nonneg_right hpow (Nat.cast_nonneg a)

theorem root_le_sourceWindow {y : Real} {a : Nat}
    (hy : 0 <= y) :
    a <= sourceWindow y a := by
  unfold sourceWindow
  apply Nat.le_floor
  have hpow : (1 : Real) <= (2 : Real) ^ y := by
    simpa using
      (Real.rpow_le_rpow_of_exponent_le
        (by norm_num : (1 : Real) <= 2) hy)
  simpa [one_mul] using
    mul_le_mul_of_nonneg_right hpow (Nat.cast_nonneg a)

theorem sourceWindow_retarded_four (y : Real) (a : Nat) :
    sourceWindow (y - 2) (4 * a) = sourceWindow y a := by
  unfold sourceWindow
  apply congrArg Nat.floor
  calc
    (2 : Real) ^ (y - 2) * ((4 * a : Nat) : Real)
        = ((2 : Real) ^ y / (2 : Real) ^ (2 : Real)) *
            (4 * (a : Real)) := by
          rw [Real.rpow_sub (by norm_num : 0 < (2 : Real))]
          norm_num
    _ = ((2 : Real) ^ y / 4) * (4 * (a : Real)) := by
          rw [Real.rpow_two]
          norm_num
    _ = (2 : Real) ^ y * (a : Real) := by ring

theorem sourceWindow_parity_two (z : Real) (c : Nat) :
    sourceWindow (z - 1) (2 * c) = sourceWindow z c := by
  unfold sourceWindow
  apply congrArg Nat.floor
  calc
    (2 : Real) ^ (z - 1) * ((2 * c : Nat) : Real)
        = ((2 : Real) ^ z / (2 : Real) ^ (1 : Real)) *
            (2 * (c : Real)) := by
          rw [Real.rpow_sub (by norm_num : 0 < (2 : Real))]
          norm_num
    _ = ((2 : Real) ^ z / 2) * (2 * (c : Real)) := by
          rw [Real.rpow_one]
    _ = (2 : Real) ^ z * (c : Real) := by ring

theorem source_two_rpow_alpha :
    (2 : Real) ^ alpha = 3 := by
  unfold alpha
  exact
    Real.rpow_logb
      (by norm_num : 0 < (2 : Real))
      (by norm_num : Ne (2 : Real) 1)
      (by norm_num : 0 < (3 : Real))

theorem source_two_rpow_alpha_sub_one :
    (2 : Real) ^ (alpha - 1) = (3 / 2 : Real) := by
  rw [Real.rpow_sub (by norm_num : 0 < (2 : Real))]
  rw [source_two_rpow_alpha, Real.rpow_one]

theorem source_advanced_power_mul_child_le_root {a c : Nat}
    (hchild : 3 * c + 1 = 2 * a) :
    (2 : Real) ^ (alpha - 1) * (c : Real) <= (a : Real) := by
  rw [source_two_rpow_alpha_sub_one]
  have hchildR :
      (3 : Real) * (c : Real) + 1 = 2 * (a : Real) := by
    exact_mod_cast hchild
  nlinarith

theorem sourceWindow_advanced_child_le_target {y : Real} {a c : Nat}
    (hchild : 3 * c + 1 = 2 * a) :
    sourceWindow (y + alpha - 1) c <= sourceWindow y a := by
  unfold sourceWindow
  apply Nat.floor_mono
  have hlocal :
      (2 : Real) ^ (alpha - 1) * (c : Real) <= (a : Real) :=
    source_advanced_power_mul_child_le_root hchild
  calc
    (2 : Real) ^ (y + alpha - 1) * (c : Real)
        = (2 : Real) ^ y *
            ((2 : Real) ^ (alpha - 1) * (c : Real)) := by
          rw [show y + alpha - 1 = y + (alpha - 1) by ring]
          rw [Real.rpow_add (by norm_num : 0 < (2 : Real))]
          ring
    _ <= (2 : Real) ^ y * (a : Real) :=
      mul_le_mul_of_nonneg_left hlocal
        (Real.rpow_nonneg (by norm_num : (0 : Real) <= 2) y)

theorem sourceWindow_lifted_advanced_child_le_target
    {y : Real} {a c : Nat}
    (hchild : 3 * c + 1 = 2 * a) :
    sourceWindow (y + alpha - 2) (2 * c) <= sourceWindow y a := by
  rw [show y + alpha - 2 = (y + alpha - 1) - 1 by ring]
  rw [sourceWindow_parity_two]
  exact sourceWindow_advanced_child_le_target hchild

theorem source_two_rpow_logb_ratio_mul_root_eq_x {a x : Nat}
    (ha : 0 < a) (hx : 0 < x) :
    (2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real))) * (a : Real)
      = (x : Real) := by
  have haR_pos : 0 < (a : Real) := by exact_mod_cast ha
  have hxR_pos : 0 < (x : Real) := by exact_mod_cast hx
  have haR_ne : Ne (a : Real) 0 := ne_of_gt haR_pos
  have hratio_pos : 0 < (x : Real) / (a : Real) :=
    div_pos hxR_pos haR_pos
  calc
    (2 : Real) ^ (Real.logb 2 ((x : Real) / (a : Real))) * (a : Real)
        = ((x : Real) / (a : Real)) * (a : Real) := by
          rw [Real.rpow_logb
            (by norm_num : 0 < (2 : Real))
            (by norm_num : Ne (2 : Real) 1)
            hratio_pos]
    _ = (x : Real) := div_mul_cancel₀ (x : Real) haR_ne

theorem sourceWindow_logb_eq_self {a x : Nat}
    (ha : 0 < a) (hx : 0 < x) :
    sourceWindow (Real.logb 2 ((x : Real) / (a : Real))) a = x := by
  unfold sourceWindow
  rw [source_two_rpow_logb_ratio_mul_root_eq_x ha hx]
  exact Nat.floor_natCast x

end KL2003
end CollatzClassical
