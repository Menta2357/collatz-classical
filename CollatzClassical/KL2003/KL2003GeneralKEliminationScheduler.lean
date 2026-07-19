import CollatzClassical.KL2003.KL2003GeneralKEliminationContext

namespace CollatzClassical
namespace KL2003

/-!
Source-faithful scheduling for one general-`k` EL expansion step.

The scheduler finds the first terminal whose symbolic shift is nonnegative,
expands it with the source D1/D2/D3 row, and applies the syntactic deletion
rule immediately to the new advanced minimum in the D1 and D3 cases.  The
deletion decision depends only on path labels and shifts, never on `Phi`.

The source step preserves `CriticalNodeBounds`, including when the advanced
minimum selected for syntactic deletion is not globally critical. This module
does not claim termination of the combined expansion/deletion process, order
independence, or an EL normal-form theorem.
-/

namespace ELTree

namespace Context

theorem criticalNodeBounds_of_root {k : Nat} (context : Context k)
    (tree : ELTree k) (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : tree.CriticalNodeBounds Phi y) :
    context.CriticalNodeBounds Phi y tree := by
  apply criticalNodeBounds_of_dominates .hole context Phi y tree
  · intro inner subtree _ hcritical
    have hparts := (holeCritical_comp_iff context inner subtree Phi y).1 hcritical
    simpa [comp] using hparts.1
  · exact hbounds

end Context

namespace Min3Path

theorem normalExpr_eval_le_reduceAt {k : Nat} {tree : ELTree k}
    (retention : Min3Retention) (path : Min3Path tree)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    tree.normalExpr.eval Phi y <=
      (path.reduceAt retention).normalExpr.eval Phi y := by
  have hlocal := retention.min3_normalExpr_eval_le_reduce
    path.firstChild path.secondChild path.thirdChild Phi y
  have hplug := path.context.plug_normalExpr_eval_mono path.target
    (retention.reduce path.firstChild path.secondChild path.thirdChild)
    Phi y hlocal
  simpa [context_plug_target, context_plug_reduce] using hplug

