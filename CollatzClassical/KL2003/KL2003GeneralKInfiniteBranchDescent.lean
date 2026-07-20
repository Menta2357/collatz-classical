import CollatzClassical.KL2003.KL2003GeneralKNestedReturnDescent
import CollatzClassical.KL2003.KL2003GeneralKTerminationCore

namespace CollatzClassical
namespace KL2003

/-!
Arithmetic descent along an infinite typed source branch.

This module is deliberately scheduler-independent.  It defines the structural
object which the surviving-branch extraction must construct: coherent source
actions with their actual typed targets.  Context admissibility and
nonnegativity are separate proved properties, not fields of the structure.
-/

namespace GeneralKInfiniteBranchDescent

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKTermination

/-- A coherent infinite chain in the finite source-transition graph. -/
structure InfiniteSourceWalk {p : Nat} (hp : 1 <= p) where
  modes : Nat -> TrackedMode (p + 1)
  actions : forall n : Nat, SourceAction (modes n)
  target_next : forall n : Nat, (actions n).target hp = modes (n + 1)

namespace InfiniteSourceWalk

/-- Transport both endpoints of a typed source walk.  Keeping this transport
explicit prevents dependent casts from leaking into the arithmetic lemmas. -/
def castSourceWalk {p : Nat} {hp : 1 <= p}
    {source target source' target' : TrackedMode (p + 1)}
    (hsource : source = source') (htarget : target = target')
    (walk : SourceWalk hp source target) : SourceWalk hp source' target' := by
  subst source'
  subst target'
  exact walk

@[simp] theorem castSourceWalk_length {p : Nat} {hp : 1 <= p}
    {source target source' target' : TrackedMode (p + 1)}
    (hsource : source = source') (htarget : target = target')
    (walk : SourceWalk hp source target) :
    (castSourceWalk hsource htarget walk).length = walk.length := by
  subst source'
  subst target'
  rfl

@[simp] theorem castSourceWalk_weight {p : Nat} {hp : 1 <= p}
    {source target source' target' : TrackedMode (p + 1)}
    (hsource : source = source') (htarget : target = target')
    (walk : SourceWalk hp source target) :
    (castSourceWalk hsource htarget walk).weight = walk.weight := by
  subst source'
  subst target'
  rfl

theorem castSourceWalk_contextAdmissible_iff
    {p : Nat} {hp : 1 <= p}
    {source target source' target' : TrackedMode (p + 1)}
    (hsource : source = source') (htarget : target = target')
    (walk : SourceWalk hp source target) :
    ContextAdmissible (castSourceWalk hsource htarget walk) <->
      ContextAdmissible walk := by
  subst source'
  subst target'
  rfl

