import P5J131EarlyCapture

namespace CollatzCharacterBridge.P5J131Residual

open A2CertifiedLanding (Descended PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord)
open FixedSourceRun (Ones)
open P5CompensationMeetings (Affine affine_admissible)
open P5RZeroA2 (entry entry_book original)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000
set_option maxHeartbeats 800000

private def coordinate (u : Nat) : Nat := 131+256*u
def seed (u : Nat) : Nat := original.at (coordinate u)
def pivot (u : Nat) : Nat := 187572225825199+366028679279376*u
private def cofactor (u : Nat) : Nat := 11723264114075+22876792454961*u

private theorem valid_of_list {v : List Nat}
    (checked : v.all (fun a => decide (1≤a))=true) : ValWord v := by
  intro a ha
  exact of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

theorem history28 (u : Nat) : Segment (seed u) (pivot u) 28 44 64305438710449 := by
  have entry_eq : entry.at (coordinate u)=222307823200235+433811768034816*u := by
    simp only [entry,coordinate,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (entry.at (coordinate u)) (pivot u) 3 5 23 := by
    rw [entry_eq]
    have h := CRTWordSegment.crt_word_segment [1,2,2] (ρ := 222307823200235)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (6778308875544*u)
    simpa only [pivot,←Nat.mul_assoc] using h
  exact compose (entry_book (coordinate u)) tail

private theorem pivot_bounds (u : Nat) : 0<pivot u ∧ pivot u%2=1 ∧ pivot u<2*seed u+1 := by
  simp only [pivot,seed,coordinate,original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem three_ones (u : Nat) :
    orbit (pivot u) 3=54*cofactor u-1 ∧ Ones (pivot u) 3 := by
  have hp : 0<cofactor u := by unfold cofactor; omega
  have start : pivot u=2^(3+1)*cofactor u-1 := by
    unfold pivot cofactor
    change 187572225825199+366028679279376*u=16*(11723264114075+22876792454961*u)-1
    omega
  rw [start]
  exact FixedSourceRun.ones_prefix 3 (cofactor u) hp

private theorem valuation_lower_bound {x a p : Nat}
    (factor : 3*x+1=2^a*step x) (divides : 2^p ∣ 3*x+1) : p≤a := by
  by_cases h : p≤a
  · exact h
  · have next : a+1≤p := by omega
    exact ((P5R3S5.exact_reserve (step_odd x) factor).2
      (Nat.dvd_trans (Nat.pow_dvd_pow 2 next) divides)).elim

/-- A strong physical first rupture pays relative to the original N,
    including arbitrary lengths and valuations in the two books. -/
theorem strong_capture (u k b : Nat) (run : Ones (pivot u) (k+1)) (strong : 3≤b)
    (factor : 3*orbit (pivot u) (k+1)+1=2^b*orbit (pivot u) (k+2)) :
    let w := A2HalfAdaptive.half (pivot u)
    let K := orbit (pivot u) (k+2)
    0<w ∧ w%2=1 ∧ w<seed u ∧
      Segment (seed u) K (28+(k+2)) (44+(k+1+b))
        (3^(k+2)*64305438710449+A2HalfAdaptive.originalCost k*2^44) ∧
      Segment w K (k+2) (k+b) (A2HalfAdaptive.sourceCost k) ∧ PaidMeeting (seed u) := by
  obtain ⟨positive,odd,height⟩ := pivot_bounds u
  obtain ⟨wp,wo,below,fromN,source⟩ :=
    A2HalfAdaptive.history_capture (history28 u) positive odd height run strong factor
  exact ⟨wp,wo,below,fromN,source,_,_,_,_,_,_,_,_,wp,wo,below,
    orbit_pos _ positive _,orbit_odd _ odd _,fromN,source⟩

/-- Everything left by this test has a real rupture of valuation two,
    after at least three physical returns of valuation one. -/
theorem paid_or_two (u : Nat) : PaidMeeting (seed u) ∨
    ∃ r, 3≤r ∧ Ones (pivot u) r ∧
      3*orbit (pivot u) r+1=4*orbit (pivot u) (r+1) := by
  obtain ⟨positive,odd,_⟩ := pivot_bounds u
  obtain ⟨r,b,run,hb,factor⟩ := A2HalfAdaptive.first_break (pivot u) odd
  have length : 3≤r := by
    by_cases h : 3≤r
    · exact h
    · have one := (three_ones u).2 r (by omega)
      have ge : (4:Nat)≤2^b := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) hb
      have scaled := Nat.mul_le_mul_right (orbit (pivot u) (r+1)) ge
      rw [←factor,one] at scaled
      have hp := orbit_pos _ positive (r+1)
      omega
  by_cases two : b=2
  · rw [two] at factor
    exact Or.inr ⟨r,length,run,factor⟩
  · have eq : r=r-1+1 := by omega
    have clock : r-1+2=r+1 := by omega
    have payment := strong_capture u (r-1) b
      (by rw [←eq]; exact run) (by omega) (by rw [←eq,clock]; exact factor)
    exact Or.inl payment.2.2.2.2.2

/-- The physical valuation is strong for every u=2 mod 4, with no
    additional guard on that valuation. -/
theorem pays_mod_four_two (q : Nat) : PaidMeeting (seed (2+4*q)) := by
  let u := 2+4*q
  have run := three_ones u
  have phase : cofactor u%4=1 := by dsimp only [cofactor,u]; omega
  let x := orbit (pivot u) 3
  have od := orbit_odd _ (pivot_bounds u).2.1 3
  obtain ⟨b,_,factor⟩ := P5R3S5.actual_step_factor x od
  have divides : (2:Nat)^3 ∣ 3*x+1 := by
    apply Nat.dvd_of_mod_eq_zero
    change (3*orbit (pivot u) 3+1)%8=0
    rw [run.1]
    have positive : 0<cofactor u := by unfold cofactor; omega
    omega
  have bound := valuation_lower_bound factor divides
  exact (strong_capture u 2 b run.2 bound factor).2.2.2.2.2

private theorem descendant_step {N X j s C p : Nat} (history : Segment N X j s C)
    (positive : 0<X) (odd : X%2=1) (divides : 2^p ∣ 3*X+1)
    (price : 3*X+1<2^p*N) :
    ∃ c, p≤c ∧ 3*X+1=2^c*step X ∧ step X<N ∧
      Segment N (step X) (j+1) (s+c) (3*C+2^s) ∧ Descended N := by
  obtain ⟨c,cp,factor⟩ := P5R3S5.actual_step_factor X odd
  have cb := valuation_lower_bound factor divides
  have power := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) cb
  have scaled := Nat.mul_le_mul_right (step X) power
  rw [←factor] at scaled
  have below := Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scaled price)
  have whole : Segment N (step X) (j+1) (s+c) (3*C+2^s) :=
    by simpa only [Nat.pow_one,Nat.mul_one] using
      compose history (P5R3S5.step_segment X c positive odd cp factor)
  exact ⟨c,cb,factor,below,whole,_,_,_,_,step_pos _,step_odd _,below,whole⟩

