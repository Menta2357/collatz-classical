import Front4bSwitchedRealization

namespace CollatzCharacterBridge.Front4bSwitchedRows

open StagedCylinder (Segment)
open Front4bWeakRank (oddAffineLift attachOrigin)
open Front4bSwitchedRealization (Transition Allowed Trace physical finiteProgression)
open Front4bRowEven (originalSeed pivot originalSeedFormula originalCost)
open Front4bGuardRun (entry3)
open Front4bE1 (entry5)
open Front4bS29Landing (landing)
open P5CompensationMeetings (Affine)

set_option maxRecDepth 12000
set_option maxHeartbeats 1600000

/-- Choose either legal schedule within a dyadic progression of
Front4b entries with odd slope. -/
theorem affineTrace {A a L : Nat} (oddSlope : a%2=1) (long : 2≤L)
    (xs : List (Nat × Nat)) (legal : Allowed xs) :
    ∃ t q X m d C, Trace (8*(A+a*t)-1) L q xs X m d C := by
  obtain ⟨q,K,_,_,reaches⟩ := finiteProgression xs legal long
  let k := L-2
  obtain ⟨t,u,lift⟩ := oddAffineLift oddSlope A (2^k*q) (k+K)
  obtain ⟨X,m,d,C,path⟩ := reaches u
  have ex : L+1=3+k := by dsimp only [k]; omega
  have align : 8*(A+a*t)-1=2^(L+1)*(q+2^K*u)-1 := by
    rw [lift,Nat.pow_add 2 k K,ex,Nat.pow_add 2 3 k]
    simp only [show (2:Nat)^3=8 by decide,Nat.mul_add,Nat.mul_assoc]
  change Trace (2^(L+1)*(q+2^K*u)-1) L (q+2^K*u) xs X m d C at path
  rw [←align] at path
  exact ⟨t,_,X,m,d,C,path⟩

/-- Both original clocks and the accumulated additive are carried to the
end of the chosen schedule, with the same original N throughout. -/
structure Witness (N V J j S C L : Nat) (xs : List (Nat × Nat)) : Prop where
  order : N<V ∧ V<J
  realizes : ∃ q X m d B,
    Trace J L q xs X m d B ∧
    Segment N X (j+m) (S+d) (3^m*C+2^S*B) ∧
    (∀ i≤m, J≤orbit N (j+i)) ∧
    (∀ k≤d, J≤TerrasClock.orbit N (S+k)) ∧
    4*xs.length≤m ∧ m≤d

private theorem carries {N V J j S C L q X m d B : Nat} {xs : List (Nat × Nat)}
    (order : N<V ∧ V<J) (odd : J%2=1) (origin : Segment N J j S C)
    (trace : Trace J L q xs X m d B) : Witness N V J j S C L xs := by
  obtain ⟨suffix,lower,_,size,ordered⟩ := physical trace
  obtain ⟨book,oddStates,shortcutStates⟩ := attachOrigin origin odd suffix lower
  exact ⟨order,q,X,m,d,B,trace,book,oddStates,shortcutStates,size,ordered⟩

