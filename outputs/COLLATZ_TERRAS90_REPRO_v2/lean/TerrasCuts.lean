import Terras90
import TerrasCapacityAbsorption

namespace TerrasCuts

open TerrasClock
open Terras88 (valleyTimes valleyTimes_mem)
open TerrasCapacityAbsorption (capacityNum capacityNum_absorption)

/-- A cut at an actual valley preserves the run count of each side. -/
theorem oddRunsAddAtValley {N p : Nat} (start : startsOddRun N p = true) (q : Nat) :
    oddRuns N (p+q) = oddRuns N p + oddRuns (orbit N p) q := by
  by_cases zero : p=0
  · subst p
    simp [oddRuns,orbit]
  have previous : orbit N (p-1)%2=0 := by
    rcases (startsOddRun_iff N p).mp start |>.2 with h | h
    · exact (zero h).elim
    · exact h
  induction q with
  | zero => simp [oddRuns]
  | succ q ih =>
    rw [Nat.add_succ,oddRuns_succ,oddRuns_succ,ih,orbit_add N p q]
    have before :
        (p+q=0 ∨ orbit N (p+q-1)%2=0) ↔
        (q=0 ∨ orbit (orbit N p) (q-1)%2=0) := by
      by_cases initial : q=0
      · subst q
        simp [previous]
      · rw [show p+q-1=p+(q-1) by omega,orbit_add]
        simp [initial,show p+q≠0 by omega]
    simp only [before,Nat.add_assoc]

/-- The chronological slice starts at a valley and ends after an even
source. Its last even gap may be truncated at the first contraction. -/
structure Slice (N k : Nat) where
  left : Nat
  right : Nat
  forward : left<right
  within : right≤k
  start : startsOddRun N left=true
  lastEven : orbit N (right-1)%2=0

def Slice.clock {N k : Nat} (s : Slice N k) : Nat := s.right-s.left
def Slice.runs {N k : Nat} (s : Slice N k) : Nat := oddRuns (orbit N s.left) s.clock
def Slice.odds {N k : Nat} (s : Slice N k) : Nat := oddCount (orbit N s.left) s.clock

theorem Slice.book {N k : Nat} (s : Slice N k) :
    2^s.clock*orbit N s.right = 3^s.odds*orbit N s.left+additive (orbit N s.left) s.clock := by
  have split : s.left+s.clock=s.right := by unfold Slice.clock; have := s.forward; omega
  have endEq := orbit_add N s.left s.clock
  rw [split] at endEq
  rw [endEq]
  exact exact_book _ _

theorem Slice.historyCost {N k : Nat} (s : Slice N k) :
    additive N s.right = 3^s.odds*additive N s.left+2^s.left*additive (orbit N s.left) s.clock := by
  have split : s.left+s.clock=s.right := by unfold Slice.clock; have := s.forward; omega
  simpa only [split,Slice.odds] using additive_add N s.left s.clock

private theorem oddRunsPositive {x k : Nat} (odd : x%2=1) (clock : 0<k) : 0<oddRuns x k := by
  induction k with
  | zero => omega
  | succ k ih =>
    by_cases zero : k=0
    · subst k
      simp [oddRuns,startsOddRun,orbit,odd]
    · have prev := ih (by omega)
      rw [oddRuns_succ]
      omega

theorem Slice.runsPositive {N k : Nat} (s : Slice N k) : 0<s.runs :=
  oddRunsPositive ((startsOddRun_iff N s.left).mp s.start).1
    (by unfold Slice.clock; have := s.forward; omega)

theorem Slice.leftMem {N k : Nat} (s : Slice N k) : s.left∈valleyTimes N k :=
  List.mem_filter.mpr ⟨List.mem_range.mpr (Nat.lt_of_lt_of_le s.forward s.within),s.start⟩

private theorem countsAtSlice {N k : Nat} (s : Slice N k) :
    oddRuns N s.right = oddRuns N s.left+s.runs ∧
    oddCount N s.right = oddCount N s.left+s.odds ∧ s.left+s.clock=s.right := by
  have split : s.left+s.clock=s.right := by unfold Slice.clock; have := s.forward; omega
  exact ⟨by simpa only [split,Slice.runs] using oddRunsAddAtValley s.start s.clock,
    by simpa only [split,Slice.odds] using oddCount_add N s.left s.clock, split⟩

