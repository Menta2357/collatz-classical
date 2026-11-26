import A2WeakEntry

namespace CollatzCharacterBridge.A2BoundedReducer

open StagedCylinder (Segment)
open P5R3S5 (transport step_segment)
open A2HalfAdaptive (first_break history_capture)
open FixedSourceRun (Ones)

/-- The remaining physical pivot is no higher than the input checkpoint.
This is the rank information not present in `A2WeakEntry.Remaining`. -/
def RemainingAtMost (N bound : Nat) : Prop :=
  ∃ x j s B r : Nat,
    N ≤ x ∧ x ≤ bound ∧ x % 2 = 1 ∧ x < 2 * N + 1 ∧ 1 ≤ r ∧
    Segment N x j s B ∧ Ones x r ∧
    3 * orbit x r + 1 = 4 * orbit x (r + 1)

theorem remaining_mono {N x y : Nat} (h : RemainingAtMost N x)
    (hxy : x ≤ y) : RemainingAtMost N y := by
  obtain ⟨z,j,s,B,r,hNz,hzx,ho,hw,hr,seg,run,factor⟩ := h
  exact ⟨z,j,s,B,r,hNz,by omega,ho,hw,hr,seg,run,factor⟩

theorem remaining_forget {N x : Nat} (h : RemainingAtMost N x) :
    A2WeakEntry.Remaining N := by
  obtain ⟨z,j,s,B,r,hNz,_,ho,hw,hr,seg,run,factor⟩ := h
  exact ⟨z,j,s,B,r,hNz,ho,hw,hr,seg,run,factor⟩

private theorem orbit_one (i : Nat) : orbit 1 i = 1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i) = 1
    rw [ih]
    change oddPart 4 = 1
    exact (oddPart_quadruple 1).trans (oddPart_of_odd (by decide))

private theorem through_segment {N x j s B : Nat}
    (p : Segment N x j s B) (arrives : ∃ i, orbit x i = 1) :
    ∃ i, orbit N i = 1 := by
  obtain ⟨i,hi⟩ := arrives
  exact ⟨j+i, by rw [orbit_add,A2Header.physical_endpoint p.physical,hi]⟩

private theorem through_meeting {N w x j s B k t C : Nat}
    (a : Segment N x j s B) (b : Segment w x k t C)
    (arrives : ∃ i, orbit w i = 1) : ∃ i, orbit N i = 1 := by
  obtain ⟨i,hi⟩ := arrives
  have meet := (A2Header.physical_endpoint a.physical).trans
    (A2Header.physical_endpoint b.physical).symm
  refine ⟨j+i,?_⟩
  rw [orbit_add,meet,←orbit_add,Nat.add_comm k i,orbit_add,hi,orbit_one]

/-- The same reduction as `A2WeakEntry.reduce_window`, exposing the
monotone checkpoint in the remainder. No outcome above the input `x` can
be returned from the leading-two recursion. -/
theorem reduce_window_bounded {N x j s B : Nat} (Nbig : 1 < N)
    (fromN : Segment N x j s B) (positive : 0 < x) (odd : x % 2 = 1)
    (height : x < 2 * N + 1)
    (IH : ∀ w : Nat, 0 < w → w % 2 = 1 → w < N → ∃ i, orbit w i = 1) :
    (∃ i, orbit N i = 1) ∨ RemainingAtMost N x := by
  induction x using Nat.strongRecOn generalizing j s B with
  | ind x ih =>
    by_cases below : x < N
    · exact Or.inl (through_segment fromN (IH x positive odd below))
    obtain ⟨r,b,run,hb,factor⟩ := first_break x odd
    cases r with
    | zero =>
      change 3*x+1 = 2^b*step x at factor
      have tail := step_segment x b positive odd (by omega) factor
      have whole := transport fromN tail
      by_cases two : b = 2
      · rw [two] at factor
        change 3*x+1 = 4*step x at factor
        have lower : step x < x := by omega
        rcases ih (step x) lower whole (step_pos _) (step_odd _) (by omega) with done | rem
        · exact Or.inl done
        · exact Or.inr (remaining_mono rem (by omega))
      · have strength : 3 ≤ b := by omega
        have pow : (8:Nat) ≤ 2^b := Nat.pow_le_pow_right (by decide : 0 < (2:Nat)) strength
        have bound := Nat.mul_le_mul_right (step x) pow
        rw [←factor] at bound
        exact Or.inl (through_segment whole (IH (step x) (step_pos _) (step_odd _) (by omega)))
    | succ r =>
      by_cases two : b = 2
      · rw [two] at factor
        exact Or.inr ⟨x,j,s,B,r+1,by omega,by omega,odd,height,by omega,fromN,run,factor⟩
      · obtain ⟨hp,ho,hl,ns,ws⟩ := history_capture fromN positive odd height run (by omega) factor
        exact Or.inl (through_meeting ns ws (IH _ hp ho hl))

