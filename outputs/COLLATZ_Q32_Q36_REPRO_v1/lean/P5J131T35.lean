import P5J131Residual

namespace CollatzCharacterBridge.P5J131T35

open A2CertifiedLanding (Descended)
open A2SecondSwitchWordCompiler (ValWord)
open P5CompensationMeetings (Affine affine_admissible)
open P5J131Residual (seed)
open P5RZeroA2 (entry entry_book original)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 800000

private theorem seed_eq (u : Nat) : seed u=original.at (131+256*u) := rfl

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private def tip92 : Affine := ⟨48213967997140157,133417453597332552⟩
private def tip120 : Affine := ⟨62806501984348405,133417453597332552⟩

private theorem history92 (q : Nat) :
    Segment (seed (92+256*q)) (tip92.at q) 34 53 59984843423007241 := by
  have entry_eq : entry.at (131+256*(92+256*q))=40132990482403307+111055812616912896*q := by
    simp only [entry,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (entry.at (131+256*(92+256*q))) (tip92.at q) 9 14 40607 := by
    rw [entry_eq]
    have h := CRTWordSegment.crt_word_segment [1,2,2,1,1,1,2,1,3]
      (ρ := 40132990482403307) (by decide) (by decide) (valid_of_list (by decide))
      (by decide) (3389154437772*q)
    simpa only [tip92,Affine.at,←Nat.mul_assoc] using h
  exact compose (entry_book (131+256*(92+256*q))) tail

private theorem history120 (q : Nat) :
    Segment (seed (120+256*q)) (tip120.at q) 34 53 61110743329849865 := by
  have entry_eq : entry.at (131+256*(120+256*q))=52279719987378155+111055812616912896*q := by
    simp only [entry,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (entry.at (131+256*(120+256*q))) (tip120.at q) 9 14 42655 := by
    rw [entry_eq]
    have h := CRTWordSegment.crt_word_segment [1,2,2,1,1,1,2,2,2]
      (ρ := 52279719987378155) (by decide) (by decide) (valid_of_list (by decide))
      (by decide) (3389154437772*q)
    simpa only [tip120,Affine.at,←Nat.mul_assoc] using h
  exact compose (entry_book (131+256*(120+256*q))) tail

private theorem descend35 {N X B : Nat} (history : Segment N X 34 53 B)
    (positive : 0<X) (odd : X%2=1) (divides : 8 ∣ 3*X+1)
    (price : 3*X+1<8*N) :
    ∃ c, 3≤c ∧ 3*orbit N 34+1=2^c*orbit N 35 ∧ orbit N 35<N ∧
      Segment N (orbit N 35) 35 (53+c) (3*B+2^53) ∧ Descended N := by
  obtain ⟨c,cp,factor⟩ := P5R3S5.actual_step_factor X odd
  have bound : 3≤c := by
    by_cases h : 3≤c
    · exact h
    · have small : c+1≤3 := by omega
      exact ((P5R3S5.exact_reserve (step_odd X) factor).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 small) divides)).elim
  have power := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) bound
  have scaled := Nat.mul_le_mul_right (step X) power
  rw [←factor] at scaled
  have below : step X<N := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scaled price)
  have whole : Segment N (step X) 35 (53+c) (3*B+2^53) := by
    simpa only [Nat.pow_one,Nat.mul_one] using
      compose history (P5R3S5.step_segment X c positive odd cp factor)
  rw [A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨c,bound,factor,below,whole,_,_,_,_,step_pos _,step_odd _,below,whole⟩

/-- T35 is below the original N for every u=92 mod 256.
    The last valuation is the physical one and may exceed three. -/
theorem descends_mod_256_ninety_two (q : Nat) :
    let N := seed (92+256*q)
    ∃ c, 3≤c ∧ 3*orbit N 34+1=2^c*orbit N 35 ∧ orbit N 35<N ∧
      Segment N (orbit N 35) 35 (53+c) 188961729523762715 ∧ Descended N := by
  obtain ⟨positive,odd⟩ := affine_admissible (f := tip92) (by decide) q
  apply descend35 (history92 q) positive odd
  · apply Nat.dvd_of_mod_eq_zero
    change (3*(48213967997140157+133417453597332552*q)+1)%8=0
    omega
  · simp only [tip92,seed_eq,original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega

/-- T35 is below the original N for every u=120 mod 256,
    with the complete physical exponent and additive cost. -/
theorem descends_mod_256_one_twenty (q : Nat) :
    let N := seed (120+256*q)
    ∃ c, 3≤c ∧ 3*orbit N 34+1=2^c*orbit N 35 ∧ orbit N 35<N ∧
      Segment N (orbit N 35) 35 (53+c) 192339429244290587 ∧ Descended N := by
  obtain ⟨positive,odd⟩ := affine_admissible (f := tip120) (by decide) q
  apply descend35 (history120 q) positive odd
  · apply Nat.dvd_of_mod_eq_zero
    change (3*(62806501984348405+133417453597332552*q)+1)%8=0
    omega
  · simp only [tip120,seed_eq,original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega

end CollatzCharacterBridge.P5J131T35
