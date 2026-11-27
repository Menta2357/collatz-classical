import StagedCylinder
import Arrival

namespace CollatzCharacterBridge.P5R3S5

set_option maxRecDepth 16000
set_option maxHeartbeats 1000000

open A2Header (Physical)
open StagedCylinder (Segment)

theorem actual_step_factor (x : Nat) (hodd : x%2=1) :
    ∃ b : Nat, 1≤b ∧ 3*x+1=2^b*step x := by
  obtain ⟨b,hb⟩ := oddPart_factor (3*x+1) (by omega)
  change 3*x+1=2^b*step x at hb
  have ht := step_odd x
  by_cases hz : b=0
  · rw [hz] at hb
    simp only [Nat.pow_zero,Nat.one_mul] at hb
    omega
  · exact ⟨b,by omega,hb⟩

theorem step_segment (x b : Nat) (hx : 0<x) (hodd : x%2=1)
    (hb : 1≤b) (hf : 3*x+1=2^b*step x) : Segment x (step x) 1 b 1 :=
  ⟨Physical.edge hx hodd (step_pos x) (step_odd x) (by omega) hf,hf.symm⟩

/-- An odd cofactor certifies the exact power, not only divisibility. -/
theorem exact_reserve {n u z : Nat} (hz : z%2=1) (hf : n=2^u*z) :
    2^u ∣ n ∧ ¬2^(u+1) ∣ n := by
  constructor
  · exact ⟨z,hf⟩
  · rintro ⟨v,hv⟩
    have hv' : n=2^u*(2*v) := by
      rw [Nat.pow_succ] at hv
      exact hv.trans (by ac_rfl)
    have he : 2^u*z=2^u*(2*v) := hf.symm.trans hv'
    have hc := Nat.mul_left_cancel (Nat.pow_pos (by decide : 0<2)) he
    omega

/-- Transport a local physical segment without changing its own
    original source or replacing its earlier additive. -/
theorem transport {N x y j S B r d c : Nat}
    (origin : Segment N x j S B) (tail : Segment x y r d c) :
    Segment N y (j+r) (S+d) (3^r*B+c*2^S) := by
  have hh := StagedCylinder.compose origin tail
  have he : 3^r*B+2^S*c=3^r*B+c*2^S :=
    congrArg (fun t : Nat => 3^r*B+t) (Nat.mul_comm (2^S) c)
  rw [he] at hh
  exact hh

structure R3Relation (E F : Nat) : Prop where
  E_positive : 0<E
  E_odd : E%2=1
  F_positive : 0<F
  F_odd : F%2=1
  relation : 8*F+1=9*E

def r3U (E : Nat) : Nat := (3*E+1)/4
def r3V (F : Nat) : Nat := step F

theorem r3_class {E F : Nat} (hr : R3Relation E F) : E%16=1 := by
  have hf := hr.F_odd
  have he := hr.relation
  omega

theorem r3_pivot_data {E F : Nat} (hr : R3Relation E F) :
    0<r3U E ∧ r3U E%2=1 ∧ 4*r3U E=3*E+1 := by
  have hm := r3_class hr
  have he := hr.E_positive
  simp only [r3U]
  omega

theorem r3_E_segment {E F : Nat} (hr : R3Relation E F) :
    Segment E (r3U E) 1 2 1 := by
  have hu := r3_pivot_data hr
  exact ⟨Physical.edge hr.E_positive hr.E_odd hu.1 hu.2.1 (by decide) hu.2.2.symm,
    hu.2.2⟩

theorem r3_renewed_relation {E F b : Nat} (hr : R3Relation E F)
    (hf : 3*F+1=2^b*r3V F) : 2^(b+1)*r3V F+1=9*r3U E := by
  have he := hr.relation
  have hu := (r3_pivot_data hr).2.2
  have hp : 2^(b+1)*r3V F=2*(2^b*r3V F) := by
    rw [Nat.pow_succ]
    ac_rfl
  rw [hp,←hf]
  omega

