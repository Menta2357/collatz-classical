import CollatzClassical.KL2003.KL2003GeneralKCriticalInfiniteBranchExtraction
import CollatzClassical.KL2003.KL2003GeneralKAdvancedPrefixRealization

namespace CollatzClassical
namespace KL2003

namespace GeneralKCriticalAdvancedDominance

/-!
Advanced-arrival dominance for the critical scheduler.

The invariant is intrinsic to each stored source genealogy.  A retained D1 or
D3 child inherits its new final-arrival inequality from the corresponding raw
`AdvancedMinConfiguration` path and `RetainedBranchesWitnessFree`; prior
arrivals are inherited from the parent genealogy.  Iterating this invariant
over the critical run and restricting it to the coherent Konig branch proves
the exact `AdvancedArrivalsNonincreasing` contract used by recurrence, without
assuming historical realizations or introducing a second scheduler interface.
-/

open GeneralKSourceGraph
open GeneralKNestedReturnDescent
open GeneralKSourceGenealogy
open GeneralKCriticalScheduler
open GeneralKCriticalInfiniteBranchExtraction
open GeneralKExtractedBranchNonnegative
open GeneralKInfiniteBranchDescent
open GeneralKAdvancedRecurrence
open GeneralKAdvancedPrefixRealization
open GeneralKProvenanceTrace

open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler

def AdvancedPrefixDominatesEarlier {p : Nat}
    (hp : 1 <= p) (initial : Real)
    (code : List (PackedSourceAction p)) : Prop :=
  forall (arrival : Nat) (harrival : arrival < code.length),
    IsAdvancedAction (code[arrival]'(by omega)).2 ->
      0 <= (advancePackedShift SymbolicShift.zero
          (code.take (arrival + 1))).eval + initial ->
        forall (earlier : Nat) (hearlier : earlier < arrival + 1),
          (code[earlier]'(by omega)).1 =
              (code[arrival]'harrival).2.target hp ->
            (advancePackedShift SymbolicShift.zero
                (code.take (arrival + 1))).eval + initial <=
              (advancePackedShift SymbolicShift.zero
                (code.take earlier)).eval + initial

def AllSelectedPrefixesAdvancedDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)} {y : Real}
    (hne : NeverStops (ProvenancedTree.initial hp root) y) : Prop :=
  forall code : List (PackedSourceAction p),
    IsSelectedCodePrefix hne code ->
      AdvancedPrefixDominatesEarlier hp root.shift.eval code

theorem AdvancedPrefixDominatesEarlier.of_isPrefix
    {p : Nat} {hp : 1 <= p} {initial : Real}
    {shortCode full : List (PackedSourceAction p)}
    (hfull : AdvancedPrefixDominatesEarlier hp initial full)
    (hprefix : shortCode <+: full) :
    AdvancedPrefixDominatesEarlier hp initial shortCode := by
  obtain ⟨suffix, rfl⟩ := hprefix
  intro arrival harrival hadvanced hnonnegative earlier hearlier hmodes
  have harrivalFull : arrival < (shortCode ++ suffix).length := by simp; omega
  have hearlierPrefix : earlier < shortCode.length := by omega
  have harrivalGet :
      (shortCode ++ suffix)[arrival]'harrivalFull =
        shortCode[arrival]'harrival :=
    List.getElem_append_left harrival
  have hearlierGet :
      (shortCode ++ suffix)[earlier]'(by omega) =
        shortCode[earlier]'hearlierPrefix :=
    List.getElem_append_left hearlierPrefix
  have harrivalTake : (shortCode ++ suffix).take (arrival + 1) =
      shortCode.take (arrival + 1) := by
    rw [List.take_append_of_le_length]
    omega
  have hearlierTake : (shortCode ++ suffix).take earlier =
      shortCode.take earlier := by
    rw [List.take_append_of_le_length]
    omega
  have hle := hfull arrival harrivalFull
    (by rwa [harrivalGet]) (by rwa [harrivalTake])
    earlier hearlier (by rwa [harrivalGet, hearlierGet])
  rwa [harrivalTake, hearlierTake] at hle

theorem advancePackedShift_zero_eval_add
    {p : Nat} (initial : SymbolicShift)
    (code : List (PackedSourceAction p)) :
    (advancePackedShift initial code).eval =
      initial.eval + (advancePackedShift SymbolicShift.zero code).eval := by
  induction code generalizing initial with
  | nil => simp [advancePackedShift, SymbolicShift.eval_zero]
  | cons action tail ih =>
      simp only [advancePackedShift]
      rw [ih, ih (SymbolicShift.zero + action.2.weight)]
      rw [SymbolicShift.eval_add, SymbolicShift.eval_add,
        SymbolicShift.eval_zero]
      ring

theorem advancePackedShift_extractedPrefix_eval
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)} {y : Real}
    (hne : NeverStops (ProvenancedTree.initial hp root) y)
    (length : Nat) :
    (advancePackedShift root.shift
      ((coherentPackedStream hne).take length)).eval =
      (extractedInfiniteSourceWalk hne).beta root.shift.eval length := by
  rw [advancePackedShift_eval]
  have hcode : sourceWalkActionList
      ((extractedInfiniteSourceWalk hne).segment 0 length) =
      (coherentPackedStream hne).take length := by
    simpa using extractedInfiniteSourceWalk_segment_code hne 0 length
  rw [← hcode, packedWeightEval_sourceWalkActionList]
  rw [InfiniteSourceWalk.beta,
    ← (extractedInfiniteSourceWalk hne).segment_weight_eval]

