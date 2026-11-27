import Front4bShortExit
import A2SecondOne

namespace CollatzCharacterBridge.Front4bLowExit

open StagedCylinder (Segment compose)
open A2CertifiedLanding (PaidMeeting)
open FixedSourceRun (Ones)
open Front4bRowEven (originalSeed pivot originalSeedFormula)
open Front4bS29Landing (landing history62)
open P5CompensationMeetings (Affine affine_admissible)

set_option maxHeartbeats 1200000
set_option maxRecDepth 16000

/-- The quarter consumer applies at the end of any physical reserve, while
retaining the exact original segment from N to that checkpoint. -/
theorem atStrongInQuarterWindow {N X j S B a : Nat} (history : Segment N X j S B)
    (height : X<4*N+1) (strong : 3≤a) (factor : 3*X+1=2^a*step X) :
    PaidMeeting N := by
  obtain ⟨wp,wo,ws,orig,src,_⟩ := A2SecondOne.quarter_capture history height strong factor
  exact ⟨(X-1)/4,step X,j+1,S+a,3*B+2^S,1,a-2,1,wp,wo,ws,step_pos _,step_odd _,orig,src⟩

/-- An actual valuation three provides an auxiliary valuation-one
predecessor. A following run of any length and a strong break then pay
from half that auxiliary predecessor, with its own clock. -/
theorem afterThreeThenOnes {N X j S B h a : Nat} (history : Segment N X j S B)
    (height : X<8*N+5) (three : 3*X+1=8*step X)
    (run : Ones (step X) h) (strong : 3≤a)
    (factor : 3*orbit (step X) h+1=2^a*orbit (step X) (h+1)) :
    PaidMeeting N := by
  let Z := step X
  let A := (X-1)/4
  have zp : 0<Z := step_pos _
  have zo : Z%2=1 := step_odd _
  change 3*X+1=8*Z at three
  have shape : X=4*A+1 := by dsimp only [A]; omega
  have one : 3*A+1=2*Z := by omega
  have ap : 0<A := by omega
  have ao : A%2=1 := by omega
  have smallA : A<2*N+1 := by omega
  have way : Segment A Z 1 1 1 :=
    ⟨A2Header.Physical.edge ap ao zp zo (by decide) one,one.symm⟩
  have toZ := A2Header.physical_endpoint way.physical
  have shift (i : Nat) : orbit A (i+1)=orbit Z i := by
    rw [Nat.add_comm i 1,orbit_add,toZ]
  have more : Ones A (h+1) := by
    intro i hi
    cases i with
    | zero => exact one.trans (by rw [toZ])
    | succ k =>
      change 3*orbit A (k+1)+1=2*orbit A (k+1+1)
      rw [shift k, shift (k+1)]
      exact run k (by omega)
  have later : 3*orbit A (h+1)+1=2^a*orbit A (h+2) := by
    rw [shift h,show h+2=h+1+1 by omega,shift (h+1)]
    exact factor
  obtain ⟨wp,wo,ws,_,src⟩ := A2HalfAdaptive.local_capture N A h a ap ao smallA more strong later
  rw [show orbit A (h+2)=orbit Z (h+1) by simpa only [Nat.add_assoc] using shift (h+1)] at src
  have edgeThree : Segment X Z 1 3 1 :=
    ⟨A2Header.Physical.edge (by omega) (by omega) zp zo (by decide) three,three.symm⟩
  have firstOnes := A2HalfAdaptive.ones_segment Z h zp zo run
  have exit : Segment (orbit Z h) (orbit Z (h+1)) 1 a 1 :=
    ⟨A2Header.Physical.edge (orbit_pos _ zp _) (orbit_odd _ zo _)
      (orbit_pos _ zp _) (orbit_odd _ zo _) (by omega) factor,factor.symm⟩
  have original := compose (compose (compose history edgeThree) firstOnes) exit
  exact ⟨A2HalfAdaptive.half A,orbit Z (h+1),_,_,_,_,_,_,wp,wo,ws,
    orbit_pos _ zp _,orbit_odd _ zo _,original,src⟩

private def crossTerminal : Affine :=
  ⟨424705090970292969852091631954538577,10948802178840438764154311867139503526⟩

