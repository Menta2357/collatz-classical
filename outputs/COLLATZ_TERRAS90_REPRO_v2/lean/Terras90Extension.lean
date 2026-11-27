import Terras90

namespace Terras90

open TerrasClock

private theorem shortcut_pos {x : Nat} (pos : 0 < x) : 0 < shortcut x := by
  unfold shortcut
  split <;> omega

private theorem orbit_pos {x : Nat} (pos : 0 < x) (k : Nat) : 0 < orbit x k := by
  induction k with
  | zero => exact pos
  | succ k ih => exact shortcut_pos ih

private theorem shifted_odd_prefix (x k : Nat)
    (odd : ∀ j, j < k → orbit x j % 2 = 1) :
    2^k * (orbit x k + 1) = 3^k * (x + 1) := by
  induction k with
  | zero => simp [orbit]
  | succ k ih =>
    have edge := shortcut_odd (odd k (Nat.lt_succ_self k))
    have shifted : 2 * (orbit x (k+1)+1) = 3*(orbit x k+1) := by
      rw [orbit_succ]
      omega
    calc
      2^(k+1) * (orbit x (k+1)+1) = 2^k * (2 * (orbit x (k+1)+1)) := by
        rw [Nat.pow_succ, Nat.mul_assoc]
      _ = 3 * (2^k * (orbit x k+1)) := by rw [shifted]; ac_rfl
      _ = 3^(k+1) * (x+1) := by
        rw [ih (fun j before => odd j (by omega)), Nat.pow_succ]
        ac_rfl

private theorem pow_dvd_shifted_start (x k : Nat)
    (odd : ∀ j, j < k → orbit x j % 2 = 1) : 2^k ∣ x+1 := by
  have entry := shifted_odd_prefix x k odd
  have divides : 2^k ∣ 3^k*(x+1) := ⟨orbit x k+1, entry.symm⟩
  have gcdOne : Nat.gcd (2^k) (3^k) = 1 :=
    Nat.pow_gcd_pow_of_gcd_eq_one (by decide : Nat.gcd 2 3 = 1)
  have reduced := (Nat.dvd_mul_gcd_iff_dvd_mul
    (k := 2^k) (n := x+1) (m := 3^k)).mpr (by
      rw [Nat.mul_comm]
      exact divides)
  rw [gcdOne, Nat.mul_one] at reduced
  exact reduced

private theorem eventually_even (x : Nat) : ∃ k, orbit x k % 2 = 0 := by
  apply Classical.byContradiction
  intro absence
  let k := x+1
  have odd : ∀ j, j < k → orbit x j % 2 = 1 := by
    intro j _
    have notEven : ¬orbit x j % 2 = 0 := fun h => absence ⟨j,h⟩
    omega
  exact (Nat.not_le_of_gt (Nat.lt_two_pow_self (n := x+1)))
    (Nat.le_of_dvd (Nat.succ_pos x) (pow_dvd_shifted_start x k odd))

private theorem even_to_odd {x : Nat} (pos : 0 < x) (even : x % 2 = 0) :
    ∃ j, orbit x j % 2 = 0 ∧ orbit x (j+1) % 2 = 1 := by
  induction x using Nat.strongRecOn with
  | ind x ih =>
    by_cases nextOdd : shortcut x % 2 = 1
    · exact ⟨0, even, nextOdd⟩
    · have evenNext : shortcut x % 2 = 0 := by omega
      have nextPos := shortcut_pos pos
      have smaller : shortcut x < x := by
        have eq := shortcut_even even
        omega
      obtain ⟨j, before, after⟩ := ih (shortcut x) smaller nextPos evenNext
      refine ⟨1+j, ?_, ?_⟩
      · rw [orbit_add]
        exact before
      · rw [show 1+j+1 = 1+(j+1) by omega, orbit_add]
        exact after

private theorem runs_mono_after (N k gap : Nat) :
    oddRuns N k ≤ oddRuns N (k+gap) := by
  induction gap with
  | zero => simp
  | succ gap ih =>
    rw [Nat.add_succ, oddRuns_succ]
    exact Nat.le_trans ih (Nat.le_add_right _ _)

private theorem reachesRunCount (N wanted limit : Nat)
    (enough : wanted ≤ oddRuns N limit) :
    ∃ l, l ≤ limit ∧ oddRuns N l = wanted := by
  induction limit with
  | zero =>
    have none : wanted = 0 := by simpa [oddRuns] using enough
    exact ⟨0, Nat.le_refl _, none.symm⟩
  | succ limit ih =>
    by_cases before : wanted ≤ oddRuns N limit
    · obtain ⟨l, bound, count⟩ := ih before
      exact ⟨l, by omega, count⟩
    · refine ⟨limit+1, by omega, ?_⟩
      rw [oddRuns_succ] at enough ⊢
      by_cases start : orbit N limit % 2 = 1 ∧
          (limit = 0 ∨ orbit N (limit-1) % 2 = 0) <;>
        simp [start] at enough ⊢ <;> omega

