import Front4bShortExit

namespace CollatzCharacterBridge.Front4bShortExitFiveSix

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine)
open Front4bE1 (entry5 entry5History)
open Front4bGuardRun (entry3 entry3History)
open Front4bRowEven (originalSeed originalCost originalSeedFormula)
open A2CertifiedLanding (PaidMeeting)

set_option maxRecDepth 14000
set_option maxHeartbeats 1400000

/-- A valuation-five exit has a real inversion of valuation one. Its
price is checked against N, and each history keeps its own exact clock. -/
theorem oneReturnSource {N J X Y j S B : Nat} (entry : Segment N J j S B)
    (twoBlocks : Segment J X 10 13 84217) (exit : Segment X Y 1 5 1)
    (price : 2*(177147*J+260843)<2^18*(3*N+1)) :
    let w := (2*Y-1)/3
    0<w ∧ w%2=1 ∧ w<N ∧ 0<Y ∧ Y%2=1 ∧
      Segment N Y (j+11) (S+18) (177147*B+2^S*260843) ∧ Segment w Y 1 1 1 := by
  let w := (2*Y-1)/3
  have suffix : Segment J Y 11 18 260843 := by
    simpa only [Nat.pow_one,Nat.mul_one] using compose twoBlocks exit
  have factor := exit.book
  change 32*Y=3*X+1 at factor
  have value := A2Header.physical_endpoint exit.physical
  have yPos : 0<Y := by rw [←value]; exact step_pos X
  have yOdd : Y%2=1 := by rw [←value]; exact step_odd X
  have trueFactor : 3*w+1=2*Y := by unfold w; omega
  have wPos : 0<w := by omega
  have wOdd : w%2=1 := by omega
  have dyadic : 262144*Y=177147*J+260843 := suffix.book
  change 2*(177147*J+260843)<262144*(3*N+1) at price
  rw [←dyadic] at price
  have wPaid : w<N := by omega
  have source : Segment w Y 1 1 1 :=
    ⟨A2Header.Physical.edge wPos wOdd yPos yOdd (by decide) trueFactor,trueFactor.symm⟩
  exact ⟨wPos,wOdd,wPaid,yPos,yOdd,compose entry suffix,source⟩

/-- The entire valuation-five exit in the c=3 E1 row is paid. -/
theorem bandThreeAtFive {t X Y : Nat}
    (twoBlocks : Segment (entry3.at t) X 10 13 84217) (exit : Segment X Y 1 5 1) :
    PaidMeeting (originalSeed (18+32*t)) := by
  have price : 2*(177147*entry3.at t+260843)<2^18*(3*originalSeed (18+32*t)+1) := by
    change 2*(177147*entry3.at t+260843)<262144*(3*originalSeed (18+32*t)+1)
    simp only [entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨pos,odd,paid,yPos,yOdd,orig,src⟩ := oneReturnSource (entry3History t).1 twoBlocks exit price
  exact ⟨(2*Y-1)/3,Y,_,_,_,1,1,1,pos,odd,paid,yPos,yOdd,orig,src⟩

/-- The entire valuation-five exit in the c=5 E1 row is paid. -/
theorem bandFiveAtFive {t X Y : Nat}
    (twoBlocks : Segment (entry5.at t) X 10 13 84217) (exit : Segment X Y 1 5 1) :
    PaidMeeting (originalSeed (10+128*t)) := by
  have price : 2*(177147*entry5.at t+260843)<2^18*(3*originalSeed (10+128*t)+1) := by
    change 2*(177147*entry5.at t+260843)<262144*(3*originalSeed (10+128*t)+1)
    simp only [entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨pos,odd,paid,yPos,yOdd,orig,src⟩ := oneReturnSource (entry5History t).1 twoBlocks exit price
  exact ⟨(2*Y-1)/3,Y,_,_,_,1,1,1,pos,odd,paid,yPos,yOdd,orig,src⟩

/-- The exact affine entry lowers the former c=3 descent cutoff from the
valuation seven to six. The actual higher valuation is left unchanged. -/
theorem bandThreeAtLeastSix {t X Y c : Nat} (hc : 6≤c)
    (twoBlocks : Segment (entry3.at t) X 10 13 84217) (exit : Segment X Y 1 c 1) :
    let N := originalSeed (18+32*t)
    Y<N ∧ Segment N Y 76 (102+(13+c)) (177147*originalCost 3 19+2^102*260843) := by
  have canPay : 177147*entry3.at t+260843<524288*originalSeed (18+32*t) := by
    simp only [entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have pow : (524288:Nat)≤2^(13+c) :=
    Nat.pow_le_pow_right (by decide : 0<2) (show 19≤13+c by omega)
  exact Front4bShortExit.guardedDescent (entry3History t).1 twoBlocks exit
    (Nat.lt_of_lt_of_le canPay (Nat.mul_le_mul_right _ pow))

end CollatzCharacterBridge.Front4bShortExitFiveSix

#print axioms CollatzCharacterBridge.Front4bShortExitFiveSix.oneReturnSource
#print axioms CollatzCharacterBridge.Front4bShortExitFiveSix.bandThreeAtFive
#print axioms CollatzCharacterBridge.Front4bShortExitFiveSix.bandFiveAtFive
#print axioms CollatzCharacterBridge.Front4bShortExitFiveSix.bandThreeAtLeastSix
