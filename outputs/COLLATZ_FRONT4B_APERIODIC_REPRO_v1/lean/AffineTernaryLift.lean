import Std

namespace CollatzCharacterBridge.AffineTernaryLift

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

private theorem choose_ternary_digit (d z : Nat) (hd : d%3≠0) :
    ∃ u : Nat, u≤2 ∧ 3 ∣ z+d*u := by
  by_cases hz : z%3=0
  · refine ⟨0,by decide,?_⟩
    simpa only [Nat.mul_zero,Nat.add_zero] using Nat.dvd_of_mod_eq_zero hz
  have hdCases : d%3=1 ∨ d%3=2 := by omega
  have hzCases : z%3=1 ∨ z%3=2 := by omega
  rcases hdCases with hd1|hd2 <;> rcases hzCases with hz1|hz2
  · exact ⟨2,by decide,Nat.dvd_of_mod_eq_zero (by omega)⟩
  · exact ⟨1,by decide,Nat.dvd_of_mod_eq_zero (by omega)⟩
  · exact ⟨1,by decide,Nat.dvd_of_mod_eq_zero (by omega)⟩
  · exact ⟨2,by decide,Nat.dvd_of_mod_eq_zero (by omega)⟩

/-- One exact ternary digit is lifted at each inductive step. The
lower cutoff is retained because each correction is nonnegative. -/
theorem affine_lift_above (c d J L : Nat) (hd : d%3≠0) :
    ∃ t : Nat, L≤t ∧ 3^J ∣ c+d*t := by
  induction J with
  | zero => exact ⟨L,Nat.le_refl L,by simp⟩
  | succ j ih =>
    obtain ⟨t,hL,z,hz⟩ := ih
    obtain ⟨u,_hu,v,hv⟩ := choose_ternary_digit d z hd
    refine ⟨t+3^j*u,by omega,v,?_⟩
    calc
      _ = (c+d*t)+3^j*(d*u) := by simp only [Nat.mul_add]; ac_rfl
      _ = 3^j*z+3^j*(d*u) := by rw [hz]
      _ = 3^j*(z+d*u) := (Nat.mul_add _ _ _).symm
      _ = 3^j*(3*v) := by rw [hv]
      _ = _ := by rw [Nat.pow_succ]; ac_rfl

/-- Every supplied solution generates its complete forward period
progression. No unit hypothesis is needed for this preservation step. -/
theorem progression_preserves (c d J t : Nat) (ht : 3^J ∣ c+d*t) :
    ∀ n : Nat, 3^J ∣ c+d*(t+3^J*n) := by
  intro n
  have he : c+d*(t+3^J*n)=(c+d*t)+3^J*(d*n) := by
    simp only [Nat.mul_add]
    ac_rfl
  rw [he]
  exact Nat.dvd_add ht (Nat.dvd_mul_right _ _)

theorem affine_congruence_above (c d J L : Nat) (hd : d%3≠0) :
    ∃ t : Nat, L≤t ∧ 3^J ∣ c+d*t ∧
      ∀ n : Nat, 3^J ∣ c+d*(t+3^J*n) := by
  obtain ⟨t,hL,ht⟩ := affine_lift_above c d J L hd
  exact ⟨t,hL,ht,progression_preserves c d J t ht⟩

private theorem scale_divisibility (T k x : Nat) (hTk : T≤4*k)
    (hx : 3^(4*k-T) ∣ x) : 3^(4*k+1) ∣ 3^(T+1)*x := by
  obtain ⟨q,hq⟩ := hx
  refine ⟨q,?_⟩
  rw [hq,show 4*k+1=(T+1)+(4*k-T) by omega,Nat.pow_add 3 (T+1) (4*k-T)]
  ac_rfl

/-- The leading 3^(T+1) is kept. The target is 3^(4k+1), not 3^(4k).
The natural difference 4k-T is nontruncated by the explicit guard. -/
theorem scaled_affine_lift (T k c d L : Nat) (hTk : T≤4*k) (hd : d%3≠0) :
    ∃ t : Nat, L≤t ∧ 3^(4*k+1) ∣ 3^(T+1)*(c+d*t) ∧
      ∀ n : Nat, 3^(4*k+1) ∣ 3^(T+1)*(c+d*(t+3^(4*k-T)*n)) := by
  obtain ⟨t,hL,ht,hprog⟩ := affine_congruence_above c d (4*k-T) L hd
  exact ⟨t,hL,scale_divisibility T k _ hTk ht,
    fun n => scale_divisibility T k _ hTk (hprog n)⟩

private theorem supplied_scale_identity (T constant slope c d t : Nat)
    (hc : constant=3^(T+1)*c) (hd : slope=3^(T+1)*d) :
    constant+slope*t=3^(T+1)*(c+d*t) := by
  rw [hc,hd,Nat.mul_add]
  ac_rfl

/-- Constant and slope quotients are supplied as exact natural
factorizations. No signed subtraction or unproved division is used. -/
theorem scaled_affine_consumer (T k constant slope c d L : Nat)
    (hTk : T≤4*k) (hc : constant=3^(T+1)*c) (hs : slope=3^(T+1)*d)
    (hd : d%3≠0) :
    ∃ t : Nat, L≤t ∧ 3^(T+1) ∣ constant+slope*t ∧
      3^(4*k+1) ∣ constant+slope*t ∧
      ∀ n : Nat, 3^(4*k+1) ∣ constant+slope*(t+3^(4*k-T)*n) := by
  obtain ⟨t,hL,ht,hprog⟩ := scaled_affine_lift T k c d L hTk hd
  refine ⟨t,hL,?_,?_,?_⟩
  · rw [supplied_scale_identity T constant slope c d t hc hs]
    exact Nat.dvd_mul_right _ _
  · rw [supplied_scale_identity T constant slope c d t hc hs]
    exact ht
  · intro n
    rw [supplied_scale_identity T constant slope c d (t+3^(4*k-T)*n) hc hs]
    exact hprog n

#print axioms choose_ternary_digit
#print axioms affine_lift_above
#print axioms progression_preserves
#print axioms affine_congruence_above
#print axioms scale_divisibility
#print axioms scaled_affine_lift
#print axioms supplied_scale_identity
#print axioms scaled_affine_consumer

end CollatzCharacterBridge.AffineTernaryLift
