import Front4bPeriodicWeakRepeat

namespace CollatzCharacterBridge.Front4bSeparatedRepeat

open StagedCylinder (Segment compose)
open Front4bPeriodicWeakRepeat (WeakEpisode Follows periodReturns periodDivisions periodCost composePeriod)

set_option maxRecDepth 14000
set_option maxHeartbeats 1600000

private theorem oddThree (r : Nat) : 3^r%2=1 := by
  induction r with
  | zero => decide
  | succ r ih => rw [Nat.pow_succ,Nat.mul_mod,ih]

private theorem evenTwo {k : Nat} (positive : 0<k) : 2^k%2=0 := by
  cases k with
  | zero => omega
  | succ k => rw [Nat.pow_succ,Nat.mul_mod]; simp

private theorem cancelOddFactor {a x k v : Nat} (odd : a%2=1) (book : a*x=2^k*v) :
    ∃ u, x=2^k*u ∧ a*u=v := by
  induction k generalizing x with
  | zero => exact ⟨x,by simp,by simpa using book⟩
  | succ k ih =>
    rw [Nat.pow_succ,show (2:Nat)^k*2*v=2*(2^k*v) by ac_rfl] at book
    have residue := congrArg (fun n : Nat => n%2) book
    change (a*x)%2=(2*(2^k*v))%2 at residue
    have even : x%2=0 := by simpa [Nat.mul_mod,odd] using residue
    have half : x=2*(x/2) := by omega
    have smaller : a*(x/2)=2^k*v := by
      apply Nat.mul_left_cancel (by decide : 0<2)
      calc
        _=a*(2*(x/2)) := by ac_rfl
        _=a*x := by rw [←half]
        _=_ := book
    obtain ⟨u,shape,atEnd⟩ := ih smaller
    refine ⟨u,?_,atEnd⟩
    calc
      x=2*(x/2) := half
      _=2*(2^k*u) := by rw [shape]
      _=_ := by rw [Nat.pow_succ]; ac_rfl

private theorem sameScale {x y a p q : Nat} (xp : x+1=a*p) (yq : y+1=a*q) :
    y-x=a*(q-p) := by
  rw [Nat.mul_sub_left_distrib,←xp,←yq]
  omega

private theorem cofactorLess {x y a p q : Nat} (order : x<y)
    (xp : x+1=a*p) (yq : y+1=a*q) : p<q := by
  have h : a*p<a*q := by omega
  exact Nat.lt_of_mul_lt_mul_left h

/-- The first unequal terminal run length fixes the exact two-part of
the endpoint difference. Equal lengths supply at least one extra factor. -/
private theorem endpointDifference {x y H K p q : Nat} (order : x<y)
    (pOdd : p%2=1) (qOdd : q%2=1)
    (first : x+1=2^(H+1)*p) (second : y+1=2^(K+1)*q) :
    ∃ t, y-x=2^(min H K+1)*t ∧ t%2=(if H=K then 0 else 1) := by
  rcases Nat.lt_trichotomy H K with less | equal | more
  · let a := K-H
    have ex : K+1=(H+1)+a := by dsimp only [a]; omega
    have second' : y+1=2^(H+1)*(2^a*q) := by
      rw [second,ex,Nat.pow_add,Nat.mul_assoc]
    have cmp := cofactorLess order first second'
    have even : (2^a*q)%2=0 := by
      rw [Nat.mul_mod,evenTwo (by dsimp only [a]; omega)]; simp
    rw [Nat.min_eq_left (Nat.le_of_lt less),if_neg (by omega : H≠K)]
    exact ⟨(2^a*q)-p,sameScale first second',by omega⟩
  · subst K
    have cmp := cofactorLess order first second
    rw [Nat.min_self,if_pos rfl]
    exact ⟨q-p,sameScale first second,by omega⟩
  · let a := H-K
    have ex : H+1=(K+1)+a := by dsimp only [a]; omega
    have first' : x+1=2^(K+1)*(2^a*p) := by
      rw [first,ex,Nat.pow_add,Nat.mul_assoc]
    have cmp := cofactorLess order first' second
    have even : (2^a*p)%2=0 := by
      rw [Nat.mul_mod,evenTwo (by dsimp only [a]; omega)]; simp
    rw [Nat.min_eq_right (Nat.le_of_lt more),if_neg (by omega : H≠K)]
    exact ⟨q-(2^a*p),sameScale first' second,by omega⟩

