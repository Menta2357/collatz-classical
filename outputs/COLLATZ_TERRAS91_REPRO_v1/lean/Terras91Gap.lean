import Terras90UniformGap
import Terras91ClockSieve

namespace Terras91Gap

open TerrasClock
open Terras88 (verifiedHeight)
open Terras90RankAssembly (sortedHeights)
open Terras90Lattice (logScale lowGap highGap)
open Terras90Physical (gap reciprocal sortedLower gapPositive LogBrackets scaledBrackets)
open Terras91Lattice (globalGap)

private theorem reciprocalLe (xs : List Nat) {N : Nat} (pos : 0<N)
    (h : ∀ x∈xs, N≤x) : reciprocal xs≤(xs.length:ℝ)/N := by
  induction xs with
  | nil => simp [reciprocal]
  | cons x rest ih =>
    have hN : 0<(N:ℝ) := by exact_mod_cast pos
    have ratio : (1:ℝ)/x ≤ 1/N := by
      apply one_div_le_one_div_of_le hN
      exact_mod_cast h x List.mem_cons_self
    have tail := ih (fun y hy => h y (List.mem_cons_of_mem _ hy))
    change 1/(x:ℝ)+reciprocal rest≤((rest.length+1:Nat):ℝ)/N
    rw [Nat.cast_add,Nat.cast_one,add_div]
    linarith only [ratio,tail]

/-- At most 90 factors remain after the source factor is cancelled.
Their heights and multiplicities come from the original prefix. -/
theorem gapTimesSeed {N k : Nat} (pos : 0<N) (first : FirstContraction N k)
    (many : 2≤oddRuns N k) (runs : oddRuns N k≤91) (shift : N+1≤orbit N k) :
    (N:ℝ)*gap k (oddCount N k)<90 := by
  let ys := (sortedHeights N k).drop 1
  have h := Terras90UniformGap.discountedGap pos first many shift
  have sum := reciprocalLe ys pos fun x hx => sortedLower first x (List.mem_of_mem_drop hx)
  have yn : ys.length≤90 := by simp only [ys,List.length_drop,Terras90UniformGap.sortedLengthEq]; omega
  have nPos : 0<(N:ℝ) := by exact_mod_cast pos
  have ynReal : (ys.length:ℝ)≤90 := by exact_mod_cast yn
  have gapBound := h.trans_le (sum.trans (div_le_div_of_nonneg_right ynReal nPos.le))
  exact (lt_div_iff₀' nPos).1 gapBound

theorem gapStrip {N k : Nat} (bounds : LogBrackets) (base : verifiedHeight<N)
    (first : FirstContraction N k) (many : 2≤oddRuns N k) (runs : oddRuns N k≤91)
    (shift : N+1≤orbit N k) :
    lowGap k (oddCount N k)<globalGap ∧ 0<highGap k (oddCount N k) := by
  have pos : 0<N := Nat.lt_of_le_of_lt (Nat.zero_le _) base
  have pg := gapPositive first
  have g := gapTimesSeed pos first many runs shift
  have bracket := scaledBrackets bounds k (oddCount N k)
  have Bpos : 0<(verifiedHeight:ℝ) := by norm_num [verifiedHeight]
  have Mpos : 0<(logScale:ℝ) := by norm_num [logScale]
  have small : gap k (oddCount N k)<91/(verifiedHeight:ℝ) := by
    apply (lt_div_iff₀' Bpos).2
    have leN : (verifiedHeight:ℝ)≤N := by exact_mod_cast base.le
    have le := mul_le_mul_of_nonneg_right leN pg.le
    linarith
  have capNat : 91*logScale≤globalGap*verifiedHeight := by decide
  have cap : 91*(logScale:ℝ)≤(globalGap:ℝ)*verifiedHeight := by exact_mod_cast capNat
  have middle : (logScale:ℝ)*(91/(verifiedHeight:ℝ))≤globalGap := by
    rw [←mul_div_assoc]
    apply (div_le_iff₀ Bpos).2
    simpa only [mul_comm (logScale:ℝ) 91] using cap
  constructor
  · have h := bracket.1.trans_lt ((mul_lt_mul_of_pos_left small Mpos).trans_le middle)
    exact_mod_cast h
  · have h := (mul_pos Mpos pg).trans_le bracket.2
    exact_mod_cast h


end Terras91Gap

#print axioms Terras91Gap.gapTimesSeed
#print axioms Terras91Gap.gapStrip