theorem advancedArrivalsNonincreasing_of_allSelectedPrefixesAdvancedDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)} {y : Real}
    (hne : NeverStops (ProvenancedTree.initial hp root) y)
    (hall : AllSelectedPrefixesAdvancedDominance hne) :
    AdvancedArrivalsNonincreasing
      (extractedInfiniteSourceWalk hne) root.shift.eval := by
  intro arrival hadvanced earlier hearlier hmodes
  let code := (coherentPackedStream hne).take (arrival + 1)
  have hcodeLength : code.length = arrival + 1 := by simp [code]
  have hselected : IsSelectedCodePrefix hne code := by
    dsimp only [code]
    rw [coherentPackedStream_take]
    exact (coherentSelectedCodes hne (arrival + 1)).2.2
  have hdom := hall code hselected arrival (by omega)
  have harrivalPacked :
      code[arrival]'(by omega) = (coherentPackedStream hne).get arrival := by
    have hget := Stream'.getElem?_take
      (s := coherentPackedStream hne) (k := arrival)
      (n := arrival + 1) (by omega)
    simpa [code, List.getElem?_eq_getElem] using hget
  have hadvancedCode : IsAdvancedAction (code[arrival]'(by omega)).2 := by
    rw [harrivalPacked]
    exact hadvanced
  have htargetMode :
      (code[arrival]'(by omega)).2.target hp =
        (extractedInfiniteSourceWalk hne).modes (arrival + 1) := by
    rw [harrivalPacked]
    exact (extractedInfiniteSourceWalk hne).target_next arrival
  have hearlierMode :
      (code[earlier]'(by omega)).1 =
        (extractedInfiniteSourceWalk hne).modes earlier := by
    have hget := Stream'.getElem?_take
      (s := coherentPackedStream hne) (k := earlier)
      (n := arrival + 1) (by omega)
    simpa [code, List.getElem?_eq_getElem,
      extractedInfiniteSourceWalk] using congrArg Sigma.fst hget
  have hnonnegative :
      0 <= (advancePackedShift SymbolicShift.zero
          (code.take (arrival + 1))).eval + root.shift.eval := by
    have htake : code.take (arrival + 1) =
        (coherentPackedStream hne).take (arrival + 1) := by
      simp [code]
    rw [htake, add_comm,
      ← advancePackedShift_zero_eval_add root.shift
        ((coherentPackedStream hne).take (arrival + 1)),
      advancePackedShift_extractedPrefix_eval hne (arrival + 1)]
    exact extractedInfiniteSourceWalk_shiftsNonnegative hne (arrival + 1)
  have hle := hdom hadvancedCode hnonnegative
    earlier hearlier (by rw [hearlierMode, htargetMode, hmodes])
  have harrivalTake : code.take (arrival + 1) =
      (coherentPackedStream hne).take (arrival + 1) := by
    simp [code, List.take_take]
  have hearlierTake : code.take earlier =
      (coherentPackedStream hne).take earlier := by
    dsimp only [code]
    rw [Stream'.take_take, Nat.min_eq_right (by omega)]
  rw [harrivalTake, hearlierTake] at hle
  have harrivalEq :
      (advancePackedShift SymbolicShift.zero
          ((coherentPackedStream hne).take (arrival + 1))).eval +
          root.shift.eval =
        (extractedInfiniteSourceWalk hne).beta
          root.shift.eval (arrival + 1) := by
    rw [add_comm,
      ← advancePackedShift_zero_eval_add root.shift
        ((coherentPackedStream hne).take (arrival + 1)),
      advancePackedShift_extractedPrefix_eval hne (arrival + 1)]
  have hearlierEq :
      (advancePackedShift SymbolicShift.zero
          ((coherentPackedStream hne).take earlier)).eval + root.shift.eval =
        (extractedInfiniteSourceWalk hne).beta root.shift.eval earlier := by
    rw [add_comm,
      ← advancePackedShift_zero_eval_add root.shift
        ((coherentPackedStream hne).take earlier),
      advancePackedShift_extractedPrefix_eval hne earlier]
  rwa [harrivalEq, hearlierEq] at hle

theorem ELTree.Context.expandedLabels_comp
    {k : Nat} (outer inner : ELTree.Context k) :
    (outer.comp inner).expandedLabels =
      outer.expandedLabels ++ inner.expandedLabels := by
  induction outer <;>
    simp [ELTree.Context.comp, ELTree.Context.expandedLabels, *]

theorem ELTree.TerminalPath.AdvancedMinConfiguration.firstPath_context_transport
    {k : Nat} {tree tree' : ELTree k} {first second third : ELLabel k}
    (h : tree = tree')
    (configuration : ELTree.TerminalPath.AdvancedMinConfiguration
      tree first second third) :
    ((h ▸ configuration).firstPath).context =
      configuration.firstPath.context := by
  subst tree'
  rfl

theorem ELTree.TerminalPath.AdvancedMinConfiguration.secondPath_context_transport
    {k : Nat} {tree tree' : ELTree k} {first second third : ELLabel k}
    (h : tree = tree')
    (configuration : ELTree.TerminalPath.AdvancedMinConfiguration
      tree first second third) :
    ((h ▸ configuration).secondPath).context =
      configuration.secondPath.context := by
  subst tree'
  rfl

theorem ELTree.TerminalPath.AdvancedMinConfiguration.thirdPath_context_transport
    {k : Nat} {tree tree' : ELTree k} {first second third : ELLabel k}
    (h : tree = tree')
    (configuration : ELTree.TerminalPath.AdvancedMinConfiguration
      tree first second third) :
    ((h ▸ configuration).thirdPath).context =
      configuration.thirdPath.context := by
  subst tree'
  rfl

theorem sourceD1_firstPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) :
    (ELTree.TerminalPath.sourceD1AdvancedConfigurationData hp label hm
      ).firstPath.context.expandedLabels = [label] := by
  unfold ELTree.TerminalPath.sourceD1AdvancedConfigurationData
  rw [ELTree.TerminalPath.AdvancedMinConfiguration.firstPath_context_transport]
  rfl

theorem sourceD1_secondPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) :
    (ELTree.TerminalPath.sourceD1AdvancedConfigurationData hp label hm
      ).secondPath.context.expandedLabels = [label] := by
  unfold ELTree.TerminalPath.sourceD1AdvancedConfigurationData
  rw [ELTree.TerminalPath.AdvancedMinConfiguration.secondPath_context_transport]
  rfl

theorem sourceD1_thirdPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 2) :
    (ELTree.TerminalPath.sourceD1AdvancedConfigurationData hp label hm
      ).thirdPath.context.expandedLabels = [label] := by
  unfold ELTree.TerminalPath.sourceD1AdvancedConfigurationData
  rw [ELTree.TerminalPath.AdvancedMinConfiguration.thirdPath_context_transport]
  rfl

theorem sourceD3_firstPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) :
    (ELTree.TerminalPath.sourceD3AdvancedConfigurationData hp label hm
      ).firstPath.context.expandedLabels = [label] := by
  unfold ELTree.TerminalPath.sourceD3AdvancedConfigurationData
  rw [ELTree.TerminalPath.AdvancedMinConfiguration.firstPath_context_transport]
  rfl

theorem sourceD3_secondPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) :
    (ELTree.TerminalPath.sourceD3AdvancedConfigurationData hp label hm
      ).secondPath.context.expandedLabels = [label] := by
  unfold ELTree.TerminalPath.sourceD3AdvancedConfigurationData
  rw [ELTree.TerminalPath.AdvancedMinConfiguration.secondPath_context_transport]
  rfl

theorem sourceD3_thirdPath_expandedLabels
    {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1))
    (hm : label.mode.1.1 % 9 = 8) :
    (ELTree.TerminalPath.sourceD3AdvancedConfigurationData hp label hm
      ).thirdPath.context.expandedLabels = [label] := by
  unfold ELTree.TerminalPath.sourceD3AdvancedConfigurationData
  rw [ELTree.TerminalPath.AdvancedMinConfiguration.thirdPath_context_transport]
  rfl

theorem d1Configuration_firstPath_expandedLabels
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2) :
    (occurrence.forgetOccurrence.d1Configuration hp hm
      ).firstPath.context.expandedLabels =
      occurrence.path.forgetPath.context.expandedLabels ++
        [occurrence.target.label] := by
  unfold ELTree.ExpandableOccurrence.d1Configuration
  unfold ELTree.TerminalPath.AdvancedMinConfiguration.descendSplit
  rw [ELTree.TerminalPath.context_descendSplit,
    ELTree.Context.expandedLabels_comp,
    sourceD1_firstPath_expandedLabels]
  rfl

theorem d1Configuration_secondPath_expandedLabels
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2) :
    (occurrence.forgetOccurrence.d1Configuration hp hm
      ).secondPath.context.expandedLabels =
      occurrence.path.forgetPath.context.expandedLabels ++
        [occurrence.target.label] := by
  unfold ELTree.ExpandableOccurrence.d1Configuration
  unfold ELTree.TerminalPath.AdvancedMinConfiguration.descendSplit
  rw [ELTree.TerminalPath.context_descendSplit,
    ELTree.Context.expandedLabels_comp,
    sourceD1_secondPath_expandedLabels]
  rfl

theorem d1Configuration_thirdPath_expandedLabels
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2) :
    (occurrence.forgetOccurrence.d1Configuration hp hm
      ).thirdPath.context.expandedLabels =
      occurrence.path.forgetPath.context.expandedLabels ++
        [occurrence.target.label] := by
  unfold ELTree.ExpandableOccurrence.d1Configuration
  unfold ELTree.TerminalPath.AdvancedMinConfiguration.descendSplit
  rw [ELTree.TerminalPath.context_descendSplit,
    ELTree.Context.expandedLabels_comp,
    sourceD1_thirdPath_expandedLabels]
  rfl

theorem d3Configuration_firstPath_expandedLabels
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8) :
    (occurrence.forgetOccurrence.d3Configuration hp hm
      ).firstPath.context.expandedLabels =
      occurrence.path.forgetPath.context.expandedLabels ++
        [occurrence.target.label] := by
  unfold ELTree.ExpandableOccurrence.d3Configuration
  unfold ELTree.TerminalPath.AdvancedMinConfiguration.descendSplit
  rw [ELTree.TerminalPath.context_descendSplit,
    ELTree.Context.expandedLabels_comp,
    sourceD3_firstPath_expandedLabels]
  rfl

