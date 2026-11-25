import P5R3S5

namespace CollatzCharacterBridge.A2CenteredRecharge

def U (m : Nat) : Nat := 2^(3*m+4)
def V (m : Nat) : Nat := 3^(2*m+3)
def K (m : Nat) : Nat := V m-U m

/-- The centered numerator is positive at every positive cofactor. -/
theorem coefficient_lower_bound (m : Nat) : 11≤K m := by
  have u_form : U m=16*8^m := by
    unfold U
    rw [Nat.pow_add 2 (3*m) 4,Nat.pow_mul 2 3 m]
    change 8^m*16=16*8^m
    exact Nat.mul_comm _ _
  have v_form : V m=27*9^m := by
    unfold V
    rw [Nat.pow_add 3 (2*m) 3,Nat.pow_mul 3 2 m]
    change 9^m*27=27*9^m
    exact Nat.mul_comm _ _
  have ordered : (8:Nat)^m≤9^m := Nat.pow_le_pow_left (by decide) m
  have positive : 0<(8:Nat)^m := Nat.pow_pos (by decide)
  simp only [K,u_form,v_form]
  omega

/-- If the label m is held fixed, shifting both cofactors by the same
    centered numerator removes the inhomogeneous term of the relation. -/
theorem centered_identity {m z zNext : Nat}
    (positive : 0<z) (next_positive : 0<zNext)
    (relation : U m*zNext+1=V m*z) :
    U m*(K m*zNext-1)=V m*(K m*z-1) := by
  have minimum := coefficient_lower_bound m
  have coefficient_pos : 0<K m := by omega
  have current_bound : 1≤K m*z := Nat.mul_pos coefficient_pos positive
  have next_bound : 1≤K m*zNext := Nat.mul_pos coefficient_pos next_positive
  have uv : U m≤V m := by
    simp only [K] at minimum
    omega
  have decomposition : K m+U m=V m := Nat.sub_add_cancel uv
  have balanced : U m*(K m*zNext-1)+V m=V m*(K m*z-1)+V m := by
    calc
      _ = (U m*(K m*zNext-1)+U m)+K m := by rw [←decomposition]; ac_rfl
      _ = U m*((K m*zNext-1)+1)+K m := by rw [Nat.mul_add,Nat.mul_one]
      _ = U m*(K m*zNext)+K m := by rw [Nat.sub_add_cancel next_bound]
      _ = K m*(U m*zNext+1) := by rw [Nat.mul_add,Nat.mul_one]; ac_rfl
      _ = K m*(V m*z) := by rw [relation]
      _ = V m*(K m*z) := by ac_rfl
      _ = V m*((K m*z-1)+1) := by rw [Nat.sub_add_cancel current_bound]
      _ = _ := by rw [Nat.mul_add,Nat.mul_one]
  exact Nat.add_right_cancel balanced

/-- Exact reserve consumption for equal labels. Oddness of the new
    quotient prevents any additional power of two from dividing. -/
theorem consumes_equal_label {m z zNext r v : Nat}
    (positive : 0<z) (next_positive : 0<zNext)
    (relation : U m*zNext+1=V m*z)
    (factor : K m*z-1=2^(3*m+4+r)*v) (odd : v%2=1) :
    K m*zNext-1=2^r*(V m*v) ∧ (V m*v)%2=1 ∧
      2^r ∣ K m*zNext-1 ∧ ¬2^(r+1) ∣ K m*zNext-1 := by
  have multiplied : U m*(K m*zNext-1)=U m*(2^r*(V m*v)) := by
    calc
      _ = V m*(K m*z-1) := centered_identity positive next_positive relation
      _ = V m*((2^(3*m+4)*2^r)*v) := by rw [factor,Nat.pow_add 2 (3*m+4) r]
      _ = _ := by simp only [U]; ac_rfl
  have modulus_pos : 0<U m := Nat.pow_pos (by decide)
  have identity := Nat.eq_of_mul_eq_mul_left modulus_pos multiplied
  have odd_multiplier : V m%2=1 := by simp [V,Nat.pow_mod]
  have odd_quotient : (V m*v)%2=1 := by rw [Nat.mul_mod,odd_multiplier,odd]
  exact ⟨identity,odd_quotient,P5R3S5.exact_reserve odd_quotient identity⟩

end CollatzCharacterBridge.A2CenteredRecharge
