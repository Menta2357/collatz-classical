import CollatzClassical.KL2003.F3ReturnExcursionExactCoreMatrix
import CollatzClassical.KL2003.F3ReturnExcursionRealOperatorBridge

open scoped BigOperators

noncomputable section

namespace CollatzClassical
namespace KL2003
namespace F3ExactCoreMatrix

/-!
The frozen CSV used the left action `wᵀ M`, while the generic mass bridge uses
the right action of its transition matrix.  `coreTransition` records the
transpose convention explicitly: rows are destinations and columns are
sources.  No inequality is asserted here; this file only removes the
orientation ambiguity algebraically.
-/

def coreTransition (s t : Fin 243) : ℝ := coreMatrix t s

def leftCertificate : Prop :=
  ∀ s : Fin 243, (101 / 100 : ℝ) * frozenWeight s ≤
    ∑ t : Fin 243, coreMatrix t s * frozenWeight t

def transitionCertificate : Prop :=
  ∀ s : Fin 243, (101 / 100 : ℝ) * frozenWeight s ≤
    ∑ t : Fin 243, coreTransition s t * frozenWeight t

theorem leftCertificate_iff_transitionCertificate :
    leftCertificate ↔ transitionCertificate := by
  rfl

theorem coreTransition_nonneg (s t : Fin 243) : 0 ≤ coreTransition s t := by
  exact coreMatrix_nonneg t s

theorem transitionCertificate_implies_bridge_assumption
    (h : transitionCertificate) :
    ∀ s : Fin 243, (101 / 100 : ℝ) * frozenWeight s ≤
      ∑ t : Fin 243, coreTransition s t * frozenWeight t :=
  h

end F3ExactCoreMatrix
end KL2003
end CollatzClassical
