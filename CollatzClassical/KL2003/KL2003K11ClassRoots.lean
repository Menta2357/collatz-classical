import CollatzClassical.KL2003.KL2003GeneralKSemantics
import Mathlib.RingTheory.ZMod.UnitsCyclic

namespace CollatzClassical
namespace KL2003
namespace K11ClassRoots

def k11TwoUnit : (ZMod (3 ^ 11))ˣ :=
  ZMod.unitOfCoprime 2 (by norm_num)

def k11NegTwoUnit : (ZMod (3 ^ 11))ˣ := -k11TwoUnit

set_option maxRecDepth 100000 in
theorem k11NegTwoUnit_order : orderOf k11NegTwoUnit = 3 ^ 10 := by
  rw [← orderOf_injective (Units.coeHom (ZMod (3 ^ 11))) Units.ext k11NegTwoUnit]
  simpa [k11NegTwoUnit, k11TwoUnit] using
    (ZMod.orderOf_one_add_mul_prime Nat.prime_three (by norm_num)
      (-1 : Int) (by norm_num) 10)

theorem k11NegOneUnit_order : orderOf (-1 : (ZMod (3 ^ 11))ˣ) = 2 := by
  letI : Fact (1 < 3 ^ 11) := ⟨by norm_num⟩
  rw [← orderOf_injective (Units.coeHom (ZMod (3 ^ 11))) Units.ext
    (-1 : (ZMod (3 ^ 11))ˣ)]
  change orderOf (-1 : ZMod (3 ^ 11)) = 2
  rw [orderOf_neg_one]
  norm_num [ringChar.eq]

theorem k11NegOneUnit_ne_one : (-1 : (ZMod (3 ^ 11))ˣ) ≠ 1 := by
  intro h
  have horder : orderOf (-1 : (ZMod (3 ^ 11))ˣ) = 1 := orderOf_eq_one_iff.2 h
  rw [k11NegOneUnit_order] at horder
  norm_num at horder

theorem k11NegTwoUnit_pow_eq (m : Nat) :
    k11NegTwoUnit ^ m = (-1 : (ZMod (3 ^ 11))ˣ) ^ m * k11TwoUnit ^ m := by
  simp only [k11NegTwoUnit]
  rw [neg_eq_neg_one_mul, mul_pow]

theorem k11TwoUnit_pow_period : k11TwoUnit ^ (2 * 3 ^ 10) = 1 := by
  have hneg : k11NegTwoUnit ^ (3 ^ 10) = 1 := by
    rw [← orderOf_dvd_iff_pow_eq_one, k11NegTwoUnit_order]
  have hneg2 : k11NegTwoUnit ^ (2 * 3 ^ 10) = 1 := by
    rw [mul_comm 2 (3 ^ 10), pow_mul, hneg]
    simp
  have hformula := k11NegTwoUnit_pow_eq (2 * 3 ^ 10)
  rw [hneg2] at hformula
  have hminus : (-1 : (ZMod (3 ^ 11))ˣ) ^ (2 * 3 ^ 10) = 1 := by
    rw [show 2 * 3 ^ 10 = 2 * (3 ^ 10) by rfl, pow_mul]
    norm_num
  rw [hminus, one_mul] at hformula
  exact hformula.symm

theorem k11TwoUnit_order : orderOf k11TwoUnit = 2 * 3 ^ 10 := by
  apply (orderOf_eq_iff (by norm_num : 0 < 2 * 3 ^ 10)).2
  constructor
  · exact k11TwoUnit_pow_period
  · intro m hm hpos hpow
    have hformula := k11NegTwoUnit_pow_eq m
    rw [hpow, mul_one] at hformula
    by_cases heven : Even m
    · obtain ⟨r, rfl⟩ := heven
      have hminus : (-1 : (ZMod (3 ^ 11))ˣ) ^ (2 * r) = 1 := by
        rw [pow_mul]
        norm_num
      have hneg : k11NegTwoUnit ^ (2 * r) = 1 := by
        simpa [hminus, two_mul] using hformula
      have hdvd : 3 ^ 10 ∣ 2 * r := by
        rw [← k11NegTwoUnit_order]
        exact orderOf_dvd_of_pow_eq_one hneg
      have hcop : Nat.Coprime (3 ^ 10) 2 := by norm_num
      have hdvdr : 3 ^ 10 ∣ r := (hcop.dvd_mul_left).1 hdvd
      have hnle : 2 * 3 ^ 10 <= 2 * r :=
        Nat.mul_le_mul_left 2 (Nat.le_of_dvd (by omega) hdvdr)
      omega
    · have hodd : Odd m := Nat.not_even_iff_odd.mp heven
      have hminus : (-1 : (ZMod (3 ^ 11))ˣ) ^ m = -1 := by
        simpa [hodd.neg_one_pow]
      have hneg_eq_neg : k11NegTwoUnit ^ m = (-1 : (ZMod (3 ^ 11))ˣ) := by
        simpa [hminus] using hformula
      have hsquare : k11NegTwoUnit ^ (2 * m) = 1 := by
        rw [mul_comm 2 m, pow_mul, hneg_eq_neg]
        norm_num
      have hdvd : 3 ^ 10 ∣ 2 * m := by
        rw [← k11NegTwoUnit_order]
        exact orderOf_dvd_of_pow_eq_one hsquare
      have hcop : Nat.Coprime (3 ^ 10) 2 := by norm_num
      have hdvdm : 3 ^ 10 ∣ m := (hcop.dvd_mul_left).1 hdvd
      have hneg_one : k11NegTwoUnit ^ m = 1 := by
        rw [← orderOf_dvd_iff_pow_eq_one, k11NegTwoUnit_order]
        exact hdvdm
      rw [hneg_eq_neg] at hneg_one
      exact (k11NegOneUnit_ne_one hneg_one).elim

