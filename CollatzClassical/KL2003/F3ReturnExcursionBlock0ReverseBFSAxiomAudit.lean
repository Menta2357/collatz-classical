import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSMassIntegration
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

set_option maxRecDepth 100000

/-!
# Exhaustive trust audit for the Block0 reverse-BFS layer

The 42 explicit roots exhaust every public source-level declaration in the
data/generator, generic verifier, and typed mass-demand integration modules.
The meta audit additionally sweeps every declaration generated under their
three namespaces.  It fails hard on a missing declaration or on any axiom
outside `propext`, `Classical.choice`, and `Quot.sound`; consequently
`Lean.ofReduceBool`, `Lean.trustCompiler`, and `sorryAx` are forbidden.
-/

namespace CollatzClassical.KL2003.F3Block0ReverseBFSData

#print axioms ReverseBFSConfig
#print axioms configOfOccurrence
#print axioms ReverseBFSNode
#print axioms ReverseBFSClosureRow
#print axioms ReverseBFSCertificateKind
#print axioms ReverseBFSCertificate
#print axioms nodeValues
#print axioms containsValue
#print axioms predecessorCandidates_card_le_two
#print axioms preimagesWithin_card_le_two
#print axioms expandAt
#print axioms reverseBFSLoop
#print axioms generatedNodes
#print axioms generatedClosureRows
#print axioms generateReverseBFSCertificate

end CollatzClassical.KL2003.F3Block0ReverseBFSData

namespace CollatzClassical.KL2003.F3Block0ReverseBFSVerifier

#print axioms NodeStructurallyValid
#print axioms nodeStructurallyValidBool
#print axioms nodeStructurallyValidBool_eq_true_iff
#print axioms ClosureRowValid
#print axioms closureRowValidDecidable
#print axioms DeficientClosureValid
#print axioms deficientClosureValidDecidable
#print axioms ReverseBFSCertificateValid
#print axioms verifyReverseBFSCertificate
#print axioms verifyReverseBFSCertificate_eq_true_iff
#print axioms verified_node_firstHitViaChildAt
#print axioms verified_node_firstHitViaChild
#print axioms verified_node_mem_orderedFirstHitFiber0
#print axioms verified_nodeValues_nodup
#print axioms verified_nodeValues_toFinset_subset
#print axioms verified_saturated_length
#print axioms verified_nodes_length_le_demand
#print axioms verified_saturated_capacity
#print axioms verified_deficient_has_closure_row
#print axioms verified_deficient_predecessor_closed

end CollatzClassical.KL2003.F3Block0ReverseBFSVerifier

namespace CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration

#print axioms typedReverseBFSConfig
#print axioms generateTypedReverseBFSCertificate
#print axioms verifyTypedReverseBFSCertificate
#print axioms verifyTypedReverseBFSCertificate_eq_true_iff
#print axioms verified_typed_node_mem_orderedFirstHitFiber0
#print axioms verified_typed_nodes_length_le_massDemand
#print axioms verified_typed_saturated_capacity

end CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration

namespace CollatzClassical.KL2003.F3Block0ReverseBFSAudit

private def explicitRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.ReverseBFSConfig,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.configOfOccurrence,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.ReverseBFSNode,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.ReverseBFSClosureRow,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.ReverseBFSCertificateKind,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.ReverseBFSCertificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.nodeValues,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.containsValue,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.predecessorCandidates_card_le_two,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.preimagesWithin_card_le_two,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.expandAt,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.reverseBFSLoop,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.generatedNodes,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.generatedClosureRows,
  `CollatzClassical.KL2003.F3Block0ReverseBFSData.generateReverseBFSCertificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.NodeStructurallyValid,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.nodeStructurallyValidBool,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.nodeStructurallyValidBool_eq_true_iff,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.ClosureRowValid,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.closureRowValidDecidable,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.DeficientClosureValid,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.deficientClosureValidDecidable,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.ReverseBFSCertificateValid,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verifyReverseBFSCertificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verifyReverseBFSCertificate_eq_true_iff,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_node_firstHitViaChildAt,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_node_firstHitViaChild,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_node_mem_orderedFirstHitFiber0,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_nodeValues_nodup,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_nodeValues_toFinset_subset,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_saturated_length,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_nodes_length_le_demand,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_saturated_capacity,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_deficient_has_closure_row,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier.verified_deficient_predecessor_closed,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration.typedReverseBFSConfig,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration.generateTypedReverseBFSCertificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration.verifyTypedReverseBFSCertificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration.verifyTypedReverseBFSCertificate_eq_true_iff,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration.verified_typed_node_mem_orderedFirstHitFiber0,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration.verified_typed_nodes_length_le_massDemand,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration.verified_typed_saturated_capacity
]

private def namespacePrefixes : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSData,
  `CollatzClassical.KL2003.F3Block0ReverseBFSVerifier,
  `CollatzClassical.KL2003.F3Block0ReverseBFSMassIntegration
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

  if explicitRoots.size != 42 then
    Lean.throwError
      m!"explicit reverse-BFS inventory has {explicitRoots.size} entries; expected 42"

  for root in explicitRoots do
    if ← auditDeclaration environment root "EXPLICIT" then
      failed := true
  Lean.logInfo m!"EXPLICIT_DECLARATION_COVERAGE={explicitRoots.size}/42"

  let mut namespaceDeclarationTotal := 0
  for namespacePrefix in namespacePrefixes do
    let declarations :=
      environment.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf
    namespaceDeclarationTotal := namespaceDeclarationTotal + declarations.length
    Lean.logInfo
      m!"NAMESPACE_DECLARATION_COUNT\t{namespacePrefix}\t{declarations.length}"
    for declaration in declarations do
      if ← auditDeclaration environment declaration "NAMESPACE" then
        failed := true
    Lean.logInfo
      m!"NAMESPACE_DECLARATION_COVERAGE\t{namespacePrefix}\t{declarations.length}/{declarations.length}"

  Lean.logInfo m!"NAMESPACE_PREFIX_COVERAGE={namespacePrefixes.size}/3"
  Lean.logInfo m!"NAMESPACE_DECLARATION_TOTAL={namespaceDeclarationTotal}"

  if failed then
    Lean.throwError
      "Block0 reverse-BFS trust audit failed; inspect the declaration profile"
  else
    Lean.logInfo "BLOCK0_REVERSE_BFS_AUDIT_PASS"

end CollatzClassical.KL2003.F3Block0ReverseBFSAudit
