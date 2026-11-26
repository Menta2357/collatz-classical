import P5ROddThreeReadmission
import P5RenewalRun

namespace CollatzCharacterBridge.P5RZeroA2

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine Word affine_admissible affine_edge word_segment)
open A2CertifiedLanding (Descended PaidMeeting)
open A2CertifiedLandingTrace (reduce_window_with_trace)
open P5ROddThreeReadmission (RankedResidual rank_associated)

set_option maxRecDepth 16000
set_option maxHeartbeats 1400000

def original : Affine := ⟨206466174079, 1099511627776⟩
def oldSource : Affine := ⟨165359444351, 880602513408⟩
def anchor : Affine := ⟨837132187037, 4458050224128⟩
def sourceAnchor : Affine := ⟨837132187031, 4458050224128⟩
def parExit : Affine := ⟨353165141407, 1880739938304⟩
def entry : Affine := ⟨318207526169, 1694577218886⟩
def sourceExit : Affine := ⟨88291285351, 470184984576⟩

private def originalWord : Word :=
  [(1, ⟨309699261119, 1649267441664⟩),
   (1, ⟨464548891679, 2473901162496⟩),
   (1, ⟨696823337519, 3710851743744⟩),
   (1, ⟨1045235006279, 5566277615616⟩),
   (1, ⟨1567852509419, 8349416423424⟩),
   (1, ⟨2351778764129, 12524124635136⟩),
   (2, ⟨1763834073097, 9393093476352⟩),
   (2, ⟨1322875554823, 7044820107264⟩),
   (1, ⟨1984313332235, 10567230160896⟩),
   (1, ⟨2976469998353, 15850845241344⟩),
   (2, ⟨2232352498765, 11888133931008⟩),
   (3, anchor),
   (3, ⟨313924570139, 1671768834048⟩),
   (1, ⟨470886855209, 2507653251072⟩),
   (2, parExit),
   (1, ⟨529747712111, 2821109907456⟩),
   (1, ⟨794621568167, 4231664861184⟩),
   (1, ⟨1191932352251, 6347497291776⟩),
   (1, ⟨1787898528377, 9521245937664⟩),
   (2, ⟨1340923896283, 7140934453248⟩),
   (1, ⟨2011385844425, 10711401679872⟩),
   (2, ⟨1508539383319, 8033551259904⟩),
   (1, ⟨2262809074979, 12050326889856⟩),
   (1, ⟨3394213612469, 18075490334784⟩),
   (5, entry)]

private def sourceWord : Word :=
  [(1, ⟨248039166527, 1320903770112⟩),
   (1, ⟨372058749791, 1981355655168⟩),
   (1, ⟨558088124687, 2972033482752⟩),
   (1, sourceAnchor),
   (1, ⟨1255698280547, 6687075336192⟩),
   (1, ⟨1883547420821, 10030613004288⟩),
   (6, sourceExit)]

/-- Real reserve five at the source checkpoint precludes a positive renewal count. -/
theorem zero_renewal_books (j : Nat) :
    0<oldSource.at j ∧ (oldSource.at j)%2=1 ∧ oldSource.at j<original.at j ∧
    anchor.at j=sourceAnchor.at j+6 ∧
    Segment (original.at j) (anchor.at j) 12 17 595825 ∧
    Segment (oldSource.at j) (sourceAnchor.at j) 4 4 65 ∧
    P5RenewalRun.Reserve (sourceAnchor.at j) 5 ∧
    (∀ n z, P5RenewalRun.Run (sourceAnchor.at j) n z → n=0) ∧
    Segment (original.at j) (parExit.at j) 15 23 22509803 ∧
    Segment (oldSource.at j) (sourceExit.at j) 7 12 2059 := by
  have sourceValid := affine_admissible (f := oldSource) (by decide) j
  have reserve : P5RenewalRun.Reserve (sourceAnchor.at j) 5 := by
    refine ⟨?_,(affine_admissible (f := sourceAnchor) (by decide) j).2,
      130801904223+696570347520*j,?_,?_⟩
    · simp only [sourceAnchor, Affine.at]
      omega
    · omega
    · simp only [sourceAnchor, Affine.at]
      change 5*(837132187031+4458050224128*j)-19=32*(130801904223+696570347520*j)
      omega
  refine ⟨sourceValid.1,sourceValid.2,?_,?_,?_,?_,reserve,?_,?_,?_⟩
  · simp only [oldSource,original,Affine.at]
    omega
  · simp only [anchor,sourceAnchor,Affine.at]
    omega
  · exact word_segment j original (originalWord.take 12) (by decide)
  · exact word_segment j oldSource (sourceWord.take 4) (by decide)
  · intro n z h
    have h' := (P5RenewalRun.exact_run_range reserve n).mp ⟨z,h⟩
    omega
  · exact word_segment j original (originalWord.take 15) (by decide)
  · exact word_segment j oldSource sourceWord (by decide)

theorem entry_book (j : Nat) :
    Segment (original.at j) (entry.at j) 25 39 1913372407075 :=
  word_segment j original originalWord (by decide)

theorem entry_bounds (j : Nat) :
    original.at j<entry.at j ∧ entry.at j<parExit.at j ∧ parExit.at j<2*original.at j+1 := by
  simp only [original,entry,parExit,Affine.at]
  omega

