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

def elLeaf {k : Nat} (mode : TrackedMode k)
    (shift : SymbolicShift) : ELExpr k :=
  .leaf ⟨mode, shift⟩

def d1TopExpr {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2) :
    ELExpr (p + 1) :=
  .add
    (elLeaf (fourTrackedMode (by omega) m) .retardedTwo)
    (.min3
      (elLeaf (liftTrackedMode hp (d1LowerTrackedMode hp m hm) 0)
        .d1Advanced)
      (elLeaf (liftTrackedMode hp (d1LowerTrackedMode hp m hm) 1)
        .d1Advanced)
      (elLeaf (liftTrackedMode hp (d1LowerTrackedMode hp m hm) 2)
        .d1Advanced))

def d2TopExpr {p : Nat} (_hp : 1 <= p)
    (m : TrackedMode (p + 1)) : ELExpr (p + 1) :=
  elLeaf (fourTrackedMode (by omega) m) .retardedTwo

def d3TopExpr {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8) :
    ELExpr (p + 1) :=
  .add
    (elLeaf (fourTrackedMode (by omega) m) .retardedTwo)
    (.min3
      (elLeaf (liftTrackedMode hp (d3LowerTrackedMode hp m hm) 0)
        .d3Advanced)
      (elLeaf (liftTrackedMode hp (d3LowerTrackedMode hp m hm) 1)
        .d3Advanced)
      (elLeaf (liftTrackedMode hp (d3LowerTrackedMode hp m hm) 2)
        .d3Advanced))

theorem d1TopExpr_eval {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) :
    (d1TopExpr hp m hm).eval Phi y =
      Phi (fourTrackedMode (by omega) m) (y - 2) +
        min (Phi (liftTrackedMode hp (d1LowerTrackedMode hp m hm) 0)
              (y + alpha - 2))
          (min (Phi (liftTrackedMode hp (d1LowerTrackedMode hp m hm) 1)
                (y + alpha - 2))
            (Phi (liftTrackedMode hp (d1LowerTrackedMode hp m hm) 2)
              (y + alpha - 2))) := by
  simp [d1TopExpr, elLeaf, ELExpr.eval,
    SymbolicShift.eval_retardedTwo, SymbolicShift.eval_d1Advanced]
  ring_nf

theorem d2TopExpr_eval {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1))
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) :
    (d2TopExpr hp m).eval Phi y =
      Phi (fourTrackedMode (by omega) m) (y - 2) := by
  change Phi (fourTrackedMode (by omega) m)
    (y + SymbolicShift.retardedTwo.eval) = _
  rw [SymbolicShift.eval_retardedTwo]
  congr 1

theorem d3TopExpr_eval {p : Nat} (hp : 1 <= p)
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8)
    (Phi : TrackedMode (p + 1) -> Real -> Real) (y : Real) :
    (d3TopExpr hp m hm).eval Phi y =
      Phi (fourTrackedMode (by omega) m) (y - 2) +
        min (Phi (liftTrackedMode hp (d3LowerTrackedMode hp m hm) 0)
              (y + alpha - 1))
          (min (Phi (liftTrackedMode hp (d3LowerTrackedMode hp m hm) 1)
                (y + alpha - 1))
            (Phi (liftTrackedMode hp (d3LowerTrackedMode hp m hm) 2)
              (y + alpha - 1))) := by
  simp [d3TopExpr, elLeaf, ELExpr.eval,
    SymbolicShift.eval_retardedTwo, SymbolicShift.eval_d3Advanced]
  ring_nf

theorem sourcePhiK_D1_topExpr {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 2)
    {y : Real} (hy : 2 <= y) :
    (d1TopExpr hp m hm).eval (fun mode z => sourcePhiK mode z) y <=
      sourcePhiK m y := by
  have hyAdv : 0 <= y + alpha - 2 := by
    have h := alpha_lower_bound
    linarith
  rw [d1TopExpr_eval]
  have hp3 := sourcePhiK_P3 hp roots (d1LowerTrackedMode hp m hm) hyAdv
  simp only [sourcePhiK_liftMin3] at hp3
  rw [← hp3]
  exact sourcePhiK_D1 hp roots m hm hy

