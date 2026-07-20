import CollatzClassical.KL2003.KL2003GeneralKUniformCriticalDepth
import Mathlib.Data.Finset.Max

namespace CollatzClassical
namespace KL2003
namespace GeneralKUniformRetardedWindow

/-!
Uniform retarded-shift windows for the source-faithful general-k EL witness.

The critical scheduler already supplies one selected-depth bound for every
root mode and every `y >= 2`. This module propagates `bound + 1` to every
terminal leaf of each finite run, transports exact source-walk provenance
through normalization and critical branch selection, and takes the exact
minimum and maximum of the resulting finite family of negative packed shifts.
No canonical EL normal form or numerical shift estimate is assumed.
-/

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKExtractedBranchNonnegative
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler
open GeneralKProvenancedScheduler.ProvenancedTree
open GeneralKCriticalTerminalFinder
open GeneralKCriticalScheduler
open GeneralKCriticalStopSemantics
open GeneralKUniformCriticalDepth
open ELTree

def AllTerminalWalkLengthLe {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (bound : Nat) :
    ProvenancedTree hp root -> Prop
  | .terminal node => node.walk.length <= bound
  | .expanded _ body => AllTerminalWalkLengthLe bound body
  | .add left right =>
      AllTerminalWalkLengthLe bound left /\ AllTerminalWalkLengthLe bound right
  | .min2 left right =>
      AllTerminalWalkLengthLe bound left /\ AllTerminalWalkLengthLe bound right
  | .min3 first second third =>
      AllTerminalWalkLengthLe bound first /\
        AllTerminalWalkLengthLe bound second /\
          AllTerminalWalkLengthLe bound third

theorem AllTerminalWalkLengthLe.reduce
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {bound : Nat} (retention : Min3Retention)
    {first second third : ProvenancedTree hp root}
    (hfirst : AllTerminalWalkLengthLe bound first)
    (hsecond : AllTerminalWalkLengthLe bound second)
    (hthird : AllTerminalWalkLengthLe bound third) :
    AllTerminalWalkLengthLe bound
      (ProvenancedTree.reduce retention first second third) := by
  cases retention <;> simp [ProvenancedTree.reduce,
    AllTerminalWalkLengthLe, hfirst, hsecond, hthird]

theorem allTerminalWalkLengthLe_terminal_child
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {bound : Nat} (node : ProvenancedLabel hp root)
    (action : SourceAction node.label.mode)
    (hnode : node.walk.length <= bound) :
    AllTerminalWalkLengthLe (bound + 1)
      (.terminal (node.child action)) := by
  change (node.child action).walk.length <= bound + 1
  rw [ProvenancedLabel.child_walk_length]
  omega

theorem allTerminalWalkLengthLe_d1ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {bound : Nat} (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 2) (retention : Min3Retention)
    (hnode : node.walk.length <= bound) :
    AllTerminalWalkLengthLe (bound + 1)
      (d1ReducedSourceSplit node hm retention) := by
  simp only [d1ReducedSourceSplit, AllTerminalWalkLengthLe]
  constructor
  · exact allTerminalWalkLengthLe_terminal_child node _ hnode
  · apply AllTerminalWalkLengthLe.reduce retention <;>
      exact allTerminalWalkLengthLe_terminal_child node _ hnode

theorem allTerminalWalkLengthLe_d3ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {bound : Nat} (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 8) (retention : Min3Retention)
    (hnode : node.walk.length <= bound) :
    AllTerminalWalkLengthLe (bound + 1)
      (d3ReducedSourceSplit node hm retention) := by
  simp only [d3ReducedSourceSplit, AllTerminalWalkLengthLe]
  constructor
  · exact allTerminalWalkLengthLe_terminal_child node _ hnode
  · apply AllTerminalWalkLengthLe.reduce retention <;>
      exact allTerminalWalkLengthLe_terminal_child node _ hnode

theorem allTerminalWalkLengthLe_sourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {bound : Nat} (node : ProvenancedLabel hp root)
    (hnode : node.walk.length <= bound) :
    AllTerminalWalkLengthLe (bound + 1)
      (ProvenancedTree.sourceSplit node) := by
  classical
  unfold ProvenancedTree.sourceSplit
  split
  next hm2 =>
    simp only [AllTerminalWalkLengthLe]
    constructor
    · exact allTerminalWalkLengthLe_terminal_child node _ hnode
    · refine ⟨?_, ?_, ?_⟩ <;>
        exact allTerminalWalkLengthLe_terminal_child node _ hnode
  next hnot2 =>
    split
    next hm5 =>
      simp only [AllTerminalWalkLengthLe]
      exact allTerminalWalkLengthLe_terminal_child node _ hnode
    next hnot5 =>
      simp only [AllTerminalWalkLengthLe]
      constructor
      · exact allTerminalWalkLengthLe_terminal_child node _ hnode
      · refine ⟨?_, ?_, ?_⟩ <;>
          exact allTerminalWalkLengthLe_terminal_child node _ hnode

theorem AllTerminalWalkLengthLe.provenancedReplaceAt
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {bound : Nat} {tree replacement : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : AllTerminalWalkLengthLe bound tree)
    (hreplacement : AllTerminalWalkLengthLe bound replacement) :
    AllTerminalWalkLengthLe bound (provenancedReplaceAt path replacement) := by
  induction path with
  | here node => exact hreplacement
  | expanded node body target path ih =>
      exact ih htree
  | addLeft left right target path ih =>
      exact ⟨ih htree.1, htree.2⟩
  | addRight left right target path ih =>
      exact ⟨htree.1, ih htree.2⟩
  | min2Left left right target path ih =>
      exact ⟨ih htree.1, htree.2⟩
  | min2Right left right target path ih =>
      exact ⟨htree.1, ih htree.2⟩
  | minFirst first second third target path ih =>
      exact ⟨ih htree.1, htree.2⟩
  | minSecond first second third target path ih =>
      exact ⟨htree.1, ih htree.2.1, htree.2.2⟩
  | minThird first second third target path ih =>
      exact ⟨htree.1, htree.2.1, ih htree.2.2⟩

theorem sourceStep_allTerminalWalkLengthLe
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {bound : Nat} {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htree : AllTerminalWalkLengthLe (bound + 1) tree)
    (htarget : occurrence.target.walk.length <= bound) :
    AllTerminalWalkLengthLe (bound + 1) occurrence.sourceStep := by
  rcases trackedMode_mod_nine_cases occurrence.target.label.mode with
      hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hm2]
    apply htree.provenancedReplaceAt occurrence.path
    exact allTerminalWalkLengthLe_d1ReducedSourceSplit
      occurrence.target hm2 _ htarget
  · rw [occurrence.sourceStep_eq_d2 hm5]
    rw [← GeneralKProvenancedSchedulerDepth.provenancedReplaceAt_sourceSplit
      occurrence.path]
    apply htree.provenancedReplaceAt occurrence.path
    exact allTerminalWalkLengthLe_sourceSplit occurrence.target htarget
  · rw [occurrence.sourceStep_eq_d3 hm8]
    apply htree.provenancedReplaceAt occurrence.path
    exact allTerminalWalkLengthLe_d3ReducedSourceSplit
      occurrence.target hm8 _ htarget

