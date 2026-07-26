import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileCore
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSourceFiberCards

set_option maxHeartbeats 600000
set_option maxRecDepth 100000

/-!
Advanced-parity-lift-constructor shard of the exact Block0 mass-demand
histogram.

The active lift representative exists precisely at quotient-class-zero
roots.  Its fine tag is the root's missing base-three digit.  The only
exhaustive reductions are the two frozen root histogram certificates.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0MassDemandLiftShard

noncomputable section

open F3CoreArithmeticCodecPilotRepair
open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3Block0ActiveCarrierCards
open F3Block0MassDemandProfile

abbrev LiftActiveRoot :=
  {i : Block0Root // ((rootState i).1 / 3) % 3 = 0}

def liftEdge (i : LiftActiveRoot) : FormulaEdge :=
  .advancedParityLift ⟨rootState i.1, i.2⟩ (rootFineLift i.1)

def IsLiftOccurrence (p : Active0Occurrence) : Prop :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ => False
  | .advancedDirect _ _ => False
  | .advancedParityLift _ _ => True

def liftOccurrenceSlice : Finset Active0Occurrence :=
  by
    classical
    exact active0Carrier.filter IsLiftOccurrence

theorem mem_liftOccurrenceSlice_iff (p : Active0Occurrence) :
    p ∈ liftOccurrenceSlice ↔
      p ∈ active0Carrier ∧ IsLiftOccurrence p := by
  classical
  simp [liftOccurrenceSlice]

abbrev LiftActiveOccurrence :=
  {p : Active0Occurrence // IsLiftOccurrence p}

def liftActiveOccurrenceDirect
    (i : LiftActiveRoot) : Active0Occurrence :=
  ⟨⟨⟨i.1, .advancedParityLift
      ⟨rootState i.1, i.2⟩ (rootFineLift i.1)⟩, rfl⟩, rfl⟩

private def liftRootOfOccurrence
    (p : LiftActiveOccurrence) : LiftActiveRoot := by
  rcases p with ⟨⟨⟨⟨i, e⟩, hs⟩, ha⟩, hlift⟩
  cases e with
  | retarded s =>
      change False at hlift
      exact hlift.elim
  | advancedDirect s ell =>
      change False at hlift
      exact hlift.elim
  | advancedParityLift s ell =>
      refine ⟨i, ?_⟩
      have hsource : s.1 = rootState i := by
        simpa [formulaSource] using hs
      rw [← hsource]
      exact s.2

/-- Quotient-class-zero roots are exactly the active lift occurrences. -/
def liftRootEquiv : LiftActiveRoot ≃ LiftActiveOccurrence where
  toFun i :=
    ⟨liftActiveOccurrenceDirect i, by
      simp [IsLiftOccurrence, liftActiveOccurrenceDirect,
        occurrenceFormulaEdge]⟩
  invFun := liftRootOfOccurrence
  left_inv i := by
    apply Subtype.ext
    rfl
  right_inv p := by
    rcases p with ⟨⟨⟨⟨i, e⟩, hs⟩, ha⟩, hlift⟩
    cases e with
    | retarded s =>
        change False at hlift
        exact hlift.elim
    | advancedDirect s ell =>
        change False at hlift
        exact hlift.elim
    | advancedParityLift s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have hell : rootFineLift i = ell := by
          simpa [FormulaActiveAtRoot] using ha
        apply Subtype.ext
        apply Subtype.ext
        apply Subtype.ext
        apply Prod.ext
        · rfl
        · exact congrArg₂ FormulaEdge.advancedParityLift
            (Subtype.ext hsource.symm) hell

theorem liftRootEquiv_edge (i : LiftActiveRoot) :
    occurrenceFormulaEdge (liftRootEquiv i).1.1 = liftEdge i := by
  rfl

def liftDemandOneRoots : Finset LiftActiveRoot :=
  Finset.univ.filter (fun i => massDemandShadow (liftEdge i) = 1)

def liftDemandTwoRoots : Finset LiftActiveRoot :=
  Finset.univ.filter (fun i => massDemandShadow (liftEdge i) = 2)

theorem liftDemandOneRoots_card :
    liftDemandOneRoots.card = 296 := by
  decide

theorem liftDemandTwoRoots_card :
    liftDemandTwoRoots.card = 28 := by
  decide

def liftDemandOneOccurrences : Finset Active0Occurrence :=
  liftOccurrenceSlice.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 1)

def liftDemandTwoOccurrences : Finset Active0Occurrence :=
  liftOccurrenceSlice.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 2)

