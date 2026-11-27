import Front4bGuardRun
import A2LongDosePhysicalWordBridge

namespace CollatzCharacterBridge.Front4bWeakBudget

open StagedCylinder (Segment compose)
open A2CertifiedLanding (Descended)
open Front4bRowEven (originalSeed originalSeedFormula)
open P5CompensationMeetings (Affine)
open TwosCompression (Twos power_conversion)

set_option maxRecDepth 16000
set_option maxHeartbeats 1600000

/-- The physical prefix from the beginning of the run of ones through
the exact rupture (2,b), for b in {1,2}. -/
abbrev WeakBook (J Z L b : Nat) : Prop :=
  Segment J Z (L+2) (L+2+b) (3^(L+2)-2^(L+1))

private theorem conserved {J Z L b : Nat} (weak : WeakBook J Z L b) :
    2^(L+2+b)*Z+2^(L+1)=3^(L+2)*(J+1) := by
  have capacity : 2^(L+1)≤3^(L+2) :=
    Nat.le_trans (Nat.pow_le_pow_left (by decide : 2≤3) (L+1))
      (Nat.pow_le_pow_right (by decide : 0<3) (by omega : L+1≤L+2))
  have eq := weak.2
  rw [eq,Nat.mul_add,Nat.mul_one,Nat.add_assoc,Nat.sub_add_cancel capacity]

private theorem terminalBounds {N J Z L b : Nat} (height : J+1≤3*N)
    (weak : WeakBook J Z L b) : 2^(L+2+b)*Z≤27*3^L*N := by
  have eq := conserved weak
  calc
    _ ≤ 3^(L+2)*(J+1) := by rw [← eq]; exact Nat.le_add_right _ _
    _ ≤ 3^(L+2)*(3*N) := Nat.mul_le_mul_left _ height
    _ = (9*3)*(3^L*N) := by rw [Nat.pow_add 3 L 2]; change (3^L*9)*(3*N)=_; ac_rfl
    _ = 27*3^L*N := by rw [show 9*3=27 by decide,Nat.mul_assoc]

private theorem highComparison (k : Nat) : 108*3^(k+2)<2^(2*(k+2)+6) := by
  induction k with
  | zero => decide
  | succ k ih =>
    have e : 2*(k+1+2)+6=(2*(k+2)+6)+2 := by omega
    change 108*3^(k+1+2)<2^(2*(k+1+2)+6)
    rw [e,Nat.pow_add 2 (2*(k+2)+6) 2,show k+1+2=k+2+1 by omega,Nat.pow_succ 3 (k+2)]
    change 108*(3^(k+2)*3)<2^(2*(k+2)+6)*4
    rw [←Nat.mul_assoc]
    omega

private theorem exactEdge {x a : Nat} (pos : 0<x) (odd : x%2=1) (strong : 1≤a)
    (factor : 3*x+1=2^a*step x) : Segment x (step x) 1 a 1 :=
  ⟨A2Header.Physical.edge pos odd (step_pos _) (step_odd _) strong factor,factor.symm⟩

/-- A single physical valuation can pay the historical run debt at either
weak exit. The cutoff scales with the actual length L. -/
theorem descentOfHighExit {N J Z j s C L b a : Nat} (length : 2≤L)
    (branch : b=1 ∨ b=2) (height : J+1≤3*N) (zPos : 0<Z) (zOdd : Z%2=1)
    (hist : Segment N J j s C) (weak : WeakBook J Z L b)
    (large : L+4≤a+b) (factor : 3*Z+1=2^a*step Z) :
    Descended N := by
  let P := 2^(L+2+b)
  have hCut : 108*3^L<2^(2*L+6) := by
    obtain ⟨k,rfl⟩ : ∃ k, L=k+2 := ⟨L-2,by omega⟩
    exact highComparison k
  have nPos : 0<N := by omega
  have exponent : 2*L+6≤a+(L+2+b) := by omega
  have scale : 2^(2*L+6)≤2^a*P := by
    rw [← Nat.pow_add]; exact Nat.pow_le_pow_right (by decide) exponent
  have bounded : (P*2^a)*step Z < (P*2^a)*N := by
    calc
      _ = P*(3*Z+1) := by rw [Nat.mul_assoc,←factor]
      _ ≤ P*(4*Z) := Nat.mul_le_mul_left _ (by omega)
      _ = 4*(P*Z) := by ac_rfl
      _ ≤ 4*(27*3^L*N) := Nat.mul_le_mul_left _ (terminalBounds height weak)
      _ = (108*3^L)*N := by rw [← Nat.mul_assoc 4 (27*3^L),←Nat.mul_assoc 4 27]
      _ < 2^(2*L+6)*N := Nat.mul_lt_mul_of_pos_right hCut nPos
      _ ≤ _ := by rw [Nat.mul_comm P]; exact Nat.mul_le_mul_right _ scale
  have history := compose (compose hist weak) (exactEdge zPos zOdd (by omega : 1≤a) factor)
  exact ⟨step Z,_,_,_,step_pos _,step_odd _,Nat.lt_of_mul_lt_mul_left bounded,history⟩

private theorem longComparison (k : Nat) : (8*2187)*27^(k+2)<(7*2048)*32^(k+2) := by
  induction k with
  | zero => decide
  | succ k ih =>
    change (8*2187)*27^(k+1+2)<(7*2048)*32^(k+1+2)
    rw [show k+1+2=k+2+1 by omega,Nat.pow_succ 27 (k+2),Nat.pow_succ 32 (k+2)]
    simp only [←Nat.mul_assoc]
    omega

