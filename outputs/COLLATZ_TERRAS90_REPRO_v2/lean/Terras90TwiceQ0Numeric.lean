import Terras90Q0Ratio

namespace Terras90TwiceQ0Numeric

open Terras88 (q0Clock verifiedHeight)
open Terras90Q0Price (floor92 product shiftedProduct envelopeNumerator envelopeDenominator)

def twiceQ0Clock : Nat × Nat := (2*q0Clock.1,2*q0Clock.2)

def floors : List Nat := List.replicate 7 verifiedHeight ++ List.replicate 82 floor92

theorem floorsLength : floors.length=89 := by simp [floors]

/-- Compare this envelope with the square of the envelope already certified
for Q0. This calculation only evaluates moderate-size integers. -/
theorem envelope_lt_squared :
    shiftedProduct floors*(envelopeDenominator*envelopeDenominator) <
      product floors*(envelopeNumerator*envelopeNumerator) := by
  decide

private theorem useSquaredComparison {a b : Nat}
    (single : a*envelopeNumerator < b*envelopeDenominator) :
    (a*a)*shiftedProduct floors < (b*b)*product floors := by
  have positive : 0<b*envelopeDenominator :=
    Nat.lt_of_le_of_lt (Nat.zero_le _) single
  have upper : (a*envelopeNumerator)*(a*envelopeNumerator) <
      (b*envelopeDenominator)*(b*envelopeDenominator) := by
    calc
      _ ≤ (b*envelopeDenominator)*(a*envelopeNumerator) :=
        Nat.mul_le_mul_right _ (Nat.le_of_lt single)
      _ < _ := Nat.mul_lt_mul_of_pos_left single positive
  have reuse : shiftedProduct floors*(envelopeDenominator*envelopeDenominator) ≤
      product floors*(envelopeNumerator*envelopeNumerator) :=
    Nat.le_of_lt envelope_lt_squared
  apply Nat.lt_of_mul_lt_mul_left (a := envelopeDenominator*envelopeDenominator)
  calc
    _ = (a*a)*(shiftedProduct floors*(envelopeDenominator*envelopeDenominator)) := by ac_rfl
    _ ≤ (a*a)*(product floors*(envelopeNumerator*envelopeNumerator)) :=
      Nat.mul_le_mul_left _ reuse
    _ = product floors*((a*envelopeNumerator)*(a*envelopeNumerator)) := by ac_rfl
    _ < product floors*((b*envelopeDenominator)*(b*envelopeDenominator)) :=
      Nat.mul_lt_mul_of_pos_left upper (by decide)
    _ = _ := by ac_rfl

private theorem comparePowers {k d : Nat}
    (single : 3^d*envelopeNumerator < 2^k*envelopeDenominator) :
    3^(2*d)*shiftedProduct floors < 2^(2*k)*product floors := by
  rw [Nat.two_mul d,Nat.two_mul k,Nat.pow_add,Nat.pow_add]
  exact useSquaredComparison single

theorem productStrict :
    3^(2*q0Clock.2)*shiftedProduct floors < 2^(2*q0Clock.1)*product floors :=
  comparePowers Terras90Q0Price.q0ProductStrict

end Terras90TwiceQ0Numeric
