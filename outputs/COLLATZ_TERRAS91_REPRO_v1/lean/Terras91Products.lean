import Terras91Q0Floors
import TerrasDisplacement
import Terras91Q0

namespace Terras91Products

open TerrasClock
open Terras88 (valleyTimes verifiedHeight q0Clock q1Clock twiceQ1Clock q0Price HasWindow)
open Terras90Q0Price (floor92 floor146 product shiftedProduct floor_tail rank_count_of_price)
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered sortedFloorOfCount)

set_option maxRecDepth 10000
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 2048

private def precision : Nat := 2^256

private structure Mantissa where
  oddExp : Nat
  dyadicExp : Nat
  bound : Nat
  deriving DecidableEq

private def Mantissa.valid (x : Mantissa) : Prop :=
  precision*3^x.oddExp ≤ x.bound*2^x.dyadicExp

private def advance (x : Mantissa) (digit : Nat × Nat) : Mantissa :=
  let (bit, shift) := digit
  ⟨x.oddExp+x.oddExp+bit,x.dyadicExp+x.dyadicExp+shift,
    (x.bound*x.bound*3^bit)/(precision*2^shift)+1⟩

private theorem rounding (n d : Nat) (pos : 0<d) : n≤(n/d+1)*d := by
  have rem := Nat.mod_lt n pos
  have decomp := Nat.mod_add_div n d
  rw [Nat.add_mul,Nat.one_mul,Nat.mul_comm (n/d)]
  omega

private theorem advance_valid (x : Mantissa) (digit : Nat × Nat) (old : x.valid) :
    (advance x digit).valid := by
  rcases digit with ⟨bit,shift⟩
  let u := x.bound
  let n := x.oddExp
  let k := x.dyadicExp
  let next := (u*u*3^bit)/(precision*2^shift)+1
  change precision*3^n≤u*2^k at old
  change precision*3^(n+n+bit)≤next*2^(k+k+shift)
  have denom : 0<precision*2^shift :=
    Nat.mul_pos (by decide) (Nat.pow_pos (by decide))
  have round := rounding (u*u*3^bit) (precision*2^shift) denom
  have upper : precision*(precision*3^(n+n+bit))≤precision*(next*2^(k+k+shift)) := by
    calc
      _ = ((precision*3^n)*(precision*3^n))*3^bit := by
        rw [Nat.pow_add 3 (n+n),Nat.pow_add 3 n n]
        ac_rfl
      _ ≤ ((u*2^k)*(u*2^k))*3^bit := Nat.mul_le_mul_right _ (Nat.mul_le_mul old old)
      _ = (u*u*3^bit)*2^(k+k) := by rw [Nat.pow_add 2 k k]; ac_rfl
      _ ≤ (next*(precision*2^shift))*2^(k+k) := Nat.mul_le_mul_right _ round
      _ = _ := by rw [Nat.pow_add 2 (k+k)]; ac_rfl
  exact Nat.le_of_mul_le_mul_left upper (by decide)

private theorem fold_valid (trace : List (Nat × Nat)) (x : Mantissa) (valid : x.valid) :
    (trace.foldl advance x).valid := by
  induction trace generalizing x with
  | nil => exact valid
  | cons digit trail ih => exact ih _ (advance_valid x digit valid)

/-- Run 67 stages at increasing prefix length. The paired dyadic
prefix is the integer quotient of the two clocks times the odd prefix. -/
private def trace (clock : Nat × Nat) : List (Nat × Nat) :=
  (List.range 67).reverse.map fun i =>
    let e := clock.2/2^i
    let prev := clock.2/2^(i+1)
    (e-2*prev,clock.1*e/clock.2-2*(clock.1*prev/clock.2))

private def ratioBound (clock : Nat × Nat) : Mantissa :=
  (trace clock).foldl advance ⟨0,0,precision⟩

def envelope (high low rank : Nat) : List Nat :=
  List.replicate (rank-2) low ++ List.replicate (92-rank) high

private def checked (clock : Nat × Nat) (high low rank : Nat) : Bool :=
  let b := ratioBound clock
  decide (b.oddExp=clock.2 ∧ b.dyadicExp=clock.1 ∧
    b.bound*shiftedProduct (envelope high low rank)<precision*product (envelope high low rank))

