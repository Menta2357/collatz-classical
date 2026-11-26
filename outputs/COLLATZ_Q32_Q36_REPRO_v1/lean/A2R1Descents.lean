import A2U392

namespace CollatzCharacterBridge.A2R1Descents

open A2CertifiedLanding (Descended)
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

/-- The affine bound pays for the last physical return at its actual
    valuation, retaining the original book at both clocks. -/
private theorem terminal_descends {N X j S B floor : Nat}
    (history : Segment N X j S B) (positive : 0<X) (odd : X%2=1)
    (divides : 2^floor ∣ 3*X+1) (price : 3*X+1<2^floor*N) :
    ∃ c, floor≤c ∧ 3*orbit N j+1=2^c*orbit N (j+1) ∧ orbit N (j+1)<N ∧
      Segment N (orbit N (j+1)) (j+1) (S+c) (3*B+2^S) ∧ Descended N := by
  obtain ⟨c,c_pos,factor⟩ := P5R3S5.actual_step_factor X odd
  have minimum : floor≤c := by
    by_cases enough : floor≤c
    · exact enough
    · have smaller : c+1≤floor := by omega
      exact ((P5R3S5.exact_reserve (step_odd X) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divides)).elim
  have scale := Nat.mul_le_mul_right (step X)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) minimum)
  rw [←factor] at scale
  have below : step X<N := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scale price)
  have whole : Segment N (step X) (j+1) (S+c) (3*B+2^S) := by
    simpa only [Nat.pow_one,Nat.mul_one] using
      compose history (P5R3S5.step_segment X c positive odd c_pos factor)
  have paid : Descended N :=
    ⟨step X,j+1,S+c,3*B+2^S,step_pos X,step_odd X,below,whole⟩
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨c,minimum,factor,below,whole,paid⟩

private def last1 (q : Nat) : Nat := 467162665831940629+5403406870691968356*q
private def last57 (q : Nat) : Nat := 29068630069880744813+32420441224151810136*q
private def last25 (q : Nat) : Nat := 9643807093353629809+48630661836227715204*q
private def last73 (q : Nat) : Nat := 55760610563878046021+97261323672455430408*q

private theorem lead1 (q : Nat) :
    Segment (landing (1+16*q)) (last1 q) 2 3 5 := by
  have start : landing (1+16*q)=415255702961725003+4803028329503971872*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,2] (ρ := 415255702961725003)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (300189270593998242*q)
  simpa only [last1,←Nat.mul_assoc] using raw

private theorem lead57 (q : Nat) :
    Segment (landing (57+64*q)) (last57 q) 3 4 23 := by
  have start : landing (57+64*q)=17225854856225626555+19212113318015887488*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,2,1] (ρ := 17225854856225626555)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (600378541187996484*q)
  simpa only [last57,←Nat.mul_assoc] using raw

private theorem lead25 (q : Nat) :
    Segment (landing (25+128*q)) (last25 q) 4 6 85 := by
  have start : landing (25+128*q)=7619798197217682811+38424226636031774976*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,2,1,2] (ρ := 7619798197217682811)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (300189270593998242*q)
  simpa only [last25,←Nat.mul_assoc] using raw

private theorem lead73 (q : Nat) :
    Segment (landing (73+128*q)) (last73 q) 4 5 85 := by
  have start : landing (73+128*q)=22028883185729598427+38424226636031774976*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  rw [start]
  have raw := CRTWordSegment.crt_word_segment [1,2,1,1] (ρ := 22028883185729598427)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide) (600378541187996484*q)
  simpa only [last73,←Nat.mul_assoc] using raw

theorem descends_1_mod_16 (q : Nat) :
    let N := seed (1+16*q)
    ∃ c, 2≤c ∧ 3*orbit N 38+1=2^c*orbit N 39 ∧ orbit N 39<N ∧
      Segment N (orbit N 39) 39 (60+c) 18772545904593219211 ∧ Descended N := by
  have history : Segment (seed (1+16*q)) (last1 q) 38 60 5873208133328790745 :=
    compose (history36 _) (lead1 q)
  have positive : 0<last1 q := by simp only [last1]; omega
  have odd : last1 q%2=1 := by simp only [last1]; omega
  have divides : 2^2 ∣ 3*last1 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last1 q+1)%4=0
    simp only [last1]
    omega
  have price : 3*last1 q+1<2^2*seed (1+16*q) := by
    change 3*last1 q+1<4*seed (1+16*q)
    simp only [last1,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminal_descends history positive odd divides price

theorem descends_57_mod_64 (q : Nat) :
    let N := seed (57+64*q)
    ∃ c, 3≤c ∧ 3*orbit N 39+1=2^c*orbit N 40 ∧ orbit N 40<N ∧
      Segment N (orbit N 40) 40 (61+c) 58623480722993351585 ∧ Descended N := by
  have history : Segment (seed (57+64*q)) (last57 q) 39 61 18772545904593219211 :=
    compose (history36 _) (lead57 q)
  have positive : 0<last57 q := by simp only [last57]; omega
  have odd : last57 q%2=1 := by simp only [last57]; omega
  have divides : 2^3 ∣ 3*last57 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last57 q+1)%8=0
    simp only [last57]
    omega
  have price : 3*last57 q+1<2^3*seed (57+64*q) := by
    change 3*last57 q+1<8*seed (57+64*q)
    simp only [last57,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminal_descends history positive odd divides price

theorem descends_25_mod_128 (q : Nat) :
    let N := seed (25+128*q)
    ∃ c, 2≤c ∧ 3*orbit N 40+1=2^c*orbit N 41 ∧ orbit N 41<N ∧
      Segment N (orbit N 41) 41 (63+c) 185093814205834830563 ∧ Descended N := by
  have history : Segment (seed (25+128*q)) (last25 q) 40 63 58623480722993351585 :=
    compose (history36 _) (lead25 q)
  have positive : 0<last25 q := by simp only [last25]; omega
  have odd : last25 q%2=1 := by simp only [last25]; omega
  have divides : 2^2 ∣ 3*last25 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last25 q+1)%4=0
    simp only [last25]
    omega
  have price : 3*last25 q+1<2^2*seed (25+128*q) := by
    change 3*last25 q+1<4*seed (25+128*q)
    simp only [last25,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminal_descends history positive odd divides price

theorem descends_73_mod_128 (q : Nat) :
    let N := seed (73+128*q)
    ∃ c, 3≤c ∧ 3*orbit N 40+1=2^c*orbit N 41 ∧ orbit N 41<N ∧
      Segment N (orbit N 41) 41 (62+c) 180482128187407442659 ∧ Descended N := by
  have history : Segment (seed (73+128*q)) (last73 q) 40 62 58623480722993351585 :=
    compose (history36 _) (lead73 q)
  have positive : 0<last73 q := by simp only [last73]; omega
  have odd : last73 q%2=1 := by simp only [last73]; omega
  have divides : 2^3 ∣ 3*last73 q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*last73 q+1)%8=0
    simp only [last73]
    omega
  have price : 3*last73 q+1<2^3*seed (73+128*q) := by
    change 3*last73 q+1<8*seed (73+128*q)
    simp only [last73,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact terminal_descends history positive odd divides price

end CollatzCharacterBridge.A2R1Descents
