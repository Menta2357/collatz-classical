import CollatzClassical.KL2003.KL2003K11CertificateDataRouter
import CollatzClassical.KL2003.KL2003K2AlphaBounds
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity

namespace CollatzClassical
namespace KL2003
namespace K11EndpointBounds

open K11CertificateMatch

noncomputable def lambdaR11 : Real := (lambda : Real)
noncomputable def bReal11 : Real := lambdaR11 ^ (alpha - 2)
noncomputable def dReal11 : Real := lambdaR11 ^ (alpha - 1)

theorem lambdaR11_pos : 0 < lambdaR11 := by
  norm_num [lambdaR11, lambda]

theorem lambdaR11_gt_one : 1 < lambdaR11 := by
  norm_num [lambdaR11, lambda]

theorem alpha_strong_lower_bound : (569 / 359 : Real) < alpha := by
  have key : Real.log ((2 : Real) ^ 569) < Real.log ((3 : Real) ^ 359) :=
    Real.log_lt_log (by positivity) (by norm_num)
  rw [Real.log_pow, Real.log_pow] at key
  have hscaled : (569 / 359 : Real) * Real.log (2 : Real) < Real.log (3 : Real) := by
    have hdiv : ((569 : Real) * Real.log (2 : Real)) / 359 < Real.log (3 : Real) :=
      (div_lt_iff₀ (by norm_num : (0 : Real) < 359)).2 (by
        simpa [mul_comm] using key)
    simpa [div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm] using hdiv
  unfold alpha
  rw [← Real.log_div_log]
  exact (lt_div_iff₀ log_two_pos).2 hscaled

theorem dLower_endpoint :
    ((dLower : Rat) : Real) <= lambdaR11 ^ (210 / 359 : Real) := by
  have hdNonneg : 0 <= ((dLower : Rat) : Real) := by
    norm_num [dLower]
  have hpowNat : (((dLower : Rat) : Real) ^ 359) <= lambdaR11 ^ 210 := by
    norm_num [dLower, lambdaR11, lambda]
  have hpow :
      (((dLower : Rat) : Real) ^ (359 : Real)) <=
        (lambdaR11 ^ (210 / 359 : Real)) ^ (359 : Real) := by
    calc
      (((dLower : Rat) : Real) ^ (359 : Real)) =
          (((dLower : Rat) : Real) ^ 359) := by norm_num
      _ <= lambdaR11 ^ 210 := hpowNat
      _ = lambdaR11 ^ ((210 / 359 : Real) * (359 : Real)) := by norm_num
      _ = (lambdaR11 ^ (210 / 359 : Real)) ^ (359 : Real) := by
        rw [Real.rpow_mul lambdaR11_pos.le]
  exact
    (Real.rpow_le_rpow_iff
      hdNonneg
      (Real.rpow_nonneg lambdaR11_pos.le _)
      (by norm_num : 0 < (359 : Real))).1 hpow

theorem dReal11_lower : ((dLower : Rat) : Real) <= dReal11 := by
  have hexp : (210 / 359 : Real) <= alpha - 1 := by
    linarith [alpha_strong_lower_bound]
  exact dLower_endpoint.trans
    (Real.rpow_le_rpow_of_exponent_le lambdaR11_gt_one.le hexp)

theorem bReal11_eq_dReal11_div_lambda : bReal11 = dReal11 / lambdaR11 := by
  dsimp [bReal11, dReal11]
  rw [show alpha - 2 = (alpha - 1) - 1 by ring]
  rw [Real.rpow_sub lambdaR11_pos, Real.rpow_one]

theorem bReal11_lower : ((bLower : Rat) : Real) <= bReal11 := by
  rw [bReal11_eq_dReal11_div_lambda]
  have hdiv := div_le_div_of_nonneg_right dReal11_lower lambdaR11_pos.le
  calc
    ((bLower : Rat) : Real) = ((dLower : Rat) : Real) / lambdaR11 := by
      norm_num [bLower, dLower, lambdaR11, lambda]
    _ <= dReal11 / lambdaR11 := hdiv

theorem aCoeff_real_eq_lambda_neg_two :
    ((aCoeff : Rat) : Real) = lambdaR11 ^ (-2 : Real) := by
  norm_num [aCoeff, lambdaR11, lambda,
    Real.rpow_neg (by norm_num : (0 : Real) <= 71689 / 40000)]

end K11EndpointBounds
end KL2003
end CollatzClassical
