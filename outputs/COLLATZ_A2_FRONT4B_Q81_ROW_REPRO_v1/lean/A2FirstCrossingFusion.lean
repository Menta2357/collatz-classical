import A2MixedProgressCut
import A2ThreeWeakCommonLongRate
import A2PhysicalPrefix
import A2CertifiedLanding

namespace CollatzCharacterBridge.A2FirstCrossingFusion

open StagedCylinder (Segment)
open A2BoundedReducer (RemainingBelow)
open A2CertifiedLanding (Descended PaidMeeting)
open FixedSourceRun (Ones)

def Paid (N : Nat) : Prop := Descended N ∨ PaidMeeting N

def HitsBelow (x V horizon : Nat) : Prop := ∃ m, m ≤ horizon ∧ orbit x m < V

/-- Minimum over the certified finite horizon, before changing any pivot. -/
theorem first_index {x V horizon : Nat} (hit : HitsBelow x V horizon) :
    ∃ m, m ≤ horizon ∧ orbit x m < V ∧ ∀ i, i < m → V ≤ orbit x i := by
  induction horizon with
  | zero =>
    obtain ⟨m,hm,hlt⟩ := hit
    exact ⟨m,hm,hlt,by intro i hi; omega⟩
  | succ k ih =>
    by_cases old : HitsBelow x V k
    · obtain ⟨m,hm,small,first⟩ := ih old
      exact ⟨m,by omega,small,first⟩
    · obtain ⟨m,hm,small⟩ := hit
      have eq : m=k+1 := by
        have later : ¬m≤k := fun h => old ⟨m,h,small⟩
        omega
      refine ⟨m,hm,small,?_⟩
      intro i hi
      by_cases h : orbit x i < V
      · exact False.elim (old ⟨i,by omega,h⟩)
      · omega

/-- At the first strict crossing, retain both sides of the physical split
and the composed history from N to the crossing. -/
def FirstCrossing (N V Z j S B len σ C : Nat) : Prop :=
  ∃ m d e D E,
    0 < m ∧ m ≤ len ∧ orbit V m < V ∧
    (∀ i, i < m → V ≤ orbit V i) ∧
    d+e=σ ∧ C=3^(len-m)*D+2^d*E ∧
    Segment V (orbit V m) m d D ∧
    Segment (orbit V m) Z (len-m) e E ∧
    Segment N (orbit V m) (j+m) (S+d) (3^m*B+2^S*D) ∧
    (Paid N ∨ RemainingBelow N V)

theorem reduce_first_crossing {N V Z j S B len σ C : Nat}
    (big : 1<N) (odd : V%2=1) (window : V<2*N+1)
    (origin : Segment N V j S B) (tail : Segment V Z len σ C)
    (hit : HitsBelow V V len) : FirstCrossing N V Z j S B len σ C := by
  obtain ⟨m,mlt,small,minimal⟩ := first_index hit
  have nonzero : 0<m := by
    by_cases h : m=0
    · rw [h] at small
      exact False.elim (Nat.lt_irrefl _ small)
    · omega
  obtain ⟨d,e,D,E,divisions,hl,hr,hcost⟩ := A2PhysicalPrefix.split_segment tail mlt
  have crossed := StagedCylinder.compose origin hl
  have reduce := A2CertifiedLanding.reduce_window_certified big crossed
    (orbit_pos V (by omega) m) (orbit_odd V odd m) (by omega)
  refine ⟨m,d,e,D,E,nonzero,mlt,small,minimal,divisions,hcost,hl,hr,crossed,?_⟩
  rcases reduce with descent | meet | rem
  · exact Or.inl (Or.inl descent)
  · exact Or.inl (Or.inr meet)
  · exact Or.inr (A2BoundedReducer.remaining_strict rem small)

