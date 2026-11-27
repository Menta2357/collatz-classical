import Terras91OrdinaryRank
import Terras91Cutoff
import Terras91Reciprocal
import Terras90LogBrackets

namespace Terras91Physical

open TerrasClock
open Terras88 (verifiedHeight)
open Terras90Lattice (logScale budgetScale lowGap highGap basisD otherD sourceBoundary)
open Terras91Lattice
open Terras90RankAssembly (sortedHeights)
open Terras90Physical (LogBrackets RhinBound oddsLeClock sortedLower scaledBrackets gap reciprocal)

set_option maxRecDepth 12000
set_option maxHeartbeats 1200000

structure ScaledAdmission (k d : Nat) : Prop where
  cutoff : d<maxOdds
  low : lowGap k d<globalGap
  high : 0<highGap k d
  ordinary : lowGap k d<100000*(ordinaryBudget d:Int)

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

/-- Turn the ordinary valley rank bounds into all four integer
conditions on the same first crossing, with the external analytic inputs
present explicitly. -/
theorem admissionOfRankBounds {N k : Nat} (logs : LogBrackets) (rhin : RhinBound)
    (base : verifiedHeight<N) (first : FirstContraction N k)
    (runs : oddRuns N k=91) (shift : N+1≤orbit N k)
    (firstRank : (oddCount N k:ℝ)≤(roundedCapacity 1:ℝ)*
      (Real.log ((N:ℝ)+1)/Real.log 2))
    (ranks : ∀ (i : Nat) (hi : i < (sortedHeights N k).length),
      (1 ≤ i) → (oddCount N k : ℝ) ≤ (roundedCapacity (i+1) : ℝ) *
        (Real.log ((↑((sortedHeights N k)[i]'hi) : ℝ) + 1) / Real.log 2)) :
    ScaledAdmission k (oddCount N k) := by
  have pos : 0<N := Nat.lt_of_le_of_lt (Nat.zero_le _) base
  have dPos : 0<oddCount N k := by have := oddRuns_le_oddCount N k; omega
  have cut := Terras91Cutoff.oddCutoff rhin pos first (by omega) (by omega) shift firstRank
  obtain ⟨lo,hi⟩ := Terras91Gap.gapStrip logs base first (by omega) (by omega) shift
  obtain ⟨h,j,hPos,_,_,_,clock⟩ := admitCoordinates cut lo hi
  have bd : basisD≤oddCount N k := by
    have dEq := congrArg Prod.snd clock
    change h*basisD+j*otherD=oddCount N k at dEq
    have hGe := Nat.mul_le_mul_right basisD hPos
    rw [Nat.one_mul] at hGe
    omega
  let xs := sortedHeights N k
  have len : xs.length=91 := (Terras90UniformGap.sortedLengthEq N k).trans runs
  have upwards : ∀ x∈xs, sourceBoundary≤x := fun x hx =>
    Nat.le_trans (Nat.le_of_lt base) (sortedLower first x hx)
  have floors : ∀ (i : Nat) (ih : i<xs.length), (1 ≤ i) →
    2^(min 180 (oddCount N k/roundedCapacity (i+1)))-1≤xs[i]'ih :=
      fun i ih hi => floorOfLogRank dPos (ranks i ih hi)
  have envelope := Terras91Reciprocal.ordinaryReciprocalBound len upwards bd floors
  have bound : (budgetScale:ℝ)*reciprocal (xs.drop 1)≤(ordinaryBudget (oddCount N k):ℝ) := envelope
  have units : (logScale:ℝ)=100000*(budgetScale:ℝ) := by norm_num [logScale,budgetScale]
  have Bpos : 0<(logScale:ℝ) := by norm_num [logScale]
  have total : (lowGap k (oddCount N k):ℝ)<100000*(ordinaryBudget (oddCount N k):ℝ) := by
    calc
      _ ≤ (logScale:ℝ)*gap k (oddCount N k) := (scaledBrackets logs k _).1
      _ < (logScale:ℝ)*reciprocal (xs.drop 1) :=
        mul_lt_mul_of_pos_left (Terras90UniformGap.discountedGap pos first (by omega) shift) Bpos
      _ = 100000*((budgetScale:ℝ)*reciprocal (xs.drop 1)) := by rw [units,mul_assoc]
      _ ≤ _ := mul_le_mul_of_nonneg_left bound (by norm_num)
  exact ⟨cut,lo,hi,by exact_mod_cast total⟩

theorem ScaledAdmission.memClocks {k d : Nat} (admitted : ScaledAdmission k d) :
    (k,d)∈survivors :=
  clocksOfScaledEnvelope admitted.cutoff admitted.low admitted.high admitted.ordinary

open Terras91OrdinaryRank
open Terras90RankAssembly (sortedHeights_perm sortedHeights_ordered)

/-- All four inputs to the integer sieve follow from the physical
first-crossing candidate once the analytic logarithm bounds are supplied. -/
theorem admissionFromPhysical {N k : Nat} (bounds : LogBrackets) (rhin : RhinBound)
    (base : verifiedHeight<N) (first : FirstContraction N k)
    (runs : oddRuns N k=91) (shift : N+1≤orbit N k) :
    ScaledAdmission k (oddCount N k) := by
  have late : 1<k := by
    have n := oddsLeClock N k
    have r := oddRuns_le_oddCount N k
    omega
  apply admissionOfRankBounds bounds rhin base first runs shift
  · exact ordinarySourceBound first late (by omega)
  · intro i hi _
    exact ordinaryRankBoundOfSorted first late (by omega) (sortedHeights_ordered N k)
      (sortedHeights_perm N k) hi

/-- The clock pair of the same physical first crossing is one of the 18
finite candidates. The scaled logarithm brackets are proved in Lean. -/
theorem clocksFromPhysical {N k : Nat} (rhin : RhinBound)
    (base : verifiedHeight<N) (first : FirstContraction N k)
    (runs : oddRuns N k=91) (shift : N+1≤orbit N k) :
    (k,oddCount N k)∈survivors :=
  (admissionFromPhysical Terras90LogBrackets.certified rhin base first runs shift).memClocks

end Terras91Physical

#print axioms Terras91Physical.admissionOfRankBounds
#print axioms Terras91Physical.ScaledAdmission.memClocks
#print axioms Terras91Physical.admissionFromPhysical
#print axioms Terras91Physical.clocksFromPhysical
