import Front4bFourShortRank

namespace CollatzCharacterBridge.Front4bFourShortCrossing

open StagedCylinder (Segment compose)
open A2FirstCrossingFusion (FirstCrossing HitsBelow reduce_first_crossing)
open A2SecondSwitchWordCompiler (compile_word)
open Front4bRowEven (originalSeed originalSeedFormula pivot originalCost)
open Front4bS29Landing (landing history62)
open Front4bE1 (entry5 entry5History)
open P5CompensationMeetings (Affine affine_admissible)

set_option maxRecDepth 14000
set_option maxHeartbeats 1600000

private theorem entryFromPivot (t : Nat) :
    Segment (pivot (10+128*t)) (entry5.at t) 4 6 73 := by
  have start := affine_admissible (f:=landing) (by decide) (10+128*t)
  have stop := affine_admissible (f:=entry5) (by decide) t
  have book : 64*entry5.at t=81*pivot (10+128*t)+73 := by
    simp only [pivot,landing,entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact compile_word [1,1,2,2] start.1 start.2 stop.1 stop.2
    (by intro a ha; simp at ha; omega) book

private theorem consume {u Z : Nat} (tail : Segment (pivot u) Z 17 27 308574187)
    (below : Z<pivot u) :
    FirstCrossing (originalSeed u) (pivot u) Z
      62 98 2417122598839266567112547605177 17 27 308574187 := by
  have odd := (affine_admissible (f:=landing) (by decide) u).2
  have guard : 1<originalSeed u ∧ pivot u<2*originalSeed u+1 := by
    simp only [pivot,landing,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have hit : HitsBelow (pivot u) (pivot u) 17 :=
    ⟨17,by decide,by rw [A2Header.physical_endpoint tail.physical]; exact below⟩
  exact reduce_first_crossing guard.1 odd guard.2 (history62 u) tail hit

/-- With no post-four twos, the actual continuation (1,3) reaches the
old A2 pivot window. The first-crossing consumer retains the same N. -/
theorem crossAfterOneThree {t U W Z : Nat}
    (postFour : Segment (entry5.at t) U 11 17 260843)
    (one : Segment U W 1 1 1) (three : Segment W Z 1 3 1) :
    let u := 10+128*t
    originalSeed u<Z ∧ Z<pivot u ∧
    FirstCrossing (originalSeed u) (pivot u) Z
      62 98 2417122598839266567112547605177 17 27 308574187 ∧
    Segment (originalSeed u) Z 79 125 409938669746458470781450280772615731179 := by
  dsimp only
  have localPath : Segment (entry5.at t) Z 13 21 3002947 :=
    compose (compose postFour one) three
  have book : 2097152*Z=1594323*entry5.at t+3002947 := localPath.book
  have lower : 2097152*originalSeed (10+128*t)<1594323*entry5.at t+3002947 := by
    simp only [entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have upper : 1594323*entry5.at t+3002947<2097152*pivot (10+128*t) := by
    simp only [pivot,landing,entry5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [←book] at lower upper
  have nBelow := Nat.lt_of_mul_lt_mul_left lower
  have vAbove := Nat.lt_of_mul_lt_mul_left upper
  have tail : Segment (pivot (10+128*t)) Z 17 27 308574187 :=
    compose (entryFromPivot t) localPath
  exact ⟨nBelow,vAbove,consume tail vAbove,compose (history62 _) tail⟩

private theorem floorN (t : Nat) : 1000≤originalSeed (10+128*t) := by
  rw [originalSeedFormula]
  omega

private theorem smallEntry (t : Nat) : 4*entry5.at t≤7*originalSeed (10+128*t) := by
  simp only [entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
  omega

/-- With no post-four twos, a single one followed by any actual
valuation at least four descends directly below the original seed. -/
theorem zeroDoseStrongDescent {t U W Z e : Nat} (strong : 4≤e)
    (postFour : Segment (entry5.at t) U 11 17 260843)
    (one : Segment U W 1 1 1) (edge : Segment W Z 1 e 1) :
    let N := originalSeed (10+128*t)
    Z<N ∧ Segment N Z 79 (104+(18+e))
      (1594323*originalCost 4 73+2^104*3002947) := by
  let N := originalSeed (10+128*t)
  have localPath : Segment (entry5.at t) Z 13 (18+e) 3002947 :=
    compose (compose postFour one) edge
  have height : 4*entry5.at t≤7*N := smallEntry t
  have large : 1000≤N := floorN t
  have pay : 1594323*entry5.at t+3002947<4194304*N := by omega
  have den : (4194304:Nat)≤2^(18+e) :=
    Nat.pow_le_pow_right (by decide : 0<2) (show 22≤18+e by omega)
  have strict := Nat.lt_of_lt_of_le pay (Nat.mul_le_mul_right _ den)
  have exactPay : 2^(18+e)*Z<2^(18+e)*N := by
    rw [localPath.book]
    exact strict
  exact ⟨Nat.lt_of_mul_lt_mul_left exactPay,compose (entry5History t).1 localPath⟩

/-- With one post-four dose, a single one followed by any actual
valuation at least three descends directly below the original seed. -/
theorem oneDoseStrongDescent {t U W Z e : Nat} (strong : 3≤e)
    (postDose : Segment (entry5.at t) U 12 19 913601)
    (one : Segment U W 1 1 1) (edge : Segment W Z 1 e 1) :
    let N := originalSeed (10+128*t)
    Z<N ∧ Segment N Z 80 (104+(20+e))
      (4782969*originalCost 4 73+2^104*10843849) := by
  let N := originalSeed (10+128*t)
  have localPath : Segment (entry5.at t) Z 14 (20+e) 10843849 :=
    compose (compose postDose one) edge
  have height : 4*entry5.at t≤7*N := smallEntry t
  have large : 1000≤N := floorN t
  have pay : 4782969*entry5.at t+10843849<8388608*N := by omega
  have den : (8388608:Nat)≤2^(20+e) :=
    Nat.pow_le_pow_right (by decide : 0<2) (show 23≤20+e by omega)
  have strict := Nat.lt_of_lt_of_le pay (Nat.mul_le_mul_right _ den)
  have exactPay : 2^(20+e)*Z<2^(20+e)*N := by
    rw [localPath.book]
    exact strict
  exact ⟨Nat.lt_of_mul_lt_mul_left exactPay,compose (entry5History t).1 localPath⟩

private def zeroThreeEnd : Affine :=
  ⟨85024976204835324046717778946619883351,2*3^79⟩

/-- t=452384 mod 524288 realizes the zero-dose crossing with a real
(1,3), inside the original t=59168 mod 65536 short class. -/
theorem zeroDoseCrossingFamily (k : Nat) :
    let t := 452384+524288*k
    let u := 10+128*t
    let Z := zeroThreeEnd.at k
    t%65536=59168 ∧ originalSeed u<Z ∧ Z<pivot u ∧
    FirstCrossing (originalSeed u) (pivot u) Z
      62 98 2417122598839266567112547605177 17 27 308574187 ∧
    Segment (originalSeed u) Z 79 125 409938669746458470781450280772615731179 := by
  let t := 452384+524288*k
  let u := 10+128*t
  let Z := zeroThreeEnd.at k
  have start := affine_admissible (f:=landing) (by decide) u
  have stop := affine_admissible (f:=zeroThreeEnd) (by decide) k
  have book : 134217728*Z=129140163*pivot u+308574187 := by
    simp only [Z,u,t,pivot,landing,zeroThreeEnd,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path : Segment (pivot u) Z 17 27 308574187 :=
    compile_word [1,1,2,2,1,1,1,2,2,1,1,1,2,1,4,1,3]
      start.1 start.2 stop.1 stop.2 (by intro a ha; simp at ha; omega) book
  have range : originalSeed u<Z ∧ Z<pivot u := by
    simp only [Z,u,t,pivot,landing,zeroThreeEnd,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have cylinder : t%65536=59168 := by dsimp only [t]; omega
  exact ⟨cylinder,range.1,range.2,consume path range.2,compose (history62 u) path⟩

private def oneThreeEnd : Affine :=
  ⟨290101002194343688112790749838489336965,2*3^80⟩

/-- t=2058016 mod 2097152 realizes the one-dose descent on a
whole subcylinder of t=223008 mod 262144. -/
theorem oneDoseDescentFamily (k : Nat) :
    let t := 2058016+2097152*k
    let u := 10+128*t
    let Z := oneThreeEnd.at k
    t%262144=223008 ∧ Z<originalSeed u ∧
      Segment (originalSeed u) Z 80 127 1267034393121353056785657440005696841665 := by
  let t := 2058016+2097152*k
  let u := 10+128*t
  let Z := oneThreeEnd.at k
  have start := affine_admissible (f:=landing) (by decide) u
  have stop := affine_admissible (f:=oneThreeEnd) (by decide) k
  have book : 536870912*Z=387420489*pivot u+1043163073 := by
    simp only [Z,u,t,pivot,landing,oneThreeEnd,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path : Segment (pivot u) Z 18 29 1043163073 :=
    compile_word [1,1,2,2,1,1,1,2,2,1,1,1,2,1,4,2,1,3]
      start.1 start.2 stop.1 stop.2 (by intro a ha; simp at ha; omega) book
  have below : Z<originalSeed u := by
    simp only [Z,u,t,oneThreeEnd,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have cylinder : t%262144=223008 := by dsimp only [t]; omega
  exact ⟨cylinder,below,compose (history62 u) path⟩

end CollatzCharacterBridge.Front4bFourShortCrossing

#print axioms CollatzCharacterBridge.Front4bFourShortCrossing.crossAfterOneThree
#print axioms CollatzCharacterBridge.Front4bFourShortCrossing.zeroDoseStrongDescent
#print axioms CollatzCharacterBridge.Front4bFourShortCrossing.oneDoseStrongDescent
#print axioms CollatzCharacterBridge.Front4bFourShortCrossing.zeroDoseCrossingFamily
#print axioms CollatzCharacterBridge.Front4bFourShortCrossing.oneDoseDescentFamily
