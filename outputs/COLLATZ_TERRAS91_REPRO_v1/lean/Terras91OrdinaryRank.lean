import TerrasUniformRanks
import Terras91ClockSieve

namespace Terras91OrdinaryRank

open TerrasClock
open TerrasOrdinaryRank
open Terras88 (valleyTimes valleyTimes_mem valleyTimes_length)
open Terras91Lattice (roundedCapacity rationalNumerator)
open TerrasCuts (Slice)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

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

private theorem markBelowHeight {N k W r : Nat} (first : FirstContraction N k)
    (odd : N%2=1) (positive : 0<r)
    (many : r≤(valleyTimes N k).countP (fun i => decide (orbit N i≤W))) :
    ∃ mark : Nat → Bool, mark 0=true ∧ (valleyTimes N k).countP mark=r ∧
      ∀ i, mark i=true → orbit N i≤W := by
  let times := valleyTimes N k
  let low := times.filter (fun i => decide (orbit N i≤W))
  have order : times.Pairwise (·<·) := List.pairwise_lt_range.filter _
  have len : r≤low.length := by simpa only [List.countP_eq_length_filter] using many
  have least : 0∈low := by
    obtain ⟨i,mem⟩ := List.length_pos_iff_exists_mem.mp (show 0<low.length by omega)
    obtain ⟨valley,height⟩ := List.mem_filter.mp mem
    have baseline := prior_no_descent first (valleyTimes_mem valley).1
    have below := of_decide_eq_true height
    have source : 0∈times := List.mem_filter.mpr ⟨List.mem_range.mpr (first_contraction_pos first),
      (startsOddRun_iff _ _).mpr ⟨odd,Or.inl rfl⟩⟩
    have lowN : N≤W := by omega
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

private theorem geomFraction (n : Nat) : geom n=(rationalNumerator n : ℝ)/(1000:ℝ)^n := by
  induction n with
  | zero => simp [geom,rationalNumerator]
  | succ n ih =>
    rw [geom,rationalNumerator,ih]
    simp only [Nat.cast_add,Nat.cast_mul,Nat.cast_pow,Nat.cast_ofNat]
    rw [pow_succ (1000:ℝ) n]
    unfold alpha
    field_simp
    ring

