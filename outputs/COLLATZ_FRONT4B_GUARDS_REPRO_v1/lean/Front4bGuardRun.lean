import Front4bQuarterTail
import Front4bE1

namespace CollatzCharacterBridge.Front4bGuardRun

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine affine_admissible)
open A2SecondSwitchWordCompiler (compile_word)
open Front4bS29Landing (landing history62)
open Front4bRowEven (originalSeed pivot originalCost originalSeedFormula)
open A2CertifiedLanding (PaidMeeting)
open Front4bQuarterTail (Tail HeadBook paidOfActualRun)

def entry3 : Affine :=
  ⟨48703904041268437968961386239215,82408411687020299631788378142744⟩

/-- Fix the original checkpoint before the free one-run in the weak c=3 guard. -/
theorem entry3History (t : Nat) :
    Segment (originalSeed (18+32*t)) (entry3.at t) 65 102 (originalCost 3 19) ∧
      entry3.at t<4*originalSeed (18+32*t)+3 := by
  let u := 18+32*t
  have start := affine_admissible (f:=landing) (by decide) u
  have finish := affine_admissible (f:=entry3) (by decide) t
  have book : 16*entry3.at t=27*pivot u+19 := by
    simp only [u,pivot,landing,entry3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path : Segment (pivot u) (entry3.at t) 3 4 19 :=
    compile_word [1,1,2] start.1 start.2 finish.1 finish.2
      (by intro a ha; simp at ha; omega) book
  refine ⟨compose (history62 u) path,?_⟩
  simp only [u,entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
  omega

theorem band3AdaptiveTail {tail : Tail} (t L Q Z : Nat)
    (length : 2≤L) (odd : Q%2=1) (run : entry3.at t+1=2^(L+1)*Q)
    (head : HeadBook tail (orbit (entry3.at t) L) Z) :
    PaidMeeting (originalSeed (18+32*t)) := by
  obtain ⟨history,price⟩ := entry3History t
  exact paidOfActualRun length odd run price history head

theorem band5AdaptiveTail {tail : Tail} (t L Q Z : Nat)
    (length : 2≤L) (odd : Q%2=1)
    (run : Front4bE1.entry5.at t+1=2^(L+1)*Q)
    (head : HeadBook tail (orbit (Front4bE1.entry5.at t) L) Z) :
    PaidMeeting (originalSeed (10+128*t)) := by
  obtain ⟨history,_,_,price⟩ := Front4bE1.entry5History t
  exact paidOfActualRun length odd run (by omega) history head

end CollatzCharacterBridge.Front4bGuardRun

#print axioms CollatzCharacterBridge.Front4bGuardRun.entry3History
#print axioms CollatzCharacterBridge.Front4bGuardRun.band3AdaptiveTail
#print axioms CollatzCharacterBridge.Front4bGuardRun.band5AdaptiveTail
