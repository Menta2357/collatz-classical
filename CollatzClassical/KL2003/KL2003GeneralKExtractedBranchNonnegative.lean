import CollatzClassical.KL2003.KL2003GeneralKInfiniteBranchExtraction

namespace CollatzClassical
namespace KL2003

/-!
Nonnegative accumulated shifts on the infinite branch extracted from the
provenanced source scheduler.

The key operational invariant is stronger than terminal eligibility: every
strict prefix of every live provenance has nonnegative absolute shift.  A new
child inherits the old strict prefixes, while its final new strict prefix is
the terminal just selected by the scheduler.
-/

namespace GeneralKExtractedBranchNonnegative

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler
open GeneralKProvenancedScheduler.ProvenancedTree
open GeneralKInfiniteBranchDescent
open GeneralKInfiniteBranchExtraction

/-- Evaluated sum of the symbolic weights serialized in a packed action list. -/
noncomputable def packedWeightEval {p : Nat}
    (code : List (PackedSourceAction p)) : Real :=
  (code.map fun action => action.2.weight.eval).sum

theorem packedWeightEval_sourceWalkActionList {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    packedWeightEval (sourceWalkActionList walk) = walk.weight.eval := by
  induction walk with
  | nil => simp [packedWeightEval, SymbolicShift.eval_zero]
  | cons action tail ih =>
      rw [SourceWalk.weight_eval]
      change action.weight.eval +
          (List.map (fun action => action.2.weight.eval)
            (sourceWalkActionList tail)).sum =
        action.weight.eval + tail.weight.eval
      change (List.map (fun action => action.2.weight.eval)
          (sourceWalkActionList tail)).sum = tail.weight.eval at ih
      rw [ih]

theorem sourceWalkActionList_append {p : Nat} {hp : 1 <= p}
    {source middle target : TrackedMode (p + 1)}
    (first : SourceWalk hp source middle)
    (second : SourceWalk hp middle target) :
    sourceWalkActionList (first.append second) =
      sourceWalkActionList first ++ sourceWalkActionList second := by
  induction first with
  | nil => rfl
  | cons action tail ih => simp [ih]

/-- Every strict genealogy prefix of this node has nonnegative absolute
shift relative to the fixed root label. -/
def StrictPrefixesNonnegative {p : Nat} {hp : 1 <= p}
    (root : ELLabel (p + 1)) (node : ProvenancedLabel hp root) : Prop :=
  forall n : Nat, n < node.walk.length ->
    0 <= root.shift.eval +
      packedWeightEval ((sourceWalkActionList node.walk).take n)

theorem StrictPrefixesNonnegative.root {p : Nat} (hp : 1 <= p)
    (root : ELLabel (p + 1)) :
    StrictPrefixesNonnegative root (ProvenancedLabel.root hp root) := by
  intro n hn
  change n < 0 at hn
  omega

theorem provenancedLabel_shift_eval_eq {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root) :
    node.label.shift.eval = root.shift.eval + node.walk.weight.eval := by
  rw [node.shift_eq, SymbolicShift.eval_add]

theorem StrictPrefixesNonnegative.child {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {node : ProvenancedLabel hp root}
    (hprefix : StrictPrefixesNonnegative root node)
    (hnode : 0 <= node.label.shift.eval)
    (action : SourceAction node.label.mode) :
    StrictPrefixesNonnegative root (node.child action) := by
  intro n hn
  have hnle : n <= node.walk.length := by
    rw [ProvenancedLabel.child_walk_length] at hn
    omega
  have hcode : sourceWalkActionList (node.child action).walk =
      sourceWalkActionList node.walk ++
        [⟨node.label.mode, action⟩] := by
    rw [ProvenancedLabel.child]
    rw [sourceWalkActionList_append]
    rfl
  rw [hcode, List.take_append_of_le_length]
  · by_cases hstrict : n < node.walk.length
    · exact hprefix n hstrict
    · have hnEq : n = node.walk.length := by omega
      subst n
      have htake :
          (sourceWalkActionList node.walk).take node.walk.length =
            sourceWalkActionList node.walk := by
        rw [← sourceWalkActionList_length node.walk]
        exact List.take_length
      rw [htake, packedWeightEval_sourceWalkActionList]
      simpa only [provenancedLabel_shift_eval_eq] using hnode
  · simpa only [sourceWalkActionList_length] using hnle

/-- Tree-wide form of the strict-prefix invariant. -/
def AllStrictPrefixesNonnegative {p : Nat} {hp : 1 <= p}
    (root : ELLabel (p + 1)) : ProvenancedTree hp root -> Prop
  | .terminal node => StrictPrefixesNonnegative root node
  | .expanded node body =>
      StrictPrefixesNonnegative root node /\
        AllStrictPrefixesNonnegative root body
  | .add left right | .min2 left right =>
      AllStrictPrefixesNonnegative root left /\
        AllStrictPrefixesNonnegative root right
  | .min3 first second third =>
      AllStrictPrefixesNonnegative root first /\
        AllStrictPrefixesNonnegative root second /\
          AllStrictPrefixesNonnegative root third

theorem AllStrictPrefixesNonnegative.initial {p : Nat} (hp : 1 <= p)
    (root : ELLabel (p + 1)) :
    AllStrictPrefixesNonnegative root (ProvenancedTree.initial hp root) :=
  StrictPrefixesNonnegative.root hp root

theorem AllStrictPrefixesNonnegative.reduce {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {first second third : ProvenancedTree hp root}
    (hfirst : AllStrictPrefixesNonnegative root first)
    (hsecond : AllStrictPrefixesNonnegative root second)
    (hthird : AllStrictPrefixesNonnegative root third)
    (retention : ELTree.Min3Retention) :
    AllStrictPrefixesNonnegative root
      (ProvenancedTree.reduce retention first second third) := by
  cases retention <;> simp [ProvenancedTree.reduce,
    AllStrictPrefixesNonnegative, *]

theorem AllStrictPrefixesNonnegative.sourceSplit {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {node : ProvenancedLabel hp root}
    (hprefix : StrictPrefixesNonnegative root node)
    (hnode : 0 <= node.label.shift.eval) :
    AllStrictPrefixesNonnegative root (ProvenancedTree.sourceSplit node) := by
  classical
  by_cases hm2 : node.label.mode.1.1 % 9 = 2
  · simp [ProvenancedTree.sourceSplit, hm2, AllStrictPrefixesNonnegative,
      hprefix, hprefix.child hnode]
  by_cases hm5 : node.label.mode.1.1 % 9 = 5
  · simp [ProvenancedTree.sourceSplit, hm2, hm5,
      AllStrictPrefixesNonnegative, hprefix, hprefix.child hnode]
  · simp [ProvenancedTree.sourceSplit, hm2, hm5,
      AllStrictPrefixesNonnegative, hprefix, hprefix.child hnode]

theorem AllStrictPrefixesNonnegative.d1ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {node : ProvenancedLabel hp root}
    (hprefix : StrictPrefixesNonnegative root node)
    (hnode : 0 <= node.label.shift.eval)
    (hm : node.label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention) :
    AllStrictPrefixesNonnegative root
      (ProvenancedTree.d1ReducedSourceSplit node hm retention) := by
  apply And.intro hprefix
  apply And.intro (hprefix.child hnode _)
  apply AllStrictPrefixesNonnegative.reduce <;>
    exact hprefix.child hnode _

theorem AllStrictPrefixesNonnegative.d3ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {node : ProvenancedLabel hp root}
    (hprefix : StrictPrefixesNonnegative root node)
    (hnode : 0 <= node.label.shift.eval)
    (hm : node.label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention) :
    AllStrictPrefixesNonnegative root
      (ProvenancedTree.d3ReducedSourceSplit node hm retention) := by
  apply And.intro hprefix
  apply And.intro (hprefix.child hnode _)
  apply AllStrictPrefixesNonnegative.reduce <;>
    exact hprefix.child hnode _

theorem target_strictPrefixesNonnegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : AllStrictPrefixesNonnegative root tree) :
    StrictPrefixesNonnegative root target := by
  induction path with
  | here node => exact htree
  | expanded node body target path ih => exact ih htree.2
  | addLeft left right target path ih => exact ih htree.1
  | addRight left right target path ih => exact ih htree.2
  | min2Left left right target path ih => exact ih htree.1
  | min2Right left right target path ih => exact ih htree.2
  | minFirst first second third target path ih => exact ih htree.1
  | minSecond first second third target path ih => exact ih htree.2.1
  | minThird first second third target path ih => exact ih htree.2.2

theorem AllStrictPrefixesNonnegative.provenancedReplaceAt
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree replacement : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : AllStrictPrefixesNonnegative root tree)
    (hreplacement : AllStrictPrefixesNonnegative root replacement) :
    AllStrictPrefixesNonnegative root
      (ProvenancedTree.provenancedReplaceAt path replacement) := by
  induction path with
  | here node => exact hreplacement
  | expanded node body target path ih => exact ⟨htree.1, ih htree.2⟩
  | addLeft left right target path ih => exact ⟨ih htree.1, htree.2⟩
  | addRight left right target path ih => exact ⟨htree.1, ih htree.2⟩
  | min2Left left right target path ih => exact ⟨ih htree.1, htree.2⟩
  | min2Right left right target path ih => exact ⟨htree.1, ih htree.2⟩
  | minFirst first second third target path ih =>
      exact ⟨ih htree.1, htree.2⟩
  | minSecond first second third target path ih =>
      exact ⟨htree.1, ih htree.2.1, htree.2.2⟩
  | minThird first second third target path ih =>
      exact ⟨htree.1, htree.2.1, ih htree.2.2⟩

theorem AllStrictPrefixesNonnegative.splitAt
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : AllStrictPrefixesNonnegative root tree)
    (htarget : 0 <= target.label.shift.eval) :
    AllStrictPrefixesNonnegative root path.splitAt := by
  induction path with
  | here node =>
      exact AllStrictPrefixesNonnegative.sourceSplit htree htarget
  | expanded node body target path ih =>
      exact ⟨htree.1, ih htree.2 htarget⟩
  | addLeft left right target path ih =>
      exact ⟨ih htree.1 htarget, htree.2⟩
  | addRight left right target path ih =>
      exact ⟨htree.1, ih htree.2 htarget⟩
  | min2Left left right target path ih =>
      exact ⟨ih htree.1 htarget, htree.2⟩
  | min2Right left right target path ih =>
      exact ⟨htree.1, ih htree.2 htarget⟩
  | minFirst first second third target path ih =>
      exact ⟨ih htree.1 htarget, htree.2⟩
  | minSecond first second third target path ih =>
      exact ⟨htree.1, ih htree.2.1 htarget, htree.2.2⟩
  | minThird first second third target path ih =>
      exact ⟨htree.1, htree.2.1, ih htree.2.2 htarget⟩

theorem AllStrictPrefixesNonnegative.sourceStep
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htree : AllStrictPrefixesNonnegative root tree) :
    AllStrictPrefixesNonnegative root occurrence.sourceStep := by
  classical
  have htarget := target_strictPrefixesNonnegative occurrence.path htree
  rcases ELTree.trackedMode_mod_nine_cases occurrence.target.label.mode with
      hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hm2]
    apply htree.provenancedReplaceAt occurrence.path
    exact AllStrictPrefixesNonnegative.d1ReducedSourceSplit htarget
      occurrence.shift_nonnegative hm2 _
  · rw [occurrence.sourceStep_eq_d2 hm5]
    exact htree.splitAt occurrence.path occurrence.shift_nonnegative
  · rw [occurrence.sourceStep_eq_d3 hm8]
    apply htree.provenancedReplaceAt occurrence.path
    exact AllStrictPrefixesNonnegative.d3ReducedSourceSplit htarget
      occurrence.shift_nonnegative hm8 _

