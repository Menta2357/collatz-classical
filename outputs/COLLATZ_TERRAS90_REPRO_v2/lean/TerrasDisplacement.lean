import Terras90RankAssembly

namespace TerrasDisplacement

open TerrasClock
open Terras88 (valleyTimes q0Clock q0Price verifiedHeight HasWindow)
open Terras90Q0Price (chronologicalHeights product shiftedProduct floor92 floor146)
open Terras90RankAssembly (sortedHeights sortedHeights_perm sortedHeights_ordered)

set_option maxRecDepth 8000
set_option maxHeartbeats 800000

private theorem oddFromPositiveShift {N k : Nat} (first : FirstContraction N k)
    (shift : N+1≤orbit N k) : N%2=1 := by
  by_cases odd : N%2=1
  · exact odd
  have even : N%2=0 := by omega
  have positive := first_contraction_pos first
  have earlier : k≤1 := by
    by_cases h : k≤1
    · exact h
    · have before := first.2 1 (by omega)
      simp [oddCount,orbit,odd] at before
  have atOne : k=1 := by omega
  rw [atOne] at shift
  change N+1≤shortcut N at shift
  have physical := shortcut_even even
  omega

private theorem additivePositive {N k : Nat} (odd : N%2=1) (positive : 0<k) :
    0<additive N k := by
  induction k with
  | zero => omega
  | succ k ih =>
    cases k with
    | zero => simp [additive,orbit,odd]
    | succ m =>
      have prev := ih (Nat.succ_pos m)
      change 0 < (if orbit N (m+1)%2=1 then 3*additive N (m+1)+2^(m+1) else additive N (m+1))
      split
      · exact Nat.lt_of_lt_of_le (Nat.mul_pos (by decide) prev) (Nat.le_add_right _ _)
      · exact prev

/-- A nonzero index before the first contraction is strictly above the initial
odd seed, since the initial odd step contributes a positive additive. -/
theorem prior_strict {N k i : Nat} (odd : N%2=1) (first : FirstContraction N k)
    (positive : 0<i) (before : i<k) : N<orbit N i := by
  have above := prior_no_descent first before
  by_cases strict : N<orbit N i
  · exact strict
  have equal : orbit N i=N := by omega
  have historical := exact_book N i
  rw [equal] at historical
  have coefficient := Nat.mul_le_mul_right N (first.2 i before)
  have cost := additivePositive odd positive
  omega

private theorem timeHead {N k : Nat} (odd : N%2=1) (positive : 0<k) :
    ∃ ts, valleyTimes N k=0::ts := by
  cases k with
  | zero => omega
  | succ k =>
    rw [valleyTimes,List.range_succ_eq_map,List.filter_cons]
    have start : startsOddRun N 0=true := (startsOddRun_iff _ _).mpr ⟨odd,Or.inl rfl⟩
    simp [start]

/-- The product budget at the real first crossing uses the unshifted
endpoint, because its final source is even. -/
theorem physicalCrossingProduct {N k : Nat} (first : FirstContraction N k) :
    2^k*orbit N k*product (chronologicalHeights N k)≤
      3^(oddCount N k)*N*shiftedProduct (chronologicalHeights N k) := by
  cases k with
  | zero => exact (Nat.not_lt_zero _ (first_contraction_pos first)).elim
  | succ j =>
    have budget := Terras90Q0Price.physicalPrefixProduct N (j+1)
    have even := first_contraction_last_even first
    have notOdd : ¬orbit N j%2=1 := by omega
    change 2^(j+1)*(orbit N (j+1)+(if orbit N j%2=1 then 1 else 0))*_≤_ at budget
    simpa only [if_neg notOdd,Nat.add_zero] using budget

