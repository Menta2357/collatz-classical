import A2U392
import P5U8Fold

namespace CollatzCharacterBridge.A2T43

open A2CertifiedLanding (Descended PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord cost total)
open A2U392 (seed landing history36)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 400000

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,P5CompensationMeetings.Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem seed_progression (k q : Nat) :
    seed (k+2048*q)=seed k+590295810358705651712*q := by
  simp only [seed_affine,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

/-- Transport each exact suffix from T36 by its CRT stride and keep the
    original prefix. All row-specific tests are closed integer comparisons. -/
private theorem lift_book (k q : Nat) (word : List Nat) (lift : Nat)
    (valid : ValWord word)
    (crt : (3^word.length*landing k+cost word)%2^(total word+1)=2^total word)
    (stride : 2^(total word+1)*lift=614787626176508399616) :
    Segment (seed (k+2048*q))
      (CRTWordSegment.initial_terminal word (landing k)+(2*3^word.length*lift)*q)
      (36+word.length) (57+total word) (3^word.length*572514688105501265+2^57*cost word) := by
  have positive : 0<landing k := by simp only [landing]; omega
  have odd := (A2U392.ordering k).2.2.2.2.2
  have coord : landing (k+2048*q)=landing k+614787626176508399616*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  have raw := CRTWordSegment.crt_word_segment word positive odd valid crt (lift*q)
  have tail : Segment (landing (k+2048*q))
      (CRTWordSegment.initial_terminal word (landing k)+(2*3^word.length*lift)*q)
      word.length (total word) (cost word) := by
    simpa only [coord,←Nat.mul_assoc,stride] using raw
  exact compose (history36 _) tail

private theorem numerator_affine (y dy q : Nat) :
    3*(y+dy*q)+1=(3*y+1)+(3*dy)*q := by
  simp only [Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem odd_affine {y dy : Nat} (q : Nat) (odd : y%2=1) (even : dy%2=0) :
    (y+dy*q)%2=1 := by
  rw [Nat.add_mod,Nat.mul_mod,odd,even,Nat.zero_mul]

private theorem terminal_descent {N X S B p : Nat}
    (history : Segment N X 42 S B) (positive : 0<X) (odd : X%2=1)
    (divides : 2^p ∣ 3*X+1) (price : 3*X+1<2^p*N) :
    ∃ a, p≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (S+a) (3*B+2^S) ∧ Descended N := by
  obtain ⟨a,a_pos,factor⟩ := P5R3S5.actual_step_factor X odd
  have lower : p≤a := by
    by_cases enough : p≤a
    · exact enough
    · have smaller : a+1≤p := by omega
      exact ((P5R3S5.exact_reserve (step_odd X) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divides)).elim
  have scale := Nat.mul_le_mul_right (step X)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) lower)
  rw [←factor] at scale
  have below := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scale price)
  have whole : Segment N (step X) 43 (S+a) (3*B+2^S) := by
    simpa only [Nat.pow_one,Nat.mul_one] using
      compose history (P5R3S5.step_segment X a positive odd a_pos factor)
  have paid : Descended N :=
    ⟨step X,43,S+a,3*B+2^S,step_pos X,step_odd X,below,whole⟩
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨a,lower,factor,below,whole,paid⟩

/-- A strict intercept margin and a weak slope margin suffice uniformly. -/
private theorem descent_row {k q y dy S B p : Nat}
    (history : Segment (seed (k+2048*q)) (y+dy*q) 42 S B)
    (checks : 0<y ∧ y%2=1 ∧ dy%2=0 ∧ (3*y+1)%2^p=0 ∧ (3*dy)%2^p=0 ∧
      3*y+1<2^p*seed k ∧ 3*dy≤2^p*590295810358705651712) :
    let N := seed (k+2048*q)
    ∃ a, p≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (S+a) (3*B+2^S) ∧ Descended N := by
  obtain ⟨positive,odd,even,base_div,stride_div,base_lt,stride_le⟩ := checks
  have divides : 2^p ∣ 3*(y+dy*q)+1 := by
    rw [numerator_affine]
    exact Nat.dvd_add (Nat.dvd_of_mod_eq_zero base_div)
      (Nat.dvd_mul_right_of_dvd (Nat.dvd_of_mod_eq_zero stride_div) q)
  have price : 3*(y+dy*q)+1<2^p*seed (k+2048*q) := by
    rw [seed_progression,numerator_affine,Nat.mul_add,←Nat.mul_assoc]
    exact Nat.add_lt_add_of_lt_of_le base_lt (Nat.mul_le_mul_right q stride_le)
  exact terminal_descent history (by omega) (odd_affine q odd even) divides price

