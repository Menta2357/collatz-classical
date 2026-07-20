import CollatzClassical.KL2003.KL2003GeneralKLNTFeasibilityTransfer
import Mathlib.Data.Stream.Init
import Mathlib.Order.KonigLemma

namespace CollatzClassical
namespace KL2003
namespace GeneralKUniformCriticalDepth

/-!
Uniform source-genealogy depth for every critical scheduler run, jointly over
all tracked roots and all real arguments `y >= 2`.

The fixed-`y` termination theorem alone does not imply a uniform retarded
shift window. This module closes the missing compactness step without assuming
a canonical EL normal form. If selected source-walk depths were unbounded as
`y` and the root mode vary, finite packed prefixes at every exact depth would
form an inverse system. Konig extraction gives one coherent infinite source
walk. Every finite prefix comes from an actual finite critical run, so it
inherits both nonnegative accumulated shift and advanced-arrival dominance.
The existing recurrent-drop theorem excludes that infinite branch.

The result bounds scheduler-selected expansion targets. A subsequent finite
tree argument must bound all terminal leaves by one extra level and extract a
positive minimum from the resulting finite family of negative symbolic shifts.
-/

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler
open GeneralKCriticalTerminalFinder
open GeneralKCriticalScheduler
open GeneralKCriticalSourceStep
open GeneralKCriticalInfiniteBranchExtraction
open GeneralKExtractedBranchNonnegative
open GeneralKInfiniteBranchDescent
open GeneralKAdvancedRecurrence
open GeneralKAdvancedPrefixRealization
open GeneralKCriticalAdvancedDominance
open GeneralKAdvancedArrivalBoundedness
open GeneralKProvenanceTrace
open ELTree

theorem criticalScheduledStep_allLabelsAdvancedDominance
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    {y : Real} (hy : 2 <= y)
    (hbounds : tree.forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : tree.forget.normalExpr.ArgumentsNonnegative y)
    (htree : AllLabelsAdvancedDominance tree)
    (htrace : TraceConsistentFrom [] tree) :
    AllLabelsAdvancedDominance (criticalScheduledStep tree y) := by
  generalize hfind : findCriticalExpandableOccurrence tree
      (fun mode z => sourcePhiK mode z) y = result
  cases result with
  | none =>
      rw [criticalScheduledStep_eq_self_of_find_eq_none tree y hfind]
      exact htree
  | some selected =>
      rw [criticalScheduledStep_eq_sourceStep_of_find_eq_some
        tree y selected hfind]
      have facts := criticalSourceStepFacts roots hy selected hbounds hargs
      exact htree.criticalSourceStep selected.occurrence htrace
        facts.d1RetainedBranchesWitnessFree
        facts.d3RetainedBranchesWitnessFree

theorem run_allLabelsAdvancedDominance_finite
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y) :
    forall n,
      AllLabelsAdvancedDominance
        (run (ProvenancedTree.initial hp root) y n) := by
  intro n
  induction n with
  | zero => exact allLabelsAdvancedDominance_initial hp root
  | succ n ih =>
      rw [run_succ]
      apply criticalScheduledStep_allLabelsAdvancedDominance roots hy
      · exact run_criticalNodeBounds roots (ProvenancedTree.initial hp root) hy
          hbounds hargs n
      · exact run_argumentsNonnegative roots (ProvenancedTree.initial hp root) hy
          hbounds hargs n
      · exact ih
      · exact run_initial_traceConsistent hp root y n

structure UniformSelectedCodeWitness {p : Nat} (hp : 1 <= p)
    (code : List (PackedSourceAction p)) where
  mode : TrackedMode (p + 1)
  y : Real
  hy : 2 <= y
  time : Nat
  selected : CriticalExpandableOccurrence
    (run (ProvenancedTree.initial hp
      (GeneralKCriticalStopSemantics.zeroRootLabel mode)) y time)
    (fun tracked z => sourcePhiK tracked z) y
  find_eq : findCriticalExpandableOccurrence
      (run (ProvenancedTree.initial hp
        (GeneralKCriticalStopSemantics.zeroRootLabel mode)) y time)
      (fun tracked z => sourcePhiK tracked z) y = some selected
  isPrefix : code <+:
    sourceWalkActionList selected.occurrence.target.walk

