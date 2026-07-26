import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileSharded
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

set_option maxHeartbeats 600000
set_option maxRecDepth 100000

/-!
Fail-hard trust audit source for the sharded Block0 mass-demand profile.

The explicit inventory contains all 86 public source declarations across
Core, the three constructor shards, and the assembly.  The seven ordinary
kernel decisions are separately inventoried: one Core bound and exactly two
histogram cards per shard.  Namespace sweeps additionally audit every
elaborator-generated declaration.  The only permitted axioms are `propext`,
`Classical.choice`, and `Quot.sound`.

This file is audit source only.  Its existence is not an audit result, and
semantic first-hit, reverse-BFS capacity, rho, exponent, and density remain
outside scope.
-/

namespace CollatzClassical.KL2003.F3Block0MassDemandProfile

#print axioms qHiCoeffNum
#print axioms qHiCoeffDen
#print axioms qHiNumerator
#print axioms qHiDenominator
#print axioms qHiCoeffDen_pos
#print axioms qHiDenominator_pos
#print axioms qHi_eq_natural_fraction
#print axioms qHiNumerator_le_two_mul_denominator
#print axioms qHi_le_two
#print axioms massDemand_le_two
#print axioms massDemandShadow
#print axioms qHi_le_one_of_numerator_le_denominator
#print axioms one_lt_qHi_of_denominator_lt_numerator
#print axioms massDemand_eq_shadow
#print axioms constructorSlices_pairwiseDisjoint
#print axioms constructorSlices_exhaust_active0Carrier
#print axioms shadowDemandOneCarrier
#print axioms shadowDemandTwoCarrier
#print axioms shadowDemandOneCarrier_eq_constructorUnion
#print axioms shadowDemandTwoCarrier_eq_constructorUnion
#print axioms sum_shadowDemand_active0Carrier
#print axioms shadowDemand_profile_exact
#print axioms demandOneCarrier
#print axioms demandTwoCarrier
#print axioms demandOneCarrier_eq_shadow
#print axioms demandTwoCarrier_eq_shadow
#print axioms demandOneCarrier_card
#print axioms demandTwoCarrier_card
#print axioms sum_massDemand_active0Carrier

end CollatzClassical.KL2003.F3Block0MassDemandProfile

namespace CollatzClassical.KL2003.F3Block0MassDemandRetardedShard

#print axioms RetardedActiveRoot
#print axioms retardedEdge
#print axioms IsRetardedOccurrence
#print axioms retardedOccurrenceSlice
#print axioms mem_retardedOccurrenceSlice_iff
#print axioms RetardedActiveOccurrence
#print axioms retardedActiveOccurrenceDirect
#print axioms retardedRootEquiv
#print axioms retardedRootEquiv_edge
#print axioms retardedDemandOneRoots
#print axioms retardedDemandTwoRoots
#print axioms retardedDemandOneRoots_card
#print axioms retardedDemandTwoRoots_card
#print axioms retardedDemandOneOccurrences
#print axioms retardedDemandTwoOccurrences
#print axioms retardedDemandOneOccurrences_card
#print axioms retardedDemandTwoOccurrences_card
#print axioms retardedShadowSum
#print axioms retardedShadowSum_eq_1296

end CollatzClassical.KL2003.F3Block0MassDemandRetardedShard

namespace CollatzClassical.KL2003.F3Block0MassDemandDirectShard

#print axioms DirectActiveRoot
#print axioms directEdge
#print axioms IsDirectOccurrence
#print axioms directOccurrenceSlice
#print axioms mem_directOccurrenceSlice_iff
#print axioms DirectActiveOccurrence
#print axioms directActiveOccurrenceDirect
#print axioms directRootEquiv
#print axioms directRootEquiv_edge
#print axioms directDemandOneRoots
#print axioms directDemandTwoRoots
#print axioms directDemandOneRoots_card
#print axioms directDemandTwoRoots_card
#print axioms directDemandOneOccurrences
#print axioms directDemandTwoOccurrences
#print axioms directDemandOneOccurrences_card
#print axioms directDemandTwoOccurrences_card
#print axioms directShadowSum
#print axioms directShadowSum_eq_424

end CollatzClassical.KL2003.F3Block0MassDemandDirectShard

namespace CollatzClassical.KL2003.F3Block0MassDemandLiftShard