/-- Equal physical words cancel their common additive. This gives an
exact dyadic charge for unequal following lengths, and at least one
extra unit when the following lengths coincide. -/
theorem cofactorSeparation {J W X Y r d B L H K p q u v : Nat}
    (later : J<W) (clock : L≤d+min H K)
    (first : Segment J X r d B) (second : Segment W Y r d B)
    (base1 : J+1=2^(L+1)*p) (base2 : W+1=2^(L+1)*q)
    (uOdd : u%2=1) (vOdd : v%2=1)
    (dest1 : X+1=2^(H+1)*u) (dest2 : Y+1=2^(K+1)*v) :
    let e := d+min H K-L
    p<q ∧ ∃ w, q-p=2^e*w ∧ w%2=(if H=K then 0 else 1) := by
  let e := d+min H K-L
  have endings : X<Y := by
    have h := Nat.add_lt_add_right (Nat.mul_lt_mul_of_pos_left later
      (Nat.pow_pos (by decide : 0<3) : 0<3^r)) B
    rw [←first.book,←second.book] at h
    exact Nat.lt_of_mul_lt_mul_left h
  obtain ⟨t,gapEnd,tParity⟩ := endpointDifference endings uOdd vOdd dest1 dest2
  have bookDiff : 2^d*(Y-X)=3^r*(W-J) := by
    rw [Nat.mul_sub_left_distrib,Nat.mul_sub_left_distrib,first.book,second.book,
      Nat.add_sub_add_right]
  have full : d+(min H K+1)=(L+1)+e := by dsimp only [e]; omega
  have pay : 3^r*(q-p)=2^e*t := by
    apply Nat.mul_left_cancel (Nat.pow_pos (by decide : 0<2) : 0<2^(L+1))
    calc
      _=3^r*(2^(L+1)*(q-p)) := by ac_rfl
      _=2^d*(Y-X) := by rw [←sameScale base1 base2,bookDiff]
      _=(2^d*2^(min H K+1))*t := by rw [gapEnd,Nat.mul_assoc]
      _=_ := by rw [←Nat.pow_add,full,Nat.pow_add,Nat.mul_assoc]
  obtain ⟨w,wGap,prod⟩ := cancelOddFactor (oddThree r) pay
  have modEq := congrArg (fun z : Nat => z%2) prod
  change (3^r*w)%2=t%2 at modEq
  have wParity : w%2=t%2 := by simpa [Nat.mul_mod,oddThree] using modEq
  exact ⟨cofactorLess later base1 base2,w,wGap,wParity.trans tParity⟩

private theorem weakWordPositive {word : List WeakEpisode} (nonempty : word≠[]) :
    0<periodCost word := by
  cases word with
  | nil => contradiction
  | cons episode rest =>
    obtain ⟨L,b⟩ := episode
    have p : 2^(L+1)<3^(L+2) :=
      Nat.lt_of_le_of_lt (Nat.pow_le_pow_left (by decide : 2≤3) _)
        ((Nat.pow_lt_pow_iff_right (by decide : 1<(3:Nat))).2 (by omega))
    have product := Nat.mul_pos (Nat.pow_pos (by decide : 0<3) : 0<3^periodReturns rest)
      (show 0<3^(L+2)-2^(L+1) by omega)
    simp only [periodCost]
    omega

