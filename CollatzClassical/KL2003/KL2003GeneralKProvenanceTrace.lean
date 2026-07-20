import CollatzClassical.KL2003.KL2003GeneralKExtractedBranchNonnegative

namespace CollatzClassical
namespace KL2003
namespace GeneralKProvenanceTrace

/-!
Exact label traces for packed source genealogies.

`packedPrefixLabels shift code` lists one EL label for every strict action
prefix: the source mode of the next packed action together with the symbolic
shift accumulated before that action.  The append algebra shows that extending
a provenanced node by one source action appends exactly the parent label to
this list.  This is the traffic layer needed to compare deletion witnesses in
an EL context with earlier vertices of the typed source walk.
-/

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKSourceGenealogy
open GeneralKExtractedBranchNonnegative
open GeneralKProvenancedScheduler

open GeneralKSourceGenealogy.ProvenancedTree

def advancePackedShift {p : Nat} :
    SymbolicShift -> List (PackedSourceAction p) -> SymbolicShift
  | shift, [] => shift
  | shift, action :: tail =>
      advancePackedShift (shift + action.2.weight) tail

def packedPrefixLabels {p : Nat} :
    SymbolicShift -> List (PackedSourceAction p) -> List (ELLabel (p + 1))
  | _, [] => []
  | shift, action :: tail =>
      ⟨action.1, shift⟩ ::
        packedPrefixLabels (shift + action.2.weight) tail

theorem advancePackedShift_append {p : Nat} (shift : SymbolicShift)
    (first second : List (PackedSourceAction p)) :
    advancePackedShift shift (first ++ second) =
      advancePackedShift (advancePackedShift shift first) second := by
  induction first generalizing shift with
  | nil => rfl
  | cons action tail ih =>
      simp only [List.cons_append, advancePackedShift]
      exact ih (shift + action.2.weight)

theorem packedPrefixLabels_append {p : Nat} (shift : SymbolicShift)
    (first second : List (PackedSourceAction p)) :
    packedPrefixLabels shift (first ++ second) =
      packedPrefixLabels shift first ++
        packedPrefixLabels (advancePackedShift shift first) second := by
  induction first generalizing shift with
  | nil => rfl
  | cons action tail ih =>
      simp only [List.cons_append, packedPrefixLabels, List.cons_append]
      rw [ih]
      rfl

theorem advancePackedShift_sourceWalkActionList
    {p : Nat} {hp : 1 <= p} {source target : TrackedMode (p + 1)}
    (shift : SymbolicShift) (walk : SourceWalk hp source target) :
    advancePackedShift shift (sourceWalkActionList walk) =
      shift + walk.weight := by
  induction walk generalizing shift with
  | nil => exact (shift_add_zero shift).symm
  | cons action tail ih =>
      simp only [sourceWalkActionList_cons, advancePackedShift,
        SourceWalk.weight_cons]
      rw [ih]
      exact shift_add_assoc shift action.weight tail.weight

theorem packedPrefixLabels_provenancedChild
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root)
    (action : SourceAction node.label.mode) :
    packedPrefixLabels root.shift
        (sourceWalkActionList (node.child action).walk) =
      packedPrefixLabels root.shift (sourceWalkActionList node.walk) ++
        [node.label] := by
  rw [ProvenancedLabel.child]
  rw [sourceWalkActionList_append]
  rw [packedPrefixLabels_append]
  rw [advancePackedShift_sourceWalkActionList]
  rw [← node.shift_eq]
  rfl

theorem packedPrefixLabels_root
    {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1)) :
    packedPrefixLabels root.shift
      (sourceWalkActionList (ProvenancedLabel.root hp root).walk) = [] := rfl