/-- The physical source uses its own clock. Proof transfers only at the
    common terminal and does not replace the original T42 history. -/
private theorem capture_row {k q y dy w dw S B : Nat}
    (history : Segment (seed (k+2048*q)) (y+dy*q) 42 S B)
    (checks : 0<w ∧ w%2=1 ∧ dw%2=0 ∧ y=4*w+1 ∧ dy=4*dw ∧
      w<seed k ∧ dw≤590295810358705651712) :
    let N := seed (k+2048*q)
    ∃ v a, v=(orbit N 42-1)/4 ∧ 0<v ∧ v%2=1 ∧ v<N ∧ 3≤a ∧
      3*orbit N 42+1=2^a*orbit N 43 ∧
      Segment N (orbit N 43) 43 (S+a) (3*B+2^S) ∧
      Segment v (orbit N 43) 1 (a-2) 1 ∧ PaidMeeting N := by
  obtain ⟨w0_pos,w0_odd,ws_even,base_eq,stride_eq,base_lt,stride_le⟩ := checks
  let X := y+dy*q
  let v := w+dw*q
  have form : X=4*v+1 := by
    simp only [X,v,base_eq,stride_eq,Nat.mul_add,←Nat.mul_assoc]
    omega
  have positive : 0<X := by omega
  have odd : X%2=1 := by omega
  have v_pos : 0<v := by dsimp only [v]; omega
  have v_odd : v%2=1 := odd_affine q w0_odd ws_even
  have v_paid : v<seed (k+2048*q) := by
    rw [seed_progression]
    exact Nat.add_lt_add_of_lt_of_le base_lt (Nat.mul_le_mul_right q stride_le)
  have source_eq : v=(X-1)/4 := by omega
  have link : 3*X+1=2^2*(3*v+1) := by rw [form]; omega
  have divides : 2^(2+1) ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*X+1)%8=0
    omega
  obtain ⟨a,lower,factor,whole,source,meeting⟩ :=
    P5U8Fold.fold_capture history positive odd v_pos v_odd v_paid link divides
  dsimp only
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨v,a,source_eq,v_pos,v_odd,v_paid,lower,factor,whole,source,meeting⟩

theorem descends_9_mod_2048 (q : Nat) :
    let N := seed (9+2048*q)
    ∃ a, 3≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (66+a) 1753466362202633845243 ∧ Descended N := by
  have history : Segment (seed (9+2048*q))
      (4010596159303311085+875351913052098873672*q) 42 66 559893128635931879593 :=
    lift_book 9 q [1,2,1,1,2,2] 600378541187996484 (valid_of_list (by decide))
      (by decide) (by decide)
  exact descent_row (p := 3) history (by decide)

theorem captures_169_mod_2048 (q : Nat) :
    let N := seed (169+2048*q)
    ∃ w a, w=(orbit N 42-1)/4 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ 3≤a ∧
      3*orbit N 42+1=2^a*orbit N 43 ∧
      Segment N (orbit N 43) 43 (65+a) 1688902757944650414587 ∧
      Segment w (orbit N 43) 1 (a-2) 1 ∧ PaidMeeting N := by
  have history : Segment (seed (169+2048*q))
      (144794928732997071181+1750703826104197747344*q) 42 65 550669756599077103785 :=
    lift_book 169 q [1,2,1,1,1,2] 1200757082375992968 (valid_of_list (by decide))
      (by decide) (by decide)
  exact capture_row (w := 36198732183249267795) (dw := 437675956526049436836) history (by decide)