theorem criticalScheduledStep_allTerminalWalkLengthLe
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} {bound : Nat} {y : Real}
    (hy : 2 <= y) (hbound : CriticalSelectedDepthBound hp bound)
    (time : Nat)
    (htree : AllTerminalWalkLengthLe (bound + 1)
      (run (ProvenancedTree.initial hp (zeroRootLabel mode)) y time)) :
    AllTerminalWalkLengthLe (bound + 1)
      (criticalScheduledStep
        (run (ProvenancedTree.initial hp (zeroRootLabel mode)) y time) y) := by
  generalize hfind : findCriticalExpandableOccurrence
      (run (ProvenancedTree.initial hp (zeroRootLabel mode)) y time)
      (fun tracked z => sourcePhiK tracked z) y = result
  cases result with
  | none =>
      rw [criticalScheduledStep_eq_self_of_find_eq_none _ y hfind]
      exact htree
  | some selected =>
      rw [criticalScheduledStep_eq_sourceStep_of_find_eq_some _ y selected hfind]
      exact sourceStep_allTerminalWalkLengthLe selected.occurrence htree
        (hbound mode y hy time selected hfind)

theorem run_allTerminalWalkLengthLe
    {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} {bound : Nat} {y : Real}
    (hy : 2 <= y) (hbound : CriticalSelectedDepthBound hp bound) :
    forall time : Nat,
      AllTerminalWalkLengthLe (bound + 1)
        (run (ProvenancedTree.initial hp (zeroRootLabel mode)) y time) := by
  intro time
  induction time with
  | zero =>
      change (ProvenancedLabel.root hp (zeroRootLabel mode)).walk.length <= bound + 1
      simp [ProvenancedLabel.root, SourceWalk.length]
  | succ time ih =>
      rw [GeneralKCriticalScheduler.run_succ]
      exact criticalScheduledStep_allTerminalWalkLengthLe hy hbound time ih

