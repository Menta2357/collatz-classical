import Terras90Extension

namespace Terras90PublishedCapacity

open TerrasClock

/-- A universal row stated at the start of the next odd run. The prefix
contains all odd entries of its complete runs and their even gaps. -/
def CompletedRunBound (runs height score : Nat) : Prop :=
  ∀ N t, 0<N → N%2=1 → N<2^height → oddRuns N t=runs →
    startsOddRun N t=true → oddCount N t≤score

private theorem least {P : Nat → Prop} (nonempty : ∃ i, P i) :
    ∃ i, P i ∧ ∀ j, j<i → ¬P j := by
  obtain ⟨t,ht⟩ := nonempty
  induction t using Nat.strongRecOn with
  | ind t ih =>
    by_cases before : ∃ j, j<t ∧ P j
    · obtain ⟨j,hj,witness⟩ := before
      exact ih j hj witness
    · exact ⟨t,ht,fun j hj witness => before ⟨j,hj,witness⟩⟩

/-- Finish the run containing the last odd entry, and its following even
gap, without adding an odd entry of the next run. -/
theorem completePrefix {N k : Nat} (pos : 0<N) :
    ∃ t, k≤t ∧ oddRuns N t=oddRuns N k ∧ startsOddRun N t=true ∧
      oddCount N k≤oddCount N t := by
  obtain ⟨extra,grows,earliest⟩ := least (Terras90.extendOddRuns (k:=k) pos)
  cases extra with
  | zero => simp at grows
  | succ j =>
    change oddRuns N (k+j)+(if startsOddRun N (k+j) then 1 else 0)=
      oddRuns N k+1 at grows
    cases phase : startsOddRun N (k+j)
    · simp only [phase,Bool.false_eq_true,if_false,Nat.add_zero] at grows
      exact (earliest j (Nat.lt_succ_self j) grows).elim
    · simp only [phase,if_true] at grows
      refine ⟨k+j, Nat.le_add_right _ _, by omega, phase, ?_⟩
      rw [oddCount_add]
      exact Nat.le_add_right _ _

theorem existsCompletion {N : Nat} (pos : 0<N) (runs : Nat) :
    ∃ t, oddRuns N t=runs ∧ startsOddRun N t=true := by
  have count (r : Nat) : ∃ k, oddRuns N k=r := by
    induction r with
    | zero => exact ⟨0,rfl⟩
    | succ r ih =>
      obtain ⟨k,hk⟩ := ih
      obtain ⟨extra,h⟩ := Terras90.extendOddRuns (k:=k) pos
      exact ⟨k+extra,by simpa only [hk] using h⟩
  obtain ⟨k,hk⟩ := count runs
  obtain ⟨t,_,same,phase,_⟩ := completePrefix (k:=k) pos
  exact ⟨t,same.trans hk,phase⟩

theorem completionUnique {N s t : Nat} (sPhase : startsOddRun N s=true)
    (tPhase : startsOddRun N t=true) (same : oddRuns N s=oddRuns N t) : s=t := by
  have grows (a tail : Nat) : oddRuns N a≤oddRuns N (a+tail) := by
    induction tail with
    | zero => exact Nat.le_refl _
    | succ tail ih =>
      have next : oddRuns N (a+tail+1)=oddRuns N (a+tail)+(if startsOddRun N (a+tail)
          then 1 else 0) := rfl
      change oddRuns N a≤oddRuns N (a+tail+1)
      rw [next]
      exact Nat.le_trans ih (Nat.le_add_right _ _)
  have strict {a b : Nat} (before : a<b) (phase : startsOddRun N a=true) :
      oddRuns N a<oddRuns N b := by
    have add : oddRuns N (a+1)=oddRuns N a+1 := by simp [oddRuns,phase]
    have rest := grows (a+1) (b-(a+1))
    rw [Nat.add_sub_of_le (by omega : a+1≤b),add] at rest
    omega
  by_cases left : s<t
  · exact (Nat.ne_of_lt (strict left sPhase) same).elim
  · by_cases right : t<s
    · exact (Nat.ne_of_lt (strict right tPhase) same.symm).elim
    · omega

theorem prefixBoundOfCompleted {runs height score : Nat}
    (row : CompletedRunBound runs height score) :
    Terras90.RunBound runs height score := by
  intro N k pos odd heightBound count
  obtain ⟨t,_,same,complete,nondecrease⟩ := completePrefix (k:=k) pos
  exact Nat.le_trans nondecrease (row N t pos odd heightBound (same.trans count) complete)

