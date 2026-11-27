import P5RZeroA2

namespace CollatzCharacterBridge.P5RZeroJ131

open P5RZeroA2 (entry entry_book original)
open P5CompensationMeetings (Affine Word affine_admissible checkWord word_segment)
open StagedCylinder (Segment compose)

set_option maxRecDepth 32000

private def entryEven : Affine := ⟨222307823200235,13881976577114112⟩
private def tipEven : Affine := ⟨474792196620037,29648323021629456⟩

private def wordEven : Word :=
  [(1, ⟨333461734800353,20822964865671168⟩),
   (2, ⟨250096301100265,15617223649253376⟩),
   (2, ⟨187572225825199,11712917736940032⟩),
   (1, ⟨281358338737799,17569376605410048⟩),
   (1, ⟨422037508106699,26354064908115072⟩),
   (1, ⟨633056262160049,39531097362172608⟩),
   (2, tipEven)]

private theorem history32 (q : Nat) :
    Segment (original.at (131+256*(32*q))) (tipEven.at q) 32 49 6352232628433409 := by
  have entryAt : entryEven.at q=entry.at (131+256*(32*q)) := by
    simp only [entryEven, entry, Affine.at, Nat.mul_add, ←Nat.mul_assoc]
    omega
  have valid : checkWord entryEven wordEven=true := by decide
  have tail := word_segment q entryEven wordEven valid
  rw [entryAt] at tail
  exact compose (entry_book (131+256*(32*q))) tail

/-- The last valuation is the physical valuation; the guard only gives its lower bound. -/
theorem direct32 (q : Nat) :
    let N := original.at (131+256*(32*q))
    ∃ a, 4≤a ∧ 3*orbit N 32+1=2^a*orbit N 33 ∧ orbit N 33<N ∧
      Segment N (orbit N 33) 33 (49+a) 19619647838721539 := by
  let N := original.at (131+256*(32*q))
  let Z := tipEven.at q
  have za := affine_admissible (f := tipEven) (by decide) q
  have numerator : 3*Z+1=1424376589860112+88944969064888368*q := by
    simp only [Z, tipEven, Affine.at, Nat.mul_add, ←Nat.mul_assoc]
    omega
  have divides : 2^4 ∣ 3*Z+1 := by
    rw [numerator]
    exact Nat.dvd_add (by decide) (Nat.dvd_mul_right_of_dvd (by decide) q)
  have price : 3*Z+1<2^4*N := by
    rw [numerator]
    change 1424376589860112+88944969064888368*q<16*N
    simp only [N, original, Affine.at, Nat.mul_add, ←Nat.mul_assoc]
    omega
  obtain ⟨a,apos,factor⟩ := P5R3S5.actual_step_factor Z za.2
  have reserve := P5R3S5.exact_reserve (step_odd Z) factor
  have enough : 4≤a := by
    by_cases bound : 4≤a
    · exact bound
    · exact (reserve.2 (Nat.dvd_trans (Nat.pow_dvd_pow 2 (by omega)) divides)).elim
  have scaled := Nat.mul_le_mul_right (step Z)
    (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) enough)
  rw [←factor] at scaled
  have below : step Z<N :=
    Nat.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt scaled price)
  have tail := P5R3S5.step_segment _ a za.1 za.2 apos factor
  have whole : Segment N (step Z) 33 (49+a) 19619647838721539 :=
    compose (history32 q) tail
  refine ⟨a,enough,?_⟩
  rw [A2Header.physical_endpoint (history32 q).physical,
    A2Header.physical_endpoint whole.physical]
  exact ⟨factor,below,whole⟩

end CollatzCharacterBridge.P5RZeroJ131
