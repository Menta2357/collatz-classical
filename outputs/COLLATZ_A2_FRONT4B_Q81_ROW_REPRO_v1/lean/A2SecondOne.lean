import StagedCylinder
import TwosCompression

namespace CollatzCharacterBridge.A2SecondOne

open A2Header (Physical)
open StagedCylinder (Segment)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

def N (t : Nat) : Nat := A2Header.seed t
def U (t : Nat) : Nat := A2Header.U t
def firstEnd (r H : Nat) : Nat := TwosCompression.runEnd r H
def afterFirstOne (r H : Nat) : Nat := step (firstEnd r H)
def secondEnd (s G : Nat) : Nat := TwosCompression.runEnd s G
def afterSecondOne (s G : Nat) : Nat := step (secondEnd s G)

def firstCost (r : Nat) : Nat :=
  3^r*A2Header.B45+2^70*(4^r-3^r)
def afterFirstCost (r : Nat) : Nat :=
  3*firstCost r+2^(70+2*r)
def beforeSecondCost (r s : Nat) : Nat :=
  3^s*afterFirstCost r+2^(71+2*r)*(4^s-3^s)
def afterSecondCost (r s : Nat) : Nat :=
  3*beforeSecondCost r s+2^(71+2*r+2*s)

theorem header_segment (t : Nat) :
    Segment (N t) (U t) 45 70 A2Header.B45 :=
  ⟨A2Header.header_physical t,A2Header.original_ledger t⟩

/-- Turn an actually supplied run of valuation-two returns into a physical
    history with its exact accumulated division clock. -/
theorem twos_physical {x m : Nat} (hx : 0<x) (hxo : x%2=1)
    (h : TwosCompression.Twos x m) :
    Physical x m (2*m) (orbit x m) := by
  induction m with
  | zero => simpa using Physical.refl x
  | succ m ih =>
    have hp : TwosCompression.Twos x m := fun i hi => h i (by omega)
    have prefixHistory := ih hp
    have hf := h m (by omega)
    have edgeHistory : Physical (orbit x m) 1 2 (orbit x (m+1)) := by
      apply Physical.edge
      · exact orbit_pos x hx m
      · exact orbit_odd x hxo m
      · exact orbit_pos x hx (m+1)
      · exact orbit_odd x hxo (m+1)
      · decide
      · simpa using hf
    have both := Physical.append prefixHistory edgeHistory
    simpa only [Nat.mul_add,Nat.mul_one] using both

theorem twos_segment (m A : Nat) :
    Segment (TwosCompression.runStart m A) (TwosCompression.runEnd m A)
      m (2*m) (4^m-3^m) := by
  have hs := TwosCompression.two_prefix m A
  have hpos : 0<TwosCompression.runStart m A := by
    simp only [TwosCompression.runStart]
    omega
  have hodd : TwosCompression.runStart m A%2=1 := by
    simp [TwosCompression.runStart,Nat.add_mod,Nat.mul_mod]
  have hp := twos_physical hpos hodd hs.2
  rw [hs.1] at hp
  refine ⟨hp,?_⟩
  rw [TwosCompression.power_conversion]
  exact TwosCompression.local_ledger m A

theorem first_one_segment (r H : Nat) (ho : H%2=1) :
    Segment (firstEnd r H) (afterFirstOne r H) 1 1 1 := by
  have hf := (TwosCompression.odd_exit r H ho).1
  have hs : 0<firstEnd r H ∧ firstEnd r H%2=1 := by
    constructor
    · simp only [firstEnd,TwosCompression.runEnd]; omega
    · simp [firstEnd,TwosCompression.runEnd,Nat.add_mod,Nat.mul_mod]
  have ht : 0<afterFirstOne r H ∧ afterFirstOne r H%2=1 :=
    ⟨step_pos _,step_odd _⟩
  exact ⟨Physical.edge hs.1 hs.2 ht.1 ht.2 (by decide) hf,hf.symm⟩

theorem second_one_segment (s G : Nat) (go : G%2=1) :
    Segment (secondEnd s G) (afterSecondOne s G) 1 1 1 := by
  have hf := (TwosCompression.odd_exit s G go).1
  have hs : 0<secondEnd s G ∧ secondEnd s G%2=1 := by
    constructor
    · simp only [secondEnd,TwosCompression.runEnd]; omega
    · simp [secondEnd,TwosCompression.runEnd,Nat.add_mod,Nat.mul_mod]
  have ht : 0<afterSecondOne s G ∧ afterSecondOne s G%2=1 :=
    ⟨step_pos _,step_odd _⟩
  exact ⟨Physical.edge hs.1 hs.2 ht.1 ht.2 (by decide) hf,hf.symm⟩

