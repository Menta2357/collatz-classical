import Front4bWeakRealization
import Front4bGuardRun

namespace CollatzCharacterBridge.Front4bWeakRows

open StagedCylinder (Segment)
open FixedSourceRun (Ones)
open Front4bWeakRank (weakCost attachOnes attachOrigin)
open Front4bRowEven (originalSeed pivot originalCost originalSeedFormula)
open Front4bS29Landing (landing)
open P5CompensationMeetings (Affine)
open Front4bGuardRun (entry3)

set_option maxRecDepth 12000
set_option maxHeartbeats 1000000

theorem entry3History (t : Nat) :
    Segment (originalSeed (18+32*t)) (entry3.at t) 65 102 (originalCost 3 19) :=
  (Front4bGuardRun.entry3History t).1

def localCost (L b H : Nat) : Nat :=
  3^H*weakCost L+2^(L+2+b)*(3^H-2^H)

/-- A particular original seed carries an arbitrarily large checked horizon
above J, with physical weak pair, exact clock and odd cofactors. -/
structure Witness (N V J j S C L b H : Nat) : Prop where
  ordering : N<V ∧ V<J
  weak : Front4bWeakRank.WeakRank J L b
  more : Ones (orbit J (L+2)) H
  factors : ∃ Q Q', Q%2=1 ∧ Q'%2=1 ∧
    J+1=2^(L+1)*Q ∧ orbit J (L+2)+1=2^(H+1)*Q'
  history : Segment N (orbit J (L+2+H)) (j+(L+2+H)) (S+(L+2+b+H))
    (3^(L+2+H)*C+2^S*localCost L b H)
  oddLower : ∀ i≤L+2+H, J≤orbit N (j+i)
  shortcutLower : ∀ k≤L+2+b+H, J≤TerrasClock.orbit N (S+k)

private theorem witness {N V J j S C L b H : Nat} (order : N<V ∧ V<J)
    (entry : Segment N J j S C) (weak : Front4bWeakRank.WeakRank J L b)
    (more : Ones (orbit J (L+2)) H) (factors : ∃ Q Q', Q%2=1 ∧ Q'%2=1 ∧
      J+1=2^(L+1)*Q ∧ orbit J (L+2)+1=2^(H+1)*Q') :
    Witness N V J j S C L b H := by
  have odd : J%2=1 := by
    obtain ⟨Q,_,_,_,factor,_⟩ := factors
    rw [Nat.pow_succ,show (2:Nat)^L*2*Q=2*(2^L*Q) by ac_rfl] at factor
    omega
  obtain ⟨suffix,lower,_⟩ := attachOnes odd weak more
  obtain ⟨history,oddLower,shortcutLower⟩ := attachOrigin entry odd suffix lower
  exact ⟨order,weak,more,factors,history,oddLower,shortcutLower⟩

theorem band3 {L b : Nat} (many : 2≤L) (weak : b=1 ∨ b=2) (H : Nat) :
    ∃ t, Witness (originalSeed (18+32*t)) (pivot (18+32*t)) (entry3.at t)
      65 102 (originalCost 3 19) L b H := by
  obtain ⟨t,phys,more,factors⟩ := Front4bWeakRealization.realizesOnesWeakOnes
    (A:=6087988005158554746120173279902) (a:=10301051460877537453973547267843)
    (by decide) many weak H
  have atEntry : 8*(6087988005158554746120173279902+10301051460877537453973547267843*t)-1
      = entry3.at t := by
    simp only [Front4bGuardRun.entry3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [atEntry] at phys more factors
  have order : originalSeed (18+32*t)<pivot (18+32*t) ∧ pivot (18+32*t)<entry3.at t := by
    simp only [originalSeedFormula,pivot,landing,Front4bGuardRun.entry3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨t,witness order (entry3History t) phys more factors⟩

theorem band5 {L b : Nat} (many : 2≤L) (weak : b=1 ∨ b=2) (H : Nat) :
    ∃ t, Witness (originalSeed (10+128*t)) (pivot (10+128*t)) (Front4bE1.entry5.at t)
      66 104 (originalCost 4 73) L b H := by
  obtain ⟨t,phys,more,factors⟩ := Front4bWeakRealization.realizesOnesWeakOnes
    (A:=2634543854954377786970089847206) (a:=30903154382632612361920641803529)
    (by decide) many weak H
  have atEntry : 8*(2634543854954377786970089847206+30903154382632612361920641803529*t)-1
      = Front4bE1.entry5.at t := by
    simp only [Front4bE1.entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [atEntry] at phys more factors
  have order : originalSeed (10+128*t)<pivot (10+128*t) ∧
      pivot (10+128*t)<Front4bE1.entry5.at t := by
    simp only [originalSeedFormula,pivot,landing,Front4bE1.entry5,Affine.at,Nat.mul_add,
      ←Nat.mul_assoc]
    omega
  exact ⟨t,witness order (Front4bE1.entry5History t).1 phys more factors⟩

end CollatzCharacterBridge.Front4bWeakRows

#print axioms CollatzCharacterBridge.Front4bWeakRows.entry3History
#print axioms CollatzCharacterBridge.Front4bWeakRows.band3
#print axioms CollatzCharacterBridge.Front4bWeakRows.band5
