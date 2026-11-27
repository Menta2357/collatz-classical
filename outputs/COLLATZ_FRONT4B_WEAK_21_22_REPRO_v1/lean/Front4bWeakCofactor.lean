import Front4bWeakBudget

namespace CollatzCharacterBridge.Front4bWeakCofactor

open StagedCylinder (Segment compose)
open Front4bWeakBudget (WeakBook)

set_option maxRecDepth 14000
set_option maxHeartbeats 1200000

private theorem threeModEight (a : Nat) : 3^a%8=if a%2=0 then 1 else 3 := by
  induction a with
  | zero => decide
  | succ a ih =>
    rw [Nat.pow_succ,Nat.mul_mod,ih]
    by_cases even : a%2=0
    · rw [if_pos even,if_neg (by omega : (a+1)%2≠0)]
    · rw [if_neg even,if_pos (by omega : (a+1)%2=0)]

private theorem twoModThree (a : Nat) : 2^a%3=if a%2=0 then 1 else 2 := by
  induction a with
  | zero => decide
  | succ a ih =>
    rw [Nat.pow_succ,Nat.mul_mod,ih]
    by_cases even : a%2=0
    · rw [if_pos even,if_neg (by omega : (a+1)%2≠0)]
    · rw [if_neg even,if_pos (by omega : (a+1)%2=0)]

private theorem twoModEight {e : Nat} (he : 3≤e) : 2^e%8=0 := by
  rw [show e=3+(e-3) by omega,Nat.pow_add,Nat.mul_mod]
  simp

private theorem noSmallSquareGap {a e : Nat} (ha : 4≤a) (he : 3≤e)
    (eq : 2^e=3^a+7) : False := by
  have e8 := twoModEight he
  rw [eq,Nat.add_mod,threeModEight] at e8
  have evenA : a%2=0 := by
    by_cases even : a%2=0
    · exact even
    · rw [if_neg even] at e8
      exact False.elim ((by decide : (3+7)%8≠0) e8)
  have e3 := twoModThree e
  have mod3 : 3^a%3=0 := by
    rw [show a=(a-1)+1 by omega,Nat.pow_succ]
    omega
  rw [eq,Nat.add_mod] at e3
  · rw [mod3] at e3
    have evenE : e%2=0 := by
      by_cases even : e%2=0
      · exact even
      · rw [if_neg even] at e3
        exact False.elim ((by decide : (0+7%3)%3≠2) e3)
    let x := 2^(e/2)
    let y := 3^(a/2)
    have squares : x^2=y^2+7 := by
      dsimp only [x,y]
      rw [←Nat.pow_mul,←Nat.pow_mul,show e/2*2=e by omega,show a/2*2=a by omega,eq]
    have ordered : y<x := by
      by_cases large : x≤y
      · have bound := Nat.pow_le_pow_left large 2
        omega
      · omega
    have yLarge : 9≤y := Nat.pow_le_pow_right (by decide : 0<3) (by omega : 2≤a/2)
    have more := Nat.pow_le_pow_left (by omega : y+1≤x) 2
    simp only [Nat.pow_succ,Nat.pow_zero,Nat.one_mul] at more squares
    simp only [Nat.add_mul,Nat.mul_add,Nat.mul_one,Nat.one_mul] at more
    omega

private theorem noGap {a e d : Nat} (ha : 4≤a) (he : 3≤e)
    (tiny : d=1 ∨ d=3 ∨ d=7) (eq : 2^e=3^a+d) : False := by
  have e8 := twoModEight he
  rcases tiny with rfl | rfl | rfl
  · rw [eq,Nat.add_mod,threeModEight] at e8
    split at e8 <;> contradiction
  · rw [eq,Nat.add_mod,threeModEight] at e8
    split at e8 <;> contradiction
  · exact noSmallSquareGap ha he eq

private theorem smallDivisor {d q : Nat} (dp : 0<d) (qp : 0<q)
    (product : d*q=3 ∨ d*q=7) : d=1 ∨ d=3 ∨ d=7 := by
  have bound : d≤7 := by
    have lower := Nat.mul_le_mul_left d (show 1≤q by omega)
    rw [Nat.mul_one] at lower
    omega
  have possibilities : d=1 ∨ d=2 ∨ d=3 ∨ d=4 ∨ d=5 ∨ d=6 ∨ d=7 := by omega
  rcases possibilities with e | e | e | e | e | e | e <;> rw [e] at product ⊢ <;> omega

