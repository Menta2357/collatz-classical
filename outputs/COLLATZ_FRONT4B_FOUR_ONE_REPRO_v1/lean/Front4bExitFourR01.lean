import Front4bLowExit

namespace CollatzCharacterBridge.Front4bExitFourR01

open StagedCylinder (Segment compose)
open A2FirstCrossingFusion (Paid FirstCrossing)
open A2BoundedReducer (RemainingBelow)
open Front4bRowEven (originalSeed originalSeedFormula pivot)
open Front4bS29Landing (landing history62)
open P5CompensationMeetings (Affine affine_admissible)
open A2SecondSwitchWordCompiler (compile_word)

set_option maxRecDepth 16000
set_option maxHeartbeats 1500000

private def stem : List Nat := [1,1,2,1,1,1,2,2,1,1,1,2,1,4]

private theorem reduce {N U X j s B : Nat} (history : Segment N X j s B)
    (big : 1<N) (positive : 0<X) (odd : X%2=1) (price : X<2*N+1) (smaller : X<U) :
    Paid N ∨ RemainingBelow N U := by
  have pay := A2CertifiedLanding.reduce_window_certified big history positive odd price
  rcases pay with descend | meet | remaining
  · exact Or.inl (Or.inl descend)
  · exact Or.inl (Or.inr meet)
  · exact Or.inr (A2BoundedReducer.remaining_strict remaining smaller)

private theorem reduction {u U X C : Nat} (tail : Segment (pivot u) X 18 28 C)
    (positive : 0<X) (odd : X%2=1) (price : X<2*originalSeed u+1) (smaller : X<U) :
    Paid (originalSeed u) ∨ RemainingBelow (originalSeed u) U := by
  have big : 1<originalSeed u := by rw [originalSeedFormula]; omega
  exact reduce (compose (history62 u) tail) big positive odd price smaller

/-- A physical one-run and its full rupture book reenter under the actual
starting pivot when the height bound and multiplicative guard pay. -/
theorem guardedRunReduction {N U X j s B H a : Nat}
    (history : Segment N U j s B) (big : 1<N) (left : 2<U) (odd : U%2=1)
    (price : U+1≤3*N) (guard : 3*3^(H+1)≤2*2^(H+a))
    (tail : Segment U X (H+1) (H+a) (3^(H+1)-2^(H+1))) :
    Segment N X (j+(H+1)) (s+(H+a)) (3^(H+1)*B+2^s*(3^(H+1)-2^(H+1))) ∧
      (Paid N ∨ RemainingBelow N U) := by
  have full := compose history tail
  have original : 2^(H+a)*X≤3^(H+1)*(U+1) := by
    rw [tail.book,Nat.mul_add,Nat.mul_one]
    exact Nat.add_le_add_left (Nat.sub_le _ _) _
  have scaled : 2^(H+a)*(3*X)≤2^(H+a)*(2*(U+1)) := calc
    _ = 3*(2^(H+a)*X) := by ac_rfl
    _ ≤ 3*(3^(H+1)*(U+1)) := Nat.mul_le_mul_left _ original
    _ = (3*3^(H+1))*(U+1) := by ac_rfl
    _ ≤ (2*2^(H+a))*(U+1) := Nat.mul_le_mul_right _ guard
    _ = _ := by ac_rfl
  have three : 3*X≤2*(U+1) := Nat.le_of_mul_le_mul_left scaled (Nat.pow_pos (by decide))
  have endpoint := A2Header.physical_endpoint tail.physical
  have hp : 0<X := endpoint ▸ orbit_pos U (by omega) (H+1)
  have ho : X%2=1 := endpoint ▸ orbit_odd U odd (H+1)
  exact ⟨full,reduce full big hp ho (by omega) (by omega)⟩

private def beforeR0 : Affine :=
  ⟨323209811003477021565144918443565831595,467148892963858720603917306331285483776⟩
private def afterR0 : Affine :=
  ⟨204531208525637802709193268702569002807,295617658828691846632166420412766595202⟩
private def beforeR1 : Affine :=
  ⟨42591718488769758728042497257378434347,350361669722894040452937979748464112832⟩
private def afterR1 : Affine :=
  ⟨35936762474899483926785857060913053981,295617658828691846632166420412766595202⟩

