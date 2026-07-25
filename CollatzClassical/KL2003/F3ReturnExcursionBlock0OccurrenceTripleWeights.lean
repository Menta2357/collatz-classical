import CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceSigmaCards

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
The local three-residue weights for Block0 formula occurrences.

This module contains the reindexing `Fin 972 ≃ Fin 324 × Fin 3` and proves
that every fixed `Fin 324` coordinate contributes `1 + 4 + 4 = 9`.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0OccurrenceTripleWeights

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0CarrierFiberCards
open F3Block0OccurrenceCards
open F3Block0FormulaFiberCards
open scoped BigOperators

def block0RootTripleEquiv : Fin 324 × Fin 3 ≃ Block0Root :=
  finProdFinEquiv

theorem rootState_quotient_mod_three (i : Block0Root) :
    ((rootState i).1 / 3) % 3 = (i.1 + 1) % 3 := by
  rw [rootState_div_three]
  rw [Nat.mod_mod_of_dvd (i.1 + 1) (by norm_num : 3 ∣ 81)]

theorem rootState_quotient_mod_three_triple (k : Fin 324) (r : Fin 3) :
    ((rootState (block0RootTripleEquiv (k, r))).1 / 3) % 3 =
      (r.1 + 1) % 3 := by
  rw [rootState_quotient_mod_three]
  change (r.1 + 3 * k.1 + 1) % 3 = (r.1 + 1) % 3
  omega

theorem sourceFormulaEdge_triple_sum (k : Fin 324) :
    (∑ r : Fin 3,
      Fintype.card (SourceFormulaEdge
        (rootState (block0RootTripleEquiv (k, r))))) = 9 := by
  rw [Fin.sum_univ_three]
  simp only [sourceFormulaEdge_card, rootState_quotient_mod_three_triple]
  norm_num

end F3Block0OccurrenceTripleWeights
end KL2003
end CollatzClassical
