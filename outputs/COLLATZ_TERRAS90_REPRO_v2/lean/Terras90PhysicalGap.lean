import TerrasDisplacement
import Terras90Lattice
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.NormNum

namespace Terras90Physical

noncomputable section

open TerrasClock
open Terras88 (verifiedHeight valleyTimes)
open Terras90Q0Price (product shiftedProduct chronologicalHeights)
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered)
open Terras90Lattice

set_option maxRecDepth 12000
set_option maxHeartbeats 1400000
set_option exponentiation.threshold 512

noncomputable def gap (k d : Nat) : ℝ := k*Real.log 2-d*Real.log 3
noncomputable def reciprocal (xs : List Nat) : ℝ := (xs.map (fun x : Nat => (1:ℝ)/(x:ℝ))).sum

/-- Independent rounding inputs for the analytic logarithms, in the units
of the integer sieve. The lattice receipt computes these intervals. -/
def LogBrackets : Prop :=
  (log2Low:ℝ) ≤ (logScale:ℝ)*Real.log 2 ∧
    (logScale:ℝ)*Real.log 2 ≤ (log2High:ℝ) ∧
    (log3Low:ℝ) ≤ (logScale:ℝ)*Real.log 3 ∧
    (logScale:ℝ)*Real.log 3 ≤ (log3High:ℝ)

theorem gapPositive {N k : Nat} (first : FirstContraction N k) :
    0<gap k (oddCount N k) := by
  have coeff : (3:ℝ)^oddCount N k < (2:ℝ)^k := by exact_mod_cast first.1
  have logs := Real.log_lt_log (by positivity : 0<(3:ℝ)^oddCount N k) coeff
  rw [Real.log_pow,Real.log_pow] at logs
  exact sub_pos.mpr logs

theorem sortedLength {N k : Nat} (runs : oddRuns N k=90) :
    (sortedHeights N k).length=90 := by
  rw [(sortedHeights_perm N k).length_eq,Terras90RankAssembly.valleyHeights,
    List.length_map,Terras88.valleyTimes_length,runs]

theorem sortedLower {N k : Nat} (first : FirstContraction N k) :
    ∀ x ∈ sortedHeights N k, N≤x := by
  intro x mem
  exact Terras90Q0Price.chronological_lower first x ((sortedHeights_perm N k).mem_iff.mp mem)

private def shiftedLogs (xs : List Nat) : ℝ :=
  (xs.map (fun x : Nat => Real.log ((x:ℝ)+1)-Real.log (x:ℝ))).sum

private theorem productPositive (xs : List Nat) (h : ∀ x∈xs, 0<x) :
    0<product xs := by
  induction xs with
  | nil => decide
  | cons x rest ih =>
    exact Nat.mul_pos (h x List.mem_cons_self)
      (ih fun y hy => h y (List.mem_cons_of_mem _ hy))

private theorem shiftedPositive (xs : List Nat) : 0<shiftedProduct xs := by
  apply productPositive
  intro x mem
  obtain ⟨y,_,rfl⟩ := List.mem_map.mp mem
  omega

