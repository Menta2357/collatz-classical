import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandRetardedShard
import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandDirectShard
import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandLiftShard

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Structural assembly of the three constructor shards for the exact Block0
mass-demand profile.

No exhaustive reduction occurs here.  Constructor disjointness and
exhaustion are proved by cases; the global cards and mass are sums of the six
frozen shard cards.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0MassDemandProfile

noncomputable section

open F3CoreArithmeticCodecPilotRepair
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3Block0MassAtoms
open F3Block0MassDemandRetardedShard
open F3Block0MassDemandDirectShard
open F3Block0MassDemandLiftShard

theorem constructorSlices_pairwiseDisjoint :
    Disjoint retardedOccurrenceSlice directOccurrenceSlice ∧
      Disjoint retardedOccurrenceSlice liftOccurrenceSlice ∧
      Disjoint directOccurrenceSlice liftOccurrenceSlice := by
  classical
  constructor
  · refine Finset.disjoint_left.mpr ?_
    intro p hr hd
    have hr' := (Finset.mem_filter.mp hr).2
    have hd' := (Finset.mem_filter.mp hd).2
    cases h : occurrenceFormulaEdge p.1 <;>
      simp [IsRetardedOccurrence, IsDirectOccurrence, h] at hr' hd'
  constructor
  · refine Finset.disjoint_left.mpr ?_
    intro p hr hl
    have hr' := (Finset.mem_filter.mp hr).2
    have hl' := (Finset.mem_filter.mp hl).2
    cases h : occurrenceFormulaEdge p.1 <;>
      simp [IsRetardedOccurrence, IsLiftOccurrence, h] at hr' hl'
  · refine Finset.disjoint_left.mpr ?_
    intro p hd hl
    have hd' := (Finset.mem_filter.mp hd).2
    have hl' := (Finset.mem_filter.mp hl).2
    cases h : occurrenceFormulaEdge p.1 <;>
      simp [IsDirectOccurrence, IsLiftOccurrence, h] at hd' hl'

theorem constructorSlices_exhaust_active0Carrier :
    (retardedOccurrenceSlice ∪ directOccurrenceSlice) ∪
        liftOccurrenceSlice = active0Carrier := by
  classical
  ext p
  cases h : occurrenceFormulaEdge p.1 <;>
    simp [retardedOccurrenceSlice, directOccurrenceSlice,
      liftOccurrenceSlice, IsRetardedOccurrence, IsDirectOccurrence,
      IsLiftOccurrence, active0Carrier, h]

def shadowDemandOneCarrier : Finset Active0Occurrence :=
  active0Carrier.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 1)

def shadowDemandTwoCarrier : Finset Active0Occurrence :=
  active0Carrier.filter (fun p =>
    massDemandShadow (occurrenceFormulaEdge p.1) = 2)

theorem shadowDemandOneCarrier_eq_constructorUnion :
    shadowDemandOneCarrier =
      (retardedDemandOneOccurrences ∪ directDemandOneOccurrences) ∪
        liftDemandOneOccurrences := by
  classical
  ext p
  cases h : occurrenceFormulaEdge p.1 <;>
    simp [shadowDemandOneCarrier, retardedDemandOneOccurrences,
      directDemandOneOccurrences, liftDemandOneOccurrences,
      retardedOccurrenceSlice, directOccurrenceSlice,
      liftOccurrenceSlice, IsRetardedOccurrence, IsDirectOccurrence,
      IsLiftOccurrence, active0Carrier, h]

theorem shadowDemandTwoCarrier_eq_constructorUnion :
    shadowDemandTwoCarrier =
      (retardedDemandTwoOccurrences ∪ directDemandTwoOccurrences) ∪
        liftDemandTwoOccurrences := by
  classical
  ext p
  cases h : occurrenceFormulaEdge p.1 <;>
    simp [shadowDemandTwoCarrier, retardedDemandTwoOccurrences,
      directDemandTwoOccurrences, liftDemandTwoOccurrences,
      retardedOccurrenceSlice, directOccurrenceSlice,
      liftOccurrenceSlice, IsRetardedOccurrence, IsDirectOccurrence,
      IsLiftOccurrence, active0Carrier, h]