/-- The maximal run of twos need only reach this length. The exact
twos book is composed with the original one-run and weak exit. -/
theorem descentOfLongTwos {N J Z j s C L b : Nat} (length : 2≤L)
    (branch : b=1 ∨ b=2) (seed : 8≤N) (height : J+1≤3*N)
    (zPos : 0<Z) (zOdd : Z%2=1)
    (hist : Segment N J j s C) (weak : WeakBook J Z L b)
    (twos : Twos Z (2*L+4)) : Descended N := by
  let m := 2*L+4
  let P := 2^(L+2+b)
  let Y := orbit Z m
  have geometric : (8*2187)*27^L<(7*2048)*32^L := by
    obtain ⟨k,rfl⟩ : ∃ k, L=k+2 := ⟨L-2,by omega⟩
    exact longComparison k
  have powerScale : 2048*32^L ≤ P*4^m := by
    have pSmall : 2^(L+3)≤P := Nat.pow_le_pow_right (by decide) (by omega)
    apply Nat.le_trans ?_ (Nat.mul_le_mul_right (4^m) pSmall)
    apply Nat.le_of_eq
    unfold m
    rw [Nat.pow_add 2 L 3,Nat.pow_add 4 (2*L) 4,Nat.pow_mul 4 2 L]
    change 2048*32^L=2^L*8*(16^L*256)
    have pow : (32:Nat)^L=2^L*16^L := Nat.mul_pow 2 16 L
    rw [pow,show (2048:Nat)=8*256 by decide]
    ac_rfl
  have pay : 8*(3^m*Z)<8*(4^m*(N-1)) := by
    apply Nat.lt_of_mul_lt_mul_left (a:=P)
    calc
      _ = (8*3^m)*(P*Z) := by ac_rfl
      _ ≤ (8*3^m)*(27*3^L*N) := Nat.mul_le_mul_left _ (terminalBounds height weak)
      _ = ((8*2187)*27^L)*N := by
        unfold m
        rw [Nat.pow_add 3 (2*L) 4,Nat.pow_mul 3 2 L]
        change (8*(9^L*81))*(27*3^L*N)=((8*2187)*27^L)*N
        have pow : (27:Nat)^L=9^L*3^L := Nat.mul_pow 9 3 L
        rw [pow]
        rw [show 2187=81*27 by decide]
        ac_rfl
      _ < ((7*2048)*32^L)*N := Nat.mul_lt_mul_of_pos_right geometric (by omega)
      _ ≤ 7*(P*4^m)*N := by
        rw [Nat.mul_assoc 7 2048]
        exact Nat.mul_le_mul_right _ (Nat.mul_le_mul_left 7 powerScale)
      _ ≤ _ := by
        have compensation : 7*N≤8*(N-1) := by omega
        calc
          _ = (P*4^m)*(7*N) := by ac_rfl
          _ ≤ (P*4^m)*(8*(N-1)) := Nat.mul_le_mul_left _ compensation
          _ = _ := by ac_rfl
  have localBook := A2LongDosePhysicalWordBridge.twos_segment_of_word zPos zOdd twos
  have here : 4^m*Y=3^m*Z+(4^m-3^m) := by
    have h := localBook.2
    rw [power_conversion] at h
    exact h
  have small : 4^m*Y<4^m*N := by
    have left : 3^m*Z<4^m*(N-1) := Nat.lt_of_mul_lt_mul_left pay
    have shift : 4^m*(N-1)+4^m=4^m*N := by
      rw [← Nat.mul_succ]; congr 1; omega
    calc
      _ = 3^m*Z+(4^m-3^m) := here
      _ ≤ 3^m*Z+4^m := Nat.add_le_add_left (Nat.sub_le _ _) _
      _ < 4^m*(N-1)+4^m := Nat.add_lt_add_right left _
      _ = _ := shift
  exact ⟨Y,_,_,_,orbit_pos _ zPos _,orbit_odd _ zOdd _,Nat.lt_of_mul_lt_mul_left small,
    compose (compose hist weak) localBook⟩

/-- Both pinned E1 guards satisfy the same price and retain their
own exact historical starting clock and additive cost. -/
theorem guard3Budget (t : Nat) :
    ∃ j s C, Segment (originalSeed (18+32*t)) (Front4bGuardRun.entry3.at t) j s C ∧
      Front4bGuardRun.entry3.at t+1≤3*originalSeed (18+32*t) ∧ 8≤originalSeed (18+32*t) := by
  refine ⟨65,102,_,(Front4bGuardRun.entry3History t).1,?_,?_⟩
  all_goals
    simp only [Front4bGuardRun.entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega

theorem guard5Budget (t : Nat) :
    ∃ j s C, Segment (originalSeed (10+128*t)) (Front4bE1.entry5.at t) j s C ∧
      Front4bE1.entry5.at t+1≤3*originalSeed (10+128*t) ∧ 8≤originalSeed (10+128*t) := by
  obtain ⟨history,_,_,height⟩ := Front4bE1.entry5History t
  have base : 8≤originalSeed (10+128*t) := by rw [originalSeedFormula]; omega
  exact ⟨66,104,_,history,by omega,base⟩

end CollatzCharacterBridge.Front4bWeakBudget

#print axioms CollatzCharacterBridge.Front4bWeakBudget.descentOfHighExit
#print axioms CollatzCharacterBridge.Front4bWeakBudget.descentOfLongTwos
#print axioms CollatzCharacterBridge.Front4bWeakBudget.guard3Budget
#print axioms CollatzCharacterBridge.Front4bWeakBudget.guard5Budget
