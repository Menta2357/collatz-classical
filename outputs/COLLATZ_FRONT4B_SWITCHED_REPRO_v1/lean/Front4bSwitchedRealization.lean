import Front4bWeakRows

namespace CollatzCharacterBridge.Front4bSwitchedRealization

open StagedCylinder (Segment compose)
open Front4bWeakRank (WeakRank weakCost oddAffineLift shortcutLowerOfOddLower)
open Front4bWeakRealization (weakRankOfFactors)

set_option maxRecDepth 12000
set_option maxHeartbeats 1600000

/-- A schedule lists the second valuation b of each weak pair and the
length H of the next run of ones, starting from the separately specified L. -/
def Allowed : List (Nat × Nat) → Prop
  | [] => True
  | (b,H)::rest => (b=1 ∨ b=2) ∧ 2≤H ∧ Allowed rest

structure Transition (J L q b H Z v : Nat) : Prop where
  long : 2≤L
  weak : b=1 ∨ b=2
  odd : q%2=1
  entry : J+1=2^(L+1)*q
  nextOdd : v%2=1
  nextEntry : Z+1=2^(H+1)*v
  path : WeakRank J L b
  atNext : orbit J (L+2)=Z
  growth : 2^(H+b+2)<3^(L+2) → q<v

/-- The endpoint, two clocks and additive are indexed by actual successive
weak episodes. The final entry has its own exact run length and odd cofactor. -/
inductive Trace : Nat → Nat → Nat → List (Nat × Nat) → Nat → Nat → Nat → Nat → Prop where
  | stop {J L q : Nat} (length : 2≤L) (odd : q%2=1) (entry : J+1=2^(L+1)*q) :
      Trace J L q [] J 0 0 0
  | extend {J L q b H Z v : Nat} {rest : List (Nat × Nat)} {X m d C : Nat}
      (head : Transition J L q b H Z v) (tail : Trace Z H v rest X m d C) :
      Trace J L q ((b,H)::rest) X (L+2+m) (L+2+b+d) (3^m*weakCost L+2^(L+2+b)*C)

private theorem entryOdd {J L q : Nat} (entry : J+1=2^(L+1)*q) : J%2=1 := by
  rw [Nat.pow_succ,show (2:Nat)^L*2*q=2*(2^L*q) by ac_rfl] at entry
  omega

theorem physical {J L q : Nat} {xs : List (Nat × Nat)} {X m d C : Nat}
    (trace : Trace J L q xs X m d C) :
    Segment J X m d C ∧ (∀ i≤m, J≤orbit J i) ∧
      (∀ k≤d, J≤TerrasClock.orbit J k) ∧ 4*xs.length≤m ∧ m≤d := by
  induction trace with
  | stop length qo entry =>
    refine ⟨⟨A2Header.Physical.refl _,by simp⟩,?_,?_,by decide,by decide⟩
    · intro i hi
      have eq : i=0 := by omega
      subst i
      exact Nat.le_refl _
    · intro k hk
      have eq : k=0 := by omega
      subst k
      exact Nat.le_refl _
  | @extend J L q b H Z v rest X m d C head tail ih =>
    obtain ⟨suffix,lower,_,length,ordered⟩ := ih
    have path := head.path.history
    rw [head.atNext] at path
    have full := compose path suffix
    have lowerAll : ∀ i≤L+2+m, J≤orbit J i := by
      intro i hi
      by_cases first : i≤L+2
      · exact head.path.oddLower i first
      · rw [show i=L+2+(i-(L+2)) by omega,orbit_add,head.atNext]
        have height := head.path.lastAbove
        rw [head.atNext] at height
        exact Nat.le_trans (Nat.le_of_lt height) (lower _ (by omega))
    exact ⟨full,lowerAll,shortcutLowerOfOddLower (entryOdd head.entry) full lowerAll,
      by simp only [List.length_cons,Nat.mul_succ]; have := head.long; omega,by omega⟩

private theorem oddPowerThree (k : Nat) : 3^k%2=1 := by
  induction k with
  | zero => decide
  | succ k ih => rw [Nat.pow_succ,Nat.mul_mod,ih]

private theorem evenPowerTwo {k : Nat} (pos : 0<k) : 2^k%2=0 := by
  cases k with
  | zero => omega
  | succ k => rw [Nat.pow_succ,Nat.mul_mod]; simp

private theorem natEntry {L q : Nat} (qo : q%2=1) :
    (2^(L+1)*q-1)+1=2^(L+1)*q := by
  have positive := Nat.mul_pos (Nat.pow_pos (by decide : (0:Nat)<2) : 0<2^(L+1))
    (show 0<q by omega)
  omega