private theorem previousEven {N i : Nat} (pos : 0<i) (start : startsOddRun N i=true) :
    orbit N (i-1)%2=0 := by
  rcases ((startsOddRun_iff N i).mp start).2 with zero | even
  · omega
  · exact even

private theorem partitionFrom {N k i : Nat} {rest : List Nat}
    (head : i∈valleyTimes N k) (all : ∀ j ∈ rest, j∈valleyTimes N k)
    (order : (i::rest).Pairwise (·<·)) (even : orbit N (k-1)%2=0) :
    ∃ cuts : List (Slice N k), cuts.map Slice.left=i::rest ∧ cuts.map Slice.right=rest++[k] ∧
      oddRuns N i+(cuts.map Slice.runs).sum=oddRuns N k ∧
      oddCount N i+(cuts.map Slice.odds).sum=oddCount N k ∧ i+(cuts.map Slice.clock).sum=k := by
  induction rest generalizing i with
  | nil =>
    let s : Slice N k := ⟨i,k,(valleyTimes_mem head).1,Nat.le_refl _,(valleyTimes_mem head).2,even⟩
    obtain ⟨runs,odds,clock⟩ := countsAtSlice s
    exact ⟨[s],rfl,rfl,by simpa [s] using runs.symm,by simpa [s] using odds.symm,by simpa [s] using clock⟩
  | cons j rest ih =>
    have jmem := all j List.mem_cons_self
    have before := (List.pairwise_cons.mp order).1 j List.mem_cons_self
    let s : Slice N k := ⟨i,j,before,Nat.le_of_lt (valleyTimes_mem jmem).1,(valleyTimes_mem head).2,
      previousEven (by omega) (valleyTimes_mem jmem).2⟩
    obtain ⟨cuts,lefts,rights,runs,odds,clocks⟩ := ih jmem
      (fun t ht => all t (List.mem_cons_of_mem _ ht)) (List.pairwise_cons.mp order).2
    obtain ⟨partRuns,partOdds,partClock⟩ := countsAtSlice s
    change oddRuns N j = oddRuns N i+s.runs at partRuns
    change oddCount N j = oddCount N i+s.odds at partOdds
    change i+s.clock=j at partClock
    refine ⟨s::cuts,by simp [s,lefts],by simp [s,rights],?_,?_,?_⟩ <;>
      simp only [List.map_cons,List.sum_cons] <;> omega

/-- Marked valleys retain physical ordering and multiplicities. Each odd
run is complete inside its cut, even when the final gap is cut short. -/
theorem markedPartition {N k : Nat} (mark : Nat → Bool) (first : FirstContraction N k)
    (odd : N%2=1) (markZero : mark 0=true) :
    ∃ cuts : List (Slice N k), cuts.map Slice.left=(valleyTimes N k).filter mark ∧
      (cuts.map Slice.runs).sum=oddRuns N k ∧ (cuts.map Slice.odds).sum=oddCount N k ∧
      (cuts.map Slice.clock).sum=k := by
  have pos := first_contraction_pos first
  have even : orbit N (k-1)%2=0 := by
    apply first_contraction_last_even
    simpa only [Nat.sub_add_cancel (show 1≤k by omega)] using first
  have before : (valleyTimes N k).Pairwise (·<·) :=
    List.pairwise_lt_range.filter _
  have monotone := before.filter mark
  have zeroMem : 0∈(valleyTimes N k).filter mark := by
    apply List.mem_filter.mpr
    refine ⟨List.mem_filter.mpr ⟨List.mem_range.mpr pos,?_⟩,markZero⟩
    exact (startsOddRun_iff _ _).mpr ⟨odd,Or.inl rfl⟩
  cases eq : (valleyTimes N k).filter mark with
  | nil => simp [eq] at zeroMem
  | cons i rest =>
    rw [eq] at monotone zeroMem
    have izero : i=0 := by
      rcases List.mem_cons.mp zeroMem with same | tail
      · exact same.symm
      · have impossible := (List.pairwise_cons.mp monotone).1 0 tail
        omega
    subst i
    have all : ∀ j ∈ 0::rest, j∈valleyTimes N k := by
      intro j mem
      rw [← eq] at mem
      exact (List.mem_filter.mp mem).1
    obtain ⟨cuts,lefts,_,runs,odds,clocks⟩ := partitionFrom (all 0 List.mem_cons_self)
      (fun j mem => all j (List.mem_cons_of_mem _ mem)) monotone even
    exact ⟨cuts,lefts,by simpa [oddRuns] using runs,by simpa [oddCount] using odds,by simpa using clocks⟩