/-- The actual additive shift reappears as constant 3 or 7 in the book
between successive cofactor coordinates. -/
theorem readmissionEquation {J Z L b H q v : Nat} (weak : WeakBook J Z L b)
    (initial : J+1=2^(L+1)*q) (next : Z+1=2^(H+1)*v) :
    2^(H+b+2)*v=3^(L+2)*q+(2^(b+1)-1) := by
  have cap : 2^(L+1)≤3^(L+2) :=
    Nat.le_trans (Nat.pow_le_pow_left (by decide : 2≤3) (L+1))
      (Nat.pow_le_pow_right (by decide : 0<3) (by omega : L+1≤L+2))
  have balance := weak.2
  have sum : 2^(L+2+b)*Z+2^(L+1)=3^(L+2)*(J+1) := by
    rw [balance,Nat.mul_add,Nat.mul_one,Nat.add_assoc,Nat.sub_add_cancel cap]
  have scale : 2^ (L+2+b)=2^(L+1)*2^(b+1) := by
    rw [←Nat.pow_add]; congr 1; omega
  have pos : 0<2^(L+1) := Nat.pow_pos (by decide)
  apply Nat.eq_of_mul_eq_mul_left pos
  have shift : 2^(L+1)*(2^(b+1)-1)+2^(L+1)=2^(L+1)*2^(b+1) := by
    rw [←Nat.mul_succ]
    congr 1
    have pow : 0<2^(b+1) := Nat.pow_pos (by decide)
    omega
  have nextBook : 2^(L+2+b)*(Z+1)=2^(L+1)*(2^(H+b+2)*v) := by
    rw [next,scale,show H+b+2=(b+1)+(H+1) by omega,Nat.pow_add 2 (b+1) (H+1)]
    ac_rfl
  have base : 3^(L+2)*(J+1)=2^(L+1)*(3^(L+2)*q) := by rw [initial]; ac_rfl
  rw [base] at sum
  rw [Nat.mul_add,Nat.mul_one,scale] at nextBook
  rw [scale] at sum
  rw [Nat.mul_add]
  omega

private theorem rankSign {a e q v offset : Nat} (ha : 4≤a) (he : 3≤e) (hq : 0<q)
    (small : offset=3 ∨ offset=7)
    (book : 2^e*v=3^a*q+offset) :
    v<q ↔ 3^a<2^e := by
  obtain ⟨pos,cap⟩ : 0<offset ∧ offset≤7 := by omega
  constructor
  · intro lower
    by_cases lt : 3^a<2^e
    · exact lt
    have early := Nat.mul_lt_mul_of_pos_left lower (Nat.pow_pos (by decide) : 0<2^e)
    have middle := Nat.mul_le_mul_right q (show 2^e≤3^a by omega)
    omega
  · intro exponent
    have noGrowth : ¬q<v := by
      intro growth
      have more := Nat.mul_le_mul_left (2^e) (show q+1≤v by omega)
      have scale := Nat.mul_le_mul_right q (Nat.le_of_lt exponent)
      have eight : 8≤2^e := Nat.pow_le_pow_right (by decide : 0<2) he
      rw [Nat.mul_succ] at more
      omega
    by_cases eq : v=q
    · subst v
      let d := 2^e-3^a
      have diff : 2^e=3^a+d := by dsimp only [d]; omega
      rw [diff,Nat.add_mul] at book
      have smallProd : d*q=offset := by omega
      have allowed := smallDivisor (show 0<d by dsimp only [d]; omega) hq (by omega)
      exact (noGap ha he allowed diff).elim
    · omega

/-- In the reentry domain of long ones and a weak pair, the odd cofactor
drops exactly when the coefficients satisfy this strict true-clock bound.
The new point comes with its full physical history from the same seed. -/
theorem rankOfReadmission {N J Z j S C L b H q v : Nat}
    (length : 2≤L) (newLength : 2≤H) (branch : b=1 ∨ b=2) (qPos : 0<q)
    (history : Segment N J j S C) (weak : WeakBook J Z L b)
    (initial : J+1=2^(L+1)*q) (next : Z+1=2^(H+1)*v) :
    (v<q ↔ 3^(L+2)<2^(H+b+2)) ∧
      Segment N Z (j+(L+2)) (S+(L+2+b))
        (3^(L+2)*C+2^S*(3^(L+2)-2^(L+1))) := by
  have shift : 2^(b+1)-1=3 ∨ 2^(b+1)-1=7 := by
    rcases branch with rfl | rfl <;> decide
  exact ⟨rankSign (by omega) (by omega) qPos shift
    (readmissionEquation weak initial next),compose history weak⟩

/-- Every chain of genuine readmissions satisfying the strict coefficient
guard terminates as a chain of decreasing natural cofactors. -/
theorem noInfiniteRankDrops (q : Nat → Nat) (less : ∀ i, q (i+1)<q i) : False := by
  have budget (i : Nat) : q i+i≤q 0 := by
    induction i with
    | zero => simp
    | succ i ih => have next := less i; omega
  have beyond := budget (q 0+1)
  omega

end CollatzCharacterBridge.Front4bWeakCofactor

#print axioms CollatzCharacterBridge.Front4bWeakCofactor.readmissionEquation
#print axioms CollatzCharacterBridge.Front4bWeakCofactor.rankOfReadmission
#print axioms CollatzCharacterBridge.Front4bWeakCofactor.noInfiniteRankDrops
