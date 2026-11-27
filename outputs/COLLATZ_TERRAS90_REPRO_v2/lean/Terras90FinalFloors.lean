import Terras90TwiceQ0

namespace Terras90FinalFloors

open TerrasClock
open Terras88 (valleyTimes valleyTimes_mem)
open Terras90Q0Price (floor92)
open Terras90RankAssembly (sortedHeights sortedFloorOfCount valleyHeights)
open TerrasCuts (capacitySixNum capacitySixAbsorption)

set_option maxRecDepth 8000

private theorem filterSublist {ys xs : List Nat} (sub : ys.Sublist xs) (distinct : xs.Nodup) :
    xs.filter (fun i => decide (i∈ys))=ys := by
  induction sub with
  | slnil => rfl
  | @cons ys xs a sub ih =>
    have noHead : a∉ys := fun h => (List.nodup_cons.mp distinct).1 (sub.subset h)
    simpa [noHead] using ih (List.nodup_cons.mp distinct).2
  | @cons₂ ys xs a _ ih =>
    have nodup := List.nodup_cons.mp distinct
    have predicates : ∀ j ∈ xs, decide (j∈a::ys)=decide (j∈ys) := by
      intro j mem
      have different : j≠a := fun eq => by rw [eq] at mem; exact nodup.1 mem
      simp [different]
    simp only [List.filter_cons,List.mem_cons_self,decide_true,if_true]
    rw [List.filter_congr predicates,ih nodup.2]

private theorem markBelowHeight {N k H r : Nat} (first : FirstContraction N k)
    (odd : N%2=1) (positive : 0<r)
    (many : r≤(valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))) :
    ∃ mark : Nat → Bool, mark 0=true ∧ (valleyTimes N k).countP mark=r ∧
      ∀ i, mark i=true → orbit N i+1<2^H := by
  let times := valleyTimes N k
  let low := times.filter (fun i => decide (orbit N i<2^H-1))
  have order : times.Pairwise (·<·) := List.pairwise_lt_range.filter _
  have len : r≤low.length := by simpa only [List.countP_eq_length_filter] using many
  have least : 0∈low := by
    obtain ⟨i,mem⟩ := List.length_pos_iff_exists_mem.mp (show 0<low.length by omega)
    obtain ⟨valley,height⟩ := List.mem_filter.mp mem
    have baseline := prior_no_descent first (valleyTimes_mem valley).1
    have below := of_decide_eq_true height
    have source : 0∈times := List.mem_filter.mpr ⟨List.mem_range.mpr (first_contraction_pos first),
      (startsOddRun_iff _ _).mpr ⟨odd,Or.inl rfl⟩⟩
    have lowN : N<2^H-1 := by omega
    exact List.mem_filter.mpr ⟨source,decide_eq_true lowN⟩
  let selected := low.take r
  have chosenZero : 0∈selected := by
    have sorted : low.Pairwise (·<·) := order.filter _
    cases eq : low with
    | nil => simp [eq] at least
    | cons i rest =>
      rw [eq] at sorted least
      have initial : i=0 := by
        rcases List.mem_cons.mp least with eq | tail
        · exact eq.symm
        · have impossible := (List.pairwise_cons.mp sorted).1 0 tail
          omega
      cases r with
      | zero => omega
      | succ r => simp [selected,eq,initial]
  have sub : selected.Sublist times := (List.take_sublist _ _).trans List.filter_sublist
  have distinct : times.Nodup := order.imp (fun h => Nat.ne_of_lt h)
  have retained := filterSublist sub distinct
  refine ⟨fun i => decide (i∈selected),decide_eq_true chosenZero,?_,?_⟩
  · rw [List.countP_eq_length_filter,retained]
    simp only [selected,List.length_take,Nat.min_eq_left len]
  · intro i marked
    have inside := List.mem_of_mem_take (of_decide_eq_true marked)
    have bound := of_decide_eq_true (List.mem_filter.mp inside).2
    omega

private theorem sumMapScale (factor : Nat) (cap : Nat → Nat) (sizes : List Nat) :
    (sizes.map (fun n => factor*cap n)).sum=factor*(sizes.map cap).sum := by
  induction sizes with
  | nil => simp
  | cons h t ih => simp [ih,Nat.mul_add]

private theorem sumMapPad (extra : Nat) (cap : Nat → Nat) (sizes : List Nat) :
    (sizes.map (fun n => cap n+extra)).sum=(sizes.map cap).sum+sizes.length*extra := by
  induction sizes with
  | nil => simp
  | cons h t ih =>
    simp only [List.map_cons,List.sum_cons,ih,List.length_cons,Nat.succ_mul]
    omega

