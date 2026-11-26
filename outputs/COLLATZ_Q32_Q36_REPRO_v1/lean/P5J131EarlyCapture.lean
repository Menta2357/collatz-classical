import P5J131Chronology
import P5RZeroJ131

namespace CollatzCharacterBridge.P5J131EarlyCapture

open A2CertifiedLanding (PaidMeeting)
open A2FirstCrossingFusion (Paid)
open A2SecondSwitchWordCompiler (ValWord)
open P5CompensationMeetings (Affine affine_admissible)
open P5RZeroA2 (entry entry_book original)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 800000

/-- An odd reachable terminal in residue 2 mod 3 has a real valuation-one
    predecessor. Its price is measured against the seed of the original book. -/
theorem paid_one_return {N K j S C : Nat} (history : Segment N K j S C)
    (odd : K%2=1) (phase : K%3=2) (price : 2*K<3*N+1) :
    let w := (2*K-1)/3
    0<w ∧ w%2=1 ∧ w<N ∧ Segment w K 1 1 1 ∧ PaidMeeting N := by
  let w := (2*K-1)/3
  have factor : 3*w+1=2*K := by dsimp only [w]; omega
  have positiveK : 0<K := by omega
  have positiveW : 0<w := by omega
  have oddW : w%2=1 := by omega
  have below : w<N := by omega
  have source : Segment w K 1 1 1 :=
    ⟨A2Header.Physical.edge positiveW oddW positiveK odd (by decide) factor,
      factor.symm⟩
  exact ⟨positiveW,oddW,below,source,w,K,j,S,C,1,1,1,
    positiveW,oddW,below,positiveK,odd,history,source⟩

private def captureSeed : Affine := ⟨4647842116783231,9007199254740992⟩
private def terminal : Affine := ⟨5737107640288037,11118121133111046⟩
private def word : List Nat := [1,2,2,1,1,1,2,3]

private theorem seed_at (q : Nat) :
    captureSeed.at q=original.at (131+256*(16+32*q)) := by
  simp only [captureSeed,original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_word : ValWord word := by
  have check : word.all (fun a => decide (1≤a))=true := by decide
  intro a ha
  exact of_decide_eq_true ((List.all_eq_true.mp check) a ha)

private theorem history33 (q : Nat) :
    Segment (captureSeed.at q) (terminal.at q) 33 52 19619647838721539 := by
  have entry_eq : entry.at (131+256*(16+32*q))=
      7163296111757291+13881976577114112*q := by
    simp only [entry,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have local_history : Segment (entry.at (131+256*(16+32*q)))
      (terminal.at q) 8 13 12853 := by
    rw [entry_eq]
    have h := CRTWordSegment.crt_word_segment word (ρ := 7163296111757291)
      (by decide) (by decide) valid_word (by decide) (847288609443*q)
    simpa only [terminal,Affine.at,←Nat.mul_assoc] using h
  rw [seed_at]
  exact compose (entry_book (131+256*(16+32*q))) local_history

private theorem terminal_phase (q : Nat) : terminal.at q%3=2 := by
  rw [Affine.at,Nat.add_mod,Nat.mul_mod terminal.slope q 3,
    show terminal.offset%3=2 by decide,
    show terminal.slope%3=0 by decide]
  simp

/-- The original 33-return history and the independent one-return source
    meet for the complete guard 16+32q, with no assumption on later exits. -/
theorem capture33 (q : Nat) :
    let N := original.at (131+256*(16+32*q))
    let K := orbit N 33
    let w := (2*K-1)/3
    N<K ∧ 0<w ∧ w%2=1 ∧ w<N ∧ Segment N K 33 52 19619647838721539 ∧
      Segment w K 1 1 1 ∧ PaidMeeting N := by
  have history := history33 q
  have valid := affine_admissible (f := terminal) (by decide) q
  have larger : captureSeed.at q<terminal.at q :=
    Nat.add_lt_add_of_lt_of_le (by decide) (Nat.mul_le_mul_right q (by decide))
  have price : 2*terminal.at q<3*captureSeed.at q+1 := calc
    _ = (2*terminal.offset)+(2*terminal.slope)*q := by
      simp only [Affine.at,Nat.mul_add,←Nat.mul_assoc]
    _ < (3*captureSeed.offset+1)+(3*captureSeed.slope)*q :=
      Nat.add_lt_add_of_lt_of_le (by decide) (Nat.mul_le_mul_right q (by decide))
    _ = _ := by simp only [Affine.at,Nat.mul_add,←Nat.mul_assoc]; ac_rfl
  obtain ⟨positive,odd,below,source,paid⟩ :=
    paid_one_return history valid.2 (terminal_phase q) price
  rw [seed_at q] at larger history below paid
  dsimp only
  rw [A2Header.physical_endpoint history.physical]
  exact ⟨larger,positive,odd,below,history,source,paid⟩

/-- The complete congruence class j=131 mod 4096 is paid at T33.
    The two subcases retain their corresponding physical evidence. -/
theorem pays33 (h : Nat) : Paid (original.at (131+4096*h)) := by
  let q := h/2
  by_cases even : h%2=0
  · have coordinate : 131+4096*h=131+256*(32*q) := by dsimp only [q]; omega
    rw [coordinate]
    let N := original.at (131+256*(32*q))
    obtain ⟨a,_,_,below,history⟩ := P5RZeroJ131.direct32 q
    have valid := affine_admissible (f := original) (by decide) (131+256*(32*q))
    exact Or.inl ⟨orbit N 33,33,49+a,19619647838721539,
      orbit_pos N valid.1 33,orbit_odd N valid.2 33,below,history⟩
  · have coordinate : 131+4096*h=131+256*(16+32*q) := by dsimp only [q]; omega
    rw [coordinate]
    obtain ⟨_,_,_,_,_,_,paid⟩ := capture33 q
    exact Or.inr paid

/-- The entire Q29 family lies in the T33 capture class. -/
theorem q29_capture33 (t : Nat) :
    let N := P5J131Chronology.seed.at t
    let K := orbit N 33
    let w := (2*K-1)/3
    N<K ∧ 0<w ∧ w%2=1 ∧ w<N ∧ Segment N K 33 52 19619647838721539 ∧
      Segment w K 1 1 1 ∧ PaidMeeting N := by
  let q := 501072404818209+2251799813685248*t
  have same : captureSeed.at q=P5J131Chronology.seed.at t := by
    simp only [q,captureSeed,P5J131Chronology.seed,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    rw [←Nat.add_assoc]
  have h := capture33 q
  rw [←seed_at q,same] at h
  exact h

theorem arrives_under_induction (h : Nat)
    (smaller : ∀ w, 0<w → w%2=1 → w<original.at (131+4096*h) → ∃ i, orbit w i=1) :
    ∃ i, orbit (original.at (131+4096*h)) i=1 :=
  A2FirstCrossingChronology.arrival_of_paid (pays33 h) smaller

end CollatzCharacterBridge.P5J131EarlyCapture