/-- Any positive displacement also pays for dropping the lowest factor.
The statement accepts arbitrary sorted clocks, not just Q0. -/
theorem singleDiscount {N k : Nat} {xs : List Nat} (pos : 0<N)
    (first : FirstContraction N k) (shift : N+1≤orbit N k)
    (ordered : xs.Pairwise (·≤·)) (same : xs.Perm (chronologicalHeights N k)) :
    2^k*product (xs.drop 1)≤3^(oddCount N k)*shiftedProduct (xs.drop 1) := by
  obtain ⟨ts,head⟩ := timeHead (oddFromPositiveShift first shift) (first_contraction_pos first)
  have timeline : chronologicalHeights N k=N::ts.map (orbit N) := by
    simp only [chronologicalHeights,head,List.map_cons,orbit]
  have inSorted : N∈xs := same.mem_iff.mpr (by rw [timeline]; simp)
  have allBefore := Terras90Q0Price.chronological_lower first
  cases xs with
  | nil => simp at inSorted
  | cons U rest =>
    have headLe : U≤N := by
      rcases List.mem_cons.mp inSorted with eq | later
      · omega
      · exact (List.pairwise_cons.mp ordered).1 _ later
    have headAbove := allBefore U (same.mem_iff.mp List.mem_cons_self)
    have sameHead : U=N := Nat.le_antisymm headLe headAbove
    subst U
    have budget := physicalCrossingProduct first
    rw [←Terras90Q0Price.product_perm same,←Terras90Q0Price.shiftedProduct_perm same] at budget
    change 2^k*product rest≤3^(oddCount N k)*shiftedProduct rest
    have common : 0<N*(N+1) := Nat.mul_pos pos (by omega)
    apply Nat.le_of_mul_le_mul_left _ common
    calc
      _ = (2^k*(N+1))*(N*product rest) := by ac_rfl
      _ ≤ (2^k*orbit N k)*(N*product rest) := Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ shift)
      _ ≤ 3^(oddCount N k)*N*shiftedProduct (N::rest) := budget
      _ = _ := by simp only [shiftedProduct,List.map_cons,product]; ac_rfl

private theorem cancelTwo {a b N V Z : Nat} {rest : List Nat}
    (pos : 0<N) (after : N+1≤V) (shift : N+2≤Z)
    (budget : b*Z*product (N::V::rest)≤a*N*shiftedProduct (N::V::rest)) :
    b*product rest≤a*shiftedProduct rest := by
  have credit : (N+1)*(V+1)≤(N+2)*V := by
    simp only [Nat.add_mul,Nat.mul_add,Nat.mul_one,Nat.one_mul]
    omega
  have fee : 0<N*((N+2)*V) := Nat.mul_pos pos (Nat.mul_pos (by omega) (by omega))
  apply Nat.le_of_mul_le_mul_left _ fee
  calc
    _ = (b*(N+2))*(N*(V*product rest)) := by ac_rfl
    _ ≤ (b*Z)*(N*(V*product rest)) := Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ shift)
    _ ≤ a*N*shiftedProduct (N::V::rest) := budget
    _ = (a*shiftedProduct rest)*(N*((N+1)*(V+1))) := by
      simp only [shiftedProduct,List.map_cons,product]
      ac_rfl
    _ = (N*((N+1)*(V+1)))*(a*shiftedProduct rest) := by ac_rfl
    _ ≤ _ := Nat.mul_le_mul_right _ (Nat.mul_le_mul_left N credit)

/-- A displacement of at least two discounts the two lowest valley factors
on the original history, independently of their exact heights. -/
theorem doubleDiscount {N k : Nat} {xs : List Nat} (pos : 0<N)
    (first : FirstContraction N k) (shift : N+2≤orbit N k)
    (many : 2≤xs.length) (ordered : xs.Pairwise (·≤·))
    (same : xs.Perm (chronologicalHeights N k)) :
    2^k*product (xs.drop 2)≤3^(oddCount N k)*shiftedProduct (xs.drop 2) := by
  have odd := oddFromPositiveShift first (by omega)
  obtain ⟨ts,head⟩ := timeHead odd (first_contraction_pos first)
  have timeline : chronologicalHeights N k=N::ts.map (orbit N) := by
    simp only [chronologicalHeights,head,List.map_cons,orbit]
  have inSorted : N∈xs := same.mem_iff.mpr (by rw [timeline]; simp)
  have allBefore := Terras90Q0Price.chronological_lower first
  cases xs with
  | nil => simp at many
  | cons U tail =>
    have headLe : U≤N := by
      rcases List.mem_cons.mp inSorted with eq | later
      · omega
      · exact (List.pairwise_cons.mp ordered).1 _ later
    have headAbove := allBefore U (same.mem_iff.mp List.mem_cons_self)
    have eq : U=N := Nat.le_antisymm headLe headAbove
    subst U
    have originalOrder : (valleyTimes N k).Pairwise (·<·) := List.pairwise_lt_range.filter _
    rw [head] at originalOrder
    rw [timeline] at same
    have tailPerm := same.cons_inv
    cases tail with
    | nil => simp at many
    | cons V rest =>
      have vAt := tailPerm.mem_iff.mp (show V∈V::rest from List.mem_cons_self)
      obtain ⟨i,mem,rfl⟩ := List.mem_map.mp vAt
      have ipos := (List.pairwise_cons.mp originalOrder).1 i mem
      have prior : i<k := by
        apply (Terras88.valleyTimes_mem (N:=N) (k:=k) (i:=i) _).1
        rw [head]
        exact List.mem_cons_of_mem _ mem
      have after := prior_strict odd first ipos prior
      have budget := physicalCrossingProduct first
      rw [timeline,←Terras90Q0Price.product_perm same,←Terras90Q0Price.shiftedProduct_perm same] at budget
      exact cancelTwo pos after shift budget

