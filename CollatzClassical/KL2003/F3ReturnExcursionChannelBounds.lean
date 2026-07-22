import CollatzClassical.KL2003.KL2003M1Surrogate

namespace CollatzClassical
namespace KL2003
namespace F3ChannelBounds

noncomputable section

def rhoStarF3 : ℝ := 9 / 5

def alphaF3 : ℝ := Real.log 3 / Real.log 2

def channelWeightF3 : Nat → ℝ
  | 0 => Real.rpow rhoStarF3 (-2)
  | 1 => Real.rpow rhoStarF3 (alphaF3 - 1) / 3
  | 2 => Real.rpow rhoStarF3 (alphaF3 - 2) / 3
  | _ => 0

theorem alpha_lower_bound_f3 : (19 / 12 : ℝ) < alphaF3 := by
  have key : Real.log ((2 : ℝ) ^ 19) < Real.log ((3 : ℝ) ^ 12) :=
    Real.log_lt_log (by positivity) (by norm_num)
  rw [Real.log_pow, Real.log_pow] at key
  have hscaled : (19 / 12 : ℝ) * Real.log (2 : ℝ) < Real.log (3 : ℝ) := by
    have hdiv : ((19 : ℝ) * Real.log (2 : ℝ)) / 12 < Real.log (3 : ℝ) :=
      (div_lt_iff₀ (by norm_num : (0 : ℝ) < 12)).2 (by
        simpa [mul_comm] using key)
    simpa [div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm] using hdiv
  unfold alphaF3
  exact (lt_div_iff₀ (Real.log_pos (by norm_num : (1 : ℝ) < 2))).2 hscaled

theorem rhoStar_pos_f3 : 0 < rhoStarF3 := by
  norm_num [rhoStarF3]

theorem rhoStar_gt_one_f3 : 1 < rhoStarF3 := by
  norm_num [rhoStarF3]

theorem rhoStar_rpow_seventh_twelfth_lower :
    (1407 / 1000 : ℝ) < Real.rpow rhoStarF3 (7 / 12 : ℝ) := by
  have hpow_nat : ((1407 / 1000 : ℝ) ^ 12) < rhoStarF3 ^ 7 := by
    norm_num [rhoStarF3]
  have hpow :
      ((1407 / 1000 : ℝ) ^ (12 : ℝ)) <
        (Real.rpow rhoStarF3 (7 / 12 : ℝ)) ^ (12 : ℝ) := by
    calc
      ((1407 / 1000 : ℝ) ^ (12 : ℝ)) =
          (1407 / 1000 : ℝ) ^ 12 := by norm_num
      _ < rhoStarF3 ^ 7 := hpow_nat
      _ = Real.rpow rhoStarF3 (7 : ℝ) := by norm_num
      _ = rhoStarF3 ^ ((7 / 12 : ℝ) * (12 : ℝ)) := by norm_num
      _ = (rhoStarF3 ^ (7 / 12 : ℝ)) ^ (12 : ℝ) := by
        rw [Real.rpow_mul rhoStar_pos_f3.le]
  exact
    (Real.rpow_lt_rpow_iff
      (by positivity : 0 ≤ (1407 / 1000 : ℝ))
      (Real.rpow_nonneg rhoStar_pos_f3.le _)
      (by norm_num : 0 < (12 : ℝ))).1 hpow

theorem channelWeight_zero_eq : channelWeightF3 0 = (25 / 81 : ℝ) := by
  dsimp [channelWeightF3]
  rw [Real.rpow_neg rhoStar_pos_f3.le]
  norm_num [rhoStarF3]

theorem channelWeight_one_lower :
    (469 / 1000 : ℝ) ≤ channelWeightF3 1 := by
  dsimp [channelWeightF3]
  have hexp : (7 / 12 : ℝ) ≤ alphaF3 - 1 := by
    linarith [alpha_lower_bound_f3]
  have hpow := Real.rpow_le_rpow_of_exponent_le rhoStar_gt_one_f3.le hexp
  have hbase := rhoStar_rpow_seventh_twelfth_lower
  have hstrict : (1407 / 1000 : ℝ) < Real.rpow rhoStarF3 (alphaF3 - 1) :=
    lt_of_lt_of_le hbase hpow
  have hscaled := div_lt_div_of_pos_right hstrict (by norm_num : (0 : ℝ) < 3)
  have htarget : (469 / 1000 : ℝ) = (1407 / 1000 : ℝ) / 3 := by norm_num
  rw [htarget]
  exact le_of_lt hscaled

theorem channelWeight_two_eq_channelWeight_one_div_rho :
    channelWeightF3 2 = channelWeightF3 1 / rhoStarF3 := by
  dsimp [channelWeightF3]
  rw [show alphaF3 - 2 = (alphaF3 - 1) - 1 by ring]
  rw [Real.rpow_sub rhoStar_pos_f3, Real.rpow_one]
  ring

theorem channelWeight_two_lower :
    (13 / 50 : ℝ) ≤ channelWeightF3 2 := by
  rw [channelWeight_two_eq_channelWeight_one_div_rho]
  have hdiv := div_le_div_of_nonneg_right channelWeight_one_lower rhoStar_pos_f3.le
  norm_num [rhoStarF3] at hdiv ⊢
  nlinarith

end
end F3ChannelBounds
end KL2003
end CollatzClassical
