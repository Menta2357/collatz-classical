import CollatzClassical.KL2003.KL2003GeneralKCriticalTerminalFinder
import CollatzClassical.KL2003.KL2003GeneralKEliminationNormalizer

namespace CollatzClassical
namespace KL2003

open ELTree

/-!
One source-faithful expansion at a globally critical nonnegative terminal.

The central replacement lemma works with `CriticalNodeBounds`, not the
strictly stronger `NodeBounds`: replacing the selected critical occurrence by
a pointwise smaller source split cannot make an unaffected sibling newly
critical.  D1/D3 then use the existing witness retention, while provenance is
kept by `GeneralKProvenancedScheduler.ProvenancedTree.ExpandableOccurrence.sourceStep`.

No termination, scheduler iteration, or general-`k` EL conclusion is claimed
in this module.
-/

namespace ELTree.Context

theorem holeCritical_of_normalExpr_eval_le {k : Nat}
    (context : Context k) (oldTree newTree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hle : newTree.normalExpr.eval Phi y <= oldTree.normalExpr.eval Phi y)
    (hold : context.HoleCritical oldTree Phi y) :
    context.HoleCritical newTree Phi y := by
  induction context with
  | hole => trivial
  | expanded label context ih => exact ih hold
  | addLeft context right ih => exact ih hold
  | addRight left context ih => exact ih hold
  | min2Left context right ih =>
      exact ⟨ih hold.1,
        (context.plug_normalExpr_eval_mono newTree oldTree Phi y hle).trans hold.2⟩
  | min2Right left context ih =>
      exact ⟨ih hold.1,
        (context.plug_normalExpr_eval_mono newTree oldTree Phi y hle).trans hold.2⟩
  | minFirst context second third ih =>
      have hplug := context.plug_normalExpr_eval_mono newTree oldTree Phi y hle
      exact ⟨ih hold.1, hplug.trans hold.2.1, hplug.trans hold.2.2⟩
  | minSecond first context third ih =>
      have hplug := context.plug_normalExpr_eval_mono newTree oldTree Phi y hle
      exact ⟨ih hold.1, hplug.trans hold.2.1, hplug.trans hold.2.2⟩
  | minThird first second context ih =>
      have hplug := context.plug_normalExpr_eval_mono newTree oldTree Phi y hle
      exact ⟨ih hold.1, hplug.trans hold.2.1, hplug.trans hold.2.2⟩