private def largest (l : List Nat) := l.foldr max (2^146)

private theorem leLargest (l : List Nat) : ∀ x ∈ l, x≤largest l := by
  induction l with
  | nil => simp
  | cons a l ih =>
    intro x mem
    rcases List.mem_cons.mp mem with eq | tail
    · subst x
      exact Nat.le_max_left _ _
    · exact Nat.le_trans (ih x tail) (Nat.le_max_right _ _)

/-- Delete one of the discounted positions and append a largest dummy
height. The shifted list satisfies the existing exact sixth-price test. -/
theorem seventh_lt_price_product (xs : List Nat) (len : xs.length=90)
    (ordered : xs.Pairwise (·≤·)) (above : ∀ x∈xs, verifiedHeight≤x)
    (at11 : floor92≤xs[10]'(by omega)) (at12 : floor146≤xs[11]'(by omega))
    (budget : 2^q0Clock.1*product (xs.drop 2)≤3^q0Clock.2*shiftedProduct (xs.drop 2)) :
    xs[6]'(by omega)<q0Price := by
  let z := largest (xs.drop 1)
  let short := xs.drop 1 ++ [z]
  have length : short.length=90 := by simp [short,len]
  have sorted : short.Pairwise (·≤·) := by
    refine List.pairwise_append.mpr ⟨ordered.drop,by simp,?_⟩
    intro x xmem y ymem
    have eq : y=z := by simpa using ymem
    subst y
    exact leLargest _ x xmem
  have minZ : verifiedHeight≤z := by
    have hit : xs[1]'(by omega)∈xs.drop 1 := by
      rw [List.mem_iff_getElem]
      exact ⟨0,by simp [len],by simp⟩
    exact Nat.le_trans (above _ (List.mem_of_mem_drop hit)) (leLargest _ _ hit)
  have minAll : ∀ x∈short, verifiedHeight≤x := by
    intro x mem
    rcases List.mem_append.mp mem with left | right
    · exact above x (List.mem_of_mem_drop left)
    · have e : x=z := by simpa using right
      omega
  have shiftIndex (i : Nat) (bound : i<89) : short[i]'(by omega)=xs[i+1]'(by omega) := by
    unfold short
    rw [List.getElem_append_left (by simp [len]; omega),List.getElem_drop]
    simp [Nat.add_comm]
  have drop : short.drop 1=xs.drop 2++[z] := by
    unfold short
    rw [List.drop_append_of_le_length (by simp [len]), List.drop_drop]
  have newBudget : 2^q0Clock.1*product (short.drop 1)≤3^q0Clock.2*shiftedProduct (short.drop 1) := by
    rw [drop,Terras90Q0Price.product_append,Terras90Q0Price.shiftedProduct_append]
    simp only [product,shiftedProduct,List.map_cons,List.map_nil,Nat.mul_one]
    have next := Nat.mul_le_mul budget (show z≤z+1 by omega)
    simpa only [Nat.mul_assoc] using next
  have cheap := Terras90Q0Price.sixth_lt_price_product short length sorted minAll
    (by rwa [shiftIndex 9 (by decide)]) (by rwa [shiftIndex 10 (by decide)]) newBudget
  rwa [shiftIndex 5 (by decide)] at cheap

