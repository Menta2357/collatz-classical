import CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceTotal
import Lean.Meta.Basic
import Lean.Util.CollectAxioms
import Lean.Util.FoldConsts

set_option maxRecDepth 100000

/-!
Audit-only surface for the ten Block0 R2 modules.

The 87 `#print axioms` commands below are an exhaustive, source-level
inventory of every explicit `def`, `abbrev`, `theorem`, and named declaration
in those modules.  The meta audit then does two deliberately wider checks:

* it profiles every declaration under each of the ten namespaces, including
  constructors, recursors and other elaborator-generated declarations; and
* for each of the 87 explicit roots it uses the official
  `Lean.CollectAxioms.collect` state as the named kernel-dependency cone and
  rejects any visit to the three historical frozen-table certificates.  A
  direct path is reconstructed only after such a hit, following exactly the
  same `ConstantInfo` fields as the official collector.

Every axiom profile is also rejected if it contains `Lean.ofReduceBool`,
`Lean.trustCompiler`, or `sorryAx`.  This module contains no mathematical
declarations and is not imported by the R2 construction.
-/

/-! ## Explicit source inventory: 87/87 -/

namespace CollatzClassical.KL2003.F3Block0Carrier

#print axioms Block0Root
#print axioms block0Root_card
#print axioms rootValue
#print axioms rootValue_lower
#print axioms rootValue_upper
#print axioms rootValue_mod3
#print axioms rootValue_eq_iff
#print axioms IsBlock0RootValue
#print axioms rootValue_isBlock0RootValue
#print axioms isBlock0RootValue_iff_existsUnique
#print axioms Block0SeenIndex
#print axioms Block0FreshIndex
#print axioms block0SeenIndex_card
#print axioms block0FreshIndex_card
#print axioms seenRoot
#print axioms freshRoot
#print axioms seenRoot_value_lt
#print axioms freshRoot_value_ge
#print axioms rootValue_lt_128_iff
#print axioms classifyRoot
#print axioms assembleRoot
#print axioms assembleRoot_classifyRoot
#print axioms classifyRoot_assembleRoot

end CollatzClassical.KL2003.F3Block0Carrier

namespace CollatzClassical.KL2003.F3Block0CarrierFibers

#print axioms rootState
#print axioms rootState_val
#print axioms rootFineLift
#print axioms stateFiber
#print axioms stateFineFiber
#print axioms initialBlockNat
#print axioms mem_stateFiber_iff
#print axioms mem_stateFineFiber_iff
#print axioms formulaFineLift
#print axioms Block0Occurrence
#print axioms occurrenceRoot
#print axioms occurrenceFormulaEdge
#print axioms occurrenceFineLift
#print axioms formulaFiber
#print axioms block0OccurrenceCarrier
#print axioms mem_block0OccurrenceCarrier_iff
#print axioms occurrenceRow
#print axioms occurrenceRow_injective

end CollatzClassical.KL2003.F3Block0CarrierFibers

namespace CollatzClassical.KL2003.F3Block0CarrierFiberCards

#print axioms rootCoordinate
#print axioms coordinateRoot
#print axioms coordinateRoot_rootCoordinate
#print axioms rootCoordinate_coordinateRoot
#print axioms rootCoordinateEquiv
#print axioms rootFineLift_val_index
#print axioms rootState_div_three
#print axioms stateResidue
#print axioms stateResidue_successor_mod
#print axioms residue_eq_stateResidue_of_successor_mod
#print axioms rootCoordinate_fst_eq_stateResidue_of_state
#print axioms statePeriodRoot
#print axioms statePeriodRoot_rootCoordinate_snd_of_state
#print axioms rootCoordinate_snd_statePeriodRoot
#print axioms periodFineFiber
#print axioms stateFineFiber_card_eq_periodFineFiber
#print axioms periodFineFiber_card_all
#print axioms stateFineFiber_card

end CollatzClassical.KL2003.F3Block0CarrierFiberCards

namespace CollatzClassical.KL2003.F3Block0CarrierStateCards

#print axioms stateFiber_card_eq_sum_fine
#print axioms stateFiber_card

end CollatzClassical.KL2003.F3Block0CarrierStateCards

namespace CollatzClassical.KL2003.F3Block0OccurrenceCards

#print axioms FormulaEdgeCases
#print axioms formulaEdgeOfCases
#print axioms formulaEdgeCases
#print axioms formulaEdgeOfCases_cases
#print axioms formulaEdgeCases_ofCases
#print axioms formulaEdgeCasesEquiv
#print axioms formulaCaseSource
#print axioms formulaSource_formulaEdgeOfCases
#print axioms SourceFormulaEdge
#print axioms SourceFormulaEdgeCases
#print axioms sourceFormulaEdgeCasesEquiv

