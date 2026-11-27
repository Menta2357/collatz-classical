import Adic

namespace CollatzCharacterBridge

private theorem one_plus_multiple_pow (a c n : Nat) :
    ∃ h, (1+a*c)^n = 1+a*h := by
  induction n with
  | zero => exact ⟨0, by simp⟩
  | succ n ih =>
    obtain ⟨h, hh⟩ := ih
    refine ⟨c+h+a*c*h, ?_⟩
    rw [Nat.pow_succ, hh]
    simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul]
    ac_rfl

private theorem ternary_lift_one (j s t : Nat) (hj : 1 ≤ j)
    (hdiv : 3^j ∣ s*2^t+1) :
    ∃ t', t ≤ t' ∧ 3^(j+1) ∣ s*2^t'+1 := by
  let a := 3^j
  let X := s*2^t
  let P := 2*3^(j-1)
  obtain ⟨v, hv, hg⟩ := four_pow_cubing_quotient (j-1)
  have hj' : j-1+1=j := by omega
  rw [hj'] at hg
  have hP : 2^P = 1+a*v := by
    dsimp [P, a]
    rw [Nat.pow_mul, show (2:Nat)^2=4 by decide]
    exact hg
  have ha3 : 3 ∣ a := by
    dsimp [a]
    exact Nat.pow_dvd_pow 3 hj
  have ham : a%3=0 := Nat.mod_eq_zero_of_dvd ha3
  have hX3 : (X+1)%3=0 := by
    apply Nat.mod_eq_zero_of_dvd
    exact Nat.dvd_trans ha3 hdiv
  have hXm : X%3=2 := by omega
  have hgm : (1+a*v)%3=1 := by
    rw [Nat.add_mod, Nat.mul_mod, ham]
    omega
  obtain ⟨b, hb⟩ := hdiv
  by_cases hb0 : b%3=0
  · obtain ⟨c, hc⟩ : 3 ∣ b := Nat.dvd_of_mod_eq_zero hb0
    refine ⟨t, Nat.le_refl t, ?_⟩
    rw [Nat.pow_succ]
    change a*3 ∣ X+1
    refine ⟨c, ?_⟩
    rw [hb, hc]
    dsimp [a]
    ac_rfl
  by_cases hb1 : b%3=1
  · have hsum : 3 ∣ b+v*X := by
      apply Nat.dvd_of_mod_eq_zero
      rw [Nat.add_mod, Nat.mul_mod, hb1, hv, hXm]
    obtain ⟨c, hc⟩ := hsum
    have hnew : s*2^(t+P)+1 = a*(b+v*X) := by
      rw [Nat.pow_add, hP]
      calc
        s*(2^t*(1+a*v))+1 = X*(1+a*v)+1 := by dsimp [X]; ac_rfl
        _ = (X+1)+a*(v*X) := by
          simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul]
          ac_rfl
        _ = a*(b+v*X) := by
          rw [hb, Nat.mul_add a b (v*X)] <;> dsimp [a] <;> ac_rfl
    refine ⟨t+P, by omega, ?_⟩
    rw [Nat.pow_succ]
    change a*3 ∣ s*2^(t+P)+1
    refine ⟨c, ?_⟩
    rw [hnew, hc]
    ac_rfl
  · have hb2 : b%3=2 := by omega
    have hg2 : ((1+a*v)+1)%3=2 := by
      rw [Nat.add_mod, hgm]
    have hprod : (v*X*((1+a*v)+1))%3=1 := by
      simp [Nat.mul_mod, hv, hXm, hg2]
    have hsum : 3 ∣ b+v*X*((1+a*v)+1) := by
      apply Nat.dvd_of_mod_eq_zero
      rw [Nat.add_mod, hb2, hprod]
    obtain ⟨c, hc⟩ := hsum
    have hnew : s*2^(t+P+P)+1 = a*(b+v*X*((1+a*v)+1)) := by
      rw [Nat.pow_add, Nat.pow_add, hP]
      calc
        s*(2^t*(1+a*v)*(1+a*v))+1 = X*(1+a*v)*(1+a*v)+1 := by
          dsimp [X]
          ac_rfl
        _ = (X+1)+a*(v*X*((1+a*v)+1)) := by
          simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul]
          ac_rfl
        _ = a*(b+v*X*((1+a*v)+1)) := by
          rw [hb, Nat.mul_add a b (v*X*((1+a*v)+1))] <;> dsimp [a] <;> ac_rfl
    refine ⟨t+P+P, by omega, ?_⟩
    rw [Nat.pow_succ]
    change a*3 ∣ s*2^(t+P+P)+1
    refine ⟨c, ?_⟩
    rw [hnew, hc]
    ac_rfl

