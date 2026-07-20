import CollatzClassical.KL2003.KL2003GeneralKEliminationContext

namespace CollatzClassical
namespace KL2003

/-!
Finite weighted source transitions for the general-`k` EL process.

The action validity proofs are indexed by the source mode, so D1 and D3
advanced branches cannot be constructed at modes where their source row does
not apply. The weights and child labels reuse the existing source definitions.
-/

namespace GeneralKSourceGraph

theorem shift_add_zero (shift : SymbolicShift) :
    shift + SymbolicShift.zero = shift := by
  cases shift with
  | mk alphaCoeff constCoeff =>
      change SymbolicShift.mk (alphaCoeff + 0) (constCoeff + 0) =
        SymbolicShift.mk alphaCoeff constCoeff
      rw [Int.add_zero, Int.add_zero]

theorem shift_zero_add (shift : SymbolicShift) :
    SymbolicShift.zero + shift = shift := by
  cases shift with
  | mk alphaCoeff constCoeff =>
      change SymbolicShift.mk (0 + alphaCoeff) (0 + constCoeff) =
        SymbolicShift.mk alphaCoeff constCoeff
      rw [Int.zero_add, Int.zero_add]

theorem shift_add_assoc (first second third : SymbolicShift) :
    first + second + third = first + (second + third) := by
  cases first with
  | mk firstAlpha firstConst =>
      cases second with
      | mk secondAlpha secondConst =>
          cases third with
          | mk thirdAlpha thirdConst =>
              change SymbolicShift.mk
                  ((firstAlpha + secondAlpha) + thirdAlpha)
                  ((firstConst + secondConst) + thirdConst) =
                SymbolicShift.mk
                  (firstAlpha + (secondAlpha + thirdAlpha))
                  (firstConst + (secondConst + thirdConst))
              rw [Int.add_assoc, Int.add_assoc]

inductive SourceBranch where
  | retarded
  | d1Advanced (index : Fin 3)
  | d3Advanced (index : Fin 3)
deriving DecidableEq, Fintype, Repr

def SourceBranch.ValidFor {p : Nat} (branch : SourceBranch)
    (mode : TrackedMode (p + 1)) : Prop :=
  match branch with
  | .retarded => True
  | .d1Advanced _ => mode.1.1 % 9 = 2
  | .d3Advanced _ => mode.1.1 % 9 = 8

instance {p : Nat} (branch : SourceBranch) (mode : TrackedMode (p + 1)) :
    Decidable (branch.ValidFor mode) := by
  cases branch <;> simp [SourceBranch.ValidFor] <;> infer_instance

