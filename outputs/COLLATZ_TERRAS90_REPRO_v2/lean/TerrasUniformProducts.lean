import WeaverWindows90
import Terras90TwiceQ0Numeric
import Terras90FinalNumeric
import Terras90FinalFloors
import TerrasUniformSix

namespace TerrasUniformProducts

open TerrasClock
open Terras88 (verifiedHeight valleyTimes q0Clock q0Price q1Clock twiceQ1Clock HasWindow)
open Terras90Q0Price
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered sortedFloorOfCount)

set_option maxHeartbeats 1200000
set_option maxRecDepth 10000

theorem sortedLength (N k : Nat) : (sortedHeights N k).length = oddRuns N k := by
  rw [(sortedHeights_perm N k).length_eq, Terras90RankAssembly.valleyHeights,
    List.length_map, Terras88.valleyTimes_length]

def ceiling (xs : List Nat) : Nat := xs.foldr max (2^180)

theorem ceilingHigh (xs : List Nat) : 2^180 ≤ ceiling xs := by
  induction xs with
  | nil => exact Nat.le_refl _
  | cons a rest ih => exact Nat.le_trans ih (Nat.le_max_right a (ceiling rest))

private theorem leCeiling {xs : List Nat} {x : Nat} (mem : x ∈ xs) : x ≤ ceiling xs := by
  induction xs with
  | nil => simp at mem
  | cons a rest ih =>
    rcases List.mem_cons.mp mem with eq | tail
    · subst x
      exact Nat.le_max_left _ _
    · exact Nat.le_trans (ih tail) (Nat.le_max_right _ _)

/-- Complete an analytic list of heights to size ninety. The appended
heights never enter an orbit, a count of runs, or a chronological window. -/
def pad (xs : List Nat) : List Nat := xs ++ List.replicate (90-xs.length) (ceiling xs)

theorem padLength {xs : List Nat} (size : xs.length ≤ 90) : (pad xs).length = 90 := by
  simp [pad, Nat.add_sub_of_le size]

theorem padGet {xs : List Nat} {i : Nat} (within : i<xs.length) :
    (pad xs)[i]'(by simp [pad]; omega) = xs[i] := List.getElem_append_left within

theorem padRanked {xs : List Nat} (ordered : xs.Pairwise (·≤·)) :
    (pad xs).Pairwise (·≤·) := by
  apply List.pairwise_append.mpr
  refine ⟨ordered, List.pairwise_replicate.mpr (.inr (Nat.le_refl _)), ?_⟩
  intro x mem z zmem
  have hz := (List.mem_replicate.mp zmem).2
  subst z
  exact leCeiling mem

theorem padLower {xs : List Nat} {a : Nat} (large : a≤2^180)
    (all : ∀ x ∈ xs, a≤x) : ∀ x ∈ pad xs, a≤x := by
  intro x mem
  rcases List.mem_append.mp mem with actual | dummy
  · exact all x actual
  · rw [(List.mem_replicate.mp dummy).2]
    exact Nat.le_trans large (ceilingHigh xs)

theorem padDrop {xs : List Nat} {d : Nat} (drop : d≤xs.length) :
    (pad xs).drop d = xs.drop d ++ List.replicate (90-xs.length) (ceiling xs) := by
  exact List.drop_append_of_le_length drop

private theorem productLeShift (ys : List Nat) : product ys≤shiftedProduct ys := by
  induction ys with
  | nil => decide
  | cons x rest ih =>
    exact Nat.mul_le_mul (Nat.le_succ x) ih

private theorem padBudget {xs : List Nat} {a b : Nat} (drop : 1≤xs.length)
    (bill : b*product (xs.drop 1)≤a*shiftedProduct (xs.drop 1)) :
    b*product ((pad xs).drop 1)≤a*shiftedProduct ((pad xs).drop 1) := by
  rw [padDrop drop, product_append, shiftedProduct_append, ←Nat.mul_assoc, ←Nat.mul_assoc]
  exact Nat.mul_le_mul bill (productLeShift _)

