import CollatzClassical.KL2003.KL2003M0CRetardedInduction
import CollatzClassical.KL2003.KL2003M0BReachabilityAPI
import CollatzClassical.KL2003.KL2003M0BD123CoreInstantiations
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

/-!
## Row25 seam traffic

The row25 seam is the single-branch retarded row.  It deliberately does not
use the advanced child in the EL ledger.
-/

theorem T_le_two_of_le_two {n : Nat} (hn : n <= 2) :
    T n <= 2 := by
  have hcases : n = 0 ∨ n = 1 ∨ n = 2 := by omega
  rcases hcases with rfl | rfl | rfl <;> norm_num [T]

theorem iterate_two_le_two (q : Nat) :
    T^[q] 2 <= 2 := by
  induction q with
  | zero =>
      simp
  | succ q ih =>
      simpa [Function.iterate_succ_apply'] using T_le_two_of_le_two ih

theorem notInCycle_five :
    NotInCycle 5 := by
  intro q hq hcycle
  by_cases hsmall : q < 3
  · interval_cases q <;> norm_num [T] at hcycle
  · have hq3 : 3 <= q := by omega
    have hle : T^[q] 5 <= 2 := by
      calc
        T^[q] 5 = T^[(q - 3) + 3] 5 := by
          have hidx : (q - 3) + 3 = q := by omega
          rw [hidx]
        _ = T^[q - 3] (T^[3] 5) := by
          rw [Function.iterate_add_apply]
        _ = T^[q - 3] 2 := by norm_num [T]
        _ <= 2 := iterate_two_le_two (q - 3)
    have hfive_le_two : 5 <= 2 := by
      rw [hcycle] at hle
      exact hle
    omega

theorem classRoots_five_nonempty :
    Nonempty (ClassRoots 5) := by
  exact ⟨⟨5, by norm_num, notInCycle_five, by norm_num⟩⟩

theorem notInCycle_four_mul {a : Nat}
    (ha : NotInCycle a) :
    NotInCycle (4 * a) := by
  intro q hq hcycle
  have hcycle_a : T^[q] a = a := by
    calc
      T^[q] a = T^[q] (T^[2] (4 * a)) := by
        rw [two_branch_T_two_steps_four_mul]
      _ = T^[q + 2] (4 * a) := by
        exact (Function.iterate_add_apply T q 2 (4 * a)).symm
      _ = T^[2 + q] (4 * a) := by
        rw [Nat.add_comm]
      _ = T^[2] (T^[q] (4 * a)) := by
        rw [Function.iterate_add_apply]
      _ = T^[2] (4 * a) := by
        rw [hcycle]
      _ = a := two_branch_T_two_steps_four_mul a
  exact (ha q hq) hcycle_a

theorem row25_retarded_residue_mod_9 {a : Nat}
    (ha : a % 9 = 5) :
    (4 * a) % 9 = 2 := by
  have haeq : a = 9 * (a / 9) + 5 := by
    have h := Nat.div_add_mod a 9
    omega
  exact retarded_residue_mod_9_of_root_mod_5 (t := a / 9) haeq

def row25_retarded_classRoot (a : ClassRoots 5) :
    ClassRoots 2 := by
  exact
    ⟨4 * a.1,
      row25_retarded_residue_mod_9 a.2.1,
      notInCycle_four_mul a.2.2.1,
      by omega⟩

theorem row25_advanced_child_arith {a : Nat}
    (ha : a % 9 = 5) :
    3 * (6 * (a / 9) + 3) + 1 = 2 * a := by
  have haeq : a = 9 * (a / 9) + 5 := by
    have h := Nat.div_add_mod a 9
    omega
  omega

theorem row25_concreteWindow_retarded (y : Real) (a : Nat) :
    concreteWindow (y - 2) (4 * a) = concreteWindow y a := by
  unfold concreteWindow
  apply congrArg Nat.ceil
  calc
    (2 : Real) ^ (y - 2) * ((4 * a : Nat) : Real)
        = ((2 : Real) ^ y / (2 : Real) ^ (2 : Real)) * (4 * (a : Real)) := by
          rw [Real.rpow_sub (by norm_num : 0 < (2 : Real))]
          norm_num
    _ = ((2 : Real) ^ y / 4) * (4 * (a : Real)) := by
          rw [Real.rpow_two]
          norm_num
    _ = (2 : Real) ^ y * (a : Real) := by ring

theorem row25_piStar_retarded_le_target
    {y : Real} (hy0 : 0 <= y) (a : ClassRoots 5) :
    (piStar (4 * a.1) (concreteWindow (y - 2) (4 * a.1)) : Real) <=
      (piStar a.1 (concreteWindow y a.1) : Real) := by
  let c := 6 * (a.1 / 9) + 3
  have hcore :
      piStar (4 * a.1) (concreteWindow y a.1) <=
        piStar a.1 (concreteWindow y a.1) := by
    dsimp [piStar]
    exact
      d2_single_branch_core_instantiation
        (a := a.1) (c := c)
        (x := concreteWindow y a.1) (xRet := concreteWindow y a.1)
        a.2.2.2
        a.2.2.1
        (by
          dsimp [c]
          exact row25_advanced_child_arith a.2.1)
        (classRoot_le_concreteWindow (m := 5) hy0 a)
        le_rfl
  have hcore_real :
      (piStar (4 * a.1) (concreteWindow y a.1) : Real) <=
        (piStar a.1 (concreteWindow y a.1) : Real) := by
    exact_mod_cast hcore
  simpa [row25_concreteWindow_retarded] using hcore_real

theorem concretePhi_row25_seam :
    forall y, 14 <= y ->
      concretePhi.phi22 (y - 2) <= concretePhi.phi25 y := by
  intro y hy14
  have hy0 : 0 <= y := by linarith
  have hy2 : 0 <= y - 2 := by linarith
  dsimp [concretePhi]
  letI : Nonempty (ClassRoots 5) := classRoots_five_nonempty
  refine
    le_concretePhiComponent_of_forall
      (m := 5) (y := y) (b := concretePhiComponent 2 (y - 2)) hy0 ?_
  intro a
  have hsource :
      concretePhiComponent 2 (y - 2) <=
        (piStar (4 * a.1)
          (concreteWindow (y - 2) (4 * a.1)) : Real) :=
    by
      have hsource0 :=
        concretePhiComponent_le_piStar_of_classRoot
          (m := 2) (y := y - 2) hy2 (row25_retarded_classRoot a)
      simpa [row25_retarded_classRoot] using hsource0
  exact hsource.trans (row25_piStar_retarded_le_target hy0 a)

/-!
## Row22 parity lift

For roots `a % 9 = 2`, the direct advanced child has residue `1 mod 3` and
is not a tracked class.  The seam therefore tracks the parity lift `2*c`,
which maps to `c` in one `T` step and lands in one of the classes `{2,5,8}`.
-/

def row22AdvancedChild (a : Nat) : Nat :=
  6 * (a / 9) + 1

def row22LiftedChild (a : Nat) : Nat :=
  2 * row22AdvancedChild a

theorem row22_root_decomp {a : Nat} (ha : a % 9 = 2) :
    a = 9 * (a / 9) + 2 := by
  have h := Nat.div_add_mod a 9
  omega

theorem row22_advanced_child_arith {a : Nat}
    (ha : a % 9 = 2) :
    3 * row22AdvancedChild a + 1 = 2 * a := by
  have haeq := row22_root_decomp ha
  dsimp [row22AdvancedChild]
  omega

theorem row22_advanced_child_mod_three (a : Nat) :
    row22AdvancedChild a % 3 = 1 := by
  dsimp [row22AdvancedChild]
  have hExpr : 6 * (a / 9) + 1 = 3 * (2 * (a / 9)) + 1 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem row22_parity_lift_maps_to_child (a : Nat) :
    T (row22LiftedChild a) = row22AdvancedChild a := by
  dsimp [row22LiftedChild]
  exact two_branch_T_two_mul (row22AdvancedChild a)

theorem row22_advanced_child_maps_to_root {a : Nat}
    (ha : a % 9 = 2) :
    T (row22AdvancedChild a) = a := by
  exact two_branch_advanced_child_maps_to_root (row22_advanced_child_arith ha)

theorem row22_parity_lift_route_to_root {a : Nat}
    (ha : a % 9 = 2) :
    T^[2] (row22LiftedChild a) = a := by
  calc
    T^[2] (row22LiftedChild a) = T (T (row22LiftedChild a)) := by rfl
    _ = T (row22AdvancedChild a) := by rw [row22_parity_lift_maps_to_child]
    _ = a := row22_advanced_child_maps_to_root ha

theorem notInCycle_of_iterate_maps_to_notInCycle {a b k : Nat}
    (ha : NotInCycle a)
    (hmap : T^[k] b = a) :
    NotInCycle b := by
  intro q hq hcycle
  have hcycle_a : T^[q] a = a := by
    calc
      T^[q] a = T^[q] (T^[k] b) := by rw [hmap]
      _ = T^[q + k] b := by
        exact (Function.iterate_add_apply T q k b).symm
      _ = T^[k + q] b := by rw [Nat.add_comm]
      _ = T^[k] (T^[q] b) := by
        rw [Function.iterate_add_apply]
      _ = T^[k] b := by rw [hcycle]
      _ = a := hmap
  exact (ha q hq) hcycle_a

theorem row22_advanced_child_notInCycle {a : Nat}
    (ha_mod : a % 9 = 2)
    (ha_cycle : NotInCycle a) :
    NotInCycle (row22AdvancedChild a) := by
  exact notInCycle_of_iterate_maps_to_notInCycle
    (a := a) (b := row22AdvancedChild a) (k := 1)
    ha_cycle (by simpa [Function.iterate_one] using row22_advanced_child_maps_to_root ha_mod)

theorem row22_lifted_child_notInCycle {a : Nat}
    (ha_mod : a % 9 = 2)
    (ha_cycle : NotInCycle a) :
    NotInCycle (row22LiftedChild a) := by
  exact notInCycle_of_iterate_maps_to_notInCycle
    (a := a) (b := row22LiftedChild a) (k := 2)
    ha_cycle (row22_parity_lift_route_to_root ha_mod)

theorem row22_lifted_child_residue_mod_9_of_t_mod_0 {t : Nat}
    (ht : t % 3 = 0) :
    (2 * (6 * t + 1)) % 9 = 2 := by
  have ht_decomp : t = 3 * (t / 3) := by
    have h := Nat.div_add_mod t 3
    omega
  rw [ht_decomp]
  have hExpr : 2 * (6 * (3 * (t / 3)) + 1) = 9 * (4 * (t / 3)) + 2 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem row22_lifted_child_residue_mod_9_of_t_mod_1 {t : Nat}
    (ht : t % 3 = 1) :
    (2 * (6 * t + 1)) % 9 = 5 := by
  have ht_decomp : t = 3 * (t / 3) + 1 := by
    have h := Nat.div_add_mod t 3
    omega
  rw [ht_decomp]
  have hExpr :
      2 * (6 * (3 * (t / 3) + 1) + 1) = 9 * (4 * (t / 3) + 1) + 5 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem row22_lifted_child_residue_mod_9_of_t_mod_2 {t : Nat}
    (ht : t % 3 = 2) :
    (2 * (6 * t + 1)) % 9 = 8 := by
  have ht_decomp : t = 3 * (t / 3) + 2 := by
    have h := Nat.div_add_mod t 3
    omega
  rw [ht_decomp]
  have hExpr :
      2 * (6 * (3 * (t / 3) + 2) + 1) = 9 * (4 * (t / 3) + 2) + 8 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem row22_lifted_child_residue_mod_9_of_root_t_mod_0 {a : Nat}
    (ht : (a / 9) % 3 = 0) :
    row22LiftedChild a % 9 = 2 := by
  dsimp [row22LiftedChild, row22AdvancedChild]
  exact row22_lifted_child_residue_mod_9_of_t_mod_0 ht

theorem row22_lifted_child_residue_mod_9_of_root_t_mod_1 {a : Nat}
    (ht : (a / 9) % 3 = 1) :
    row22LiftedChild a % 9 = 5 := by
  dsimp [row22LiftedChild, row22AdvancedChild]
  exact row22_lifted_child_residue_mod_9_of_t_mod_1 ht

theorem row22_lifted_child_residue_mod_9_of_root_t_mod_2 {a : Nat}
    (ht : (a / 9) % 3 = 2) :
    row22LiftedChild a % 9 = 8 := by
  dsimp [row22LiftedChild, row22AdvancedChild]
  exact row22_lifted_child_residue_mod_9_of_t_mod_2 ht

def row22_lifted_child_classRoot_mod2 (a : ClassRoots 2)
    (ht : (a.1 / 9) % 3 = 0) :
    ClassRoots 2 := by
  exact
    ⟨row22LiftedChild a.1,
      row22_lifted_child_residue_mod_9_of_root_t_mod_0 ht,
      row22_lifted_child_notInCycle a.2.1 a.2.2.1,
      by dsimp [row22LiftedChild, row22AdvancedChild]; omega⟩

def row22_lifted_child_classRoot_mod5 (a : ClassRoots 2)
    (ht : (a.1 / 9) % 3 = 1) :
    ClassRoots 5 := by
  exact
    ⟨row22LiftedChild a.1,
      row22_lifted_child_residue_mod_9_of_root_t_mod_1 ht,
      row22_lifted_child_notInCycle a.2.1 a.2.2.1,
      by dsimp [row22LiftedChild, row22AdvancedChild]; omega⟩

def row22_lifted_child_classRoot_mod8 (a : ClassRoots 2)
    (ht : (a.1 / 9) % 3 = 2) :
    ClassRoots 8 := by
  exact
    ⟨row22LiftedChild a.1,
      row22_lifted_child_residue_mod_9_of_root_t_mod_2 ht,
      row22_lifted_child_notInCycle a.2.1 a.2.2.1,
      by dsimp [row22LiftedChild, row22AdvancedChild]; omega⟩

theorem row22_parity_concreteWindow (z : Real) (c : Nat) :
    concreteWindow (z - 1) (2 * c) = concreteWindow z c := by
  unfold concreteWindow
  apply congrArg Nat.ceil
  calc
    (2 : Real) ^ (z - 1) * ((2 * c : Nat) : Real)
        = ((2 : Real) ^ z / (2 : Real) ^ (1 : Real)) * (2 * (c : Real)) := by
          rw [Real.rpow_sub (by norm_num : 0 < (2 : Real))]
          norm_num
    _ = ((2 : Real) ^ z / 2) * (2 * (c : Real)) := by
          rw [Real.rpow_one]
    _ = (2 : Real) ^ z * (c : Real) := by ring

theorem row22_parity_piStar_transfer_nat {c xLift x : Nat}
    (hxLift : xLift <= x) :
    piStar (2 * c) xLift <= piStar c x := by
  dsimp [piStar]
  refine Finset.card_le_card ?_
  intro n hn
  have hm :=
    (mem_piStarFinset_reachesWithin_iff
      (a := 2 * c) (x := xLift) (n := n)).1 hn
  have hroot : 2 * c <= xLift :=
    reachesWithin_root_le_window hm.2.2
  have h2cx : 2 * c <= x := le_trans hroot hxLift
  have hcx : c <= x := by omega
  have hreach :
      ReachesWithin c x n :=
    reachesWithin_append_path
      (reachesWithin_window_mono hm.2.2 hxLift) le_rfl
      (two_branch_child_path_to_root (a := c) (x := x) h2cx hcx)
  rw [mem_piStarFinset_reachesWithin_iff]
  exact ⟨le_trans hm.1 hxLift, hm.2.1, hreach⟩

theorem row22_parity_piStar_transfer (z : Real) (c : Nat) :
    (piStar (2 * c) (concreteWindow (z - 1) (2 * c)) : Real) <=
      (piStar c (concreteWindow z c) : Real) := by
  have hx :
      concreteWindow (z - 1) (2 * c) <= concreteWindow z c := by
    rw [row22_parity_concreteWindow]
  exact_mod_cast row22_parity_piStar_transfer_nat (c := c) hx

/-!
## Row22 seam

This is the concrete D1/row22 seam.  The retarded source is `4*a`, in class
`8`.  The direct advanced child is first lifted by one parity step to land in
one of the tracked classes `{2,5,8}`; that exact parity step accounts for the
extra `-1` in the padded shift `alpha - 2 - epsilon0`.
-/

theorem two_rpow_alpha :
    (2 : Real) ^ alpha = 3 := by
  have hbase_pos : 0 < (2 : Real) := by norm_num
  have hbase_ne : (2 : Real) ≠ 1 := by norm_num
  have hx : 0 < (3 : Real) := by norm_num
  unfold alpha
  exact Real.rpow_logb hbase_pos hbase_ne hx

theorem two_rpow_alpha_sub_one :
    (2 : Real) ^ (alpha - 1) = (3 / 2 : Real) := by
  rw [Real.rpow_sub (by norm_num : 0 < (2 : Real))]
  rw [two_rpow_alpha, Real.rpow_one]

theorem row22_pad_power_mul_child_le_root {a : Nat}
    (ha : a % 9 = 2) :
    (2 : Real) ^ (alpha - 1 - epsilon0) *
        (row22AdvancedChild a : Real) <= (a : Real) := by
  have hpow :
      (2 : Real) ^ (alpha - 1 - epsilon0) <=
        (2 : Real) ^ (alpha - 1) := by
    exact
      Real.rpow_le_rpow_of_exponent_le
        (by norm_num : (1 : Real) <= 2) (by linarith [epsilon0_nonneg])
  have hmul :
      (2 : Real) ^ (alpha - 1 - epsilon0) *
          (row22AdvancedChild a : Real) <=
        (2 : Real) ^ (alpha - 1) *
          (row22AdvancedChild a : Real) :=
    mul_le_mul_of_nonneg_right hpow (Nat.cast_nonneg _)
  have harith :
      (3 : Real) * (row22AdvancedChild a : Real) + 1 =
        2 * (a : Real) := by
    exact_mod_cast row22_advanced_child_arith ha
  have hchild :
      (2 : Real) ^ (alpha - 1) *
          (row22AdvancedChild a : Real) <= (a : Real) := by
    rw [two_rpow_alpha_sub_one]
    nlinarith
  exact hmul.trans hchild

theorem row22_advanced_window_le_target
    {y : Real} (_hy14 : 14 <= y) (a : ClassRoots 2) :
    concreteWindow (y + shiftAlphaMinus1Pad) (row22AdvancedChild a.1) <=
      concreteWindow y a.1 := by
  unfold concreteWindow
  apply Nat.ceil_mono
  have hshift :
      (2 : Real) ^ shiftAlphaMinus1Pad *
          (row22AdvancedChild a.1 : Real) <= (a.1 : Real) := by
    simpa [shiftAlphaMinus1Pad] using
      row22_pad_power_mul_child_le_root a.2.1
  calc
    (2 : Real) ^ (y + shiftAlphaMinus1Pad) *
        (row22AdvancedChild a.1 : Real)
        = (2 : Real) ^ y *
            ((2 : Real) ^ shiftAlphaMinus1Pad *
              (row22AdvancedChild a.1 : Real)) := by
          rw [Real.rpow_add (by norm_num : 0 < (2 : Real))]
          ring
    _ <= (2 : Real) ^ y * (a.1 : Real) :=
          mul_le_mul_of_nonneg_left hshift
            (Real.rpow_nonneg (by norm_num : (0 : Real) <= 2) y)

theorem row22_shiftAlphaMinus2Pad_nonneg {y : Real}
    (hy14 : 14 <= y) :
    0 <= y + shiftAlphaMinus2Pad := by
  dsimp [shiftAlphaMinus2Pad]
  linarith [hy14, alpha_lower_bound, epsilon0_lt_one]

theorem notInCycle_eleven :
    NotInCycle 11 := by
  exact
    notInCycle_of_iterate_maps_to_notInCycle
      (a := 5) (b := 11) (k := 6)
      notInCycle_five (by norm_num [T])

theorem classRoots_two_nonempty :
    Nonempty (ClassRoots 2) := by
  exact ⟨⟨11, by norm_num, notInCycle_eleven, by norm_num⟩⟩

def row22_retarded_classRoot (a : ClassRoots 2) :
    ClassRoots 8 := by
  exact
    ⟨4 * a.1,
      retarded_residue_mod_9_of_root_mod_2
        (t := a.1 / 9) (row22_root_decomp a.2.1),
      notInCycle_four_mul a.2.2.1,
      by omega⟩

theorem row22_min3_le_lifted_child
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 2) :
    min3
        (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
        (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
        (concretePhiComponent 8 (y + shiftAlphaMinus2Pad))
      <=
      (piStar (row22LiftedChild a.1)
        (concreteWindow (y + shiftAlphaMinus2Pad)
          (row22LiftedChild a.1)) : Real) := by
  have hyPad : 0 <= y + shiftAlphaMinus2Pad :=
    row22_shiftAlphaMinus2Pad_nonneg hy14
  have hcases :
      (a.1 / 9) % 3 = 0 ∨
        (a.1 / 9) % 3 = 1 ∨
        (a.1 / 9) % 3 = 2 := by
    have hlt : (a.1 / 9) % 3 < 3 := Nat.mod_lt _ (by norm_num)
    omega
  rcases hcases with h0 | h1 | h2
  · have hmin :
        min3
            (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
            (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
            (concretePhiComponent 8 (y + shiftAlphaMinus2Pad))
          <= concretePhiComponent 2 (y + shiftAlphaMinus2Pad) := by
      dsimp [min3]
      exact min_le_left _ _
    have hphi :=
      concretePhiComponent_le_piStar_of_classRoot
        (m := 2) (y := y + shiftAlphaMinus2Pad)
        hyPad (row22_lifted_child_classRoot_mod2 a h0)
    exact hmin.trans (by simpa [row22_lifted_child_classRoot_mod2] using hphi)
  · have hmin :
        min3
            (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
            (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
            (concretePhiComponent 8 (y + shiftAlphaMinus2Pad))
          <= concretePhiComponent 5 (y + shiftAlphaMinus2Pad) := by
      dsimp [min3]
      exact (min_le_right _ _).trans (min_le_left _ _)
    have hphi :=
      concretePhiComponent_le_piStar_of_classRoot
        (m := 5) (y := y + shiftAlphaMinus2Pad)
        hyPad (row22_lifted_child_classRoot_mod5 a h1)
    exact hmin.trans (by simpa [row22_lifted_child_classRoot_mod5] using hphi)
  · have hmin :
        min3
            (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
            (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
            (concretePhiComponent 8 (y + shiftAlphaMinus2Pad))
          <= concretePhiComponent 8 (y + shiftAlphaMinus2Pad) := by
      dsimp [min3]
      exact (min_le_right _ _).trans (min_le_right _ _)
    have hphi :=
      concretePhiComponent_le_piStar_of_classRoot
        (m := 8) (y := y + shiftAlphaMinus2Pad)
        hyPad (row22_lifted_child_classRoot_mod8 a h2)
    exact hmin.trans (by simpa [row22_lifted_child_classRoot_mod8] using hphi)

theorem row22_min3_le_direct_advanced
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 2) :
    min3
        (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
        (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
        (concretePhiComponent 8 (y + shiftAlphaMinus2Pad))
      <=
      (piStar (row22AdvancedChild a.1)
        (concreteWindow (y + shiftAlphaMinus1Pad)
          (row22AdvancedChild a.1)) : Real) := by
  have hlift := row22_min3_le_lifted_child hy14 a
  have htransfer :=
    row22_parity_piStar_transfer
      (z := y + shiftAlphaMinus1Pad)
      (c := row22AdvancedChild a.1)
  have htransfer' :
      (piStar (row22LiftedChild a.1)
        (concreteWindow (y + shiftAlphaMinus2Pad)
          (row22LiftedChild a.1)) : Real) <=
      (piStar (row22AdvancedChild a.1)
        (concreteWindow (y + shiftAlphaMinus1Pad)
          (row22AdvancedChild a.1)) : Real) := by
    have hshift :
        y + shiftAlphaMinus1Pad - 1 = y + shiftAlphaMinus2Pad := by
      dsimp [shiftAlphaMinus1Pad, shiftAlphaMinus2Pad]
      ring
    rw [← hshift]
    simpa [row22LiftedChild] using htransfer
  exact hlift.trans htransfer'

theorem row22_piStar_sum_le_target
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 2) :
    piStar (4 * a.1) (concreteWindow y a.1) +
        piStar (row22AdvancedChild a.1)
          (concreteWindow (y + shiftAlphaMinus1Pad)
            (row22AdvancedChild a.1))
      <=
      piStar a.1 (concreteWindow y a.1) := by
  exact
    d1_core_instantiation
      (a := a.1) (c := row22AdvancedChild a.1)
      (x := concreteWindow y a.1)
      (xRet := concreteWindow y a.1)
      (xAdv :=
        concreteWindow (y + shiftAlphaMinus1Pad)
          (row22AdvancedChild a.1))
      a.2.2.2
      a.2.2.1
      (row22_advanced_child_arith a.2.1)
      (classRoot_le_concreteWindow (m := 2) (by linarith [hy14]) a)
      le_rfl
      (row22_advanced_window_le_target hy14 a)

theorem concretePhi_row22_seam :
    forall y, 14 <= y ->
      concretePhi.phi28 (y - 2)
        + min3
            (concretePhi.phi22 (y + shiftAlphaMinus2Pad))
            (concretePhi.phi25 (y + shiftAlphaMinus2Pad))
            (concretePhi.phi28 (y + shiftAlphaMinus2Pad))
        <= concretePhi.phi22 y := by
  intro y hy14
  have hy0 : 0 <= y := by linarith
  have hy2 : 0 <= y - 2 := by linarith
  dsimp [concretePhi]
  letI : Nonempty (ClassRoots 2) := classRoots_two_nonempty
  refine
    le_concretePhiComponent_of_forall
      (m := 2) (y := y)
      (b :=
        concretePhiComponent 8 (y - 2)
          + min3
              (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
              (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
              (concretePhiComponent 8 (y + shiftAlphaMinus2Pad)))
      hy0 ?_
  intro a
  let x := concreteWindow y a.1
  let c := row22AdvancedChild a.1
  let xAdv := concreteWindow (y + shiftAlphaMinus1Pad) c
  have hret :
      concretePhiComponent 8 (y - 2) <=
        (piStar (4 * a.1) x : Real) := by
    have hret0 :=
      concretePhiComponent_le_piStar_of_classRoot
        (m := 8) (y := y - 2) hy2 (row22_retarded_classRoot a)
    simpa [x, row22_retarded_classRoot, row25_concreteWindow_retarded] using hret0
  have hadv :
      min3
          (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
          (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
          (concretePhiComponent 8 (y + shiftAlphaMinus2Pad))
        <=
        (piStar c xAdv : Real) := by
    simpa [c, xAdv] using row22_min3_le_direct_advanced hy14 a
  have hsum :
      concretePhiComponent 8 (y - 2)
          + min3
              (concretePhiComponent 2 (y + shiftAlphaMinus2Pad))
              (concretePhiComponent 5 (y + shiftAlphaMinus2Pad))
              (concretePhiComponent 8 (y + shiftAlphaMinus2Pad))
        <=
        ((piStar (4 * a.1) x + piStar c xAdv : Nat) : Real) := by
    rw [Nat.cast_add]
    exact add_le_add hret hadv
  have hcore :
      ((piStar (4 * a.1) x + piStar c xAdv : Nat) : Real) <=
        (piStar a.1 x : Real) := by
    exact_mod_cast row22_piStar_sum_le_target (y := y) hy14 a
  exact hsum.trans hcore

/-!
## Row28 nested seam traffic

The row28/D3 advanced child is integral for roots `a % 9 = 8`.  Its residue
splits into `{5,2,8}` and determines which branch of the eliminated row28
block is meant to feed the direct advanced subtree.
-/

def row28AdvancedChild (a : Nat) : Nat :=
  6 * (a / 9) + 5

theorem row28_root_decomp {a : Nat} (ha : a % 9 = 8) :
    a = 9 * (a / 9) + 8 := by
  have h := Nat.div_add_mod a 9
  omega

theorem row28_advanced_child_arith {a : Nat}
    (ha : a % 9 = 8) :
    3 * row28AdvancedChild a + 1 = 2 * a := by
  have haeq := row28_root_decomp ha
  dsimp [row28AdvancedChild]
  omega

theorem row28_advanced_child_maps_to_root {a : Nat}
    (ha : a % 9 = 8) :
    T (row28AdvancedChild a) = a := by
  exact two_branch_advanced_child_maps_to_root (row28_advanced_child_arith ha)

theorem row28_advanced_child_notInCycle {a : Nat}
    (ha_mod : a % 9 = 8)
    (ha_cycle : NotInCycle a) :
    NotInCycle (row28AdvancedChild a) := by
  exact notInCycle_of_iterate_maps_to_notInCycle
    (a := a) (b := row28AdvancedChild a) (k := 1)
    ha_cycle (by simpa [Function.iterate_one] using row28_advanced_child_maps_to_root ha_mod)

theorem row28_advanced_child_residue_mod_9_of_root_t_mod_0 {a : Nat}
    (ht : (a / 9) % 3 = 0) :
    row28AdvancedChild a % 9 = 5 := by
  dsimp [row28AdvancedChild]
  exact d3_advanced_residue_mod_9_of_t_mod_0 rfl ht

theorem row28_advanced_child_residue_mod_9_of_root_t_mod_1 {a : Nat}
    (ht : (a / 9) % 3 = 1) :
    row28AdvancedChild a % 9 = 2 := by
  dsimp [row28AdvancedChild]
  exact d3_advanced_residue_mod_9_of_t_mod_1 rfl ht

theorem row28_advanced_child_residue_mod_9_of_root_t_mod_2 {a : Nat}
    (ht : (a / 9) % 3 = 2) :
    row28AdvancedChild a % 9 = 8 := by
  dsimp [row28AdvancedChild]
  exact d3_advanced_residue_mod_9_of_t_mod_2 rfl ht

def row28_advanced_child_classRoot_mod5 (a : ClassRoots 8)
    (ht : (a.1 / 9) % 3 = 0) :
    ClassRoots 5 := by
  exact
    ⟨row28AdvancedChild a.1,
      row28_advanced_child_residue_mod_9_of_root_t_mod_0 ht,
      row28_advanced_child_notInCycle a.2.1 a.2.2.1,
      by dsimp [row28AdvancedChild]; omega⟩

def row28_advanced_child_classRoot_mod2 (a : ClassRoots 8)
    (ht : (a.1 / 9) % 3 = 1) :
    ClassRoots 2 := by
  exact
    ⟨row28AdvancedChild a.1,
      row28_advanced_child_residue_mod_9_of_root_t_mod_1 ht,
      row28_advanced_child_notInCycle a.2.1 a.2.2.1,
      by dsimp [row28AdvancedChild]; omega⟩

def row28_advanced_child_classRoot_mod8 (a : ClassRoots 8)
    (ht : (a.1 / 9) % 3 = 2) :
    ClassRoots 8 := by
  exact
    ⟨row28AdvancedChild a.1,
      row28_advanced_child_residue_mod_9_of_root_t_mod_2 ht,
      row28_advanced_child_notInCycle a.2.1 a.2.2.1,
      by dsimp [row28AdvancedChild]; omega⟩

theorem row28_retarded_residue_mod_9 {a : Nat}
    (ha : a % 9 = 8) :
    (4 * a) % 9 = 5 := by
  exact
    retarded_residue_mod_9_of_root_mod_8
      (t := a / 9) (row28_root_decomp ha)

def row28_retarded_classRoot (a : ClassRoots 8) :
    ClassRoots 5 := by
  exact
    ⟨4 * a.1,
      row28_retarded_residue_mod_9 a.2.1,
      notInCycle_four_mul a.2.2.1,
      by omega⟩

theorem three_rpow_alpha_sub_one :
    (2 : Real) ^ (alpha - 1) / 3 = (1 / 2 : Real) := by
  rw [two_rpow_alpha_sub_one]
  norm_num

theorem row28_pad_power_mul_child_le_root {a : Nat}
    (ha : a % 9 = 8) :
    (2 : Real) ^ (alpha - 1 - epsilon0) *
        (row28AdvancedChild a : Real) <= (a : Real) := by
  have hpow :
      (2 : Real) ^ (alpha - 1 - epsilon0) <=
        (2 : Real) ^ (alpha - 1) := by
    exact
      Real.rpow_le_rpow_of_exponent_le
        (by norm_num : (1 : Real) <= 2) (by linarith [epsilon0_nonneg])
  have hmul :
      (2 : Real) ^ (alpha - 1 - epsilon0) *
          (row28AdvancedChild a : Real) <=
        (2 : Real) ^ (alpha - 1) *
          (row28AdvancedChild a : Real) :=
    mul_le_mul_of_nonneg_right hpow (Nat.cast_nonneg _)
  have harith :
      (3 : Real) * (row28AdvancedChild a : Real) + 1 =
        2 * (a : Real) := by
    exact_mod_cast row28_advanced_child_arith ha
  have hchild :
      (2 : Real) ^ (alpha - 1) *
          (row28AdvancedChild a : Real) <= (a : Real) := by
    rw [two_rpow_alpha_sub_one]
    nlinarith
  exact hmul.trans hchild

theorem row28_advanced_window_le_target
    {y : Real} (_hy14 : 14 <= y) (a : ClassRoots 8) :
    concreteWindow (y + shiftAlphaMinus1Pad) (row28AdvancedChild a.1) <=
      concreteWindow y a.1 := by
  unfold concreteWindow
  apply Nat.ceil_mono
  have hshift :
      (2 : Real) ^ shiftAlphaMinus1Pad *
          (row28AdvancedChild a.1 : Real) <= (a.1 : Real) := by
    simpa [shiftAlphaMinus1Pad] using
      row28_pad_power_mul_child_le_root a.2.1
  calc
    (2 : Real) ^ (y + shiftAlphaMinus1Pad) *
        (row28AdvancedChild a.1 : Real)
        = (2 : Real) ^ y *
            ((2 : Real) ^ shiftAlphaMinus1Pad *
              (row28AdvancedChild a.1 : Real)) := by
          rw [Real.rpow_add (by norm_num : 0 < (2 : Real))]
          ring
    _ <= (2 : Real) ^ y * (a.1 : Real) :=
          mul_le_mul_of_nonneg_left hshift
            (Real.rpow_nonneg (by norm_num : (0 : Real) <= 2) y)

theorem row28_shiftAlphaMinus1Pad_nonneg {y : Real}
    (hy14 : 14 <= y) :
    0 <= y + shiftAlphaMinus1Pad := by
  dsimp [shiftAlphaMinus1Pad]
  linarith [hy14, alpha_lower_bound, epsilon0_lt_one]

theorem row28_shiftAlphaMinus3Pad_nonneg {y : Real}
    (hy14 : 14 <= y) :
    0 <= y + shiftAlphaMinus3Pad := by
  dsimp [shiftAlphaMinus3Pad]
  linarith [hy14, alpha_lower_bound, epsilon0_lt_one]

theorem row28_shiftAlphaMinus3Pad_le_shiftAlphaMinus1Pad (y : Real) :
    y + shiftAlphaMinus3Pad <= y + shiftAlphaMinus1Pad := by
  dsimp [shiftAlphaMinus3Pad, shiftAlphaMinus1Pad]
  linarith

theorem row28_outer_block_le_second (y : Real) :
    min
        (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
        (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
      <= concretePhi.phi22 (y + shiftAlphaMinus3Pad) := by
  exact min_le_right _ _

theorem row28_outer_block_le_child_mod2
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 8)
    (ht : (a.1 / 9) % 3 = 1) :
    min
        (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
        (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
      <=
      (piStar (row28AdvancedChild a.1)
        (concreteWindow (y + shiftAlphaMinus1Pad)
          (row28AdvancedChild a.1)) : Real) := by
  have hs3 : 0 <= y + shiftAlphaMinus3Pad :=
    row28_shiftAlphaMinus3Pad_nonneg hy14
  have hs1 : 0 <= y + shiftAlphaMinus1Pad :=
    row28_shiftAlphaMinus1Pad_nonneg hy14
  have hmono :
      concretePhi.phi22 (y + shiftAlphaMinus3Pad) <=
        concretePhi.phi22 (y + shiftAlphaMinus1Pad) := by
    dsimp [concretePhi]
    exact
      concretePhiComponent_mono_y
        (m := 2) (row28_shiftAlphaMinus3Pad_le_shiftAlphaMinus1Pad y)
  have hphi :
      concretePhi.phi22 (y + shiftAlphaMinus1Pad) <=
        (piStar (row28AdvancedChild a.1)
          (concreteWindow (y + shiftAlphaMinus1Pad)
            (row28AdvancedChild a.1)) : Real) := by
    dsimp [concretePhi]
    exact
      concretePhiComponent_le_piStar_of_classRoot
        (m := 2) (y := y + shiftAlphaMinus1Pad)
        hs1 (row28_advanced_child_classRoot_mod2 a ht)
  exact (row28_outer_block_le_second y).trans (hmono.trans hphi)

theorem row28_child_mod5_row25_shift_ge_fourteen
    {y : Real} (hy14 : 14 <= y) :
    14 <= y + shiftAlphaMinus1Pad := by
  dsimp [shiftAlphaMinus1Pad, epsilon0]
  linarith [hy14, alpha_lower_bound]

theorem row28_outer_block_le_child_mod5
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 8)
    (ht : (a.1 / 9) % 3 = 0) :
    min
        (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
        (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
      <=
      (piStar (row28AdvancedChild a.1)
        (concreteWindow (y + shiftAlphaMinus1Pad)
          (row28AdvancedChild a.1)) : Real) := by
  let z := y + shiftAlphaMinus1Pad
  have hz14 : 14 <= z :=
    row28_child_mod5_row25_shift_ge_fourteen hy14
  have hs1 : 0 <= z := by linarith
  have hshift : z - 2 = y + shiftAlphaMinus3Pad := by
    dsimp [z, shiftAlphaMinus1Pad, shiftAlphaMinus3Pad]
    ring
  have hrow25 := concretePhi_row25_seam z hz14
  have hrow25' :
      concretePhi.phi22 (y + shiftAlphaMinus3Pad) <=
        concretePhi.phi25 (y + shiftAlphaMinus1Pad) := by
    simpa [z, hshift] using hrow25
  have hphi :
      concretePhi.phi25 (y + shiftAlphaMinus1Pad) <=
        (piStar (row28AdvancedChild a.1)
          (concreteWindow (y + shiftAlphaMinus1Pad)
            (row28AdvancedChild a.1)) : Real) := by
    dsimp [concretePhi]
    exact
      concretePhiComponent_le_piStar_of_classRoot
        (m := 5) (y := y + shiftAlphaMinus1Pad)
        hs1 (row28_advanced_child_classRoot_mod5 a ht)
  exact (row28_outer_block_le_second y).trans (hrow25'.trans hphi)

theorem row28_piStar_sum_le_target
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 8) :
    piStar (4 * a.1) (concreteWindow y a.1) +
        piStar (row28AdvancedChild a.1)
          (concreteWindow (y + shiftAlphaMinus1Pad)
            (row28AdvancedChild a.1))
      <=
      piStar a.1 (concreteWindow y a.1) := by
  exact
    d3_core_instantiation
      (a := a.1) (c := row28AdvancedChild a.1)
      (x := concreteWindow y a.1)
      (xRet := concreteWindow y a.1)
      (xAdv :=
        concreteWindow (y + shiftAlphaMinus1Pad)
          (row28AdvancedChild a.1))
      a.2.2.2
      a.2.2.1
      (row28_advanced_child_arith a.2.1)
      (classRoot_le_concreteWindow (m := 8) (by linarith [hy14]) a)
      le_rfl
      (row28_advanced_window_le_target hy14 a)

theorem row28_retarded_le_piStar_source
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 8) :
    concretePhi.phi25 (y - 2) <=
      (piStar (4 * a.1) (concreteWindow y a.1) : Real) := by
  have hy2 : 0 <= y - 2 := by linarith
  dsimp [concretePhi]
  have hsource0 :=
    concretePhiComponent_le_piStar_of_classRoot
      (m := 5) (y := y - 2) hy2 (row28_retarded_classRoot a)
  simpa [row28_retarded_classRoot, row25_concreteWindow_retarded] using hsource0

theorem row28_pointwise_seam_mod2
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 8)
    (ht : (a.1 / 9) % 3 = 1) :
    concretePhi.phi25 (y - 2)
        + min
            (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
            (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
      <=
      (piStar a.1 (concreteWindow y a.1) : Real) := by
  let x := concreteWindow y a.1
  let c := row28AdvancedChild a.1
  let xAdv := concreteWindow (y + shiftAlphaMinus1Pad) c
  have hret :
      concretePhi.phi25 (y - 2) <=
        (piStar (4 * a.1) x : Real) := by
    simpa [x] using row28_retarded_le_piStar_source hy14 a
  have hadv :
      min
          (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
          (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
        <=
        (piStar c xAdv : Real) := by
    simpa [c, xAdv] using row28_outer_block_le_child_mod2 hy14 a ht
  have hsum :
      concretePhi.phi25 (y - 2)
          + min
              (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
              (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
        <= ((piStar (4 * a.1) x + piStar c xAdv : Nat) : Real) := by
    rw [Nat.cast_add]
    exact add_le_add hret hadv
  have hcore :
      ((piStar (4 * a.1) x + piStar c xAdv : Nat) : Real) <=
        (piStar a.1 x : Real) := by
    exact_mod_cast row28_piStar_sum_le_target (y := y) hy14 a
  exact hsum.trans hcore

theorem row28_pointwise_seam_mod5
    {y : Real} (hy14 : 14 <= y) (a : ClassRoots 8)
    (ht : (a.1 / 9) % 3 = 0) :
    concretePhi.phi25 (y - 2)
        + min
            (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
            (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
      <=
      (piStar a.1 (concreteWindow y a.1) : Real) := by
  let x := concreteWindow y a.1
  let c := row28AdvancedChild a.1
  let xAdv := concreteWindow (y + shiftAlphaMinus1Pad) c
  have hret :
      concretePhi.phi25 (y - 2) <=
        (piStar (4 * a.1) x : Real) := by
    simpa [x] using row28_retarded_le_piStar_source hy14 a
  have hadv :
      min
          (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
          (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
        <=
        (piStar c xAdv : Real) := by
    simpa [c, xAdv] using row28_outer_block_le_child_mod5 hy14 a ht
  have hsum :
      concretePhi.phi25 (y - 2)
          + min
              (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
              (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
        <= ((piStar (4 * a.1) x + piStar c xAdv : Nat) : Real) := by
    rw [Nat.cast_add]
    exact add_le_add hret hadv
  have hcore :
      ((piStar (4 * a.1) x + piStar c xAdv : Nat) : Real) <=
        (piStar a.1 x : Real) := by
    exact_mod_cast row28_piStar_sum_le_target (y := y) hy14 a
  exact hsum.trans hcore

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
