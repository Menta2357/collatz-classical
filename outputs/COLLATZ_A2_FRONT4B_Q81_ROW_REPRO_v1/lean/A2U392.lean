import P5J131Residual
import A2FirstCrossingChronology

namespace CollatzCharacterBridge.A2U392

open A2FirstCrossingFusion (Admitted FirstCrossing HitsBelow Paid)
open A2FirstCrossingChronology (LaterResidual)
open A2SecondSwitchWordCompiler (ValWord cost total)
open FixedSourceRun (Ones)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 800000

def seed (k : Nat) : Nat := P5J131Residual.seed (392+1024*k)
def pivot (k : Nat) : Nat := 143670814503340591+374813367582081024*k
def landing (k : Nat) : Nat := 115066432367726761+300189270593998242*k

private theorem seed_eq (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,P5CompensationMeetings.Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem origin (k : Nat) : Segment (seed k) (pivot k) 28 44 64305438710449 := by
  have h := P5J131Residual.history28 (392+1024*k)
  have pivot_eq : P5J131Residual.pivot (392+1024*k)=pivot k := by
    simp only [P5J131Residual.pivot,pivot,Nat.mul_add,←Nat.mul_assoc]
    omega
  simpa only [seed,pivot_eq] using h

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem tail (k : Nat) : Segment (pivot k) (landing k) 8 13 8561 := by
  have h := CRTWordSegment.crt_word_segment [1,1,1,2,2,1,1,4]
    (ρ := 143670814503340591) (by decide) (by decide)
    (valid_of_list (by decide)) (by decide) (22876792454961*k)
  simpa only [pivot,landing,←Nat.mul_assoc] using h

theorem history36 (k : Nat) : Segment (seed k) (landing k) 36 57 572514688105501265 :=
  compose (origin k) (tail k)

theorem ordering (k : Nat) :
    1<seed k ∧ seed k<landing k ∧ landing k<pivot k ∧ pivot k<2*seed k+1 ∧
      pivot k%2=1 ∧ landing k%2=1 := by
  simp only [seed_eq,landing,pivot]
  omega

private theorem prefix_above (k : Nat) (word : List Nat) (lift : Nat)
    (valid : ValWord word)
    (crt : (3^word.length*143670814503340591+cost word)%2^(total word+1)=2^total word)
    (lift_eq : 2^(total word+1)*lift=374813367582081024)
    (initial_ge : 143670814503340591≤CRTWordSegment.initial_terminal word 143670814503340591)
    (slope_ge : 374813367582081024≤2*3^word.length*lift) :
    pivot k≤orbit (pivot k) word.length := by
  have h := CRTWordSegment.crt_word_segment word (ρ := 143670814503340591)
    (by decide) (by decide) valid crt (lift*k)
  have p : Segment (pivot k)
      (CRTWordSegment.initial_terminal word 143670814503340591+(2*3^word.length*lift)*k)
      word.length (total word) (cost word) := by
    simpa only [pivot,←Nat.mul_assoc,lift_eq] using h
  rw [A2Header.physical_endpoint p.physical]
  exact Nat.add_le_add initial_ge (Nat.mul_le_mul_right k slope_ge)

theorem crossing_exact (k : Nat) :
    orbit (pivot k) 8=landing k ∧ landing k<pivot k ∧
      ∀ i, i<8 → pivot k≤orbit (pivot k) i := by
  refine ⟨A2Header.physical_endpoint (tail k).physical,(ordering k).2.2.1,?_⟩
  intro i hi
  have cases : i=0∨i=1∨i=2∨i=3∨i=4∨i=5∨i=6∨i=7 := by omega
  rcases cases with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl
  · exact Nat.le_refl _
  · exact prefix_above k [1] 93703341895520256
      (valid_of_list (by decide)) (by decide) (by decide) (by decide) (by decide)
  · exact prefix_above k [1,1] 46851670947760128
      (valid_of_list (by decide)) (by decide) (by decide) (by decide) (by decide)
  · exact prefix_above k [1,1,1] 23425835473880064
      (valid_of_list (by decide)) (by decide) (by decide) (by decide) (by decide)
  · exact prefix_above k [1,1,1,2] 5856458868470016
      (valid_of_list (by decide)) (by decide) (by decide) (by decide) (by decide)
  · exact prefix_above k [1,1,1,2,2] 1464114717117504
      (valid_of_list (by decide)) (by decide) (by decide) (by decide) (by decide)
  · exact prefix_above k [1,1,1,2,2,1] 732057358558752
      (valid_of_list (by decide)) (by decide) (by decide) (by decide) (by decide)
  · exact prefix_above k [1,1,1,2,2,1,1] 366028679279376
      (valid_of_list (by decide)) (by decide) (by decide) (by decide) (by decide)

theorem first_crossing (k : Nat) :
    FirstCrossing (seed k) (pivot k) (landing k) 28 44 64305438710449 8 13 8561 := by
  obtain ⟨big,_,_,height,odd,_⟩ := ordering k
  obtain ⟨at8,below,_⟩ := crossing_exact k
  have hit : HitsBelow (pivot k) (pivot k) 8 := ⟨8,by decide,by rw [at8]; exact below⟩
  exact A2FirstCrossingFusion.reduce_first_crossing big odd height (origin k) (tail k) hit

theorem chronological (k : Nat) :
    Paid (seed k) ∨ LaterResidual (seed k) (pivot k) 28 44 64305438710449 8 := by
  obtain ⟨big,_,_,height,odd,_⟩ := ordering k
  exact A2FirstCrossingChronology.chronological_landing big odd height (first_crossing k)

theorem even_descends37 (k : Nat) (even : k%2=0) :
    ∃ b, 2≤b ∧ 3*landing k+1=2^b*orbit (seed k) 37 ∧
      orbit (seed k) 37<seed k ∧
      Segment (seed k) (orbit (seed k) 37) 37 (57+b) 1861659252392359667 ∧
      A2CertifiedLanding.Descended (seed k) := by
  have positive : 0<landing k := by simp only [landing]; omega
  have odd := (ordering k).2.2.2.2.2
  obtain ⟨b,b_pos,factor⟩ := P5R3S5.actual_step_factor (landing k) odd
  have mod4 : landing k%4=1 := by simp only [landing]; omega
  have bound : 2≤b := by
    by_cases one : b=1
    · rw [one,Nat.pow_one] at factor
      have hp := step_odd (landing k)
      omega
    · omega
  have price : 3*landing k+1<4*seed k := by simp only [landing,seed_eq]; omega
  have scale := Nat.mul_le_mul_right (step (landing k))
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) bound)
  rw [←factor] at scale
  have below : step (landing k)<seed k := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scale price)
  have whole : Segment (seed k) (step (landing k)) 37 (57+b) 1861659252392359667 :=
    compose (history36 k) (P5R3S5.step_segment (landing k) b positive odd b_pos factor)
  have descended : A2CertifiedLanding.Descended (seed k) :=
    ⟨_,37,57+b,1861659252392359667,step_pos _,step_odd _,below,whole⟩
  rw [A2Header.physical_endpoint whole.physical]
  exact ⟨b,bound,factor,below,whole,descended⟩