/-- Lifting the next progression backwards across one genuine physical
weak episode supplies an entire initial progression. -/
private theorem prepend {L b H v K : Nat} (long : 2≤L)
    (weak : b=1 ∨ b=2) (vo : v%2=1) (kp : 0<K) :
    ∃ q M, q%2=1 ∧ 0<M ∧ ∀ t, ∃ u,
      let q' := q+2^M*t
      let v' := v+2^K*u
      Transition (2^(L+1)*q'-1) L q' b H (2^(H+1)*v'-1) v' := by
  let A := 3^(L+2)
  let e := (b+1)+(H+1)
  let M := e+K
  let B := 2^(H+1)*v
  let T := 1+2^(b+1)*(B-1)
  have Aodd : A%2=1 := oddPowerThree _
  have Bpos : 0<B := Nat.mul_pos (Nat.pow_pos (by decide : (0:Nat)<2)) (by omega)
  have Todd : T%2=1 := by
    dsimp only [T]
    rw [Nat.add_mod,Nat.mul_mod,evenPowerTwo (by omega : 0<b+1)]
    simp
  have Mpos : 0<M := by dsimp only [M,e]; omega
  obtain ⟨q,r,lift⟩ := oddAffineLift Aodd 0 T M
  rw [Nat.zero_add] at lift
  have qo : q%2=1 := by
    have eq := congrArg (fun n : Nat => n%2) lift
    change (A*q)%2=(T+2^M*r)%2 at eq
    simpa [Nat.add_mod,Nat.mul_mod,Aodd,Todd,evenPowerTwo Mpos] using eq
  refine ⟨q,M,qo,Mpos,?_⟩
  intro t
  let u := r+A*t
  let q' := q+2^M*t
  let v' := v+2^K*u
  let J := 2^(L+1)*q'-1
  let Z := 2^(H+1)*v'-1
  have qodd : q'%2=1 := by simp [q',Nat.add_mod,Nat.mul_mod,qo,evenPowerTwo Mpos]
  have vodd : v'%2=1 := by simp [v',Nat.add_mod,Nat.mul_mod,vo,evenPowerTwo kp]
  have jEntry : J+1=2^(L+1)*q' := natEntry qodd
  have zEntry : Z+1=2^(H+1)*v' := natEntry vodd
  have invoice : A*q'=T+2^M*u := by
    simp only [q',u,Nat.mul_add,lift]
    ac_rfl
  have zs : Z=(B-1)+(2^(H+1)*2^K)*u := by
    simp only [Z,v',Nat.mul_add,←Nat.mul_assoc]
    change B+((2^(H+1)*2^K)*u)-1=(B-1)+((2^(H+1)*2^K)*u)
    omega
  have terminal : A*q'=1+2^(b+1)*Z := by
    rw [invoice,zs,show (2:Nat)^M=2^(b+1)*(2^(H+1)*2^K) by
      dsimp only [M,e]; rw [Nat.pow_add,Nat.pow_add,Nat.mul_assoc]]
    simp only [T,Nat.mul_add,Nat.mul_assoc,Nat.add_assoc]
  obtain ⟨path,endpoint⟩ := weakRankOfFactors long weak qodd (entryOdd zEntry) jEntry terminal
  have grows (power : 2^(H+b+2)<3^(L+2)) : q'<v' := by
    have scale : (2:Nat)^e=2^(b+1)*2^(H+1) := Nat.pow_add _ _ _
    have invoice' : 2^e*v'=A*q'+(2^(b+1)-1) := by
      have eq := congrArg (fun n : Nat => 2^(b+1)*n) zEntry
      change 2^(b+1)*(Z+1)=2^(b+1)*(2^(H+1)*v') at eq
      rw [Nat.mul_add,Nat.mul_one] at eq
      rw [scale,Nat.mul_assoc]
      have pos : 0<2^(b+1) := Nat.pow_pos (by decide)
      omega
    by_cases yes : q'<v'
    · exact yes
    · have scales := Nat.mul_le_mul_left (2^e) (show v'≤q' by omega)
      have power' : 2^e<A := by
        have ex : e=H+b+2 := by dsimp only [e]; omega
        rw [ex]
        exact power
      have strict := Nat.mul_lt_mul_of_pos_right power' (show 0<q' by omega)
      omega
  exact ⟨u,long,weak,qodd,jEntry,vodd,zEntry,path,endpoint,grows⟩

/-- Every legal finite schedule is realized on an entire progression of
positive odd starting cofactors. No uniform period is imposed on the schedule. -/
theorem finiteProgression (xs : List (Nat × Nat)) (legal : Allowed xs)
    {L : Nat} (long : 2≤L) :
    ∃ q K, q%2=1 ∧ 0<K ∧ ∀ t, ∃ X m d C,
      let q' := q+2^K*t
      Trace (2^(L+1)*q'-1) L q' xs X m d C := by
  induction xs generalizing L with
  | nil =>
    refine ⟨1,1,by decide,by decide,?_⟩
    intro t
    have odd : (1+2*t)%2=1 := by omega
    exact ⟨_,0,0,0,Trace.stop long odd (natEntry odd)⟩
  | cons item rest ih =>
    obtain ⟨b,H⟩ := item
    obtain ⟨weak,hl,tail⟩ := legal
    obtain ⟨v,K,vo,kp,carry⟩ := ih tail hl
    obtain ⟨q,M,qo,mp,step⟩ := prepend long weak vo kp
    refine ⟨q,M,qo,mp,?_⟩
    intro t
    obtain ⟨u,head⟩ := step t
    obtain ⟨X,m,d,C,suffix⟩ := carry u
    exact ⟨X,_,_,_,Trace.extend head suffix⟩

end CollatzCharacterBridge.Front4bSwitchedRealization

#print axioms CollatzCharacterBridge.Front4bSwitchedRealization.physical
#print axioms CollatzCharacterBridge.Front4bSwitchedRealization.finiteProgression
