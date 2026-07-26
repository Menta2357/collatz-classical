import CollatzClassical.KL2003.KL2003M0BTwoBranchCore

/-!
# Exact one-step reverse predecessors for the accelerated Collatz map

This module isolates the finite predecessor primitive needed by the reverse
first-hit construction.  The even predecessor of `v` is always `2 * v`.
The possible odd predecessor is `(2 * v - 1) / 3`; it is inserted only when
the numerator is divisible by three and the quotient is odd.
-/

namespace CollatzClassical
namespace KL2003

/-- The arithmetically valid one-step predecessor candidates of `v`. -/
def predecessorCandidates (v : Nat) : Finset Nat :=
  insert (2 * v)
    (if 3 ∣ 2 * v - 1 ∧ ((2 * v - 1) / 3) % 2 = 1 then
      {((2 * v - 1) / 3)}
    else
      ∅)

private theorem odd_candidate_maps_to_target {v : Nat}
    (hdiv : 3 ∣ 2 * v - 1)
    (hodd : ((2 * v - 1) / 3) % 2 = 1) :
    T ((2 * v - 1) / 3) = v := by
  let u := (2 * v - 1) / 3
  have hu : 1 ≤ u := by
    have hlt : u % 2 < 2 := Nat.mod_lt _ (by omega)
    omega
  have hnum : 2 * v - 1 = 3 * u := by
    rcases hdiv with ⟨k, hk⟩
    have huk : u = k := by
      dsimp [u]
      rw [hk]
      omega
    simpa [huk] using hk
  have harith : 3 * u + 1 = 2 * v := by omega
  exact two_branch_advanced_child_maps_to_root harith

private theorem predecessor_eq_candidate {u v : Nat}
    (hT : T u = v) :
    u = 2 * v ∨
      (3 ∣ 2 * v - 1 ∧
        ((2 * v - 1) / 3) % 2 = 1 ∧
        u = (2 * v - 1) / 3) := by
  by_cases heven : u % 2 = 0
  · left
    have hdiv : u / 2 = v := by
      simpa [T, heven] using hT
    have hreconstruct := Nat.mod_add_div u 2
    omega
  · right
    have hodd : u % 2 = 1 := by
      have hlt : u % 2 < 2 := Nat.mod_lt _ (by omega)
      omega
    have hdivEq : (3 * u + 1) / 2 = v := by
      simpa [T, heven] using hT
    have hthreeOdd : (3 * u + 1) % 2 = 0 := by omega
    have hreconstruct := Nat.mod_add_div (3 * u + 1) 2
    have harith : 3 * u + 1 = 2 * v := by omega
    have hnum : 2 * v - 1 = 3 * u := by omega
    have hthree : 3 ∣ 2 * v - 1 := by
      exact ⟨u, by simpa [Nat.mul_comm] using hnum⟩
    have hquot : (2 * v - 1) / 3 = u := by
      rw [hnum]
      omega
    exact ⟨hthree, by simpa [hquot] using hodd, hquot.symm⟩

theorem mem_predecessorCandidates_iff {u v : Nat} :
    u ∈ predecessorCandidates v ↔ T u = v := by
  constructor
  · intro hmem
    by_cases hvalid : 3 ∣ 2 * v - 1 ∧ ((2 * v - 1) / 3) % 2 = 1
    · simp only [predecessorCandidates, if_pos hvalid, Finset.mem_insert,
        Finset.mem_singleton] at hmem
      rcases hmem with hEven | hOdd
      · subst u
        exact two_branch_T_two_mul v
      · subst u
        exact odd_candidate_maps_to_target hvalid.1 hvalid.2
    · simp only [predecessorCandidates, if_neg hvalid, Finset.mem_insert,
        Finset.notMem_empty, or_false] at hmem
      subst u
      exact two_branch_T_two_mul v
  · intro hT
    rcases predecessor_eq_candidate hT with hEven | hOdd
    · simp [predecessorCandidates, hEven]
    · rcases hOdd with ⟨hdiv, hparity, hEq⟩
      simp [predecessorCandidates, hdiv, hparity, hEq]

/-- Positive predecessors of `v` inside `[1, x]`, excluding the root `a`. -/
def preimagesWithin (a x v : Nat) : Finset Nat :=
  (predecessorCandidates v).filter
    (fun u => 1 ≤ u ∧ u ≤ x ∧ u ≠ a)

theorem mem_preimagesWithin_iff {a x v u : Nat} :
    u ∈ preimagesWithin a x v ↔
      1 ≤ u ∧ u ≤ x ∧ u ≠ a ∧ T u = v := by
  rw [preimagesWithin, Finset.mem_filter]
  constructor
  · rintro ⟨hcandidate, hu, hux, hua⟩
    exact ⟨hu, hux, hua, mem_predecessorCandidates_iff.mp hcandidate⟩
  · rintro ⟨hu, hux, hua, hT⟩
    exact ⟨mem_predecessorCandidates_iff.mpr hT, hu, hux, hua⟩

end KL2003
end CollatzClassical