theorem sourcePhiK_D2_topExpr {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 5)
    {y : Real} (hy : 2 <= y) :
    (d2TopExpr hp m).eval (fun mode z => sourcePhiK mode z) y <=
      sourcePhiK m y := by
  rw [d2TopExpr_eval]
  exact sourcePhiK_D2 hp roots m hm hy

theorem sourcePhiK_D3_topExpr {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (m : TrackedMode (p + 1)) (hm : m.1.1 % 9 = 8)
    {y : Real} (hy : 2 <= y) :
    (d3TopExpr hp m hm).eval (fun mode z => sourcePhiK mode z) y <=
      sourcePhiK m y := by
  have hyAdv : 0 <= y + alpha - 1 := by
    have h := alpha_lower_bound
    linarith
  rw [d3TopExpr_eval]
  have hp3 := sourcePhiK_P3 hp roots (d3LowerTrackedMode hp m hm) hyAdv
  simp only [sourcePhiK_liftMin3] at hp3
  rw [← hp3]
  exact sourcePhiK_D3 hp roots m hm hy

def ELExpr.shiftBy {k : Nat} (delta : SymbolicShift) : ELExpr k -> ELExpr k
  | .leaf label => .leaf ⟨label.mode, delta + label.shift⟩
  | .add left right => .add (left.shiftBy delta) (right.shiftBy delta)
  | .min3 first second third =>
      .min3 (first.shiftBy delta) (second.shiftBy delta)
        (third.shiftBy delta)

theorem ELExpr.shiftBy_eval {k : Nat} (expr : ELExpr k)
    (delta : SymbolicShift) (Phi : TrackedMode k -> Real -> Real)
    (y : Real) :
    (expr.shiftBy delta).eval Phi y = expr.eval Phi (y + delta.eval) := by
  induction expr with
  | leaf label =>
      simp only [shiftBy, eval, SymbolicShift.eval_add]
      congr 1
      ring
  | add left right ihLeft ihRight =>
      simp only [shiftBy, eval, ihLeft, ihRight]
  | min3 first second third ihFirst ihSecond ihThird =>
      simp only [shiftBy, eval, ihFirst, ihSecond, ihThird]

def splitTopExpr {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) : ELExpr (p + 1) := by
  by_cases h2 : label.mode.1.1 % 9 = 2
  · exact (d1TopExpr hp label.mode h2).shiftBy label.shift
  by_cases h5 : label.mode.1.1 % 9 = 5
  · exact (d2TopExpr hp label.mode).shiftBy label.shift
  · have h8 : label.mode.1.1 % 9 = 8 := by
      rcases trackedMode_mod_nine_cases label.mode with h | h | h
      · exact False.elim (h2 h)
      · exact False.elim (h5 h)
      · exact h
    exact (d3TopExpr hp label.mode h8).shiftBy label.shift

theorem splitTopExpr_eval_le_sourceLeaf {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (label : ELLabel (p + 1)) {y : Real}
    (hy : 2 <= y + label.shift.eval) :
    (splitTopExpr hp label).eval (fun mode z => sourcePhiK mode z) y <=
      sourcePhiK label.mode (y + label.shift.eval) := by
  unfold splitTopExpr
  split
  next h2 =>
    rw [ELExpr.shiftBy_eval]
    exact sourcePhiK_D1_topExpr hp roots label.mode h2 hy
  next hnot2 =>
    split
    next h5 =>
      rw [ELExpr.shiftBy_eval]
      exact sourcePhiK_D2_topExpr hp roots label.mode h5 hy
    next hnot5 =>
      have h8 : label.mode.1.1 % 9 = 8 := by
        rcases trackedMode_mod_nine_cases label.mode with h | h | h
        · exact False.elim (hnot2 h)
        · exact False.elim (hnot5 h)
        · exact h
      rw [ELExpr.shiftBy_eval]
      exact sourcePhiK_D3_topExpr hp roots label.mode h8 hy

def ELExpr.replaceLeaves {k : Nat}
    (replacement : ELLabel k -> ELExpr k) : ELExpr k -> ELExpr k
  | .leaf label => replacement label
  | .add left right =>
      .add (left.replaceLeaves replacement) (right.replaceLeaves replacement)
  | .min3 first second third =>
      .min3 (first.replaceLeaves replacement)
        (second.replaceLeaves replacement) (third.replaceLeaves replacement)

theorem ELExpr.replaceLeaves_eval_le {k : Nat} (expr : ELExpr k)
    (replacement : ELLabel k -> ELExpr k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hleaf : forall label,
      (replacement label).eval Phi y <=
        Phi label.mode (y + label.shift.eval)) :
    (expr.replaceLeaves replacement).eval Phi y <= expr.eval Phi y := by
  induction expr with
  | leaf label => exact hleaf label
  | add left right ihLeft ihRight =>
      exact add_le_add ihLeft ihRight
  | min3 first second third ihFirst ihSecond ihThird =>
      exact min_le_min ihFirst (min_le_min ihSecond ihThird)

def ELExpr.ArgumentsNonnegative {k : Nat} (y : Real) : ELExpr k -> Prop
  | .leaf label => 0 <= y + label.shift.eval
  | .add left right =>
      left.ArgumentsNonnegative y /\ right.ArgumentsNonnegative y
  | .min3 first second third =>
      first.ArgumentsNonnegative y /\ second.ArgumentsNonnegative y /\
        third.ArgumentsNonnegative y

inductive ELExpr.CriticalAssignment {k : Nat} : ELExpr k -> Type
  | leaf (label : ELLabel k) : CriticalAssignment (.leaf label)
  | add (left right : ELExpr k)
      (leftChoice : CriticalAssignment left)
      (rightChoice : CriticalAssignment right) :
      CriticalAssignment (.add left right)
  | minFirst (first second third : ELExpr k)
      (choice : CriticalAssignment first) :
      CriticalAssignment (.min3 first second third)
  | minSecond (first second third : ELExpr k)
      (choice : CriticalAssignment second) :
      CriticalAssignment (.min3 first second third)
  | minThird (first second third : ELExpr k)
      (choice : CriticalAssignment third) :
      CriticalAssignment (.min3 first second third)

namespace ELExpr.CriticalAssignment

def selectedExpr {k : Nat} {expr : ELExpr k}
    (assignment : CriticalAssignment expr) : ELExpr k :=
  match assignment with
  | .leaf label => .leaf label
  | .add _ _ leftChoice rightChoice =>
      .add leftChoice.selectedExpr rightChoice.selectedExpr
  | .minFirst _ _ _ choice => choice.selectedExpr
  | .minSecond _ _ _ choice => choice.selectedExpr
  | .minThird _ _ _ choice => choice.selectedExpr

def IsCritical {k : Nat} {expr : ELExpr k}
    (assignment : CriticalAssignment expr)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) : Prop :=
  match assignment with
  | .leaf _ => True
  | .add _ _ leftChoice rightChoice =>
      leftChoice.IsCritical Phi y /\ rightChoice.IsCritical Phi y
  | .minFirst first second third choice =>
      choice.IsCritical Phi y /\
        first.eval Phi y <= second.eval Phi y /\
        first.eval Phi y <= third.eval Phi y
  | .minSecond first second third choice =>
      choice.IsCritical Phi y /\
        second.eval Phi y <= first.eval Phi y /\
        second.eval Phi y <= third.eval Phi y
  | .minThird first second third choice =>
      choice.IsCritical Phi y /\
        third.eval Phi y <= first.eval Phi y /\
        third.eval Phi y <= second.eval Phi y

theorem selectedExpr_eval_eq {k : Nat} {expr : ELExpr k}
    (assignment : CriticalAssignment expr)
    (Phi : TrackedMode k -> Real -> Real) (y : Real)
    (hcritical : assignment.IsCritical Phi y) :
    assignment.selectedExpr.eval Phi y = expr.eval Phi y := by
  induction assignment with
  | leaf => rfl
  | add left right leftChoice rightChoice ihLeft ihRight =>
      simp only [selectedExpr, ELExpr.eval]
      rw [ihLeft hcritical.1, ihRight hcritical.2]
  | minFirst first second third choice ih =>
      simp only [selectedExpr, ELExpr.eval]
      rw [ih hcritical.1]
      exact (min_eq_left (le_min hcritical.2.1 hcritical.2.2)).symm
  | minSecond first second third choice ih =>
      simp only [selectedExpr, ELExpr.eval]
      rw [ih hcritical.1]
      symm
      calc
        min (first.eval Phi y) (min (second.eval Phi y) (third.eval Phi y)) =
            min (second.eval Phi y) (third.eval Phi y) :=
          min_eq_right (le_trans (min_le_left _ _) hcritical.2.1)
        _ = second.eval Phi y := min_eq_left hcritical.2.2
  | minThird first second third choice ih =>
      simp only [selectedExpr, ELExpr.eval]
      rw [ih hcritical.1]
      symm
      calc
        min (first.eval Phi y) (min (second.eval Phi y) (third.eval Phi y)) =
            min (second.eval Phi y) (third.eval Phi y) :=
          min_eq_right (le_trans (min_le_right _ _) hcritical.2.1)
        _ = third.eval Phi y := min_eq_right hcritical.2.2

theorem exists_isCritical {k : Nat} (expr : ELExpr k)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    exists assignment : CriticalAssignment expr,
      assignment.IsCritical Phi y := by
  induction expr with
  | leaf label => exact ⟨.leaf label, trivial⟩
  | add left right ihLeft ihRight =>
      rcases ihLeft with ⟨leftChoice, hleft⟩
      rcases ihRight with ⟨rightChoice, hright⟩
      exact ⟨.add left right leftChoice rightChoice, hleft, hright⟩
  | min3 first second third ihFirst ihSecond ihThird =>
      rcases ihFirst with ⟨firstChoice, hfirst⟩
      rcases ihSecond with ⟨secondChoice, hsecond⟩
      rcases ihThird with ⟨thirdChoice, hthird⟩
      by_cases hfirstMin :
          first.eval Phi y <= second.eval Phi y /\
            first.eval Phi y <= third.eval Phi y
      · exact ⟨.minFirst first second third firstChoice, hfirst, hfirstMin⟩
      by_cases hsecondMin :
          second.eval Phi y <= first.eval Phi y /\
            second.eval Phi y <= third.eval Phi y
      · exact ⟨.minSecond first second third secondChoice, hsecond, hsecondMin⟩
      · refine ⟨.minThird first second third thirdChoice, hthird, ?_, ?_⟩
        · by_contra hnot
          have hfirstLe : first.eval Phi y <= third.eval Phi y :=
            le_of_not_ge hnot
          have hsecondLt : second.eval Phi y < first.eval Phi y := by
            by_contra hsecondNotLt
            exact hsecondMin ⟨le_of_not_gt hsecondNotLt,
              le_trans (le_of_not_gt hsecondNotLt) hfirstLe⟩
          exact hfirstMin ⟨le_of_lt hsecondLt, hfirstLe⟩
        · by_contra hnot
          have hsecondLe : second.eval Phi y <= third.eval Phi y :=
            le_of_not_ge hnot
          have hfirstLt : first.eval Phi y < second.eval Phi y := by
            by_contra hfirstNotLt
            exact hfirstMin ⟨le_of_not_gt hfirstNotLt,
              le_trans (le_of_not_gt hfirstNotLt) hsecondLe⟩
          exact hsecondMin ⟨le_of_lt hfirstLt, hsecondLe⟩

theorem selectedExpr_argumentsNonnegative {k : Nat} {expr : ELExpr k}
    (assignment : CriticalAssignment expr) {y : Real}
    (hargs : expr.ArgumentsNonnegative y) :
    assignment.selectedExpr.ArgumentsNonnegative y := by
  induction assignment with
  | leaf => exact hargs
  | add _ _ _ _ ihLeft ihRight => exact ⟨ihLeft hargs.1, ihRight hargs.2⟩
  | minFirst _ _ _ _ ih => exact ih hargs.1
  | minSecond _ _ _ _ ih => exact ih hargs.2.1
  | minThird _ _ _ _ ih => exact ih hargs.2.2

end ELExpr.CriticalAssignment

theorem ELExpr.eval_pos {k : Nat} (expr : ELExpr k)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hargs : expr.ArgumentsNonnegative y) :
    0 < expr.eval Phi y := by
  induction expr with
  | leaf label => exact hpos label.mode _ hargs
  | add left right ihLeft ihRight =>
      exact add_pos (ihLeft hargs.1) (ihRight hargs.2)
  | min3 first second third ihFirst ihSecond ihThird =>
      exact lt_min (ihFirst hargs.1)
        (lt_min (ihSecond hargs.2.1) (ihThird hargs.2.2))

