import P5OddExit

namespace CollatzCharacterBridge.P5RenewalRun

open A2Header (Physical)
open StagedCylinder (Segment)
open P5OddExit (renewStart renewEnd renewal_measure renewal_reserve renewal_segments)

set_option maxRecDepth 12000
set_option maxHeartbeats 200000

/-- The lower bound makes the natural subtraction exact and the
measure strictly positive. An odd cofactor certifies the exponent. -/
structure Reserve (x b : Nat) : Prop where
  minimum : 5≤x
  odd : x%2=1
  factor : ∃ r : Nat, r%2=1 ∧ 5*x-19=2^b*r

theorem reserve_exists {x : Nat} (hx : 5≤x) (ho : x%2=1) :
    ∃ b : Nat, Reserve x b := by
  have hp : 0<5*x-19 := by omega
  obtain ⟨b,hb⟩ := oddPart_factor _ hp
  exact ⟨b,hx,ho,oddPart (5*x-19),(oddPart_pos_and_odd _ hp).2,hb⟩

theorem reserve_positive {x b : Nat} (h : Reserve x b) : 1≤b := by
  obtain ⟨r,hr,hf⟩ := h.factor
  have hx := h.minimum
  have ho := h.odd
  by_cases hb : 1≤b
  · exact hb
  · have hz : b=0 := by omega
    rw [hz,Nat.pow_zero,Nat.one_mul] at hf
    omega

/-- The coordinate guard is equivalent to six bits of actual reserve. -/
theorem guard_iff {x b : Nat} (h : Reserve x b) :
    (∃ k : Nat, x=renewStart k) ↔ 6≤b := by
  obtain ⟨r,hr,hf⟩ := h.factor
  have hx := h.minimum
  constructor
  · rintro ⟨k,rfl⟩
    have h64 : (2:Nat)^6 ∣ 5*renewStart k-19 :=
      Nat.dvd_of_mod_eq_zero (renewal_measure k).1
    by_cases hb : 6≤b
    · exact hb
    · have tooMuch : 2^(b+1) ∣ 5*renewStart k-19 :=
        Nat.dvd_trans (Nat.pow_dvd_pow 2 (by omega : b+1≤6)) h64
      exact False.elim ((P5R3S5.exact_reserve hr hf).2 tooMuch)
  · intro hb
    have hd : (2:Nat)^6 ∣ 5*x-19 := by
      rw [hf]
      exact Nat.dvd_trans (Nat.pow_dvd_pow 2 hb) (Nat.dvd_mul_right _ _)
    obtain ⟨j,hj⟩ := hd
    change 5*x-19=64*j at hj
    have ha : x+64*x=55+64*(13*j+3) := by omega
    have hm := congrArg (fun n : Nat => n%64) ha
    simp only [Nat.add_mul_mod_self_left] at hm
    refine ⟨x/64,?_⟩
    have hdiv := Nat.mod_add_div x 64
    simp only [renewStart]
    omega

private theorem reserve_after_block {k b : Nat} (h : Reserve (renewStart k) b)
    (hb : 6≤b) : Reserve (renewEnd k) (b-5) := by
  obtain ⟨r,hr,hf⟩ := h.factor
  refine ⟨?_,?_,27*r,by omega,(renewal_reserve (by omega) hr hf).1⟩
  · simp only [renewEnd]
    omega
  · simp only [renewEnd]
    omega

/-- A run consists only of certified (1,1,3)/(2,2,1) blocks.
The zero run is the empty physical history. -/
inductive Run : Nat → Nat → Nat → Prop where
  | empty (x : Nat) : Run x 0 x
  | block {k n y : Nat} (tail : Run (renewEnd k) n y) : Run (renewStart k) (n+1) y

theorem run_succ_iff {x n y : Nat} :
    Run x (n+1) y ↔ ∃ k, x=renewStart k ∧ Run (renewEnd k) n y := by
  constructor
  · intro h
    cases h with
    | block tail => exact ⟨_,rfl,tail⟩
  · rintro ⟨k,rfl,tail⟩
    exact Run.block tail

