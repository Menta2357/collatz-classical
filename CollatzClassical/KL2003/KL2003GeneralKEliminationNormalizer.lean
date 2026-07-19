import CollatzClassical.KL2003.KL2003GeneralKEliminationContext

namespace CollatzClassical
namespace KL2003

/-!
Deterministic syntactic localization for the next general-k EL advanced split.
This module does not yet iterate deletion or claim termination.
-/

namespace ELTree

namespace Context

def liftMin3Path {k : Nat} (outer : Context k) {tree : ELTree k}
    (path : Min3Path tree) : Min3Path (outer.plug tree) :=
  match outer with
  | .hole => path
  | .expanded label inner =>
      .expanded label _ (inner.liftMin3Path path)
  | .addLeft inner right =>
      .addLeft _ right (inner.liftMin3Path path)
  | .addRight left inner =>
      .addRight left _ (inner.liftMin3Path path)
  | .min2Left inner right =>
      .min2Left _ right (inner.liftMin3Path path)
  | .min2Right left inner =>
      .min2Right left _ (inner.liftMin3Path path)
  | .minFirst inner second third =>
      .minFirst _ second third (inner.liftMin3Path path)
  | .minSecond first inner third =>
      .minSecond first _ third (inner.liftMin3Path path)
  | .minThird first second inner =>
      .minThird first second _ (inner.liftMin3Path path)

def liftTerminalPath {k : Nat} (outer : Context k) {tree : ELTree k}
    {target : ELLabel k} (path : TerminalPath tree target) :
    TerminalPath (outer.plug tree) target :=
  match outer with
  | .hole => path
  | .expanded label inner =>
      .expanded label _ target (inner.liftTerminalPath path)
  | .addLeft inner right =>
      .addLeft _ right target (inner.liftTerminalPath path)
  | .addRight left inner =>
      .addRight left _ target (inner.liftTerminalPath path)
  | .min2Left inner right =>
      .min2Left _ right target (inner.liftTerminalPath path)
  | .min2Right left inner =>
      .min2Right left _ target (inner.liftTerminalPath path)
  | .minFirst inner second third =>
      .minFirst _ second third target (inner.liftTerminalPath path)
  | .minSecond first inner third =>
      .minSecond first _ third target (inner.liftTerminalPath path)
  | .minThird first second inner =>
      .minThird first second _ target (inner.liftTerminalPath path)

@[simp] theorem firstChild_liftMin3Path {k : Nat} (outer : Context k)
    {tree : ELTree k} (path : Min3Path tree) :
    (outer.liftMin3Path path).firstChild = path.firstChild := by
  induction outer <;> simp [liftMin3Path, Min3Path.firstChild, *]

@[simp] theorem secondChild_liftMin3Path {k : Nat} (outer : Context k)
    {tree : ELTree k} (path : Min3Path tree) :
    (outer.liftMin3Path path).secondChild = path.secondChild := by
  induction outer <;> simp [liftMin3Path, Min3Path.secondChild, *]

@[simp] theorem thirdChild_liftMin3Path {k : Nat} (outer : Context k)
    {tree : ELTree k} (path : Min3Path tree) :
    (outer.liftMin3Path path).thirdChild = path.thirdChild := by
  induction outer <;> simp [liftMin3Path, Min3Path.thirdChild, *]

@[simp] theorem context_liftMin3Path {k : Nat} (outer : Context k)
    {tree : ELTree k} (path : Min3Path tree) :
    (outer.liftMin3Path path).context = outer.comp path.context := by
  induction outer <;>
    simp [liftMin3Path, Min3Path.context, comp, *]

@[simp] theorem context_liftTerminalPath {k : Nat} (outer : Context k)
    {tree : ELTree k} {target : ELLabel k}
    (path : TerminalPath tree target) :
    (outer.liftTerminalPath path).context = outer.comp path.context := by
  induction outer <;>
    simp [liftTerminalPath, TerminalPath.context, comp, *]

end Context

namespace TerminalPath.AdvancedMinConfiguration

