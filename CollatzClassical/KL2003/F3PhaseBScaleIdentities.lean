namespace CollatzClassical
namespace KL2003
namespace F3PhaseB

/-!
Minimal arithmetic identities for the F3 PHASE_B scale-aware gate.

This file intentionally avoids importing Mathlib. It records only small
kernel-level arithmetic facts that are useful for the next operator contract.
It does not define a density statement, a `rho` certificate, a Collatz theorem,
or a Lean version of the empirical F3 pilot.
-/

/-- Numerator of the rational target proposed for the first scale-aware F3 gate. -/
def rhoStarNum : Nat := 9

/-- Denominator of the rational target proposed for the first scale-aware F3 gate. -/
def rhoStarDen : Nat := 5

/-- Numerator of the official Lean k=11 lambda value `71689/40000`. -/
def lambda11OfficialNum : Nat := 71689

/-- Denominator of the official Lean k=11 lambda value `71689/40000`. -/
def lambda11OfficialDen : Nat := 40000

/-- Numerator of the older decimal lambda approximation `8961/5000`. -/
def lambda11DecimalNum : Nat := 8961

/-- Denominator of the older decimal lambda approximation `8961/5000`. -/
def lambda11DecimalDen : Nat := 5000

/-- Cross-multiplied form of `71689/40000 < 9/5`. -/
theorem rhoStar_gt_lambda11Official_cross :
    lambda11OfficialNum * rhoStarDen <
      rhoStarNum * lambda11OfficialDen := by
  decide

/-- Cross-multiplied form of `8961/5000 <= 71689/40000`.

This keeps the older decimal approximation explicitly below the official Lean
constant, avoiding drift between the three lambda conventions in the dossier.
-/
theorem lambda11Decimal_le_lambda11Official_cross :
    lambda11DecimalNum * lambda11OfficialDen <=
      lambda11OfficialNum * lambda11DecimalDen := by
  decide

/-- Retarded branch scale in multiplicative form.

Writing `m = 2^(y-2)`, this is the exact algebraic core of
`2^(y-2) * (4a) = 2^y * a`.
-/
theorem retarded_scale_mul (m a : Nat) :
    m * (4 * a) = (4 * m) * a := by
  simp [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm]

/-- PHASE_B advanced branch scale in multiplicative form.

If `3*c + 1 = 2*a`, then multiplying by any window scale `m` preserves the
exact PHASE_B identity. With `m = 2^(y-1)`, this is
`3*m*c + m = 2^y*a`, stated without natural subtraction.
-/
theorem phaseB_scale_mul (m a c : Nat) (hc : 3 * c + 1 = 2 * a) :
    m * (3 * c + 1) = m * (2 * a) := by
  rw [hc]

/-- Expanded PHASE_B identity from `phaseB_scale_mul`.

This is the exact no-subtraction form used by the scale-aware ledger:
`3*m*c + m = m*(2*a)`.
-/
theorem phaseB_scale_expanded (m a c : Nat) (hc : 3 * c + 1 = 2 * a) :
    3 * m * c + m = m * (2 * a) := by
  calc
    3 * m * c + m = m * (3 * c + 1) := by
      simp [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm, Nat.left_distrib]
    _ = m * (2 * a) := phaseB_scale_mul m a c hc

/-- At critical rate `rho = 2`, the retarded and PHASE_B advanced rational
scale coefficients add to one.  This is recorded in cross-multiplied form:
`1 + 3 = 4`, i.e. `1/4 + 3/4 = 1`.

This is not a spectral certificate for any F3 operator.
-/
theorem critical_split_at_two_cross :
    1 + 3 = 4 := by
  decide

end F3PhaseB
end KL2003
end CollatzClassical
