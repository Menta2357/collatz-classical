import Terras91Delay
import TerrasDisplacement

namespace Terras91Q0Product

open TerrasClock
open Terras88 (verifiedHeight q0Price q0Clock valleyTimes HasWindow)
open Terras90Q0Price
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered sortedFloorOfCount)

set_option maxRecDepth 10000
set_option maxHeartbeats 1200000
set_option exponentiation.threshold 2048

def sourceFloor : Nat := Terras91Delay.recordSeed+1

/-- Rank 1 is discounted. The four blocks correspond to physical ranks
2–6, 7–10, 11 and 12–91 in the ordered list of valleys. -/
def floors : List Nat :=
  List.replicate 5 sourceFloor ++ (List.replicate 4 q0Price ++ (floor92 :: List.replicate 80 floor146))

theorem floorsLength : floors.length=90 := by decide

private theorem transferStrict {a b u v p q : Nat}
    (old : a*u<b*v) (new : p*v≤q*u) (qPos : 0<q) : a*p<b*q := by
  apply Nat.lt_of_mul_lt_mul_left (a:=v)
  calc
    _ = a*(p*v) := by ac_rfl
    _ ≤ a*(q*u) := Nat.mul_le_mul_left a new
    _ = (a*u)*q := by ac_rfl
    _ < (b*v)*q := Nat.mul_lt_mul_of_pos_right old qPos
    _ = _ := by ac_rfl

/-- Reuse the frozen dyadic comparison from Q0 at 90 runs. Five factors
at the confirmed delay floor cost less than four at the old seed floor. -/
theorem productStrict :
    3^q0Clock.2*shiftedProduct floors < 2^q0Clock.1*product floors := by
  apply transferStrict q0ProductStrict
  · decide
  · decide

