import CollatzClassical.KL2003.KL2003GeneralKSourceTransitionGraph
import Mathlib.Data.Real.Irrational

namespace CollatzClassical
namespace KL2003

/-!
Irrationality and zero-weight exclusion for general-`k` source walks.

The proof of `alpha_irrational` is elementary. If `alpha = logb 2 3`
were rational, then `2 ^ alpha = 3` would yield an equality between a
positive natural power of two and a natural power of three. The former is
even and the latter odd.

This module does not prove that recurrent source walks are nonpositive. It
only proves that a nonempty source walk cannot have evaluated weight zero;
the contextual nonpositivity input remains the responsibility of the future
finite-cycle descent module.
-/

theorem alpha_irrational : Irrational alpha := by
  intro hrat
  obtain ⟨q, hq⟩ := hrat
  have hq_pos_real : (0 : Real) < (q : Real) := by
    rw [hq]
    linarith [alpha_lower_bound]
  have hq_pos : 0 < q := by
    exact_mod_cast hq_pos_real
  have hnum_pos : 0 < q.num := Rat.num_pos.mpr hq_pos
  have hden_pos : 0 < q.den := q.den_pos
  have hden_ne_real : (q.den : Real) ≠ 0 := by
    positivity
  have hq_cast : (q : Real) =
      (q.num.natAbs : Real) / (q.den : Real) := by
    calc
      (q : Real) = (q.num : Real) / (q.den : Real) := Rat.cast_def q
      _ = (q.num.natAbs : Real) / (q.den : Real) := by
        congr 1
        symm
        rw [Int.cast_natAbs, abs_of_nonneg]
        exact_mod_cast hnum_pos.le
  have hpow : (2 : Real) ^
      ((q.num.natAbs : Real) / (q.den : Real)) = 3 := by
    rw [← hq_cast, hq, source_two_rpow_alpha]
  have hpowers_real :
      ((2 : Real) ^ q.num.natAbs) = ((3 : Real) ^ q.den) := by
    calc
      (2 : Real) ^ q.num.natAbs =
          (2 : Real) ^ (q.num.natAbs : Real) := by
            rw [Real.rpow_natCast]
      _ = (2 : Real) ^
          (((q.num.natAbs : Real) / (q.den : Real)) *
            (q.den : Real)) := by
            rw [div_mul_cancel₀ _ hden_ne_real]
      _ = ((2 : Real) ^
          ((q.num.natAbs : Real) / (q.den : Real))) ^
            (q.den : Real) := by
            rw [Real.rpow_mul (by norm_num : (0 : Real) ≤ 2)]
      _ = (3 : Real) ^ (q.den : Real) := by rw [hpow]
      _ = (3 : Real) ^ q.den := by rw [Real.rpow_natCast]
  have hpowers_nat : 2 ^ q.num.natAbs = 3 ^ q.den := by
    exact_mod_cast hpowers_real
  have hnum_natAbs_pos : 0 < q.num.natAbs := by
    exact Int.natAbs_pos.mpr hnum_pos.ne'
  have heven : Even (2 ^ q.num.natAbs) :=
    Nat.even_pow.mpr ⟨even_two, hnum_natAbs_pos.ne'⟩
  have hodd : Odd (3 ^ q.den) :=
    (show Odd 3 by exact ⟨1, rfl⟩).pow
  rw [hpowers_nat] at heven
  obtain ⟨u, hu⟩ := heven
  obtain ⟨v, hv⟩ := hodd
  omega

namespace SymbolicShift

theorem eval_irrational_of_alphaCoeff_ne_zero (shift : SymbolicShift)
    (hcoeff : shift.alphaCoeff ≠ 0) : Irrational shift.eval := by
  have hmul : Irrational ((shift.alphaCoeff : Real) * alpha) :=
    alpha_irrational.intCast_mul hcoeff
  simpa [eval] using hmul.add_intCast shift.constCoeff

theorem eval_ne_zero_of_constCoeff_neg (shift : SymbolicShift)
    (hconst : shift.constCoeff < 0) : shift.eval ≠ 0 := by
  by_cases hcoeff : shift.alphaCoeff = 0
  · have hconst_real : (shift.constCoeff : Real) < 0 := by
      exact_mod_cast hconst
    simpa [eval, hcoeff] using hconst_real.ne
  · exact (shift.eval_irrational_of_alphaCoeff_ne_zero hcoeff).ne_zero

end SymbolicShift

namespace GeneralKSourceGraph.SourceWalk

theorem weight_eval_ne_zero_of_length_pos {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) (hlength : 0 < walk.length) :
    walk.weight.eval ≠ 0 := by
  exact walk.weight.eval_ne_zero_of_constCoeff_neg
    (walk.weight_constCoeff_neg_of_length_pos hlength)

theorem weight_eval_neg_of_length_pos_of_nonpos {p : Nat} {hp : 1 <= p}
    {source target : TrackedMode (p + 1)}
    (walk : SourceWalk hp source target) (hlength : 0 < walk.length)
    (hnonpos : walk.weight.eval <= 0) : walk.weight.eval < 0 := by
  exact lt_of_le_of_ne hnonpos (walk.weight_eval_ne_zero_of_length_pos hlength)

end GeneralKSourceGraph.SourceWalk

end KL2003
end CollatzClassical