abbrev SourceAction {p : Nat} (mode : TrackedMode (p + 1)) :=
  {branch : SourceBranch // branch.ValidFor mode}

def retardedAction {p : Nat} (mode : TrackedMode (p + 1)) :
    SourceAction mode :=
  ⟨.retarded, trivial⟩

def d1AdvancedAction {p : Nat} (mode : TrackedMode (p + 1))
    (hm : mode.1.1 % 9 = 2) (index : Fin 3) : SourceAction mode :=
  ⟨.d1Advanced index, hm⟩

def d3AdvancedAction {p : Nat} (mode : TrackedMode (p + 1))
    (hm : mode.1.1 % 9 = 8) (index : Fin 3) : SourceAction mode :=
  ⟨.d3Advanced index, hm⟩

def SourceAction.target {p : Nat} (hp : 1 <= p)
    {mode : TrackedMode (p + 1)} (action : SourceAction mode) :
    TrackedMode (p + 1) :=
  match action with
  | ⟨.retarded, _⟩ => fourTrackedMode (by omega) mode
  | ⟨.d1Advanced index, hm⟩ =>
      liftTrackedMode hp (d1LowerTrackedMode hp mode hm) index
  | ⟨.d3Advanced index, hm⟩ =>
      liftTrackedMode hp (d3LowerTrackedMode hp mode hm) index

def SourceAction.weight {p : Nat} {mode : TrackedMode (p + 1)}
    (action : SourceAction mode) : SymbolicShift :=
  match action.1 with
  | .retarded => .retardedTwo
  | .d1Advanced _ => .d1Advanced
  | .d3Advanced _ => .d3Advanced

def SourceAction.childLabel {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (action : SourceAction label.mode) :
    ELLabel (p + 1) :=
  ⟨action.target hp, label.shift + action.weight⟩

@[simp] theorem retardedAction_target {p : Nat} (hp : 1 <= p)
    (mode : TrackedMode (p + 1)) :
    (retardedAction mode).target hp = fourTrackedMode (by omega) mode := rfl

@[simp] theorem d1AdvancedAction_target {p : Nat} (hp : 1 <= p)
    (mode : TrackedMode (p + 1)) (hm : mode.1.1 % 9 = 2)
    (index : Fin 3) :
    (d1AdvancedAction mode hm index).target hp =
      liftTrackedMode hp (d1LowerTrackedMode hp mode hm) index := rfl

@[simp] theorem d3AdvancedAction_target {p : Nat} (hp : 1 <= p)
    (mode : TrackedMode (p + 1)) (hm : mode.1.1 % 9 = 8)
    (index : Fin 3) :
    (d3AdvancedAction mode hm index).target hp =
      liftTrackedMode hp (d3LowerTrackedMode hp mode hm) index := rfl

@[simp] theorem retardedAction_weight {p : Nat}
    (mode : TrackedMode (p + 1)) :
    (retardedAction mode).weight = SymbolicShift.retardedTwo := rfl

@[simp] theorem d1AdvancedAction_weight {p : Nat}
    (mode : TrackedMode (p + 1)) (hm : mode.1.1 % 9 = 2)
    (index : Fin 3) :
    (d1AdvancedAction mode hm index).weight =
      SymbolicShift.d1Advanced := rfl

@[simp] theorem d3AdvancedAction_weight {p : Nat}
    (mode : TrackedMode (p + 1)) (hm : mode.1.1 % 9 = 8)
    (index : Fin 3) :
    (d3AdvancedAction mode hm index).weight =
      SymbolicShift.d3Advanced := rfl

theorem childLabel_retarded {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) :
    (retardedAction label.mode).childLabel hp label =
      ELTree.retardedSplitLabel label := rfl

theorem childLabel_d1Advanced {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 2)
    (index : Fin 3) :
    (d1AdvancedAction label.mode hm index).childLabel hp label =
      ELTree.d1AdvancedSplitLabel hp label hm index := rfl

theorem childLabel_d3Advanced {p : Nat} (hp : 1 <= p)
    (label : ELLabel (p + 1)) (hm : label.mode.1.1 % 9 = 8)
    (index : Fin 3) :
    (d3AdvancedAction label.mode hm index).childLabel hp label =
      ELTree.d3AdvancedSplitLabel hp label hm index := rfl

theorem SourceAction.weight_alphaCoeff_nonneg {p : Nat}
    {mode : TrackedMode (p + 1)} (action : SourceAction mode) :
    0 <= action.weight.alphaCoeff := by
  rcases action with ⟨branch, hvalid⟩
  cases branch <;> norm_num [SourceAction.weight,
    SymbolicShift.retardedTwo, SymbolicShift.d1Advanced,
    SymbolicShift.d3Advanced]

theorem SourceAction.weight_constCoeff_neg {p : Nat}
    {mode : TrackedMode (p + 1)} (action : SourceAction mode) :
    action.weight.constCoeff < 0 := by
  rcases action with ⟨branch, hvalid⟩
  cases branch <;> norm_num [SourceAction.weight,
    SymbolicShift.retardedTwo, SymbolicShift.d1Advanced,
    SymbolicShift.d3Advanced]

inductive SourceWalk {p : Nat} (hp : 1 <= p) :
    TrackedMode (p + 1) -> TrackedMode (p + 1) -> Type where
  | nil (mode : TrackedMode (p + 1)) : SourceWalk hp mode mode
  | cons {source target : TrackedMode (p + 1)}
      (action : SourceAction source)
      (tail : SourceWalk hp (action.target hp) target) :
      SourceWalk hp source target

namespace SourceWalk

def length {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} :
    SourceWalk hp source target -> Nat
  | .nil _ => 0
  | .cons _ tail => tail.length + 1

def weight {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} :
    SourceWalk hp source target -> SymbolicShift
  | .nil _ => SymbolicShift.zero
  | .cons action tail => action.weight + tail.weight

def append {p : Nat} {hp : 1 <= p}
    {source middle target : TrackedMode (p + 1)}
    (first : SourceWalk hp source middle)
    (second : SourceWalk hp middle target) : SourceWalk hp source target :=
  match first with
  | .nil _ => second
  | .cons action tail => .cons action (tail.append second)

@[simp] theorem length_nil {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1)) :
    (SourceWalk.nil mode : SourceWalk hp mode mode).length = 0 := rfl

@[simp] theorem length_cons {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} (action : SourceAction source)
    (tail : SourceWalk hp (action.target hp) target) :
    (SourceWalk.cons action tail).length = tail.length + 1 := rfl

@[simp] theorem weight_nil {p : Nat} {hp : 1 <= p}
    (mode : TrackedMode (p + 1)) :
    (SourceWalk.nil mode : SourceWalk hp mode mode).weight =
      SymbolicShift.zero := rfl

@[simp] theorem weight_cons {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)} (action : SourceAction source)
    (tail : SourceWalk hp (action.target hp) target) :
    (SourceWalk.cons action tail).weight = action.weight + tail.weight := rfl

