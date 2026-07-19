import CollatzClassical.KL2003.KL2003GeneralKElimination

namespace CollatzClassical
namespace KL2003

/-!
Internal principal-node trees for the general-k EL process.  The frontier
projection forgets expansions, while the normal projection recursively
substitutes every expanded principal node.  This module proves the source
equation-(305) bound for every node satisfying local source-row bounds.  It
does not yet define deletion or prove termination.
-/

inductive ELTree (k : Nat) where
  | terminal : ELLabel k -> ELTree k
  | expanded : ELLabel k -> ELTree k -> ELTree k
  | add : ELTree k -> ELTree k -> ELTree k
  | min2 : ELTree k -> ELTree k -> ELTree k
  | min3 : ELTree k -> ELTree k -> ELTree k -> ELTree k
deriving Repr

namespace ELTree

def frontierExpr {k : Nat} : ELTree k -> ELExpr k
  | .terminal label => .leaf label
  | .expanded label _ => .leaf label
  | .add left right => .add left.frontierExpr right.frontierExpr
  | .min2 left right =>
      .min3 left.frontierExpr right.frontierExpr right.frontierExpr
  | .min3 first second third =>
      .min3 first.frontierExpr second.frontierExpr third.frontierExpr

def normalExpr {k : Nat} : ELTree k -> ELExpr k
  | .terminal label => .leaf label
  | .expanded _ body => body.normalExpr
  | .add left right => .add left.normalExpr right.normalExpr
  | .min2 left right =>
      .min3 left.normalExpr right.normalExpr right.normalExpr
  | .min3 first second third =>
      .min3 first.normalExpr second.normalExpr third.normalExpr

def NodeBounds {k : Nat} (Phi : TrackedMode k -> Real -> Real)
    (y : Real) : ELTree k -> Prop
  | .terminal _ => True
  | .expanded label body =>
      body.NodeBounds Phi y /\
        body.frontierExpr.eval Phi y <=
          Phi label.mode (y + label.shift.eval)
  | .add left right => left.NodeBounds Phi y /\ right.NodeBounds Phi y
  | .min2 left right => left.NodeBounds Phi y /\ right.NodeBounds Phi y
  | .min3 first second third =>
      first.NodeBounds Phi y /\ second.NodeBounds Phi y /\
        third.NodeBounds Phi y

theorem normalExpr_eval_le_frontierExpr_eval {k : Nat}
    (tree : ELTree k) (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : tree.NodeBounds Phi y) :
    tree.normalExpr.eval Phi y <= tree.frontierExpr.eval Phi y := by
  induction tree with
  | terminal label => exact le_rfl
  | expanded label body ih =>
      exact le_trans (ih hbounds.1) hbounds.2
  | add left right ihLeft ihRight =>
      exact add_le_add (ihLeft hbounds.1) (ihRight hbounds.2)
  | min2 left right ihLeft ihRight =>
      exact min_le_min (ihLeft hbounds.1)
        (min_le_min (ihRight hbounds.2) (ihRight hbounds.2))
  | min3 first second third ihFirst ihSecond ihThird =>
      exact min_le_min (ihFirst hbounds.1)
        (min_le_min (ihSecond hbounds.2.1) (ihThird hbounds.2.2))

theorem expandedNode_normalExpr_eval_le_label {k : Nat}
    (label : ELLabel k) (body : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : (ELTree.expanded label body).NodeBounds Phi y) :
    body.normalExpr.eval Phi y <=
      Phi label.mode (y + label.shift.eval) :=
  le_trans (body.normalExpr_eval_le_frontierExpr_eval Phi y hbounds.1)
    hbounds.2

