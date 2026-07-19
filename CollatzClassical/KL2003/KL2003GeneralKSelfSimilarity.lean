import CollatzClassical.KL2003.KL2003GeneralKTerminationCore

namespace CollatzClassical
namespace KL2003

/-!
Translation equivariance for the source general-`k` EL expansion.

This module formalizes the local algebra behind the self-similarity statement
used in KL2003 Theorem 3.1: changing the root argument by one symbolic shift
translates every descendant shift by the same amount, while preserving modes
and tree shape. It does not yet identify recurrent infinite subtrees or prove
termination/order independence.
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

end ELTree

end KL2003
end CollatzClassical