theorem reduceAt_criticalNodeBounds_of_totallyNoncritical_of_nodeBounds
    {k : Nat} {tree : ELTree k} (retention : Min3Retention)
    (path : Min3Path tree) (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hnot : path.TotallyNoncritical Phi y)
    (hbounds : tree.NodeBounds Phi y) :
    (path.reduceAt retention).CriticalNodeBounds Phi y := by
  induction path with
  | here first second third =>
      exact False.elim (hnot (by simp [TotallyNoncritical, context,
        Context.HoleCritical]))
  | expanded label body path ih =>
      have hnotSub : path.TotallyNoncritical Phi y := by
        simpa [TotallyNoncritical, context, Context.HoleCritical] using hnot
      have hbodyBounds := ih hnotSub hbounds.1
      refine ⟨?_, Context.criticalNodeBounds_of_root
        (.expanded label .hole) _ Phi y hbodyBounds⟩
      intro _
      calc
        (path.reduceAt retention).normalExpr.eval Phi y =
            body.normalExpr.eval Phi y :=
          path.reduceAt_normalExpr_eval_eq_of_totallyNoncritical
            retention Phi y hnotSub
        _ <= body.frontierExpr.eval Phi y :=
          body.normalExpr_eval_le_frontierExpr_eval Phi y hbounds.1
        _ <= Phi label.mode (y + label.shift.eval) := hbounds.2
  | addLeft left right path ih =>
      have hnotSub : path.TotallyNoncritical Phi y := by
        simpa [TotallyNoncritical, context, Context.HoleCritical] using hnot
      exact ⟨Context.criticalNodeBounds_of_root
          (.addLeft .hole right) _ Phi y (ih hnotSub hbounds.1),
        Context.criticalNodeBounds_of_nodeBounds
          (.addRight (path.reduceAt retention) .hole) right Phi y hbounds.2⟩
  | addRight left right path ih =>
      have hnotSub : path.TotallyNoncritical Phi y := by
        simpa [TotallyNoncritical, context, Context.HoleCritical] using hnot
      exact ⟨Context.criticalNodeBounds_of_nodeBounds
          (.addLeft .hole (path.reduceAt retention)) left Phi y hbounds.1,
        Context.criticalNodeBounds_of_root
          (.addRight left .hole) _ Phi y (ih hnotSub hbounds.2)⟩
  | min2Left left right path ih =>
      change ¬ (path.context.HoleCritical path.target Phi y /\
        (path.context.plug path.target).normalExpr.eval Phi y <=
          right.normalExpr.eval Phi y) at hnot
      by_cases hsub : path.context.HoleCritical path.target Phi y
      · have hlocalNot : ¬ (path.context.plug path.target).normalExpr.eval Phi y <=
            right.normalExpr.eval Phi y := by
          intro hle
          exact hnot ⟨hsub, hle⟩
        have hmono := path.context.plug_normalExpr_eval_mono path.target
          (retention.reduce path.firstChild path.secondChild path.thirdChild)
          Phi y (retention.min3_normalExpr_eval_le_reduce
            path.firstChild path.secondChild path.thirdChild Phi y)
        have hnotWhole : ¬ ((.min2Left .hole right) : Context k).HoleCritical
            (path.reduceAt retention) Phi y := by
          intro hcritical
          have hnewLe :
              (path.context.plug
                (retention.reduce path.firstChild path.secondChild
                  path.thirdChild)).normalExpr.eval Phi y <=
                right.normalExpr.eval Phi y := by
            simpa [path.context_plug_reduce] using hcritical.2
          exact hlocalNot (hmono.trans hnewLe)
        exact ⟨Context.criticalNodeBounds_of_not_holeCritical
            (.min2Left .hole right) (path.reduceAt retention) Phi y hnotWhole,
          Context.criticalNodeBounds_of_nodeBounds
            (.min2Right (path.reduceAt retention) .hole) right Phi y hbounds.2⟩
      · have hnotSub : path.TotallyNoncritical Phi y := hsub
        exact ⟨Context.criticalNodeBounds_of_root
            (.min2Left .hole right) _ Phi y (ih hnotSub hbounds.1),
          Context.criticalNodeBounds_of_nodeBounds
            (.min2Right (path.reduceAt retention) .hole) right Phi y hbounds.2⟩
  | min2Right left right path ih =>
      change ¬ (path.context.HoleCritical path.target Phi y /\
        (path.context.plug path.target).normalExpr.eval Phi y <=
          left.normalExpr.eval Phi y) at hnot
      by_cases hsub : path.context.HoleCritical path.target Phi y
      · have hlocalNot : ¬ (path.context.plug path.target).normalExpr.eval Phi y <=
            left.normalExpr.eval Phi y := by
          intro hle
          exact hnot ⟨hsub, hle⟩
        have hmono := path.context.plug_normalExpr_eval_mono path.target
          (retention.reduce path.firstChild path.secondChild path.thirdChild)
          Phi y (retention.min3_normalExpr_eval_le_reduce
            path.firstChild path.secondChild path.thirdChild Phi y)
        have hnotWhole : ¬ ((.min2Right left .hole) : Context k).HoleCritical
            (path.reduceAt retention) Phi y := by
          intro hcritical
          have hnewLe :
              (path.context.plug
                (retention.reduce path.firstChild path.secondChild
                  path.thirdChild)).normalExpr.eval Phi y <=
                left.normalExpr.eval Phi y := by
            simpa [path.context_plug_reduce] using hcritical.2
          exact hlocalNot (hmono.trans hnewLe)
        exact ⟨Context.criticalNodeBounds_of_nodeBounds
            (.min2Left .hole (path.reduceAt retention)) left Phi y hbounds.1,
          Context.criticalNodeBounds_of_not_holeCritical
            (.min2Right left .hole) (path.reduceAt retention) Phi y hnotWhole⟩
      · have hnotSub : path.TotallyNoncritical Phi y := hsub
        exact ⟨Context.criticalNodeBounds_of_nodeBounds
            (.min2Left .hole (path.reduceAt retention)) left Phi y hbounds.1,
          Context.criticalNodeBounds_of_root
            (.min2Right left .hole) _ Phi y (ih hnotSub hbounds.2)⟩
  | minFirst first second third path ih =>
      change ¬ (path.context.HoleCritical path.target Phi y /\
        Min3Retention.criticalFirst
          ((path.context.plug path.target).normalExpr.eval Phi y)
          (second.normalExpr.eval Phi y) (third.normalExpr.eval Phi y)) at hnot
      by_cases hsub : path.context.HoleCritical path.target Phi y
      · have hlocalNot : ¬ Min3Retention.criticalFirst
            ((path.context.plug path.target).normalExpr.eval Phi y)
            (second.normalExpr.eval Phi y)
            (third.normalExpr.eval Phi y) := by
          intro hcritical
          exact hnot ⟨hsub, hcritical⟩
        have hmono := path.context.plug_normalExpr_eval_mono path.target
          (retention.reduce path.firstChild path.secondChild path.thirdChild)
          Phi y (retention.min3_normalExpr_eval_le_reduce
            path.firstChild path.secondChild path.thirdChild Phi y)
        have hnewLocalNot := Context.not_criticalFirst_of_mono hmono hlocalNot
        have hnotWhole : ¬ ((.minFirst .hole second third) : Context k).HoleCritical
            (path.reduceAt retention) Phi y := by
          intro hcritical
          apply hnewLocalNot
          simpa [path.context_plug_reduce] using hcritical.2
        exact ⟨Context.criticalNodeBounds_of_not_holeCritical
            (.minFirst .hole second third) (path.reduceAt retention)
            Phi y hnotWhole,
          Context.criticalNodeBounds_of_nodeBounds
            (.minSecond (path.reduceAt retention) .hole third)
            second Phi y hbounds.2.1,
          Context.criticalNodeBounds_of_nodeBounds
            (.minThird (path.reduceAt retention) second .hole)
            third Phi y hbounds.2.2⟩
      · have hnotSub : path.TotallyNoncritical Phi y := hsub
        exact ⟨Context.criticalNodeBounds_of_root
            (.minFirst .hole second third) _ Phi y (ih hnotSub hbounds.1),
          Context.criticalNodeBounds_of_nodeBounds
            (.minSecond (path.reduceAt retention) .hole third)
            second Phi y hbounds.2.1,
          Context.criticalNodeBounds_of_nodeBounds
            (.minThird (path.reduceAt retention) second .hole)
            third Phi y hbounds.2.2⟩
  | minSecond first second third path ih =>
      change ¬ (path.context.HoleCritical path.target Phi y /\
        Min3Retention.criticalSecond (first.normalExpr.eval Phi y)
          ((path.context.plug path.target).normalExpr.eval Phi y)
          (third.normalExpr.eval Phi y)) at hnot
      by_cases hsub : path.context.HoleCritical path.target Phi y
      · have hlocalNot : ¬ Min3Retention.criticalSecond
            (first.normalExpr.eval Phi y) (second.normalExpr.eval Phi y)
            (third.normalExpr.eval Phi y) := by
          intro hcritical
          apply hnot
          refine ⟨hsub, ?_⟩
          simpa [path.context_plug_target] using hcritical
        have hmono := path.context.plug_normalExpr_eval_mono path.target
          (retention.reduce path.firstChild path.secondChild path.thirdChild)
          Phi y (retention.min3_normalExpr_eval_le_reduce
            path.firstChild path.secondChild path.thirdChild Phi y)
        have hlocalNotPlug : ¬ Min3Retention.criticalSecond
            (first.normalExpr.eval Phi y)
            ((path.context.plug path.target).normalExpr.eval Phi y)
            (third.normalExpr.eval Phi y) := by
          simpa [path.context_plug_target] using hlocalNot
        have hnewLocalNot := Context.not_criticalSecond_of_mono hmono hlocalNotPlug
        have hnotWhole : ¬ ((.minSecond first .hole third) : Context k).HoleCritical
            (path.reduceAt retention) Phi y := by
          intro hcritical
          apply hnewLocalNot
          simpa [path.context_plug_reduce] using hcritical.2
        exact ⟨Context.criticalNodeBounds_of_nodeBounds
            (.minFirst .hole (path.reduceAt retention) third)
            first Phi y hbounds.1,
          Context.criticalNodeBounds_of_not_holeCritical
            (.minSecond first .hole third) (path.reduceAt retention)
            Phi y hnotWhole,
          Context.criticalNodeBounds_of_nodeBounds
            (.minThird first (path.reduceAt retention) .hole)
            third Phi y hbounds.2.2⟩
      · have hnotSub : path.TotallyNoncritical Phi y := hsub
        exact ⟨Context.criticalNodeBounds_of_nodeBounds
            (.minFirst .hole (path.reduceAt retention) third)
            first Phi y hbounds.1,
          Context.criticalNodeBounds_of_root
            (.minSecond first .hole third) _ Phi y (ih hnotSub hbounds.2.1),
          Context.criticalNodeBounds_of_nodeBounds
            (.minThird first (path.reduceAt retention) .hole)
            third Phi y hbounds.2.2⟩
  | minThird first second third path ih =>
      change ¬ (path.context.HoleCritical path.target Phi y /\
        Min3Retention.criticalThird (first.normalExpr.eval Phi y)
          (second.normalExpr.eval Phi y)
          ((path.context.plug path.target).normalExpr.eval Phi y)) at hnot
      by_cases hsub : path.context.HoleCritical path.target Phi y
      · have hlocalNot : ¬ Min3Retention.criticalThird
            (first.normalExpr.eval Phi y) (second.normalExpr.eval Phi y)
            (third.normalExpr.eval Phi y) := by
          intro hcritical
          apply hnot
          refine ⟨hsub, ?_⟩
          simpa [path.context_plug_target] using hcritical
        have hmono := path.context.plug_normalExpr_eval_mono path.target
          (retention.reduce path.firstChild path.secondChild path.thirdChild)
          Phi y (retention.min3_normalExpr_eval_le_reduce
            path.firstChild path.secondChild path.thirdChild Phi y)
        have hlocalNotPlug : ¬ Min3Retention.criticalThird
            (first.normalExpr.eval Phi y) (second.normalExpr.eval Phi y)
            ((path.context.plug path.target).normalExpr.eval Phi y) := by
          simpa [path.context_plug_target] using hlocalNot
        have hnewLocalNot := Context.not_criticalThird_of_mono hmono hlocalNotPlug
        have hnotWhole : ¬ ((.minThird first second .hole) : Context k).HoleCritical
            (path.reduceAt retention) Phi y := by
          intro hcritical
          apply hnewLocalNot
          simpa [path.context_plug_reduce] using hcritical.2
        exact ⟨Context.criticalNodeBounds_of_nodeBounds
            (.minFirst .hole second (path.reduceAt retention))
            first Phi y hbounds.1,
          Context.criticalNodeBounds_of_nodeBounds
            (.minSecond first .hole (path.reduceAt retention))
            second Phi y hbounds.2.1,
          Context.criticalNodeBounds_of_not_holeCritical
            (.minThird first second .hole) (path.reduceAt retention)
            Phi y hnotWhole⟩
      · have hnotSub : path.TotallyNoncritical Phi y := hsub
        exact ⟨Context.criticalNodeBounds_of_nodeBounds
            (.minFirst .hole second (path.reduceAt retention))
            first Phi y hbounds.1,
          Context.criticalNodeBounds_of_nodeBounds
            (.minSecond first .hole (path.reduceAt retention))
            second Phi y hbounds.2.1,
          Context.criticalNodeBounds_of_root
            (.minThird first second .hole) _ Phi y (ih hnotSub hbounds.2.2)⟩

