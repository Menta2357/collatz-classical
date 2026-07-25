import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveCarrierCards
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveOperatorReindex
import Lean.Meta.Basic
import Lean.Util.CollectAxioms
import Lean.Util.FoldConsts

set_option maxRecDepth 100000

/-!
Audit-only surface for the ten Block0 Active R3 modules.

The 75 `#print axioms` commands below are an exhaustive, source-level
inventory of every public explicit `def`, `abbrev`, `instance`, and `theorem`
introduced by those modules.  Private proof helpers in the formula-row module
are intentionally not public roots; the wider namespace sweep still profiles
every generated declaration whose name lies below one of the five public
namespace prefixes.

For every explicit root the meta audit uses the official
`Lean.CollectAxioms.collect` state as the named kernel-dependency cone and
rejects any visit to the three historical frozen-table certificates.  A
direct path is reconstructed only after such a hit, following exactly the
same `ConstantInfo` fields as the official collector.

Every axiom profile is also rejected if it contains `Lean.ofReduceBool`,
`Lean.trustCompiler`, or `sorryAx`.  This module contains no mathematical
declarations and is not imported by the Active R3 construction.
-/

/-! ## Explicit public source inventory: 75/75 -/

namespace CollatzClassical.KL2003.F3Block0ActiveCarrier

#print axioms Active0
#print axioms active0Decidable
#print axioms Active0Occurrence
#print axioms active0Carrier
#print axioms active0SeenCarrier
#print axioms active0FreshCarrier
#print axioms active0Row
#print axioms FormulaActiveAtRoot
#print axioms formulaActiveAtRootDecidable
#print axioms active0_iff_formulaActiveAtRoot
#print axioms mem_active0Carrier
#print axioms mem_active0SeenCarrier_iff
#print axioms mem_active0FreshCarrier_iff
#print axioms mem_active0Row_iff

end CollatzClassical.KL2003.F3Block0ActiveCarrier

namespace CollatzClassical.KL2003.F3Block0ActiveCarrierCards

#print axioms ActiveSourceFormulaEdge
#print axioms Block0ActiveOccurrenceSigma
#print axioms active0OccurrenceSigmaEquiv
#print axioms active0Occurrence_card_eq_sum_sourceFibers
#print axioms activeSourceFormulaEdgeEquivQ0
#print axioms activeSourceFormulaEdgeEquivQ1
#print axioms activeSourceFormulaEdgeEquivQ2
#print axioms activeSourceFormulaEdge_card
#print axioms activeSourceFormulaEdge_triple_sum
#print axioms active0Occurrence_card
#print axioms active0Carrier_card
#print axioms SeenActive0Occurrence
#print axioms SeenBlock0ActiveOccurrenceSigma
#print axioms seenIndexOfRoot
#print axioms seenRoot_seenIndexOfRoot
#print axioms seenIndexOfRoot_seenRoot
#print axioms seenIndexSplitEquiv
#print axioms rootState_quotient_mod_three_seenSplit_left
#print axioms rootState_quotient_mod_three_seenSplit_right
#print axioms seenActive0OccurrenceSigmaEquiv
#print axioms activeSourceFormulaEdge_seenSplit_left_sum
#print axioms activeSourceFormulaEdge_seenSplit_right_sum
#print axioms activeSourceFormulaEdge_seen_sum
#print axioms seenActive0Occurrence_card
#print axioms FreshActive0Occurrence
#print axioms freshActive0Occurrence_card

end CollatzClassical.KL2003.F3Block0ActiveCarrierCards

namespace CollatzClassical.KL2003.F3Block0ActiveWeight

#print axioms forwardRightWeights81_get_pos
#print axioms forwardRightWeightNat_pos
#print axioms forwardRightWeight_pos
#print axioms stateFiber_card_pos
#print axioms initialUnitMass
#print axioms initialUnitMass_pos
#print axioms activeMultiplicity
#print axioms activeMultiplicity_retarded
#print axioms activeMultiplicity_advancedDirect
#print axioms activeMultiplicity_advancedParityLift
#print axioms activeMultiplicity_pos
#print axioms formulaChannelWeight_pos
#print axioms activeContribution
#print axioms activeContribution_pos

