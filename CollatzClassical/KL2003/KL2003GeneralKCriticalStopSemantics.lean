import CollatzClassical.KL2003.KL2003GeneralKAdvancedArrivalBoundedness

namespace CollatzClassical
namespace KL2003
namespace GeneralKCriticalStopSemantics

/-!
Pointwise semantic exit from the terminating critical general-k scheduler.

The stopped tree need not be a canonical normal form. For fixed `Phi,y`, a
critical assignment selects one value-preserving branch of every minimum.
The scheduler's stopping predicate says exactly that every terminal on such a
globally critical route has negative shift. The selected expression therefore
gives a finite all-retarded witness below the root value.

The witness retains its scheduler step, generated provenanced tree, critical
assignment, and criticality proof; it cannot be replaced by an arbitrary
retarded expression. This module proves the source `SatisfiesEL` conclusion
pointwise. It neither assumes nor proves order independence or uniqueness of a
syntactic EL tree.
-/

open GeneralKSourceGraph
open GeneralKCriticalScheduler
open GeneralKCriticalTerminalFinder
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree
open ELTree

def AllLeafShiftsNegative {k : Nat} : ELExpr k -> Prop
  | .leaf label => label.shift.eval < 0
  | .add left right =>
      AllLeafShiftsNegative left /\ AllLeafShiftsNegative right
  | .min3 first second third =>
      AllLeafShiftsNegative first /\ AllLeafShiftsNegative second /\
        AllLeafShiftsNegative third

theorem provenanced_selectedExpr_allLeafShiftsNegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real)
    (hnegative : CriticalTerminalShiftsNegative tree Phi y) :
    forall assignment : ELExpr.CriticalAssignment tree.forget.normalExpr,
      assignment.IsCritical Phi y ->
        AllLeafShiftsNegative assignment.selectedExpr := by
  induction tree with
  | terminal node =>
      intro assignment _hcritical
      cases assignment with
      | leaf =>
          change node.label.shift.eval < 0
          exact hnegative node (.here node) trivial
  | expanded node body ih =>
      intro assignment hcritical
      apply ih
      · intro target path hpath
        apply hnegative target (.expanded node body target path)
        simpa [ProvenancedTree.TerminalPath.forgetPath,
          ELTree.TerminalPath.context, ELTree.Context.HoleCritical] using hpath
      · exact hcritical
  | add left right ihLeft ihRight =>
      intro assignment hcritical
      cases assignment with
      | add _ _ leftChoice rightChoice =>
          change AllLeafShiftsNegative leftChoice.selectedExpr /\
            AllLeafShiftsNegative rightChoice.selectedExpr
          constructor
          · apply ihLeft
            · intro target path hpath
              apply hnegative target (.addLeft left right target path)
              simpa [ProvenancedTree.TerminalPath.forgetPath,
                ELTree.TerminalPath.context,
                ELTree.Context.HoleCritical] using hpath
            · exact hcritical.1
          · apply ihRight
            · intro target path hpath
              apply hnegative target (.addRight left right target path)
              simpa [ProvenancedTree.TerminalPath.forgetPath,
                ELTree.TerminalPath.context,
                ELTree.Context.HoleCritical] using hpath
            · exact hcritical.2
  | min2 left right ihLeft ihRight =>
      intro assignment hcritical
      cases assignment with
      | minFirst _ _ _ choice =>
          change AllLeafShiftsNegative choice.selectedExpr
          apply ihLeft
          · intro target path hpath
            apply hnegative target (.min2Left left right target path)
            refine ⟨hpath, ?_⟩
            rw [path.forgetPath.context_plug_target]
            exact hcritical.2.1
          · exact hcritical.1
      | minSecond _ _ _ choice =>
          change AllLeafShiftsNegative choice.selectedExpr
          apply ihRight
          · intro target path hpath
            apply hnegative target (.min2Right left right target path)
            refine ⟨hpath, ?_⟩
            rw [path.forgetPath.context_plug_target]
            exact hcritical.2.1
          · exact hcritical.1
      | minThird _ _ _ choice =>
          change AllLeafShiftsNegative choice.selectedExpr
          apply ihRight
          · intro target path hpath
            apply hnegative target (.min2Right left right target path)
            refine ⟨hpath, ?_⟩
            rw [path.forgetPath.context_plug_target]
            exact hcritical.2.1
          · exact hcritical.1
  | min3 first second third ihFirst ihSecond ihThird =>
      intro assignment hcritical
      cases assignment with
      | minFirst _ _ _ choice =>
          change AllLeafShiftsNegative choice.selectedExpr
          apply ihFirst
          · intro target path hpath
            apply hnegative target (.minFirst first second third target path)
            refine ⟨hpath, ?_⟩
            change Min3Retention.criticalFirst
              ((path.forgetPath.context.plug (.terminal target.label)).normalExpr.eval Phi y)
              (second.forget.normalExpr.eval Phi y) (third.forget.normalExpr.eval Phi y)
            rw [path.forgetPath.context_plug_target]
            exact hcritical.2
          · exact hcritical.1
      | minSecond _ _ _ choice =>
          change AllLeafShiftsNegative choice.selectedExpr
          apply ihSecond
          · intro target path hpath
            apply hnegative target (.minSecond first second third target path)
            refine ⟨hpath, ?_⟩
            change Min3Retention.criticalSecond (first.forget.normalExpr.eval Phi y)
              ((path.forgetPath.context.plug (.terminal target.label)).normalExpr.eval Phi y)
              (third.forget.normalExpr.eval Phi y)
            rw [path.forgetPath.context_plug_target]
            exact hcritical.2
          · exact hcritical.1
      | minThird _ _ _ choice =>
          change AllLeafShiftsNegative choice.selectedExpr
          apply ihThird
          · intro target path hpath
            apply hnegative target (.minThird first second third target path)
            refine ⟨hpath, ?_⟩
            change Min3Retention.criticalThird (first.forget.normalExpr.eval Phi y)
              (second.forget.normalExpr.eval Phi y)
              ((path.forgetPath.context.plug (.terminal target.label)).normalExpr.eval Phi y)
            rw [path.forgetPath.context_plug_target]
            exact hcritical.2
          · exact hcritical.1

