import CollatzClassical.KL2003.F3ReturnExcursionBlock0OrderedFirstHit
import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassAtoms

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
# The semantic child is the depth-zero ordered first-hit witness

For every active Block0 occurrence, its semantic child starts inside the child
window, avoids the parent at time zero, and follows the fixed channel suffix to
its first visit to the parent.  This supplies the base point needed by reverse
predecessor closure arguments.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0SemanticChildBaseHit

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3CoreArithmeticCodecPilotRepair
open F3Block0OrderedFirstHit
open F3Block0MassAtoms

/-- The semantic child itself realizes the ordered specification at reverse
depth zero. -/
theorem semanticChildRoot_firstHitViaChildAt_zero
    (p : Active0Occurrence) :
    FirstHitViaChildAt p (semanticChildRoot p) 0 := by
  have hparentPos : 1 ≤ parentRoot p := by
    exact le_trans (by omega : 1 ≤ 3)
      (rootValue_lower (occurrenceRoot p.1))
  have hinverseLower : 3 ≤ inverseChildRoot p := by
    simp only [inverseChildRoot]
    omega
  have hinversePos : 1 ≤ inverseChildRoot p :=
    le_trans (by omega) hinverseLower
  unfold FirstHitViaChildAt
  cases hedge : occurrenceFormulaEdge p.1 with
  | retarded s =>
      refine ⟨by simp, ?_, ?_, channelSuffix_proved p, ?_⟩
      · intro j hj
        have hjzero : j = 0 := by omega
        subst j
        simp only [Function.iterate_zero_apply, semanticChildRoot,
          hedge, childWindow0, parentWindow0]
        omega
      · intro j hj
        have hjzero : j = 0 := by omega
        subst j
        simp only [Function.iterate_zero_apply, semanticChildRoot, hedge]
        omega
      · simp only [Nat.zero_add, suffixLength, hedge,
          semanticChildRoot, FirstHitsAt]
        refine ⟨two_branch_T_two_steps_four_mul (parentRoot p), ?_⟩
        intro j hj
        have hjcases : j = 0 ∨ j = 1 := by omega
        rcases hjcases with rfl | rfl
        · simp only [Function.iterate_zero_apply]
          omega
        · simpa only [Function.iterate_one, two_branch_T_four_mul] using
            two_branch_root_ne_retarded_child hparentPos
  | advancedDirect s ell =>
      have harith := inverseChildRoot_arithmetic p
      have hchildNe : inverseChildRoot p ≠ parentRoot p :=
        two_branch_advanced_child_ne_root harith
      refine ⟨by simp, ?_, ?_, channelSuffix_proved p, ?_⟩
      · intro j hj
        have hjzero : j = 0 := by omega
        subst j
        simp only [Function.iterate_zero_apply, semanticChildRoot,
          hedge, childWindow0]
        omega
      · intro j hj
        have hjzero : j = 0 := by omega
        subst j
        simpa only [Function.iterate_zero_apply, semanticChildRoot, hedge]
          using hchildNe
      · simp only [Nat.zero_add, suffixLength, hedge,
          semanticChildRoot, FirstHitsAt]
        refine ⟨?_, ?_⟩
        · simpa only [Function.iterate_one] using
            two_branch_advanced_child_maps_to_root harith
        · intro j hj
          have hjzero : j = 0 := by omega
          subst j
          simpa only [Function.iterate_zero_apply] using hchildNe
  | advancedParityLift s ell =>
      have harith := inverseChildRoot_arithmetic p
      have hchildNe : inverseChildRoot p ≠ parentRoot p :=
        two_branch_advanced_child_ne_root harith
      have hliftNe : 2 * inverseChildRoot p ≠ parentRoot p := by
        intro heq
        omega
      refine ⟨by simp, ?_, ?_, channelSuffix_proved p, ?_⟩
      · intro j hj
        have hjzero : j = 0 := by omega
        subst j
        simp only [Function.iterate_zero_apply, semanticChildRoot,
          hedge, childWindow0]
        omega
      · intro j hj
        have hjzero : j = 0 := by omega
        subst j
        simpa only [Function.iterate_zero_apply, semanticChildRoot, hedge]
          using hliftNe
      · simp only [Nat.zero_add, suffixLength, hedge,
          semanticChildRoot, FirstHitsAt]
        refine ⟨?_, ?_⟩
        · calc
            T^[2] (2 * inverseChildRoot p) =
                T (T (2 * inverseChildRoot p)) := by rfl
            _ = T (inverseChildRoot p) := by
              rw [two_branch_T_two_mul]
            _ = parentRoot p :=
              two_branch_advanced_child_maps_to_root harith
        · intro j hj
          have hjcases : j = 0 ∨ j = 1 := by omega
          rcases hjcases with rfl | rfl
          · simpa only [Function.iterate_zero_apply] using hliftNe
          · simpa only [Function.iterate_one, two_branch_T_two_mul] using
              hchildNe

/-- Hence the semantic child is a member of its occurrence's ordered finite
first-hit fibre. -/
theorem semanticChildRoot_mem_orderedFirstHitFiber0
    (p : Active0Occurrence) :
    semanticChildRoot p ∈ orderedFirstHitFiber0 p := by
  have hbase := semanticChildRoot_firstHitViaChildAt_zero p
  have hzero := hbase.2.1 0 (Nat.zero_le 0)
  rw [mem_orderedFirstHitFiber0_iff]
  exact
    ⟨by simpa using hzero.2,
      by simpa using hzero.1,
      ⟨0, hbase⟩⟩

/-- The depth-zero semantic child completely serves every owner whose exact
mass demand is one. -/
theorem massDemand_le_orderedFirstHitFiber0_card_of_eq_one
    (p : Active0Occurrence) (hdemand : massDemand p = 1) :
    massDemand p ≤ (orderedFirstHitFiber0 p).card := by
  rw [hdemand]
  exact Finset.one_le_card.2
    ⟨semanticChildRoot p,
      semanticChildRoot_mem_orderedFirstHitFiber0 p⟩

/-!
This module proves only the depth-zero base witness.  It performs no reverse
search, capacity count, mass comparison, exponent, or density argument.
-/

end F3Block0SemanticChildBaseHit
end KL2003
end CollatzClassical