def IsUniformSelectedCodePrefix {p : Nat} {hp : 1 <= p}
    (code : List (PackedSourceAction p)) : Prop :=
  Nonempty (UniformSelectedCodeWitness hp code)

abbrev UniformSelectedCodeAtDepth {p : Nat} {hp : 1 <= p}
    (depth : Nat) :=
  {code : List (PackedSourceAction p) //
    code.length = depth /\ IsUniformSelectedCodePrefix (hp := hp) code}

instance finite_uniformSelectedCodeAtDepth
    {p : Nat} {hp : 1 <= p} (depth : Nat) :
    Finite (UniformSelectedCodeAtDepth (hp := hp) depth) := by
  letI : Finite {code : List (PackedSourceAction p) //
      code.length = depth} :=
    ((List.finite_length_le (PackedSourceAction p) depth).subset
      (by
        intro code hlength
        change code.length = depth at hlength
        change code.length <= depth
        omega)).to_subtype
  let embed : UniformSelectedCodeAtDepth (hp := hp) depth ->
      {code : List (PackedSourceAction p) // code.length = depth} :=
    fun code => ⟨code.1, code.2.1⟩
  exact Finite.of_injective embed (fun first second h => by
    apply Subtype.ext
    exact congrArg (fun code : {code : List (PackedSourceAction p) //
      code.length = depth} => code.1) h)

def uniformPrefixProjection {p : Nat} {hp : 1 <= p}
    {i j : Nat} (hij : i <= j)
    (code : UniformSelectedCodeAtDepth (hp := hp) j) :
    UniformSelectedCodeAtDepth (hp := hp) i := by
  refine ⟨code.1.take i, ?_, ?_⟩
  · simp [List.length_take, code.2.1, Nat.min_eq_left hij]
  · rcases code.2.2 with ⟨witness⟩
    exact ⟨{
      mode := witness.mode
      y := witness.y
      hy := witness.hy
      time := witness.time
      selected := witness.selected
      find_eq := witness.find_eq
      isPrefix := (List.take_prefix i code.1).trans witness.isPrefix
    }⟩

theorem uniformPrefixProjection_refl {p : Nat} {hp : 1 <= p}
    {i : Nat} (code : UniformSelectedCodeAtDepth (hp := hp) i) :
    uniformPrefixProjection (hp := hp) (le_refl i) code = code := by
  apply Subtype.ext
  simp [uniformPrefixProjection, List.take_of_length_le, code.2.1]

theorem uniformPrefixProjection_trans {p : Nat} {hp : 1 <= p}
    {i j k : Nat} (hij : i <= j) (hjk : j <= k)
    (code : UniformSelectedCodeAtDepth (hp := hp) k) :
    uniformPrefixProjection (hp := hp) hij
        (uniformPrefixProjection (hp := hp) hjk code) =
      uniformPrefixProjection (hp := hp) (hij.trans hjk) code := by
  apply Subtype.ext
  simp [uniformPrefixProjection, List.take_take, Nat.min_eq_left hij]

theorem uniformSelectedCode_chainCoherent
    {p : Nat} {hp : 1 <= p} {code : List (PackedSourceAction p)}
    (hcode : IsUniformSelectedCodePrefix (hp := hp) code) :
    PackedChainCoherent hp code := by
  rcases hcode with ⟨witness⟩
  exact (sourceWalkActionList_chainCoherent
    witness.selected.occurrence.target.walk).of_prefix witness.isPrefix

theorem uniformSelectedCode_nonnegative
    {p : Nat} {hp : 1 <= p} {code : List (PackedSourceAction p)}
    (hcode : IsUniformSelectedCodePrefix (hp := hp) code) :
    0 <= packedWeightEval code := by
  rcases hcode with ⟨witness⟩
  let root := GeneralKCriticalStopSemantics.zeroRootLabel witness.mode
  let occurrence := witness.selected.occurrence
  have htree := GeneralKCriticalInfiniteBranchExtraction.run_allStrictPrefixesNonnegative
    (AllStrictPrefixesNonnegative.initial hp root) witness.y witness.time
  have hstrict := target_strictPrefixesNonnegative occurrence.path htree
  obtain ⟨suffix, hfull⟩ := witness.isPrefix
  change code ++ suffix = sourceWalkActionList occurrence.target.walk at hfull
  have hfullLength := congrArg List.length hfull
  rw [sourceWalkActionList_length] at hfullLength
  simp only [List.length_append] at hfullLength
  have hlength : code.length <= occurrence.target.walk.length := by omega
  by_cases hlt : code.length < occurrence.target.walk.length
  · have htake :
        (sourceWalkActionList occurrence.target.walk).take code.length = code := by
      rw [← hfull]
      simp
    have hnonnegative : 0 <= root.shift.eval + packedWeightEval code := by
      simpa only [htake] using hstrict code.length hlt
    simpa [root, GeneralKCriticalStopSemantics.zeroRootLabel,
      SymbolicShift.eval_zero] using hnonnegative
  · have heqLength : code.length = occurrence.target.walk.length := by omega
    have hsuffixLength : suffix.length = 0 := by omega
    have hsuffix : suffix = [] := List.eq_nil_of_length_eq_zero hsuffixLength
    subst suffix
    simp only [List.append_nil] at hfull
    rw [hfull, packedWeightEval_sourceWalkActionList]
    have htarget : 0 <= occurrence.target.label.shift.eval :=
      occurrence.shift_nonnegative
    simpa [root, GeneralKCriticalStopSemantics.zeroRootLabel,
      provenancedLabel_shift_eval_eq, SymbolicShift.eval_zero] using htarget

theorem uniformSelectedCode_advancedDominance
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {code : List (PackedSourceAction p)}
    (hcode : IsUniformSelectedCodePrefix (hp := hp) code) :
    AdvancedPrefixDominatesEarlier hp 0 code := by
  rcases hcode with ⟨witness⟩
  let root := GeneralKCriticalStopSemantics.zeroRootLabel witness.mode
  have htree := run_allLabelsAdvancedDominance_finite (hp := hp) roots witness.hy
    (root := root) (by trivial) (by
      change 0 <= witness.y + root.shift.eval
      change 0 <= witness.y + SymbolicShift.zero.eval
      rw [SymbolicShift.eval_zero, add_zero]
      linarith [witness.hy]) witness.time
  have htarget := target_advancedDominance
    witness.selected.occurrence.path htree
  have hprefix := htarget.of_isPrefix witness.isPrefix
  simpa [root, GeneralKCriticalStopSemantics.zeroRootLabel,
    SymbolicShift.eval_zero] using hprefix

def CriticalSelectedDepthBound {p : Nat} (hp : 1 <= p)
    (bound : Nat) : Prop :=
  forall (mode : TrackedMode (p + 1)) (y : Real), 2 <= y ->
    forall (time : Nat)
      (selected : CriticalExpandableOccurrence
        (run (ProvenancedTree.initial hp
          (GeneralKCriticalStopSemantics.zeroRootLabel mode)) y time)
        (fun tracked z => sourcePhiK tracked z) y),
      findCriticalExpandableOccurrence
          (run (ProvenancedTree.initial hp
            (GeneralKCriticalStopSemantics.zeroRootLabel mode)) y time)
          (fun tracked z => sourcePhiK tracked z) y = some selected ->
        selected.occurrence.target.walk.length <= bound

def CriticalSelectedDepthUnbounded {p : Nat} (hp : 1 <= p) : Prop :=
  forall bound : Nat,
    exists (mode : TrackedMode (p + 1)) (y : Real), 2 <= y /\
      exists (time : Nat)
        (selected : CriticalExpandableOccurrence
          (run (ProvenancedTree.initial hp
            (GeneralKCriticalStopSemantics.zeroRootLabel mode)) y time)
          (fun tracked z => sourcePhiK tracked z) y),
        findCriticalExpandableOccurrence
            (run (ProvenancedTree.initial hp
              (GeneralKCriticalStopSemantics.zeroRootLabel mode)) y time)
            (fun tracked z => sourcePhiK tracked z) y = some selected /\
          bound < selected.occurrence.target.walk.length

theorem nonempty_uniformSelectedCodeAtDepth_of_unbounded
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) (depth : Nat) :
    Nonempty (UniformSelectedCodeAtDepth (hp := hp) depth) := by
  obtain ⟨mode, y, hy, time, selected, hfind, hlength⟩ := hunbounded depth
  let fullCode := sourceWalkActionList selected.occurrence.target.walk
  let code := fullCode.take depth
  have hdepth : depth <= fullCode.length := by
    dsimp only [fullCode]
    rw [sourceWalkActionList_length]
    omega
  refine ⟨⟨code, ?_, ?_⟩⟩
  · simp [code, List.length_take, Nat.min_eq_left hdepth]
  · exact ⟨{
      mode := mode
      y := y
      hy := hy
      time := time
      selected := selected
      find_eq := hfind
      isPrefix := List.take_prefix depth fullCode
    }⟩

