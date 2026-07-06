import CollatzClassical.KL2003.KL2003K2AlphaBounds
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace CollatzClassical
namespace KL2003

noncomputable def BReal : Real := lambdaR ^ (alpha - 2)

noncomputable def DReal : Real := lambdaR ^ (alpha - 1)

theorem D_lower_endpoint :
    (119 / 100 : Real) <= lambdaR ^ ((7 / 12 : Real)) := by
  have hpow_nat : (119 / 100 : Real) ^ 12 <= lambdaR ^ 7 := by
    norm_num [lambdaR]
  have hpow :
      (119 / 100 : Real) ^ (12 : Real) <=
        (lambdaR ^ ((7 / 12 : Real))) ^ (12 : Real) := by
    calc
      (119 / 100 : Real) ^ (12 : Real) = (119 / 100 : Real) ^ 12 := by
        norm_num
      _ <= lambdaR ^ 7 := hpow_nat
      _ = lambdaR ^ (((7 / 12 : Real)) * (12 : Real)) := by norm_num
      _ = (lambdaR ^ ((7 / 12 : Real))) ^ (12 : Real) := by
        rw [Real.rpow_mul lambdaR_pos.le]
  exact
    (Real.rpow_le_rpow_iff
      (by norm_num : 0 <= (119 / 100 : Real))
      (Real.rpow_nonneg lambdaR_pos.le _)
      (by norm_num : 0 < (12 : Real))).1 hpow

theorem D_upper_endpoint :
    lambdaR ^ ((3 / 5 : Real)) <= (6 / 5 : Real) := by
  have hpow_nat : lambdaR ^ 3 <= (6 / 5 : Real) ^ 5 := by
    norm_num [lambdaR]
  have hpow :
      (lambdaR ^ ((3 / 5 : Real))) ^ (5 : Real) <=
        (6 / 5 : Real) ^ (5 : Real) := by
    calc
      (lambdaR ^ ((3 / 5 : Real))) ^ (5 : Real)
          = lambdaR ^ (((3 / 5 : Real)) * (5 : Real)) := by
            rw [← Real.rpow_mul lambdaR_pos.le]
      _ = lambdaR ^ 3 := by norm_num
      _ <= (6 / 5 : Real) ^ 5 := hpow_nat
      _ = (6 / 5 : Real) ^ (5 : Real) := by
        norm_num
  exact
    (Real.rpow_le_rpow_iff
      (Real.rpow_nonneg lambdaR_pos.le _)
      (by norm_num : 0 <= (6 / 5 : Real))
      (by norm_num : 0 < (5 : Real))).1 hpow

theorem DReal_lower : (119 / 100 : Real) <= DReal := by
  have hexp : (7 / 12 : Real) <= alpha - 1 := by
    linarith [alpha_lower_bound]
  have hmono : lambdaR ^ ((7 / 12 : Real)) <= DReal := by
    dsimp [DReal]
    exact Real.rpow_le_rpow_of_exponent_le lambdaR_gt_one.le hexp
  exact D_lower_endpoint.trans hmono

theorem DReal_upper : DReal <= (6 / 5 : Real) := by
  have hexp : alpha - 1 <= (3 / 5 : Real) := by
    linarith [alpha_upper_bound]
  have hmono : DReal <= lambdaR ^ ((3 / 5 : Real)) := by
    dsimp [DReal]
    exact Real.rpow_le_rpow_of_exponent_le lambdaR_gt_one.le hexp
  exact hmono.trans D_upper_endpoint

theorem BReal_eq_DReal_div_lambda : BReal = DReal / lambdaR := by
  dsimp [BReal, DReal]
  rw [show alpha - 2 = (alpha - 1) - 1 by ring]
  rw [Real.rpow_sub lambdaR_pos]
  rw [Real.rpow_one]

theorem BReal_lower : (119 / 135 : Real) <= BReal := by
  rw [BReal_eq_DReal_div_lambda]
  dsimp [lambdaR]
  have h := div_le_div_of_nonneg_right DReal_lower
    (by norm_num : 0 <= ((27 / 20 : Rat) : Real))
  calc
    (119 / 135 : Real) = (119 / 100 : Real) / ((27 / 20 : Rat) : Real) := by norm_num
    _ <= DReal / ((27 / 20 : Rat) : Real) := h

theorem BReal_upper : BReal <= (8 / 9 : Real) := by
  rw [BReal_eq_DReal_div_lambda]
  dsimp [lambdaR]
  have h := div_le_div_of_nonneg_right DReal_upper
    (by norm_num : 0 <= ((27 / 20 : Rat) : Real))
  calc
    DReal / ((27 / 20 : Rat) : Real) <=
        (6 / 5 : Real) / ((27 / 20 : Rat) : Real) := by
      exact h
    _ = (8 / 9 : Real) := by norm_num

theorem BReal_within_strong_interval :
    (119 / 135 : Real) <= BReal ∧ BReal <= (8 / 9 : Real) := by
  exact ⟨BReal_lower, BReal_upper⟩

theorem DReal_within_target_interval :
    (119 / 100 : Real) <= DReal ∧ DReal <= (6 / 5 : Real) := by
  exact ⟨DReal_lower, DReal_upper⟩

end KL2003
end CollatzClassical
