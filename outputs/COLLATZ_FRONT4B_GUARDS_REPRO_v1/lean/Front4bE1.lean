import Front4bRowEven
import A2HalfAdaptive
import A2SecondSwitchWordCompiler

namespace CollatzCharacterBridge.Front4bE1

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine Word endpoint word_segment affine_admissible)
open Front4bS29Landing (landing history62)
open Front4bRowEven (originalSeed pivot originalCost originalSeedFormula)
open FixedSourceRun (Ones)
open A2CertifiedLanding (PaidMeeting)
open A2SecondSwitchWordCompiler (compile_word)

set_option maxRecDepth 12000
set_option maxHeartbeats 1000000

/-- The checkpoint just before the first one in the c=5 residual. -/
def entry5 : Affine := ⟨21076350839635022295760718777647,247225235061060898895365134428232⟩

private def pivot5 : Affine := ⟨16652919181933844776897358046535,195338457332196265793868748190208⟩

private def word5 : Word :=
  [(1,⟨24979378772900767165346037069803,293007685998294398690803122285312⟩),
   (1,⟨37469068159351150748019055604705,439511528997441598036204683427968⟩),
   (2,⟨28101801119513363061014291703529,329633646748081198527153512570976⟩),
   (2,entry5)]

theorem entry5History (t : Nat) :
    Segment (originalSeed (10+128*t)) (entry5.at t) 66 104 (originalCost 4 73) ∧
    0<entry5.at t ∧ entry5.at t%2=1 ∧ entry5.at t<2*originalSeed (10+128*t)+1 := by
  have start : pivot (10+128*t)=pivot5.at t := by
    simp only [pivot,landing,pivot5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t pivot5 word5 (by decide)
  change Segment (pivot5.at t) (entry5.at t) 4 6 73 at path
  rw [←start] at path
  have admissible := affine_admissible (f:=entry5) (by decide) t
  have height : entry5.at t<2*originalSeed (10+128*t)+1 := by
    simp only [entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨compose (history62 (10+128*t)) path,admissible.1,admissible.2,height⟩

/-- All strong ruptures after a nonempty run in c=5 pay by the sealed half source. -/
theorem band5StrongRupture (t k b : Nat) (run : Ones (entry5.at t) (k+1)) (hb : 3≤b)
    (factor : 3*orbit (entry5.at t) (k+1)+1=2^b*orbit (entry5.at t) (k+2)) :
    PaidMeeting (originalSeed (10+128*t)) := by
  obtain ⟨history,positive,odd,height⟩ := entry5History t
  obtain ⟨wp,wo,price,orig,src⟩ :=
    A2HalfAdaptive.history_capture history positive odd height run hb factor
  exact ⟨A2HalfAdaptive.half (entry5.at t),orbit (entry5.at t) (k+2),
    66+(k+2),104+(k+1+b),3^(k+2)*originalCost 4 73+A2HalfAdaptive.originalCost k*2^104,
    k+2,k+b,A2HalfAdaptive.sourceCost k,wp,wo,price,orbit_pos _ positive _,orbit_odd _ odd _,orig,src⟩

/-- Derive the finite first rupture from the physical orbit, leaving only two unpaid here. -/
theorem band5PaidOrTwo (t : Nat) :
    PaidMeeting (originalSeed (10+128*t)) ∨
      ∃ m, 1≤m ∧ Ones (entry5.at t) m ∧
        3*orbit (entry5.at t) m+1=4*orbit (entry5.at t) (m+1) := by
  obtain ⟨_,positive,odd,_⟩ := entry5History t
  obtain ⟨m,b,run,lower,factor⟩ := A2HalfAdaptive.first_break (entry5.at t) odd
  have phase : entry5.at t%4=3 := by
    simp only [entry5,Affine.at]
    omega
  have nonempty : 1≤m := by
    cases m with
    | succ m => omega
    | zero =>
      change 3*entry5.at t+1=2^b*orbit (entry5.at t) 1 at factor
      rw [show b=(b-2)+2 by omega,Nat.pow_add] at factor
      change 3*entry5.at t+1=2^(b-2)*4*orbit (entry5.at t) 1 at factor
      rw [show 2^(b-2)*4*orbit (entry5.at t) 1=4*(2^(b-2)*orbit (entry5.at t) 1) by ac_rfl] at factor
      omega
  by_cases two : b=2
  · rw [two] at factor
    exact Or.inr ⟨m,nonempty,run,factor⟩
  · have mEq : m=(m-1)+1 := by omega
    have nextEq : m-1+2=m+1 := by omega
    have run' : Ones (entry5.at t) (m-1+1) := by rwa [←mEq]
    have factor' : 3*orbit (entry5.at t) (m-1+1)+1=
        2^b*orbit (entry5.at t) (m-1+2) := by rwa [←mEq,nextEq]
    exact Or.inl (band5StrongRupture t (m-1) b run' (by omega) factor')

/-- A terminal with a long ternary run has a physical, separate all-ones source. -/
theorem terminalOnesPaid {N Z j S B h q : Nat} (history : Segment N Z j S B)
    (hp : 0<q) (factor : Z+1=2*3^h*q)
    (price : 2^h*(Z+1)<3^h*(N+1)) : PaidMeeting N := by
  let w := 2^(h+1)*q-1
  have positive : 0<2^h*q := Nat.mul_pos (Nat.pow_pos (by decide)) hp
  have oddSource : 0<w ∧ w%2=1 := by
    simp only [w,Nat.pow_succ,show (2:Nat)^h*2*q=2*(2^h*q) by ac_rfl]
    omega
  have zRepr : Z=2*3^h*q-1 := by omega
  have oddTerminal : 0<Z ∧ Z%2=1 := by
    have p3 : 0<3^h*q := Nat.mul_pos (Nat.pow_pos (by decide)) hp
    rw [zRepr,show 2*3^h*q=2*(3^h*q) by ac_rfl]
    omega
  have scaling : 2^h*(Z+1)=3^h*(2^(h+1)*q) := by
    rw [factor,Nat.pow_succ]
    ac_rfl
  have small : w<N := by
    rw [scaling] at price
    have bound := Nat.lt_of_mul_lt_mul_left price
    dsimp only [w]
    omega
  obtain ⟨endPoint,run⟩ := FixedSourceRun.ones_prefix h q hp
  have src := A2HalfAdaptive.ones_segment w h oddSource.1 oddSource.2 run
  rw [show orbit w h=Z by exact endPoint.trans zRepr.symm] at src
  exact ⟨w,Z,j,S,B,h,h,3^h-2^h,oddSource.1,oddSource.2,small,
    oddTerminal.1,oddTerminal.2,history,src⟩

private def terminal3 : Affine := ⟨120821149209978430467472369423233629,135170397269635046471040887248635846⟩
private def terminal5 : Affine := ⟨183574575455836001588840644393026779,1216533575426715418239367985237722614⟩

/-- Six physical ones, rupture two and then five in the c=3 residual. -/
theorem band3RuptureTwoFive (t : Nat) :
    let u := 58578+65536*t
    let N := originalSeed u
    let Z := terminal3.at t
    Segment N Z 73 115 (originalCost 11 227587) ∧
      3*N+1<2*Z ∧ PaidMeeting N := by
  let u := 58578+65536*t
  let N := originalSeed u
  let Z := terminal3.at t
  have V := affine_admissible (f:=landing) (by decide) u
  have W := affine_admissible (f:=terminal3) (by decide) t
  have localBook : 131072*Z=177147*pivot u+227587 := by
    simp only [Z,u,pivot,landing,terminal3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have suffix : Segment (pivot u) Z 11 17 227587 := by
    exact compile_word [1,1,2,1,1,1,1,1,1,2,5] V.1 V.2 W.1 W.2
      (by intro a ha; simp at ha; omega) localBook
  have history : Segment N Z 73 115 (originalCost 11 227587) := compose (history62 u) suffix
  let q := 6712286067221023914859576079068535+7509466514979724803946715958257547*t
  have factor : Z+1=2*3^2*q := by simp only [Z,terminal3,Affine.at,q]; omega
  have price : 2^2*(Z+1)<3^2*(N+1) := by
    simp only [Z,N,u,terminal3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have oneTooHigh : 3*N+1<2*Z := by
    simp only [Z,N,u,terminal3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨history,oneTooHigh,terminalOnesPaid history (h:=2) (by dsimp only [q]; omega) factor price⟩

/-- Seven physical ones, rupture two and then five in the c=5 residual. -/
theorem band5RuptureTwoFive (t : Nat) :
    let u := 79114+524288*t
    let N := originalSeed u
    let Z := terminal5.at t
    Segment N Z 75 118 (originalCost 13 2680187) ∧
      3*N+1<2*Z ∧ PaidMeeting N := by
  let u := 79114+524288*t
  let N := originalSeed u
  let Z := terminal5.at t
  have V := affine_admissible (f:=landing) (by decide) u
  have W := affine_admissible (f:=terminal5) (by decide) t
  have localBook : 1048576*Z=1594323*pivot u+2680187 := by
    simp only [Z,u,pivot,landing,terminal5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have suffix : Segment (pivot u) Z 13 20 2680187 := by
    exact compile_word [1,1,2,2,1,1,1,1,1,1,1,2,5] V.1 V.2 W.1 W.2
      (by intro a ha; simp at ha; omega) localBook
  have history : Segment N Z 75 118 (originalCost 13 2680187) := compose (history62 u) suffix
  let q := 10198587525324222310491146910723710+67585198634817523235520443624317923*t
  have factor : Z+1=2*3^2*q := by simp only [Z,terminal5,Affine.at,q]; omega
  have price : 2^2*(Z+1)<3^2*(N+1) := by
    simp only [Z,N,u,terminal5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have oneTooHigh : 3*N+1<2*Z := by
    simp only [Z,N,u,terminal5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨history,oneTooHigh,terminalOnesPaid history (h:=2) (by dsimp only [q]; omega) factor price⟩

end CollatzCharacterBridge.Front4bE1

#print axioms CollatzCharacterBridge.Front4bE1.entry5History
#print axioms CollatzCharacterBridge.Front4bE1.band5StrongRupture
#print axioms CollatzCharacterBridge.Front4bE1.band5PaidOrTwo
#print axioms CollatzCharacterBridge.Front4bE1.terminalOnesPaid
#print axioms CollatzCharacterBridge.Front4bE1.band3RuptureTwoFive
#print axioms CollatzCharacterBridge.Front4bE1.band5RuptureTwoFive
