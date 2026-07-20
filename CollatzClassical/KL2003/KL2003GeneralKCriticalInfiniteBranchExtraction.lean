import CollatzClassical.KL2003.KL2003GeneralKCriticalSchedulerRun
import Mathlib.Data.Stream.Init
import Mathlib.Order.KonigLemma

namespace CollatzClassical
namespace KL2003

/-!
Compact extraction of one coherent infinite critical source branch.

The critical-scheduler run supplies selected provenances of arbitrarily large
finite length. This module applies the inverse-system form of Konig's lemma to
their homogeneous action-list serializations. The resulting family contains
one critical-selected prefix at every exact length and is coherent under
`List.take`.
-/

namespace GeneralKCriticalInfiniteBranchExtraction

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKCriticalScheduler
open GeneralKCriticalTerminalFinder
open GeneralKExtractedBranchNonnegative

/-- A packed action list which is a prefix of some terminal selected by the
never-stopping scheduler. -/
def IsSelectedCodePrefix {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (code : List (PackedSourceAction p)) : Prop :=
  exists time : Nat,
    code <+: sourceWalkActionList (selectedOccurrence hne time).occurrence.target.walk

/-- Selected code prefixes at one exact depth. -/
abbrev SelectedCodeAtDepth {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (depth : Nat) :=
  {code : List (PackedSourceAction p) //
    code.length = depth /\ IsSelectedCodePrefix hne code}

instance finite_selectedCodeAtDepth {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (depth : Nat) :
    Finite (SelectedCodeAtDepth hne depth) := by
  letI : Finite {code : List (PackedSourceAction p) //
      code.length = depth} :=
    ((List.finite_length_le (PackedSourceAction p) depth).subset
      (by
        intro code hlength
        change code.length = depth at hlength
        change code.length <= depth
        omega)).to_subtype
  let embed : SelectedCodeAtDepth hne depth ->
      {code : List (PackedSourceAction p) // code.length = depth} :=
    fun code => ⟨code.1, code.2.1⟩
  exact Finite.of_injective embed (fun first second h => by
    apply Subtype.ext
    exact congrArg (fun code : {code : List (PackedSourceAction p) //
      code.length = depth} => code.1) h)

theorem nonempty_selectedCodeAtDepth {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (depth : Nat) :
    Nonempty (SelectedCodeAtDepth hne depth) := by
  obtain ⟨time, hlength⟩ := exists_selectedOccurrence_walk_length_gt hne depth
  let fullCode := sourceWalkActionList (selectedOccurrence hne time).occurrence.target.walk
  let code := fullCode.take depth
  have hdepth : depth <= fullCode.length := by
    dsimp only [fullCode]
    rw [sourceWalkActionList_length]
    omega
  refine ⟨⟨code, ?_, ?_⟩⟩
  · simp [code, List.length_take, Nat.min_eq_left hdepth]
  · exact ⟨time, (List.take_prefix depth fullCode)⟩

/-- Restrict an exact-depth selected prefix to a smaller exact depth. -/
def prefixProjection {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    {hne : NeverStops initial y} {i j : Nat} (hij : i <= j)
    (code : SelectedCodeAtDepth hne j) : SelectedCodeAtDepth hne i := by
  refine ⟨code.1.take i, ?_, ?_⟩
  · simp [List.length_take, code.2.1, Nat.min_eq_left hij]
  · obtain ⟨time, hprefix⟩ := code.2.2
    exact ⟨time, (List.take_prefix i code.1).trans hprefix⟩

theorem prefixProjection_refl {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    {hne : NeverStops initial y} {i : Nat}
    (code : SelectedCodeAtDepth hne i) :
    prefixProjection (hne := hne) (le_refl i) code = code := by
  apply Subtype.ext
  simp [prefixProjection, List.take_of_length_le, code.2.1]

theorem prefixProjection_trans {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    {hne : NeverStops initial y} {i j k : Nat}
    (hij : i <= j) (hjk : j <= k) (code : SelectedCodeAtDepth hne k) :
    prefixProjection (hne := hne) hij
        (prefixProjection (hne := hne) hjk code) =
      prefixProjection (hne := hne) (hij.trans hjk) code := by
  apply Subtype.ext
  simp [prefixProjection, List.take_take, Nat.min_eq_left hij]

/-- Konig extraction in inverse-system form: one selected prefix at every
depth, coherent under every restriction. -/
theorem exists_coherent_selectedCodes {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) :
    exists codes : (depth : Nat) -> SelectedCodeAtDepth hne depth,
      forall {i j : Nat} (hij : i <= j),
        prefixProjection (hne := hne) hij (codes j) = codes i := by
  letI (depth : Nat) : Nonempty (SelectedCodeAtDepth hne depth) :=
    nonempty_selectedCodeAtDepth hne depth
  apply exists_seq_forall_proj_of_forall_finite
    (fun hij => prefixProjection (hne := hne) hij)
  · intro i code
    exact prefixProjection_refl (hne := hne) code
  · intro i j k hij hjk code
    exact prefixProjection_trans (hne := hne) hij hjk code
  · intro i code
    exact Set.toFinite _

/-- A packed code is typed from left to right: every action targets the source
mode packed with the following action. -/
def PackedChainCoherent {p : Nat} (hp : 1 <= p) :
    List (PackedSourceAction p) -> Prop
  | [] => True
  | [_] => True
  | first :: second :: tail =>
      first.2.target hp = second.1 /\
        PackedChainCoherent hp (second :: tail)

theorem sourceWalkActionList_chainCoherent {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    PackedChainCoherent hp (sourceWalkActionList walk) := by
  induction walk with
  | nil => trivial
  | @cons source target action tail ih =>
      cases tail with
      | nil => trivial
      | @cons nextSource nextTarget nextAction nextTail =>
          exact ⟨rfl, ih⟩

theorem PackedChainCoherent.of_prefix {p : Nat} {hp : 1 <= p}
    {prefixCode full : List (PackedSourceAction p)}
    (hfull : PackedChainCoherent hp full) (hprefix : prefixCode <+: full) :
    PackedChainCoherent hp prefixCode := by
  obtain ⟨suffix, rfl⟩ := hprefix
  induction prefixCode with
  | nil => trivial
  | cons first tail ih =>
      cases tail with
      | nil => trivial
      | cons second rest =>
          exact ⟨hfull.1, ih hfull.2⟩

theorem selectedCodeAtDepth_chainCoherent {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    {hne : NeverStops initial y} {depth : Nat}
    (code : SelectedCodeAtDepth hne depth) :
    PackedChainCoherent hp code.1 := by
  obtain ⟨time, hprefix⟩ := code.2.2
  exact (sourceWalkActionList_chainCoherent
    (selectedOccurrence hne time).occurrence.target.walk).of_prefix hprefix

theorem PackedChainCoherent.get_adjacent {p : Nat} {hp : 1 <= p}
    {code : List (PackedSourceAction p)} (hcode : PackedChainCoherent hp code)
    (index : Nat) (hindex : index + 1 < code.length) :
    (code[index]).2.target hp = (code[index + 1]).1 := by
  induction code generalizing index with
  | nil => simp at hindex
  | cons first tail ih =>
      cases tail with
      | nil => simp at hindex
      | cons second rest =>
          cases index with
          | zero => exact hcode.1
          | succ index =>
              simpa only [List.getElem_cons_succ, Nat.succ_eq_add_one,
                Nat.add_assoc] using ih hcode.2 index (by simpa using hindex)

/-- A fixed coherent family supplied by Konig's lemma. -/
noncomputable def coherentSelectedCodes {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) :
    (depth : Nat) -> SelectedCodeAtDepth hne depth :=
  Classical.choose (exists_coherent_selectedCodes hne)

theorem coherentSelectedCodes_projection {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) {i j : Nat} (hij : i <= j) :
    prefixProjection (hne := hne) hij (coherentSelectedCodes hne j) =
      coherentSelectedCodes hne i :=
  Classical.choose_spec (exists_coherent_selectedCodes hne) hij

/-- The new packed action appearing between coherent depths `n` and `n+1`. -/
noncomputable def coherentPackedAction {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (n : Nat) : PackedSourceAction p :=
  (coherentSelectedCodes hne (n + 1)).1[n]'(by
    rw [(coherentSelectedCodes hne (n + 1)).2.1]
    omega)

theorem coherentSelectedCodes_succ {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (n : Nat) :
    (coherentSelectedCodes hne (n + 1)).1 =
      (coherentSelectedCodes hne n).1 ++ [coherentPackedAction hne n] := by
  have hprojection := coherentSelectedCodes_projection hne
    (show n <= n + 1 by omega)
  have htake : (coherentSelectedCodes hne (n + 1)).1.take n =
      (coherentSelectedCodes hne n).1 := by
    exact congrArg Subtype.val hprojection
  let code := (coherentSelectedCodes hne (n + 1)).1
  have hlength : code.length = n + 1 :=
    (coherentSelectedCodes hne (n + 1)).2.1
  calc
    code = code.take (n + 1) := by simp [hlength]
    _ = code.take n ++ [code[n]] := by
      symm
      exact List.take_concat_get' code n (by omega)
    _ = (coherentSelectedCodes hne n).1 ++
        [coherentPackedAction hne n] := by
      rw [htake]
      rfl

/-- Infinite packed stream determined by the coherent finite prefixes. -/
noncomputable def coherentPackedStream {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) : Stream' (PackedSourceAction p) :=
  fun n => coherentPackedAction hne n

theorem coherentPackedStream_take {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (n : Nat) :
    (coherentPackedStream hne).take n = (coherentSelectedCodes hne n).1 := by
  induction n with
  | zero =>
      have hlength := (coherentSelectedCodes hne 0).2.1
      simpa using List.eq_nil_of_length_eq_zero hlength
  | succ n ih =>
      rw [Stream'.take_succ', ih, coherentSelectedCodes_succ]
      rfl

theorem coherentPackedStream_adjacent {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (n : Nat) :
    ((coherentPackedStream hne).get n).2.target hp =
      ((coherentPackedStream hne).get (n + 1)).1 := by
  let code := (coherentPackedStream hne).take (n + 2)
  have hcoherent : PackedChainCoherent hp code := by
    dsimp only [code]
    rw [coherentPackedStream_take]
    exact selectedCodeAtDepth_chainCoherent (coherentSelectedCodes hne (n + 2))
  have hadjacent := hcoherent.get_adjacent n (by
    dsimp only [code]
    simp)
  have hn : n < code.length := by simp [code]
  have hn1 : n + 1 < code.length := by simp [code]
  have hfirst : code[n]'hn = (coherentPackedStream hne).get n := by
    have hget := Stream'.getElem?_take
      (s := coherentPackedStream hne) (k := n) (n := n + 2) (by omega)
    simpa [code, List.getElem?_eq_getElem] using hget
  have hsecond : code[n + 1]'hn1 =
      (coherentPackedStream hne).get (n + 1) := by
    have hget := Stream'.getElem?_take
      (s := coherentPackedStream hne) (k := n + 1) (n := n + 2) (by omega)
    simpa [code, List.getElem?_eq_getElem] using hget
  rw [hfirst, hsecond] at hadjacent
  exact hadjacent

/-- The coherent typed infinite source branch extracted from a nonterminating
provenanced scheduler. -/
noncomputable def extractedInfiniteSourceWalk {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) : GeneralKInfiniteBranchDescent.InfiniteSourceWalk hp where
  modes n := ((coherentPackedStream hne).get n).1
  actions n := ((coherentPackedStream hne).get n).2
  target_next n := coherentPackedStream_adjacent hne n

theorem sourceWalkActionList_castSourceWalk {p : Nat} {hp : 1 <= p}
    {source target source' target' : TrackedMode (p + 1)}
    (hsource : source = source') (htarget : target = target')
    (walk : SourceWalk hp source target) :
    sourceWalkActionList
        (GeneralKInfiniteBranchDescent.InfiniteSourceWalk.castSourceWalk
          hsource htarget walk) = sourceWalkActionList walk := by
  subst source'
  subst target'
  rfl

theorem extractedInfiniteSourceWalk_segment_code {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (start length : Nat) :
    sourceWalkActionList
        ((extractedInfiniteSourceWalk hne).segment start length) =
      ((coherentPackedStream hne).drop start).take length := by
  induction length generalizing start with
  | zero => rfl
  | succ length ih =>
      simp only [GeneralKInfiniteBranchDescent.InfiniteSourceWalk.segment,
        sourceWalkActionList_cons, sourceWalkActionList_castSourceWalk,
        Stream'.take_succ,
        Stream'.head_drop, Stream'.tail_drop']
      rw [ih]
      simp only [extractedInfiniteSourceWalk]

theorem extractedInfiniteSourceWalk_prefix_code {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (length : Nat) :
    sourceWalkActionList
        ((extractedInfiniteSourceWalk hne).segment 0 length) =
      (coherentSelectedCodes hne length).1 := by
  rw [extractedInfiniteSourceWalk_segment_code]
  simp [coherentPackedStream_take]

theorem extractedInfiniteSourceWalk_prefix_isSelected {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hne : NeverStops initial y) (length : Nat) :
    IsSelectedCodePrefix hne
      (sourceWalkActionList
        ((extractedInfiniteSourceWalk hne).segment 0 length)) := by
  rw [extractedInfiniteSourceWalk_prefix_code]
  exact (coherentSelectedCodes hne length).2.2

theorem allStrictPrefixesNonnegative_criticalScheduledStep
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (htree : AllStrictPrefixesNonnegative root tree) (y : Real) :
    AllStrictPrefixesNonnegative root (criticalScheduledStep tree y) := by
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

theorem run_allStrictPrefixesNonnegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {initial : GeneralKSourceGenealogy.ProvenancedTree hp root}
    (hinitial : AllStrictPrefixesNonnegative root initial) (y : Real) :
    forall n, AllStrictPrefixesNonnegative root (run initial y n) := by
  intro n
  induction n with
  | zero => exact hinitial
  | succ n ih => exact allStrictPrefixesNonnegative_criticalScheduledStep ih y

theorem selectedCodePrefix_nonnegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {initial : GeneralKSourceGenealogy.ProvenancedTree hp root} {y : Real}
    (hinitial : AllStrictPrefixesNonnegative root initial)
    (hne : NeverStops initial y) {code : List (PackedSourceAction p)}
    (hcode : IsSelectedCodePrefix hne code) :
    0 <= root.shift.eval + packedWeightEval code := by
  obtain ⟨time, hprefix⟩ := hcode
  let selected := selectedOccurrence hne time
  let occurrence := selected.occurrence
  have htree := run_allStrictPrefixesNonnegative hinitial y time
  have hstrict := target_strictPrefixesNonnegative occurrence.path htree
  obtain ⟨suffix, hfull⟩ := hprefix
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
    simpa only [htake] using hstrict code.length hlt
  · have heqLength : code.length = occurrence.target.walk.length := by omega
    have hsuffixLength : suffix.length = 0 := by omega
    have hsuffix : suffix = [] := List.eq_nil_of_length_eq_zero hsuffixLength
    subst suffix
    simp only [List.append_nil] at hfull
    rw [hfull, packedWeightEval_sourceWalkActionList]
    simpa only [provenancedLabel_shift_eval_eq] using
      occurrence.shift_nonnegative

theorem extractedInfiniteSourceWalk_shiftsNonnegative
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)} {y : Real}
    (hne : NeverStops (GeneralKSourceGenealogy.ProvenancedTree.initial hp root) y) :
    GeneralKInfiniteBranchDescent.InfiniteSourceWalk.ShiftsNonnegative
      (extractedInfiniteSourceWalk hne) root.shift.eval := by
  intro n
  have hselected := extractedInfiniteSourceWalk_prefix_isSelected hne n
  have hnonnegative := selectedCodePrefix_nonnegative
    (AllStrictPrefixesNonnegative.initial hp root) hne hselected
  rw [GeneralKInfiniteBranchDescent.InfiniteSourceWalk.beta,
    ← (extractedInfiniteSourceWalk hne).segment_weight_eval]
  rw [← packedWeightEval_sourceWalkActionList]
  exact hnonnegative

end GeneralKCriticalInfiniteBranchExtraction

end KL2003
end CollatzClassical