private theorem nthFloor {xs : List Nat} {i r a : Nat}
    (sorted : xs.Pairwise (·≤·)) (ri : r≤i) (hi : i<xs.length)
    (floor : a≤xs[r]'(by omega)) : a≤xs[i] := by
  by_cases eq : r=i
  · subst r
    exact floor
  · exact Nat.le_trans floor (List.pairwise_iff_getElem.mp sorted r i (by omega) hi (by omega))

private theorem envelopeAtRanks {xs : List Nat} (len : xs.length=91)
    (sorted : xs.Pairwise (·≤·)) (lower : ∀ x∈xs, sourceFloor≤x)
    (price : q0Price≤xs[6]'(by omega)) (at92 : floor92≤xs[10]'(by omega))
    (at146 : floor146≤xs[11]'(by omega)) :
    ∀ p∈(xs.drop 1).zip floors, p.2≤p.1 := by
  intro p mem
  obtain ⟨i,hi,item⟩ := List.mem_iff_getElem.mp mem
  have b : i<(xs.drop 1).length ∧ i<floors.length := by
    simpa only [List.length_zip,Nat.lt_min] using hi
  have within : 1+i<xs.length := by simp only [List.length_drop] at b; omega
  rw [List.getElem_zip] at item
  rw [←item]
  by_cases first : i<5
  · have side : i<(List.replicate 5 sourceFloor).length := by simpa using first
    rw [show floors[i]'b.2=sourceFloor by
      unfold floors
      rw [List.getElem_append_left side,List.getElem_replicate]]
    exact lower _ (List.mem_of_mem_drop (List.getElem_mem b.1))
  have rest : 5≤i := by omega
  by_cases next : i<9
  · rw [show floors[i]'b.2=q0Price by
      unfold floors
      rw [List.getElem_append_right (by simpa using rest)]
      rw [List.getElem_append_left (by simp; omega),List.getElem_replicate]]
    rw [List.getElem_drop]
    exact nthFloor sorted (r:=6) (by omega) within price
  by_cases middle : i=9
  · subst i
    rw [show floors[9]'b.2=floor92 by rfl,List.getElem_drop]
    exact at92
  · rw [show floors[i]'b.2=floor146 by
      unfold floors
      rw [List.getElem_append_right (by simpa using rest)]
      rw [List.getElem_append_right (by simp; omega)]
      have eq : i-5-4=(i-10)+1 := by omega
      simp only [List.length_replicate,eq,List.getElem_cons_succ,List.getElem_replicate]]
    rw [List.getElem_drop]
    exact nthFloor sorted (r:=11) (by omega) within at146

private theorem positiveProduct (xs : List Nat) (pos : ∀ x∈xs, 0<x) : 0<product xs := by
  induction xs with
  | nil => decide
  | cons x rest ih =>
    exact Nat.mul_pos (pos x List.mem_cons_self) (ih fun y mem => pos y (List.mem_cons_of_mem _ mem))

/-- The original chronology must contain a Weaver Q0 window at every
positive shift, including the remaining case `orbit N k=N+1`. -/
theorem windowOfPositiveShift {N k : Nat} (record : Terras91Delay.OrdinaryDelay2480)
    (seed : 2≤N) (first : FirstContraction N k) (runs : oddRuns N k=91)
    (clock : (k,oddCount N k)=q0Clock) (shift : N+1≤orbit N k)
    (rank92 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor92))<11)
    (rank146 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))<12) :
    HasWindow N k q0Price floor146 5 := by
  have floor := Terras91Delay.aboveRecordAtQ0 record seed first clock
  have base : verifiedHeight<N := Nat.lt_of_le_of_lt (by decide) floor
  let xs := sortedHeights N k
  have same : xs.Perm (chronologicalHeights N k) := sortedHeights_perm N k
  have sorted : xs.Pairwise (·≤·) := sortedHeights_ordered N k
  have len : xs.length=91 := by
    rw [same.length_eq,chronologicalHeights,List.length_map,Terras88.valleyTimes_length,runs]
  have lower : ∀ x∈xs, sourceFloor≤x := fun x mem =>
    Nat.le_trans floor (chronological_lower first x (same.mem_iff.mp mem))
  have h92 : floor92≤xs[10]'(by omega) := by
    apply sortedFloorOfCount (rank:=10) (by change 10<xs.length; omega)
    simpa only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def] using
      Nat.le_of_lt_succ rank92
  have h146 : floor146≤xs[11]'(by omega) := by
    apply sortedFloorOfCount (rank:=11) (by change 11<xs.length; omega)
    simpa only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def] using
      Nat.le_of_lt_succ rank146
  have cheap : xs[6]'(by omega)<q0Price := by
    by_cases cheap : xs[6]'(by omega)<q0Price
    · exact cheap
    have budget := TerrasDisplacement.singleDiscount (show 0<N by omega) first shift sorted same
    have clockK : k=q0Clock.1 := congrArg Prod.fst clock
    have clockD : oddCount N k=q0Clock.2 := congrArg Prod.snd clock
    have strict : 3^(oddCount N k)*shiftedProduct floors<2^k*product floors := by
      rw [clockD,clockK]
      exact productStrict
    exact (TerrasDisplacement.excludeFromEnvelope (by simp [floorsLength,len])
      (envelopeAtRanks len sorted lower (Nat.le_of_not_gt cheap) h92 h146)
      (positiveProduct _ fun x mem => Nat.lt_of_lt_of_le (by decide) (lower x (List.mem_of_mem_drop mem)))
      budget strict).elim
  have paid := rank_count_of_price sorted (r:=6) (by omega) cheap
  rw [same.countP_eq] at paid
  simp only [chronologicalHeights,List.countP_map,Function.comp_def] at paid
  have clockK : k=q0Clock.1 := congrArg Prod.fst clock
  have late : 1<k := clockK ▸ (by decide : 1<q0Clock.1)
  have odd : N%2=1 := by
    by_cases isOdd : N%2=1
    · exact isOdd
    have before := first.2 1 late
    simp [oddCount,orbit,isOdd] at before
  exact TerrasDisplacement.windowOfCounts (paid:=7) (cap:=11) base first odd
    (by decide) (by decide) paid (Nat.le_of_lt_succ rank146) (by omega) (by decide)

end Terras91Q0Product

#print axioms Terras91Q0Product.productStrict
#print axioms Terras91Q0Product.windowOfPositiveShift
