import Terras90LatticeData

namespace Terras90Lattice

def sourceBoundary : Nat := 28000000000000000000

def capacityCeilings : List Nat :=
  [1085047766188405879,684572723147259231,431907080850005825,272496580977921658,
   171922133109098840,108468222781765832,68434209956950054,43176157701545779,
   27240478045139296,17186421479583156,10843168125919976,6841115536858034,
   4316161221992455,2723130108512596,1718063159944861,1083951520469950]

private def rationalNumerator : Nat → Nat
  | 0 => 0
  | t+1 => 1000^(t+1)+1585*rationalNumerator t

def roundedCapacity (r : Nat) : Nat :=
  let t := 91-r
  let den := 1000^t
  (rationalNumerator t+(r-1)*den+den-1)/den

theorem rationalAlphaBound : 1000*log3High < 1585*log2Low := by decide

set_option maxRecDepth 8000 in
theorem capacitiesChecked :
    (List.range 16).map (fun i => roundedCapacity (i+2))=capacityCeilings ∧
    (List.range 73).all (fun i => decide (180*roundedCapacity (i+18)≤basisD))=true := by
  decide

def ceilScore (x : Nat) : Nat := (budgetScale-1)/x+1

def reciprocalBound (height : Nat) : Nat := ceilScore (max sourceBoundary (2^height-1))

def ordinaryBudget (d : Nat) : Nat :=
  ceilScore (sourceBoundary*(sourceBoundary+1)) +
    (capacityCeilings.map (fun cap => reciprocalBound (min 180 (d/cap)))).sum +
    73*reciprocalBound 180

def survivors : List (Nat × Nat) :=
  [(630118245525664765,397560349370386783),
   (1260236491051329530,795120698740773566),
   (7354673373747273033,4640282259296926456),
   (7984791619272937798,5037842608667313239),
   (14709346747494546066,9280564518593852912),
   (22064020121241819099,13920846777890779368),
   (29418693494989092132,18561129037187705824),
   (43497921996957973433,27444133206411171953),
   (50852595370705246466,32084415465708098409),
   (58207268744452519499,36724697725005024865),
   (86995843993915946866,54888266412822343906)]

private def permits (h j : Nat) : Bool :=
  let d := (toClock h j).2
  decide (d<maxOdds ∧ (h:Int)*basisLow-(j:Int)*epsilonHigh < 100000*(ordinaryBudget d:Int))

def checkAt (h : Nat) : Bool :=
  let lo := jLower h
  let hi := jUpper h
  (List.range (hi+1-lo)).all (fun off =>
    let j := lo+off
    if permits h j then decide (toClock h j ∈ survivors) else true)

def checkChunk (start width : Nat) : Bool :=
  (List.range width).all (fun off => checkAt (start+off))

def chunks : List Nat := [0,1]

set_option maxRecDepth 8000 in
set_option maxHeartbeats 0 in
theorem checkedClockTable :
    chunks.all (fun block => checkChunk (97*block+1) 97)=true := by decide

theorem listedClocksPass :
    survivors.all (fun pair => decide (pair.2<maxOdds ∧
      lowGap pair.1 pair.2<globalGap ∧ 0<highGap pair.1 pair.2 ∧
      lowGap pair.1 pair.2<100000*(ordinaryBudget pair.2:Int)))=true := by
  decide

