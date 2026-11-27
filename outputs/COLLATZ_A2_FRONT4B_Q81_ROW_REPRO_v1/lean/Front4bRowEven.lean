import Front4bS29Landing

namespace CollatzCharacterBridge.Front4bRowEven

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine Word endpoint word_segment)
open Front4bS29Landing (landing history62)
open Front4bT61S3 (index seed_affine)
open A2CertifiedLanding (Descended)

set_option maxRecDepth 12000
set_option maxHeartbeats 1000000

def originalSeed (u : Nat) : Nat := A2U392.seed (index (29+32*u))

def pivot (u : Nat) : Nat := landing.at u

def originalCost (j C : Nat) : Nat :=
  3^j*2417122598839266567112547605177+2^98*C

theorem originalSeedFormula (u : Nat) :
    originalSeed u=1156359581173680383779426258047+1267650600228229401496703205376*u := by
  simp only [originalSeed,seed_affine,index,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem pivotOdd (u : Nat) : 0<pivot u ∧ pivot u%2=1 :=
  P5CompensationMeetings.affine_admissible (f:=landing) (by decide) u

/-- A final valuation of at least three is read from its actual shortcut
numerator. The value bound uses only the first three divisions. -/
private theorem extendHigh {u W j s C : Nat} (path : Segment (pivot u) W j s C)
    (divisible : (3*W+1)%8=0) (price : 3*W+1<8*originalSeed u) :
    ∃ e L, 3≤e ∧ 0<L ∧ L%2=1 ∧ L<originalSeed u ∧
      Segment (pivot u) L (j+1) (s+e) (3*C+2^s) ∧
      Segment (originalSeed u) L (62+(j+1)) (98+(s+e)) (originalCost (j+1) (3*C+2^s)) := by
  have ends := A2Header.physical_endpoint path.physical
  have positive := ends ▸ orbit_pos (pivot u) (pivotOdd u).1 j
  have odd := ends ▸ orbit_odd (pivot u) (pivotOdd u).2 j
  obtain ⟨e,nonzero,factor⟩ := P5R3S5.actual_step_factor W odd
  have targetOdd := step_odd W
  have large : 3≤e := by
    by_cases large : 3≤e
    · exact large
    have small : e=1 ∨ e=2 := by omega
    rcases small with rfl | rfl
    · change 3*W+1=2*step W at factor
      omega
    · change 3*W+1=4*step W at factor
      omega
  have le : 8*step W≤3*W+1 := by
    rw [factor]
    exact Nat.mul_le_mul_right (step W) (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) large)
  have tail := P5R3S5.step_segment W e positive odd nonzero factor
  have localPath : Segment (pivot u) (step W) (j+1) (s+e) (3*C+2^s) := by
    simpa only [Nat.pow_one,Nat.mul_one] using compose path tail
  exact ⟨e,step W,large,step_pos W,targetOdd,by omega,localPath,
    compose (history62 u) localPath⟩

private def start4 : Affine := ⟨41070226348458378001130951570311,48834614333049066448467187047552⟩
private def word4 : Word :=
  [(1,⟨61605339522687567001696427355467,73251921499573599672700780571328⟩),
   (1,⟨92408009284031350502544641033201,109877882249360399509051170856992⟩),
   (2,⟨69306006963023512876908480774901,82408411687020299631788378142744⟩)]

