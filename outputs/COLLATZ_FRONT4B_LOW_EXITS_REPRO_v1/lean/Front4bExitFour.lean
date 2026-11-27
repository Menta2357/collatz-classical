import Front4bGuardRun
import Front4bE1
import A2FirstCrossingFusion
import A2SecondOne

namespace CollatzCharacterBridge.Front4bExitFour

open StagedCylinder (Segment compose)
open A2CertifiedLanding (PaidMeeting Descended)
open A2FirstCrossingFusion (Paid)
open P5CompensationMeetings (Affine)
open Front4bE1 (entry5 entry5History)
open Front4bGuardRun (entry3 entry3History)
open Front4bRowEven (originalSeed originalCost originalSeedFormula)
open TwosCompression (Twos)

set_option maxRecDepth 14000
set_option maxHeartbeats 1200000

/-- The unpaid alternative retains the whole actual maximal run of twos,
its short length, the real exit valuation one, and its history from N. -/
def ShortTwoRun (N Y j S C cap : Nat) : Prop :=
  ∃ r U, r<cap ∧ Twos Y r ∧ ¬Twos Y (r+1) ∧ 3*U+1=2*step U ∧
    Segment Y U r (2*r) (4^r-3^r) ∧
    Segment N U (j+r) (S+2*r) (3^r*C+2^S*(4^r-3^r))

private theorem twosFromHistory {Y : Nat} (large : 1<Y) (odd : Y%2=1) :
    ∃ r U, 0<U ∧ U%2=1 ∧ Twos Y r ∧ ¬Twos Y (r+1) ∧
      4^r*(U-1)=3^r*(Y-1) ∧ Segment Y U r (2*r) (4^r-3^r) ∧
      (3*U+1=2*step U ∨ ∃ a, 3≤a ∧ 3*U+1=2^a*step U) := by
  obtain ⟨k,hk⟩ := oddPart_factor (Y-1) (by omega)
  let H := oddPart (Y-1)
  change Y-1=2^k*H at hk
  have ⟨hp,ho⟩ := oddPart_pos_and_odd (Y-1) (by omega)
  change 0<H at hp
  change H%2=1 at ho
  have kk : 1≤k := by
    cases k with
    | zero => simp only [Nat.pow_zero,Nat.one_mul] at hk; omega
    | succ k => omega
  let r := TwosCompression.count k
  let U := TwosCompression.endpoint k H
  have shape : Y=TwosCompression.seed k H := by unfold TwosCompression.seed; omega
  have cert := TwosCompression.compress k H kk hp ho
  have trueEnd : orbit Y r=U := by rw [shape]; exact cert.endpoint_eq
  have up : 0<U := trueEnd ▸ orbit_pos Y (by omega) r
  have uo : U%2=1 := trueEnd ▸ orbit_odd Y odd r
  have run : Twos Y r := by rw [shape]; exact cert.physical_twos
  have noMore : ¬Twos Y (r+1) := by rw [shape]; exact cert.maximal
  have book : 4^r*U=3^r*Y+(4^r-3^r) := by rw [shape]; exact cert.ledger
  have power : (3:Nat)^r≤4^r := Nat.pow_le_pow_left (by decide) r
  have subY : 3^r*Y=3^r*((Y-1)+1) := by congr 1; omega
  have centered : 4^r*(U-1)=3^r*(Y-1) := by
    have subU : 4^r*U=4^r*((U-1)+1) := by congr 1; omega
    rw [Nat.mul_add,Nat.mul_one] at subU subY
    omega
  refine ⟨r,U,up,uo,run,noMore,centered,?_,?_⟩
  · have steps := A2SecondOne.twos_physical (by omega : 0<Y) odd run
    rw [trueEnd] at steps
    exact ⟨steps,by rw [TwosCompression.power_conversion]; exact book⟩
  · by_cases even : k%2=0
    · exact Or.inr (cert.even_branch even).2
    · exact Or.inl (cert.odd_branch (by omega))

private theorem payLong {N Y U r cap : Nat} (run : cap≤r)
    (centered : 4^r*(U-1)=3^r*(Y-1)) (price : 3^cap*(Y-1)<4^cap*(N-1)) :
    U<N := by
  have split : r=cap+(r-cap) := by omega
  have strong : (3:Nat)^(r-cap)≤4^(r-cap) := Nat.pow_le_pow_left (by decide) _
  have all : 3^r*(Y-1)<4^r*(N-1) := calc
    _ = 3^(cap+(r-cap))*(Y-1) := congrArg (fun i => 3^i*(Y-1)) split
    _ = 3^(r-cap)*(3^cap*(Y-1)) := by rw [Nat.pow_add]; ac_rfl
    _ ≤ 4^(r-cap)*(3^cap*(Y-1)) := Nat.mul_le_mul_right _ strong
    _ < 4^(r-cap)*(4^cap*(N-1)) := Nat.mul_lt_mul_of_pos_left price (Nat.pow_pos (by decide))
    _ = 4^(cap+(r-cap))*(N-1) := by rw [Nat.pow_add]; ac_rfl
    _ = _ := congrArg (fun i => 4^i*(N-1)) split.symm
  rw [←centered] at all
  have paid := Nat.lt_of_mul_lt_mul_left all
  omega

