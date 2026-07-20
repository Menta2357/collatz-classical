import CollatzClassical.KL2003.KL2003GeneralKSemantics
import Mathlib.RingTheory.ZMod.UnitsCyclic

namespace CollatzClassical
namespace KL2003
namespace K9ClassRoots

def k9TwoUnit : (ZMod (3 ^ 9))ˣ :=
  ZMod.unitOfCoprime 2 (by norm_num)

def k9NegTwoUnit : (ZMod (3 ^ 9))ˣ := -k9TwoUnit

theorem k9NegTwoUnit_order : orderOf k9NegTwoUnit = 3 ^ 8 := by
  rw [← orderOf_injective (Units.coeHom (ZMod (3 ^ 9))) Units.ext k9NegTwoUnit]
  simpa [k9NegTwoUnit, k9TwoUnit] using
    (ZMod.orderOf_one_add_mul_prime Nat.prime_three (by norm_num)
      (-1 : Int) (by norm_num) 8)

theorem k9NegOneUnit_order : orderOf (-1 : (ZMod (3 ^ 9))ˣ) = 2 := by
  letI : Fact (1 < 3 ^ 9) := ⟨by norm_num⟩
  rw [← orderOf_injective (Units.coeHom (ZMod (3 ^ 9))) Units.ext
    (-1 : (ZMod (3 ^ 9))ˣ)]
  change orderOf (-1 : ZMod (3 ^ 9)) = 2
  rw [orderOf_neg_one]
  norm_num [ringChar.eq]

theorem k9TwoUnit_order : orderOf k9TwoUnit = 13122 := by
  have hproduct :
      (-1 : (ZMod (3 ^ 9))ˣ) * k9NegTwoUnit = k9TwoUnit := by
    simp [k9NegTwoUnit]
  rw [← hproduct,
    (Commute.all _ _).orderOf_mul_eq_mul_orderOf_of_coprime (by
      rw [k9NegOneUnit_order, k9NegTwoUnit_order]
      norm_num),
    k9NegOneUnit_order, k9NegTwoUnit_order]
  norm_num

theorem k9TwoUnit_zpowers_eq_top : Subgroup.zpowers k9TwoUnit = ⊤ := by
  rw [← Subgroup.card_eq_iff_eq_top]
  rw [Nat.card_zpowers, k9TwoUnit_order]
  rw [Nat.card_eq_fintype_card, ZMod.card_units_eq_totient,
    Nat.totient_prime_pow Nat.prime_three (by norm_num)]
  norm_num

theorem exists_k9_power_residue (mode : TrackedMode 9) :
    exists exponent : Nat, 2 ^ exponent % generalKModulus 9 = mode.1.1 := by
  have hcoprime : Nat.Coprime mode.1.1 (3 ^ 9) := by
    apply Nat.prime_three.coprime_pow_of_not_dvd
    intro hdiv
    have hmod : mode.1.1 % 3 = 0 := Nat.dvd_iff_mod_eq_zero.mp hdiv
    omega
  let modeUnit : (ZMod (3 ^ 9))ˣ :=
    ZMod.unitOfCoprime mode.1.1 hcoprime
  have hmem : modeUnit ∈ Subgroup.zpowers k9TwoUnit := by
    rw [k9TwoUnit_zpowers_eq_top]
    exact Subgroup.mem_top modeUnit
  have hpower : modeUnit ∈ Submonoid.powers k9TwoUnit :=
    (mem_powers_iff_mem_zpowers).2 hmem
  obtain ⟨exponent, hexponent⟩ :=
    (Submonoid.mem_powers_iff modeUnit k9TwoUnit).1 hpower
  refine ⟨exponent, ?_⟩
  have hcoe := congr_arg (fun unit : (ZMod (3 ^ 9))ˣ =>
    (unit : ZMod (3 ^ 9))) hexponent
  change (k9TwoUnit : ZMod (3 ^ 9)) ^ exponent =
    (modeUnit : ZMod (3 ^ 9)) at hcoe
  simp only [k9TwoUnit, modeUnit, ZMod.coe_unitOfCoprime] at hcoe
  rw [← Nat.cast_pow] at hcoe
  change ((2 ^ exponent : Nat) : ZMod (3 ^ 9)) =
    (mode.1.1 : ZMod (3 ^ 9)) at hcoe
  have hmodEq : 2 ^ exponent ≡ mode.1.1 [MOD 3 ^ 9] :=
    (ZMod.eq_iff_modEq_nat (3 ^ 9)).mp hcoe
  have hmodeLt : mode.1.1 < 19683 := by
    simpa [generalKModulus] using mode.1.2
  simpa [Nat.ModEq, generalKModulus,
    Nat.mod_eq_of_lt hmodeLt] using hmodEq

theorem k9_classRoots_nonempty : GeneralKClassRootsNonempty 9 := by
  intro mode
  obtain ⟨exponent, hexponent⟩ := exists_k9_power_residue mode
  refine ⟨⟨2 ^ (exponent + 13122), ?_, notInCycle_two_pow (by omega), ?_⟩⟩
  rw [pow_add, Nat.mul_mod]
  have hperiod : 2 ^ 13122 % generalKModulus 9 = 1 := by
    norm_num [generalKModulus]
  rw [hperiod, Nat.mul_one, Nat.mod_mod, hexponent]
  exact one_le_pow₀ (by norm_num)

end K9ClassRoots
end KL2003
end CollatzClassical