private theorem actual_of_divisor (x power : Nat) (ho : x%2=1)
    (hd : 3*x+1=2^power*((3*x+1)/2^power)) :
    ∃ a, power≤a ∧ 3*x+1=2^a*step x := by
  obtain ⟨a,_,hf⟩ := P5R3S5.actual_step_factor x ho
  refine ⟨a,?_,hf⟩
  by_cases enough : power≤a
  · exact enough
  have d : power=a+1+(power-(a+1)) := by omega
  have powerEq : 2^power=2^a*(2*2^(power-(a+1))) := by
    calc
      2^power=2^(a+1+(power-(a+1))) := congrArg (fun e : Nat => 2^e) d
      _=2^a*(2*2^(power-(a+1))) := by rw [Nat.pow_add,Nat.pow_add,Nat.pow_one,Nat.mul_assoc]
  have cancel : 2^a*step x=2^a*(2*(2^(power-(a+1))*((3*x+1)/2^power))) := by
    calc
      2^a*step x=3*x+1 := hf.symm
      _=2^power*((3*x+1)/2^power) := hd
      _=2^a*(2*(2^(power-(a+1))*((3*x+1)/2^power))) := by
        rw [powerEq]
        simp only [Nat.mul_assoc]
  have eq := Nat.eq_of_mul_eq_mul_left (Nat.pow_pos (by decide : 0<(2:Nat))) cancel
  have odd := step_odd x
  rw [eq] at odd
  omega

/-- The previously paper-only progression i = 16 + 32k, with physical
valuation at the last edge left free. -/
theorem direct_descent_16 (k : Nat) :
    let j := 2+4*k
    ∃ a, 3≤a ∧ step (entry.at j)<original.at j ∧
      Segment (original.at j) (step (entry.at j)) 26 (39+a) 6289873035113 := by
  let j := 2+4*k
  change ∃ a, 3≤a ∧ step (entry.at j)<original.at j ∧
    Segment (original.at j) (step (entry.at j)) 26 (39+a) 6289873035113
  have y := affine_admissible (f := entry) (by decide) j
  have divisible : 3*entry.at j+1=8*((3*entry.at j+1)/8) := by
    simp only [entry,Affine.at,j,Nat.mul_add]
    omega
  obtain ⟨a,ha,hf⟩ := actual_of_divisor (entry.at j) 3 y.2 (by simpa using divisible)
  have h8 := Nat.mul_le_mul_right (step (entry.at j))
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) ha)
  rw [←hf] at h8
  change 8*step (entry.at j)≤3*entry.at j+1 at h8
  have bound : 3*entry.at j+1<8*original.at j := by
    simp only [entry,original,Affine.at,j,Nat.mul_add]
    omega
  refine ⟨a,ha,by omega,?_⟩
  exact compose (entry_book j) (P5R3S5.step_segment _ a y.1 y.2 (by omega) hf)

private def connectorEntry : Affine := ⟨5401939182827, 27113235502176⟩
private def connectorOne : Affine := ⟨8102908774241, 40669853253264⟩
private def connectorTwo : Affine := ⟨6077181580681, 30502389939948⟩

/-- Complete the initial (1,2) with its next physical valuation. The
returned residual has rank strictly lower than the actual entry pivot. -/
theorem weak_exit_reduces (t : Nat) :
    let j := 3+16*t
    let N := original.at j
    let Y := entry.at j
    ∃ a H, 2≤a ∧ H<Y ∧ Segment Y H 3 (3+a) 23 ∧
      Segment N H 28 (42+a) 64305438710449 ∧
      (Descended N ∨ PaidMeeting N ∨ RankedResidual N Y H 28 (42+a) 64305438710449) := by
  let j := 3+16*t
  let N := original.at j
  let Y := entry.at j
  let U := connectorTwo.at t
  change ∃ a H, 2≤a ∧ H<Y ∧ Segment Y H 3 (3+a) 23 ∧
    Segment N H 28 (42+a) 64305438710449 ∧
    (Descended N ∨ PaidMeeting N ∨ RankedResidual N Y H 28 (42+a) 64305438710449)
  have eq : Y=connectorEntry.at t := by
    simp only [Y,j,entry,connectorEntry,Affine.at,Nat.mul_add]
    omega
  have opening : Segment Y U 2 3 5 := by
    rw [eq]
    exact compose
      (affine_edge (x := connectorEntry) (y := connectorOne) (a := 1) (by decide) t)
      (affine_edge (x := connectorOne) (y := connectorTwo) (a := 2) (by decide) t)
  have uv := affine_admissible (f := connectorTwo) (by decide) t
  have d : 3*U+1=4*((3*U+1)/4) := by
    simp only [U,connectorTwo,Affine.at]
    omega
  obtain ⟨a,ha,hf⟩ := actual_of_divisor U 2 uv.2 (by simpa using d)
  have tail : Segment Y (step U) 3 (3+a) 23 :=
    compose opening (P5R3S5.step_segment U a uv.1 uv.2 (by omega) hf)
  have full : Segment N (step U) 28 (42+a) 64305438710449 := by
    simpa only [←Nat.add_assoc] using compose (entry_book j) tail
  have h4 := Nat.mul_le_mul_right (step U)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) ha)
  rw [←hf] at h4
  change 4*step U≤3*U+1 at h4
  have book := opening.book
  change 8*U=9*Y+5 at book
  have yp := (affine_admissible (f := entry) (by decide) j).1
  have yLarge : 5<Y := by
    simp only [Y,entry,Affine.at]
    omega
  have rank : step U<Y := by omega
  have window : step U<2*N+1 := by
    rcases entry_bounds j with ⟨_,lo,hi⟩
    change Y<parExit.at j at lo
    change parExit.at j<2*N+1 at hi
    omega
  have big : 1<N := by simp only [N,original,Affine.at]; omega
  refine ⟨a,step U,ha,rank,tail,full,?_⟩
  rcases reduce_window_with_trace big full (step_pos _) (step_odd _) window with h|h|h
  · exact Or.inl h
  · exact Or.inr (Or.inl h)
  · exact Or.inr (Or.inr (rank_associated rank h))

end CollatzCharacterBridge.P5RZeroA2
