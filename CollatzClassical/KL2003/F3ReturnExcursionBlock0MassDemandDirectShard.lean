import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileCore
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSourceFiberCards

set_option maxHeartbeats 600000
set_option maxRecDepth 100000

/-!
Advanced-direct-constructor shard of the exact Block0 mass-demand histogram.

The active direct representative exists precisely at quotient-class-two
roots.  Its fine tag is the root's missing base-three digit.  The only
exhaustive reductions are the two frozen root histogram certificates.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0MassDemandDirectShard

noncomputable section

open F3CoreArithmeticCodecPilotRepair
open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3Block0ActiveCarrierCards
open F3Block0MassDemandProfile

abbrev DirectActiveRoot :=
  {i : Block0Root // ((rootState i).1 / 3) % 3 = 2}

def directEdge (i : DirectActiveRoot) : FormulaEdge :=
  .advancedDirect ⟨rootState i.1, i.2⟩ (rootFineLift i.1)

def IsDirectOccurrence (p : Active0Occurrence) : Prop :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ => False
  | .advancedDirect _ _ => True
  | .advancedParityLift _ _ => False

def directOccurrenceSlice : Finset Active0Occurrence :=
  by
    classical
    exact active0Carrier.filter IsDirectOccurrence

theorem mem_directOccurrenceSlice_iff (p : Active0Occurrence) :
    p ∈ directOccurrenceSlice ↔
      p ∈ active0Carrier ∧ IsDirectOccurrence p := by
  classical
  simp [directOccurrenceSlice]

abbrev DirectActiveOccurrence :=
  {p : Active0Occurrence // IsDirectOccurrence p}

def directActiveOccurrenceDirect
    (i : DirectActiveRoot) : Active0Occurrence :=
  ⟨⟨⟨i.1, .advancedDirect
      ⟨rootState i.1, i.2⟩ (rootFineLift i.1)⟩, rfl⟩, rfl⟩

private def directRootOfOccurrence
    (p : DirectActiveOccurrence) : DirectActiveRoot := by
  rcases p with ⟨⟨⟨⟨i, e⟩, hs⟩, ha⟩, hdirect⟩
  cases e with
  | retarded s =>
      change False at hdirect
      exact hdirect.elim
  | advancedDirect s ell =>
      refine ⟨i, ?_⟩
      have hsource : s.1 = rootState i := by
        simpa [formulaSource] using hs
      rw [← hsource]
      exact s.2
  | advancedParityLift s ell =>
      change False at hdirect
      exact hdirect.elim

/-- Quotient-class-two roots are exactly the active direct occurrences. -/
def directRootEquiv : DirectActiveRoot ≃ DirectActiveOccurrence where
  toFun i :=
    ⟨directActiveOccurrenceDirect i, by
      simp [IsDirectOccurrence, directActiveOccurrenceDirect,
        occurrenceFormulaEdge]⟩
  invFun := directRootOfOccurrence
  left_inv i := by
    apply Subtype.ext
    rfl
  right_inv p := by
    rcases p with ⟨⟨⟨⟨i, e⟩, hs⟩, ha⟩, hdirect⟩
    cases e with
    | retarded s =>
        change False at hdirect
        exact hdirect.elim
    | advancedDirect s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have hell : rootFineLift i = ell := by
          simpa [FormulaActiveAtRoot] using ha
        apply Subtype.ext
        apply Subtype.ext
        apply Subtype.ext
        apply Prod.ext
        · rfl
        · exact congrArg₂ FormulaEdge.advancedDirect
            (Subtype.ext hsource.symm) hell
    | advancedParityLift s ell =>
        change False at hdirect
        exact hdirect.elim

theorem directRootEquiv_edge (i : DirectActiveRoot) :
    occurrenceFormulaEdge (directRootEquiv i).1.1 = directEdge i := by
  rfl

def directDemandOneRoots : Finset DirectActiveRoot :=
  Finset.univ.filter (fun i => massDemandShadow (directEdge i) = 1)

def directDemandTwoRoots : Finset DirectActiveRoot :=
  Finset.univ.filter (fun i => massDemandShadow (directEdge i) = 2)

theorem directDemandOneRoots_card :
    directDemandOneRoots.card = 224 := by
  decide

theorem directDemandTwoRoots_card :
    directDemandTwoRoots.card = 100 := by
  decide

def directDemandOneOccurrences : Finset Active0Occurrence :=
  directOccurrenceSlice.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 1)

def directDemandTwoOccurrences : Finset Active0Occurrence :=
  directOccurrenceSlice.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 2)

