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

theorem piStarFinset_subset_window {a x1 x2 : Nat}
    (hx : x1 <= x2) :
    piStarFinset a x1 ⊆ piStarFinset a x2 := by
  intro n hn
  have hm :=
    (mem_piStarFinset_reachesWithin_iff (a := a) (x := x1) (n := n)).1 hn
  exact
    (mem_piStarFinset_reachesWithin_iff (a := a) (x := x2) (n := n)).2
      ⟨le_trans hm.1 hx, hm.2.1,
        reachesWithin_window_mono hm.2.2 hx⟩

theorem piStar_window_mono {a x1 x2 : Nat}
    (hx : x1 <= x2) :
    piStar a x1 <= piStar a x2 := by
  dsimp [piStar]
  exact Finset.card_le_card (piStarFinset_subset_window (a := a) hx)

theorem concreteWindow_mono_y {y1 y2 : Real} {a : Nat}
    (hy : y1 <= y2) :
    concreteWindow y1 a <= concreteWindow y2 a := by
  have hpow : (2 : Real) ^ y1 <= (2 : Real) ^ y2 :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : Real) <= 2) hy
  have ha_nonneg : 0 <= (a : Real) := by exact_mod_cast Nat.zero_le a
  exact Nat.ceil_mono (mul_le_mul_of_nonneg_right hpow ha_nonneg)

theorem concretePhiComponent_nonneg {m : Nat} {y : Real} :
    0 <= concretePhiComponent m y := by
  classical
  by_cases hy : y < 0
  · simp [concretePhiComponent, hy]
  · have hy0 : 0 <= y := le_of_not_gt hy
    dsimp [concretePhiComponent]
    simp only [hy, ↓reduceIte]
    split_ifs with hnonempty
    · letI : Nonempty (ClassRoots m) := hnonempty
      refine le_ciInf ?_
      intro a
      exact Nat.cast_nonneg _
    · norm_num

theorem concretePhiComponent_range_bddBelow {m : Nat} {y : Real} :
    BddBelow
      (Set.range
        (fun a : ClassRoots m =>
          (piStar a.1 (concreteWindow y a.1) : Real))) := by
  refine ⟨0, ?_⟩
  rintro _ ⟨a, rfl⟩
  exact Nat.cast_nonneg _

theorem concretePhiComponent_le_piStar_of_classRoot
    {m : Nat} {y : Real} (hy0 : 0 <= y) (a : ClassRoots m) :
    concretePhiComponent m y <=
      (piStar a.1 (concreteWindow y a.1) : Real) := by
  classical
  dsimp [concretePhiComponent]
  simp only [not_lt_of_ge hy0, ↓reduceIte]
  split_ifs with hnonempty
  · exact ciInf_le concretePhiComponent_range_bddBelow a
  · exact False.elim (hnonempty ⟨a⟩)

theorem concretePhiComponent_le_of_member
    {m a : Nat} {y : Real} (hy0 : 0 <= y)
    (hm : a % 9 = m) (hcycle : NotInCycle a) (ha : 1 <= a) :
    concretePhiComponent m y <=
      (piStar a (concreteWindow y a) : Real) := by
  exact
    concretePhiComponent_le_piStar_of_classRoot
      (m := m) (y := y) hy0 ⟨a, hm, hcycle, ha⟩

theorem le_concretePhiComponent_of_forall
    {m : Nat} {y b : Real} [Nonempty (ClassRoots m)] (hy0 : 0 <= y)
    (h :
      ∀ a : ClassRoots m,
        b <= (piStar a.1 (concreteWindow y a.1) : Real)) :
    b <= concretePhiComponent m y := by
  classical
  have hnonempty : Nonempty (ClassRoots m) := inferInstance
  simpa [concretePhiComponent, not_lt_of_ge hy0, hnonempty] using
    (le_ciInf h)

theorem concretePhiComponent_mono_y {m : Nat} {y1 y2 : Real}
    (hy : y1 <= y2) :
    concretePhiComponent m y1 <= concretePhiComponent m y2 := by
  classical
  by_cases hy1neg : y1 < 0
  · have hleft : concretePhiComponent m y1 = 0 := by
      simp [concretePhiComponent, hy1neg]
    rw [hleft]
    exact concretePhiComponent_nonneg
  · have hy10 : 0 <= y1 := le_of_not_gt hy1neg
    have hy20 : 0 <= y2 := le_trans hy10 hy
    dsimp [concretePhiComponent]
    simp only [not_lt_of_ge hy10, not_lt_of_ge hy20, ↓reduceIte]
    split_ifs with hnonempty
    · letI : Nonempty (ClassRoots m) := hnonempty
      refine le_ciInf ?_
      intro a
      have hwindow :
          concreteWindow y1 a.1 <= concreteWindow y2 a.1 :=
        concreteWindow_mono_y (a := a.1) hy
      have hpi :
          (piStar a.1 (concreteWindow y1 a.1) : Real) <=
            (piStar a.1 (concreteWindow y2 a.1) : Real) := by
        exact_mod_cast piStar_window_mono (a := a.1) hwindow
      exact (ciInf_le concretePhiComponent_range_bddBelow a).trans hpi
    · rfl

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