theorem reduceAt_criticalNodeBounds_of_deletedBranchesTotallyNoncritical_of_nodeBounds
    {k : Nat} {tree : ELTree k} (retention : Min3Retention)
    (path : Min3Path tree) (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hsound : path.DeletedBranchesTotallyNoncritical retention Phi y)
    (hbounds : tree.NodeBounds Phi y) :
    (path.reduceAt retention).CriticalNodeBounds Phi y := by
  by_cases hcritical : path.context.HoleCritical path.target Phi y
  · exact path.reduceAt_criticalNodeBounds_of_deletedBranchesTotallyNoncritical_of_targetCritical
      retention Phi y hsound hcritical
        (criticalNodeBounds_of_nodeBounds tree Phi y hbounds)
  · exact path.reduceAt_criticalNodeBounds_of_totallyNoncritical_of_nodeBounds
      retention Phi y hcritical hbounds

end Min3Path

theorem shiftBy_argumentsNonnegative {k : Nat} (expr : ELExpr k)
    (delta : SymbolicShift) (y : Real)
    (hargs : expr.ArgumentsNonnegative (y + delta.eval)) :
    (expr.shiftBy delta).ArgumentsNonnegative y := by
  induction expr with
  | leaf label =>
      simpa only [ELExpr.shiftBy, ELExpr.ArgumentsNonnegative,
        SymbolicShift.eval_add,
        add_assoc] using hargs
  | add left right ihLeft ihRight =>
      exact ⟨ihLeft hargs.1, ihRight hargs.2⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      exact ⟨ihFirst hargs.1, ihSecond hargs.2.1, ihThird hargs.2.2⟩