theorem criticalityDominatesBelow_of_frame_replacement {k : Nat}
    (outer oldFrame newFrame : Context k) (tree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (houterOld : outer.HoleCritical (oldFrame.plug tree) Phi y)
    (hlocal : forall inner subtree, inner.plug subtree = tree ->
      (newFrame.comp inner).HoleCritical subtree Phi y ->
        (oldFrame.comp inner).HoleCritical subtree Phi y) :
    (outer.comp oldFrame).CriticalityDominatesBelow
      (outer.comp newFrame) Phi y tree := by
  intro inner subtree hplug hcritical
  have hnewParts :=
    ((outer.comp newFrame).holeCritical_comp_iff inner subtree Phi y).1
      hcritical
  apply ((outer.comp oldFrame).holeCritical_comp_iff
    inner subtree Phi y).2
  refine ⟨hnewParts.1, ?_⟩
  have hlocalNew :=
    (outer.holeCritical_comp_iff newFrame (inner.plug subtree) Phi y).1
      hnewParts.2
  have hnewComposed :
      (newFrame.comp inner).HoleCritical subtree Phi y :=
    (newFrame.holeCritical_comp_iff inner subtree Phi y).2
      ⟨hnewParts.1, hlocalNew.1⟩
  have holdComposed := hlocal inner subtree hplug hnewComposed
  have holdLocal :=
    (oldFrame.holeCritical_comp_iff inner subtree Phi y).1 holdComposed
  apply (outer.holeCritical_comp_iff oldFrame (inner.plug subtree) Phi y).2
  exact ⟨holdLocal.2, by simpa [hplug] using houterOld⟩

theorem plug_criticalNodeBounds_of_le_of_targetCritical {k : Nat}
    (outer context : Context k) (oldTree newTree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hle : newTree.normalExpr.eval Phi y <= oldTree.normalExpr.eval Phi y)
    (holdBounds : outer.CriticalNodeBounds Phi y (context.plug oldTree))
    (htargetCritical : (outer.comp context).HoleCritical oldTree Phi y)
    (hnewBounds : (outer.comp context).CriticalNodeBounds Phi y newTree) :
    outer.CriticalNodeBounds Phi y (context.plug newTree) := by
  induction context generalizing outer with
  | hole => simpa [plug, comp_hole] using hnewBounds
  | expanded label context ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.expanded label context) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      have hbodyLe := context.plug_normalExpr_eval_mono
        newTree oldTree Phi y hle
      refine ⟨?_, ?_⟩
      · intro _
        exact hbodyLe.trans (holdBounds.1 hcriticalParts.2)
      · apply ih (outer := outer.comp (.expanded label .hole))
          holdBounds.2
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds
  | addLeft context right ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.addLeft context right) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      refine ⟨?_, ?_⟩
      · apply ih (outer := outer.comp (.addLeft .hole right)) holdBounds.1
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.addRight (context.plug oldTree) .hole))
          (outer.comp (.addRight (context.plug newTree) .hole))
          Phi y right
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.addRight (context.plug oldTree) .hole)
              (.addRight (context.plug newTree) .hole) right Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree hplug hcritical
          simpa [comp, hplug] using hcritical
        · exact holdBounds.2
  | addRight left context ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.addRight left context) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      refine ⟨?_, ?_⟩
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.addLeft .hole (context.plug oldTree)))
          (outer.comp (.addLeft .hole (context.plug newTree)))
          Phi y left
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.addLeft .hole (context.plug oldTree))
              (.addLeft .hole (context.plug newTree)) left Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree hplug hcritical
          simpa [comp, hplug] using hcritical
        · exact holdBounds.1
      · apply ih (outer := outer.comp (.addRight left .hole)) holdBounds.2
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds
  | min2Left context right ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.min2Left context right) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      have hplugLe := context.plug_normalExpr_eval_mono
        newTree oldTree Phi y hle
      refine ⟨?_, ?_⟩
      · apply ih (outer := outer.comp (.min2Left .hole right)) holdBounds.1
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.min2Right (context.plug oldTree) .hole))
          (outer.comp (.min2Right (context.plug newTree) .hole))
          Phi y right
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.min2Right (context.plug oldTree) .hole)
              (.min2Right (context.plug newTree) .hole) right Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            And.intro hcritical.1 (hcritical.2.trans hplugLe)
        · exact holdBounds.2
  | min2Right left context ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.min2Right left context) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      have hplugLe := context.plug_normalExpr_eval_mono
        newTree oldTree Phi y hle
      refine ⟨?_, ?_⟩
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.min2Left .hole (context.plug oldTree)))
          (outer.comp (.min2Left .hole (context.plug newTree)))
          Phi y left
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.min2Left .hole (context.plug oldTree))
              (.min2Left .hole (context.plug newTree)) left Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            And.intro hcritical.1 (hcritical.2.trans hplugLe)
        · exact holdBounds.1
      · apply ih (outer := outer.comp (.min2Right left .hole)) holdBounds.2
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds
  | minFirst context second third ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.minFirst context second third) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      have hplugLe := context.plug_normalExpr_eval_mono
        newTree oldTree Phi y hle
      refine ⟨?_, ?_, ?_⟩
      · apply ih (outer := outer.comp (.minFirst .hole second third)) holdBounds.1
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.minSecond (context.plug oldTree) .hole third))
          (outer.comp (.minSecond (context.plug newTree) .hole third))
          Phi y second
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.minSecond (context.plug oldTree) .hole third)
              (.minSecond (context.plug newTree) .hole third) second Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            ⟨hcritical.1, hcritical.2.1.trans hplugLe, hcritical.2.2⟩
        · exact holdBounds.2.1
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.minThird (context.plug oldTree) second .hole))
          (outer.comp (.minThird (context.plug newTree) second .hole))
          Phi y third
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.minThird (context.plug oldTree) second .hole)
              (.minThird (context.plug newTree) second .hole) third Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            ⟨hcritical.1, hcritical.2.1.trans hplugLe, hcritical.2.2⟩
        · exact holdBounds.2.2
  | minSecond first context third ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.minSecond first context third) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      have hplugLe := context.plug_normalExpr_eval_mono
        newTree oldTree Phi y hle
      refine ⟨?_, ?_, ?_⟩
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.minFirst .hole (context.plug oldTree) third))
          (outer.comp (.minFirst .hole (context.plug newTree) third))
          Phi y first
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.minFirst .hole (context.plug oldTree) third)
              (.minFirst .hole (context.plug newTree) third) first Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            ⟨hcritical.1, hcritical.2.1.trans hplugLe, hcritical.2.2⟩
        · exact holdBounds.1
      · apply ih (outer := outer.comp (.minSecond first .hole third))
          holdBounds.2.1
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.minThird first (context.plug oldTree) .hole))
          (outer.comp (.minThird first (context.plug newTree) .hole))
          Phi y third
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.minThird first (context.plug oldTree) .hole)
              (.minThird first (context.plug newTree) .hole) third Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            ⟨hcritical.1, hcritical.2.1, hcritical.2.2.trans hplugLe⟩
        · exact holdBounds.2.2
  | minThird first second context ih =>
      have hcriticalParts :=
        (outer.holeCritical_comp_iff
          (.minThird first second context) oldTree Phi y).1
          (by simpa [comp_assoc] using htargetCritical)
      have hplugLe := context.plug_normalExpr_eval_mono
        newTree oldTree Phi y hle
      refine ⟨?_, ?_, ?_⟩
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.minFirst .hole second (context.plug oldTree)))
          (outer.comp (.minFirst .hole second (context.plug newTree)))
          Phi y first
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.minFirst .hole second (context.plug oldTree))
              (.minFirst .hole second (context.plug newTree)) first Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            ⟨hcritical.1, hcritical.2.1, hcritical.2.2.trans hplugLe⟩
        · exact holdBounds.1
      · apply criticalNodeBounds_of_dominates
          (outer.comp (.minSecond first .hole (context.plug oldTree)))
          (outer.comp (.minSecond first .hole (context.plug newTree)))
          Phi y second
        · apply criticalityDominatesBelow_of_frame_replacement
            outer (.minSecond first .hole (context.plug oldTree))
              (.minSecond first .hole (context.plug newTree)) second Phi y
            (by simpa [plug] using hcriticalParts.2)
          intro inner subtree _ hcritical
          simpa [comp, HoleCritical, plug] using
            ⟨hcritical.1, hcritical.2.1, hcritical.2.2.trans hplugLe⟩
        · exact holdBounds.2.1
      · apply ih (outer := outer.comp (.minThird first second .hole))
          holdBounds.2.2
        · simpa [comp_assoc, comp] using htargetCritical
        · simpa [comp_assoc, comp] using hnewBounds

