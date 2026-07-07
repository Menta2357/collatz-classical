import CollatzClassical.KL2003.KL2003M0BEntryPredecessorDisjointness

/-!
# KL2003 M0B two-branch core

This module proves the class-free combinatorial core shared by the D1 and D3
two-branch rows.  It contains no scaling, rounding ledger, LP data, `Real`,
`rpow`, `alpha`, or residue-class assumptions.
-/

namespace CollatzClassical
namespace KL2003

theorem reachesWithin_root_le_window {a x n : Nat}
    (h : ReachesWithin a x n) :
    a <= x := by
  rcases h with ⟨k, hwin, hhit⟩
  simpa [hhit] using hwin k le_rfl

theorem two_branch_advanced_child_maps_to_root {a c : Nat}
    (hc : 3 * c + 1 = 2 * a) :
    T c = a := by
  by_cases hmod : c % 2 = 0
  · have hdiv : 2 ∣ c := Nat.dvd_iff_mod_eq_zero.mpr hmod
    rcases hdiv with ⟨q, rfl⟩
    omega
  · have hdiv : (3 * c + 1) / 2 = a := by
      rw [hc]
      exact Nat.mul_div_right a (by norm_num : 0 < 2)
    simp [T, hmod, hdiv]

theorem two_branch_children_distinct {a c : Nat}
    (_ha : 1 <= a) (hc : 3 * c + 1 = 2 * a) :
    2 * a ≠ c := by
  intro h
  omega

theorem two_branch_root_ne_retarded_child {a : Nat}
    (ha : 1 <= a) :
    2 * a ≠ a := by
  omega

theorem two_branch_advanced_child_ne_root {a c : Nat}
    (hc : 3 * c + 1 = 2 * a) :
    c ≠ a := by
  intro h
  omega

theorem two_branch_T_two_mul (a : Nat) :
    T (2 * a) = a := by
  simp [T, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc]

theorem two_branch_T_four_mul (a : Nat) :
    T (4 * a) = 2 * a := by
  have h : 4 * a = 2 * (2 * a) := by omega
  calc
    T (4 * a) = T (2 * (2 * a)) := by rw [h]
    _ = 2 * a := two_branch_T_two_mul (2 * a)

theorem two_branch_T_two_steps_four_mul (a : Nat) :
    T^[2] (4 * a) = a := by
  calc
    T^[2] (4 * a) = T (T (4 * a)) := by rfl
    _ = T (2 * a) := by rw [two_branch_T_four_mul]
    _ = a := two_branch_T_two_mul a

theorem two_branch_retarded_path_to_child {a x : Nat}
    (h4 : 4 * a <= x) :
    PathWithin (4 * a) (2 * a) x 1 := by
  constructor
  · intro j hj
    cases j with
    | zero =>
        simpa using h4
    | succ j =>
        have hj0 : j = 0 := by omega
        have h2 : 2 * a <= 4 * a := by omega
        simpa [hj0, Function.iterate_one, two_branch_T_four_mul] using le_trans h2 h4
  · simp [Function.iterate_one, two_branch_T_four_mul]

theorem two_branch_child_path_to_root {a x : Nat}
    (h2 : 2 * a <= x) (hax : a <= x) :
    PathWithin (2 * a) a x 1 := by
  constructor
  · intro j hj
    cases j with
    | zero =>
        simpa using h2
    | succ j =>
        have hj0 : j = 0 := by omega
        simpa [hj0, Function.iterate_one, two_branch_T_two_mul] using hax
  · simp [Function.iterate_one, two_branch_T_two_mul]

theorem two_branch_advanced_path_to_root {a c x : Nat}
    (hc : T c = a) (hcx : c <= x) (hax : a <= x) :
    PathWithin c a x 1 := by
  constructor
  · intro j hj
    cases j with
    | zero =>
        simpa using hcx
    | succ j =>
        have hj0 : j = 0 := by omega
        simpa [hj0, Function.iterate_one, hc] using hax
  · simp [Function.iterate_one, hc]

theorem two_branch_retarded_reaches_child {a x xRet n : Nat}
    (hxRet : xRet <= x)
    (hmem : n ∈ piStarFinset (4 * a) xRet) :
    ReachesWithin (2 * a) x n := by
  have hm :=
    (mem_piStarFinset_reachesWithin_iff
      (a := 4 * a) (x := xRet) (n := n)).1 hmem
  have hroot : 4 * a <= xRet :=
    reachesWithin_root_le_window hm.2.2
  have h4x : 4 * a <= x := le_trans hroot hxRet
  exact reachesWithin_append_path hm.2.2 hxRet
    (two_branch_retarded_path_to_child (a := a) (x := x) h4x)