/-- The finite typed segment beginning at `start` and containing `length`
source actions. -/
def segment {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (start : Nat) : forall length : Nat,
      SourceWalk hp (branch.modes start) (branch.modes (start + length))
  | 0 => SourceWalk.nil (branch.modes start)
  | length + 1 =>
      let tail := castSourceWalk
        (branch.target_next start).symm
        (congrArg branch.modes (by omega))
        (branch.segment (start + 1) length)
      SourceWalk.cons (branch.actions start) tail

@[simp] theorem segment_zero {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (start : Nat) :
    branch.segment start 0 = SourceWalk.nil (branch.modes start) := rfl

theorem segment_length {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (start length : Nat) :
    (branch.segment start length).length = length := by
  induction length generalizing start with
  | zero => simp [segment]
  | succ length ih =>
      simp [segment, ih]

/-- The evaluated weight of a finite branch segment, stated independently of
the dependent source and target indices. -/
noncomputable def segmentWeightEval {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (start : Nat) : Nat -> Real
  | 0 => 0
  | length + 1 =>
      (branch.actions start).weight.eval +
        branch.segmentWeightEval (start + 1) length

theorem segment_weight_eval {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (start length : Nat) :
    (branch.segment start length).weight.eval =
      branch.segmentWeightEval start length := by
  induction length generalizing start with
  | zero => simp [segment, segmentWeightEval, SymbolicShift.eval_zero]
  | succ length ih =>
      simp only [segment, segmentWeightEval, SourceWalk.weight_cons,
        castSourceWalk_weight]
      rw [SymbolicShift.eval_add, ih]

theorem segmentWeightEval_add {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (start first second : Nat) :
    branch.segmentWeightEval start (first + second) =
      branch.segmentWeightEval start first +
        branch.segmentWeightEval (start + first) second := by
  induction first generalizing start with
  | zero => simp [segmentWeightEval]
  | succ first ih =>
      rw [Nat.succ_add]
      simp only [Nat.succ_eq_add_one, segmentWeightEval]
      rw [ih]
      have hindex : start + 1 + first = start + (first + 1) := by omega
      rw [hindex]
      ring

/-- Shift obtained from an initial real value and the finite prefix weight. -/
noncomputable def beta {p : Nat} {hp : 1 <= p} (branch : InfiniteSourceWalk hp)
    (initial : Real) (n : Nat) : Real :=
  initial + branch.segmentWeightEval 0 n

theorem beta_add {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (initial : Real)
    (start length : Nat) :
    branch.beta initial (start + length) =
      branch.beta initial start + (branch.segment start length).weight.eval := by
  rw [beta, beta, branch.segment_weight_eval,
    branch.segmentWeightEval_add]
  simp only [Nat.zero_add]
  ring

/-- Transport only the final endpoint of a typed walk along a proof that it
equals the source. -/
def closeSourceWalk {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) (hclose : source = target) :
    SourceWalk hp source source :=
  castSourceWalk rfl hclose.symm walk

@[simp] theorem closeSourceWalk_length {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) (hclose : source = target) :
    (closeSourceWalk walk hclose).length = walk.length := by
  simp [closeSourceWalk]

@[simp] theorem closeSourceWalk_weight {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) (hclose : source = target) :
    (closeSourceWalk walk hclose).weight = walk.weight := by
  simp [closeSourceWalk]

theorem closeSourceWalk_contextAdmissible_iff
    {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) (hclose : source = target) :
    ContextAdmissible (closeSourceWalk walk hclose) <->
      ContextAdmissible walk := by
  exact castSourceWalk_contextAdmissible_iff rfl hclose.symm walk

def AllSegmentsContextAdmissible {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) : Prop :=
  forall start length : Nat,
    ContextAdmissible (branch.segment start length)

def ShiftsNonnegative {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (initial : Real) : Prop :=
  forall n : Nat, 0 <= branch.beta initial n

theorem recurrentDropAtLength_of_allSegmentsContextAdmissible
    {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (initial epsilon : Real)
    (hdrop : forall weight, weight ∈ admissibleClosedWeights hp ->
      weight <= -epsilon)
    (hadmissible : AllSegmentsContextAdmissible branch)
    (start length : Nat) (hlength : 0 < length)
    (hmodes : branch.modes start = branch.modes (start + length)) :
    branch.beta initial (start + length) <=
      branch.beta initial start - epsilon := by
  let closedSegment : SourceWalk hp (branch.modes start) (branch.modes start) :=
    closeSourceWalk (branch.segment start length) hmodes
  have hclosedLength : 0 < closedSegment.length := by
    dsimp only [closedSegment]
    rw [closeSourceWalk_length, branch.segment_length]
    exact hlength
  have hclosedAdmissible : ContextAdmissible closedSegment := by
    dsimp only [closedSegment]
    exact (closeSourceWalk_contextAdmissible_iff
      (branch.segment start length) hmodes).2 (hadmissible start length)
  have hweightMem : closedSegment.weight.eval ∈ admissibleClosedWeights hp :=
    ⟨branch.modes start, closedSegment, hclosedLength,
      hclosedAdmissible, rfl⟩
  have hsegmentDrop : closedSegment.weight.eval <= -epsilon :=
    hdrop closedSegment.weight.eval hweightMem
  have hbeta := branch.beta_add initial start length
  have hweightEq : closedSegment.weight.eval =
      (branch.segment start length).weight.eval := by
    dsimp only [closedSegment]
    rw [closeSourceWalk_weight]
  rw [← hweightEq] at hbeta
  linarith

theorem hasUniformRecurrentDrop_of_allSegmentsContextAdmissible
    {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (initial : Real)
    (hadmissible : AllSegmentsContextAdmissible branch) :
    exists epsilon : Real,
      HasUniformRecurrentDrop branch.modes (branch.beta initial) epsilon := by
  obtain ⟨epsilon, hepsilon, hdrop⟩ :=
    exists_uniform_admissible_return_drop hp
  refine ⟨epsilon, hepsilon, ?_⟩
  intro i j hij hmodes
  have hadd : i + (j - i) = j := Nat.add_sub_of_le hij.le
  have hmodes' : branch.modes i = branch.modes (i + (j - i)) := by
    simpa only [hadd] using hmodes
  have hdropAtLength :=
    recurrentDropAtLength_of_allSegmentsContextAdmissible
      branch initial epsilon hdrop hadmissible i (j - i)
        (Nat.sub_pos_of_lt hij) hmodes'
  simpa only [hadd] using hdropAtLength

theorem not_shiftsNonnegative_of_allSegmentsContextAdmissible
    {p : Nat} {hp : 1 <= p}
    (branch : InfiniteSourceWalk hp) (initial : Real)
    (hadmissible : AllSegmentsContextAdmissible branch) :
    Not (ShiftsNonnegative branch initial) := by
  obtain ⟨epsilon, hdrop⟩ :=
    hasUniformRecurrentDrop_of_allSegmentsContextAdmissible
      branch initial hadmissible
  exact not_forall_nonnegative_of_hasUniformRecurrentDrop hdrop

end InfiniteSourceWalk

end GeneralKInfiniteBranchDescent

end KL2003
end CollatzClassical
