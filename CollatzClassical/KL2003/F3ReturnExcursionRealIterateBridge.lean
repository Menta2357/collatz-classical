import CollatzClassical.KL2003.F3ReturnExcursionRealOperatorBridge

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3RealIterateBridge

open F3RealOperatorBridge

noncomputable section

variable {ι : Type*} [Fintype ι]

/-!
Finite iteration of the generic Real push-forward.  This module deliberately
imports the already audited one-step bridge rather than the F3 matrix.
-/

def iteratePush (M : ι → ι → ℝ) (μ : ι → ℝ) : Nat → ι → ℝ
  | 0 => μ
  | n + 1 => push M (iteratePush M μ n)

theorem iteratePush_nonneg
    {ι : Type*} [Fintype ι]
    (M : ι → ι → ℝ) (μ : ι → ℝ)
    (hM : ∀ s t, 0 ≤ M s t) (hμ : ∀ s, 0 ≤ μ s) :
    ∀ n s, 0 ≤ iteratePush M μ n s := by
  intro n
  induction n with
  | zero =>
      intro s
      simpa [iteratePush] using hμ s
  | succ n ihn =>
      intro s
      simpa [iteratePush] using
        (push_nonneg M (iteratePush M μ n)
          hM (fun t => ihn t) s)

theorem weighted_mass_iterate_lower_bound
    {ι : Type*} [Fintype ι]
    (M : ι → ι → ℝ) (w μ : ι → ℝ) {δ : ℝ}
    (hdelta : 0 ≤ 1 + δ)
    (hrow : ∀ s, (1 + δ) * w s ≤ ∑ t, M s t * w t)
    (hM : ∀ s t, 0 ≤ M s t)
    (hμ : ∀ s, 0 ≤ μ s) :
    ∀ n, (1 + δ) ^ n * weightedMass w μ ≤
      weightedMass w (iteratePush M μ n) := by
  intro n
  induction n with
  | zero =>
      simp [iteratePush]
  | succ n ih =>
      have hμn : ∀ s, 0 ≤ iteratePush M μ n s :=
        iteratePush_nonneg M μ hM hμ n
      have hstep := weighted_mass_push_lower_bound
        M w (iteratePush M μ n) hrow hμn
      calc
        (1 + δ) ^ (n + 1) * weightedMass w μ =
            (1 + δ) * ((1 + δ) ^ n * weightedMass w μ) := by
              rw [pow_succ]
              ring
        _ ≤ (1 + δ) * weightedMass w (iteratePush M μ n) := by
              exact mul_le_mul_of_nonneg_left ih hdelta
        _ ≤ weightedMass w (iteratePush M μ (n + 1)) := by
              simpa [iteratePush] using hstep

end
end F3RealIterateBridge
end KL2003
end CollatzClassical