theorem first_history (t r H : Nat)
    (hU : U t=TwosCompression.runStart r H) :
    Segment (N t) (firstEnd r H) (45+r) (70+2*r) (firstCost r) := by
  have hlocal := twos_segment r H
  rw [←hU] at hlocal
  simpa only [firstCost] using StagedCylinder.compose (header_segment t) hlocal

theorem after_first_one_history (t r H : Nat) (ho : H%2=1)
    (hU : U t=TwosCompression.runStart r H) :
    Segment (N t) (afterFirstOne r H) (46+r) (71+2*r) (afterFirstCost r) := by
  have both := StagedCylinder.compose (first_history t r H hU)
    (first_one_segment r H ho)
  simpa only [afterFirstCost,Nat.pow_one,Nat.one_mul,Nat.mul_one,
    show 45+r+1=46+r by omega,show 70+2*r+1=71+2*r by omega] using both

theorem before_second_one_history (t r s H G : Nat)
    (ho : H%2=1)
    (hU : U t=TwosCompression.runStart r H)
    (hX : afterFirstOne r H=TwosCompression.runStart s G) :
    Segment (N t) (secondEnd s G) (46+r+s) (71+2*r+2*s)
      (beforeSecondCost r s) := by
  have hlocal := twos_segment s G
  rw [←hX] at hlocal
  have both := StagedCylinder.compose (after_first_one_history t r H ho hU) hlocal
  simpa only [beforeSecondCost,Nat.add_assoc,Nat.mul_add,Nat.mul_one] using both

theorem second_one_history (t r s H G : Nat)
    (ho : H%2=1) (go : G%2=1)
    (hU : U t=TwosCompression.runStart r H)
    (hX : afterFirstOne r H=TwosCompression.runStart s G) :
    Segment (N t) (afterSecondOne s G) (47+r+s) (72+2*r+2*s)
      (afterSecondCost r s) := by
  have both := StagedCylinder.compose
    (before_second_one_history t r s H G ho hU hX)
    (second_one_segment s G go)
  rw [show 46+r+s+1=47+r+s by omega,
    show 71+2*r+2*s+1=72+2*r+2*s by omega] at both
  simpa only [afterSecondCost,Nat.pow_one,Nat.one_mul,Nat.mul_one] using both

theorem runEnd_le_runStart (m A : Nat) :
    TwosCompression.runEnd m A≤TwosCompression.runStart m A := by
  have hp : 3^m≤4^m := Nat.pow_le_pow_left (by decide : (3:Nat)≤4) m
  have hm := Nat.mul_le_mul_right (2*A) hp
  simp only [TwosCompression.runStart,TwosCompression.runEnd]
  apply Nat.add_le_add_left
  calc
    2*3^m*A = 3^m*(2*A) := by ac_rfl
    _ ≤ 4^m*(2*A) := hm
    _ = 2*4^m*A := by ac_rfl

theorem first_height (t r H : Nat)
    (hU : U t=TwosCompression.runStart r H) : firstEnd r H<4*N t+1 := by
  have hle := runEnd_le_runStart r H
  have hcoarse := A2Header.coarse_upper t
  have hn := A2Header.seed_admissible t
  have hu := A2Header.endpoint_admissible t
  simp only [N,U,firstEnd] at *
  rw [←hU] at hle
  omega

theorem after_first_height (t r H : Nat) (ho : H%2=1)
    (hU : U t=TwosCompression.runStart r H) : afterFirstOne r H<4*N t+1 := by
  have hle := runEnd_le_runStart r H
  have hf := (TwosCompression.odd_exit r H ho).1
  have hcoarse := A2Header.coarse_upper t
  have hn := A2Header.seed_admissible t
  have hu := A2Header.endpoint_admissible t
  simp only [N,U,firstEnd,afterFirstOne] at *
  rw [←hU] at hle
  omega

theorem before_second_height (t r s H G : Nat) (ho : H%2=1)
    (hU : U t=TwosCompression.runStart r H)
    (hX : afterFirstOne r H=TwosCompression.runStart s G) :
    secondEnd s G<4*N t+1 := by
  have hle := runEnd_le_runStart s G
  have hx := after_first_height t r H ho hU
  simp only [secondEnd] at hle ⊢
  rw [←hX] at hle
  omega

/-- Generic quarter certificate. It is deliberately stated over an arbitrary
    retained original book, so it applies both before and after the first one. -/
