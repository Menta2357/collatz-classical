import CollatzClassical.KL2003.KL2003GeneralKEliminationContext

namespace CollatzClassical
namespace KL2003

/-!
Source-faithful scheduling for one general-`k` EL expansion step.

The scheduler finds the first terminal whose symbolic shift is nonnegative,
expands it with the source D1/D2/D3 row, and applies the syntactic deletion
rule immediately to the new advanced minimum in the D1 and D3 cases.  The
deletion decision depends only on path labels and shifts, never on `Phi`.

This module does not claim semantic preservation of unconditional deletion,
termination of the combined expansion/deletion process, order independence,
or an EL normal-form theorem.
-/

namespace ELTree

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

noncomputable def d1Configuration {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 2) :
    TerminalPath.AdvancedMinConfiguration (occurrence.split hp)
      (d1AdvancedSplitLabel hp occurrence.target hm 0)
      (d1AdvancedSplitLabel hp occurrence.target hm 1)
      (d1AdvancedSplitLabel hp occurrence.target hm 2) :=
  (Classical.choice
    (TerminalPath.sourceD1AdvancedConfiguration hp occurrence.target hm)).descendSplit
      hp occurrence.path

noncomputable def d3Configuration {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.mode.1.1 % 9 = 8) :
    TerminalPath.AdvancedMinConfiguration (occurrence.split hp)
      (d3AdvancedSplitLabel hp occurrence.target hm 0)
      (d3AdvancedSplitLabel hp occurrence.target hm 1)
      (d3AdvancedSplitLabel hp occurrence.target hm 2) :=
  (Classical.choice
    (TerminalPath.sourceD3AdvancedConfiguration hp occurrence.target hm)).descendSplit
      hp occurrence.path

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

theorem sourceScheduledStep_eq_self_of_terminalShiftsNegative
    {p : Nat} (hp : 1 <= p) (tree : ELTree (p + 1))
    (hnegative : tree.TerminalShiftsNegative) :
    sourceScheduledStep hp tree = tree := by
  apply sourceScheduledStep_eq_self_of_none
  exact (findExpandableOccurrence_eq_none_iff tree).2 hnegative

end ELTree

end KL2003
end CollatzClassical