end CollatzClassical.KL2003.F3Block0OccurrenceCards

namespace CollatzClassical.KL2003.F3Block0FormulaFiberCards

#print axioms sourceFormulaEdgeEquivQ0
#print axioms sourceFormulaEdgeEquivQ1
#print axioms sourceFormulaEdgeEquivQ2
#print axioms sourceFormulaEdge_card
#print axioms formulaFiber_card

end CollatzClassical.KL2003.F3Block0FormulaFiberCards

namespace CollatzClassical.KL2003.F3Block0OccurrenceSigmaCards

#print axioms Block0OccurrenceSigma
#print axioms block0OccurrenceSigmaEquiv
#print axioms block0Occurrence_card_eq_sum_sourceFibers

end CollatzClassical.KL2003.F3Block0OccurrenceSigmaCards

namespace CollatzClassical.KL2003.F3Block0OccurrenceTripleWeights

#print axioms block0RootTripleEquiv
#print axioms rootState_quotient_mod_three
#print axioms rootState_quotient_mod_three_triple
#print axioms sourceFormulaEdge_triple_sum

end CollatzClassical.KL2003.F3Block0OccurrenceTripleWeights

namespace CollatzClassical.KL2003.F3Block0OccurrenceNumericTotal

#print axioms block0Occurrence_card

end CollatzClassical.KL2003.F3Block0OccurrenceNumericTotal

namespace CollatzClassical.KL2003.F3Block0OccurrenceTotal

#print axioms block0Occurrence_card_eq_carrier
#print axioms block0OccurrenceCarrier_card

end CollatzClassical.KL2003.F3Block0OccurrenceTotal

namespace CollatzClassical.KL2003.F3Block0R2Audit

