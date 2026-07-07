import CollatzClassical.KL2003.KL2003M0BReachabilityAPI

/-!
# KL2003 M0B entry-predecessor disjointness

This module isolates the structural hinge needed before D1/D2/D3.  The useful
partition is not "the orbit reaches an inverse child of `a`" in isolation, but
"the first entrance into `a` has this immediate predecessor".

The imported `NotInCycle a` hypothesis is essential.  Without it, the naive
disjointness statement is false: conceptually, at the positive cycle `1 <-> 2`,
an orbit can pass through the root and later touch another inverse branch.
-/

namespace CollatzClassical
namespace KL2003

def FirstHitsAt (a n k : Nat) : Prop :=
  T^[k] n = a ∧ ∀ j, j < k -> T^[j] n ≠ a

theorem firstHitsAt_of_natFind {a n : Nat}
    (h : ∃ k, T^[k] n = a) :
    FirstHitsAt a n (Nat.find h) := by
  exact ⟨Nat.find_spec h, fun j hj => Nat.find_min h hj⟩

theorem exists_firstHitsAt_of_reachesWithin {a x n : Nat}
    (h : ReachesWithin a x n) :
    ∃ k,
      k <= x ∧
      FirstHitsAt a n k ∧
      ∀ j, j <= k -> T^[j] n <= x := by
  rcases h with ⟨k, hwin, hhit⟩
  let hp : ∃ m, T^[m] n = a := ⟨k, hhit⟩
  let k0 := Nat.find hp
  have hk0le_k : k0 <= k := by
    dsimp [k0]
    exact Nat.find_min' hp hhit
  rcases reachesWithin_has_bounded_min_hit
      (a := a) (x := x) (n := n) ⟨k, hwin, hhit⟩ with
    ⟨kb, hkb_x, hkb_hit, _hkb_win⟩
  have hk0le_b : k0 <= kb := by
    dsimp [k0]
    exact Nat.find_min' hp hkb_hit
  have hwin0 : ∀ j, j <= k0 -> T^[j] n <= x := by
    intro j hj
    exact hwin j (le_trans hj hk0le_k)
  exact
    ⟨k0, le_trans hk0le_b hkb_x, firstHitsAt_of_natFind hp, hwin0⟩

theorem T_ne_self {n : Nat} (hn : 1 <= n) :
    T n ≠ n := by
  by_cases hmod : n % 2 = 0
  · have hlt : n / 2 < n :=
      Nat.div_lt_self (by omega : 0 < n) (by norm_num : 1 < 2)
    have hTlt : T n < n := by
      simpa [T, hmod] using hlt
    exact ne_of_lt hTlt
  · have hgt : n < (3 * n + 1) / 2 := by
      rw [Nat.lt_iff_add_one_le]
      rw [Nat.le_div_iff_mul_le (by norm_num : 0 < 2)]
      omega
    have hTgt : n < T n := by
      simpa [T, hmod] using hgt
    exact ne_of_gt hTgt

theorem inverseChild_ne_root_of_one_le {a c : Nat}
    (hc : InverseChild a c) (hcpos : 1 <= c) :
    c ≠ a := by
  intro hca
  have hfixed : T c = c := by
    simpa [hca] using hc
  exact T_ne_self hcpos hfixed

theorem entry_predecessor_maps_to_root {a n k : Nat}
    (h : FirstHitsAt a n k) (_hn : n ≠ a) (hk : 0 < k) :
    T (T^[k - 1] n) = a := by
  calc
    T (T^[k - 1] n) = T^[(k - 1).succ] n := by
      exact (Function.iterate_succ_apply' T (k - 1) n).symm
    _ = T^[k] n := by
      have hidx : (k - 1).succ = k := by omega
      rw [hidx]
    _ = a := h.1

theorem entry_predecessor_is_inverse_child {a n k : Nat}
    (h : FirstHitsAt a n k) (hn : n ≠ a) (hk : 0 < k) :
    InverseChild a (T^[k - 1] n) := by
  exact entry_predecessor_maps_to_root h hn hk

theorem iterate_from_later_hit {n c1 c2 k1 k2 : Nat}
    (h1 : T^[k1] n = c1)
    (h2 : T^[k2] n = c2)
    (hk : k1 <= k2) :
    T^[k2 - k1] c1 = c2 := by
  calc
    T^[k2 - k1] c1 = T^[k2 - k1] (T^[k1] n) := by
      rw [h1]
    _ = T^[(k2 - k1) + k1] n := by
      exact (Function.iterate_add_apply T (k2 - k1) k1 n).symm
    _ = T^[k2] n := by
      have hidx : (k2 - k1) + k1 = k2 := by omega
      rw [hidx]
    _ = c2 := h2

theorem entry_pred_eq_of_reaches_child {a c x n k0 : Nat}
    (ha : NotInCycle a)
    (hc : T c = a)
    (hrc : ReachesWithin c x n)
    (_hax : a <= x)
    (hfirst : FirstHitsAt a n k0)
    (_hk0 : 0 < k0) :
    T^[k0 - 1] n = c := by
  rcases hrc with ⟨kc, _hwin_c, hhit_c⟩
  have hroot_later : T^[kc + 1] n = a := by
    calc
      T^[kc + 1] n = T (T^[kc] n) := by
        exact Function.iterate_succ_apply' T kc n
      _ = T c := by rw [hhit_c]
      _ = a := hc
  have hk0_le : k0 <= kc + 1 := by
    by_contra hnot
    have hlt : kc + 1 < k0 := Nat.lt_of_not_ge hnot
    exact hfirst.2 (kc + 1) hlt hroot_later
  have hk0_eq : k0 = kc + 1 := by
    by_contra hne
    have hlt : k0 < kc + 1 := by omega
    have hcycle : T^[(kc + 1) - k0] a = a :=
      iterate_from_later_hit hfirst.1 hroot_later (by omega)
    have hp : 0 < (kc + 1) - k0 := by omega
    exact (ha ((kc + 1) - k0) hp) hcycle
  calc
    T^[k0 - 1] n = T^[kc] n := by
      have hidx : k0 - 1 = kc := by omega
      rw [hidx]
    _ = c := hhit_c

theorem inverse_children_disjoint_descendants {a c1 c2 x n k0 : Nat}
    (ha : NotInCycle a)
    (hne : c1 ≠ c2)
    (hc1 : T c1 = a)
    (hc2 : T c2 = a)
    (h1 : ReachesWithin c1 x n)
    (h2 : ReachesWithin c2 x n)
    (hax : a <= x)
    (hfirst : FirstHitsAt a n k0)
    (hk0 : 0 < k0) :
    False := by
  have hp1 :
      T^[k0 - 1] n = c1 :=
    entry_pred_eq_of_reaches_child ha hc1 h1 hax hfirst hk0
  have hp2 :
      T^[k0 - 1] n = c2 :=
    entry_pred_eq_of_reaches_child ha hc2 h2 hax hfirst hk0
  exact hne (hp1.symm.trans hp2)

end KL2003
end CollatzClassical