private theorem capacityLeRounded (r : Nat) :
    geom (92-r)+(r-1 : Nat)≤(roundedCapacity r : ℝ) := by
  let den := 1000^(92-r)
  let total := rationalNumerator (92-r)+(r-1)*den
  have denPos : 0<den := by dsimp [den]; positivity
  have denPosR : 0<(den : ℝ) := by exact_mod_cast denPos
  have round : roundedCapacity r=(total+den-1)/den := rfl
  have ceil : total≤roundedCapacity r*den := by
    have split := Nat.mod_add_div (total+den-1) den
    have rem := Nat.mod_lt (total+den-1) denPos
    rw [←round,mul_comm den] at split
    omega
  calc
    _ = (total : ℝ)/(den : ℝ) := by
      rw [geomFraction]
      simp only [total,Nat.cast_add,Nat.cast_mul]
      have denominator : (den : ℝ)=(1000:ℝ)^(92-r) := by simp [den]
      rw [←denominator]
      rw [add_div,mul_div_cancel_right₀ _ denPosR.ne']
    _ ≤ _ := (div_le_iff₀ denPosR).mpr (by exact_mod_cast ceil)

private theorem sliceSumLe {N k : Nat} (cuts : List (Slice N k)) (W : Nat)
    (allHeights : ∀ s ∈ cuts, orbit N s.left≤W) :
    ((cuts.map Slice.odds).sum : ℝ)≤(cuts.map (fun s => geom s.runs)).sum*logHeight W := by
  induction cuts with
  | nil => simp
  | cons s cuts ih =>
    have odd := ((startsOddRun_iff N s.left).mp s.start).1
    have localBound := localLogCapacity (t:=s.clock) odd
    have floor := logHeight_mono (allHeights s List.mem_cons_self)
    have tagged : (s.odds : ℝ)≤geom s.runs*logHeight W :=
      localBound.trans (mul_le_mul_of_nonneg_left floor (geom_nonneg _))
    have tail := ih (fun s mem => allHeights s (List.mem_cons_of_mem _ mem))
    simp only [List.map_cons,List.sum_cons,Nat.cast_add,add_mul]
    exact add_le_add tagged tail

private theorem oddAtLateCrossing {N k : Nat} (first : FirstContraction N k) (late : 1<k) :
    N%2=1 := by
  by_cases odd : N%2=1
  · exact odd
  · have earlier := first.2 1 late
    simp [oddCount,orbit,odd] at earlier

/-- The source height bounds the odd clock of its own first contraction. -/
theorem ordinarySourceBound {N k : Nat} (first : FirstContraction N k) (late : 1<k)
    (runs : oddRuns N k≤91) : (oddCount N k : ℝ)≤(roundedCapacity 1 : ℝ)*logHeight N := by
  have localBound := localLogCapacity (t:=k) (oddAtLateCrossing first late)
  have ceiling : geom 91≤(roundedCapacity 1 : ℝ) := by
    simpa using capacityLeRounded 1
  exact localBound.trans (mul_le_mul_of_nonneg_right ((TerrasUniformRanks.geom_mono runs).trans ceiling)
    (logHeight_nonneg N))

/-- If `r` physical valleys of the same first contraction lie at or below
`W`, the actual odd clock fits the rounded ordinary rank envelope at `W`. -/
theorem ordinaryRankBoundOfCount {N k r W : Nat} (first : FirstContraction N k)
    (late : 1<k) (runs : oddRuns N k≤91) (rank : 0<r) (bound : r≤91)
    (enough : r≤(valleyTimes N k).countP (fun i => decide (orbit N i≤W))) :
    (oddCount N k : ℝ)≤(roundedCapacity r : ℝ)*logHeight W := by
  have odd := oddAtLateCrossing first late
  obtain ⟨mark,zmark,count,height⟩ := markBelowHeight first odd rank enough
  obtain ⟨cuts,lefts,runSum,oddSum,_⟩ := TerrasCuts.markedPartition mark first odd zmark
  have cutSize : cuts.length=r := by
    have eq := congrArg List.length lefts
    rw [List.length_map,←List.countP_eq_length_filter,count] at eq
    exact eq
  have absorbed := absorbGeometric (cuts.map Slice.runs) (fun a mem => by
    obtain ⟨s,_,rfl⟩ := List.mem_map.mp mem
    exact s.runsPositive)
  simp only [List.map_map,Function.comp_def,runSum,List.length_map,cutSize] at absorbed
  have body : oddRuns N k-r+1≤92-r := by omega
  have capped := add_le_add_right (TerrasUniformRanks.geom_mono body) ((r-1:Nat):ℝ)
  have envelope := absorbed.trans (capped.trans (capacityLeRounded r))
  have allHeights : ∀ s∈cuts, orbit N s.left≤W := by
    intro s mem
    have m : s.left∈cuts.map Slice.left := List.mem_map_of_mem mem
    rw [lefts] at m
    exact height _ (List.mem_filter.mp m).2
  have total := sliceSumLe cuts W allHeights
  rw [oddSum] at total
  exact total.trans (mul_le_mul_of_nonneg_right envelope (logHeight_nonneg W))

/-- The same bound indexed by the zero-based position in the sorted physical
valley heights. The permutation retains repetitions of a height. -/
theorem ordinaryRankBoundOfSorted {N k i : Nat} {xs : List Nat} (first : FirstContraction N k)
    (late : 1<k) (runs : oddRuns N k≤91) (sorted : xs.Pairwise (·≤·))
    (heights : xs.Perm ((valleyTimes N k).map (orbit N))) (ix : i<xs.length) :
    (oddCount N k : ℝ)≤(roundedCapacity (i+1) : ℝ)*logHeight xs[i] := by
  have enough := Terras90Q0Price.rank_count_of_price sorted ix (Nat.lt_succ_self xs[i])
  rw [List.Perm.countP_eq _ heights,List.countP_map] at enough
  simp only [Nat.lt_succ_iff] at enough
  have len := heights.length_eq
  rw [List.length_map,valleyTimes_length] at len
  exact ordinaryRankBoundOfCount first late runs (by omega) (by omega) enough

end Terras91OrdinaryRank

#print axioms Terras91OrdinaryRank.ordinarySourceBound
#print axioms Terras91OrdinaryRank.ordinaryRankBoundOfCount
#print axioms Terras91OrdinaryRank.ordinaryRankBoundOfSorted