private theorem directOccurrenceFilter_card_eq_rootFilter_card
    (k : Nat) :
    (directOccurrenceSlice.filter (fun p =>
      massDemandShadow (occurrenceFormulaEdge p.1) = k)).card =
      (Finset.univ.filter (fun i : DirectActiveRoot =>
        massDemandShadow (directEdge i) = k)).card := by
  classical
  apply Finset.card_bij (fun p hp =>
    directRootEquiv.symm
      ⟨p, ((mem_directOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩)
  · intro p hp
    let q : DirectActiveOccurrence :=
      ⟨p, ((mem_directOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩
    let i : DirectActiveRoot := directRootEquiv.symm q
    have happly : (directRootEquiv i).1 = p := by
      exact congrArg Subtype.val (directRootEquiv.apply_symm_apply q)
    have hedge := directRootEquiv_edge i
    rw [happly] at hedge
    exact Finset.mem_filter.mpr
      ⟨Finset.mem_univ i, by
        rw [← hedge]
        exact (Finset.mem_filter.mp hp).2⟩
  · intro p hp q hq heq
    let pp : DirectActiveOccurrence :=
      ⟨p, ((mem_directOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩
    let qq : DirectActiveOccurrence :=
      ⟨q, ((mem_directOccurrenceSlice_iff q).mp
        (Finset.mem_filter.mp hq).1).2⟩
    have hpq : pp = qq := directRootEquiv.symm.injective heq
    exact congrArg Subtype.val hpq
  · intro i hi
    let p : Active0Occurrence := (directRootEquiv i).1
    have hpSlice : p ∈ directOccurrenceSlice := by
      exact (mem_directOccurrenceSlice_iff p).2
        ⟨mem_active0Carrier p, (directRootEquiv i).2⟩
    have hpDemand :
        massDemandShadow (occurrenceFormulaEdge p.1) = k := by
      rw [directRootEquiv_edge]
      exact (Finset.mem_filter.mp hi).2
    refine ⟨p, Finset.mem_filter.mpr ⟨hpSlice, hpDemand⟩, ?_⟩
    exact directRootEquiv.symm_apply_apply i

theorem directDemandOneOccurrences_card :
    directDemandOneOccurrences.card = 224 := by
  simpa [directDemandOneOccurrences, directDemandOneRoots] using
    (directOccurrenceFilter_card_eq_rootFilter_card 1).trans
      directDemandOneRoots_card

theorem directDemandTwoOccurrences_card :
    directDemandTwoOccurrences.card = 100 := by
  simpa [directDemandTwoOccurrences, directDemandTwoRoots] using
    (directOccurrenceFilter_card_eq_rootFilter_card 2).trans
      directDemandTwoRoots_card

def directShadowSum : Nat :=
  ∑ p in directOccurrenceSlice,
    massDemandShadow (occurrenceFormulaEdge p.1)

theorem directShadowSum_eq_424 : directShadowSum = 424 := by
  classical
  have hsplit :
      directOccurrenceSlice =
        directDemandOneOccurrences ∪ directDemandTwoOccurrences := by
    ext p
    by_cases h :
        qHiNumerator (occurrenceFormulaEdge p.1) ≤
          qHiDenominator (occurrenceFormulaEdge p.1)
    · simp [directDemandOneOccurrences, directDemandTwoOccurrences,
        massDemandShadow, h]
    · have hlt :
          qHiDenominator (occurrenceFormulaEdge p.1) <
            qHiNumerator (occurrenceFormulaEdge p.1) :=
        Nat.lt_of_not_ge h
      simp [directDemandOneOccurrences, directDemandTwoOccurrences,
        massDemandShadow, h, hlt]
  have hdisjoint :
      Disjoint directDemandOneOccurrences directDemandTwoOccurrences := by
    refine Finset.disjoint_left.mpr ?_
    intro p hOne hTwo
    have h1 := (Finset.mem_filter.mp hOne).2
    have h2 := (Finset.mem_filter.mp hTwo).2
    omega
  have hsumOne :
      (∑ p in directDemandOneOccurrences,
        massDemandShadow (occurrenceFormulaEdge p.1)) =
          directDemandOneOccurrences.card := by
    calc
      _ = ∑ _p in directDemandOneOccurrences, 1 := by
        apply Finset.sum_congr rfl
        intro p hp
        exact (Finset.mem_filter.mp hp).2
      _ = directDemandOneOccurrences.card := by simp
  have hsumTwo :
      (∑ p in directDemandTwoOccurrences,
        massDemandShadow (occurrenceFormulaEdge p.1)) =
          directDemandTwoOccurrences.card * 2 := by
    calc
      _ = ∑ _p in directDemandTwoOccurrences, 2 := by
        apply Finset.sum_congr rfl
        intro p hp
        exact (Finset.mem_filter.mp hp).2
      _ = directDemandTwoOccurrences.card * 2 := by simp
  rw [directShadowSum, hsplit, Finset.sum_union hdisjoint,
    hsumOne, hsumTwo, directDemandOneOccurrences_card,
    directDemandTwoOccurrences_card]

end

/-!
Scope: exact advanced-direct histogram and structural transfer only.
No first-hit, capacity, rho, exponent, density, or global Collatz claim.
-/

end F3Block0MassDemandDirectShard
end KL2003
end CollatzClassical
