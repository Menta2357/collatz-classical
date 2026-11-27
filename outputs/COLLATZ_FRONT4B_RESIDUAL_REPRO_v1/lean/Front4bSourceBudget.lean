import Front4bAperiodicCapture

namespace CollatzCharacterBridge.Front4bSourceBudget

open FixedSourceRun (Ones ones_balanced)
open StagedCylinder (Segment compose)
open Front4bSwitchedRealization (Trace)

private theorem cancelOddFactor {a x r : Nat} (odd : a%2=1)
    (multiple : 2^r ∣ a*x) : 2^r ∣ x := by
  induction r generalizing x with
  | zero => simp
  | succ r ih =>
    obtain ⟨q,hq⟩ := multiple
    have even : x%2=0 := by
      have mul := congrArg (·%2) hq
      rw [Nat.pow_succ,show 2^r*2*q=2*(2^r*q) by ac_rfl] at mul
      simpa [Nat.mul_mod a x,odd] using mul
    have split : x=2*(x/2) := by omega
    have smaller : a*(x/2)=2^r*q := by
      apply Nat.mul_left_cancel (show 0<2 by decide)
      calc
        _ = a*(2*(x/2)) := by ac_rfl
        _ = a*x := congrArg (fun y => a*y) split.symm
        _ = _ := by rw [hq,Nat.pow_succ]; ac_rfl
    have ⟨z,hz⟩ := ih ⟨q,smaller⟩
    refine ⟨z,?_⟩
    calc
      x = 2*(x/2) := split
      _ = _ := by rw [hz,Nat.pow_succ]; ac_rfl

/-- An all-one run contributes at most the square of its shifted entry.
The usable dyadic reserve belongs to its actual entry, at any run length. -/
theorem onesHeight {x h : Nat} (ones : Ones x h) :
    orbit x h+1 ≤ (x+1)^2 := by
  have book := ones_balanced x h ones
  have multiple : 2^h ∣ 3^h*(x+1) := ⟨orbit x h+1, book.symm⟩
  have reserve : 2^h∣x+1 := cancelOddFactor (by simp [Nat.pow_mod]) multiple
  have budget : 2^h≤x+1 := Nat.le_of_dvd (by omega) reserve
  have p : (3:Nat)^h ≤ 2^h*2^h := by
    have h' := Nat.pow_le_pow_left (show (3:Nat)≤2*2 by decide) h
    simpa only [Nat.mul_pow] using h'
  apply Nat.le_of_mul_le_mul_left _ (Nat.pow_pos (by decide) : 0<(2:Nat)^h)
  calc
    _ = 3^h*(x+1) := book
    _ ≤ (2^h*2^h)*(x+1) := Nat.mul_le_mul_right _ p
    _ ≤ 2^h*((x+1)^2) := by
      rw [Nat.pow_succ,Nat.pow_one,←Nat.mul_assoc]
      exact Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ budget)

private theorem breakHeight {y z a : Nat} (breaking : 2≤a)
    (edge : Segment y z 1 a 1) : z+1≤y+1 := by
  have h₂ : (4:Nat)≤2^a := Nat.pow_le_pow_right (show 0<(2:Nat) by decide) breaking
  have h₄ : 4*z ≤ 3*y+1 := by
    simpa [Nat.pow_one,edge.book] using Nat.mul_le_mul_right z h₂
  omega

/-- A source history with its exact number of non-one valuations, separated from
the two physical clocks and the additive. The final run of ones can be empty. -/
inductive SourceBook : Nat → Nat → Nat → Nat → Nat → Nat → Prop where
  | ones {x y r C : Nat} (run : Ones x r) (history : Segment x y r r C) :
      SourceBook 0 x y r r C
  | breaking {x y z X h r a j s C B : Nat}
      (run : Ones x r) (history : Segment x y r r C)
      (big : 2≤a) (edge : Segment y z 1 a 1) (tail : SourceBook h z X j s B) :
      SourceBook (h+1) x X (r+1+j) (r+a+s)
        (3^j*(3*C+2^r)+2^(r+a)*B)

theorem sourceSegment {h x y j s C : Nat} (source : SourceBook h x y j s C) :
    Segment x y j s C := by
  induction source with
  | ones _ history => exact history
  | breaking _ history _ edge _ ih =>
    simpa only [Nat.pow_one,Nat.mul_one] using compose (compose history edge) ih

/-- This bounds all source shapes of bounded non-one count even if the positions
and magnitudes of those valuations are allowed to vary with the endpoint. -/
theorem sourceHeight {h x y j s C : Nat} (source : SourceBook h x y j s C) :
    y+1≤(x+1)^(2^(h+1)) := by
  induction source with
  | ones run history =>
    rw [← A2Header.physical_endpoint history.physical]
    exact onesHeight run
  | @breaking x y z X h r a j s C B run history big edge _ ih =>
    have runBound : y+1≤(x+1)^2 := by
      rw [←A2Header.physical_endpoint history.physical]
      exact onesHeight run
    have bound := Nat.pow_le_pow_left (Nat.le_trans (breakHeight big edge) runBound) (2^(h+1))
    calc
      _ ≤ ((x+1)^2)^(2^(h+1)) := Nat.le_trans ih bound
      _ = _ := by rw [←Nat.pow_mul,Nat.pow_succ 2 (h+1),Nat.mul_comm (2^(h+1)) 2]

/-- A late paid meeting must pay this price in number of non-one valuations.
Both original arithmetic and physical histories and the independent source book
are returned with no change to the original seed. -/
theorem historicalPrice {N J L q X m d C j S B h w r s A : Nat}
    {xs : List (Nat × Nat)} (history : Segment N J j S B) (seedHeight : N≤J)
    (weak : Trace J L q xs X m d C) (price : w<N)
    (source : SourceBook h w X r s A) :
    Segment N X (j+m) (S+d) (3^m*B+2^S*C) ∧ Segment w X r s A ∧
      81^xs.length*(J+1) ≤ 64^xs.length*N^(2^(h+1)) ∧
      81^xs.length ≤ 64^xs.length*N^(2^(h+1)-1) := by
  have coins : X+1≤N^(2^(h+1)) :=
    Nat.le_trans (sourceHeight source) (Nat.pow_le_pow_left (by omega) _)
  have bound := Nat.le_trans (Front4bWeakPriceExit.gainOfTrace weak) (Nat.mul_le_mul_left _ coins)
  refine ⟨compose history (Front4bSwitchedRealization.physical weak).1, sourceSegment source,
    bound, ?_⟩
  have exponent : 2^(h+1)-1+1 = (2:Nat)^(h+1) := by
    have positive : 0 < (2:Nat)^(h+1) := Nat.pow_pos (by decide)
    omega
  apply Nat.le_of_mul_le_mul_right _ (show 0<N by omega)
  calc
    _ ≤ 81^xs.length*(J+1) := Nat.mul_le_mul_left _ (by omega)
    _ ≤ 64^xs.length*N^(2^(h+1)) := bound
    _ = 64^xs.length*N^(2^(h+1)-1+1) :=
      congrArg (fun e => 64^xs.length*N^e) exponent.symm
    _ = _ := by rw [Nat.pow_succ,←Nat.mul_assoc]

end CollatzCharacterBridge.Front4bSourceBudget

#print axioms CollatzCharacterBridge.Front4bSourceBudget.onesHeight
#print axioms CollatzCharacterBridge.Front4bSourceBudget.sourceSegment
#print axioms CollatzCharacterBridge.Front4bSourceBudget.sourceHeight
#print axioms CollatzCharacterBridge.Front4bSourceBudget.historicalPrice
