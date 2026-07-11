import CollatzClassical.KL2003.KL2003M0APiStarSemantics

namespace CollatzClassical
namespace KL2003

/-!
Minimal root-count bridge for the KL2003 base segment.

This module stays at the `Nat`/`piStar` layer.  It does not define `Phi`, does
not choose a real-to-natural window policy, and does not use M0C, EL rows, the
scaling seam ledger, or any M1 statement.
-/

theorem root_mem_piStarFinset_of_root_in_window {a x : Nat}
    (ha : 1 <= a) (hax : a <= x) :
    a ∈ piStarFinset a x := by
  exact a_mem_piStarFinset_self_window ha hax

theorem root_count_unit_lower_bound_for_window {a x : Nat}
    (ha : 1 <= a) (hax : a <= x) :
    1 <= piStar a x := by
  exact one_le_piStar_of_one_le_a_le_x ha hax

end KL2003
end CollatzClassical