theorem d3Configuration_secondPath_expandedLabels
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8) :
    (occurrence.forgetOccurrence.d3Configuration hp hm
      ).secondPath.context.expandedLabels =
      occurrence.path.forgetPath.context.expandedLabels ++
        [occurrence.target.label] := by
  unfold ELTree.ExpandableOccurrence.d3Configuration
  unfold ELTree.TerminalPath.AdvancedMinConfiguration.descendSplit
  rw [ELTree.TerminalPath.context_descendSplit,
    ELTree.Context.expandedLabels_comp,
    sourceD3_secondPath_expandedLabels]
  rfl

theorem d3Configuration_thirdPath_expandedLabels
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8) :
    (occurrence.forgetOccurrence.d3Configuration hp hm
      ).thirdPath.context.expandedLabels =
      occurrence.path.forgetPath.context.expandedLabels ++
        [occurrence.target.label] := by
  unfold ELTree.ExpandableOccurrence.d3Configuration
  unfold ELTree.TerminalPath.AdvancedMinConfiguration.descendSplit
  rw [ELTree.TerminalPath.context_descendSplit,
    ELTree.Context.expandedLabels_comp,
    sourceD3_thirdPath_expandedLabels]
  rfl

theorem raw_target_shift_le_ancestor_shift_of_noDeletionWitness
    {k : Nat} {tree : ELTree k} {target ancestor : ELLabel k}
    (path : ELTree.TerminalPath tree target)
    (htarget : 0 <= target.shift.eval)
    (hno : Not path.HasDeletionWitness)
    (hmem : ancestor ∈ path.context.expandedLabels)
    (hmode : ancestor.mode = target.mode) :
    target.shift.eval <= ancestor.shift.eval := by
  by_contra hnot
  apply hno
  change 0 <= target.shift.eval /\
    exists candidate,
      candidate ∈ path.context.expandedLabels /\
      candidate.mode = target.mode /\
      candidate.shift.eval < target.shift.eval
  exact ⟨htarget, ancestor, hmem, hmode, lt_of_not_ge hnot⟩