/-- Entire maximal-twos continuation in the quarter price window.
Large r descends, and any actual strong rupture pays with its own source. -/
theorem maxTwosExit {N Y j S C cap : Nat} (start : Segment N Y j S C)
    (large : 1<Y) (odd : Y%2=1) (height : Y<4*N+1)
    (budget : 3^cap*(Y-1)<4^cap*(N-1)) :
    Paid N ∨ ShortTwoRun N Y j S C cap := by
  obtain ⟨r,U,up,uo,run,stop,center,path,phase⟩ := twosFromHistory large odd
  have whole := compose start path
  by_cases take : cap≤r
  · have pay := payLong take center budget
    exact Or.inl (Or.inl ⟨U,_,_,_,up,uo,pay,whole⟩)
  · rcases phase with one|⟨a,ha,factor⟩
    · exact Or.inr ⟨r,U,by omega,run,stop,one,path,whole⟩
    · have scale := Nat.mul_le_mul_right (Y-1) (Nat.pow_le_pow_left (by decide : 3≤4) r)
      rw [←center] at scale
      have uheight := Nat.le_of_mul_le_mul_left scale (Nat.pow_pos (by decide))
      have price : U<4*N+1 := by omega
      obtain ⟨wp,wo,ws,orig,src,_⟩ := A2SecondOne.quarter_capture whole price ha factor
      exact Or.inl (Or.inr ⟨(U-1)/4,step U,_,_,_,1,a-2,1,wp,wo,ws,
        step_pos _,step_odd _,orig,src⟩)

private theorem fourBook {J X Y : Nat}
    (head : Segment J X 10 13 84217) (four : Segment X Y 1 4 1) :
    Segment J Y 11 17 260843 := by
  simpa only [Nat.pow_one,Nat.mul_one] using compose head four

private theorem seedLarge (t : Nat) : 1000≤originalSeed t := by
  rw [originalSeedFormula]
  omega

private theorem calcThree {N J Y : Nat} (seed : 1000≤N) (lower : 1≤J)
    (upper : 4*J≤9*N) (book : 131072*Y=177147*J+260843) :
    1<Y ∧ Y<4*N+1 ∧ 81*(Y-1)<256*(N-1) := by omega

private theorem calcFive {N J Y : Nat} (seed : 1000≤N) (lower : 1≤J)
    (upper : 4*J≤7*N) (book : 131072*Y=177147*J+260843) :
    1<Y ∧ Y<4*N+1 ∧ 27*(Y-1)<64*(N-1) := by omega

private theorem rowThreePrices {t Y : Nat} (book : 131072*Y=177147*entry3.at t+260843) :
    1<Y ∧ Y<4*originalSeed (18+32*t)+1 ∧
        81*(Y-1)<256*(originalSeed (18+32*t)-1) := by
  have lower : 1≤entry3.at t := by simp only [entry3,Affine.at]; omega
  have upper : 4*entry3.at t≤9*originalSeed (18+32*t) := by
    simp only [entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact calcThree (seedLarge _) lower upper book

private theorem rowFivePrices {t Y : Nat} (book : 131072*Y=177147*entry5.at t+260843) :
    1<Y ∧ Y<4*originalSeed (10+128*t)+1 ∧
        27*(Y-1)<64*(originalSeed (10+128*t)-1) := by
  have lower : 1≤entry5.at t := by simp only [entry5,Affine.at]; omega
  have upper : 4*entry5.at t≤7*originalSeed (10+128*t) := by
    simp only [entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact calcFive (seedLarge _) lower upper book

/-- Valuation four in E1 c=3. The remaining one exit has at most three
preceding twos. The original return, division and additive books are exact. -/
theorem bandThreeAtFour {t X Y : Nat} (head : Segment (entry3.at t) X 10 13 84217)
    (four : Segment X Y 1 4 1) :
    let N := originalSeed (18+32*t)
    Paid N ∨ ShortTwoRun N Y 76 119 (177147*originalCost 3 19+2^102*260843) 4 := by
  dsimp only
  have localPath := fourBook head four
  have book : 131072*Y=177147*entry3.at t+260843 := localPath.book
  obtain ⟨yp,price,budget⟩ := rowThreePrices book
  have yo : Y%2=1 := by rw [← A2Header.physical_endpoint four.physical]; exact step_odd _
  exact maxTwosExit (compose (entry3History t).1 localPath) yp yo price budget

/-- Valuation four in E1 c=5. The remaining one exit has at most two
preceding twos. The original return, division and additive books are exact. -/
theorem bandFiveAtFour {t X Y : Nat} (head : Segment (entry5.at t) X 10 13 84217)
    (four : Segment X Y 1 4 1) :
    let N := originalSeed (10+128*t)
    Paid N ∨ ShortTwoRun N Y 77 121 (177147*originalCost 4 73+2^104*260843) 3 := by
  dsimp only
  have localPath := fourBook head four
  have book : 131072*Y=177147*entry5.at t+260843 := localPath.book
  obtain ⟨yp,price,budget⟩ := rowFivePrices book
  have yo : Y%2=1 := by rw [← A2Header.physical_endpoint four.physical]; exact step_odd _
  exact maxTwosExit (compose (entry5History t).1 localPath) yp yo price budget

end CollatzCharacterBridge.Front4bExitFour

#print axioms CollatzCharacterBridge.Front4bExitFour.maxTwosExit
#print axioms CollatzCharacterBridge.Front4bExitFour.bandThreeAtFour
#print axioms CollatzCharacterBridge.Front4bExitFour.bandFiveAtFour