theorem r3_rank {E F : Nat} (hr : R3Relation E F) :
    4*(r3U E-1)=3*(E-1) := by
  have hu := r3_pivot_data hr
  have he := hr.E_positive
  omega

theorem r3_strict {E F : Nat} (hr : R3Relation E F) (he : 1<E) : r3U E<E := by
  have hu := r3_pivot_data hr
  omega

theorem r3_one {E F : Nat} (hr : R3Relation E F) (he : E=1) : F=1 := by
  have hf := hr.relation
  omega

structure R3Certificate (E F b : Nat) : Prop where
  input : R3Relation E F
  b_ge : 1≤b
  actual_factor : 3*F+1=2^b*r3V F
  E_segment : Segment E (r3U E) 1 2 1
  F_segment : Segment F (r3V F) 1 b 1
  renewed : 2^(b+1)*r3V F+1=9*r3U E
  rank : 4*(r3U E-1)=3*(E-1)

theorem r3_kernel {E F : Nat} (hr : R3Relation E F) :
    ∃ b : Nat, R3Certificate E F b := by
  obtain ⟨b,hb,hf⟩ := actual_step_factor F hr.F_odd
  exact ⟨b,hr,hb,hf,r3_E_segment hr,
    step_segment F b hr.F_positive hr.F_odd hb hf,r3_renewed_relation hr hf,r3_rank hr⟩

theorem r3_histories {NE NF E F b jE SE BE jF SF BF : Nat}
    (hc : R3Certificate E F b)
    (historyE : Segment NE E jE SE BE) (historyF : Segment NF F jF SF BF) :
    Segment NE (r3U E) (jE+1) (SE+2) (3*BE+2^SE) ∧
    Segment NF (r3V F) (jF+1) (SF+b) (3*BF+2^SF) := by
  constructor
  · simpa only [Nat.pow_one,Nat.one_mul] using transport historyE hc.E_segment
  · simpa only [Nat.pow_one,Nat.one_mul] using transport historyF hc.F_segment

theorem r3_capture_one {NE NF E F jE SE BE jF SF BF : Nat}
    (hr : R3Relation E F) (he : E=1)
    (historyE : Segment NE E jE SE BE) (historyF : Segment NF F jF SF BF) :
    orbit NE jE=1 ∧ orbit NF jF=1 :=
  ⟨(A2Header.physical_endpoint historyE.physical).trans he,
    (A2Header.physical_endpoint historyF.physical).trans (r3_one hr he)⟩

/-- The complete alpha4,s5 row. InputE and inputF remain explicit;
    their equations, rather than an unproved reparametrization,
    connect them to the U-coordinate. -/
def s5U (k : Nat) : Nat := 51+64*k
def s5F (k : Nat) : Nat := 611+768*k
def s5D (k : Nat) : Nat := 917+1152*k
def s5J (k : Nat) : Nat := 43+54*k
def s5A (k : Nat) : Nat := 77+96*k
def s5Next (k : Nat) : Nat := 29+36*k
def s5Other (k : Nat) : Nat := step (s5J k)

structure S5Entry (E F k : Nat) : Prop where
  E_positive : 0<E
  E_odd : E%2=1
  F_positive : 0<F
  F_odd : F%2=1
  relation : 4*F+1=9*E
  alpha_four : 3*E+1=16*s5U k

theorem s5_F_coordinates {E F k : Nat} (hr : S5Entry E F k) : F=s5F k := by
  have h1 := hr.relation
  have h2 := hr.alpha_four
  simp only [s5F,s5U] at *
  omega

theorem s5_phase (k : Nat) :
    s5U k%64=51 ∧ 27*s5U k-1=32*s5J k ∧
    2^5 ∣ 27*s5U k-1 ∧ ¬2^6 ∣ 27*s5U k-1 := by
  have hj : s5J k%2=1 := by simp only [s5J]; omega
  have he : 27*s5U k-1=2^5*s5J k := by simp only [s5U,s5J]; omega
  have hex := exact_reserve hj he
  exact ⟨by simp only [s5U]; omega,he,hex.1,hex.2⟩

