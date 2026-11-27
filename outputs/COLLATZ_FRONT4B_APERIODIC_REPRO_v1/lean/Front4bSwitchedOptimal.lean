import Front4bSwitchedEnvelope

namespace CollatzCharacterBridge.Front4bSwitchedOptimal

open Front4bWeakBudget (WeakBook)
open Front4bPeriodicWeakRepeat (WeakEpisode Follows periodReturns periodDivisions periodCost composePeriod)
open StagedCylinder (Segment compose)

set_option maxRecDepth 14000
set_option maxHeartbeats 1500000

def weight (J : Nat) : Nat := 17*J+73

/-- Any shift c/k valid for every weak episode must satisfy 17c≥73k. -/
theorem minimalRatio (k c : Nat) (all : ∀ L b : Nat, 2≤L → (b=1 ∨ b=2) →
    k*(3^(L+2)-2^(L+1))+c*2^(L+2+b)≤c*3^(L+2)) : 73*k≤17*c := by
  have boundary := all 2 2 (by decide) (Or.inr rfl)
  change k*73+c*64≤c*81 at boundary
  omega

private theorem marginAtLength (n : Nat) : 73*2^(n+6)≤56*3^(n+4)+17*2^(n+3) := by
  induction n with
  | zero => decide
  | succ n ih =>
    rw [show n+1+6=(n+6)+1 by omega,show n+1+4=(n+4)+1 by omega,
      show n+1+3=(n+3)+1 by omega,Nat.pow_succ 2 (n+6),Nat.pow_succ 3 (n+4),Nat.pow_succ 2 (n+3)]
    simp only [←Nat.mul_assoc 73,←Nat.mul_assoc 56,←Nat.mul_assoc 17]
    omega

theorem optimalAtEpisode {L b : Nat} (length : 2≤L) (branch : b=1 ∨ b=2) :
    17*(3^(L+2)-2^(L+1))+73*2^(L+2+b)≤73*3^(L+2) := by
  have cap : 2^(L+2+b)≤2^((L-2)+6) := Nat.pow_le_pow_right (by decide) (by omega)
  have margin := Nat.le_trans (Nat.mul_le_mul_left 73 cap) (marginAtLength (L-2))
  rw [show L-2+4=L+2 by omega,show L-2+3=L+1 by omega] at margin
  have addPos : 2^(L+1)≤3^(L+2) := Nat.le_trans (Nat.pow_le_pow_left (by decide) _)
    (Nat.pow_le_pow_right (by decide) (by omega : L+1≤L+2))
  have cost : 17*(3^(L+2)-2^(L+1))+17*2^(L+1)=17*3^(L+2) := by
    rw [←Nat.mul_add,Nat.sub_add_cancel addPos]
  omega

private theorem oneWord {L b X Y : Nat} (length : 2≤L) (branch : b=1 ∨ b=2)
    (word : WeakBook X Y L b) : 2^(L+2+b)*weight Y≤3^(L+2)*weight X := by
  have cap := optimalAtEpisode length branch
  calc
    _ = 17*(2^(L+2+b)*Y)+73*2^(L+2+b) := by unfold weight; rw [Nat.mul_add]; ac_rfl
    _ = 17*(3^(L+2)*X)+(17*(3^(L+2)-2^(L+1))+73*2^(L+2+b)) := by
      rw [word.book,Nat.mul_add,Nat.add_assoc]
    _ ≤ 17*(3^(L+2)*X)+73*3^(L+2) := Nat.add_le_add_left cap _
    _ = _ := by unfold weight; rw [Nat.mul_add]; ac_rfl

/-- Optimal shared height envelope for arbitrary physical switching. -/
theorem optimalForWord {p : List WeakEpisode} {X Y : Nat} (word : Follows X Y p) :
    2^periodDivisions p*weight Y≤3^periodReturns p*weight X := by
  induction p generalizing X Y with
  | nil => rw [show X=Y from word]; simp [periodDivisions,periodReturns]
  | cons episode rest ih =>
    rcases episode with ⟨L,b⟩
    obtain ⟨length,branch,Z,left,right⟩ := word
    have first := oneWord length branch left
    have last := ih right
    rw [periodDivisions,periodReturns,Nat.pow_add 2 (L+2+b),Nat.pow_add 3 (L+2)]
    calc
      _ = 2^(L+2+b)*(2^periodDivisions rest*weight Y) := by ac_rfl
      _ ≤ 2^(L+2+b)*(3^periodReturns rest*weight Z) := Nat.mul_le_mul_left _ last
      _ = 3^periodReturns rest*(2^(L+2+b)*weight Z) := by ac_rfl
      _ ≤ 3^periodReturns rest*(3^(L+2)*weight X) := Nat.mul_le_mul_left _ first
      _ = _ := by ac_rfl

