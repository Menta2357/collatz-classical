import Front4bRowC7

namespace CollatzCharacterBridge.Front4bWeakTwo

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine Word endpoint word_segment affine_admissible)
open Front4bS29Landing (landing history62)
open Front4bRowEven (originalSeed pivot originalSeedFormula originalCost)
open A2CertifiedLanding (Descended PaidMeeting)
open A2FirstCrossingFusion (Paid Admitted)
open A2BoundedReducer (RemainingBelow)

set_option maxRecDepth 12000
set_option maxHeartbeats 1200000

abbrev Exact (x a : Nat) : Prop := 3*x+1=2^a*step x

private theorem edge {x a : Nat} (positive : 0<x) (odd : x%2=1)
    (ha : 0<a) (factor : Exact x a) : Segment x (step x) 1 a 1 :=
  P5R3S5.step_segment x a positive odd ha factor

private theorem descendStep {N x j S C a b : Nat}
    (history : Segment N x j S C) (positive : 0<x) (odd : x%2=1)
    (amin : 1≤b) (high : b≤a) (factor : Exact x a)
    (price : 3*x+1<2^b*N) : Descended N := by
  have scaled := Nat.mul_le_mul_right (step x)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) high)
  rw [←factor] at scaled
  have below := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scaled price)
  exact ⟨step x,_,_,_,step_pos x,step_odd x,below,
    compose history (edge positive odd (by omega) factor)⟩

private theorem descendTwos {N x j S C K : Nat}
    (history : Segment N x j S C) (positive : 0<x) (odd : x%2=1)
    (twos : TwosCompression.Twos x K)
    (price : 3^K*x+(4^K-3^K)<2^(2*K)*N) : Descended N := by
  have newPath := A2LongDosePhysicalWordBridge.twos_segment_of_word positive odd twos
  have crossed : 2^(2*K)*orbit x K<2^(2*K)*N := by
    rw [newPath.book]
    exact price
  have below := Nat.lt_of_mul_lt_mul_left crossed
  exact ⟨orbit x K,_,_,_,orbit_pos x positive K,orbit_odd x odd K,below,compose history newPath⟩

private theorem reduceBelow {N Z x j S C : Nat} (big : 1<N)
    (history : Segment N x j S C) (positive : 0<x) (odd : x%2=1)
    (window : x<2*N+1) (lower : x<Z) : Paid N ∨ RemainingBelow N Z := by
  rcases A2CertifiedLanding.reduce_window_certified big history positive odd window with
    desc | meet | remaining
  · exact Or.inl (Or.inl desc)
  · exact Or.inl (Or.inr meet)
  · exact Or.inr (A2BoundedReducer.remaining_strict remaining lower)

/-- A high final valuation permits an independent physical odd source
one quarter of the current state, paid against the fixed initial N. -/
theorem quarterPaid {N x j S C a : Nat} (path : Segment N x j S C)
    (high : 3≤a) (factor : Exact x a) (height : x<4*N+1) : PaidMeeting N := by
  obtain ⟨wp,wo,wn,original,auxiliary,_⟩ :=
    A2SecondOne.quarter_capture path height high factor
  exact ⟨(x-1)/4,step x,_,_,_,1,a-2,1,wp,wo,wn,step_pos _,step_odd _,original,auxiliary⟩

def parameter3 (t : Nat) : Nat := 34+64*t
private def start3 : Affine := ⟨53278879931720644613247748332199,97669228666098132896934374095104⟩
private def word3 : Word :=
  [(1,⟨79918319897580966919871622498299,146503842999147199345401561142656⟩),
   (1,⟨119877479846371450379807433747449,219755764498720799018102341713984⟩),
   (2,⟨89908109884778587784855575310587,164816823374040599263576756285488⟩),
   (1,⟨134862164827167881677283362965881,247225235061060898895365134428232⟩),
   (2,⟨101146623620375911257962522224411,185418926295795674171523850821174⟩)]
