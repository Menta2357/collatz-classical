import CollatzClassical.KL2003.KL2003GeneralKSourceGenealogy

namespace CollatzClassical
namespace KL2003

/-!
Lift the source scheduler's contextual retention to provenanced trees.

This module separates the global retention decision, which is computed from
the existing forgotten tree, from its local application to the newly created
advanced min.  The principal acceptance theorem will state that forgetting a
provenanced step is exactly `ExpandableOccurrence.sourceStep`.
-/

namespace GeneralKProvenancedScheduler

open GeneralKSourceGraph
open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree

namespace ProvenancedTree

/-- D1 source split with a supplied retention applied to the advanced min. -/
def d1ReducedSourceSplit {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention) : ProvenancedTree hp root :=
  .expanded node
    (.add
      (.terminal (node.child (retardedAction node.label.mode)))
      (reduce retention
        (.terminal (node.child (d1AdvancedAction node.label.mode hm 0)))
        (.terminal (node.child (d1AdvancedAction node.label.mode hm 1)))
        (.terminal (node.child (d1AdvancedAction node.label.mode hm 2)))))

/-- D3 source split with a supplied retention applied to the advanced min. -/
def d3ReducedSourceSplit {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention) : ProvenancedTree hp root :=
  .expanded node
    (.add
      (.terminal (node.child (retardedAction node.label.mode)))
      (reduce retention
        (.terminal (node.child (d3AdvancedAction node.label.mode hm 0)))
        (.terminal (node.child (d3AdvancedAction node.label.mode hm 1)))
        (.terminal (node.child (d3AdvancedAction node.label.mode hm 2)))))

/-- The forgotten canonical D1 tree after one supplied retention. -/
def rawD1ReducedSourceSplit {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention) : ELTree (p + 1) :=
  .expanded label
    (.add (.terminal (ELTree.retardedSplitLabel label))
      (retention.reduce
        (.terminal (ELTree.d1AdvancedSplitLabel hp label hm 0))
        (.terminal (ELTree.d1AdvancedSplitLabel hp label hm 1))
        (.terminal (ELTree.d1AdvancedSplitLabel hp label hm 2))))

/-- The forgotten canonical D3 tree after one supplied retention. -/
def rawD3ReducedSourceSplit {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention) : ELTree (p + 1) :=
  .expanded label
    (.add (.terminal (ELTree.retardedSplitLabel label))
      (retention.reduce
        (.terminal (ELTree.d3AdvancedSplitLabel hp label hm 0))
        (.terminal (ELTree.d3AdvancedSplitLabel hp label hm 1))
        (.terminal (ELTree.d3AdvancedSplitLabel hp label hm 2))))

