import Front4bT61S3

namespace CollatzCharacterBridge.Front4bT64U1

open A2CertifiedLanding (Descended)
open A2U392 (seed)
open Front4bT61S3 (checkpoint60 history60 index seed_affine)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 350000

private def start60 : Affine :=
  ⟨5187882490246746379139487447841,10852136518455348099659374899456⟩

private def target61 : Affine :=
  ⟨3890911867685059784354615585881,8139102388841511074744531174592⟩

private def target62 : Affine :=
  ⟨2918183900763794838265961689411,6104326791631133306058398380944⟩

private def target63 : Affine :=
  ⟨4377275851145692257398942534117,9156490187446699959087597571416⟩

private theorem history63 (t : Nat) :
    Segment (seed (index (61+128*t))) (target63.at t) 63 99 7568280446574857051711818616875 := by
  have start : checkpoint60.at (61+128*t)=start60.at t := by
    simp only [checkpoint60,start60,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have first : Segment (start60.at t) (target61.at t) 1 2 1 := affine_edge (by decide) t
  have second : Segment (target61.at t) (target62.at t) 1 2 1 := affine_edge (by decide) t
  have third : Segment (target62.at t) (target63.at t) 1 1 1 := affine_edge (by decide) t
  have tail : Segment (start60.at t) (target63.at t) 3 5 37 :=
    compose (compose first second) third
  rw [←start] at tail
  exact compose (history60 (61+128*t)) tail

/-- Every residual seed with u = 1 mod 4 descends at T64. The final
    valuation is exact and may exceed its certified lower bound. -/
theorem descends_t64 (t : Nat) :
    let N := seed (index (61+128*t))
    ∃ d, 3≤d ∧ 3*orbit N 63+1=2^d*orbit N 64 ∧ ¬2^(d+1) ∣ 3*orbit N 63+1 ∧
      orbit N 64<N ∧ Segment N (orbit N 63) 63 99 7568280446574857051711818616875 ∧
      Segment N (orbit N 64) 64 (99+d) 23338666639838685855883807453313 ∧ Descended N := by
  let N := seed (index (61+128*t))
  let X := target63.at t
  have hist := history63 t
  obtain ⟨pos,odd⟩ := affine_admissible (f := target63) (by decide) t
  have div8 : (2:Nat)^3 ∣ 3*X+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*X+1)%8=0
    simp only [X,target63,Affine.at]
    omega
  have price8 : 3*X+1<8*N := by
    simp only [X,N,target63,Affine.at,seed_affine,index,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨d,dpos,factor⟩ := P5R3S5.actual_step_factor X odd
  obtain ⟨_,exactFloor⟩ := P5R3S5.exact_reserve (step_odd X) factor
  have lower : 3≤d := by
    by_cases enough : 3≤d
    · exact enough
    · have smaller : d+1≤3 := by omega
      exact (exactFloor (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) div8)).elim
  have margin : 3*X+1<2^d*N :=
    Nat.lt_of_lt_of_le price8
      (Nat.mul_le_mul_right N (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) lower))
  obtain ⟨below,whole,paid⟩ :=
    Front4bPairExit.descent_of_numerator_bound hist pos odd dpos factor margin
  change ∃ a, 3≤a ∧ 3*orbit N 63+1=2^a*orbit N 64 ∧ ¬2^(a+1) ∣ 3*orbit N 63+1 ∧
      orbit N 64<N ∧ Segment N (orbit N 63) 63 99 7568280446574857051711818616875 ∧
      Segment N (orbit N 64) 64 (99+a) 23338666639838685855883807453313 ∧ Descended N
  rw [A2Header.physical_endpoint hist.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨d,lower,factor,exactFloor,below,hist,whole,paid⟩

end CollatzCharacterBridge.Front4bT64U1
