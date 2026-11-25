import A2U392
import P5U8Fold

namespace CollatzCharacterBridge.A2T42

open A2CertifiedLanding (Descended PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 400000

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,P5CompensationMeetings.Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem lt_of_price {N X a floor : Nat}
    (factor : 3*X+1=2^a*step X) (lower : floor≤a) (price : 3*X+1<2^floor*N) :
    step X<N := by
  have scale := Nat.mul_le_mul_right (step X)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) lower)
  rw [←factor] at scale
  exact Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scale price)

/-- Compose one actual return after a certified book at T41. -/
private theorem terminal_descent {N X S B floor : Nat}
    (history : Segment N X 41 S B) (positive : 0<X) (odd : X%2=1)
    (divides : 2^floor ∣ 3*X+1) (price : 3*X+1<2^floor*N) :
    ∃ a, floor≤a ∧ 3*orbit N 41+1=2^a*orbit N 42 ∧ orbit N 42<N ∧
      Segment N (orbit N 42) 42 (S+a) (3*B+2^S) ∧ Descended N := by
  obtain ⟨a,a_pos,factor⟩ := P5R3S5.actual_step_factor X odd
  have lower : floor≤a := by
    by_cases enough : floor≤a
    · exact enough
    · have smaller : a+1≤floor := by omega
      exact ((P5R3S5.exact_reserve (step_odd X) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divides)).elim
  have below := lt_of_price factor lower price
  have whole : Segment N (step X) 42 (S+a) (3*B+2^S) := by
    simpa only [Nat.pow_one,Nat.mul_one] using
      compose history (P5R3S5.step_segment X a positive odd a_pos factor)
  have paid : Descended N :=
    ⟨step X,42,S+a,3*B+2^S,step_pos X,step_odd X,below,whole⟩
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨a,lower,factor,below,whole,paid⟩

private def last265 (q : Nat) : Nat := 151239447054420893725+291783971017366291224*q
private def last89 (q : Nat) : Nat := 50938707017201231117+291783971017366291224*q
private def last41 (q : Nat) : Nat := 47167919468646282629+291783971017366291224*q
private def last331 (q : Nat) : Nat := 377704449136756534405+583567942034732582448*q
private def source41 (q : Nat) : Nat := 11791979867161570657+72945992754341572806*q

private theorem lead265 (q : Nat) :
    Segment (landing (265+512*q)) (last265 q) 5 7 287 := by
  have start : landing (265+512*q)=79665223139777260891+153696906544127099904*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,2,1,1,2] (ρ := 79665223139777260891)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (600378541187996484*q)
  simpa only [last265,←Nat.mul_assoc] using raw

private theorem lead89 (q : Nat) :
    Segment (landing (89+512*q)) (last89 q) 5 7 319 := by
  have start : landing (89+512*q)=26831911515233570299+153696906544127099904*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,2,1,2,1] (ρ := 26831911515233570299)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (600378541187996484*q)
  simpa only [last89,←Nat.mul_assoc] using raw

private theorem lead41 (q : Nat) :
    Segment (landing (41+256*q)) (last41 q) 5 6 287 := by
  have start : landing (41+256*q)=12422826526721654683+76848453272063549952*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,2,1,1,1] (ρ := 12422826526721654683)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (600378541187996484*q)
  simpa only [last41,←Nat.mul_assoc] using raw

private theorem lead331 (q : Nat) :
    Segment (landing (331+512*q)) (last331 q) 5 6 211 := by
  have start : landing (331+512*q)=99477714998981144863+153696906544127099904*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,1,1,1,2] (ρ := 99477714998981144863)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (1200757082375992968*q)
  simpa only [last331,←Nat.mul_assoc] using raw