theorem sourceSplitTree_normalExpr_argumentsNonnegative {p : Nat}
    (hp : 1 <= p) (label : ELLabel (p + 1)) {y : Real}
    (hy : 2 <= y + label.shift.eval) :
    (sourceSplitTree hp label).normalExpr.ArgumentsNonnegative y := by
  rw [show (sourceSplitTree hp label).normalExpr = splitTopExpr hp label by
    simp [sourceSplitTree, normalExpr, normalExpr_ofExpr]]
  unfold splitTopExpr
  split
  next h2 =>
    apply shiftBy_argumentsNonnegative
    simp only [d1TopExpr, ELExpr.ArgumentsNonnegative, elLeaf,
      SymbolicShift.eval_retardedTwo, SymbolicShift.eval_d1Advanced]
    constructor
    · linarith
    · have halpha := alpha_lower_bound
      constructor
      · linarith
      · constructor <;> linarith
  next hnot2 =>
    split
    next h5 =>
      apply shiftBy_argumentsNonnegative
      simp only [d2TopExpr, ELExpr.ArgumentsNonnegative, elLeaf,
        SymbolicShift.eval_retardedTwo]
      linarith
    next hnot5 =>
      apply shiftBy_argumentsNonnegative
      simp only [d3TopExpr, ELExpr.ArgumentsNonnegative, elLeaf,
        SymbolicShift.eval_retardedTwo, SymbolicShift.eval_d3Advanced]
      constructor
      · linarith
      · have halpha := alpha_lower_bound
        constructor
        · linarith
        · constructor <;> linarith

