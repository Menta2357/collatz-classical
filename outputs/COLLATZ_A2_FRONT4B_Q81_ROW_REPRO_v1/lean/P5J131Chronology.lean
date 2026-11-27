import P5RZeroA2
import CRTWordSegment
import A2FirstCrossingChronology

namespace CollatzCharacterBridge.P5J131Chronology

open P5CompensationMeetings (Affine affine_admissible)
open StagedCylinder (Segment compose)
open A2SecondSwitchWordCompiler (ValWord)
open A2FirstCrossingFusion (Paid HitsBelow reduce_first_crossing)
open A2FirstCrossingChronology (LaterResidual chronological_landing)

set_option maxRecDepth 32000

def seed : Affine := ⟨4513258991249853401649257106559,20282409603651670423947251286016⟩
def pivot : Affine := ⟨4700517491161216403002023855175,21123941987308616798560151666688⟩
def terminal : Affine := ⟨4584397419600739073700750533939,20602102921755074907947094535686⟩

private def coordinate (t : Nat) : Nat := 4104785140270772355+2^64*t
private def toPivot : List Nat := [1,2,2,1,1,1,2,3,1,2,2]
private def toTerminal : List Nat := [1,1,2,2,1,2,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,2,3]

private theorem valid_of_check {w : List Nat} (h : w.all (fun a => decide (1≤a))=true) :
    ValWord w := by
  intro a ha
  exact of_decide_eq_true ((List.all_eq_true.mp h) a ha)

private theorem history36 (t : Nat) :
    Segment (seed.at t) (pivot.at t) 36 57 633313283075002961 := by
  have original : (P5RZeroA2.original).at (coordinate t)=seed.at t := by
    simp only [P5RZeroA2.original,coordinate,seed,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have entry : (P5RZeroA2.entry).at (coordinate t)=6955875387124624818645320222699+31259432269928534166775347019776*t := by
    simp only [P5RZeroA2.entry,coordinate,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have part : Segment ((P5RZeroA2.entry).at (coordinate t)) (pivot.at t)
      11 18 535447 := by
    rw [entry]
    have h := CRTWordSegment.crt_word_segment toPivot (ρ := 6955875387124624818645320222699)
      (by decide) (by decide) (valid_of_check (by decide)) (by decide) (59622635402543133100081152*t)
    simpa only [pivot,Affine.at,←Nat.mul_assoc] using h
  rw [←original]
  exact compose (P5RZeroA2.entry_book (coordinate t)) part

private theorem suffix29 (t : Nat) :
    Segment (pivot.at t) (terminal.at t) 29 46 345824154918971 := by
  have h := CRTWordSegment.crt_word_segment toTerminal (ρ := 4700517491161216403002023855175)
    (by decide) (by decide) (valid_of_check (by decide)) (by decide) (150094635296999121*t)
  simpa only [pivot,terminal,Affine.at,←Nat.mul_assoc] using h

private theorem affine_lt {a b : Affine}
    (lower : a.offset<b.offset) (slope : a.slope≤b.slope) (t : Nat) : a.at t<b.at t :=
  Nat.add_lt_add_of_lt_of_le lower (Nat.mul_le_mul_right t slope)

/-- A certified crossing has same-origin payment or an admitted residual with
a new clock and strictly smaller pivot rank. -/
theorem landing65 (t : Nat) :
    seed.at t<pivot.at t ∧ pivot.at t<2*seed.at t+1 ∧
    seed.at t<terminal.at t ∧ terminal.at t<pivot.at t ∧
    Segment (seed.at t) (pivot.at t) 36 57 633313283075002961 ∧
    Segment (pivot.at t) (terminal.at t) 29 46 345824154918971 ∧
    Segment (seed.at t) (terminal.at t) 65 103 93303042734951846419392236966275 ∧
    (Paid (seed.at t) ∨ LaterResidual (seed.at t) (pivot.at t) 36 57 633313283075002961 29) := by
  have large : 1<seed.at t :=
    Nat.lt_of_lt_of_le (by decide : 1<seed.offset) (Nat.le_add_right _ _)
  have wo := (affine_admissible (f := pivot) (by decide) t).2
  have startBelow : seed.at t<pivot.at t := affine_lt (by decide) (by decide) t
  have cap : pivot.at t<2*seed.at t+1 := calc
    _ < (2*seed.offset+1)+(2*seed.slope)*t :=
      Nat.add_lt_add_of_lt_of_le (by decide) (Nat.mul_le_mul_right t (by decide))
    _ = _ := by simp only [Affine.at,Nat.mul_add,Nat.mul_assoc]; ac_rfl
  have staysAbove : seed.at t<terminal.at t := affine_lt (by decide) (by decide) t
  have smaller : terminal.at t<pivot.at t := affine_lt (by decide) (by decide) t
  have history := history36 t
  have path := suffix29 t
  have hit : HitsBelow (pivot.at t) (pivot.at t) 29 :=
    ⟨29,Nat.le_refl _,(A2Header.physical_endpoint path.physical).symm ▸ smaller⟩
  have crossing := reduce_first_crossing large wo cap history path hit
  exact ⟨startBelow,cap,staysAbove,smaller,history,path,compose history path,
    chronological_landing large wo cap crossing⟩

end CollatzCharacterBridge.P5J131Chronology
