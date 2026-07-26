import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileCore
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveSourceFiberCards

set_option maxHeartbeats 600000
set_option maxRecDepth 100000

/-!
Retarded-constructor shard of the exact Block0 mass-demand histogram.

The only exhaustive reductions in this file are the two frozen root-indexed
cardinality certificates.  Transfer to active occurrences is structural,
through `active0OccurrenceSigmaEquiv`; the mass total is then ordinary
two-valued arithmetic.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0MassDemandRetardedShard

noncomputable section

open F3CoreArithmeticCodecPilotRepair
open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3Block0ActiveCarrierCards
open F3Block0MassDemandProfile

abbrev RetardedActiveRoot := Block0Root

def retardedEdge (i : RetardedActiveRoot) : FormulaEdge :=
  .retarded (rootState i)

def IsRetardedOccurrence (p : Active0Occurrence) : Prop :=
  match occurrenceFormulaEdge p.1 with
  | .retarded _ => True
  | .advancedDirect _ _ => False
  | .advancedParityLift _ _ => False

def retardedOccurrenceSlice : Finset Active0Occurrence :=
  by
    classical
    exact active0Carrier.filter IsRetardedOccurrence

theorem mem_retardedOccurrenceSlice_iff (p : Active0Occurrence) :
    p ∈ retardedOccurrenceSlice ↔
      p ∈ active0Carrier ∧ IsRetardedOccurrence p := by
  classical
  simp [retardedOccurrenceSlice]

abbrev RetardedActiveOccurrence :=
  {p : Active0Occurrence // IsRetardedOccurrence p}

def retardedActiveOccurrenceDirect
    (i : RetardedActiveRoot) : Active0Occurrence :=
  ⟨⟨⟨i, .retarded (rootState i)⟩, rfl⟩, trivial⟩

/-- Every root has exactly one active retarded occurrence. -/
def retardedRootEquiv :
    RetardedActiveRoot ≃ RetardedActiveOccurrence where
  toFun i :=
    ⟨retardedActiveOccurrenceDirect i, by
      simp [IsRetardedOccurrence, retardedActiveOccurrenceDirect,
        occurrenceFormulaEdge]⟩
  invFun p := occurrenceRoot p.1.1
  left_inv i := rfl
  right_inv p := by
    rcases p with ⟨⟨⟨⟨i, e⟩, hs⟩, ha⟩, hret⟩
    cases e with
    | retarded s =>
        have hsource : s = rootState i := by
          simpa [formulaSource] using hs
        subst s
        rfl
    | advancedDirect s ell =>
        change False at hret
        exact hret.elim
    | advancedParityLift s ell =>
        change False at hret
        exact hret.elim

theorem retardedRootEquiv_edge (i : RetardedActiveRoot) :
    occurrenceFormulaEdge (retardedRootEquiv i).1.1 = retardedEdge i := by
  rfl

def retardedDemandOneRoots : Finset RetardedActiveRoot :=
  Finset.univ.filter (fun i => massDemandShadow (retardedEdge i) = 1)

def retardedDemandTwoRoots : Finset RetardedActiveRoot :=
  Finset.univ.filter (fun i => massDemandShadow (retardedEdge i) = 2)

theorem retardedDemandOneRoots_card :
    retardedDemandOneRoots.card = 648 := by
  decide

theorem retardedDemandTwoRoots_card :
    retardedDemandTwoRoots.card = 324 := by
  decide

def retardedDemandOneOccurrences : Finset Active0Occurrence :=
  retardedOccurrenceSlice.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 1)

def retardedDemandTwoOccurrences : Finset Active0Occurrence :=
  retardedOccurrenceSlice.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 2)