private theorem sumCapacity {N k scale : Nat} (cap : Nat → Nat) (cuts : List (Slice N k))
    (localBound : ∀ s ∈ cuts, scale*s.odds≤cap s.runs) :
    scale*(cuts.map Slice.odds).sum≤(cuts.map (fun s => cap s.runs)).sum := by
  induction cuts with
  | nil => simp
  | cons s cuts ih =>
    have first := localBound s List.mem_cons_self
    have tail := ih (fun part mem => localBound part (List.mem_cons_of_mem _ mem))
    simpa only [List.map_cons,List.sum_cons,Nat.mul_add] using Nat.add_le_add first tail

/-- Sum supplied local capacities on the actual cut lengths. The root list
is a filter of indices, so equal state values keep their multiplicity. -/
theorem markedCapacity {N k scale : Nat} (mark : Nat → Bool) (cap : Nat → Nat)
    (first : FirstContraction N k) (odd : N%2=1) (markZero : mark 0=true)
    (localBound : ∀ s : Slice N k, mark s.left=true → scale*s.odds≤cap s.runs) :
    ∃ sizes : List Nat, sizes.length=(valleyTimes N k).countP mark ∧
      (∀ n ∈ sizes, 1≤n) ∧ sizes.sum=oddRuns N k ∧
      scale*oddCount N k≤(sizes.map cap).sum := by
  obtain ⟨cuts,lefts,runs,odds,_⟩ := markedPartition mark first odd markZero
  refine ⟨cuts.map Slice.runs,?_,?_,runs,?_⟩
  · have length := congrArg List.length lefts
    simpa only [List.length_map,List.countP_eq_length_filter] using length
  · intro n member
    obtain ⟨slice,_,eq⟩ := List.mem_map.mp member
    rw [← eq]
    exact slice.runsPositive
  · have localSum := sumCapacity cap cuts (fun slice mem =>
      localBound slice ((List.mem_filter.mp (lefts ▸ List.mem_map_of_mem mem)).2))
    simpa only [odds,List.map_map,Function.comp_def] using localSum

theorem q0Odd {N k : Nat} (Q : Terras90.DeltaOneQ0 N k) : N%2=1 := by
  rcases Nat.mod_two_eq_zero_or_one N with even | odd
  · have clock := congrArg Prod.fst Q.clock
    change k=630118245525664765 at clock
    have prior := Q.first.2 1 (by omega)
    have notOdd : ¬N%2=1 := by omega
    simp [oddCount,orbit,notOdd] at prior
  · exact odd

/-- Q0 instance of the physical partition, with its exact run and odd counts. -/
theorem q0MarkedCapacity {N k scale : Nat} (Q : Terras90.DeltaOneQ0 N k)
    (mark : Nat → Bool) (cap : Nat → Nat) (markZero : mark 0=true)
    (localBound : ∀ s : Slice N k, mark s.left=true → scale*s.odds≤cap s.runs) :
    ∃ sizes : List Nat, sizes.length=(valleyTimes N k).countP mark ∧
      (∀ n ∈ sizes, 1≤n) ∧ sizes.sum=90 ∧
      scale*397560349370386783≤(sizes.map cap).sum := by
  have count := congrArg Prod.snd Q.clock
  change oddCount N k=397560349370386783 at count
  simpa only [Q.runs,count] using markedCapacity mark cap Q.first (q0Odd Q) markZero localBound

/-- The six-run profile keeps the one- and two-run caps and delays the
geometric recurrence by one run. -/
def capacitySixNum (p q M n : Nat) : Nat :=
  capacityNum p q M (if 6≤n then n-1 else min n 4)

theorem capacitySix_le_five (p q M n : Nat) : capacitySixNum p q M n≤capacityNum p q M n := by
  have longDef (i : Nat) (h : 5≤i) : capacityNum p q M i=
      2*TerrasCapacityAbsorption.geometricNum p q M (i-3) := by
    simp [capacityNum,show i≠0 by omega,show i≠1 by omega,show i≠2 by omega,show ¬i≤4 by omega]
  by_cases long : 6≤n
  · simp only [capacitySixNum,if_pos long,longDef (n-1) (by omega),longDef n (by omega)]
    rw [show n-3=(n-1-3)+1 by omega]
    simp only [TerrasCapacityAbsorption.geometricNum]
    omega
  by_cases short : n≤4
  · simp [capacitySixNum,long,Nat.min_eq_left short]
  have five : n=5 := by omega
  subst n
  simp [capacitySixNum,capacityNum,TerrasCapacityAbsorption.geometricNum,TerrasCapacityAbsorption.scaledWeight]

