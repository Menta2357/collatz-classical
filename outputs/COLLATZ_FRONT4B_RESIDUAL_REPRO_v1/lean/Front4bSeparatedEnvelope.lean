import Front4bSeparatedRepeat

namespace CollatzCharacterBridge.Front4bSeparatedEnvelope

open Front4bWeakBudget (WeakBook)
open Front4bWeakCofactor (readmissionEquation)
open Front4bPeriodicWeakRepeat (Follows periodDivisions composePeriod)
open Front4bSeparatedRepeat (sameEndingLower)

set_option maxRecDepth 14000
set_option maxHeartbeats 1600000

def scaled (q : Nat) : Nat := 17*q+7

private theorem oneInvoice {q v b : Nat} (branch : b=1 ∨ b=2)
    (book : 2^(4+b)*v=81*q+(2^(b+1)-1)) :
    q<v ∧ 2^(4+b)*scaled v≤81*scaled q ∧
      32*scaled v≤81*scaled q ∧ scaled v≤4*scaled q := by
  rcases branch with rfl | rfl
  · change 32*v=81*q+3 at book
    unfold scaled
    omega
  · change 64*v=81*q+7 at book
    unfold scaled
    omega

def labels (B : Nat → Nat) (s : Nat) : Nat → List (Nat × Nat)
  | 0 => []
  | n+1 => (2,B s)::labels B (s+1) n

private theorem physicalLabels (B J : Nat → Nat)
    (branch : ∀ i, B i=1 ∨ B i=2)
    (path : ∀ i, WeakBook (J i) (J (i+1)) 2 (B i)) (s n : Nat) :
    Follows (J s) (J (s+n)) (labels B s n) := by
  induction n generalizing s with
  | zero => change J s=J (s+0); simp
  | succ n ih =>
    rw [labels]
    refine ⟨by decide,branch s,J (s+1),path s,?_⟩
    rw [show s+(n+1)=s+1+n by omega]
    exact ih (s+1)

private theorem equalLabels (B : Nat → Nat) {s t n : Nat}
    (matchAt : ∀ j<n, B (s+j)=B (t+j)) :
    labels B s n=labels B t n := by
  induction n generalizing s t with
  | zero => rfl
  | succ n ih =>
    have head := matchAt 0 (by omega)
    simp only [Nat.add_zero] at head
    have tail := ih (s:=s+1) (t:=t+1) (fun j hj => by
      simpa only [Nat.add_assoc,Nat.add_comm 1 j] using matchAt (j+1) (by omega))
    rw [labels,labels,head,tail]

private theorem episodesLower (B : Nat → Nat) (branch : ∀ i, B i=1 ∨ B i=2)
    (s n : Nat) : 5*n≤periodDivisions (labels B s n) := by
  induction n generalizing s with
  | zero => simp [labels,periodDivisions]
  | succ n ih =>
    have b := branch s
    have tail := ih (s+1)
    simp only [labels,periodDivisions,Nat.mul_succ]
    omega

private theorem invoice (B J Q : Nat → Nat)
    (path : ∀ i, WeakBook (J i) (J (i+1)) 2 (B i))
    (entries : ∀ i, J i+1=8*Q i) (i : Nat) :
    2^(4+B i)*Q (i+1)=81*Q i+(2^(B i+1)-1) := by
  have h := readmissionEquation (L:=2) (H:=2) (path i) (entries i) (entries (i+1))
  simpa only [show 2+B i+2=4+B i by omega] using h

