import Front4bRowEven
import A2ShortcutClock

namespace CollatzCharacterBridge.Front4bRowC7

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine Word endpoint checkWord word_segment)
open Front4bS29Landing (landing history62)
open Front4bRowEven (originalSeed pivot originalCost originalSeedFormula)
open A2FirstCrossingFusion (Admitted Paid)

set_option maxRecDepth 12000
set_option maxHeartbeats 1000000

def parameter (t : Nat) : Nat := 170+256*t
abbrev seed (t : Nat) : Nat := originalSeed (parameter t)
abbrev startPoint (t : Nat) : Nat := pivot (parameter t)

private def start : Affine := ⟨260825990847179177019233293284295,390676914664392531587737496380416⟩
private def word : Word :=
  [(1,⟨391238986270768765528849939926443,586015371996588797381606244570624⟩),
   (1,⟨586858479406153148293274909889665,879023057994883196072409366855936⟩),
   (2,⟨440143859554614861219956182417249,659267293496162397054307025141952⟩),
   (2,⟨330107894665961145914967136812937,494450470122121797790730268856464⟩),
   (2,⟨247580920999470859436225352609703,370837852591591348343047701642348⟩)]

def crossedPoint (t : Nat) : Nat := (endpoint start word).at t

private theorem startEq (t : Nat) : startPoint t=start.at t := by
  simp only [parameter,pivot,landing,start,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem bounds (t : Nat) :
    1<seed t ∧ seed t<crossedPoint t ∧ crossedPoint t<startPoint t ∧
      startPoint t≤2*crossedPoint t ∧ startPoint t<2*seed t+1 := by
  simp only [parameter,pivot,landing,crossedPoint,endpoint,word,Affine.at,
    originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem earlierCoefficients : ∀ i : Fin 5,
    checkWord start (word.take i.val)=true ∧
    start.offset≤(endpoint start (word.take i.val)).offset ∧
    start.slope≤(endpoint start (word.take i.val)).slope := by decide

private theorem oddEarlier (t i : Nat) (before : i<5) : startPoint t≤orbit (startPoint t) i := by
  obtain ⟨checked,offset,slope⟩ := earlierCoefficients ⟨i,before⟩
  have path := word_segment t start (word.take i) checked
  have seen := A2Header.physical_endpoint path.physical
  rw [List.length_take,show word.length=5 by decide,Nat.min_eq_left (Nat.le_of_lt before)] at seen
  rw [startEq,seen]
  exact Nat.add_le_add offset (Nat.mul_le_mul_right t slope)

/-- The first odd state below the current pivot lies above the original seed.
The sealed original history reaches it at odd clock 67 and shortcut clock 106. -/
theorem firstC7 (t : Nat) :
    seed t<crossedPoint t ∧ crossedPoint t<startPoint t ∧
    (∀ i<5, startPoint t≤orbit (startPoint t) i) ∧
    Segment (startPoint t) (crossedPoint t) 5 8 283 ∧
    Segment (seed t) (crossedPoint t) 67 106 (originalCost 5 283) := by
  have path : Segment (startPoint t) (crossedPoint t) 5 8 283 := by
    rw [startEq]
    exact word_segment t start word (by decide)
  have h := bounds t
  exact ⟨h.2.1,h.2.2.1,fun i hi => oddEarlier t i hi,path,
    compose (history62 (parameter t)) path⟩

/-- The local shortcut clock 8 is itself the first strict crossing. When
an earlier shortcut time already has count five, its endpoint is still an
even multiple of the completed crossing and remains at least the pivot. -/
theorem firstShortcutC7 (t : Nat) :
    A2ShortcutClock.ShortcutFirstBelow (startPoint t) 8 := by
  let V := startPoint t
  let X := crossedPoint t
  have h := bounds t
  obtain ⟨_,below,earlier,path,_⟩ := firstC7 t
  have pivotOdd : V%2=1 := by
    rw [show V=start.at t from startEq t]
    exact (P5CompensationMeetings.affine_admissible (f:=start) (by decide) t).2
  have target : orbit V 5=X := A2Header.physical_endpoint path.physical
  have targetOdd : X%2=1 := by rw [←target]; exact orbit_odd V pivotOdd _
  obtain ⟨atEight,countEight⟩ := A2ShortcutClock.physicalShortcut path.physical
  refine ⟨atEight ▸ below,?_⟩
  intro i within
  change V≤TerrasClock.orbit V i
  obtain ⟨e,completed⟩ := A2ShortcutClock.completeShortcutPrefix (q:=i) pivotOdd
  have count := TerrasClock.oddCount_add V i (8-i)
  rw [show i+(8-i)=8 by omega,countEight] at count
  have power : 1≤(2:Nat)^e := Nat.pow_pos (by decide : 0<(2:Nat))
  by_cases short : TerrasClock.oddCount V i<5
  · have old := earlier _ short
    rw [completed.factor]
    have scale := Nat.mul_le_mul_right (A2ShortcutClock.landing V i) power
    rw [Nat.one_mul] at scale
    exact Nat.le_trans old scale
  have full : TerrasClock.oddCount V i=5 := by omega
  have same : A2ShortcutClock.landing V i=X := by
    unfold A2ShortcutClock.landing
    rw [full,target]
  have positive : 0<e := by
    by_cases zero : e=0
    · have atRaw := completed.endpoint
      rw [zero,Nat.add_zero,same] at atRaw
      have odd : TerrasClock.orbit V i%2=1 := by rw [atRaw]; exact targetOdd
      have next := TerrasClock.oddCount_add V (i+1) (8-(i+1))
      rw [show i+1+(8-(i+1))=8 by omega,countEight] at next
      simp only [TerrasClock.oddCount,if_pos odd,full] at next
      omega
    · omega
  have twice : 2≤(2:Nat)^e :=
    Nat.pow_le_pow_right (by decide : 0<(2:Nat)) (show 1≤e from positive)
  rw [completed.factor,same]
  exact Nat.le_trans h.2.2.2.1 (Nat.mul_le_mul_right X twice)

/-- Consume the genuine first local crossing with the sealed A2 splitter. -/
theorem sealedFirstC7 (t : Nat) :
    A2FirstCrossingFusion.FirstCrossing (seed t) (startPoint t) (crossedPoint t)
      62 98 2417122598839266567112547605177 5 8 283 := by
  obtain ⟨_,below,_,path,_⟩ := firstC7 t
  have odd : startPoint t%2=1 := by
    rw [startEq]
    exact (P5CompensationMeetings.affine_admissible (f:=start) (by decide) t).2
  have h := bounds t
  exact A2FirstCrossingFusion.reduce_first_crossing h.1 odd h.2.2.2.2
    (history62 (parameter t)) path
    ⟨5,by decide,(A2Header.physical_endpoint path.physical) ▸ below⟩

/-- A2 pays the original seed or admits an ambient A2 pivot of smaller
rank, with an exact segment from the same seed in the admitted branch. -/
theorem paidOrAmbientC7 (t : Nat) :
    Paid (seed t) ∨ ∃ x j s B, x-seed t<startPoint t-seed t ∧ Admitted (seed t) x j s B := by
  obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,_,_,result⟩ := sealedFirstC7 t
  rcases result with paid | remaining
  · exact Or.inl paid
  · exact Or.inr (A2FirstCrossingFusion.next_rank remaining)

theorem paidOrAmbientOfResidue {u : Nat} (guard : u%256=170) :
    Paid (originalSeed u) ∨ ∃ x j s B,
      x-originalSeed u<pivot u-originalSeed u ∧ Admitted (originalSeed u) x j s B := by
  have form : u=parameter (u/256) := by unfold parameter; omega
  rw [form]
  exact paidOrAmbientC7 (u/256)

end CollatzCharacterBridge.Front4bRowC7

#print axioms CollatzCharacterBridge.Front4bRowC7.firstC7
#print axioms CollatzCharacterBridge.Front4bRowC7.firstShortcutC7
#print axioms CollatzCharacterBridge.Front4bRowC7.sealedFirstC7
#print axioms CollatzCharacterBridge.Front4bRowC7.paidOrAmbientC7
#print axioms CollatzCharacterBridge.Front4bRowC7.paidOrAmbientOfResidue
