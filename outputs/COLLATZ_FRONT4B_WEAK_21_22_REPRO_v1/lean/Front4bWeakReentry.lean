import Front4bWeakCofactor
import Front4bWeakRank

namespace CollatzCharacterBridge.Front4bWeakReentry

open StagedCylinder (Segment)
open Front4bWeakRank (WeakRank weakCost)
open Front4bWeakBudget (WeakBook)
open Front4bWeakCofactor (rankOfReadmission readmissionEquation)

theorem weakBookOfRank {J L b : Nat} (rank : WeakRank J L b) :
    WeakBook J (orbit J (L+2)) L b := by
  have eq : weakCost L=3^(L+2)-2^(L+1) := by
    have p : 2^L≤3^L := Nat.pow_le_pow_left (by decide) _
    unfold weakCost
    rw [Nat.pow_add 2 L 2,Nat.pow_add 3 L 2,Nat.pow_succ 2 L]
    change 3*(3*(3^L-2^L)+2^L)+2^L*4=3^L*9-2^L*2
    omega
  unfold WeakBook
  rw [←eq]
  exact rank.history

/-- A physical successor in the same one-run/weak-pair domain can reuse
the cofactor ranking rule with its composed history from N. -/
theorem restart {N J j S C L b H q v : Nat}
    (length : 2≤L) (newLength : 2≤H) (branch : b=1 ∨ b=2)
    (qOdd : q%2=1) (vOdd : v%2=1)
    (history : Segment N J j S C) (rank : WeakRank J L b)
    (initial : J+1=2^(L+1)*q) (next : orbit J (L+2)+1=2^(H+1)*v) :
    (v<q ↔ 3^(L+2)<2^(H+b+2)) ∧ v%2=1 ∧
      Segment N (orbit J (L+2)) (j+(L+2)) (S+(L+2+b))
        (3^(L+2)*C+2^S*(3^(L+2)-2^(L+1))) := by
  have result := rankOfReadmission length newLength branch (by omega : 0<q)
    history (weakBookOfRank rank) initial next
  exact ⟨result.1,vOdd,result.2⟩

/-- A next run of exactly two ones has the opposite cofactor behavior.
In this case the bound cannot act as an unconditional rank function. -/
theorem growsAtTwo {J L b q v : Nat} (length : 2≤L)
    (branch : b=1 ∨ b=2) (qPos : 0<q) (rank : WeakRank J L b)
    (initial : J+1=2^(L+1)*q) (next : orbit J (L+2)+1=8*v) : q<v := by
  have exp : 2^(2+b+2)≤64 := by rcases branch with rfl | rfl <;> decide
  have least : 81≤3^(L+2) := Nat.pow_le_pow_right (by decide : 0<3) (by omega : 4≤L+2)
  have strict : 2^(2+b+2)<3^(L+2) := by omega
  have eq := readmissionEquation (H:=2) (weakBookOfRank rank) initial next
  by_cases wrong : v≤q
  · have bad : 2^(2+b+2)*v<3^(L+2)*q :=
      Nat.lt_of_le_of_lt (Nat.mul_le_mul_left _ wrong) (Nat.mul_lt_mul_of_pos_right strict qPos)
    omega
  · omega

end CollatzCharacterBridge.Front4bWeakReentry

#print axioms CollatzCharacterBridge.Front4bWeakReentry.weakBookOfRank
#print axioms CollatzCharacterBridge.Front4bWeakReentry.restart
#print axioms CollatzCharacterBridge.Front4bWeakReentry.growsAtTwo