/-- A provenanced subtree is trace-consistent from `prefix` when every stored
genealogy agrees with the expanded labels already traversed before the
subtree.  Algebraic branching does not change that prefix; expanding a
principal node appends exactly its label. -/
def TraceConsistentFrom {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} :
    List (ELLabel (p + 1)) -> ProvenancedTree hp root -> Prop
  | history, .terminal node =>
      packedPrefixLabels root.shift (sourceWalkActionList node.walk) = history
  | history, .expanded node body =>
      packedPrefixLabels root.shift (sourceWalkActionList node.walk) = history /\
        TraceConsistentFrom (history ++ [node.label]) body
  | history, .add left right | history, .min2 left right =>
      TraceConsistentFrom history left /\ TraceConsistentFrom history right
  | history, .min3 first second third =>
      TraceConsistentFrom history first /\
        TraceConsistentFrom history second /\
        TraceConsistentFrom history third

/-- The one-node initial provenanced tree has an empty genealogy trace. -/
theorem traceConsistentFrom_initial {p : Nat} (hp : 1 <= p)
    (root : ELLabel (p + 1)) :
    TraceConsistentFrom [] (ProvenancedTree.initial hp root) := by
  exact packedPrefixLabels_root hp root

/-- A trace-consistent tree identifies the raw expanded-label context of any
terminal path with the corresponding strict source-walk prefixes. -/
theorem traceConsistentFrom_terminalPath
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    {history : List (ELLabel (p + 1))}
    (path : ProvenancedTree.TerminalPath tree target)
    (htrace : TraceConsistentFrom history tree) :
    history ++ path.forgetPath.context.expandedLabels =
      packedPrefixLabels root.shift (sourceWalkActionList target.walk) := by
  induction path generalizing history with
  | here node =>
      simpa [TraceConsistentFrom, ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        htrace.symm
  | expanded node body target path ih =>
      have hsub := ih htrace.2
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels,
        List.append_assoc] using hsub
  | addLeft left right target path ih =>
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        ih htrace.1
  | addRight left right target path ih =>
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        ih htrace.2
  | min2Left left right target path ih =>
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        ih htrace.1
  | min2Right left right target path ih =>
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        ih htrace.2
  | minFirst first second third target path ih =>
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        ih htrace.1
  | minSecond first second third target path ih =>
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        ih htrace.2.1
  | minThird first second third target path ih =>
      simpa [ProvenancedTree.TerminalPath.forgetPath,
        ELTree.TerminalPath.context, ELTree.Context.expandedLabels] using
        ih htrace.2.2

/-- The source-faithful local split is trace-consistent from the genealogy of
its principal node. -/
theorem traceConsistentFrom_sourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root) :
    TraceConsistentFrom
      (packedPrefixLabels root.shift (sourceWalkActionList node.walk))
      (ProvenancedTree.sourceSplit node) := by
  classical
  by_cases hm2 : node.label.mode.1.1 % 9 = 2
  · simp [ProvenancedTree.sourceSplit, hm2, TraceConsistentFrom,
      packedPrefixLabels_provenancedChild]
  by_cases hm5 : node.label.mode.1.1 % 9 = 5
  · simp [ProvenancedTree.sourceSplit, hm2, hm5, TraceConsistentFrom,
      packedPrefixLabels_provenancedChild]
  · simp [ProvenancedTree.sourceSplit, hm2, hm5, TraceConsistentFrom,
      packedPrefixLabels_provenancedChild]

/-- Any min-three retention preserves a shared trace history. -/
theorem TraceConsistentFrom.reduce
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {history : List (ELLabel (p + 1))}
    {first second third : ProvenancedTree hp root}
    (hfirst : TraceConsistentFrom history first)
    (hsecond : TraceConsistentFrom history second)
    (hthird : TraceConsistentFrom history third)
    (retention : ELTree.Min3Retention) :
    TraceConsistentFrom history
      (ProvenancedTree.reduce retention first second third) := by
  cases retention <;>
    simp [ProvenancedTree.reduce, TraceConsistentFrom, *]

/-- A reduced D1 split remains trace-consistent independently of which
advanced branches the contextual deletion decision retains. -/
theorem traceConsistentFrom_d1ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention) :
    TraceConsistentFrom
      (packedPrefixLabels root.shift (sourceWalkActionList node.walk))
      (ProvenancedTree.d1ReducedSourceSplit node hm retention) := by
  apply And.intro rfl
  apply And.intro
  · exact packedPrefixLabels_provenancedChild node _
  · apply TraceConsistentFrom.reduce <;>
      exact packedPrefixLabels_provenancedChild node _