private theorem fromCheck {clock : Nat × Nat} {high low rank : Nat}
    (ok : checked clock high low rank=true) :
    3^clock.2*shiftedProduct (envelope high low rank)<
      2^clock.1*product (envelope high low rank) := by
  let b := ratioBound clock
  have bValid : b.valid := fold_valid (trace clock) _
    (by simp [Mantissa.valid])
  unfold checked at ok
  obtain ⟨hd,hk,hstrict⟩ := of_decide_eq_true ok
  change precision*3^b.oddExp≤b.bound*2^b.dyadicExp at bValid
  rw [show b.oddExp=clock.2 from hd,show b.dyadicExp=clock.1 from hk] at bValid
  apply Nat.lt_of_mul_lt_mul_left (a:=precision)
  calc
    _ = (precision*3^clock.2)*shiftedProduct (envelope high low rank) := by ac_rfl
    _ ≤ (b.bound*2^clock.1)*shiftedProduct (envelope high low rank) := Nat.mul_le_mul_right _ bValid
    _ = (b.bound*shiftedProduct (envelope high low rank))*2^clock.1 := by ac_rfl
    _ < (precision*product (envelope high low rank))*2^clock.1 :=
      Nat.mul_lt_mul_of_pos_right hstrict (Nat.pow_pos (by decide))
    _ = _ := by ac_rfl

/-- One discounted factor at rank 1, and a single certified floor change. -/
private theorem excludeEnvelope {N k high low r : Nat} (first : FirstContraction N k)
    (runs : oddRuns N k=91) (pos : 0<N) (shift : N+1≤orbit N k)
    (loRank : 2≤r) (hiRank : r≤91)
    (lowFloor : ∀ x ∈ (sortedHeights N k).drop 1, low≤x)
    (rank : (valleyTimes N k).countP (fun i => decide (orbit N i<high))<r)
    (strict : 3^(oddCount N k)*shiftedProduct (envelope high low r)<
      2^k*product (envelope high low r)) : False := by
  let xs := sortedHeights N k
  have same : xs.Perm (Terras90RankAssembly.valleyHeights N k) := sortedHeights_perm N k
  have sorted : xs.Pairwise (·≤·) := sortedHeights_ordered N k
  have len : xs.length=91 := by
    rw [same.length_eq,Terras90RankAssembly.valleyHeights,List.length_map,Terras88.valleyTimes_length,runs]
  have tall : high≤xs[r-1]'(by omega) := by
    apply sortedFloorOfCount (by change r-1<xs.length; omega)
    simpa only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def] using
      (show (valleyTimes N k).countP (fun i => decide (orbit N i<high))≤r-1 by omega)
  have shape : (xs.drop 1).length=(envelope high low r).length := by
    simp only [envelope,List.length_drop,List.length_append,List.length_replicate,len]
    omega
  have allPos : ∀ x∈xs.drop 1, 0<x := by
    intro x mem
    have phys := Terras90Q0Price.chronological_lower first x (same.mem_iff.mp (List.mem_of_mem_drop mem))
    omega
  have productPositive (ys : List Nat) (positive : ∀ x∈ys, 0<x) : 0<product ys := by
    induction ys with
    | nil => decide
    | cons a rest ih =>
      exact Nat.mul_pos (positive a List.mem_cons_self)
        (ih fun y mem => positive y (List.mem_cons_of_mem a mem))
  refine TerrasDisplacement.excludeFromEnvelope shape ?_ (productPositive _ allPos)
    (TerrasDisplacement.singleDiscount pos first shift sorted same) strict
  intro p mem
  obtain ⟨i,hi,item⟩ := List.mem_iff_getElem.mp mem
  have sides : i<(xs.drop 1).length ∧ i<(envelope high low r).length := by
    simpa only [List.length_zip,Nat.lt_min] using hi
  rw [List.getElem_zip] at item
  rw [←item]
  by_cases early : i<r-2
  · have within : i<(List.replicate (r-2) low).length := by simpa using early
    rw [show (envelope high low r)[i]'sides.2=low by
      unfold envelope
      rw [List.getElem_append_left within,List.getElem_replicate]]
    exact lowFloor _ (List.getElem_mem sides.1)
  · have later : (List.replicate (r-2) low).length≤i := by simp; omega
    rw [show (envelope high low r)[i]'sides.2=high by
      unfold envelope
      rw [List.getElem_append_right later,List.getElem_replicate]]
    rw [List.getElem_drop]
    apply floor_tail sorted (r:=r-1) (by omega) tall
    have idx : 1+i-(r-1)<(xs.drop (r-1)).length := by
      simp only [List.length_drop] at sides ⊢
      omega
    exact List.mem_iff_getElem.mpr ⟨_,idx,by rw [List.getElem_drop]; congr 1; omega⟩

/-- The 15 direct exclusions. The clock order agrees with the outward-rounded
sieve. Each entry records the first guaranteed one-based rank at height 2^92-1. -/
def directRows : List ((Nat × Nat) × Nat) :=
  [((1260236491051329530,795120698740773566),10),
   ((7984791619272937798,5037842608667313239),6),
   ((15339464993020210831,9678124867964239695),5),
   ((22064020121241819099,13920846777890779368),4),
   ((29418693494989092132,18561129037187705824),3),
   ((36773366868736365165,23201411296484632280),3),
   ((43497921996957973433,27444133206411171953),2),
   ((50852595370705246466,32084415465708098409),2),
   ((58207268744452519499,36724697725005024865),2),
   ((65561942118199792532,41364979984301951321),2),
   ((86995843993915946866,54888266412822343906),2),
   ((94350517367663219899,59528548672119270362),2),
   ((123139092617126647266,77692117359936589403),2),
   ((130493765990873920299,82332399619233515859),2),
   ((166637014614084620699,105136250566347761356),2)]

