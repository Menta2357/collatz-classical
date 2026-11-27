import Front4bShortReentry

namespace CollatzCharacterBridge.Front4bShortReentryGuards

open StagedCylinder (Segment compose)
open Front4bRowEven (originalSeed originalSeedFormula originalCost)
open Front4bE1 (entry5 entry5History)
open Front4bGuardRun (entry3 entry3History)
open P5CompensationMeetings (Affine)

set_option maxRecDepth 14000
set_option maxHeartbeats 1600000

private theorem boundThree (t : Nat) : 2*entry3.at t<5*originalSeed (18+32*t) := by
  rw [originalSeedFormula]
  simp only [entry3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem boundFive (t : Nat) : 4*entry5.at t<7*originalSeed (10+128*t) := by
  rw [originalSeedFormula]
  simp only [entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem seedLower (u : Nat) : 16≤originalSeed u := by
  rw [originalSeedFormula]
  omega

def costAfterTwoEdges (c : Nat) : Nat := 782529+2^(13+c)

private theorem smallCost {c : Nat} (short : c=1 ∨ c=2) : costAfterTwoEdges c≤815297 := by
  rcases short with rfl | rfl <;> decide

/-- Compose the two actual post-block edges with an arbitrary prior
original book. The price guard is expressed at that same N. -/
theorem twoEdgeDescent {N J X Y Z j S B c e : Nat}
    (entry : Segment N J j S B) (twoBlocks : Segment J X 10 13 84217)
    (first : Segment X Y 1 c 1) (second : Segment Y Z 1 e 1)
    (price : 531441*J+costAfterTwoEdges c<2^(13+c+e)*N) :
    Z<N ∧ Segment N Z (j+12) (S+(13+c+e))
      (531441*B+2^S*costAfterTwoEdges c) := by
  have suffix : Segment J Z 12 (13+c+e) (costAfterTwoEdges c) := by
    simpa only [Nat.pow_one,Nat.mul_one,costAfterTwoEdges] using
      compose (compose twoBlocks first) second
  rw [←suffix.book] at price
  exact ⟨Nat.lt_of_mul_lt_mul_left price,compose entry suffix⟩

theorem bandFiveTwoEdges {t X Y Z c e : Nat} (short : c=1 ∨ c=2) (sum : 7≤c+e)
    (twoBlocks : Segment (entry5.at t) X 10 13 84217)
    (first : Segment X Y 1 c 1) (second : Segment Y Z 1 e 1) :
    let N := originalSeed (10+128*t)
    Z<N ∧ Segment N Z 78 (104+(13+c+e))
      (531441*originalCost 4 73+2^104*costAfterTwoEdges c) := by
  let N := originalSeed (10+128*t)
  have size : 16≤N := seedLower _
  have height : 4*entry5.at t<7*N := boundFive t
  have cost := smallCost short
  have pay : 531441*entry5.at t+costAfterTwoEdges c<1048576*N := by omega
  have pow : (1048576:Nat)≤2^(13+c+e) :=
    Nat.pow_le_pow_right (by decide : 0<2) (show 20≤13+c+e by omega)
  exact twoEdgeDescent (entry5History t).1 twoBlocks first second
    (Nat.lt_of_lt_of_le pay (Nat.mul_le_mul_right _ pow))

theorem bandThreeTwoEdges {t X Y Z c e : Nat} (short : c=1 ∨ c=2) (sum : 8≤c+e)
    (twoBlocks : Segment (entry3.at t) X 10 13 84217)
    (first : Segment X Y 1 c 1) (second : Segment Y Z 1 e 1) :
    let N := originalSeed (18+32*t)
    Z<N ∧ Segment N Z 77 (102+(13+c+e))
      (531441*originalCost 3 19+2^102*costAfterTwoEdges c) := by
  let N := originalSeed (18+32*t)
  have size : 16≤N := seedLower _
  have height : 2*entry3.at t<5*N := boundThree t
  have cost := smallCost short
  have pay : 531441*entry3.at t+costAfterTwoEdges c<2097152*N := by omega
  have pow : (2097152:Nat)≤2^(13+c+e) :=
    Nat.pow_le_pow_right (by decide : 0<2) (show 21≤13+c+e by omega)
  exact twoEdgeDescent (entry3History t).1 twoBlocks first second
    (Nat.lt_of_lt_of_le pay (Nat.mul_le_mul_right _ pow))

end CollatzCharacterBridge.Front4bShortReentryGuards

#print axioms CollatzCharacterBridge.Front4bShortReentryGuards.twoEdgeDescent
#print axioms CollatzCharacterBridge.Front4bShortReentryGuards.bandFiveTwoEdges
#print axioms CollatzCharacterBridge.Front4bShortReentryGuards.bandThreeTwoEdges