private def explicitRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0Carrier.Block0Root,
  `CollatzClassical.KL2003.F3Block0Carrier.block0Root_card,
  `CollatzClassical.KL2003.F3Block0Carrier.rootValue,
  `CollatzClassical.KL2003.F3Block0Carrier.rootValue_lower,
  `CollatzClassical.KL2003.F3Block0Carrier.rootValue_upper,
  `CollatzClassical.KL2003.F3Block0Carrier.rootValue_mod3,
  `CollatzClassical.KL2003.F3Block0Carrier.rootValue_eq_iff,
  `CollatzClassical.KL2003.F3Block0Carrier.IsBlock0RootValue,
  `CollatzClassical.KL2003.F3Block0Carrier.rootValue_isBlock0RootValue,
  `CollatzClassical.KL2003.F3Block0Carrier.isBlock0RootValue_iff_existsUnique,
  `CollatzClassical.KL2003.F3Block0Carrier.Block0SeenIndex,
  `CollatzClassical.KL2003.F3Block0Carrier.Block0FreshIndex,
  `CollatzClassical.KL2003.F3Block0Carrier.block0SeenIndex_card,
  `CollatzClassical.KL2003.F3Block0Carrier.block0FreshIndex_card,
  `CollatzClassical.KL2003.F3Block0Carrier.seenRoot,
  `CollatzClassical.KL2003.F3Block0Carrier.freshRoot,
  `CollatzClassical.KL2003.F3Block0Carrier.seenRoot_value_lt,
  `CollatzClassical.KL2003.F3Block0Carrier.freshRoot_value_ge,
  `CollatzClassical.KL2003.F3Block0Carrier.rootValue_lt_128_iff,
  `CollatzClassical.KL2003.F3Block0Carrier.classifyRoot,
  `CollatzClassical.KL2003.F3Block0Carrier.assembleRoot,
  `CollatzClassical.KL2003.F3Block0Carrier.assembleRoot_classifyRoot,
  `CollatzClassical.KL2003.F3Block0Carrier.classifyRoot_assembleRoot,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.rootState,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.rootState_val,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.rootFineLift,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.stateFiber,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.stateFineFiber,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.initialBlockNat,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.mem_stateFiber_iff,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.mem_stateFineFiber_iff,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.formulaFineLift,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.Block0Occurrence,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.occurrenceRoot,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.occurrenceFormulaEdge,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.occurrenceFineLift,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.formulaFiber,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.block0OccurrenceCarrier,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.mem_block0OccurrenceCarrier_iff,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.occurrenceRow,
  `CollatzClassical.KL2003.F3Block0CarrierFibers.occurrenceRow_injective,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.rootCoordinate,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.coordinateRoot,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.coordinateRoot_rootCoordinate,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.rootCoordinate_coordinateRoot,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.rootCoordinateEquiv,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.rootFineLift_val_index,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.rootState_div_three,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.stateResidue,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.stateResidue_successor_mod,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.residue_eq_stateResidue_of_successor_mod,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.rootCoordinate_fst_eq_stateResidue_of_state,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.statePeriodRoot,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.statePeriodRoot_rootCoordinate_snd_of_state,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.rootCoordinate_snd_statePeriodRoot,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.periodFineFiber,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.stateFineFiber_card_eq_periodFineFiber,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.periodFineFiber_card_all,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards.stateFineFiber_card,
  `CollatzClassical.KL2003.F3Block0CarrierStateCards.stateFiber_card_eq_sum_fine,
  `CollatzClassical.KL2003.F3Block0CarrierStateCards.stateFiber_card,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.FormulaEdgeCases,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.formulaEdgeOfCases,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.formulaEdgeCases,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.formulaEdgeOfCases_cases,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.formulaEdgeCases_ofCases,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.formulaEdgeCasesEquiv,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.formulaCaseSource,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.formulaSource_formulaEdgeOfCases,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.SourceFormulaEdge,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.SourceFormulaEdgeCases,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards.sourceFormulaEdgeCasesEquiv,
  `CollatzClassical.KL2003.F3Block0FormulaFiberCards.sourceFormulaEdgeEquivQ0,
  `CollatzClassical.KL2003.F3Block0FormulaFiberCards.sourceFormulaEdgeEquivQ1,
  `CollatzClassical.KL2003.F3Block0FormulaFiberCards.sourceFormulaEdgeEquivQ2,
  `CollatzClassical.KL2003.F3Block0FormulaFiberCards.sourceFormulaEdge_card,
  `CollatzClassical.KL2003.F3Block0FormulaFiberCards.formulaFiber_card,
  `CollatzClassical.KL2003.F3Block0OccurrenceSigmaCards.Block0OccurrenceSigma,
  `CollatzClassical.KL2003.F3Block0OccurrenceSigmaCards.block0OccurrenceSigmaEquiv,
  `CollatzClassical.KL2003.F3Block0OccurrenceSigmaCards.block0Occurrence_card_eq_sum_sourceFibers,
  `CollatzClassical.KL2003.F3Block0OccurrenceTripleWeights.block0RootTripleEquiv,
  `CollatzClassical.KL2003.F3Block0OccurrenceTripleWeights.rootState_quotient_mod_three,
  `CollatzClassical.KL2003.F3Block0OccurrenceTripleWeights.rootState_quotient_mod_three_triple,
  `CollatzClassical.KL2003.F3Block0OccurrenceTripleWeights.sourceFormulaEdge_triple_sum,
  `CollatzClassical.KL2003.F3Block0OccurrenceNumericTotal.block0Occurrence_card,
  `CollatzClassical.KL2003.F3Block0OccurrenceTotal.block0Occurrence_card_eq_carrier,
  `CollatzClassical.KL2003.F3Block0OccurrenceTotal.block0OccurrenceCarrier_card
]

private def namespacePrefixes : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0Carrier,
  `CollatzClassical.KL2003.F3Block0CarrierFibers,
  `CollatzClassical.KL2003.F3Block0CarrierFiberCards,
  `CollatzClassical.KL2003.F3Block0CarrierStateCards,
  `CollatzClassical.KL2003.F3Block0OccurrenceCards,
  `CollatzClassical.KL2003.F3Block0FormulaFiberCards,
  `CollatzClassical.KL2003.F3Block0OccurrenceSigmaCards,
  `CollatzClassical.KL2003.F3Block0OccurrenceTripleWeights,
  `CollatzClassical.KL2003.F3Block0OccurrenceNumericTotal,
  `CollatzClassical.KL2003.F3Block0OccurrenceTotal
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

  if explicitRoots.size != 87 then
    Lean.throwError m!"explicit R2 inventory has {explicitRoots.size} entries; expected 87"

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

  Lean.logInfo m!"EXPLICIT_DECLARATION_COVERAGE={explicitRoots.size}/87"

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

  Lean.logInfo m!"NAMESPACE_PREFIX_COVERAGE={namespacePrefixes.size}/10"
  Lean.logInfo m!"NAMESPACE_DECLARATION_TOTAL={namespaceDeclarationTotal}"

  if failed then
    Lean.throwError "R2 Block0 audit failed; inspect the logged declaration or dependency path"
  else
    Lean.logInfo "R2_BLOCK0_AUDIT_PASS"

end CollatzClassical.KL2003.F3Block0R2Audit
