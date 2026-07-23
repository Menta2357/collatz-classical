import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-!
Real first-passage consequence of a Chernoff live-mass bound.

This is the analytic half of the tilted renewal argument.  It deliberately
does not mention the F3 matrix or construct the live bound.  Once a path
argument supplies `live n ≤ C*q^n`, the ledger inequality immediately gives a
lower bound for stopped mass and an eventual positive fraction of the initial
mass.
-/

open Filter Topology

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3ChernoffFirstPassage

theorem stopped_lower_bound_of_live_bound
    {A C q : ℝ} (stopped live : Nat → ℝ)
    (hledger : ∀ n, A ≤ stopped n + live n)
    (hlive : ∀ n, live n ≤ C * q ^ n) :
    ∀ n, A - C * q ^ n ≤ stopped n := by
  intro n
  linarith [hledger n, hlive n]

theorem stopped_lower_bound_tendsto_initial
    {A C q : ℝ} (hq0 : 0 ≤ q) (hq1 : q < 1) :
    Tendsto (fun n : Nat => A - C * q ^ n) atTop (𝓝 A) := by
  have hpow : Tendsto (fun n : Nat => q ^ n) atTop (𝓝 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one hq0 hq1
  have hCconst : Tendsto (fun _ : Nat => C) atTop (𝓝 C) :=
    tendsto_const_nhds
  have hscaled : Tendsto (fun n : Nat => C * q ^ n) atTop (𝓝 0) :=
    by simpa using hCconst.mul hpow
  have hconst : Tendsto (fun _ : Nat => A) atTop (𝓝 A) :=
    tendsto_const_nhds
  simpa using hconst.sub hscaled

theorem stopped_eventually_exceeds_fraction
    {A C q : ℝ} (hA : 0 < A)
    (hq0 : 0 ≤ q) (hq1 : q < 1)
    (stopped live : Nat → ℝ)
    (hledger : ∀ n, A ≤ stopped n + live n)
    (hlive : ∀ n, live n ≤ C * q ^ n) :
    ∃ N, ∀ n ≥ N, A / 2 < stopped n := by
  have hlim := stopped_lower_bound_tendsto_initial
    (A := A) (C := C) hq0 hq1
  have h_event : ∀ᶠ n : Nat in atTop,
      A / 2 < A - C * q ^ n := by
    have hopen : A / 2 < A := by linarith
    exact hlim.eventually (Ioi_mem_nhds hopen)
  rcases (eventually_atTop.1 h_event) with ⟨N, hN⟩
  refine ⟨N, ?_⟩
  intro n hn
  exact lt_of_lt_of_le (hN n hn)
    (stopped_lower_bound_of_live_bound stopped live hledger hlive n)

end F3ChernoffFirstPassage
end KL2003
end CollatzClassical