/-- The new optimal bound measures the next cofactor against the full
ledger from N and separately returns the composed physical Segment. -/
theorem originalOptimalReentry {p : List WeakEpisode} {N J Z j S B H v : Nat}
    (origin : Segment N J j S B) (word : Follows J Z p) (factor : Z+1=2^(H+1)*v) :
    17*2^(S+periodDivisions p+H+1)*v<
      3^periodReturns p*(17*(3^j*N+B)+73*2^S) ∧
      Segment N Z (j+periodReturns p) (S+periodDivisions p)
        (3^periodReturns p*B+2^S*periodCost p) := by
  have high : 17*(Z+1)<weight Z := by unfold weight; omega
  have narrow := Nat.mul_lt_mul_of_pos_left high (Nat.pow_pos (by decide) : 0<2^periodDivisions p)
  rw [factor] at narrow
  have localBound := Nat.lt_of_lt_of_le narrow (optimalForWord word)
  have extended := Nat.mul_lt_mul_of_pos_left localBound (Nat.pow_pos (by decide) : 0<2^S)
  have origPrice : 2^S*weight J=17*(3^j*N+B)+73*2^S := by
    calc
      _ = 17*(2^S*J)+73*2^S := by unfold weight; rw [Nat.mul_add]; ac_rfl
      _ = _ := by rw [origin.book]
  have right : 2^S*(3^periodReturns p*weight J)=3^periodReturns p*(2^S*weight J) := by ac_rfl
  have left : 17*2^(S+periodDivisions p+H+1)*v=2^S*(2^periodDivisions p*(17*(2^(H+1)*v))) := by
    rw [show S+periodDivisions p+H+1=S+periodDivisions p+(H+1) by omega,
      Nat.pow_add 2 (S+periodDivisions p) (H+1),Nat.pow_add 2 S (periodDivisions p)]
    ac_rfl
  rw [←left,right,origPrice] at extended
  exact ⟨extended,compose origin (composePeriod word).1⟩

/-- At length two the two weak transitions have different exact charges. -/
theorem twoOneCharge {J Z : Nat} (path : WeakBook J Z 2 1) : 32*weight Z+2336=81*weight J := by
  have book := path.book
  change 32*Z=81*J+73 at book
  unfold weight
  omega

theorem twoTwoNoCharge {J Z : Nat} (path : WeakBook J Z 2 2) : 64*weight Z=81*weight J := by
  have book := path.book
  change 64*Z=81*J+73 at book
  unfold weight
  omega

/-- A length-two b=1 followed by another length-two entry can only
regenerate divisibility from a checkpoint with exact initial valuation five. -/
theorem twoOneResetPhase {J Z v : Nat} (path : WeakBook J Z 2 1)
    (next : Z+1=8*v) (vOdd : v%2=1) : weight J%64=32 := by
  have book := twoOneCharge path
  unfold weight at book ⊢
  omega

end CollatzCharacterBridge.Front4bSwitchedOptimal

#print axioms CollatzCharacterBridge.Front4bSwitchedOptimal.minimalRatio
#print axioms CollatzCharacterBridge.Front4bSwitchedOptimal.optimalAtEpisode
#print axioms CollatzCharacterBridge.Front4bSwitchedOptimal.optimalForWord
#print axioms CollatzCharacterBridge.Front4bSwitchedOptimal.originalOptimalReentry
#print axioms CollatzCharacterBridge.Front4bSwitchedOptimal.twoOneCharge
#print axioms CollatzCharacterBridge.Front4bSwitchedOptimal.twoTwoNoCharge
#print axioms CollatzCharacterBridge.Front4bSwitchedOptimal.twoOneResetPhase