namespace TerminalPath

theorem splitAt_normalExpr_argumentsNonnegative {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target) {y : Real}
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hy : 2 <= y + target.shift.eval) :
    (path.splitAt hp).normalExpr.ArgumentsNonnegative y := by
  induction path with
  | here label => exact sourceSplitTree_normalExpr_argumentsNonnegative hp label hy
  | expanded label body target path ih => exact ih hargs hy
  | addLeft left right target path ih => exact ⟨ih hargs.1 hy, hargs.2⟩
  | addRight left right target path ih => exact ⟨hargs.1, ih hargs.2 hy⟩
  | min2Left left right target path ih => exact ⟨ih hargs.1 hy, hargs.2⟩
  | min2Right left right target path ih =>
      exact ⟨hargs.1, ih hargs.2.1 hy, ih hargs.2.2 hy⟩
  | minFirst first second third target path ih =>
      exact ⟨ih hargs.1 hy, hargs.2.1, hargs.2.2⟩
  | minSecond first second third target path ih =>
      exact ⟨hargs.1, ih hargs.2.1 hy, hargs.2.2⟩
  | minThird first second third target path ih =>
      exact ⟨hargs.1, hargs.2.1, ih hargs.2.2 hy⟩

end TerminalPath

structure ExpandableOccurrence {k : Nat} (tree : ELTree k) where
  target : ELLabel k
  path : TerminalPath tree target
  shift_nonnegative : 0 <= target.shift.eval

namespace ExpandableOccurrence

def split {p : Nat} (hp : 1 <= p) {tree : ELTree (p + 1)}
    (occurrence : ExpandableOccurrence tree) : ELTree (p + 1) :=
  occurrence.path.splitAt hp

theorem split_frontierExpr {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree) :
    (occurrence.split hp).frontierExpr = tree.frontierExpr :=
  occurrence.path.frontierExpr_splitAt hp