#print axioms LiftActiveRoot
#print axioms liftEdge
#print axioms IsLiftOccurrence
#print axioms liftOccurrenceSlice
#print axioms mem_liftOccurrenceSlice_iff
#print axioms LiftActiveOccurrence
#print axioms liftActiveOccurrenceDirect
#print axioms liftRootEquiv
#print axioms liftRootEquiv_edge
#print axioms liftDemandOneRoots
#print axioms liftDemandTwoRoots
#print axioms liftDemandOneRoots_card
#print axioms liftDemandTwoRoots_card
#print axioms liftDemandOneOccurrences
#print axioms liftDemandTwoOccurrences
#print axioms liftDemandOneOccurrences_card
#print axioms liftDemandTwoOccurrences_card
#print axioms liftShadowSum
#print axioms liftShadowSum_eq_352

end CollatzClassical.KL2003.F3Block0MassDemandLiftShard

namespace CollatzClassical.KL2003.F3Block0MassDemandProfileShardedAudit

private def coreRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiCoeffNum,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiCoeffDen,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiNumerator,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiDenominator,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiCoeffDen_pos,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiDenominator_pos,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHi_eq_natural_fraction,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiNumerator_le_two_mul_denominator,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHi_le_two,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.massDemand_le_two,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.massDemandShadow,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHi_le_one_of_numerator_le_denominator,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.one_lt_qHi_of_denominator_lt_numerator,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.massDemand_eq_shadow
]

private def retardedRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.RetardedActiveRoot,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedEdge,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.IsRetardedOccurrence,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedOccurrenceSlice,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.mem_retardedOccurrenceSlice_iff,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.RetardedActiveOccurrence,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedActiveOccurrenceDirect,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedRootEquiv,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedRootEquiv_edge,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandOneRoots,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandTwoRoots,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandOneRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandTwoRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandOneOccurrences,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandTwoOccurrences,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandOneOccurrences_card,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandTwoOccurrences_card,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedShadowSum,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedShadowSum_eq_1296
]

private def directRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.DirectActiveRoot,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directEdge,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.IsDirectOccurrence,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directOccurrenceSlice,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.mem_directOccurrenceSlice_iff,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.DirectActiveOccurrence,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directActiveOccurrenceDirect,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directRootEquiv,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directRootEquiv_edge,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandOneRoots,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandTwoRoots,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandOneRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandTwoRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandOneOccurrences,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandTwoOccurrences,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandOneOccurrences_card,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandTwoOccurrences_card,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directShadowSum,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directShadowSum_eq_424
]

private def liftRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.LiftActiveRoot,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftEdge,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.IsLiftOccurrence,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftOccurrenceSlice,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.mem_liftOccurrenceSlice_iff,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.LiftActiveOccurrence,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftActiveOccurrenceDirect,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftRootEquiv,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftRootEquiv_edge,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandOneRoots,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandTwoRoots,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandOneRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandTwoRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandOneOccurrences,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandTwoOccurrences,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandOneOccurrences_card,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandTwoOccurrences_card,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftShadowSum,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftShadowSum_eq_352
]

private def assemblyRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.constructorSlices_pairwiseDisjoint,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.constructorSlices_exhaust_active0Carrier,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.shadowDemandOneCarrier,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.shadowDemandTwoCarrier,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.shadowDemandOneCarrier_eq_constructorUnion,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.shadowDemandTwoCarrier_eq_constructorUnion,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.sum_shadowDemand_active0Carrier,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.shadowDemand_profile_exact,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.demandOneCarrier,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.demandTwoCarrier,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.demandOneCarrier_eq_shadow,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.demandTwoCarrier_eq_shadow,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.demandOneCarrier_card,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.demandTwoCarrier_card,
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.sum_massDemand_active0Carrier
]

private def explicitRoots : Array Lean.Name :=
  coreRoots ++ retardedRoots ++ directRoots ++ liftRoots ++ assemblyRoots

private def coreOrdinaryDecideRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandProfile.qHiNumerator_le_two_mul_denominator
]

private def shardOrdinaryDecideRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandOneRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard.retardedDemandTwoRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandOneRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard.directDemandTwoRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandOneRoots_card,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard.liftDemandTwoRoots_card
]

private def ordinaryDecideRoots : Array Lean.Name :=
  coreOrdinaryDecideRoots ++ shardOrdinaryDecideRoots

private def successorNamespacePrefixes : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0MassDemandProfile,
  `CollatzClassical.KL2003.F3Block0MassDemandRetardedShard,
  `CollatzClassical.KL2003.F3Block0MassDemandDirectShard,
  `CollatzClassical.KL2003.F3Block0MassDemandLiftShard
]

private def allowedAxiomNames : Lean.NameSet :=
  ({} : Lean.NameSet)
    |>.insert `propext
    |>.insert `Classical.choice
    |>.insert `Quot.sound

