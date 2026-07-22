import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
F3 M0-b pilot: the isolated rational telescoping identity used by the
combined-ledger route.  This is deliberately not the Chernoff/renewal
conversion and makes no claim about rho, density, or Collatz.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3ReturnExcursionM0B

def epsilon : ℚ := 2 / 243

def q : ℚ := (24100 : ℚ) / 24543

def etaRow : ℚ := epsilon / (1 - q)

theorem q_is_declared_ratio : q = (24100 : ℚ) / 24543 := by
  rfl

theorem epsilon_is_declared_ratio : epsilon = (2 : ℚ) / 243 := by
  rfl

theorem eta_row_exact : etaRow = (202 : ℚ) / 443 := by
  norm_num [etaRow, epsilon, q]

theorem geometric_telescoping (r : ℚ) (n : Nat) :
    (1 - r) * (∑ k ∈ Finset.range n, r ^ k) = 1 - r ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ, pow_succ]
      calc
        (1 - r) * (∑ x ∈ Finset.range n, r ^ x + r ^ n) =
            (1 - r) * (∑ x ∈ Finset.range n, r ^ x) +
              (1 - r) * r ^ n := by ring
        _ = (1 - r ^ n) + (1 - r) * r ^ n := by rw [ih]
        _ = 1 - r ^ n * r := by ring

end F3ReturnExcursionM0B
end KL2003
end CollatzClassical
