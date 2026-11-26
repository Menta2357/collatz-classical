import A2FirstCrossingFusion

namespace CollatzCharacterBridge.A2ThinDomain

open A2BoundedReducer (RemainingBelow)
open A2FirstCrossingFusion (Admitted HitsBelow Paid next_rank reduce_first_crossing)
open StagedCylinder (Segment)

/-- Keep every physical and historical condition of A2 and tighten the height. -/
def ThinAdmitted (N x j S B : Nat) : Prop :=
  Admitted N x j S B ∧ 11*x<12*N

/-- The first-crossing reducer returns a lower residual, so the narrow
    height bound persists without any additional hypothesis on the tail. -/
theorem next_thin_rank {N V : Nat} (thin : 11*V<12*N) (remaining : RemainingBelow N V) :
    ∃ u j S B, u-N<V-N ∧ ThinAdmitted N u j S B := by
  obtain ⟨u,j,S,B,rank,admitted⟩ := next_rank remaining
  have lower : u<V := (Nat.sub_lt_sub_iff_right admitted.1).mp rank
  have smaller_height : 11*u<12*N :=
    Nat.lt_trans (Nat.mul_lt_mul_of_pos_left lower (by decide : 0<(11:Nat))) thin
  exact ⟨u,j,S,B,rank,admitted,smaller_height⟩

/-- A producer defined only on the narrow domain suffices for induction,
    since all residuals returned there have strictly lower rank and remain
    in that same domain. The hypothesis supplies every physical crossing. -/
theorem paid_of_total_thin_producer {N : Nat} (big : 1<N)
    (produce : ∀ x j S B, ThinAdmitted N x j S B →
      Paid N ∨ ∃ z len σ C, Segment x z len σ C ∧ HitsBelow x x len) :
    ∀ x j S B, ThinAdmitted N x j S B → Paid N := by
  have consume (r : Nat) : ∀ x j S B, x-N=r → ThinAdmitted N x j S B → Paid N := by
    induction r using Nat.strongRecOn with
    | ind r ih =>
      intro x j S B rank_eq state
      rcases produce x j S B state with paid | ⟨z,len,σ,C,tail,hit⟩
      · exact paid
      obtain ⟨⟨_,odd,window,history,_⟩,thin⟩ := state
      obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,_,_,outcome⟩ :=
        reduce_first_crossing big odd window history tail hit
      rcases outcome with paid | remaining
      · exact paid
      obtain ⟨u,j',S',B',lower,admitted⟩ := next_thin_rank thin remaining
      have smaller_rank : u-N<r := by rw [←rank_eq]; exact lower
      exact ih (u-N) smaller_rank u j' S' B' rfl admitted
  intro x j S B state
  exact consume (x-N) x j S B rfl state

end CollatzCharacterBridge.A2ThinDomain