/-- The r=0 history (1,2,2,2) supplies payment or an admitted pivot below
the actual beginning of its run of ones. -/
theorem r0Readmission (t : Nat) :
    let u := 92862226+134217728*t
    let N := originalSeed u
    let U := beforeR0.at t
    let X := afterR0.at t
    Segment N U 76 119 (3^14*2417122598839266567112547605177+2^98*7539281) ∧
    Segment N X 80 126 1197101608222418270618232455065949759425 ∧ N<X ∧ X<U ∧
    (Paid N ∨ RemainingBelow N U) := by
  let u := 92862226+134217728*t
  let N := originalSeed u
  let U := beforeR0.at t
  let X := afterR0.at t
  have vp := affine_admissible (f:=landing) (by decide) u
  have up := affine_admissible (f:=beforeR0) (by decide) t
  have xp := affine_admissible (f:=afterR0) (by decide) t
  have headBook : 2097152*U=4782969*pivot u+7539281 := by
    simp only [U,u,beforeR0,pivot,landing,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have fullBook : 268435456*X=387420489*pivot u+822494113 := by
    simp only [X,u,afterR0,pivot,landing,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have head : Segment (pivot u) U 14 21 7539281 :=
    compile_word stem vp.1 vp.2 up.1 up.2 (by intro a ha; simp [stem] at ha; omega) headBook
  have full : Segment (pivot u) X 18 28 822494113 :=
    compile_word [1,1,2,1,1,1,2,2,1,1,1,2,1,4,1,2,2,2] vp.1 vp.2 xp.1 xp.2
      (by intro a ha; simp at ha; omega) fullBook
  have margins : N<X ∧ X<U ∧ X<2*N+1 := by
    simp only [N,U,X,u,beforeR0,afterR0,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨compose (history62 u) head,compose (history62 u) full,margins.1,margins.2.1,
    reduction full xp.1 xp.2 margins.2.2 margins.2.1⟩

/-- The r=1 history (2,1,2,2) reaches the same price window without
equating the distinct additive books. -/
theorem r1Readmission (t : Nat) :
    let u := 16316178+134217728*t
    let N := originalSeed u
    let U := beforeR1.at t
    let X := afterR1.at t
    Segment N U 77 121 (3^15*2417122598839266567112547605177+2^98*24714995) ∧
    Segment N X 80 126 1209064660184482513474366718608472860609 ∧ N<X ∧ X<U ∧
    (Paid N ∨ RemainingBelow N U) := by
  let u := 16316178+134217728*t
  let N := originalSeed u
  let U := beforeR1.at t
  let X := afterR1.at t
  have vp := affine_admissible (f:=landing) (by decide) u
  have up := affine_admissible (f:=beforeR1) (by decide) t
  have xp := affine_admissible (f:=afterR1) (by decide) t
  have headBook : 8388608*U=14348907*pivot u+24714995 := by
    simp only [U,u,beforeR1,pivot,landing,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have fullBook : 268435456*X=387420489*pivot u+860242849 := by
    simp only [X,u,afterR1,pivot,landing,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have head : Segment (pivot u) U 15 23 24714995 :=
    compile_word [1,1,2,1,1,1,2,2,1,1,1,2,1,4,2] vp.1 vp.2 up.1 up.2
      (by intro a ha; simp at ha; omega) headBook
  have full : Segment (pivot u) X 18 28 860242849 :=
    compile_word [1,1,2,1,1,1,2,2,1,1,1,2,1,4,2,1,2,2] vp.1 vp.2 xp.1 xp.2
      (by intro a ha; simp at ha; omega) fullBook
  have margins : N<X ∧ X<U ∧ X<2*N+1 := by
    simp only [N,U,X,u,beforeR1,afterR1,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨compose (history62 u) head,compose (history62 u) full,margins.1,margins.2.1,
    reduction full xp.1 xp.2 margins.2.2 margins.2.1⟩

private def crossR0 : Affine :=
  ⟨22418166343533552583314704600958876637,98539219609563948877388806804255531734⟩

/-- A different word (1,1,4) crosses the old pivot at the old crossing
clock, with its own exact additive. -/
theorem r0TwoOnesCrossing (t : Nat) :
    let u := 15267602+67108864*t
    let N := originalSeed u
    let V := pivot u
    let X := crossR0.at t
    N<X ∧ X<V ∧ FirstCrossing N V X 62 98 2417122598839266567112547605177 17 27 243406475 := by
  let u := 15267602+67108864*t
  let N := originalSeed u
  let V := pivot u
  let X := crossR0.at t
  have vp := affine_admissible (f:=landing) (by decide) u
  have xp := affine_admissible (f:=crossR0) (by decide) t
  have book : 134217728*X=129140163*V+243406475 := by
    simp only [X,V,u,crossR0,pivot,landing,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have trail : Segment V X 17 27 243406475 :=
    compile_word [1,1,2,1,1,1,2,2,1,1,1,2,1,4,1,1,4] vp.1 vp.2 xp.1 xp.2
      (by intro a ha; simp at ha; omega) book
  have margins : 1<N ∧ V<2*N+1 ∧ N<X ∧ X<V := by
    simp only [N,V,X,u,pivot,landing,crossR0,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have hit : A2FirstCrossingFusion.HitsBelow V V 17 :=
    ⟨17,by decide,by rw [A2Header.physical_endpoint trail.physical]; exact margins.2.2.2⟩
  exact ⟨margins.2.2.1,margins.2.2.2,
    A2FirstCrossingFusion.reduce_first_crossing margins.1 vp.2 margins.2.1 (history62 u) trail hit⟩

end CollatzCharacterBridge.Front4bExitFourR01

#print axioms CollatzCharacterBridge.Front4bExitFourR01.r0Readmission
#print axioms CollatzCharacterBridge.Front4bExitFourR01.r1Readmission
#print axioms CollatzCharacterBridge.Front4bExitFourR01.r0TwoOnesCrossing
#print axioms CollatzCharacterBridge.Front4bExitFourR01.guardedRunReduction
