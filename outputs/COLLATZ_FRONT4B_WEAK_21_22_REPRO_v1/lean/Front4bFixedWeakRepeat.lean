import Front4bWeakReentry

namespace CollatzCharacterBridge.Front4bFixedWeakRepeat

open StagedCylinder (Segment compose)
open Front4bWeakRank (WeakRank)
open Front4bWeakReentry (weakBookOfRank)
open Front4bWeakCofactor (readmissionEquation)

set_option maxRecDepth 12000
set_option maxHeartbeats 1200000

def divisions (b : Nat) : Nat := 2^(4+b)
def shift (b : Nat) : Nat := 2^(b+1)-1

/-- This positive quantity loses one factor of divisions b for each
fixed episode, despite the cofactor itself increasing. -/
def reserve (b q : Nat) : Nat := (81-divisions b)*q+shift b

private theorem cancellation {u q k : Nat} (odd : u%2=1) (multiple : 2^k∣u*q) :
    2^k∣q := by
  induction k generalizing q with
  | zero => simp
  | succ k ih =>
    obtain ⟨v,eq⟩ := multiple
    rw [Nat.pow_succ,show (2:Nat)^k*2*v=2*(2^k*v) by ac_rfl] at eq
    have parity := congrArg (fun x : Nat => x%2) eq
    change (u*q)%2=(2*(2^k*v))%2 at parity
    rw [Nat.mul_mod u q 2,odd] at parity
    simp at parity
    have half : q=2*(q/2) := by omega
    have next : u*(q/2)=2^k*v := by
      apply Nat.eq_of_mul_eq_mul_left (by decide : 0<2)
      calc
        _ = u*(2*(q/2)) := by ac_rfl
        _ = _ := by rw [←half]; exact eq
    obtain ⟨w,hw⟩ := ih ⟨v,next⟩
    refine ⟨w,?_⟩
    calc
      q = 2*(q/2) := half
      _ = 2*(2^k*w) := by rw [hw]
      _ = 2^(k+1)*w := by rw [Nat.pow_succ]; ac_rfl

private theorem affineReserve {b q v : Nat} (branch : b=1 ∨ b=2)
    (invoice : divisions b*v=81*q+shift b) :
    divisions b*reserve b v=81*reserve b q := by
  rcases branch with rfl | rfl
  · change (32:Nat)*v=81*q+3 at invoice
    change (32:Nat)*(49*v+3)=81*(49*q+3)
    omega
  · change (64:Nat)*v=81*q+7 at invoice
    change (64:Nat)*(17*v+7)=81*(17*q+7)
    omega

/-- The divisibility resource is consumed by every repeat of the same
weak pair with a prior one-run of length exactly two. -/
theorem repeatedDivisibility {b n : Nat} (branch : b=1 ∨ b=2) (q : Nat → Nat)
    (invoices : ∀ i<n, divisions b*q (i+1)=81*q i+shift b) :
    2^((4+b)*n)∣reserve b (q 0) := by
  have telescope : (divisions b)^n*reserve b (q n)=81^n*reserve b (q 0) := by
    induction n with
    | zero => simp
    | succ n ih =>
      have pay := affineReserve branch (invoices n (by omega))
      have earlier := ih (fun i hi => invoices i (by omega))
      calc
        _ = (divisions b)^n*(divisions b*reserve b (q (n+1))) := by rw [Nat.pow_succ,Nat.mul_assoc]
        _ = (divisions b)^n*(81*reserve b (q n)) := by rw [pay]
        _ = 81*((divisions b)^n*reserve b (q n)) := by ac_rfl
        _ = _ := by rw [earlier,Nat.pow_succ]; ac_rfl
  have odd (m : Nat) : (81:Nat)^m%2=1 := by
    induction m with
    | zero => decide
    | succ m ih => rw [Nat.pow_succ,Nat.mul_mod,ih]
  apply cancellation (odd n)
  refine ⟨reserve b (q n),?_⟩
  rw [Nat.pow_mul]
  exact telescope.symm

def historyCost (b S C : Nat) : Nat → Nat
  | 0 => C
  | i+1 => 81*historyCost b S C i+2^(S+(4+b)*i)*73

/-- Each fixed repeat consumes (4+b) divisibility units from the
initial reserve. This bounds the run for the particular seed, and the
composed certificate still refers to the original physical N. -/
theorem fixedPhysicalRepeat {N j S C b n : Nat} (branch : b=1 ∨ b=2) (J q : Nat → Nat)
    (origin : Segment N (J 0) j S C)
    (entries : ∀ i≤n, J i+1=8*q i)
    (edges : ∀ i<n, WeakRank (J i) 2 b ∧ orbit (J i) 4=J (i+1)) :
    2^((4+b)*n)∣reserve b (q 0) ∧
      2^((4+b)*n)≤reserve b (q 0) ∧
      Segment N (J n) (j+4*n) (S+(4+b)*n) (historyCost b S C n) := by
  have pieces (i : Nat) (hi : i<n) : Segment (J i) (J (i+1)) 4 (4+b) 73 := by
    obtain ⟨w,atNext⟩ := edges i hi
    have localBook := weakBookOfRank w
    rw [atNext] at localBook
    exact localBook
  have invoice (i : Nat) (hi : i<n) : divisions b*q (i+1)=81*q i+shift b := by
    have localBook : Front4bWeakBudget.WeakBook (J i) (J (i+1)) 2 b := pieces i hi
    have localCost := readmissionEquation localBook (H:=2)
      (entries i (by omega)) (entries (i+1) (by omega))
    have exponent : 2+b+2=4+b := by omega
    rw [exponent] at localCost
    exact localCost
  have divides := repeatedDivisibility branch q invoice
  have positive : 0<reserve b (q 0) := by
    rcases branch with rfl | rfl
    · change 0<49*q 0+3; omega
    · change 0<17*q 0+7; omega
  refine ⟨divides,Nat.le_of_dvd positive divides,?_⟩
  have carry (i : Nat) (bound : i≤n) :
      Segment N (J i) (j+4*i) (S+(4+b)*i) (historyCost b S C i) := by
    induction i with
    | zero => simpa [historyCost] using origin
    | succ i ih =>
      have extended := compose (ih (by omega)) (pieces i (by omega))
      rw [show j+4*(i+1)=j+4*i+4 by omega,
          show S+(4+b)*(i+1)=S+(4+b)*i+(4+b) by rw [Nat.mul_succ]; omega]
      exact extended
  exact carry n (Nat.le_refl _)

end CollatzCharacterBridge.Front4bFixedWeakRepeat

#print axioms CollatzCharacterBridge.Front4bFixedWeakRepeat.repeatedDivisibility
#print axioms CollatzCharacterBridge.Front4bFixedWeakRepeat.fixedPhysicalRepeat