/-- The two remaining non-Q0 clocks force a real Q0 Weaver window.
Here the rank is measured at height 2^146-1. -/
def windowRows : List ((Nat × Nat) × Nat) := [(q1Clock,7),(twiceQ1Clock,6)]

private def directGood (row : (Nat × Nat) × Nat) : Bool :=
  decide (2≤row.2 ∧ row.2≤10 ∧ Terras91Q0Floors.paddedArithmetic 92 row.2 row.1.2) &&
    checked row.1 floor92 verifiedHeight row.2

private def windowGood (row : (Nat × Nat) × Nat) : Bool :=
  decide (2≤row.2 ∧ row.2≤7 ∧ Terras91Q0Floors.paddedArithmetic 146 row.2 row.1.2) &&
    checked row.1 floor146 q0Price row.2

set_option maxHeartbeats 0 in
theorem directChecks : directRows.all directGood=true := by decide

set_option maxHeartbeats 0 in
theorem windowChecks : windowRows.all windowGood=true := by decide

theorem excludesDirect {N k r : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=91) (shift : N+1≤orbit N k)
    (six92 : Terras90.SixRunCapacity 92)
    (row : ((k,oddCount N k),r)∈directRows) : False := by
  have check := List.all_eq_true.mp directChecks _ row
  obtain ⟨tests,ok⟩ := Bool.and_eq_true_iff.mp check
  obtain ⟨lo,hi,arithmetic⟩ := of_decide_eq_true tests
  have rank := Terras91Q0Floors.rankFloorOfSix first runs rfl lo (by omega) six92 arithmetic
  apply excludeEnvelope first runs (by omega) shift lo (by omega) ?_ rank (fromCheck ok)
  intro x mem
  have real := (sortedHeights_perm N k).mem_iff.mp (List.mem_of_mem_drop mem)
  exact Nat.le_trans (Nat.le_of_lt base) (Terras90Q0Price.chronological_lower first x real)

theorem forcesWindow {N k r : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (runs : oddRuns N k=91) (shift : N+1≤orbit N k)
    (six146 : Terras90.SixRunCapacity 146)
    (row : ((k,oddCount N k),r)∈windowRows) : HasWindow N k q0Price floor146 5 := by
  have check := List.all_eq_true.mp windowChecks _ row
  obtain ⟨tests,ok⟩ := Bool.and_eq_true_iff.mp check
  obtain ⟨lo,hi,arithmetic⟩ := of_decide_eq_true tests
  have rank := Terras91Q0Floors.rankFloorOfSix first runs rfl lo (by omega) six146 arithmetic
  let xs := sortedHeights N k
  have same := sortedHeights_perm N k
  have ordered := sortedHeights_ordered N k
  have len : xs.length=91 := by
    rw [same.length_eq,Terras90RankAssembly.valleyHeights,List.length_map,Terras88.valleyTimes_length,runs]
  change (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))<r at rank
  have within : 1<xs.length := by omega
  have cheap : xs[1]'within<q0Price := by
    by_cases yes : xs[1]'(by omega)<q0Price
    · exact yes
    exact (excludeEnvelope first runs (by omega) shift lo (by omega)
      (floor_tail (xs:=xs) ordered (r:=1) within (Nat.le_of_not_gt yes)) rank (fromCheck ok)).elim
  have enough := rank_count_of_price (xs:=xs) ordered (r:=1) within cheap
  rw [same.countP_eq] at enough
  simp only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def] at enough
  have late : 1<k := by
    by_cases long : 1<k
    · exact long
    have small : k=0 ∨ k=1 := by omega
    rcases small with rfl | rfl
    · simp [oddRuns] at runs
    · cases h : startsOddRun N 0 <;> simp [oddRuns,h] at runs
  have odd : N%2=1 := by
    by_cases yes : N%2=1
    · exact yes
    have early := first.2 1 late
    simp [oddCount,orbit,yes] at early
  exact TerrasDisplacement.windowOfCounts (paid:=2) (cap:=r-1) base first odd
    (by decide) (by decide) enough (by omega) (by omega) (by omega)

end Terras91Products

#print axioms Terras91Products.directChecks
#print axioms Terras91Products.windowChecks
#print axioms Terras91Products.excludesDirect
#print axioms Terras91Products.forcesWindow
