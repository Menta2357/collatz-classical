import Terras90UniformCutoff
import Terras90UniformReciprocal
import TerrasUniformRanks
import TerrasUniformProducts
import Terras90SourceBridge

namespace TerrasUniformFirstDescent

open TerrasClock
open Terras88 (verifiedHeight valleyTimes q0Clock q0Price q1Clock twiceQ1Clock HasWindow)
open Terras90Q0Price (floor92 floor146 product shiftedProduct)
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered)
open Terras90Physical (ScaledAdmission gap reciprocal gapPositive scaledBrackets physicalBasisFloor oddsLeClock)
open Terras90Lattice

set_option maxRecDepth 12000
set_option maxHeartbeats 1800000
set_option exponentiation.threshold 512

private theorem floorOfLogRank {d c x : Nat} (dPos : 0<d)
    (bound : (d:ℝ) ≤ (c:ℝ)*(Real.log ((x:ℝ)+1)/Real.log 2)) :
    2^(min 180 (d/c))-1≤x := by
  have hc : 0<c := by
    by_contra small
    have zero : c=0 := by omega
    have hd : (0:ℝ)<d := by exact_mod_cast dPos
    rw [zero] at bound
    have nonpos : (d:ℝ)≤0 := by simpa only [Nat.cast_zero,zero_mul] using bound
    exact (not_lt_of_ge nonpos) hd
  let e := min 180 (d/c)
  have count : e*c≤d := Nat.le_trans (Nat.mul_le_mul_right c (Nat.min_le_right 180 (d/c)))
    (Nat.div_mul_le_self _ _)
  change 2^e-1≤x
  by_contra missing
  have tight : x+1<2^e := by omega
  have n : (x:ℝ)+1<(2:ℝ)^e := by exact_mod_cast tight
  have h := Real.log_lt_log (by positivity) n
  rw [Real.log_pow] at h
  have ltwo : 0<Real.log 2 := Real.log_pos (by norm_num)
  have lh : Real.log ((x:ℝ)+1)/Real.log 2 < (e:ℝ) := (div_lt_iff₀ ltwo).2 h
  have cr : (0:ℝ)<c := by exact_mod_cast hc
  have contradiction := bound.trans_lt (mul_lt_mul_of_pos_left lh cr)
  exact (not_lt_of_ge (show (c:ℝ)*e≤d by rw [mul_comm]; exact_mod_cast count)) contradiction

/-- The same eleven absolute clocks admit positive-displacement candidates
through the entire new range of run counts. -/
theorem admissionOfPhysicalRange {N k : Nat} (rhin : Terras90Physical.RhinBound)
    (base : verifiedHeight<N) (first : FirstContraction N k)
    (lower : 87≤oddRuns N k) (upper : oddRuns N k≤90) (shift : N+1≤orbit N k) :
    ScaledAdmission k (oddCount N k) := by
  let d := oddCount N k
  let xs := sortedHeights N k
  have pos : 0<N := Nat.lt_of_le_of_lt (Nat.zero_le _) base
  have late : 1<k := by have := oddRuns_le_oddCount N k; have := oddsLeClock N k; omega
  have dPos : 0<d := by have := oddRuns_le_oddCount N k; omega
  have many : 2≤oddRuns N k := by omega
  have length : xs.length=oddRuns N k := TerrasUniformProducts.sortedLength N k
  have cut := Terras90UniformCutoff.oddCutoff rhin pos first many upper shift
    (TerrasUniformRanks.ordinarySourceBound first late upper)
  obtain ⟨lo,hi⟩ := Terras90UniformGap.gapStrip Terras90LogBrackets.certified base first many upper shift
  have bd := physicalBasisFloor cut lo hi
  have upwards : ∀ x∈xs, sourceBoundary≤x := fun x hx =>
    Nat.le_trans (Nat.le_of_lt base) (Terras90Physical.sortedLower first x hx)
  have floors : ∀ (i : Nat) (ih : i < xs.length), (1 ≤ i) →
      2^(min 180 (d/roundedCapacity (i+1)))-1 ≤ xs[i]'ih := by
    intro i ih _
    exact floorOfLogRank dPos (TerrasUniformRanks.ordinaryRankBoundOfSorted first late upper
      (sortedHeights_ordered N k) (sortedHeights_perm N k) ih)
  have budget : (budgetScale:ℝ)*reciprocal (xs.drop 1)≤(ordinaryBudget d:ℝ) :=
    Terras90UniformReciprocal.ordinaryReciprocalBound (by omega) (by omega) upwards bd floors
  have units : (logScale:ℝ)=100000*(budgetScale:ℝ) := by norm_num [logScale,budgetScale]
  have Bpos : 0<(logScale:ℝ) := by norm_num [logScale]
  have total : (lowGap k d:ℝ)<100000*(ordinaryBudget d:ℝ) := by
    calc
      _ ≤ (logScale:ℝ)*gap k d := (scaledBrackets Terras90LogBrackets.certified k d).1
      _ < (logScale:ℝ)*reciprocal (xs.drop 1) :=
        mul_lt_mul_of_pos_left (Terras90UniformGap.discountedGap pos first many shift) Bpos
      _ = 100000*((budgetScale:ℝ)*reciprocal (xs.drop 1)) := by rw [units,mul_assoc]
      _ ≤ _ := mul_le_mul_of_nonneg_left budget (by norm_num)
  exact ⟨cut,lo,hi,by exact_mod_cast total⟩

/-- Weaver's theorem 1, expressed at its physical first-crossing clock. -/
def Weaver86 : Prop :=
  ∀ N k, 2≤N → FirstContraction N k → oddRuns N k≤86 → orbit N k<N

/-- The additional 87–90 branch uses the source statements and a single
range proof. The earlier theorem consumed is precisely Weaver's 86. -/
theorem firstDescentAtMost90FromWeaver (inputs : Terras90SourceBridge.Inputs) (older : Weaver86)
    {N k : Nat} (seed : 2≤N) (first : FirstContraction N k) (ceilRuns : oddRuns N k≤90) :
    orbit N k<N ∧ (∀ j<k, N≤orbit N j) ∧
      2^k*orbit N k=3^(oddCount N k)*N+additive N k := by
  refine ⟨?_,fun _ h => prior_no_descent first h,exact_book N k⟩
  by_cases earlier : oddRuns N k≤86
  · exact older N k seed first earlier
  by_cases small : N≤verifiedHeight
  · exact inputs.finiteRange N k seed small first
  have large : verifiedHeight<N := by omega
  by_contra failure
  have neq := Terras90Hercher.noEqualOfAtMost91 inputs.hercher
    (Nat.lt_trans (by decide) large) first (by omega)
  have shift : N+1≤orbit N k := by omega
  have a := admissionOfPhysicalRange (Terras90SourceBridge.rhinBoundOfPrinted inputs.linearForms)
    large first (by omega) ceilRuns shift
  obtain ⟨s92,s146⟩ := Terras90PublishedCapacity.sixRunCapacities inputs.sevenRuns inputs.fiveRuns
    inputs.guardedH146
  exact TerrasUniformProducts.excludesPositiveInRange large first (by omega) ceilRuns shift a.memClocks s92 s146
    (Terras90WeaverEvidence.noWindow inputs.weaver N k)

end TerrasUniformFirstDescent

#print axioms TerrasUniformFirstDescent.admissionOfPhysicalRange
#print axioms TerrasUniformFirstDescent.firstDescentAtMost90FromWeaver