private theorem productPositive (xs : List Nat) (positive : ∀ x∈xs, 0<x) : 0<product xs := by
  induction xs with
  | nil => decide
  | cons x xs ih =>
    exact Nat.mul_pos (positive x List.mem_cons_self)
      (ih (fun y hy => positive y (List.mem_cons_of_mem _ hy)))

/-- The numerical envelopes used for all one-discount comparisons. -/
def envelope (large small low : Nat) : List Nat :=
  List.replicate low small ++ List.replicate (89-low) large

private theorem excludePad {xs : List Nat} {large small low a b : Nat}
    (len : xs.length=90) (within : low≤88) (ranked : xs.Pairwise (·≤·))
    (base : ∀ x∈xs.drop 1, 0<x ∧ small≤x)
    (tall : large≤xs[low+1]'(by omega))
    (bill : b*product (xs.drop 1)≤a*shiftedProduct (xs.drop 1))
    (strict : a*shiftedProduct (envelope large small low)<b*product (envelope large small low)) :
    False := by
  have shape : (xs.drop 1).length=(envelope large small low).length := by
    simp [envelope, len, Nat.add_sub_of_le (show low≤89 by omega)]
  refine TerrasDisplacement.excludeFromEnvelope shape ?_
    (productPositive _ fun x h => (base x h).1) bill strict
  intro p mem
  obtain ⟨i,hi,item⟩ := List.mem_iff_getElem.mp mem
  have bounds : i<(xs.drop 1).length ∧ i<(envelope large small low).length := by
    simpa only [List.length_zip,Nat.lt_min] using hi
  rw [List.getElem_zip] at item
  rw [← item]
  by_cases early : i<low
  · have side : i<(List.replicate low small).length := by simpa using early
    rw [show (envelope large small low)[i]'bounds.2=small by
      unfold envelope
      rw [List.getElem_append_left side,List.getElem_replicate]]
    exact (base _ (List.getElem_mem bounds.1)).2
  · have side : (List.replicate low small).length≤i := by simp; omega
    rw [show (envelope large small low)[i]'bounds.2=large by
      unfold envelope
      rw [List.getElem_append_right side,List.getElem_replicate]]
    rw [List.getElem_drop]
    apply floor_tail ranked (r:=low+1) (by omega) tall
    rw [List.mem_iff_getElem]
    have inside : i-low<(xs.drop (low+1)).length := by
      simp only [List.length_drop,len] at *
      omega
    exact ⟨i-low,inside,by rw [List.getElem_drop]; congr 1; omega⟩

private theorem realFloor {N k r height : Nat} (within : r<(sortedHeights N k).length)
    (low : (valleyTimes N k).countP (fun i => decide (orbit N i<height))≤r) :
    height≤(sortedHeights N k)[r] := by
  apply sortedFloorOfCount within
  simpa only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def] using low

private theorem realPrice {N k r price : Nat} (within : r<(sortedHeights N k).length)
    (priceBound : (sortedHeights N k)[r]<price) :
    r+1≤(valleyTimes N k).countP (fun i => decide (orbit N i<price)) := by
  have count := rank_count_of_price (sortedHeights_ordered N k) within priceBound
  rw [(sortedHeights_perm N k).countP_eq] at count
  simpa only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def] using count

private theorem physicalLower {N k : Nat} (base : verifiedHeight<N) (first : FirstContraction N k) :
    ∀ x∈pad (sortedHeights N k), verifiedHeight≤x := by
  apply padLower (by decide)
  intro x mem
  exact Nat.le_trans (Nat.le_of_lt base)
    (chronological_lower first x ((sortedHeights_perm N k).mem_iff.mp mem))

private theorem physicalBudget {N k : Nat} (base : verifiedHeight<N) (first : FirstContraction N k)
    (shift : N+1≤orbit N k) (some : 1≤oddRuns N k) :
    2^k*product ((pad (sortedHeights N k)).drop 1)≤
      3^(oddCount N k)*shiftedProduct ((pad (sortedHeights N k)).drop 1) := by
  apply padBudget (by simpa [sortedLength] using some)
  exact TerrasDisplacement.singleDiscount (Nat.lt_of_le_of_lt (Nat.zero_le _) base)
    first shift (sortedHeights_ordered N k) (sortedHeights_perm N k)

