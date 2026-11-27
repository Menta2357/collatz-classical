import Terras90PhysicalGap
import Terras90ClockTable

namespace Terras90Physical

open TerrasClock
open Terras90Lattice

set_option maxRecDepth 12000
set_option maxHeartbeats 1400000
set_option exponentiation.threshold 512

/-- Rhin's uniform exponent 13.3 with factor one, specialized to
positive forms using the two clocks. -/
def RhinBound : Prop :=
  ∀ k d : Nat, 2≤k → d≤k → 0<gap k d →
    (k:ℝ)^(-(133/10:ℝ))≤gap k d

theorem oddsLeClock (N k : Nat) : oddCount N k≤k := by
  induction k with
  | zero => rfl
  | succ k ih =>
    by_cases odd : orbit N k%2=1 <;> simp [oddCount,odd] <;> omega

private theorem clockBound {N k : Nat} (first : FirstContraction N k)
    (dPos : 0<oddCount N k) : k≤2*oddCount N k := by
  cases k with
  | zero => exact (Nat.not_lt_zero 0 dPos).elim
  | succ i =>
    have even := first_contraction_last_even first
    have changeCount : oddCount N (i+1)=oddCount N i := by
      simp [oddCount,show ¬orbit N i%2=1 by omega]
    have earlier := first.2 i (Nat.lt_succ_self i)
    rw [←changeCount] at earlier
    have p : (3:Nat)^oddCount N (i+1)<4^oddCount N (i+1) :=
      Nat.pow_lt_pow_left (by decide) (by omega)
    have p' : (3:Nat)^oddCount N (i+1)<2^(2*oddCount N (i+1)) := by
      rw [Nat.pow_mul]
      exact p
    have h := (Nat.pow_lt_pow_iff_right (by decide : 1<(2:Nat))).mp (earlier.trans_lt p')
    omega

private theorem dyadicMargin (j : Nat) (large : 71≤j) :
    2000000000000000000*(70+133*(j+2)) < 10*2^j := by
  have step (i : Nat) :
      2000000000000000000*(70+133*((71+i)+2)) < 10*2^(71+i) := by
    induction i with
    | zero => decide
    | succ i ih =>
      rw [show 71+(i+1)=(71+i)+1 by omega,Nat.pow_succ]
      rw [←Nat.mul_assoc]
      omega
  simpa only [Nat.add_sub_of_le large] using step (j-71)

private theorem capacityOneNeat : roundedCapacity 1≤2000000000000000000 := by decide

/-- Once the first-valley rank bound is supplied from the same physical
prefix, the uniform Rhin estimate gives the finite dyadic cutoff. -/
theorem oddCutoff {N k : Nat} (rhin : RhinBound) (pos : 0<N)
    (first : FirstContraction N k) (runs : oddRuns N k=90)
    (shift : N+1≤orbit N k)
    (height : (oddCount N k:ℝ)≤(roundedCapacity 1:ℝ)*
      (Real.log ((N:ℝ)+1)/Real.log 2)) :
    oddCount N k < maxOdds := by
  let d := oddCount N k
  have nd : 90≤d := by simpa only [d,runs] using oddRuns_le_oddCount N k
  have kGe : 2≤k := by have := oddsLeClock N k; omega
  have kPos : 0<(k:ℝ) := by exact_mod_cast (show 0<k by omega)
  have kOne : (1:ℝ)≤k := by exact_mod_cast (show 1≤k by omega)
  have np : 0<(N:ℝ) := by exact_mod_cast pos
  have gapCap := gapTimesSeed pos first runs shift
  have uniform := rhin k d kGe (oddsLeClock N k) (gapPositive first)
  have compare := (mul_le_mul_of_nonneg_left uniform np.le).trans_lt gapCap
  have rp : 0<(k:ℝ)^(133/10:ℝ) := Real.rpow_pos_of_pos kPos _
  rw [Real.rpow_neg kPos.le,←div_eq_mul_inv] at compare
  have size := (div_lt_iff₀ rp).1 compare
  have aboveOne : (1:ℝ)≤(k:ℝ)^(133/10:ℝ) := Real.one_le_rpow kOne (by norm_num)
  have larger : (N:ℝ)+1<(2:ℝ)^7*(k:ℝ)^(133/10:ℝ) := by
    norm_num
    linarith
  have nlog := Real.log_lt_log (by positivity : (0:ℝ)<(N:ℝ)+1) larger
  rw [Real.log_mul (by positivity) rp.ne',Real.log_pow,Real.log_rpow kPos] at nlog
  let j := d.log2
  have upper : d<2^(j+1) := Nat.lt_log2_self
  have kRange : k<2^(j+2) := by
    have := clockBound first (by omega)
    rw [show j+2=(j+1)+1 by omega,Nat.pow_succ]
    omega
  have kRangeReal : (k:ℝ)<(2:ℝ)^(j+2) := by exact_mod_cast kRange
  have klog := Real.log_lt_log kPos kRangeReal
  rw [Real.log_pow,Nat.cast_add] at klog
  have logs₂ : 0<Real.log 2 := Real.log_pos (by norm_num)
  have logBound : Real.log ((N:ℝ)+1)/Real.log 2 < 7+(133/10:ℝ)*(j+2) := by
    apply (div_lt_iff₀ logs₂).2
    have m := mul_lt_mul_of_pos_left klog (by norm_num : 0<(133/10:ℝ))
    nlinarith only [nlog,m]
  have capR : (roundedCapacity 1:ℝ) ≤ 2000000000000000000 := by exact_mod_cast capacityOneNeat
  have rhs : 0≤(7:ℝ)+(133/10:ℝ)*(j+2) := by positivity
  have h : (d:ℝ) ≤ 2000000000000000000*(7+(133/10:ℝ)*(j+2)) :=
    (height.trans (mul_le_mul_of_nonneg_left logBound.le (Nat.cast_nonneg _))).trans
      (mul_le_mul_of_nonneg_right capR rhs)
  by_contra high
  have dBig : 2^71≤d := by simpa [d,maxOdds] using (Nat.le_of_not_gt high)
  have jBig : 71≤j := (Nat.le_log2 (by omega : d≠0)).2 dBig
  have dLower : 2^j≤d := (Nat.le_log2 (by omega : d≠0)).1 (Nat.le_refl j)
  have dLowerReal : (2:ℝ)^j≤d := by exact_mod_cast dLower
  have num := dyadicMargin j jBig
  have res : (2000000000000000000:ℝ)*(70+133*((j:ℝ)+2)) < 10*(2:ℝ)^j := by
    exact_mod_cast num
  nlinarith only [h,res,dLowerReal]

/-- The lattice lower bound for d is derived using the first three
inequalities, before the ordinary envelope is constructed. -/
theorem physicalBasisFloor {k d : Nat} (small : d<maxOdds)
    (lower : lowGap k d<globalGap) (upper : 0<highGap k d) : basisD≤d := by
  obtain ⟨h,j,hp,_,_,_,clock⟩ := admitCoordinates small lower upper
  have dEq := congrArg Prod.snd clock
  change h*basisD+j*otherD=d at dEq
  have hge : basisD≤h*basisD := by simpa only [Nat.one_mul] using Nat.mul_le_mul_right basisD hp
  omega

end Terras90Physical