theorem descends_265_mod_512 (q : Nat) :
    let N := seed (265+512*q)
    ∃ a, 3≤a ∧ 3*orbit N 41+1=2^a*orbit N 42 ∧ orbit N 42<N ∧
      Segment N (orbit N 42) 42 (64+a) 559893128635931879593 ∧ Descended N := by
  have history : Segment (seed (265+512*q)) (last265 q) 41 64 180482128187407442659 :=
    compose (history36 _) (lead265 q)
  have positive : 0<last265 q := by simp only [last265]; omega
  have odd : last265 q%2=1 := by simp only [last265]; omega
  have divides : 2^3 ∣ 3*last265 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last265 q+1)%8=0
    simp only [last265]
    omega
  have price : 3*last265 q+1<2^3*seed (265+512*q) := by
    change 3*last265 q+1<8*seed (265+512*q)
    simp only [last265,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminal_descent history positive odd divides price

theorem descends_89_mod_512 (q : Nat) :
    let N := seed (89+512*q)
    ∃ a, 3≤a ∧ 3*orbit N 41+1=2^a*orbit N 42 ∧ orbit N 42<N ∧
      Segment N (orbit N 42) 42 (64+a) 573728186691214043305 ∧ Descended N := by
  have history : Segment (seed (89+512*q)) (last89 q) 41 64 185093814205834830563 :=
    compose (history36 _) (lead89 q)
  have positive : 0<last89 q := by simp only [last89]; omega
  have odd : last89 q%2=1 := by simp only [last89]; omega
  have divides : 2^3 ∣ 3*last89 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last89 q+1)%8=0
    simp only [last89]
    omega
  have price : 3*last89 q+1<2^3*seed (89+512*q) := by
    change 3*last89 q+1<8*seed (89+512*q)
    simp only [last89,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminal_descent history positive odd divides price

/-- Two divisions fold into the actual last valuation. A stronger
    last valuation also pays by strict descent of the original. -/
theorem captures_41_mod_256 (q : Nat) :
    let N := seed (41+256*q)
    ∃ w a, w=(orbit N 41-1)/4 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ 3≤a ∧
      3*orbit N 41+1=2^a*orbit N 42 ∧
      Segment N (orbit N 42) 42 (63+a) 550669756599077103785 ∧
      Segment w (orbit N 42) 1 (a-2) 1 ∧ PaidMeeting N ∧
      (4≤a → orbit N 42<N ∧ Descended N) := by
  have history : Segment (seed (41+256*q)) (last41 q) 41 63 180482128187407442659 :=
    compose (history36 _) (lead41 q)
  have positive : 0<last41 q := by simp only [last41]; omega
  have odd : last41 q%2=1 := by simp only [last41]; omega
  have w_pos : 0<source41 q := by simp only [source41]; omega
  have w_odd : source41 q%2=1 := by simp only [source41]; omega
  have w_small : source41 q<seed (41+256*q) := by
    simp only [source41,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have form : last41 q=4*source41 q+1 := by
    simp only [last41,source41,Nat.mul_add,←Nat.mul_assoc]
    omega
  have defines : source41 q=(last41 q-1)/4 := by rw [form]; omega
  have link : 3*last41 q+1=2^2*(3*source41 q+1) := by rw [form]; omega
  have divides : 2^(2+1) ∣ 3*last41 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last41 q+1)%8=0
    simp only [last41]
    omega
  obtain ⟨a,lower,factor,whole,source,meeting⟩ :=
    P5U8Fold.fold_capture history positive odd w_pos w_odd w_small link divides
  have price : 3*last41 q+1<2^4*seed (41+256*q) := by
    change 3*last41 q+1<16*seed (41+256*q)
    simp only [last41,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have strong : 4≤a → step (last41 q)<seed (41+256*q) ∧ Descended (seed (41+256*q)) := by
    intro at_least
    have below := lt_of_price factor at_least price
    exact ⟨below,step (last41 q),42,63+a,550669756599077103785,
      step_pos _,step_odd _,below,whole⟩
  dsimp only
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨source41 q,a,defines,w_pos,w_odd,w_small,lower,factor,whole,source,meeting,strong⟩

/-- Unlike the three preceding guards, this row starts with four ones. -/
theorem descends_331_mod_512 (q : Nat) :
    let N := seed (331+512*q)
    ∃ a, 4≤a ∧ 3*orbit N 41+1=2^a*orbit N 42 ∧ orbit N 42<N ∧
      Segment N (orbit N 42) 42 (63+a) 517811493717781964969 ∧ Descended N := by
  have history : Segment (seed (331+512*q)) (last331 q) 41 63 169529373893642396387 :=
    compose (history36 _) (lead331 q)
  have positive : 0<last331 q := by simp only [last331]; omega
  have odd : last331 q%2=1 := by simp only [last331]; omega
  have divides : 2^4 ∣ 3*last331 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last331 q+1)%16=0
    simp only [last331]
    omega
  have price : 3*last331 q+1<2^4*seed (331+512*q) := by
    change 3*last331 q+1<16*seed (331+512*q)
    simp only [last331,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminal_descent history positive odd divides price

end CollatzCharacterBridge.A2T42