def AllLeaves {k : Nat} (P : ELLabel k -> Prop) : ELExpr k -> Prop
  | .leaf label => P label
  | .add left right => AllLeaves P left /\ AllLeaves P right
  | .min3 first second third =>
      AllLeaves P first /\ AllLeaves P second /\ AllLeaves P third

def LabelHasBoundedProvenance {p : Nat} {hp : 1 <= p}
    (root : ELLabel (p + 1)) (bound : Nat) (label : ELLabel (p + 1)) : Prop :=
  exists walk : SourceWalk hp root.mode label.mode,
    walk.length <= bound /\ label.shift = root.shift + walk.weight

theorem normalExpr_allLeaves_boundedProvenance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)} {bound : Nat}
    {tree : ProvenancedTree hp root}
    (htree : AllTerminalWalkLengthLe bound tree) :
    AllLeaves (LabelHasBoundedProvenance (hp := hp) root bound)
      tree.forget.normalExpr := by
  induction tree with
  | terminal node =>
      exact ⟨node.walk, htree, node.shift_eq⟩
  | expanded node body ih =>
      exact ih htree
  | add left right ihLeft ihRight =>
      exact ⟨ihLeft htree.1, ihRight htree.2⟩
  | min2 left right ihLeft ihRight =>
      exact ⟨ihLeft htree.1, ihRight htree.2, ihRight htree.2⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      exact ⟨ihFirst htree.1, ihSecond htree.2.1, ihThird htree.2.2⟩

theorem selectedExpr_allLeaves
    {k : Nat} {expr : ELExpr k} {P : ELLabel k -> Prop}
    (assignment : ELExpr.CriticalAssignment expr)
    (hexpr : AllLeaves P expr) : AllLeaves P assignment.selectedExpr := by
  induction assignment with
  | leaf label => exact hexpr
  | add left right leftChoice rightChoice ihLeft ihRight =>
      exact ⟨ihLeft hexpr.1, ihRight hexpr.2⟩
  | minFirst first second third choice ih => exact ih hexpr.1
  | minSecond first second third choice ih => exact ih hexpr.2.1
  | minThird first second third choice ih => exact ih hexpr.2.2