private theorem sumsLe {f g : Nat → Nat} (h : ∀ n, f n≤g n) (sizes : List Nat) :
    (sizes.map f).sum≤(sizes.map g).sum := by
  induction sizes with
  | nil => simp
  | cons n sizes ih =>
    simp only [List.map_cons,List.sum_cons]
    exact Nat.add_le_add (h n) ih

private theorem sumLeFive (sizes : List Nat) (short : ∀ n ∈ sizes, n≤5) :
    sizes.sum≤5*sizes.length := by
  induction sizes with
  | nil => simp
  | cons n sizes ih =>
    have tail := ih (fun j mem => short j (List.mem_cons_of_mem _ mem))
    have head := short n List.mem_cons_self
    simp only [List.sum_cons,List.length_cons]
    omega

private theorem sumAppend (left right : List Nat) : (left++right).sum=left.sum+right.sum := by
  induction left with
  | nil => simp
  | cons a rest ih => simp [ih,Nat.add_assoc]

/-- Lower only the receiver length when reusing the sealed five-run
absorption theorem. All actual sizes and donor multiplicities are kept. -/
theorem capacitySixAbsorption {p q M : Nat} (hq : 0<q) (ratio : q≤p) (hM : 1≤M)
    (sizes : List Nat) (positive : ∀ n ∈ sizes, 1≤n) (longEnough : 5*sizes.length<sizes.sum)
    (budget : sizes.sum≤M+5) :
    (sizes.map (capacitySixNum p q M)).sum≤
      capacitySixNum p q M (sizes.sum-sizes.length+1)+(sizes.length-1)*capacitySixNum p q M 1 := by
  have someLong : ∃ n ∈ sizes, 6≤n := by
    by_cases found : ∃ n ∈ sizes, 6≤n
    · exact found
    have small : ∀ n ∈ sizes, n≤5 := fun n mem => by
      by_cases large : 6≤n
      · exact (found ⟨n,mem,large⟩).elim
      · omega
    have short := sumLeFive sizes small
    omega
  obtain ⟨L,mem,long⟩ := someLong
  obtain ⟨left,right,split,_⟩ := List.eq_append_cons_of_mem mem
  let donors := left++right
  let lowered := (L-1)::donors
  have nonempty : 0<lowered.length := by simp [lowered]
  have length : lowered.length=sizes.length := by
    rw [split]
    simp only [lowered,donors,List.length_cons,List.length_append]
    omega
  have total : lowered.sum+1=sizes.sum := by
    rw [split]
    simp only [lowered,donors,List.sum_cons,sumAppend]
    omega
  have donorPositive : ∀ n ∈ lowered, 1≤n := by
    intro n present
    rcases List.mem_cons.mp present with eq | others
    · rw [eq]
      omega
    · apply positive n
      rw [split]
      rcases List.mem_append.mp others with hl | hr
      · exact List.mem_append_left _ hl
      · exact List.mem_append_right _ (List.mem_cons_of_mem _ hr)
  have compare : (sizes.map (capacitySixNum p q M)).sum≤(lowered.map (capacityNum p q M)).sum := by
    have donorBound := sumsLe (capacitySix_le_five p q M) donors
    rw [split]
    simp only [List.map_append,List.map_cons,sumAppend,List.sum_cons,lowered]
    rw [show capacitySixNum p q M L=capacityNum p q M (L-1) by simp [capacitySixNum,long]]
    simp only [donors,List.map_append,sumAppend] at donorBound ⊢
    omega
  have collapsed := capacityNum_absorption hq ratio hM lowered donorPositive
    (by omega) (by omega)
  have idx : lowered.sum-lowered.length+1=sizes.sum-sizes.length+1-1 := by omega
  have longFinal : 6≤sizes.sum-sizes.length+1 := by omega
  have unit : capacitySixNum p q M 1=capacityNum p q M 1 := rfl
  rw [idx,length] at collapsed
  rw [show capacitySixNum p q M (sizes.sum-sizes.length+1)=
    capacityNum p q M (sizes.sum-sizes.length+1-1) by simp [capacitySixNum,longFinal],unit]
  exact Nat.le_trans compare collapsed

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

