import Front4bT61S3
import Front4bEarlyMeeting

namespace CollatzCharacterBridge.Front4bValSixCut

open A2CertifiedLanding (Descended PaidMeeting)
open A2U392 (seed)
open P5CompensationMeetings (Affine Word endpoint divisions cost checkWord word_segment affine_admissible)
open StagedCylinder (Segment compose)
open Front4bT61S3 (checkpoint60 history60 index)

set_option maxRecDepth 16000
set_option maxHeartbeats 350000

private def pivot (r m : Nat) : Affine :=
  ⟨checkpoint60.at r, checkpoint60.slope*m⟩

private def origin (r m : Nat) : Affine :=
  ⟨7551224716847488673038978175+39614081257132168796771975168*r,
   39614081257132168796771975168*m⟩

private theorem from_origin (r m t : Nat) :
    seed (index (r+m*t))=(origin r m).at t := by
  simp only [Front4bT61S3.seed_affine,index,origin,Affine.at,Nat.mul_add,←Nat.mul_assoc]
  rw [show 288230376151711744*137438953472=39614081257132168796771975168 by decide]
  omega

private theorem prefix_book (r m t : Nat) (word : Word)
    (ok : checkWord (pivot r m) word=true) :
    Segment ((origin r m).at t) ((endpoint (pivot r m) word).at t)
      (60+word.length) (94+divisions word)
      (3^word.length*253163701604367108480427299121+2^94*cost word) := by
  have h := history60 (r+m*t)
  have hp : checkpoint60.at (r+m*t)=(pivot r m).at t := by
    simp only [pivot, Affine.at, Nat.mul_add, Nat.mul_assoc, Nat.add_assoc]
  rw [from_origin r m t,hp] at h
  exact compose h (word_segment t (pivot r m) word ok)

private theorem numerator {X : Affine} (t : Nat) :
    3*X.at t+1=(3*X.offset+1)+(3*X.slope)*t := by
  simp only [Affine.at,Nat.mul_add,Nat.mul_assoc]
  ac_rfl

private theorem factor_at_least {X : Affine} {e : Nat} (t : Nat) (h : X.admissible)
    (h0 : 2^e ∣ 3*X.offset+1) (h1 : 2^e ∣ 3*X.slope) :
    ∃ b, e≤b ∧ 1≤b ∧ 3*X.at t+1=2^b*step (X.at t) := by
  obtain ⟨b,pos,hb⟩ := P5R3S5.actual_step_factor (X.at t) (affine_admissible h t).2
  have hd : 2^e ∣ 3*X.at t+1 := by
    rw [numerator]
    exact Nat.dvd_add h0 (Nat.dvd_mul_right_of_dvd h1 t)
  have enough : e≤b := by
    by_cases hn : e≤b
    · exact hn
    · have smaller : b+1≤e := by omega
      exact ((P5R3S5.exact_reserve (step_odd _) hb).2
        (Nat.dvd_trans (Nat.pow_dvd_pow 2 smaller) hd)).elim
  exact ⟨b,enough,pos,hb⟩