/-- Every positive physical prefix can be extended by one maximal odd run. -/
theorem extendOddRuns {N k : Nat} (pos : 0 < N) :
    ∃ extra, oddRuns N (k+extra) = oddRuns N k+1 := by
  obtain ⟨e, even⟩ := eventually_even (orbit N k)
  have evenAt : orbit N (k+e) % 2 = 0 := by rwa [orbit_add]
  obtain ⟨j, prev, next⟩ := even_to_odd (orbit_pos pos (k+e)) evenAt
  let m := k+e+j+1
  have high : k ≤ m := by dsimp [m]; omega
  have before : orbit N (m-1) % 2 = 0 := by
    rw [show m-1 = (k+e)+j by dsimp [m] <;> omega, orbit_add]
    exact prev
  have atRun : orbit N m % 2 = 1 := by
    rw [show m = (k+e)+(j+1) by dsimp [m]; omega, orbit_add]
    exact next
  have incr : oddRuns N (m+1) = oddRuns N m+1 := by
    rw [oddRuns_succ]
    simp [atRun, before]
  have grows : oddRuns N k ≤ oddRuns N m := by
    simpa [Nat.add_sub_of_le high] using runs_mono_after N k (m-k)
  obtain ⟨l, _, count⟩ := reachesRunCount N (oddRuns N k+1) (m+1) (by omega)
  have after : k ≤ l := by
    by_cases le : l ≤ k
    · have prevBound := runs_mono_after N l (k-l)
      rw [Nat.add_sub_of_le le, count] at prevBound
      omega
    · omega
  exact ⟨l-k, by rwa [Nat.add_sub_of_le after]⟩

theorem capacity92OfSeven (external : RunBound 7 100 156) : SixRunCapacity 92 := by
  intro N k pos odd source runs
  obtain ⟨extra, extended⟩ := extendOddRuns (k := k) pos
  rw [runs] at extended
  exact capacity92OfExtension external pos odd source extended

private theorem earliest {P : Nat → Prop} (existsAt : ∃ j, P j) :
    ∃ j, P j ∧ ∀ i, i<j → ¬P i := by
  obtain ⟨w, witness⟩ := existsAt
  induction w using Nat.strongRecOn with
  | ind w ih =>
    by_cases previous : ∃ j, j<w ∧ P j
    · obtain ⟨j, before, atJ⟩ := previous
      exact ih j before atJ
    · exact ⟨w, witness, fun i before atI => previous ⟨i, before, atI⟩⟩

private theorem even_prefix (x k : Nat) (even : ∀ j, j<k → orbit x j % 2=0) :
    2^k*orbit x k=x := by
  induction k with
  | zero => simp [orbit]
  | succ k ih =>
    rw [Nat.pow_succ, orbit_succ, Nat.mul_assoc,
      shortcut_even (even k (Nat.lt_succ_self k))]
    exact ih (fun j before => even j (by omega))

private theorem odd_count_of_parity (x k parity : Nat)
    (physical : ∀ j, j<k → orbit x j % 2=parity) :
    oddCount x k = if parity=1 then k else 0 := by
  induction k with
  | zero => simp [oddCount]
  | succ k ih =>
    change oddCount x k+(if orbit x k % 2=1 then 1 else 0) =
      if parity=1 then k+1 else 0
    rw [ih (fun j before => physical j (by omega)),
      physical k (Nat.lt_succ_self k)]
    split <;> simp_all

private theorem runs_until_next_valley (N a p : Nat) (pPos : 0<p)
    (initial : N % 2=1)
    (odd : ∀ j, j<a → orbit N j % 2=1)
    (even : ∀ j, a≤j → j<p → orbit N j % 2=0) :
    oddRuns N p=1 := by
  have onlyFirst : ∀ j, 0<j → j<p →
      ¬(orbit N j%2=1 ∧ (j=0 ∨ orbit N (j-1)%2=0)) := by
    intro j positive before start
    by_cases oddPart : j<a
    · have older := odd (j-1) (by omega)
      omega
    · have here := even j (by omega) before
      omega
  have aux : ∀ n, 0<n → n≤p → oddRuns N n=1 := by
    intro n
    induction n with
    | zero => omega
    | succ n ih =>
      intro positive bound
      rw [oddRuns_succ]
      by_cases first : n=0
      · subst n
        simp [oddRuns, orbit, initial]
      · simp [onlyFirst n (by omega) (by omega), ih (by omega) (by omega)]
  exact aux p pPos (Nat.le_refl _)

private theorem oddRuns_add_at_valley (N p k : Nat)
    (beforeEven : orbit N (p-1)%2=0) (positive : 0<p) :
    oddRuns N (p+k)=oddRuns N p+oddRuns (orbit N p) k := by
  induction k with
  | zero => simp [oddRuns]
  | succ k ih =>
    rw [Nat.add_succ, oddRuns_succ, oddRuns_succ, ih, orbit_add N p k]
    have atStart :
        (p+k=0 ∨ orbit N (p+k-1)%2=0) ↔
        (k=0 ∨ orbit (orbit N p) (k-1)%2=0) := by
      by_cases initial : k=0
      · subst k
        simp [beforeEven]
      · rw [show p+k-1=p+(k-1) by omega, orbit_add]
        simp [initial, show p+k≠0 by omega]
    simp only [atStart, Nat.add_assoc]

