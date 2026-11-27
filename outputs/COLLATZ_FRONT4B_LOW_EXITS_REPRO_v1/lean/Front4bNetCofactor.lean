import Front4bSwitchedOptimal

namespace CollatzCharacterBridge.Front4bNetCofactor

open Front4bSwitchedOptimal (optimalForWord weight)
open Front4bWeakBudget (WeakBook)
open Front4bPeriodicWeakRepeat
  (WeakEpisode Follows periodReturns periodDivisions periodCost composePeriod)
open StagedCylinder (Segment compose)

set_option maxRecDepth 14000
set_option maxHeartbeats 1200000

/-- The original clocks and additive decide the sign of the net rank change
across any finite physical weak word. Intermediate cofactors may rise. -/
theorem exactRank {p : List WeakEpisode} {N J Z j S C L H q v : Nat}
    (original : Segment N J j S C) (word : Follows J Z p)
    (entry : J+1=2^(L+1)*q) (next : Z+1=2^(H+1)*v) :
    let r := periodReturns p
    let d := periodDivisions p
    let B := periodCost p
    let incoming := 3^r*2^(L+1)
    let outgoing := 2^d*2^(H+1)
    (v<q ↔ incoming*q+B+2^d<outgoing*q+3^r) ∧
      Segment N Z (j+r) (S+d) (3^r*C+2^S*B) := by
  dsimp only
  have localPath := (composePeriod word).1
  have localBook := localPath.book
  have changeBook :
      (2^periodDivisions p*2^(H+1))*v+3^periodReturns p =
      (3^periodReturns p*2^(L+1))*q+periodCost p+2^periodDivisions p := by
    have balanced : 2^periodDivisions p*(Z+1)+3^periodReturns p =
        3^periodReturns p*(J+1)+periodCost p+2^periodDivisions p := by
      simp only [Nat.mul_add,Nat.mul_one]
      omega
    simpa only [entry,next,Nat.mul_assoc] using balanced
  have pos : 0<2^periodDivisions p*2^(H+1) :=
    Nat.mul_pos (Nat.pow_pos (by decide)) (Nat.pow_pos (by decide))
  refine ⟨?_,compose original localPath⟩
  constructor
  · intro lower
    have m := Nat.mul_lt_mul_of_pos_left lower pos
    omega
  · intro lower
    have less : (2^periodDivisions p*2^(H+1))*v < (2^periodDivisions p*2^(H+1))*q := by omega
    exact Nat.lt_of_mul_lt_mul_left less

private theorem cofactorEnvelope {p : List WeakEpisode} {J Z L H q v : Nat}
    (word : Follows J Z p) (entry : J+1=2^(L+1)*q) (next : Z+1=2^(H+1)*v) :
    17*((2^periodDivisions p*2^(H+1))*v)+56*2^periodDivisions p ≤
      17*((3^periodReturns p*2^(L+1))*q)+56*3^periodReturns p := by
  have eqJ : weight J=17*(J+1)+56 := by simp [weight,Nat.mul_add]
  have eqZ : weight Z=17*(Z+1)+56 := by simp [weight,Nat.mul_add]
  have main := optimalForWord word
  rw [eqZ,eqJ,next,entry,Nat.mul_add,Nat.mul_add] at main
  simpa only [Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using main

/-- A coefficient excess that already covers one unit of the incoming
cofactor forces strict decline. This form can be checked with no sum
of additive terms, while the full original book remains available. -/
theorem budgetDrop {p : List WeakEpisode} {N J Z j S C L H q v : Nat}
    (length : 2≤L) (original : Segment N J j S C) (word : Follows J Z p)
    (entry : J+1=2^(L+1)*q) (next : Z+1=2^(H+1)*v)
    (pay : (3^periodReturns p*2^(L+1))*(q+1)≤(2^periodDivisions p*2^(H+1))*q) :
    v<q ∧ Segment N Z (j+periodReturns p) (S+periodDivisions p)
        (3^periodReturns p*C+2^S*periodCost p) := by
  refine ⟨?_,compose original (composePeriod word).1⟩
  by_cases sufficient : v<q
  · exact sufficient
  ·
    have margin := cofactorEnvelope word entry next
    have hq : q≤v := by omega
    have scaled : (2^periodDivisions p*2^(H+1))*q ≤
        (2^periodDivisions p*2^(H+1))*v := Nat.mul_le_mul_left _ hq
    have eight : (8:Nat)≤2^(L+1) :=
      Nat.pow_le_pow_right (by decide : 0<(2:Nat)) (by omega : 3≤L+1)
    have ample := Nat.mul_le_mul_left (3^periodReturns p) eight
    have power : 0<(3:Nat)^periodReturns p := Nat.pow_pos (by decide)
    rw [Nat.mul_succ] at pay
    omega

/-- Two length-two episodes with different tails can lower the cofactor
across the pair when the terminal starts a run of at least four ones.
The terminal carries the complete history from the original seed. -/
theorem mixedLengthTwoDrops {N J X Z j S C H q v b₁ b₂ : Nat}
    (original : Segment N J j S C)
    (first : WeakBook J X 2 b₁) (second : WeakBook X Z 2 b₂)
    (opposite : (b₁=1 ∧ b₂=2) ∨ (b₁=2 ∧ b₂=1))
    (positive : 0<q) (longer : 4≤H)
    (entry : J+1=8*q) (next : Z+1=2^(H+1)*v) :
    v<q ∧ ∃ B : Nat, (B=8249 ∨ B=10585) ∧
      Segment N Z (j+8) (S+11) (6561*C+2^S*B) := by
  have physical : Follows J Z [(2,b₁),(2,b₂)] := by
    have p : b₁=1 ∨ b₁=2 := by omega
    have q : b₂=1 ∨ b₂=2 := by omega
    exact ⟨by decide,p,X,first,by exact ⟨by decide,q,Z,second,rfl⟩⟩
  have path := (composePeriod physical).1
  obtain ⟨clocks,cost⟩ :
      periodReturns [(2,b₁),(2,b₂)]=8 ∧ periodDivisions [(2,b₁),(2,b₂)]=11 := by
    rcases opposite with ⟨rfl,rfl⟩|⟨rfl,rfl⟩ <;> decide
  let A := periodCost [(2,b₁),(2,b₂)]
  have small : A=8249 ∨ A=10585 := by
    dsimp only [A]
    rcases opposite with ⟨rfl,rfl⟩|⟨rfl,rfl⟩ <;> decide
  have pwr : (65536:Nat)≤2^11*2^(H+1) := by
    have eight : (32:Nat)≤2^(H+1) :=
      Nat.pow_le_pow_right (by decide : 0<(2:Nat)) (by omega : 5≤H+1)
    exact Nat.mul_le_mul_left (2^11) eight
  have enough := Nat.mul_le_mul_right q pwr
  have price : 52488*q+A+2048<(2^11*2^(H+1))*q+6561 := by omega
  have result := exactRank (L:=2) original physical entry next
  rw [clocks,cost] at result
  change (v<q ↔ 52488*q+A+2048<(2^11*2^(H+1))*q+6561) ∧ _ at result
  exact ⟨result.1.mpr price,A,small,result.2⟩

end CollatzCharacterBridge.Front4bNetCofactor

#print axioms CollatzCharacterBridge.Front4bNetCofactor.exactRank
#print axioms CollatzCharacterBridge.Front4bNetCofactor.budgetDrop
#print axioms CollatzCharacterBridge.Front4bNetCofactor.mixedLengthTwoDrops