/-- The 26 modulo 32 band descends from the sealed checkpoint. -/
theorem band4 (t : Nat) :
    ∃ e L, 3≤e ∧ 0<L ∧ L%2=1 ∧ L<originalSeed (26+32*t) ∧
      Segment (pivot (26+32*t)) L 4 (4+e) 73 ∧
      Segment (originalSeed (26+32*t)) L 66 (98+(4+e))
        (originalCost 4 73) := by
  have start : pivot (26+32*t)=start4.at t := by
    simp only [pivot,landing,start4,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t start4 word4 (by decide)
  rw [←start] at path
  have divisible : (3*((endpoint start4 word4).at t)+1)%8=0 := by
    simp only [endpoint,word4,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have price : 3*((endpoint start4 word4).at t)+1<8*originalSeed (26+32*t) := by
    simp only [endpoint,word4,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact extendHigh (j:=3) (s:=4) (C:=19) path divisible price

private def start6 : Affine := ⟨163156762181081044122298919189191,195338457332196265793868748190208⟩
private def word6 : Word :=
  [(1,⟨244735143271621566183448378783787,293007685998294398690803122285312⟩),
   (1,⟨367102714907432349275172568175681,439511528997441598036204683427968⟩),
   (2,⟨275327036180574261956379426131761,329633646748081198527153512570976⟩),
   (2,⟨206495277135430696467284569598821,247225235061060898895365134428232⟩)]

/-- The 106 modulo 128 band descends from the sealed checkpoint. -/
theorem band6 (t : Nat) :
    ∃ e L, 3≤e ∧ 0<L ∧ L%2=1 ∧ L<originalSeed (106+128*t) ∧
      Segment (pivot (106+128*t)) L 5 (6+e) 283 ∧
      Segment (originalSeed (106+128*t)) L 67 (98+(6+e))
        (originalCost 5 283) := by
  have start : pivot (106+128*t)=start6.at t := by
    simp only [pivot,landing,start6,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t start6 word6 (by decide)
  rw [←start] at path
  have divisible : (3*((endpoint start6 word6).at t)+1)%8=0 := by
    simp only [endpoint,word6,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have price : 3*((endpoint start6 word6).at t)+1<8*originalSeed (106+128*t) := by
    simp only [endpoint,word6,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact extendHigh (j:=4) (s:=6) (C:=73) path divisible price

private def start8 : Affine := ⟨456164448179375442813102041474503,781353829328785063175474992760832⟩
private def word8 : Word :=
  [(1,⟨684246672269063164219653062211755,1172030743993177594763212489141248⟩),
   (1,⟨1026370008403594746329479593317633,1758046115989766392144818733711872⟩),
   (2,⟨769777506302696059747109694988225,1318534586992324794108614050283904⟩),
   (2,⟨577333129727022044810332271241169,988900940244243595581460537712928⟩),
   (2,⟨432999847295266533607749203430877,741675705183182696686095403284696⟩)]

/-- The 298 modulo 512 band descends from the sealed checkpoint. -/
theorem band8 (t : Nat) :
    ∃ e L, 3≤e ∧ 0<L ∧ L%2=1 ∧ L<originalSeed (298+512*t) ∧
      Segment (pivot (298+512*t)) L 6 (8+e) 1105 ∧
      Segment (originalSeed (298+512*t)) L 68 (98+(8+e))
        (originalCost 6 1105) := by
  have start : pivot (298+512*t)=start8.at t := by
    simp only [pivot,landing,start8,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t start8 word8 (by decide)
  rw [←start] at path
  have divisible : (3*((endpoint start8 word8).at t)+1)%8=0 := by
    simp only [endpoint,word8,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have price : 3*((endpoint start8 word8).at t)+1<8*originalSeed (298+512*t) := by
    simp only [endpoint,word8,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact extendHigh (j:=5) (s:=8) (C:=283) path divisible price

private def start9 : Affine := ⟨65487533514982911225364545094087,781353829328785063175474992760832⟩
private def word9 : Word :=
  [(1,⟨98231300272474366838046817641131,1172030743993177594763212489141248⟩),
   (1,⟨147346950408711550257070226461697,1758046115989766392144818733711872⟩),
   (2,⟨110510212806533662692802669846273,1318534586992324794108614050283904⟩),
   (2,⟨82882659604900247019602002384705,988900940244243595581460537712928⟩),
   (2,⟨62161994703675185264701501788529,741675705183182696686095403284696⟩),
   (2,⟨46621496027756388948526126341397,556256778887387022514571552463522⟩)]

/-- The 42 modulo 512 band needs just the six fixed valuations. -/
theorem band9 (t : Nat) :
    ∃ L, 0<L ∧ L%2=1 ∧ L<originalSeed (42+512*t) ∧
      Segment (pivot (42+512*t)) L 6 10 1105 ∧
      Segment (originalSeed (42+512*t)) L 68 108 (originalCost 6 1105) := by
  have start : pivot (42+512*t)=start9.at t := by
    simp only [pivot,landing,start9,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path := word_segment t start9 word9 (by decide)
  rw [←start] at path
  have price : ((endpoint start9 word9).at t)<originalSeed (42+512*t) := by
    simp only [endpoint,word9,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have admissible := P5CompensationMeetings.affine_admissible
    (f:=endpoint start9 word9) (by decide) t
  exact ⟨_,admissible.1,admissible.2,price,path,compose (history62 (42+512*t)) path⟩

/-- The two high branches are exactly the residue 42 modulo 256. -/
theorem evenAndHighDescend {u : Nat}
    (guard : u%32=26 ∨ u%128=106 ∨ u%256=42) : Descended (originalSeed u) := by
  rcases guard with c4 | c6 | high
  · have parameter : u=26+32*(u/32) := by omega
    rw [parameter]
    obtain ⟨_,L,_,hp,ho,lt,_,path⟩ := band4 (u/32)
    exact ⟨L,_,_,_,hp,ho,lt,path⟩
  · have parameter : u=106+128*(u/128) := by omega
    rw [parameter]
    obtain ⟨_,L,_,hp,ho,lt,_,path⟩ := band6 (u/128)
    exact ⟨L,_,_,_,hp,ho,lt,path⟩
  · have nested := Nat.mod_mod_of_dvd u (by decide : 256∣512)
    have choices : u%512=42 ∨ u%512=298 := by omega
    rcases choices with c9 | c8
    · have parameter : u=42+512*(u/512) := by omega
      rw [parameter]
      obtain ⟨L,hp,ho,lt,_,path⟩ := band9 (u/512)
      exact ⟨L,_,_,_,hp,ho,lt,path⟩
    · have parameter : u=298+512*(u/512) := by omega
      rw [parameter]
      obtain ⟨_,L,_,hp,ho,lt,_,path⟩ := band8 (u/512)
      exact ⟨L,_,_,_,hp,ho,lt,path⟩

end CollatzCharacterBridge.Front4bRowEven

#print axioms CollatzCharacterBridge.Front4bRowEven.originalSeedFormula
#print axioms CollatzCharacterBridge.Front4bRowEven.band4
#print axioms CollatzCharacterBridge.Front4bRowEven.band6
#print axioms CollatzCharacterBridge.Front4bRowEven.band8
#print axioms CollatzCharacterBridge.Front4bRowEven.band9
#print axioms CollatzCharacterBridge.Front4bRowEven.evenAndHighDescend
