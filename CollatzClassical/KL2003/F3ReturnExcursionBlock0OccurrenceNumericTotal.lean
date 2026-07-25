import CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceTripleWeights

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Numerical total for the typed Block0 occurrence carrier.

This module contains only the `Fin 324 × Fin 3` reindexing, the local
`1 + 4 + 4 = 9` sum, and the resulting typed cardinality 2916.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0OccurrenceNumericTotal

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0CarrierFiberCards
open F3Block0OccurrenceCards
open F3Block0OccurrenceSigmaCards
open F3Block0OccurrenceTripleWeights
open scoped BigOperators

theorem block0Occurrence_card :
    Fintype.card Block0Occurrence = 2916 := by
  rw [block0Occurrence_card_eq_sum_sourceFibers]
  rw [← block0RootTripleEquiv.sum_comp
    (fun i : Block0Root =>
      Fintype.card (SourceFormulaEdge (rootState i)))]
  rw [Fintype.sum_prod_type]
  calc
    (∑ k : Fin 324, ∑ r : Fin 3,
      Fintype.card (SourceFormulaEdge
        (rootState (block0RootTripleEquiv (k, r))))) =
        ∑ _k : Fin 324, 9 := by
      apply Finset.sum_congr rfl
      intro k hk
      exact sourceFormulaEdge_triple_sum k
    _ = 324 * 9 := by simp
    _ = 2916 := by norm_num

end F3Block0OccurrenceNumericTotal
end KL2003
end CollatzClassical