private theorem logProductDifference (xs : List Nat) (h : ∀ x∈xs, 0<x) :
    Real.log (shiftedProduct xs:ℝ)-Real.log (product xs:ℝ)=shiftedLogs xs := by
  induction xs with
  | nil => simp [shiftedProduct,product,shiftedLogs]
  | cons x rest ih =>
    have positive : ∀ y∈rest, 0<y := fun y hy => h y (List.mem_cons_of_mem _ hy)
    have posX : 0<(x:ℝ) := by exact_mod_cast h x List.mem_cons_self
    have posP : 0<(product rest:ℝ) := by exact_mod_cast productPositive rest positive
    have posS : 0<(shiftedProduct rest:ℝ) := by exact_mod_cast shiftedPositive rest
    change Real.log (((x+1)*shiftedProduct rest:Nat):ℝ)-
        Real.log ((x*product rest:Nat):ℝ)=_
    push_cast
    rw [Real.log_mul (by positivity) posS.ne',Real.log_mul posX.ne' posP.ne']
    have tail := ih positive
    simp only [shiftedLogs,List.map_cons,List.sum_cons] at tail ⊢
    linarith only [tail]

private theorem logFactorLt {x : Nat} (pos : 0<x) :
    Real.log ((x:ℝ)+1)-Real.log x < (1:ℝ)/x := by
  have hx : 0<(x:ℝ) := by exact_mod_cast pos
  rw [← Real.log_div (by positivity) hx.ne']
  have zpos : 0<((x:ℝ)+1)/x := by positivity
  have zne : ((x:ℝ)+1)/x≠1 := by
    intro equality
    have h := (div_eq_iff hx.ne').mp equality
    linarith
  have strict := Real.log_lt_sub_one_of_pos zpos zne
  have eq : ((x:ℝ)+1)/x-1=1/x := by field_simp
  simpa only [eq] using strict

private theorem sumLogLt (xs : List Nat) (nonempty : xs≠[])
    (h : ∀ x∈xs, 0<x) : shiftedLogs xs<reciprocal xs := by
  induction xs with
  | nil => exact (nonempty rfl).elim
  | cons x rest ih =>
    have hx := logFactorLt (h x List.mem_cons_self)
    have tail : shiftedLogs rest≤reciprocal rest := by
      by_cases empty : rest=[]
      · simp [empty,shiftedLogs,reciprocal]
      · exact (ih empty fun y hy => h y (List.mem_cons_of_mem _ hy)).le
    exact add_lt_add_of_lt_of_le hx tail

theorem discountedGap {N k : Nat} (pos : 0<N) (first : FirstContraction N k)
    (runs : oddRuns N k=90) (shift : N+1≤orbit N k) :
    gap k (oddCount N k)<reciprocal ((sortedHeights N k).drop 1) := by
  let ys := (sortedHeights N k).drop 1
  have yn : ys.length=89 := by simp [ys,sortedLength runs]
  have ye : ys≠[] := by intro h; rw [h] at yn; simp at yn
  have positive : ∀ x∈ys, 0<x := fun x hx =>
    Nat.lt_of_lt_of_le pos (sortedLower first x (List.mem_of_mem_drop hx))
  have budget := TerrasDisplacement.singleDiscount pos first shift (sortedHeights_ordered N k)
    (sortedHeights_perm N k)
  have cast : (2:ℝ)^k*(product ys:ℝ)≤(3:ℝ)^oddCount N k*(shiftedProduct ys:ℝ) := by
    exact_mod_cast budget
  have posP : 0<(product ys:ℝ) := by exact_mod_cast productPositive ys positive
  have posS : 0<(shiftedProduct ys:ℝ) := by exact_mod_cast shiftedPositive ys
  have logs := (Real.log_le_log_iff (by positivity) (by positivity)).2 cast
  rw [Real.log_mul (by positivity) posP.ne',Real.log_mul (by positivity) posS.ne',
    Real.log_pow,Real.log_pow] at logs
  have diff := logProductDifference ys positive
  have bound : gap k (oddCount N k) ≤ shiftedLogs ys := by unfold gap; linarith
  exact bound.trans_lt (sumLogLt ys ye positive)

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

/-- On a nondecreasing positive-displacement first crossing, 89 physical
valley factors suffice. This bound needs no analytic source correction. -/
theorem gapTimesSeed {N k : Nat} (pos : 0<N) (first : FirstContraction N k)
    (runs : oddRuns N k=90) (shift : N+1≤orbit N k) :
    (N:ℝ)*gap k (oddCount N k)<89 := by
  let ys := (sortedHeights N k).drop 1
  have h := discountedGap pos first runs shift
  have sum := reciprocalLe ys pos fun x hx => sortedLower first x (List.mem_of_mem_drop hx)
  have yn : ys.length=89 := by simp [ys,sortedLength runs]
  rw [yn] at sum
  have gapBound := h.trans_le sum
  have nPos : 0<(N:ℝ) := by exact_mod_cast pos
  exact (lt_div_iff₀' nPos).1 gapBound

theorem scaledBrackets (bounds : LogBrackets) (k d : Nat) :
    (lowGap k d:ℝ)≤(logScale:ℝ)*gap k d ∧
      (logScale:ℝ)*gap k d≤(highGap k d:ℝ) := by
  obtain ⟨lo2,hi2,lo3,hi3⟩ := bounds
  constructor
  · have a := mul_le_mul_of_nonneg_left lo2 (Nat.cast_nonneg k : 0≤(k:ℝ))
    have b := mul_le_mul_of_nonneg_left hi3 (Nat.cast_nonneg d : 0≤(d:ℝ))
    unfold lowGap gap
    push_cast
    nlinarith only [a,b]
  · have a := mul_le_mul_of_nonneg_left hi2 (Nat.cast_nonneg k : 0≤(k:ℝ))
    have b := mul_le_mul_of_nonneg_left lo3 (Nat.cast_nonneg d : 0≤(d:ℝ))
    unfold highGap gap
    push_cast
    nlinarith only [a,b]

theorem gapStrip {N k : Nat} (bounds : LogBrackets) (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=90) (shift : N+1≤orbit N k) :
    lowGap k (oddCount N k)<globalGap ∧ 0<highGap k (oddCount N k) := by
  have pos : 0<N := Nat.lt_of_le_of_lt (Nat.zero_le _) base
  have pg := gapPositive first
  have g := gapTimesSeed pos first runs shift
  have bracket := scaledBrackets bounds k (oddCount N k)
  have Bpos : 0<(verifiedHeight:ℝ) := by norm_num [verifiedHeight]
  have Mpos : 0<(logScale:ℝ) := by norm_num [logScale]
  have small : gap k (oddCount N k)<90/(verifiedHeight:ℝ) := by
    apply (lt_div_iff₀' Bpos).2
    have leN : (verifiedHeight:ℝ)≤N := by exact_mod_cast base.le
    have le := mul_le_mul_of_nonneg_right leN pg.le
    linarith
  have capNat : 90*logScale≤globalGap*verifiedHeight := by decide
  have cap : 90*(logScale:ℝ)≤(globalGap:ℝ)*verifiedHeight := by exact_mod_cast capNat
  have middle : (logScale:ℝ)*(90/(verifiedHeight:ℝ))≤globalGap := by
    rw [←mul_div_assoc]
    apply (div_le_iff₀ Bpos).2
    simpa only [mul_comm (logScale:ℝ) 90] using cap
  constructor
  · have h := bracket.1.trans_lt ((mul_lt_mul_of_pos_left small Mpos).trans_le middle)
    exact_mod_cast h
  · have h := (mul_pos Mpos pg).trans_le bracket.2
    exact_mod_cast h

end
end Terras90Physical
