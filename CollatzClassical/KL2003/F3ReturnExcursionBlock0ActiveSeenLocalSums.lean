import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSeenCarrier

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-! Local active-occurrence sums on the triple and two-point seen blocks. -/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveCarrierCards

open F3Block0Carrier

theorem activeSourceFormulaEdge_seenSplit_left_sum (k : Fin 13) :
    (∑ r : Fin 3,
      Fintype.card (ActiveSourceFormulaEdge
        (seenRoot (seenIndexSplitEquiv (Sum.inl (k, r)))))) = 5 := by
  rw [Fin.sum_univ_three]
  simp only [activeSourceFormulaEdge_card,
    rootState_quotient_mod_three_seenSplit_left]
  norm_num

theorem activeSourceFormulaEdge_seenSplit_right_sum :
    (∑ u : Fin 2,
      Fintype.card (ActiveSourceFormulaEdge
        (seenRoot (seenIndexSplitEquiv (Sum.inr u))))) = 3 := by
  rw [Fin.sum_univ_two]
  simp only [activeSourceFormulaEdge_card,
    rootState_quotient_mod_three_seenSplit_right]
  norm_num

end F3Block0ActiveCarrierCards
end KL2003
end CollatzClassical
