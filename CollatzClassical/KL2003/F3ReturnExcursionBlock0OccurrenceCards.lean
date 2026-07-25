import CollatzClassical.KL2003.F3ReturnExcursionBlock0CarrierStateCards

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Structural counting of the formula occurrences over the fixed Block0 carrier.

The formula-edge type is first decomposed by constructor.  No edge table,
transition path, or global finite decision procedure is used here.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0OccurrenceCards

open F3CoreArithmeticCodecPilotRepair
open F3Block0CarrierFibers
open F3Block0CarrierStateCards
open scoped BigOperators

/-! ## Constructor decomposition of formula edges -/

abbrev FormulaEdgeCases :=
  Fin 243 ⊕ ((DirectSource × Fin 3) ⊕ (LiftSource × Fin 3))

def formulaEdgeOfCases : FormulaEdgeCases → FormulaEdge
  | Sum.inl s => .retarded s
  | Sum.inr (Sum.inl (s, ell)) => .advancedDirect s ell
  | Sum.inr (Sum.inr (s, ell)) => .advancedParityLift s ell

def formulaEdgeCases : FormulaEdge → FormulaEdgeCases
  | .retarded s => Sum.inl s
  | .advancedDirect s ell => Sum.inr (Sum.inl (s, ell))
  | .advancedParityLift s ell => Sum.inr (Sum.inr (s, ell))

theorem formulaEdgeOfCases_cases (e : FormulaEdge) :
    formulaEdgeOfCases (formulaEdgeCases e) = e := by
  cases e <;> rfl

theorem formulaEdgeCases_ofCases (e : FormulaEdgeCases) :
    formulaEdgeCases (formulaEdgeOfCases e) = e := by
  rcases e with s | e
  · rfl
  · rcases e with e | e <;> rfl

def formulaEdgeCasesEquiv : FormulaEdgeCases ≃ FormulaEdge where
  toFun := formulaEdgeOfCases
  invFun := formulaEdgeCases
  left_inv := formulaEdgeCases_ofCases
  right_inv := formulaEdgeOfCases_cases

def formulaCaseSource : FormulaEdgeCases → Fin 243
  | Sum.inl s => s
  | Sum.inr (Sum.inl (s, _)) => s.1
  | Sum.inr (Sum.inr (s, _)) => s.1

theorem formulaSource_formulaEdgeOfCases (e : FormulaEdgeCases) :
    formulaSource (formulaEdgeOfCases e) = formulaCaseSource e := by
  rcases e with s | e
  · rfl
  · rcases e with e | e <;> rfl

abbrev SourceFormulaEdge (s : Fin 243) :=
  {e : FormulaEdge // formulaSource e = s}

abbrev SourceFormulaEdgeCases (s : Fin 243) :=
  {e : FormulaEdgeCases // formulaCaseSource e = s}

def sourceFormulaEdgeCasesEquiv (s : Fin 243) :
    SourceFormulaEdgeCases s ≃ SourceFormulaEdge s where
  toFun e :=
    ⟨formulaEdgeOfCases e.1, by
      rw [formulaSource_formulaEdgeOfCases]
      exact e.2⟩
  invFun e :=
    ⟨formulaEdgeCases e.1, by
      rw [← formulaSource_formulaEdgeOfCases]
      rw [formulaEdgeOfCases_cases]
      exact e.2⟩
  left_inv e := by
    apply Subtype.ext
    exact formulaEdgeCases_ofCases e.1
  right_inv e := by
    apply Subtype.ext
    exact formulaEdgeOfCases_cases e.1

end F3Block0OccurrenceCards
end KL2003
end CollatzClassical
