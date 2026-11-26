import Std

namespace TerrasClock

/-- The shortcut map divides by one factor of two at every step. -/
def shortcut (x : Nat) : Nat :=
  if x%2=1 then (3*x+1)/2 else x/2

/-- Physical shortcut orbit, with index zero at the original input. -/
def orbit (N : Nat) : Nat → Nat
  | 0 => N
  | k+1 => shortcut (orbit N k)

/-- Count odd source states at indices 0, ..., k-1. -/
def oddCount (N : Nat) : Nat → Nat
  | 0 => 0
  | k+1 => oddCount N k + if orbit N k%2=1 then 1 else 0

/-- An odd run starts at an odd entry whose predecessor is even,
    or at an initial odd entry. -/
def startsOddRun (N k : Nat) : Bool :=
  decide (orbit N k%2=1 ∧ (k=0 ∨ orbit N (k-1)%2=0))

/-- One count per maximal odd run in the prefix of length k. A run
    that reaches the end of the prefix contributes its start. -/
def oddRuns (N : Nat) : Nat → Nat
  | 0 => 0
  | k+1 => oddRuns N k + if startsOddRun N k then 1 else 0

/-- The integer additive term in the affine book of the original N. -/
def additive (N : Nat) : Nat → Nat
  | 0 => 0
  | k+1 =>
    if orbit N k%2=1 then 3*additive N k+2^k else additive N k

/-- The potential first crossing is supplied by the caller. -/
def FirstContraction (N τ : Nat) : Prop :=
  3^(oddCount N τ)<2^τ ∧ ∀ k, k<τ → 2^k≤3^(oddCount N k)

theorem orbit_succ (N k : Nat) :
    orbit N (k+1)=shortcut (orbit N k) := rfl

theorem orbit_add (N p q : Nat) :
    orbit N (p+q)=orbit (orbit N p) q := by
  induction q with
  | zero => rfl
  | succ q ih => rw [Nat.add_succ,orbit_succ,orbit_succ,ih]

theorem startsOddRun_iff (N k : Nat) :
    (startsOddRun N k=true) ↔ orbit N k%2=1 ∧ (k=0 ∨ orbit N (k-1)%2=0) := by
  simp [startsOddRun]

theorem oddRuns_succ (N k : Nat) :
    oddRuns N (k+1)=oddRuns N k +
      if orbit N k%2=1 ∧ (k=0 ∨ orbit N (k-1)%2=0) then 1 else 0 := by
  simp [oddRuns,startsOddRun]

theorem oddRuns_le_oddCount (N k : Nat) :
    oddRuns N k≤oddCount N k := by
  induction k with
  | zero => exact Nat.le_refl 0
  | succ k ih =>
    rw [oddRuns_succ]
    change oddRuns N k + (if orbit N k%2=1 ∧ (k=0 ∨ orbit N (k-1)%2=0) then 1 else 0)
        ≤ oddCount N k + (if orbit N k%2=1 then 1 else 0)
    by_cases odd : orbit N k%2=1
    · simp only [odd,if_pos,true_and]
      split <;> omega
    · simp only [odd,if_neg,false_and,Nat.add_zero]
      exact ih

theorem oddCount_add (N p q : Nat) :
    oddCount N (p+q)=oddCount N p+oddCount (orbit N p) q := by
  induction q with
  | zero => rfl
  | succ q ih =>
    change oddCount N (p+q)+(if orbit N (p+q)%2=1 then 1 else 0) =
      oddCount N p+(oddCount (orbit N p) q+(if orbit (orbit N p) q%2=1 then 1 else 0))
    rw [ih,orbit_add N p q,Nat.add_assoc]

theorem shortcut_even {x : Nat} (h : x%2=0) :
    2*shortcut x=x := by
  have even : ¬x%2=1 := by omega
  simp only [shortcut,if_neg even]
  omega

theorem shortcut_odd {x : Nat} (h : x%2=1) :
    2*shortcut x=3*x+1 := by
  simp only [shortcut,if_pos h]
  omega

