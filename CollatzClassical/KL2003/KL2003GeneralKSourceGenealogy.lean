import CollatzClassical.KL2003.KL2003GeneralKInfiniteBranchDescent

namespace CollatzClassical
namespace KL2003

/-!
Source provenance for the general-k EL scheduler.

The scheduler's raw `ELTree` labels remember only their current mode and
symbolic shift.  This module equips every label with a concrete typed
`SourceWalk` from one fixed root and proves that one source expansion preserves
that provenance.  It deliberately does not yet lift terminal paths, deletion,
or the complete scheduler step.
-/

namespace GeneralKSourceGenealogy

open GeneralKSourceGraph

/-- A raw EL label together with its exact typed source-action genealogy from
the fixed root label. -/
structure ProvenancedLabel {p : Nat} (hp : 1 <= p)
    (root : ELLabel (p + 1)) where
  label : ELLabel (p + 1)
  walk : SourceWalk hp root.mode label.mode
  shift_eq : label.shift = root.shift + walk.weight

namespace ProvenancedLabel

/-- The root label carries the empty source walk. -/
def root {p : Nat} (hp : 1 <= p) (label : ELLabel (p + 1)) :
    ProvenancedLabel hp label where
  label := label
  walk := SourceWalk.nil label.mode
  shift_eq := by
    rw [SourceWalk.weight_nil, shift_add_zero]

/-- A source action as a one-edge typed walk. -/
def oneStepWalk {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} (action : SourceAction mode) :
    SourceWalk hp mode (action.target hp) :=
  SourceWalk.cons action (SourceWalk.nil (action.target hp))

@[simp] theorem oneStepWalk_length {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} (action : SourceAction mode) :
    (oneStepWalk (hp := hp) action).length = 1 := by
  simp [oneStepWalk]

@[simp] theorem oneStepWalk_weight {p : Nat} {hp : 1 <= p}
    {mode : TrackedMode (p + 1)} (action : SourceAction mode) :
    (oneStepWalk (hp := hp) action).weight = action.weight := by
  simp [oneStepWalk, shift_add_zero]

/-- Extend a provenance by one valid source action. -/
def child {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root) (action : SourceAction node.label.mode) :
    ProvenancedLabel hp root where
  label := action.childLabel hp node.label
  walk := node.walk.append (oneStepWalk (hp := hp) action)
  shift_eq := by
    change node.label.shift + action.weight =
      root.shift +
        (node.walk.append (oneStepWalk (hp := hp) action)).weight
    rw [SourceWalk.weight_append, oneStepWalk_weight, node.shift_eq]
    exact shift_add_assoc root.shift node.walk.weight action.weight

@[simp] theorem child_label {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root)
    (action : SourceAction node.label.mode) :
    (node.child action).label = action.childLabel hp node.label := rfl

@[simp] theorem child_walk_length {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root)
    (action : SourceAction node.label.mode) :
    (node.child action).walk.length = node.walk.length + 1 := by
  rw [child, SourceWalk.length_append, oneStepWalk_length]

@[simp] theorem child_walk_weight {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root)
    (action : SourceAction node.label.mode) :
    (node.child action).walk.weight = node.walk.weight + action.weight := by
  rw [child, SourceWalk.weight_append, oneStepWalk_weight]

end ProvenancedLabel

/-- An EL tree whose principal and terminal labels all carry source
genealogy from one fixed root. -/
inductive ProvenancedTree {p : Nat} (hp : 1 <= p)
    (root : ELLabel (p + 1)) where
  | terminal : ProvenancedLabel hp root -> ProvenancedTree hp root
  | expanded : ProvenancedLabel hp root -> ProvenancedTree hp root ->
      ProvenancedTree hp root
  | add : ProvenancedTree hp root -> ProvenancedTree hp root ->
      ProvenancedTree hp root
  | min2 : ProvenancedTree hp root -> ProvenancedTree hp root ->
      ProvenancedTree hp root
  | min3 : ProvenancedTree hp root -> ProvenancedTree hp root ->
      ProvenancedTree hp root -> ProvenancedTree hp root

namespace ProvenancedTree

/-- Forget source genealogy and recover the existing raw EL tree. -/
def forget {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)} :
    ProvenancedTree hp root -> ELTree (p + 1)
  | .terminal node => .terminal node.label
  | .expanded node body => .expanded node.label body.forget
  | .add left right => .add left.forget right.forget
  | .min2 left right => .min2 left.forget right.forget
  | .min3 first second third =>
      .min3 first.forget second.forget third.forget