private theorem prefixCovers {h j : Nat} (positive : 1≤h) (within : h<194)
    (lower : jLower h≤j) (upper : j≤jUpper h) (odds : (toClock h j).2<maxOdds)
    (budget : (h:Int)*basisLow-(j:Int)*epsilonHigh<100000*(ordinaryBudget (toClock h j).2:Int)) :
    toClock h j∈survivors := by
  let block := (h-1)/97
  let off := (h-1)%97
  have offRange : off<97 := Nat.mod_lt _ (by decide)
  have offset : 97*block+1+off=h := by
    have split := Nat.mod_add_div (h-1) 97
    change off+97*block=h-1 at split
    omega
  have blockRange : block<2 := by
    change (h-1)/97<2
    apply (Nat.div_lt_iff_lt_mul (by decide : 0<97)).2
    omega
  have blockMem : block∈chunks := by
    unfold chunks
    have cases : block=0 ∨ block=1 := by omega
    rcases cases with e | e <;> simp [e]
  have chunk := (List.all_eq_true.mp checkedClockTable) block blockMem
  have row := (List.all_eq_true.mp chunk) off (List.mem_range.mpr offRange)
  change checkAt (97*block+1+off)=true at row
  rw [offset] at row
  let column := j-jLower h
  have colRange : column<jUpper h+1-jLower h := by unfold column; omega
  have colEq : jLower h+column=j := by unfold column; omega
  unfold checkAt at row
  have cert := (List.all_eq_true.mp row) column (List.mem_range.mpr colRange)
  change (if permits h (jLower h+column) then decide (toClock h (jLower h+column)∈survivors)
    else true)=true at cert
  rw [colEq] at cert
  have pass : permits h j=true := by simp [permits,odds,budget]
  simpa [pass] using cert

private theorem jLowerMo {a b : Nat} (ab : a≤b) : jLower a≤jLower b := by
  have prodLe := Nat.mul_le_mul_right basisLow ab
  by_cases has : globalGap≤a*basisLow
  · have grows := Nat.le_trans has prodLe
    simp only [jLower,if_pos has,if_pos grows]
    exact Nat.add_le_add_right (Nat.div_le_div_right (Nat.sub_le_sub_right prodLe _)) _
  · simp [jLower,has]

private theorem weightAnti {a b : Nat} (ab : a≤b) : reciprocalBound b≤reciprocalBound a := by
  unfold reciprocalBound ceilScore
  have grow := Nat.pow_le_pow_right (by decide : 0<2) ab
  have den := Nat.sub_le_sub_right grow 1
  have le : max sourceBoundary (2^a-1) ≤ max sourceBoundary (2^b-1) :=
    Nat.max_le.mpr ⟨Nat.le_max_left _ _, Nat.le_trans den (Nat.le_max_right _ _)⟩
  have pos : 0<max sourceBoundary (2^a-1) :=
    Nat.lt_of_lt_of_le (by decide : 0<sourceBoundary) (Nat.le_max_left _ _)
  exact Nat.add_le_add_right (Nat.div_le_div_left le pos) _

private theorem ordinaryAnti {a b : Nat} (ab : a≤b) : ordinaryBudget b≤ordinaryBudget a := by
  have scores (l : List Nat) :
      (l.map fun cap => reciprocalBound (min 180 (b/cap))).sum ≤
        (l.map fun cap => reciprocalBound (min 180 (a/cap))).sum := by
    induction l with
    | nil => simp
    | cons cap rest ih =>
      have dlo : a/cap≤b/cap := Nat.div_le_div_right ab
      have lo : min 180 (a/cap)≤min 180 (b/cap) :=
        Nat.le_min.mpr ⟨Nat.min_le_left _ _, Nat.le_trans (Nat.min_le_right _ _) dlo⟩
      exact Nat.add_le_add (weightAnti lo) ih
  unfold ordinaryBudget
  exact Nat.add_le_add_right (Nat.add_le_add_left (scores _) _) _

private theorem farey
    (h j : Nat) (left : 532*h<487*j) (right : 5173*j<5651*h) : 5660≤h := by
  omega

