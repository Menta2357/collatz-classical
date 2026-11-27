import Front4bPeriodicWeakRepeat

namespace CollatzCharacterBridge.Front4bSwitchedEnvelope

open StagedCylinder (Segment compose)
open Front4bPeriodicWeakRepeat (WeakEpisode Follows periodReturns periodDivisions periodCost composePeriod)

set_option maxRecDepth 14000
set_option maxHeartbeats 1500000

private theorem worstRatio {L b : Nat} (length : 2≤L) (branch : b=1 ∨ b=2) :
    5*2^(L+2+b)<4*3^(L+2) := by
  have induct (k : Nat) : 5*2^(k+6)<4*3^(k+4) := by
    induction k with
    | zero => decide
    | succ k ih =>
      rw [show k+1+6=(k+6)+1 by omega,show k+1+4=(k+4)+1 by omega,
        Nat.pow_succ 2 (k+6),Nat.pow_succ 3 (k+4)]
      rw [←Nat.mul_assoc 5,←Nat.mul_assoc 4]
      omega
  have cap : 2^(L+2+b)≤2^((L-2)+6) := Nat.pow_le_pow_right (by decide) (by omega)
  have auto := induct (L-2)
  rw [show L-2+4=L+2 by omega] at auto
  exact Nat.lt_of_le_of_lt (Nat.mul_le_mul_left 5 cap) auto

/-- Among natural shifts valid for both b=1 and b=2, five is least.
The weak episode L=2,b=2 already requires 73≤17c. -/
theorem shiftFiveMinimal (c : Nat) (universal : ∀ L b : Nat, 2≤L → (b=1 ∨ b=2) →
    (3^(L+2)-2^(L+1))+c*2^(L+2+b)≤c*3^(L+2)) : 5≤c := by
  have smallest := universal 2 2 (by decide) (Or.inr rfl)
  change 73+c*64≤c*81 at smallest
  omega

private theorem shiftAtEpisode {L b : Nat} (length : 2≤L) (branch : b=1 ∨ b=2) :
    (3^(L+2)-2^(L+1))+5*2^(L+2+b)<5*3^(L+2) := by
  have cap := worstRatio length branch
  have shift : 3^(L+2)-2^(L+1)≤3^(L+2) := Nat.sub_le _ _
  omega

/-- A universal compensation of the entire additive B by the same shift,
for a freely changing list of weak episodes. -/
theorem budgetForWord {p : List WeakEpisode} {x y : Nat} (path : Follows x y p) :
    periodCost p+5*2^periodDivisions p≤5*3^periodReturns p ∧
    (p≠[] → periodCost p+5*2^periodDivisions p<5*3^periodReturns p) := by
  induction p generalizing x y with
  | nil => exact ⟨by decide,fun h => (h rfl).elim⟩
  | cons episode rest ih =>
    rcases episode with ⟨L,b⟩
    obtain ⟨len,branch,z,_,tail⟩ := path
    have suffix := (ih tail).1
    have strict := shiftAtEpisode len branch
    let D₁ := 2^(L+2+b)
    let A₁ := 3^(L+2)
    let C₁ := 3^(L+2)-2^(L+1)
    let D₂ := 2^periodDivisions rest
    let A₂ := 3^periodReturns rest
    let C₂ := periodCost rest
    have positive : 0<A₂ := Nat.pow_pos (by decide)
    have bound : C₂+5*D₂≤5*A₂ := suffix
    have contribution : C₁+5*D₁<5*A₁ := strict
    have total : A₂*C₁+D₁*C₂+5*(D₁*D₂)<5*(A₁*A₂) := by
      calc
        _ = A₂*C₁+D₁*(C₂+5*D₂) := by rw [Nat.mul_add]; ac_rfl
        _ ≤ A₂*C₁+D₁*(5*A₂) := Nat.add_le_add_left (Nat.mul_le_mul_left _ bound) _
        _ = A₂*(C₁+5*D₁) := by rw [Nat.mul_add]; ac_rfl
        _ < A₂*(5*A₁) := Nat.mul_lt_mul_of_pos_left contribution positive
        _ = _ := by ac_rfl
    have result : periodCost ((L,b)::rest)+5*2^periodDivisions ((L,b)::rest)<
        5*3^periodReturns ((L,b)::rest) := by
      rw [periodCost,periodDivisions,periodReturns,Nat.pow_add 2 (L+2+b),Nat.pow_add 3 (L+2)]
      exact total
    exact ⟨Nat.le_of_lt result,fun _ => result⟩

