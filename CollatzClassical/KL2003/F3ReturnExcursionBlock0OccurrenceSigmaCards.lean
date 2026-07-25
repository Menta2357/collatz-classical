import CollatzClassical.KL2003.F3ReturnExcursionBlock0FormulaFiberCards

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Typed sigma decomposition of Block0 formula occurrences.

This module deliberately contains only the carrier equivalence and its
cardinality-as-a-sum consequence.  It performs no numerical normalization.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0OccurrenceSigmaCards

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0OccurrenceCards
open scoped BigOperators

abbrev Block0OccurrenceSigma :=
  Σ i : Block0Root, SourceFormulaEdge (rootState i)

def block0OccurrenceSigmaEquiv :
    Block0Occurrence ≃ Block0OccurrenceSigma where
  toFun p := ⟨p.1.1, ⟨p.1.2, p.2⟩⟩
  invFun p := ⟨(p.1, p.2.1), p.2.2⟩
  left_inv p := by
    rcases p with ⟨⟨i, e⟩, h⟩
    rfl
  right_inv p := by
    rcases p with ⟨i, e, h⟩
    rfl

theorem block0Occurrence_card_eq_sum_sourceFibers :
    Fintype.card Block0Occurrence =
      ∑ i : Block0Root,
        Fintype.card (SourceFormulaEdge (rootState i)) := by
  rw [Fintype.card_congr block0OccurrenceSigmaEquiv]
  exact Fintype.card_sigma

end F3Block0OccurrenceSigmaCards
end KL2003
end CollatzClassical
