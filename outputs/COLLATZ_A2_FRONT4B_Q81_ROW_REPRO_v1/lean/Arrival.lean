import OddMap

namespace CollatzCharacterBridge

/-- The actual odd-part recursion keeps track of a power of two witness. -/
theorem oddPart_factor (n : Nat) (hn : 0 < n) :
    ∃ a : Nat, n = 2^a * oddPart n := by
  induction n using Nat.strongRecOn with
  | ind n ih =>
    by_cases h : n % 2 = 0
    · obtain ⟨a, ha⟩ := ih (n/2) (by omega) (by omega)
      refine ⟨a+1, ?_⟩
      rw [oddPart_of_even ⟨hn, h⟩, Nat.pow_succ, Nat.mul_comm (2^a) 2,
        Nat.mul_assoc, ← ha]
      omega
    · refine ⟨0, ?_⟩
      rw [oddPart_of_odd (by omega), Nat.pow_zero, Nat.one_mul]

/-- Exact test for a smaller positive odd predecessor at an arrival at or
above the starting seed. There is no restriction on the departure height. -/
theorem smaller_source_iff_arrival {N y : Nat} (ho : y % 2 = 1) (hN : N ≤ y) :
    (∃ w, 0 < w ∧ w % 2 = 1 ∧ w < N ∧ step w = y) ↔
      y % 3 = 2 ∧ 2*y < 3*N+1 := by
  constructor
  · intro ⟨w, hwpos, hwo, hwN, hwy⟩
    obtain ⟨a, ha⟩ := oddPart_factor (3*w+1) (by omega)
    change oddPart (3*w+1) = y at hwy
    rw [hwy] at ha
    cases a with
    | zero => simp at ha; omega
    | succ a =>
      cases a with
      | zero => have ht : 3*w+1 = 2*y := ha; omega
      | succ a =>
        have hp : 4 ≤ (2 : Nat) ^ (a+1+1) := by
          exact Nat.pow_le_pow_right (by omega : 0 < (2 : Nat)) (by omega : 2 ≤ a+1+1)
        have hb := Nat.mul_le_mul_right y hp
        rw [← ha] at hb
        omega
  · rintro ⟨h3, hlt⟩
    let w := (2*y-1)/3
    have h2 : 3*w+1 = 2*y := by dsimp [w]; omega
    have h4 : w % 4 = 3 := by omega
    have hs := step_mul_two h4
    exact ⟨w, by omega, by omega, by omega, by omega⟩

private theorem step_of_power_two (x y a : Nat) (hy : y % 2 = 1)
    (h : 3*x+1 = 2^a*y) : step x = y := by
  have hf : oddPart (2^a*y) = oddPart y := by
    clear h
    induction a with
    | zero => rw [Nat.pow_zero, Nat.one_mul]
    | succ a ih => rw [Nat.pow_succ, Nat.mul_comm (2^a) 2, Nat.mul_assoc,
        oddPart_double, ih]
  rw [step, h, hf, oddPart_of_odd hy]

/-- A complete five-point trace with a smaller branch that joins before a descent. -/
theorem capture_79 :
    step 79 = 119 ∧ step 119 = 179 ∧ step 179 = 269 ∧ step 269 = 101 ∧
      step 67 = 101 ∧ 67 < 79 ∧ 79 < 101 := by
  exact ⟨step_of_power_two 79 119 1 (by decide) (by decide),
    step_of_power_two 119 179 1 (by decide) (by decide),
    step_of_power_two 179 269 1 (by decide) (by decide),
    step_of_power_two 269 101 3 (by decide) (by decide),
    step_of_power_two 67 101 1 (by decide) (by decide), by decide, by decide⟩

/-- The departure at 27701 is outside the old guard, yet yields a capture
above the seed and before any descent. Every displayed transition is checked. -/
theorem outside_capture_2431 :
    step 2431 = 3647 ∧ step 3647 = 5471 ∧ step 5471 = 8207 ∧
      step 8207 = 12311 ∧ step 12311 = 18467 ∧ step 18467 = 27701 ∧
      step 27701 = 2597 ∧ step 1731 = 2597 ∧
      4*2431 < 27701 ∧ 2431 < 2597 ∧ 1731 < 2431 := by
  exact ⟨step_of_power_two 2431 3647 1 (by decide) (by decide),
    step_of_power_two 3647 5471 1 (by decide) (by decide),
    step_of_power_two 5471 8207 1 (by decide) (by decide),
    step_of_power_two 8207 12311 1 (by decide) (by decide),
    step_of_power_two 12311 18467 1 (by decide) (by decide),
    step_of_power_two 18467 27701 1 (by decide) (by decide),
    step_of_power_two 27701 2597 5 (by decide) (by decide),
    step_of_power_two 1731 2597 1 (by decide) (by decide),
    by decide, by decide, by decide⟩

/-- Infinite arithmetic progression of concrete departures outside 4N.
The six initial steps use one halving; the seventh uses five. -/
theorem outside_capture_progression (k : Nat) :
    let N := 4096*k+2431
    let x := 46656*k+27701
    let y := 4374*k+2597
    let w := 2916*k+1731
    orbit N 6 = x ∧ orbit N 7 = y ∧ step w = y ∧
      4*N < x ∧ N < y ∧ w < N := by
  dsimp
  have h1 := step_of_power_two (4096*k+2431) (6144*k+3647) 1 (by omega) (by omega)
  have h2 := step_of_power_two (6144*k+3647) (9216*k+5471) 1 (by omega) (by omega)
  have h3 := step_of_power_two (9216*k+5471) (13824*k+8207) 1 (by omega) (by omega)
  have h4 := step_of_power_two (13824*k+8207) (20736*k+12311) 1 (by omega) (by omega)
  have h5 := step_of_power_two (20736*k+12311) (31104*k+18467) 1 (by omega) (by omega)
  have h6 := step_of_power_two (31104*k+18467) (46656*k+27701) 1 (by omega) (by omega)
  have h7 := step_of_power_two (46656*k+27701) (4374*k+2597) 5 (by omega) (by omega)
  have hw := step_of_power_two (2916*k+1731) (4374*k+2597) 1 (by omega) (by omega)
  have h6orb : orbit (4096*k+2431) 6 = 46656*k+27701 := by
    simp only [orbit, h1, h2, h3, h4, h5, h6]
  have h7orb : orbit (4096*k+2431) 7 = 4374*k+2597 := by
    change step (orbit (4096*k+2431) 6) = _
    rw [h6orb, h7]
  exact ⟨h6orb, h7orb, hw, by omega, by omega, by omega⟩

#print axioms oddPart_factor
#print axioms smaller_source_iff_arrival
#print axioms step_of_power_two
#print axioms capture_79
#print axioms outside_capture_2431
#print axioms outside_capture_progression

end CollatzCharacterBridge
