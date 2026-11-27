import TerrasLocalProfiles

namespace TerrasUniformSix

open TerrasClock
open Terras88 (valleyTimes valleyTimes_mem)
open TerrasCapacityAbsorption (capacityNum geometricNum)
open TerrasCuts (capacitySixNum capacitySixAbsorption)

set_option maxRecDepth 8000

/-- The long branch of the six-run profile grows with the receiver length. -/
theorem capacitySixMonoLong {p q M a b : Nat} (long : 6 ≤ a) (ordered : a ≤ b) :
    capacitySixNum p q M a ≤ capacitySixNum p q M b := by
  have formula (n : Nat) (h : 6 ≤ n) :
      capacitySixNum p q M n = 2 * geometricNum p q M (n - 4) := by
    simp [capacitySixNum, h, capacityNum, show n-1 ≠ 0 by omega,
      show n-1 ≠ 1 by omega, show n-1 ≠ 2 by omega, show ¬n-1 ≤ 4 by omega,
      show n-1-3 = n-4 by omega]
  have mono {i j : Nat} (le : i ≤ j) : geometricNum p q M i ≤ geometricNum p q M j := by
    induction le with
    | refl => exact Nat.le_refl _
    | step _ ih => exact Nat.le_trans ih (Nat.le_add_right _ _)
  rw [formula a long, formula b (Nat.le_trans long ordered)]
  exact Nat.mul_le_mul_left 2 (mono (Nat.sub_le_sub_right ordered 4))

/-- A larger total budget increases the recipient length while preserving the
actual number of donors. -/
theorem capacitySixAbsorptionUpTo {p q M m : Nat}
    (hq : 0 < q) (ratio : q ≤ p) (hM : 1 ≤ M)
    (sizes : List Nat) (positive : ∀ n ∈ sizes, 1 ≤ n)
    (longEnough : 5 * sizes.length < sizes.sum) (total : sizes.sum ≤ m) (budget : m ≤ M+5) :
    (sizes.map (capacitySixNum p q M)).sum ≤
      capacitySixNum p q M (m-sizes.length+1) + (sizes.length-1)*capacitySixNum p q M 1 := by
  have nonempty : 0 < sizes.length := by
    cases sizes with
    | nil => simp at longEnough
    | cons head tail => simp
  have absorbed := capacitySixAbsorption hq ratio hM sizes positive longEnough (Nat.le_trans total budget)
  have raised := capacitySixMonoLong (p:=p) (q:=q) (M:=M)
    (a:=sizes.sum-sizes.length+1) (b:=m-sizes.length+1) (by omega) (by omega)
  exact Nat.le_trans absorbed (Nat.add_le_add_right raised _)

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

/-- The same exact integer comparison works throughout the four run counts. -/
abbrev arithmetic (H r extra d : Nat) : Prop :=
  H*(capacitySixNum 485 306 85 (91-r)+(r-1)*capacitySixNum 485 306 85 1+r*extra)
    < (2*306^85)*d

abbrev paddedArithmetic (H r d : Nat) : Prop :=
  arithmetic H r (4*306^85) d

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

/-- The same local profile and integer inequality certify a physical rank floor
for every first-contraction prefix with 87 to 90 odd runs. -/
theorem rankFloorAtClock {N k H r extra d m : Nat}
    (first : FirstContraction N k) (runs : oddRuns N k = m)
    (mLower : 87 ≤ m) (mUpper : m ≤ 90) (odds : oddCount N k = d)
    (pos : 0 < r) (long : 5*r < m) (localBound : TerrasCuts.LocalProfile H extra)
    (comparison : arithmetic H r extra d) :
    (valleyTimes N k).countP (fun i => decide (orbit N i < 2^H-1)) < r := by
  by_cases enough : r ≤ (valleyTimes N k).countP (fun i => decide (orbit N i < 2^H-1))
  · have odd := oddOfManyRuns first runs mLower
    obtain ⟨mark,atZero,count,height⟩ := markBelowHeight first odd pos enough
    obtain ⟨sizes,len,positive,total,bound⟩ := TerrasCuts.markedCapacity mark
      (fun n => H*(capacitySixNum 485 306 85 n+extra)) first odd atZero (fun s marked => by
        have rootOdd := ((startsOddRun_iff N s.left).mp s.start).1
        exact localBound _ _ (by omega) rootOdd (height _ marked))
    rw [count] at len
    rw [runs] at total
    rw [odds] at bound
    have absorbed := capacitySixAbsorptionUpTo (p:=485) (q:=306) (M:=85) (m:=90)
      (by decide) (by decide) (by decide) sizes positive (by omega) (by omega) (by decide)
    have receiver : 90-sizes.length+1=91-r := by omega
    rw [sumMapScale,sumMapPad,len] at bound
    rw [receiver,len] at absorbed
    have padded := Nat.add_le_add_right absorbed (r*extra)
    exact ((Nat.not_le_of_gt comparison) (Nat.le_trans bound (Nat.mul_le_mul_left H padded))).elim
  · omega

/-- Count valleys strictly below the H floor using a completed six-run capacity. -/
theorem rankFloorOfSix {N k H r d m : Nat}
    (first : FirstContraction N k) (runs : oddRuns N k = m)
    (mLower : 87 ≤ m) (mUpper : m ≤ 90) (odds : oddCount N k = d)
    (pos : 0 < r) (long : 5*r < m) (six : Terras90.SixRunCapacity H)
    (comparison : paddedArithmetic H r d) :
    (valleyTimes N k).countP (fun i => decide (orbit N i < 2^H-1)) < r :=
  rankFloorAtClock first runs mLower mUpper odds pos long
    (TerrasLocalProfiles.localSixProfileOfSix six) comparison

end TerrasUniformSix