/-- Integer form of the interval envelope in the frozen paper, with the
exact shortcut clock from the actual intervening weak episodes. -/
theorem intervalEnvelope (B J Q : Nat → Nat)
    (branch : ∀ i, B i=1 ∨ B i=2)
    (path : ∀ i, WeakBook (J i) (J (i+1)) 2 (B i))
    (entries : ∀ i, J i+1=8*Q i) (s n : Nat) :
    2^periodDivisions (labels B s n)*scaled (Q (s+n))≤81^n*scaled (Q s) := by
  induction n generalizing s with
  | zero => simp [labels,periodDivisions]
  | succ n ih =>
    have tail := ih (s+1)
    have head := (oneInvoice (branch s) (invoice B J Q path entries s)).2.1
    rw [labels,periodDivisions,Nat.pow_add 2 (2+2+B s),Nat.pow_succ,
      show s+(n+1)=s+1+n by omega]
    change (2^(4+B s)*2^periodDivisions (labels B (s+1) n))*scaled (Q (s+1+n))
      ≤(81^n*81)*scaled (Q s)
    calc
      _=2^(4+B s)*(2^periodDivisions (labels B (s+1) n)*scaled (Q (s+1+n))) :=
        Nat.mul_assoc _ _ _
      _≤2^(4+B s)*(81^n*scaled (Q (s+1))) := Nat.mul_le_mul_left _ tail
      _=81^n*(2^(4+B s)*scaled (Q (s+1))) := by ac_rfl
      _≤81^n*(81*scaled (Q s)) := Nat.mul_le_mul_left _ head
      _=_ := by rw [Nat.mul_assoc]

/-- A separated repeat imposes an exact inequality on the actual
intervening length and its dyadic clock, even with short runs. -/
theorem collisionEnvelope (B J Q : Nat → Nat)
    (branch : ∀ i, B i=1 ∨ B i=2)
    (path : ∀ i, WeakBook (J i) (J (i+1)) 2 (B i))
    (entries : ∀ i, J i+1=8*Q i) (odd : ∀ i, Q i%2=1)
    {s t n : Nat} (ordered : s<t) (same : ∀ j<n, B (s+j)=B (t+j)) :
    let d := periodDivisions (labels B s n)
    let e := periodDivisions (labels B s (t-s))
    (2:Nat)^(d+1)∣Q t-Q s ∧ (2:Nat)^(d+1)≤Q t-Q s ∧
      2^e*(17*2^(d+1)+scaled (Q s))≤81^(t-s)*scaled (Q s) := by
  have word := equalLabels B same
  have left := (composePeriod (physicalLabels B J branch path s n)).1
  have right := (composePeriod (physicalLabels B J branch path t n)).1
  rw [←word] at right
  have increasing : Q s<Q t := by
    have walk (m : Nat) (low : s≤m) : Q s≤Q m := by
      induction m with
      | zero =>
        have start : s=0 := by omega
        simp [start]
      | succ m ih =>
        by_cases earlier : s≤m
        · exact Nat.le_trans (ih earlier)
            (Nat.le_of_lt (oneInvoice (branch m) (invoice B J Q path entries m)).1)
        · have eq : s=m+1 := by omega
          simp [eq]
    have up := walk (t-1) (by omega)
    have edge := (oneInvoice (branch (t-1)) (invoice B J Q path entries (t-1))).1
    rw [show t-1+1=t by omega] at edge
    exact Nat.lt_of_le_of_lt up edge
  have start : J s<J t := by
    have s0 := entries s
    have t0 := entries t
    omega
  have lower := sameEndingLower (L:=2) (H:=2) start (by omega)
    left right (entries s) (entries t) (odd (s+n)) (odd (t+n))
    (entries (s+n)) (entries (t+n))
  simp only [Nat.add_sub_cancel] at lower
  obtain ⟨dvd,sep⟩ := lower
  have between := intervalEnvelope B J Q branch path entries s (t-s)
  rw [show s+(t-s)=t by omega] at between
  refine ⟨dvd,sep,Nat.le_trans (Nat.mul_le_mul_left _ ?_) between⟩
  unfold scaled
  omega

end CollatzCharacterBridge.Front4bSeparatedEnvelope

#print axioms CollatzCharacterBridge.Front4bSeparatedEnvelope.intervalEnvelope
#print axioms CollatzCharacterBridge.Front4bSeparatedEnvelope.collisionEnvelope