theorem AllStrictPrefixesNonnegative.sourceScheduledStep
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (htree : AllStrictPrefixesNonnegative root tree) :
    AllStrictPrefixesNonnegative root
      (ProvenancedTree.sourceScheduledStep tree) := by
  generalize hfind : ProvenancedTree.findExpandableOccurrence tree = result
  cases result with
  | none => simpa [ProvenancedTree.sourceScheduledStep, hfind] using htree
  | some occurrence =>
      simpa [ProvenancedTree.sourceScheduledStep, hfind] using
        htree.sourceStep occurrence

theorem run_allStrictPrefixesNonnegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {initial : ProvenancedTree hp root}
    (hinitial : AllStrictPrefixesNonnegative root initial) (n : Nat) :
    AllStrictPrefixesNonnegative root (ProvenancedTree.run initial n) := by
  induction n with
  | zero => exact hinitial
  | succ n ih => exact ih.sourceScheduledStep

theorem selectedCodePrefix_nonnegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {initial : ProvenancedTree hp root}
    (hinitial : AllStrictPrefixesNonnegative root initial)
    (hne : NeverStops initial) {code : List (PackedSourceAction p)}
    (hcode : IsSelectedCodePrefix hne code) :
    0 <= root.shift.eval + packedWeightEval code := by
  obtain ⟨time, hprefix⟩ := hcode
  let occurrence := selectedOccurrence hne time
  have htree := run_allStrictPrefixesNonnegative hinitial time
  have hstrict := target_strictPrefixesNonnegative occurrence.path htree
  obtain ⟨suffix, hfull⟩ := hprefix
  change code ++ suffix = sourceWalkActionList occurrence.target.walk at hfull
  have hfullLength := congrArg List.length hfull
  rw [sourceWalkActionList_length] at hfullLength
  simp only [List.length_append] at hfullLength
  have hlength : code.length <= occurrence.target.walk.length := by
    omega
  by_cases hlt : code.length < occurrence.target.walk.length
  · have htake :
        (sourceWalkActionList occurrence.target.walk).take code.length = code := by
      rw [← hfull]
      simp
    simpa only [htake] using hstrict code.length hlt
  · have heqLength : code.length = occurrence.target.walk.length := by omega
    have hsuffixLength : suffix.length = 0 := by
      omega
    have hsuffix : suffix = [] := List.eq_nil_of_length_eq_zero hsuffixLength
    subst suffix
    simp only [List.append_nil] at hfull
    rw [hfull, packedWeightEval_sourceWalkActionList]
    simpa only [provenancedLabel_shift_eval_eq] using
      occurrence.shift_nonnegative

theorem extractedInfiniteSourceWalk_shiftsNonnegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (hne : NeverStops (ProvenancedTree.initial hp root)) :
    InfiniteSourceWalk.ShiftsNonnegative
      (extractedInfiniteSourceWalk hne) root.shift.eval := by
  intro n
  have hselected := extractedInfiniteSourceWalk_prefix_isSelected hne n
  have hnonnegative := selectedCodePrefix_nonnegative
    (AllStrictPrefixesNonnegative.initial hp root) hne hselected
  rw [InfiniteSourceWalk.beta,
    ← (extractedInfiniteSourceWalk hne).segment_weight_eval]
  rw [← packedWeightEval_sourceWalkActionList]
  exact hnonnegative

end GeneralKExtractedBranchNonnegative

end KL2003
end CollatzClassical