theorem provenancedLabel_shift_eval_eq_advancePackedShift
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root) :
    node.label.shift.eval =
      (advancePackedShift root.shift
        (sourceWalkActionList node.walk)).eval := by
  rw [advancePackedShift_sourceWalkActionList, node.shift_eq]

theorem provenancedLabel_shift_eval_eq_zero_advancePackedShift
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root) :
    node.label.shift.eval =
      (advancePackedShift SymbolicShift.zero
        (sourceWalkActionList node.walk)).eval + root.shift.eval := by
  rw [provenancedLabel_shift_eval_eq_advancePackedShift node,
    advancePackedShift_zero_eval_add]
  ring

def SameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root) : Prop :=
  forall (earlier : Nat)
    (hearlier : earlier < (sourceWalkActionList node.walk).length),
    ((sourceWalkActionList node.walk)[earlier]'hearlier).1 =
        node.label.mode ->
      0 <= node.label.shift.eval ->
        node.label.shift.eval <=
          (advancePackedShift SymbolicShift.zero
            ((sourceWalkActionList node.walk).take earlier)).eval +
              root.shift.eval

theorem dominatesSameModePrefixes_of_noDeletionWitness
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root)
    {tree : ELTree (p + 1)}
    (path : ELTree.TerminalPath tree node.label)
    (hlabels : path.context.expandedLabels =
      packedPrefixLabels root.shift (sourceWalkActionList node.walk))
    (hno : Not path.HasDeletionWitness) :
    SameModePrefixDominance node := by
  intro earlier hearlier hmode hnonnegative
  have hlabelsIndex : earlier <
      (packedPrefixLabels root.shift
        (sourceWalkActionList node.walk)).length := by
    simpa [packedPrefixLabels_length] using hearlier
  let ancestor := (packedPrefixLabels root.shift
    (sourceWalkActionList node.walk))[earlier]'hlabelsIndex
  have hancestorMem : ancestor ∈ path.context.expandedLabels := by
    rw [hlabels]
    exact List.getElem_mem _
  have hancestorMode : ancestor.mode = node.label.mode := by
    dsimp only [ancestor]
    rw [packedPrefixLabels_get_mode root.shift
      (sourceWalkActionList node.walk) earlier hearlier]
    exact hmode
  have hle := raw_target_shift_le_ancestor_shift_of_noDeletionWitness
    path hnonnegative hno hancestorMem hancestorMode
  have hancestorShift : ancestor.shift.eval =
      (advancePackedShift SymbolicShift.zero
        ((sourceWalkActionList node.walk).take earlier)).eval +
          root.shift.eval := by
    dsimp only [ancestor]
    rw [packedPrefixLabels_get_shift root.shift
      (sourceWalkActionList node.walk) earlier hearlier]
    rw [advancePackedShift_zero_eval_add]
    ring
  rwa [hancestorShift] at hle

def ProvenancedLabelAdvancedDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root) : Prop :=
  AdvancedPrefixDominatesEarlier hp root.shift.eval
    (sourceWalkActionList node.walk)

theorem provenancedLabelAdvancedDominance_root
    {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1)) :
    ProvenancedLabelAdvancedDominance (ProvenancedLabel.root hp root) := by
  intro arrival harrival
  change arrival < 0 at harrival
  omega

theorem ProvenancedLabelAdvancedDominance.child
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {node : ProvenancedLabel hp root}
    (hnode : ProvenancedLabelAdvancedDominance node)
    (action : SourceAction node.label.mode)
    (hfinal : IsAdvancedAction action ->
      SameModePrefixDominance (node.child action)) :
    ProvenancedLabelAdvancedDominance (node.child action) := by
  let parentCode := sourceWalkActionList node.walk
  let packed : PackedSourceAction p := ⟨node.label.mode, action⟩
  have hcode : sourceWalkActionList (node.child action).walk =
      parentCode ++ [packed] := by
    rw [ProvenancedLabel.child, sourceWalkActionList_append]
    rfl
  rw [ProvenancedLabelAdvancedDominance, hcode]
  intro arrival harrival hadvanced hnonnegative earlier hearlier hmodes
  by_cases hold : arrival < parentCode.length
  · have hearlierParent : earlier < parentCode.length := by omega
    have harrivalGet :
        (parentCode ++ [packed])[arrival]'harrival =
          parentCode[arrival]'hold := by
      exact List.getElem_append_left hold
    have hearlierGet :
        (parentCode ++ [packed])[earlier]'(by omega) =
          parentCode[earlier]'hearlierParent := by
      exact List.getElem_append_left hearlierParent
    have harrivalTake : (parentCode ++ [packed]).take (arrival + 1) =
        parentCode.take (arrival + 1) := by
      rw [List.take_append_of_le_length]
      omega
    have hearlierTake : (parentCode ++ [packed]).take earlier =
        parentCode.take earlier := by
      rw [List.take_append_of_le_length]
      omega
    rw [harrivalGet] at hadvanced hmodes
    rw [hearlierGet] at hmodes
    rw [harrivalTake] at hnonnegative
    rw [harrivalTake, hearlierTake]
    exact hnode arrival hold hadvanced hnonnegative earlier hearlier hmodes
  · have harrivalEq : arrival = parentCode.length := by
      simp at harrival
      omega
    subst arrival
    have hlastGet :
        (parentCode ++ [packed])[parentCode.length]'harrival = packed := by
      simp
    rw [hlastGet] at hadvanced hmodes
    have hfullTake :
        (parentCode ++ [packed]).take (parentCode.length + 1) =
          parentCode ++ [packed] := by simp
    have hnodeCode : sourceWalkActionList (node.child action).walk =
        parentCode ++ [packed] := hcode
    have hnonnegativeNode : 0 <= (node.child action).label.shift.eval := by
      rw [provenancedLabel_shift_eval_eq_zero_advancePackedShift,
        hnodeCode]
      rw [hfullTake] at hnonnegative
      exact hnonnegative
    have hfinalDom := hfinal hadvanced earlier (by simpa [hnodeCode])
      (by simpa [hnodeCode] using hmodes) hnonnegativeNode
    rw [provenancedLabel_shift_eval_eq_zero_advancePackedShift,
      hnodeCode] at hfinalDom
    rw [hfullTake]
    exact hfinalDom

def AllLabelsAdvancedDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)} :
    ProvenancedTree hp root -> Prop
  | .terminal node => ProvenancedLabelAdvancedDominance node
  | .expanded node body =>
      ProvenancedLabelAdvancedDominance node /\
        AllLabelsAdvancedDominance body
  | .add left right | .min2 left right =>
      AllLabelsAdvancedDominance left /\ AllLabelsAdvancedDominance right
  | .min3 first second third =>
      AllLabelsAdvancedDominance first /\
        AllLabelsAdvancedDominance second /\
          AllLabelsAdvancedDominance third

theorem allLabelsAdvancedDominance_initial
    {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1)) :
    AllLabelsAdvancedDominance (ProvenancedTree.initial hp root) :=
  provenancedLabelAdvancedDominance_root hp root