private theorem oddSeed {N k : Nat} (first : FirstContraction N k) (many : 2≤oddRuns N k) : N%2=1 := by
  have long : 1<k := by
    by_cases late : 1<k
    · exact late
    have small : k=0 ∨ k=1 := by omega
    rcases small with rfl | rfl
    · simp [oddRuns] at many
    · cases hs : startsOddRun N 0 <;> simp [oddRuns,hs] at many
  by_cases yes : N%2=1
  · exact yes
  have early := first.2 1 long
  simp [oddCount,orbit,yes] at early

/-- The single-discount Q0 price applies to every positive displacement. -/
theorem q0Window {N k : Nat} (base : verifiedHeight<N) (first : FirstContraction N k)
    (lower : 87≤oddRuns N k) (upper : oddRuns N k≤90)
    (clock : (k,oddCount N k)=q0Clock) (shift : N+1≤orbit N k)
    (rank10 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor92))<10)
    (rank11 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))<11) :
    HasWindow N k q0Price floor146 5 := by
  let xs := sortedHeights N k
  have length : xs.length=oddRuns N k := sortedLength N k
  have len := padLength (show xs.length≤90 by omega)
  have x9 := realFloor (N:=N) (k:=k) (r:=9) (height:=floor92)
    (by change 9<xs.length; omega) (Nat.le_of_lt_succ rank10)
  have x10 := realFloor (N:=N) (k:=k) (r:=10) (height:=floor146)
    (by change 10<xs.length; omega) (Nat.le_of_lt_succ rank11)
  have b := physicalBudget base first shift (by omega)
  have kEq : k=q0Clock.1 := congrArg Prod.fst clock
  have dEq : oddCount N k=q0Clock.2 := congrArg Prod.snd clock
  have bPaid : 2^q0Clock.1*product ((pad xs).drop 1)≤
      3^q0Clock.2*shiftedProduct ((pad xs).drop 1) := by
    rw [show (2:Nat)^q0Clock.1=2^k from congrArg (2^·) kEq.symm,
      show (3:Nat)^q0Clock.2=3^oddCount N k from congrArg (3^·) dEq.symm]
    exact b
  have cheap := sixth_lt_price_product (pad xs) len (padRanked (sortedHeights_ordered N k))
    (physicalLower base first)
    (by rw [padGet (show 9<xs.length by omega)]; exact x9)
    (by rw [padGet (show 10<xs.length by omega)]; exact x10) bPaid
  rw [padGet (show 5<xs.length by omega)] at cheap
  exact TerrasDisplacement.windowOfCounts (paid:=6) (cap:=10) base first (oddSeed first (by omega))
    (by decide) (by decide) (realPrice (r:=5) (by change 5<xs.length; omega) cheap)
    (by omega) (by omega) (by decide)

theorem q1WindowOfStrict {N k : Nat} (base : verifiedHeight<N) (first : FirstContraction N k)
    (lower : 87≤oddRuns N k) (upper : oddRuns N k≤90) (shift : N+1≤orbit N k)
    (rank7 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))<7)
    (strict : 3^(oddCount N k)*shiftedProduct (envelope floor146 q0Price 5)<
      2^k*product (envelope floor146 q0Price 5)) : HasWindow N k q0Price floor146 5 := by
  let xs := sortedHeights N k
  have length : xs.length=oddRuns N k := sortedLength N k
  have len := padLength (show xs.length≤90 by omega)
  have ranked : (pad xs).Pairwise (·≤·) := padRanked (sortedHeights_ordered N k)
  have x6 := realFloor (N:=N) (k:=k) (r:=6) (height:=floor146)
    (by change 6<xs.length; omega) (Nat.le_of_lt_succ rank7)
  have affordable : xs[1]'(by omega)<q0Price := by
    by_cases cheap : xs[1]'(by omega)<q0Price
    · exact cheap
    exfalso
    have price : q0Price≤(pad xs)[1]'(by omega) := by
      rw [padGet (show 1<xs.length by omega)]
      exact Nat.le_of_not_gt cheap
    exact excludePad len (by decide) ranked (fun x mem =>
      have hx := floor_tail ranked (r:=1) (by rw [len]; decide) price x mem
      ⟨Nat.lt_of_lt_of_le (by decide) hx,hx⟩)
      (by rw [padGet (show 6<xs.length by omega)]; exact x6)
      (physicalBudget base first shift (by omega)) strict
  exact TerrasDisplacement.windowOfCounts (paid:=2) (cap:=6) base first (oddSeed first (by omega))
    (by decide) (by decide) (realPrice (r:=1) (by change 1<xs.length; omega) affordable)
    (by omega) (by omega) (by decide)