theorem split_nodeBounds {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    {y : Real} (hbounds : tree.NodeBounds
      (fun mode z => sourcePhiK mode z) y) (hy : 2 <= y) :
    (occurrence.split hp).NodeBounds
      (fun mode z => sourcePhiK mode z) y := by
  apply occurrence.path.splitAt_nodeBounds hp roots hbounds
  linarith [occurrence.shift_nonnegative]

theorem split_normalExpr_argumentsNonnegative {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    {y : Real} (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hy : 2 <= y) :
    (occurrence.split hp).normalExpr.ArgumentsNonnegative y := by
  apply occurrence.path.splitAt_normalExpr_argumentsNonnegative hp hargs
  linarith [occurrence.shift_nonnegative]

theorem sourcePhiK_positive {p : Nat}
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    PositivePhi (fun (mode : TrackedMode (p + 1)) z => sourcePhiK mode z) := by
  intro mode y hy
  exact lt_of_lt_of_le zero_lt_one (sourcePhiK_one_le roots hy)

theorem sourcePhiK_monotone {p : Nat}
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    MonotonePhi (fun (mode : TrackedMode (p + 1)) z => sourcePhiK mode z) := by
  intro mode y1 y2 hy
  exact sourcePhiK_mono_y roots hy

def d1Configuration {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 2) :
    TerminalPath.AdvancedMinConfiguration (occurrence.split hp)
      (d1AdvancedSplitLabel hp occurrence.target hm 0)
      (d1AdvancedSplitLabel hp occurrence.target hm 1)
      (d1AdvancedSplitLabel hp occurrence.target hm 2) :=
  (TerminalPath.sourceD1AdvancedConfigurationData hp occurrence.target hm)
    |>.descendSplit hp occurrence.path

def d3Configuration {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 8) :
    TerminalPath.AdvancedMinConfiguration (occurrence.split hp)
      (d3AdvancedSplitLabel hp occurrence.target hm 0)
      (d3AdvancedSplitLabel hp occurrence.target hm 1)
      (d3AdvancedSplitLabel hp occurrence.target hm 2) :=
  (TerminalPath.sourceD3AdvancedConfigurationData hp occurrence.target hm)
    |>.descendSplit hp occurrence.path

noncomputable def sourceStep {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree) :
    ELTree (p + 1) := by
  classical
  exact if hm2 : occurrence.target.mode.1.1 % 9 = 2 then
    let configuration := occurrence.d1Configuration hp hm2
    configuration.minPath.reduceAt configuration.witnessRetention
  else if hm8 : occurrence.target.mode.1.1 % 9 = 8 then
    let configuration := occurrence.d3Configuration hp hm8
    configuration.minPath.reduceAt configuration.witnessRetention
  else
    occurrence.split hp

theorem sourceStep_eq_d1 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 2) :
    occurrence.sourceStep hp =
      let configuration := occurrence.d1Configuration hp hm
      configuration.minPath.reduceAt configuration.witnessRetention := by
  simp [sourceStep, hm]

theorem sourceStep_eq_d3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 8) :
    occurrence.sourceStep hp =
      let configuration := occurrence.d3Configuration hp hm
      configuration.minPath.reduceAt configuration.witnessRetention := by
  have hnot2 : occurrence.target.mode.1.1 % 9 != 2 := by
    rw [hm]
    decide
  simp [sourceStep, hm, hnot2]

theorem sourceStep_eq_d2 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 5) :
    occurrence.sourceStep hp = occurrence.split hp := by
  have hnot2 : occurrence.target.mode.1.1 % 9 != 2 := by
    rw [hm]
    decide
  have hnot8 : occurrence.target.mode.1.1 % 9 != 8 := by
    rw [hm]
    decide
  simp [sourceStep, hm, hnot2, hnot8]

theorem d1_deletedBranchesHaveWitness {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 2) :
    (occurrence.d1Configuration hp hm).DeletedBranchesHaveWitness
      (occurrence.d1Configuration hp hm).witnessRetention :=
  (occurrence.d1Configuration hp hm).witnessRetention_deletedBranchesHaveWitness

theorem d3_deletedBranchesHaveWitness {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 8) :
    (occurrence.d3Configuration hp hm).DeletedBranchesHaveWitness
      (occurrence.d3Configuration hp hm).witnessRetention :=
  (occurrence.d3Configuration hp hm).witnessRetention_deletedBranchesHaveWitness