-- The sealed 2Q0 module keeps this proof private. The cut construction is the
-- same here, with the rank and the odd count left as parameters.
private theorem rankFloorAtClock {N k H r extra d : Nat}
    (first : FirstContraction N k) (odd : N%2=1) (runs : oddRuns N k=90)
    (odds : oddCount N k=d) (pos : 0<r) (long : 5*r<90)
    (localBound : TerrasCuts.LocalProfile H extra)
    (arithmetic : H*(capacitySixNum 485 306 85 (91-r)+(r-1)*capacitySixNum 485 306 85 1+r*extra)
        < (2*306^85)*d) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))<r := by
  by_cases enough : r≤(valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))
  · obtain ⟨mark,atZero,count,height⟩ := markBelowHeight first odd pos enough
    obtain ⟨sizes,len,positive,total,bound⟩ := TerrasCuts.markedCapacity mark
      (fun n => H*(capacitySixNum 485 306 85 n+extra)) first odd atZero (fun s marked => by
        have rootOdd := ((startsOddRun_iff N s.left).mp s.start).1
        exact localBound _ _ (by omega) rootOdd (height _ marked))
    rw [count] at len
    rw [runs] at total
    rw [odds] at bound
    have absorb := capacitySixAbsorption (p:=485) (q:=306) (M:=85) (by decide) (by decide)
      (by decide) sizes positive (by omega) (by omega)
    have size : sizes.sum-sizes.length+1=91-r := by omega
    rw [sumMapScale,sumMapPad,len] at bound
    rw [size,len] at absorb
    have padded := Nat.add_le_add_right absorb (r*extra)
    exact ((Nat.not_le_of_gt arithmetic) (Nat.le_trans bound (Nat.mul_le_mul_left H padded))).elim
  · omega

private theorem oddAtLateCrossing {N k : Nat} (first : FirstContraction N k) (late : 1<k) : N%2=1 := by
  by_cases odd : N%2=1
  · exact odd
  · have earlier := first.2 1 late
    simp [oddCount,orbit,odd] at earlier

/-- The exact integer comparison needed for the H92 capacity at rank `r`. -/
abbrev h92Arithmetic (r d : Nat) : Prop :=
  92*(capacitySixNum 485 306 85 (91-r)+(r-1)*capacitySixNum 485 306 85 1+
    r*(4*306^85)) < (2*306^85)*d

/-- Every candidate with `r` low valleys would contradict the H92 clock
comparison. The marked cuts retain the original first-contraction prefix. -/
theorem rankFloorH92 {N k r d : Nat} (first : FirstContraction N k)
    (runs : oddRuns N k=90) (odds : oddCount N k=d) (pos : 0<r) (long : 5*r<90)
    (six92 : Terras90.SixRunCapacity 92) (arithmetic : h92Arithmetic r d) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<r := by
  have late : 1<k := by
    by_cases late : 1<k
    · exact late
    have small : k=0 ∨ k=1 := by omega
    rcases small with zero | one
    · simp [zero,oddRuns] at runs
    · rw [one] at runs
      cases atZero : startsOddRun N 0 <;> simp [oddRuns,atZero] at runs
  exact rankFloorAtClock first (oddAtLateCrossing first late) runs odds pos long
    (TerrasLocalProfiles.localSixProfileOfSix six92) arithmetic

/-- One-based H92 rank for each of the seven residual clocks. -/
def h92Rank (p : Nat × Nat) : Nat :=
  if p=(7984791619272937798,5037842608667313239) then 5
  else if p=(22064020121241819099,13920846777890779368) then 3
  else if p=(29418693494989092132,18561129037187705824) then 2
  else 1

set_option maxHeartbeats 0 in
theorem remainingH92Table :
    Terras90TwiceQ0.remaining.all (fun p =>
      decide (0<h92Rank p ∧ 5*h92Rank p<90 ∧ h92Arithmetic (h92Rank p) p.2))=true := by
  decide

theorem rowH92Arithmetic {p : Nat × Nat} (row : p∈Terras90TwiceQ0.remaining) :
    0<h92Rank p ∧ 5*h92Rank p<90 ∧ h92Arithmetic (h92Rank p) p.2 :=
  of_decide_eq_true (List.all_eq_true.mp remainingH92Table p row)

/-- In the residual clock table, fewer than the prescribed rank's valleys
lie below H92. Every valley is counted with its occurrence in the prefix. -/
theorem remainingRankH92 {N k : Nat} (first : FirstContraction N k)
    (runs : oddRuns N k=90) (row : (k,oddCount N k)∈Terras90TwiceQ0.remaining)
    (six92 : Terras90.SixRunCapacity 92) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<
      h92Rank (k,oddCount N k) := by
  obtain ⟨positive,long,arith⟩ := rowH92Arithmetic row
  exact rankFloorH92 first runs rfl positive long six92 arith

/-- The same H92 floor in the sorted valley heights, at a zero-based rank. -/
theorem remainingSortedFloorH92 {N k i : Nat} (first : FirstContraction N k)
    (runs : oddRuns N k=90) (row : (k,oddCount N k)∈Terras90TwiceQ0.remaining)
    (six92 : Terras90.SixRunCapacity 92) (within : i<(sortedHeights N k).length)
    (atOrAfter : h92Rank (k,oddCount N k)≤i+1) :
    floor92≤(sortedHeights N k)[i] := by
  have count := remainingRankH92 first runs row six92
  apply sortedFloorOfCount within
  simp only [valleyHeights,List.countP_map,Function.comp_def,floor92]
  omega

end Terras90FinalFloors
