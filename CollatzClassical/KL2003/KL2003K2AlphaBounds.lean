import CollatzClassical.KL2003.KL2003K2CertificateData
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Base
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace CollatzClassical
namespace KL2003

noncomputable def alpha : Real := Real.logb 2 3

def lambdaR : Real := ((27 / 20 : Rat) : Real)

theorem log_two_pos : 0 < Real.log (2 : Real) := by
  exact Real.log_pos (by norm_num)

theorem lambdaR_pos : 0 < lambdaR := by
  norm_num [lambdaR]

theorem lambdaR_gt_one : 1 < lambdaR := by
  norm_num [lambdaR]

theorem alpha_lower_bound : (19 / 12 : Real) < alpha := by
  have key : Real.log ((2 : Real) ^ 19) < Real.log ((3 : Real) ^ 12) :=
    Real.log_lt_log (by positivity) (by norm_num)
  rw [Real.log_pow, Real.log_pow] at key
  have hscaled : (19 / 12 : Real) * Real.log (2 : Real) < Real.log (3 : Real) := by
    have hdiv : ((19 : Real) * Real.log (2 : Real)) / 12 < Real.log (3 : Real) :=
      (div_lt_iff₀ (by norm_num : (0 : Real) < 12)).2 (by
        simpa [mul_comm] using key)
    simpa [div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm] using hdiv
  unfold alpha
  rw [← Real.log_div_log]
  exact (lt_div_iff₀ log_two_pos).2 hscaled

theorem alpha_upper_bound : alpha < (8 / 5 : Real) := by
  have key : Real.log ((3 : Real) ^ 5) < Real.log ((2 : Real) ^ 8) :=
    Real.log_lt_log (by positivity) (by norm_num)
  rw [Real.log_pow, Real.log_pow] at key
  have hscaled : Real.log (3 : Real) < (8 / 5 : Real) * Real.log (2 : Real) := by
    have hdiv : Real.log (3 : Real) < ((8 : Real) * Real.log (2 : Real)) / 5 :=
      (lt_div_iff₀ (by norm_num : (0 : Real) < 5)).2 (by
        simpa [mul_comm] using key)
    simpa [div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm] using hdiv
  unfold alpha
  rw [← Real.log_div_log]
  exact (div_lt_iff₀ log_two_pos).2 hscaled

end KL2003
end CollatzClassical