theorem sourceStep_criticalNodeBounds {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    {y : Real} (hy : 2 <= y)
    (hbounds : tree.NodeBounds (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    (occurrence.sourceStep hp).CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y := by
  have hsplitBounds := occurrence.split_nodeBounds hp roots hbounds hy
  have hsplitArgs :=
    occurrence.split_normalExpr_argumentsNonnegative hp hargs hy
  have hpos := sourcePhiK_positive roots
  have hmono := sourcePhiK_monotone roots
  have hmodes : occurrence.target.mode.1.1 % 9 = 2 \/
      occurrence.target.mode.1.1 % 9 = 5 \/
        occurrence.target.mode.1.1 % 9 = 8 := by
    have htracked := occurrence.target.mode.2
    omega
  rcases hmodes with hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hp hm2]
    let configuration := occurrence.d1Configuration hp hm2
    have hsound :=
      configuration.deletedBranchesTotallyNoncritical_of_witnesses
        configuration.witnessRetention hpos hmono hsplitBounds hsplitArgs
          configuration.witnessRetention_deletedBranchesHaveWitness
    exact configuration.minPath
      |>.reduceAt_criticalNodeBounds_of_deletedBranchesTotallyNoncritical_of_nodeBounds
        configuration.witnessRetention _ _ hsound hsplitBounds
  · rw [occurrence.sourceStep_eq_d2 hp hm5]
    exact criticalNodeBounds_of_nodeBounds _ _ _ hsplitBounds
  · rw [occurrence.sourceStep_eq_d3 hp hm8]
    let configuration := occurrence.d3Configuration hp hm8
    have hsound :=
      configuration.deletedBranchesTotallyNoncritical_of_witnesses
        configuration.witnessRetention hpos hmono hsplitBounds hsplitArgs
          configuration.witnessRetention_deletedBranchesHaveWitness
    exact configuration.minPath
      |>.reduceAt_criticalNodeBounds_of_deletedBranchesTotallyNoncritical_of_nodeBounds
        configuration.witnessRetention _ _ hsound hsplitBounds

end ExpandableOccurrence

theorem trackedMode_mod_nine_cases {k : Nat} (mode : TrackedMode k) :
    mode.1.1 % 9 = 2 \/ mode.1.1 % 9 = 5 \/ mode.1.1 % 9 = 8 := by
  have htracked : mode.1.1 % 3 = 2 := mode.2
  omega

def TerminalShiftsNegative {k : Nat} : ELTree k -> Prop
  | .terminal label => label.shift.eval < 0
  | .expanded _ body => body.TerminalShiftsNegative
  | .add left right | .min2 left right =>
      left.TerminalShiftsNegative /\ right.TerminalShiftsNegative
  | .min3 first second third =>
      first.TerminalShiftsNegative /\ second.TerminalShiftsNegative /\
        third.TerminalShiftsNegative

noncomputable def findExpandableOccurrence {k : Nat} :
    (tree : ELTree k) -> Option (ExpandableOccurrence tree)
  | .terminal label =>
      if hshift : 0 <= label.shift.eval then
        some <| ExpandableOccurrence.mk label (.here label) hshift
      else none
  | .expanded label body =>
      (findExpandableOccurrence body).map fun occurrence =>
        ExpandableOccurrence.mk occurrence.target
          (.expanded label body occurrence.target occurrence.path)
          occurrence.shift_nonnegative
  | .add left right =>
      match findExpandableOccurrence left with
      | some occurrence =>
          some <| ExpandableOccurrence.mk occurrence.target
            (.addLeft left right occurrence.target occurrence.path)
            occurrence.shift_nonnegative
      | none =>
          (findExpandableOccurrence right).map fun occurrence =>
            ExpandableOccurrence.mk occurrence.target
              (.addRight left right occurrence.target occurrence.path)
              occurrence.shift_nonnegative
  | .min2 left right =>
      match findExpandableOccurrence left with
      | some occurrence =>
          some <| ExpandableOccurrence.mk occurrence.target
            (.min2Left left right occurrence.target occurrence.path)
            occurrence.shift_nonnegative
      | none =>
          (findExpandableOccurrence right).map fun occurrence =>
            ExpandableOccurrence.mk occurrence.target
              (.min2Right left right occurrence.target occurrence.path)
              occurrence.shift_nonnegative
  | .min3 first second third =>
      match findExpandableOccurrence first with
      | some occurrence =>
          some <| ExpandableOccurrence.mk occurrence.target
            (.minFirst first second third occurrence.target occurrence.path)
            occurrence.shift_nonnegative
      | none =>
          match findExpandableOccurrence second with
          | some occurrence =>
              some <| ExpandableOccurrence.mk occurrence.target
                (.minSecond first second third occurrence.target occurrence.path)
                occurrence.shift_nonnegative
          | none =>
              (findExpandableOccurrence third).map fun occurrence =>
                ExpandableOccurrence.mk occurrence.target
                  (.minThird first second third occurrence.target occurrence.path)
                  occurrence.shift_nonnegative
termination_by tree => tree

theorem findExpandableOccurrence_eq_none_iff {k : Nat} (tree : ELTree k) :
    findExpandableOccurrence tree = none <-> tree.TerminalShiftsNegative := by
  classical
  induction tree with
  | terminal label =>
      simp [findExpandableOccurrence, TerminalShiftsNegative, not_le]
  | expanded label body ih =>
      simp [findExpandableOccurrence, TerminalShiftsNegative, ih]
  | add left right ihLeft ihRight =>
      generalize hleft : findExpandableOccurrence left = leftResult
      cases leftResult with
      | none =>
          have hnegativeLeft : left.TerminalShiftsNegative := ihLeft.mp hleft
          simp [findExpandableOccurrence, TerminalShiftsNegative, hleft,
            hnegativeLeft, ihRight]
      | some occurrence =>
          have hnotNegativeLeft : ¬ left.TerminalShiftsNegative := by
            intro hnegative
            have hnone := ihLeft.mpr hnegative
            rw [hleft] at hnone
            contradiction
          simp [findExpandableOccurrence, TerminalShiftsNegative, hleft,
            hnotNegativeLeft]
  | min2 left right ihLeft ihRight =>
      generalize hleft : findExpandableOccurrence left = leftResult
      cases leftResult with
      | none =>
          have hnegativeLeft : left.TerminalShiftsNegative := ihLeft.mp hleft
          simp [findExpandableOccurrence, TerminalShiftsNegative, hleft,
            hnegativeLeft, ihRight]
      | some occurrence =>
          have hnotNegativeLeft : ¬ left.TerminalShiftsNegative := by
            intro hnegative
            have hnone := ihLeft.mpr hnegative
            rw [hleft] at hnone
            contradiction
          simp [findExpandableOccurrence, TerminalShiftsNegative, hleft,
            hnotNegativeLeft]
  | min3 first second third ihFirst ihSecond ihThird =>
      generalize hfirst : findExpandableOccurrence first = firstResult
      cases firstResult with
      | some occurrence =>
          have hnotNegativeFirst : ¬ first.TerminalShiftsNegative := by
            intro hnegative
            have hnone := ihFirst.mpr hnegative
            rw [hfirst] at hnone
            contradiction
          simp [findExpandableOccurrence, TerminalShiftsNegative, hfirst,
            hnotNegativeFirst]
      | none =>
          have hnegativeFirst : first.TerminalShiftsNegative := ihFirst.mp hfirst
          generalize hsecond : findExpandableOccurrence second = secondResult
          cases secondResult with
          | some occurrence =>
              have hnotNegativeSecond : ¬ second.TerminalShiftsNegative := by
                intro hnegative
                have hnone := ihSecond.mpr hnegative
                rw [hsecond] at hnone
                contradiction
              simp [findExpandableOccurrence, TerminalShiftsNegative, hfirst,
                hsecond, hnegativeFirst, hnotNegativeSecond]
          | none =>
              have hnegativeSecond : second.TerminalShiftsNegative :=
                ihSecond.mp hsecond
              simp [findExpandableOccurrence, TerminalShiftsNegative, hfirst,
                hsecond, hnegativeFirst, hnegativeSecond, ihThird]

theorem findExpandableOccurrence_terminal_of_nonnegative {k : Nat}
    (label : ELLabel k) (hshift : 0 <= label.shift.eval) :
    findExpandableOccurrence (.terminal label) =
      some (ExpandableOccurrence.mk label (.here label) hshift) := by
  simp [findExpandableOccurrence, hshift]

theorem findExpandableOccurrence_terminal_of_negative {k : Nat}
    (label : ELLabel k) (hshift : label.shift.eval < 0) :
    findExpandableOccurrence (.terminal label) = none := by
  simp [findExpandableOccurrence, not_le_of_gt hshift]

noncomputable def sourceScheduledStep {p : Nat} (hp : 1 <= p)
    (tree : ELTree (p + 1)) : ELTree (p + 1) :=
  match findExpandableOccurrence tree with
  | none => tree
  | some occurrence => occurrence.sourceStep hp

theorem sourceScheduledStep_eq_self_of_none {p : Nat} (hp : 1 <= p)
    (tree : ELTree (p + 1))
    (hfind : findExpandableOccurrence tree = none) :
    sourceScheduledStep hp tree = tree := by
  simp [sourceScheduledStep, hfind]

theorem sourceScheduledStep_criticalNodeBounds {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (tree : ELTree (p + 1)) {y : Real} (hy : 2 <= y)
    (hbounds : tree.NodeBounds (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    (sourceScheduledStep hp tree).CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y := by
  generalize hfind : findExpandableOccurrence tree = result
  cases result with
  | none =>
      rw [sourceScheduledStep_eq_self_of_none hp tree hfind]
      exact criticalNodeBounds_of_nodeBounds _ _ _ hbounds
  | some occurrence =>
      simpa [sourceScheduledStep, hfind] using
        occurrence.sourceStep_criticalNodeBounds hp roots hy hbounds hargs

theorem sourceScheduledStep_eq_self_of_terminalShiftsNegative
    {p : Nat} (hp : 1 <= p) (tree : ELTree (p + 1))
    (hnegative : tree.TerminalShiftsNegative) :
    sourceScheduledStep hp tree = tree := by
  apply sourceScheduledStep_eq_self_of_none
  exact (findExpandableOccurrence_eq_none_iff tree).2 hnegative

end ELTree

end KL2003
end CollatzClassical
