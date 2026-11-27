import TerrasCuts

namespace Terras90WeaverEvidence

open TerrasClock
open Terras88 (HasWindow valleyTimes valleyTimes_length valleyTimes_mem verifiedHeight)

/-- Weaver's finite query on a segment of the shortcut map, starting at
an odd source and ending at a valley after one to `span` complete blocks. -/
def ReachesHighValley (price height span : Nat) : Prop :=
  ∃ x t, x % 2 = 1 ∧ verifiedHeight < x ∧ x < price ∧ 0 < t ∧
    startsOddRun x t = true ∧ 0 < oddRuns x t ∧ oddRuns x t ≤ span ∧
    (∀ j ≤ t, startsOddRun x j = true → x ≤ orbit x j) ∧ height ≤ orbit x t

private theorem valleysBefore {N k t : Nat} (within : t ≤ k) :
    (valleyTimes N k).filter (fun i => decide (i < t)) = valleyTimes N t := by
  induction k with
  | zero => have eq : t = 0 := by omega
            simp [eq, valleyTimes]
  | succ k ih =>
    by_cases atEnd : t = k+1
    · subst t
      exact List.filter_eq_self.mpr fun _ mem => decide_eq_true ((valleyTimes_mem mem).1)
    have prev : t ≤ k := by omega
    have append : valleyTimes N (k+1) = valleyTimes N k ++ [k].filter (startsOddRun N) := by
      simp [valleyTimes, List.range_succ, List.filter_append]
    rw [append, List.filter_append, ih prev]
    have empty : ([k].filter (startsOddRun N)).filter (fun i => decide (i<t)) = [] := by
      cases h : startsOddRun N k <;> simp [h, show ¬k<t by omega]
    simp [empty]

private theorem beforeOfSplit {N k t : Nat} {left right : List Nat}
    (split : valleyTimes N k = left ++ t :: right) : valleyTimes N t = left := by
  have inside : t ∈ valleyTimes N k := by rw [split]; simp
  have ordered : (left ++ t :: right).Pairwise (· < ·) := by
    rw [← split]
    exact List.pairwise_lt_range.filter _
  have separated := List.pairwise_append.mp ordered
  have early : left.filter (fun i => decide (i<t)) = left :=
    List.filter_eq_self.mpr fun i mem => decide_eq_true (separated.2.2 i mem t (by simp))
  have late : (t :: right).filter (fun i => decide (i<t)) = [] := by
    apply List.filter_eq_nil_iff.mpr
    intro i mem
    rcases List.mem_cons.mp mem with rfl | tail
    · simp
    · have after := (List.pairwise_cons.mp separated.2.1).1 i tail
      simp [show ¬i<t by omega]
  rw [← valleysBefore (Nat.le_of_lt (valleyTimes_mem inside).1), split,
    List.filter_append, early, late, List.append_nil]

private theorem shiftStart {N z : Nat} (root : startsOddRun N z = true) (j : Nat) :
    startsOddRun (orbit N z) j = true ↔ startsOddRun N (z+j) = true := by
  cases j with
  | zero =>
    rw [Nat.add_zero, root]
    simp [startsOddRun, orbit, (startsOddRun_iff N z |>.mp root).1]
  | succ j =>
    rw [startsOddRun_iff, startsOddRun_iff, ← orbit_add N z (j+1)]
    rw [show z+(j+1)-1=z+j by omega, show j+1-1=j by omega, ← orbit_add N z j]
    simp [show z+(j+1)≠0 by omega]

/-- A ranked window yields the published bounded query. The local source
and terminal are explicit occurrences of the original physical history. -/
theorem queryOfWindow {N k price height span : Nat} (window : HasWindow N k price height span) :
    ReachesHighValley price height span := by
  obtain ⟨pre,z,run,post,i,split,base,priced,spanEq,safe,inside,high⟩ := window
  obtain ⟨middle,tail,parts⟩ := List.append_of_mem inside
  have beforeZ := beforeOfSplit split
  have splitI : valleyTimes N k = (pre ++ z :: middle) ++ i :: (tail ++ post) := by
    rw [split,parts]
    simp [List.append_assoc]
  have beforeI := beforeOfSplit splitI
  have zIn : z ∈ valleyTimes N i := by rw [beforeI]; simp
  have zi := (valleyTimes_mem zIn).1
  have root := (valleyTimes_mem zIn).2
  have iIn : i ∈ valleyTimes N k := by rw [splitI]; simp
  let t := i-z
  have zt : z+t=i := by omega
  have count := TerrasCuts.oddRunsAddAtValley root t
  rw [zt, ← valleyTimes_length, beforeI, List.length_append, List.length_cons,
    ← valleyTimes_length, beforeZ] at count
  have duration : oddRuns (orbit N z) t = middle.length+1 := by omega
  have visited : middle.length+1 ≤ span := by
    rw [parts, List.length_append, List.length_cons] at spanEq
    omega
  refine ⟨orbit N z,t,(startsOddRun_iff N z |>.mp root).1,base,priced,by omega,
    (shiftStart root t).mpr (by rw [zt]; exact (valleyTimes_mem iIn).2),
    by omega,by omega,?_,by rwa [← orbit_add,zt]⟩
  intro j hj atValley
  by_cases endTime : j=t
  · subst j
    rw [← orbit_add,zt]
    exact safe i inside
  have start := (shiftStart root j).mp atValley
  have global : z+j ∈ valleyTimes N i :=
    List.mem_filter.mpr ⟨List.mem_range.mpr (by omega),start⟩
  rw [beforeI,List.mem_append,List.mem_cons] at global
  rw [← orbit_add]
  rcases global with inPre | eq | mid
  · have inBefore : z+j ∈ valleyTimes N z := by rwa [beforeZ]
    have earlier := (valleyTimes_mem inBefore).1
    omega
  · simp [eq]
  · exact safe _ (by rw [parts]; exact List.mem_append_left _ mid)

/-- Transfer a native finite exclusion with an inclusive source cap `price-1`
to the original-orbit condition used by the Terras consumers. -/
theorem noWindow {price height span : Nat} (external : ¬ ReachesHighValley price height span)
    (N k : Nat) : ¬ HasWindow N k price height span :=
  fun window => external (queryOfWindow window)

end Terras90WeaverEvidence

#print axioms Terras90WeaverEvidence.queryOfWindow
#print axioms Terras90WeaverEvidence.noWindow