theorem expandedNode_criticalAssignment_bound {k : Nat}
    (label : ELLabel k) (body : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : (ELTree.expanded label body).NodeBounds Phi y)
    (assignment : ELExpr.CriticalAssignment body.normalExpr)
    (hcritical : assignment.IsCritical Phi y) :
    assignment.selectedExpr.eval Phi y <=
      Phi label.mode (y + label.shift.eval) := by
  rw [assignment.selectedExpr_eval_eq Phi y hcritical]
  exact expandedNode_normalExpr_eval_le_label label body Phi y hbounds

def ofExpr {k : Nat} : ELExpr k -> ELTree k
  | .leaf label => .terminal label
  | .add left right => .add (ofExpr left) (ofExpr right)
  | .min3 first second third =>
      .min3 (ofExpr first) (ofExpr second) (ofExpr third)

theorem frontierExpr_ofExpr {k : Nat} (expr : ELExpr k) :
    (ofExpr expr).frontierExpr = expr := by
  induction expr with
  | leaf => rfl
  | add left right ihLeft ihRight => simp [ofExpr, frontierExpr, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [ofExpr, frontierExpr, ihFirst, ihSecond, ihThird]

theorem normalExpr_ofExpr {k : Nat} (expr : ELExpr k) :
    (ofExpr expr).normalExpr = expr := by
  induction expr with
  | leaf => rfl
  | add left right ihLeft ihRight => simp [ofExpr, normalExpr, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp [ofExpr, normalExpr, ihFirst, ihSecond, ihThird]

theorem nodeBounds_ofExpr {k : Nat} (expr : ELExpr k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    (ofExpr expr).NodeBounds Phi y := by
  induction expr with
  | leaf => trivial
  | add left right ihLeft ihRight => exact ⟨ihLeft, ihRight⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      exact ⟨ihFirst, ihSecond, ihThird⟩

def sourceSplitTree {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) : ELTree (p + 1) :=
  .expanded label (ofExpr (splitTopExpr hp label))

theorem sourceSplitTree_nodeBounds {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (label : ELLabel (p + 1)) {y : Real}
    (hy : 2 <= y + label.shift.eval) :
    (sourceSplitTree hp label).NodeBounds
      (fun mode z => sourcePhiK mode z) y := by
  refine ⟨nodeBounds_ofExpr _ _ _, ?_⟩
  rw [frontierExpr_ofExpr]
  exact splitTopExpr_eval_le_sourceLeaf hp roots label hy

inductive Min3Retention where
  | keepAll
  | keepFirstSecond
  | keepFirstThird
  | keepSecondThird
  | keepFirst
  | keepSecond
  | keepThird
deriving DecidableEq, Repr

namespace Min3Retention

def retainedCount : Min3Retention -> Nat
  | .keepAll => 3
  | .keepFirstSecond | .keepFirstThird | .keepSecondThird => 2
  | .keepFirst | .keepSecond | .keepThird => 1

theorem retainedCount_pos (retention : Min3Retention) :
    0 < retention.retainedCount := by
  cases retention <;> decide

def reduce {k : Nat} (retention : Min3Retention)
    (first second third : ELTree k) : ELTree k :=
  match retention with
  | .keepAll => .min3 first second third
  | .keepFirstSecond => .min2 first second
  | .keepFirstThird => .min2 first third
  | .keepSecondThird => .min2 second third
  | .keepFirst => first
  | .keepSecond => second
  | .keepThird => third

def criticalFirst (first second third : Real) : Prop :=
  first <= second /\ first <= third

def criticalSecond (first second third : Real) : Prop :=
  second <= first /\ second <= third

def criticalThird (first second third : Real) : Prop :=
  third <= first /\ third <= second

def DeletedBranchesNoncritical (retention : Min3Retention)
    (first second third : Real) : Prop :=
  match retention with
  | .keepAll => True
  | .keepFirstSecond => ¬ criticalThird first second third
  | .keepFirstThird => ¬ criticalSecond first second third
  | .keepSecondThird => ¬ criticalFirst first second third
  | .keepFirst =>
      (¬ criticalSecond first second third) /\
        (¬ criticalThird first second third)
  | .keepSecond =>
      (¬ criticalFirst first second third) /\
        (¬ criticalThird first second third)
  | .keepThird =>
      (¬ criticalFirst first second third) /\
        (¬ criticalSecond first second third)

noncomputable def reducedValue (retention : Min3Retention)
    (first second third : Real) : Real :=
  match retention with
  | .keepAll => min first (min second third)
  | .keepFirstSecond => min first second
  | .keepFirstThird => min first third
  | .keepSecondThird => min second third
  | .keepFirst => first
  | .keepSecond => second
  | .keepThird => third

theorem one_branch_critical (first second third : Real) :
    criticalFirst first second third \/
      criticalSecond first second third \/
        criticalThird first second third := by
  rcases le_total first second with h12 | h21
  · rcases le_total first third with h13 | h31
    · exact Or.inl ⟨h12, h13⟩
    · exact Or.inr (Or.inr ⟨h31, le_trans h31 h12⟩)
  · rcases le_total second third with h23 | h32
    · exact Or.inr (Or.inl ⟨h21, h23⟩)
    · exact Or.inr (Or.inr ⟨le_trans h32 h21, h32⟩)

theorem not_all_branches_noncritical (first second third : Real) :
    ¬ ((¬ criticalFirst first second third) /\
      (¬ criticalSecond first second third) /\
      (¬ criticalThird first second third)) := by
  intro hall
  rcases one_branch_critical first second third with hfirst | hsecond | hthird
  · exact hall.1 hfirst
  · exact hall.2.1 hsecond
  · exact hall.2.2 hthird

theorem min_other_le_of_not_criticalFirst {first second third : Real}
    (hnot : ¬ criticalFirst first second third) :
    min second third <= first := by
  by_contra hcontra
  have hfirstMin : first < min second third := lt_of_not_ge hcontra
  exact hnot ⟨le_trans (le_of_lt hfirstMin) (min_le_left _ _),
    le_trans (le_of_lt hfirstMin) (min_le_right _ _)⟩

theorem reducedValue_eq_full {retention : Min3Retention}
    {first second third : Real}
    (hsound : retention.DeletedBranchesNoncritical first second third) :
    retention.reducedValue first second third =
      min first (min second third) := by
  cases retention with
  | keepAll => rfl
  | keepFirstSecond =>
      have hle : min first second <= third :=
        min_other_le_of_not_criticalFirst (first := third)
          (second := first) (third := second) hsound
      rw [← min_assoc, min_eq_left hle]
      rfl
  | keepFirstThird =>
      have hle : min first third <= second :=
        min_other_le_of_not_criticalFirst (first := second)
          (second := first) (third := third) hsound
      calc
        min first third = min (min first third) second :=
          (min_eq_left hle).symm
        _ = min first (min third second) := min_assoc _ _ _
        _ = min first (min second third) := by rw [min_comm third second]
  | keepSecondThird =>
      exact (min_eq_right
        (min_other_le_of_not_criticalFirst hsound)).symm
  | keepFirst =>
      have hfirst : criticalFirst first second third := by
        rcases one_branch_critical first second third with hfirst | hsecond | hthird
        · exact hfirst
        · exact False.elim (hsound.1 hsecond)
        · exact False.elim (hsound.2 hthird)
      exact (min_eq_left (le_min hfirst.1 hfirst.2)).symm
  | keepSecond =>
      have hsecond : criticalSecond first second third := by
        rcases one_branch_critical first second third with hfirst | hsecond | hthird
        · exact False.elim (hsound.1 hfirst)
        · exact hsecond
        · exact False.elim (hsound.2 hthird)
      change second = min first (min second third)
      rw [min_eq_left hsecond.2, min_eq_right hsecond.1]
  | keepThird =>
      have hthird : criticalThird first second third := by
        rcases one_branch_critical first second third with hfirst | hsecond | hthird
        · exact False.elim (hsound.1 hfirst)
        · exact False.elim (hsound.2 hsecond)
        · exact hthird
      change third = min first (min second third)
      rw [min_eq_right hthird.2, min_eq_right hthird.1]

theorem reduce_nodeBounds {k : Nat} (retention : Min3Retention)
    (first second third : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : (ELTree.min3 first second third).NodeBounds Phi y) :
    (retention.reduce first second third).NodeBounds Phi y := by
  cases retention <;> simp only [reduce, NodeBounds]
  · exact hbounds
  · exact ⟨hbounds.1, hbounds.2.1⟩
  · exact ⟨hbounds.1, hbounds.2.2⟩
  · exact ⟨hbounds.2.1, hbounds.2.2⟩
  · exact hbounds.1
  · exact hbounds.2.1
  · exact hbounds.2.2

theorem reduce_normalExpr_eval_eq {k : Nat}
    (retention : Min3Retention) (first second third : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hsound : retention.DeletedBranchesNoncritical
      (first.normalExpr.eval Phi y) (second.normalExpr.eval Phi y)
      (third.normalExpr.eval Phi y)) :
    (retention.reduce first second third).normalExpr.eval Phi y =
      (ELTree.min3 first second third).normalExpr.eval Phi y := by
  have hvalue := retention.reducedValue_eq_full hsound
  cases retention <;>
    simp [reduce, reducedValue, normalExpr, ELExpr.eval] at hvalue ⊢ <;>
    exact hvalue

theorem reduce_frontierExpr_eval_eq {k : Nat}
    (retention : Min3Retention) (first second third : ELTree k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hsound : retention.DeletedBranchesNoncritical
      (first.frontierExpr.eval Phi y) (second.frontierExpr.eval Phi y)
      (third.frontierExpr.eval Phi y)) :
    (retention.reduce first second third).frontierExpr.eval Phi y =
      (ELTree.min3 first second third).frontierExpr.eval Phi y := by
  have hvalue := retention.reducedValue_eq_full hsound
  cases retention <;>
    simp [reduce, reducedValue, frontierExpr, ELExpr.eval] at hvalue ⊢ <;>
    exact hvalue

end Min3Retention

inductive Min3Path {k : Nat} : ELTree k -> Type
  | here (first second third : ELTree k) :
      Min3Path (.min3 first second third)
  | expanded (label : ELLabel k) (body : ELTree k)
      (path : Min3Path body) : Min3Path (.expanded label body)
  | addLeft (left right : ELTree k) (path : Min3Path left) :
      Min3Path (.add left right)
  | addRight (left right : ELTree k) (path : Min3Path right) :
      Min3Path (.add left right)
  | min2Left (left right : ELTree k) (path : Min3Path left) :
      Min3Path (.min2 left right)
  | min2Right (left right : ELTree k) (path : Min3Path right) :
      Min3Path (.min2 left right)
  | minFirst (first second third : ELTree k) (path : Min3Path first) :
      Min3Path (.min3 first second third)
  | minSecond (first second third : ELTree k) (path : Min3Path second) :
      Min3Path (.min3 first second third)
  | minThird (first second third : ELTree k) (path : Min3Path third) :
      Min3Path (.min3 first second third)

namespace Min3Path

def firstChild {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) : ELTree k :=
  match path with
  | .here first _ _ => first
  | .expanded _ _ subpath => subpath.firstChild
  | .addLeft _ _ subpath => subpath.firstChild
  | .addRight _ _ subpath => subpath.firstChild
  | .min2Left _ _ subpath => subpath.firstChild
  | .min2Right _ _ subpath => subpath.firstChild
  | .minFirst _ _ _ subpath => subpath.firstChild
  | .minSecond _ _ _ subpath => subpath.firstChild
  | .minThird _ _ _ subpath => subpath.firstChild

def secondChild {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) : ELTree k :=
  match path with
  | .here _ second _ => second
  | .expanded _ _ subpath => subpath.secondChild
  | .addLeft _ _ subpath => subpath.secondChild
  | .addRight _ _ subpath => subpath.secondChild
  | .min2Left _ _ subpath => subpath.secondChild
  | .min2Right _ _ subpath => subpath.secondChild
  | .minFirst _ _ _ subpath => subpath.secondChild
  | .minSecond _ _ _ subpath => subpath.secondChild
  | .minThird _ _ _ subpath => subpath.secondChild

def thirdChild {k : Nat} {tree : ELTree k}
    (path : Min3Path tree) : ELTree k :=
  match path with
  | .here _ _ third => third
  | .expanded _ _ subpath => subpath.thirdChild
  | .addLeft _ _ subpath => subpath.thirdChild
  | .addRight _ _ subpath => subpath.thirdChild
  | .min2Left _ _ subpath => subpath.thirdChild
  | .min2Right _ _ subpath => subpath.thirdChild
  | .minFirst _ _ _ subpath => subpath.thirdChild
  | .minSecond _ _ _ subpath => subpath.thirdChild
  | .minThird _ _ _ subpath => subpath.thirdChild

def reduceAt {k : Nat} {tree : ELTree k}
    (retention : Min3Retention) (path : Min3Path tree) : ELTree k :=
  match path with
  | .here first second third => retention.reduce first second third
  | .expanded label _ subpath => .expanded label (subpath.reduceAt retention)
  | .addLeft _ right subpath => .add (subpath.reduceAt retention) right
  | .addRight left _ subpath => .add left (subpath.reduceAt retention)
  | .min2Left _ right subpath => .min2 (subpath.reduceAt retention) right
  | .min2Right left _ subpath => .min2 left (subpath.reduceAt retention)
  | .minFirst _ second third subpath =>
      .min3 (subpath.reduceAt retention) second third
  | .minSecond first _ third subpath =>
      .min3 first (subpath.reduceAt retention) third
  | .minThird first second _ subpath =>
      .min3 first second (subpath.reduceAt retention)

theorem reduceAt_normalExpr_eval_eq {k : Nat} {tree : ELTree k}
    (retention : Min3Retention) (path : Min3Path tree)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hsound : retention.DeletedBranchesNoncritical
      (path.firstChild.normalExpr.eval Phi y)
      (path.secondChild.normalExpr.eval Phi y)
      (path.thirdChild.normalExpr.eval Phi y)) :
    (path.reduceAt retention).normalExpr.eval Phi y =
      tree.normalExpr.eval Phi y := by
  induction path with
  | here first second third =>
      exact retention.reduce_normalExpr_eval_eq first second third Phi y hsound
  | expanded label body path ih =>
      simpa [reduceAt, normalExpr, firstChild, secondChild, thirdChild]
        using ih hsound
  | addLeft left right path ih =>
      simp [reduceAt, normalExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | addRight left right path ih =>
      simp [reduceAt, normalExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | min2Left left right path ih =>
      simp [reduceAt, normalExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | min2Right left right path ih =>
      simp [reduceAt, normalExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | minFirst first second third path ih =>
      simp [reduceAt, normalExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | minSecond first second third path ih =>
      simp [reduceAt, normalExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | minThird first second third path ih =>
      simp [reduceAt, normalExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]

theorem reduceAt_frontierExpr_eval_eq {k : Nat} {tree : ELTree k}
    (retention : Min3Retention) (path : Min3Path tree)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hsound : retention.DeletedBranchesNoncritical
      (path.firstChild.frontierExpr.eval Phi y)
      (path.secondChild.frontierExpr.eval Phi y)
      (path.thirdChild.frontierExpr.eval Phi y)) :
    (path.reduceAt retention).frontierExpr.eval Phi y =
      tree.frontierExpr.eval Phi y := by
  induction path with
  | here first second third =>
      exact retention.reduce_frontierExpr_eval_eq first second third Phi y hsound
  | expanded => rfl
  | addLeft left right path ih =>
      simp [reduceAt, frontierExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | addRight left right path ih =>
      simp [reduceAt, frontierExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | min2Left left right path ih =>
      simp [reduceAt, frontierExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | min2Right left right path ih =>
      simp [reduceAt, frontierExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | minFirst first second third path ih =>
      simp [reduceAt, frontierExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | minSecond first second third path ih =>
      simp [reduceAt, frontierExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]
  | minThird first second third path ih =>
      simp [reduceAt, frontierExpr, ELExpr.eval, firstChild, secondChild,
        thirdChild, ih hsound]

theorem reduceAt_nodeBounds {k : Nat} {tree : ELTree k}
    (retention : Min3Retention) (path : Min3Path tree)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hbounds : tree.NodeBounds Phi y)
    (hsound : retention.DeletedBranchesNoncritical
      (path.firstChild.frontierExpr.eval Phi y)
      (path.secondChild.frontierExpr.eval Phi y)
      (path.thirdChild.frontierExpr.eval Phi y)) :
    (path.reduceAt retention).NodeBounds Phi y := by
  induction path with
  | here first second third =>
      exact retention.reduce_nodeBounds first second third Phi y hbounds
  | expanded label body path ih =>
      refine ⟨ih hbounds.1 hsound, ?_⟩
      rw [reduceAt_frontierExpr_eval_eq retention path Phi y hsound]
      exact hbounds.2
  | addLeft left right path ih => exact ⟨ih hbounds.1 hsound, hbounds.2⟩
  | addRight left right path ih => exact ⟨hbounds.1, ih hbounds.2 hsound⟩
  | min2Left left right path ih => exact ⟨ih hbounds.1 hsound, hbounds.2⟩
  | min2Right left right path ih => exact ⟨hbounds.1, ih hbounds.2 hsound⟩
  | minFirst first second third path ih =>
      exact ⟨ih hbounds.1 hsound, hbounds.2.1, hbounds.2.2⟩
  | minSecond first second third path ih =>
      exact ⟨hbounds.1, ih hbounds.2.1 hsound, hbounds.2.2⟩
  | minThird first second third path ih =>
      exact ⟨hbounds.1, hbounds.2.1, ih hbounds.2.2 hsound⟩

end Min3Path

inductive TerminalPath {k : Nat} : ELTree k -> ELLabel k -> Type
  | here (label : ELLabel k) : TerminalPath (.terminal label) label
  | expanded (label : ELLabel k) (body : ELTree k)
      (target : ELLabel k) (path : TerminalPath body target) :
      TerminalPath (.expanded label body) target
  | addLeft (left right : ELTree k) (target : ELLabel k)
      (path : TerminalPath left target) :
      TerminalPath (.add left right) target
  | addRight (left right : ELTree k) (target : ELLabel k)
      (path : TerminalPath right target) :
      TerminalPath (.add left right) target
  | min2Left (left right : ELTree k) (target : ELLabel k)
      (path : TerminalPath left target) :
      TerminalPath (.min2 left right) target
  | min2Right (left right : ELTree k) (target : ELLabel k)
      (path : TerminalPath right target) :
      TerminalPath (.min2 left right) target
  | minFirst (first second third : ELTree k) (target : ELLabel k)
      (path : TerminalPath first target) :
      TerminalPath (.min3 first second third) target
  | minSecond (first second third : ELTree k) (target : ELLabel k)
      (path : TerminalPath second target) :
      TerminalPath (.min3 first second third) target
  | minThird (first second third : ELTree k) (target : ELLabel k)
      (path : TerminalPath third target) :
      TerminalPath (.min3 first second third) target

namespace TerminalPath

def splitAt {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target) : ELTree (p + 1) :=
  match path with
  | .here label => sourceSplitTree hp label
  | .expanded label _ _ subpath => .expanded label (subpath.splitAt hp)
  | .addLeft _ right _ subpath => .add (subpath.splitAt hp) right
  | .addRight left _ _ subpath => .add left (subpath.splitAt hp)
  | .min2Left _ right _ subpath => .min2 (subpath.splitAt hp) right
  | .min2Right left _ _ subpath => .min2 left (subpath.splitAt hp)
  | .minFirst _ second third _ subpath =>
      .min3 (subpath.splitAt hp) second third
  | .minSecond first _ third _ subpath =>
      .min3 first (subpath.splitAt hp) third
  | .minThird first second _ _ subpath =>
      .min3 first second (subpath.splitAt hp)

theorem frontierExpr_splitAt {p : Nat} (hp : 1 <= p)
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target) :
    (path.splitAt hp).frontierExpr = tree.frontierExpr := by
  induction path with
  | here => rfl
  | expanded => rfl
  | addLeft _ _ _ _ ih => simp [splitAt, frontierExpr, ih]
  | addRight _ _ _ _ ih => simp [splitAt, frontierExpr, ih]
  | min2Left _ _ _ _ ih => simp [splitAt, frontierExpr, ih]
  | min2Right _ _ _ _ ih => simp [splitAt, frontierExpr, ih]
  | minFirst _ _ _ _ _ ih => simp [splitAt, frontierExpr, ih]
  | minSecond _ _ _ _ _ ih => simp [splitAt, frontierExpr, ih]
  | minThird _ _ _ _ _ ih => simp [splitAt, frontierExpr, ih]

theorem splitAt_nodeBounds {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    {tree : ELTree (p + 1)} {target : ELLabel (p + 1)}
    (path : TerminalPath tree target)
    {y : Real} (hbounds : tree.NodeBounds
      (fun mode z => sourcePhiK mode z) y)
    (hy : 2 <= y + target.shift.eval) :
    (path.splitAt hp).NodeBounds (fun mode z => sourcePhiK mode z) y := by
  induction path with
  | here label => exact sourceSplitTree_nodeBounds hp roots label hy
  | expanded label body target path ih =>
      refine ⟨ih hbounds.1 hy, ?_⟩
      rw [frontierExpr_splitAt]
      exact hbounds.2
  | addLeft left right target path ih =>
      exact ⟨ih hbounds.1 hy, hbounds.2⟩
  | addRight left right target path ih =>
      exact ⟨hbounds.1, ih hbounds.2 hy⟩
  | min2Left left right target path ih =>
      exact ⟨ih hbounds.1 hy, hbounds.2⟩
  | min2Right left right target path ih =>
      exact ⟨hbounds.1, ih hbounds.2 hy⟩
  | minFirst first second third target path ih =>
      exact ⟨ih hbounds.1 hy, hbounds.2.1, hbounds.2.2⟩
  | minSecond first second third target path ih =>
      exact ⟨hbounds.1, ih hbounds.2.1 hy, hbounds.2.2⟩
  | minThird first second third target path ih =>
      exact ⟨hbounds.1, hbounds.2.1, ih hbounds.2.2 hy⟩

end TerminalPath

theorem sourceSplitTree_criticalAssignment_bound {p : Nat}
    (hp : 1 <= p) (roots : GeneralKClassRootsNonempty (p + 1))
    (label : ELLabel (p + 1)) {y : Real}
    (hy : 2 <= y + label.shift.eval)
    (assignment : ELExpr.CriticalAssignment
      (sourceSplitTree hp label).normalExpr)
    (hcritical : assignment.IsCritical
      (fun mode z => sourcePhiK mode z) y) :
    assignment.selectedExpr.eval (fun mode z => sourcePhiK mode z) y <=
      sourcePhiK label.mode (y + label.shift.eval) :=
  expandedNode_criticalAssignment_bound label
    (ofExpr (splitTopExpr hp label)) _ _
    (sourceSplitTree_nodeBounds hp roots label hy) assignment hcritical

end ELTree

end KL2003
end CollatzClassical