private def auditDeclaration
    (environment : Lean.Environment)
    (root : Lean.Name)
    (label : String) : Lean.MetaM Bool := do
  if (environment.checked.get.find? root).isNone then
    Lean.logError m!"{label}_DECLARATION_MISSING\t{root}"
    return true
  let (_, state) := ((Lean.CollectAxioms.collect root).run environment).run {}
  let axioms := state.axioms
  Lean.logInfo m!"{label}_AXIOM_PROFILE\t{root}\t{axioms.toList}"
  let unexpected := axioms.filter fun axiomName =>
    !allowedAxiomNames.contains axiomName
  if unexpected.isEmpty then
    return false
  Lean.logError m!"UNEXPECTED_{label}_AXIOM\troot={root}\thits={unexpected}"
  return true

run_meta do
  let environment ← Lean.getEnv
  let mut failed := false

  if coreRoots.size != 14 then
    Lean.throwError m!"Core inventory has {coreRoots.size} entries; expected 14"
  if retardedRoots.size != 19 then
    Lean.throwError
      m!"retarded inventory has {retardedRoots.size} entries; expected 19"
  if directRoots.size != 19 then
    Lean.throwError m!"direct inventory has {directRoots.size} entries; expected 19"
  if liftRoots.size != 19 then
    Lean.throwError m!"lift inventory has {liftRoots.size} entries; expected 19"
  if assemblyRoots.size != 15 then
    Lean.throwError
      m!"assembly inventory has {assemblyRoots.size} entries; expected 15"
  if explicitRoots.size != 86 then
    Lean.throwError
      m!"explicit sharded-profile inventory has {explicitRoots.size} entries; expected 86"

  for root in explicitRoots do
    if ← auditDeclaration environment root "EXPLICIT" then
      failed := true
  Lean.logInfo m!"EXPLICIT_DECLARATION_COVERAGE={explicitRoots.size}/86"
  Lean.logInfo m!"CORE_EXPLICIT_DECLARATION_COVERAGE={coreRoots.size}/14"

  if coreOrdinaryDecideRoots.size != 1 then
    Lean.throwError
      m!"Core ordinary-decision inventory has {coreOrdinaryDecideRoots.size} entries; expected 1"
  if shardOrdinaryDecideRoots.size != 6 then
    Lean.throwError
      m!"shard ordinary-decision inventory has {shardOrdinaryDecideRoots.size} entries; expected 6"
  if ordinaryDecideRoots.size != 7 then
    Lean.throwError
      m!"complete ordinary-decision inventory has {ordinaryDecideRoots.size} entries; expected 7"
  for root in ordinaryDecideRoots do
    if ← auditDeclaration environment root "ORDINARY_DECIDE" then
      failed := true
  Lean.logInfo
    m!"CORE_ORDINARY_DECIDE_KERNEL_CLEAN_COVERAGE={coreOrdinaryDecideRoots.size}/1"
  Lean.logInfo
    m!"SHARD_ORDINARY_DECIDE_KERNEL_CLEAN_COVERAGE={shardOrdinaryDecideRoots.size}/6"
  Lean.logInfo
    m!"COMPLETE_ORDINARY_DECIDE_KERNEL_CLEAN_COVERAGE={ordinaryDecideRoots.size}/7"

  for namespacePrefix in successorNamespacePrefixes do
    let declarations := environment.constants.toList.map Prod.fst |>.filter
      namespacePrefix.isPrefixOf
    if declarations.isEmpty then
      Lean.logError m!"NAMESPACE_INVENTORY_EMPTY\t{namespacePrefix}"
      failed := true
    for declaration in declarations do
      if ← auditDeclaration environment declaration "NAMESPACE" then
        failed := true
    Lean.logInfo
      m!"NAMESPACE_DECLARATION_COVERAGE\t{namespacePrefix}\t{declarations.length}/{declarations.length}"

  Lean.logInfo "SEMANTIC_FIRST_HIT_SCOPE=NOT_COVERED"
  Lean.logInfo "REVERSE_BFS_CAPACITY_SCOPE=NOT_COVERED"
  Lean.logInfo "RHO_EXPONENT_DENSITY_SCOPE=NOT_COVERED"

  if failed then
    Lean.throwError
      "Block0 sharded mass-demand-profile trust audit failed"
  else
    Lean.logInfo "BLOCK0_MASS_DEMAND_PROFILE_SHARDED_AUDIT_PASS"

end CollatzClassical.KL2003.F3Block0MassDemandProfileShardedAudit
