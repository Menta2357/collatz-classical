import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSeenTotal

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Structural cardinalities of the active one-layer Block0 carrier.

This final layer computes the inspected-prefix total and derives the fresh
complement.  The source-fibre and total-cardinality proofs live in the two
preceding structural modules.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveCarrierCards

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0CarrierFiberCards
open F3Block0OccurrenceCards
open F3Block0OccurrenceTripleWeights
open F3Block0ActiveCarrier
open F3CoreArithmeticCodecPilotRepair

theorem seenActive0Occurrence_card :
    Fintype.card SeenActive0Occurrence = 68 := by
  rw [Fintype.card_congr seenActive0OccurrenceSigmaEquiv]
  rw [Fintype.card_sigma]
  exact activeSourceFormulaEdge_seen_sum

abbrev FreshActive0Occurrence :=
  {p : Active0Occurrence //
    ¬ rootValue (occurrenceRoot p.1) < 128}

theorem freshActive0Occurrence_card :
    Fintype.card FreshActive0Occurrence = 1552 := by
  rw [Fintype.card_subtype_compl]
  rw [active0Occurrence_card, seenActive0Occurrence_card]

end F3Block0ActiveCarrierCards
end KL2003
end CollatzClassical