@[simp] theorem nil_append {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    (SourceWalk.nil source).append walk = walk := rfl

@[simp] theorem cons_append {p : Nat} {hp : 1 <= p}
    {source middle target : TrackedMode (p + 1)}
    (action : SourceAction source)
    (tail : SourceWalk hp (action.target hp) middle)
    (walk : SourceWalk hp middle target) :
    (SourceWalk.cons action tail).append walk =
      SourceWalk.cons action (tail.append walk) := rfl

theorem length_append {p : Nat} {hp : 1 <= p}
    {source middle target : TrackedMode (p + 1)}
    (first : SourceWalk hp source middle)
    (second : SourceWalk hp middle target) :
    (first.append second).length = first.length + second.length := by
  induction first with
  | nil => simp [append, length]
  | cons action tail ih =>
      simp only [cons_append, length_cons, ih]
      omega

theorem weight_append {p : Nat} {hp : 1 <= p}
    {source middle target : TrackedMode (p + 1)}
    (first : SourceWalk hp source middle)
    (second : SourceWalk hp middle target) :
    (first.append second).weight = first.weight + second.weight := by
  induction first with
  | nil =>
      exact (shift_zero_add second.weight).symm
  | cons action tail ih =>
      simp only [cons_append, weight_cons, ih]
      exact (shift_add_assoc action.weight tail.weight second.weight).symm

theorem weight_eval {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    walk.weight.eval = match walk with
      | .nil _ => 0
      | .cons action tail => action.weight.eval + tail.weight.eval := by
  cases walk with
  | nil => exact SymbolicShift.eval_zero
  | cons action tail => exact SymbolicShift.eval_add _ _

theorem weight_alphaCoeff_nonneg {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    0 <= walk.weight.alphaCoeff := by
  induction walk with
  | nil => norm_num [weight, SymbolicShift.zero]
  | cons action tail ih =>
      change 0 <= action.weight.alphaCoeff + tail.weight.alphaCoeff
      exact add_nonneg action.weight_alphaCoeff_nonneg ih

theorem weight_constCoeff_nonpos {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) :
    walk.weight.constCoeff <= 0 := by
  induction walk with
  | nil => norm_num [weight, SymbolicShift.zero]
  | cons action tail ih =>
      change action.weight.constCoeff + tail.weight.constCoeff <= 0
      have haction := action.weight_constCoeff_neg
      omega

theorem weight_constCoeff_neg_of_length_pos {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) (hlength : 0 < walk.length) :
    walk.weight.constCoeff < 0 := by
  cases walk with
  | nil => simp at hlength
  | cons action tail =>
      change action.weight.constCoeff + tail.weight.constCoeff < 0
      have haction := action.weight_constCoeff_neg
      have htail := tail.weight_constCoeff_nonpos
      omega

def finalLabel {p : Nat} {hp : 1 <= p}
    (label : ELLabel (p + 1)) {target : TrackedMode (p + 1)}
    (walk : SourceWalk hp label.mode target) : ELLabel (p + 1) :=
  ⟨target, label.shift + walk.weight⟩

theorem finalLabel_nil {p : Nat} {hp : 1 <= p}
    (label : ELLabel (p + 1)) :
    finalLabel (hp := hp) label (SourceWalk.nil (hp := hp) label.mode) =
      label := by
  cases label
  exact congrArg (ELLabel.mk _) (shift_add_zero _)

theorem finalLabel_cons {p : Nat} {hp : 1 <= p}
    (label : ELLabel (p + 1)) {target : TrackedMode (p + 1)}
    (action : SourceAction label.mode)
    (tail : SourceWalk hp (action.target hp) target) :
    finalLabel (hp := hp) label (SourceWalk.cons action tail) =
      finalLabel (hp := hp) (action.childLabel hp label) tail := by
  cases label with
  | mk mode shift =>
      change ELLabel.mk target (shift + (action.weight + tail.weight)) =
        ELLabel.mk target ((shift + action.weight) + tail.weight)
      exact congrArg (ELLabel.mk target)
        (shift_add_assoc shift action.weight tail.weight).symm

theorem finalLabel_shift_eval {p : Nat} {hp : 1 <= p}
    (label : ELLabel (p + 1)) {target : TrackedMode (p + 1)}
    (walk : SourceWalk hp label.mode target) :
    (finalLabel (hp := hp) label walk).shift.eval =
      label.shift.eval + walk.weight.eval := by
  exact SymbolicShift.eval_add _ _

end SourceWalk

end GeneralKSourceGraph

end KL2003
end CollatzClassical