def terminal3 (t : Nat) : Nat := (endpoint start3 word3).at t

theorem trace3 (t : Nat) :
    Segment (pivot (parameter3 t)) (terminal3 t) 5 7 251 ∧
    Segment (originalSeed (parameter3 t)) (terminal3 t) 67 105 (originalCost 5 251) := by
  have start : pivot (parameter3 t)=start3.at t := by
    simp only [parameter3,pivot,landing,start3,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path : Segment (pivot (parameter3 t)) (terminal3 t) 5 7 251 := by
    rw [start]
    exact word_segment t start3 word3 (by decide)
  exact ⟨path,compose (history62 (parameter3 t)) path⟩

theorem bounds3 (t : Nat) :
    5<(originalSeed (parameter3 t)) ∧ (originalSeed (parameter3 t))<(terminal3 t) ∧ 3*(terminal3 t)+1<8*(originalSeed (parameter3 t)) ∧
    27*(terminal3 t)+37<64*(originalSeed (parameter3 t)) := by
  simp only [terminal3,parameter3,endpoint,word3,Affine.at,originalSeedFormula,
    Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem odd3 (t : Nat) : terminal3 t%2=1 :=
  (affine_admissible (f:=endpoint start3 word3) (by decide) t).2

def parameter5 (t : Nat) : Nat := 202+256*t
private def start5 : Affine := ⟨309660605180228243467700480331847,390676914664392531587737496380416⟩
private def word5 : Word :=
  [(1,⟨464490907770342365201550720497771,586015371996588797381606244570624⟩),
   (1,⟨696736361655513547802326080746657,879023057994883196072409366855936⟩),
   (2,⟨522552271241635160851744560559993,659267293496162397054307025141952⟩),
   (2,⟨391914203431226370638808420419995,494450470122121797790730268856464⟩),
   (1,⟨587871305146839555958212630629993,741675705183182696686095403284696⟩),
   (2,⟨440903478860129666968659472972495,556256778887387022514571552463522⟩)]
def terminal5 (t : Nat) : Nat := (endpoint start5 word5).at t

theorem trace5 (t : Nat) :
    Segment (pivot (parameter5 t)) (terminal5 t) 6 9 977 ∧
    Segment (originalSeed (parameter5 t)) (terminal5 t) 68 107 (originalCost 6 977) := by
  have start : pivot (parameter5 t)=start5.at t := by
    simp only [parameter5,pivot,landing,start5,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path : Segment (pivot (parameter5 t)) (terminal5 t) 6 9 977 := by
    rw [start]
    exact word_segment t start5 word5 (by decide)
  exact ⟨path,compose (history62 (parameter5 t)) path⟩

theorem bounds5 (t : Nat) :
    5<(originalSeed (parameter5 t)) ∧ (originalSeed (parameter5 t))<(terminal5 t) ∧ 3*(terminal5 t)+1<8*(originalSeed (parameter5 t)) ∧
    (terminal5 t)<2*(originalSeed (parameter5 t))+1 ∧ 9*(terminal5 t)+7<16*(originalSeed (parameter5 t)) := by
  simp only [terminal5,parameter5,endpoint,word5,Affine.at,originalSeedFormula,
    Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem odd5 (t : Nat) : terminal5 t%2=1 :=
  (affine_admissible (f:=endpoint start5 word5) (by decide) t).2

def parameter7 (t : Nat) : Nat := 938+1024*t
private def start7 : Affine := ⟨1432856734840356771782445782425543,1562707658657570126350949985521664⟩
private def word7 : Word :=
  [(1,⟨2149285102260535157673668673638315,2344061487986355189526424978282496⟩),
   (1,⟨3223927653390802736510503010457473,3516092231979532784289637467423744⟩),
   (2,⟨2417945740043102052382877257843105,2637069173984649588217228100567808⟩),
   (2,⟨1813459305032326539287157943382329,1977801880488487191162921075425856⟩),
   (2,⟨1360094478774244904465368457536747,1483351410366365393372190806569392⟩),
   (1,⟨2040141718161367356698052686305121,2225027115549548090058286209854088⟩),
   (2,⟨1530106288621025517523539514728841,1668770336662161067543714657390566⟩)]
def terminal7 (t : Nat) : Nat := (endpoint start7 word7).at t

theorem trace7 (t : Nat) :
    Segment (pivot (parameter7 t)) (terminal7 t) 7 11 3827 ∧
    Segment (originalSeed (parameter7 t)) (terminal7 t) 69 109 (originalCost 7 3827) := by
  have start : pivot (parameter7 t)=start7.at t := by
    simp only [parameter7,pivot,landing,start7,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have path : Segment (pivot (parameter7 t)) (terminal7 t) 7 11 3827 := by
    rw [start]
    exact word_segment t start7 word7 (by decide)
  exact ⟨path,compose (history62 (parameter7 t)) path⟩

theorem bounds7 (t : Nat) :
    5<(originalSeed (parameter7 t)) ∧ (originalSeed (parameter7 t))<(terminal7 t) ∧ 3*(terminal7 t)+1<8*(originalSeed (parameter7 t)) ∧
    3*(terminal7 t)+1<4*(originalSeed (parameter7 t)) := by
  simp only [terminal7,parameter7,endpoint,word7,Affine.at,originalSeedFormula,
    Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem odd7 (t : Nat) : terminal7 t%2=1 :=
  (affine_admissible (f:=endpoint start7 word7) (by decide) t).2

theorem afterThreeTwos3 (t : Nat) (twos : TwosCompression.Twos (terminal3 t) 3) :
    Descended (originalSeed (parameter3 t)) := by
  have b := bounds3 t
  exact descendTwos (trace3 t).2 (by omega) (odd3 t) twos b.2.2.2

theorem afterTwoTwos5 (t : Nat) (twos : TwosCompression.Twos (terminal5 t) 2) :
    Descended (originalSeed (parameter5 t)) := by
  have b := bounds5 t
  exact descendTwos (trace5 t).2 (by omega) (odd5 t) twos b.2.2.2.2

theorem strong7 (t a : Nat) (strong : 2≤a) (factor : Exact (terminal7 t) a) :
    Descended (originalSeed (parameter7 t)) := by
  have b := bounds7 t
  exact descendStep (trace7 t).2 (by omega) (odd7 t) (b:=2) (by decide : 1≤2)
    strong factor b.2.2.2

private theorem oneStrong {N x j S C a : Nat} (history : Segment N x j S C)
    (positive : 0<x) (odd : x%2=1) (one : Exact x 1)
    (strong : 3≤a) (next : Exact (step x) a) (price : 9*x+5<16*N) : Descended N := by
  have first : 3*x+1=2*step x := one
  have limit : 3*step x+1<8*N := by omega
  exact descendStep (compose history (edge positive odd (by decide : 0<1) one))
    (step_pos x) (step_odd x) (b:=3) (by decide : 1≤3) strong next limit

theorem oneStrong5 (t a : Nat) (one : Exact (terminal5 t) 1)
    (strong : 3≤a) (next : Exact (step (terminal5 t)) a) :
    Descended (originalSeed (parameter5 t)) := by
  have b := bounds5 t
  exact oneStrong (trace5 t).2 (by omega) (odd5 t) one strong next (by omega)

theorem oneStrong7 (t a : Nat) (one : Exact (terminal7 t) 1)
    (strong : 3≤a) (next : Exact (step (terminal7 t)) a) :
    Descended (originalSeed (parameter7 t)) := by
  have b := bounds7 t
  exact oneStrong (trace7 t).2 (by omega) (odd7 t) one strong next (by omega)

/-- Weak exits that remain after the c3 refinements, with the exact original
book carried into either residual. -/
def Weak3 (N Z C : Nat) : Prop :=
  let Y := step Z
  let U := step Y
  let X := step U
  Exact Z 1 ∧
    ((Exact Y 1 ∧ Segment N U 69 107 (9*C+2^105*5)) ∨
      (Exact Y 2 ∧ Exact U 1 ∧ Segment N X 70 109 (27*C+2^105*23)))

theorem split3 (t : Nat) :
    let N := originalSeed (parameter3 t)
    let Z := terminal3 t
    Paid N ∨ RemainingBelow N Z ∨ Weak3 N Z (originalCost 5 251) := by
  let N := originalSeed (parameter3 t)
  let Z := terminal3 t
  let Y := step Z
  let U := step Y
  have h := (trace3 t).2
  obtain ⟨big,nz,highZ,margin⟩ := bounds3 t
  change 5<N at big
  change N<Z at nz
  change 3*Z+1<8*N at highZ
  change 27*Z+37<64*N at margin
  have oddZ : Z%2=1 := odd3 t
  have posZ : 0<Z := by omega
  obtain ⟨a,ap,fa⟩ := P5R3S5.actual_step_factor Z oddZ
  have first := compose h (edge posZ oddZ ap fa)
  by_cases strong : 3≤a
  · exact Or.inl (Or.inl (descendStep h posZ oddZ (b:=3) (by decide : 1≤3) strong fa highZ))
  by_cases two : a=2
  · have eq4 : 3*Z+1=4*Y := by simpa only [two] using fa
    have r := reduceBelow (by omega : 1<N) first (step_pos Z) (step_odd Z)
      (by omega : Y<2*N+1) (by omega : Y<Z)
    exact r.imp id Or.inl
  have one : a=1 := by omega
  have f1 : Exact Z 1 := by simpa only [one] using fa
  have eq2 : 3*Z+1=2*Y := f1
  have hY := compose h (edge posZ oddZ (by decide : 0<1) f1)
  obtain ⟨b,bp,fb⟩ := P5R3S5.actual_step_factor Y (step_odd Z)
  by_cases strongY : 3≤b
  · have price : Y<4*N+1 := by omega
    exact Or.inl (Or.inr (quarterPaid hY strongY fb price))
  by_cases oneY : b=1
  · have f2 : Exact Y 1 := by simpa only [oneY] using fb
    exact Or.inr (Or.inr ⟨f1,Or.inl ⟨f2,
      compose hY (edge (step_pos Z) (step_odd Z) (by decide : 0<1) f2)⟩⟩)
  have twoY : b=2 := by omega
  have f2 : Exact Y 2 := by simpa only [twoY] using fb
  have eq4 : 3*Y+1=4*U := f2
  have hU := compose hY (edge (step_pos Z) (step_odd Z) (by decide : 0<2) f2)
  obtain ⟨c,cp,fc⟩ := P5R3S5.actual_step_factor U (step_odd Y)
  by_cases strongU : 3≤c
  · have price : 3*U+1<8*N := by omega
    exact Or.inl (Or.inl (descendStep hU (step_pos Y) (step_odd Y)
      (b:=3) (by decide : 1≤3) strongU fc price))
  by_cases twoU : c=2
  · let X := step U
    have f3 : Exact U 2 := by simpa only [twoU] using fc
    have eqX : 3*U+1=4*X := f3
    have final := compose hU (edge (step_pos Y) (step_odd Y) (by decide : 0<2) f3)
    have r := reduceBelow (by omega : 1<N) final (step_pos U) (step_odd U)
      (by omega : X<2*N+1) (by omega : X<Z)
    exact r.imp id Or.inl
  have oneU : c=1 := by omega
  have f3 : Exact U 1 := by simpa only [oneU] using fc
  exact Or.inr (Or.inr ⟨f1,Or.inr ⟨f2,f3,
    compose hU (edge (step_pos Y) (step_odd Y) (by decide : 0<1) f3)⟩⟩)

/-- The whole c5 e2 band lies in the A2 price window. The only branch
that can keep the same bound has a genuine one-run and break two at Z. -/
theorem split5 (t : Nat) :
    let N := originalSeed (parameter5 t)
    let Z := terminal5 t
    Paid N ∨ RemainingBelow N Z ∨ Admitted N Z 68 107 (originalCost 6 977) := by
  let N := originalSeed (parameter5 t)
  let Z := terminal5 t
  let Y := step Z
  have h := (trace5 t).2
  obtain ⟨big,nz,highZ,window,_⟩ := bounds5 t
  have oddZ : Z%2=1 := odd5 t
  have posZ : 0<Z := by omega
  obtain ⟨a,ap,fa⟩ := P5R3S5.actual_step_factor Z oddZ
  by_cases strong : 3≤a
  · exact Or.inl (Or.inl (descendStep h posZ oddZ (b:=3) (by decide : 1≤3) strong fa highZ))
  by_cases two : a=2
  · have eq4 : 3*Z+1=4*Y := by simpa only [two] using fa
    have r := reduceBelow (by omega : 1<N) (compose h (edge posZ oddZ ap fa))
      (step_pos Z) (step_odd Z) (by omega : Y<2*N+1) (by omega : Y<Z)
    exact r.imp id Or.inl
  have one : a=1 := by omega
  have eq2 : 3*Z+1=2*Y := by simpa only [one,Nat.pow_one] using fa
  obtain ⟨r,b,run,bp,br⟩ := A2HalfAdaptive.first_break Z oddZ
  have runPositive : 0<r := by
    by_cases zero : r=0
    · rw [zero] at br
      change 3*Z+1=2^b*Y at br
      have atLeast := Nat.mul_le_mul_right Y
        (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) bp)
      rw [←br,eq2] at atLeast
      have yp := step_pos Z
      omega
    · omega
  by_cases twoBreak : b=2
  · rw [twoBreak] at br
    exact Or.inr (Or.inr ⟨by omega,oddZ,window,h,r,runPositive,run,br⟩)
  obtain ⟨k,eq⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : r≠0)
  rw [eq] at run br
  obtain ⟨wp,wo,price,original,auxiliary⟩ := A2HalfAdaptive.history_capture
    h posZ oddZ window run (by omega : 3≤b) br
  exact Or.inl (Or.inr ⟨_,_,_,_,_,_,_,_,wp,wo,price,
    orbit_pos Z posZ _,orbit_odd Z oddZ _,original,auxiliary⟩)

theorem ambient7 (t : Nat) :
    Paid (originalSeed (parameter7 t)) ∨ ∃ x j s B,
      x-originalSeed (parameter7 t)<pivot (parameter7 t)-originalSeed (parameter7 t) ∧
      Admitted (originalSeed (parameter7 t)) x j s B := by
  exact Front4bRowC7.paidOrAmbientOfResidue (by unfold parameter7; omega)

end CollatzCharacterBridge.Front4bWeakTwo

#print axioms CollatzCharacterBridge.Front4bWeakTwo.trace3
#print axioms CollatzCharacterBridge.Front4bWeakTwo.trace5
#print axioms CollatzCharacterBridge.Front4bWeakTwo.trace7
#print axioms CollatzCharacterBridge.Front4bWeakTwo.quarterPaid
#print axioms CollatzCharacterBridge.Front4bWeakTwo.afterThreeTwos3
#print axioms CollatzCharacterBridge.Front4bWeakTwo.afterTwoTwos5
#print axioms CollatzCharacterBridge.Front4bWeakTwo.strong7
#print axioms CollatzCharacterBridge.Front4bWeakTwo.oneStrong5
#print axioms CollatzCharacterBridge.Front4bWeakTwo.oneStrong7
#print axioms CollatzCharacterBridge.Front4bWeakTwo.split3
#print axioms CollatzCharacterBridge.Front4bWeakTwo.split5
#print axioms CollatzCharacterBridge.Front4bWeakTwo.ambient7