theorem s5_fixed_edges (k : Nat) :
    Physical (s5F k) 1 1 (s5D k) ∧ Physical (s5D k) 1 6 (s5J k) ∧
    Physical (s5U k) 1 1 (s5A k) ∧ Physical (s5A k) 1 3 (s5Next k) := by
  refine ⟨?_,?_,?_,?_⟩
  all_goals apply Physical.edge
  all_goals try simp only [s5F,s5D,s5J,s5U,s5A,s5Next]
  all_goals omega

theorem s5_U_local (k : Nat) : Segment (s5U k) (s5Next k) 2 4 5 := by
  have he := s5_fixed_edges k
  have e1 : Segment (s5U k) (s5A k) 1 1 1 := by
    refine ⟨he.2.2.1,?_⟩
    simp only [s5U,s5A]
    omega
  have e2 : Segment (s5A k) (s5Next k) 1 3 1 := by
    refine ⟨he.2.2.2,?_⟩
    simp only [s5A,s5Next]
    omega
  exact StagedCylinder.compose e1 e2

theorem s5_F_to_J (k : Nat) : Segment (s5F k) (s5J k) 2 7 5 := by
  have he := s5_fixed_edges k
  have e1 : Segment (s5F k) (s5D k) 1 1 1 := by
    refine ⟨he.1,?_⟩
    simp only [s5F,s5D]
    omega
  have e2 : Segment (s5D k) (s5J k) 1 6 1 := by
    refine ⟨he.2.1,?_⟩
    simp only [s5D,s5J]
    omega
  exact StagedCylinder.compose e1 e2

theorem s5_E_first {E F k : Nat} (hr : S5Entry E F k) :
    Segment E (s5U k) 1 4 1 := by
  have hu : 0<s5U k ∧ s5U k%2=1 := by simp only [s5U]; omega
  exact ⟨Physical.edge hr.E_positive hr.E_odd hu.1 hu.2 (by decide) hr.alpha_four,
    hr.alpha_four.symm⟩

theorem s5_E_local {E F k : Nat} (hr : S5Entry E F k) :
    Segment E (s5Next k) 3 8 89 :=
  StagedCylinder.compose (s5_E_first hr) (s5_U_local k)

theorem s5_relation_after (k b : Nat) (hf : 3*s5J k+1=2^b*s5Other k) :
    2^(b+1)*s5Other k+1=9*s5Next k := by
  have he : 2^(b+1)*s5Other k=2*(2^b*s5Other k) := by
    rw [Nat.pow_succ]
    ac_rfl
  rw [he,←hf]
  simp only [s5J,s5Next]
  omega

theorem s5_order {E F k : Nat} (hr : S5Entry E F k) :
    1<s5Next k ∧ s5Next k<s5U k ∧ s5U k<E := by
  have he := hr.alpha_four
  simp only [s5Next,s5U] at *
  omega

theorem s5_rank {E F k : Nat} (hr : S5Entry E F k) :
    16*(s5Next k-1)≤3*(E-1) ∧ 4*(s5Next k-1)≤3*(E-1) := by
  have he := hr.alpha_four
  have hep := hr.E_positive
  simp only [s5Next,s5U] at *
  omega

structure S5Certificate (E F k u : Nat) : Prop where
  input : S5Entry E F k
  u_ge : 2≤u
  F_prefix : Segment F (s5J k) 2 7 5
  U_prefix : Segment (s5U k) (s5Next k) 2 4 5
  terminal : Segment (s5J k) (s5Other k) 1 (u-1) 1
  actual_factor : 3*s5J k+1=2^(u-1)*s5Other k
  E_segment : Segment E (s5Next k) 3 8 89
  F_segment : Segment F (s5Other k) 3 (u+6) 143
  renewed : 2^u*s5Other k+1=9*s5Next k
  exact_u : 2^u ∣ 9*s5Next k-1 ∧ ¬2^(u+1) ∣ 9*s5Next k-1
  strict : s5Next k<E
  rank : 4*(s5Next k-1)≤3*(E-1)
  stronger_rank : 16*(s5Next k-1)≤3*(E-1)

