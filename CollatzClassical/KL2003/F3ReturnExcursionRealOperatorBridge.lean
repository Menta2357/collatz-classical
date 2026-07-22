import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring

/-!
Real operator-to-functional bridge for the next F3 renewal gate.

The finite row certificate is an assumption of this interface, not a claim
that the numeric CSV is already a Lean matrix.  The theorem shows exactly how
member-wise row inequalities imply growth of the weighted functional after
one push-forward step.  It is the algebraic bridge needed before the renewal
conversion can be instantiated with the 243-state operator.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3RealOperatorBridge

variable {ι : Type*} [Fintype ι]

def push (M : ι → ι → ℝ) (μ : ι → ℝ) : ι → ℝ :=
  fun t => ∑ s, μ s * M s t

def weightedMass (w μ : ι → ℝ) : ℝ :=
  ∑ s, μ s * w s

theorem weighted_mass_push_identity (M : ι → ι → ℝ) (w μ : ι → ℝ) :
    weightedMass w (push M μ) =
      ∑ s, μ s * (∑ t, M s t * w t) := by
  classical
  simp only [weightedMass, push]
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro s hs
  calc
    (∑ x, μ s * M s x * w x) =
        ∑ x, μ s * (M s x * w x) := by
          apply Finset.sum_congr rfl
          intro x hx
          ring
    _ = μ s * ∑ x, M s x * w x := by
          rw [Finset.mul_sum]

theorem weighted_mass_push_lower_bound
    (M : ι → ι → ℝ) (w μ : ι → ℝ) {δ : ℝ}
    (hrow : ∀ s, (1 + δ) * w s ≤ ∑ t, M s t * w t)
    (hμ : ∀ s, 0 ≤ μ s) :
    (1 + δ) * weightedMass w μ ≤ weightedMass w (push M μ) := by
  rw [weighted_mass_push_identity]
  calc
    (1 + δ) * ∑ s, μ s * w s =
        ∑ s, μ s * ((1 + δ) * w s) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro s hs
          ring
    _ ≤ ∑ s, μ s * (∑ t, M s t * w t) := by
          exact Finset.sum_le_sum (fun s hs =>
            mul_le_mul_of_nonneg_left (hrow s) (hμ s))

theorem push_nonneg
    (M : ι → ι → ℝ) (μ : ι → ℝ)
    (hM : ∀ s t, 0 ≤ M s t)
    (hμ : ∀ s, 0 ≤ μ s) :
    ∀ t, 0 ≤ push M μ t := by
  intro t
  apply Finset.sum_nonneg
  intro s hs
  exact mul_nonneg (hμ s) (hM s t)

theorem weighted_mass_nonneg
    (w μ : ι → ℝ) (hw : ∀ s, 0 ≤ w s) (hμ : ∀ s, 0 ≤ μ s) :
    0 ≤ weightedMass w μ := by
  apply Finset.sum_nonneg
  intro s hs
  exact mul_nonneg (hμ s) (hw s)

end F3RealOperatorBridge
end KL2003
end CollatzClassical
