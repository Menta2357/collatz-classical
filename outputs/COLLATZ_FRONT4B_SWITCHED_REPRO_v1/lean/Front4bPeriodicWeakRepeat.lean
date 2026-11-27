import Front4bFixedWeakRepeat

namespace CollatzCharacterBridge.Front4bPeriodicWeakRepeat

open StagedCylinder (Segment compose)
open Front4bWeakBudget (WeakBook)

set_option maxRecDepth 14000
set_option maxHeartbeats 1500000

/-- Reserve in the original, unshifted checkpoint coordinate. -/
def reserve (r s B J : Nat) : Nat := (3^r-2^s)*J+B

private theorem cancelPowTwo {a q s : Nat} (odd : a%2=1) (multiple : 2^s∣a*q) :
    2^s∣q := by
  induction s generalizing q with
  | zero => simp
  | succ s ih =>
    obtain ⟨v,eq⟩ := multiple
    rw [Nat.pow_succ,show (2:Nat)^s*2*v=2*(2^s*v) by ac_rfl] at eq
    have parity := congrArg (fun x : Nat => x%2) eq
    change (a*q)%2=(2*(2^s*v))%2 at parity
    rw [Nat.mul_mod a q 2,odd] at parity
    simp at parity
    have half : q=2*(q/2) := by omega
    have next : a*(q/2)=2^s*v := by
      apply Nat.eq_of_mul_eq_mul_left (by decide : 0<2)
      calc
        _ = a*(2*(q/2)) := by ac_rfl
        _ = _ := by rw [←half]; exact eq
    obtain ⟨w,hw⟩ := ih ⟨v,next⟩
    refine ⟨w,?_⟩
    calc
      q = 2*(q/2) := half
      _ = 2*(2^s*w) := by rw [hw]
      _ = 2^(s+1)*w := by rw [Nat.pow_succ]; ac_rfl

/-- A positive homogeneous resource for the affine return of an entire
physical period, retaining its full additive B. -/
theorem reserveStep {x y r s B : Nat} (scale : 2^s≤3^r) (path : Segment x y r s B) :
    2^s*reserve r s B y=3^r*reserve r s B x := by
  let c := 3^r-2^s
  change 2^s*(c*y+B)=3^r*(c*x+B)
  calc
    _ = c*(2^s*y)+2^s*B := by rw [Nat.mul_add]; ac_rfl
    _ = c*(3^r*x+B)+2^s*B := by rw [path.book]
    _ = 3^r*(c*x)+(c+2^s)*B := by simp only [Nat.mul_add,Nat.add_mul]; ac_rfl
    _ = _ := by rw [show c+2^s=3^r from Nat.sub_add_cancel scale,Nat.mul_add]

def historyCost (r s B S C : Nat) : Nat → Nat
  | 0 => C
  | i+1 => 3^r*historyCost r s B S C i+2^(S+s*i)*B

