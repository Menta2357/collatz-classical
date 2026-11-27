import Front4bSwitchedRows
import Front4bWeakReentry

namespace CollatzCharacterBridge.Front4bTernarySwitch

open Front4bSwitchedRealization (Trace Transition)
open Front4bWeakCofactor (readmissionEquation)
open Front4bWeakReentry (weakBookOfRank)
open StagedCylinder (Segment compose)

private theorem powTwoModThree (k : Nat) : 2^k%3=1 ∨ 2^k%3=2 := by
  induction k with
  | zero => exact Or.inl rfl
  | succ k ih =>
    rw [Nat.pow_succ,Nat.mul_mod]
    omega

private theorem zeroPowThree {k : Nat} (pos : 1≤k) : 3^k%3=0 := by
  cases k with
  | zero => omega
  | succ k => rw [Nat.pow_succ,Nat.mul_mod]; simp

private theorem residue {M Q a c : Nat} (less : c<M)
    (book : a=M*Q+c) : a%M=c := by
  rw [book,Nat.add_mod,Nat.mul_mod]
  simp [Nat.mod_eq_of_lt less]

/-- A true (2,1) exit admits exactly one factor of three in the next
cofactor, and fixes its quotient at a larger ternary modulus. -/
theorem afterOne {J L q H Z v : Nat} (head : Transition J L q 1 H Z v) :
    v%3=0 ∧ (v/3)%3≠0 ∧ (2^(H+3)*(v/3))%3^(L+1)=1 := by
  have equation := readmissionEquation (weakBookOfRank head.path) head.entry
    (by rw [head.atNext]; exact head.nextEntry)
  change 2^(H+3)*v=3^(L+2)*q+3 at equation
  have modulo : (2^(H+3)*v)%3=0 :=
    residue (M:=3) (Q:=3^(L+1)*q+1) (c:=0) (by decide) (by
      rw [equation,Nat.pow_succ 3 (L+1),Nat.mul_add]
      simp only [Nat.add_zero,Nat.mul_one]
      ac_rfl)
  rw [Nat.mul_mod] at modulo
  have power := powTwoModThree (H+3)
  have div : v%3=0 := by
    rcases power with one | two
    · rw [one] at modulo
      omega
    · rw [two] at modulo
      omega
  have quot := show v=3*(v/3) by omega
  have reduced : 2^(H+3)*(v/3)=3^(L+1)*q+1 := by
    apply Nat.eq_of_mul_eq_mul_left (by decide : 0<3)
    calc
      _ = 2^(H+3)*(3*(v/3)) := by ac_rfl
      _ = 3^(L+2)*q+3 := by rw [←quot,equation]
      _ = _ := by rw [Nat.pow_succ 3 (L+1),Nat.mul_add,Nat.mul_one]; ac_rfl
  have one : (2^(H+3)*(v/3))%3=1 := by
    rw [reduced,Nat.add_mod,Nat.mul_mod,zeroPowThree (by omega : 1≤L+1)]
    simp
  have odd3 : (v/3)%3≠0 := by
    intro zero
    rw [Nat.mul_mod,zero] at one
    simp at one
  exact ⟨div,odd3,residue (Nat.pow_lt_pow_right (by decide) (by omega : 0<L+1)) reduced⟩

/-- A true (2,2) exit has no factor of three in its next cofactor. -/
theorem afterTwo {J L q H Z v : Nat} (head : Transition J L q 2 H Z v) :
    v%3≠0 ∧ (2^(H+4)*v)%3^(L+2)=7 := by
  have equation := readmissionEquation (weakBookOfRank head.path) head.entry
    (by rw [head.atNext]; exact head.nextEntry)
  change 2^(H+4)*v=3^(L+2)*q+7 at equation
  have one : (2^(H+4)*v)%3=1 := by
    rw [equation,Nat.add_mod,Nat.mul_mod,zeroPowThree (by omega : 1≤L+2)]
    simp
  have notDiv : v%3≠0 := by
    intro zero
    rw [Nat.mul_mod,zero] at one
    simp at one
  have large : 7<3^(L+2) := Nat.lt_of_lt_of_le (by decide : 7<9)
    (Nat.pow_le_pow_right (by decide : 0<(3:Nat)) (by omega : 2≤L+2))
  exact ⟨notDiv,residue large equation⟩

/-- The cofactor labels and the exact clock and cost are from the same
physical transition, with the original history retained. -/
theorem ternaryHistory {N J j S C L q b H Z v : Nat} (history : Segment N J j S C)
    (head : Transition J L q b H Z v) :
    (if b=1 then v%3=0 ∧ (v/3)%3≠0 else v%3≠0) ∧
    Segment N Z (j+(L+2)) (S+(L+2+b))
      (3^(L+2)*C+2^S*(3^(L+2)-2^(L+1))) := by
  have path := weakBookOfRank head.path
  rw [head.atNext] at path
  refine ⟨?_,compose history path⟩
  rcases head.weak with rfl | rfl
  · exact ⟨(afterOne head).1,(afterOne head).2.1⟩
  · exact (afterTwo head).1

/-- Two successive genuine weak blocks can drop the ternary label while
both physical cofactors grow. The first and second lengths are both two. -/
theorem changeCanGrow {J q X m d B : Nat}
    (trace : Trace J 2 q [(1,2),(2,2)] X m d B) :
    ∃ a v : Nat, q<a ∧ a<v ∧ a%3=0 ∧ (a/3)%3≠0 ∧ v%3≠0 ∧
      orbit J 4+1=8*a ∧ X+1=8*v := by
  cases trace with
  | extend first tail =>
    cases tail with
    | extend second ending =>
      cases ending with
      | stop =>
        exact ⟨_,_,first.growth (by decide),second.growth (by decide),
          (afterOne first).1,(afterOne first).2.1,(afterTwo second).1,
          by rw [first.atNext]; exact first.nextEntry,second.nextEntry⟩

end CollatzCharacterBridge.Front4bTernarySwitch

#print axioms CollatzCharacterBridge.Front4bTernarySwitch.afterOne
#print axioms CollatzCharacterBridge.Front4bTernarySwitch.afterTwo
#print axioms CollatzCharacterBridge.Front4bTernarySwitch.ternaryHistory
#print axioms CollatzCharacterBridge.Front4bTernarySwitch.changeCanGrow