theorem target_advancedDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : AllLabelsAdvancedDominance tree) :
    ProvenancedLabelAdvancedDominance target := by
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

theorem AllLabelsAdvancedDominance.provenancedReplaceAt
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree replacement : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (htree : AllLabelsAdvancedDominance tree)
    (hreplacement : AllLabelsAdvancedDominance replacement) :
    AllLabelsAdvancedDominance
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

theorem ProvenancedLabelAdvancedDominance.retardedChild
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {node : ProvenancedLabel hp root}
    (hnode : ProvenancedLabelAdvancedDominance node) :
    ProvenancedLabelAdvancedDominance
      (node.child (retardedAction node.label.mode)) := by
  apply hnode.child
  intro hadvanced
  change False at hadvanced
  contradiction

theorem d1FirstChild_sameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2)
    (hno : Not
      ((occurrence.forgetOccurrence.d1Configuration hp hm).firstPath
        ).HasDeletionWitness) :
    SameModePrefixDominance
      (occurrence.target.child
        (d1AdvancedAction occurrence.target.label.mode hm 0)) := by
  let child := occurrence.target.child
    (d1AdvancedAction occurrence.target.label.mode hm 0)
  let configuration := occurrence.forgetOccurrence.d1Configuration hp hm
  have houter : occurrence.path.forgetPath.context.expandedLabels =
      packedPrefixLabels root.shift
        (sourceWalkActionList occurrence.target.walk) := by
    simpa using traceConsistentFrom_terminalPath occurrence.path htrace
  have hlabels : configuration.firstPath.context.expandedLabels =
      packedPrefixLabels root.shift (sourceWalkActionList child.walk) := by
    calc
      configuration.firstPath.context.expandedLabels =
          occurrence.path.forgetPath.context.expandedLabels ++
            [occurrence.target.label] :=
        d1Configuration_firstPath_expandedLabels occurrence hm
      _ = packedPrefixLabels root.shift
            (sourceWalkActionList occurrence.target.walk) ++
              [occurrence.target.label] := by rw [houter]
      _ = packedPrefixLabels root.shift
            (sourceWalkActionList child.walk) := by
        exact (packedPrefixLabels_provenancedChild occurrence.target
          (d1AdvancedAction occurrence.target.label.mode hm 0)).symm
  exact dominatesSameModePrefixes_of_noDeletionWitness child
    configuration.firstPath hlabels hno

theorem sourceChild_sameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (action : SourceAction occurrence.target.label.mode)
    {rawTree : ELTree (p + 1)}
    (path : ELTree.TerminalPath rawTree
      (occurrence.target.child action).label)
    (hcontext : path.context.expandedLabels =
      occurrence.path.forgetPath.context.expandedLabels ++
        [occurrence.target.label])
    (hno : Not path.HasDeletionWitness) :
    SameModePrefixDominance (occurrence.target.child action) := by
  have houter : occurrence.path.forgetPath.context.expandedLabels =
      packedPrefixLabels root.shift
        (sourceWalkActionList occurrence.target.walk) := by
    simpa using traceConsistentFrom_terminalPath occurrence.path htrace
  have hlabels : path.context.expandedLabels =
      packedPrefixLabels root.shift
        (sourceWalkActionList (occurrence.target.child action).walk) := by
    calc
      path.context.expandedLabels =
          occurrence.path.forgetPath.context.expandedLabels ++
            [occurrence.target.label] := hcontext
      _ = packedPrefixLabels root.shift
            (sourceWalkActionList occurrence.target.walk) ++
              [occurrence.target.label] := by rw [houter]
      _ = packedPrefixLabels root.shift
            (sourceWalkActionList (occurrence.target.child action).walk) :=
        (packedPrefixLabels_provenancedChild occurrence.target action).symm
  exact dominatesSameModePrefixes_of_noDeletionWitness
    (occurrence.target.child action) path hlabels hno

theorem d1SecondChild_sameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2)
    (hno : Not
      ((occurrence.forgetOccurrence.d1Configuration hp hm).secondPath
        ).HasDeletionWitness) :
    SameModePrefixDominance
      (occurrence.target.child
        (d1AdvancedAction occurrence.target.label.mode hm 1)) := by
  exact sourceChild_sameModePrefixDominance occurrence htrace _ _
    (d1Configuration_secondPath_expandedLabels occurrence hm) hno

theorem d1ThirdChild_sameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2)
    (hno : Not
      ((occurrence.forgetOccurrence.d1Configuration hp hm).thirdPath
        ).HasDeletionWitness) :
    SameModePrefixDominance
      (occurrence.target.child
        (d1AdvancedAction occurrence.target.label.mode hm 2)) := by
  exact sourceChild_sameModePrefixDominance occurrence htrace _ _
    (d1Configuration_thirdPath_expandedLabels occurrence hm) hno