/-- Every admitted run consumes exactly five bits per block. -/
theorem run_remaining {x n y b : Nat} (run : Run x n y) (h : Reserve x b) :
    Reserve y (b-5*n) := by
  induction run generalizing b with
  | empty x => simpa using h
  | @block k n y tail ih =>
    have hb : 6≤b := (guard_iff h).mp ⟨k,rfl⟩
    have remain := ih (reserve_after_block h hb)
    rw [show b-5*(n+1)=(b-5)-5*n by omega]
    exact remain

theorem run_capacity {x b : Nat} (h : Reserve x b) (n : Nat) :
    (∃ y, Run x n y) ↔ 5*n+1≤b := by
  induction n generalizing x b with
  | zero => exact ⟨fun _ => by simpa using reserve_positive h, fun _ => ⟨x,Run.empty x⟩⟩
  | succ n ih =>
    constructor
    · rintro ⟨y,hy⟩
      obtain ⟨k,rfl,tail⟩ := run_succ_iff.mp hy
      have hb : 6≤b := (guard_iff h).mp ⟨k,rfl⟩
      have hn := (ih (reserve_after_block h hb)).mp ⟨y,tail⟩
      omega
    · intro hn
      have hb : 6≤b := by omega
      obtain ⟨k,rfl⟩ := (guard_iff h).mpr hb
      obtain ⟨y,hy⟩ := (ih (reserve_after_block h hb)).mpr (by omega)
      exact ⟨y,Run.block hy⟩

theorem exact_run_range {x b : Nat} (h : Reserve x b) (n : Nat) :
    (∃ y, Run x n y) ↔ n≤(b-1)/5 := by
  have hb := reserve_positive h
  rw [run_capacity h n]
  omega

theorem maximal_run {x b : Nat} (h : Reserve x b) :
    ∃ y, Run x ((b-1)/5) y ∧ ¬∃ k, y=renewStart k := by
  obtain ⟨y,run⟩ := (exact_run_range h ((b-1)/5)).mpr (Nat.le_refl _)
  have remain := run_remaining run h
  have hb := reserve_positive h
  exact ⟨y,run,fun guard => by
    have hs := (guard_iff remain).mp guard
    omega⟩

/-- Prepending a block adds its local cost with the length of the
tail and scales the tail's additive by the five divisions. -/
def runAdditive (blockCost : Nat) : Nat → Nat
  | 0 => 0
  | n+1 => 3^(3*n)*blockCost+32*runAdditive blockCost n

theorem run_segments {x n y : Nat} (run : Run x n y) :
    Segment x y (3*n) (5*n) (runAdditive 19 n) ∧
    Segment (3*x-4) (3*y-4) (3*n) (5*n) (runAdditive 37 n) := by
  induction run with
  | empty x =>
    exact ⟨⟨Physical.refl _,by simp [runAdditive]⟩,
      ⟨Physical.refl _,by simp [runAdditive]⟩⟩
  | @block k n y tail ih =>
    obtain ⟨hn,hw,_⟩ := renewal_segments k
    have hj : 3+3*n=3*(n+1) := by omega
    have hs : 5+5*n=5*(n+1) := by omega
    exact ⟨by simpa only [hj,hs,runAdditive] using StagedCylinder.compose hn ih.1,
      by simpa only [hj,hs,runAdditive] using StagedCylinder.compose hw ih.2⟩

/-- Compose each finite block run with its own supplied historical
prefix without identifying the two origins. -/
theorem run_histories {x n y N w jN sN bN jW sW bW : Nat}
    (run : Run x n y)
    (original : Segment N x jN sN bN)
    (source : Segment w (3*x-4) jW sW bW) :
    Segment N y (jN+3*n) (sN+5*n) (3^(3*n)*bN+runAdditive 19 n*2^sN) ∧
    Segment w (3*y-4) (jW+3*n) (sW+5*n) (3^(3*n)*bW+runAdditive 37 n*2^sW) := by
  obtain ⟨hn,hw⟩ := run_segments run
  exact ⟨P5R3S5.transport original hn,P5R3S5.transport source hw⟩

#print axioms reserve_exists
#print axioms reserve_positive
#print axioms guard_iff
#print axioms reserve_after_block
#print axioms run_succ_iff
#print axioms run_remaining
#print axioms run_capacity
#print axioms exact_run_range
#print axioms maximal_run
#print axioms run_segments
#print axioms run_histories

end CollatzCharacterBridge.P5RenewalRun
