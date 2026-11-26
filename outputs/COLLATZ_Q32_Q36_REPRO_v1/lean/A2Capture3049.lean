import A2U392

namespace CollatzCharacterBridge.A2Capture3049

open A2CertifiedLanding (PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine affine_admissible)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def pivot : Affine := ⟨1029816171532651912447,5533088635588575596544⟩
private def auxiliary : Affine := ⟨514908085766325956223,2766544317794287798272⟩
private def terminal : Affine := ⟨6598265528736063669503,35451752478610004383716⟩

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

/-- The two certified initial returns retain the old book to T38. -/
private theorem history38 (q : Nat) :
    Segment (seed (3049+16384*q)) (pivot.at q) 38 60 5873208133328790745 := by
  have start : landing (3049+16384*q)=915392152473468366619+4918301009412067196928*q := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (landing (3049+16384*q)) (pivot.at q) 2 3 5 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment [1,2] (ρ := 915392152473468366619)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (307393813088254199808*q)
    simpa only [pivot,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history36 _) tail

private theorem original_tail (q : Nat) :
    Segment (pivot.at q) (terminal.at q) 8 10 6305 := by
  have raw := CRTWordSegment.crt_word_segment [1,1,1,1,1,1,1,3]
    (ρ := 1029816171532651912447) (by decide) (by decide)
    (valid_of_list (by decide)) (by decide) (2701703435345984178*q)
  simpa only [pivot,terminal,Affine.at,←Nat.mul_assoc] using raw

private theorem source_tail (q : Nat) :
    Segment (auxiliary.at q) (terminal.at q) 8 9 6433 := by
  have raw := CRTWordSegment.crt_word_segment [1,1,1,1,1,1,2,1]
    (ρ := 514908085766325956223) (by decide) (by decide)
    (valid_of_list (by decide)) (by decide) (2701703435345984178*q)
  simpa only [auxiliary,terminal,Affine.at,←Nat.mul_assoc] using raw

/-- All seeds in k = 3049 mod 16384 admit the same physical half-source
    construction from T38, with separate histories up to the encounter. -/
theorem paid_3049 (q : Nat) :
    let N := seed (3049+16384*q)
    ∃ w, w=(orbit N 38-1)/2 ∧ 0<w ∧ w%2=1 ∧ w<N ∧ N<orbit N 46 ∧
      Segment N (orbit N 46) 46 70 45803288649316366261625 ∧
      Segment w (orbit N 46) 8 9 6433 ∧ PaidMeeting N := by
  let N := seed (3049+16384*q)
  let w := auxiliary.at q
  have original : Segment N (terminal.at q) 46 70 45803288649316366261625 :=
    compose (history38 q) (original_tail q)
  have source := source_tail q
  have w_eq : w=(pivot.at q-1)/2 := by
    simp only [w,pivot,auxiliary,Affine.at]
    omega
  obtain ⟨w_pos,w_odd⟩ := affine_admissible (f := auxiliary) (by decide) q
  obtain ⟨end_pos,end_odd⟩ := affine_admissible (f := terminal) (by decide) q
  have priced : w<N := by
    simp only [w,N,auxiliary,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have above : N<terminal.at q := by
    simp only [N,terminal,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have paid : PaidMeeting N :=
    ⟨w,terminal.at q,46,70,45803288649316366261625,8,9,6433,
      w_pos,w_odd,priced,end_pos,end_odd,original,source⟩
  dsimp only
  rw [A2Header.physical_endpoint (history38 q).physical,A2Header.physical_endpoint original.physical]
  exact ⟨w,w_eq,w_pos,w_odd,priced,above,original,source,paid⟩

end CollatzCharacterBridge.A2Capture3049