/-- Repeating any one fixed affine period consumes s dyadic units per
copy. The last certificate still has original source N and the same book. -/
theorem affinePhysicalRepeat {N j S C r s B n : Nat} (scale : 2^s≤3^r) (positive : 0<B)
    (J : Nat → Nat) (origin : Segment N (J 0) j S C)
    (repeats : ∀ i<n, Segment (J i) (J (i+1)) r s B) :
    2^(s*n)∣reserve r s B (J 0) ∧ 2^(s*n)≤reserve r s B (J 0) ∧
      Segment N (J n) (j+r*n) (S+s*n) (historyCost r s B S C n) := by
  have telescope (m : Nat) (bound : m≤n) :
      (2^s)^m*reserve r s B (J m)=(3^r)^m*reserve r s B (J 0) := by
    induction m with
    | zero => simp
    | succ m ih =>
      have pay := reserveStep scale (repeats m (by omega))
      calc
        _ = (2^s)^m*(2^s*reserve r s B (J (m+1))) := by rw [Nat.pow_succ,Nat.mul_assoc]
        _ = (2^s)^m*(3^r*reserve r s B (J m)) := by rw [pay]
        _ = 3^r*((2^s)^m*reserve r s B (J m)) := by ac_rfl
        _ = _ := by rw [ih (by omega),Nat.pow_succ]; ac_rfl
  have odd3 (m : Nat) : (3:Nat)^m%2=1 := by
    induction m with
    | zero => decide
    | succ m ih => rw [Nat.pow_succ,Nat.mul_mod,ih]
  have divides : 2^(s*n)∣reserve r s B (J 0) := by
    apply cancelPowTwo (a:=(3^r)^n) (by rw [←Nat.pow_mul]; exact odd3 _)
    refine ⟨reserve r s B (J n),?_⟩
    rw [Nat.pow_mul]
    exact (telescope n (Nat.le_refl _)).symm
  have p : 0<reserve r s B (J 0) := by unfold reserve; omega
  have carry (m : Nat) (bound : m≤n) :
      Segment N (J m) (j+r*m) (S+s*m) (historyCost r s B S C m) := by
    induction m with
    | zero => simpa [historyCost] using origin
    | succ m ih =>
      have h := compose (ih (by omega)) (repeats m (by omega))
      rw [Nat.mul_succ r m,Nat.mul_succ s m,←Nat.add_assoc,←Nat.add_assoc]
      exact h
  exact ⟨divides,Nat.le_of_dvd p divides,carry n (Nat.le_refl _)⟩

abbrev WeakEpisode := Nat × Nat

def periodReturns : List WeakEpisode → Nat
  | [] => 0
  | (L,_)::rest => (L+2)+periodReturns rest

def periodDivisions : List WeakEpisode → Nat
  | [] => 0
  | (L,b)::rest => (L+2+b)+periodDivisions rest

def periodCost : List WeakEpisode → Nat
  | [] => 0
  | (L,b)::rest => 3^periodReturns rest*(3^(L+2)-2^(L+1))+2^(L+2+b)*periodCost rest

/-- A fixed finite list of actual weak episode books. Its types force the
same ordered episode labels and exact books at every full copy. -/
def Follows (x y : Nat) : List WeakEpisode → Prop
  | [] => x=y
  | (L,b)::rest => 2≤L ∧ (b=1 ∨ b=2) ∧ ∃ z, WeakBook x z L b ∧ Follows z y rest

private theorem weakExpands {L b : Nat} (length : 2≤L) (branch : b=1 ∨ b=2) :
    2^(L+2+b)<3^(L+2) := by
  have induct (m : Nat) : 2^(m+6)<3^(m+4) := by
    induction m with
    | zero => decide
    | succ m ih =>
      rw [show m+1+6=(m+6)+1 by omega,show m+1+4=(m+4)+1 by omega,
        Nat.pow_succ 2 (m+6),Nat.pow_succ 3 (m+4)]
      omega
  have h := induct (L-2)
  have two : 2^(L+2+b)≤2^((L-2)+6) := Nat.pow_le_pow_right (by decide) (by omega)
  apply Nat.lt_of_le_of_lt two
  rwa [show L-2+4=L+2 by omega] at h

private theorem weakCostPositive (L : Nat) : 0<3^(L+2)-2^(L+1) := by
  have le : 2^(L+1)≤3^(L+1) := Nat.pow_le_pow_left (by decide) _
  have lt : (3:Nat)^(L+1)<3^(L+2) := (Nat.pow_lt_pow_iff_right (by decide)).2 (by omega)
  omega

/-- Compose a mixed period by folding its exact additive ledger. -/
theorem composePeriod {p : List WeakEpisode} {x y : Nat} (history : Follows x y p) :
    Segment x y (periodReturns p) (periodDivisions p) (periodCost p) ∧
      2^periodDivisions p≤3^periodReturns p := by
  induction p generalizing x y with
  | nil =>
    change x=y at history
    subst y
    exact ⟨⟨A2Header.Physical.refl _,by simp [periodReturns,periodDivisions,periodCost]⟩,by decide⟩
  | cons episode rest ih =>
    rcases episode with ⟨L,b⟩
    obtain ⟨length,branch,z,head,tail⟩ := history
    obtain ⟨right,scale⟩ := ih tail
    refine ⟨compose head right,?_⟩
    rw [periodDivisions,periodReturns,Nat.pow_add 2 (L+2+b),Nat.pow_add 3 (L+2)]
    exact Nat.mul_le_mul (Nat.le_of_lt (weakExpands length branch)) scale