private theorem cut_margin {A X : Affine} {e : Nat} (t : Nat)
    (h0 : 3*X.offset+1<2^e*A.offset) (h1 : 3*X.slope≤2^e*A.slope) :
    3*X.at t+1<2^e*A.at t := by
  rw [numerator]
  have ht := Nat.mul_le_mul_right t h1
  simp only [Affine.at,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem descends_cut {r m e : Nat} (t : Nat) (word : Word)
    (ok : checkWord (pivot r m) word=true)
    (h : (endpoint (pivot r m) word).admissible)
    (div0 : 2^e ∣ 3*(endpoint (pivot r m) word).offset+1)
    (div1 : 2^e ∣ 3*(endpoint (pivot r m) word).slope)
    (price0 : 3*(endpoint (pivot r m) word).offset+1<2^e*(origin r m).offset)
    (price1 : 3*(endpoint (pivot r m) word).slope≤2^e*(origin r m).slope) :
    Descended (seed (index (r+m*t))) := by
  let X := endpoint (pivot r m) word
  obtain ⟨b,low,pos,factor⟩ := factor_at_least t h div0 div1
  have price : 3*X.at t+1<2^e*(origin r m).at t := cut_margin t price0 price1
  have priceB : 3*X.at t+1<2^b*(origin r m).at t :=
    Nat.lt_of_lt_of_le price (Nat.mul_le_mul_right _ (Nat.pow_le_pow_right (by decide) low))
  obtain ⟨xp,xo⟩ := affine_admissible h t
  rw [from_origin]
  exact (Front4bPairExit.descent_of_numerator_bound (prefix_book r m t word ok) xp xo pos factor priceB).2.2

private def word5 : Word := [(2, ⟨330054572566898689153883196997, 1017387798605188884343066396824⟩)]
private theorem descends_5 (t : Nat) : Descended (seed (index (5+16*t))) :=
  descends_cut (e := 3) t word5
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

private def word6 : Word := [(1, ⟨787282619959445988850649693597, 1017387798605188884343066396824⟩)]
private def word2 : Word := [(1, ⟨278588720656851546679116495185, 4069551194420755537372265587296⟩), (2, ⟨208941540492638660009337371389, 3052163395815566653029199190472⟩)]
private theorem descends_2 (t : Nat) : Descended (seed (index (2+32*t))) :=
  descends_cut (e := 3) t word2
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

private def word8 : Word := [(1, ⟨1041629569610743209936416292803, 4069551194420755537372265587296⟩), (1, ⟨1562444354416114814904624439205, 6104326791631133306058398380944⟩)]
private theorem descends_8 (t : Nat) : Descended (seed (index (8+32*t))) :=
  descends_cut (e := 4) t word8
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

private def word13 : Word := [(2, ⟨838748471869493131325416395409, 2034775597210377768686132793648⟩), (2, ⟨629061353902119848494062296557, 1526081697907783326514599595236⟩)]
private theorem descends_13 (t : Nat) : Descended (seed (index (13+32*t))) :=
  descends_cut (e := 2) t word13
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

private def word25 : Word := [(2, ⟨1601789320823384794582716193027, 2034775597210377768686132793648⟩), (1, ⟨2402683981235077191874074289541, 3052163395815566653029199190472⟩)]
private theorem descends_25 (t : Nat) : Descended (seed (index (25+32*t))) :=
  descends_cut (e := 3) t word25
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)


private theorem paid_at_floor_three {r m : Nat} (t : Nat) (word : Word)
    (ok : checkWord (pivot r m) word=true)
    (h : (endpoint (pivot r m) word).admissible)
    (div0 : 2^3 ∣ 3*(endpoint (pivot r m) word).offset+1)
    (div1 : 2^3 ∣ 3*(endpoint (pivot r m) word).slope)
    (desc0 : 3*(endpoint (pivot r m) word).offset+1<2^4*(origin r m).offset)
    (desc1 : 3*(endpoint (pivot r m) word).slope≤2^4*(origin r m).slope)
    (price0 : 3*(endpoint (pivot r m) word).offset+1<12*(origin r m).offset+4)
    (price1 : 3*(endpoint (pivot r m) word).slope≤12*(origin r m).slope) :
    Descended (seed (index (r+m*t))) ∨ PaidMeeting (seed (index (r+m*t))) := by
  let X := endpoint (pivot r m) word
  have hist := prefix_book r m t word ok
  obtain ⟨xp,xo⟩ := affine_admissible h t
  obtain ⟨b,low,pos,factor⟩ := factor_at_least (e := 3) t h div0 div1
  rw [from_origin]
  by_cases strong : 4≤b
  · have price : 3*X.at t+1<2^4*(origin r m).at t := cut_margin t desc0 desc1
    have priceB : 3*X.at t+1<2^b*(origin r m).at t :=
      Nat.lt_of_lt_of_le price (Nat.mul_le_mul_right _ (Nat.pow_le_pow_right (by decide) strong))
    exact Or.inl (Front4bPairExit.descent_of_numerator_bound hist xp xo pos factor priceB).2.2
  · have eq : b=3 := by omega
    subst b
    have tail := P5R3S5.step_segment (X.at t) 3 xp xo pos factor
    have exact : 3*X.at t+1=8*step (X.at t) := factor
    have res : step (X.at t)%3=2 := by omega
    have calcMargin : 3*X.at t+1<12*(origin r m).at t+4 := by
      change 3*X.offset+1<12*(origin r m).offset+4 at price0
      change 3*X.slope≤12*(origin r m).slope at price1
      have scaled := Nat.mul_le_mul_right t price1
      rw [numerator]
      simp only [Affine.at, Nat.mul_add, ←Nat.mul_assoc]
      omega
    have price : 2*step (X.at t)<3*(origin r m).at t+1 := by omega
    exact Or.inr (Front4bEarlyMeeting.paid_of_small_two_mod_three
      (compose hist tail) (step_odd _) res price)

