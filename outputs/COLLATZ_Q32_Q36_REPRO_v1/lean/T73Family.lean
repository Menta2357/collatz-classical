import A2U392

namespace CollatzCharacterBridge.T73Family

open A2CertifiedLanding (PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def predecessor : Affine := ⟨50805987214706401211473622659359,
  40050488079891865621049151777373584⟩
private def shortSource : Affine := ⟨76208980822059601817210433989039,
  60075732119837798431573727666060376⟩
private def terminal : Affine := ⟨171470206849634104088723476475339,
  135170397269635046471040887248635846⟩

private def word : List Nat :=
  [1,2,1,1,2,2,1,1,1,1,1,2,1,2,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,7]

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {values : List Nat}
    (checked : values.all (fun a => decide (1≤a))=true) : ValWord values :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem history73 (t : Nat) :
    Segment (seed (365634215903753+288230376151711744*t)) (terminal.at t)
      73 115 411443494169899340644307646523772515 := by
  have start : landing (365634215903753+288230376151711744*t)=
      109759468576356199858620090928987+86523666380016094406902381226754048*t := by
    simp only [landing,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (landing (365634215903753+288230376151711744*t)) (terminal.at t)
      37 58 1066156498015419935 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment word (ρ := 109759468576356199858620090928987)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (150094635296999121*t)
    simpa only [terminal,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history36 _) tail

private theorem two_ones (t : Nat) : Segment (shortSource.at t) (terminal.at t) 2 2 5 := by
  have raw := CRTWordSegment.crt_word_segment [1,1] (ρ := 76208980822059601817210433989039)
    (by decide) (by decide) (valid_of_list (by decide)) (by decide)
    (7509466514979724803946715958257547*t)
  simpa only [shortSource,terminal,Affine.at,←Nat.mul_assoc] using raw

/-- The shorter paid source is itself the first physical return of
    the three-one source. Its clock begins only at that state. -/
theorem paid_t73 (t : Nat) :
    let N := seed (365634215903753+288230376151711744*t)
    ∃ w z, 0<w ∧ w%2=1 ∧ w<N ∧ z=step w ∧ 0<z ∧ z%2=1 ∧ z<N ∧
      2*N≤3*z ∧ N<orbit N 73 ∧
      Segment N (orbit N 73) 73 115 411443494169899340644307646523772515 ∧
      Segment w z 1 1 1 ∧ Segment w (orbit N 73) 3 3 19 ∧
      Segment z (orbit N 73) 2 2 5 ∧ PaidMeeting N := by
  let N := seed (365634215903753+288230376151711744*t)
  let w := predecessor.at t
  let z := shortSource.at t
  have original := history73 t
  have aux := two_ones t
  have first : Segment w z 1 1 1 := affine_edge (by decide) t
  have entire_aux : Segment w (terminal.at t) 3 3 19 := compose first aux
  have source_step : z=step w := (A2Header.physical_endpoint first.physical).symm
  obtain ⟨w_pos,w_odd⟩ := affine_admissible (f := predecessor) (by decide) t
  obtain ⟨z_pos,z_odd⟩ := affine_admissible (f := shortSource) (by decide) t
  obtain ⟨end_pos,end_odd⟩ := affine_admissible (f := terminal) (by decide) t
  have priced : z<N := by
    simp only [N,z,shortSource,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have earlier_price : w<N := by
    have h : 2*z=3*w+1 := first.book
    omega
  have bound : 2*N≤3*z := by
    simp only [N,z,shortSource,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have above : N<terminal.at t := by
    simp only [N,terminal,Affine.at,seed_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have meeting : PaidMeeting N :=
    ⟨z,terminal.at t,73,115,411443494169899340644307646523772515,2,2,5,
      z_pos,z_odd,priced,end_pos,end_odd,original,aux⟩
  dsimp only
  rw [A2Header.physical_endpoint original.physical]
  exact ⟨w,z,w_pos,w_odd,earlier_price,source_step,z_pos,z_odd,priced,bound,above,
    original,first,entire_aux,aux,meeting⟩

end CollatzCharacterBridge.T73Family
