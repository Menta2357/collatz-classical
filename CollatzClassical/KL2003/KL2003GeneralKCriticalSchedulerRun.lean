import CollatzClassical.KL2003.KL2003GeneralKCriticalSourceStep
import CollatzClassical.KL2003.KL2003GeneralKProvenancedSchedulerDepth
import CollatzClassical.KL2003.KL2003GeneralKProvenanceTrace

namespace CollatzClassical
namespace KL2003

open ELTree

namespace GeneralKCriticalScheduler

open GeneralKSourceGenealogy
open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler
open GeneralKCriticalTerminalFinder
open GeneralKCriticalSourceStep
open GeneralKProvenancedSchedulerDepth
open GeneralKProvenanceTrace

noncomputable def criticalScheduledStep {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root) (y : Real) : ProvenancedTree hp root :=
  match findCriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y with
  | none => tree
  | some selected => selected.occurrence.sourceStep

theorem criticalScheduledStep_eq_self_of_find_eq_none
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root) (y : Real)
    (hfind : findCriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y = none) :
    criticalScheduledStep tree y = tree := by
  simp [criticalScheduledStep, hfind]

theorem criticalScheduledStep_eq_sourceStep_of_find_eq_some
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root) (y : Real)
    (selected : CriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y)
    (hfind : findCriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y = some selected) :
    criticalScheduledStep tree y = selected.occurrence.sourceStep := by
  simp [criticalScheduledStep, hfind]

