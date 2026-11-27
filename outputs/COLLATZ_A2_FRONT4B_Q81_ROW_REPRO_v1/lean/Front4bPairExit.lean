import A2WeakBreakReserve
import A2CertifiedLanding

namespace CollatzCharacterBridge.Front4bPairExit

open A2CertifiedLanding (Descended)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

/-- Price the final return directly, leaving its physical valuation exact. -/
theorem descent_of_numerator_bound {N X j S B d : Nat}
    (history : Segment N X j S B) (Xpos : 0<X) (Xodd : X%2=1)
    (dpos : 1≤d) (factor : 3*X+1=2^d*step X)
    (margin : 3*X+1<2^d*N) :
    step X<N ∧ Segment N (step X) (j+1) (S+d) (3*B+2^S) ∧
      Descended N := by
  have compared : 2^d*step X<2^d*N := factor ▸ margin
  have smaller := Nat.lt_of_mul_lt_mul_left compared
  have extended := compose history (P5R3S5.step_segment X d Xpos Xodd dpos factor)
  simp only [Nat.pow_one,Nat.mul_one] at extended
  exact ⟨smaller,extended,step X,j+1,S+d,3*B+2^S,
    step_pos X,step_odd X,smaller,extended⟩

private theorem pair_height {F X m M : Nat} (h : m≤M)
    (pairs : Segment F X (2*m) (3*m) (5*(3^(2*m)-2^(3*m)))) :
    8^M*(X+5)≤9^M*(F+5) := by
  have ordered : (8:Nat)^m≤9^m := Nat.pow_le_pow_left (by decide) m
  have no_truncation : 5*(9^m-8^m)+5*8^m=5*9^m := by
    rw [←Nat.mul_add,Nat.sub_add_cancel ordered]
  have book : 8^m*X=9^m*F+5*(9^m-8^m) := by
    simpa only [Nat.pow_mul] using pairs.book
  have centered : 8^m*(X+5)=9^m*(F+5) := by
    calc
      _ = 8^m*X+5*8^m := by rw [Nat.mul_add,Nat.mul_comm (8^m) 5]
      _ = 9^m*F+5*9^m := by rw [book,Nat.add_assoc,no_truncation]
      _ = _ := by rw [Nat.mul_add,Nat.mul_comm (9^m) 5]
  let r := M-m
  have split : M=r+m := by dsimp only [r]; omega
  calc
    _ = 8^r*(8^m*(X+5)) := by rw [split,Nat.pow_add,Nat.mul_assoc]
    _ = 8^r*(9^m*(F+5)) := by rw [centered]
    _ ≤ 9^r*(9^m*(F+5)) :=
      Nat.mul_le_mul_right _ (Nat.pow_le_pow_left (by decide) r)
    _ = _ := by rw [split,Nat.pow_add,Nat.mul_assoc]

private theorem margin_at_cap {N F X m M D : Nat} (cap : m≤M)
    (pairs : Segment F X (2*m) (3*m) (5*(3^(2*m)-2^(3*m))))
    (table : 3*(9^M*(F+5))<8^M*(2^D*N+14)) :
    3*X+1<2^D*N := by
  apply Nat.lt_of_not_ge
  intro bad
  have shifted : 2^D*N+14≤3*(X+5) := by omega
  have multiplied := Nat.mul_le_mul_left (8^M) shifted
  have reassociate : 8^M*(3*(X+5))=3*(8^M*(X+5)) := by ac_rfl
  rw [reassociate] at multiplied
  have height := Nat.mul_le_mul_left 3 (pair_height cap pairs)
  exact (Nat.not_le_of_gt table) (Nat.le_trans multiplied height)

/-- Front4b direct exits of valuations at least two, three, or four,
    under the indicated caps on the number of completed pairs. The original
    book, including the actual final valuation, is retained. -/
theorem direct_exit_descends {N F X j S B m d : Nat}
    (large : 64≤N) (start : N<F) (window : 11*F<12*N)
    (Fodd : F%2=1) (history : Segment N F j S B)
    (pairs : Segment F X (2*m) (3*m) (5*(3^(2*m)-2^(3*m))))
    (factor : 3*X+1=2^d*step X)
    (gate : (m≤1 ∧ 2≤d) ∨ (m≤7 ∧ 3≤d) ∨ (m≤13 ∧ 4≤d)) :
    step X<N ∧ 2^d ∣ 3*X+1 ∧ ¬2^(d+1) ∣ 3*X+1 ∧
      Segment N (step X) (j+2*m+1) (S+3*m+d)
        (3*(3^(2*m)*B+2^S*(5*(3^(2*m)-2^(3*m))))+2^(S+3*m)) ∧
      Descended N := by
  have raise {D : Nat} (floor : D≤d) (small : 3*X+1<2^D*N) :
      3*X+1<2^d*N :=
    Nat.lt_of_lt_of_le small
      (Nat.mul_le_mul_right N (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) floor))
  have dpos : 1≤d := by omega
  have margin : 3*X+1<2^d*N := by
    rcases gate with ⟨cap,floor⟩ | ⟨cap,floor⟩ | ⟨cap,floor⟩
    · apply raise floor (margin_at_cap cap pairs ?_)
      rw [←Nat.mul_assoc]
      change 27*(F+5)<8*(4*N+14)
      omega
    · apply raise floor (margin_at_cap cap pairs ?_)
      rw [←Nat.mul_assoc]
      change 14348907*(F+5)<2097152*(8*N+14)
      omega
    · apply raise floor (margin_at_cap cap pairs ?_)
      rw [←Nat.mul_assoc]
      change 7625597484987*(F+5)<549755813888*(16*N+14)
      omega
  have endpoint := A2Header.physical_endpoint pairs.physical
  have Xpos : 0<X := endpoint ▸ orbit_pos F (by omega) (2*m)
  have Xodd : X%2=1 := endpoint ▸ orbit_odd F Fodd (2*m)
  obtain ⟨below,book,paid⟩ :=
    descent_of_numerator_bound (compose history pairs) Xpos Xodd dpos factor margin
  obtain ⟨divides,exactFloor⟩ := P5R3S5.exact_reserve (step_odd X) factor
  exact ⟨below,divides,exactFloor,book,paid⟩

end CollatzCharacterBridge.Front4bPairExit
