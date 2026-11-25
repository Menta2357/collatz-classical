import A2BoundedReducer

namespace CollatzCharacterBridge.A2CertifiedLanding

open StagedCylinder (Segment)
open P5R3S5 (transport step_segment)
open A2HalfAdaptive (first_break history_capture)

set_option maxRecDepth 16000
set_option maxHeartbeats 1000000

/-- A strict descent is exhibited together with its full physical book
    from the same original N. No induction hypothesis is an input. -/
def Descended (N : Nat) : Prop :=
  ∃ p j s B : Nat,
    0<p ∧ p%2=1 ∧ p<N ∧ Segment N p j s B

/-- The initial source is paid against N. Both clocks and both additives
    are explicit, independent witnesses at one actual common endpoint. -/
def PaidMeeting (N : Nat) : Prop :=
  ∃ w z j s B k R C : Nat,
    0<w ∧ w%2=1 ∧ w<N ∧ 0<z ∧ z%2=1 ∧
      Segment N z j s B ∧ Segment w z k R C

/-- Only the unresolved physical pivot is bounded by the input checkpoint.
    The other alternatives exhibit payment, not a presumed arrival at 1. -/
def Landing (N bound : Nat) : Prop :=
  Descended N ∨ PaidMeeting N ∨ A2BoundedReducer.RemainingAtMost N bound

theorem landing_mono {N x y : Nat} (h : Landing N x) (hxy : x≤y) :
    Landing N y := by
  rcases h with hd|hm|hr
  · exact Or.inl hd
  · exact Or.inr (Or.inl hm)
  · exact Or.inr (Or.inr (A2BoundedReducer.remaining_mono hr hxy))

/-- The physical reduction tree behind reduce_window_bounded, before IH
    is applied. Leading twos decrease x; all histories retain their N. -/
theorem reduce_window_certified {N x j s B : Nat} (Nbig : 1<N)
    (fromN : Segment N x j s B) (positive : 0<x) (odd : x%2=1)
    (height : x<2*N+1) : Landing N x := by
  induction x using Nat.strongRecOn generalizing j s B with
  | ind x ih =>
    by_cases below : x<N
    · exact Or.inl ⟨x,j,s,B,positive,odd,below,fromN⟩
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
        have smaller := ih (step x) lower whole (step_pos _) (step_odd _) (by omega)
        exact landing_mono smaller (by omega)
      · have strength : 3≤b := by omega
        have power : (8:Nat)≤2^b :=
          Nat.pow_le_pow_right (by decide : 0<(2:Nat)) strength
        have bound := Nat.mul_le_mul_right (step x) power
        rw [←factor] at bound
        exact Or.inl ⟨step x,_,_,_,step_pos _,step_odd _,by omega,whole⟩
    | succ r =>
      by_cases two : b=2
      · rw [two] at factor
        exact Or.inr (Or.inr
          ⟨x,j,s,B,r+1,by omega,by omega,odd,height,by omega,fromN,run,factor⟩)
      · obtain ⟨hp,ho,hl,ns,ws⟩ :=
          history_capture fromN positive odd height run (by omega) factor
        exact Or.inr (Or.inl
          ⟨A2HalfAdaptive.half x,orbit x (r+2),_,_,_,_,_,_,
            hp,ho,hl,orbit_pos _ positive _,orbit_odd _ odd _,ns,ws⟩)

/-- The exhibited payment includes an actual orbital witness. The
    existential clocks/additives remain available in Descended itself. -/
theorem descended_endpoint {N : Nat} (h : Descended N) :
    ∃ p j s B : Nat,
      0<p ∧ p%2=1 ∧ p<N ∧ Segment N p j s B ∧ orbit N j=p := by
  obtain ⟨p,j,s,B,hp,ho,hl,hist⟩ := h
  exact ⟨p,j,s,B,hp,ho,hl,hist,A2Header.physical_endpoint hist.physical⟩

theorem paid_meeting_endpoint {N : Nat} (h : PaidMeeting N) :
    ∃ w z j s B k R C : Nat,
      0<w ∧ w%2=1 ∧ w<N ∧ 0<z ∧ z%2=1 ∧
        Segment N z j s B ∧ Segment w z k R C ∧ orbit N j=orbit w k := by
  obtain ⟨w,z,j,s,B,k,R,C,hp,ho,hl,hz,hzo,orig,source⟩ := h
  exact ⟨w,z,j,s,B,k,R,C,hp,ho,hl,hz,hzo,orig,source,
    (A2Header.physical_endpoint orig.physical).trans
      (A2Header.physical_endpoint source.physical).symm⟩

#print axioms Descended
#print axioms PaidMeeting
#print axioms Landing
#print axioms landing_mono
#print axioms reduce_window_certified
#print axioms descended_endpoint
#print axioms paid_meeting_endpoint

end CollatzCharacterBridge.A2CertifiedLanding
