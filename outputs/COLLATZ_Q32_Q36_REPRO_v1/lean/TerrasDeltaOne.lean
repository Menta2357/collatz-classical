import TerrasClock

namespace TerrasClock

private theorem odd_at_delta_one {N k : Nat} (large : 3≤N)
    (first : FirstContraction N k) (delta : orbit N k=N+1) :
    N%2=1 := by
  rcases Nat.mod_two_eq_zero_or_one N with even | odd
  · have one_count : oddCount N 1=0 := by simp [oddCount,orbit,even]
    have positive := first_contraction_pos first
    have limit : k≤1 := by
      by_cases later : 1<k
      · have prior := first.2 1 later
        rw [one_count] at prior
        omega
      · omega
    have index : k=1 := by omega
    have physical : 2*orbit N 1=N := shortcut_even even
    rw [index] at delta
    omega
  · exact odd

private theorem three_mod_four_at_delta_one {N k : Nat} (large : 3≤N)
    (first : FirstContraction N k) (delta : orbit N k=N+1)
    (odd : N%2=1) :
    N%4=3 := by
  by_cases good : N%4=3
  · exact good
  · have bad : N%4=1 := by omega
    have step1 : 2*orbit N 1=3*N+1 := shortcut_odd odd
    have even1 : orbit N 1%2=0 := by omega
    have step2 : 2*orbit N 2=orbit N 1 := shortcut_even even1
    have one_count : oddCount N 1=1 := by simp [oddCount,orbit,odd]
    have two_count : oddCount N 2=1 := by
      change oddCount N 1+(if orbit N 1%2=1 then 1 else 0)=1
      simp [one_count,even1]
    have limit : k≤2 := by
      by_cases later : 2<k
      · have prior := first.2 2 later
        rw [two_count] at prior
        omega
      · omega
    have positive := first_contraction_pos first
    have index_cases : k=1 ∨ k=2 := by omega
    rcases index_cases with index | index
    · rw [index] at delta
      omega
    · rw [index] at delta
      omega

private theorem shortcut_odd_nonzero_mod_three {x : Nat} (odd : x%2=1) :
    shortcut x%3≠0 := by
  have factor := shortcut_odd odd
  omega

private theorem shortcut_even_preserves_nonzero_mod_three {x : Nat}
    (even : x%2=0) (nonzero : x%3≠0) : shortcut x%3≠0 := by
  have factor := shortcut_even even
  omega

/-- Once the original makes an odd departure, every later state avoids
    zero modulo three. Even steps preserve the nonzero residue property. -/
theorem after_initial_odd_nonzero_mod_three {N : Nat} (odd : N%2=1) (m : Nat) :
    orbit N (m+1)%3≠0 := by
  induction m with
  | zero => exact shortcut_odd_nonzero_mod_three odd
  | succ m ih =>
    rw [orbit_succ]
    rcases Nat.mod_two_eq_zero_or_one (orbit N (m+1)) with even | odd
    · exact shortcut_even_preserves_nonzero_mod_three even ih
    · exact shortcut_odd_nonzero_mod_three odd

/-- At a first contraction with endpoint N+1, the next step is an
    actual strict descent and the origin belongs to one of two classes. -/
theorem delta_one_physics {N k : Nat} (large : 3≤N)
    (first : FirstContraction N k) (delta : orbit N k=N+1) :
    N%2=1 ∧ orbit N (k+1)=(N+1)/2 ∧ orbit N (k+1)<N ∧
      (N%12=3 ∨ N%12=7) := by
  have odd := odd_at_delta_one large first delta
  have four := three_mod_four_at_delta_one large first delta odd
  have kpos := first_contraction_pos first
  have nonzero : orbit N k%3≠0 := by
    have rew : k=k-1+1 := by omega
    rw [rew]
    exact after_initial_odd_nonzero_mod_three odd (k-1)
  rw [delta] at nonzero
  have residue : N%12=3 ∨ N%12=7 := by omega
  have factor : 2*orbit N (k+1)=N+1 := by
    rw [orbit_succ,delta]
    exact shortcut_even (by omega)
  have half : orbit N (k+1)=(N+1)/2 := by omega
  exact ⟨odd,half,by omega,residue⟩

/-- No repeat is possible through clock k. A repeat would place the
    strict descent at k+1 at an earlier clock on the same orbit. -/
theorem delta_one_distinct {N k : Nat} (large : 3≤N)
    (first : FirstContraction N k) (delta : orbit N k=N+1)
    {i j : Nat} (ordered : i<j) (before : j≤k) :
    orbit N i≠orbit N j := by
  intro same
  let rest := k+1-j
  have final_clock : j+rest=k+1 := by dsimp only [rest]; omega
  have earlier_clock : i+rest≤k := by dsimp only [rest]; omega
  have transported : orbit N (i+rest)=orbit N (k+1) := by
    rw [←final_clock,orbit_add N i rest,orbit_add N j rest,same]
  have after := (delta_one_physics large first delta).2.2.1
  have before_lower : N≤orbit N (i+rest) := by
    rcases Nat.lt_or_eq_of_le earlier_clock with early | at_last
    · exact prior_no_descent first early
    · rw [at_last,delta]
      omega
  omega

end TerrasClock
