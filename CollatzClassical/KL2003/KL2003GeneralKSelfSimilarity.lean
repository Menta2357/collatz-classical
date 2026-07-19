import CollatzClassical.KL2003.KL2003GeneralKTerminationCore

namespace CollatzClassical
namespace KL2003

/-!
Translation equivariance for source general-`k` EL expansion traces.

This module formalizes the local algebra behind the self-similarity statement
used in KL2003 Theorem 3.1: changing the root argument by one symbolic shift
translates every descendant shift by the same amount, while preserving modes
and tree shape. It covers arbitrary finite traces of explicitly matched raw
source splits, fixed-retention deletion, and witness-retention deletion when
the relevant leaves remain nonnegative. It does not claim that the
sign-sensitive scheduler chooses the same occurrence after translation,
identify recurrent infinite subtrees, or prove termination/order independence.
-/

namespace SymbolicShift

theorem add_assoc (first second third : SymbolicShift) :
    first + second + third = first + (second + third) := by
  cases first with
  | mk firstAlpha firstConst =>
      cases second with
      | mk secondAlpha secondConst =>
          cases third with
          | mk thirdAlpha thirdConst =>
              change
                SymbolicShift.mk
                    ((firstAlpha + secondAlpha) + thirdAlpha)
                    ((firstConst + secondConst) + thirdConst) =
                  SymbolicShift.mk
                    (firstAlpha + (secondAlpha + thirdAlpha))
                    (firstConst + (secondConst + thirdConst))
              rw [Int.add_assoc, Int.add_assoc]

end SymbolicShift

namespace ELExpr

theorem shiftBy_shiftBy {k : Nat} (expr : ELExpr k)
    (first second : SymbolicShift) :
    (expr.shiftBy first).shiftBy second = expr.shiftBy (second + first) := by
  induction expr with
  | leaf label =>
      simp only [shiftBy]
      rw [SymbolicShift.add_assoc]
  | add left right ihLeft ihRight => simp [shiftBy, ihLeft, ihRight]
  | min3 firstExpr secondExpr thirdExpr ihFirst ihSecond ihThird =>
      simp [shiftBy, ihFirst, ihSecond, ihThird]

end ELExpr

namespace ELLabel

def translate {k : Nat} (delta : SymbolicShift) (label : ELLabel k) :
    ELLabel k :=
  ⟨label.mode, delta + label.shift⟩

@[simp] theorem translate_mode {k : Nat} (delta : SymbolicShift)
    (label : ELLabel k) :
    (label.translate delta).mode = label.mode := rfl

@[simp] theorem translate_shift {k : Nat} (delta : SymbolicShift)
    (label : ELLabel k) :
    (label.translate delta).shift = delta + label.shift := rfl

theorem translate_shift_eval {k : Nat} (delta : SymbolicShift)
    (label : ELLabel k) :
    (label.translate delta).shift.eval = delta.eval + label.shift.eval := by
  rw [translate_shift, SymbolicShift.eval_add]

end ELLabel

namespace ELTree

def translate {k : Nat} (delta : SymbolicShift) : ELTree k -> ELTree k
  | .terminal label => .terminal (label.translate delta)
  | .expanded label body => .expanded (label.translate delta) (body.translate delta)
  | .add left right => .add (left.translate delta) (right.translate delta)
  | .min2 left right => .min2 (left.translate delta) (right.translate delta)
  | .min3 first second third =>
      .min3 (first.translate delta) (second.translate delta)
        (third.translate delta)

namespace Context

def translate {k : Nat} (delta : SymbolicShift) : Context k -> Context k
  | .hole => .hole
  | .expanded label context =>
      .expanded (label.translate delta) (context.translate delta)
  | .addLeft context right =>
      .addLeft (context.translate delta) (right.translate delta)
  | .addRight left context =>
      .addRight (left.translate delta) (context.translate delta)
  | .min2Left context right =>
      .min2Left (context.translate delta) (right.translate delta)
  | .min2Right left context =>
      .min2Right (left.translate delta) (context.translate delta)
  | .minFirst context second third =>
      .minFirst (context.translate delta) (second.translate delta)
        (third.translate delta)
  | .minSecond first context third =>
      .minSecond (first.translate delta) (context.translate delta)
        (third.translate delta)
  | .minThird first second context =>
      .minThird (first.translate delta) (second.translate delta)
        (context.translate delta)

