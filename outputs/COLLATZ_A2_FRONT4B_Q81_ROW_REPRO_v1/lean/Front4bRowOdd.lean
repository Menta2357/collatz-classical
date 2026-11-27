import Front4bRowEven

namespace CollatzCharacterBridge.Front4bRowOdd

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine Word endpoint word_segment affine_edge affine_admissible)
open Front4bS29Landing (landing history62)
open Front4bRowEven (originalSeed pivot originalCost originalSeedFormula)
open A2CertifiedLanding (Descended PaidMeeting)

set_option maxRecDepth 12000
set_option maxHeartbeats 1000000

private theorem terminalDescent {u W j s C eMin : Nat} (path : Segment (pivot u) W j s C)
    (divides : 2^eMin ∣ 3*W+1) (price : 3*W+1<2^eMin*originalSeed u) :
    ∃ e Z, eMin≤e ∧ 0<Z ∧ Z%2=1 ∧ Z<originalSeed u ∧
      Segment (pivot u) Z (j+1) (s+e) (3*C+2^s) ∧
      Segment (originalSeed u) Z (62+(j+1)) (98+(s+e)) (originalCost (j+1) (3*C+2^s)) := by
  have ends := A2Header.physical_endpoint path.physical
  have adm := affine_admissible (f:=landing) (by decide) u
  have positive := ends ▸ orbit_pos (pivot u) adm.1 j
  have odd := ends ▸ orbit_odd (pivot u) adm.2 j
  obtain ⟨e,nonzero,factor⟩ := P5R3S5.actual_step_factor W odd
  have eo := step_odd W
  have sufficient : eMin≤e := by
    by_cases enough : eMin≤e
    · exact enough
    exact ((P5R3S5.exact_reserve eo factor).2
      (Nat.dvd_trans (Nat.pow_dvd_pow 2 (by omega : e+1≤eMin)) divides)).elim
  have bound : 2^eMin*step W≤3*W+1 := by
    rw [factor]
    exact Nat.mul_le_mul_right (step W)
      (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) sufficient)
  have terminal : step W<originalSeed u :=
    Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt bound price)
  have tail := P5R3S5.step_segment W e positive odd nonzero factor
  have suffix : Segment (pivot u) (step W) (j+1) (s+e) (3*C+2^s) := by
    simpa only [Nat.pow_one,Nat.mul_one] using compose path tail
  exact ⟨e,step W,sufficient,step_pos W,eo,terminal,suffix,compose (history62 u) suffix⟩

private def start3 : Affine := ⟨4444265598671578164780561284647,195338457332196265793868748190208⟩
private def word3 : Word :=
  [(1,⟨6666398398007367247170841926971,293007685998294398690803122285312⟩),
   (1,⟨9999597597011050870756262890457,439511528997441598036204683427968⟩),
   (2,⟨7499698197758288153067197167843,329633646748081198527153512570976⟩),
   (1,⟨11249547296637432229600795751765,494450470122121797790730268856464⟩)]