theorem k11TwoUnit_zpowers_eq_top : Subgroup.zpowers k11TwoUnit = ⊤ := by
  rw [← Subgroup.card_eq_iff_eq_top]
  rw [Nat.card_zpowers, k11TwoUnit_order]
  rw [Nat.card_eq_fintype_card, ZMod.card_units_eq_totient,
    Nat.totient_prime_pow Nat.prime_three (by norm_num)]
  norm_num

theorem exists_k11_power_residue (mode : TrackedMode 11) :
    exists exponent : Nat, 2 ^ exponent % generalKModulus 11 = mode.1.1 := by
  have hcoprime : Nat.Coprime mode.1.1 (3 ^ 11) := by
    apply Nat.prime_three.coprime_pow_of_not_dvd
    intro hdiv
    have hmod : mode.1.1 % 3 = 0 := Nat.dvd_iff_mod_eq_zero.mp hdiv
    omega
  let modeUnit : (ZMod (3 ^ 11))ˣ :=
    ZMod.unitOfCoprime mode.1.1 hcoprime
  have hmem : modeUnit ∈ Subgroup.zpowers k11TwoUnit := by
    rw [k11TwoUnit_zpowers_eq_top]
    exact Subgroup.mem_top modeUnit
  have hpower : modeUnit ∈ Submonoid.powers k11TwoUnit :=
    (mem_powers_iff_mem_zpowers).2 hmem
  obtain ⟨exponent, hexponent⟩ :=
    (Submonoid.mem_powers_iff modeUnit k11TwoUnit).1 hpower
  refine ⟨exponent, ?_⟩
  have hcoe := congr_arg (fun unit : (ZMod (3 ^ 11))ˣ =>
    (unit : ZMod (3 ^ 11))) hexponent
  change (k11TwoUnit : ZMod (3 ^ 11)) ^ exponent =
    (modeUnit : ZMod (3 ^ 11)) at hcoe
  simp only [k11TwoUnit, modeUnit, ZMod.coe_unitOfCoprime] at hcoe
  rw [← Nat.cast_pow] at hcoe
  change ((2 ^ exponent : Nat) : ZMod (3 ^ 11)) =
    (mode.1.1 : ZMod (3 ^ 11)) at hcoe
  have hmodEq : 2 ^ exponent ≡ mode.1.1 [MOD 3 ^ 11] :=
    (ZMod.eq_iff_modEq_nat (3 ^ 11)).mp hcoe
  have hmodeLt : mode.1.1 < 177147 := by
    simpa [generalKModulus] using mode.1.2
  simpa [Nat.ModEq, generalKModulus,
    Nat.mod_eq_of_lt hmodeLt] using hmodEq

theorem k11_classRoots_nonempty : GeneralKClassRootsNonempty 11 := by
  intro mode
  obtain ⟨exponent, hexponent⟩ := exists_k11_power_residue mode
  refine ⟨⟨2 ^ (exponent + 118098), ?_, notInCycle_two_pow (by omega), ?_⟩⟩
  rw [pow_add, Nat.mul_mod]
  have hperiod : 2 ^ 118098 % generalKModulus 11 = 1 := by
    norm_num [generalKModulus]
  rw [hperiod, Nat.mul_one, Nat.mod_mod, hexponent]
  exact one_le_pow₀ (by norm_num)

end K11ClassRoots
end KL2003
end CollatzClassical
