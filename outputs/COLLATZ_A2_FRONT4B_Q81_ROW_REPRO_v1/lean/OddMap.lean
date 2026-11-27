import Std

namespace CollatzCharacterBridge

/-- Strip every factor of two. The zero branch makes this total. -/
def oddPart (n : Nat) : Nat :=
  if h : 0 < n ∧ n % 2 = 0 then oddPart (n / 2) else n
termination_by n
decreasing_by omega

theorem oddPart_of_odd {n : Nat} (h : n % 2 = 1) : oddPart n = n := by
  rw [oddPart, dif_neg]
  omega

theorem oddPart_of_even {n : Nat} (h : 0 < n ∧ n % 2 = 0) :
    oddPart n = oddPart (n / 2) := by
  rw [oddPart, dif_pos h]

theorem oddPart_pos_and_odd (n : Nat) (hn : 0 < n) :
    0 < oddPart n ∧ oddPart n % 2 = 1 := by
  induction n using Nat.strongRecOn with
  | ind n ih =>
    by_cases h : n % 2 = 0
    · rw [oddPart_of_even ⟨hn,h⟩]
      exact ih (n / 2) (by omega) (by omega)
    · rw [oddPart_of_odd (by omega)]
      exact ⟨hn, by omega⟩

theorem oddPart_double (n : Nat) : oddPart (2*n) = oddPart n := by
  by_cases h : n = 0
  · simp [h]
  · rw [oddPart_of_even (by omega : 0 < 2*n ∧ (2*n)%2 = 0)]
    have hd : (2*n)/2 = n := by omega
    rw [hd]

theorem oddPart_quadruple (n : Nat) : oddPart (4*n) = oddPart n := by
  have he : 4*n = 2*(2*n) := by omega
  rw [he, oddPart_double, oddPart_double]

/-- Odd-to-odd Collatz step on the positive odd integers. -/
def step (x : Nat) : Nat := oddPart (3*x+1)

theorem step_pos (x : Nat) : 0 < step x :=
  (oddPart_pos_and_odd (3*x+1) (by omega)).1

theorem step_odd (x : Nat) : step x % 2 = 1 :=
  (oddPart_pos_and_odd (3*x+1) (by omega)).2

theorem step_mul_two {x : Nat} (h : x % 4 = 3) : step x * 2 = 3*x+1 := by
  unfold step
  have hh : 3*x+1 = 2*((3*x+1)/2) := by omega
  have ho : ((3*x+1)/2)%2 = 1 := by omega
  have he : oddPart (3*x+1) = (3*x+1)/2 :=
    (congrArg oddPart hh).trans ((oddPart_double _).trans (oddPart_of_odd ho))
  rw [he]
  omega

theorem step_mul_four {x : Nat} (h : x % 8 = 1) : step x * 4 = 3*x+1 := by
  unfold step
  have hh : 3*x+1 = 4*((3*x+1)/4) := by omega
  have ho : ((3*x+1)/4)%2 = 1 := by omega
  have he : oddPart (3*x+1) = (3*x+1)/4 :=
    (congrArg oddPart hh).trans ((oddPart_quadruple _).trans (oddPart_of_odd ho))
  rw [he]
  omega

def orbit (x : Nat) : Nat → Nat
  | 0 => x
  | j+1 => step (orbit x j)

theorem orbit_add (x i j : Nat) : orbit x (i+j) = orbit (orbit x i) j := by
  induction j with
  | zero => rfl
  | succ j ih => exact congrArg step ih

theorem orbit_pos (x : Nat) (h : 0 < x) (j : Nat) : 0 < orbit x j := by
  cases j with
  | zero => exact h
  | succ j => exact step_pos _

theorem orbit_odd (x : Nat) (h : x % 2 = 1) (j : Nat) : orbit x j % 2 = 1 := by
  cases j with
  | zero => exact h
  | succ j => exact step_odd _

theorem capture {N x : Nat} (hx : 1 < x) (hN : x < 4*N) (hr : x % 8 = 5) :
    let w := (x-1)/4
    0 < w ∧ w % 2 = 1 ∧ w < N ∧ step w = step x := by
  dsimp
  refine ⟨by omega, by omega, by omega, ?_⟩
  unfold step
  have he : 3*x+1 = 4*(3*((x-1)/4)+1) := by omega
  exact ((congrArg oddPart he).trans (oddPart_quadruple _)).symm

/-- The ordinary map with one operation per step. -/
def rawStep (n : Nat) : Nat := if n % 2 = 0 then n / 2 else 3*n+1

def rawOrbit (x : Nat) : Nat → Nat
  | 0 => x
  | j+1 => rawStep (rawOrbit x j)