theorem plug_translate {k : Nat} (context : Context k) (tree : ELTree k)
    (delta : SymbolicShift) :
    (context.translate delta).plug (tree.translate delta) =
      (context.plug tree).translate delta := by
  induction context <;>
    simp [translate, plug, ELTree.translate, *]

theorem expandedLabels_translate {k : Nat} (context : Context k)
    (delta : SymbolicShift) :
    (context.translate delta).expandedLabels =
      context.expandedLabels.map (ELLabel.translate delta) := by
  induction context <;>
    simp [translate, expandedLabels, *]

theorem comp_translate {k : Nat} (outer inner : Context k)
    (delta : SymbolicShift) :
    (outer.comp inner).translate delta =
      (outer.translate delta).comp (inner.translate delta) := by
  induction outer <;>
    simp [translate, comp, *]

@[simp] theorem containsAdd_translate {k : Nat} (context : Context k)
    (delta : SymbolicShift) :
    (context.translate delta).ContainsAdd <-> context.ContainsAdd := by
  induction context <;>
    simp [translate, ContainsAdd, *]

@[simp] theorem addBelowEveryExpanded_translate {k : Nat}
    (context : Context k) (delta : SymbolicShift) :
    (context.translate delta).AddBelowEveryExpanded <->
      context.AddBelowEveryExpanded := by
  induction context <;>
    simp [translate, AddBelowEveryExpanded, *]

end Context

