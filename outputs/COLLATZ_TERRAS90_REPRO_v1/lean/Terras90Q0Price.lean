import Terras88

namespace Terras90Q0Price

open Terras88 (q0Price verifiedHeight)

def scale : Nat := 10^44

/-- The ceiling of the scaled reciprocal at a positive height. -/
def reciprocal (x : Nat) : Nat := (scale-1)/x+1

/-- A rational encloser for the Q0 log gap minus the source correction. -/
def discountedGap : Nat := 15168663102485338995718101

def floor92 : Nat := 2^92-1
def floor146 : Nat := 2^146-1

theorem exactPriceMargin :
    4*reciprocal verifiedHeight + 4*reciprocal q0Price +
      reciprocal floor92 + 80*reciprocal floor146 + 334 = discountedGap := by
  decide

theorem reciprocal_antitone {a b : Nat} (pos : 0<a) (ab : a≤b) :
    reciprocal b ≤ reciprocal a := by
  unfold reciprocal
  exact Nat.add_le_add_right (Nat.div_le_div_left ab pos) 1

private theorem sum_bounded (a : Nat) (pos : 0<a) (l : List Nat)
    (all : ∀ x ∈ l, a≤x) :
    (l.map reciprocal).sum ≤ l.length*reciprocal a := by
  induction l with
  | nil => simp
  | cons x xs ih =>
    have head := reciprocal_antitone pos (all x (by simp))
    have tail := ih (fun v hv => all v (List.mem_cons_of_mem _ hv))
    simp only [List.map_cons, List.sum_cons, List.length_cons, Nat.add_mul, Nat.one_mul]
    omega

private theorem sum_append (as bs : List Nat) : (as++bs).sum=as.sum+bs.sum := by
  induction as with
  | nil => simp
  | cons a as ih => simp [ih, Nat.add_assoc]

private theorem sum_split (n : Nat) (xs : List Nat) :
    (xs.map reciprocal).sum =
      ((xs.take n).map reciprocal).sum + ((xs.drop n).map reciprocal).sum := by
  rw [← sum_append, ← List.map_append, List.take_append_drop]

theorem floor_tail {xs : List Nat} (sorted : xs.Pairwise (· ≤ ·))
    {r bound : Nat} (hr : r < xs.length) (lower : bound ≤ xs[r]) :
    ∀ x ∈ xs.drop r, bound≤x := by
  intro x hx
  obtain ⟨i, hi, value⟩ := List.mem_iff_getElem.mp hx
  rw [List.getElem_drop] at value
  have hri : r+i < xs.length := by
    rw [List.length_drop] at hi
    omega
  by_cases zero : i=0
  · subst i
    simp only [Nat.add_zero] at value
    exact value ▸ lower
  · have bigger := List.pairwise_iff_getElem.mp sorted r (r+i) hr hri (by omega)
    exact value ▸ Nat.le_trans lower bigger

theorem count_below_of_rank_floor {xs : List Nat} (sorted : xs.Pairwise (· ≤ ·))
    {r floor : Nat} (hr : r<xs.length) (lower : floor≤xs[r]) :
    xs.countP (fun x => decide (x<floor))≤r := by
  let p := fun x => decide (x<floor)
  have tailZero : (xs.drop r).countP p=0 := by
    apply List.countP_eq_zero.mpr
    intro x hit
    have hx := floor_tail sorted hr lower x hit
    simp [p, Nat.not_lt_of_ge hx]
  change xs.countP p≤r
  calc
    _ = (xs.take r).countP p + (xs.drop r).countP p := by
      rw [← List.countP_append, List.take_append_drop]
    _ ≤ r := by
      rw [tailZero, Nat.add_zero]
      exact Nat.le_trans List.countP_le_length (by rw [List.length_take]; exact Nat.min_le_left _ _)

theorem rank_count_of_price {xs : List Nat} (sorted : xs.Pairwise (· ≤ ·))
    {r price : Nat} (hr : r<xs.length) (paid : xs[r]<price) :
    r+1≤xs.countP (fun x => decide (x<price)) := by
  let p := fun x => decide (x<price)
  have all : (xs.take (r+1)).countP p = r+1 := by
    have count : (xs.take (r+1)).countP p = (xs.take (r+1)).length := by
      apply List.countP_eq_length.mpr
      intro x hit
      obtain ⟨i, hi, value⟩ := List.mem_iff_getElem.mp hit
      rw [List.getElem_take] at value
      have le : i≤r := by
        rw [List.length_take] at hi
        omega
      have valueLe : x≤xs[r] := by
        by_cases eq : i=r
        · subst i
          omega
        · exact value ▸ List.pairwise_iff_getElem.mp sorted i r
            (by omega) hr (by omega)
      simp only [p, decide_eq_true_eq]
      omega
    rw [count, List.length_take, Nat.min_eq_left (by omega)]
  change r+1≤xs.countP p
  rw [← List.take_append_drop (r+1) xs, List.countP_append, all]
  omega

/-- Only floors 10 and 11 are needed for the strict price of rank 6. The
remaining premise is the lower bound supplied by the physical Q0 history. -/
theorem sixth_lt_price (xs : List Nat) (len : xs.length=90)
    (ordered : xs.Pairwise (· ≤ ·))
    (positive : ∀ x ∈ xs, verifiedHeight≤x)
    (at10 : floor92≤xs[9]'(by omega)) (at11 : floor146≤xs[10]'(by omega))
    (budget : discountedGap < ((xs.drop 1).map reciprocal).sum) :
    xs[5]'(by omega)<q0Price := by
  by_cases cheaper : xs[5]'(by omega)<q0Price
  · exact cheaper
  · have q0Lower : q0Price ≤ xs[5]'(by omega) := Nat.le_of_not_gt cheaper
    have low := sum_bounded verifiedHeight (by decide : 0<verifiedHeight)
      ((xs.drop 1).take 4)
      (fun x hit => positive x (List.mem_of_mem_drop (List.mem_of_mem_take hit)))
    have mid := sum_bounded q0Price (by decide : 0<q0Price) ((xs.drop 5).take 4)
      (fun x hit => floor_tail ordered (by omega) q0Lower x (List.mem_of_mem_take hit))
    have tenth := sum_bounded floor92 (by decide : 0<floor92) ((xs.drop 9).take 1)
      (fun x hit => floor_tail ordered (by omega) at10 x (List.mem_of_mem_take hit))
    have high := sum_bounded floor146 (by decide : 0<floor146) (xs.drop 10)
      (floor_tail ordered (by omega) at11)
    have partition := sum_split 4 (xs.drop 1)
    have partitionMid := sum_split 4 (xs.drop 5)
    have partitionHigh := sum_split 1 (xs.drop 9)
    simp only [List.drop_drop, Nat.reduceAdd] at partition partitionMid partitionHigh
    simp only [List.length_take, List.length_drop, len, Nat.reduceSub,
      Nat.min_eq_left (by decide : 4≤89), Nat.min_eq_left (by decide : 4≤85),
      Nat.min_eq_left (by decide : 1≤81), Nat.one_mul] at low mid tenth high
    have exact := exactPriceMargin
    omega

end Terras90Q0Price