end ELTree.Context

namespace ELTree.TerminalPath

theorem advancedMinPath_holeCritical {k : Nat}
    (root retarded first second third : ELLabel k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    (advancedMinPath root retarded first second third).context.HoleCritical
      (advancedMinPath root retarded first second third).target Phi y := by
  simp [advancedMinPath, Min3Path.context, Min3Path.target,
    Context.HoleCritical]

theorem advancedMinConfiguration_minPath_holeCritical_transport
    {k : Nat} {tree tree' : ELTree k} {first second third : ELLabel k}
    (h : tree = tree')
    (configuration : AdvancedMinConfiguration tree first second third)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hcritical : configuration.minPath.context.HoleCritical
      configuration.minPath.target Phi y) :
    let transported : AdvancedMinConfiguration tree' first second third :=
      h ▸ configuration
    transported.minPath.context.HoleCritical transported.minPath.target Phi y := by
  subst tree'
  exact hcritical

theorem sourceD1AdvancedConfigurationData_minPath_holeCritical
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) :
    let configuration := sourceD1AdvancedConfigurationData hp label hm
    configuration.minPath.context.HoleCritical
      configuration.minPath.target Phi y := by
  unfold sourceD1AdvancedConfigurationData
  apply advancedMinConfiguration_minPath_holeCritical_transport
  exact advancedMinPath_holeCritical _ _ _ _ _ Phi y

theorem sourceD3AdvancedConfigurationData_minPath_holeCritical
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) :
    let configuration := sourceD3AdvancedConfigurationData hp label hm
    configuration.minPath.context.HoleCritical
      configuration.minPath.target Phi y := by
  unfold sourceD3AdvancedConfigurationData
  apply advancedMinConfiguration_minPath_holeCritical_transport
  exact advancedMinPath_holeCritical _ _ _ _ _ Phi y