private theorem demandOneSlices_pairwiseDisjoint :
    Disjoint retardedDemandOneOccurrences directDemandOneOccurrences ∧
      Disjoint retardedDemandOneOccurrences liftDemandOneOccurrences ∧
      Disjoint directDemandOneOccurrences liftDemandOneOccurrences := by
  classical
  constructor
  · refine Finset.disjoint_left.mpr ?_
    intro p hr hd
    have hrSlice : p ∈ retardedOccurrenceSlice :=
      (Finset.mem_filter.mp hr).1
    have hdSlice : p ∈ directOccurrenceSlice :=
      (Finset.mem_filter.mp hd).1
    exact (Finset.disjoint_left.mp constructorSlices_pairwiseDisjoint.1)
      hrSlice hdSlice
  constructor
  · refine Finset.disjoint_left.mpr ?_
    intro p hr hl
    have hrSlice : p ∈ retardedOccurrenceSlice :=
      (Finset.mem_filter.mp hr).1
    have hlSlice : p ∈ liftOccurrenceSlice :=
      (Finset.mem_filter.mp hl).1
    exact
      (Finset.disjoint_left.mp constructorSlices_pairwiseDisjoint.2.1)
        hrSlice hlSlice
  · refine Finset.disjoint_left.mpr ?_
    intro p hd hl
    have hdSlice : p ∈ directOccurrenceSlice :=
      (Finset.mem_filter.mp hd).1
    have hlSlice : p ∈ liftOccurrenceSlice :=
      (Finset.mem_filter.mp hl).1
    exact
      (Finset.disjoint_left.mp constructorSlices_pairwiseDisjoint.2.2)
        hdSlice hlSlice

private theorem demandTwoSlices_pairwiseDisjoint :
    Disjoint retardedDemandTwoOccurrences directDemandTwoOccurrences ∧
      Disjoint retardedDemandTwoOccurrences liftDemandTwoOccurrences ∧
      Disjoint directDemandTwoOccurrences liftDemandTwoOccurrences := by
  classical
  constructor
  · refine Finset.disjoint_left.mpr ?_
    intro p hr hd
    have hrSlice : p ∈ retardedOccurrenceSlice :=
      (Finset.mem_filter.mp hr).1
    have hdSlice : p ∈ directOccurrenceSlice :=
      (Finset.mem_filter.mp hd).1
    exact (Finset.disjoint_left.mp constructorSlices_pairwiseDisjoint.1)
      hrSlice hdSlice
  constructor
  · refine Finset.disjoint_left.mpr ?_
    intro p hr hl
    have hrSlice : p ∈ retardedOccurrenceSlice :=
      (Finset.mem_filter.mp hr).1
    have hlSlice : p ∈ liftOccurrenceSlice :=
      (Finset.mem_filter.mp hl).1
    exact
      (Finset.disjoint_left.mp constructorSlices_pairwiseDisjoint.2.1)
        hrSlice hlSlice
  · refine Finset.disjoint_left.mpr ?_
    intro p hd hl
    have hdSlice : p ∈ directOccurrenceSlice :=
      (Finset.mem_filter.mp hd).1
    have hlSlice : p ∈ liftOccurrenceSlice :=
      (Finset.mem_filter.mp hl).1
    exact
      (Finset.disjoint_left.mp constructorSlices_pairwiseDisjoint.2.2)
        hdSlice hlSlice

private theorem shadowDemandOneCarrier_card_sharded :
    shadowDemandOneCarrier.card = 1168 := by
  have hUnion :
      Disjoint
        (retardedDemandOneOccurrences ∪ directDemandOneOccurrences)
        liftDemandOneOccurrences :=
    Finset.disjoint_union_left.mpr
      ⟨demandOneSlices_pairwiseDisjoint.2.1,
        demandOneSlices_pairwiseDisjoint.2.2⟩
  rw [shadowDemandOneCarrier_eq_constructorUnion,
    Finset.card_union_of_disjoint hUnion,
    Finset.card_union_of_disjoint demandOneSlices_pairwiseDisjoint.1,
    retardedDemandOneOccurrences_card,
    directDemandOneOccurrences_card,
    liftDemandOneOccurrences_card]