theorem ELExpr.CriticalAssignment.selectedExpr_eval_pos {k : Nat}
    {expr : ELExpr k} (assignment : CriticalAssignment expr)
    {Phi : TrackedMode k -> Real -> Real} {y : Real}
    (hpos : PositivePhi Phi) (hargs : expr.ArgumentsNonnegative y) :
    0 < assignment.selectedExpr.eval Phi y :=
  assignment.selectedExpr.eval_pos hpos
    (assignment.selectedExpr_argumentsNonnegative hargs)

theorem deletionWitness_critical_sum_contradiction {k : Nat}
    {Phi : TrackedMode k -> Real -> Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    {y : Real} {leaf : ELLeafState k} {ancestor : ELLabel k}
    {companion : ELExpr k}
    (_hancestor : ancestor ∈ leaf.ancestors)
    (hmode : ancestor.mode = leaf.label.mode)
    (hshift : ancestor.shift.eval < leaf.label.shift.eval)
    (hargs : companion.ArgumentsNonnegative y)
    (hcritical :
      Phi leaf.label.mode (y + leaf.label.shift.eval) +
          companion.eval Phi y <=
        Phi ancestor.mode (y + ancestor.shift.eval)) :
    False := by
  have hmonoValue :
      Phi ancestor.mode (y + ancestor.shift.eval) <=
        Phi leaf.label.mode (y + leaf.label.shift.eval) := by
    rw [hmode]
    exact hmono leaf.label.mode (by linarith)
  have hcompanion : 0 < companion.eval Phi y :=
    companion.eval_pos hpos hargs
  linarith

theorem deletionWitness_excludes_critical_sum {k : Nat}
    {Phi : TrackedMode k -> Real -> Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    {y : Real} {leaf : ELLeafState k} {companion : ELExpr k}
    (hwitness : HasDeletionWitness leaf)
    (hargs : companion.ArgumentsNonnegative y)
    (hcritical : forall ancestor,
      ancestor ∈ leaf.ancestors ->
      ancestor.mode = leaf.label.mode ->
      ancestor.shift.eval < leaf.label.shift.eval ->
      Phi leaf.label.mode (y + leaf.label.shift.eval) +
          companion.eval Phi y <=
        Phi ancestor.mode (y + ancestor.shift.eval)) :
    False := by
  rcases hwitness.2 with ⟨ancestor, hmem, hmode, hshift⟩
  exact deletionWitness_critical_sum_contradiction hpos hmono hmem hmode
    hshift hargs (hcritical ancestor hmem hmode hshift)

theorem deletionWitness_excludes_critical_assignment {k : Nat}
    {Phi : TrackedMode k -> Real -> Real}
    (hpos : PositivePhi Phi) (hmono : MonotonePhi Phi)
    {y : Real} {leaf : ELLeafState k} {companion : ELExpr k}
    (hwitness : HasDeletionWitness leaf)
    (assignment : ELExpr.CriticalAssignment companion)
    (hassignment : assignment.IsCritical Phi y)
    (hargs : companion.ArgumentsNonnegative y)
    (hcritical : forall ancestor,
      ancestor ∈ leaf.ancestors ->
      ancestor.mode = leaf.label.mode ->
      ancestor.shift.eval < leaf.label.shift.eval ->
      Phi leaf.label.mode (y + leaf.label.shift.eval) +
          assignment.selectedExpr.eval Phi y <=
        Phi ancestor.mode (y + ancestor.shift.eval)) :
    False := by
  apply deletionWitness_excludes_critical_sum hpos hmono hwitness hargs
  intro ancestor hmem hmode hshift
  rw [← assignment.selectedExpr_eval_eq Phi y hassignment]
  exact hcritical ancestor hmem hmode hshift

end KL2003
end CollatzClassical