theorem advancedConfiguration_reduceAt_transport {k : Nat}
    {tree tree' : ELTree k} {first second third : ELLabel k}
    (h : tree = tree')
    (configuration : ELTree.TerminalPath.AdvancedMinConfiguration
      tree first second third)
    (retention : ELTree.Min3Retention) :
    ((h ▸ configuration).minPath.reduceAt retention) =
      configuration.minPath.reduceAt retention := by
  subst tree'
  rfl

theorem d1Configuration_reduceAt_eq {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention) :
    (ELTree.TerminalPath.sourceD1AdvancedConfigurationData
      hp label hm).minPath.reduceAt retention =
      rawD1ReducedSourceSplit hp label hm retention := by
  unfold ELTree.TerminalPath.sourceD1AdvancedConfigurationData
  rw [advancedConfiguration_reduceAt_transport]
  rfl

theorem d3Configuration_reduceAt_eq {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention) :
    (ELTree.TerminalPath.sourceD3AdvancedConfigurationData
      hp label hm).minPath.reduceAt retention =
      rawD3ReducedSourceSplit hp label hm retention := by
  unfold ELTree.TerminalPath.sourceD3AdvancedConfigurationData
  rw [advancedConfiguration_reduceAt_transport]
  rfl

theorem forget_d1ReducedSourceSplit {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 2)
    (retention : ELTree.Min3Retention) :
    (d1ReducedSourceSplit node hm retention).forget =
      rawD1ReducedSourceSplit hp node.label hm retention := by
  cases retention <;>
    simp [d1ReducedSourceSplit, forget, reduce,
      rawD1ReducedSourceSplit, ELTree.Min3Retention.reduce,
      childLabel_retarded, childLabel_d1Advanced]

theorem forget_d3ReducedSourceSplit {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root)
    (hm : node.label.mode.1.1 % 9 = 8)
    (retention : ELTree.Min3Retention) :
    (d3ReducedSourceSplit node hm retention).forget =
      rawD3ReducedSourceSplit hp node.label hm retention := by
  cases retention <;>
    simp [d3ReducedSourceSplit, forget, reduce,
      rawD3ReducedSourceSplit, ELTree.Min3Retention.reduce,
      childLabel_retarded, childLabel_d3Advanced]

/-- Replace the terminal selected by a raw path with an arbitrary raw tree. -/
def rawReplaceAt {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : ELTree.TerminalPath tree target) (replacement : ELTree k) :
    ELTree k :=
  match path with
  | .here _ => replacement
  | .expanded label _ _ subpath =>
      .expanded label (rawReplaceAt subpath replacement)
  | .addLeft _ right _ subpath =>
      .add (rawReplaceAt subpath replacement) right
  | .addRight left _ _ subpath =>
      .add left (rawReplaceAt subpath replacement)
  | .min2Left _ right _ subpath =>
      .min2 (rawReplaceAt subpath replacement) right
  | .min2Right left _ _ subpath =>
      .min2 left (rawReplaceAt subpath replacement)
  | .minFirst _ second third _ subpath =>
      .min3 (rawReplaceAt subpath replacement) second third
  | .minSecond first _ third _ subpath =>
      .min3 first (rawReplaceAt subpath replacement) third
  | .minThird first second _ _ subpath =>
      .min3 first second (rawReplaceAt subpath replacement)

theorem rawReplaceAt_sourceSplit {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : ELTree.TerminalPath tree target) :
    rawReplaceAt path (ELTree.sourceSplitTree hp target) = path.splitAt hp := by
  induction path <;>
    simp [rawReplaceAt, ELTree.TerminalPath.splitAt, *]

theorem reduceAt_descendSplitMin3_eq_rawReplaceAt {p : Nat}
    (hp : 1 <= p) {tree : ELTree (p + 1)}
    {target : ELLabel (p + 1)}
    (outer : ELTree.TerminalPath tree target)
    (inner : ELTree.Min3Path (ELTree.sourceSplitTree hp target))
    (retention : ELTree.Min3Retention) :
    (outer.descendSplitMin3 hp inner).reduceAt retention =
      rawReplaceAt outer (inner.reduceAt retention) := by
  induction outer <;>
    simp [ELTree.TerminalPath.descendSplitMin3, ELTree.Min3Path.reduceAt,
      rawReplaceAt, *]

/-- Replace a provenanced terminal while preserving every unaffected
provenance in the surrounding tree. -/
def provenancedReplaceAt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (replacement : ProvenancedTree hp root) : ProvenancedTree hp root :=
  match path with
  | .here _ => replacement
  | .expanded node _ _ subpath =>
      .expanded node (provenancedReplaceAt subpath replacement)
  | .addLeft _ right _ subpath =>
      .add (provenancedReplaceAt subpath replacement) right
  | .addRight left _ _ subpath =>
      .add left (provenancedReplaceAt subpath replacement)
  | .min2Left _ right _ subpath =>
      .min2 (provenancedReplaceAt subpath replacement) right
  | .min2Right left _ _ subpath =>
      .min2 left (provenancedReplaceAt subpath replacement)
  | .minFirst _ second third _ subpath =>
      .min3 (provenancedReplaceAt subpath replacement) second third
  | .minSecond first _ third _ subpath =>
      .min3 first (provenancedReplaceAt subpath replacement) third
  | .minThird first second _ _ subpath =>
      .min3 first second (provenancedReplaceAt subpath replacement)

theorem forget_provenancedReplaceAt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root}
    (path : ProvenancedTree.TerminalPath tree target)
    (replacement : ProvenancedTree hp root) :
    (provenancedReplaceAt path replacement).forget =
      rawReplaceAt path.forgetPath replacement.forget := by
  induction path <;>
    simp [provenancedReplaceAt, rawReplaceAt, forget,
      ProvenancedTree.TerminalPath.forgetPath, *]

/-- A nonnegative terminal occurrence retaining its complete source
provenance. -/
structure ExpandableOccurrence {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (tree : ProvenancedTree hp root) where
  target : ProvenancedLabel hp root
  path : ProvenancedTree.TerminalPath tree target
  shift_nonnegative : 0 <= target.label.shift.eval

namespace ExpandableOccurrence

/-- Forget provenance in an expandable occurrence. -/
def forgetOccurrence {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    (occurrence : ExpandableOccurrence tree) :
    ELTree.ExpandableOccurrence tree.forget where
  target := occurrence.target.label
  path := occurrence.path.forgetPath
  shift_nonnegative := occurrence.shift_nonnegative

/-- Apply the same contextual retention decision as the raw source scheduler,
but preserve concrete source genealogy in every retained branch. -/
noncomputable def sourceStep {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    (occurrence : ExpandableOccurrence tree) : ProvenancedTree hp root := by
  classical
  exact if hm2 : occurrence.target.label.mode.1.1 % 9 = 2 then
    let configuration := occurrence.forgetOccurrence.d1Configuration hp hm2
    provenancedReplaceAt occurrence.path
      (d1ReducedSourceSplit occurrence.target hm2
        configuration.witnessRetention)
  else if hm8 : occurrence.target.label.mode.1.1 % 9 = 8 then
    let configuration := occurrence.forgetOccurrence.d3Configuration hp hm8
    provenancedReplaceAt occurrence.path
      (d3ReducedSourceSplit occurrence.target hm8
        configuration.witnessRetention)
  else
    occurrence.path.splitAt

theorem sourceStep_eq_d1 {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 2) :
    occurrence.sourceStep =
      let configuration := occurrence.forgetOccurrence.d1Configuration hp hm
      provenancedReplaceAt occurrence.path
        (d1ReducedSourceSplit occurrence.target hm
          configuration.witnessRetention) := by
  simp [sourceStep, hm]

theorem sourceStep_eq_d3 {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 8) :
    occurrence.sourceStep =
      let configuration := occurrence.forgetOccurrence.d3Configuration hp hm
      provenancedReplaceAt occurrence.path
        (d3ReducedSourceSplit occurrence.target hm
          configuration.witnessRetention) := by
  have hnot2 : occurrence.target.label.mode.1.1 % 9 != 2 := by
    rw [hm]
    decide
  simp [sourceStep, hm, hnot2]

theorem sourceStep_eq_d2 {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    (occurrence : ExpandableOccurrence tree)
    (hm : occurrence.target.label.mode.1.1 % 9 = 5) :
    occurrence.sourceStep = occurrence.path.splitAt := by
  have hnot2 : occurrence.target.label.mode.1.1 % 9 != 2 := by
    rw [hm]
    decide
  have hnot8 : occurrence.target.label.mode.1.1 % 9 != 8 := by
    rw [hm]
    decide
  simp [sourceStep, hm, hnot2, hnot8]

theorem sourceStep_forget {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    (occurrence : ExpandableOccurrence tree) :
    occurrence.sourceStep.forget = occurrence.forgetOccurrence.sourceStep hp := by
  classical
  rcases ELTree.trackedMode_mod_nine_cases occurrence.target.label.mode with
      hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hm2,
      occurrence.forgetOccurrence.sourceStep_eq_d1 hp hm2]
    dsimp only
    rw [forget_provenancedReplaceAt, forget_d1ReducedSourceSplit]
    let localConfiguration :=
      ELTree.TerminalPath.sourceD1AdvancedConfigurationData
        hp occurrence.target.label hm2
    let globalConfiguration :=
      occurrence.forgetOccurrence.d1Configuration hp hm2
    have hglobal : globalConfiguration =
        localConfiguration.descendSplit hp occurrence.path.forgetPath := rfl
    change rawReplaceAt occurrence.path.forgetPath
        (rawD1ReducedSourceSplit hp occurrence.target.label hm2
          globalConfiguration.witnessRetention) =
      globalConfiguration.minPath.reduceAt globalConfiguration.witnessRetention
    rw [hglobal]
    rw [← d1Configuration_reduceAt_eq hp occurrence.target.label hm2
      (localConfiguration.descendSplit hp
        occurrence.path.forgetPath).witnessRetention]
    exact (reduceAt_descendSplitMin3_eq_rawReplaceAt hp
      occurrence.path.forgetPath localConfiguration.minPath
      (localConfiguration.descendSplit hp
        occurrence.path.forgetPath).witnessRetention).symm
  · rw [occurrence.sourceStep_eq_d2 hm5,
      occurrence.forgetOccurrence.sourceStep_eq_d2 hp hm5]
    exact occurrence.path.forget_splitAt
  · rw [occurrence.sourceStep_eq_d3 hm8,
      occurrence.forgetOccurrence.sourceStep_eq_d3 hp hm8]
    dsimp only
    rw [forget_provenancedReplaceAt, forget_d3ReducedSourceSplit]
    let localConfiguration :=
      ELTree.TerminalPath.sourceD3AdvancedConfigurationData
        hp occurrence.target.label hm8
    let globalConfiguration :=
      occurrence.forgetOccurrence.d3Configuration hp hm8
    have hglobal : globalConfiguration =
        localConfiguration.descendSplit hp occurrence.path.forgetPath := rfl
    change rawReplaceAt occurrence.path.forgetPath
        (rawD3ReducedSourceSplit hp occurrence.target.label hm8
          globalConfiguration.witnessRetention) =
      globalConfiguration.minPath.reduceAt globalConfiguration.witnessRetention
    rw [hglobal]
    rw [← d3Configuration_reduceAt_eq hp occurrence.target.label hm8
      (localConfiguration.descendSplit hp
        occurrence.path.forgetPath).witnessRetention]
    exact (reduceAt_descendSplitMin3_eq_rawReplaceAt hp
      occurrence.path.forgetPath localConfiguration.minPath
      (localConfiguration.descendSplit hp
        occurrence.path.forgetPath).witnessRetention).symm

end ExpandableOccurrence

/-- Left-to-right nonnegative terminal finder preserving provenance. -/
noncomputable def findExpandableOccurrence {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} :
    (tree : ProvenancedTree hp root) -> Option (ExpandableOccurrence tree)
  | .terminal node =>
      if hshift : 0 <= node.label.shift.eval then
        some ⟨node, .here node, hshift⟩
      else none
  | .expanded node body =>
      (findExpandableOccurrence body).map fun occurrence =>
        ⟨occurrence.target,
          .expanded node body occurrence.target occurrence.path,
          occurrence.shift_nonnegative⟩
  | .add left right =>
      match findExpandableOccurrence left with
      | some occurrence =>
          some ⟨occurrence.target,
            .addLeft left right occurrence.target occurrence.path,
            occurrence.shift_nonnegative⟩
      | none =>
          (findExpandableOccurrence right).map fun occurrence =>
            ⟨occurrence.target,
              .addRight left right occurrence.target occurrence.path,
              occurrence.shift_nonnegative⟩
  | .min2 left right =>
      match findExpandableOccurrence left with
      | some occurrence =>
          some ⟨occurrence.target,
            .min2Left left right occurrence.target occurrence.path,
            occurrence.shift_nonnegative⟩
      | none =>
          (findExpandableOccurrence right).map fun occurrence =>
            ⟨occurrence.target,
              .min2Right left right occurrence.target occurrence.path,
              occurrence.shift_nonnegative⟩
  | .min3 first second third =>
      match findExpandableOccurrence first with
      | some occurrence =>
          some ⟨occurrence.target,
            .minFirst first second third occurrence.target occurrence.path,
            occurrence.shift_nonnegative⟩
      | none =>
          match findExpandableOccurrence second with
          | some occurrence =>
              some ⟨occurrence.target,
                .minSecond first second third occurrence.target
                  occurrence.path,
                occurrence.shift_nonnegative⟩
          | none =>
              (findExpandableOccurrence third).map fun occurrence =>
                ⟨occurrence.target,
                  .minThird first second third occurrence.target
                    occurrence.path,
                  occurrence.shift_nonnegative⟩
termination_by tree => tree

theorem findExpandableOccurrence_forget {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (tree : ProvenancedTree hp root) :
    match findExpandableOccurrence tree with
    | none => ELTree.findExpandableOccurrence tree.forget = none
    | some occurrence =>
        ELTree.findExpandableOccurrence tree.forget =
          some occurrence.forgetOccurrence := by
  classical
  induction tree with
  | terminal node =>
      by_cases hshift : 0 <= node.label.shift.eval
      · simp [findExpandableOccurrence, ELTree.findExpandableOccurrence,
          forget, hshift, ExpandableOccurrence.forgetOccurrence,
          ProvenancedTree.TerminalPath.forgetPath]
      · simp [findExpandableOccurrence, ELTree.findExpandableOccurrence,
          forget, hshift]
  | expanded node body ih =>
      generalize hfind : findExpandableOccurrence body = result
      cases result with
      | none =>
          rw [hfind] at ih
          simp [findExpandableOccurrence, hfind, forget,
            ELTree.findExpandableOccurrence, ih]
      | some occurrence =>
          rw [hfind] at ih
          simp [findExpandableOccurrence, hfind, forget,
            ELTree.findExpandableOccurrence, ih,
            ExpandableOccurrence.forgetOccurrence,
            ProvenancedTree.TerminalPath.forgetPath]
  | add left right ihLeft ihRight =>
      generalize hleft : findExpandableOccurrence left = leftResult
      cases leftResult with
      | some occurrence =>
          rw [hleft] at ihLeft
          simp [findExpandableOccurrence, hleft, forget,
            ELTree.findExpandableOccurrence, ihLeft,
            ExpandableOccurrence.forgetOccurrence,
            ProvenancedTree.TerminalPath.forgetPath]
      | none =>
          rw [hleft] at ihLeft
          generalize hright : findExpandableOccurrence right = rightResult
          cases rightResult with
          | none =>
              rw [hright] at ihRight
              simp [findExpandableOccurrence, hleft, hright, forget,
                ELTree.findExpandableOccurrence, ihLeft, ihRight]
          | some occurrence =>
              rw [hright] at ihRight
              simp [findExpandableOccurrence, hleft, hright, forget,
                ELTree.findExpandableOccurrence, ihLeft, ihRight,
                ExpandableOccurrence.forgetOccurrence,
                ProvenancedTree.TerminalPath.forgetPath]
  | min2 left right ihLeft ihRight =>
      generalize hleft : findExpandableOccurrence left = leftResult
      cases leftResult with
      | some occurrence =>
          rw [hleft] at ihLeft
          simp [findExpandableOccurrence, hleft, forget,
            ELTree.findExpandableOccurrence, ihLeft,
            ExpandableOccurrence.forgetOccurrence,
            ProvenancedTree.TerminalPath.forgetPath]
      | none =>
          rw [hleft] at ihLeft
          generalize hright : findExpandableOccurrence right = rightResult
          cases rightResult with
          | none =>
              rw [hright] at ihRight
              simp [findExpandableOccurrence, hleft, hright, forget,
                ELTree.findExpandableOccurrence, ihLeft, ihRight]
          | some occurrence =>
              rw [hright] at ihRight
              simp [findExpandableOccurrence, hleft, hright, forget,
                ELTree.findExpandableOccurrence, ihLeft, ihRight,
                ExpandableOccurrence.forgetOccurrence,
                ProvenancedTree.TerminalPath.forgetPath]
  | min3 first second third ihFirst ihSecond ihThird =>
      generalize hfirst : findExpandableOccurrence first = firstResult
      cases firstResult with
      | some occurrence =>
          rw [hfirst] at ihFirst
          simp [findExpandableOccurrence, hfirst, forget,
            ELTree.findExpandableOccurrence, ihFirst,
            ExpandableOccurrence.forgetOccurrence,
            ProvenancedTree.TerminalPath.forgetPath]
      | none =>
          rw [hfirst] at ihFirst
          generalize hsecond : findExpandableOccurrence second = secondResult
          cases secondResult with
          | some occurrence =>
              rw [hsecond] at ihSecond
              simp [findExpandableOccurrence, hfirst, hsecond, forget,
                ELTree.findExpandableOccurrence, ihFirst, ihSecond,
                ExpandableOccurrence.forgetOccurrence,
                ProvenancedTree.TerminalPath.forgetPath]
          | none =>
              rw [hsecond] at ihSecond
              generalize hthird : findExpandableOccurrence third = thirdResult
              cases thirdResult with
              | none =>
                  rw [hthird] at ihThird
                  simp [findExpandableOccurrence, hfirst, hsecond, hthird,
                    forget, ELTree.findExpandableOccurrence, ihFirst,
                    ihSecond, ihThird]
              | some occurrence =>
                  rw [hthird] at ihThird
                  simp [findExpandableOccurrence, hfirst, hsecond, hthird,
                    forget, ELTree.findExpandableOccurrence, ihFirst,
                    ihSecond, ihThird,
                    ExpandableOccurrence.forgetOccurrence,
                    ProvenancedTree.TerminalPath.forgetPath]

/-- Deterministic source scheduler on the provenanced tree. -/
noncomputable def sourceScheduledStep {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root) : ProvenancedTree hp root :=
  match findExpandableOccurrence tree with
  | none => tree
  | some occurrence => occurrence.sourceStep

theorem sourceScheduledStep_forget {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (tree : ProvenancedTree hp root) :
    (sourceScheduledStep tree).forget =
      ELTree.sourceScheduledStep hp tree.forget := by
  generalize hfind : findExpandableOccurrence tree = result
  have hforget := findExpandableOccurrence_forget tree
  cases result with
  | none =>
      rw [hfind] at hforget
      simp [sourceScheduledStep, hfind, ELTree.sourceScheduledStep, hforget]
  | some occurrence =>
      rw [hfind] at hforget
      simp [sourceScheduledStep, hfind, ELTree.sourceScheduledStep, hforget,
        occurrence.sourceStep_forget]

end ProvenancedTree

end GeneralKProvenancedScheduler

end KL2003
end CollatzClassical
