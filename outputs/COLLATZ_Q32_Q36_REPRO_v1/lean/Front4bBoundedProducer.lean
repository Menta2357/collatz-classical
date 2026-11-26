import A2FirstCrossingFusion

namespace CollatzCharacterBridge.Front4bBoundedProducer

open A2BoundedReducer (RemainingBelow)
open A2FirstCrossingFusion (Admitted HitsBelow Paid next_rank reduce_first_crossing)
open StagedCylinder (Segment)

/-- The bound is fixed for the whole induction. Admissibility retains the
    full physical prefix from the original source. -/
def BoundedAdmitted (N V x j S B : Nat) : Prop :=
  Admitted N x j S B ∧ x≤V

/-- A returned residual lies strictly below the current pivot and remains
    in the fixed bounded domain with its own prefix from N. -/
theorem next_bounded_rank {N V x : Nat} (bound : x≤V) (remaining : RemainingBelow N x) :
    ∃ u j S B, u<x ∧ u-N<x-N ∧ BoundedAdmitted N V u j S B := by
  obtain ⟨u,j,S,B,rank,admitted⟩ := next_rank remaining
  have lower : u<x := (Nat.sub_lt_sub_iff_right admitted.1).mp rank
  exact ⟨u,j,S,B,lower,rank,admitted,Nat.le_trans (Nat.le_of_lt lower) bound⟩

/-- A total producer is needed only on the bounded admissible domain.
    Every crossing in its premise is below that call's current pivot. -/
theorem paid_of_total_bounded_producer {N V : Nat} (big : 1<N)
    (produce : ∀ x j S B, BoundedAdmitted N V x j S B →
      Paid N ∨ ∃ z len σ C, Segment x z len σ C ∧ HitsBelow x x len) :
    ∀ x j S B, BoundedAdmitted N V x j S B → Paid N := by
  intro x
  induction x using Nat.strongRecOn with
  | ind x ih =>
    intro j S B state
    rcases produce x j S B state with paid | ⟨z,len,σ,C,tail,hit⟩
    · exact paid
    obtain ⟨admitted,bound⟩ := state
    obtain ⟨_,odd,window,history,_⟩ := admitted
    obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,_,_,outcome⟩ :=
      reduce_first_crossing big odd window history tail hit
    rcases outcome with paid | remaining
    · exact paid
    obtain ⟨u,j',S',B',lower,_,state'⟩ := next_bounded_rank bound remaining
    exact ih u lower j' S' B' state'

end CollatzCharacterBridge.Front4bBoundedProducer
