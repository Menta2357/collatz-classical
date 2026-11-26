import A2U392

namespace CollatzCharacterBridge.A2Capture473

open A2CertifiedLanding (Descended PaidMeeting)
open A2FirstCrossingFusion (Paid)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def row (t : Nat) : Nat := 473+16384*t
private def pivot40 : Affine := ⟨179851123520150633023,6224724715037147546112⟩
private def before45 : Affine := ⟨1365744469231143869525,47269003304813339178288⟩
private def capture45 : Affine := ⟨48634747774044483047813,94538006609626678356576⟩
private def capture46 : Affine := ⟨9119015207633340571465,17725876239305002191858⟩
private def source46 : Affine := ⟨3202287919278649089567,6224724715037147546112⟩

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {values : List Nat}
    (checked : values.all (fun a => decide (1≤a))=true) : ValWord values :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem history40 (t : Nat) :
    Segment (seed (row t)) (pivot40.at t) 40 63 58623480722993351585 := by
  have start : landing (row t)=142104591423328895227+4918301009412067196928*t := by
    simp only [landing,row,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (landing (row t)) (pivot40.at t) 4 6 85 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment [1,2,1,2] (ρ := 142104591423328895227)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (38424226636031774976*t)
    simpa only [pivot40,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history36 _) tail

private theorem history45 (t : Nat) :
    Segment (seed (row t)) (before45.at t) 45 68 16191637315463742130643 := by
  have raw := CRTWordSegment.crt_word_segment [1,1,1,1,1] (ρ := 179851123520150633023)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (97261323672455430408*t)
  have tail : Segment (pivot40.at t) (before45.at t) 5 5 211 := by
    simpa only [pivot40,before45,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history40 t) tail

/-- The even half has an actual last valuation at least five. -/
theorem descends_t46 (q : Nat) :
    let N := seed (473+16384*(2*q))
    ∃ a, 5≤a ∧ 3*orbit N 45+1=2^a*orbit N 46 ∧ orbit N 46<N ∧
      Segment N (orbit N 46) 46 (68+a) 48870059851570579217785 ∧ Descended N := by
  let t := 2*q
  let N := seed (row t)
  let X := before45.at t
  have history := history45 t
  obtain ⟨positive,odd⟩ := affine_admissible (f := before45) (by decide) t
  have divides : (2:Nat)^5 ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*X+1)%32=0
    simp only [X,t,before45,Affine.at,←Nat.mul_assoc]
    omega
  have margin : 3*X+1<2^5*N := by
    change 3*X+1<32*N
    simp only [X,N,t,row,before45,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨a,a_pos,factor⟩ := P5R3S5.actual_step_factor X odd
  have lower : 5≤a := by
    by_cases enough : 5≤a
    · exact enough
    · have smaller : a+1≤5 := by omega
      exact ((P5R3S5.exact_reserve (step_odd X) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divides)).elim
  have scale := Nat.mul_le_mul_right (step X)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) lower)
  rw [←factor] at scale
  have below : step X<N := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scale margin)
  have whole : Segment N (step X) 46 (68+a) 48870059851570579217785 :=
    compose history (P5R3S5.step_segment X a positive odd a_pos factor)
  have paid : Descended N :=
    ⟨step X,46,68+a,48870059851570579217785,step_pos X,step_odd X,below,whole⟩
  change ∃ b, 5≤b ∧ 3*orbit N 45+1=2^b*orbit N 46 ∧ orbit N 46<N ∧
      Segment N (orbit N 46) 46 (68+b) 48870059851570579217785 ∧ Descended N
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨a,lower,factor,below,whole,paid⟩

/-- In the odd half the original valuation is exactly four, and the
    independently certified source follows the word (1,1,1,1,2,2). -/
theorem captures_t46 (q : Nat) :
    let N := seed (473+16384*(1+2*q))
    ∃ w, w=(orbit N 40-1)/2 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ N<orbit N 46 ∧
      3*orbit N 45+1=16*orbit N 46 ∧
      Segment N (orbit N 46) 46 72 48870059851570579217785 ∧
      Segment w (orbit N 46) 6 8 697 ∧ PaidMeeting N := by
  let t := 1+2*q
  let N := seed (row t)
  let w := source46.at q
  have before := history45 t
  have at45 : before45.at t=capture45.at q := by
    simp only [before45,capture45,t,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [at45] at before
  have final_edge : Segment (capture45.at q) (capture46.at q) 1 4 1 :=
    affine_edge (by decide) q
  have factor : 3*capture45.at q+1=16*capture46.at q := final_edge.book.symm
  have whole : Segment N (capture46.at q) 46 72 48870059851570579217785 :=
    compose before final_edge
  have source : Segment w (capture46.at q) 6 8 697 := by
    have raw := CRTWordSegment.crt_word_segment [1,1,1,1,2,2] (ρ := 3202287919278649089567)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (12157665459056928801*q)
    simpa only [w,source46,capture46,Affine.at,←Nat.mul_assoc] using raw
  have source_eq : w=(pivot40.at t-1)/2 := by
    simp only [w,t,source46,pivot40,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨w_positive,w_odd⟩ := affine_admissible (f := source46) (by decide) q
  obtain ⟨end_positive,end_odd⟩ := affine_admissible (f := capture46) (by decide) q
  have priced : w<N := by
    simp only [w,N,t,row,source46,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have above : N<capture46.at q := by
    simp only [N,t,row,capture46,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have paid : PaidMeeting N :=
    ⟨w,capture46.at q,46,72,48870059851570579217785,6,8,697,
      w_positive,w_odd,priced,end_positive,end_odd,whole,source⟩
  change ∃ s, s=(orbit N 40-1)/2 ∧ 0<s ∧ s%2=1 ∧ s<N ∧ N<orbit N 46 ∧
      3*orbit N 45+1=16*orbit N 46 ∧
      Segment N (orbit N 46) 46 72 48870059851570579217785 ∧
      Segment s (orbit N 46) 6 8 697 ∧ PaidMeeting N
  rw [A2Header.physical_endpoint (history40 t).physical,A2Header.physical_endpoint before.physical,
    A2Header.physical_endpoint whole.physical]
  exact ⟨w,source_eq,w_positive,w_odd,priced,above,factor,whole,source,paid⟩

/-- The two parity guards cover the entire original residue. -/
theorem pays_473 (t : Nat) : Paid (seed (473+16384*t)) := by
  by_cases even : t%2=0
  · have coordinate : t=2*(t/2) := by omega
    rw [coordinate]
    obtain ⟨_,_,_,_,_,paid⟩ := descends_t46 (t/2)
    exact Or.inl paid
  have coordinate : t=1+2*(t/2) := by omega
  rw [coordinate]
  obtain ⟨_,_,_,_,_,_,_,_,_,paid⟩ := captures_t46 (t/2)
  exact Or.inr paid

end CollatzCharacterBridge.A2Capture473