end CollatzClassical.KL2003.F3Block0ActiveWeight

namespace CollatzClassical.KL2003.F3Block0ActiveFormulaRow

#print axioms formulaForwardMatrix_row_eq_sourceFormulaEdge_sum

end CollatzClassical.KL2003.F3Block0ActiveFormulaRow

namespace CollatzClassical.KL2003.F3Block0ActiveOperatorReindex

#print axioms stateFiber_card_eq_three_mul_fine
#print axioms ActiveRootFibre
#print axioms retardedActiveRootFibreEquiv
#print axioms advancedDirectActiveRootFibreEquiv
#print axioms advancedParityLiftActiveRootFibreEquiv
#print axioms activeRootFibre_card
#print axioms activeRootFibre_card_mul_activeMultiplicity
#print axioms matchingFine_sum
#print axioms formulaEdgeNormalizedContribution
#print axioms active_root_fibre_reindex
#print axioms Block0ActiveOccurrenceEdgeSigma
#print axioms active0OccurrenceEdgeSigmaEquiv
#print axioms activeContribution_eq_normalized
#print axioms active0Carrier_sum_edge_first
#print axioms active0Carrier_sum_eq_formulaEdge_sum
#print axioms SourceFormulaEdgeSigma
#print axioms sourceFormulaEdgeSigmaEquiv
#print axioms formulaEdge_sigma_reindex
#print axioms block0_operator_formulaEdge_reindex
#print axioms block0_operator_active_reindex

end CollatzClassical.KL2003.F3Block0ActiveOperatorReindex

namespace CollatzClassical.KL2003.F3Block0ActiveR3Audit

private def explicitRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.Active0,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.active0Decidable,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.Active0Occurrence,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.active0Carrier,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.active0SeenCarrier,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.active0FreshCarrier,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.active0Row,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.FormulaActiveAtRoot,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.formulaActiveAtRootDecidable,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.active0_iff_formulaActiveAtRoot,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.mem_active0Carrier,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.mem_active0SeenCarrier_iff,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.mem_active0FreshCarrier_iff,
  `CollatzClassical.KL2003.F3Block0ActiveCarrier.mem_active0Row_iff,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.ActiveSourceFormulaEdge,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.Block0ActiveOccurrenceSigma,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.active0OccurrenceSigmaEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.active0Occurrence_card_eq_sum_sourceFibers,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdgeEquivQ0,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdgeEquivQ1,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdgeEquivQ2,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdge_card,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdge_triple_sum,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.active0Occurrence_card,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.active0Carrier_card,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.SeenActive0Occurrence,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.SeenBlock0ActiveOccurrenceSigma,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.seenIndexOfRoot,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.seenRoot_seenIndexOfRoot,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.seenIndexOfRoot_seenRoot,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.seenIndexSplitEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.rootState_quotient_mod_three_seenSplit_left,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.rootState_quotient_mod_three_seenSplit_right,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.seenActive0OccurrenceSigmaEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdge_seenSplit_left_sum,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdge_seenSplit_right_sum,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.activeSourceFormulaEdge_seen_sum,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.seenActive0Occurrence_card,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.FreshActive0Occurrence,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards.freshActive0Occurrence_card,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.forwardRightWeights81_get_pos,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.forwardRightWeightNat_pos,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.forwardRightWeight_pos,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.stateFiber_card_pos,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.initialUnitMass,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.initialUnitMass_pos,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.activeMultiplicity,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.activeMultiplicity_retarded,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.activeMultiplicity_advancedDirect,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.activeMultiplicity_advancedParityLift,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.activeMultiplicity_pos,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.formulaChannelWeight_pos,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.activeContribution,
  `CollatzClassical.KL2003.F3Block0ActiveWeight.activeContribution_pos,
  `CollatzClassical.KL2003.F3Block0ActiveFormulaRow.formulaForwardMatrix_row_eq_sourceFormulaEdge_sum,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.stateFiber_card_eq_three_mul_fine,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.ActiveRootFibre,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.retardedActiveRootFibreEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.advancedDirectActiveRootFibreEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.advancedParityLiftActiveRootFibreEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.activeRootFibre_card,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.activeRootFibre_card_mul_activeMultiplicity,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.matchingFine_sum,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.formulaEdgeNormalizedContribution,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.active_root_fibre_reindex,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.Block0ActiveOccurrenceEdgeSigma,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.active0OccurrenceEdgeSigmaEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.activeContribution_eq_normalized,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.active0Carrier_sum_edge_first,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.active0Carrier_sum_eq_formulaEdge_sum,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.SourceFormulaEdgeSigma,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.sourceFormulaEdgeSigmaEquiv,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.formulaEdge_sigma_reindex,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.block0_operator_formulaEdge_reindex,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex.block0_operator_active_reindex
]

private def namespacePrefixes : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ActiveCarrier,
  `CollatzClassical.KL2003.F3Block0ActiveCarrierCards,
  `CollatzClassical.KL2003.F3Block0ActiveWeight,
  `CollatzClassical.KL2003.F3Block0ActiveFormulaRow,
  `CollatzClassical.KL2003.F3Block0ActiveOperatorReindex
]

private def forbiddenNamedDependencies : Lean.NameSet :=
  ({} : Lean.NameSet)
    |>.insert `CollatzClassical.KL2003.F3ExactCoreMatrix.core_edge_count
    |>.insert `CollatzClassical.KL2003.F3ExactCoreMatrix.frozen_weight_count
    |>.insert `CollatzClassical.KL2003.F3ExactCoreMatrix.core_edges_have_valid_channels

