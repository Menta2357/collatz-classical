import TerrasLocalProfiles

namespace Terras91Q0Floors

open TerrasClock
open Terras88 (valleyTimes valleyTimes_mem q0Clock)
open TerrasCapacityAbsorption (capacityNum geometricNum scaledWeight)
open TerrasCuts (capacitySixNum capacitySixAbsorption Slice)

set_option maxRecDepth 10000

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

private theorem oddOfManyRuns {N k m : Nat} (first : FirstContraction N k)
    (runs : oddRuns N k = m) (lower : 87 ≤ m) : N%2=1 := by
  have late : 1 < k := by
    by_cases late : 1 < k
    · exact late
    have small : k=0 ∨ k=1 := by omega
    rcases small with zero | one
    · simp [zero,oddRuns] at runs
      omega
    · rw [one] at runs
      cases atZero : startsOddRun N 0 <;> simp [oddRuns,atZero] at runs <;> omega
  by_cases odd : N%2=1
  · exact odd
  · have earlier := first.2 1 late
    simp [oddCount,orbit,odd] at earlier

private theorem raisedGeometric {n : Nat} (room : n≤86) :
    geometricNum 485 306 86 n=306*geometricNum 485 306 85 n := by
  induction n with
  | zero => simp [geometricNum]
  | succ n ih =>
    have exponent : 86-n=(85-n)+1 := by omega
    have weight : scaledWeight 485 306 86 n=306*scaledWeight 485 306 85 n := by
      unfold scaledWeight
      rw [exponent,Nat.pow_succ]
      ac_rfl
    simp only [geometricNum,ih (by omega),weight,Nat.mul_add]

private theorem raisedCapacityNum {n : Nat} (room : n≤89) :
    capacityNum 485 306 86 n=306*capacityNum 485 306 85 n := by
  have mainPower : (306:Nat)^86=306*(306:Nat)^85 := by rw [show 86=85+1 by decide,Nat.pow_succ,Nat.mul_comm]
  have sidePower : (306:Nat)^(86-1)=306*(306:Nat)^(85-1) := by
    change (306:Nat)^(84+1)=306*(306:Nat)^84
    rw [Nat.pow_succ,Nat.mul_comm]
  unfold capacityNum
  split
  · simp
  split
  · rw [mainPower] <;> ac_rfl
  split
  · rw [mainPower] <;> ac_rfl
  split
  · rw [mainPower,sidePower] <;> simp only [Nat.mul_add] <;> ac_rfl
  rw [raisedGeometric (by omega)]
  ac_rfl

private theorem raisedCapacity {n : Nat} (room : n≤90) :
    capacitySixNum 485 306 86 n=306*capacitySixNum 485 306 85 n := by
  unfold capacitySixNum
  apply raisedCapacityNum
  split <;> omega

private theorem totalBoundsEach {xs : List Nat} (positive : ∀ n∈xs, 1≤n)
    {n : Nat} (inside : n∈xs) : n+xs.length≤xs.sum+1 := by
  induction xs with
  | nil => simp at inside
  | cons a rest ih =>
    have tail : ∀ j∈rest, 1≤j := fun j seen => positive j (List.mem_cons_of_mem _ seen)
    simp only [List.length_cons,List.sum_cons]
    rcases List.mem_cons.mp inside with same | later
    · subst n
      have length_le_sum : ∀ (l : List Nat), (∀ j∈l, 1≤j) → l.length≤l.sum := by
        intro l
        induction l with
        | nil => simp
        | cons b l ih =>
          intro pos
          have bh := pos b List.mem_cons_self
          have bl := ih (fun j mem => pos j (List.mem_cons_of_mem _ mem))
          simp only [List.length_cons,List.sum_cons]
          omega
      have lower := length_le_sum rest tail
      omega
    · have bound := ih tail later
      have aPositive := positive a List.mem_cons_self
      omega

private theorem sumCutCapacity {N k scale : Nat} (cap : Nat → Nat) (cuts : List (Slice N k))
    (localBound : ∀ s ∈ cuts, scale*s.odds≤cap s.runs) :
    scale*(cuts.map Slice.odds).sum≤(cuts.map (fun s => cap s.runs)).sum := by
  induction cuts with
  | nil => simp
  | cons s rest ih =>
    have head := localBound s List.mem_cons_self
    have tail := ih (fun slice present => localBound slice (List.mem_cons_of_mem _ present))
    simpa only [List.map_cons,List.sum_cons,Nat.mul_add] using Nat.add_le_add head tail

abbrev paddedArithmetic (H r d : Nat) : Prop :=
  H*(capacitySixNum 485 306 86 (92-r)+(r-1)*capacitySixNum 485 306 86 1+r*(4*306^86))
    < (2*306^86)*d