theorem d3FirstChild_sameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8)
    (hno : Not
      ((occurrence.forgetOccurrence.d3Configuration hp hm).firstPath
        ).HasDeletionWitness) :
    SameModePrefixDominance
      (occurrence.target.child
        (d3AdvancedAction occurrence.target.label.mode hm 0)) := by
  exact sourceChild_sameModePrefixDominance occurrence htrace _ _
    (d3Configuration_firstPath_expandedLabels occurrence hm) hno

theorem d3SecondChild_sameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8)
    (hno : Not
      ((occurrence.forgetOccurrence.d3Configuration hp hm).secondPath
        ).HasDeletionWitness) :
    SameModePrefixDominance
      (occurrence.target.child
        (d3AdvancedAction occurrence.target.label.mode hm 1)) := by
  exact sourceChild_sameModePrefixDominance occurrence htrace _ _
    (d3Configuration_secondPath_expandedLabels occurrence hm) hno

theorem d3ThirdChild_sameModePrefixDominance
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8)
    (hno : Not
      ((occurrence.forgetOccurrence.d3Configuration hp hm).thirdPath
        ).HasDeletionWitness) :
    SameModePrefixDominance
      (occurrence.target.child
        (d3AdvancedAction occurrence.target.label.mode hm 2)) := by
  exact sourceChild_sameModePrefixDominance occurrence htrace _ _
    (d3Configuration_thirdPath_expandedLabels occurrence hm) hno

theorem allLabelsAdvancedDominance_d1ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hparent : ProvenancedLabelAdvancedDominance occurrence.target)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention)
    (hretained :
      GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
        (occurrence.forgetOccurrence.d1Configuration hp hm) retention) :
    AllLabelsAdvancedDominance
      (ProvenancedTree.d1ReducedSourceSplit occurrence.target hm retention) := by
  have hretarded := hparent.retardedChild
  have hfirst (hno : Not
      ((occurrence.forgetOccurrence.d1Configuration hp hm).firstPath
        ).HasDeletionWitness) :
      ProvenancedLabelAdvancedDominance
        (occurrence.target.child
          (d1AdvancedAction occurrence.target.label.mode hm 0)) :=
    hparent.child _ (fun _ =>
      d1FirstChild_sameModePrefixDominance occurrence htrace hm hno)
  have hsecond (hno : Not
      ((occurrence.forgetOccurrence.d1Configuration hp hm).secondPath
        ).HasDeletionWitness) :
      ProvenancedLabelAdvancedDominance
        (occurrence.target.child
          (d1AdvancedAction occurrence.target.label.mode hm 1)) :=
    hparent.child _ (fun _ =>
      d1SecondChild_sameModePrefixDominance occurrence htrace hm hno)
  have hthird (hno : Not
      ((occurrence.forgetOccurrence.d1Configuration hp hm).thirdPath
        ).HasDeletionWitness) :
      ProvenancedLabelAdvancedDominance
        (occurrence.target.child
          (d1AdvancedAction occurrence.target.label.mode hm 2)) :=
    hparent.child _ (fun _ =>
      d1ThirdChild_sameModePrefixDominance occurrence htrace hm hno)
  cases retention <;>
    simp only [GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree]
      at hretained <;>
    simp [ProvenancedTree.d1ReducedSourceSplit, ProvenancedTree.reduce,
      AllLabelsAdvancedDominance, hparent, hretarded, hfirst, hsecond,
      hthird, hretained]

theorem allLabelsAdvancedDominance_d3ReducedSourceSplit
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htrace : TraceConsistentFrom [] tree)
    (hparent : ProvenancedLabelAdvancedDominance occurrence.target)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention)
    (hretained :
      GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
        (occurrence.forgetOccurrence.d3Configuration hp hm) retention) :
    AllLabelsAdvancedDominance
      (ProvenancedTree.d3ReducedSourceSplit occurrence.target hm retention) := by
  have hretarded := hparent.retardedChild
  have hfirst (hno : Not
      ((occurrence.forgetOccurrence.d3Configuration hp hm).firstPath
        ).HasDeletionWitness) :
      ProvenancedLabelAdvancedDominance
        (occurrence.target.child
          (d3AdvancedAction occurrence.target.label.mode hm 0)) :=
    hparent.child _ (fun _ =>
      d3FirstChild_sameModePrefixDominance occurrence htrace hm hno)
  have hsecond (hno : Not
      ((occurrence.forgetOccurrence.d3Configuration hp hm).secondPath
        ).HasDeletionWitness) :
      ProvenancedLabelAdvancedDominance
        (occurrence.target.child
          (d3AdvancedAction occurrence.target.label.mode hm 1)) :=
    hparent.child _ (fun _ =>
      d3SecondChild_sameModePrefixDominance occurrence htrace hm hno)
  have hthird (hno : Not
      ((occurrence.forgetOccurrence.d3Configuration hp hm).thirdPath
        ).HasDeletionWitness) :
      ProvenancedLabelAdvancedDominance
        (occurrence.target.child
          (d3AdvancedAction occurrence.target.label.mode hm 2)) :=
    hparent.child _ (fun _ =>
      d3ThirdChild_sameModePrefixDominance occurrence htrace hm hno)
  cases retention <;>
    simp only [GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree]
      at hretained <;>
    simp [ProvenancedTree.d3ReducedSourceSplit, ProvenancedTree.reduce,
      AllLabelsAdvancedDominance, hparent, hretarded, hfirst, hsecond,
      hthird, hretained]

