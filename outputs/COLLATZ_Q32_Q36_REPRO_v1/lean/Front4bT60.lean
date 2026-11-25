import A2U392

namespace CollatzCharacterBridge.Front4bT60

open A2CertifiedLanding (Descended)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine affine_admissible)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def index (t : Nat) : Nat := 428769801+2^31*(44+128*t)
private def last : Affine := ⟨1249116564172496083410368651093,3617378839485116033219791633152⟩
private def word : List Nat := [1,2,1,1,2,2,1,1,1,1,1,2,1,2,1,1,2,1,2,1,2,1,1]

private theorem index_affine (t : Nat) : index t=94918050313+274877906944*t := by
  change 428769801+2147483648*(44+128*t)=_
  omega

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {values : List Nat}
    (checked : values.all (fun a => decide (1≤a))=true) : ValWord values :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem history59 (t : Nat) :
    Segment (seed (index t)) (last.at t) 59 88 84284738864848587803900839355 := by
  have start : landing (index t)=28493380289778962962357276507+82515398387924284369375592448*t := by
    simp only [landing,index_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (landing (index t)) (last.at t) 23 31 210847909975 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment word (ρ := 28493380289778962962357276507)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (19212113318015887488*t)
    simpa only [last,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history36 _) tail

/-- The physical valuation on the final return is left free above eight.
    Both the T59 and the T60 book refer to the same original seed. -/
theorem descends_t60 (t : Nat) :
    let N := seed (428769801+2^31*(44+128*t))
    ∃ b, 8≤b ∧ 3*orbit N 59+1=2^b*orbit N 60 ∧ orbit N 60<N ∧
      Segment N (orbit N 59) 59 88 84284738864848587803900839355 ∧
      Segment N (orbit N 60) 60 (88+b) 253163701604367108480427299121 ∧ Descended N := by
  let N := seed (index t)
  let J := last.at t
  have history := history59 t
  obtain ⟨positive,odd⟩ := affine_admissible (f := last) (by decide) t
  have divisible : (2:Nat)^8 ∣ 3*J+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*J+1)%256=0
    simp only [J,last,Affine.at]
    omega
  have margin : 3*J+1<2^8*N := by
    change 3*J+1<256*N
    simp only [J,N,last,Affine.at,seed_affine,index_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨b,b_pos,factor⟩ := P5R3S5.actual_step_factor J odd
  have lower : 8≤b := by
    by_cases enough : 8≤b
    · exact enough
    · have smaller : b+1≤8 := by omega
      exact ((P5R3S5.exact_reserve (step_odd J) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divisible)).elim
  have scaled := Nat.mul_le_mul_right (step J)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) lower)
  rw [←factor] at scaled
  have below : step J<N := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scaled margin)
  have whole : Segment N (step J) 60 (88+b) 253163701604367108480427299121 :=
    compose history (P5R3S5.step_segment J b positive odd b_pos factor)
  have paid : Descended N :=
    ⟨step J,60,88+b,253163701604367108480427299121,step_pos J,step_odd J,below,whole⟩
  change ∃ a, 8≤a ∧ 3*orbit N 59+1=2^a*orbit N 60 ∧ orbit N 60<N ∧
      Segment N (orbit N 59) 59 88 84284738864848587803900839355 ∧
      Segment N (orbit N 60) 60 (88+a) 253163701604367108480427299121 ∧ Descended N
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨b,lower,factor,below,history,whole,paid⟩

end CollatzCharacterBridge.Front4bT60
