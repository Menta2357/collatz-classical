import Front4bT61S3
import Front4bEarlyMeeting

namespace CollatzCharacterBridge.Front4bT65U6

open A2CertifiedLanding (Descended PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed)
open Front4bT61S3 (checkpoint60 history60 index seed_affine)
open P5CompensationMeetings (Affine affine_admissible)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def target64 : Affine :=
  ⟨23734332878181100809387659247581,27469470562340099877262792714248⟩

private def word : List Nat := [2,2,1,1]

private theorem valid_of_list {values : List Nat}
    (checked : values.all (fun a => decide (1≤a))=true) : ValWord values :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

/-- Exact prefix of the original on the whole new cylinder. -/
theorem history64 (t : Nat) :
    Segment (seed (index (221+256*t))) (target64.at t) 64 100 23338666639838685855883807453313 := by
  have start : checkpoint60.at (221+256*t)=18753053138315931503713706072161+
      21704273036910696199318749798912*t := by
    simp only [checkpoint60,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (checkpoint60.at (221+256*t)) (target64.at t) 4 6 143 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment word (ρ := 18753053138315931503713706072161)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (169564633100864814057177732804*t)
    simpa only [target64,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history60 (221+256*t)) tail

/-- All (s=221+256t), equivalently (s=29+32u, u=6+8t), pay at T65.
    The valuation is exact, and the two outcomes retain the same original. -/
theorem pays_t65 (t : Nat) :
    let N := seed (index (221+256*t))
    ∃ d, 3≤d ∧ 3*orbit N 64+1=2^d*orbit N 65 ∧ ¬2^(d+1) ∣ 3*orbit N 64+1 ∧
      Segment N (orbit N 64) 64 100 23338666639838685855883807453313 ∧
      Segment N (orbit N 65) 65 (100+d) 71283650519744286969148125565315 ∧
      ((4≤d ∧ orbit N 65<N ∧ Descended N) ∨
       (d=3 ∧ orbit N 65%3=2 ∧ 2*orbit N 65<3*N+1 ∧ PaidMeeting N)) := by
  let N := seed (index (221+256*t))
  let X := target64.at t
  have hist := history64 t
  obtain ⟨pos,odd⟩ := affine_admissible (f := target64) (by decide) t
  have div8 : (2:Nat)^3 ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*X+1)%8=0
    simp only [X,target64,Affine.at]
    omega
  obtain ⟨d,dpos,factor⟩ := P5R3S5.actual_step_factor X odd
  obtain ⟨_,exactFloor⟩ := P5R3S5.exact_reserve (step_odd X) factor
  have lower : 3≤d := by
    by_cases enough : 3≤d
    · exact enough
    · have smaller : d+1≤3 := by omega
      exact (exactFloor (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) div8)).elim
  have whole : Segment N (step X) 65 (100+d) 71283650519744286969148125565315 :=
    compose hist (P5R3S5.step_segment X d pos odd dpos factor)
  have outcome : (4≤d ∧ step X<N ∧ Descended N) ∨
      (d=3 ∧ step X%3=2 ∧ 2*step X<3*N+1 ∧ PaidMeeting N) := by
    by_cases strong : 4≤d
    · have margin16 : 3*X+1<16*N := by
        simp only [X,N,target64,Affine.at,seed_affine,index,Nat.mul_add,←Nat.mul_assoc]
        omega
      have margin : 3*X+1<2^d*N :=
        Nat.lt_of_lt_of_le margin16
          (Nat.mul_le_mul_right N (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) strong))
      obtain ⟨smaller,_,paid⟩ :=
        Front4bPairExit.descent_of_numerator_bound hist pos odd dpos factor margin
      exact Or.inl ⟨strong,smaller,paid⟩
    · have eq : d=3 := by omega
      have right_factor : 3*X+1=8*step X := by simpa only [eq] using factor
      have margin12 : 3*X+1<12*N+4 := by
        simp only [X,N,target64,Affine.at,seed_affine,index,Nat.mul_add,←Nat.mul_assoc]
        omega
      have residue : step X%3=2 := by omega
      have price : 2*step X<3*N+1 := by omega
      exact Or.inr ⟨eq,residue,price,
        Front4bEarlyMeeting.paid_of_small_two_mod_three whole (step_odd X) residue price⟩
  change ∃ a, 3≤a ∧ 3*orbit N 64+1=2^a*orbit N 65 ∧ ¬2^(a+1) ∣ 3*orbit N 64+1 ∧
    Segment N (orbit N 64) 64 100 23338666639838685855883807453313 ∧
    Segment N (orbit N 65) 65 (100+a) 71283650519744286969148125565315 ∧
    ((4≤a ∧ orbit N 65<N ∧ Descended N) ∨
      (a=3 ∧ orbit N 65%3=2 ∧ 2*orbit N 65<3*N+1 ∧ PaidMeeting N))
  rw [A2Header.physical_endpoint hist.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨d,lower,factor,exactFloor,hist,whole,outcome⟩

end CollatzCharacterBridge.Front4bT65U6
