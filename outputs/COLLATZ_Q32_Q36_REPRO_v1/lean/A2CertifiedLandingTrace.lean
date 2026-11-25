import A2CertifiedLanding

namespace CollatzCharacterBridge.A2CertifiedLandingTrace

open A2Header (Physical)
open StagedCylinder (Segment compose)
open A2CertifiedLanding (Descended PaidMeeting)
open P5R3S5 (transport step_segment)
open A2HalfAdaptive (first_break history_capture)
open FixedSourceRun (Ones)

set_option maxRecDepth 16000
set_option maxHeartbeats 1000000

/-- The unresolved pivot is reached by a physical suffix starting at the
    reducer input x. Its local clock and local additive remain explicit. -/
def LocalRemaining (N x : Nat) : Prop :=
  ∃ u m d D r : Nat,
    N≤u ∧ u≤x ∧ u%2=1 ∧ u<2*N+1 ∧ 1≤r ∧
      Segment x u m d D ∧ Ones u r ∧
      3*orbit u r+1=4*orbit u (r+1)

/-- Both the original history and its exact association with the post-entry
    suffix are exported. In particular j' and s' cannot precede the input. -/
def AssociatedRemaining (N x j s B : Nat) : Prop :=
  ∃ u j' s' B' r m d D : Nat,
    N≤u ∧ u≤x ∧ u%2=1 ∧ u<2*N+1 ∧ 1≤r ∧
      Segment N u j' s' B' ∧ Ones u r ∧
      3*orbit u r+1=4*orbit u (r+1) ∧
      Segment x u m d D ∧ j'=j+m ∧ s'=s+d ∧ B'=3^m*B+2^s*D

theorem associate_suffix {N x j s B : Nat}
    (origin : Segment N x j s B) (h : LocalRemaining N x) :
    AssociatedRemaining N x j s B := by
  obtain ⟨u,m,d,D,r,hN,hu,ho,hw,hr,suffix,run,factor⟩ := h
  exact ⟨u,j+m,s+d,3^m*B+2^s*D,r,m,d,D,
    hN,hu,ho,hw,hr,compose origin suffix,run,factor,suffix,rfl,rfl,rfl⟩

theorem associated_forget {N x j s B : Nat}
    (h : AssociatedRemaining N x j s B) :
    A2BoundedReducer.RemainingAtMost N x := by
  obtain ⟨u,j',s',B',r,m,d,D,hN,hu,ho,hw,hr,hist,run,factor,
    _suffix,_hj,_hs,_hB⟩ := h
  exact ⟨u,j',s',B',r,hN,hu,ho,hw,hr,hist,run,factor⟩

/-- The only recursion consumes leading twos. Payment branches reuse the
    sealed producers; unresolved branches compose only the local suffix. -/
private theorem reduce_local_suffix {N x j s B : Nat} (Nbig : 1<N)
    (fromN : Segment N x j s B) (positive : 0<x) (odd : x%2=1)
    (height : x<2*N+1) : Descended N ∨ PaidMeeting N ∨ LocalRemaining N x := by
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
        rcases smaller with hd|hm|hr
        · exact Or.inl hd
        · exact Or.inr (Or.inl hm)
        · obtain ⟨u,m,d,D,ρ,hN,hu,ho,hw,hρ,suffix,run',factor'⟩ := hr
          exact Or.inr (Or.inr
            ⟨u,1+m,b+d,3^m*1+2^b*D,ρ,hN,by omega,ho,hw,hρ,
              compose tail suffix,run',factor'⟩)
      · have strength : 3≤b := by omega
        have power : (8:Nat)≤2^b :=
          Nat.pow_le_pow_right (by decide : 0<(2:Nat)) strength
        have bound := Nat.mul_le_mul_right (step x) power
        rw [←factor] at bound
        exact Or.inl ⟨step x,_,_,_,step_pos _,step_odd _,by omega,whole⟩
    | succ r =>
      by_cases two : b=2
      · rw [two] at factor
        have refl : Segment x x 0 0 0 := ⟨Physical.refl x,by simp⟩
        exact Or.inr (Or.inr
          ⟨x,0,0,0,r+1,by omega,by omega,odd,height,by omega,refl,run,factor⟩)
      · obtain ⟨hp,ho,hl,ns,ws⟩ :=
          history_capture fromN positive odd height run (by omega) factor
        exact Or.inr (Or.inl
          ⟨A2HalfAdaptive.half x,orbit x (r+2),_,_,_,_,_,_,
            hp,ho,hl,orbit_pos _ positive _,orbit_odd _ odd _,ns,ws⟩)

/-- No IH_N and no unrecorded reindexing. Every returned residual follows
    the exact input history by the supplied physical local suffix. -/
theorem reduce_window_with_trace {N x j s B : Nat} (Nbig : 1<N)
    (fromN : Segment N x j s B) (positive : 0<x) (odd : x%2=1)
    (height : x<2*N+1) :
    Descended N ∨ PaidMeeting N ∨ AssociatedRemaining N x j s B := by
  rcases reduce_local_suffix Nbig fromN positive odd height with hd|hm|hr
  · exact Or.inl hd
  · exact Or.inr (Or.inl hm)
  · exact Or.inr (Or.inr (associate_suffix fromN hr))

/-- The public association also exposes monotonicity of both original
    integer clocks; the additive equality is retained in the same witness. -/
theorem associated_clocks {N x j s B : Nat}
    (h : AssociatedRemaining N x j s B) :
    ∃ u j' s' B' r m d D : Nat,
      N≤u ∧ u≤x ∧ u%2=1 ∧ u<2*N+1 ∧ 1≤r ∧
        Segment N u j' s' B' ∧ Ones u r ∧
        3*orbit u r+1=4*orbit u (r+1) ∧
        Segment x u m d D ∧ j'=j+m ∧ s'=s+d ∧
        B'=3^m*B+2^s*D ∧ j≤j' ∧ s≤s' := by
  obtain ⟨u,j',s',B',r,m,d,D,hN,hu,ho,hw,hr,hist,run,factor,suffix,hj,hs,hB⟩ := h
  exact ⟨u,j',s',B',r,m,d,D,hN,hu,ho,hw,hr,hist,run,factor,
    suffix,hj,hs,hB,by omega,by omega⟩

#print axioms LocalRemaining
#print axioms AssociatedRemaining
#print axioms associate_suffix
#print axioms associated_forget
#print axioms reduce_local_suffix
#print axioms reduce_window_with_trace
#print axioms associated_clocks

end CollatzCharacterBridge.A2CertifiedLandingTrace
