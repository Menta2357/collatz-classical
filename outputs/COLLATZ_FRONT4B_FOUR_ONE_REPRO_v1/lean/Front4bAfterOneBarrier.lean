import Front4bGuardRun
import Front4bE1
import Front4bSwitchedRealization

namespace CollatzCharacterBridge.Front4bAfterOneBarrier

open StagedCylinder (Segment compose)
open Front4bSwitchedRealization (Trace)
open Front4bRowEven (originalSeed originalCost originalSeedFormula)
open Front4bGuardRun (entry3 entry3History)
open Front4bE1 (entry5 entry5History)
open P5CompensationMeetings (Affine)

set_option maxRecDepth 14000
set_option maxHeartbeats 1000000

private theorem fourthBook {J X Y : Nat}
    (head : Segment J X 10 13 84217) (four : Segment X Y 1 4 1) :
    Segment J Y 11 17 260843 := by
  simpa only [Nat.pow_one,Nat.mul_one] using compose head four

private theorem sizeThree {N J Y : Nat} (entry : 2*N<J)
    (equation : 131072*Y=177147*J+260843) : 8*N<3*Y := by omega

private theorem sizeFive {N J Y : Nat} (entry : 3*N<2*J)
    (equation : 131072*Y=177147*J+260843) : 2*N<Y := by omega

private theorem boundaryThree {N Y U R r : Nat} (short : r≤2)
    (start : 8*N<3*Y) (book : 2^(2*r)*U=3^r*Y+(4^r-3^r)) (one : 2*R=3*U+1) :
    2*N+1<R := by
  have modes : r=0 ∨ r=1 ∨ r=2 := by omega
  rcases modes with rfl|rfl|rfl
  · simp only [Nat.mul_zero,Nat.pow_zero,Nat.one_mul,Nat.sub_self,Nat.add_zero] at book; omega
  · change 4*U=3*Y+1 at book; omega
  · change 16*U=9*Y+7 at book; omega

private theorem boundaryFive {N Y U R r : Nat} (short : r≤1)
    (start : 2*N<Y) (book : 2^(2*r)*U=3^r*Y+(4^r-3^r)) (one : 2*R=3*U+1) :
    2*N+1<R := by
  have modes : r=0 ∨ r=1 := by omega
  rcases modes with rfl|rfl
  · simp only [Nat.mul_zero,Nat.pow_zero,Nat.one_mul,Nat.sub_self,Nat.add_zero] at book; omega
  · change 4*U=3*Y+1 at book; omega

/-- Once the known one has been spent, no continuation consisting only
of genuine weak episodes can return to the A2 height window. The same
absolute seed and all actual clocks and additive terms stay attached. -/
theorem preserve {N R Z j S B L q m d C : Nat} {xs : List (Nat × Nat)}
    (history : Segment N R j S B) (outside : 2*N+1<R)
    (tail : Trace R L q xs Z m d C) :
    (∀ i≤m, 2*N+1<orbit R i) ∧
       Segment N Z (j+m) (S+d) (3^m*B+2^S*C) := by
  have full := Front4bSwitchedRealization.physical tail
  exact ⟨fun i hi => Nat.lt_of_lt_of_le outside (full.2.1 i hi),compose history full.1⟩

/-- All three short residues of row 3 cross strictly above the A2 height
window at their observed one, irrespective of any future valuation. -/
theorem rowThree {t X Y U R r : Nat} (short : r≤2)
    (head : Segment (entry3.at t) X 10 13 84217) (four : Segment X Y 1 4 1)
    (twos : Segment Y U r (2*r) (4^r-3^r)) (one : Segment U R 1 1 1) :
    let N := originalSeed (18+32*t)
    2*N+1<R ∧ Segment N R ((76+r)+1) ((119+2*r)+1)
      (3*(3^r*(177147*originalCost 3 19+2^102*260843)+2^119*(4^r-3^r))+
        2^(119+2*r)) := by
  let N := originalSeed (18+32*t)
  have entry : 2*N<entry3.at t := by
    simp only [N,entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have turn := fourthBook head four
  have cross := boundaryThree short (sizeThree entry turn.book) twos.book one.book
  have path := compose (compose (compose (entry3History t).1 turn) twos) one
  exact ⟨cross,by simpa only [Nat.pow_one,Nat.mul_one] using path⟩

/-- Both short residues of row 5 have the same obstruction. -/
theorem rowFive {t X Y U R r : Nat} (short : r≤1)
    (head : Segment (entry5.at t) X 10 13 84217) (four : Segment X Y 1 4 1)
    (twos : Segment Y U r (2*r) (4^r-3^r)) (one : Segment U R 1 1 1) :
    let N := originalSeed (10+128*t)
    2*N+1<R ∧ Segment N R ((77+r)+1) ((121+2*r)+1)
      (3*(3^r*(177147*originalCost 4 73+2^104*260843)+2^121*(4^r-3^r))+
        2^(121+2*r)) := by
  let N := originalSeed (10+128*t)
  have entry : 3*N<2*entry5.at t := by
    simp only [N,entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have turn := fourthBook head four
  have cross := boundaryFive short (sizeFive entry turn.book) twos.book one.book
  have path := compose (compose (compose (entry5History t).1 turn) twos) one
  exact ⟨cross,by simpa only [Nat.pow_one,Nat.mul_one] using path⟩

end CollatzCharacterBridge.Front4bAfterOneBarrier

#print axioms CollatzCharacterBridge.Front4bAfterOneBarrier.preserve
#print axioms CollatzCharacterBridge.Front4bAfterOneBarrier.rowThree
#print axioms CollatzCharacterBridge.Front4bAfterOneBarrier.rowFive