/-- Exact alternative for the initial run. High runs use the exhaustive
cofactor bound. Short runs use the physical second valley. -/
theorem capacity146OfFirstRuns (external : Terras89.FiveRunBound 229 254)
    (long : ∀ N k, 0<N → N%2=1 → N+1<2^146 → oddRuns N k=6 →
      2^124 ∣ N+1 → oddCount N k≤166) :
    SixRunCapacity 146 := by
  intro N k pos initial small runs
  by_cases high : 2^124 ∣ N+1
  · have bound := long N k pos initial small runs high
    exact Nat.le_trans (Nat.pow_le_pow_right (by decide) bound) (by decide)
  obtain ⟨a, evenA, beforeA⟩ := earliest (eventually_even N)
  have aPos : 0<a := by
    by_cases zero : a=0
    · subst a
      change N%2=0 at evenA
      omega
    · omega
  have headOdd : ∀ j, j<a → orbit N j%2=1 := by
    intro j before
    have notEven := beforeA j before
    omega
  have weight := pow_dvd_shifted_start N a headOdd
  have short : a≤123 := by
    by_cases tall : 124≤a
    · exact (high (Nat.dvd_trans (Nat.pow_dvd_pow 2 tall) weight)).elim
    · omega
  have nextExists : ∃ j, orbit (orbit N a) j %2=1 := by
    obtain ⟨j, _, yes⟩ := even_to_odd (orbit_pos pos a) evenA
    exact ⟨j+1, yes⟩
  obtain ⟨b, oddB, beforeB⟩ := earliest nextExists
  have gap : 1≤b := by
    by_cases zero : b=0
    · subst b
      change orbit N a%2=1 at oddB
      omega
    · omega
  have allEven : ∀ j, j<b → orbit (orbit N a) j%2=0 := by
    intro j before
    have notOdd := beforeB j before
    omega
  let p := a+b
  have pPos : 0<p := by dsimp [p]; omega
  have yOdd : orbit N p%2=1 := by simpa [p, orbit_add] using oddB
  have middleEven : ∀ j, a≤j → j<p → orbit N j%2=0 := by
    intro j after before
    rw [show j=a+(j-a) by omega, orbit_add]
    exact allEven (j-a) (by dsimp [p] at before; omega)
  have prevEven : orbit N (p-1)%2=0 :=
    middleEven (p-1) (by dsimp [p]; omega) (by omega)
  have one := runs_until_next_valley N a p pPos initial headOdd middleEven
  have beforeK : p≤k := by
    by_cases le : k≤p
    · have m := runs_mono_after N k (p-k)
      rw [Nat.add_sub_of_le le, runs, one] at m
      omega
    · omega
  have tail : oddRuns (orbit N p) (k-p)=5 := by
    have compose := oddRuns_add_at_valley N p (k-p) prevEven pPos
    rw [Nat.add_sub_of_le beforeK, runs, one] at compose
    omega
  have counted : oddCount N p=a := by
    dsimp only [p]
    rw [oddCount_add, odd_count_of_parity N a 1 headOdd,
      odd_count_of_parity (orbit N a) b 0 allEven]
    simp
  obtain ⟨u, decompose⟩ := weight
  have oddBook := shifted_odd_prefix N a headOdd
  have evenBook := even_prefix (orbit N a) b allEven
  rw [← orbit_add] at evenBook
  have book : 2^b*orbit N p+1=3^a*u := by
    dsimp only [p]
    rw [evenBook]
    apply Nat.eq_of_mul_eq_mul_left (Nat.pow_pos (show (0:Nat)<2 by decide) : 0<2^a)
    calc
      _ = 3^a*(N+1) := oddBook
      _ = _ := by rw [decompose]; ac_rfl
  have atSource : 2^a*u<2^146 := by rwa [← decompose]
  have pay := shortFirstRunCapacity external short gap atSource book yOdd counted tail
  simpa only [Nat.add_sub_of_le beforeK] using pay

theorem firstDescentOfRunBounds
    (prev88 : Terras88.Inputs) (prev89 : Terras89.Inputs89)
    (five92 : Terras89.FiveRunCapacity 92) (five146 : Terras89.FiveRunCapacity 146)
    (current : Inputs90) (seven : RunBound 7 100 156)
    (five : Terras89.FiveRunBound 229 254)
    (long : ∀ N k, 0<N → N%2=1 → N+1<2^146 → oddRuns N k=6 →
      2^124 ∣ N+1 → oddCount N k≤166)
    {N k : Nat} (large : 2≤N) (first : FirstContraction N k) (runs : oddRuns N k≤90) :
    orbit N k<N ∧ ∀ j, j<k → N≤orbit N j :=
  firstDescent prev88 prev89 five92 five146 current
    (capacity92OfSeven seven) (capacity146OfFirstRuns five long) large first runs

end Terras90