theorem strong_capture (k r b : Nat) (run : Ones (landing k) (r+1)) (strength : 3≤b)
    (factor : 3*orbit (landing k) (r+1)+1=2^b*orbit (landing k) (r+2)) :
    let w := A2HalfAdaptive.half (landing k)
    let z := orbit (landing k) (r+2)
    0<w ∧ w%2=1 ∧ w<seed k ∧
      Segment (seed k) z (36+(r+2)) (57+(r+1+b))
        (3^(r+2)*572514688105501265+2^57*(3^(r+2)-2^(r+2))) ∧
      Segment w z (r+2) (r+b) (3^(r+2)-2^(r+1)) ∧
      A2CertifiedLanding.PaidMeeting (seed k) := by
  have positive : 0<landing k := by simp only [landing]; omega
  obtain ⟨_,_,smaller,height,_,odd⟩ := ordering k
  have fits : landing k<2*seed k+1 := by omega
  obtain ⟨hp,ho,hw,whole,source⟩ :=
    A2HalfAdaptive.history_capture (history36 k) positive odd fits run strength factor
  obtain ⟨a,c⟩ := A2HalfAdaptive.cost_formulas r
  rw [a,Nat.mul_comm (3^(r+2)-2^(r+2)) (2^57)] at whole
  rw [c] at source
  exact ⟨hp,ho,hw,whole,source,
    _,_,_,_,_,_,_,_,hp,ho,hw,orbit_pos _ positive _,orbit_odd _ odd _,whole,source⟩

theorem two_readmits (k r : Nat) (positive : 1≤r) (run : Ones (landing k) r)
    (factor : 3*orbit (landing k) r+1=4*orbit (landing k) (r+1)) :
    Admitted (seed k) (landing k) 36 57 572514688105501265 ∧
      landing k-seed k<pivot k-seed k ∧
      LaterResidual (seed k) (pivot k) 28 44 64305438710449 8 := by
  obtain ⟨_,above,smaller,height,_,odd⟩ := ordering k
  have allowed : Admitted (seed k) (landing k) 36 57 572514688105501265 :=
    ⟨by omega,odd,by omega,history36 k,r,positive,run,factor⟩
  have rank : landing k-seed k<pivot k-seed k := Nat.sub_lt_sub_right (by omega) smaller
  obtain ⟨at8,_,above_prefix⟩ := crossing_exact k
  refine ⟨allowed,rank,8,13,8561,landing k,36,57,572514688105501265,0,0,0,
    by decide,by decide,?_,above_prefix,?_,?_,by decide,by decide,by decide,by decide,rank,allowed⟩
  · rwa [at8]
  · rw [at8]; exact tail k
  · rw [at8]; exact ⟨A2Header.Physical.refl (landing k),by simp⟩

end CollatzCharacterBridge.A2U392