/-- A surplus starting at P is enough to find a crossing. The minimum is
nevertheless taken over the whole supplied path starting at V. -/
theorem from_surplus {N V P Z j S B len σ C k u D : Nat}
    (big : 1<N) (odd : V%2=1) (window : V<2*N+1)
    (origin : Segment N V j S B) (lead : Segment V P len σ C)
    (suffix : Segment P Z k u D)
    (cut : P*(3*V+1)^k < 2^u*V^(k+1)) :
    FirstCrossing N V Z j S B (len+k) (σ+u) (3^k*C+2^σ*D) := by
  have full := StagedCylinder.compose lead suffix
  obtain ⟨m,hm,small⟩ := A2MixedProgressCut.surplus_forces_crossing suffix.physical cut
  have firstP := A2Header.physical_endpoint lead.physical
  apply reduce_first_crossing big odd window origin full
  refine ⟨len+m,by omega,?_⟩
  rw [orbit_add V len m,firstP]
  exact small

/-- Reuse the grouped Front4b guard as a second producer of a crossing,
then consume the first crossing rather than the end of the grouped word. -/
theorem from_front4b {N V P j S B i r K : Nat}
    (big : 1<N) (odd : V%2=1) (window : V<2*N+1)
    (origin : Segment N V j S B) (lead : Segment V P 5 7 251)
    (pre : TwosCompression.Twos P i) (run : Ones (orbit P i) r)
    (post : TwosCompression.Twos (orbit P (i+r)) K)
    (large : 79≤V) (hi : i≤2) (hr : 1≤r)
    (cut : (3*r+1)/2+3≤i+K) :
    FirstCrossing N V (orbit P (i+r+K)) j S B (5+i+r+K) (7+2*i+r+2*K)
      (A2ThreeWeakCommonLongRate.commonCost i r K) := by
  have full := A2ThreeWeakCommonLongRate.common_tail (by omega : 0<V) odd lead pre run post
  have small := A2ThreeWeakCommonLongRate.common_strict large hi hr cut full
  have finalState := A2Header.physical_endpoint full.physical
  exact reduce_first_crossing big odd window origin full
    ⟨_,Nat.le_refl _,by rw [finalState]; exact small⟩

/-- A particular residual checkpoint, with its own exact prefix of N. -/
def Admitted (N x j s B : Nat) : Prop :=
  N≤x ∧ x%2=1 ∧ x<2*N+1 ∧ Segment N x j s B ∧
    ∃ r, 1≤r ∧ Ones x r ∧ 3*orbit x r+1=4*orbit x (r+1)

theorem next_rank {N V : Nat} (rem : RemainingBelow N V) :
    ∃ x j s B, x-N<V-N ∧ Admitted N x j s B := by
  obtain ⟨x,j,s,B,r,hNx,lt,odd,window,hr,history,run,factor⟩ := rem
  exact ⟨x,j,s,B,Nat.sub_lt_sub_right hNx lt,hNx,odd,window,history,r,hr,run,factor⟩

/-- Only a producer total on the actual residual checkpoints lets the
well-founded iteration reach a paid terminal. Each new comparison is
with the current pivot u, never with the first V of the episode. -/
theorem paid_of_total_producer {N : Nat} (big : 1<N)
    (produce : ∀ x j s B, Admitted N x j s B →
      Paid N ∨ ∃ z len σ C, Segment x z len σ C ∧ HitsBelow x x len) :
    ∀ x j s B, Admitted N x j s B → Paid N := by
  intro x
  induction x using Nat.strongRecOn with
  | ind x ih =>
    intro j s B state
    rcases produce x j s B state with paid | ⟨z,len,σ,C,tail,hit⟩
    · exact paid
    obtain ⟨_,odd,window,history,_⟩ := state
    obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,_,_,paidOrRemaining⟩ :=
      reduce_first_crossing big odd window history tail hit
    rcases paidOrRemaining with paid | remaining
    · exact paid
    obtain ⟨u,j',s',B',rank,state'⟩ := next_rank remaining
    have smaller : u<x := (Nat.sub_lt_sub_iff_right state'.1).mp rank
    exact ih u smaller j' s' B' state'

end CollatzCharacterBridge.A2FirstCrossingFusion
