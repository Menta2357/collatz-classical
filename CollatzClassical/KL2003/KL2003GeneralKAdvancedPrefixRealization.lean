import CollatzClassical.KL2003.KL2003GeneralKProvenanceTrace
import CollatzClassical.KL2003.KL2003GeneralKAdvancedRecurrence

namespace CollatzClassical
namespace KL2003
namespace GeneralKAdvancedPrefixRealization

/-!
Transfer witness-free retained advanced prefixes from finite scheduler runs to
the coherent infinite source branch.  The remaining scheduler obligation is
packaged as concrete terminal realizations, not as the desired inequality.
-/

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler
open GeneralKInfiniteBranchExtraction
open GeneralKExtractedBranchNonnegative
open GeneralKInfiniteBranchDescent
open GeneralKAdvancedRecurrence
open GeneralKProvenanceTrace

theorem advancePackedShift_eval {p : Nat} (shift : SymbolicShift)
    (code : List (PackedSourceAction p)) :
    (advancePackedShift shift code).eval =
      shift.eval + packedWeightEval code := by
  induction code generalizing shift with
  | nil => simp [advancePackedShift, packedWeightEval, SymbolicShift.eval_zero]
  | cons action tail ih =>
      simp only [advancePackedShift, packedWeightEval, List.map_cons,
        List.sum_cons]
      rw [ih, SymbolicShift.eval_add]
      simp only [packedWeightEval]
      ring

theorem packedPrefixLabels_length {p : Nat} (shift : SymbolicShift)
    (code : List (PackedSourceAction p)) :
    (packedPrefixLabels shift code).length = code.length := by
  induction code generalizing shift with
  | nil => rfl
  | cons action tail ih => simp [packedPrefixLabels, ih]

theorem packedPrefixLabels_get_mode {p : Nat} (shift : SymbolicShift)
    (code : List (PackedSourceAction p)) (index : Nat)
    (hindex : index < code.length) :
    ((packedPrefixLabels shift code)[index]'(by
      simpa [packedPrefixLabels_length] using hindex)).mode =
      (code[index]'hindex).1 := by
  induction code generalizing shift index with
  | nil => simp at hindex
  | cons action tail ih =>
      cases index with
      | zero => rfl
      | succ index =>
          simpa only [packedPrefixLabels, List.getElem_cons_succ] using
            ih (shift + action.2.weight) index (by simpa using hindex)

theorem packedPrefixLabels_get_shift {p : Nat} (shift : SymbolicShift)
    (code : List (PackedSourceAction p)) (index : Nat)
    (hindex : index < code.length) :
    ((packedPrefixLabels shift code)[index]'(by
      simpa [packedPrefixLabels_length] using hindex)).shift =
      advancePackedShift shift (code.take index) := by
  induction code generalizing shift index with
  | nil => simp at hindex
  | cons action tail ih =>
      cases index with
      | zero => rfl
      | succ index =>
          simpa only [packedPrefixLabels, List.getElem_cons_succ,
            List.take_succ_cons, advancePackedShift] using
            ih (shift + action.2.weight) index (by simpa using hindex)

theorem advancePackedShift_extractedPrefix_eval
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (hne : GeneralKProvenancedScheduler.ProvenancedTree.NeverStops
      (ProvenancedTree.initial hp root)) (length : Nat) :
    (advancePackedShift root.shift
      ((coherentPackedStream hne).take length)).eval =
      (extractedInfiniteSourceWalk hne).beta root.shift.eval length := by
  rw [advancePackedShift_eval]
  have hcode : sourceWalkActionList
      ((extractedInfiniteSourceWalk hne).segment 0 length) =
      (coherentPackedStream hne).take length := by
    simpa using extractedInfiniteSourceWalk_segment_code hne 0 length
  rw [← hcode]
  rw [packedWeightEval_sourceWalkActionList]
  rw [InfiniteSourceWalk.beta,
    ← (extractedInfiniteSourceWalk hne).segment_weight_eval]

/-- A concrete witness-free terminal realization of one coherent advanced
prefix.  Its data all live in an actual finite scheduler run. -/
structure WitnessFreeAdvancedPrefixRealization
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (hne : GeneralKProvenancedScheduler.ProvenancedTree.NeverStops
      (ProvenancedTree.initial hp root))
    (arrival : Nat) where
  time : Nat
  target : ProvenancedLabel hp root
  path : ProvenancedTree.TerminalPath
    (ProvenancedTree.run (ProvenancedTree.initial hp root) time) target
  code_eq : sourceWalkActionList target.walk =
    (coherentPackedStream hne).take (arrival + 1)
  target_mode_eq : target.label.mode =
    (extractedInfiniteSourceWalk hne).modes (arrival + 1)
  noDeletionWitness : ¬ path.forgetPath.HasDeletionWitness

/-- Every advanced prefix of the coherent branch is realized by a retained
witness-free terminal in some finite run. -/
def AllAdvancedPrefixesWitnessFree
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (hne : GeneralKProvenancedScheduler.ProvenancedTree.NeverStops
      (ProvenancedTree.initial hp root)) : Prop :=
  forall arrival : Nat,
    IsAdvancedAction ((extractedInfiniteSourceWalk hne).actions arrival) ->
      Nonempty (WitnessFreeAdvancedPrefixRealization hne arrival)

