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
  | min3 : ELTree k -> ELTree k -> ELTree k -> ELTree k
deriving Repr

namespace ELTree

def frontierExpr {k : Nat} : ELTree k -> ELExpr k
  | .terminal label => .leaf label
  | .expanded label _ => .leaf label
  | .add left right => .add left.frontierExpr right.frontierExpr
  | .min3 first second third =>
      .min3 first.frontierExpr second.frontierExpr third.frontierExpr

def normalExpr {k : Nat} : ELTree k -> ELExpr k
  | .terminal label => .leaf label
  | .expanded _ body => body.normalExpr
  | .add left right => .add left.normalExpr right.normalExpr
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