theorem noShiftOfFloor {N k low : Nat} (base : verifiedHeight<N) (first : FirstContraction N k)
    (lower : 87≤oddRuns N k) (upper : oddRuns N k≤90) (shift : N+1≤orbit N k)
    (within : low≤7)
    (rank : (valleyTimes N k).countP (fun i => decide (orbit N i<floor92))≤low+1)
    (strict : 3^(oddCount N k)*shiftedProduct (envelope floor92 verifiedHeight low)<
      2^k*product (envelope floor92 verifiedHeight low)) : False := by
  let xs := sortedHeights N k
  have length : xs.length=oddRuns N k := sortedLength N k
  have len := padLength (show xs.length≤90 by omega)
  have tall : floor92≤(pad xs)[low+1]'(by omega) := by
    rw [padGet (show low+1<xs.length by omega)]
    exact realFloor _ rank
  exact excludePad len (by omega) (padRanked (sortedHeights_ordered N k))
    (fun x mem => have h := physicalLower base first x (List.mem_of_mem_drop mem)
                  ⟨Nat.lt_of_lt_of_le (by decide) h,h⟩)
    tall (physicalBudget base first shift (by omega)) strict

private theorem countedFloor {N k H r d : Nat} (first : FirstContraction N k)
    (lower : 87≤oddRuns N k) (upper : oddRuns N k≤90) (odds : oddCount N k=d)
    (positive : 0<r) (small : r≤12) (six : Terras90.SixRunCapacity H)
    (arithmetic : TerrasUniformSix.paddedArithmetic H r d) :
    (valleyTimes N k).countP (fun i => decide (orbit N i<2^H-1))<r :=
  TerrasUniformSix.rankFloorOfSix first rfl lower upper odds positive (by omega) six arithmetic