private theorem retardedOccurrenceFilter_card_eq_rootFilter_card
    (k : Nat) :
    (retardedOccurrenceSlice.filter (fun p =>
      massDemandShadow (occurrenceFormulaEdge p.1) = k)).card =
      (Finset.univ.filter (fun i : RetardedActiveRoot =>
        massDemandShadow (retardedEdge i) = k)).card := by
  classical
  apply Finset.card_bij (fun p hp =>
    retardedRootEquiv.symm
      ⟨p, ((mem_retardedOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩)
  · intro p hp
    let q : RetardedActiveOccurrence :=
      ⟨p, ((mem_retardedOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩
    let i : RetardedActiveRoot := retardedRootEquiv.symm q
    have happly : (retardedRootEquiv i).1 = p := by
      exact congrArg Subtype.val (retardedRootEquiv.apply_symm_apply q)
    have hedge := retardedRootEquiv_edge i
    rw [happly] at hedge
    exact Finset.mem_filter.mpr
      ⟨Finset.mem_univ i, by
        rw [← hedge]
        exact (Finset.mem_filter.mp hp).2⟩
  · intro p hp q hq heq
    let pp : RetardedActiveOccurrence :=
      ⟨p, ((mem_retardedOccurrenceSlice_iff p).mp
        (Finset.mem_filter.mp hp).1).2⟩
    let qq : RetardedActiveOccurrence :=
      ⟨q, ((mem_retardedOccurrenceSlice_iff q).mp
        (Finset.mem_filter.mp hq).1).2⟩
    have hpq : pp = qq := retardedRootEquiv.symm.injective heq
    exact congrArg Subtype.val hpq
  · intro i hi
    let p : Active0Occurrence := (retardedRootEquiv i).1
    have hpSlice : p ∈ retardedOccurrenceSlice := by
      exact (mem_retardedOccurrenceSlice_iff p).2
        ⟨mem_active0Carrier p, (retardedRootEquiv i).2⟩
    have hpDemand :
        massDemandShadow (occurrenceFormulaEdge p.1) = k := by
      rw [retardedRootEquiv_edge]
      exact (Finset.mem_filter.mp hi).2
    refine ⟨p, Finset.mem_filter.mpr ⟨hpSlice, hpDemand⟩, ?_⟩
    exact retardedRootEquiv.symm_apply_apply i

theorem retardedDemandOneOccurrences_card :
    retardedDemandOneOccurrences.card = 648 := by
  simpa [retardedDemandOneOccurrences, retardedDemandOneRoots] using
    (retardedOccurrenceFilter_card_eq_rootFilter_card 1).trans
      retardedDemandOneRoots_card

theorem retardedDemandTwoOccurrences_card :
    retardedDemandTwoOccurrences.card = 324 := by
  simpa [retardedDemandTwoOccurrences, retardedDemandTwoRoots] using
    (retardedOccurrenceFilter_card_eq_rootFilter_card 2).trans
      retardedDemandTwoRoots_card

def retardedShadowSum : Nat :=
  ∑ p in retardedOccurrenceSlice,
    massDemandShadow (occurrenceFormulaEdge p.1)

theorem retardedShadowSum_eq_1296 :
    retardedShadowSum = 1296 := by
  classical
  have hsplit :
      retardedOccurrenceSlice =
        retardedDemandOneOccurrences ∪ retardedDemandTwoOccurrences := by
    ext p
    by_cases h :
        qHiNumerator (occurrenceFormulaEdge p.1) ≤
          qHiDenominator (occurrenceFormulaEdge p.1)
    · simp [retardedDemandOneOccurrences, retardedDemandTwoOccurrences,
        massDemandShadow, h]
    · have hlt :
          qHiDenominator (occurrenceFormulaEdge p.1) <
            qHiNumerator (occurrenceFormulaEdge p.1) :=
        Nat.lt_of_not_ge h
      simp [retardedDemandOneOccurrences, retardedDemandTwoOccurrences,
        massDemandShadow, h, hlt]
  have hdisjoint :
      Disjoint retardedDemandOneOccurrences
        retardedDemandTwoOccurrences := by
    refine Finset.disjoint_left.mpr ?_
    intro p hOne hTwo
    have h1 := (Finset.mem_filter.mp hOne).2
    have h2 := (Finset.mem_filter.mp hTwo).2
    omega
  have hsumOne :
      (∑ p in retardedDemandOneOccurrences,
        massDemandShadow (occurrenceFormulaEdge p.1)) =
          retardedDemandOneOccurrences.card := by
    calc
      _ = ∑ _p in retardedDemandOneOccurrences, 1 := by
        apply Finset.sum_congr rfl
        intro p hp
        exact (Finset.mem_filter.mp hp).2
      _ = retardedDemandOneOccurrences.card := by simp
  have hsumTwo :
      (∑ p in retardedDemandTwoOccurrences,
        massDemandShadow (occurrenceFormulaEdge p.1)) =
          retardedDemandTwoOccurrences.card * 2 := by
    calc
      _ = ∑ _p in retardedDemandTwoOccurrences, 2 := by
        apply Finset.sum_congr rfl
        intro p hp
        exact (Finset.mem_filter.mp hp).2
      _ = retardedDemandTwoOccurrences.card * 2 := by simp
  rw [retardedShadowSum, hsplit, Finset.sum_union hdisjoint,
    hsumOne, hsumTwo, retardedDemandOneOccurrences_card,
    retardedDemandTwoOccurrences_card]

end

/-!
Scope: exact retarded-constructor histogram and structural transfer only.
No first-hit, capacity, rho, exponent, density, or global Collatz claim.
-/

end F3Block0MassDemandRetardedShard
end KL2003
end CollatzClassical