/-- Exact integer affine book from N at every shortcut clock. -/
theorem exact_book (N k : Nat) :
    2^k*orbit N k=3^(oddCount N k)*N+additive N k := by
  induction k with
  | zero => simp [orbit,oddCount,additive]
  | succ k ih =>
    rcases Nat.mod_two_eq_zero_or_one (orbit N k) with even | odd
    · have not_odd : ¬orbit N k%2=1 := by omega
      calc
        _ = 2^k*(2*shortcut (orbit N k)) := by rw [Nat.pow_succ,orbit_succ,Nat.mul_assoc]
        _ = 2^k*orbit N k := by rw [shortcut_even even]
        _ = _ := by simpa only [oddCount,additive,if_neg not_odd,Nat.add_zero] using ih
    · calc
        _ = 2^k*(2*shortcut (orbit N k)) := by rw [Nat.pow_succ,orbit_succ,Nat.mul_assoc]
        _ = 3*(2^k*orbit N k)+2^k := by
          rw [shortcut_odd odd,Nat.mul_add,Nat.mul_one]
          congr 1
          ac_rfl
        _ = 3*(3^(oddCount N k)*N+additive N k)+2^k := by rw [ih]
        _ = _ := by
          simp only [oddCount,additive,if_pos odd,Nat.pow_succ,Nat.mul_add]
          ac_rfl

/-- Prefix and tail books compose with their own clocks and costs. -/
theorem additive_add (N p q : Nat) :
    additive N (p+q)=3^(oddCount (orbit N p) q)*additive N p+
      2^p*additive (orbit N p) q := by
  have scaled : 2^(p+q)*orbit N (p+q)=
      3^(oddCount (orbit N p) q)*(2^p*orbit N p)+2^p*additive (orbit N p) q := by
    calc
      _ = 2^p*(2^q*orbit (orbit N p) q) := by rw [Nat.pow_add,orbit_add,Nat.mul_assoc]
      _ = _ := by rw [exact_book,Nat.mul_add]; ac_rfl
  rw [exact_book N (p+q),exact_book N p,oddCount_add,Nat.pow_add] at scaled
  apply Nat.add_left_cancel (n := (3^oddCount N p*3^oddCount (orbit N p) q)*N)
  calc
    _ = 3^(oddCount (orbit N p) q)*
        (3^(oddCount N p)*N+additive N p)+2^p*additive (orbit N p) q := scaled
    _ = _ := by rw [Nat.mul_add]; ac_rfl

/-- Every clock whose coefficient is at least one is above the source. -/
theorem no_descent_of_coefficient {N k : Nat}
    (h : 2^k≤3^(oddCount N k)) : N≤orbit N k := by
  have coeff := Nat.mul_le_mul_right N h
  have scaled : 2^k*N≤2^k*orbit N k := by
    rw [exact_book]
    exact Nat.le_trans coeff (Nat.le_add_right _ _)
  exact Nat.le_of_mul_le_mul_left scaled (Nat.pow_pos (by decide))

theorem prior_no_descent {N τ k : Nat} (h : FirstContraction N τ) (hk : k<τ) :
    N≤orbit N k :=
  no_descent_of_coefficient (h.2 k hk)

theorem first_contraction_pos {N τ : Nat} (h : FirstContraction N τ) : 0<τ := by
  cases τ with
  | zero => simp [FirstContraction,oddCount] at h
  | succ τ => exact Nat.succ_pos _

/-- The final source state is even at a first contraction. The even
    stretch containing this step can extend beyond the crossing. -/
theorem first_contraction_last_even {N k : Nat} (h : FirstContraction N (k+1)) :
    orbit N k%2=0 := by
  rcases Nat.mod_two_eq_zero_or_one (orbit N k) with even | odd
  · exact even
  · have prior := h.2 k (Nat.lt_succ_self k)
    have after : 2^(k+1)≤3^(oddCount N (k+1)) := by
      simp only [oddCount,if_pos odd,Nat.pow_succ]
      calc
        _ ≤ 3^(oddCount N k)*2 := Nat.mul_le_mul_right 2 prior
        _ ≤ _ := Nat.mul_le_mul_left _ (by decide : 2≤3)
    exact ((Nat.not_le_of_gt h.1) after).elim

end TerrasClock