def lift {k : Nat} {tree : ELTree k} {first second third : ELLabel k}
    (configuration : TerminalPath.AdvancedMinConfiguration
      tree first second third)
    (outer : Context k) :
    TerminalPath.AdvancedMinConfiguration
      (outer.plug tree) first second third where
  minPath := outer.liftMin3Path configuration.minPath
  firstPath := outer.liftTerminalPath configuration.firstPath
  secondPath := outer.liftTerminalPath configuration.secondPath
  thirdPath := outer.liftTerminalPath configuration.thirdPath
  firstChild_eq := by simpa using configuration.firstChild_eq
  secondChild_eq := by simpa using configuration.secondChild_eq
  thirdChild_eq := by simpa using configuration.thirdChild_eq
  firstContext_eq := by
    simpa [Min3Path.firstBranchContext, Context.comp_assoc] using
      congrArg (Context.comp outer) configuration.firstContext_eq
  secondContext_eq := by
    simpa [Min3Path.secondBranchContext, Context.comp_assoc] using
      congrArg (Context.comp outer) configuration.secondContext_eq
  thirdContext_eq := by
    simpa [Min3Path.thirdBranchContext, Context.comp_assoc] using
      congrArg (Context.comp outer) configuration.thirdContext_eq
  firstContainsAdd := by
    rw [Context.context_liftTerminalPath]
    exact outer.containsAdd_comp_right _ configuration.firstContainsAdd
  secondContainsAdd := by
    rw [Context.context_liftTerminalPath]
    exact outer.containsAdd_comp_right _ configuration.secondContainsAdd
  thirdContainsAdd := by
    rw [Context.context_liftTerminalPath]
    exact outer.containsAdd_comp_right _ configuration.thirdContainsAdd
  firstAddBelow := by
    change (outer.liftTerminalPath configuration.firstPath).context.AddBelowEveryExpanded
    rw [Context.context_liftTerminalPath]
    exact outer.addBelowEveryExpanded_comp _ configuration.firstContainsAdd
      configuration.firstAddBelow
  secondAddBelow := by
    change (outer.liftTerminalPath configuration.secondPath).context.AddBelowEveryExpanded
    rw [Context.context_liftTerminalPath]
    exact outer.addBelowEveryExpanded_comp _ configuration.secondContainsAdd
      configuration.secondAddBelow
  thirdAddBelow := by
    change (outer.liftTerminalPath configuration.thirdPath).context.AddBelowEveryExpanded
    rw [Context.context_liftTerminalPath]
    exact outer.addBelowEveryExpanded_comp _ configuration.thirdContainsAdd
      configuration.thirdAddBelow

end TerminalPath.AdvancedMinConfiguration

inductive AdvancedOccurrence {k : Nat} : ELTree k -> Type
  | here (root retarded first second third : ELLabel k) :
      AdvancedOccurrence (advancedSplitTree root retarded first second third)
  | expanded (label : ELLabel k) {body : ELTree k} :
      AdvancedOccurrence body -> AdvancedOccurrence (.expanded label body)
  | addLeft {left : ELTree k} (right : ELTree k) :
      AdvancedOccurrence left -> AdvancedOccurrence (.add left right)
  | addRight (left : ELTree k) {right : ELTree k} :
      AdvancedOccurrence right -> AdvancedOccurrence (.add left right)
  | min2Left {left : ELTree k} (right : ELTree k) :
      AdvancedOccurrence left -> AdvancedOccurrence (.min2 left right)
  | min2Right (left : ELTree k) {right : ELTree k} :
      AdvancedOccurrence right -> AdvancedOccurrence (.min2 left right)
  | minFirst {first : ELTree k} (second third : ELTree k) :
      AdvancedOccurrence first -> AdvancedOccurrence (.min3 first second third)
  | minSecond (first : ELTree k) {second : ELTree k} (third : ELTree k) :
      AdvancedOccurrence second -> AdvancedOccurrence (.min3 first second third)
  | minThird (first second : ELTree k) {third : ELTree k} :
      AdvancedOccurrence third -> AdvancedOccurrence (.min3 first second third)

namespace AdvancedOccurrence

def rootLabel {k : Nat} {tree : ELTree k} :
    AdvancedOccurrence tree -> ELLabel k
  | .here root _ _ _ _ => root
  | .expanded _ occurrence | .addLeft _ occurrence |
      .addRight _ occurrence | .min2Left _ occurrence |
      .min2Right _ occurrence | .minFirst _ _ occurrence |
      .minSecond _ _ occurrence | .minThird _ _ occurrence =>
    occurrence.rootLabel

def retardedLabel {k : Nat} {tree : ELTree k} :
    AdvancedOccurrence tree -> ELLabel k
  | .here _ retarded _ _ _ => retarded
  | .expanded _ occurrence | .addLeft _ occurrence |
      .addRight _ occurrence | .min2Left _ occurrence |
      .min2Right _ occurrence | .minFirst _ _ occurrence |
      .minSecond _ _ occurrence | .minThird _ _ occurrence =>
    occurrence.retardedLabel

