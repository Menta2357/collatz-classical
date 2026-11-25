import A2U392

namespace CollatzCharacterBridge.A2T43Inverse

open A2CertifiedLanding (PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord cost total)
open A2U392 (seed landing history36)
open P5CompensationMeetings (Affine EdgeCoefficients affine_admissible affine_edge)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 400000

private theorem seed_affine (k : Nat) :
    seed k=110482433359989887+288230376151711744*k := by
  change P5RZeroA2.original.at (131+256*(392+1024*k))=_
  simp only [P5RZeroA2.original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem seed_lift (k q : Nat) :
    seed (k+2048*q)=seed k+590295810358705651712*q := by
  simp only [seed_affine,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem landing_lift (k q : Nat) :
    landing (k+2048*q)=landing k+614787626176508399616*q := by
  simp only [landing,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

/-- Both words are reconstructed by the same CRT lemma on their respective
    affine input, with a separate starting clock and additive. -/
private theorem affine_word (q : Nat) (start finish : Affine) (word : List Nat) (lift : Nat)
    (admissible : start.admissible) (valid : ValWord word)
    (crt : (3^word.length*start.offset+cost word)%2^(total word+1)=2^total word)
    (start_stride : 2^(total word+1)*lift=start.slope)
    (end_offset : CRTWordSegment.initial_terminal word start.offset=finish.offset)
    (end_stride : 2*3^word.length*lift=finish.slope) :
    Segment (start.at q) (finish.at q) word.length (total word) (cost word) := by
  have raw := CRTWordSegment.crt_word_segment word admissible.1 admissible.2.1
    valid crt (lift*q)
  simpa only [Affine.at,←Nat.mul_assoc,start_stride,end_offset,end_stride] using raw

private def start36 (k : Nat) : Affine := ⟨landing k,614787626176508399616⟩

private theorem history42 (k q : Nat) (y : Affine)
    (crt : (729*landing k+925)%256=128)
    (end_offset : CRTWordSegment.initial_terminal [1,2,1,1,1,1] (landing k)=y.offset)
    (end_stride : y.slope=3501407652208395494688) :
    Segment (seed (k+2048*q)) (y.at q) 42 64 550669756599077103785 := by
  have admissible : (start36 k).admissible := by
    have order := A2U392.ordering k
    have pos : 0<landing k := by omega
    exact ⟨pos,order.2.2.2.2.2,by change (614787626176508399616 : Nat)%2=0; decide⟩
  have tail : Segment ((start36 k).at q) (y.at q) 6 7 925 :=
    affine_word q (start36 k) y [1,2,1,1,1,1] 2401514164751985936 admissible
      (valid_of_list (by decide)) crt
      (by change 2^8*2401514164751985936=614787626176508399616; decide)
      end_offset end_stride.symm
  have at36 : (start36 k).at q=landing (k+2048*q) := (landing_lift k q).symm
  rw [at36] at tail
  exact compose (history36 _) tail

private theorem meeting (k q a : Nat) (y x w : Affine)
    (history : Segment (seed (k+2048*q)) (y.at q) 42 64 550669756599077103785)
    (last : EdgeCoefficients y x a)
    (source : Segment (w.at q) (x.at q) 4 (a+2) 73)
    (w_admissible : w.admissible)
    (checks : 32*w.offset=27*landing k+7 ∧ 32*w.slope=27*614787626176508399616 ∧
      w.offset<seed k ∧ w.slope≤590295810358705651712 ∧
      seed k<x.offset ∧ 590295810358705651712≤x.slope) :
    let N := seed (k+2048*q)
    ∃ v, v=(27*orbit N 36+7)/32 ∧ 0<v ∧ v%2=1 ∧ v<N ∧
      3*orbit N 42+1=2^a*orbit N 43 ∧ N<orbit N 43 ∧
      Segment N (orbit N 43) 43 (64+a) 1670456013870940862971 ∧
      Segment v (orbit N 43) 4 (a+2) 73 ∧ PaidMeeting N := by
  obtain ⟨value,stride,base_lt,stride_le,end_base_lt,end_stride_le⟩ := checks
  have w_coord : 32*w.at q=27*landing (k+2048*q)+7 := by
    rw [landing_lift]
    simp only [Affine.at,Nat.mul_add,←Nat.mul_assoc,value,stride]
    omega
  have w_formula : w.at q=(27*landing (k+2048*q)+7)/32 := by omega
  obtain ⟨w_positive,w_odd⟩ := affine_admissible w_admissible q
  have w_paid : w.at q<seed (k+2048*q) := by
    rw [seed_lift]
    exact Nat.add_lt_add_of_lt_of_le base_lt (Nat.mul_le_mul_right q stride_le)
  have terminal_above : seed (k+2048*q)<x.at q := by
    rw [seed_lift]
    exact Nat.add_lt_add_of_lt_of_le end_base_lt (Nat.mul_le_mul_right q end_stride_le)
  have final := affine_edge last q
  have factor : 3*y.at q+1=2^a*x.at q := by
    simpa only [Nat.pow_one] using final.book.symm
  have whole : Segment (seed (k+2048*q)) (x.at q) 43 (64+a) 1670456013870940862971 :=
    compose history final
  obtain ⟨x_positive,x_odd⟩ := affine_admissible last.2.1 q
  have paid : PaidMeeting (seed (k+2048*q)) :=
    ⟨w.at q,x.at q,43,64+a,1670456013870940862971,4,a+2,73,
      w_positive,w_odd,w_paid,x_positive,x_odd,whole,source⟩
  dsimp only
  rw [A2Header.physical_endpoint (history36 (k+2048*q)).physical,
    A2Header.physical_endpoint history.physical,A2Header.physical_endpoint whole.physical]
  exact ⟨w.at q,w_formula,w_positive,w_odd,w_paid,factor,terminal_above,whole,source,paid⟩

theorem captures_873_mod_2048 (q : Nat) :
    let N := seed (873+2048*q)
    ∃ w, w=(27*orbit N 36+7)/32 ∧ 0<w ∧ w%2=1 ∧ w<N ∧
      3*orbit N 42+1=2^3*orbit N 43 ∧ N<orbit N 43 ∧
      Segment N (orbit N 43) 43 67 1670456013870940862971 ∧
      Segment w (orbit N 43) 4 5 73 ∧ PaidMeeting N := by
  let y : Affine := ⟨1493198737912630093661,3501407652208395494688⟩
  let x : Affine := ⟨559949526717236285123,1313027869578148310508⟩
  let w : Affine := ⟨221214627838908162023,518727059586428962176⟩
  have original := history42 873 q y (by decide) (by decide) (by decide)
  have auxiliary : Segment (w.at q) (x.at q) 4 5 73 :=
    affine_word q w x [1,1,2,1] 8105110306037952534 (by decide) (valid_of_list (by decide))
      (by decide) (by decide) (by decide) (by decide)
  exact meeting 873 q 3 y x w original (by decide) auxiliary (by decide) (by decide)

theorem captures_1385_mod_2048 (q : Nat) :
    let N := seed (1385+2048*q)
    ∃ w, w=(27*orbit N 36+7)/32 ∧ 0<w ∧ w%2=1 ∧ w<N ∧
      3*orbit N 42+1=2^4*orbit N 43 ∧ N<orbit N 43 ∧
      Segment N (orbit N 43) 43 68 1670456013870940862971 ∧
      Segment w (orbit N 43) 4 6 73 ∧ PaidMeeting N := by
  let y : Affine := ⟨2368550650964728967333,3501407652208395494688⟩
  let x : Affine := ⟨444103247055886681375,656513934789074155254⟩
  let w : Affine := ⟨350896392735515402567,518727059586428962176⟩
  have original := history42 1385 q y (by decide) (by decide) (by decide)
  have auxiliary : Segment (w.at q) (x.at q) 4 6 73 :=
    affine_word q w x [1,1,2,2] 4052555153018976267 (by decide) (valid_of_list (by decide))
      (by decide) (by decide) (by decide) (by decide)
  exact meeting 1385 q 4 y x w original (by decide) auxiliary (by decide) (by decide)

theorem captures_1897_mod_2048 (q : Nat) :
    let N := seed (1897+2048*q)
    ∃ w, w=(27*orbit N 36+7)/32 ∧ 0<w ∧ w%2=1 ∧ w<N ∧
      3*orbit N 42+1=2^3*orbit N 43 ∧ N<orbit N 43 ∧
      Segment N (orbit N 43) 43 67 1670456013870940862971 ∧
      Segment w (orbit N 43) 4 5 73 ∧ PaidMeeting N := by
  let y : Affine := ⟨3243902564016827841005,3501407652208395494688⟩
  let x : Affine := ⟨1216463461506310440377,1313027869578148310508⟩
  let w : Affine := ⟨480578157632122643111,518727059586428962176⟩
  have original := history42 1897 q y (by decide) (by decide) (by decide)
  have auxiliary : Segment (w.at q) (x.at q) 4 5 73 :=
    affine_word q w x [1,1,2,1] 8105110306037952534 (by decide) (valid_of_list (by decide))
      (by decide) (by decide) (by decide) (by decide)
  exact meeting 1897 q 3 y x w original (by decide) auxiliary (by decide) (by decide)

end CollatzCharacterBridge.A2T43Inverse