structure CriticalScheduledStepFacts {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (tree : ProvenancedTree hp root)
    (y : Real) where
  criticalNodeBounds : (criticalScheduledStep tree y).forget.CriticalNodeBounds
    (fun mode z => sourcePhiK mode z) y
  argumentsNonnegative :
    (criticalScheduledStep tree y).forget.normalExpr.ArgumentsNonnegative y
  normalExprEvalLe :
    (criticalScheduledStep tree y).forget.normalExpr.eval
        (fun mode z => sourcePhiK mode z) y <=
      tree.forget.normalExpr.eval (fun mode z => sourcePhiK mode z) y

theorem criticalScheduledStepFacts {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} (tree : ProvenancedTree hp root)
    {y : Real} (hy : 2 <= y)
    (hbounds : tree.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.forget.normalExpr.ArgumentsNonnegative y) :
    CriticalScheduledStepFacts tree y := by
  generalize hfind : findCriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y = result
  cases result with
  | none =>
      refine {
        criticalNodeBounds := ?_
        argumentsNonnegative := ?_
        normalExprEvalLe := ?_ }
      · simpa [criticalScheduledStep, hfind] using hbounds
      · simpa [criticalScheduledStep, hfind] using hargs
      · simp [criticalScheduledStep, hfind]
  | some selected =>
      have facts := criticalSourceStepFacts roots hy selected hbounds hargs
      refine {
        criticalNodeBounds := ?_
        argumentsNonnegative := ?_
        normalExprEvalLe := ?_ }
      · simpa [criticalScheduledStep, hfind] using facts.criticalNodeBounds
      · simpa [criticalScheduledStep, hfind] using facts.argumentsNonnegative
      · simpa [criticalScheduledStep, hfind] using facts.normalExprEvalLe

noncomputable def run {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    (y : Real) : Nat -> ProvenancedTree hp root
  | 0 => initial
  | n + 1 => criticalScheduledStep (run initial y n) y

@[simp] theorem run_zero {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    (y : Real) : run initial y 0 = initial := rfl

@[simp] theorem run_succ {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    (y : Real) (n : Nat) :
    run initial y (n + 1) = criticalScheduledStep (run initial y n) y := rfl

theorem run_invariants {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y) :
    forall n,
      (run initial y n).forget.CriticalNodeBounds
          (fun mode z => sourcePhiK mode z) y /\
        (run initial y n).forget.normalExpr.ArgumentsNonnegative y := by
  intro n
  induction n with
  | zero => exact ⟨hbounds, hargs⟩
  | succ n ih =>
      rw [run_succ]
      have facts := criticalScheduledStepFacts roots (run initial y n)
        hy ih.1 ih.2
      exact ⟨facts.criticalNodeBounds, facts.argumentsNonnegative⟩

theorem run_criticalNodeBounds {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y) :
    forall n, (run initial y n).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y := by
  intro n
  exact (run_invariants roots initial hy hbounds hargs n).1

theorem run_argumentsNonnegative {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y) :
    forall n, (run initial y n).forget.normalExpr.ArgumentsNonnegative y := by
  intro n
  exact (run_invariants roots initial hy hbounds hargs n).2

theorem run_succ_normalExprEvalLe {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y)
    (n : Nat) :
    (run initial y (n + 1)).forget.normalExpr.eval
        (fun mode z => sourcePhiK mode z) y <=
      (run initial y n).forget.normalExpr.eval
        (fun mode z => sourcePhiK mode z) y := by
  rw [run_succ]
  exact (criticalScheduledStepFacts roots (run initial y n) hy
    (run_criticalNodeBounds roots initial hy hbounds hargs n)
    (run_argumentsNonnegative roots initial hy hbounds hargs n)).normalExprEvalLe

theorem run_normalExprEvalLe_initial {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y) :
    forall n,
      (run initial y n).forget.normalExpr.eval
          (fun mode z => sourcePhiK mode z) y <=
        initial.forget.normalExpr.eval (fun mode z => sourcePhiK mode z) y := by
  intro n
  induction n with
  | zero => exact le_rfl
  | succ n ih => exact (run_succ_normalExprEvalLe roots initial hy
      hbounds hargs n).trans ih

theorem traceConsistentFrom_criticalScheduledStep
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    {history : List (ELLabel (p + 1))}
    (htree : TraceConsistentFrom history tree) (y : Real) :
    TraceConsistentFrom history (criticalScheduledStep tree y) := by
  generalize hfind : findCriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y = result
  cases result with
  | none =>
      rw [criticalScheduledStep_eq_self_of_find_eq_none tree y hfind]
      exact htree
  | some selected =>
      rw [criticalScheduledStep_eq_sourceStep_of_find_eq_some
        tree y selected hfind]
      exact htree.sourceStep selected.occurrence

theorem run_traceConsistentFrom
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {initial : ProvenancedTree hp root}
    {history : List (ELLabel (p + 1))}
    (hinitial : TraceConsistentFrom history initial) (y : Real) :
    forall n, TraceConsistentFrom history (run initial y n) := by
  intro n
  induction n with
  | zero => exact hinitial
  | succ n ih => exact traceConsistentFrom_criticalScheduledStep ih y

theorem run_initial_traceConsistent
    {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1))
    (y : Real) (n : Nat) :
    TraceConsistentFrom [] (run (ProvenancedTree.initial hp root) y n) :=
  run_traceConsistentFrom (traceConsistentFrom_initial hp root) y n

theorem run_initial_terminalPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1))
    (y : Real) (n : Nat) {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath
      (run (ProvenancedTree.initial hp root) y n) target) :
    path.forgetPath.context.expandedLabels =
      packedPrefixLabels root.shift (sourceWalkActionList target.walk) := by
  simpa using traceConsistentFrom_terminalPath path
    (run_initial_traceConsistent hp root y n)

def NeverStops {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    (y : Real) : Prop :=
  forall n, findCriticalExpandableOccurrence (run initial y n)
    (fun mode z => sourcePhiK mode z) y ≠ none

theorem exists_selectedOccurrence {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hne : NeverStops initial y) (n : Nat) :
    exists selected : CriticalExpandableOccurrence (run initial y n)
      (fun mode z => sourcePhiK mode z) y,
      findCriticalExpandableOccurrence (run initial y n)
        (fun mode z => sourcePhiK mode z) y = some selected := by
  generalize hfind : findCriticalExpandableOccurrence (run initial y n)
      (fun mode z => sourcePhiK mode z) y = result
  cases result with
  | none => exact False.elim (hne n hfind)
  | some selected => exact ⟨selected, rfl⟩

noncomputable def selectedOccurrence {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hne : NeverStops initial y) (n : Nat) :
    CriticalExpandableOccurrence (run initial y n)
      (fun mode z => sourcePhiK mode z) y :=
  Classical.choose (exists_selectedOccurrence hne n)

theorem find_run_eq_selectedOccurrence {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hne : NeverStops initial y) (n : Nat) :
    findCriticalExpandableOccurrence (run initial y n)
      (fun mode z => sourcePhiK mode z) y =
        some (selectedOccurrence hne n) :=
  Classical.choose_spec (exists_selectedOccurrence hne n)

theorem run_succ_eq_selectedOccurrence_sourceStep
    {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hne : NeverStops initial y) (n : Nat) :
    run initial y (n + 1) =
      (selectedOccurrence hne n).occurrence.sourceStep := by
  rw [run_succ]
  exact criticalScheduledStep_eq_sourceStep_of_find_eq_some
    _ _ _ (find_run_eq_selectedOccurrence hne n)

theorem selectedOccurrence_critical {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hne : NeverStops initial y) (n : Nat) :
    (selectedOccurrence hne n).occurrence.path.forgetPath.context.HoleCritical
      (.terminal (selectedOccurrence hne n).occurrence.target.label)
        (fun mode z => sourcePhiK mode z) y :=
  (selectedOccurrence hne n).targetCritical

theorem selectedStepFacts {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y)
    (hne : NeverStops initial y) (n : Nat) :
    CriticalSourceStepFacts y (selectedOccurrence hne n) :=
  criticalSourceStepFacts roots hy (selectedOccurrence hne n)
    (run_criticalNodeBounds roots initial hy hbounds hargs n)
    (run_argumentsNonnegative roots initial hy hbounds hargs n)

theorem selected_d1_retainedBranchesWitnessFree
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y)
    (hne : NeverStops initial y) (n : Nat)
    (hm : (selectedOccurrence hne n).occurrence.target.label.mode.1.1 % 9 = 2) :
    GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
      ((selectedOccurrence hne n).occurrence.forgetOccurrence.d1Configuration hp hm)
      ((selectedOccurrence hne n).occurrence.forgetOccurrence.d1Configuration hp hm).witnessRetention :=
  (selectedStepFacts roots hy hbounds hargs hne n).d1RetainedBranchesWitnessFree hm

theorem selected_d3_retainedBranchesWitnessFree
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hy : 2 <= y)
    (hbounds : initial.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : initial.forget.normalExpr.ArgumentsNonnegative y)
    (hne : NeverStops initial y) (n : Nat)
    (hm : (selectedOccurrence hne n).occurrence.target.label.mode.1.1 % 9 = 8) :
    GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
      ((selectedOccurrence hne n).occurrence.forgetOccurrence.d3Configuration hp hm)
      ((selectedOccurrence hne n).occurrence.forgetOccurrence.d3Configuration hp hm).witnessRetention :=
  (selectedStepFacts roots hy hbounds hargs hne n).d3RetainedBranchesWitnessFree hm

