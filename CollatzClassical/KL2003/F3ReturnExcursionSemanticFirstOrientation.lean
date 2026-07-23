import CollatzClassical.KL2003.F3ReturnExcursionRealOperatorBridge

/-!
Semantic-first orientation interface for the F3 renewal bridge.

The semantic statement is source-row indexed and keeps the shifted window
inside the invariant.  The module deliberately contains no numerical claim
about the frozen F3 matrix and no operator-to-fibre or `piStar` implication.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3SemanticFirstOrientation

open F3RealOperatorBridge

variable {ι : Type*} [Fintype ι]
variable {κ : Type*}

def semanticOneStep
    (M : ι → ι → ℝ)
    (B : ι → κ → ℝ)
    (shift : ι → ι → κ → κ) : Prop :=
  ∀ s z, ∑ t, M s t * B t (shift s t z) ≤ B s z

theorem semanticOneStep_source_row
    (M : ι → ι → ℝ)
    (B : ι → κ → ℝ)
    (shift : ι → ι → κ → κ)
    (h : semanticOneStep M B shift) :
    ∀ s z, ∑ t, M s t * B t (shift s t z) ≤ B s z :=
  h

theorem weighted_mass_step_from_source_certificate
    (M : ι → ι → ℝ) (w μ : ι → ℝ) {δ : ℝ}
    (hrow : ∀ s, (1 + δ) * w s ≤ ∑ t, M s t * w t)
    (hμ : ∀ s, 0 ≤ μ s) :
    (1 + δ) * weightedMass w μ ≤ weightedMass w (push M μ) :=
  weighted_mass_push_lower_bound M w μ hrow hμ

theorem semantic_static_specialization
    (M : ι → ι → ℝ)
    (B : ι → κ → ℝ)
    (shift : ι → ι → κ → κ)
    (w : ι → ℝ) (z : κ)
    (hB : ∀ t u, B t u = w t)
    (hsem : semanticOneStep M B shift) :
    ∀ s, ∑ t, M s t * w t ≤ w s := by
  intro s
  have hs := hsem s z
  simpa [hB] using hs

end F3SemanticFirstOrientation
end KL2003
end CollatzClassical
