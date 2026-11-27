import Terras90Q0Ratio
import Terras90

namespace Terras90Q0Price

open TerrasClock
open Terras88 (q0Clock q0Price verifiedHeight valleyTimes valleyTimes_mem)

def chronologicalHeights (N k : Nat) : List Nat := (valleyTimes N k).map (orbit N)

private def adjusted (N : Nat) : Nat → Nat
  | 0 => N
  | j+1 => orbit N (j+1) + if orbit N j%2=1 then 1 else 0

private theorem orbit_le_adjusted (N k : Nat) : orbit N k≤adjusted N k := by
  cases k with
  | zero => exact Nat.le_refl _
  | succ k => exact Nat.le_add_right _ _

private theorem adjusted_at_start {N k : Nat} (begins : startsOddRun N k=true) :
    adjusted N k=orbit N k := by
  cases k with
  | zero => rfl
  | succ k =>
    have phase := (startsOddRun_iff N (k+1)).mp begins
    have even : orbit N k%2=0 := by simpa using phase.2
    simp [adjusted,even]

private theorem adjusted_at_continuation {N k : Nat} (odd : orbit N k%2=1)
    (notStart : startsOddRun N k=false) : adjusted N k=orbit N k+1 := by
  cases k with
  | zero => simp [startsOddRun,odd] at notStart
  | succ k =>
    have prevOdd : orbit N k%2=1 := by
      rcases Nat.mod_two_eq_zero_or_one (orbit N k) with even | oddPrev
      · have begins := (startsOddRun_iff N (k+1)).mpr
          ⟨odd,Or.inr (by simpa using even)⟩
        simp [notStart] at begins
      · exact oddPrev
    simp [adjusted,prevOdd]

private theorem adjusted_after_odd {N k : Nat} (odd : orbit N k%2=1) :
    2*adjusted N (k+1)=3*(orbit N k+1) := by
  have step := shortcut_odd odd
  simp only [adjusted,odd,if_true,orbit_succ,Nat.mul_add,Nat.mul_one]
  omega

private theorem adjusted_after_even {N k : Nat} (even : orbit N k%2=0) :
    2*adjusted N (k+1)=orbit N k := by
  simpa [adjusted,even,orbit_succ] using shortcut_even even

private theorem heights_succ (N k : Nat) :
    chronologicalHeights N (k+1) = chronologicalHeights N k ++
      if startsOddRun N k then [orbit N k] else [] := by
  cases h : startsOddRun N k <;>
    simp [chronologicalHeights,valleyTimes,List.range_succ,List.filter_append,h]

/-- Prefix product over the genuine ordinal run starts. Shifting by one
after an odd source telescopes a whole odd run without charging it twice. -/
theorem physicalPrefixProduct (N k : Nat) :
    2^k*adjusted N k*product (chronologicalHeights N k) ≤
      3^(oddCount N k)*N*shiftedProduct (chronologicalHeights N k) := by
  induction k with
  | zero => simp [adjusted,chronologicalHeights,valleyTimes,product,shiftedProduct,oddCount]
  | succ k ih =>
    let before := chronologicalHeights N k
    change 2^k*adjusted N k*product before ≤ 3^(oddCount N k)*N*shiftedProduct before at ih
    rw [heights_succ]
    change 2^(k+1)*adjusted N (k+1)*product (before ++ _) ≤
      3^(oddCount N (k+1))*N*shiftedProduct (before ++ _)
    rcases Nat.mod_two_eq_zero_or_one (orbit N k) with even | odd
    · have no : startsOddRun N k=false := by simp [startsOddRun,even]
      simp only [no, Bool.false_eq_true, if_false, List.append_nil, oddCount, even,
        Nat.zero_ne_one, Nat.add_zero,Nat.pow_succ]
      calc
        _ = (2^k*(2*adjusted N (k+1)))*product before := by ac_rfl
        _ = (2^k*orbit N k)*product before := by rw [adjusted_after_even even]
        _ ≤ (2^k*adjusted N k)*product before :=
          Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ (orbit_le_adjusted N k))
        _ ≤ _ := ih
    · cases start : startsOddRun N k
      · have same := adjusted_at_continuation odd start
        simp only [start, Bool.false_eq_true, if_false, List.append_nil, oddCount, odd,
          if_true,Nat.pow_succ]
        calc
          _ = (2^k*(2*adjusted N (k+1)))*product before := by ac_rfl
          _ = (2^k*adjusted N k*product before)*3 := by
            rw [adjusted_after_odd odd,same]
            ac_rfl
          _ ≤ (3^(oddCount N k)*N*shiftedProduct before)*3 := Nat.mul_le_mul_right _ ih
          _ = _ := by ac_rfl
      · have same := adjusted_at_start start
        simp only [start, if_true,product_append,shiftedProduct_append,
          oddCount,odd,Nat.pow_succ]
        have single (x : Nat) : product [x]=x := by simp [product]
        have shiftSingle (x : Nat) : shiftedProduct [x]=x+1 := by simp [shiftedProduct,product]
        rw [single,shiftSingle]
        calc
          _ = (2^k*(2*adjusted N (k+1)))*(product before*orbit N k) := by ac_rfl
          _ = (2^k*adjusted N k*product before)*(3*(orbit N k+1)) := by
            rw [adjusted_after_odd odd,same]
            ac_rfl
          _ ≤ (3^(oddCount N k)*N*shiftedProduct before)*(3*(orbit N k+1)) :=
            Nat.mul_le_mul_right _ ih
          _ = _ := by ac_rfl