theorem rawOrbit_add (x i j : Nat) : rawOrbit x (i+j) = rawOrbit (rawOrbit x i) j := by
  induction j with
  | zero => rfl
  | succ j ih => exact congrArg rawStep ih

theorem rawOrbit_pos (x : Nat) (hx : 0 < x) (j : Nat) : 0 < rawOrbit x j := by
  induction j with
  | zero => exact hx
  | succ j ih =>
    change 0 < rawStep (rawOrbit x j)
    unfold rawStep
    split <;> omega

theorem oddPart_raw_reaches (x : Nat) (hx : 0 < x) : ∃ k, rawOrbit x k = oddPart x := by
  induction x using Nat.strongRecOn with
  | ind x ih =>
    by_cases he : x % 2 = 0
    · obtain ⟨k, hk⟩ := ih (x / 2) (by omega) (by omega)
      refine ⟨1+k, ?_⟩
      rw [rawOrbit_add, oddPart_of_even ⟨hx, he⟩]
      simpa only [rawOrbit, rawStep, if_pos he] using hk
    · refine ⟨0, ?_⟩
      change x = oddPart x
      exact (oddPart_of_odd (by omega)).symm

theorem step_raw_reaches (x : Nat) (ho : x % 2 = 1) : ∃ k, rawOrbit x k = step x := by
  obtain ⟨k, hk⟩ := oddPart_raw_reaches (3*x+1) (by omega)
  refine ⟨1+k, ?_⟩
  rw [rawOrbit_add]
  have hn : ¬ x % 2 = 0 := by omega
  simpa only [rawOrbit, rawStep, if_neg hn, step] using hk

theorem orbit_raw_reaches (x : Nat) (ho : x % 2 = 1) (j : Nat) :
    ∃ k, rawOrbit x k = orbit x j := by
  induction j with
  | zero => exact ⟨0, rfl⟩
  | succ j ih =>
    obtain ⟨k, hk⟩ := ih
    obtain ⟨l, hl⟩ := step_raw_reaches (orbit x j) (orbit_odd x ho j)
    exact ⟨k+l, (rawOrbit_add x k l).trans (by rw [hk]; exact hl)⟩

theorem rawOrbit_oddPart_reaches (x : Nat) (hx : 0 < x) (j : Nat) :
    ∃ k, orbit (oddPart x) k = oddPart (rawOrbit x j) := by
  induction j with
  | zero => exact ⟨0, rfl⟩
  | succ j ih =>
    obtain ⟨k, hk⟩ := ih
    have hz := rawOrbit_pos x hx j
    by_cases he : rawOrbit x j % 2 = 0
    · refine ⟨k, ?_⟩
      change orbit (oddPart x) k = oddPart (rawStep (rawOrbit x j))
      rw [hk, rawStep, if_pos he, ← oddPart_of_even ⟨hz, he⟩]
    · refine ⟨k+1, ?_⟩
      change step (orbit (oddPart x) k) = oddPart (rawStep (rawOrbit x j))
      have ho : rawOrbit x j % 2 = 1 := by omega
      rw [hk, oddPart_of_odd ho, rawStep, if_neg he]
      rfl

/-- Acceleration preserves and reflects reaching 1, with no bound on either clock. -/
theorem reaches_one_iff_raw_reaches_one (x : Nat) (hx : 0 < x) :
    (∃ j, orbit (oddPart x) j = 1) ↔ (∃ k, rawOrbit x k = 1) := by
  constructor
  · intro ⟨j, hj⟩
    obtain ⟨a, ha⟩ := oddPart_raw_reaches x hx
    obtain ⟨b, hb⟩ := orbit_raw_reaches (oddPart x) (oddPart_pos_and_odd x hx).2 j
    refine ⟨a+b, ?_⟩
    rw [rawOrbit_add, ha, hb, hj]
  · intro ⟨k, hk⟩
    obtain ⟨j, hj⟩ := rawOrbit_oddPart_reaches x hx k
    refine ⟨j, ?_⟩
    rw [hj, hk, oddPart_of_odd (by decide : 1 % 2 = 1)]

#print axioms oddPart_of_odd
#print axioms oddPart_of_even
#print axioms oddPart_pos_and_odd
#print axioms oddPart_double
#print axioms oddPart_quadruple
#print axioms step_pos
#print axioms step_odd
#print axioms step_mul_two
#print axioms step_mul_four
#print axioms orbit_add
#print axioms orbit_pos
#print axioms orbit_odd
#print axioms capture
#print axioms rawOrbit_add
#print axioms rawOrbit_pos
#print axioms oddPart_raw_reaches
#print axioms step_raw_reaches
#print axioms orbit_raw_reaches
#print axioms rawOrbit_oddPart_reaches
#print axioms reaches_one_iff_raw_reaches_one

end CollatzCharacterBridge