/-- The low exit (3,4) in the c=3 band crosses the former pivot but stays
above the original seed. The certified first-crossing consumer keeps both
physical segments and returns payment or a smaller admitted pivot. -/
theorem bandThreeExit34Crossing (t : Nat) :
    let u := 325394+8388608*t
    let N := originalSeed u
    let V := pivot u
    let X := crossTerminal.at t
    N<X ∧ X<V ∧ A2FirstCrossingFusion.FirstCrossing N V X
      62 98 2417122598839266567112547605177 15 24 23666419 := by
  let u := 325394+8388608*t
  let N := originalSeed u
  let V := pivot u
  let X := crossTerminal.at t
  have admissible := affine_admissible (f:=landing) (by decide) u
  have last := affine_admissible (f:=crossTerminal) (by decide) t
  have book : 16777216*X=14348907*V+23666419 := by
    simp only [X,V,u,pivot,landing,crossTerminal,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path : Segment V X 15 24 23666419 :=
    A2SecondSwitchWordCompiler.compile_word [1,1,2,1,1,1,2,2,1,1,1,2,1,3,4]
      admissible.1 admissible.2 last.1 last.2 (by intro a ha; simp at ha; omega) book
  have inequalities : 1<N ∧ V<2*N+1 ∧ N<X ∧ X<V := by
    simp only [N,V,X,u,pivot,landing,crossTerminal,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have hit : A2FirstCrossingFusion.HitsBelow V V 15 :=
    ⟨15,by decide,by rw [A2Header.physical_endpoint path.physical]; exact inequalities.2.2.2⟩
  exact ⟨inequalities.2.2.1,inequalities.2.2.2,
    A2FirstCrossingFusion.reduce_first_crossing inequalities.1 admissible.2 inequalities.2.1
      (history62 u) path hit⟩

private theorem consumeCrossing {u X C : Nat} (tail : Segment (pivot u) X 17 27 C)
    (below : X<pivot u) :
    A2FirstCrossingFusion.FirstCrossing (originalSeed u) (pivot u) X
      62 98 2417122598839266567112547605177 17 27 C := by
  have odd := (affine_admissible (f:=landing) (by decide) u).2
  have guards : 1<originalSeed u ∧ pivot u<2*originalSeed u+1 := by
    simp only [pivot,landing,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact A2FirstCrossingFusion.reduce_first_crossing guards.1 odd guards.2 (history62 u) tail
    ⟨17,by decide,by rw [A2Header.physical_endpoint tail.physical]; exact below⟩

private def exitFourAfterThree : Affine :=
  ⟨79386152680312710528055108534669105921,98539219609563948877388806804255531734⟩

private def exitFourAfterTwo : Affine :=
  ⟨66548872528042083632207377670821971151,98539219609563948877388806804255531734⟩

/-- Three further twos suffice for a certified first crossing in the c=3
E1 band after the valuation-four exit, with later valuations free. -/
theorem bandThreeExitFourCrossing (t : Nat) :
    let u := 54064914+67108864*t
    let X := exitFourAfterThree.at t
    originalSeed u<X ∧ X<pivot u ∧
      A2FirstCrossingFusion.FirstCrossing (originalSeed u) (pivot u) X
        62 98 2417122598839266567112547605177 17 27 281155211 := by
  let u := 54064914+67108864*t
  let X := exitFourAfterThree.at t
  have start := affine_admissible (f:=landing) (by decide) u
  have last := affine_admissible (f:=exitFourAfterThree) (by decide) t
  have book : 134217728*X=129140163*pivot u+281155211 := by
    simp only [X,u,pivot,landing,exitFourAfterThree,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (pivot u) X 17 27 281155211 :=
    A2SecondSwitchWordCompiler.compile_word [1,1,2,1,1,1,2,2,1,1,1,2,1,4,2,2,2]
      start.1 start.2 last.1 last.2 (by intro a ha; simp at ha; omega) book
  have inequalities : originalSeed u<X ∧ X<pivot u := by
    simp only [X,u,pivot,landing,exitFourAfterThree,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨inequalities.1,inequalities.2,consumeCrossing tail inequalities.2⟩

/-- In the c=5 E1 band, two further twos reach the same price window. -/
theorem bandFiveExitFourCrossing (t : Nat) :
    let u := 45322250+67108864*t
    let X := exitFourAfterTwo.at t
    originalSeed u<X ∧ X<pivot u ∧
      A2FirstCrossingFusion.FirstCrossing (originalSeed u) (pivot u) X
        62 98 2417122598839266567112547605177 17 27 325351403 := by
  let u := 45322250+67108864*t
  let X := exitFourAfterTwo.at t
  have start := affine_admissible (f:=landing) (by decide) u
  have last := affine_admissible (f:=exitFourAfterTwo) (by decide) t
  have book : 134217728*X=129140163*pivot u+325351403 := by
    simp only [X,u,pivot,landing,exitFourAfterTwo,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (pivot u) X 17 27 325351403 :=
    A2SecondSwitchWordCompiler.compile_word [1,1,2,2,1,1,1,2,2,1,1,1,2,1,4,2,2]
      start.1 start.2 last.1 last.2 (by intro a ha; simp at ha; omega) book
  have inequalities : originalSeed u<X ∧ X<pivot u := by
    simp only [X,u,pivot,landing,exitFourAfterTwo,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨inequalities.1,inequalities.2,consumeCrossing tail inequalities.2⟩

end CollatzCharacterBridge.Front4bLowExit

#print axioms CollatzCharacterBridge.Front4bLowExit.atStrongInQuarterWindow
#print axioms CollatzCharacterBridge.Front4bLowExit.afterThreeThenOnes
#print axioms CollatzCharacterBridge.Front4bLowExit.bandThreeExit34Crossing
#print axioms CollatzCharacterBridge.Front4bLowExit.bandThreeExitFourCrossing
#print axioms CollatzCharacterBridge.Front4bLowExit.bandFiveExitFourCrossing
