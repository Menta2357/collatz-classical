import TerrasDisplacement

namespace WeaverWindows90

open TerrasClock
open Terras88 (HasWindow q0Price verifiedHeight valleyTimes)
open Terras90Q0Price (product shiftedProduct chronologicalHeights floor146)
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered sortedFloorOfCount)

set_option maxHeartbeats 1200000
set_option maxRecDepth 10000
set_option exponentiation.threshold 2048

def priceFloors : List Nat :=
  List.replicate 5 q0Price ++ List.replicate 84 floor146

private theorem productPositive (xs : List Nat) (positive : ∀ x∈xs, 0<x) : 0<product xs := by
  induction xs with
  | nil => decide
  | cons x xs ih =>
    exact Nat.mul_pos (positive x List.mem_cons_self)
      (ih (fun y hy => positive y (List.mem_cons_of_mem _ hy)))

private theorem envelopeAtRanks {xs : List Nat} (len : xs.length=90)
    (ranked : xs.Pairwise (·≤·))
    (price : q0Price≤xs[1]'(by omega))
    (tall : floor146≤xs[6]'(by omega)) :
    ∀ p ∈ (xs.drop 1).zip priceFloors, p.2≤p.1 := by
  intro p mem
  obtain ⟨i, hi, item⟩ := List.mem_iff_getElem.mp mem
  have bounds : i<(xs.drop 1).length ∧ i<priceFloors.length := by
    simpa only [List.length_zip,Nat.lt_min] using hi
  rw [List.getElem_zip] at item
  rw [← item]
  by_cases early : i<5
  · have side : i<(List.replicate 5 q0Price).length := by simpa using early
    rw [show priceFloors[i]'bounds.2=q0Price by
      unfold priceFloors
      rw [List.getElem_append_left side, List.getElem_replicate]]
    apply Terras90Q0Price.floor_tail ranked (r:=1) (by omega) price
    exact List.getElem_mem bounds.1
  · have side : (List.replicate 5 q0Price).length≤i := by simp; omega
    rw [show priceFloors[i]'bounds.2=floor146 by
      unfold priceFloors
      rw [List.getElem_append_right side, List.getElem_replicate]]
    rw [List.getElem_drop]
    apply Terras90Q0Price.floor_tail ranked (r:=6) (by omega) tall
    rw [List.mem_iff_getElem]
    have within : i-5<(xs.drop 6).length := by simp only [List.length_drop,len] at *; omega
    exact ⟨i-5,within,by rw [List.getElem_drop]; congr 1; omega⟩

/-- One paid valley factor is cancelled against positive displacement.
The remaining product forces a second affordable valley from the same prefix. -/
theorem secondValleyBelowPrice {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (shift : N+1≤orbit N k) (runs : oddRuns N k=90)
    (rank7 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))≤6)
    (strict : 3^(oddCount N k)*shiftedProduct priceFloors < 2^k*product priceFloors) :
    2≤(valleyTimes N k).countP (fun i => decide (orbit N i<q0Price)) := by
  let xs := sortedHeights N k
  have same : xs.Perm (chronologicalHeights N k) := sortedHeights_perm N k
  have ranked : xs.Pairwise (·≤·) := sortedHeights_ordered N k
  have len : xs.length=90 := by
    rw [same.length_eq, chronologicalHeights, List.length_map, Terras88.valleyTimes_length, runs]
  have budget := TerrasDisplacement.singleDiscount (Nat.lt_of_le_of_lt (Nat.zero_le _) base)
    first shift ranked same
  have floorCount : (Terras90RankAssembly.valleyHeights N k).countP (fun x => decide (x<floor146))≤6 := by
    simpa only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def] using rank7
  have tall : floor146≤xs[6]'(by omega) :=
    sortedFloorOfCount (rank:=6) (by change 6<xs.length; omega) floorCount
  have affordable : xs[1]'(by omega)<q0Price := by
    by_cases cheap : xs[1]'(by omega)<q0Price
    · exact cheap
    · exfalso
      have price := Nat.le_of_not_gt cheap
      have positive : 0<product (xs.drop 1) := productPositive _ fun x hx =>
        Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (Nat.zero_le _) base)
          (Terras90Q0Price.chronological_lower first x (same.mem_iff.mp (List.mem_of_mem_drop hx)))
      exact TerrasDisplacement.excludeFromEnvelope
        (by simp [priceFloors,len]) (envelopeAtRanks len ranked price tall) positive budget strict
  have counts := Terras90Q0Price.rank_count_of_price ranked (r:=1) (by omega) affordable
  rw [same.countP_eq] at counts
  simpa only [chronologicalHeights,List.countP_map,Function.comp_def] using counts

/-- The window is extracted on the original chronological valley indices.
Only its two counts use sorted heights. -/
theorem windowFromProduct {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (kLong : 1<k)
    (shift : N+1≤orbit N k) (runs : oddRuns N k=90)
    (rank7 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))≤6)
    (strict : 3^(oddCount N k)*shiftedProduct priceFloors < 2^k*product priceFloors) :
    HasWindow N k q0Price floor146 5 := by
  have odd : N%2=1 := by
    by_cases yes : N%2=1
    · exact yes
    · have earlier := first.2 1 kLong
      simp [oddCount,orbit,yes] at earlier
  exact TerrasDisplacement.windowOfCounts (paid:=2) (cap:=6) base first odd
    (by decide) (by decide) (secondValleyBelowPrice base first shift runs rank7 strict)
    rank7 (by simp [runs]) (by decide)

end WeaverWindows90