/-- A reduced D3 split remains trace-consistent independently of retention. -/
theorem traceConsistentFrom_d3ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention) :
    TraceConsistentFrom
      (packedPrefixLabels root.shift (sourceWalkActionList node.walk))
      (ProvenancedTree.d3ReducedSourceSplit node hm retention) := by
  apply And.intro rfl
  apply And.intro
  · exact packedPrefixLabels_provenancedChild node _
  · apply TraceConsistentFrom.reduce <;>
      exact packedPrefixLabels_provenancedChild node _

/-- Replacing a terminal by a subtree rooted at that terminal's exact
genealogy preserves the surrounding trace invariant. -/
theorem TraceConsistentFrom.provenancedReplaceAt
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree replacement : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root}
    {history : List (ELLabel (p + 1))}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : TraceConsistentFrom history tree)
    (hreplacement : TraceConsistentFrom
      (packedPrefixLabels root.shift (sourceWalkActionList target.walk))
      replacement) :
    TraceConsistentFrom history
      (ProvenancedTree.provenancedReplaceAt path replacement) := by
  induction path generalizing history with
  | here node =>
      change packedPrefixLabels root.shift
        (sourceWalkActionList node.walk) = history at htree
      change TraceConsistentFrom history replacement
      rw [← htree]
      exact hreplacement
  | expanded node body target path ih =>
      exact ⟨htree.1, ih htree.2 hreplacement⟩
  | addLeft left right target path ih =>
      exact ⟨ih htree.1 hreplacement, htree.2⟩
  | addRight left right target path ih =>
      exact ⟨htree.1, ih htree.2 hreplacement⟩
  | min2Left left right target path ih =>
      exact ⟨ih htree.1 hreplacement, htree.2⟩
  | min2Right left right target path ih =>
      exact ⟨htree.1, ih htree.2 hreplacement⟩
  | minFirst first second third target path ih =>
      exact ⟨ih htree.1 hreplacement, htree.2⟩
  | minSecond first second third target path ih =>
      exact ⟨htree.1, ih htree.2.1 hreplacement, htree.2.2⟩
  | minThird first second third target path ih =>
      exact ⟨htree.1, htree.2.1, ih htree.2.2 hreplacement⟩

/-- Splitting an arbitrary trace-consistent terminal preserves the invariant. -/
theorem TraceConsistentFrom.splitAt
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    {history : List (ELLabel (p + 1))}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : TraceConsistentFrom history tree) :
    TraceConsistentFrom history path.splitAt := by
  induction path generalizing history with
  | here node =>
      change packedPrefixLabels root.shift
        (sourceWalkActionList node.walk) = history at htree
      change TraceConsistentFrom history (ProvenancedTree.sourceSplit node)
      rw [← htree]
      exact traceConsistentFrom_sourceSplit node
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

/-- One contextual source step preserves the exact genealogy trace. -/
theorem TraceConsistentFrom.sourceStep
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    {history : List (ELLabel (p + 1))}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htree : TraceConsistentFrom history tree) :
    TraceConsistentFrom history occurrence.sourceStep := by
  classical
  rcases ELTree.trackedMode_mod_nine_cases occurrence.target.label.mode with
      hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hm2]
    apply htree.provenancedReplaceAt occurrence.path
    exact traceConsistentFrom_d1ReducedSourceSplit occurrence.target hm2 _
  · rw [occurrence.sourceStep_eq_d2 hm5]
    exact htree.splitAt occurrence.path
  · rw [occurrence.sourceStep_eq_d3 hm8]
    apply htree.provenancedReplaceAt occurrence.path
    exact traceConsistentFrom_d3ReducedSourceSplit occurrence.target hm8 _

