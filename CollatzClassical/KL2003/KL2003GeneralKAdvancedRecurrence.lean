import CollatzClassical.KL2003.KL2003GeneralKInfiniteBranchDescent

namespace CollatzClassical
namespace KL2003
namespace GeneralKAdvancedRecurrence

/-!
Advanced-arrival recurrence on an infinite source branch.

This is the scheduler-independent combinatorial replacement for the false
global `AllSegmentsContextAdmissible` bridge.  A branch whose accumulated
shifts stay nonnegative cannot have an eventually retarded tail, because every
retarded action subtracts exactly two.  Hence advanced actions occur
arbitrarily far out.  Since tracked modes are finite, one target mode receives
an infinite strictly ordered subsequence of advanced arrivals.
-/

open GeneralKSourceGraph
open GeneralKInfiniteBranchDescent
open GeneralKTermination

def IsAdvancedAction {p : Nat} {mode : TrackedMode (p + 1)}
    (action : SourceAction mode) : Prop :=
  match action.1 with
  | .retarded => False
  | .d1Advanced _ => True
  | .d3Advanced _ => True

instance {p : Nat} {mode : TrackedMode (p + 1)}
    (action : SourceAction mode) : Decidable (IsAdvancedAction action) := by
  rcases action with ⟨branch, hvalid⟩
  cases branch <;> simp only [IsAdvancedAction] <;> infer_instance

theorem weight_eval_eq_neg_two_of_not_isAdvanced
    {p : Nat} {mode : TrackedMode (p + 1)} (action : SourceAction mode)
    (hnot : Not (IsAdvancedAction action)) :
    action.weight.eval = -2 := by
  rcases action with ⟨branch, hvalid⟩
  cases branch with
  | retarded => exact SymbolicShift.eval_retardedTwo
  | d1Advanced index => simp [IsAdvancedAction] at hnot
  | d3Advanced index => simp [IsAdvancedAction] at hnot

theorem segmentWeightEval_eq_neg_two_mul_of_no_advanced
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (start length : Nat)
    (hretarded : forall offset : Nat, offset < length ->
      Not (IsAdvancedAction (branch.actions (start + offset)))) :
    branch.segmentWeightEval start length = -2 * (length : Real) := by
  induction length generalizing start with
  | zero => simp [GeneralKInfiniteBranchDescent.InfiniteSourceWalk.segmentWeightEval]
  | succ length ih =>
      simp only [GeneralKInfiniteBranchDescent.InfiniteSourceWalk.segmentWeightEval]
      have hhead : (branch.actions start).weight.eval = -2 := by
        apply weight_eval_eq_neg_two_of_not_isAdvanced
        simpa using hretarded 0 (by omega)
      have htail : branch.segmentWeightEval (start + 1) length =
          -2 * (length : Real) := by
        apply ih
        intro offset hoffset
        have := hretarded (offset + 1) (by omega)
        have hindex : start + 1 + offset = start + (offset + 1) := by omega
        rw [hindex]
        exact this
      rw [hhead, htail]
      push_cast
      ring

theorem exists_advanced_at_or_after_of_shiftsNonnegative
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial)
    (lower : Nat) :
    exists n : Nat, lower <= n /\ IsAdvancedAction (branch.actions n) := by
  by_contra hnone
  have hretarded : forall n : Nat, lower <= n ->
      Not (IsAdvancedAction (branch.actions n)) := by
    intro n hn hadvanced
    exact hnone ⟨n, hn, hadvanced⟩
  obtain ⟨length, hlength⟩ :=
    exists_nat_gt (branch.beta initial lower / 2)
  have hsegment : branch.segmentWeightEval lower length =
      -2 * (length : Real) := by
    apply segmentWeightEval_eq_neg_two_mul_of_no_advanced branch
    intro offset hoffset
    exact hretarded (lower + offset) (by omega)
  have hbeta := branch.beta_add initial lower length
  rw [branch.segment_weight_eval, hsegment] at hbeta
  have htooLow : branch.beta initial (lower + length) < 0 := by
    have hmul : branch.beta initial lower < 2 * (length : Real) := by
      have htwo : (0 : Real) < 2 := by norm_num
      simpa [mul_comm] using (div_lt_iff₀ htwo).mp hlength
    linarith
  exact (not_lt_of_ge (hnonnegative (lower + length))) htooLow

theorem advancedIndices_infinite
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial) :
    {n : Nat | IsAdvancedAction (branch.actions n)}.Infinite := by
  by_contra hnot
  have hfinite : {n : Nat | IsAdvancedAction (branch.actions n)}.Finite :=
    Set.not_infinite.mp hnot
  obtain ⟨bound, hbound⟩ := hfinite.bddAbove
  obtain ⟨n, hn, hadvanced⟩ :=
    exists_advanced_at_or_after_of_shiftsNonnegative
      branch initial hnonnegative (bound + 1)
  have hnle : n <= bound := hbound hadvanced
  omega

theorem exists_recurrent_advanced_target_subsequence
    {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (hnonnegative : branch.ShiftsNonnegative initial) :
    exists mode : TrackedMode (p + 1), exists positions : Nat -> Nat,
      StrictMono positions /\
        (forall j : Nat, IsAdvancedAction (branch.actions (positions j))) /\
          (forall j : Nat, branch.modes (positions j + 1) = mode) := by
  let predicate : Nat -> Prop := fun n => IsAdvancedAction (branch.actions n)
  have hinfinite : {n : Nat | predicate n}.Infinite := by
    simpa only [predicate] using
      advancedIndices_infinite branch initial hnonnegative
  let advancedPositions : Nat -> Nat := Nat.nth predicate
  have hadvancedStrict : StrictMono advancedPositions :=
    Nat.nth_strictMono hinfinite
  have hadvanced : forall j : Nat,
      IsAdvancedAction (branch.actions (advancedPositions j)) := by
    intro j
    exact Nat.nth_mem_of_infinite hinfinite j
  let advancedTargets : Nat -> TrackedMode (p + 1) :=
    fun j => branch.modes (advancedPositions j + 1)
  obtain ⟨mode, subsequence, hsubsequenceStrict, hmodes⟩ :=
    exists_recurrent_mode_subsequence advancedTargets
  refine ⟨mode, fun j => advancedPositions (subsequence j), ?_, ?_, ?_⟩
  · exact hadvancedStrict.comp hsubsequenceStrict
  · intro j
    exact hadvanced (subsequence j)
  · intro j
    exact hmodes j

end GeneralKAdvancedRecurrence
end KL2003
end CollatzClassical
