import CollatzClassical.KL2003.KL2003GeneralKCriticalTripleWitnessExclusion
import CollatzClassical.KL2003.KL2003GeneralKProvenancedScheduler

namespace CollatzClassical
namespace KL2003
namespace GeneralKCriticalTerminalFinder

open GeneralKSourceGenealogy
open GeneralKProvenancedScheduler

open GeneralKSourceGenealogy.ProvenancedTree

/-!
Noncomputable selection of a nonnegative terminal occurrence that lies on a
global critical path at fixed `Phi,y`.

The source proof permits arbitrary splitting order.  A choice-based finder is
therefore sufficient at this layer and avoids conflating semantic criticality
with the existing deterministic left-to-right syntactic finder.
-/

structure CriticalExpandableOccurrence {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (tree : ProvenancedTree hp root)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) where
  occurrence : GeneralKProvenancedScheduler.ProvenancedTree.ExpandableOccurrence tree
  targetCritical :
    occurrence.path.forgetPath.context.HoleCritical
      (.terminal occurrence.target.label) Phi y

def CriticalTerminalShiftsNegative {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (tree : ProvenancedTree hp root)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) : Prop :=
  forall (target : ProvenancedLabel hp root)
    (path : ProvenancedTree.TerminalPath tree target),
      path.forgetPath.context.HoleCritical (.terminal target.label) Phi y ->
        target.label.shift.eval < 0

noncomputable def findCriticalExpandableOccurrence
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) :
    Option (CriticalExpandableOccurrence tree Phi y) := by
  classical
  exact if h : Nonempty (CriticalExpandableOccurrence tree Phi y) then
    some (Classical.choice h)
  else
    none

theorem findCriticalExpandableOccurrence_eq_none_iff
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) :
    findCriticalExpandableOccurrence tree Phi y = none <->
      CriticalTerminalShiftsNegative tree Phi y := by
  classical
  by_cases hnonempty : Nonempty (CriticalExpandableOccurrence tree Phi y)
  · let selected := Classical.choice hnonempty
    apply iff_of_false
    · simp [findCriticalExpandableOccurrence, hnonempty]
    · intro hnegative
      have hlt := hnegative selected.occurrence.target
        selected.occurrence.path selected.targetCritical
      exact (not_lt_of_ge selected.occurrence.shift_nonnegative) hlt
  · have hfind : findCriticalExpandableOccurrence tree Phi y = none := by
      simp [findCriticalExpandableOccurrence, hnonempty]
    constructor
    · intro _ target path hcritical
      by_contra hnotNegative
      have hnonnegative : 0 <= target.label.shift.eval :=
        le_of_not_gt hnotNegative
      apply hnonempty
      exact ⟨{
        occurrence := {
          target := target
          path := path
          shift_nonnegative := hnonnegative }
        targetCritical := hcritical }⟩
    · intro _
      exact hfind

theorem criticalExpandableOccurrence_fields
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    {Phi : TrackedMode (p + 1) -> Real -> Real} {y : Real}
    (selected : CriticalExpandableOccurrence tree Phi y) :
    0 <= selected.occurrence.target.label.shift.eval /\
      selected.occurrence.path.forgetPath.context.HoleCritical
        (.terminal selected.occurrence.target.label) Phi y := by
  exact ⟨selected.occurrence.shift_nonnegative, selected.targetCritical⟩

theorem findCriticalExpandableOccurrence_ne_none_of_occurrence
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    {Phi : TrackedMode (p + 1) -> Real -> Real} {y : Real}
    (occurrence : CriticalExpandableOccurrence tree Phi y) :
    findCriticalExpandableOccurrence tree Phi y ≠ none := by
  classical
  simp [findCriticalExpandableOccurrence, Nonempty.intro occurrence]

end GeneralKCriticalTerminalFinder
end KL2003
end CollatzClassical
