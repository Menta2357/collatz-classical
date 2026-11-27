import Front4bWeakReentry

namespace CollatzCharacterBridge.Front4bSwitchReserve

open StagedCylinder (Segment compose)
open Front4bWeakRank (WeakRank)
open Front4bWeakReentry (weakBookOfRank)
open Front4bWeakCofactor (readmissionEquation)

set_option maxRecDepth 14000

def price (L b : Nat) : Nat := 2^(L+b+2)
def weight (L b : Nat) : Nat := 3^(L+2)-price L b
def shift (b : Nat) : Nat := 2^(b+1)-1

def reserve (L b J : Nat) : Nat := weight L b*(J+1)+2^(L+1)*shift b

def ExactPower (e n : Nat) : Prop := ∃ q, q%2=1 ∧ n=2^e*q

private theorem powerEven (k : Nat) (pos : 1≤k) : 2^k%2=0 := by
  cases k with
  | zero => omega
  | succ k => rw [Nat.pow_succ,Nat.mul_mod]; simp

private theorem powerEight (k : Nat) (large : 3≤k) : 2^k%8=0 := by
  rw [show k=(k-3)+3 by omega,Nat.pow_add,Nat.mul_mod]
  simp

private theorem threeOdd (k : Nat) : 3^k%2=1 := by
  induction k with
  | zero => decide
  | succ k ih => rw [Nat.pow_succ,Nat.mul_mod,ih]

private theorem fast (k : Nat) : 2^(k+2+4)<3^(k+2+2) := by
  induction k with
  | zero => decide
  | succ k ih =>
    change 2^(k+1+2+4)<3^(k+1+2+2)
    rw [show k+1+2+4=(k+2+4)+1 by omega,show k+1+2+2=(k+2+2)+1 by omega,
      Nat.pow_succ 2 (k+2+4),Nat.pow_succ 3 (k+2+2)]
    omega

private theorem weightSum {L b : Nat} (len : 2≤L) (branch : b=1 ∨ b=2) :
    weight L b+price L b=3^(L+2) := by
  have f : 2^(L+4)<3^(L+2) := by
    obtain ⟨k,rfl⟩ : ∃ k,L=k+2 := ⟨L-2,by omega⟩
    exact fast k
  have p : price L b≤2^(L+4) := Nat.pow_le_pow_right (by decide) (by omega)
  exact Nat.sub_add_cancel (Nat.le_trans p (Nat.le_of_lt f))

private theorem weightOdd {L b : Nat} (len : 2≤L) (branch : b=1 ∨ b=2) :
    weight L b%2=1 := by
  have equality := congrArg (fun x : Nat => x%2) (weightSum len branch)
  change (weight L b+price L b)%2=3^(L+2)%2 at equality
  rw [Nat.add_mod,show price L b%2=0 from powerEven _ (by omega),threeOdd] at equality
  omega

private theorem shiftOdd {b : Nat} (branch : b=1 ∨ b=2) : shift b%2=1 := by
  rcases branch with rfl | rfl <;> decide

/-- At a length change the abandoned mode has exactly min(P,L)+1 factors. -/
theorem lengthSwitch {J P L b Q : Nat} (old : 2≤P) (branch : b=1 ∨ b=2)
    (changed : P≠L) (odd : Q%2=1) (current : J+1=2^(L+1)*Q) :
    ExactPower (min P L+1) (reserve P b J) := by
  by_cases low : P<L
  · let delta := L-P
    have step : L+1=(P+1)+delta := by dsimp only [delta]; omega
    have even : 2^delta%2=0 := powerEven _ (by dsimp only [delta]; omega)
    rw [Nat.min_eq_left (Nat.le_of_lt low)]
    refine ⟨weight P b*(2^delta*Q)+shift b,?_,?_⟩
    · simp [Nat.add_mod,Nat.mul_mod,even,shiftOdd branch]
    · unfold reserve
      rw [current,step,Nat.pow_add,Nat.mul_add]
      ac_rfl
  · have high : L<P := by omega
    let delta := P-L
    have step : P+1=(L+1)+delta := by dsimp only [delta]; omega
    have even : 2^delta%2=0 := powerEven _ (by dsimp only [delta]; omega)
    rw [Nat.min_eq_right (Nat.le_of_lt high)]
    refine ⟨weight P b*Q+2^delta*shift b,?_,?_⟩
    · simp [Nat.add_mod,Nat.mul_mod,even,weightOdd old branch,odd]
    · unfold reserve
      have expand : 2^(P+1)=2^(L+1)*2^delta := by rw [step,Nat.pow_add]
      rw [current,expand,Nat.mul_add]
      ac_rfl