private theorem markBelowHeight {N k H r : Nat} (Q : Terras90.DeltaOneQ0 N k) (positive : 0<r)
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
    have baseline := prior_no_descent Q.first (valleyTimes_mem valley).1
    have below := of_decide_eq_true height
    have source : 0∈times := List.mem_filter.mpr ⟨List.mem_range.mpr (first_contraction_pos Q.first),
      (startsOddRun_iff _ _).mpr ⟨q0Odd Q,Or.inl rfl⟩⟩
    have lowN : N<2^H-1 := by omega
    exact List.mem_filter.mpr ⟨source,decide_eq_true lowN⟩
  let selected := low.take r
  have chosenZero : 0∈selected := by
    have sorted : low.Pairwise (·<·) := order.filter _
    cases eq : low with
    | nil => simp [eq] at least
    | cons i rest =>
      rw [eq] at sorted least
      have first : i=0 := by
        rcases List.mem_cons.mp least with eq | tail
        · exact eq.symm
        · have impossible := (List.pairwise_cons.mp sorted).1 0 tail
          omega
      cases r with
      | zero => omega
      | succ r => simp [selected,eq,first]
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

set_option exponentiation.threshold 512 in
theorem alpha_upper : (3:Nat)^306≤2^485 := by decide

/-- The only local premise for rank floors. It is a capacity for the real
odd counts of small positive valleys, in units of 2 * 306^85. -/
def LocalProfile (H extra : Nat) : Prop :=
  ∀ x t, 0<x → x%2=1 → x+1<2^H →
    (2*306^85)*oddCount x t≤H*(capacitySixNum 485 306 85 (oddRuns x t)+extra)

abbrev LocalSixProfile (H : Nat) := LocalProfile H 0
abbrev LocalSixProfilePadded (H : Nat) := LocalProfile H (4*306^85)

private theorem rankFloor {N k H r extra : Nat} (Q : Terras90.DeltaOneQ0 N k) (pos : 0<r)
    (long : 5*r<90) (localBound : LocalProfile H extra)
    (arithmetic : H*(capacitySixNum 485 306 85 (91-r)+(r-1)*capacitySixNum 485 306 85 1+r*extra)
        < (2*306^85)*397560349370386783) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))<r := by
  by_cases enough : r≤(valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))
  · obtain ⟨mark,first,count,height⟩ := markBelowHeight Q pos enough
    obtain ⟨sizes,len,positive,total,bound⟩ := q0MarkedCapacity Q mark
      (fun n => H*(capacitySixNum 485 306 85 n+extra)) first (fun s marked => by
        have odd := ((startsOddRun_iff N s.left).mp s.start).1
        exact localBound _ _ (by omega) odd (height _ marked))
    rw [count] at len
    have absorb := capacitySixAbsorption (p:=485) (q:=306) (M:=85) (by decide) (by decide)
      (by decide) sizes positive (by omega) (by omega)
    have size : sizes.sum-sizes.length+1=91-r := by omega
    rw [sumMapScale,sumMapPad,len] at bound
    rw [size,len] at absorb
    have padded := Nat.add_le_add_right absorb (r*extra)
    exact ((Nat.not_le_of_gt arithmetic) (Nat.le_trans bound (Nat.mul_le_mul_left H padded))).elim
  · omega

/-- Fewer than ten valley starts are below the H92 floor, and fewer than
eleven are below the H146 floor. The comparisons are exact naturals. -/
theorem q0RankFloors {N k : Nat} (Q : Terras90.DeltaOneQ0 N k)
    (at92 : LocalSixProfile 92) (at146 : LocalSixProfile 146) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<10 ∧
      (valleyTimes N k).countP (fun i => decide (orbit N i<2^146-1))<11 :=
  ⟨rankFloor Q (by decide) (by decide) at92 (by decide),
    rankFloor Q (by decide) (by decide) at146 (by decide)⟩

/-- Both exact margins survive a uniform extra 2H per slice. -/
theorem q0RankFloorsPadded {N k : Nat} (Q : Terras90.DeltaOneQ0 N k)
    (at92 : LocalSixProfilePadded 92) (at146 : LocalSixProfilePadded 146) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<10 ∧
      (valleyTimes N k).countP (fun i => decide (orbit N i<2^146-1))<11 :=
  ⟨rankFloor Q (by decide) (by decide) at92 (by decide),
    rankFloor Q (by decide) (by decide) at146 (by decide)⟩

end TerrasCuts
