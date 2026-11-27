import Front4bGuardRun
import Front4bE1

namespace CollatzCharacterBridge.Front4bShortExit

open A2SecondSwitchWordCompiler (compile_word)
open StagedCylinder (Segment compose cast_segment shifted_segment offset)
open Front4bRowEven (originalSeed originalCost originalSeedFormula)
open Front4bE1 (entry5 entry5History)
open Front4bGuardRun (entry3 entry3History)
open P5CompensationMeetings (Affine)

set_option maxRecDepth 14000
set_option maxHeartbeats 1400000

/-- Consume the exact two-block exit history with a real terminal valuation.
The original N and every accumulated additive are retained. -/
theorem guardedDescent {N J X Y j S B c : Nat}
    (entry : Segment N J j S B)
    (twoBlocks : Segment J X 10 13 84217)
    (exit : Segment X Y 1 c 1)
    (price : 177147*J+260843<2^(13+c)*N) :
    Y<N ∧ Segment N Y (j+11) (S+(13+c)) (177147*B+2^S*260843) := by
  have suffix : Segment J Y 11 (13+c) 260843 := by
    simpa only [Nat.pow_one, Nat.mul_one] using compose twoBlocks exit
  have path : Segment N Y (j+11) (S+(13+c)) (177147*B+2^S*260843) :=
    compose entry suffix
  rw [←suffix.book] at price
  exact ⟨Nat.lt_of_mul_lt_mul_left price,path⟩

/-- In the c=5 band, an actual next valuation at least six pays this exit. -/
theorem bandFiveGuard {t X Y c : Nat} (hc : 6≤c)
    (twoBlocks : Segment (entry5.at t) X 10 13 84217) (exit : Segment X Y 1 c 1) :
    let N := originalSeed (10+128*t)
    Y<N ∧ Segment N Y 77 (104+(13+c)) (177147*originalCost 4 73+2^104*260843) := by
  obtain ⟨history,_,_,height⟩ := entry5History t
  have large : 2≤originalSeed (10+128*t) := by rw [originalSeedFormula]; omega
  have pow : (524288:Nat)≤2^(13+c) :=
    Nat.pow_le_pow_right (by decide : (2:Nat)>0) (show 19≤13+c by omega)
  have pay : 177147*entry5.at t+260843<524288*originalSeed (10+128*t) := by omega
  exact guardedDescent history twoBlocks exit (Nat.lt_of_lt_of_le pay (Nat.mul_le_mul_right _ pow))

/-- In the c=3 band, an actual next valuation at least seven pays this exit. -/
theorem bandThreeGuard {t X Y c : Nat} (hc : 7≤c)
    (twoBlocks : Segment (entry3.at t) X 10 13 84217) (exit : Segment X Y 1 c 1) :
    let N := originalSeed (18+32*t)
    Y<N ∧ Segment N Y 76 (102+(13+c)) (177147*originalCost 3 19+2^102*260843) := by
  obtain ⟨history,height⟩ := entry3History t
  have large : 2≤originalSeed (18+32*t) := by rw [originalSeedFormula]; omega
  have pow : (1048576:Nat)≤2^(13+c) :=
    Nat.pow_le_pow_right (by decide : (2:Nat)>0) (show 20≤13+c by omega)
  have pay : 177147*entry3.at t+260843<1048576*originalSeed (18+32*t) := by omega
  exact guardedDescent history twoBlocks exit (Nat.lt_of_lt_of_le pay (Nat.mul_le_mul_right _ pow))

private def exitWord : List Nat := [1,1,1,2,2,1,1,1,2,1,7]
private def start : Nat := 10577305533203269133361597672096255535
private def finish : Nat := 1786935752191886441390616362398944263

private theorem physicalBase : Segment start finish 11 20 260843 := by
  exact compile_word exitWord (by decide) (by decide) (by decide) (by decide)
    (by intro a ha; simp [exitWord] at ha; omega) (by decide)

/-- Every seed in this explicit progression executes the two weak blocks and
its actual valuation-seven exit, which descends below that same seed. -/
theorem bandFiveExitFamily (h : Nat) :
    let t := 42784+2^18*h
    let N := originalSeed (10+128*t)
    let Y := finish+2*3^77*h
    Y<N ∧ Segment N Y 77 124 44071821087623256894712467796645809491 := by
  dsimp only
  have word := shifted_segment physicalBase 0 66 h
  have enter : offset start (20+1+0) 66 h=entry5.at (42784+2^18*h) := by
    simp only [offset,start,entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have finishAt : offset finish (0+1) (66+11) h=finish+2*3^77*h := by
    simp [offset]
  have localPath := cast_segment word enter finishAt
  have full : Segment (originalSeed (10+128*(42784+2^18*h))) (finish+2*3^77*h)
      77 124 44071821087623256894712467796645809491 :=
    compose (entry5History (42784+2^18*h)).1 localPath
  have price : finish+2*3^77*h<originalSeed (10+128*(42784+2^18*h)) := by
    rw [originalSeedFormula]
    simp only [finish,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨price,full⟩

private def switched : Nat := 20080353473190581245366158080620235119

private theorem switchBase : Segment start switched 5 7 227 := by
  exact compile_word [1,1,1,2,2] (by decide) (by decide) (by decide) (by decide)
    (by intro a ha; simp at ha; omega) (by decide)

/-- The first switch in the family really increases the cofactor and
leaves the old half-source price window. The same N is used at both cuts. -/
theorem bandFiveFirstSwitch (h : Nat) :
    let t := 42784+2^18*h
    let N := originalSeed (10+128*t)
    let J := entry5.at t
    let Z := switched+2^14*3^71*h
    2*N+1<Z ∧ (J+1)%32=16 ∧ (Z+1)%32=16 ∧ (J+1)/16<(Z+1)/16 ∧
      Segment N Z 71 111 (243*originalCost 4 73+2^104*227) := by
  dsimp only
  have word := shifted_segment switchBase 13 66 h
  have enter : offset start (7+1+13) 66 h=entry5.at (42784+2^18*h) := by
    simp only [offset,start,entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have localPath := cast_segment word enter
    (show offset switched (13+1) (66+5) h=switched+2^14*3^71*h from rfl)
  obtain ⟨history,_,_,entryHeight⟩ := entry5History (42784+2^18*h)
  have out : 2*originalSeed (10+128*(42784+2^18*h))+1<switched+2^14*3^71*h := by
    rw [originalSeedFormula]
    simp only [switched,Nat.mul_add,←Nat.mul_assoc]
    omega
  have jphase : (entry5.at (42784+2^18*h)+1)%32=16 := by
    simp only [entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have zphase : (switched+2^14*3^71*h+1)%32=16 := by
    simp only [switched,←Nat.mul_assoc]
    omega
  refine ⟨out,jphase,zphase,?_,compose history localPath⟩
  omega

end CollatzCharacterBridge.Front4bShortExit

#print axioms CollatzCharacterBridge.Front4bShortExit.guardedDescent
#print axioms CollatzCharacterBridge.Front4bShortExit.bandFiveGuard
#print axioms CollatzCharacterBridge.Front4bShortExit.bandThreeGuard
#print axioms CollatzCharacterBridge.Front4bShortExit.bandFiveExitFamily
#print axioms CollatzCharacterBridge.Front4bShortExit.bandFiveFirstSwitch