structure SourceELRetardedWitness {p : Nat} (hp : 1 <= p)
    (root : ELLabel (p + 1)) (y : Real) where
  steps : Nat
  assignment : ELExpr.CriticalAssignment
    ((GeneralKCriticalScheduler.run
      (ProvenancedTree.initial hp root) y steps).forget.normalExpr)
  critical : assignment.IsCritical
    (fun mode z => sourcePhiK mode z) y
  retarded : AllLeafShiftsNegative assignment.selectedExpr
  row_le : assignment.selectedExpr.eval
      (fun mode z => sourcePhiK mode z) y <=
    sourcePhiK root.mode (y + root.shift.eval)

def SatisfiesELAt {p : Nat} {hp : 1 <= p}
    (root : ELLabel (p + 1)) (y : Real) : Prop :=
  Nonempty (SourceELRetardedWitness hp root y)

theorem criticalStop_satisfiesELAt
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y)
    (n : Nat)
    (hnegative : CriticalTerminalShiftsNegative
      (GeneralKCriticalScheduler.run (ProvenancedTree.initial hp root) y n)
      (fun mode z => sourcePhiK mode z) y) :
    SatisfiesELAt (hp := hp) root y := by
  let stopped :=
    GeneralKCriticalScheduler.run (ProvenancedTree.initial hp root) y n
  obtain ⟨assignment, hcritical⟩ :=
    ELExpr.CriticalAssignment.exists_isCritical stopped.forget.normalExpr
      (fun mode z => sourcePhiK mode z) y
  refine ⟨{
    steps := n
    assignment := assignment
    critical := hcritical
    retarded := ?_
    row_le := ?_
  }⟩
  · exact provenanced_selectedExpr_allLeafShiftsNegative stopped
      (fun mode z => sourcePhiK mode z) y hnegative assignment hcritical
  · rw [assignment.selectedExpr_eval_eq (fun mode z => sourcePhiK mode z) y hcritical]
    exact GeneralKCriticalScheduler.run_normalExprEvalLe_initial
      roots (ProvenancedTree.initial hp root) hy hbounds hargs n

theorem sourcePhiK_satisfiesELAt
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y) :
    SatisfiesELAt (hp := hp) root y := by
  obtain ⟨n, hnegative⟩ :=
    GeneralKAdvancedArrivalBoundedness.exists_criticalTerminalShiftsNegative
      roots hy hbounds hargs
  exact criticalStop_satisfiesELAt roots hy hbounds hargs n hnegative

def zeroRootLabel {k : Nat} (mode : TrackedMode k) : ELLabel k :=
  ⟨mode, SymbolicShift.zero⟩

def SatisfiesEL {p : Nat} (hp : 1 <= p) : Prop :=
  forall mode y, 2 <= y ->
    SatisfiesELAt (hp := hp) (zeroRootLabel mode) y

theorem sourcePhiK_satisfiesEL
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    SatisfiesEL hp := by
  intro mode y hy
  apply sourcePhiK_satisfiesELAt (hp := hp) roots hy
  · trivial
  · change 0 <= y + SymbolicShift.zero.eval
    rw [SymbolicShift.eval_zero, add_zero]
    linarith

end GeneralKCriticalStopSemantics
end KL2003
end CollatzClassical