/-- Turn a priced lower count and a bounded upper count into an actual
Weaver window. The predicates operate directly on the chronological cuts. -/
theorem windowOfCounts {N k price height span paid cap : Nat} (base : verifiedHeight<N)
    (first : FirstContraction N k) (odd : N%2=1) (ordering : price≤height)
    (paidPositive : 0<paid)
    (cheap : paid≤(valleyTimes N k).countP (fun i => decide (orbit N i<price)))
    (tall : (valleyTimes N k).countP (fun i => decide (orbit N i<height))≤cap)
    (occupied : cap*span<oddRuns N k) (enough : cap<paid+span) : HasWindow N k price height span := by
  let small := fun i => decide (orbit N i<price)
  let upper := fun i => decide (orbit N i<height)
  have compare : (valleyTimes N k).countP small≤(valleyTimes N k).countP upper := by
    apply List.countP_mono_left
    intro i _ below
    simp only [small,upper,decide_eq_true_eq] at below ⊢
    omega
  have seed : N<price := by
    by_cases below : N<price
    · exact below
    have none : (valleyTimes N k).countP small=0 := by
      apply List.countP_eq_zero.mpr
      intro i mem hit
      have lower := prior_no_descent first (Terras88.valleyTimes_mem mem).1
      simp only [small,decide_eq_true_eq] at hit
      omega
    change paid≤(valleyTimes N k).countP small at cheap
    omega
  obtain ⟨times,head⟩ := timeHead odd (first_contraction_pos first)
  have starts : TerrasValleyExtraction.StartsLow small (valleyTimes N k) := by
    rw [head]
    simp [TerrasValleyExtraction.StartsLow,small,orbit,seed]
  apply Terras88.physical_window base first ordering
  refine ⟨small,?_,?_,starts,?_,?_⟩
  · intro i hi
    exact of_decide_eq_true hi
  · intro i _ j _ low high
    have ilt : orbit N i<price := of_decide_eq_true low
    have jle : price≤orbit N j := by simpa only [small,decide_eq_false_iff_not,Nat.not_lt] using high
    omega
  · change (valleyTimes N k).countP upper≤cap at tall
    exact Nat.lt_of_le_of_lt (Nat.mul_le_mul_right _ (Nat.le_trans compare tall)) occupied
  · change (valleyTimes N k).countP upper≤cap at tall
    change paid≤(valleyTimes N k).countP small at cheap
    change (valleyTimes N k).countP upper < (valleyTimes N k).countP small+span
    omega

/-- The Q0 row for endpoint displacement at least two. The adopted Criba
floors are rank eleven at H92 and rank twelve at H146. -/
theorem q0WindowOfShift {N k : Nat} (base : verifiedHeight<N) (first : FirstContraction N k)
    (runs : oddRuns N k=90) (clock : (k,oddCount N k)=q0Clock) (shift : N+2≤orbit N k)
    (at92 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor92))<11)
    (at146 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))<12) :
    HasWindow N k q0Price floor146 5 := by
  let xs := sortedHeights N k
  have same : xs.Perm (chronologicalHeights N k) := sortedHeights_perm N k
  have ranked : xs.Pairwise (·≤·) := sortedHeights_ordered N k
  have len : xs.length=90 := by
    rw [same.length_eq,chronologicalHeights,List.length_map,Terras88.valleyTimes_length,runs]
  have all : ∀ x∈xs, verifiedHeight≤x := fun x mem => Nat.le_trans (Nat.le_of_lt base)
    (Terras90Q0Price.chronological_lower first x (same.mem_iff.mp mem))
  have low : (Terras90RankAssembly.valleyHeights N k).countP (fun x => decide (x<floor92))≤10 := by
    simp only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def]
    omega
  have high : (Terras90RankAssembly.valleyHeights N k).countP (fun x => decide (x<floor146))≤11 := by
    simp only [Terras90RankAssembly.valleyHeights,List.countP_map,Function.comp_def]
    omega
  have rank11 := Terras90RankAssembly.sortedFloorOfCount (rank:=10) (by change 10<xs.length; omega) low
  have rank12 := Terras90RankAssembly.sortedFloorOfCount (rank:=11) (by change 11<xs.length; omega) high
  have paid := doubleDiscount (Nat.lt_of_le_of_lt (Nat.zero_le _) base) first shift (by omega) ranked same
  have clockK : k=q0Clock.1 := congrArg Prod.fst clock
  have clockD : oddCount N k=q0Clock.2 := congrArg Prod.snd clock
  rw [clockD,clockK] at paid
  have cheap := seventh_lt_price_product xs len ranked all rank11 rank12 paid
  have count := Terras90Q0Price.rank_count_of_price ranked (r:=6) (by omega) cheap
  rw [same.countP_eq] at count
  simp only [chronologicalHeights,List.countP_map,Function.comp_def] at count
  exact windowOfCounts (paid:=7) (cap:=11) base first (oddFromPositiveShift first (by omega))
    (by decide) (by decide) count (by omega) (by omega) (by decide)