private theorem positivePeriod {p : List WeakEpisode} (nonempty : p≠[]) : 0<periodDivisions p ∧ 0<periodCost p := by
  cases p with
  | nil => contradiction
  | cons episode rest =>
    rcases episode with ⟨L,b⟩
    constructor
    · simp only [periodDivisions]; omega
    · have cap := Nat.mul_pos (Nat.pow_pos (by decide) : 0<3^periodReturns rest)
          (weakCostPositive L)
      simp only [periodCost]
      omega

theorem periodicPhysicalRepeat {p : List WeakEpisode} {N j S C n : Nat}
    (nonempty : p≠[]) (J : Nat → Nat) (origin : Segment N (J 0) j S C)
    (periods : ∀ i<n, Follows (J i) (J (i+1)) p) :
    2^(periodDivisions p*n)∣reserve (periodReturns p) (periodDivisions p) (periodCost p) (J 0) ∧
    2^(periodDivisions p*n)≤reserve (periodReturns p) (periodDivisions p) (periodCost p) (J 0) ∧
    Segment N (J n) (j+periodReturns p*n) (S+periodDivisions p*n)
      (historyCost (periodReturns p) (periodDivisions p) (periodCost p) S C n) := by
  by_cases h : n=0
  · subst n
    have pos : 1≤reserve (periodReturns p) (periodDivisions p) (periodCost p) (J 0) := by
      have cost := (positivePeriod nonempty).2
      unfold reserve
      omega
    simpa [historyCost] using And.intro pos origin
  · exact affinePhysicalRepeat (composePeriod (periods 0 (by omega))).2
      (positivePeriod nonempty).2 J origin
      (fun i hi => (composePeriod (periods i hi)).1)

/-- Excludes an infinite repetition of any fixed nonempty mixed period
starting at one fixed checkpoint. -/
theorem noInfinitePeriodicRepeat {p : List WeakEpisode} {N j S C : Nat}
    (nonempty : p≠[]) (J : Nat → Nat) (origin : Segment N (J 0) j S C)
    (periods : ∀ i, Follows (J i) (J (i+1)) p) : False := by
  let b := reserve (periodReturns p) (periodDivisions p) (periodCost p) (J 0)
  have s : 1≤periodDivisions p := (positivePeriod nonempty).1
  have lower : b≤periodDivisions p*b := by
    simpa only [Nat.one_mul] using Nat.mul_le_mul_right b s
  have up := (periodicPhysicalRepeat (n:=b) nonempty J origin (fun i _ => periods i)).2.1
  change 2^(periodDivisions p*b)≤b at up
  have grows (m : Nat) : m<2^m := by
    induction m with
    | zero => decide
    | succ m ih =>
      rw [Nat.pow_succ]
      have positive : 0<(2:Nat)^m := Nat.pow_pos (by decide)
      omega
  have bad := Nat.lt_of_lt_of_le (grows b) (Nat.le_trans (Nat.pow_le_pow_right (by decide : 0<2) lower) up)
  exact (Nat.lt_irrefl b) bad

end CollatzCharacterBridge.Front4bPeriodicWeakRepeat

#print axioms CollatzCharacterBridge.Front4bPeriodicWeakRepeat.reserveStep
#print axioms CollatzCharacterBridge.Front4bPeriodicWeakRepeat.affinePhysicalRepeat
#print axioms CollatzCharacterBridge.Front4bPeriodicWeakRepeat.composePeriod
#print axioms CollatzCharacterBridge.Front4bPeriodicWeakRepeat.periodicPhysicalRepeat
#print axioms CollatzCharacterBridge.Front4bPeriodicWeakRepeat.noInfinitePeriodicRepeat
