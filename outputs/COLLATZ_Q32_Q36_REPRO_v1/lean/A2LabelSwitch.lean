import A2CenteredRecharge

namespace CollatzCharacterBridge.A2LabelSwitch

open A2CenteredRecharge (U V K coefficient_lower_bound)

set_option maxHeartbeats 200000

private theorem split_power {s t : Nat} (bound : s≤t) (x : Nat) :
    2^t*x=2^s*(2^(t-s)*x) := by
  rw (occs := .pos [1]) [show t=s+(t-s) by omega, Nat.pow_add, Nat.mul_assoc]

private theorem even_scaled {s : Nat} (positive : 1≤s) (x : Nat) :
    (2^s*x)%2=0 := by
  have divides : (2:Nat)∣2^s := by simpa using Nat.pow_dvd_pow 2 positive
  exact Nat.mod_eq_zero_of_dvd (Nat.dvd_mul_right_of_dvd divides x)

private theorem exact_difference {s x y F : Nat} (relation : F+2^s*y=2^s*x)
    (parities : x%2≠y%2) :
    ∃ q, F=2^s*q ∧ q%2=1 ∧ 2^s∣F ∧ ¬2^(s+1)∣F := by
  have ordered : 2^s*y≤2^s*x := by omega
  have bound := Nat.le_of_mul_le_mul_left ordered (Nat.pow_pos (by decide))
  have sum : 2^s*(x-y)+2^s*y=2^s*x := by
    rw [←Nat.mul_add,Nat.sub_add_cancel bound]
  have identity : F=2^s*(x-y) := Nat.add_right_cancel (relation.trans sum.symm)
  have odd : (x-y)%2=1 := by omega
  exact ⟨x-y,identity,odd,P5R3S5.exact_reserve odd identity⟩

/-- At a genuine switch, the centered reserve before the edge is
exactly the smaller of the two division counts. The next reserve is
not assumed to be bounded. -/
theorem switch_exact_reserve {a b z zNext : Nat}
    (change_label : a≠b) (positive : 0<z) (odd : z%2=1) (next_odd : zNext%2=1)
    (physical_relation : U b*zNext+1=V a*z) :
    let s := min (3*a+4) (3*b+4)
    ∃ q, K a*z-1=2^s*q ∧ q%2=1 ∧ 2^s∣K a*z-1 ∧ ¬2^(s+1)∣K a*z-1 := by
  have kmin := coefficient_lower_bound a
  have ordered : U a≤V a := by simp only [K] at kmin; omega
  have decomposition : K a+U a=V a := Nat.sub_add_cancel ordered
  have price : 1≤K a*z := Nat.mul_pos (by omega) positive
  have whole : K a*z+U a*z=V a*z := by rw [←Nat.add_mul,decomposition]
  have one : K a*z-1+1=K a*z := Nat.sub_add_cancel price
  have difference : K a*z-1+2^(3*a+4)*z=2^(3*b+4)*zNext := by
    change K a*z-1+U a*z=U b*zNext
    omega
  by_cases rising : a<b
  · have ex : 3*a+4<3*b+4 := by omega
    have scale := split_power (Nat.le_of_lt ex) zNext
    rw [scale] at difference
    have even : (2^(3*b+4-(3*a+4))*zNext)%2=0 := even_scaled (by omega) _
    have diff : (2^(3*b+4-(3*a+4))*zNext)%2≠z%2 := by rw [even,odd]; decide
    dsimp only
    rw [Nat.min_eq_left (Nat.le_of_lt ex)]
    exact exact_difference difference diff
  · have ex : 3*b+4<3*a+4 := by omega
    have scale := split_power (Nat.le_of_lt ex) z
    rw [scale] at difference
    have even : (2^(3*a+4-(3*b+4))*z)%2=0 := even_scaled (by omega) _
    have diff : zNext%2≠(2^(3*a+4-(3*b+4))*z)%2 := by rw [next_odd,even]; decide
    dsimp only
    rw [Nat.min_eq_right (Nat.le_of_lt ex)]
    exact exact_difference difference diff

end CollatzCharacterBridge.A2LabelSwitch
