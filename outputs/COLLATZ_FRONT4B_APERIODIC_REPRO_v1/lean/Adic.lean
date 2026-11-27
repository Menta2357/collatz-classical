import Arrival

namespace CollatzCharacterBridge

private theorem cube_sum (x : Nat) :
    x^3 + 1 + 3*x*(x+1) = (x+1)^3 := by
  simp only [Nat.pow_succ, Nat.pow_zero, Nat.one_mul, Nat.mul_one, Nat.mul_add, Nat.add_mul]
  simp only [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm, Nat.reduceMul]
  have h : x*(x*3)=3*(x*x) := by ac_rfl
  simp only [h]
  omega

private theorem cube_one_plus_three (x : Nat) :
    (1+3*x)^3 = 1+9*x*(1+3*x+3*x*x) := by
  simp only [Nat.pow_succ, Nat.pow_zero, Nat.one_mul, Nat.mul_one, Nat.mul_add, Nat.add_mul]
  simp only [Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm, Nat.reduceMul]
  have h1 : x*(x*27)=27*(x*x) := by ac_rfl
  have h2 : x*(x*9)=9*(x*x) := by ac_rfl
  simp only [h1,h2]
  omega

theorem two_pow_cubing_dvd (j : Nat) : 3^(j+1) ∣ 2^(3^j)+1 := by
  induction j with
  | zero => decide
  | succ j ih =>
    let x := 2^(3^j)
    let m := 3^(j+1)
    have hm : m ∣ x+1 := ih
    have h3 : 3 ∣ x+1 := Nat.dvd_trans (Nat.pow_dvd_pow 3 (show 1≤j+1 by omega)) hm
    have ha : m*3 ∣ (x+1)^3 := by
      have hsq := Nat.mul_dvd_mul hm h3
      simpa only [Nat.pow_succ, Nat.pow_zero, Nat.one_mul] using
        Nat.dvd_mul_right_of_dvd hsq (x+1)
    have hb : m*3 ∣ 3*x*(x+1) := by
      have hx : 3 ∣ 3*x := Nat.dvd_mul_right 3 x
      simpa only [Nat.mul_comm] using Nat.mul_dvd_mul hx hm
    have hc := Nat.dvd_sub ha hb
    rw [← cube_sum x, Nat.add_sub_cancel] at hc
    rw [Nat.pow_succ 3 j, Nat.pow_mul]
    exact hc

theorem four_pow_cubing_quotient (j : Nat) :
    ∃ v : Nat, v % 3 = 1 ∧ 4^(3^j) = 1 + 3^(j+1)*v := by
  induction j with
  | zero => exact ⟨1, by decide, by decide⟩
  | succ j ih =>
    obtain ⟨v, hv, he⟩ := ih
    let s := 3^j*v
    let z := 1+3*s+3*s*s
    have hz : z%3=1 := by dsimp [z]; rw [Nat.mul_assoc 3 s s]; omega
    refine ⟨v*z, ?_, ?_⟩
    · rw [Nat.mul_mod, hv, hz]
    · rw [Nat.pow_succ 3 j, Nat.pow_mul, he]
      have h3s : 3^(j+1)*v=3*s := by dsimp [s]; rw [Nat.pow_succ]; ac_rfl
      rw [h3s, cube_one_plus_three s]
      change 1+9*s*z = 1+3^(j+1+1)*(v*z)
      have hpow : (3:Nat)^(j+1+1)=3^j*9 := by
        rw [show j+1+1=j+2 by omega, Nat.pow_add]
      rw [hpow]
      dsimp [s]
      ac_rfl

theorem return_alternate_divisibility {r K k u y : Nat}
    (hk : K+3 ≤ k+1)
    (he : 3^(k+1)*u = 1+2^(r+3^(K+2))*y) :
    3^(K+3) ∣ 2^r*y-1 := by
  let m := 3^(K+3)
  let b := 2^(3^(K+2))
  let z := 2^r*y
  have h1 : m ∣ b+1 := two_pow_cubing_dvd (K+2)
  have h2 : m ∣ 1+b*z := by
    have hbase : m ∣ 3^(k+1)*u := Nat.dvd_mul_right_of_dvd (Nat.pow_dvd_pow 3 hk) u
    rw [he, Nat.pow_add] at hbase
    change m ∣ 1 + 2^r*b*y at hbase
    have hassoc : 2^r*b*y = b*z := by dsimp [z]; ac_rfl
    exact hassoc ▸ hbase
  have h3 : m ∣ (b+1)*z := Nat.dvd_mul_right_of_dvd h1 z
  have h4 := Nat.dvd_sub h3 h2
  rw [Nat.add_mul, Nat.one_mul, show b*z+z-(1+b*z)=z-1 by omega] at h4
  exact h4

#print axioms cube_sum
#print axioms cube_one_plus_three
#print axioms two_pow_cubing_dvd
#print axioms four_pow_cubing_quotient
#print axioms return_alternate_divisibility

end CollatzCharacterBridge
