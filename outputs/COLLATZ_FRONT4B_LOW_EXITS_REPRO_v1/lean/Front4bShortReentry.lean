import Front4bShortExit
import Front4bWeakReentry

namespace CollatzCharacterBridge.Front4bShortReentry

open StagedCylinder (Segment compose)
open FixedSourceRun (Ones ones_prefix)
open Front4bWeakBudget (WeakBook)
open Front4bWeakRank (WeakRank weakRank weakCost)

set_option maxRecDepth 14000
set_option maxHeartbeats 1600000

structure ExactOnes (J H q : Nat) : Prop where
  factor : J+1=2^(H+1)*q
  oddCofactor : q%2=1
  run : Ones J H
  maximal : ¬ Ones J (H+1)

/-- An odd cofactor fixes the maximal initial one-run, including the
case of no ones. -/
theorem ofFactor {J H q : Nat} (factor : J+1=2^(H+1)*q) (qo : q%2=1) :
    ExactOnes J H q := by
  have shape : J=2^(H+1)*q-1 := by omega
  have qp : 0<q := by omega
  have even : (2^(H+1)*q)%2=0 := by
    rw [Nat.pow_succ,show (2:Nat)^H*2*q=2*(2^H*q) by ac_rfl]
    omega
  have jo : J%2=1 := by omega
  obtain ⟨ending,run⟩ := ones_prefix H q qp
  rw [←shape] at ending run
  refine ⟨factor,qo,run,?_⟩
  intro longer
  have next := longer H (by omega)
  rw [ending,Nat.mul_assoc 2] at next
  have target : (orbit J (H+1))%2=1 := orbit_odd J jo _
  have threeOdd (k : Nat) : (3:Nat)^k%2=1 := by
    induction k with
    | zero => decide
    | succ k ih => rw [Nat.pow_succ,Nat.mul_mod,ih]
  have prodOdd : (3^H*q)%2=1 := by rw [Nat.mul_mod,threeOdd,qo]
  have positive : 0<3^H*q := Nat.mul_pos (Nat.pow_pos (by decide)) qp
  omega

/-- The fixed two physical blocks have their original local book. -/
theorem twoBlockBook {J Z X : Nat}
    (first : WeakBook J Z 3 2) (second : WeakBook Z X 3 1) :
    Segment J X 10 13 84217 :=
  compose first second

private theorem rankOfInvoice {H base A C Q q : Nat} (positive : 0<Q)
    (smaller : 2^(5+base)<A) (larger : A+C<2^(6+base))
    (invoice : 2^(H+base)*q=A*Q+C) :
    (q<Q ↔ 6≤H) ∧ (Q<q ↔ H≤5) := by
  have down (long : 6≤H) : q<Q := by
    have low : (2:Nat)^(6+base)≤2^(H+base) :=
      Nat.pow_le_pow_right (by decide) (by omega)
    have rising := Nat.mul_lt_mul_of_pos_right larger positive
    have sum : A*Q+C≤(A+C)*Q := by
      rw [Nat.add_mul]
      exact Nat.add_le_add_left
        (by simpa only [Nat.mul_one] using Nat.mul_le_mul_left C (show 1≤Q by omega)) _
    by_cases good : q<Q
    · exact good
    · have pay : 2^(6+base)*Q≤2^(H+base)*q := Nat.mul_le_mul low (by omega)
      omega
  have up (short : H≤5) : Q<q := by
    have top : (2:Nat)^(H+base)≤2^(5+base) :=
      Nat.pow_le_pow_right (by decide) (by omega)
    have rising := Nat.mul_lt_mul_of_pos_right smaller positive
    by_cases good : Q<q
    · exact good
    · have pay : 2^(H+base)*q≤2^(5+base)*Q := Nat.mul_le_mul top (by omega)
      omega
  exact ⟨⟨fun h => by by_cases yes : 6≤H; exact yes; have bad := up (by omega); omega,down⟩,
    ⟨fun h => by by_cases yes : H≤5; exact yes; have bad := down (by omega); omega,up⟩⟩

private theorem hasFirstOne {X Y : Nat} (edge : Segment X Y 1 1 1) : Ones X 1 := by
  intro i hi
  have first : i=0 := by omega
  subst i
  change 3*X+1=2*orbit X 1
  rw [A2Header.physical_endpoint edge.physical]
  exact edge.book.symm