theorem quarter_capture {N0 X j S B d : Nat} (prefixHistory : Segment N0 X j S B)
    (hheight : X<4*N0+1) (hd : 3≤d)
    (hf : 3*X+1=2^d*step X) :
    let w := (X-1)/4
    0<w ∧ w%2=1 ∧ w<N0 ∧
      Segment N0 (step X) (j+1) (S+d) (3*B+2^S) ∧
      Segment w (step X) 1 (d-2) 1 ∧
      orbit N0 (j+1)=orbit w 1 := by
  have hphase := FixedSourceRun.phase_from_real_break X d (step X) hd hf
  have hx : 1<X := by omega
  have hstrict : X<4*N0 := by omega
  have hcap := capture hx hstrict hphase
  dsimp only at hcap ⊢
  let w : Nat := (X-1)/4
  have hw : 4*w+1=X := by dsimp only [w]; omega
  have hsource : 3*w+1=2^(d-2)*step X := by
    apply Nat.mul_left_cancel (by decide : 0<4)
    calc
      _ = 3*X+1 := by omega
      _ = 2^d*step X := hf
      _ = _ := by
        rw [show d=(d-2)+2 by omega,Nat.pow_add 2 (d-2) 2]
        change (2^(d-2)*4)*step X=4*(2^(d-2)*step X)
        ac_rfl
  have htail : Segment X (step X) 1 d 1 := by
    have hp := step_pos X
    have ho := step_odd X
    exact ⟨Physical.edge (by omega) (by omega) hp ho (by omega) hf,hf.symm⟩
  have originalExtended := StagedCylinder.compose prefixHistory htail
  have sourceHistory : Segment w (step X) 1 (d-2) 1 := by
    exact ⟨Physical.edge hcap.1 hcap.2.1 (step_pos X) (step_odd X)
      (by omega) hsource,hsource.symm⟩
  refine ⟨hcap.1,hcap.2.1,hcap.2.2.1,?_,sourceHistory,?_⟩
  · simpa only [Nat.pow_one,Nat.one_mul,Nat.mul_one] using originalExtended
  · exact (A2Header.physical_endpoint originalExtended.physical).trans
      (A2Header.physical_endpoint sourceHistory.physical).symm

theorem quarter_before_first_one (t r H d : Nat)
    (hU : U t=TwosCompression.runStart r H) (hd : 3≤d)
    (hf : 3*firstEnd r H+1=2^d*step (firstEnd r H)) :
    let w := (firstEnd r H-1)/4
    0<w ∧ w%2=1 ∧ w<N t ∧
      Segment (N t) (step (firstEnd r H)) (46+r) (70+2*r+d)
        (3*firstCost r+2^(70+2*r)) ∧
      Segment w (step (firstEnd r H)) 1 (d-2) 1 ∧
      orbit (N t) (46+r)=orbit w 1 := by
  have h := quarter_capture (first_history t r H hU) (first_height t r H hU) hd hf
  simpa only [show 45+r+1=46+r by omega] using h

theorem quarter_before_second_one (t r s H G d : Nat)
    (ho : H%2=1) (hU : U t=TwosCompression.runStart r H)
    (hX : afterFirstOne r H=TwosCompression.runStart s G) (hd : 3≤d)
    (hf : 3*secondEnd s G+1=2^d*step (secondEnd s G)) :
    let w := (secondEnd s G-1)/4
    0<w ∧ w%2=1 ∧ w<N t ∧
      Segment (N t) (step (secondEnd s G)) (47+r+s) (71+2*r+2*s+d)
        (3*beforeSecondCost r s+2^(71+2*r+2*s)) ∧
      Segment w (step (secondEnd s G)) 1 (d-2) 1 ∧
      orbit (N t) (47+r+s)=orbit w 1 := by
  have h := quarter_capture (before_second_one_history t r s H G ho hU hX)
    (before_second_height t r s H G ho hU hX) hd hf
  simpa only [show 46+r+s+1=47+r+s by omega] using h

private theorem orbit_one (i : Nat) : orbit 1 i=1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i)=1
    rw [ih]
    change oddPart 4=1
    exact (oddPart_quadruple 1).trans (oddPart_of_odd (by decide))

