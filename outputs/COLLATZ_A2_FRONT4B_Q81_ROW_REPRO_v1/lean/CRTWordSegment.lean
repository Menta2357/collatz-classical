import A2SecondSwitchWordCompiler

namespace CollatzCharacterBridge.CRTWordSegment

open A2SecondSwitchWordCompiler (ValWord compile_word cost total)
open StagedCylinder (Segment)

/-- Odd terminal produced by the exact residue of the affine numerator. -/
def initial_terminal (word : List Nat) (ρ : Nat) : Nat :=
  2*((3^word.length*ρ+cost word)/2^(total word+1))+1

/-- The affine numerator's residue is enough to certify the entire physical
    word on the lifted progression, with the original book at every shift. -/
theorem crt_word_segment (word : List Nat) {ρ : Nat} (positive : 0<ρ) (odd : ρ%2=1)
    (valid : ValWord word)
    (crt : (3^word.length*ρ+cost word)%2^(total word+1)=2^total word)
    (u : Nat) :
    Segment (ρ+2^(total word+1)*u) (initial_terminal word ρ+2*3^word.length*u)
      word.length (total word) (cost word) := by
  let A := 3^word.length*ρ+cost word
  let S := total word
  have residue : A%2^(S+1)=2^S := crt
  have book : 2^total word*initial_terminal word ρ=3^word.length*ρ+cost word := by
    change 2^S*(2*(A/2^(S+1))+1)=A
    calc
      _ = 2^S+2^(S+1)*(A/2^(S+1)) := by
        simp only [Nat.pow_succ, Nat.mul_add, Nat.mul_one]
        ac_rfl
      _ = A%2^(S+1)+2^(S+1)*(A/2^(S+1)) :=
        congrArg (fun r => r+2^(S+1)*(A/2^(S+1))) residue.symm
      _ = A := Nat.mod_add_div A (2^(S+1))
  have terminalPositive : 0<initial_terminal word ρ := by
    unfold initial_terminal
    omega
  have terminalOdd : initial_terminal word ρ%2=1 := by
    unfold initial_terminal
    omega
  have core := compile_word word positive odd terminalPositive terminalOdd valid book
  simpa only [StagedCylinder.offset, Nat.add_zero, Nat.zero_add, Nat.pow_zero,
    Nat.pow_one, Nat.mul_one] using StagedCylinder.shifted_segment core 0 0 u

end CollatzCharacterBridge.CRTWordSegment