theorem band3Strong (t : Nat) :
    ∃ e Z, 4≤e ∧ 0<Z ∧ Z%2=1 ∧ Z<originalSeed (2+128*t) ∧
      Segment (pivot (2+128*t)) Z 5 (5+e) 251 ∧
      Segment (originalSeed (2+128*t)) Z 67 (98+(5+e))
        (originalCost 5 251) := by
  have start : pivot (2+128*t)=start3.at t := by
    simp only [pivot,landing,start3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t start3 word3 (by decide)
  rw [←start] at path
  have divides : 2^4 ∣ 3*((endpoint start3 word3).at t)+1 := by
    apply Nat.dvd_iff_mod_eq_zero.mpr
    change (3*((endpoint start3 word3).at t)+1)%16=0
    simp only [endpoint,word3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have price : 3*((endpoint start3 word3).at t)+1<2^4*originalSeed (2+128*t) := by
    change 3*((endpoint start3 word3).at t)+1<16*originalSeed (2+128*t)
    simp only [endpoint,word3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminalDescent (j:=4) (s:=5) (C:=73) path divides price

private def start5 : Affine := ⟨114322147848031977673831732141639,390676914664392531587737496380416⟩
private def word5 : Word :=
  [(1,⟨171483221772047966510747598212459,586015371996588797381606244570624⟩),
   (1,⟨257224832658071949766121397318689,879023057994883196072409366855936⟩),
   (2,⟨192918624493553962324591047989017,659267293496162397054307025141952⟩),
   (2,⟨144688968370165471743443285991763,494450470122121797790730268856464⟩),
   (1,⟨217033452555248207615164928987645,741675705183182696686095403284696⟩)]

theorem band5Strong (t : Nat) :
    ∃ e Z, 3≤e ∧ 0<Z ∧ Z%2=1 ∧ Z<originalSeed (74+256*t) ∧
      Segment (pivot (74+256*t)) Z 6 (7+e) 977 ∧
      Segment (originalSeed (74+256*t)) Z 68 (98+(7+e))
        (originalCost 6 977) := by
  have start : pivot (74+256*t)=start5.at t := by
    simp only [pivot,landing,start5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t start5 word5 (by decide)
  rw [←start] at path
  have divides : 2^3 ∣ 3*((endpoint start5 word5).at t)+1 := by
    apply Nat.dvd_iff_mod_eq_zero.mpr
    change (3*((endpoint start5 word5).at t)+1)%8=0
    simp only [endpoint,word5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have price : 3*((endpoint start5 word5).at t)+1<2^3*originalSeed (74+256*t) := by
    change 3*((endpoint start5 word5).at t)+1<8*originalSeed (74+256*t)
    simp only [endpoint,word5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminalDescent (j:=5) (s:=7) (C:=283) path divides price

private def start7 : Affine := ⟨651502905511571708606970789664711,1562707658657570126350949985521664⟩
private def word7 : Word :=
  [(1,⟨977254358267357562910456184497067,2344061487986355189526424978282496⟩),
   (1,⟨1465881537401036344365684276745601,3516092231979532784289637467423744⟩),
   (2,⟨1099411153050777258274263207559201,2637069173984649588217228100567808⟩),
   (2,⟨824558364788082943705697405669401,1977801880488487191162921075425856⟩),
   (2,⟨618418773591062207779273054252051,1483351410366365393372190806569392⟩),
   (1,⟨927628160386593311668909581378077,2225027115549548090058286209854088⟩)]

theorem band7Strong (t : Nat) :
    ∃ e Z, 3≤e ∧ 0<Z ∧ Z%2=1 ∧ Z<originalSeed (426+1024*t) ∧
      Segment (pivot (426+1024*t)) Z 7 (9+e) 3827 ∧
      Segment (originalSeed (426+1024*t)) Z 69 (98+(9+e))
        (originalCost 7 3827) := by
  have start : pivot (426+1024*t)=start7.at t := by
    simp only [pivot,landing,start7,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t start7 word7 (by decide)
  rw [←start] at path
  have divides : 2^3 ∣ 3*((endpoint start7 word7).at t)+1 := by
    apply Nat.dvd_iff_mod_eq_zero.mpr
    change (3*((endpoint start7 word7).at t)+1)%8=0
    simp only [endpoint,word7,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have price : 3*((endpoint start7 word7).at t)+1<2^3*originalSeed (426+1024*t) := by
    change 3*((endpoint start7 word7).at t)+1<8*originalSeed (426+1024*t)
    simp only [endpoint,word7,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminalDescent (j:=6) (s:=9) (C:=1105) path divides price

private def startCapture : Affine := ⟨102113494264769711061714935379751,195338457332196265793868748190208⟩
private def wordCapture : Word :=
  [(1,⟨153170241397154566592572403069627,293007685998294398690803122285312⟩),
   (1,⟨229755362095731849888858604604441,439511528997441598036204683427968⟩),
   (2,⟨172316521571798887416643953453331,329633646748081198527153512570976⟩),
   (1,⟨258474782357698331124965930179997,494450470122121797790730268856464⟩),
   (3,⟨96928043384136874171862223817499,185418926295795674171523850821174⟩)]

private def source : Affine := ⟨64618695589424582781241482544999,123612617530530449447682567214116⟩

/-- One exact return from a strictly smaller positive odd source, with
both histories terminating at the same physical checkpoint. -/
theorem band3Capture (t : Nat) :
    let N := originalSeed (66+128*t)
    let Z := (endpoint startCapture wordCapture).at t
    let w := source.at t
    0<w ∧ w%2=1 ∧ w<N ∧ N<Z ∧
      Segment N Z 67 106 (originalCost 5 251) ∧ Segment w Z 1 1 1 := by
  have start : pivot (66+128*t)=startCapture.at t := by
    simp only [pivot,landing,startCapture,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t startCapture wordCapture (by decide)
  rw [←start] at path
  have sourcePath : Segment (source.at t) ((endpoint startCapture wordCapture).at t) 1 1 1 :=
    affine_edge (by decide) t
  have hSource := affine_admissible (f:=source) (by decide) t
  have price : source.at t<originalSeed (66+128*t) := by
    simp only [source,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have high : originalSeed (66+128*t)<(endpoint startCapture wordCapture).at t := by
    simp only [endpoint,wordCapture,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact ⟨hSource.1,hSource.2,price,high,compose (history62 (66+128*t)) path,sourcePath⟩

theorem smallerSourceCapture (t : Nat) : PaidMeeting (originalSeed (66+128*t)) := by
  obtain ⟨positive,odd,price,high,original,src⟩ := band3Capture t
  have hZ := affine_admissible (f:=endpoint startCapture wordCapture) (by decide) t
  exact ⟨source.at t,(endpoint startCapture wordCapture).at t,67,106,originalCost 5 251,
    1,1,1,positive,odd,price,hZ.1,hZ.2,original,src⟩

end CollatzCharacterBridge.Front4bRowOdd

#print axioms CollatzCharacterBridge.Front4bRowOdd.band3Strong
#print axioms CollatzCharacterBridge.Front4bRowOdd.band5Strong
#print axioms CollatzCharacterBridge.Front4bRowOdd.band7Strong
#print axioms CollatzCharacterBridge.Front4bRowOdd.band3Capture
#print axioms CollatzCharacterBridge.Front4bRowOdd.smallerSourceCapture
