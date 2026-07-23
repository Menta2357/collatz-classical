import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
Finite Chernoff comparison for live paths.

This module formalizes the path-level algebra used by the tilted renewal
argument.  It does not construct the path family or prove the tilted matrix
bound.  Those are the remaining F3-specific obligations.
-/

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3TiltedLiveComparison

theorem tilted_path_weight_le
    {κ : Type*} [DecidableEq κ]
    (P : Finset κ)
    (star tilt shift : κ → ℝ) (theta H : ℝ)
    (hθ : 0 ≤ theta)
    (hrel : ∀ p, star p = tilt p * Real.exp (-theta * shift p))
    (hlive : ∀ p, -H ≤ shift p)
    (htilt : ∀ p, 0 ≤ tilt p) :
    ∀ p ∈ P, star p ≤ Real.exp (theta * H) * tilt p := by
  intro p hp
  have hmul : theta * (-H) ≤ theta * shift p := by
    exact mul_le_mul_of_nonneg_left (hlive p) hθ
  have hshift : -theta * shift p ≤ theta * H := by
    nlinarith
  have hexp : Real.exp (-theta * shift p) ≤ Real.exp (theta * H) :=
    Real.exp_le_exp.mpr hshift
  rw [hrel p]
  calc
    tilt p * Real.exp (-theta * shift p) ≤
        tilt p * Real.exp (theta * H) :=
      mul_le_mul_of_nonneg_left hexp (htilt p)
    _ = Real.exp (theta * H) * tilt p := by ring

theorem tilted_live_sum_le
    {κ : Type*} [DecidableEq κ]
    (P : Finset κ)
    (star tilt shift : κ → ℝ) (theta H : ℝ)
    (hθ : 0 ≤ theta)
    (hrel : ∀ p, star p = tilt p * Real.exp (-theta * shift p))
    (hlive : ∀ p, -H ≤ shift p)
    (htilt : ∀ p, 0 ≤ tilt p) :
    ∑ p ∈ P, star p ≤
      Real.exp (theta * H) * ∑ p ∈ P, tilt p := by
  have hterm := tilted_path_weight_le P star tilt shift theta H
    hθ hrel hlive htilt
  calc
    ∑ p ∈ P, star p ≤
        ∑ p ∈ P, Real.exp (theta * H) * tilt p := by
      exact Finset.sum_le_sum (fun p hp => hterm p hp)
    _ = Real.exp (theta * H) * ∑ p ∈ P, tilt p := by
      rw [Finset.mul_sum]

theorem tilted_live_weighted_sum_le
    {κ ι : Type*} [DecidableEq κ] [DecidableEq ι]
    (P : Finset κ) (endpoint : κ → ι)
    (star tilt shift : κ → ℝ) (weight v : ι → ℝ)
    (theta H K R : ℝ)
    (hθ : 0 ≤ theta)
    (hK : 0 ≤ K)
    (hrel : ∀ p, star p = tilt p * Real.exp (-theta * shift p))
    (hlive : ∀ p, -H ≤ shift p)
    (htilt : ∀ p, 0 ≤ tilt p)
    (hweight : ∀ i, 0 ≤ weight i)
    (hwv : ∀ i, weight i ≤ K * v i)
    (hpath : ∑ p ∈ P, tilt p * v (endpoint p) ≤ R) :
    ∑ p ∈ P, star p * weight (endpoint p) ≤
      K * Real.exp (theta * H) * R := by
  have hstar := tilted_path_weight_le P star tilt shift theta H
    hθ hrel hlive htilt
  have hterm : ∀ p ∈ P,
      star p * weight (endpoint p) ≤
        K * Real.exp (theta * H) *
          (tilt p * v (endpoint p)) := by
    intro p hp
    have hfirst : star p * weight (endpoint p) ≤
        (Real.exp (theta * H) * tilt p) * weight (endpoint p) := by
      exact mul_le_mul_of_nonneg_right
        (hstar p hp) (hweight (endpoint p))
    have hsecond :
        (Real.exp (theta * H) * tilt p) * weight (endpoint p) ≤
          (Real.exp (theta * H) * tilt p) *
            (K * v (endpoint p)) := by
      exact mul_le_mul_of_nonneg_left
        (hwv (endpoint p))
        (mul_nonneg (Real.exp_nonneg _) (htilt p))
    calc
      star p * weight (endpoint p) ≤
          (Real.exp (theta * H) * tilt p) * weight (endpoint p) := hfirst
      _ ≤ (Real.exp (theta * H) * tilt p) *
          (K * v (endpoint p)) := hsecond
      _ = K * Real.exp (theta * H) *
          (tilt p * v (endpoint p)) := by ring
  calc
    ∑ p ∈ P, star p * weight (endpoint p) ≤
        ∑ p ∈ P, K * Real.exp (theta * H) *
          (tilt p * v (endpoint p)) := by
      exact Finset.sum_le_sum (fun p hp => hterm p hp)
    _ = K * Real.exp (theta * H) *
        ∑ p ∈ P, tilt p * v (endpoint p) := by
      rw [Finset.mul_sum]
    _ ≤ K * Real.exp (theta * H) * R := by
      exact mul_le_mul_of_nonneg_left hpath
        (mul_nonneg hK (Real.exp_nonneg _))

end F3TiltedLiveComparison
end KL2003
end CollatzClassical