theorem frontierExpr_translate {k : Nat} (tree : ELTree k)
    (delta : SymbolicShift) :
    (tree.translate delta).frontierExpr = tree.frontierExpr.shiftBy delta := by
  induction tree with
  | terminal label => rfl
  | expanded label body ih => rfl
  | add left right ihLeft ihRight =>
      simp [translate, frontierExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min2 left right ihLeft ihRight =>
      simp [translate, frontierExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [translate, frontierExpr, ELExpr.shiftBy, ihFirst, ihSecond, ihThird]

theorem normalExpr_translate {k : Nat} (tree : ELTree k)
    (delta : SymbolicShift) :
    (tree.translate delta).normalExpr = tree.normalExpr.shiftBy delta := by
  induction tree with
  | terminal label => rfl
  | expanded label body ih => simpa [translate, normalExpr] using ih
  | add left right ihLeft ihRight =>
      simp [translate, normalExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min2 left right ihLeft ihRight =>
      simp [translate, normalExpr, ELExpr.shiftBy, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [translate, normalExpr, ELExpr.shiftBy, ihFirst, ihSecond, ihThird]

theorem normalExpr_eval_translate {k : Nat} (tree : ELTree k)
    (delta : SymbolicShift) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    (tree.translate delta).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi (y + delta.eval) := by
  rw [normalExpr_translate, ELExpr.shiftBy_eval]

theorem ofExpr_shiftBy {k : Nat} (expr : ELExpr k)
    (delta : SymbolicShift) :
    ofExpr (expr.shiftBy delta) = (ofExpr expr).translate delta := by
  induction expr with
  | leaf label => rfl
  | add left right ihLeft ihRight =>
      simp [ELExpr.shiftBy, ofExpr, translate, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [ELExpr.shiftBy, ofExpr, translate, ihFirst, ihSecond, ihThird]

theorem splitTopExpr_translate {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (delta : SymbolicShift) :
    splitTopExpr hp (label.translate delta) =
      (splitTopExpr hp label).shiftBy delta := by
  by_cases h2 : label.mode.1.1 % 9 = 2
  · simp [splitTopExpr, h2, ELLabel.translate, ELExpr.shiftBy_shiftBy]
  · by_cases h5 : label.mode.1.1 % 9 = 5
    · simp [splitTopExpr, h2, h5, ELLabel.translate, ELExpr.shiftBy_shiftBy]
    · simp [splitTopExpr, h2, h5, ELLabel.translate, ELExpr.shiftBy_shiftBy]

theorem sourceSplitTree_translate {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (delta : SymbolicShift) :
    sourceSplitTree hp (label.translate delta) =
      (sourceSplitTree hp label).translate delta := by
  simp [sourceSplitTree, translate, splitTopExpr_translate, ofExpr_shiftBy]

namespace Min3Retention

theorem reduce_translate {k : Nat} (retention : Min3Retention)
    (first second third : ELTree k) (delta : SymbolicShift) :
    retention.reduce (first.translate delta) (second.translate delta)
        (third.translate delta) =
      (retention.reduce first second third).translate delta := by
  cases retention <;> rfl

end Min3Retention

namespace Min3Path

def translate {k : Nat} {tree : ELTree k} (path : Min3Path tree)
    (delta : SymbolicShift) : Min3Path (tree.translate delta) :=
  match path with
  | .here first second third =>
      .here (first.translate delta) (second.translate delta)
        (third.translate delta)
  | .expanded label body subpath =>
      .expanded (label.translate delta) (body.translate delta)
        (subpath.translate delta)
  | .addLeft left right subpath =>
      .addLeft (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .addRight left right subpath =>
      .addRight (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .min2Left left right subpath =>
      .min2Left (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .min2Right left right subpath =>
      .min2Right (left.translate delta) (right.translate delta)
        (subpath.translate delta)
  | .minFirst first second third subpath =>
      .minFirst (first.translate delta) (second.translate delta)
        (third.translate delta) (subpath.translate delta)
  | .minSecond first second third subpath =>
      .minSecond (first.translate delta) (second.translate delta)
        (third.translate delta) (subpath.translate delta)
  | .minThird first second third subpath =>
      .minThird (first.translate delta) (second.translate delta)
        (third.translate delta) (subpath.translate delta)

@[simp] theorem firstChild_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).firstChild = path.firstChild.translate delta := by
  induction path <;> simp [translate, firstChild, *]

@[simp] theorem secondChild_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).secondChild = path.secondChild.translate delta := by
  induction path <;> simp [translate, secondChild, *]

@[simp] theorem thirdChild_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).thirdChild = path.thirdChild.translate delta := by
  induction path <;> simp [translate, thirdChild, *]

theorem context_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).context = path.context.translate delta := by
  induction path <;>
    simp [translate, context, Context.translate, *]

theorem firstBranchContext_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).firstBranchContext =
      path.firstBranchContext.translate delta := by
  simp [firstBranchContext, context_translate, Context.comp_translate,
    Context.translate]

theorem secondBranchContext_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).secondBranchContext =
      path.secondBranchContext.translate delta := by
  simp [secondBranchContext, context_translate, Context.comp_translate,
    Context.translate]

theorem thirdBranchContext_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (delta : SymbolicShift) :
    (path.translate delta).thirdBranchContext =
      path.thirdBranchContext.translate delta := by
  simp [thirdBranchContext, context_translate, Context.comp_translate,
    Context.translate]

theorem reduceAt_translate {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) (retention : Min3Retention)
    (delta : SymbolicShift) :
    (path.translate delta).reduceAt retention =
      (path.reduceAt retention).translate delta := by
  induction path with
  | here first second third =>
      exact retention.reduce_translate first second third delta
  | expanded label body subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | addLeft left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | addRight left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | min2Left left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | min2Right left right subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | minFirst first second third subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | minSecond first second third subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]
  | minThird first second third subpath ih =>
      simp [translate, reduceAt, ELTree.translate, ih]

end Min3Path

namespace TerminalPath

def translate {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) (delta : SymbolicShift) :
    TerminalPath (tree.translate delta) (target.translate delta) :=
  match path with
  | .here label => .here (label.translate delta)
  | .expanded label body target subpath =>
      .expanded (label.translate delta) (body.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .addLeft left right target subpath =>
      .addLeft (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .addRight left right target subpath =>
      .addRight (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .min2Left left right target subpath =>
      .min2Left (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .min2Right left right target subpath =>
      .min2Right (left.translate delta) (right.translate delta)
        (target.translate delta) (subpath.translate delta)
  | .minFirst first second third target subpath =>
      .minFirst (first.translate delta) (second.translate delta)
        (third.translate delta) (target.translate delta)
        (subpath.translate delta)
  | .minSecond first second third target subpath =>
      .minSecond (first.translate delta) (second.translate delta)
        (third.translate delta) (target.translate delta)
        (subpath.translate delta)
  | .minThird first second third target subpath =>
      .minThird (first.translate delta) (second.translate delta)
        (third.translate delta) (target.translate delta)
        (subpath.translate delta)

theorem context_translate {k : Nat} {tree : ELTree k}
    {target : ELLabel k} (path : TerminalPath tree target)
    (delta : SymbolicShift) :
    (path.translate delta).context = path.context.translate delta := by
  induction path <;>
    simp [TerminalPath.translate, TerminalPath.context, Context.translate, *]

theorem leafState_translate_ancestors {k : Nat} {tree : ELTree k}
    {target : ELLabel k} (path : TerminalPath tree target)
    (delta : SymbolicShift) :
    (path.translate delta).leafState.ancestors =
      path.leafState.ancestors.map (ELLabel.translate delta) := by
  simp [leafState, context_translate, Context.expandedLabels_translate]

theorem hasDeletionWitness_translate_iff_of_nonnegative
    {k : Nat} {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) (delta : SymbolicShift)
    (horiginal : 0 <= target.shift.eval)
    (htranslated : 0 <= (target.translate delta).shift.eval) :
    (path.translate delta).HasDeletionWitness <-> path.HasDeletionWitness := by
  constructor
  · intro hwitness
    rcases hwitness with ⟨_, ancestor, hmem, hmode, hshift⟩
    rw [leafState_translate_ancestors] at hmem
    rcases List.mem_map.mp hmem with ⟨sourceAncestor, hsourceMem, heq⟩
    subst ancestor
    refine ⟨horiginal, sourceAncestor, hsourceMem, ?_, ?_⟩
    · simpa using hmode
    · simp only [leafState, ELLabel.translate_shift_eval] at hshift ⊢
      linarith
  · intro hwitness
    rcases hwitness with ⟨_, ancestor, hmem, hmode, hshift⟩
    refine ⟨htranslated, ancestor.translate delta, ?_, ?_, ?_⟩
    · rw [leafState_translate_ancestors]
      exact List.mem_map.mpr ⟨ancestor, hmem, rfl⟩
    · simpa using hmode
    · simp only [leafState, ELLabel.translate_shift_eval] at hshift ⊢
      linarith

theorem splitAt_translate {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target) (delta : SymbolicShift) :
    (path.translate delta).splitAt hp = (path.splitAt hp).translate delta := by
  induction path with
  | here label => exact sourceSplitTree_translate hp label delta
  | expanded label body target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | addLeft left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | addRight left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | min2Left left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | min2Right left right target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | minFirst first second third target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | minSecond first second third target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]
  | minThird first second third target subpath ih =>
      simp [translate, splitAt, ELTree.translate, ih]

end TerminalPath

namespace TerminalPath.AdvancedMinConfiguration

def translate {k : Nat} {tree : ELTree k}
    {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift) :
    AdvancedMinConfiguration (tree.translate delta)
      (first.translate delta) (second.translate delta)
      (third.translate delta) where
  minPath := configuration.minPath.translate delta
  firstPath := configuration.firstPath.translate delta
  secondPath := configuration.secondPath.translate delta
  thirdPath := configuration.thirdPath.translate delta
  firstChild_eq := by
    rw [Min3Path.firstChild_translate, configuration.firstChild_eq]
    rfl
  secondChild_eq := by
    rw [Min3Path.secondChild_translate, configuration.secondChild_eq]
    rfl
  thirdChild_eq := by
    rw [Min3Path.thirdChild_translate, configuration.thirdChild_eq]
    rfl
  firstContext_eq := by
    rw [Min3Path.firstBranchContext_translate,
      configuration.firstContext_eq, TerminalPath.context_translate]
  secondContext_eq := by
    rw [Min3Path.secondBranchContext_translate,
      configuration.secondContext_eq, TerminalPath.context_translate]
  thirdContext_eq := by
    rw [Min3Path.thirdBranchContext_translate,
      configuration.thirdContext_eq, TerminalPath.context_translate]
  firstContainsAdd := by
    rw [TerminalPath.context_translate, Context.containsAdd_translate]
    exact configuration.firstContainsAdd
  secondContainsAdd := by
    rw [TerminalPath.context_translate, Context.containsAdd_translate]
    exact configuration.secondContainsAdd
  thirdContainsAdd := by
    rw [TerminalPath.context_translate, Context.containsAdd_translate]
    exact configuration.thirdContainsAdd
  firstAddBelow := by
    change (configuration.firstPath.translate delta).context.AddBelowEveryExpanded
    rw [TerminalPath.context_translate,
      Context.addBelowEveryExpanded_translate]
    exact configuration.firstAddBelow
  secondAddBelow := by
    change (configuration.secondPath.translate delta).context.AddBelowEveryExpanded
    rw [TerminalPath.context_translate,
      Context.addBelowEveryExpanded_translate]
    exact configuration.secondAddBelow
  thirdAddBelow := by
    change (configuration.thirdPath.translate delta).context.AddBelowEveryExpanded
    rw [TerminalPath.context_translate,
      Context.addBelowEveryExpanded_translate]
    exact configuration.thirdAddBelow

theorem witnessRetention_eq_of_witness_iff
    {k : Nat} {treeA treeB : ELTree k}
    {firstA secondA thirdA firstB secondB thirdB : ELLabel k}
    (configurationA : AdvancedMinConfiguration treeA firstA secondA thirdA)
    (configurationB : AdvancedMinConfiguration treeB firstB secondB thirdB)
    (hfirst : configurationA.firstPath.HasDeletionWitness <->
      configurationB.firstPath.HasDeletionWitness)
    (hsecond : configurationA.secondPath.HasDeletionWitness <->
      configurationB.secondPath.HasDeletionWitness)
    (hthird : configurationA.thirdPath.HasDeletionWitness <->
      configurationB.thirdPath.HasDeletionWitness) :
    configurationA.witnessRetention = configurationB.witnessRetention := by
  classical
  by_cases hfirstA : configurationA.firstPath.HasDeletionWitness <;>
    by_cases hfirstB : configurationB.firstPath.HasDeletionWitness <;>
    by_cases hsecondA : configurationA.secondPath.HasDeletionWitness <;>
      by_cases hsecondB : configurationB.secondPath.HasDeletionWitness <;>
      by_cases hthirdA : configurationA.thirdPath.HasDeletionWitness <;>
        by_cases hthirdB : configurationB.thirdPath.HasDeletionWitness <;>
          simp_all [witnessRetention]

theorem witnessRetention_translate_of_nonnegative
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift)
    (hfirst : 0 <= first.shift.eval)
    (hfirstTranslated : 0 <= (first.translate delta).shift.eval)
    (hsecond : 0 <= second.shift.eval)
    (hsecondTranslated : 0 <= (second.translate delta).shift.eval)
    (hthird : 0 <= third.shift.eval)
    (hthirdTranslated : 0 <= (third.translate delta).shift.eval) :
    (configuration.translate delta).witnessRetention =
      configuration.witnessRetention := by
  apply witnessRetention_eq_of_witness_iff
  · exact configuration.firstPath
      |>.hasDeletionWitness_translate_iff_of_nonnegative delta
        hfirst hfirstTranslated
  · exact configuration.secondPath
      |>.hasDeletionWitness_translate_iff_of_nonnegative delta
        hsecond hsecondTranslated
  · exact configuration.thirdPath
      |>.hasDeletionWitness_translate_iff_of_nonnegative delta
        hthird hthirdTranslated

theorem reduceAt_witnessRetention_translate_of_nonnegative
    {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : AdvancedMinConfiguration tree first second third)
    (delta : SymbolicShift)
    (hfirst : 0 <= first.shift.eval)
    (hfirstTranslated : 0 <= (first.translate delta).shift.eval)
    (hsecond : 0 <= second.shift.eval)
    (hsecondTranslated : 0 <= (second.translate delta).shift.eval)
    (hthird : 0 <= third.shift.eval)
    (hthirdTranslated : 0 <= (third.translate delta).shift.eval) :
    (configuration.translate delta).minPath.reduceAt
        (configuration.translate delta).witnessRetention =
      (configuration.minPath.reduceAt configuration.witnessRetention).translate
        delta := by
  rw [configuration.witnessRetention_translate_of_nonnegative delta
    hfirst hfirstTranslated hsecond hsecondTranslated hthird hthirdTranslated]
  exact configuration.minPath.reduceAt_translate
    configuration.witnessRetention delta

end TerminalPath.AdvancedMinConfiguration

namespace ExpandableOccurrence

def translate {k : Nat} {tree : ELTree k}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval) :
    ExpandableOccurrence (tree.translate delta) :=
  ⟨occurrence.target.translate delta, occurrence.path.translate delta, hshift⟩

@[simp] theorem translate_target {k : Nat} {tree : ELTree k}
    (occurrence : ExpandableOccurrence tree) (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval) :
    (occurrence.translate delta hshift).target =
      occurrence.target.translate delta := rfl

theorem split_translate {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval) :
    (occurrence.translate delta hshift).split hp =
      (occurrence.split hp).translate delta := by
  exact occurrence.path.splitAt_translate hp delta

theorem sourceStep_translate_d2 {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} (occurrence : ExpandableOccurrence tree)
    (delta : SymbolicShift)
    (hshift : 0 <= (occurrence.target.translate delta).shift.eval)
    (hm : occurrence.target.mode.1.1 % 9 = 5) :
    (occurrence.translate delta hshift).sourceStep hp =
      (occurrence.sourceStep hp).translate delta := by
  rw [(occurrence.translate delta hshift).sourceStep_eq_d2 hp (by simpa using hm),
    occurrence.sourceStep_eq_d2 hp hm]
  exact occurrence.split_translate hp delta hshift

end ExpandableOccurrence

inductive RawSourceSplitStep {p : Nat} (hp : 1 <= p) :
    ELTree (p + 1) -> ELTree (p + 1) -> Prop
  | split {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
      (path : TerminalPath tree target) :
      RawSourceSplitStep hp tree (path.splitAt hp)

namespace RawSourceSplitStep

theorem translate {p : Nat} {hp : 1 <= p}
    {tree next : ELTree (p + 1)}
    (step : RawSourceSplitStep hp tree next) (delta : SymbolicShift) :
    RawSourceSplitStep hp (tree.translate delta) (next.translate delta) := by
  cases step with
  | split path =>
      rw [← path.splitAt_translate hp delta]
      exact .split (path.translate delta)

end RawSourceSplitStep

theorem rawSourceSplitSteps_translate {p : Nat} {hp : 1 <= p}
    {tree next : ELTree (p + 1)}
    (steps : Relation.ReflTransGen (RawSourceSplitStep hp) tree next)
    (delta : SymbolicShift) :
    Relation.ReflTransGen (RawSourceSplitStep hp)
      (tree.translate delta) (next.translate delta) := by
  induction steps with
  | refl => exact .refl
  | tail hprefix hstep ih => exact ih.tail (hstep.translate delta)

end ELTree

end KL2003
end CollatzClassical