/-- Exclude displacement at least two at Q0 using the frozen Weaver query.
The exclusion of endpoint equality is supplied by the caller. -/
theorem deltaOneOfQ0 {N k : Nat} (base : verifiedHeight<N) (first : FirstContraction N k)
    (runs : oddRuns N k=90) (clock : (k,oddCount N k)=q0Clock)
    (nondecreasing : N≤orbit N k) (notEqual : orbit N k≠N)
    (at92 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor92))<11)
    (at146 : (valleyTimes N k).countP (fun i => decide (orbit N i<floor146))<12)
    (noWeaver : ¬HasWindow N k q0Price floor146 5) : Terras90.DeltaOneQ0 N k := by
  have notTwo : ¬N+2≤orbit N k := fun shift => noWeaver (q0WindowOfShift base first runs clock shift at92 at146)
  exact ⟨base,first,runs,clock,by omega⟩

/-- Integer product envelope from per-occurrence floors. -/
theorem productEnvelope {xs floors : List Nat} (shape : xs.length=floors.length)
    (above : ∀ pair ∈ xs.zip floors, pair.2≤pair.1) :
    shiftedProduct xs*product floors≤product xs*shiftedProduct floors := by
  induction xs generalizing floors with
  | nil =>
    have empty : floors=[] := List.eq_nil_of_length_eq_zero shape.symm
    subst floors
    exact Nat.le_refl _
  | cons x xs ih =>
    cases floors with
    | nil => simp at shape
    | cons b floors =>
      have atHead : b≤x := above (x,b) (by simp)
      have point : (x+1)*b≤x*(b+1) := by
        simp only [Nat.add_mul,Nat.mul_add,Nat.mul_one,Nat.one_mul]
        exact Nat.add_le_add_left atHead _
      have lower := ih (by simp at shape; exact shape) (fun z hz => above z (by simp [hz]))
      calc
        _ = ((x+1)*b)*(shiftedProduct xs*product floors) := by
          simp only [shiftedProduct,List.map_cons,product]; ac_rfl
        _ ≤ (x*(b+1))*(product xs*shiftedProduct floors) := Nat.mul_le_mul point lower
        _ = _ := by simp only [shiftedProduct,List.map_cons,product]; ac_rfl

/-- Consume exact floor and clock comparisons without logarithms. A
concrete sieve row must still supply all its physical floors and comparison. -/
theorem excludeFromEnvelope {a b : Nat} {xs floors : List Nat}
    (shape : xs.length=floors.length) (above : ∀ pair ∈ xs.zip floors, pair.2≤pair.1)
    (positive : 0<product xs)
    (budget : b*product xs≤a*shiftedProduct xs)
    (strict : a*shiftedProduct floors<b*product floors) : False := by
  have env := productEnvelope shape above
  have clash : (b*product xs)*product floors < (b*product xs)*product floors := by
    calc
      _ ≤ (a*shiftedProduct xs)*product floors := Nat.mul_le_mul_right _ budget
      _ = a*(shiftedProduct xs*product floors) := by ac_rfl
      _ ≤ a*(product xs*shiftedProduct floors) := Nat.mul_le_mul_left _ env
      _ = (a*shiftedProduct floors)*product xs := by ac_rfl
      _ < (b*product floors)*product xs := Nat.mul_lt_mul_of_pos_right strict positive
      _ = _ := by ac_rfl
  exact Nat.lt_irrefl _ clash

end TerrasDisplacement
