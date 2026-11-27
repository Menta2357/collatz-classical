import Terras2Q0Floors
import Terras90TwiceQ0Numeric
import WeaverWindows90

namespace Terras90TwiceQ0

open TerrasClock
open Terras88 (verifiedHeight valleyTimes q0Clock)
open Terras90Q0Price (product shiftedProduct chronologicalHeights floor92)
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered sortedFloorOfCount)
open Terras90TwiceQ0Numeric (floors)

set_option maxRecDepth 10000
set_option maxHeartbeats 1200000

def clock2 : Nat × Nat := (2*q0Clock.1,2*q0Clock.2)

private theorem productPositive (xs : List Nat) (positive : ∀ x∈xs, 0<x) : 0<product xs := by
  induction xs with
  | nil => decide
  | cons x xs ih =>
    exact Nat.mul_pos (positive x List.mem_cons_self)
      (ih (fun y hy => positive y (List.mem_cons_of_mem _ hy)))

private theorem envelopeAtRanks {xs : List Nat} (len : xs.length=90)
    (ranked : xs.Pairwise (·≤·)) (base : ∀ x∈xs, verifiedHeight≤x)
    (tall : floor92≤xs[8]'(by omega)) :
    ∀ p ∈ (xs.drop 1).zip floors, p.2≤p.1 := by
  intro p mem
  obtain ⟨i,hi,item⟩ := List.mem_iff_getElem.mp mem
  have bounds : i<(xs.drop 1).length ∧ i<floors.length := by
    simpa only [List.length_zip,Nat.lt_min] using hi
  rw [List.getElem_zip] at item
  rw [← item]
  by_cases early : i<7
  · have side : i<(List.replicate 7 verifiedHeight).length := by simpa using early
    rw [show floors[i]'bounds.2=verifiedHeight by
      unfold floors
      rw [List.getElem_append_left side,List.getElem_replicate]]
    exact base _ (List.mem_of_mem_drop (List.getElem_mem bounds.1))
  · have side : (List.replicate 7 verifiedHeight).length≤i := by simp; omega
    rw [show floors[i]'bounds.2=floor92 by
      unfold floors
      rw [List.getElem_append_right side,List.getElem_replicate]]
    rw [List.getElem_drop]
    apply Terras90Q0Price.floor_tail ranked (r:=8) (by omega) tall
    rw [List.mem_iff_getElem]
    have within : i-7<(xs.drop 8).length := by simp only [List.length_drop,len] at *; omega
    exact ⟨i-7,within,by rw [List.getElem_drop]; congr 1; omega⟩

/-- Physical factor cancellation and one floor exclude every positive
displacement at 2Q0. The ranks count occurrences in the same prefix. -/
theorem excludesPositiveShift {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=clock2) (shift : N+1≤orbit N k)
    (capacity : Terras90.SixRunCapacity 92) : False := by
  let xs := sortedHeights N k
  have same : xs.Perm (chronologicalHeights N k) := sortedHeights_perm N k
  have ranked : xs.Pairwise (·≤·) := sortedHeights_ordered N k
  have len : xs.length=90 := by
    rw [same.length_eq,chronologicalHeights,List.length_map,Terras88.valleyTimes_length,runs]
  have physical : ∀ x∈xs, verifiedHeight≤x := fun x hx =>
    Nat.le_trans (Nat.le_of_lt base) (Terras90Q0Price.chronological_lower first x (same.mem_iff.mp hx))
  have budget := TerrasDisplacement.singleDiscount (Nat.lt_of_le_of_lt (Nat.zero_le _) base)
    first shift ranked same
  have floorCount := Terras2Q0Floors.rankNineH92 first runs clock capacity
  have countHeights : (Terras90RankAssembly.valleyHeights N k).countP
      (fun x => decide (x<floor92))≤8 := by
    simp only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def,floor92]
    omega
  have tall : floor92≤xs[8]'(by omega) :=
    sortedFloorOfCount (rank:=8) (by change 8<xs.length; omega) countHeights
  have positive : 0<product (xs.drop 1) := productPositive _ fun x hx =>
    Nat.lt_of_lt_of_le (by decide) (physical x (List.mem_of_mem_drop hx))
  have total : k=2*q0Clock.1 := congrArg Prod.fst clock
  have odd : oddCount N k=2*q0Clock.2 := congrArg Prod.snd clock
  have strict : 3^(oddCount N k)*shiftedProduct floors < 2^k*product floors := by
    rw [odd,total]
    exact Terras90TwiceQ0Numeric.productStrict
  exact TerrasDisplacement.excludeFromEnvelope (by simp [floors,len])
    (envelopeAtRanks len ranked physical tall) positive budget strict

theorem firstDescent {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=clock2) (notEqual : orbit N k≠N)
    (capacity : Terras90.SixRunCapacity 92) :
    orbit N k<N ∧ ∀ i<k, N≤orbit N i := by
  refine ⟨?_,fun _ prior => prior_no_descent first prior⟩
  by_cases descends : orbit N k<N
  · exact descends
  exact (excludesPositiveShift base first runs clock (by omega) capacity).elim

def remaining : List (Nat × Nat) :=
  WeaverWindows90.residualClocks.filter (fun p => decide (p≠clock2))

theorem remainingCount : remaining.length=7 := by decide

/-- The 2Q0 row is removed from the candidates of the existing scaled sieve. -/
theorem removeFromResidual {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=90)
    (shift : N+1≤orbit N k) (capacity : Terras90.SixRunCapacity 92)
    (rows : (k,oddCount N k)∈WeaverWindows90.residualClocks) :
    (k,oddCount N k)∈remaining := by
  simp only [remaining,List.mem_filter,decide_eq_true_eq]
  exact ⟨rows,fun clock => excludesPositiveShift base first runs clock shift capacity⟩

end Terras90TwiceQ0
