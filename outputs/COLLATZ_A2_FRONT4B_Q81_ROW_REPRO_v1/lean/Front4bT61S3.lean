import A2U392
import Front4bPairExit

namespace CollatzCharacterBridge.Front4bT61S3

open A2CertifiedLanding (Descended)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine affine_admissible)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

/-- Coordinate of the whole row q = 12 + 64s. -/
def index (s : Nat) : Nat := 26198573577+137438953472*s

/-- Physical endpoint of the whole row, before separating the exits. -/
def checkpoint60 : Affine :=
  ⟨16161180670369550395566597319,84782316550432407028588866402⟩

private def word : List Nat :=
  [1,2,1,1,2,2,1,1,1,1,1,2,1,2,1,1,2,1,2,1,2,1,1,6]

theorem index_formula (s : Nat) : index s=428769801+2^31*(12+64*s) := by
  change 26198573577+137438953472*s=428769801+2147483648*(12+64*s)
  omega

theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {values : List Nat}
    (checked : values.all (fun a => decide (1≤a))=true) : ValWord values :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

theorem history60 (s : Nat) :
    Segment (seed (index s)) (checkpoint60.at s) 60 94 253163701604367108480427299121 := by
  have start : landing (index s)=7864530692797891870013378395+41257699193962142184687796224*s := by
    simp only [landing,index,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (landing (index s)) (checkpoint60.at s) 24 37 634691213573 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment word (ρ := 7864530692797891870013378395)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (150094635296999121*s)
    simpa only [checkpoint60,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history36 _) tail

/-- The whole s = 3 mod 4 subfamily in q = 12 + 64s descends in the
    next physical return from T60. Its exact valuation is retained. -/
theorem descends_t61 (t : Nat) :
    let N := seed (428769801+2^31*(12+64*(3+4*t)))
    ∃ d, 3≤d ∧ 3*orbit N 60+1=2^d*orbit N 61 ∧ ¬2^(d+1) ∣ 3*orbit N 60+1 ∧
      orbit N 61<N ∧ Segment N (orbit N 60) 60 94 253163701604367108480427299121 ∧
      Segment N (orbit N 61) 61 (94+d) 779298145441667409839667884947 ∧ Descended N := by
  rw [←index_formula]
  let N := seed (index (3+4*t))
  let F := checkpoint60.at (3+4*t)
  have history := history60 (3+4*t)
  obtain ⟨positive,odd⟩ := affine_admissible (f := checkpoint60) (by decide) (3+4*t)
  have divisible : (2:Nat)^3 ∣ 3*F+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*F+1)%8=0
    simp only [F,checkpoint60,Affine.at]
    omega
  have margin : 3*F+1<2^3*N := by
    change 3*F+1<8*N
    simp only [F,N,checkpoint60,Affine.at,seed_affine,index,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨d,dpos,factor⟩ := P5R3S5.actual_step_factor F odd
  obtain ⟨_,exactFloor⟩ := P5R3S5.exact_reserve (step_odd F) factor
  have lower : 3≤d := by
    by_cases enough : 3≤d
    · exact enough
    · have smaller : d+1≤3 := by omega
      exact (exactFloor (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) divisible)).elim
  have margin_full : 3*F+1<2^d*N :=
    Nat.lt_of_lt_of_le margin
      (Nat.mul_le_mul_right N (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) lower))
  obtain ⟨below,whole,paid⟩ :=
    Front4bPairExit.descent_of_numerator_bound history positive odd dpos factor margin_full
  change ∃ a, 3≤a ∧ 3*orbit N 60+1=2^a*orbit N 61 ∧ ¬2^(a+1) ∣ 3*orbit N 60+1 ∧
      orbit N 61<N ∧ Segment N (orbit N 60) 60 94 253163701604367108480427299121 ∧
      Segment N (orbit N 61) 61 (94+a) 779298145441667409839667884947 ∧ Descended N
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨d,lower,factor,exactFloor,below,history,whole,paid⟩

end CollatzCharacterBridge.Front4bT61S3
