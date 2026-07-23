import CollatzClassical.KL2003.F3ReturnExcursionRealIterateBridge

/-!
Iterated upper bound for a nonnegative tilted operator.

This is the algebraic counterpart of the frozen supersolution certificate:
an entrywise row inequality `M*v ≤ lambda*v` propagates to every finite
iterate.  It is deliberately independent of the concrete 243-state data;
the remaining F3 obligation is to identify the certified tilted matrix and
prove that its path mass is bounded by this iterate functional.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3TiltedIterateUpperBound

open F3RealIterateBridge
open F3RealOperatorBridge

theorem weighted_mass_push_upper_bound
    {ι : Type*} [Fintype ι]
    (M : ι → ι → ℝ) (v μ : ι → ℝ) {lambda : ℝ}
    (hrow : ∀ s, ∑ t, M s t * v t ≤ lambda * v s)
    (hμ : ∀ s, 0 ≤ μ s) :
    weightedMass v (push M μ) ≤ lambda * weightedMass v μ := by
  rw [weighted_mass_push_identity]
  calc
    ∑ s, μ s * (∑ t, M s t * v t) ≤
        ∑ s, μ s * (lambda * v s) := by
      exact Finset.sum_le_sum (fun s hs =>
        mul_le_mul_of_nonneg_left (hrow s) (hμ s))
    _ = lambda * weightedMass v μ := by
      simp only [weightedMass]
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro s hs
      ring

theorem weighted_mass_iterate_upper_bound
    {ι : Type*} [Fintype ι]
    (M : ι → ι → ℝ) (v μ : ι → ℝ) {lambda : ℝ}
    (hrow : ∀ s, ∑ t, M s t * v t ≤ lambda * v s)
    (hM : ∀ s t, 0 ≤ M s t)
    (hμ : ∀ s, 0 ≤ μ s)
    (hlambda : 0 ≤ lambda) :
    ∀ n, weightedMass v (iteratePush M μ n) ≤
      lambda ^ n * weightedMass v μ := by
  intro n
  induction n with
  | zero =>
      simp [iteratePush]
  | succ n ih =>
      have hμn : ∀ s, 0 ≤ iteratePush M μ n s :=
        iteratePush_nonneg M μ hM hμ n
      have hstep := weighted_mass_push_upper_bound
        M v (iteratePush M μ n) hrow hμn
      calc
        weightedMass v (iteratePush M μ (n + 1)) ≤
            lambda * weightedMass v (iteratePush M μ n) := by
          simpa [iteratePush] using hstep
        _ ≤ lambda * (lambda ^ n * weightedMass v μ) := by
          exact mul_le_mul_of_nonneg_left ih hlambda
        _ = lambda ^ (n + 1) * weightedMass v μ := by
          rw [pow_succ]
          ring

end F3TiltedIterateUpperBound
end KL2003
end CollatzClassical
