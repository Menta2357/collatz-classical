import Front4bSwitchedOptimal

namespace CollatzCharacterBridge.Front4bTernaryHeight

open Front4bSwitchedOptimal (weight optimalForWord)
open Front4bPeriodicWeakRepeat (WeakEpisode Follows periodReturns periodDivisions periodCost composePeriod)
open StagedCylinder (Segment compose)

/-- Once the exact division clock exceeds the entry height, the terminal
lies below the modulus of its own ternary congruence. The original
book is composed with the same physical word used for the congruence. -/
theorem belowTernaryModulus {p : List WeakEpisode} {N J X j S B : Nat}
    (original : Segment N J j S B) (word : Follows J X p)
    (clock : weight J≤17*2^periodDivisions p) :
    X<3^periodReturns p ∧
      (2^periodDivisions p*X)%3^periodReturns p=(periodCost p)%3^periodReturns p ∧
      Segment N X (j+periodReturns p) (S+periodDivisions p)
        (3^periodReturns p*B+2^S*periodCost p) := by
  have lt : 17*X<weight X := by simp [weight]
  have dp : 0<(2:Nat)^periodDivisions p := Nat.pow_pos (by decide)
  have bound : 2^periodDivisions p*(17*X)<2^periodDivisions p*(17*3^periodReturns p) := calc
    _ < 2^periodDivisions p*weight X := Nat.mul_lt_mul_of_pos_left lt dp
    _ ≤ 3^periodReturns p*weight J := optimalForWord word
    _ ≤ 3^periodReturns p*(17*2^periodDivisions p) := Nat.mul_le_mul_left _ clock
    _ = _ := by ac_rfl
  have small : X<(3:Nat)^periodReturns p :=
    Nat.lt_of_mul_lt_mul_left (Nat.lt_of_mul_lt_mul_left bound)
  have segment := (composePeriod word).1
  exact ⟨small,by simp [segment.book,Nat.add_mod],compose original segment⟩

end CollatzCharacterBridge.Front4bTernaryHeight

#print axioms CollatzCharacterBridge.Front4bTernaryHeight.belowTernaryModulus