theorem exists_coherent_uniformSelectedCodes_of_unbounded
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) :
    exists codes : (depth : Nat) ->
        UniformSelectedCodeAtDepth (hp := hp) depth,
      forall {i j : Nat} (hij : i <= j),
        uniformPrefixProjection (hp := hp) hij (codes j) = codes i := by
  letI (depth : Nat) : Nonempty
      (UniformSelectedCodeAtDepth (hp := hp) depth) :=
    nonempty_uniformSelectedCodeAtDepth_of_unbounded hunbounded depth
  apply exists_seq_forall_proj_of_forall_finite
    (fun hij => uniformPrefixProjection (hp := hp) hij)
  · intro i code
    exact uniformPrefixProjection_refl (hp := hp) code
  · intro i j k hij hjk code
    exact uniformPrefixProjection_trans (hp := hp) hij hjk code
  · intro i code
    exact Set.toFinite _

noncomputable def coherentUniformSelectedCodes
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) :
    (depth : Nat) -> UniformSelectedCodeAtDepth (hp := hp) depth :=
  Classical.choose (exists_coherent_uniformSelectedCodes_of_unbounded hunbounded)

theorem coherentUniformSelectedCodes_projection
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp)
    {i j : Nat} (hij : i <= j) :
    uniformPrefixProjection (hp := hp) hij
        (coherentUniformSelectedCodes hunbounded j) =
      coherentUniformSelectedCodes hunbounded i :=
  Classical.choose_spec
    (exists_coherent_uniformSelectedCodes_of_unbounded hunbounded) hij