theorem exists_selectedOccurrence_walk_length_gt
    {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : ProvenancedTree hp root}
    {y : Real} (hne : NeverStops initial y) (bound : Nat) :
    exists n : Nat,
      bound < (selectedOccurrence hne n).occurrence.target.walk.length := by
  by_contra hbounded
  push_neg at hbounded
  have hdesc : forall n,
      treeFuel bound (run initial y (n + 1)) <
        treeFuel bound (run initial y n) := by
    intro n
    rw [run_succ_eq_selectedOccurrence_sourceStep hne n]
    exact treeFuel_sourceStep_lt bound
      (selectedOccurrence hne n).occurrence (hbounded n)
  have hbudget := descendingFuel_add_index_le
    (fuel := fun n => treeFuel bound (run initial y n)) hdesc
    (treeFuel bound initial + 1)
  have hbudget' :
      treeFuel bound (run initial y (treeFuel bound initial + 1)) +
          (treeFuel bound initial + 1) <= treeFuel bound initial := by
    simpa using hbudget
  omega

theorem stopped_iff_criticalTerminalShiftsNegative
    {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    (y : Real) (n : Nat) :
    findCriticalExpandableOccurrence (run initial y n)
        (fun mode z => sourcePhiK mode z) y = none <->
      CriticalTerminalShiftsNegative (run initial y n)
        (fun mode z => sourcePhiK mode z) y :=
  findCriticalExpandableOccurrence_eq_none_iff _ _ _

end GeneralKCriticalScheduler
end KL2003
end CollatzClassical
