import A2FirstCrossingFusion
import A2CertifiedLandingTrace

namespace CollatzCharacterBridge.A2FirstCrossingChronology

open StagedCylinder (Segment)
open A2FirstCrossingFusion (Paid FirstCrossing Admitted)

/-- The next admitted pivot is connected to the actual crossing by a
physical suffix and carries the original book at the later clock. -/
def LaterResidual (N V j S B len : Nat) : Prop :=
  ∃ m d D u j' s' B' k a A,
    0<m ∧ m≤len ∧ orbit V m<V ∧
    (∀ t, t<m → V≤orbit V t) ∧
    Segment V (orbit V m) m d D ∧
    Segment (orbit V m) u k a A ∧
    j'=j+m+k ∧ s'=S+d+a ∧
    B'=3^k*(3^m*B+2^S*D)+2^(S+d)*A ∧
    j<j' ∧ u-N<V-N ∧ Admitted N u j' s' B'

theorem chronological_landing {N V Z j S B len σ C : Nat}
    (big : 1<N) (odd : V%2=1) (window : V<2*N+1)
    (cross : FirstCrossing N V Z j S B len σ C) :
    Paid N ∨ LaterResidual N V j S B len := by
  obtain ⟨m,d,_,D,_,hm,hmlen,small,minimal,_,_,firstPart,_,original,_⟩ := cross
  have land := A2CertifiedLandingTrace.reduce_window_with_trace big original
    (orbit_pos V (by omega) m) (orbit_odd V odd m) (by omega)
  rcases land with descent | meet | remaining
  · exact Or.inl (Or.inl descent)
  · exact Or.inl (Or.inr meet)
  · obtain ⟨u,j',s',B',r,k,a,A,hNu,hu,hodd,hwindow,hr,history,run,factor,tail,
        clock,valuations,book⟩ := remaining
    exact Or.inr ⟨m,d,D,u,j',s',B',k,a,A,hm,hmlen,small,minimal,firstPart,tail,
      clock,valuations,book,by omega,Nat.sub_lt_sub_right hNu (by omega),
      hNu,hodd,hwindow,history,r,hr,run,factor⟩

private theorem orbit_one (i : Nat) : orbit 1 i=1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i)=1
    rw [ih]
    change oddPart 4=1
    exact (oddPart_quadruple 1).trans (oddPart_of_odd (by decide))

/-- A paid witness can discharge the original seed only after
convergence of the strictly smaller seed is supplied. -/
theorem arrival_of_paid {N : Nat}
    (paid : Paid N)
    (ih : ∀ w, 0<w → w%2=1 → w<N → ∃ i, orbit w i=1) :
    ∃ i, orbit N i=1 := by
  rcases paid with ⟨p,j,s,B,hp,ho,hl,history⟩ |
    ⟨w,z,j,s,B,k,R,C,hw,ho,hl,hz,hzo,original,source⟩
  · obtain ⟨i,hi⟩ := ih p hp ho hl
    exact ⟨j+i, by rw [orbit_add,A2Header.physical_endpoint history.physical,hi]⟩
  · obtain ⟨i,hi⟩ := ih w hw ho hl
    have same := (A2Header.physical_endpoint original.physical).trans
      (A2Header.physical_endpoint source.physical).symm
    exact ⟨j+i,by rw [orbit_add,same,←orbit_add,Nat.add_comm k i,orbit_add,hi,orbit_one]⟩

end CollatzCharacterBridge.A2FirstCrossingChronology