noncomputable def coherentUniformPackedAction
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp)
    (n : Nat) : PackedSourceAction p :=
  (coherentUniformSelectedCodes hunbounded (n + 1)).1[n]'(by
    rw [(coherentUniformSelectedCodes hunbounded (n + 1)).2.1]
    omega)

theorem coherentUniformSelectedCodes_succ
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) (n : Nat) :
    (coherentUniformSelectedCodes hunbounded (n + 1)).1 =
      (coherentUniformSelectedCodes hunbounded n).1 ++
        [coherentUniformPackedAction hunbounded n] := by
  have hprojection := coherentUniformSelectedCodes_projection hunbounded
    (show n <= n + 1 by omega)
  have htake : (coherentUniformSelectedCodes hunbounded (n + 1)).1.take n =
      (coherentUniformSelectedCodes hunbounded n).1 := by
    exact congrArg Subtype.val hprojection
  let code := (coherentUniformSelectedCodes hunbounded (n + 1)).1
  have hlength : code.length = n + 1 :=
    (coherentUniformSelectedCodes hunbounded (n + 1)).2.1
  calc
    code = code.take (n + 1) := by simp [hlength]
    _ = code.take n ++ [code[n]] := by
      symm
      exact List.take_concat_get' code n (by omega)
    _ = (coherentUniformSelectedCodes hunbounded n).1 ++
        [coherentUniformPackedAction hunbounded n] := by
      rw [htake]
      rfl

noncomputable def coherentUniformPackedStream
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) :
    Stream' (PackedSourceAction p) :=
  fun n => coherentUniformPackedAction hunbounded n

theorem coherentUniformPackedStream_take
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) (n : Nat) :
    (coherentUniformPackedStream hunbounded).take n =
      (coherentUniformSelectedCodes hunbounded n).1 := by
  induction n with
  | zero =>
      have hlength := (coherentUniformSelectedCodes hunbounded 0).2.1
      simpa using List.eq_nil_of_length_eq_zero hlength
  | succ n ih =>
      rw [Stream'.take_succ', ih, coherentUniformSelectedCodes_succ]
      rfl

