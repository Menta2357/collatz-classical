import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSeenLocalSums

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-! Exact active-occurrence total on the 41-root inspected prefix. -/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveCarrierCards

open F3Block0Carrier

theorem activeSourceFormulaEdge_seen_sum :
    (∑ j : Block0SeenIndex,
      Fintype.card (ActiveSourceFormulaEdge (seenRoot j))) = 68 := by
  rw [← seenIndexSplitEquiv.sum_comp
    (fun j : Block0SeenIndex =>
      Fintype.card (ActiveSourceFormulaEdge (seenRoot j)))]
  rw [Fintype.sum_sum_type, Fintype.sum_prod_type]
  calc
    _ = (∑ _k : Fin 13, 5) + 3 := by
      apply congrArg₂ (· + ·)
      · apply Finset.sum_congr rfl
        intro k hk
        exact activeSourceFormulaEdge_seenSplit_left_sum k
      · exact activeSourceFormulaEdge_seenSplit_right_sum
    _ = 68 := by norm_num

end F3Block0ActiveCarrierCards
end KL2003
end CollatzClassical