/-- The deterministic scheduler preserves exact genealogy traces. -/
theorem TraceConsistentFrom.sourceScheduledStep
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    {history : List (ELLabel (p + 1))}
    (htree : TraceConsistentFrom history tree) :
    TraceConsistentFrom history
      (ProvenancedTree.sourceScheduledStep tree) := by
  generalize hfind : ProvenancedTree.findExpandableOccurrence tree = result
  cases result with
  | none => simpa [ProvenancedTree.sourceScheduledStep, hfind] using htree
  | some occurrence =>
      simpa [ProvenancedTree.sourceScheduledStep, hfind] using
        htree.sourceStep occurrence

/-- Every finite scheduler iterate from a consistent initial tree remains
trace-consistent. -/
theorem run_traceConsistentFrom
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {initial : ProvenancedTree hp root}
    {history : List (ELLabel (p + 1))}
    (hinitial : TraceConsistentFrom history initial) (n : Nat) :
    TraceConsistentFrom history (ProvenancedTree.run initial n) := by
  induction n with
  | zero => exact hinitial
  | succ n ih => exact ih.sourceScheduledStep

/-- Scheduler runs from the canonical one-node tree have exact traces. -/
theorem run_initial_traceConsistent
    {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1)) (n : Nat) :
    TraceConsistentFrom []
      (ProvenancedTree.run (ProvenancedTree.initial hp root) n) :=
  run_traceConsistentFrom (traceConsistentFrom_initial hp root) n

/-- On a canonical scheduler run, the raw deletion context is literally the
list of strict typed-source prefixes of the selected terminal. -/
theorem run_initial_terminalPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1)) (n : Nat)
    {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath
      (ProvenancedTree.run (ProvenancedTree.initial hp root) n) target) :
    path.forgetPath.context.expandedLabels =
      packedPrefixLabels root.shift (sourceWalkActionList target.walk) := by
  simpa using traceConsistentFrom_terminalPath path
    (run_initial_traceConsistent hp root n)

/-- In any trace-consistent tree, a raw deletion witness is exactly a
same-mode, strictly smaller-shift label among the typed source prefixes. -/
theorem hasDeletionWitness_iff_packedPrefixWitness
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htrace : TraceConsistentFrom [] tree) :
    path.forgetPath.HasDeletionWitness <->
      0 <= target.label.shift.eval /\
        exists ancestor,
          ancestor ∈ packedPrefixLabels root.shift
            (sourceWalkActionList target.walk) /\
          ancestor.mode = target.label.mode /\
          ancestor.shift.eval < target.label.shift.eval := by
  change (0 <= target.label.shift.eval /\
      exists ancestor,
        ancestor ∈ path.forgetPath.context.expandedLabels /\
        ancestor.mode = target.label.mode /\
        ancestor.shift.eval < target.label.shift.eval) <-> _
  have heq : path.forgetPath.context.expandedLabels =
      packedPrefixLabels root.shift (sourceWalkActionList target.walk) := by
    simpa using traceConsistentFrom_terminalPath path htrace
  rw [heq]

/-- If a nonnegative retained terminal has no deletion witness, every earlier
same-mode source prefix has shift at least the terminal shift. -/
theorem target_shift_le_ancestor_shift_of_noDeletionWitness
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htrace : TraceConsistentFrom [] tree)
    (htarget : 0 <= target.label.shift.eval)
    (hno : ¬ path.forgetPath.HasDeletionWitness)
    {ancestor : ELLabel (p + 1)}
    (hmem : ancestor ∈ packedPrefixLabels root.shift
      (sourceWalkActionList target.walk))
    (hmode : ancestor.mode = target.label.mode) :
    target.label.shift.eval <= ancestor.shift.eval := by
  by_contra hnot
  have hlt : ancestor.shift.eval < target.label.shift.eval := lt_of_not_ge hnot
  apply hno
  rw [hasDeletionWitness_iff_packedPrefixWitness path htrace]
  exact ⟨htarget, ancestor, hmem, hmode, hlt⟩

end GeneralKProvenanceTrace
end KL2003
end CollatzClassical