private theorem ternary_lift_n (D n s q : Nat) (hD : 1 ≤ D)
    (hs : s=1+3^D*q) :
    ∃ t, 3^(D+n) ∣ s*2^t+1 := by
  induction n with
  | zero =>
    have hbase := two_pow_cubing_dvd (D-1)
    have hDn : D-1+1=D := by omega
    rw [hDn] at hbase
    refine ⟨3^(D-1), ?_⟩
    rw [Nat.add_zero, hs]
    have heq : (1+3^D*q)*2^(3^(D-1))+1 =
        (2^(3^(D-1))+1)+3^D*(q*2^(3^(D-1))) := by
      simp only [Nat.add_mul, Nat.one_mul]
      ac_rfl
    rw [heq]
    exact Nat.dvd_add hbase (Nat.dvd_mul_right _ _)
  | succ n ih =>
    obtain ⟨t, ht⟩ := ih
    obtain ⟨t', _, ht'⟩ := ternary_lift_one (D+n) s t (by omega) ht
    exact ⟨t', by simpa only [Nat.add_succ] using ht'⟩

/-- If `s ≡ 1 (mod 3^D)`, a power of two makes `s*2^t ≡ -1`
    modulo any higher power of three. The exponent may exceed any cutoff. -/
theorem ternary_exponent_lift (D J s L : Nat)
    (hD : 1 ≤ D) (hDJ : D ≤ J) (hs : s % 3^D = 1) :
    ∃ t, L ≤ t ∧ 3^J ∣ s*2^t+1 := by
  have hsEq : s=1+3^D*(s/3^D) := by
    have h := Nat.mod_add_div s (3^D)
    rw [hs] at h
    omega
  obtain ⟨t₀, ht₀⟩ := ternary_lift_n D (J-D) s (s/3^D) hD hsEq
  have hJD : D+(J-D)=J := by omega
  rw [hJD] at ht₀
  let a := 3^J
  let P := 2*3^(J-1)
  obtain ⟨v, _, hg⟩ := four_pow_cubing_quotient (J-1)
  have hJn : J-1+1=J := by omega
  rw [hJn] at hg
  have hP : 2^P=1+a*v := by
    dsimp [P,a]
    rw [Nat.pow_mul, show (2:Nat)^2=4 by decide]
    exact hg
  obtain ⟨h, hh⟩ := one_plus_multiple_pow a v L
  let t := t₀+P*L
  have hpow : 2^t=2^t₀*(1+a*h) := by
    dsimp [t]
    rw [Nat.pow_add, Nat.pow_mul, hP, hh]
  have hPpos : 1 ≤ P := by
    dsimp [P]
    have hp : 0 < (3:Nat)^(J-1) := Nat.pow_pos (by decide)
    omega
  have hPL : L ≤ P*L := by
    simpa using Nat.mul_le_mul_right L hPpos
  have hsize : L ≤ t := by dsimp [t]; omega
  refine ⟨t, hsize, ?_⟩
  have heq : s*2^t+1 = (s*2^t₀+1)+a*(h*(s*2^t₀)) := by
    rw [hpow]
    simp only [Nat.mul_add, Nat.add_mul, Nat.mul_one, Nat.one_mul]
    ac_rfl
  rw [heq]
  change a ∣ (s*2^t₀+1)+a*(h*(s*2^t₀))
  exact Nat.dvd_add ht₀ (Nat.dvd_mul_right _ _)

#print axioms one_plus_multiple_pow
#print axioms ternary_lift_one
#print axioms ternary_lift_n
#print axioms ternary_exponent_lift

end CollatzCharacterBridge
