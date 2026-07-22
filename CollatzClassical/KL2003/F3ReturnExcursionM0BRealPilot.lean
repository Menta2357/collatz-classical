import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
F3 M0-b Real-only pilot.

This file formalizes the finite renewal conversion in `Real`: geometric
retention, a first-passage increment inequality, and the resulting stopped
mass lower bound.  It deliberately does not mention the F3 matrix, `piStar`,
rho certificates, density, or Collatz.
-/

open scoped BigOperators
open Filter Topology

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3ReturnExcursionM0BReal

def qStar : ℝ := (24100 : ℝ) / 24543

def epsilonStar : ℝ := (2 : ℝ) / 243

def deltaStar : ℝ := (1 : ℝ) / 100

theorem qStar_nonneg : 0 ≤ qStar := by
  norm_num [qStar]

theorem qStar_lt_one : qStar < 1 := by
  norm_num [qStar]

theorem epsilonStar_nonneg : 0 ≤ epsilonStar := by
  norm_num [epsilonStar]

theorem qStar_gap : 1 - qStar = (443 : ℝ) / 24543 := by
  norm_num [qStar]

theorem eta_row_real : epsilonStar / (1 - qStar) = (202 : ℝ) / 443 := by
  norm_num [epsilonStar, qStar]

theorem qStar_factorization :
    qStar = (1 - epsilonStar) / (1 + deltaStar) := by
  norm_num [qStar, epsilonStar, deltaStar]

theorem geometric_telescoping_real (r : ℝ) (n : Nat) :
    (1 - r) * (∑ k ∈ Finset.range n, r ^ k) = 1 - r ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, pow_succ]
      calc
        (1 - r) * (∑ x ∈ Finset.range n, r ^ x + r ^ n) =
            (1 - r) * (∑ x ∈ Finset.range n, r ^ x) +
              (1 - r) * r ^ n := by ring
        _ = (1 - r ^ n) + (1 - r) * r ^ n := by rw [ih]
        _ = 1 - r ^ n * r := by ring

theorem renewal_conversion_lower_bound
    {q L : ℝ} (stopped : Nat → ℝ)
    (hzero : 0 ≤ stopped 0)
    (hstep : ∀ n : Nat,
      stopped n + (1 - q) * L * q ^ n ≤ stopped (n + 1)) :
    ∀ n : Nat, L * (1 - q ^ n) ≤ stopped n := by
  intro n
  induction n with
  | zero =>
      simpa using hzero
  | succ n ih =>
      calc
        L * (1 - q ^ (n + 1)) =
            L * (1 - q ^ n) + (1 - q) * L * q ^ n := by
              rw [pow_succ]
              ring
        _ ≤ stopped n + (1 - q) * L * q ^ n := by
              exact add_le_add_right ih _
        _ ≤ stopped (n + 1) := hstep n

theorem renewal_conversion_lower_bound_of_leakage
    {q L : ℝ} (stopped : Nat → ℝ)
    (hzero : 0 ≤ stopped 0)
    (hleak : ∀ n : Nat,
      (1 - q) * L * q ^ n ≤ stopped (n + 1) - stopped n) :
    ∀ n : Nat, L * (1 - q ^ n) ≤ stopped n := by
  apply renewal_conversion_lower_bound stopped hzero
  intro n
  linarith [hleak n]

theorem renewal_retained_mass_nonneg
    {q L : ℝ} (hq : 0 ≤ q) (hL : 0 ≤ L) (n : Nat) :
    0 ≤ L * q ^ n := by
  exact mul_nonneg hL (pow_nonneg hq n)

theorem renewal_conversion_limit
    {q L : ℝ} (hq0 : 0 ≤ q) (hq1 : q < 1) :
    Tendsto (fun n : Nat => L * (1 - q ^ n)) atTop (𝓝 L) := by
  have hpow : Tendsto (fun n : Nat => q ^ n) atTop (𝓝 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one hq0 hq1
  have hone : Tendsto (fun _ : Nat => (1 : ℝ)) atTop (𝓝 1) := tendsto_const_nhds
  have hsub : Tendsto (fun n : Nat => 1 - q ^ n) atTop (𝓝 (1 - 0)) :=
    hone.sub hpow
  simpa using (tendsto_const_nhds.mul hsub)

theorem qStar_conversion_limit :
    Tendsto (fun n : Nat => (1 : ℝ) - qStar ^ n) atTop (𝓝 1) := by
  simpa using renewal_conversion_limit qStar_nonneg qStar_lt_one (L := (1 : ℝ))

end F3ReturnExcursionM0BReal
end KL2003
end CollatzClassical