abbrev BoundedPackedCode (p bound : Nat) :=
  {code : List (PackedSourceAction p) // code.length <= bound}

instance finite_boundedPackedCode (p bound : Nat) :
    Finite (BoundedPackedCode p bound) :=
  (List.finite_length_le (PackedSourceAction p) bound).to_subtype

noncomputable def boundedNegativeBackwardShifts (p bound : Nat) : Finset Real := by
  classical
  letI : Fintype (BoundedPackedCode p bound) := Fintype.ofFinite _
  exact (Finset.univ.filter fun code : BoundedPackedCode p bound =>
      packedWeightEval code.1 < 0).image
    (fun code => -packedWeightEval code.1)

def modeTwo {p : Nat} (hp : 1 <= p) : TrackedMode (p + 1) := by
  refine ⟨⟨2, ?_⟩, by norm_num⟩
  rw [generalKModulus]
  calc
    2 < 3 ^ 1 := by norm_num
    _ <= 3 ^ (p + 1) := by
      exact Nat.pow_le_pow_right (by norm_num) (by omega)

theorem two_mem_boundedNegativeBackwardShifts_succ
    {p : Nat} (hp : 1 <= p) (bound : Nat) :
    (2 : Real) ∈ boundedNegativeBackwardShifts p (bound + 1) := by
  classical
  letI : Fintype (BoundedPackedCode p (bound + 1)) := Fintype.ofFinite _
  let mode := modeTwo hp
  let action : PackedSourceAction p := ⟨mode, retardedAction mode⟩
  let code : BoundedPackedCode p (bound + 1) := ⟨[action], by simp⟩
  apply Finset.mem_image.mpr
  refine ⟨code, ?_, ?_⟩
  · apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _, ?_⟩
    simp [code, action, packedWeightEval, SymbolicShift.retardedTwo,
      SymbolicShift.eval]
  · simp [code, action, packedWeightEval, SymbolicShift.retardedTwo,
      SymbolicShift.eval]

theorem boundedNegativeBackwardShifts_pos
    {p bound : Nat} {x : Real}
    (hx : x ∈ boundedNegativeBackwardShifts p bound) : 0 < x := by
  classical
  letI : Fintype (BoundedPackedCode p bound) := Fintype.ofFinite _
  rcases Finset.mem_image.mp hx with ⟨code, hcode, rfl⟩
  exact neg_pos.mpr (Finset.mem_filter.mp hcode).2

theorem sourceWalk_backwardShift_mem
    {p : Nat} {hp : 1 <= p} {source target : TrackedMode (p + 1)}
    {bound : Nat} (walk : SourceWalk hp source target)
    (hlength : walk.length <= bound) (hnegative : walk.weight.eval < 0) :
    -walk.weight.eval ∈ boundedNegativeBackwardShifts p bound := by
  classical
  letI : Fintype (BoundedPackedCode p bound) := Fintype.ofFinite _
  let code : BoundedPackedCode p bound :=
    ⟨sourceWalkActionList walk, by
      simpa only [sourceWalkActionList_length] using hlength⟩
  apply Finset.mem_image.mpr
  refine ⟨code, ?_, ?_⟩
  · exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, by
      simpa [code, packedWeightEval_sourceWalkActionList] using hnegative⟩
  · simp [code, packedWeightEval_sourceWalkActionList]

theorem boundedNegativeBackwardShifts_succ_nonempty
    {p : Nat} (hp : 1 <= p) (bound : Nat) :
    (boundedNegativeBackwardShifts p (bound + 1)).Nonempty :=
  ⟨2, two_mem_boundedNegativeBackwardShifts_succ hp bound⟩

noncomputable def uniformMu {p : Nat} (hp : 1 <= p) (bound : Nat) : Real :=
  (boundedNegativeBackwardShifts p (bound + 1)).min'
    (boundedNegativeBackwardShifts_succ_nonempty hp bound)

noncomputable def uniformNu {p : Nat} (hp : 1 <= p) (bound : Nat) : Real :=
  (boundedNegativeBackwardShifts p (bound + 1)).max'
    (boundedNegativeBackwardShifts_succ_nonempty hp bound)

theorem uniformMu_pos {p : Nat} (hp : 1 <= p) (bound : Nat) :
    0 < uniformMu hp bound := by
  apply boundedNegativeBackwardShifts_pos
  exact Finset.min'_mem _ _

theorem uniformNu_pos {p : Nat} (hp : 1 <= p) (bound : Nat) :
    0 < uniformNu hp bound := by
  apply boundedNegativeBackwardShifts_pos
  exact Finset.max'_mem _ _

theorem uniformMu_le_uniformNu {p : Nat} (hp : 1 <= p) (bound : Nat) :
    uniformMu hp bound <= uniformNu hp bound := by
  simpa only [uniformMu, uniformNu] using
    (boundedNegativeBackwardShifts p (bound + 1)).min'_le_max'
      (boundedNegativeBackwardShifts_succ_nonempty hp bound)

theorem uniformMu_le_backwardShift_of_mem
    {p : Nat} (hp : 1 <= p) (bound : Nat) {x : Real}
    (hx : x ∈ boundedNegativeBackwardShifts p (bound + 1)) :
    uniformMu hp bound <= x := by
  simpa only [uniformMu] using
    (boundedNegativeBackwardShifts p (bound + 1)).min'_le x hx

theorem backwardShift_le_uniformNu_of_mem
    {p : Nat} (hp : 1 <= p) (bound : Nat) {x : Real}
    (hx : x ∈ boundedNegativeBackwardShifts p (bound + 1)) :
    x <= uniformNu hp bound := by
  simpa only [uniformNu] using
    (boundedNegativeBackwardShifts p (bound + 1)).le_max' x hx

theorem boundedProvenance_negative_shift_within
    {p : Nat} {hp : 1 <= p} {mode : TrackedMode (p + 1)}
    {bound : Nat} {label : ELLabel (p + 1)}
    (hprovenance : LabelHasBoundedProvenance (hp := hp)
      (zeroRootLabel mode) (bound + 1) label)
    (hnegative : label.shift.eval < 0) :
    -uniformNu hp bound <= label.shift.eval /\
      label.shift.eval <= -uniformMu hp bound := by
  rcases hprovenance with ⟨walk, hlength, hshift⟩
  have heval : label.shift.eval = walk.weight.eval := by
    rw [hshift, SymbolicShift.eval_add]
    simp [zeroRootLabel, SymbolicShift.eval_zero]
  have hwalkNegative : walk.weight.eval < 0 := by
    simpa only [heval] using hnegative
  have hmem : -label.shift.eval ∈
      boundedNegativeBackwardShifts p (bound + 1) := by
    rw [heval]
    exact sourceWalk_backwardShift_mem walk hlength hwalkNegative
  have hlower := uniformMu_le_backwardShift_of_mem hp bound hmem
  have hupper := backwardShift_le_uniformNu_of_mem hp bound hmem
  constructor <;> linarith

theorem allLeaves_shiftBounds_of_boundedProvenance_negative
    {p : Nat} {hp : 1 <= p} {mode : TrackedMode (p + 1)}
    {bound : Nat} {expr : ELExpr (p + 1)}
    (hprovenance : AllLeaves
      (LabelHasBoundedProvenance (hp := hp)
        (zeroRootLabel mode) (bound + 1)) expr)
    (hnegative : AllLeafShiftsNegative expr) :
    AllLeaves (fun label =>
      -uniformNu hp bound <= label.shift.eval /\
        label.shift.eval <= -uniformMu hp bound) expr := by
  induction expr with
  | leaf label =>
      exact boundedProvenance_negative_shift_within hprovenance hnegative
  | add left right ihLeft ihRight =>
      exact ⟨ihLeft hprovenance.1 hnegative.1,
        ihRight hprovenance.2 hnegative.2⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      exact ⟨ihFirst hprovenance.1 hnegative.1,
        ihSecond hprovenance.2.1 hnegative.2.1,
        ihThird hprovenance.2.2 hnegative.2.2⟩

theorem toRetardedExpr_shiftsWithin_of_allLeaves
    {k : Nat} {mu nu : Real} {expr : ELExpr k}
    (hshifts : AllLeaves (fun label =>
      -nu <= label.shift.eval /\ label.shift.eval <= -mu) expr) :
    expr.toRetardedExpr.ShiftsWithin mu nu := by
  induction expr with
  | leaf label => exact hshifts
  | add left right ihLeft ihRight =>
      exact ⟨ihLeft hshifts.1, ihRight hshifts.2⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      exact ⟨ihFirst hshifts.1,
        ihSecond hshifts.2.1, ihThird hshifts.2.2⟩

theorem sourceELRetardedWitness_selectedExpr_shiftsWithin
    {p : Nat} {hp : 1 <= p} {mode : TrackedMode (p + 1)}
    {bound : Nat} {y : Real}
    (hbound : CriticalSelectedDepthBound hp bound) (hy : 2 <= y)
    (witness : SourceELRetardedWitness hp (zeroRootLabel mode) y) :
    witness.assignment.selectedExpr.toRetardedExpr.ShiftsWithin
      (uniformMu hp bound) (uniformNu hp bound) := by
  have htree := run_allTerminalWalkLengthLe
    (mode := mode) hy hbound witness.steps
  have hnormal := normalExpr_allLeaves_boundedProvenance htree
  have hselected := selectedExpr_allLeaves witness.assignment hnormal
  exact toRetardedExpr_shiftsWithin_of_allLeaves
    (allLeaves_shiftBounds_of_boundedProvenance_negative
      hselected witness.retarded)

theorem exists_uniform_sourceELRetardedWindow
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    exists (mu nu : Real),
      0 < mu /\ mu <= nu /\
        forall (mode : TrackedMode (p + 1)) (y : Real), 2 <= y ->
          forall witness : SourceELRetardedWitness hp (zeroRootLabel mode) y,
            witness.assignment.selectedExpr.toRetardedExpr.ShiftsWithin mu nu := by
  obtain ⟨bound, hbound⟩ := exists_uniform_criticalSelectedDepthBound roots
  refine ⟨uniformMu hp bound, uniformNu hp bound,
    uniformMu_pos hp bound, uniformMu_le_uniformNu hp bound, ?_⟩
  intro mode y hy witness
  exact sourceELRetardedWitness_selectedExpr_shiftsWithin hbound hy witness

end GeneralKUniformRetardedWindow
end KL2003
end CollatzClassical
