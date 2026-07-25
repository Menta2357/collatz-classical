import CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceNumericTotal

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Exact cardinality of the root-tagged Block0 formula-occurrence carrier.

The proof first double-counts by roots, then reindexes the 972 roots as
`Fin 324 × Fin 3`.  The three local formula-fibre weights are 1, 4, and 4,
so every `Fin 324` row contributes 9 occurrences.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0OccurrenceTotal

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0OccurrenceNumericTotal

theorem block0Occurrence_card_eq_carrier :
    Fintype.card Block0Occurrence = block0OccurrenceCarrier.card := by
  exact Fintype.card_of_subtype block0OccurrenceCarrier
    mem_block0OccurrenceCarrier_iff

theorem block0OccurrenceCarrier_card :
    block0OccurrenceCarrier.card = 2916 := by
  rw [← block0Occurrence_card_eq_carrier, block0Occurrence_card]

end F3Block0OccurrenceTotal
end KL2003
end CollatzClassical