def firstLabel {k : Nat} {tree : ELTree k} :
    AdvancedOccurrence tree -> ELLabel k
  | .here _ _ first _ _ => first
  | .expanded _ occurrence | .addLeft _ occurrence |
      .addRight _ occurrence | .min2Left _ occurrence |
      .min2Right _ occurrence | .minFirst _ _ occurrence |
      .minSecond _ _ occurrence | .minThird _ _ occurrence =>
    occurrence.firstLabel

def secondLabel {k : Nat} {tree : ELTree k} :
    AdvancedOccurrence tree -> ELLabel k
  | .here _ _ _ second _ => second
  | .expanded _ occurrence | .addLeft _ occurrence |
      .addRight _ occurrence | .min2Left _ occurrence |
      .min2Right _ occurrence | .minFirst _ _ occurrence |
      .minSecond _ _ occurrence | .minThird _ _ occurrence =>
    occurrence.secondLabel

def thirdLabel {k : Nat} {tree : ELTree k} :
    AdvancedOccurrence tree -> ELLabel k
  | .here _ _ _ _ third => third
  | .expanded _ occurrence | .addLeft _ occurrence |
      .addRight _ occurrence | .min2Left _ occurrence |
      .min2Right _ occurrence | .minFirst _ _ occurrence |
      .minSecond _ _ occurrence | .minThird _ _ occurrence =>
    occurrence.thirdLabel

def context {k : Nat} {tree : ELTree k} :
    AdvancedOccurrence tree -> ELTree.Context k
  | .here _ _ _ _ _ => .hole
  | .expanded label occurrence => .expanded label occurrence.context
  | .addLeft right occurrence => .addLeft occurrence.context right
  | .addRight left occurrence => .addRight left occurrence.context
  | .min2Left right occurrence => .min2Left occurrence.context right
  | .min2Right left occurrence => .min2Right left occurrence.context
  | .minFirst second third occurrence =>
      .minFirst occurrence.context second third
  | .minSecond first third occurrence =>
      .minSecond first occurrence.context third
  | .minThird first second occurrence =>
      .minThird first second occurrence.context

def focus {k : Nat} {tree : ELTree k}
    (occurrence : AdvancedOccurrence tree) : ELTree k :=
  advancedSplitTree occurrence.rootLabel occurrence.retardedLabel
    occurrence.firstLabel occurrence.secondLabel occurrence.thirdLabel

theorem context_plug_focus {k : Nat} {tree : ELTree k}
    (occurrence : AdvancedOccurrence tree) :
    occurrence.context.plug occurrence.focus = tree := by
  induction occurrence with
  | here => rfl
  | expanded label occurrence ih =>
      change ELTree.expanded label (occurrence.context.plug occurrence.focus) = _
      rw [ih]
  | addLeft right occurrence ih =>
      change ELTree.add (occurrence.context.plug occurrence.focus) right = _
      rw [ih]
  | addRight left occurrence ih =>
      change ELTree.add left (occurrence.context.plug occurrence.focus) = _
      rw [ih]
  | min2Left right occurrence ih =>
      change ELTree.min2 (occurrence.context.plug occurrence.focus) right = _
      rw [ih]
  | min2Right left occurrence ih =>
      change ELTree.min2 left (occurrence.context.plug occurrence.focus) = _
      rw [ih]
  | minFirst second third occurrence ih =>
      change ELTree.min3 (occurrence.context.plug occurrence.focus) second third = _
      rw [ih]
  | minSecond first third occurrence ih =>
      change ELTree.min3 first (occurrence.context.plug occurrence.focus) third = _
      rw [ih]
  | minThird first second occurrence ih =>
      change ELTree.min3 first second (occurrence.context.plug occurrence.focus) = _
      rw [ih]

def depth {k : Nat} {tree : ELTree k} : AdvancedOccurrence tree -> Nat
  | .here _ _ _ _ _ => 0
  | .expanded _ occurrence | .addLeft _ occurrence |
      .addRight _ occurrence | .min2Left _ occurrence |
      .min2Right _ occurrence | .minFirst _ _ occurrence |
      .minSecond _ _ occurrence | .minThird _ _ occurrence =>
    occurrence.depth + 1