private theorem highNeighbor {h j : Nat} (hlen : 0<h) (upper : j≤jUpper h) :
    5173*j<5651*h := by
  have bound := (Nat.le_div_iff_mul_le (by decide : 0<epsilonLow)).mp upper
  have positive := Nat.mul_pos hlen (by decide : 0<basisHigh)
  have strict : j*epsilonLow < h*basisHigh := by omega
  have atTop : 5173*basisHigh<5651*epsilonLow := by decide
  have scaled : (5173*j)*epsilonLow<(5651*h)*epsilonLow := by
    calc
      _ = 5173*(j*epsilonLow) := by ac_rfl
      _ < 5173*(h*basisHigh) := Nat.mul_lt_mul_of_pos_left strict (by decide)
      _ = h*(5173*basisHigh) := by ac_rfl
      _ < h*(5651*epsilonLow) := Nat.mul_lt_mul_of_pos_left atTop hlen
      _ = _ := by ac_rfl
  exact Nat.lt_of_mul_lt_mul_right scaled

private def highStart : Nat := 194
private def minHighOdds : Nat := highStart*basisD+jLower highStart*otherD

private theorem lowNeighbor {h j : Nat} (hmin : highStart≤h) (jmin : jLower h≤j)
    (budget : (h:Int)*basisLow-(j:Int)*epsilonHigh<100000*(ordinaryBudget (toClock h j).2:Int)) :
    532*h<487*j := by
  have minOdds : minHighOdds≤(toClock h j).2 := by
    apply Nat.add_le_add
    · exact Nat.mul_le_mul_right _ hmin
    · exact Nat.mul_le_mul_right _ (Nat.le_trans (jLowerMo hmin) jmin)
  have budgetCap := ordinaryAnti minOdds
  by_cases contrary : 532*h<487*j
  · exact contrary
  · exfalso
    let c : Int := 487*(basisLow:Int)-532*epsilonHigh
    have cPos : 0≤c := by decide
    have residual : 0≤532*(h:Int)-487*(j:Int) := by omega
    have nonnegative := Int.mul_nonneg residual (by decide : 0≤(epsilonHigh:Int))
    have identity : 487*((h:Int)*basisLow-(j:Int)*epsilonHigh) =
        h*c+(532*(h:Int)-487*(j:Int))*epsilonHigh := by
      unfold c
      simp only [Int.mul_sub,Int.sub_mul]
      rw [show 487*((h:Int)*basisLow)=h*(487*(basisLow:Int)) by ac_rfl,
        show 487*((j:Int)*epsilonHigh)=487*(j:Int)*epsilonHigh by ac_rfl,
        show (h:Int)*(532*epsilonHigh)=532*(h:Int)*epsilonHigh by ac_rfl]
      omega
    have scaledBudget := Int.mul_lt_mul_of_pos_left budget (by decide : (0:Int)<487)
    have scaledCap := Int.mul_le_mul_of_nonneg_left (Int.ofNat_le.mpr budgetCap)
      (by decide : (0:Int)≤487*100000)
    have under : 487*((h:Int)*basisLow-(j:Int)*epsilonHigh) <
        (487*100000)*(ordinaryBudget minHighOdds:Int) := by
      apply Int.lt_of_lt_of_le scaledBudget
      rw [← Int.mul_assoc]
      exact scaledCap
    have low := Int.mul_le_mul_of_nonneg_right (Int.ofNat_le.mpr hmin) cPos
    have hand : (487*100000)*(ordinaryBudget minHighOdds:Int)<(highStart:Int)*c := by decide
    rw [identity] at under
    omega

theorem tableCovers {h j : Nat} (positive : 1≤h) (within : h≤maxIndex)
    (lower : jLower h≤j) (upper : j≤jUpper h) (odds : (toClock h j).2<maxOdds)
    (budget : (h:Int)*basisLow-(j:Int)*epsilonHigh<100000*(ordinaryBudget (toClock h j).2:Int)) :
    toClock h j∈survivors := by
  by_cases early : h<194
  · exact prefixCovers positive early lower upper odds budget
  · have forced := farey h j (lowNeighbor (by exact Nat.le_of_not_gt early) lower budget)
      (highNeighbor (by omega) upper)
    unfold maxIndex at within
    omega

end Terras90Lattice