theorem context_plug_sourceSplitTree {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target) :
    path.context.plug (sourceSplitTree hp target) = path.splitAt hp := by
  induction path <;>
    simp [context, Context.plug, splitAt, *]

theorem sourceSplitTree_eval_le_terminal {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (label : ELLabel (p + 1)) {y : Real}
    (hy : 2 <= y + label.shift.eval) :
    (sourceSplitTree hp label).normalExpr.eval
        (fun mode z => sourcePhiK mode z) y <=
      (.terminal label : ELTree (p + 1)).normalExpr.eval
        (fun mode z => sourcePhiK mode z) y := by
  simpa [sourceSplitTree, ELTree.normalExpr, ELTree.normalExpr_ofExpr,
    ELExpr.eval] using splitTopExpr_eval_le_sourceLeaf hp roots label hy

theorem splitAt_criticalNodeBounds_of_targetCritical
    {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target) {y : Real}
    (hy : 2 <= y + target.shift.eval)
    (hbounds : tree.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hcritical : path.context.HoleCritical (.terminal target)
      (fun mode z => sourcePhiK mode z) y) :
    (path.splitAt hp).CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y := by
  let Phi : TrackedMode (p + 1) -> Real -> Real :=
    fun mode z => sourcePhiK mode z
  have holdBounds : Context.CriticalNodeBounds .hole Phi y
      (path.context.plug (.terminal target)) := by
    simpa [path.context_plug_target, Phi] using hbounds
  have hnewRoot : (sourceSplitTree hp target).CriticalNodeBounds Phi y := by
    simpa [Phi] using sourceSplitTree_criticalNodeBounds hp roots target hy
  have hnewContext :
      (Context.hole.comp path.context).CriticalNodeBounds Phi y
        (sourceSplitTree hp target) := by
    exact Context.criticalNodeBounds_of_root _ _ _ _ hnewRoot
  have hle := sourceSplitTree_eval_le_terminal hp roots target hy
  have result := Context.plug_criticalNodeBounds_of_le_of_targetCritical
    .hole path.context (.terminal target) (sourceSplitTree hp target)
      Phi y (by simpa [Phi] using hle) holdBounds
      (by simpa [Context.comp, Phi] using hcritical) hnewContext
  simpa [context_plug_sourceSplitTree hp path] using result

namespace AdvancedMinConfiguration

theorem target_descendSplitMin3 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (outer : TerminalPath tree target)
    (inner : Min3Path (sourceSplitTree hp target)) :
    (outer.descendSplitMin3 hp inner).target = inner.target := by
  unfold Min3Path.target
  rw [firstChild_descendSplitMin3 hp outer inner,
    secondChild_descendSplitMin3 hp outer inner,
    thirdChild_descendSplitMin3 hp outer inner]

theorem descendSplit_minPath_holeCritical {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target first second third : ELLabel (p + 1)}
    (configuration : AdvancedMinConfiguration
      (sourceSplitTree hp target) first second third)
    (outer : TerminalPath tree target)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real)
    (hsourceCritical : outer.context.HoleCritical
      (sourceSplitTree hp target) Phi y)
    (hlocalCritical : configuration.minPath.context.HoleCritical
      configuration.minPath.target Phi y) :
    (configuration.descendSplit hp outer).minPath.context.HoleCritical
      (configuration.descendSplit hp outer).minPath.target Phi y := by
  have hcombined := (outer.context.holeCritical_comp_iff
    configuration.minPath.context configuration.minPath.target Phi y).2
      ⟨hlocalCritical, by simpa [configuration.minPath.context_plug_target]
        using hsourceCritical⟩
  simpa [descendSplit, context_descendSplitMin3,
    target_descendSplitMin3 hp outer configuration.minPath] using
      hcombined

end AdvancedMinConfiguration

end ELTree.TerminalPath

namespace ELTree.ExpandableOccurrence