private theorem pays_s6 (t : Nat) :
    Descended (seed (index (6+8*t))) ∨ PaidMeeting (seed (index (6+8*t))) :=
  paid_at_floor_three t word6
    (by decide) (by decide) (by decide) (by decide)
    (by decide) (by decide) (by decide) (by decide)

private def word17 : Word := [(2, ⟨1093095421520790352411182994615, 4069551194420755537372265587296⟩), (1, ⟨1639643132281185528616774491923, 6104326791631133306058398380944⟩), (1, ⟨2459464698421778292925161737885, 9156490187446699959087597571416⟩)]
private theorem pays_s17 (t : Nat) :
    Descended (seed (index (17+64*t))) ∨ PaidMeeting (seed (index (17+64*t))) :=
  paid_at_floor_three t word17
    (by decide) (by decide) (by decide) (by decide)
    (by decide) (by decide) (by decide) (by decide)

private def word26 : Word := [(1, ⟨3330752116472418199708315685657, 8139102388841511074744531174592⟩), (2, ⟨2498064087354313649781236764243, 6104326791631133306058398380944⟩), (1, ⟨3747096131031470474671855146365, 9156490187446699959087597571416⟩)]
private theorem pays_s26 (t : Nat) :
    Descended (seed (index (26+64*t))) ∨ PaidMeeting (seed (index (26+64*t))) :=
  paid_at_floor_three t word26
    (by decide) (by decide) (by decide) (by decide)
    (by decide) (by decide) (by decide) (by decide)

private def word32 : Word := [(1, ⟨4093792965426309862965615483275, 8139102388841511074744531174592⟩), (1, ⟨6140689448139464794448423224913, 12208653583262266612116796761888⟩), (2, ⟨4605517086104598595836317418685, 9156490187446699959087597571416⟩)]
private theorem pays_s32 (t : Nat) :
    Descended (seed (index (32+64*t))) ∨ PaidMeeting (seed (index (32+64*t))) :=
  paid_at_floor_three t word32
    (by decide) (by decide) (by decide) (by decide)
    (by decide) (by decide) (by decide) (by decide)

/-- Seven disjoint progression guards for the row with valuation six.
The physical witnesses terminate by T63 and include the original book.
-/
theorem paid_row (s : Nat)
    (covered : s%4=3 ∨ s%16=5 ∨ s%8=6 ∨
      s%32=2 ∨ s%32=8 ∨ s%32=13 ∨ s%32=25) :
    Descended (seed (index s)) ∨ PaidMeeting (seed (index s)) := by
  rcases covered with h|h|h|h|h|h|h
  · have eq : s=3+4*(s/4) := by omega
    rw [eq]
    obtain ⟨_,_,_,_,_,_,_,d⟩ := Front4bT61S3.descends_t61 (s/4)
    exact Or.inl (by simpa only [←Front4bT61S3.index_formula] using d)
  · have eq : s=5+16*(s/16) := by omega
    rw [eq]
    exact Or.inl (descends_5 (s/16))
  · have eq : s=6+8*(s/8) := by omega
    rw [eq]
    exact pays_s6 (s/8)
  · have eq : s=2+32*(s/32) := by omega
    rw [eq]
    exact Or.inl (descends_2 (s/32))
  · have eq : s=8+32*(s/32) := by omega
    rw [eq]
    exact Or.inl (descends_8 (s/32))
  · have eq : s=13+32*(s/32) := by omega
    rw [eq]
    exact Or.inl (descends_13 (s/32))
  · have eq : s=25+32*(s/32) := by omega
    rw [eq]
    exact Or.inl (descends_25 (s/32))

/-- The same price test pays three additional guards at T64. -/
theorem paid_row64 (s : Nat)
    (covered : (s%4=3 ∨ s%16=5 ∨ s%8=6 ∨ s%32=2 ∨ s%32=8 ∨ s%32=13 ∨ s%32=25)
      ∨ s%64=17 ∨ s%64=26 ∨ s%64=32) :
    Descended (seed (index s)) ∨ PaidMeeting (seed (index s)) := by
  rcases covered with old|h|h|h
  · exact paid_row s old
  · have eq : s=17+64*(s/64) := by omega
    rw [eq]
    exact pays_s17 (s/64)
  · have eq : s=26+64*(s/64) := by omega
    rw [eq]
    exact pays_s26 (s/64)
  · have eq : s=32+64*(s/64) := by omega
    rw [eq]
    exact pays_s32 (s/64)

end CollatzCharacterBridge.Front4bValSixCut