theorem coherentUniformPackedStream_adjacent
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) (n : Nat) :
    ((coherentUniformPackedStream hunbounded).get n).2.target hp =
      ((coherentUniformPackedStream hunbounded).get (n + 1)).1 := by
  let code := (coherentUniformPackedStream hunbounded).take (n + 2)
  have hcoherent : PackedChainCoherent hp code := by
    dsimp only [code]
    rw [coherentUniformPackedStream_take]
    exact uniformSelectedCode_chainCoherent
      (coherentUniformSelectedCodes hunbounded (n + 2)).2.2
  have hadjacent := hcoherent.get_adjacent n (by
    dsimp only [code]
    simp)
  have hn : n < code.length := by simp [code]
  have hn1 : n + 1 < code.length := by simp [code]
  have hfirst : code[n]'hn =
      (coherentUniformPackedStream hunbounded).get n := by
    have hget := Stream'.getElem?_take
      (s := coherentUniformPackedStream hunbounded) (k := n)
      (n := n + 2) (by omega)
    simpa [code, List.getElem?_eq_getElem] using hget
  have hsecond : code[n + 1]'hn1 =
      (coherentUniformPackedStream hunbounded).get (n + 1) := by
    have hget := Stream'.getElem?_take
      (s := coherentUniformPackedStream hunbounded) (k := n + 1)
      (n := n + 2) (by omega)
    simpa [code, List.getElem?_eq_getElem] using hget
  rw [hfirst, hsecond] at hadjacent
  exact hadjacent

noncomputable def unboundedInfiniteSourceWalk
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) :
    InfiniteSourceWalk hp where
  modes n := ((coherentUniformPackedStream hunbounded).get n).1
  actions n := ((coherentUniformPackedStream hunbounded).get n).2
  target_next n := coherentUniformPackedStream_adjacent hunbounded n

theorem unboundedInfiniteSourceWalk_segment_code
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp)
    (start length : Nat) :
    sourceWalkActionList
        ((unboundedInfiniteSourceWalk hunbounded).segment start length) =
      ((coherentUniformPackedStream hunbounded).drop start).take length := by
  induction length generalizing start with
  | zero => rfl
  | succ length ih =>
      simp only [InfiniteSourceWalk.segment,
        sourceWalkActionList_cons,
        GeneralKCriticalInfiniteBranchExtraction.sourceWalkActionList_castSourceWalk,
        Stream'.take_succ, Stream'.head_drop, Stream'.tail_drop']
      rw [ih]
      simp only [unboundedInfiniteSourceWalk]

theorem unboundedInfiniteSourceWalk_prefix_code
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) (length : Nat) :
    sourceWalkActionList
        ((unboundedInfiniteSourceWalk hunbounded).segment 0 length) =
      (coherentUniformSelectedCodes hunbounded length).1 := by
  rw [unboundedInfiniteSourceWalk_segment_code]
  simp [coherentUniformPackedStream_take]

theorem unboundedInfiniteSourceWalk_shiftsNonnegative
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) :
    (unboundedInfiniteSourceWalk hunbounded).ShiftsNonnegative 0 := by
  intro n
  have hnonnegative := uniformSelectedCode_nonnegative
    (coherentUniformSelectedCodes hunbounded n).2.2
  rw [InfiniteSourceWalk.beta,
    ← (unboundedInfiniteSourceWalk hunbounded).segment_weight_eval]
  rw [← packedWeightEval_sourceWalkActionList,
    unboundedInfiniteSourceWalk_prefix_code]
  simpa using hnonnegative

theorem advancePackedShift_unboundedPrefix_eval
    {p : Nat} {hp : 1 <= p}
    (hunbounded : CriticalSelectedDepthUnbounded hp) (length : Nat) :
    (advancePackedShift SymbolicShift.zero
      ((coherentUniformPackedStream hunbounded).take length)).eval =
      (unboundedInfiniteSourceWalk hunbounded).beta 0 length := by
  rw [advancePackedShift_eval]
  have hcode : sourceWalkActionList
      ((unboundedInfiniteSourceWalk hunbounded).segment 0 length) =
      (coherentUniformPackedStream hunbounded).take length := by
    simpa using unboundedInfiniteSourceWalk_segment_code hunbounded 0 length
  rw [← hcode, packedWeightEval_sourceWalkActionList]
  rw [InfiniteSourceWalk.beta,
    ← (unboundedInfiniteSourceWalk hunbounded).segment_weight_eval]
  simp [SymbolicShift.eval_zero]

