import P5J131Residual

namespace CollatzCharacterBridge.P5U8Fold

open A2CertifiedLanding (Descended PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open P5J131Residual (seed)
open P5RZeroA2 (entry entry_book)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 800000

/-- A factor of two relating the two odd inputs can be folded into the
    original valuation while retaining the same odd terminal and both books. -/
theorem fold_capture {N X w j S B s : Nat}
    (history : Segment N X j S B) (x_pos : 0<X) (x_odd : X%2=1)
    (w_pos : 0<w) (w_odd : w%2=1) (w_paid : w<N)
    (link : 3*X+1=2^s*(3*w+1)) (divides : 2^(s+1) ∣ 3*X+1) :
    ∃ d, s+1≤d ∧ 3*X+1=2^d*step X ∧
      Segment N (step X) (j+1) (S+d) (3*B+2^S) ∧
      Segment w (step X) 1 (d-s) 1 ∧ PaidMeeting N := by
  obtain ⟨d,d_pos,factor⟩ := P5R3S5.actual_step_factor X x_odd
  have bound : s+1≤d := by
    by_cases sufficient : s+1≤d
    · exact sufficient
    · have smaller : d+1≤s+1 := by omega
      exact ((P5R3S5.exact_reserve (step_odd X) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divides)).elim
  have folded : 3*w+1=2^(d-s)*step X := by
    apply Nat.eq_of_mul_eq_mul_left (Nat.pow_pos (by decide : 0<(2:Nat)))
    calc
      2^s*(3*w+1) = 3*X+1 := link.symm
      _ = 2^d*step X := factor
      _ = 2^s*(2^(d-s)*step X) := by
        rw [←Nat.mul_assoc,←Nat.pow_add,show s+(d-s)=d by omega]
  have original : Segment N (step X) (j+1) (S+d) (3*B+2^S) := by
    simpa only [Nat.pow_one,Nat.mul_one] using
      compose history (P5R3S5.step_segment X d x_pos x_odd d_pos factor)
  have auxiliary : Segment w (step X) 1 (d-s) 1 :=
    ⟨A2Header.Physical.edge w_pos w_odd (step_pos X) (step_odd X) (by omega) folded,
      by simpa only [Nat.pow_one] using folded.symm⟩
  exact ⟨d,bound,factor,original,auxiliary,
    w,step X,j+1,S+d,3*B+2^S,1,d-s,1,w_pos,w_odd,w_paid,step_pos X,step_odd X,
    original,auxiliary⟩

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem seed_eq (u : Nat) : seed u = P5RZeroA2.original.at (131+256*u) := rfl

private def g : Affine := ⟨8872732071030827,33354363399333138⟩
private def g40 : Affine := ⟨42227095470363965,133417453597332552⟩
private def g360 : Affine := ⟨375770729463695345,533669814389330208⟩
private def g904 : Affine := ⟨942794907252358691,1067339628778660416⟩
private def k360 : Affine := ⟨281828047097771509,400252360791997656⟩
private def k904 : Affine := ⟨1414192360878538037,1601009443167990624⟩

private def w40 : Affine := ⟨10556773867590991,33354363399333138⟩
private def w360 : Affine := ⟨70457011774442877,100063090197999414⟩
private def w904 : Affine := ⟨88387022554908627,100063090197999414⟩

private theorem history34 (q : Nat) :
    Segment (seed (8+32*q)) (g.at q) 34 52 61110743329849865 := by
  have entry_eq : entry.at (131+256*(8+32*q))=3692801967478763+13881976577114112*q := by
    simp only [entry,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (entry.at (131+256*(8+32*q))) (g.at q) 9 13 42655 := by
    rw [entry_eq]
    have h := CRTWordSegment.crt_word_segment [1,2,2,1,1,1,2,2,1]
      (ρ := 3692801967478763) (by decide) (by decide) (valid_of_list (by decide))
      (by decide) (847288609443*q)
    simpa only [g,Affine.at,←Nat.mul_assoc] using h
  exact compose (entry_book (131+256*(8+32*q))) tail

private theorem history40 (q : Nat) :
    Segment (seed (40+128*q)) (g40.at q) 34 52 61110743329849865 := by
  have h := history34 (1+4*q)
  rw [show 8+32*(1+4*q)=40+128*q by omega,
    show g.at (1+4*q)=g40.at q by
      simp only [g,g40,Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega] at h
  exact h

private theorem history360 (q : Nat) :
    Segment (seed (360+512*q)) (k360.at q) 35 54 187835829616920091 := by
  have h := history34 (11+16*q)
  rw [show 8+32*(11+16*q)=360+512*q by omega,
    show g.at (11+16*q)=g360.at q by
      simp only [g,g360,Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega] at h
  exact compose h (affine_edge (by decide) q : Segment (g360.at q) (k360.at q) 1 2 1)

private theorem history904 (q : Nat) :
    Segment (seed (904+1024*q)) (k904.at q) 35 53 187835829616920091 := by
  have h := history34 (28+32*q)
  rw [show 8+32*(28+32*q)=904+1024*q by omega,
    show g.at (28+32*q)=g904.at q by
      simp only [g,g904,Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega] at h
  exact compose h (affine_edge (by decide) q : Segment (g904.at q) (k904.at q) 1 1 1)

/-- In u = 40 mod 128 the source folds two divisions at the real T35. -/
theorem capture40 (q : Nat) :
    let N := seed (40+128*q)
    ∃ w c, orbit N 34=4*w+1 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ 3≤c ∧
      3*orbit N 34+1=2^c*orbit N 35 ∧
      Segment N (orbit N 35) 35 (52+c) 187835829616920091 ∧
      Segment w (orbit N 35) 1 (c-2) 1 ∧ PaidMeeting N := by
  let N := seed (40+128*q)
  let X := g40.at q
  let w := w40.at q
  have history := history40 q
  obtain ⟨x_pos,x_odd⟩ := affine_admissible (f := g40) (by decide) q
  obtain ⟨w_pos,w_odd⟩ := affine_admissible (f := w40) (by decide) q
  have form : X=4*w+1 := by
    simp only [X,w,g40,w40,Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega
  have paid : w<N := by
    simp only [w,w40,N,seed_eq,P5RZeroA2.original,
      Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega
  have link : 3*X+1=2^2*(3*w+1) := by rw [form]; omega
  have divides : 2^3 ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*(42227095470363965+133417453597332552*q)+1)%8=0
    omega
  obtain ⟨c,bound,factor,original,auxiliary,meeting⟩ :=
    fold_capture history x_pos x_odd w_pos w_odd paid link divides
  dsimp only
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint original.physical]
  exact ⟨w,c,form,w_pos,w_odd,paid,bound,factor,original,auxiliary,meeting⟩

/-- The same two-division fold applies at T36 in u = 360 mod 512. -/
theorem capture360 (q : Nat) :
    let N := seed (360+512*q)
    ∃ w c, orbit N 35=4*w+1 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ 3≤c ∧
      3*orbit N 35+1=2^c*orbit N 36 ∧
      Segment N (orbit N 36) 36 (54+c) 581521887360242257 ∧
      Segment w (orbit N 36) 1 (c-2) 1 ∧ PaidMeeting N := by
  let N := seed (360+512*q)
  let X := k360.at q
  let w := w360.at q
  have history := history360 q
  obtain ⟨x_pos,x_odd⟩ := affine_admissible (f := k360) (by decide) q
  obtain ⟨w_pos,w_odd⟩ := affine_admissible (f := w360) (by decide) q
  have form : X=4*w+1 := by
    simp only [X,w,k360,w360,Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega
  have paid : w<N := by
    simp only [w,w360,N,seed_eq,P5RZeroA2.original,
      Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega
  have link : 3*X+1=2^2*(3*w+1) := by rw [form]; omega
  have divides : 2^3 ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*(281828047097771509+400252360791997656*q)+1)%8=0
    omega
  obtain ⟨c,bound,factor,original,auxiliary,meeting⟩ :=
    fold_capture history x_pos x_odd w_pos w_odd paid link divides
  dsimp only
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint original.physical]
  exact ⟨w,c,form,w_pos,w_odd,paid,bound,factor,original,auxiliary,meeting⟩

/-- In u = 904 mod 1024 the four-division fold pays, and the original
    terminal is already strictly below the original seed. -/
theorem descends904 (q : Nat) :
    let N := seed (904+1024*q)
    ∃ w c, orbit N 35=16*w+5 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ 5≤c ∧
      3*orbit N 35+1=2^c*orbit N 36 ∧ orbit N 36<N ∧
      Segment N (orbit N 36) 36 (53+c) 572514688105501265 ∧
      Segment w (orbit N 36) 1 (c-4) 1 ∧ Descended N ∧ PaidMeeting N := by
  let N := seed (904+1024*q)
  let X := k904.at q
  let w := w904.at q
  have history := history904 q
  obtain ⟨x_pos,x_odd⟩ := affine_admissible (f := k904) (by decide) q
  obtain ⟨w_pos,w_odd⟩ := affine_admissible (f := w904) (by decide) q
  have form : X=16*w+5 := by
    simp only [X,w,k904,w904,Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega
  have paid : w<N := by
    simp only [w,w904,N,seed_eq,P5RZeroA2.original,
      Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega
  have link : 3*X+1=2^4*(3*w+1) := by rw [form]; omega
  have divides : 2^5 ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*(1414192360878538037+1601009443167990624*q)+1)%32=0
    omega
  obtain ⟨c,bound,factor,original,auxiliary,meeting⟩ :=
    fold_capture history x_pos x_odd w_pos w_odd paid link divides
  have price : 3*X+1<32*N := by
    simp only [X,k904,N,seed_eq,P5RZeroA2.original,
      Affine.at,Nat.mul_add,←Nat.mul_assoc]; omega
  have scale := Nat.mul_le_mul_right (step X)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) bound)
  rw [←factor] at scale
  have below : step X<N := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scale price)
  have descent : Descended N :=
    ⟨step X,36,53+c,572514688105501265,step_pos X,step_odd X,below,original⟩
  dsimp only
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint original.physical]
  exact ⟨w,c,form,w_pos,w_odd,paid,bound,factor,below,original,auxiliary,descent,meeting⟩

end CollatzCharacterBridge.P5U8Fold
