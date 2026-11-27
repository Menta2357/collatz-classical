import QuarterTwoSix
import P5CompensationMeetings
import A2CertifiedLanding

namespace CollatzCharacterBridge.Front4bQuarterTail

open P5CompensationMeetings (Affine Word endpoint divisions cost)
open StagedCylinder (Segment)
open A2CertifiedLanding (PaidMeeting)
open QuarterTwoSix (source sourceRunEnd originalRunEnd ones_segment)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

inductive Tail where
  | twoFourFour | twoFiveTwo | twoSix
  deriving DecidableEq

def sourceStart : Tail → Affine
  | .twoFourFour => ⟨1697,2048⟩
  | .twoFiveTwo => ⟨481,1024⟩
  | .twoSix => ⟨97,512⟩

def originalStart (tail : Tail) : Affine :=
  ⟨9*(sourceStart tail).offset+8,9*(sourceStart tail).slope⟩

def originalWord : Tail → Word
  | .twoFourFour => [(2,⟨11461,13824⟩),(4,⟨2149,2592⟩),(4,⟨403,486⟩)]
  | .twoFiveTwo => [(2,⟨3253,6912⟩),(5,⟨305,648⟩),(2,⟨229,486⟩)]
  | .twoSix => [(2,⟨661,3456⟩),(6,⟨31,162⟩)]

def sourceWord : Tail → Word
  | .twoFourFour => [(2,⟨1273,1536⟩),(2,⟨955,1152⟩),(1,⟨1433,1728⟩),
      (2,⟨1075,1296⟩),(1,⟨1613,1944⟩)]
  | .twoFiveTwo => [(2,⟨361,768⟩),(2,⟨271,576⟩),(1,⟨407,864⟩),
      (1,⟨611,1296⟩),(1,⟨917,1944⟩)]
  | .twoSix => [(2,⟨73,384⟩),(2,⟨55,288⟩),(1,⟨83,432⟩),(1,⟨125,648⟩)]

def originalEnd (tail : Tail) (t : Nat) : Nat :=
  (endpoint (originalStart tail) (originalWord tail)).at t

def sourceEnd (tail : Tail) (t : Nat) : Nat :=
  (endpoint (sourceStart tail) (sourceWord tail)).at t

abbrev HeadBook (tail : Tail) (R Z : Nat) : Prop :=
  Segment R Z (originalWord tail).length (divisions (originalWord tail)) (cost (originalWord tail))

private theorem original_head (tail : Tail) (t : Nat) :
    HeadBook tail (9*(sourceStart tail).at t+8) (originalEnd tail t) := by
  have cert := P5CompensationMeetings.word_segment t (originalStart tail) (originalWord tail)
    (by cases tail <;> decide)
  exact StagedCylinder.cast_segment cert (by
    simp only [originalStart,Affine.at,Nat.mul_add,Nat.mul_assoc]
    omega) rfl

private theorem source_head (tail : Tail) (t : Nat) :
    Segment ((sourceStart tail).at t) (sourceEnd tail t)
      (sourceWord tail).length (divisions (sourceWord tail)) (cost (sourceWord tail)) :=
  P5CompensationMeetings.word_segment t (sourceStart tail) (sourceWord tail)
    (by cases tail <;> decide)

private theorem endpoints (tail : Tail) (t : Nat) :
    0<originalEnd tail t ∧ originalEnd tail t%2=1 ∧
    sourceEnd tail t=4*originalEnd tail t+1 := by
  cases tail <;> simp only [originalEnd,sourceEnd,endpoint,originalWord,sourceWord,
    originalStart,sourceStart,Affine.at] <;> omega

/-- The original word's exact book and odd endpoint force the phase of both
heads. The inferred parameter is independent of the final valuation. -/
theorem phaseOfHead {tail : Tail} {U Z : Nat} (h : HeadBook tail (9*U+8) Z) :
    ∃ t, U=(sourceStart tail).at t ∧ Z=originalEnd tail t := by
  have positiveLength : 0<(originalWord tail).length := by cases tail <;> decide
  have odd : Z%2=1 := by
    have landing := A2Header.physical_endpoint h.physical
    rw [← landing]
    rw [show (originalWord tail).length=(originalWord tail).length-1+1 by omega]
    exact step_odd _
  have book := h.book
  cases tail with
  | twoFourFour =>
    change 1024*Z=27*(9*U+8)+85 at book
    refine ⟨U/2048,?_⟩
    change U=1697+2048*(U/2048) ∧ Z=403+486*(U/2048)
    omega
  | twoFiveTwo =>
    change 512*Z=27*(9*U+8)+149 at book
    refine ⟨U/1024,?_⟩
    change U=481+1024*(U/1024) ∧ Z=229+486*(U/1024)
    omega
  | twoSix =>
    change 256*Z=9*(9*U+8)+7 at book
    refine ⟨U/512,?_⟩
    change U=97+512*(U/512) ∧ Z=31+162*(U/512)
    omega