theorem d1Configuration_targetCritical {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 2) {y : Real}
    (hy : 2 <= y + occurrence.target.shift.eval)
    (hcritical : occurrence.path.context.HoleCritical
      (.terminal occurrence.target) (fun mode z => sourcePhiK mode z) y) :
    (occurrence.d1Configuration hp hm).minPath.context.HoleCritical
      (occurrence.d1Configuration hp hm).minPath.target
        (fun mode z => sourcePhiK mode z) y := by
  have hle := TerminalPath.sourceSplitTree_eval_le_terminal
    hp roots occurrence.target hy
  have hsourceCritical :=
    occurrence.path.context.holeCritical_of_normalExpr_eval_le
      (.terminal occurrence.target) (sourceSplitTree hp occurrence.target)
      (fun mode z => sourcePhiK mode z) y hle hcritical
  exact TerminalPath.AdvancedMinConfiguration.descendSplit_minPath_holeCritical
    hp (TerminalPath.sourceD1AdvancedConfigurationData hp occurrence.target hm)
      occurrence.path (fun mode z => sourcePhiK mode z) y hsourceCritical
        (TerminalPath.sourceD1AdvancedConfigurationData_minPath_holeCritical
          hp occurrence.target hm _ _)

theorem d3Configuration_targetCritical {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 8) {y : Real}
    (hy : 2 <= y + occurrence.target.shift.eval)
    (hcritical : occurrence.path.context.HoleCritical
      (.terminal occurrence.target) (fun mode z => sourcePhiK mode z) y) :
    (occurrence.d3Configuration hp hm).minPath.context.HoleCritical
      (occurrence.d3Configuration hp hm).minPath.target
        (fun mode z => sourcePhiK mode z) y := by
  have hle := TerminalPath.sourceSplitTree_eval_le_terminal
    hp roots occurrence.target hy
  have hsourceCritical :=
    occurrence.path.context.holeCritical_of_normalExpr_eval_le
      (.terminal occurrence.target) (sourceSplitTree hp occurrence.target)
      (fun mode z => sourcePhiK mode z) y hle hcritical
  exact TerminalPath.AdvancedMinConfiguration.descendSplit_minPath_holeCritical
    hp (TerminalPath.sourceD3AdvancedConfigurationData hp occurrence.target hm)
      occurrence.path (fun mode z => sourcePhiK mode z) y hsourceCritical
        (TerminalPath.sourceD3AdvancedConfigurationData_minPath_holeCritical
          hp occurrence.target hm _ _)

end ELTree.ExpandableOccurrence

namespace ELTree.ExpandableOccurrence

theorem sourceStep_criticalNodeBounds_of_targetCritical
    {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    {y : Real} (hy : 2 <= y)
    (hbounds : tree.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hcritical : occurrence.path.context.HoleCritical
      (.terminal occurrence.target) (fun mode z => sourcePhiK mode z) y) :
    (occurrence.sourceStep hp).CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y := by
  have htargetY : 2 <= y + occurrence.target.shift.eval := by
    linarith [occurrence.shift_nonnegative]
  have hsplitBounds :=
    TerminalPath.splitAt_criticalNodeBounds_of_targetCritical
      hp roots occurrence.path htargetY hbounds hcritical
  have hsplitArgs :=
    occurrence.split_normalExpr_argumentsNonnegative hp hargs hy
  have hpos := sourcePhiK_positive roots
  have hmono := sourcePhiK_monotone roots
  rcases trackedMode_mod_nine_cases occurrence.target.mode with hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hp hm2]
    let configuration := occurrence.d1Configuration hp hm2
    apply configuration
      |>.witnessRetention_reduceAt_criticalNodeBounds_of_targetCritical_of_criticalNodeBounds
        hpos hmono hsplitBounds hsplitArgs
    exact occurrence.d1Configuration_targetCritical
      hp roots hm2 htargetY hcritical
  · rw [occurrence.sourceStep_eq_d2 hp hm5]
    exact hsplitBounds
  · rw [occurrence.sourceStep_eq_d3 hp hm8]
    let configuration := occurrence.d3Configuration hp hm8
    apply configuration
      |>.witnessRetention_reduceAt_criticalNodeBounds_of_targetCritical_of_criticalNodeBounds
        hpos hmono hsplitBounds hsplitArgs
    exact occurrence.d3Configuration_targetCritical
      hp roots hm8 htargetY hcritical