theorem two_branch_retarded_injection {a x xRet n : Nat}
    (hxRet : xRet <= x)
    (hmem : n ∈ piStarFinset (4 * a) xRet) :
    n ∈ piStarFinset a x := by
  have hm :=
    (mem_piStarFinset_reachesWithin_iff
      (a := 4 * a) (x := xRet) (n := n)).1 hmem
  have hroot : 4 * a <= xRet :=
    reachesWithin_root_le_window hm.2.2
  have h4x : 4 * a <= x := le_trans hroot hxRet
  have h2x : 2 * a <= x := by omega
  have hax : a <= x := by omega
  have hchild :
      ReachesWithin (2 * a) x n :=
    two_branch_retarded_reaches_child (a := a) (x := x)
      (xRet := xRet) (n := n) hxRet hmem
  have hreach :
      ReachesWithin a x n :=
    reachesWithin_append_path hchild le_rfl
      (two_branch_child_path_to_root (a := a) (x := x) h2x hax)
  rw [mem_piStarFinset_reachesWithin_iff]
  exact ⟨le_trans hm.1 hxRet, hm.2.1, hreach⟩

theorem two_branch_advanced_reaches_child {c x xAdv n : Nat}
    (hxAdv : xAdv <= x)
    (hmem : n ∈ piStarFinset c xAdv) :
    ReachesWithin c x n := by
  have hm :=
    (mem_piStarFinset_reachesWithin_iff
      (a := c) (x := xAdv) (n := n)).1 hmem
  exact reachesWithin_window_mono hm.2.2 hxAdv

theorem two_branch_advanced_injection {a c x xAdv n : Nat}
    (hc : T c = a)
    (hax : a <= x)
    (hxAdv : xAdv <= x)
    (hmem : n ∈ piStarFinset c xAdv) :
    n ∈ piStarFinset a x := by
  have hm :=
    (mem_piStarFinset_reachesWithin_iff
      (a := c) (x := xAdv) (n := n)).1 hmem
  have hcx : c <= x := le_trans (reachesWithin_root_le_window hm.2.2) hxAdv
  have hchild :
      ReachesWithin c x n :=
    two_branch_advanced_reaches_child (c := c) (x := x)
      (xAdv := xAdv) (n := n) hxAdv hmem
  have hreach :
      ReachesWithin a x n :=
    reachesWithin_append_path hchild le_rfl
      (two_branch_advanced_path_to_root (a := a) (c := c) (x := x) hc hcx hax)
  rw [mem_piStarFinset_reachesWithin_iff]
  exact ⟨le_trans hm.1 hxAdv, hm.2.1, hreach⟩

theorem not_reaches_inverse_child_from_root {a c x : Nat}
    (ha : NotInCycle a)
    (hc : T c = a)
    (hne : c ≠ a) :
    ¬ ReachesWithin c x a := by
  intro h
  rcases h with ⟨k, _hwin, hhit⟩
  by_cases hk0 : k = 0
  · have hac : a = c := by
      simpa [hk0] using hhit
    exact hne hac.symm
  · have hkpos : 0 < k := Nat.pos_of_ne_zero hk0
    have hcycle : T^[k + 1] a = a := by
      calc
        T^[k + 1] a = T (T^[k] a) := by
          exact Function.iterate_succ_apply' T k a
        _ = T c := by rw [hhit]
        _ = a := hc
    exact (ha (k + 1) (by omega)) hcycle

theorem root_not_mem_retarded_source {a xRet : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a) :
    a ∉ piStarFinset (4 * a) xRet := by
  intro hmem
  have hreach :
      ReachesWithin (4 * a) xRet a :=
    (mem_piStarFinset_reachesWithin_iff
      (a := 4 * a) (x := xRet) (n := a)).1 hmem |>.2.2
  rcases hreach with ⟨k, _hwin, hhit⟩
  by_cases hk0 : k = 0
  · have ha_eq : a = 4 * a := by
      simpa [hk0] using hhit
    omega
  · have hcycle : T^[k + 2] a = a := by
      calc
        T^[k + 2] a = T^[2 + k] a := by
          have hidx : k + 2 = 2 + k := by omega
          rw [hidx]
        _ = T^[2] (T^[k] a) := by
          exact Function.iterate_add_apply T 2 k a
        _ = T^[2] (4 * a) := by rw [hhit]
        _ = a := two_branch_T_two_steps_four_mul a
    exact (ha_cycle (k + 2) (by omega)) hcycle

theorem root_not_mem_advanced_source {a c xAdv : Nat}
    (ha_cycle : NotInCycle a)
    (hc_arith : 3 * c + 1 = 2 * a) :
    a ∉ piStarFinset c xAdv := by
  intro hmem
  have hreach :
      ReachesWithin c xAdv a :=
    (mem_piStarFinset_reachesWithin_iff
      (a := c) (x := xAdv) (n := a)).1 hmem |>.2.2
  exact not_reaches_inverse_child_from_root
    (a := a) (c := c) (x := xAdv) ha_cycle
    (two_branch_advanced_child_maps_to_root hc_arith)
    (two_branch_advanced_child_ne_root hc_arith)
    hreach

