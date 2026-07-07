import CollatzClassical.KL2003.KL2003M0BTwoBranchCore

/-!
# KL2003 M0B D1/D2/D3 core instantiations

This module packages the class-free two-branch core as Nat/combinatorial
corollaries for the D1/D2/D3 row shapes.  It does not contain the later
analytic/window layer, rounding ledger, LP slack, induction theorem, or global
Collatz claim.

The D1 and D3 corollaries use the immediate advanced child `c` satisfying
`3 * c + 1 = 2 * a`.  Any row-specific choice of a deeper advanced source is
left to the later window/ledger layer.
-/

namespace CollatzClassical
namespace KL2003

theorem piStarFinset_card_zero (a : Nat) :
    (piStarFinset a 0).card = 0 := by
  simpa [piStar] using piStar_zero_x a

theorem d1_core_instantiation {a c x xRet xAdv : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a)
    (hc_arith : 3 * c + 1 = 2 * a)
    (hax : a <= x)
    (hxRet : xRet <= x)
    (hxAdv : xAdv <= x) :
    (piStarFinset (4 * a) xRet).card + (piStarFinset c xAdv).card
      <= (piStarFinset a x).card := by
  exact two_branch_card_bound ha_pos ha_cycle hc_arith hax hxRet hxAdv

theorem d3_core_instantiation {a c x xRet xAdv : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a)
    (hc_arith : 3 * c + 1 = 2 * a)
    (hax : a <= x)
    (hxRet : xRet <= x)
    (hxAdv : xAdv <= x) :
    (piStarFinset (4 * a) xRet).card + (piStarFinset c xAdv).card
      <= (piStarFinset a x).card := by
  exact two_branch_card_bound ha_pos ha_cycle hc_arith hax hxRet hxAdv

theorem d2_single_branch_core_instantiation {a c x xRet : Nat}
    (ha_pos : 1 <= a)
    (ha_cycle : NotInCycle a)
    (hc_arith : 3 * c + 1 = 2 * a)
    (hax : a <= x)
    (hxRet : xRet <= x) :
    (piStarFinset (4 * a) xRet).card <= (piStarFinset a x).card := by
  have hcore :
      (piStarFinset (4 * a) xRet).card + (piStarFinset c 0).card
        <= (piStarFinset a x).card :=
    two_branch_card_bound (a := a) (c := c) (x := x)
      (xRet := xRet) (xAdv := 0)
      ha_pos ha_cycle hc_arith hax hxRet (Nat.zero_le x)
  have hz : (piStarFinset c 0).card = 0 :=
    piStarFinset_card_zero c
  simpa [hz] using hcore

theorem d3_advanced_residue_mod_9_of_t_mod_0 {t c : Nat}
    (hc : c = 6 * t + 5)
    (ht : t % 3 = 0) :
    c % 9 = 5 := by
  have ht_decomp : t = 3 * (t / 3) := by
    have h := Nat.div_add_mod t 3
    omega
  rw [hc, ht_decomp]
  have hExpr : 6 * (3 * (t / 3)) + 5 = 9 * (2 * (t / 3)) + 5 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem d3_advanced_residue_mod_9_of_t_mod_1 {t c : Nat}
    (hc : c = 6 * t + 5)
    (ht : t % 3 = 1) :
    c % 9 = 2 := by
  have ht_decomp : t = 3 * (t / 3) + 1 := by
    have h := Nat.div_add_mod t 3
    omega
  rw [hc, ht_decomp]
  have hExpr : 6 * (3 * (t / 3) + 1) + 5 = 9 * (2 * (t / 3) + 1) + 2 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem d3_advanced_residue_mod_9_of_t_mod_2 {t c : Nat}
    (hc : c = 6 * t + 5)
    (ht : t % 3 = 2) :
    c % 9 = 8 := by
  have ht_decomp : t = 3 * (t / 3) + 2 := by
    have h := Nat.div_add_mod t 3
    omega
  rw [hc, ht_decomp]
  have hExpr : 6 * (3 * (t / 3) + 2) + 5 = 9 * (2 * (t / 3) + 1) + 8 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem d2_advanced_branch_residue_mod_three {t c : Nat}
    (hc : c = 6 * t + 3) :
    c % 3 = 0 := by
  rw [hc]
  have hExpr : 6 * t + 3 = 3 * (2 * t + 1) := by
    omega
  rw [hExpr]
  exact Nat.mod_eq_zero_of_dvd ⟨2 * t + 1, rfl⟩

theorem retarded_residue_mod_9_of_root_mod_2 {t a : Nat}
    (ha : a = 9 * t + 2) :
    (4 * a) % 9 = 8 := by
  rw [ha]
  have hExpr : 4 * (9 * t + 2) = 9 * (4 * t) + 8 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem retarded_residue_mod_9_of_root_mod_5 {t a : Nat}
    (ha : a = 9 * t + 5) :
    (4 * a) % 9 = 2 := by
  rw [ha]
  have hExpr : 4 * (9 * t + 5) = 9 * (4 * t + 2) + 2 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

theorem retarded_residue_mod_9_of_root_mod_8 {t a : Nat}
    (ha : a = 9 * t + 8) :
    (4 * a) % 9 = 5 := by
  rw [ha]
  have hExpr : 4 * (9 * t + 8) = 9 * (4 * t + 3) + 5 := by
    omega
  rw [hExpr]
  simp [Nat.add_mod, Nat.mul_mod]

end KL2003
end CollatzClassical