theorem unboundedInfiniteSourceWalk_advancedArrivalsNonincreasing
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    (hunbounded : CriticalSelectedDepthUnbounded hp) :
    AdvancedArrivalsNonincreasing
      (unboundedInfiniteSourceWalk hunbounded) 0 := by
  intro arrival hadvanced earlier hearlier hmodes
  let code := (coherentUniformPackedStream hunbounded).take (arrival + 1)
  have hcodeLength : code.length = arrival + 1 := by simp [code]
  have hdom := uniformSelectedCode_advancedDominance roots
    (coherentUniformSelectedCodes hunbounded (arrival + 1)).2.2
  have hdomCode : AdvancedPrefixDominatesEarlier hp 0 code := by
    simpa [code, coherentUniformPackedStream_take] using hdom
  have harrivalPacked :
      code[arrival]'(by omega) =
        (coherentUniformPackedStream hunbounded).get arrival := by
    have hget := Stream'.getElem?_take
      (s := coherentUniformPackedStream hunbounded) (k := arrival)
      (n := arrival + 1) (by omega)
    simpa [code, List.getElem?_eq_getElem] using hget
  have hadvancedCode : IsAdvancedAction (code[arrival]'(by omega)).2 := by
    rw [harrivalPacked]
    exact hadvanced
  have htargetMode :
      (code[arrival]'(by omega)).2.target hp =
        (unboundedInfiniteSourceWalk hunbounded).modes (arrival + 1) := by
    rw [harrivalPacked]
    exact (unboundedInfiniteSourceWalk hunbounded).target_next arrival
  have hearlierMode :
      (code[earlier]'(by omega)).1 =
        (unboundedInfiniteSourceWalk hunbounded).modes earlier := by
    have hget := Stream'.getElem?_take
      (s := coherentUniformPackedStream hunbounded) (k := earlier)
      (n := arrival + 1) (by omega)
    simpa [code, List.getElem?_eq_getElem,
      unboundedInfiniteSourceWalk] using congrArg Sigma.fst hget
  have hnonnegative :
      0 <= (advancePackedShift SymbolicShift.zero
          (code.take (arrival + 1))).eval + 0 := by
    have htake : code.take (arrival + 1) =
        (coherentUniformPackedStream hunbounded).take (arrival + 1) := by
      simp [code]
    rw [htake, add_zero,
      advancePackedShift_unboundedPrefix_eval hunbounded (arrival + 1)]
    exact unboundedInfiniteSourceWalk_shiftsNonnegative hunbounded (arrival + 1)
  have hle := hdomCode arrival (by omega) hadvancedCode hnonnegative
    earlier hearlier (by rw [hearlierMode, htargetMode, hmodes])
  have harrivalTake : code.take (arrival + 1) =
      (coherentUniformPackedStream hunbounded).take (arrival + 1) := by
    simp [code, List.take_take]
  have hearlierTake : code.take earlier =
      (coherentUniformPackedStream hunbounded).take earlier := by
    dsimp only [code]
    rw [Stream'.take_take, Nat.min_eq_right (by omega)]
  rw [harrivalTake, hearlierTake] at hle
  rw [add_zero, add_zero,
    advancePackedShift_unboundedPrefix_eval hunbounded (arrival + 1),
    advancePackedShift_unboundedPrefix_eval hunbounded earlier] at hle
  exact hle

theorem not_criticalSelectedDepthUnbounded
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    Not (CriticalSelectedDepthUnbounded hp) := by
  intro hunbounded
  exact nonnegative_branch_impossible_of_advancedArrivalsNonincreasing
    (unboundedInfiniteSourceWalk hunbounded) 0
    (unboundedInfiniteSourceWalk_shiftsNonnegative hunbounded)
    (unboundedInfiniteSourceWalk_advancedArrivalsNonincreasing roots hunbounded)

theorem exists_uniform_criticalSelectedDepthBound
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1)) :
    exists bound : Nat, CriticalSelectedDepthBound hp bound := by
  by_contra hbound
  apply not_criticalSelectedDepthUnbounded roots
  intro bound
  have hnot : Not (CriticalSelectedDepthBound hp bound) := by
    intro hthis
    exact hbound ⟨bound, hthis⟩
  simp only [CriticalSelectedDepthBound] at hnot
  push_neg at hnot
  obtain ⟨mode, y, hy, time, selected, hfind, hlength⟩ := hnot
  exact ⟨mode, y, hy, time, selected, hfind, hlength⟩

end GeneralKUniformCriticalDepth
end KL2003
end CollatzClassical