def suffixCost (word : Word) : Nat := 3*cost word+2^divisions word

structure LocalMeeting (tail : Tail) (U Z Y gamma : Nat) : Prop where
  originalLast : 1≤gamma ∧ 3*Z+1=2^gamma*Y
  positiveTerminal : 0<Y
  oddTerminal : Y%2=1
  original : Segment (9*U+8) Y ((originalWord tail).length+1)
    (divisions (originalWord tail)+gamma) (suffixCost (originalWord tail))
  auxiliary : Segment U Y ((sourceWord tail).length+1)
    (divisions (sourceWord tail)+(gamma+2)) (suffixCost (sourceWord tail))

/-- The terminal relation lifts the actual valuation by exactly two on the
auxiliary trajectory. No bound on the last valuation is imposed. -/
theorem localMeetingOfHead {tail : Tail} {U Z : Nat}
    (head : HeadBook tail (9*U+8) Z) :
    ∃ gamma, LocalMeeting tail U Z (step Z) gamma := by
  obtain ⟨t,sourcePhase,origPhase⟩ := phaseOfHead head
  have sourceHead := source_head tail t
  rw [← sourcePhase] at sourceHead
  have rel := endpoints tail t
  rw [← origPhase] at rel
  obtain ⟨gamma,valid,physical⟩ := P5R3S5.actual_step_factor Z rel.2.1
  have terminalPos : 0<step Z := step_pos _
  have terminalOdd : step Z%2=1 := step_odd _
  have sourceFactor : 3*sourceEnd tail t+1=2^(gamma+2)*step Z := by
    have pow : 2^(gamma+2)*step Z=4*(2^gamma*step Z) := by
      rw [Nat.pow_add 2 gamma 2]
      change 2^gamma*4*step Z=4*(2^gamma*step Z)
      ac_rfl
    rw [pow,← physical,rel.2.2]
    omega
  have first := P5R3S5.step_segment Z gamma rel.1 rel.2.1 valid physical
  have second : Segment (sourceEnd tail t) (step Z) 1 (gamma+2) 1 :=
    ⟨A2Header.Physical.edge (by omega) (by omega) terminalPos terminalOdd (by omega) sourceFactor,
      sourceFactor.symm⟩
  exact ⟨gamma,⟨valid,physical⟩,terminalPos,terminalOdd,
    by simpa only [suffixCost,Nat.pow_one,Nat.mul_one] using StagedCylinder.compose head first,
    by simpa only [suffixCost,Nat.pow_one,Nat.mul_one] using StagedCylinder.compose sourceHead second⟩

structure Entry (N J k Q : Nat) : Prop where
  cofactorOdd : Q%2=1
  originFactor : J+1=2^(k+3)*Q
  paidHeight : J<4*N+3

