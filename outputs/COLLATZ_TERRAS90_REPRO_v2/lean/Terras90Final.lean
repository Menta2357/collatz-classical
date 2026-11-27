import Terras90PhysicalCertified
import Terras90FinalFloors
import Terras90FinalNumeric

namespace Terras90Final

open TerrasClock
open Terras88 (verifiedHeight)
open Terras90Q0Price (product shiftedProduct chronologicalHeights floor92)
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered sortedFloorOfCount)
open Terras90FinalNumeric (floors rows)

set_option maxRecDepth 10000
set_option maxHeartbeats 1200000

private theorem productPositive (xs : List Nat) (positive : ∀ x ∈ xs, 0 < x) :
    0 < product xs := by
  induction xs with
  | nil => decide
  | cons x xs ih =>
    exact Nat.mul_pos (positive x List.mem_cons_self)
      (ih (fun y hy => positive y (List.mem_cons_of_mem _ hy)))

private theorem envelopeAtRanks {xs : List Nat} {low : Nat}
    (len : xs.length = 90) (within : low ≤ 88)
    (ranked : xs.Pairwise (· ≤ ·)) (base : ∀ x ∈ xs, verifiedHeight ≤ x)
    (tall : floor92 ≤ xs[low+1]'(by omega)) :
    ∀ p ∈ (xs.drop 1).zip (floors low), p.2 ≤ p.1 := by
  intro p mem
  obtain ⟨i, hi, item⟩ := List.mem_iff_getElem.mp mem
  have bounds : i < (xs.drop 1).length ∧ i < (floors low).length := by
    simpa only [List.length_zip, Nat.lt_min] using hi
  rw [List.getElem_zip] at item
  rw [← item]
  by_cases early : i < low
  · have side : i < (List.replicate low verifiedHeight).length := by simpa using early
    rw [show (floors low)[i]'bounds.2 = verifiedHeight by
      unfold floors
      rw [List.getElem_append_left side, List.getElem_replicate]]
    exact base _ (List.mem_of_mem_drop (List.getElem_mem bounds.1))
  · have side : (List.replicate low verifiedHeight).length ≤ i := by simp; omega
    rw [show (floors low)[i]'bounds.2 = floor92 by
      unfold floors
      rw [List.getElem_append_right side, List.getElem_replicate]]
    rw [List.getElem_drop]
    apply Terras90Q0Price.floor_tail ranked (r := low+1) (by omega) tall
    rw [List.mem_iff_getElem]
    have inside : i-low < (xs.drop (low+1)).length := by
      simp only [List.length_drop, len] at *
      omega
    exact ⟨i-low, inside, by rw [List.getElem_drop]; congr 1; omega⟩

private theorem excludesFromRank {N k low : Nat} (base : verifiedHeight < N)
    (first : FirstContraction N k) (runs : oddRuns N k = 90)
    (shift : N+1 ≤ orbit N k) (within : low ≤ 88)
    (count : (Terras90RankAssembly.valleyHeights N k).countP
      (fun x => decide (x < floor92)) ≤ low+1)
    (strict : 3^(oddCount N k) * shiftedProduct (floors low) <
      2^k * product (floors low)) : False := by
  let xs := sortedHeights N k
  have same : xs.Perm (chronologicalHeights N k) := sortedHeights_perm N k
  have ranked : xs.Pairwise (· ≤ ·) := sortedHeights_ordered N k
  have len : xs.length = 90 := by
    rw [same.length_eq, chronologicalHeights, List.length_map, Terras88.valleyTimes_length, runs]
  have physical : ∀ x ∈ xs, verifiedHeight ≤ x := fun x hx =>
    Nat.le_trans (Nat.le_of_lt base) (Terras90Q0Price.chronological_lower first x (same.mem_iff.mp hx))
  have budget := TerrasDisplacement.singleDiscount (Nat.lt_of_le_of_lt (Nat.zero_le _) base)
    first shift ranked same
  have tall : floor92 ≤ xs[low+1]'(by omega) :=
    sortedFloorOfCount (rank := low+1) (by change low+1 < xs.length; omega) count
  have positive : 0 < product (xs.drop 1) := productPositive _ fun x hx =>
    Nat.lt_of_lt_of_le (by decide) (physical x (List.mem_of_mem_drop hx))
  have shape : (xs.drop 1).length = (floors low).length := by simp [floors, len]; omega
  exact TerrasDisplacement.excludeFromEnvelope shape
    (envelopeAtRanks len within ranked physical tall) positive budget strict

private theorem tableCompatible : ∀ row ∈ rows,
    row.2 ≤ 88 ∧ Terras90FinalFloors.h92Rank row.1 ≤ row.2+2 := by
  intro row mem
  simp only [rows, List.mem_cons, List.not_mem_nil, or_false] at mem
  rcases mem with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

private theorem lookupRow {clock : Nat × Nat} (row : clock ∈ Terras90TwiceQ0.remaining) :
    ∃ low, (clock, low) ∈ rows := by
  have same : rows.map Prod.fst = Terras90TwiceQ0.remaining := by decide
  rw [← same, List.mem_map] at row
  obtain ⟨⟨_, low⟩, mem, rfl⟩ := row
  exact ⟨low, mem⟩

/-- Exclude all seven clock pairs still admitted by the scaled sieve.
The chronological bounds, strict comparison and cost identity concern the same prefix. -/
theorem excludesResidual {N k : Nat} (base : verifiedHeight < N)
    (first : FirstContraction N k) (runs : oddRuns N k = 90)
    (shift : N+1 ≤ orbit N k) (six92 : Terras90.SixRunCapacity 92)
    (row : (k, oddCount N k) ∈ Terras90TwiceQ0.remaining) : False := by
  obtain ⟨low, mem⟩ := lookupRow row
  obtain ⟨within, rank⟩ := tableCompatible _ mem
  change Terras90FinalFloors.h92Rank (k, oddCount N k) ≤ low+2 at rank
  have small := Terras90FinalFloors.remainingRankH92 first runs row six92
  have count : (Terras90RankAssembly.valleyHeights N k).countP
      (fun x => decide (x < floor92)) ≤ low+1 := by
    simp only [Terras90RankAssembly.valleyHeights, List.countP_map, Function.comp_def, floor92]
    omega
  exact excludesFromRank base first runs shift within count (Terras90FinalNumeric.productStrict mem)

/-- Exclude positive displacement for a physical first crossing with exactly ninety runs. -/
theorem noPositiveShift90 {N k : Nat} (rhin : Terras90Physical.RhinBound)
    (base : verifiedHeight < N) (first : FirstContraction N k)
    (runs : oddRuns N k = 90) (six92 : Terras90.SixRunCapacity 92)
    (six146 : Terras90.SixRunCapacity 146)
    (noWeaver : ¬ Terras88.HasWindow N k Terras88.q0Price Terras90Q0Price.floor146 5) :
    orbit N k ≤ N := by
  by_contra! h
  have shift : N+1 ≤ orbit N k := by omega
  obtain ⟨row, _book⟩ := Terras90Physical.sevenClocksWithRhin rhin base first runs shift
    six92 six146 noWeaver
  exact excludesResidual base first runs shift six92 row

/-- The equality case at exactly ninety runs is a separate input. -/
def NoEqual90 : Prop :=
  ∀ N k, verifiedHeight < N → FirstContraction N k →
    oddRuns N k = 90 → orbit N k ≠ N

/-- Conditional at-most-ninety extension of the Terras first-descent criterion.
It preserves the original seed and certifies all earlier times in that same orbit. -/
theorem firstDescentAtMost90 (prev88 : Terras88.Inputs) (prev89 : Terras89.Inputs89)
    (five92 : Terras89.FiveRunCapacity 92) (five146 : Terras89.FiveRunCapacity 146)
    (six92 : Terras90.SixRunCapacity 92) (six146 : Terras90.SixRunCapacity 146)
    (rhin : Terras90Physical.RhinBound) (noEqual : NoEqual90) {N k : Nat}
    (big : 2 ≤ N) (first : FirstContraction N k) (runs : oddRuns N k ≤ 90) :
    orbit N k < N ∧ ∀ i < k, N ≤ orbit N i := by
  by_cases earlier : oddRuns N k ≤ 89
  · exact Terras89.first_descent89_from_capacities prev88 prev89 five92 five146 big first earlier
  refine ⟨?_, fun _ hi => prior_no_descent first hi⟩
  by_cases low : N ≤ verifiedHeight
  · exact prev88.belowHeight N k big low first
  have base : verifiedHeight < N := by omega
  have exact90 : oddRuns N k = 90 := by omega
  have upper := noPositiveShift90 rhin base first exact90 six92 six146 (prev88.noWeaverQ0 N k)
  exact Nat.lt_of_le_of_ne upper (noEqual N k base first exact90)

end Terras90Final

#print axioms Terras90Final.excludesResidual
#print axioms Terras90Final.noPositiveShift90
#print axioms Terras90Final.firstDescentAtMost90
