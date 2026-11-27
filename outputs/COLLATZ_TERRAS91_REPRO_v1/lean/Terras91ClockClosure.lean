import Terras91ClockSieve
import Terras91Products

namespace Terras91ClockClosure

open TerrasClock
open Terras88 (verifiedHeight q0Clock)
open Terras90PublishedCapacity (sixRunCapacities)

theorem tableComplete :
    (Terras91Lattice.survivors.all fun clock =>
      decide (clock=q0Clock) ||
      (Terras91Products.directRows.map Prod.fst).contains clock ||
      (Terras91Products.windowRows.map Prod.fst).contains clock)=true := by decide

/-- All 18 candidate clock pairs, at the physical first coefficient crossing. -/
theorem excludesListedPositiveShift {N k : Nat} (input : Terras91Q0.Inputs)
    (base : verifiedHeight<N) (seed : 2≤N) (first : FirstContraction N k)
    (runs : oddRuns N k=91) (shift : N+1≤orbit N k)
    (listed : (k,oddCount N k)∈Terras91Lattice.survivors) : False := by
  let clock := (k,oddCount N k)
  obtain ⟨s92,s146⟩ := sixRunCapacities input.sevenRuns input.fiveRuns input.guardedH146
  have noWindow := Terras90WeaverEvidence.noWindow input.weaver N k
  have check := List.all_eq_true.mp tableComplete clock listed
  rcases Bool.or_eq_true_iff.mp check with direct | window
  · rcases Bool.or_eq_true_iff.mp direct with zero | price
    · exact Terras91Q0.excludesPositiveShift input.delay noWindow
        s92 s146 seed first runs (of_decide_eq_true zero) shift
    · have h : clock∈Terras91Products.directRows.map Prod.fst := List.contains_iff_mem.mp price
      obtain ⟨⟨p,r⟩,mem,eq⟩ := List.mem_map.mp h
      change p=clock at eq
      rw [eq] at mem
      exact Terras91Products.excludesDirect base first runs shift s92 mem
  · have h : clock∈Terras91Products.windowRows.map Prod.fst := List.contains_iff_mem.mp window
    obtain ⟨⟨p,r⟩,mem,eq⟩ := List.mem_map.mp h
    change p=clock at eq
    rw [eq] at mem
    exact noWindow (Terras91Products.forcesWindow base first runs shift s146 mem)

end Terras91ClockClosure

#print axioms Terras91ClockClosure.tableComplete
#print axioms Terras91ClockClosure.excludesListedPositiveShift