private theorem shadowDemandTwoCarrier_card_sharded :
    shadowDemandTwoCarrier.card = 452 := by
  have hUnion :
      Disjoint
        (retardedDemandTwoOccurrences ∪ directDemandTwoOccurrences)
        liftDemandTwoOccurrences :=
    Finset.disjoint_union_left.mpr
      ⟨demandTwoSlices_pairwiseDisjoint.2.1,
        demandTwoSlices_pairwiseDisjoint.2.2⟩
  rw [shadowDemandTwoCarrier_eq_constructorUnion,
    Finset.card_union_of_disjoint hUnion,
    Finset.card_union_of_disjoint demandTwoSlices_pairwiseDisjoint.1,
    retardedDemandTwoOccurrences_card,
    directDemandTwoOccurrences_card,
    liftDemandTwoOccurrences_card]

theorem sum_shadowDemand_active0Carrier :
    (∑ p in active0Carrier,
      massDemandShadow (occurrenceFormulaEdge p.1)) = 2072 := by
  have hUnion :
      Disjoint (retardedOccurrenceSlice ∪ directOccurrenceSlice)
        liftOccurrenceSlice :=
    Finset.disjoint_union_left.mpr
      ⟨constructorSlices_pairwiseDisjoint.2.1,
        constructorSlices_pairwiseDisjoint.2.2⟩
  rw [← constructorSlices_exhaust_active0Carrier,
    Finset.sum_union hUnion,
    Finset.sum_union constructorSlices_pairwiseDisjoint.1,
    ← retardedShadowSum, ← directShadowSum, ← liftShadowSum,
    retardedShadowSum_eq_1296, directShadowSum_eq_424,
    liftShadowSum_eq_352]

/-- Compatibility theorem with exactly the proposition of the failed
monolithic `shadowDemand_profile_exact`, now assembled structurally. -/
theorem shadowDemand_profile_exact :
    shadowDemandOneCarrier.card = 1168 ∧
      shadowDemandTwoCarrier.card = 452 ∧
      (∑ p in active0Carrier,
        massDemandShadow (occurrenceFormulaEdge p.1)) = 2072 := by
  exact ⟨shadowDemandOneCarrier_card_sharded,
    shadowDemandTwoCarrier_card_sharded,
    sum_shadowDemand_active0Carrier⟩

def demandOneCarrier : Finset Active0Occurrence :=
  active0Carrier.filter (fun p => massDemand p = 1)

def demandTwoCarrier : Finset Active0Occurrence :=
  active0Carrier.filter (fun p => massDemand p = 2)

theorem demandOneCarrier_eq_shadow :
    demandOneCarrier = shadowDemandOneCarrier := by
  classical
  ext p
  simp [demandOneCarrier, shadowDemandOneCarrier, massDemand_eq_shadow]

theorem demandTwoCarrier_eq_shadow :
    demandTwoCarrier = shadowDemandTwoCarrier := by
  classical
  ext p
  simp [demandTwoCarrier, shadowDemandTwoCarrier, massDemand_eq_shadow]

theorem demandOneCarrier_card : demandOneCarrier.card = 1168 := by
  rw [demandOneCarrier_eq_shadow]
  exact shadowDemand_profile_exact.1

theorem demandTwoCarrier_card : demandTwoCarrier.card = 452 := by
  rw [demandTwoCarrier_eq_shadow]
  exact shadowDemand_profile_exact.2.1

theorem sum_massDemand_active0Carrier :
    (∑ p in active0Carrier, massDemand p) = 2072 := by
  classical
  calc
    (∑ p in active0Carrier, massDemand p) =
        ∑ p in active0Carrier,
          massDemandShadow (occurrenceFormulaEdge p.1) := by
      apply Finset.sum_congr rfl
      intro p hp
      exact massDemand_eq_shadow p
    _ = 2072 := sum_shadowDemand_active0Carrier

end

/-!
Scope: exact sharded mass-demand profile only.  It makes no semantic
first-hit, reverse-BFS capacity, rho, exponent, density, or global Collatz
claim.
-/

end F3Block0MassDemandProfile
end KL2003
end CollatzClassical
