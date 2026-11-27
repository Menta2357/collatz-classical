import Front4bSwitchedRealization
import Front4bGuardRun
import Front4bWeakReentry

namespace CollatzCharacterBridge.Front4bWeakPriceExit

open Front4bSwitchedRealization (Trace)
open Front4bWeakRank (WeakRank)
open Front4bWeakReentry (weakBookOfRank)
open Front4bRowEven (originalSeed originalSeedFormula originalCost)
open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine)

set_option maxRecDepth 15000

private theorem gain {J L b : Nat} (many : 2≤L) (branch : b=1 ∨ b=2)
    (weak : WeakRank J L b) : 81*(J+1)≤64*(orbit J (L+2)+1) := by
  let A := 3^(L+2)
  let D := 2^(L+2+b)
  let Z := orbit J (L+2)
  have book : D*Z=A*J+(A-2^(L+1)) := (weakBookOfRank weak).2
  have scale : 81*D≤64*A := by
    have db : D≤2^(L+4) := Nat.pow_le_pow_right (by decide) (by omega)
    apply Nat.le_trans (Nat.mul_le_mul_left 81 db)
    rw [show L+4=(L-2)+6 by omega,Nat.pow_add 2 (L-2) 6]
    change 81*(2^(L-2)*64)≤64*3^(L+2)
    have index : L+2=(L-2)+4 := by omega
    rw [index,Nat.pow_add 3 (L-2) 4]
    change 81*(2^(L-2)*64)≤64*(3^(L-2)*81)
    have small := Nat.pow_le_pow_left (show 2≤3 by decide) (L-2)
    calc
      _ = (81*64)*2^(L-2) := by ac_rfl
      _ ≤ (81*64)*3^(L-2) := Nat.mul_le_mul_left _ small
      _ = _ := by ac_rfl
  have price : 2^(L+1)≤D := Nat.pow_le_pow_right (by decide) (by omega)
  have strong : 2^(L+1)≤A :=
    Nat.le_trans (Nat.pow_le_pow_left (by decide : 2≤3) (L+1))
      (Nat.pow_le_pow_right (by decide : 0<3) (by omega))
  have affine : A*(J+1)≤D*(Z+1) := by
    rw [Nat.mul_add,Nat.mul_one,Nat.mul_add,Nat.mul_one,book]
    have eq := Nat.sub_add_cancel strong
    omega
  have complete : D*(81*(J+1))≤D*(64*(Z+1)) := by
    calc
      _ = (81*D)*(J+1) := by ac_rfl
      _ ≤ (64*A)*(J+1) := Nat.mul_le_mul_right _ scale
      _ = 64*(A*(J+1)) := by ac_rfl
      _ ≤ 64*(D*(Z+1)) := Nat.mul_le_mul_left _ affine
      _ = _ := by ac_rfl
  exact Nat.le_of_mul_le_mul_left complete (Nat.pow_pos (by decide))

theorem gainOfTrace {J L q X m d C : Nat} {xs : List (Nat × Nat)}
    (trace : Trace J L q xs X m d C) :
    81^xs.length*(J+1)≤64^xs.length*(X+1) := by
  induction trace with
  | stop => simp
  | @extend J L q b H Z v rest X m d C head tail ih =>
    have one := gain head.long head.weak head.path
    rw [head.atNext] at one
    simp only [List.length_cons,Nat.pow_succ]
    calc
      _ = 81^rest.length*(81*(J+1)) := by ac_rfl
      _ ≤ 81^rest.length*(64*(Z+1)) := Nat.mul_le_mul_left _ one
      _ = 64*(81^rest.length*(Z+1)) := by ac_rfl
      _ ≤ 64*(64^rest.length*(X+1)) := Nat.mul_le_mul_left _ ih
      _ = _ := by ac_rfl

/-- Three weak episodes leave the old quarter-source price window for
every seed in the c=3 row. The absolute physical ledger is returned. -/
theorem quarterExit3 {t L q X m d B : Nat} {xs : List (Nat × Nat)} (three : xs.length=3)
    (trace : Trace (Front4bGuardRun.entry3.at t) L q xs X m d B) :
    let N := originalSeed (18+32*t)
    let C := originalCost 3 19
    4*N+1<X ∧ Segment N X (65+m) (102+d) (3^m*C+2^102*B) := by
  let J := Front4bGuardRun.entry3.at t
  let N := originalSeed (18+32*t)
  have atEntry : 2*(N+1)<J+1 := by
    simp only [N,J,Front4bGuardRun.entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have growth := gainOfTrace trace
  rw [three] at growth
  change 531441*(J+1)≤262144*(X+1) at growth
  exact ⟨by omega,compose (Front4bGuardRun.entry3History t).1
    (Front4bSwitchedRealization.physical trace).1⟩

/-- Two weak episodes leave the old half-source price window for the
c=5 row, with the same absolute physical ledger. -/
theorem halfExit5 {t L q X m d B : Nat} {xs : List (Nat × Nat)} (two : xs.length=2)
    (trace : Trace (Front4bE1.entry5.at t) L q xs X m d B) :
    let N := originalSeed (10+128*t)
    let C := originalCost 4 73
    2*N+1<X ∧ Segment N X (66+m) (104+d) (3^m*C+2^104*B) := by
  let J := Front4bE1.entry5.at t
  let N := originalSeed (10+128*t)
  have atEntry : 5*(N+1)<4*(J+1) := by
    simp only [N,J,Front4bE1.entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have growth := gainOfTrace trace
  rw [two] at growth
  change 6561*(J+1)≤4096*(X+1) at growth
  exact ⟨by omega,compose (Front4bE1.entry5History t).1
    (Front4bSwitchedRealization.physical trace).1⟩

end CollatzCharacterBridge.Front4bWeakPriceExit

#print axioms CollatzCharacterBridge.Front4bWeakPriceExit.gainOfTrace
#print axioms CollatzCharacterBridge.Front4bWeakPriceExit.quarterExit3
#print axioms CollatzCharacterBridge.Front4bWeakPriceExit.halfExit5