/-- A remainder below a later checkpoint also lies strictly below the
earlier checkpoint whenever the physical tail is strictly decreasing. -/
def RemainingBelow (N bound : Nat) : Prop :=
  ∃ x j s B r : Nat,
    N ≤ x ∧ x < bound ∧ x % 2 = 1 ∧ x < 2 * N + 1 ∧ 1 ≤ r ∧
    Segment N x j s B ∧ Ones x r ∧
    3 * orbit x r + 1 = 4 * orbit x (r + 1)

theorem remaining_strict {N P x : Nat} (h : RemainingAtMost N P)
    (hPx : P < x) : RemainingBelow N x := by
  obtain ⟨y,j,s,B,r,hNy,hyP,ho,hw,hr,seg,run,factor⟩ := h
  exact ⟨y,j,s,B,r,hNy,by omega,ho,hw,hr,seg,run,factor⟩

/-- Consume a physical decreasing tail with the *same original N*.
The historical additive is transported, and the next unresolved pivot is
strictly below the old one. The disjunction is not itself full coverage. -/
theorem consume_strict_tail {N x P j s B m d C : Nat}
    (Nbig : 1 < N) (fromN : Segment N x j s B)
    (xpos : 0 < x) (xodd : x % 2 = 1) (window : x < 2 * N + 1)
    (tail : Segment x P m d C) (small : P < x)
    (IH : ∀ w : Nat, 0 < w → w % 2 = 1 → w < N → ∃ i, orbit w i = 1) :
    Segment N P (j + m) (s + d) (3^m * B + C * 2^s) ∧
      ((∃ i, orbit N i = 1) ∨ RemainingBelow N x) := by
  have combined : Segment N P (j + m) (s + d) (3^m * B + C * 2^s) :=
    transport fromN tail
  have endpoint : orbit x m = P := A2Header.physical_endpoint tail.physical
  have ppos : 0 < P := by rw [←endpoint]; exact orbit_pos x xpos m
  have podd : P % 2 = 1 := by rw [←endpoint]; exact orbit_odd x xodd m
  have result := reduce_window_bounded Nbig combined ppos podd (by omega) IH
  refine ⟨combined, ?_⟩
  rcases result with done | rem
  · exact Or.inl done
  · exact Or.inr (remaining_strict rem small)

/-- Exact `(a,c)=(5,2)` reentry interface: the local physical word is
`(1,2,2,1,2)`. No independent height guard is assumed. -/
theorem consume_five_two {N x P j s B : Nat}
    (Nbig : 29 ≤ N) (hx : N ≤ x) (xodd : x % 2 = 1)
    (window : x < 2 * N + 1) (fromN : Segment N x j s B)
    (tail : Segment x P 5 8 367)
    (IH : ∀ w : Nat, 0 < w → w % 2 = 1 → w < N → ∃ i, orbit w i = 1) :
    Segment N P (j + 5) (s + 8) (3^5 * B + 367 * 2^s) ∧
      ((∃ i, orbit N i = 1) ∨ RemainingBelow N x) := by
  have relation : 256 * P = 243 * x + 367 := by
    simpa only [show (2:Nat)^8 = 256 by decide,
      show (3:Nat)^5 = 243 by decide] using tail.book
  have xbig : 29 ≤ x := Nat.le_trans Nbig hx
  have small : P < x := by omega
  exact consume_strict_tail (by omega) fromN (by omega) xodd window tail small IH

/-- Exact `(a,c)=(7,2)` reentry interface: the local physical word is
`(1,2,2,2,1,2)`. Its strict rank follows from the complete local book. -/
theorem consume_seven_two {N x P j s B : Nat}
    (Nbig : 29 ≤ N) (hx : N ≤ x) (xodd : x % 2 = 1)
    (window : x < 2 * N + 1) (fromN : Segment N x j s B)
    (tail : Segment x P 6 10 1549)
    (IH : ∀ w : Nat, 0 < w → w % 2 = 1 → w < N → ∃ i, orbit w i = 1) :
    Segment N P (j + 6) (s + 10) (3^6 * B + 1549 * 2^s) ∧
      ((∃ i, orbit N i = 1) ∨ RemainingBelow N x) := by
  have relation : 1024 * P = 729 * x + 1549 := by
    simpa only [show (2:Nat)^10 = 1024 by decide,
      show (3:Nat)^6 = 729 by decide] using tail.book
  have xbig : 29 ≤ x := Nat.le_trans Nbig hx
  have small : P < x := by omega
  exact consume_strict_tail (by omega) fromN (by omega) xodd window tail small IH

end CollatzCharacterBridge.A2BoundedReducer
