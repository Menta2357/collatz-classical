import CollatzClassical.DensityFusionParametric

namespace CollatzClassical

/-!
# Mazur ND31 source-surface adapter

This file mirrors only the shape of the pinned `ND31Bounds` proposition.  It
does not import the ProofAtlas closure and it does not assert the external
theorem.  The endpoint bridge remains an explicit hypothesis so that the
eventual-ratio transport cannot hide a counting-convention mismatch.
-/

/-- Source-surface shape of Mazur's fixed-exponent ND31 bound. -/
def MazurND31BoundsSurface {R : Type} [AddCommGroup R] [LinearOrder R]
    [IsOrderedAddMonoid R] [Mul R] [OfNat R 2]
    (badRatio : Nat → R → R) (bound : Nat → R) : Prop :=
  ∃ C : R, 0 ≤ C ∧
    ∀ (N0 : ℕ) (x : R), 2 ≤ N0 → 2 ≤ x →
      badRatio N0 x ≤ C * bound N0

/-- The only endpoint fact needed to pass from the real source ratio to a
natural-endpoint ratio.  A future concrete instance must prove it from the
same semi-open/inclusive counting convention as the source. -/
def NatEndpointBridge {R : Type} [LinearOrder R]
    (badRatioNat : Nat → Nat → R) (badRatio : Nat → R → R)
    (endpoint : Nat → R) : Prop :=
  ∀ (N0 X : ℕ), 2 ≤ N0 → 2 ≤ X →
    badRatioNat N0 X ≤ badRatio N0 (endpoint X)

/-- Convert the source-surface ND31 estimate into the generic eventual bound.

This is an adapter theorem only: it consumes an explicit endpoint bridge and
does not identify either ratio with a Syracuse or Collatz counting set. -/
theorem mazur_nd31_surface_to_eventual_nat_bad_bound
    {R : Type} [AddCommGroup R] [LinearOrder R] [IsOrderedAddMonoid R]
    [Mul R] [OfNat R 2]
    {badRatioNat : ℕ → ℕ → R} {badRatio : ℕ → R → R}
    {bound endpoint : ℕ → R}
    (hnd31 : MazurND31BoundsSurface badRatio bound)
    (hbridge : NatEndpointBridge badRatioNat badRatio endpoint)
    (hendpoint : ∀ X : ℕ, 2 ≤ X → 2 ≤ endpoint X) :
    ∃ C : R, 0 ≤ C ∧
      ∀ (N0 : ℕ), 2 ≤ N0 →
        ∀ᶠ X : ℕ in Filter.atTop,
          badRatioNat N0 X ≤ C * bound N0 := by
  rcases hnd31 with ⟨C, hC, hbound⟩
  refine ⟨C, hC, ?_⟩
  intro N0 hN0
  filter_upwards [Filter.eventually_ge_atTop 2] with X hX
  exact (hbridge N0 X hN0 hX).trans <|
    hbound N0 (endpoint X) hN0 (hendpoint X hX)

end CollatzClassical