theorem s5_kernel {E F k : Nat} (hr : S5Entry E F k) :
    ∃ u : Nat, S5Certificate E F k u := by
  have hj : 0<s5J k ∧ s5J k%2=1 := by simp only [s5J]; omega
  obtain ⟨b,hb,hf⟩ := actual_step_factor (s5J k) hj.2
  let u := b+1
  have hu : 2≤u := by dsimp only [u]; omega
  have hminus : u-1=b := by dsimp only [u]; omega
  have hterm : Segment (s5J k) (s5Other k) 1 (u-1) 1 := by
    rw [hminus]
    exact step_segment (s5J k) b hj.1 hj.2 hb hf
  have hfac : 3*s5J k+1=2^(u-1)*s5Other k := by simpa only [hminus] using hf
  have hpref : Segment F (s5J k) 2 7 5 := by
    have hp := s5_F_to_J k
    rw [←s5_F_coordinates hr] at hp
    exact hp
  have hlocal := StagedCylinder.compose hpref hterm
  rw [show 7+(u-1)=u+6 by omega] at hlocal
  have hrenew : 2^u*s5Other k+1=9*s5Next k := s5_relation_after k b hf
  have hbook : 9*s5Next k-1=2^u*s5Other k := by omega
  have hex := exact_reserve (step_odd (s5J k)) hbook
  have ho := s5_order hr
  have hrate := s5_rank hr
  exact ⟨u,hr,hu,hpref,s5_U_local k,hterm,hfac,s5_E_local hr,hlocal,
    hrenew,hex,by omega,hrate.2,hrate.1⟩

theorem s5_histories {NE NF E F k u jE SE BE jF SF BF : Nat}
    (hc : S5Certificate E F k u)
    (historyE : Segment NE E jE SE BE) (historyF : Segment NF F jF SF BF) :
    Segment NE (s5Next k) (jE+3) (SE+8) (27*BE+89*2^SE) ∧
    Segment NF (s5Other k) (jF+3) (SF+(u+6)) (27*BF+143*2^SF) :=
  ⟨transport historyE hc.E_segment,transport historyF hc.F_segment⟩

/-- Iteration is conditional on every admitted step having its
    proved guard/rate. No such policy is manufactured here. -/
theorem rank_iterate (p : Nat → Nat)
    (admitted : ∀ i : Nat, 4*(p (i+1)-1)≤3*(p i-1)) (m : Nat) :
    4^m*(p m-1)≤3^m*(p 0-1) := by
  induction m with
  | zero => simp
  | succ m ih =>
    have h1 := Nat.mul_le_mul_left (4^m) (admitted m)
    have h2 := Nat.mul_le_mul_left 3 ih
    calc
      _ = 4^m*(4*(p (m+1)-1)) := by rw [Nat.pow_succ]; ac_rfl
      _ ≤ 4^m*(3*(p m-1)) := h1
      _ = 3*(4^m*(p m-1)) := by ac_rfl
      _ ≤ 3*(3^m*(p 0-1)) := h2
      _ = _ := by rw [Nat.pow_succ]; ac_rfl

#print axioms actual_step_factor
#print axioms step_segment
#print axioms exact_reserve
#print axioms transport
#print axioms r3_class
#print axioms r3_pivot_data
#print axioms r3_E_segment
#print axioms r3_renewed_relation
#print axioms r3_rank
#print axioms r3_strict
#print axioms r3_one
#print axioms r3_kernel
#print axioms r3_histories
#print axioms r3_capture_one
#print axioms s5_F_coordinates
#print axioms s5_phase
#print axioms s5_fixed_edges
#print axioms s5_U_local
#print axioms s5_F_to_J
#print axioms s5_E_first
#print axioms s5_E_local
#print axioms s5_relation_after
#print axioms s5_order
#print axioms s5_rank
#print axioms s5_kernel
#print axioms s5_histories
#print axioms rank_iterate

end CollatzCharacterBridge.P5R3S5