def configuration {k : Nat} {tree : ELTree k}
    (occurrence : AdvancedOccurrence tree) :
    TerminalPath.AdvancedMinConfiguration tree occurrence.firstLabel
      occurrence.secondLabel occurrence.thirdLabel := by
  let root : ELLabel k := occurrence.rootLabel
  let retarded : ELLabel k := occurrence.retardedLabel
  let first : ELLabel k := occurrence.firstLabel
  let second : ELLabel k := occurrence.secondLabel
  let third : ELLabel k := occurrence.thirdLabel
  let outer : Context k := occurrence.context
  have hplug :
      outer.plug (advancedSplitTree root retarded first second third) = tree := by
    simpa [outer, root, retarded, first, second, third, focus] using
      occurrence.context_plug_focus
  have lifted : TerminalPath.AdvancedMinConfiguration
      (outer.plug (advancedSplitTree root retarded first second third))
      first second third :=
    (TerminalPath.advancedMinConfiguration root retarded first second third).lift
      outer
  change TerminalPath.AdvancedMinConfiguration tree first second third
  exact hplug ▸ lifted

end AdvancedOccurrence

def findAdvancedOccurrence {k : Nat} :
    (tree : ELTree k) -> Option (AdvancedOccurrence tree)
  | .terminal _ => none
  | .expanded root
      (.add (.terminal retarded)
        (.min3 (.terminal first) (.terminal second) (.terminal third))) =>
      some (.here root retarded first second third)
  | .expanded root body =>
      (findAdvancedOccurrence body).map (fun occurrence => .expanded root occurrence)
  | .add left right =>
      match findAdvancedOccurrence left with
      | some occurrence => some (.addLeft right occurrence)
      | none => (findAdvancedOccurrence right).map (.addRight left)
  | .min2 left right =>
      match findAdvancedOccurrence left with
      | some occurrence => some (.min2Left right occurrence)
      | none => (findAdvancedOccurrence right).map (.min2Right left)
  | .min3 first second third =>
      match findAdvancedOccurrence first with
      | some occurrence => some (.minFirst second third occurrence)
      | none =>
          match findAdvancedOccurrence second with
          | some occurrence => some (.minSecond first third occurrence)
          | none => (findAdvancedOccurrence third).map (.minThird first second)
termination_by tree => tree

theorem findAdvancedOccurrence_advancedSplitTree {k : Nat}
    (root retarded first second third : ELLabel k) :
    findAdvancedOccurrence
      (advancedSplitTree root retarded first second third) =
        some (.here root retarded first second third) := by
  simp [advancedSplitTree, findAdvancedOccurrence]

namespace AdvancedOccurrence

noncomputable def reduce {k : Nat} {tree : ELTree k}
    (occurrence : AdvancedOccurrence tree)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : ELTree k :=
  occurrence.configuration.minPath.reduceAt
    (occurrence.configuration.criticalWitnessRetention Phi y)

theorem reduce_normalExpr_eval_eq {k : Nat} {tree : ELTree k}
    (occurrence : AdvancedOccurrence tree)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    (occurrence.reduce Phi y).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi y := by
  exact TerminalPath.AdvancedMinConfiguration.criticalWitnessRetention_reduceAt_normalExpr_eval_eq
    occurrence.configuration hpos hmono hbounds hargs

theorem reduce_criticalNodeBounds {k : Nat} {tree : ELTree k}
    (occurrence : AdvancedOccurrence tree)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    Context.CriticalNodeBounds .hole Phi y (occurrence.reduce Phi y) := by
  exact TerminalPath.AdvancedMinConfiguration.criticalWitnessRetention_reduceAt_criticalNodeBounds
    occurrence.configuration hpos hmono hbounds hargs

end AdvancedOccurrence

noncomputable def normalizeOne {k : Nat} (tree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : ELTree k :=
  match findAdvancedOccurrence tree with
  | none => tree
  | some occurrence => occurrence.reduce Phi y

theorem normalizeOne_eq_self_of_find_eq_none {k : Nat} (tree : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hfind : findAdvancedOccurrence tree = none) :
    normalizeOne tree Phi y = tree := by
  simp [normalizeOne, hfind]

theorem normalizeOne_normalExpr_eval_eq {k : Nat} (tree : ELTree k)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    (normalizeOne tree Phi y).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi y := by
  classical
  unfold normalizeOne
  split
  · rfl
  · exact AdvancedOccurrence.reduce_normalExpr_eval_eq _
      hpos hmono hbounds hargs

theorem normalizeOne_criticalNodeBounds {k : Nat} (tree : ELTree k)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    (hbounds : tree.NodeBounds Phi y)
    (hargs : tree.normalExpr.ArgumentsNonnegative y) :
    Context.CriticalNodeBounds .hole Phi y (normalizeOne tree Phi y) := by
  classical
  unfold normalizeOne
  split
  · exact Context.criticalNodeBounds_of_nodeBounds .hole tree Phi y hbounds
  · exact AdvancedOccurrence.reduce_criticalNodeBounds _
      hpos hmono hbounds hargs

end ELTree
end KL2003
end CollatzClassical