private def tip60 : Affine := ⟨84098096793262901,88944969064888368⟩
private def tip24 : Affine := ⟨17033275847131597,44472484532444184⟩

private theorem history60 (q : Nat) :
    Segment (seed (60+64*q)) (tip60.at q) 33 50 19619647838721539 := by
  have entry_eq : entry.at (coordinate (60+64*q))=26251013905289195+27763953154228224*q := by
    simp only [entry,coordinate,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (entry.at (coordinate (60+64*q))) (tip60.at q) 8 11 12853 := by
    rw [entry_eq]
    have h := CRTWordSegment.crt_word_segment [1,2,2,1,1,1,2,1] (ρ := 26251013905289195)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (6778308875544*q)
    simpa only [tip60,Affine.at,←Nat.mul_assoc] using h
  exact compose (entry_book (coordinate (60+64*q))) tail

private theorem history24 (q : Nat) :
    Segment (seed (24+64*q)) (tip24.at q) 33 51 19619647838721539 := by
  have entry_eq : entry.at (coordinate (24+64*q))=10633790256035819+27763953154228224*q := by
    simp only [entry,coordinate,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have tail : Segment (entry.at (coordinate (24+64*q))) (tip24.at q) 8 12 12853 := by
    rw [entry_eq]
    have h := CRTWordSegment.crt_word_segment [1,2,2,1,1,1,2,2] (ρ := 10633790256035819)
      (by decide) (by decide) (valid_of_list (by decide)) (by decide) (3389154437772*q)
    simpa only [tip24,Affine.at,←Nat.mul_assoc] using h
  exact compose (entry_book (coordinate (24+64*q))) tail

theorem descends_mod_64_sixty (q : Nat) :
    let N := seed (60+64*q)
    ∃ c, 4≤c ∧ 3*orbit N 33+1=2^c*orbit N 34 ∧ orbit N 34<N ∧
      Segment N (orbit N 34) 34 (50+c) 59984843423007241 ∧ Descended N := by
  have h := history60 q
  obtain ⟨positive,odd⟩ := affine_admissible (f := tip60) (by decide) q
  have divides : (2:Nat)^4 ∣ 3*tip60.at q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    simp only [tip60,Affine.at]
    change (3*(84098096793262901+88944969064888368*q)+1)%16=0
    omega
  have price : 3*tip60.at q+1<2^4*seed (60+64*q) := by
    simp only [tip60,seed,coordinate,original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨c,strong,factor,below,book,descended⟩ := descendant_step h positive odd divides price
  dsimp only
  rw [A2Header.physical_endpoint h.physical,A2Header.physical_endpoint book.physical]
  exact ⟨c,strong,factor,below,book,descended⟩

theorem descends_mod_64_twenty_four (q : Nat) :
    let N := seed (24+64*q)
    ∃ c, 3≤c ∧ 3*orbit N 33+1=2^c*orbit N 34 ∧ orbit N 34<N ∧
      Segment N (orbit N 34) 34 (51+c) 61110743329849865 ∧ Descended N := by
  have h := history24 q
  obtain ⟨positive,odd⟩ := affine_admissible (f := tip24) (by decide) q
  have divides : (2:Nat)^3 ∣ 3*tip24.at q+1 := by
    apply Nat.dvd_of_mod_eq_zero
    simp only [tip24,Affine.at]
    change (3*(17033275847131597+44472484532444184*q)+1)%8=0
    omega
  have price : 3*tip24.at q+1<2^3*seed (24+64*q) := by
    simp only [tip24,seed,coordinate,original,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  obtain ⟨c,strong,factor,below,book,descended⟩ := descendant_step h positive odd divides price
  dsimp only
  rw [A2Header.physical_endpoint h.physical,A2Header.physical_endpoint book.physical]
  exact ⟨c,strong,factor,below,book,descended⟩

end CollatzCharacterBridge.P5J131Residual