private theorem strictlyAfter {word : List WeakEpisode} {x y : Nat} (nonempty : word≠[])
    (path : Follows x y word) : x<y := by
  obtain ⟨book,scale⟩ := composePeriod path
  have start := Nat.mul_le_mul_right x scale
  have p := weakWordPositive nonempty
  have step := book.book
  have paid : 2^periodDivisions word*x<2^periodDivisions word*y := by omega
  exact Nat.lt_of_mul_lt_mul_left paid

/-- The two occurrences belong to one original trajectory. The
intervening nonempty physical word makes the cofactor separation strict,
and both original endpoint books are returned. -/
theorem repeatedWord {N j S C J W X Y L b H K p q u v : Nat}
    {rest gap : List WeakEpisode} (nonempty : gap≠[])
    (origin : Segment N J j S C)
    (between : Follows J W gap)
    (first : Follows J X ((L,b)::rest)) (second : Follows W Y ((L,b)::rest))
    (base1 : J+1=2^(L+1)*p) (base2 : W+1=2^(L+1)*q)
    (uOdd : u%2=1) (vOdd : v%2=1)
    (dest1 : X+1=2^(H+1)*u) (dest2 : Y+1=2^(K+1)*v) :
    let word := (L,b)::rest
    let r := periodReturns word
    let d := periodDivisions word
    let B := periodCost word
    let rg := periodReturns gap
    let dg := periodDivisions gap
    let Bg := periodCost gap
    let e := d+min H K-L
    (p<q ∧ ∃ w, q-p=2^e*w ∧ w%2=(if H=K then 0 else 1)) ∧
    Segment N X (j+r) (S+d) (3^r*C+2^S*B) ∧
    Segment N Y (j+rg+r) (S+dg+d) (3^r*(3^rg*C+2^S*Bg)+2^(S+dg)*B) := by
  have clock : L≤periodDivisions ((L,b)::rest)+min H K := by
    simp only [periodDivisions]
    omega
  have left := (composePeriod first).1
  have right := (composePeriod second).1
  have middle := (composePeriod between).1
  exact ⟨cofactorSeparation (strictlyAfter nonempty between) clock left right base1 base2
    uOdd vOdd dest1 dest2,compose origin left,compose (compose origin middle) right⟩

/-- A same-length ending supplies the additional parity bit. For L=H=2
this gives precisely the separated-repeat lower bound in the paper. -/
theorem sameEndingLower {J W X Y r d B L H p q u v : Nat}
    (later : J<W) (clock : L≤d+H)
    (first : Segment J X r d B) (second : Segment W Y r d B)
    (base1 : J+1=2^(L+1)*p) (base2 : W+1=2^(L+1)*q)
    (uOdd : u%2=1) (vOdd : v%2=1)
    (dest1 : X+1=2^(H+1)*u) (dest2 : Y+1=2^(H+1)*v) :
    let e := d+H-L+1
    2^e∣q-p ∧ 2^e≤q-p := by
  have h := cofactorSeparation later (H:=H) (K:=H) (by simpa using clock)
    first second base1 base2 uOdd vOdd dest1 dest2
  dsimp only at h
  simp only [Nat.min_self,if_pos True.intro] at h
  obtain ⟨lt,w,shape,even⟩ := h
  have more : (2:Nat)^(d+H-L+1)∣q-p := by
    refine ⟨w/2,?_⟩
    calc
      q-p=2^(d+H-L)*w := shape
      _=2^(d+H-L)*(2*(w/2)) := congrArg (fun t : Nat => 2^(d+H-L)*t)
        (show w=2*(w/2) by omega)
      _=2^(d+H-L+1)*(w/2) := by rw [Nat.pow_succ,Nat.mul_assoc]
  exact ⟨more,Nat.le_of_dvd (by omega) more⟩

end CollatzCharacterBridge.Front4bSeparatedRepeat

#print axioms CollatzCharacterBridge.Front4bSeparatedRepeat.cofactorSeparation
#print axioms CollatzCharacterBridge.Front4bSeparatedRepeat.repeatedWord
#print axioms CollatzCharacterBridge.Front4bSeparatedRepeat.sameEndingLower