/-- The annotated initial tree containing only its root terminal. -/
def initial {p : Nat} (hp : 1 <= p) (root : ELLabel (p + 1)) :
    ProvenancedTree hp root :=
  .terminal (ProvenancedLabel.root hp root)

@[simp] theorem forget_initial {p : Nat} (hp : 1 <= p)
    (root : ELLabel (p + 1)) :
    (initial hp root).forget = .terminal root := rfl

/-- Apply an existing min-three retention decision without changing the
provenance stored in any retained branch. -/
def reduce {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (retention : ELTree.Min3Retention)
    (first second third : ProvenancedTree hp root) :
    ProvenancedTree hp root :=
  match retention with
  | .keepAll => .min3 first second third
  | .keepFirstSecond => .min2 first second
  | .keepFirstThird => .min2 first third
  | .keepSecondThird => .min2 second third
  | .keepFirst => first
  | .keepSecond => second
  | .keepThird => third

@[simp] theorem forget_reduce {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (retention : ELTree.Min3Retention)
    (first second third : ProvenancedTree hp root) :
    (reduce retention first second third).forget =
      retention.reduce first.forget second.forget third.forget := by
  cases retention <;> rfl

/-- The source-faithful annotated expansion of one provenanced label. -/
def sourceSplit {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    (node : ProvenancedLabel hp root) : ProvenancedTree hp root := by
  classical
  by_cases hm2 : node.label.mode.1.1 % 9 = 2
  · exact .expanded node
      (.add
        (.terminal (node.child (retardedAction node.label.mode)))
        (.min3
          (.terminal (node.child (d1AdvancedAction node.label.mode hm2 0)))
          (.terminal (node.child (d1AdvancedAction node.label.mode hm2 1)))
          (.terminal (node.child (d1AdvancedAction node.label.mode hm2 2)))))
  by_cases hm5 : node.label.mode.1.1 % 9 = 5
  · exact .expanded node
      (.terminal (node.child (retardedAction node.label.mode)))
  · have hm8 : node.label.mode.1.1 % 9 = 8 := by
      rcases trackedMode_mod_nine_cases node.label.mode with h | h | h
      · exact False.elim (hm2 h)
      · exact False.elim (hm5 h)
      · exact h
    exact .expanded node
      (.add
        (.terminal (node.child (retardedAction node.label.mode)))
        (.min3
          (.terminal (node.child (d3AdvancedAction node.label.mode hm8 0)))
          (.terminal (node.child (d3AdvancedAction node.label.mode hm8 1)))
          (.terminal (node.child (d3AdvancedAction node.label.mode hm8 2)))))

theorem sourceSplit_forget {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} (node : ProvenancedLabel hp root) :
    (sourceSplit node).forget = ELTree.sourceSplitTree hp node.label := by
  classical
  by_cases hm2 : node.label.mode.1.1 % 9 = 2
  · rw [ELTree.sourceSplitTree_eq_advanced_d1 hp node.label hm2]
    simp [sourceSplit, hm2, forget, ELTree.advancedSplitTree,
      childLabel_retarded, childLabel_d1Advanced]
  by_cases hm5 : node.label.mode.1.1 % 9 = 5
  · simp [sourceSplit, hm2, hm5, ELTree.sourceSplitTree,
      splitTopExpr, d2TopExpr, ELExpr.shiftBy, ELTree.ofExpr, forget,
      childLabel_retarded, ELTree.retardedSplitLabel]
    congr
  · have hm8 : node.label.mode.1.1 % 9 = 8 := by
      rcases trackedMode_mod_nine_cases node.label.mode with h | h | h
      · exact False.elim (hm2 h)
      · exact False.elim (hm5 h)
      · exact h
    rw [ELTree.sourceSplitTree_eq_advanced_d3 hp node.label hm8]
    simp [sourceSplit, hm2, hm5, forget, ELTree.advancedSplitTree,
      childLabel_retarded, childLabel_d3Advanced]

/-- A terminal path that retains the provenanced terminal object rather than
only its forgotten label. -/
inductive TerminalPath {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} :
    (tree : ProvenancedTree hp root) -> ProvenancedLabel hp root -> Type
  | here (node : ProvenancedLabel hp root) :
      TerminalPath (.terminal node) node
  | expanded (node : ProvenancedLabel hp root)
      (body : ProvenancedTree hp root) (target : ProvenancedLabel hp root)
      (path : TerminalPath body target) :
      TerminalPath (.expanded node body) target
  | addLeft (left right : ProvenancedTree hp root)
      (target : ProvenancedLabel hp root) (path : TerminalPath left target) :
      TerminalPath (.add left right) target
  | addRight (left right : ProvenancedTree hp root)
      (target : ProvenancedLabel hp root) (path : TerminalPath right target) :
      TerminalPath (.add left right) target
  | min2Left (left right : ProvenancedTree hp root)
      (target : ProvenancedLabel hp root) (path : TerminalPath left target) :
      TerminalPath (.min2 left right) target
  | min2Right (left right : ProvenancedTree hp root)
      (target : ProvenancedLabel hp root) (path : TerminalPath right target) :
      TerminalPath (.min2 left right) target
  | minFirst (first second third : ProvenancedTree hp root)
      (target : ProvenancedLabel hp root) (path : TerminalPath first target) :
      TerminalPath (.min3 first second third) target
  | minSecond (first second third : ProvenancedTree hp root)
      (target : ProvenancedLabel hp root) (path : TerminalPath second target) :
      TerminalPath (.min3 first second third) target
  | minThird (first second third : ProvenancedTree hp root)
      (target : ProvenancedLabel hp root) (path : TerminalPath third target) :
      TerminalPath (.min3 first second third) target

namespace TerminalPath

/-- Forget provenance in a terminal path. -/
def forgetPath {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : TerminalPath tree target) :
    ELTree.TerminalPath tree.forget target.label :=
  match path with
  | .here node => .here node.label
  | .expanded node body target subpath =>
      .expanded node.label body.forget target.label subpath.forgetPath
  | .addLeft left right target subpath =>
      .addLeft left.forget right.forget target.label subpath.forgetPath
  | .addRight left right target subpath =>
      .addRight left.forget right.forget target.label subpath.forgetPath
  | .min2Left left right target subpath =>
      .min2Left left.forget right.forget target.label subpath.forgetPath
  | .min2Right left right target subpath =>
      .min2Right left.forget right.forget target.label subpath.forgetPath
  | .minFirst first second third target subpath =>
      .minFirst first.forget second.forget third.forget target.label
        subpath.forgetPath
  | .minSecond first second third target subpath =>
      .minSecond first.forget second.forget third.forget target.label
        subpath.forgetPath
  | .minThird first second third target subpath =>
      .minThird first.forget second.forget third.forget target.label
        subpath.forgetPath

/-- Replace the selected provenanced terminal by its annotated source split. -/
def splitAt {p : Nat} {hp : 1 <= p} {root : ELLabel (p + 1)}
    {tree : ProvenancedTree hp root} {target : ProvenancedLabel hp root}
    (path : TerminalPath tree target) : ProvenancedTree hp root :=
  match path with
  | .here node => sourceSplit node
  | .expanded node _ _ subpath => .expanded node subpath.splitAt
  | .addLeft _ right _ subpath => .add subpath.splitAt right
  | .addRight left _ _ subpath => .add left subpath.splitAt
  | .min2Left _ right _ subpath => .min2 subpath.splitAt right
  | .min2Right left _ _ subpath => .min2 left subpath.splitAt
  | .minFirst _ second third _ subpath =>
      .min3 subpath.splitAt second third
  | .minSecond first _ third _ subpath =>
      .min3 first subpath.splitAt third
  | .minThird first second _ _ subpath =>
      .min3 first second subpath.splitAt

theorem forget_splitAt {p : Nat} {hp : 1 <= p}
    {root : ELLabel (p + 1)} {tree : ProvenancedTree hp root}
    {target : ProvenancedLabel hp root} (path : TerminalPath tree target) :
    path.splitAt.forget = (path.forgetPath).splitAt hp := by
  induction path with
  | here node => exact sourceSplit_forget node
  | expanded node body target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]
  | addLeft left right target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]
  | addRight left right target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]
  | min2Left left right target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]
  | min2Right left right target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]
  | minFirst first second third target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]
  | minSecond first second third target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]
  | minThird first second third target path ih =>
      simp [splitAt, forget, forgetPath, ELTree.TerminalPath.splitAt, ih]

end TerminalPath

end ProvenancedTree

end GeneralKSourceGenealogy

end KL2003
end CollatzClassical