theorem two_branch_source_members_disjoint {a c x xRet xAdv n : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a)
    (hc : T c = a)
    (hchildren : 2 * a ≠ c)
    (hax : a <= x)
    (hxRet : xRet <= x)
    (hxAdv : xAdv <= x)
    (hret : n ∈ piStarFinset (4 * a) xRet)
    (hadv : n ∈ piStarFinset c xAdv) :
    False := by
  have hret_child :
      ReachesWithin (2 * a) x n :=
    two_branch_retarded_reaches_child (a := a) (x := x)
      (xRet := xRet) (n := n) hxRet hret
  have hadv_child :
      ReachesWithin c x n :=
    two_branch_advanced_reaches_child (c := c) (x := x)
      (xAdv := xAdv) (n := n) hxAdv hadv
  have htarget :
      ReachesWithin a x n :=
    (mem_piStarFinset_reachesWithin_iff
      (a := a) (x := x) (n := n)).1
        (two_branch_retarded_injection (a := a) (x := x)
          (xRet := xRet) (n := n) hxRet hret) |>.2.2
  rcases exists_firstHitsAt_of_reachesWithin htarget with
    ⟨k0, _hk0x, hfirst, _hwin⟩
  have hk0 : 0 < k0 := by
    by_contra hnot
    have hk0eq : k0 = 0 := by omega
    have hn_eq_a : n = a := by
      simpa [FirstHitsAt, hk0eq] using hfirst.1
    have hroot_mem :
        a ∈ piStarFinset (4 * a) xRet := by
      simpa [hn_eq_a] using hret
    exact root_not_mem_retarded_source
      (a := a) (xRet := xRet) ha_pos ha_cycle hroot_mem
  exact
    inverse_children_disjoint_descendants
      (a := a) (c1 := 2 * a) (c2 := c) (x := x) (n := n) (k0 := k0)
      ha_cycle hchildren (two_branch_T_two_mul a) hc
      hret_child hadv_child hax hfirst hk0

theorem two_branch_sources_disjoint_in_target {a c x xRet xAdv : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a)
    (hc : T c = a)
    (hchildren : 2 * a ≠ c)
    (hax : a <= x)
    (hxRet : xRet <= x)
    (hxAdv : xAdv <= x) :
    Disjoint (piStarFinset (4 * a) xRet) (piStarFinset c xAdv) := by
  rw [Finset.disjoint_left]
  intro n hret hadv
  exact two_branch_source_members_disjoint
    (a := a) (c := c) (x := x) (xRet := xRet) (xAdv := xAdv) (n := n)
    ha_pos ha_cycle hc hchildren hax hxRet hxAdv hret hadv

theorem two_branch_card_bound {a c x xRet xAdv : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a)
    (hc_arith : 3 * c + 1 = 2 * a)
    (hax : a <= x)
    (hxRet : xRet <= x)
    (hxAdv : xAdv <= x) :
    (piStarFinset (4 * a) xRet).card + (piStarFinset c xAdv).card
      <= (piStarFinset a x).card := by
  have hc : T c = a :=
    two_branch_advanced_child_maps_to_root hc_arith
  have hchildren : 2 * a ≠ c :=
    two_branch_children_distinct ha_pos hc_arith
  have hret_subset :
      piStarFinset (4 * a) xRet ⊆ piStarFinset a x := by
    intro n hn
    exact two_branch_retarded_injection (a := a) (x := x)
      (xRet := xRet) (n := n) hxRet hn
  have hadv_subset :
      piStarFinset c xAdv ⊆ piStarFinset a x := by
    intro n hn
    exact two_branch_advanced_injection (a := a) (c := c) (x := x)
      (xAdv := xAdv) (n := n) hc hax hxAdv hn
  have hdisj :
      Disjoint (piStarFinset (4 * a) xRet) (piStarFinset c xAdv) :=
    two_branch_sources_disjoint_in_target
      (a := a) (c := c) (x := x) (xRet := xRet) (xAdv := xAdv)
      ha_pos ha_cycle hc hchildren hax hxRet hxAdv
  have hunion_subset :
      piStarFinset (4 * a) xRet ∪ piStarFinset c xAdv ⊆ piStarFinset a x :=
    Finset.union_subset hret_subset hadv_subset
  have hcard_union :
      (piStarFinset (4 * a) xRet ∪ piStarFinset c xAdv).card
        = (piStarFinset (4 * a) xRet).card + (piStarFinset c xAdv).card :=
    Finset.card_union_of_disjoint hdisj
  have hcard_le :
      (piStarFinset (4 * a) xRet ∪ piStarFinset c xAdv).card
        <= (piStarFinset a x).card :=
    Finset.card_le_card hunion_subset
  simpa [hcard_union] using hcard_le

end KL2003
end CollatzClassical