theorem completedBound_iff_prefixBound (runs height score : Nat) :
    CompletedRunBound runs height score ↔ Terras90.RunBound runs height score :=
  ⟨prefixBoundOfCompleted, fun row N k pos odd h r _ => row N k pos odd h r⟩

def cofactorStart (u : Nat) : Nat := 2^124*u-1

/-- Exact domain of the H146 high-first-run reproduction. Each positive
cofactor below 2^22 represents one original seed. -/
def GuardedH146Replay : Prop :=
  ∀ u t, 0<u → u<2^22 → oddRuns (cofactorStart u) t=6 →
    startsOddRun (cofactorStart u) t=true → oddCount (cofactorStart u) t≤166

theorem guardedCofactor {N : Nat} (height : N+1<2^146) (guard : 2^124 ∣ N+1) :
    ∃ u, 0<u ∧ u<2^22 ∧ N=cofactorStart u := by
  obtain ⟨u,equation⟩ := guard
  have uPos : 0<u := by
    by_cases zero : u=0
    · simp [zero] at equation
    · omega
  have uLt : u<2^22 := by
    apply Nat.lt_of_mul_lt_mul_left (a:=2^124)
    rw [← equation, ← Nat.pow_add]
    exact height
  exact ⟨u,uPos,uLt,by unfold cofactorStart; omega⟩

theorem cofactorSound {u : Nat} (positive : 0<u) (limit : u<2^22) :
    0<cofactorStart u ∧ cofactorStart u%2=1 ∧
      cofactorStart u+1<2^146 ∧ 2^124 ∣ cofactorStart u+1 := by
  have base : 2≤2^124*u := by
    have scale := Nat.mul_le_mul_left (2^124) (show 1≤u by omega)
    rw [Nat.mul_one] at scale
    exact Nat.le_trans (by decide) scale
  have equation : cofactorStart u+1=2^124*u := by unfold cofactorStart; omega
  have high := Nat.mul_lt_mul_of_pos_left limit (by decide : 0<2^124)
  rw [← Nat.pow_add] at high
  have parity : cofactorStart u%2=1 := by
    have factor : (2:Nat)^124=2*2^123 := by decide
    rw [factor,Nat.mul_assoc] at equation
    omega
  exact ⟨by omega,parity,by rwa [equation],⟨u,equation⟩⟩

theorem guardedPrefixBound (replay : GuardedH146Replay)
    {N k : Nat} (pos : 0<N) (height : N+1<2^146) (runs : oddRuns N k=6)
    (guard : 2^124 ∣ N+1) :
    oddCount N k≤166 := by
  obtain ⟨t,_,same,complete,nondecrease⟩ := completePrefix (k:=k) pos
  obtain ⟨u,uPos,uLt,seed⟩ := guardedCofactor height guard
  have count := same.trans runs
  rw [seed] at count complete nondecrease ⊢
  exact Nat.le_trans nondecrease (replay u t uPos uLt count complete)

theorem sixRunCapacities
    (seven : CompletedRunBound 7 100 156)
    (five : CompletedRunBound 5 229 254)
    (guarded : GuardedH146Replay) :
    Terras90.SixRunCapacity 92 ∧ Terras90.SixRunCapacity 146 := by
  have tail : Terras89.FiveRunBound 229 254 := prefixBoundOfCompleted five
  exact ⟨Terras90.capacity92OfSeven (prefixBoundOfCompleted seven),
    Terras90.capacity146OfFirstRuns tail
      (fun N k pos _ height runs guard => guardedPrefixBound guarded pos height runs guard)⟩

/-- The six-run result already gives the five-run capacity at each height
without consuming another published five-run row. -/
theorem fiveOfSix {height : Nat} (six : Terras90.SixRunCapacity height) :
    Terras89.FiveRunCapacity height := by
  intro N k pos odd source runs
  obtain ⟨extra,exactlySix⟩ := Terras90.extendOddRuns (k:=k) pos
  rw [runs] at exactlySix
  have price := six N (k+extra) pos odd source exactlySix
  rw [oddCount_add] at price
  exact Nat.le_trans (Nat.pow_le_pow_right (by decide) (Nat.le_add_right _ _)) price

theorem fiveAndSixRunCapacities
    (seven : CompletedRunBound 7 100 156)
    (five : CompletedRunBound 5 229 254)
    (guarded : GuardedH146Replay) :
    (Terras89.FiveRunCapacity 92 ∧ Terras89.FiveRunCapacity 146) ∧
    (Terras90.SixRunCapacity 92 ∧ Terras90.SixRunCapacity 146) := by
  have six := sixRunCapacities seven five guarded
  exact ⟨⟨fiveOfSix six.1,fiveOfSix six.2⟩,six⟩

end Terras90PublishedCapacity
