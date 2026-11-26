import A2U392

namespace CollatzCharacterBridge.Front4bEarlyMeeting

open A2CertifiedLanding (PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine affine_admissible affine_edge)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

private def index (s : Nat) : Nat := 428769801+2^31*(108+128*s)
private def target : Affine := ⟨71667327748009080469224948461,84782316550432407028588866402⟩
private def predecessor : Affine :=
  ⟨47778218498672720312816632307,56521544366954938019059244268⟩
private def word : List Nat := [1,2,1,1,2,2,1,1,1,1,1,2,1,2,1,1,2,1,2,1,2,1,1,7]

private theorem index_affine (s : Nat) : index s=232357003785+274877906944*s := by
  change 428769801+2147483648*(108+128*s)=_
  omega

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {values : List Nat}
    (checked : values.all (fun a => decide (1≤a))=true) : ValWord values :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem history60 (s : Nat) :
    Segment (seed (index s)) (target.at s) 60 95 253163701604367108480427299121 := by
  have start : landing (index s)=69751079483741105147045072731+82515398387924284369375592448*s := by
    simp only [landing,index_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (landing (index s)) (target.at s) 24 38 634691213573 := by
    rw [start]
    have raw := CRTWordSegment.crt_word_segment word (ρ := 69751079483741105147045072731)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (150094635296999121*s)
    simpa only [target,Affine.at,←Nat.mul_assoc] using raw
  exact compose (history36 _) tail

/-- An odd physical checkpoint congruent to two modulo three admits
the one-return source below the same original when the price is strict. -/
theorem paid_of_small_two_mod_three {N F j S C : Nat}
    (original : Segment N F j S C) (odd : F%2=1) (residue : F%3=2)
    (price : 2*F<3*N+1) : PaidMeeting N := by
  let w := (2*F-1)/3
  have factor : 3*w+1=2*F := by
    dsimp only [w]
    omega
  have fpos : 0<F := by omega
  have wpos : 0<w := by omega
  have wodd : w%2=1 := by omega
  have below : w<N := by omega
  have aux : Segment w F 1 1 1 := by
    refine ⟨A2Header.Physical.edge wpos wodd fpos odd (by decide) ?_,?_⟩
    · simpa only [Nat.pow_one] using factor
    · simpa only [Nat.pow_one] using factor.symm
  exact ⟨w,F,j,S,C,1,1,1,wpos,wodd,below,fpos,odd,original,aux⟩

/-- The whole row is paid before any suffix from the pivot is chosen.
    The original and the source retain their independent clocks. -/
theorem paid_t60 (s : Nat) :
    let N := seed (428769801+2^31*(108+128*s))
    let F := orbit N 60
    ∃ w, 0<w ∧ w%2=1 ∧ w<N ∧ N<F ∧ 3*w+1=2*F ∧
      Segment N F 60 95 253163701604367108480427299121 ∧
      Segment w F 1 1 1 ∧ PaidMeeting N ∧
      ∀ r, orbit w (1+r)=orbit N (60+r) := by
  let N := seed (index s)
  let F := target.at s
  let w := predecessor.at s
  have original := history60 s
  have aux : Segment w F 1 1 1 := affine_edge (by decide) s
  obtain ⟨wp,wo⟩ := affine_admissible (f := predecessor) (by decide) s
  obtain ⟨fp,fo⟩ := affine_admissible (f := target) (by decide) s
  have price : w<N := by
    simp only [w,N,predecessor,Affine.at,seed_affine,index_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have above : N<F := by
    simp only [F,N,target,Affine.at,seed_affine,index_affine,Nat.mul_add,←Nat.mul_assoc]
    omega
  have factor : 3*w+1=2*F := aux.book.symm
  have reached : orbit N 60=F := A2Header.physical_endpoint original.physical
  have companion : orbit w 1=F := A2Header.physical_endpoint aux.physical
  have suffix (r : Nat) : orbit w (1+r)=orbit N (60+r) := by
    rw [orbit_add w 1 r,orbit_add N 60 r,companion,reached]
  have paid : PaidMeeting N :=
    ⟨w,F,60,95,253163701604367108480427299121,1,1,1,wp,wo,price,fp,fo,original,aux⟩
  change ∃ w, 0<w ∧ w%2=1 ∧ w<N ∧ N<orbit N 60 ∧ 3*w+1=2*orbit N 60 ∧
    Segment N (orbit N 60) 60 95 253163701604367108480427299121 ∧
    Segment w (orbit N 60) 1 1 1 ∧ PaidMeeting N ∧ ∀ r, orbit w (1+r)=orbit N (60+r)
  rw [reached]
  exact ⟨w,wp,wo,price,above,factor,original,aux,paid,suffix⟩

end CollatzCharacterBridge.Front4bEarlyMeeting