private theorem q1Window {N k : Nat} {clock : Nat × Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (lower : 87≤oddRuns N k) (upper : oddRuns N k≤90)
    (shift : N+1≤orbit N k) (pair : (k,oddCount N k)=clock)
    (capacity : Terras90.SixRunCapacity 146)
    (arithmetic : TerrasUniformSix.paddedArithmetic 146 7 clock.2)
    (strict : 3^clock.2*shiftedProduct (Terras90Q1Numeric.priceEnvelope q0Price)<
      2^clock.1*product (Terras90Q1Numeric.priceEnvelope q0Price)) :
    HasWindow N k q0Price floor146 5 := by
  have total : k=clock.1 := congrArg Prod.fst pair
  have count : oddCount N k=clock.2 := congrArg Prod.snd pair
  have rank7 := countedFloor first lower upper count (by decide : 0<7) (by decide)
    capacity arithmetic
  refine q1WindowOfStrict base first lower upper shift rank7 ?_
  rw [count,total]
  exact strict

private theorem residualTable {clock : Nat × Nat} (row : clock∈Terras90TwiceQ0.remaining) :
    ∃ low, (clock,low)∈Terras90FinalNumeric.rows ∧ low≤7 ∧
      Terras90FinalFloors.h92Rank clock≤low+2 := by
  have same : Terras90FinalNumeric.rows.map Prod.fst=Terras90TwiceQ0.remaining := by decide
  rw [← same,List.mem_map] at row
  obtain ⟨⟨_,low⟩,mem,rfl⟩ := row
  have checks : ∀ p∈Terras90FinalNumeric.rows,
      p.2≤7 ∧ Terras90FinalFloors.h92Rank p.1≤p.2+2 := by
    intro p hm
    simp only [Terras90FinalNumeric.rows,List.mem_cons,List.not_mem_nil,or_false] at hm
    rcases hm with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide
  exact ⟨low,mem,checks _ mem⟩

/-- Inspect each row of the same finite clock sieve. All height counts
and chronological windows remain in the original prefix. -/
theorem excludesPositiveInRange {N k : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (lower : 87≤oddRuns N k) (upper : oddRuns N k≤90)
    (shift : N+1≤orbit N k) (listed : (k,oddCount N k)∈Terras90Lattice.survivors)
    (six92 : Terras90.SixRunCapacity 92) (six146 : Terras90.SixRunCapacity 146)
    (noWeaver : ¬HasWindow N k q0Price floor146 5) : False := by
  by_cases q0 : (k,oddCount N k)=q0Clock
  · have dEq : oddCount N k=q0Clock.2 := congrArg Prod.snd q0
    have r10 := countedFloor first lower upper dEq (by decide : 0<10) (by decide) six92 (by decide)
    have r11 := countedFloor first lower upper dEq (by decide : 0<11) (by decide) six146 (by decide)
    exact noWeaver (q0Window base first lower upper q0 shift r10 r11)
  by_cases q1 : (k,oddCount N k)=q1Clock
  · exact noWeaver (q1Window (clock:=q1Clock) base first lower upper shift q1 six146 (by decide)
      Terras90Q1Numeric.q1ProductStrict)
  by_cases twice1 : (k,oddCount N k)=twiceQ1Clock
  · exact noWeaver (q1Window (clock:=twiceQ1Clock) base first lower upper shift twice1 six146 (by decide)
      Terras90Q1Numeric.twiceQ1ProductStrict)
  by_cases twice0 : (k,oddCount N k)=Terras90TwiceQ0.clock2
  · have total : k=2*q0Clock.1 := congrArg Prod.fst twice0
    have count : oddCount N k=2*q0Clock.2 := congrArg Prod.snd twice0
    have r9 := countedFloor first lower upper count (by decide : 0<9) (by decide) six92 (by decide)
    change (valleyTimes N k).countP (fun i => decide (orbit N i<floor92))<9 at r9
    apply noShiftOfFloor (low:=7) base first lower upper shift (by decide)
      (Nat.le_of_lt_succ r9)
    have eqFloors : envelope floor92 verifiedHeight 7=Terras90TwiceQ0Numeric.floors := rfl
    rw [eqFloors,count,total]
    exact Terras90TwiceQ0Numeric.productStrict
  have row : (k,oddCount N k)∈Terras90TwiceQ0.remaining := by
    simp only [Terras90TwiceQ0.remaining, WeaverWindows90.residualClocks, List.mem_filter,
      decide_eq_true_eq]
    exact ⟨⟨listed,q0,q1,twice1⟩,twice0⟩
  obtain ⟨low,mem,within,rank⟩ := residualTable row
  obtain ⟨rPos,_,arith⟩ := Terras90FinalFloors.rowH92Arithmetic row
  have count := countedFloor first lower upper rfl rPos (by omega) six92 arith
  change (valleyTimes N k).countP (fun i => decide (orbit N i<floor92))<
    Terras90FinalFloors.h92Rank (k,oddCount N k) at count
  exact noShiftOfFloor base first lower upper shift within
    (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le count rank))
    (Terras90FinalNumeric.productStrict mem)

end TerrasUniformProducts

#print axioms TerrasUniformProducts.q0Window
#print axioms TerrasUniformProducts.q1WindowOfStrict
#print axioms TerrasUniformProducts.noShiftOfFloor
#print axioms TerrasUniformProducts.excludesPositiveInRange
