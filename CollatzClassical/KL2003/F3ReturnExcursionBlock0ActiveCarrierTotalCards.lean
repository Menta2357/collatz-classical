import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSourceFiberCards

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-! Exact total cardinality of the active one-layer Block0 carrier. -/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveCarrierCards

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0OccurrenceTripleWeights
open F3Block0ActiveCarrier

theorem activeSourceFormulaEdge_triple_sum (k : Fin 324) :
    (∑ r : Fin 3,
      Fintype.card (ActiveSourceFormulaEdge
        (block0RootTripleEquiv (k, r)))) = 5 := by
  rw [Fin.sum_univ_three]
  simp only [activeSourceFormulaEdge_card,
    rootState_quotient_mod_three_triple]
  norm_num

theorem active0Occurrence_card :
    Fintype.card Active0Occurrence = 1620 := by
  rw [active0Occurrence_card_eq_sum_sourceFibers]
  rw [← block0RootTripleEquiv.sum_comp
    (fun i : Block0Root =>
      Fintype.card (ActiveSourceFormulaEdge i))]
  rw [Fintype.sum_prod_type]
  calc
    (∑ k : Fin 324, ∑ r : Fin 3,
      Fintype.card (ActiveSourceFormulaEdge
        (block0RootTripleEquiv (k, r)))) =
        ∑ _k : Fin 324, 5 := by
      apply Finset.sum_congr rfl
      intro k hk
      exact activeSourceFormulaEdge_triple_sum k
    _ = 324 * 5 := by simp
    _ = 1620 := by norm_num

theorem active0Carrier_card :
    active0Carrier.card = 1620 := by
  simpa [active0Carrier] using active0Occurrence_card

end F3Block0ActiveCarrierCards
end KL2003
end CollatzClassical