/-- When the observed next valuation is one, use the actual beginning of
the run at X as the reentry cut. Passing six ones strictly decreases the
old length-three cofactor, although the physical height has increased. -/
theorem reentryAfterOne {N J X Y j S B Q H q : Nat}
    (history : Segment N J j S B) (seedPhase : J+1=16*Q) (Qodd : Q%2=1)
    (twoBlocks : Segment J X 10 13 84217) (edge : Segment X Y 1 1 1)
    (ending : X+1=2^(H+1)*q) (qOdd : q%2=1) :
    ExactOnes X H q ∧ 1≤H ∧ J<X ∧
      (q<Q ↔ 6≤H) ∧ (Q<q ↔ H≤5) ∧
      Segment N X (j+10) (S+13) (59049*B+2^S*84217) ∧
      Segment N Y (j+11) (S+14) (177147*B+2^S*260843) := by
  have exact := ofFactor ending qOdd
  have observed := hasFirstOne edge
  have long : 1≤H := by
    by_cases empty : H=0
    · subst H
      exact False.elim (exact.maximal observed)
    · omega
  have book := twoBlocks.book
  change 8192*X=59049*J+84217 at book
  have equation : 512*(X+1)=59049*Q+2085 := by omega
  have invoice : 2^(H+10)*q=59049*Q+2085 := by
    rw [←equation,ending,show H+10=9+(H+1) by omega,Nat.pow_add,Nat.mul_assoc]
  obtain ⟨down,up⟩ := rankOfInvoice (base:=10) (by omega : 0<Q) (by decide) (by decide) invoice
  have suffix : Segment J Y 11 14 260843 := compose twoBlocks edge
  exact ⟨exact,long,by omega,down,up,compose history twoBlocks,compose history suffix⟩

/-- With observed valuation two there are no ones at X. Reentry, if it
occurs, is at the next odd point Y. The same six-ones guard gives a
strictly smaller odd cofactor. The local contraction does not cross J. -/
theorem reentryAfterTwo {N J X Y j S B Q H q : Nat}
    (history : Segment N J j S B) (seedPhase : J+1=16*Q) (Qodd : Q%2=1)
    (twoBlocks : Segment J X 10 13 84217) (edge : Segment X Y 1 2 1)
    (ending : Y+1=2^(H+1)*q) (qOdd : q%2=1) :
    (¬ Ones X 1) ∧ ExactOnes Y H q ∧ J<Y ∧ Y<X ∧
      (q<Q ↔ 6≤H) ∧ (Q<q ↔ H≤5) ∧
      Segment N Y (j+11) (S+15) (177147*B+2^S*260843) := by
  have after := edge.book
  change 4*Y=3*X+1 at after
  have zero : ¬ Ones X 1 := by
    intro h
    have one := h 0 (by decide)
    change 3*X+1=2*orbit X 1 at one
    rw [A2Header.physical_endpoint edge.physical] at one
    omega
  have suffix : Segment J Y 11 15 260843 := compose twoBlocks edge
  have book := suffix.book
  change 32768*Y=177147*J+260843 at book
  have equation : 2048*(Y+1)=177147*Q+7279 := by omega
  have invoice : 2^(H+12)*q=177147*Q+7279 := by
    rw [←equation,ending,show H+12=11+(H+1) by omega,Nat.pow_add,Nat.mul_assoc]
  obtain ⟨down,up⟩ := rankOfInvoice (base:=12) (by omega : 0<Q) (by decide) (by decide) invoice
  exact ⟨zero,ofFactor ending qOdd,by omega,by omega,down,up,compose history suffix⟩

/-- Exact eligibility becomes a genuine weak episode when its next two
physical factors are the required weak pair. The original book is retained. -/
theorem actualWeakReadmission {N X H q j S B b : Nat}
    (history : Segment N X j S B) (entry : ExactOnes X H q) (enough : 2≤H)
    (weak : b=1 ∨ b=2)
    (rupture : 3*orbit X H+1=4*orbit X (H+1))
    (tail : 3*orbit X (H+1)+1=2^b*orbit X (H+2)) :
    WeakRank X H b ∧
      Segment N (orbit X (H+2)) (j+(H+2)) (S+(H+2+b)) (3^(H+2)*B+2^S*weakCost H) := by
  have odd : X%2=1 := by
    have factor := entry.factor
    rw [Nat.pow_succ,show (2:Nat)^H*2*q=2*(2^H*q) by ac_rfl] at factor
    omega
  have rank := weakRank odd enough weak entry.run rupture tail
  exact ⟨rank,compose history rank.history⟩

end CollatzCharacterBridge.Front4bShortReentry

#print axioms CollatzCharacterBridge.Front4bShortReentry.ofFactor
#print axioms CollatzCharacterBridge.Front4bShortReentry.twoBlockBook
#print axioms CollatzCharacterBridge.Front4bShortReentry.reentryAfterOne
#print axioms CollatzCharacterBridge.Front4bShortReentry.reentryAfterTwo
#print axioms CollatzCharacterBridge.Front4bShortReentry.actualWeakReadmission