theorem band3 {L : Nat} (long : 2≤L) (xs : List (Nat × Nat)) (legal : Allowed xs) :
    ∃ t, Witness (originalSeed (18+32*t)) (pivot (18+32*t)) (entry3.at t)
      65 102 (originalCost 3 19) L xs := by
  obtain ⟨t,q,X,m,d,B,path⟩ := affineTrace
    (A:=6087988005158554746120173279902) (a:=10301051460877537453973547267843)
    (by decide) long xs legal
  have entry : 8*(6087988005158554746120173279902+10301051460877537453973547267843*t)-1
      = entry3.at t := by
    simp only [entry3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [entry] at path
  have order : originalSeed (18+32*t)<pivot (18+32*t) ∧ pivot (18+32*t)<entry3.at t := by
    simp only [originalSeedFormula,pivot,landing,entry3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have odd := (P5CompensationMeetings.affine_admissible (f:=entry3) (by decide) t).2
  exact ⟨t,carries order odd (Front4bGuardRun.entry3History t).1 path⟩

theorem band5 {L : Nat} (long : 2≤L) (xs : List (Nat × Nat)) (legal : Allowed xs) :
    ∃ t, Witness (originalSeed (10+128*t)) (pivot (10+128*t)) (entry5.at t)
      66 104 (originalCost 4 73) L xs := by
  obtain ⟨t,q,X,m,d,B,path⟩ := affineTrace
    (A:=2634543854954377786970089847206) (a:=30903154382632612361920641803529)
    (by decide) long xs legal
  have entry : 8*(2634543854954377786970089847206+30903154382632612361920641803529*t)-1
      = entry5.at t := by
    simp only [entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [entry] at path
  have order : originalSeed (10+128*t)<pivot (10+128*t) ∧ pivot (10+128*t)<entry5.at t := by
    simp only [originalSeedFormula,pivot,landing,entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨origin,_,odd,_⟩ := Front4bE1.entry5History t
  exact ⟨t,carries order odd origin path⟩

/-- Checks the expansion guard at every transition. In a realized trace,
each guard implies strict increase via Transition.growth. -/
def Expanding : Nat → List (Nat × Nat) → Prop
  | _, [] => True
  | L, (b,H)::rest => 2^(H+b+2)<3^(L+2) ∧ Expanding H rest

def binarySchedule : Nat → List Nat → List (Nat × Nat)
  | _, [] => []
  | L, H::rest => (if L=2 ∧ H=3 then 1 else 2,H)::binarySchedule H rest

/-- Every sequence of run lengths drawn from 2 and 3, including any
finite aperiodic prefix, permits a schedule expanding at every transition. -/
theorem binaryGrowing (xs : List Nat) {L : Nat} (start : L=2 ∨ L=3)
    (next : ∀ H∈xs, H=2 ∨ H=3) :
    Allowed (binarySchedule L xs) ∧ Expanding L (binarySchedule L xs) ∧
      (binarySchedule L xs).length=xs.length := by
  induction xs generalizing L with
  | nil => exact ⟨trivial,trivial,rfl⟩
  | cons H xs ih =>
    have step := next H (by simp)
    obtain ⟨al,ex,length⟩ := ih step (fun n mem => next n (by simp [mem]))
    have bound : 2≤H := by omega
    have weak : (if L=2 ∧ H=3 then 1 else 2)=1 ∨ (if L=2 ∧ H=3 then 1 else 2)=2 := by
      by_cases up : L=2 ∧ H=3
      · simp [up]
      · simp [up]
    have power : 2^(H+(if L=2 ∧ H=3 then 1 else 2)+2)<3^(L+2) := by
      rcases start with rfl|rfl <;> rcases step with rfl|rfl <;> decide
    exact ⟨⟨weak,bound,al⟩,⟨power,ex⟩,congrArg Nat.succ length⟩

/-- With the expansion guard at every realized transition, the terminal
cofactor grows by at least the number of genuine episodes. -/
theorem finalCofactor {J L q X m d C : Nat} {xs : List (Nat × Nat)}
    (trace : Trace J L q xs X m d C) (expansion : Expanding L xs) :
    ∃ H v, v%2=1 ∧ X+1=2^(H+1)*v ∧ q+xs.length≤v := by
  induction trace with
  | stop length odd entry => exact ⟨_,_,odd,entry,by simp⟩
  | @extend J L q b H Z v rest X m d C head tail ih =>
    obtain ⟨power,continues⟩ := expansion
    obtain ⟨K,w,wo,finish,lower⟩ := ih continues
    have growth := head.growth power
    refine ⟨K,w,wo,finish,?_⟩
    simp only [List.length_cons]
    omega

/-- Two genuine run-length switches and both weak pair types per round. -/
def alternatingPairs : Nat → List (Nat × Nat)
  | 0 => []
  | n+1 => (1,3)::(2,2)::alternatingPairs n

theorem alternatingGrowing (n : Nat) :
    Allowed (alternatingPairs n) ∧ Expanding 2 (alternatingPairs n) ∧
      (alternatingPairs n).length=2*n := by
  induction n with
  | zero => exact ⟨trivial,trivial,rfl⟩
  | succ n ih =>
    obtain ⟨legal,expansion,count⟩ := ih
    refine ⟨⟨by decide,by decide,by decide,by decide,legal⟩,
      ⟨by decide,by decide,expansion⟩,?_⟩
    simp only [alternatingPairs,List.length_cons,count,Nat.mul_succ]

end CollatzCharacterBridge.Front4bSwitchedRows

#print axioms CollatzCharacterBridge.Front4bSwitchedRows.affineTrace
#print axioms CollatzCharacterBridge.Front4bSwitchedRows.band3
#print axioms CollatzCharacterBridge.Front4bSwitchedRows.band5
#print axioms CollatzCharacterBridge.Front4bSwitchedRows.binaryGrowing
#print axioms CollatzCharacterBridge.Front4bSwitchedRows.finalCofactor
#print axioms CollatzCharacterBridge.Front4bSwitchedRows.alternatingGrowing