private theorem runs {N J k Q : Nat} (entry : Entry N J k Q) :
    0<source k Q ∧ source k Q%2=1 ∧ source k Q<N ∧ source k Q=(J-3)/4 ∧
    originalRunEnd k Q=9*sourceRunEnd k Q+8 ∧
    Segment J (originalRunEnd k Q) (k+2) (k+2) (3^(k+2)-2^(k+2)) ∧
    Segment (source k Q) (sourceRunEnd k Q) k k (3^k-2^k) := by
  have qpos : 0<Q := by have := entry.cofactorOdd; omega
  have pa : 0<2^k*Q := Nat.mul_pos (Nat.pow_pos (by decide)) qpos
  have pb : 0<3^k*Q := Nat.mul_pos (Nat.pow_pos (by decide)) qpos
  have fo : 2^(k+3)*Q=8*(2^k*Q) := by
    rw [Nat.pow_add 2 k 3]
    change (2^k*8)*Q=8*(2^k*Q)
    ac_rfl
  have fs : 2^(k+1)*Q=2*(2^k*Q) := by rw [Nat.pow_succ]; ac_rfl
  have fron : J=2^((k+2)+1)*Q-1 := by
    rw [show k+2+1=k+3 by omega]
    have := entry.originFactor
    omega
  have paid : J<4*N+3 := entry.paidHeight
  have fj : J+1=8*(2^k*Q) := entry.originFactor.trans fo
  have bs : 2*3^k*Q=2*(3^k*Q) := by ac_rfl
  have bo : 2*3^(k+2)*Q=18*(3^k*Q) := by
    rw [Nat.pow_add 3 k 2]
    change 2*(3^k*9)*Q=(2*9)*(3^k*Q)
    ac_rfl
  have hp : 0<J ∧ J%2=1 ∧ 0<source k Q ∧ source k Q%2=1 ∧
      source k Q<N ∧ source k Q=(J-3)/4 := by
    simp only [source,fs]
    omega
  have po := FixedSourceRun.ones_prefix (k+2) Q qpos
  have ps := FixedSourceRun.ones_prefix k Q qpos
  rw [← fron] at po
  change orbit J (k+2)=originalRunEnd k Q ∧ FixedSourceRun.Ones J (k+2) at po
  change orbit (source k Q) k=sourceRunEnd k Q ∧ FixedSourceRun.Ones (source k Q) k at ps
  have os := ones_segment hp.1 hp.2.1 po.2
  have ss := ones_segment hp.2.2.1 hp.2.2.2.1 ps.2
  rw [po.1] at os
  rw [ps.1] at ss
  exact ⟨hp.2.2.1,hp.2.2.2.1,hp.2.2.2.2.1,hp.2.2.2.2.2,
    by simp only [originalRunEnd,sourceRunEnd,bo,bs]; omega,os,ss⟩

/-- Reattach the original running book and give a paid meeting with the
quarter source and its independent book. The run length is unbounded. -/
theorem paidOfHead {tail : Tail} {N J k Q j S B Z : Nat}
    (entry : Entry N J k Q) (history : Segment N J j S B)
    (head : HeadBook tail (originalRunEnd k Q) Z) : PaidMeeting N := by
  obtain ⟨pos,odd,small,_,related,originalOnes,sourceOnes⟩ := runs entry
  rw [related] at head originalOnes
  obtain ⟨gamma,meet⟩ := localMeetingOfHead head
  have original := StagedCylinder.compose history (StagedCylinder.compose originalOnes meet.original)
  have auxiliary := StagedCylinder.compose sourceOnes meet.auxiliary
  exact ⟨source k Q,step Z,_,_,_,_,_,_,pos,odd,small,meet.positiveTerminal,meet.oddTerminal,
    original,auxiliary⟩

/-- The phase alone suffices when the source-run endpoint is already known. -/
theorem paidOfPhase {tail : Tail} {N J k Q j S B t : Nat}
    (entry : Entry N J k Q) (history : Segment N J j S B)
    (phase : sourceRunEnd k Q=(sourceStart tail).at t) : PaidMeeting N := by
  have related := (runs entry).2.2.2.2.1
  have head := original_head tail t
  rw [← phase,← related] at head
  exact paidOfHead entry history head

/-- Same payment with the full run length L visible to the caller. -/
theorem paidOfActualRun {tail : Tail} {N J L Q j S B Z : Nat} (length : 2≤L)
    (cofactor : Q%2=1) (factor : J+1=2^(L+1)*Q) (height : J<4*N+3)
    (history : Segment N J j S B) (head : HeadBook tail (orbit J L) Z) : PaidMeeting N := by
  let k := L-2
  have len : k+2=L := by unfold k; omega
  have phase : k+3=L+1 := by omega
  have entry : Entry N J k Q := ⟨cofactor,by rwa [phase],height⟩
  have prefixRun := (runs entry).2.2.2.2.2.1
  have reach := A2Header.physical_endpoint prefixRun.physical
  rw [len] at reach
  rw [reach] at head
  exact paidOfHead entry history head

end CollatzCharacterBridge.Front4bQuarterTail

#print axioms CollatzCharacterBridge.Front4bQuarterTail.phaseOfHead
#print axioms CollatzCharacterBridge.Front4bQuarterTail.localMeetingOfHead
#print axioms CollatzCharacterBridge.Front4bQuarterTail.paidOfHead
#print axioms CollatzCharacterBridge.Front4bQuarterTail.paidOfPhase
#print axioms CollatzCharacterBridge.Front4bQuarterTail.paidOfActualRun
