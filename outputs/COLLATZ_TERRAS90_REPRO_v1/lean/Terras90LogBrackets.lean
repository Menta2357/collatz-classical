import Mathlib.Analysis.SpecialFunctions.Log.Deriv
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Terras90IntegerFloors

namespace Terras90LogBrackets

noncomputable section

open Finset Terras90Lattice Terras90IntegerFloors

set_option maxHeartbeats 1200000
set_option maxRecDepth 8000

private def term (x : ℝ) (i : ℕ) : ℝ :=
  2 * (1 / (2 * (i : ℝ) + 1)) * x^(2*i+1)

private def partialTotal (x : ℝ) (n : ℕ) : ℝ :=
  ∑ i ∈ range n, term x i

private def error (x : ℝ) (n : ℕ) : ℝ :=
  (2*x^(2*n+1))/(1-x^2)

private theorem partialBounds {x : ℝ} (hx : 0≤x) (hx1 : x<1) (n : ℕ) :
    partialTotal x n ≤ Real.log ((1+x)/(1-x)) ∧
      Real.log ((1+x)/(1-x)) ≤ partialTotal x n+error x n := by
  have hsum : HasSum (term x) (Real.log (1+x)-Real.log (1-x)) := by
    simpa only [term] using Real.hasSum_log_sub_log_of_abs_lt_one
      (show |x|<1 by simpa only [abs_of_nonneg hx] using hx1)
  let C : ℝ := 2*x^(2*n+1)
  have hs : Summable (fun i : ℕ => term x (i+n)) :=
    (summable_nat_add_iff n).2 hsum.summable
  have hs0 : 0≤∑' i : ℕ, term x (i+n) := tsum_nonneg (fun i => by unfold term; positivity)
  have hgeo : HasSum (fun i : ℕ => C*(x^2)^i) (C*(1-x^2)⁻¹) :=
    (hasSum_geometric_of_lt_one (by positivity : 0≤x^2)
      (by nlinarith : x^2<1)).mul_left C
  have term_le (i : ℕ) : term x (i+n) ≤ C*(x^2)^i := by
    have hp : (2*(i+n)+1 : ℕ)=(2*n+1)+2*i := by omega
    have hd : 1/(2*((i+n:ℕ):ℝ)+1)≤(1:ℝ) := by
      apply (div_le_iff₀ (by positivity : 0<2*((i+n:ℕ):ℝ)+1)).2
      simp
      positivity
    calc
      term x (i+n) ≤ 2*x^(2*(i+n)+1) := by
        unfold term
        simpa only [mul_one] using
          (mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hd (by positivity : 0≤(2:ℝ)))
            (pow_nonneg hx (2*(i+n)+1)))
      _ = C*(x^2)^i := by rw [hp,pow_add,pow_mul]; simp only [C,mul_assoc]
  have tail := Summable.tsum_le_tsum term_le hs hgeo.summable
  rw [hgeo.tsum_eq] at tail
  have split := hsum.summable.sum_add_tsum_nat_add n
  rw [hsum.tsum_eq, ←Real.log_div (by positivity : (1+x:ℝ)≠0)
    (by linarith : (1-x:ℝ)≠0)] at split
  change partialTotal x n + (∑' i, term x (i+n)) = Real.log ((1+x)/(1-x)) at split
  rw [←split]
  exact ⟨le_add_of_nonneg_right hs0,
    add_le_add_left (by simpa only [error, C, div_eq_mul_inv] using tail) _⟩

private theorem floorBounds {b : ℕ} (hb : 2≤b) (n : ℕ) :
    (floorSum b n:ℝ) ≤ (precision:ℝ)*partialTotal ((b:ℝ)⁻¹) n ∧
      (precision:ℝ)*partialTotal ((b:ℝ)⁻¹) n ≤ (floorSum b n:ℝ)+(n:ℝ) := by
  induction n with
  | zero => simp [partialTotal,floorSum]
  | succ n ih =>
    have bpos : 0<b := by omega
    have dp : 0<denominator b n := Nat.mul_pos (by omega) (Nat.pow_pos bpos)
    have dpR : (0:ℝ)<denominator b n := by exact_mod_cast dp
    have form : term ((b:ℝ)⁻¹) n = (2:ℝ)/(denominator b n:ℝ) := by
      unfold term denominator
      push_cast
      rw [inv_pow]
      field_simp
    have low : floorTerm b n * denominator b n ≤ 2*precision :=
      Nat.div_mul_le_self _ _
    have high : 2*precision < (floorTerm b n+1)*denominator b n :=
      (Nat.div_lt_iff_lt_mul dp).mp (Nat.lt_succ_self _)
    have lowR : (floorTerm b n:ℝ)*(denominator b n:ℝ)≤2*(precision:ℝ) := by
      exact_mod_cast low
    have highR : 2*(precision:ℝ)<((floorTerm b n:ℝ)+1)*(denominator b n:ℝ) := by
      exact_mod_cast high
    have hit : (precision:ℝ)*term ((b:ℝ)⁻¹) n = (2*(precision:ℝ))/(denominator b n:ℝ) := by
      rw [form]
      ring
    have lower : (floorTerm b n:ℝ)≤(precision:ℝ)*term ((b:ℝ)⁻¹) n := by
      rw [hit]
      exact (le_div_iff₀ dpR).2 lowR
    have upper : (precision:ℝ)*term ((b:ℝ)⁻¹) n≤(floorTerm b n:ℝ)+1 := by
      rw [hit]
      exact (div_le_iff₀ dpR).2 highR.le
    simp only [floorSum,Nat.cast_add,Nat.cast_one,partialTotal,sum_range_succ,mul_add] at *
    constructor
    · exact add_le_add ih.1 lower
    · linarith only [ih.2,upper]

private theorem bracketFromFloors {b n l h : ℕ} (hb : 2≤b)
    (floorLower : 10000*l≤floorSum b n)
    (floorUpper : floorSum b n+n+100≤10000*h)
    (tailSmall : (precision:ℝ)*error ((b:ℝ)⁻¹) n≤100) :
    (l:ℝ) ≤ (logScale:ℝ)*Real.log ((1+(b:ℝ)⁻¹)/(1-(b:ℝ)⁻¹)) ∧
      (logScale:ℝ)*Real.log ((1+(b:ℝ)⁻¹)/(1-(b:ℝ)⁻¹)) ≤ (h:ℝ) := by
  have b2 : (2:ℝ)≤b := by exact_mod_cast hb
  have x0 : 0≤(b:ℝ)⁻¹ := inv_nonneg.mpr (by linarith)
  have x1 : (b:ℝ)⁻¹<1 := by
    rw [inv_eq_one_div]
    exact (div_lt_iff₀ (by linarith : (0:ℝ)<b)).2 (by linarith)
  let L := Real.log ((1+(b:ℝ)⁻¹)/(1-(b:ℝ)⁻¹))
  have ppos : (0:ℝ)≤precision := by positivity
  have scaledLower : (precision:ℝ)*partialTotal ((b:ℝ)⁻¹) n≤(precision:ℝ)*L :=
    mul_le_mul_of_nonneg_left (partialBounds x0 x1 n).1 ppos
  have scaledUpper : (precision:ℝ)*L≤
      (precision:ℝ)*partialTotal ((b:ℝ)⁻¹) n+(precision:ℝ)*error ((b:ℝ)⁻¹) n := by
    simpa only [L,mul_add] using mul_le_mul_of_nonneg_left (partialBounds x0 x1 n).2 ppos
  have low : (10000:ℝ)*(l:ℝ)≤(floorSum b n:ℝ) := by exact_mod_cast floorLower
  have high : (floorSum b n:ℝ)+(n:ℝ)+100≤10000*(h:ℝ) := by exact_mod_cast floorUpper
  have rl : (10000:ℝ)*(l:ℝ)≤(precision:ℝ)*L :=
    low.trans ((floorBounds hb n).1.trans scaledLower)
  have rh : (precision:ℝ)*L≤10000*(h:ℝ) :=
    scaledUpper.trans ((add_le_add (floorBounds hb n).2 tailSmall).trans high)
  have scales : (precision:ℝ)=10000*(logScale:ℝ) := by norm_num [precision,logScale]
  rw [scales,mul_assoc] at rl rh
  change (l:ℝ)≤(logScale:ℝ)*L ∧ (logScale:ℝ)*L≤(h:ℝ)
  exact ⟨by linarith only [rl],by linarith only [rh]⟩

theorem logTwo :
    (log2Low:ℝ)≤(logScale:ℝ)*Real.log 2 ∧ (logScale:ℝ)*Real.log 2≤(log2High:ℝ) := by
  have h := bracketFromFloors (b := 3) (n := 65) (l := log2Low) (h := log2High)
    (by decide) floorTwoLow floorTwoHigh
    (by norm_num [precision,error])
  norm_num at h
  exact h

theorem logThree :
    (log3Low:ℝ)≤(logScale:ℝ)*Real.log 3 ∧ (logScale:ℝ)*Real.log 3≤(log3High:ℝ) := by
  have h := bracketFromFloors (b := 2) (n := 110) (l := log3Low) (h := log3High)
    (by decide) floorThreeLow floorThreeHigh
    (by norm_num [precision,error])
  norm_num at h
  exact h

theorem certified :
    (log2Low:ℝ) ≤ (logScale:ℝ)*Real.log 2 ∧
      (logScale:ℝ)*Real.log 2 ≤ (log2High:ℝ) ∧
      (log3Low:ℝ) ≤ (logScale:ℝ)*Real.log 3 ∧
      (logScale:ℝ)*Real.log 3 ≤ (log3High:ℝ) :=
  ⟨logTwo.1,logTwo.2,logThree.1,logThree.2⟩

end

end Terras90LogBrackets