private theorem positive_seed_odd {N k : Nat} (first : FirstContraction N k)
    (delta : orbit N k=N+1) : N%2=1 := by
  rcases Nat.mod_two_eq_zero_or_one N with even | odd
  · have positive := first_contraction_pos first
    have early : k≤1 := by
      by_cases small : k≤1
      · exact small
      · have contradiction := first.2 1 (by omega)
        simp [oddCount,orbit,even] at contradiction
    have eq : k=1 := by omega
    rw [eq] at delta
    have step := shortcut_even even
    change shortcut N=N+1 at delta
    omega
  · exact odd

private theorem first_height {N k : Nat} (odd : N%2=1) (positive : 0<k) :
    ∃ tail, chronologicalHeights N k=N::tail := by
  induction k with
  | zero => omega
  | succ k ih =>
    by_cases zero : k=0
    · subst k
      exact ⟨[],by simp [chronologicalHeights,valleyTimes,startsOddRun,orbit,odd]⟩
    · obtain ⟨tail, prior⟩ := ih (by omega)
      rw [heights_succ,prior]
      exact ⟨_,rfl⟩

theorem chronological_lower {N k : Nat} (first : FirstContraction N k) :
    ∀ x ∈ chronologicalHeights N k, N≤x := by
  intro x mem
  obtain ⟨i, hi, value⟩ := List.mem_map.mp mem
  exact value ▸ prior_no_descent first (valleyTimes_mem hi).1

private theorem discountFirst {a b N z : Nat} {tail : List Nat} (pos : 0<N)
    (lower : N+1≤z)
    (before : b*z*product (N::tail) ≤ a*N*shiftedProduct (N::tail)) :
    b*product tail≤a*shiftedProduct tail := by
  have crossed : (N*(N+1))*(b*product tail) ≤ (N*(N+1))*(a*shiftedProduct tail) := by
    calc
      _ = (b*(N+1))*(N*product tail) := by ac_rfl
      _ ≤ (b*z)*(N*product tail) := Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ lower)
      _ ≤ _ := by
        have inner : a*N*shiftedProduct (N::tail) = N*(N+1)*(a*shiftedProduct tail) := by
          simp only [shiftedProduct,List.map_cons,product]
          ac_rfl
        rw [← inner]
        exact before
  exact Nat.le_of_mul_le_mul_left crossed (Nat.mul_pos pos (by omega))

/-- The first run factor cancels against the exact endpoint N+1. -/
theorem physicalDiscountedProduct {N k : Nat} (pos : 0<N) (first : FirstContraction N k)
    (delta : orbit N k=N+1) :
    2^k*product ((chronologicalHeights N k).drop 1) ≤
      3^(oddCount N k)*shiftedProduct ((chronologicalHeights N k).drop 1) := by
  have odd := positive_seed_odd first delta
  obtain ⟨tail, initial⟩ := first_height odd (first_contraction_pos first)
  have low := orbit_le_adjusted N k
  rw [delta] at low
  have budget := physicalPrefixProduct N k
  rw [initial] at budget ⊢
  exact discountFirst pos low budget

private theorem perm_discount {N k : Nat} {xs : List Nat} (first : FirstContraction N k)
    (delta : orbit N k=N+1) (ordered : xs.Pairwise (·≤·))
    (same : xs.Perm (chronologicalHeights N k)) :
    (xs.drop 1).Perm ((chronologicalHeights N k).drop 1) := by
  have odd := positive_seed_odd first delta
  obtain ⟨tail, initial⟩ := first_height odd (first_contraction_pos first)
  have inSorted : N∈xs := same.mem_iff.mpr (by rw [initial]; simp)
  cases xs with
  | nil => simp at inSorted
  | cons x xs =>
    have left : x≤N := by
      rcases List.mem_cons.mp inSorted with eq | tailMem
      · omega
      · exact (List.pairwise_cons.mp ordered).1 _ tailMem
    have right : N≤x := chronological_lower first _ (same.mem_iff.mp (by simp))
    have equal : x=N := Nat.le_antisymm left right
    subst x
    rw [initial] at same ⊢
    exact same.cons_inv

theorem q0_sixth_lt_price {N k : Nat} (q0 : Terras90.DeltaOneQ0 N k)
    (xs : List Nat) (len : xs.length=90) (ordered : xs.Pairwise (· ≤ ·))
    (same : xs.Perm (chronologicalHeights N k))
    (at10 : floor92≤xs[9]'(by omega)) (at11 : floor146≤xs[10]'(by omega)) :
    xs[5]'(by omega)<q0Price := by
  have tails := perm_discount q0.first q0.delta ordered same
  have pos : 0<N := Nat.lt_of_le_of_lt (Nat.zero_le _) q0.base
  have budget := physicalDiscountedProduct pos q0.first q0.delta
  have oddClock : oddCount N k=q0Clock.2 := congrArg Prod.snd q0.clock
  have totalClock : k=q0Clock.1 := congrArg Prod.fst q0.clock
  rw [← product_perm tails,← shiftedProduct_perm tails,
      oddClock,totalClock] at budget
  exact sixth_lt_price_product xs len ordered
    (fun x hx => Nat.le_trans (Nat.le_of_lt q0.base) (chronological_lower q0.first x (same.mem_iff.mp hx)))
    at10 at11 budget

end Terras90Q0Price
