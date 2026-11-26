import A2U392

namespace CollatzCharacterBridge.A2T66

open A2CertifiedLanding (Descended PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def row (t : Nat) : Nat := 3805769794057+17592186044416*t
private def pivot63 : Affine := ⟨1980850684899876252481485357223,9156490187446699959087597571416⟩
private def before65 : Affine := ⟨4456914041024721568083342053753,20602102921755074907947094535686⟩
private def capture65 : Affine := ⟨128069531571555171015765909267869,164816823374040599263576756285488⟩
private def capture66 : Affine := ⟨48026074339333189130912215975451,61806308765265224723841283607058⟩
private def source66 : Affine := ⟨28459895904790038003503535392859,36625960749786799836350390285664⟩
private def toPivotWord : List Nat := [1,2,1,1,2,2,1,1,1,1,1,2,1,2,1,1,2,1,2,1,2,1,1,7,1,1,2]

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {values : List Nat}
    (checked : values.all (fun a => decide (1≤a))=true) : ValWord values :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem history63 (t : Nat) :
    Segment (seed (row t)) (pivot63.at t) 63 99 7588087487203423136110204604459 := by
  have start : landing (row t)=1142451258526756801948927774555+5280985496827154199640037916672*t := by
    simp only [landing,row,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (landing (row t)) (pivot63.at t) 27 42 22359342998407 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment toPivotWord (ρ := 1142451258526756801948927774555)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (600378541187996484*t)
    simpa only [pivot63,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history36 _) tail

private theorem history65 (t : Nat) :
    Segment (seed (row t)) (before65.at t) 65 101 71461913885401381728733599453571 := by
  have raw := CRTWordSegment.crt_word_segment [1,1] (ρ := 1980850684899876252481485357223)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide)
    (1144561273430837494885949696427*t)
  have tail : Segment (pivot63.at t) (before65.at t) 2 2 5 := by
    simpa only [pivot63,before65,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history63 t) tail

/-- For the first half of the strong phase, the real valuation stays
    free above four and the terminal lies below the same N. -/
theorem descends_t66 (q : Nat) :
    let N := seed (3805769794057+2^44*(2+8*q))
    ∃ a, 4≤a ∧ 3*orbit N 65+1=2^a*orbit N 66 ∧ orbit N 66<N ∧
      Segment N (orbit N 66) 66 (101+a) 216921042856660603989194204771465 ∧ Descended N := by
  let t := 2+8*q
  let N := seed (row t)
  let X := before65.at t
  have history := history65 t
  obtain ⟨positive,odd⟩ := affine_admissible (f := before65) (by decide) t
  have divides : (2:Nat)^4 ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*X+1)%16=0
    simp only [X,t,before65,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have margin : 3*X+1<2^4*N := by
    change 3*X+1<16*N
    simp only [X,N,t,row,before65,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨a,positive_a,factor⟩ := P5R3S5.actual_step_factor X odd
  have lower : 4≤a := by
    by_cases enough : 4≤a
    · exact enough
    · have smaller : a+1≤4 := by omega
      exact ((P5R3S5.exact_reserve (step_odd X) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divides)).elim
  have scale := Nat.mul_le_mul_right (step X)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) lower)
  rw [←factor] at scale
  have below : step X<N := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scale margin)
  have whole : Segment N (step X) 66 (101+a) 216921042856660603989194204771465 :=
    compose history (P5R3S5.step_segment X a positive odd positive_a factor)
  have paid : Descended N :=
    ⟨step X,66,101+a,216921042856660603989194204771465,step_pos X,step_odd X,below,whole⟩
  change ∃ b, 4≤b ∧ 3*orbit N 65+1=2^b*orbit N 66 ∧ orbit N 66<N ∧
      Segment N (orbit N 66) 66 (101+b) 216921042856660603989194204771465 ∧ Descended N
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨a,lower,factor,below,whole,paid⟩

/-- The other half has valuation three and is paid by a separate
    physical source, with its own clock and cost. -/
theorem captures_t66 (q : Nat) :
    let N := seed (3805769794057+2^44*(6+8*q))
    ∃ w, w=(orbit N 63-1)/2 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ N<orbit N 66 ∧
      3*orbit N 65+1=8*orbit N 66 ∧
      Segment N (orbit N 66) 66 104 216921042856660603989194204771465 ∧
      Segment w (orbit N 66) 3 4 23 ∧ PaidMeeting N := by
  let t := 6+8*q
  let N := seed (row t)
  let w := source66.at q
  have before := history65 t
  have at65 : before65.at t=capture65.at q := by
    simp only [before65,capture65,t,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [at65] at before
  have final_edge : Segment (capture65.at q) (capture66.at q) 1 3 1 :=
    affine_edge (by decide) q
  have factor : 3*capture65.at q+1=8*capture66.at q := final_edge.book.symm
  have whole : Segment N (capture66.at q) 66 104 216921042856660603989194204771465 :=
    compose before final_edge
  have source : Segment w (capture66.at q) 3 4 23 := by
    have raw := CRTWordSegment.crt_word_segment [1,2,1] (ρ := 28459895904790038003503535392859)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide)
      (1144561273430837494885949696427*q)
    simpa only [w,source66,capture66,Affine.at,←Nat.mul_assoc] using raw
  have source_eq : w=(pivot63.at t-1)/2 := by
    simp only [w,t,source66,pivot63,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨w_positive,w_odd⟩ := affine_admissible (f := source66) (by decide) q
  obtain ⟨end_positive,end_odd⟩ := affine_admissible (f := capture66) (by decide) q
  have priced : w<N := by
    simp only [w,N,t,row,source66,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have above : N<capture66.at q := by
    simp only [N,t,row,capture66,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have paid : PaidMeeting N :=
    ⟨w,capture66.at q,66,104,216921042856660603989194204771465,3,4,23,
      w_positive,w_odd,priced,end_positive,end_odd,whole,source⟩
  change ∃ s, s=(orbit N 63-1)/2 ∧ 0<s ∧ s%2=1 ∧ s<N ∧ N<orbit N 66 ∧
      3*orbit N 65+1=8*orbit N 66 ∧
      Segment N (orbit N 66) 66 104 216921042856660603989194204771465 ∧
      Segment s (orbit N 66) 3 4 23 ∧ PaidMeeting N
  rw [A2Header.physical_endpoint (history63 t).physical,A2Header.physical_endpoint before.physical,
    A2Header.physical_endpoint whole.physical]
  exact ⟨w,source_eq,w_positive,w_odd,priced,above,factor,whole,source,paid⟩

end CollatzCharacterBridge.A2T66