theorem target_shift_eval_eq_beta
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {hne : GeneralKProvenancedScheduler.ProvenancedTree.NeverStops
      (ProvenancedTree.initial hp root)} {arrival : Nat}
    (realization : WitnessFreeAdvancedPrefixRealization hne arrival) :
    realization.target.label.shift.eval =
      (extractedInfiniteSourceWalk hne).beta root.shift.eval (arrival + 1) := by
  rw [provenancedLabel_shift_eval_eq]
  rw [← packedWeightEval_sourceWalkActionList realization.target.walk]
  rw [realization.code_eq]
  rw [← advancePackedShift_extractedPrefix_eval hne (arrival + 1)]
  exact (advancePackedShift_eval root.shift
    ((coherentPackedStream hne).take (arrival + 1))).symm

theorem earlier_prefix_label
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {hne : GeneralKProvenancedScheduler.ProvenancedTree.NeverStops
      (ProvenancedTree.initial hp root)} {arrival earlier : Nat}
    (realization : WitnessFreeAdvancedPrefixRealization hne arrival)
    (hearlier : earlier < arrival + 1) :
    exists ancestor : ELLabel (p + 1),
      ancestor ∈ packedPrefixLabels root.shift
        (sourceWalkActionList realization.target.walk) /\
      ancestor.mode = (extractedInfiniteSourceWalk hne).modes earlier /\
      ancestor.shift.eval =
        (extractedInfiniteSourceWalk hne).beta root.shift.eval earlier := by
  let code := sourceWalkActionList realization.target.walk
  have hcodeLength : code.length = arrival + 1 := by
    dsimp only [code]
    rw [realization.code_eq]
    simp
  have hcodeIndex : earlier < code.length := by omega
  have hlabelsIndex : earlier < (packedPrefixLabels root.shift code).length := by
    simpa only [packedPrefixLabels_length] using hcodeIndex
  let ancestor : ELLabel (p + 1) :=
    (packedPrefixLabels root.shift code)[earlier]'hlabelsIndex
  refine ⟨ancestor, ?_, ?_, ?_⟩
  · exact List.getElem_mem _
  · dsimp only [ancestor]
    rw [packedPrefixLabels_get_mode root.shift code earlier hcodeIndex]
    have hget : code[earlier]'hcodeIndex =
        (coherentPackedStream hne).get earlier := by
      have hstream := Stream'.getElem?_take
        (s := coherentPackedStream hne) (k := earlier)
        (n := arrival + 1) hearlier
      simpa [code, realization.code_eq, List.getElem?_eq_getElem] using hstream
    rw [hget]
    rfl
  · dsimp only [ancestor]
    rw [packedPrefixLabels_get_shift root.shift code earlier hcodeIndex]
    have htake : code.take earlier =
        (coherentPackedStream hne).take earlier := by
      rw [show code = (coherentPackedStream hne).take (arrival + 1) from
        realization.code_eq]
      simp [List.take_take, Nat.min_eq_right (Nat.le_of_lt hearlier)]
    rw [htake]
    exact advancePackedShift_extractedPrefix_eval hne earlier

/-- Concrete witness-free realizations imply the branch-level monotonicity
contract consumed by advanced recurrence. -/
theorem advancedArrivalsNonincreasing_of_allAdvancedPrefixesWitnessFree
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (hne : GeneralKProvenancedScheduler.ProvenancedTree.NeverStops
      (ProvenancedTree.initial hp root))
    (hall : AllAdvancedPrefixesWitnessFree hne) :
    AdvancedArrivalsNonincreasing
      (extractedInfiniteSourceWalk hne) root.shift.eval := by
  intro arrival hadvanced earlier hearlier hmodes
  let realization := Classical.choice (hall arrival hadvanced)
  obtain ⟨ancestor, hmem, hancestorMode, hancestorShift⟩ :=
    earlier_prefix_label realization hearlier
  have htargetNonnegative : 0 <= realization.target.label.shift.eval := by
    rw [target_shift_eval_eq_beta realization]
    exact extractedInfiniteSourceWalk_shiftsNonnegative hne (arrival + 1)
  have hmode : ancestor.mode = realization.target.label.mode := by
    rw [hancestorMode, hmodes, realization.target_mode_eq]
  have hle := target_shift_le_ancestor_shift_of_noDeletionWitness
    realization.path
    (run_initial_traceConsistent hp root realization.time)
    htargetNonnegative realization.noDeletionWitness hmem hmode
  rw [target_shift_eval_eq_beta realization, hancestorShift] at hle
  exact hle

/-- The concrete realization contract supplies the full strict recurrent
descent conclusion for the branch extracted from a nonterminating scheduler. -/
theorem extracted_exists_strictly_decreasing_recurrent_advanced_arrivals
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (hne : GeneralKProvenancedScheduler.ProvenancedTree.NeverStops
      (ProvenancedTree.initial hp root))
    (hall : AllAdvancedPrefixesWitnessFree hne) :
    exists mode : TrackedMode (p + 1), exists positions : Nat -> Nat,
      StrictMono positions /\
        (forall j : Nat,
          IsAdvancedAction
            ((extractedInfiniteSourceWalk hne).actions (positions j))) /\
          (forall j : Nat,
            (extractedInfiniteSourceWalk hne).modes (positions j + 1) = mode) /\
            (forall j : Nat,
              (extractedInfiniteSourceWalk hne).beta root.shift.eval
                  (positions (j + 1) + 1) <
                (extractedInfiniteSourceWalk hne).beta root.shift.eval
                  (positions j + 1)) := by
  exact exists_strictly_decreasing_recurrent_advanced_arrivals
    (extractedInfiniteSourceWalk hne) root.shift.eval
    (extractedInfiniteSourceWalk_shiftsNonnegative hne)
    (advancedArrivalsNonincreasing_of_allAdvancedPrefixesWitnessFree hne hall)

end GeneralKAdvancedPrefixRealization
end KL2003
end CollatzClassical
