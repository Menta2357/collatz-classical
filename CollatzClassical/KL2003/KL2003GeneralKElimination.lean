import CollatzClassical.KL2003.KL2003GeneralKOriginalRows
import CollatzClassical.KL2003.KL2003GeneralKRetardedLowerBound

namespace CollatzClassical
namespace KL2003

/-!
Foundational syntax for the general-k EL elimination process.  This stage
defines symbolic shifts, nested expressions, and deletion witnesses.  It does
not yet claim termination, normal-form uniqueness, or semantic preservation.
-/

structure SymbolicShift where
  alphaCoeff : Int
  constCoeff : Int
deriving DecidableEq, Repr

namespace SymbolicShift

noncomputable def eval (shift : SymbolicShift) : Real :=
  (shift.alphaCoeff : Real) * alpha + (shift.constCoeff : Real)

def zero : SymbolicShift := ⟨0, 0⟩

def add (left right : SymbolicShift) : SymbolicShift :=
  ⟨left.alphaCoeff + right.alphaCoeff,
    left.constCoeff + right.constCoeff⟩

def neg (shift : SymbolicShift) : SymbolicShift :=
  ⟨-shift.alphaCoeff, -shift.constCoeff⟩

def sub (left right : SymbolicShift) : SymbolicShift :=
  left.add right.neg

instance : Add SymbolicShift := ⟨add⟩
instance : Neg SymbolicShift := ⟨neg⟩
instance : Sub SymbolicShift := ⟨sub⟩

theorem eval_zero : zero.eval = 0 := by
  simp [zero, eval]

theorem eval_add (left right : SymbolicShift) :
    (left + right).eval = left.eval + right.eval := by
  change
    (((left.alphaCoeff + right.alphaCoeff : Int) : Real) * alpha +
        ((left.constCoeff + right.constCoeff : Int) : Real)) =
      ((left.alphaCoeff : Real) * alpha + (left.constCoeff : Real)) +
        ((right.alphaCoeff : Real) * alpha + (right.constCoeff : Real))
  push_cast
  ring

theorem eval_neg (shift : SymbolicShift) :
    (-shift).eval = -shift.eval := by
  change
    (((-shift.alphaCoeff : Int) : Real) * alpha +
        ((-shift.constCoeff : Int) : Real)) =
      -((shift.alphaCoeff : Real) * alpha + (shift.constCoeff : Real))
  push_cast
  ring

theorem eval_sub (left right : SymbolicShift) :
    (left - right).eval = left.eval - right.eval := by
  rw [show left - right = left + -right by rfl, eval_add, eval_neg]
  ring

def retardedTwo : SymbolicShift := ⟨0, -2⟩
def d1Advanced : SymbolicShift := ⟨1, -2⟩
def d3Advanced : SymbolicShift := ⟨1, -1⟩

theorem eval_retardedTwo : retardedTwo.eval = -2 := by
  norm_num [retardedTwo, eval]

theorem eval_d1Advanced : d1Advanced.eval = alpha - 2 := by
  norm_num [d1Advanced, eval]
  ring

theorem eval_d3Advanced : d3Advanced.eval = alpha - 1 := by
  norm_num [d3Advanced, eval]
  ring

theorem d1Advanced_retarded : d1Advanced.eval < 0 := by
  rw [eval_d1Advanced]
  have h := alpha_upper_bound
  linarith

theorem d3Advanced_advanced : 0 < d3Advanced.eval := by
  rw [eval_d3Advanced]
  have h := alpha_lower_bound
  linarith

end SymbolicShift

structure ELLabel (k : Nat) where
  mode : TrackedMode k
  shift : SymbolicShift
deriving Repr

inductive ELExpr (k : Nat) where
  | leaf : ELLabel k -> ELExpr k
  | add : ELExpr k -> ELExpr k -> ELExpr k
  | min3 : ELExpr k -> ELExpr k -> ELExpr k -> ELExpr k
