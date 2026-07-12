import CollatzClassical.KL2003.KL2003M0CRetardedInduction
import CollatzClassical.KL2003.KL2003M0BReachabilityAPI
import CollatzClassical.KL2003.KL2003RootCountUnitBase

namespace CollatzClassical
namespace KL2003

/-!
Direct concrete `Phi` realization from `piStar`.

This module defines the concrete components as an `iInf` over root classes.
It closes only the two easy semantic debts: zero-extension and the base-unit
lower bound.  The seam proof of `I2ELAbstractRowsV2 concretePhi` remains open.
-/

abbrev ClassRoots (m : Nat) :=
  {a : Nat // a % 9 = m ∧ NotInCycle a ∧ 1 <= a}

noncomputable def concreteWindow (y : Real) (a : Nat) : Nat :=
  Nat.ceil ((2 : Real) ^ y * (a : Real))

noncomputable def concretePhiComponent (m : Nat) (y : Real) : Real := by
  classical
  exact
    if y < 0 then
      0
    else
      if h : Nonempty (ClassRoots m) then
        letI : Nonempty (ClassRoots m) := h
        ⨅ a : ClassRoots m, (piStar a.1 (concreteWindow y a.1) : Real)
      else
        1

noncomputable def concretePhi : K2PhiSystem where
  phi22 := concretePhiComponent 2
  phi25 := concretePhiComponent 5
  phi28 := concretePhiComponent 8

theorem one_le_two_rpow_of_nonneg {y : Real} (hy0 : 0 <= y) :
    (1 : Real) <= (2 : Real) ^ y := by
  simpa using
    (Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : Real) <= 2) hy0)

theorem classRoot_le_concreteWindow {m : Nat} {y : Real}
    (hy0 : 0 <= y) (a : ClassRoots m) :
    a.1 <= concreteWindow y a.1 := by
  have hpow : (1 : Real) <= (2 : Real) ^ y :=
    one_le_two_rpow_of_nonneg hy0
  have ha_nonneg : 0 <= (a.1 : Real) := by exact_mod_cast Nat.zero_le a.1
  have hroot :
      (a.1 : Real) <= (2 : Real) ^ y * (a.1 : Real) := by
    simpa [one_mul] using mul_le_mul_of_nonneg_right hpow ha_nonneg
  have hceil :
      (2 : Real) ^ y * (a.1 : Real) <= (concreteWindow y a.1 : Real) := by
    exact Nat.le_ceil _
  exact_mod_cast hroot.trans hceil

theorem one_le_concretePhiComponent_of_nonneg
    {m : Nat} {y : Real} (hy0 : 0 <= y) :
    (1 : Real) <= concretePhiComponent m y := by
  classical
  dsimp [concretePhiComponent]
  simp only [not_lt_of_ge hy0, ↓reduceIte]
  split_ifs with hnonempty
  · letI : Nonempty (ClassRoots m) := hnonempty
    refine le_ciInf ?_
    intro a
    have hnat : 1 <= piStar a.1 (concreteWindow y a.1) :=
      root_count_unit_lower_bound_for_window
        a.2.2.2
        (classRoot_le_concreteWindow hy0 a)
    exact_mod_cast hnat
  · rfl

theorem concretePhi_zeroExtension :
    K2PhiZeroExtension concretePhi := by
  intro y hy
  exact ⟨by simp [concretePhi, concretePhiComponent, hy],
    by simp [concretePhi, concretePhiComponent, hy],
    by simp [concretePhi, concretePhiComponent, hy]⟩

theorem concretePhi_baseSegmentUnitLowerBound :
    BaseSegmentUnitLowerBound concretePhi := by
  intro y hy0 _hy14
  exact
    ⟨ one_le_concretePhiComponent_of_nonneg (m := 2) hy0,
      one_le_concretePhiComponent_of_nonneg (m := 5) hy0,
      one_le_concretePhiComponent_of_nonneg (m := 8) hy0 ⟩

theorem concretePhi_weightedBase :
    BaseSegmentWeightedLowerBound concretePhi :=
  base_weighted_of_unit concretePhi_baseSegmentUnitLowerBound

def concretePhiRowsV2SeamObligation : Prop :=
  I2ELAbstractRowsV2 concretePhi

end KL2003
end CollatzClassical