/-- Widen the receiver to 91 runs by changing the common denominator. With at
least two marked valleys the local slices all fit the frozen 90-run profile. -/
theorem rankFloorOfSix {N k H r d : Nat} (first : FirstContraction N k)
    (runs : oddRuns N k=91) (odds : oddCount N k=d) (multiple : 2≤r) (long : 5*r<91)
    (six : Terras90.SixRunCapacity H) (comparison : paddedArithmetic H r d) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))<r := by
  by_cases enough : r≤(valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))
  · have odd := oddOfManyRuns first runs (by decide)
    obtain ⟨mark,atZero,count,height⟩ := markBelowHeight first odd (by omega) enough
    obtain ⟨cuts,lefts,cutRuns,cutOdds,_⟩ := TerrasCuts.markedPartition mark first odd atZero
    let sizes := cuts.map Slice.runs
    have len : sizes.length=r := by
      have roots := congrArg List.length lefts
      simpa only [sizes,List.length_map,← List.countP_eq_length_filter,count] using roots
    have total : sizes.sum=91 := cutRuns.trans runs
    have positive : ∀ n∈sizes, 1≤n := by
      intro n mem
      obtain ⟨s,_,rfl⟩ := List.mem_map.mp mem
      exact s.runsPositive
    let cap := fun n => capacitySixNum 485 306 86 n+4*306^86
    have localBound (s : Slice N k) (mem : s∈cuts) : (2*306^86)*s.odds≤H*cap s.runs := by
      have marked := (List.mem_filter.mp (lefts ▸ List.mem_map_of_mem mem)).2
      have small := height _ marked
      have sOdd := ((startsOddRun_iff N s.left).mp s.start).1
      have sPositive : 0<orbit N s.left := by omega
      have sMem : s.runs∈sizes := List.mem_map_of_mem mem
      have part := totalBoundsEach positive sMem
      have room : s.runs≤90 := by omega
      have sliceCap := TerrasLocalProfiles.localSixProfileOfSix six (orbit N s.left) s.clock sPositive sOdd small
      change (2*306^85)*s.odds≤H*(capacitySixNum 485 306 85 s.runs+4*306^85) at sliceCap
      have scaled := Nat.mul_le_mul_right 306 sliceCap
      have basePower : (306:Nat)^86=(306:Nat)^85*306 := rfl
      simp only [cap,raisedCapacity room,basePower]
      calc
        _ = ((2*306^85)*s.odds)*306 := by ac_rfl
        _ ≤ (H*(capacitySixNum 485 306 85 s.runs+4*306^85))*306 := scaled
        _ = _ := by simp only [Nat.mul_add,Nat.add_mul]; ac_rfl
    have budget := sumCutCapacity (fun n => H*cap n) cuts localBound
    rw [cutOdds,odds] at budget
    simp only [sizes,List.map_map,Function.comp_def] at budget
    have book : (2*306^86)*d≤(sizes.map (fun n => H*cap n)).sum := by
      simpa only [sizes,List.map_map,Function.comp_def] using budget
    have absorbed := capacitySixAbsorption (p:=485) (q:=306) (M:=86)
      (by decide) (by decide) (by decide) sizes positive (by omega) (by omega)
    have receiver : sizes.sum-sizes.length+1=92-r := by omega
    rw [receiver,len] at absorbed
    simp only [cap,sumMapScale,sumMapPad,len] at book
    have padded := Nat.add_le_add_right absorbed (r*(4*306^86))
    exact ((Nat.not_le_of_gt comparison) (Nat.le_trans book (Nat.mul_le_mul_left H padded))).elim
  · omega

set_option maxHeartbeats 0 in
theorem q0Arithmetic : paddedArithmetic 92 11 q0Clock.2 ∧
    paddedArithmetic 146 12 q0Clock.2 := by decide

theorem q0RankFloors {N k : Nat} (first : FirstContraction N k) (runs : oddRuns N k=91)
    (clock : (k,oddCount N k)=q0Clock) (six92 : Terras90.SixRunCapacity 92)
    (six146 : Terras90.SixRunCapacity 146) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<11 ∧
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^146-1))<12 :=
  ⟨rankFloorOfSix first runs (congrArg Prod.snd clock) (by decide) (by decide) six92 q0Arithmetic.1,
   rankFloorOfSix first runs (congrArg Prod.snd clock) (by decide) (by decide) six146 q0Arithmetic.2⟩

end Terras91Q0Floors

#print axioms Terras91Q0Floors.rankFloorOfSix
#print axioms Terras91Q0Floors.q0Arithmetic
#print axioms Terras91Q0Floors.q0RankFloors

