import CollatzClassical.KL2003.KL2003GeneralKTerminationCore

namespace CollatzClassical
namespace KL2003

/-!
Translation equivariance for source general-`k` EL expansion traces.

This module formalizes the local algebra behind the self-similarity statement
used in KL2003 Theorem 3.1: changing the root argument by one symbolic shift
translates every descendant shift by the same amount, while preserving modes
and tree shape. It covers arbitrary finite traces of explicitly matched raw
source splits. It does not claim that the sign-sensitive scheduler chooses the
same occurrence after translation, transport contextual deletion, identify
recurrent infinite subtrees, or prove termination/order independence.
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