theorem allLabelsAdvancedDominance_sourceSplit_d2
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root)
    (hnode : ProvenancedLabelAdvancedDominance node)
    (hm : node.label.mode.1.1 % 9 = 5) :
    AllLabelsAdvancedDominance (ProvenancedTree.sourceSplit node) := by
  have hnot2 : node.label.mode.1.1 % 9 ≠ 2 := by rw [hm]; decide
  simp [ProvenancedTree.sourceSplit, hnot2, hm,
    AllLabelsAdvancedDominance, hnode, hnode.retardedChild]

theorem AllLabelsAdvancedDominance.criticalSourceStep
    {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root}
    (occurrence : ProvenancedTree.ExpandableOccurrence tree)
    (htree : AllLabelsAdvancedDominance tree)
    (htrace : TraceConsistentFrom [] tree)
    (hd1 : forall
      (hm : occurrence.target.label.mode.1.1 % 9 = 2),
      GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
        (occurrence.forgetOccurrence.d1Configuration hp hm)
        (occurrence.forgetOccurrence.d1Configuration hp hm).witnessRetention)
    (hd3 : forall
      (hm : occurrence.target.label.mode.1.1 % 9 = 8),
      GeneralKRetentionAdmissibilityAudit.RetainedBranchesWitnessFree
        (occurrence.forgetOccurrence.d3Configuration hp hm)
        (occurrence.forgetOccurrence.d3Configuration hp hm).witnessRetention) :
    AllLabelsAdvancedDominance occurrence.sourceStep := by
  have htarget := target_advancedDominance occurrence.path htree
  rcases ELTree.trackedMode_mod_nine_cases occurrence.target.label.mode with
      hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hm2]
    apply htree.provenancedReplaceAt occurrence.path
    exact allLabelsAdvancedDominance_d1ReducedSourceSplit occurrence htrace
      htarget hm2 _ (hd1 hm2)
  · rw [occurrence.sourceStep_eq_d2 hm5,
      ← GeneralKProvenancedSchedulerDepth.provenancedReplaceAt_sourceSplit
        occurrence.path]
    apply htree.provenancedReplaceAt occurrence.path
    exact allLabelsAdvancedDominance_sourceSplit_d2 occurrence.target
      htarget hm5
  · rw [occurrence.sourceStep_eq_d3 hm8]
    apply htree.provenancedReplaceAt occurrence.path
    exact allLabelsAdvancedDominance_d3ReducedSourceSplit occurrence htrace
      htarget hm8 _ (hd3 hm8)

theorem run_allLabelsAdvancedDominance
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y)
    (hne : NeverStops (ProvenancedTree.initial hp root) y) :
    forall n,
      AllLabelsAdvancedDominance
        (GeneralKCriticalScheduler.run
          (ProvenancedTree.initial hp root) y n) := by
  intro n
  induction n with
  | zero => exact allLabelsAdvancedDominance_initial hp root
  | succ n ih =>
      rw [run_succ_eq_selectedOccurrence_sourceStep hne n]
      exact ih.criticalSourceStep
        (selectedOccurrence hne n).occurrence
        (run_initial_traceConsistent hp root y n)
        (fun hm => selected_d1_retainedBranchesWitnessFree roots hy
          hbounds hargs hne n hm)
        (fun hm => selected_d3_retainedBranchesWitnessFree roots hy
          hbounds hargs hne n hm)

theorem allSelectedPrefixesAdvancedDominance
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y)
    (hne : NeverStops (ProvenancedTree.initial hp root) y) :
    AllSelectedPrefixesAdvancedDominance hne := by
  intro code hselected
  obtain ⟨time, hprefix⟩ := hselected
  have htree := run_allLabelsAdvancedDominance roots hy hbounds hargs hne time
  have htarget := target_advancedDominance
    (selectedOccurrence hne time).occurrence.path htree
  exact htarget.of_isPrefix hprefix

theorem extractedCriticalBranch_advancedArrivalsNonincreasing
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {root : ELLabel (p + 1)} {y : Real} (hy : 2 <= y)
    (hbounds : (ProvenancedTree.initial hp root).forget.CriticalNodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hargs : (ProvenancedTree.initial hp root).forget.normalExpr
      |>.ArgumentsNonnegative y)
    (hne : NeverStops (ProvenancedTree.initial hp root) y) :
    AdvancedArrivalsNonincreasing
      (extractedInfiniteSourceWalk hne) root.shift.eval :=
  advancedArrivalsNonincreasing_of_allSelectedPrefixesAdvancedDominance hne
    (allSelectedPrefixesAdvancedDominance roots hy hbounds hargs hne)

end GeneralKCriticalAdvancedDominance
end KL2003
end CollatzClassical