private def forbiddenAxiomNames : Lean.NameSet :=
  ({} : Lean.NameSet)
    |>.insert `Lean.ofReduceBool
    |>.insert `Lean.trustCompiler
    |>.insert `sorryAx

private def constantsInExpr (initial : Lean.NameSet) (expr : Lean.Expr) : Lean.NameSet :=
  expr.getUsedConstants.toList.foldl
    (fun dependencies dependency => dependencies.insert dependency)
    initial

/--
Direct dependencies used only to reconstruct a diagnostic path after the
official collector has already found a forbidden name.  This mirrors
`Lean.CollectAxioms.collect` exactly: definition/theorem/opaque type and body;
inductive type and constructors; constructor/recursor type; no expansion of
`all` fields or recursor rules.
-/
private def directKernelDependencies (info : Lean.ConstantInfo) : Lean.NameSet :=
  match info with
  | .defnInfo value =>
      let dependencies := constantsInExpr {} value.type
      let dependencies := constantsInExpr dependencies value.value
      dependencies
  | .thmInfo value =>
      let dependencies := constantsInExpr {} value.type
      let dependencies := constantsInExpr dependencies value.value
      dependencies
  | .opaqueInfo value =>
      let dependencies := constantsInExpr {} value.type
      let dependencies := constantsInExpr dependencies value.value
      dependencies
  | .inductInfo value =>
      let dependencies := constantsInExpr {} value.type
      value.ctors.foldl (fun current dependency => current.insert dependency) dependencies
  | .ctorInfo value => constantsInExpr {} value.type
  | .recInfo value => constantsInExpr {} value.type
  | .axiomInfo _ | .quotInfo _ => {}

/--
Depth-first named dependency search.  `reversePath` contains `current` first
and the root last; reversing it therefore prints a reproducible root-to-hit
path.  A per-root visited set makes generated inductive/recursor cycles safe.
-/
private partial def findForbiddenDependencyPath
    (environment : Lean.Environment)
    (current : Lean.Name)
    (reversePath : List Lean.Name) :
    StateM Lean.NameSet (Option (List Lean.Name)) := do
  if forbiddenNamedDependencies.contains current then
    return some reversePath.reverse
  if (← get).contains current then
    return none
  modify fun visited => visited.insert current
  match environment.checked.get.find? current with
  | none => return none
  | some info =>
      for dependency in directKernelDependencies info do
        let result ←
          findForbiddenDependencyPath environment dependency (dependency :: reversePath)
        if let some path := result then
          return some path
      return none

private def forbiddenAxiomsIn (axioms : Array Lean.Name) : Array Lean.Name :=
  axioms.filter forbiddenAxiomNames.contains

run_meta do
  let environment ← Lean.getEnv
  let mut failed := false

  if explicitRoots.size != 75 then
    Lean.throwError m!"explicit Active R3 inventory has {explicitRoots.size} entries; expected 75"

  for root in explicitRoots do
    if (environment.checked.get.find? root).isNone then
      failed := true
      Lean.logError m!"EXPLICIT_DECLARATION_MISSING\t{root}"
    else
      let (_, state) := ((Lean.CollectAxioms.collect root).run environment).run {}
      let axioms := state.axioms
      let forbidden := forbiddenAxiomsIn axioms
      Lean.logInfo m!"EXPLICIT_AXIOM_PROFILE\t{root}\t{axioms.toList}"
      if !forbidden.isEmpty then
        failed := true
        Lean.logError m!"FORBIDDEN_AXIOM\troot={root}\thits={forbidden}"

      let namedForbidden :=
        forbiddenNamedDependencies.toList.filter state.visited.contains
      if namedForbidden.isEmpty then
        Lean.logInfo
          m!"NAMED_DEPENDENCY_CONE_PASS\troot={root}\tvisited={state.visited.size}"
      else
        failed := true
        let (path?, _) :=
          (findForbiddenDependencyPath environment root [root]).run {}
        match path? with
        | some path =>
            Lean.logError
              m!"NAMED_DEPENDENCY_CONE_FAIL\troot={root}\thits={namedForbidden}\tpath={path}"
        | none =>
            Lean.logError
              m!"NAMED_DEPENDENCY_CONE_FAIL_NO_PATH\troot={root}\thits={namedForbidden}"

  Lean.logInfo m!"EXPLICIT_DECLARATION_COVERAGE={explicitRoots.size}/75"

  let mut namespaceDeclarationTotal := 0
  for namespacePrefix in namespacePrefixes do
    let declarations :=
      environment.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf
    namespaceDeclarationTotal := namespaceDeclarationTotal + declarations.length
    Lean.logInfo
      m!"NAMESPACE_DECLARATION_COUNT\t{namespacePrefix}\t{declarations.length}"
    for declaration in declarations do
      let axioms ← Lean.collectAxioms declaration
      let forbidden := forbiddenAxiomsIn axioms
      Lean.logInfo
        m!"NAMESPACE_AXIOM_PROFILE\t{namespacePrefix}\t{declaration}\t{axioms.toList}"
      if !forbidden.isEmpty then
        failed := true
        Lean.logError
          m!"FORBIDDEN_NAMESPACE_AXIOM\tnamespace={namespacePrefix}\tdeclaration={declaration}\thits={forbidden}"
    Lean.logInfo
      m!"NAMESPACE_AXIOM_COVERAGE\t{namespacePrefix}\t{declarations.length}/{declarations.length}"

  Lean.logInfo m!"NAMESPACE_PREFIX_COVERAGE={namespacePrefixes.size}/5"
  Lean.logInfo m!"NAMESPACE_DECLARATION_TOTAL={namespaceDeclarationTotal}"

  if failed then
    Lean.throwError "Active R3 Block0 audit failed; inspect the logged declaration or dependency path"
  else
    Lean.logInfo "R3_BLOCK0_ACTIVE_AUDIT_PASS"

end CollatzClassical.KL2003.F3Block0ActiveR3Audit