deriving Repr

namespace ELExpr

noncomputable def eval {k : Nat}
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : ELExpr k -> Real
  | leaf label => Phi label.mode (y + label.shift.eval)
  | add left right => left.eval Phi y + right.eval Phi y
  | min3 first second third =>
      min (first.eval Phi y) (min (second.eval Phi y) (third.eval Phi y))

noncomputable def toRetardedExpr {k : Nat} :
    ELExpr k -> RetardedExpr (TrackedMode k)
  | leaf label => .leaf label.mode label.shift.eval
  | add left right => .add left.toRetardedExpr right.toRetardedExpr
  | min3 first second third =>
      .minE first.toRetardedExpr
        (.minE second.toRetardedExpr third.toRetardedExpr)

theorem toRetardedExpr_evalAt {k : Nat}
    (expr : ELExpr k) (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    expr.toRetardedExpr.evalAt Phi y = expr.eval Phi y := by
  induction expr with
  | leaf label => rfl
  | add left right ihLeft ihRight =>
      change
        left.toRetardedExpr.evalAt Phi y + right.toRetardedExpr.evalAt Phi y =
          left.eval Phi y + right.eval Phi y
      rw [ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      change
        min (first.toRetardedExpr.evalAt Phi y)
            (min (second.toRetardedExpr.evalAt Phi y)
              (third.toRetardedExpr.evalAt Phi y)) =
          min (first.eval Phi y)
            (min (second.eval Phi y) (third.eval Phi y))
      rw [ihFirst, ihSecond, ihThird]

def leafCount {k : Nat} : ELExpr k -> Nat
  | leaf _ => 1
  | add left right => left.leafCount + right.leafCount
  | min3 first second third =>
      first.leafCount + second.leafCount + third.leafCount

theorem leafCount_pos {k : Nat} (expr : ELExpr k) :
    0 < expr.leafCount := by
  induction expr with
  | leaf _ => simp [leafCount]
  | add _ _ ihLeft ihRight =>
      simp only [leafCount]
      omega
  | min3 _ _ _ ihFirst ihSecond ihThird =>
      simp only [leafCount]
      omega

end ELExpr

inductive ELNodeStatus where
  | active
  | retardedTerminal
  | deleted
deriving DecidableEq, Repr

structure ELLeafState (k : Nat) where
  label : ELLabel k
  ancestors : List (ELLabel k)
  status : ELNodeStatus
deriving Repr

def HasDeletionWitness {k : Nat} (leaf : ELLeafState k) : Prop :=
  0 <= leaf.label.shift.eval /\
    exists ancestor, ancestor ∈ leaf.ancestors /\
      ancestor.mode = leaf.label.mode /\
      ancestor.shift.eval < leaf.label.shift.eval

def PositivePhi {Index : Type*} (Phi : Index -> Real -> Real) : Prop :=
  forall i y, 0 <= y -> 0 < Phi i y

def MonotonePhi {Index : Type*} (Phi : Index -> Real -> Real) : Prop :=
  forall i, Monotone (Phi i)

theorem deletionWitness_ancestor_le_leaf {k : Nat}
    {Phi : TrackedMode k -> Real -> Real}
    (hmono : MonotonePhi Phi) {y : Real} {leaf : ELLeafState k}
    (hwitness : HasDeletionWitness leaf) :
    exists ancestor, ancestor ∈ leaf.ancestors /\
      ancestor.mode = leaf.label.mode /\
      Phi ancestor.mode (y + ancestor.shift.eval) <=
        Phi leaf.label.mode (y + leaf.label.shift.eval) := by
  rcases hwitness.2 with ⟨ancestor, hmem, hmode, hshift⟩
  refine ⟨ancestor, hmem, hmode, ?_⟩
  rw [hmode]
  exact hmono leaf.label.mode (by linarith)

end KL2003
end CollatzClassical