theorem sourceStep_normalExpr_argumentsNonnegative
    {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    {y : Real} (hy : 2 <= y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    (occurrence.sourceStep hp).normalExpr.ArgumentsNonnegative y := by
  have hsplitArgs :=
    occurrence.split_normalExpr_argumentsNonnegative hp hargs hy
  rcases trackedMode_mod_nine_cases occurrence.target.mode with hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hp hm2]
    exact (occurrence.d1Configuration hp hm2).minPath
      |>.reduceAt_normalExpr_argumentsNonnegative
        (occurrence.d1Configuration hp hm2).witnessRetention y hsplitArgs
  · rw [occurrence.sourceStep_eq_d2 hp hm5]
    exact hsplitArgs
  · rw [occurrence.sourceStep_eq_d3 hp hm8]
    exact (occurrence.d3Configuration hp hm8).minPath
      |>.reduceAt_normalExpr_argumentsNonnegative
        (occurrence.d3Configuration hp hm8).witnessRetention y hsplitArgs

theorem sourceStep_normalExpr_eval_le_of_targetCritical
    {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    {y : Real} (hy : 2 <= y)
    (hbounds : tree.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hcritical : occurrence.path.context.HoleCritical
      (.terminal occurrence.target) (fun mode z => sourcePhiK mode z) y) :
    (occurrence.sourceStep hp).normalExpr.eval
        (fun mode z => sourcePhiK mode z) y <=
      tree.normalExpr.eval (fun mode z => sourcePhiK mode z) y := by
  have htargetY : 2 <= y + occurrence.target.shift.eval := by
    linarith [occurrence.shift_nonnegative]
  have hsplitBounds :=
    TerminalPath.splitAt_criticalNodeBounds_of_targetCritical
      hp roots occurrence.path htargetY hbounds hcritical
  have hsplitArgs :=
    occurrence.split_normalExpr_argumentsNonnegative hp hargs hy
  have hlocalLe := TerminalPath.sourceSplitTree_eval_le_terminal
    hp roots occurrence.target htargetY
  have hsplitLe := occurrence.path.context.plug_normalExpr_eval_mono
    (sourceSplitTree hp occurrence.target) (.terminal occurrence.target)
      (fun mode z => sourcePhiK mode z) y hlocalLe
  have hglobalSplitLe :
      (occurrence.split hp).normalExpr.eval
          (fun mode z => sourcePhiK mode z) y <=
        tree.normalExpr.eval (fun mode z => sourcePhiK mode z) y := by
    simpa [TerminalPath.context_plug_sourceSplitTree hp occurrence.path,
      occurrence.path.context_plug_target] using hsplitLe
  have hpos := sourcePhiK_positive roots
  have hmono := sourcePhiK_monotone roots
  rcases trackedMode_mod_nine_cases occurrence.target.mode with hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hp hm2]
    exact (occurrence.d1Configuration hp hm2
      |>.witnessRetention_reduceAt_normalExpr_eval_eq_of_criticalNodeBounds
        hpos hmono hsplitBounds hsplitArgs).le.trans hglobalSplitLe
  · rw [occurrence.sourceStep_eq_d2 hp hm5]
    exact hglobalSplitLe
  · rw [occurrence.sourceStep_eq_d3 hp hm8]
    exact (occurrence.d3Configuration hp hm8
      |>.witnessRetention_reduceAt_normalExpr_eval_eq_of_criticalNodeBounds
        hpos hmono hsplitBounds hsplitArgs).le.trans hglobalSplitLe

theorem d1_retainedBranchesWitnessFree_of_targetCritical
    {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 2)
    {y : Real} (hy : 2 <= y)
    (hbounds : tree.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hcritical : occurrence.path.context.HoleCritical
      (.terminal occurrence.target) (fun mode z => sourcePhiK mode z) y) :
    GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
      (occurrence.d1Configuration hp hm)
      (occurrence.d1Configuration hp hm).witnessRetention := by
  have htargetY : 2 <= y + occurrence.target.shift.eval := by
    linarith [occurrence.shift_nonnegative]
  have hsplitBounds :=
    TerminalPath.splitAt_criticalNodeBounds_of_targetCritical
      hp roots occurrence.path htargetY hbounds hcritical
  have hsplitArgs :=
    occurrence.split_normalExpr_argumentsNonnegative hp hargs hy
  exact GeneralKCriticalTripleWitnessExclusion.witnessRetention_retainedBranchesWitnessFree_of_targetCritical
      (occurrence.d1Configuration hp hm) (sourcePhiK_positive roots)
        (sourcePhiK_monotone roots) hsplitBounds hsplitArgs
          (occurrence.d1Configuration_targetCritical
            hp roots hm htargetY hcritical)

theorem d3_retainedBranchesWitnessFree_of_targetCritical
    {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 8)
    {y : Real} (hy : 2 <= y)
    (hbounds : tree.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y)
    (hcritical : occurrence.path.context.HoleCritical
      (.terminal occurrence.target) (fun mode z => sourcePhiK mode z) y) :
    GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
      (occurrence.d3Configuration hp hm)
      (occurrence.d3Configuration hp hm).witnessRetention := by
  have htargetY : 2 <= y + occurrence.target.shift.eval := by
    linarith [occurrence.shift_nonnegative]
  have hsplitBounds :=
    TerminalPath.splitAt_criticalNodeBounds_of_targetCritical
      hp roots occurrence.path htargetY hbounds hcritical
  have hsplitArgs :=
    occurrence.split_normalExpr_argumentsNonnegative hp hargs hy
  exact GeneralKCriticalTripleWitnessExclusion.witnessRetention_retainedBranchesWitnessFree_of_targetCritical
      (occurrence.d3Configuration hp hm) (sourcePhiK_positive roots)
        (sourcePhiK_monotone roots) hsplitBounds hsplitArgs
          (occurrence.d3Configuration_targetCritical
            hp roots hm htargetY hcritical)

end ELTree.ExpandableOccurrence

namespace GeneralKCriticalSourceStep

open GeneralKCriticalTerminalFinder
open GeneralKProvenancedScheduler
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree

structure CriticalSourceStepFacts {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    (y : Real) (selected : CriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y) where
  forget_eq : selected.occurrence.sourceStep.forget =
    selected.occurrence.forgetOccurrence.sourceStep hp
  criticalNodeBounds : selected.occurrence.sourceStep.forget.CriticalNodeBounds
    (fun mode z => sourcePhiK mode z) y
  argumentsNonnegative :
    selected.occurrence.sourceStep.forget.normalExpr.ArgumentsNonnegative y
  normalExprEvalLe :
    selected.occurrence.sourceStep.forget.normalExpr.eval
        (fun mode z => sourcePhiK mode z) y <=
      tree.forget.normalExpr.eval (fun mode z => sourcePhiK mode z) y
  d1RetainedBranchesWitnessFree : forall
      (hm : selected.occurrence.target.label.mode.1.1 % 9 = 2),
    GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
      (selected.occurrence.forgetOccurrence.d1Configuration hp hm)
      (selected.occurrence.forgetOccurrence.d1Configuration hp hm).witnessRetention
  d3RetainedBranchesWitnessFree : forall
      (hm : selected.occurrence.target.label.mode.1.1 % 9 = 8),
    GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
      (selected.occurrence.forgetOccurrence.d3Configuration hp hm)
      (selected.occurrence.forgetOccurrence.d3Configuration hp hm).witnessRetention

theorem criticalSourceStepFacts {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    {y : Real} (hy : 2 <= y)
    (selected : CriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y)
    (hbounds : tree.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.forget.normalExpr.ArgumentsNonnegative y) :
    CriticalSourceStepFacts y selected := by
  let occurrence := selected.occurrence.forgetOccurrence
  have hcritical : occurrence.path.context.HoleCritical
      (.terminal occurrence.target) (fun mode z => sourcePhiK mode z) y :=
    selected.targetCritical
  have hforget := selected.occurrence.sourceStep_forget
  refine {
    forget_eq := hforget
    criticalNodeBounds := ?_
    argumentsNonnegative := ?_
    normalExprEvalLe := ?_
    d1RetainedBranchesWitnessFree := ?_
    d3RetainedBranchesWitnessFree := ?_ }
  · rw [hforget]
    exact occurrence.sourceStep_criticalNodeBounds_of_targetCritical
      hp roots hy hbounds hargs hcritical
  · rw [hforget]
    exact occurrence.sourceStep_normalExpr_argumentsNonnegative
      hp hy hargs
  · rw [hforget]
    exact occurrence.sourceStep_normalExpr_eval_le_of_targetCritical
      hp roots hy hbounds hargs hcritical
  · intro hm
    exact occurrence.d1_retainedBranchesWitnessFree_of_targetCritical
      hp roots hm hy hbounds hargs hcritical
  · intro hm
    exact occurrence.d3_retainedBranchesWitnessFree_of_targetCritical
      hp roots hm hy hbounds hargs hcritical

end GeneralKCriticalSourceStep

end KL2003
end CollatzClassical