private theorem residueAtTail {L H prev b Q v : Nat} (len : 2≤L)
    (previous : prev=1 ∨ prev=2) (current : b=1 ∨ b=2) (changed : prev≠b)
    (book : 2^(H+b+2)*v=3^(L+2)*Q+shift b) :
    (weight L prev*Q+shift prev)%8=4 := by
  have sum := weightSum len previous
  have same : weight L prev*Q+shift b+price L prev*Q=2^(H+b+2)*v := by
    calc
      _ = (weight L prev+price L prev)*Q+shift b := by rw [Nat.add_mul]; omega
      _ = _ := by rw [sum,book]
  have residue := congrArg (fun x : Nat => x%8) same
  change ((weight L prev*Q+shift b)+price L prev*Q)%8=(2^(H+b+2)*v)%8 at residue
  have a : price L prev%8=0 := powerEight _ (by omega)
  have c : 2^(H+b+2)%8=0 := powerEight _ (by omega)
  rw [Nat.add_mod,Nat.mul_mod (price L prev) Q 8,a,Nat.mul_mod (2^(H+b+2)) v 8,c] at residue
  simp only [Nat.zero_mul,Nat.zero_mod,Nat.add_zero,Nat.mod_mod] at residue
  rcases previous with hprev | hprev <;> rcases current with hb | hb
  all_goals subst prev; subst b
  · omega
  · change (weight L 1*Q+7)%8=0 at residue
    change (weight L 1*Q+3)%8=4
    omega
  · change (weight L 2*Q+3)%8=0 at residue
    change (weight L 2*Q+7)%8=4
    omega
  · omega

/-- At a genuine tail change with the length unchanged, the abandoned
mode has exactly L+3 factors of two. -/
theorem tailSwitch {J L H prev b Q v : Nat} (len : 2≤L)
    (previous : prev=1 ∨ prev=2) (current : b=1 ∨ b=2) (changed : prev≠b)
    (phase : J+1=2^(L+1)*Q) (weak : WeakRank J L b)
    (next : orbit J (L+2)+1=2^(H+1)*v) :
    ExactPower (L+3) (reserve L prev J) := by
  have eq := readmissionEquation (weakBookOfRank weak) phase next
  have r := residueAtTail len previous current changed eq
  let u := weight L prev*Q+shift prev
  have hu : u%8=4 := r
  have shape : u=4*(u/4) := by omega
  have odd : (u/4)%2=1 := by omega
  refine ⟨u/4,odd,?_⟩
  have carry : reserve L prev J=2^(L+1)*u := by
    unfold reserve u
    rw [phase,Nat.mul_add]
    ac_rfl
  rw [carry,show L+3=(L+1)+2 by omega,Nat.pow_add 2 (L+1) 2]
  change 2^(L+1)*u=(2^(L+1)*4)*(u/4)
  rw [Nat.mul_assoc,←shape]

theorem switchHistory {N J j S C P L H prev b Q v : Nat} (old : 2≤P) (len : 2≤L)
    (previous : prev=1 ∨ prev=2) (current : b=1 ∨ b=2) (changed : P≠L ∨ prev≠b)
    (odd : Q%2=1) (phase : J+1=2^(L+1)*Q)
    (history : Segment N J j S C) (weak : WeakRank J L b)
    (next : orbit J (L+2)+1=2^(H+1)*v) :
    ExactPower (if P=L then L+3 else min P L+1) (reserve P prev J) ∧
      Segment N (orbit J (L+2)) (j+(L+2)) (S+(L+2+b))
        (3^(L+2)*C+2^S*(3^(L+2)-2^(L+1))) := by
  refine ⟨?_,compose history (weakBookOfRank weak)⟩
  by_cases same : P=L
  · subst P
    simp only [if_pos rfl]
    exact tailSwitch len previous current (by omega) phase weak next
  · rw [if_neg same]
    exact lengthSwitch old previous same odd phase

end CollatzCharacterBridge.Front4bSwitchReserve

#print axioms CollatzCharacterBridge.Front4bSwitchReserve.lengthSwitch
#print axioms CollatzCharacterBridge.Front4bSwitchReserve.tailSwitch
#print axioms CollatzCharacterBridge.Front4bSwitchReserve.switchHistory
