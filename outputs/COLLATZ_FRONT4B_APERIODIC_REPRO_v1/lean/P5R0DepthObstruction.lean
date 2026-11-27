import StagedCylinder

namespace CollatzCharacterBridge.P5R0DepthObstruction

open A2Header (Physical)
open StagedCylinder (Segment)

/-- Each physical return grows the shifted height by at most 3/2. -/
theorem physical_height {x y k S : Nat} (path : Physical x k S y) :
    2^k * (y+1) ≤ 3^k * (x+1) := by
  induction path with
  | refl x => simp
  | @edge x a y _ _ _ _ ha factor =>
    have power : (2 : Nat) ≤ 2^a := by
      simpa only [Nat.pow_one] using
        (Nat.pow_le_pow_right (by decide : 0 < (2 : Nat)) (show 1 ≤ a by omega))
    have bound := Nat.mul_le_mul_right y power
    rw [←factor] at bound
    simp only [Nat.pow_one]
    omega
  | @append x y z k S l R _ _ ihp ihq =>
    calc
      2^(k+l) * (z+1) = 2^k * (2^l * (z+1)) := by rw [Nat.pow_add, Nat.mul_assoc]
      _ ≤ 2^k * (3^l * (y+1)) := Nat.mul_le_mul_left _ ihq
      _ = 3^l * (2^k * (y+1)) := by ac_rfl
      _ ≤ 3^l * (3^k * (x+1)) := Nat.mul_le_mul_left _ ihp
      _ = 3^(k+l) * (x+1) := by rw [Nat.pow_add]; ac_rfl

/-- Padding a source clock to an upper bound preserves the height inequality.
    Its original division count and additive remain in the physical segment. -/
theorem source_height {N w Z k S B D : Nat} (lt : w < N) (depth : k ≤ D)
    (path : Segment w Z k S B) : 2^D * (Z+1) ≤ 3^D * N := by
  have localBound := physical_height path.physical
  have sourceBound : 3^k * (w+1) ≤ 3^k * N := Nat.mul_le_mul_left _ (by omega)
  let d := D-k
  have count : D=k+d := by dsimp [d]; omega
  have pad : (2 : Nat)^d ≤ 3^d := Nat.pow_le_pow_left (by decide) d
  calc
    2^D * (Z+1) = 2^d * (2^k * (Z+1)) := by rw [count, Nat.pow_add]; ac_rfl
    _ ≤ 2^d * (3^k * N) := Nat.mul_le_mul_left _ (Nat.le_trans localBound sourceBound)
    _ ≤ 3^d * (3^k * N) := Nat.mul_le_mul_right _ pad
    _ = 3^D * N := by rw [count, Nat.pow_add]; ac_rfl

/-- High physical terminals admit no paid source within the stated depth. -/
theorem no_short_source {N Z D : Nat} (high : 3^D * N < 2^D * (Z+1)) :
    ¬ ∃ w k S B : Nat, 0<w ∧ w<N ∧ k≤D ∧ Segment w Z k S B := by
  rintro ⟨w,k,S,B,_positive,lt,depth,path⟩
  exact (Nat.not_lt_of_ge (source_height lt depth path)) high

end CollatzCharacterBridge.P5R0DepthObstruction