theorem captures_217_mod_2048 (q : Nat) :
    let N := seed (217+2048*q)
    ∃ w a, w=(orbit N 42-1)/4 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ 3≤a ∧
      3*orbit N 42+1=2^a*orbit N 43 ∧
      Segment N (orbit N 43) 43 (65+a) 1758078048221061233147 ∧
      Segment w (orbit N 43) 1 (a-2) 1 ∧ PaidMeeting N := by
  have history : Segment (seed (217+2048*q))
      (185827049657314205885+1750703826104197747344*q) 42 65 573728186691214043305 :=
    lift_book 217 q [1,2,1,2,1,1] 1200757082375992968 (valid_of_list (by decide))
      (by decide) (by decide)
  exact capture_row (w := 46456762414328551471) (dw := 437675956526049436836) history (by decide)

theorem descends_361_mod_2048 (q : Nat) :
    let N := seed (361+2048*q)
    ∃ a, 5≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (64+a) 1670456013870940862971 ∧ Descended N := by
  have history : Segment (seed (361+2048*q))
      (617846824860531219989+3501407652208395494688*q) 42 64 550669756599077103785 :=
    lift_book 361 q [1,2,1,1,1,1] 2401514164751985936 (valid_of_list (by decide))
      (by decide) (by decide)
  exact descent_row (p := 5) history (by decide)

theorem descends_393_mod_2048 (q : Nat) :
    let N := seed (393+2048*q)
    ∃ a, 4≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (65+a) 1716572874055214742011 ∧ Descended N := by
  have history : Segment (seed (393+2048*q))
      (336278159713143699797+1750703826104197747344*q) 42 65 559893128635931879593 :=
    lift_book 393 q [1,2,1,1,2,1] 1200757082375992968 (valid_of_list (by decide))
      (by decide) (by decide)
  exact descent_row (p := 4) history (by decide)

theorem descends_857_mod_2048 (q : Nat) :
    let N := seed (857+2048*q)
    ∃ a, 3≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (66+a) 1794971536368480336379 ∧ Descended N := by
  have history : Segment (seed (857+2048*q))
      (366460997657438000965+875351913052098873672*q) 42 66 573728186691214043305 :=
    lift_book 857 q [1,2,1,2,1,2] 600378541187996484 (valid_of_list (by decide))
      (by decide) (by decide)
  exact descent_row (p := 3) history (by decide)

theorem descends_1193_mod_2048 (q : Nat) :
    let N := seed (1193+2048*q)
    ∃ a, 4≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (65+a) 1688902757944650414587 ∧ Descended N := by
  have history : Segment (seed (1193+2048*q))
      (1020146841785095944853+1750703826104197747344*q) 42 65 550669756599077103785 :=
    lift_book 1193 q [1,2,1,1,1,2] 1200757082375992968 (valid_of_list (by decide))
      (by decide) (by decide)
  exact descent_row (p := 4) history (by decide)

theorem descends_1241_mod_2048 (q : Nat) :
    let N := seed (1241+2048*q)
    ∃ a, 4≤a ∧ 3*orbit N 42+1=2^a*orbit N 43 ∧ orbit N 43<N ∧
      Segment N (orbit N 43) 43 (65+a) 1758078048221061233147 ∧ Descended N := by
  have history : Segment (seed (1241+2048*q))
      (1061178962709413079557+1750703826104197747344*q) 42 65 573728186691214043305 :=
    lift_book 1241 q [1,2,1,2,1,1] 1200757082375992968 (valid_of_list (by decide))
      (by decide) (by decide)
  exact descent_row (p := 4) history (by decide)

theorem captures_1417_mod_2048 (q : Nat) :
    let N := seed (1417+2048*q)
    ∃ w a, w=(orbit N 42-1)/4 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ 3≤a ∧
      3*orbit N 42+1=2^a*orbit N 43 ∧
      Segment N (orbit N 43) 43 (65+a) 1716572874055214742011 ∧
      Segment w (orbit N 43) 1 (a-2) 1 ∧ PaidMeeting N := by
  have history : Segment (seed (1417+2048*q))
      (1211630072765242573469+1750703826104197747344*q) 42 65 559893128635931879593 :=
    lift_book 1417 q [1,2,1,1,2,1] 1200757082375992968 (valid_of_list (by decide))
      (by decide) (by decide)
  exact capture_row (w := 302907518191310643367) (dw := 437675956526049436836) history (by decide)

end CollatzCharacterBridge.A2T43