/-- Keep the exact book and the paid margin jointly. The positive shift is
fixed even when the valuations and lengths change aperiodically. -/
theorem shiftedBook {p : List WeakEpisode} {J Z : Nat} (path : Follows J Z p) :
    2^periodDivisions p*(Z+5)+
      (5*3^periodReturns p-(periodCost p+5*2^periodDivisions p))=3^periodReturns p*(J+5) := by
  have budget := (budgetForWord path).1
  have exactBook := (composePeriod path).1.book
  rw [Nat.mul_add,Nat.mul_add,exactBook]
  rw [show 2^periodDivisions p*5=5*2^periodDivisions p by ac_rfl,
    show 3^periodReturns p*5=5*3^periodReturns p by ac_rfl]
  omega

/-- Necessary true-clock and cofactor budget for any next one-run after
an arbitrary finite physical concatenation of weak episodes. -/
theorem reentryBound {p : List WeakEpisode} {J Z H v : Nat} (path : Follows J Z p)
    (factor : Z+1=2^(H+1)*v) :
    2^(periodDivisions p+H+1)*v<3^periodReturns p*(J+5) := by
  have exactBook := shiftedBook path
  have fact : 2^(periodDivisions p+H+1)*v=2^periodDivisions p*(Z+1) := by
    rw [factor,show periodDivisions p+H+1=periodDivisions p+(H+1) by omega,
      Nat.pow_add 2 (periodDivisions p) (H+1),Nat.mul_assoc]
  have above : 2^periodDivisions p*(Z+1)<2^periodDivisions p*(Z+5) :=
    Nat.mul_lt_mul_of_pos_left (by omega) (Nat.pow_pos (by decide))
  rw [fact]
  exact Nat.lt_of_lt_of_le above (by omega)

/-- No rebasing of N or its earlier history. The input price is exactly
3^j*N+C+5*2^S and the next cofactor remains explicit. -/
theorem originalReentryBound {p : List WeakEpisode} {N J Z j S C H v : Nat}
    (origin : Segment N J j S C) (path : Follows J Z p) (factor : Z+1=2^(H+1)*v) :
    2^(S+periodDivisions p+H+1)*v<3^periodReturns p*(3^j*N+C+5*2^S) ∧
      Segment N Z (j+periodReturns p) (S+periodDivisions p)
        (3^periodReturns p*C+2^S*periodCost p) := by
  have under := Nat.mul_lt_mul_of_pos_left (reentryBound path factor) (Nat.pow_pos (by decide) : 0<2^S)
  have price : 2^S*(J+5)=3^j*N+C+5*2^S := by rw [Nat.mul_add,origin.book,Nat.mul_comm (2^S) 5]
  have left : 2^(S+periodDivisions p+H+1)*v=2^S*(2^(periodDivisions p+H+1)*v) := by
    rw [show S+periodDivisions p+H+1=S+(periodDivisions p+H+1) by omega,Nat.pow_add,Nat.mul_assoc]
  have right : 2^S*(3^periodReturns p*(J+5))=3^periodReturns p*(3^j*N+C+5*2^S) := by
    rw [←price]
    ac_rfl
  rw [←left,right] at under
  exact ⟨under,compose origin (composePeriod path).1⟩

/-- Integer-only exclusion of oversize reentries. No rational logarithm
or bound on the number of switches is an input. -/
theorem noOversizedReentry {p : List WeakEpisode} {J Z H v K : Nat}
    (path : Follows J Z p) (factor : Z+1=2^(H+1)*v) (vPositive : 0<v)
    (seedBudget : J+5≤2^K) (large : 2*periodReturns p+K≤periodDivisions p+H+1) : False := by
  have strict := reentryBound path factor
  have minV := Nat.mul_le_mul_left (2^(periodDivisions p+H+1)) (show 1≤v by omega)
  rw [Nat.mul_one] at minV
  have pow : 3^periodReturns p≤(2:Nat)^(2*periodReturns p) := by
    rw [Nat.pow_mul]
    exact Nat.pow_le_pow_left (by decide) _
  have upper := Nat.mul_le_mul pow seedBudget
  rw [←Nat.pow_add] at upper
  have close := Nat.pow_le_pow_right (by decide : 0<2) large
  omega

end CollatzCharacterBridge.Front4bSwitchedEnvelope

#print axioms CollatzCharacterBridge.Front4bSwitchedEnvelope.shiftFiveMinimal
#print axioms CollatzCharacterBridge.Front4bSwitchedEnvelope.budgetForWord
#print axioms CollatzCharacterBridge.Front4bSwitchedEnvelope.shiftedBook
#print axioms CollatzCharacterBridge.Front4bSwitchedEnvelope.reentryBound
#print axioms CollatzCharacterBridge.Front4bSwitchedEnvelope.originalReentryBound
#print axioms CollatzCharacterBridge.Front4bSwitchedEnvelope.noOversizedReentry
