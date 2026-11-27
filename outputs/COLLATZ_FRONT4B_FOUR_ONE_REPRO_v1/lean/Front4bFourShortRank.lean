import Front4bExitFour
import Front4bShortReentry

namespace CollatzCharacterBridge.Front4bFourShortRank

open StagedCylinder (Segment compose)
open FixedSourceRun (Ones)
open Front4bShortReentry (ExactOnes ofFactor)

set_option maxRecDepth 14000
set_option maxHeartbeats 1600000

private theorem positiveOnes {U W H q : Nat} (run : ExactOnes U H q)
    (realOne : Segment U W 1 1 1) : 1≤H := by
  have one : Ones U 1 := by
    intro i hi
    have h : i=0 := by omega
    subst i
    change 3*U+1=2*orbit U 1
    rw [A2Header.physical_endpoint realOne.physical]
    exact realOne.book.symm
  by_cases empty : H=0
  · subst H
    exact False.elim (run.maximal one)
  · omega

private theorem rankFour {H base A C Q q : Nat} (positive : 0<Q)
    (smaller : 2^(3+base)<A) (larger : A+C<2^(4+base))
    (invoice : 2^(H+base)*q=A*Q+C) :
    (q<Q ↔ 4≤H) ∧ (Q<q ↔ H≤3) := by
  have down (long : 4≤H) : q<Q := by
    have ds : (2:Nat)^(4+base)≤2^(H+base) :=
      Nat.pow_le_pow_right (by decide) (by omega)
    have up := Nat.mul_lt_mul_of_pos_right larger positive
    have add : A*Q+C≤(A+C)*Q := by
      rw [Nat.add_mul]
      have w := Nat.mul_le_mul_left C (show 1≤Q by omega)
      simp only [Nat.mul_one] at w
      omega
    by_cases ok : q<Q
    · exact ok
    · have bad : 2^(4+base)*Q≤2^(H+base)*q := Nat.mul_le_mul ds (by omega)
      omega
  have up (short : H≤3) : Q<q := by
    have ds : (2:Nat)^(H+base)≤2^(3+base) :=
      Nat.pow_le_pow_right (by decide) (by omega)
    have lower := Nat.mul_lt_mul_of_pos_right smaller positive
    by_cases ok : Q<q
    · exact ok
    · have bad : 2^(H+base)*q≤2^(3+base)*Q := Nat.mul_le_mul ds (by omega)
      omega
  exact ⟨⟨fun h => by by_cases yes : 4≤H; exact yes; have bad := up (by omega); omega,down⟩,
    ⟨fun h => by by_cases yes : H≤3; exact yes; have bad := down (by omega); omega,up⟩⟩

structure Rated {N J U : Nat} (j S B Q H q r d C : Nat) : Prop where
  exactRun : ExactOnes U H q
  hasOnes : 1≤H
  height : J<U
  lower : q<Q ↔ 4≤H
  upper : Q<q ↔ H≤3
  history : Segment N U (j+r) (S+d) (3^r*B+2^S*C)

/-- No post-four twos. The real one ensures the phase at U is a
nonempty maximal one-run, before taking its first step. -/
theorem zeroDoseRank {N J X U W j S B Q H q : Nat}
    (origin : Segment N J j S B) (phase : J+1=16*Q) (odd : Q%2=1)
    (head : Segment J X 10 13 84217) (four : Segment X U 1 4 1)
    (one : Segment U W 1 1 1) (nextPhase : U+1=2^(H+1)*q) (nextOdd : q%2=1) :
    Rated (N:=N) (J:=J) (U:=U) j S B Q H q 11 17 260843 := by
  have full : Segment J U 11 17 260843 := compose head four
  have book := full.book
  change 131072*U=177147*J+260843 at book
  have eq : 8192*(U+1)=177147*Q+13423 := by omega
  have invoice : 2^(H+14)*q=177147*Q+13423 := by
    rw [←eq,nextPhase,show H+14=13+(H+1) by omega,Nat.pow_add,Nat.mul_assoc]
  obtain ⟨lower,upper⟩ := rankFour (base:=14) (by omega : 0<Q) (by decide) (by decide) invoice
  have run := ofFactor nextPhase nextOdd
  exact ⟨run,positiveOnes run one,by omega,lower,upper,compose origin full⟩

/-- Exactly one post-four dose, followed by a genuine one. Compare the
cofactor at U after the dose and before this new one-run. -/
theorem oneDoseRank {N J X Y U W j S B Q H q : Nat}
    (origin : Segment N J j S B) (phase : J+1=16*Q) (odd : Q%2=1)
    (head : Segment J X 10 13 84217) (four : Segment X Y 1 4 1)
    (dose : Segment Y U 1 2 1) (one : Segment U W 1 1 1)
    (nextPhase : U+1=2^(H+1)*q) (nextOdd : q%2=1) :
    Rated (N:=N) (J:=J) (U:=U) j S B Q H q 12 19 913601 := by
  have full : Segment J U 12 19 913601 := compose (compose head four) dose
  have book := full.book
  change 524288*U=531441*J+913601 at book
  have eq : 32768*(U+1)=531441*Q+56653 := by omega
  have invoice : 2^(H+16)*q=531441*Q+56653 := by
    rw [←eq,nextPhase,show H+16=15+(H+1) by omega,Nat.pow_add,Nat.mul_assoc]
  obtain ⟨lower,upper⟩ := rankFour (base:=16) (by omega : 0<Q) (by decide) (by decide) invoice
  have run := ofFactor nextPhase nextOdd
  exact ⟨run,positiveOnes run one,by omega,lower,upper,compose origin full⟩

/-- A decreasing numerical phase is a genuine weak readmission when the
two physical factors after its maximal one-run are (2,b). -/
theorem lowerWeak {N J U j S B Q H q r d C b : Nat}
    (rated : Rated (N:=N) (J:=J) (U:=U) j S B Q H q r d C)
    (long : 4≤H) (weak : b=1 ∨ b=2)
    (rupture : 3*orbit U H+1=4*orbit U (H+1))
    (tail : 3*orbit U (H+1)+1=2^b*orbit U (H+2)) :
    q<Q ∧ Front4bWeakRank.WeakRank U H b ∧
      Segment N (orbit U (H+2)) (j+r+(H+2)) (S+d+(H+2+b))
        (3^(H+2)*(3^r*B+2^S*C)+2^(S+d)*Front4bWeakRank.weakCost H) := by
  have next := Front4bShortReentry.actualWeakReadmission rated.history rated.exactRun
    (by omega) weak rupture tail
  exact ⟨rated.lower.mpr long,next⟩

end CollatzCharacterBridge.Front4bFourShortRank

#print axioms CollatzCharacterBridge.Front4bFourShortRank.zeroDoseRank
#print axioms CollatzCharacterBridge.Front4bFourShortRank.oneDoseRank
#print axioms CollatzCharacterBridge.Front4bFourShortRank.lowerWeak
