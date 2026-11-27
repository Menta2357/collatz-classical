import TerrasLocalProfiles

namespace Terras2Q0Floors

open TerrasClock
open Terras88 (valleyTimes valleyTimes_mem)
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

theorem rankNineH92Arithmetic :
    92*(capacitySixNum 485 306 85 82+8*capacitySixNum 485 306 85 1+9*(4*306^85))
      < (2*306^85)*795120698740773566 := by decide

/-- The actual ninth valley in the 2Q0 prefix reaches the H92 floor. -/
theorem rankNineH92 {N k : Nat} (first : FirstContraction N k) (runs : oddRuns N k=90)
    (clock : (k,oddCount N k)=(1260236491051329530,795120698740773566))
    (six92 : Terras90.SixRunCapacity 92) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^92-1))<9 := by
  have kEq : k=1260236491051329530 := congrArg Prod.fst clock
  have dEq : oddCount N k=795120698740773566 := congrArg Prod.snd clock
  exact rankFloorAtClock first (oddAtLateCrossing first (by omega)) runs dEq
    (by decide) (by decide) (TerrasLocalProfiles.localSixProfileOfSix six92) rankNineH92Arithmetic

end Terras2Q0Floors