theorem quarter_closes_under_IH {N0 X j S B d : Nat}
    (prefixHistory : Segment N0 X j S B) (hheight : X<4*N0+1)
    (hd : 3≤d) (hf : 3*X+1=2^d*step X)
    (IH : ∀ w : Nat, 0<w → w%2=1 → w<N0 → ∃ i, orbit w i=1) :
    ∃ i, orbit N0 i=1 := by
  obtain ⟨hp,ho,hlt,_original,_source,meeting⟩ :=
    quarter_capture prefixHistory hheight hd hf
  let w : Nat := (X-1)/4
  obtain ⟨i,hi⟩ := IH w hp ho hlt
  refine ⟨(j+1)+i,?_⟩
  rw [orbit_add,meeting,←orbit_add w 1 i,show 1+i=i+1 by omega,
    orbit_add w i 1,hi,orbit_one]

/-- Four valuation-two returns from the A2 header already descend. -/
theorem four_twos_descent (t A : Nat)
    (hU : U t=TwosCompression.runStart 4 A) : firstEnd 4 A<N t := by
  have hbook := TwosCompression.local_ledger 4 A
  have hcoarse := A2Header.coarse_upper t
  have hn := A2Header.seed_admissible t
  simp only [N,U,firstEnd] at *
  rw [hU] at hcoarse
  simp only [show (4:Nat)^4=256 by decide,show (3:Nat)^4=81 by decide] at hbook
  omega

theorem four_twos_history (t A : Nat)
    (hU : U t=TwosCompression.runStart 4 A) :
    Segment (N t) (firstEnd 4 A) 49 78 (firstCost 4) := by
  simpa using first_history t 4 A hU

/-- Five valuation-two returns, split arbitrarily around one real valuation-one
    return, also force strict descent before a second one is needed. -/
theorem five_twos_one_descent (t r s H G : Nat)
    (ho : H%2=1) (hrs : r+s=5)
    (hU : U t=TwosCompression.runStart r H)
    (hX : afterFirstOne r H=TwosCompression.runStart s G) :
    secondEnd s G<N t := by
  have hfirst := TwosCompression.local_ledger r H
  have hone := (TwosCompression.odd_exit r H ho).1
  have hsecond := TwosCompression.local_ledger s G
  have hcoarse := A2Header.coarse_upper t
  have hn := A2Header.seed_admissible t
  have hr : r=0 ∨ r=1 ∨ r=2 ∨ r=3 ∨ r=4 ∨ r=5 := by omega
  rcases hr with h0|h1|h2|h3|h4|h5
  all_goals subst r
  all_goals have hs : s=5 ∨ s=4 ∨ s=3 ∨ s=2 ∨ s=1 ∨ s=0 := by omega
  all_goals rcases hs with hs|hs|hs|hs|hs|hs <;> try omega
  all_goals subst s
  all_goals simp only [N,U,firstEnd,afterFirstOne,secondEnd,
    TwosCompression.runStart,TwosCompression.runEnd,
    show (4:Nat)^0=1 by decide,show (4:Nat)^1=4 by decide,
    show (4:Nat)^2=16 by decide,show (4:Nat)^3=64 by decide,
    show (4:Nat)^4=256 by decide,show (4:Nat)^5=1024 by decide,
    show (3:Nat)^0=1 by decide,show (3:Nat)^1=3 by decide,
    show (3:Nat)^2=9 by decide,show (3:Nat)^3=27 by decide,
    show (3:Nat)^4=81 by decide,show (3:Nat)^5=243 by decide] at *
  all_goals omega

theorem five_twos_one_history (t r s H G : Nat)
    (ho : H%2=1) (hrs : r+s=5)
    (hU : U t=TwosCompression.runStart r H)
    (hX : afterFirstOne r H=TwosCompression.runStart s G) :
    Segment (N t) (secondEnd s G) 51 81 (beforeSecondCost r s) := by
  have h := before_second_one_history t r s H G ho hU hX
  have hj : 46+r+s=51 := by omega
  have hS : 71+2*r+2*s=81 := by omega
  rw [hj,hS] at h
  exact h

#print axioms header_segment
#print axioms twos_physical
#print axioms twos_segment
#print axioms first_one_segment
#print axioms second_one_segment
#print axioms first_history
#print axioms after_first_one_history
#print axioms before_second_one_history
#print axioms second_one_history
#print axioms runEnd_le_runStart
#print axioms first_height
#print axioms after_first_height
#print axioms before_second_height
#print axioms quarter_capture
#print axioms quarter_before_first_one
#print axioms quarter_before_second_one
#print axioms quarter_closes_under_IH
#print axioms four_twos_descent
#print axioms four_twos_history
#print axioms five_twos_one_descent
#print axioms five_twos_one_history

end CollatzCharacterBridge.A2SecondOne
