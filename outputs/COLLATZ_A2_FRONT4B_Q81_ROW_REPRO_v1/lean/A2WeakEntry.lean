import A2HalfAdaptive

namespace CollatzCharacterBridge.A2WeakEntry

open StagedCylinder (Segment)
open P5R3S5 (transport step_segment)
open A2HalfAdaptive (first_break history_capture)
open FixedSourceRun (Ones)

/-- The unresolved event lies after a nonempty physical run, inside a
window that still refers to the original seed. -/
def Remaining (N : Nat) : Prop :=
  ∃ x j s B r : Nat,
    N≤x ∧ x%2=1 ∧ x<2*N+1 ∧ 1≤r ∧
    Segment N x j s B ∧ Ones x r ∧
    3*orbit x r+1=4*orbit x (r+1)

private theorem orbit_one (i : Nat) : orbit 1 i=1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i)=1
    rw [ih]
    change oddPart 4=1
    exact (oddPart_quadruple 1).trans (oddPart_of_odd (by decide))

private theorem through_segment {N x j s B : Nat}
    (p : Segment N x j s B) (arrives : ∃ i, orbit x i=1) :
    ∃ i, orbit N i=1 := by
  obtain ⟨i,hi⟩ := arrives
  exact ⟨j+i, by rw [orbit_add,A2Header.physical_endpoint p.physical,hi]⟩

private theorem through_meeting {N w x j s B k t C : Nat}
    (a : Segment N x j s B) (b : Segment w x k t C)
    (arrives : ∃ i, orbit w i=1) : ∃ i, orbit N i=1 := by
  obtain ⟨i,hi⟩ := arrives
  have meet := (A2Header.physical_endpoint a.physical).trans
    (A2Header.physical_endpoint b.physical).symm
  refine ⟨j+i,?_⟩
  rw [orbit_add,meet,←orbit_add,Nat.add_comm k i,orbit_add,hi,orbit_one]

/-- A leading valuation two decreases the current checkpoint and keeps
the window. Recursive calls transport the actual original book. -/
theorem reduce_window {N x j s B : Nat} (Nbig : 1<N)
    (fromN : Segment N x j s B) (positive : 0<x) (odd : x%2=1)
    (height : x<2*N+1)
    (IH : ∀ w : Nat, 0<w → w%2=1 → w<N → ∃ i, orbit w i=1) :
    (∃ i, orbit N i=1) ∨ Remaining N := by
  induction x using Nat.strongRecOn generalizing j s B with
  | ind x ih =>
    by_cases below : x<N
    · exact Or.inl (through_segment fromN (IH x positive odd below))
    obtain ⟨r,b,run,hb,factor⟩ := first_break x odd
    cases r with
    | zero =>
      change 3*x+1=2^b*step x at factor
      have tail := step_segment x b positive odd (by omega) factor
      have whole := transport fromN tail
      by_cases two : b=2
      · rw [two] at factor
        change 3*x+1=4*step x at factor
        have lower : step x<x := by omega
        exact ih (step x) lower whole (step_pos _) (step_odd _) (by omega)
      · have strength : 3≤b := by omega
        have pow : (8:Nat)≤2^b := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) strength
        have bound := Nat.mul_le_mul_right (step x) pow
        rw [←factor] at bound
        exact Or.inl (through_segment whole (IH (step x) (step_pos _) (step_odd _) (by omega)))
    | succ r =>
      by_cases two : b=2
      · rw [two] at factor
        exact Or.inr ⟨x,j,s,B,r+1,by omega,odd,height,by omega,fromN,run,factor⟩
      · obtain ⟨hp,ho,hl,ns,ws⟩ := history_capture fromN positive odd height run (by omega) factor
        exact Or.inl (through_meeting ns ws (IH _ hp ho hl))

theorem q177_reduce (t : Nat)
    (IH : ∀ w : Nat, 0<w → w%2=1 → w<A2HalfAdaptive.seed t → ∃ i, orbit w i=1) :
    (∃ i, orbit (A2HalfAdaptive.seed t) i=1) ∨ Remaining (A2HalfAdaptive.seed t) := by
  obtain ⟨hp,ho,ht⟩ := A2HalfAdaptive.entry_bounds t
  exact reduce_window (by unfold A2HalfAdaptive.seed; omega)
    (A2HalfAdaptive.entry t) hp ho ht IH

end CollatzCharacterBridge.A2WeakEntry