private theorem liftOccurrenceFilter_card_eq_rootFilter_card
    (k : Nat) :
    (liftOccurrenceSlice.filter (fun p =>
      massDemandShadow (occurrenceFormulaEdge p.1) = k)).card =
      (Finset.univ.filter (fun i : LiftActiveRoot =>
        massDemandShadow (liftEdge i) = k)).card := by
  classical
  apply Finset.card_bij (fun p hp =>
    liftRootEquiv.symm
      ⟨p, ((mem_liftOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩)
  · intro p hp
    let q : LiftActiveOccurrence :=
      ⟨p, ((mem_liftOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩
    let i : LiftActiveRoot := liftRootEquiv.symm q
    have happly : (liftRootEquiv i).1 = p := by
      exact congrArg Subtype.val (liftRootEquiv.apply_symm_apply q)
    have hedge := liftRootEquiv_edge i
    rw [happly] at hedge
    exact Finset.mem_filter.mpr
      ⟨Finset.mem_univ i, by
        rw [← hedge]
        exact (Finset.mem_filter.mp hp).2⟩
  · intro p hp q hq heq
    let pp : LiftActiveOccurrence :=
      ⟨p, ((mem_liftOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩
    let qq : LiftActiveOccurrence :=
      ⟨q, ((mem_liftOccurrenceSlice_iff q).mp
        (Finset.mem_filter.mp hq).1).2⟩
    have hpq : pp = qq := liftRootEquiv.symm.injective heq
    exact congrArg Subtype.val hpq
  · intro i hi
    let p : Active0Occurrence := (liftRootEquiv i).1
    have hpSlice : p ∈ liftOccurrenceSlice := by
      exact (mem_liftOccurrenceSlice_iff p).2
        ⟨mem_active0Carrier p, (liftRootEquiv i).2⟩
    have hpDemand :
        massDemandShadow (occurrenceFormulaEdge p.1) = k := by
      rw [liftRootEquiv_edge]
      exact (Finset.mem_filter.mp hi).2
    refine ⟨p, Finset.mem_filter.mpr ⟨hpSlice, hpDemand⟩, ?_⟩
    exact liftRootEquiv.symm_apply_apply i

theorem liftDemandOneOccurrences_card :
    liftDemandOneOccurrences.card = 296 := by
  simpa [liftDemandOneOccurrences, liftDemandOneRoots] using
    (liftOccurrenceFilter_card_eq_rootFilter_card 1).trans
      liftDemandOneRoots_card

theorem liftDemandTwoOccurrences_card :
    liftDemandTwoOccurrences.card = 28 := by
  simpa [liftDemandTwoOccurrences, liftDemandTwoRoots] using
    (liftOccurrenceFilter_card_eq_rootFilter_card 2).trans
      liftDemandTwoRoots_card

def liftShadowSum : Nat :=
  ∑ p in liftOccurrenceSlice,
    massDemandShadow (occurrenceFormulaEdge p.1)

theorem liftShadowSum_eq_352 : liftShadowSum = 352 := by
  classical
  have hsplit :
      liftOccurrenceSlice =
        liftDemandOneOccurrences ∪ liftDemandTwoOccurrences := by
    ext p
    by_cases h :
        qHiNumerator (occurrenceFormulaEdge p.1) ≤
          qHiDenominator (occurrenceFormulaEdge p.1)
    · simp [liftDemandOneOccurrences, liftDemandTwoOccurrences,
        massDemandShadow, h]
    · have hlt :
          qHiDenominator (occurrenceFormulaEdge p.1) <
            qHiNumerator (occurrenceFormulaEdge p.1) :=
        Nat.lt_of_not_ge h
      simp [liftDemandOneOccurrences, liftDemandTwoOccurrences,
        massDemandShadow, h, hlt]
  have hdisjoint :
      Disjoint liftDemandOneOccurrences liftDemandTwoOccurrences := by
    refine Finset.disjoint_left.mpr ?_
    intro p hOne hTwo
    have h1 := (Finset.mem_filter.mp hOne).2
    have h2 := (Finset.mem_filter.mp hTwo).2
    omega
  have hsumOne :
      (∑ p in liftDemandOneOccurrences,
        massDemandShadow (occurrenceFormulaEdge p.1)) =
          liftDemandOneOccurrences.card := by
    calc
      _ = ∑ _p in liftDemandOneOccurrences, 1 := by
        apply Finset.sum_congr rfl
        intro p hp
        exact (Finset.mem_filter.mp hp).2
      _ = liftDemandOneOccurrences.card := by simp
  have hsumTwo :
      (∑ p in liftDemandTwoOccurrences,
        massDemandShadow (occurrenceFormulaEdge p.1)) =
          liftDemandTwoOccurrences.card * 2 := by
    calc
      _ = ∑ _p in liftDemandTwoOccurrences, 2 := by
        apply Finset.sum_congr rfl
        intro p hp
        exact (Finset.mem_filter.mp hp).2
      _ = liftDemandTwoOccurrences.card * 2 := by simp
  rw [liftShadowSum, hsplit, Finset.sum_union hdisjoint,
    hsumOne, hsumTwo, liftDemandOneOccurrences_card,
    liftDemandTwoOccurrences_card]

end

/-!
Scope: exact advanced-parity-lift histogram and structural transfer only.
No first-hit, capacity, rho, exponent, density, or global Collatz claim.
-/

end F3Block0MassDemandLiftShard
end KL2003
end CollatzClassical
