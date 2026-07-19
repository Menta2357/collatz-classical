import CollatzClassical.KL2003.KL2003GeneralKEliminationScheduler
import Mathlib.Data.Fintype.Pigeonhole
import Mathlib.Data.Nat.Nth

namespace CollatzClassical
namespace KL2003

/-!
Finite-mode and arithmetic core of the termination argument in KL2003
Theorem 3.1.

This module proves that an infinite sequence of tracked modes has one mode
occurring arbitrarily far out, and that a real sequence with a fixed negative
increment cannot remain nonnegative. It deliberately does not assume or claim
the self-similar correspondence that turns recurrent EL subtrees into a fixed
increment, nor termination or order independence of the full EL process.
-/

namespace GeneralKTermination

theorem exists_mode_with_infinite_fiber {k : Nat}
    (modes : Nat -> TrackedMode k) :
    exists mode : TrackedMode k,
      Infinite {n : Nat // modes n = mode} := by
  obtain ⟨mode, hmode⟩ := Finite.exists_infinite_fiber modes
  refine ⟨mode, ?_⟩
  simpa only [Set.mem_preimage, Set.mem_singleton_iff] using hmode

theorem exists_recurrent_mode_unbounded {k : Nat}
    (modes : Nat -> TrackedMode k) :
    exists mode : TrackedMode k, forall lower : Nat,
      exists n : Nat, lower < n /\ modes n = mode := by
  obtain ⟨mode, hmode⟩ := exists_mode_with_infinite_fiber modes
  refine ⟨mode, ?_⟩
  intro lower
  let fiber : Set Nat := {n | modes n = mode}
  have hfiber : fiber.Infinite := by
    apply Set.infinite_coe_iff.mp
    change Infinite {n : Nat // modes n = mode}
    exact hmode
  obtain ⟨n, hnmem, hlower⟩ := hfiber.exists_gt lower
  exact ⟨n, hlower, hnmem⟩

theorem exists_recurrent_mode_subsequence {k : Nat}
    (modes : Nat -> TrackedMode k) :
    exists mode : TrackedMode k, exists positions : Nat -> Nat,
      StrictMono positions /\ forall j : Nat, modes (positions j) = mode := by
  obtain ⟨mode, hmode⟩ := exists_mode_with_infinite_fiber modes
  let predicate : Nat -> Prop := fun n => modes n = mode
  have hinfinite : {n | predicate n}.Infinite := by
    apply Set.infinite_coe_iff.mp
    change Infinite {n : Nat // modes n = mode}
    exact hmode
  refine ⟨mode, Nat.nth predicate, Nat.nth_strictMono hinfinite, ?_⟩
  intro j
  exact Nat.nth_mem_of_infinite hinfinite j

def HasFixedIncrement (beta : Nat -> Real) (delta : Real) : Prop :=
  forall j : Nat, beta (j + 1) = beta j + delta

theorem hasFixedIncrement_of_constant_difference
    {beta : Nat -> Real} {delta : Real}
    (hdiff : forall j : Nat, beta (j + 1) - beta j = delta) :
    HasFixedIncrement beta delta := by
  intro j
  linarith [hdiff j]

theorem hasFixedIncrement_closedForm {beta : Nat -> Real} {delta : Real}
    (hstep : HasFixedIncrement beta delta) (n : Nat) :
    beta n = beta 0 + (n : Real) * delta := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [show n + 1 = Nat.succ n by omega, hstep n, ih]
      push_cast
      ring

theorem corrected_delta_negative {betaOne betaTwo delta : Real}
    (hdecrease : betaTwo < betaOne)
    (hdelta : delta = betaTwo - betaOne) :
    delta < 0 := by
  linarith

theorem exists_negative_of_hasFixedIncrement_of_delta_neg
    {beta : Nat -> Real} {delta : Real}
    (hstep : HasFixedIncrement beta delta) (hdelta : delta < 0) :
    exists n : Nat, beta n < 0 := by
  have hnegDelta : 0 < -delta := neg_pos.mpr hdelta
  obtain ⟨n, hn⟩ := exists_nat_gt (beta 0 / (-delta))
  have hmul : beta 0 < (n : Real) * (-delta) :=
    (div_lt_iff₀ hnegDelta).mp hn
  refine ⟨n, ?_⟩
  rw [hasFixedIncrement_closedForm hstep n]
  linarith

theorem not_forall_nonnegative_of_hasFixedIncrement_of_delta_neg
    {beta : Nat -> Real} {delta : Real}
    (hstep : HasFixedIncrement beta delta) (hdelta : delta < 0) :
    ¬ (forall n : Nat, 0 <= beta n) := by
  obtain ⟨n, hn⟩ :=
    exists_negative_of_hasFixedIncrement_of_delta_neg hstep hdelta
  intro hnonnegative
  exact (not_lt_of_ge (hnonnegative n)) hn

theorem theorem31_arithmetic_contradiction
    {beta : Nat -> Real} {delta : Real}
    (hnonnegative : forall n : Nat, 0 <= beta n)
    (hdiff : forall n : Nat, beta (n + 1) - beta n = delta)
    (hdelta : delta < 0) : False := by
  exact not_forall_nonnegative_of_hasFixedIncrement_of_delta_neg
    (hasFixedIncrement_of_constant_difference hdiff) hdelta hnonnegative

def HasUniformRecurrentDrop {k : Nat}
    (modes : Nat -> TrackedMode k) (beta : Nat -> Real)
    (epsilon : Real) : Prop :=
  0 < epsilon /\ forall i j : Nat, i < j -> modes i = modes j ->
    beta j <= beta i - epsilon

theorem exists_negative_of_hasUniformRecurrentDrop {k : Nat}
    {modes : Nat -> TrackedMode k} {beta : Nat -> Real} {epsilon : Real}
    (hdrop : HasUniformRecurrentDrop modes beta epsilon) :
    exists n : Nat, beta n < 0 := by
  obtain ⟨mode, positions, hpositions, hmodes⟩ :=
    exists_recurrent_mode_subsequence modes
  have hbound : forall n : Nat,
      beta (positions n) <= beta (positions 0) - (n : Real) * epsilon := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
        have hposition : positions n < positions (n + 1) :=
          hpositions (Nat.lt_succ_self n)
        have hsame : modes (positions n) = modes (positions (n + 1)) := by
          rw [hmodes n, hmodes (n + 1)]
        have hstep := hdrop.2 (positions n) (positions (n + 1))
          hposition hsame
        push_cast
        nlinarith [hdrop.1]
  obtain ⟨n, hn⟩ := exists_nat_gt (beta (positions 0) / epsilon)
  have hmul : beta (positions 0) < (n : Real) * epsilon :=
    (div_lt_iff₀ hdrop.1).mp hn
  exact ⟨positions n, lt_of_le_of_lt (hbound n) (by linarith)⟩

theorem not_forall_nonnegative_of_hasUniformRecurrentDrop {k : Nat}
    {modes : Nat -> TrackedMode k} {beta : Nat -> Real} {epsilon : Real}
    (hdrop : HasUniformRecurrentDrop modes beta epsilon) :
    Not (forall n : Nat, 0 <= beta n) := by
  obtain ⟨n, hn⟩ := exists_negative_of_hasUniformRecurrentDrop hdrop
  intro hnonnegative
  exact (not_lt_of_ge (hnonnegative n)) hn

end GeneralKTermination

end KL2003
end CollatzClassical
