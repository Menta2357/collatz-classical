import CollatzClassical.KL2003.F3ReturnExcursionRealIterateBridge
import CollatzClassical.KL2003.F3ReturnExcursionTiltedLiveComparison

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
open F3TiltedLiveComparison

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

theorem tilted_live_path_bound_of_iterate_upper_bound
    {ι κ : Type*} [Fintype ι] [DecidableEq ι] [DecidableEq κ]
    (M : ι → ι → ℝ) (v μ : ι → ℝ) {lambda : ℝ}
    (P : Finset κ) (endpoint : κ → ι)
    (star tilt shift : κ → ℝ) (weight : ι → ℝ)
    (n : Nat) (theta H K : ℝ)
    (hθ : 0 ≤ theta)
    (hK : 0 ≤ K)
    (hrow : ∀ s, ∑ t, M s t * v t ≤ lambda * v s)
    (hM : ∀ s t, 0 ≤ M s t)
    (hμ : ∀ s, 0 ≤ μ s)
    (hlambda : 0 ≤ lambda)
    (hrel : ∀ p, star p = tilt p * Real.exp (-theta * shift p))
    (hlive : ∀ p, -H ≤ shift p)
    (htilt : ∀ p, 0 ≤ tilt p)
    (hweight : ∀ i, 0 ≤ weight i)
    (hwv : ∀ i, weight i ≤ K * v i)
    (hpath : ∑ p ∈ P, tilt p * v (endpoint p) ≤
      weightedMass v (iteratePush M μ n)) :
    ∑ p ∈ P, star p * weight (endpoint p) ≤
      K * Real.exp (theta * H) *
        (lambda ^ n * weightedMass v μ) := by
  have hweighted := tilted_live_weighted_sum_le
    P endpoint star tilt shift weight v theta H K
    (weightedMass v (iteratePush M μ n))
    hθ hK hrel hlive htilt hweight hwv hpath
  have hiterate := weighted_mass_iterate_upper_bound
    M v μ hrow hM hμ hlambda n
  calc
    ∑ p ∈ P, star p * weight (endpoint p) ≤
        K * Real.exp (theta * H) *
          weightedMass v (iteratePush M μ n) := hweighted
    _ ≤ K * Real.exp (theta * H) *
        (lambda ^ n * weightedMass v μ) := by
      exact mul_le_mul_of_nonneg_left hiterate
        (mul_nonneg hK (Real.exp_nonneg _))

end F3TiltedIterateUpperBound
end KL2003
end CollatzClassical
