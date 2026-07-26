import CollatzClassical.KL2003.F3ReturnExcursionBlock0SemanticChildBaseHit
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

set_option maxRecDepth 100000

/-!
Fail-hard exhaustive trust audit for the semantic-child base-hit module.

The three explicit roots below are every public source-level declaration in
`F3ReturnExcursionBlock0SemanticChildBaseHit`.  The namespace sweep must have
exactly the same cardinality, so adding an unaudited declaration makes this
module fail.  Every root is then checked through its complete dependency cone;
only Lean's standard logical axioms `propext`, `Classical.choice`, and
`Quot.sound` are permitted.

This source records the audit contract only.  Compilation remains a separate
gate.
-/

namespace CollatzClassical.KL2003.F3Block0SemanticChildBaseHit

#print axioms semanticChildRoot_firstHitViaChildAt_zero
#print axioms semanticChildRoot_mem_orderedFirstHitFiber0
#print axioms massDemand_le_orderedFirstHitFiber0_card_of_eq_one

end CollatzClassical.KL2003.F3Block0SemanticChildBaseHit

namespace CollatzClassical.KL2003.F3Block0SemanticChildBaseHitAudit

private def explicitRoots : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0SemanticChildBaseHit.semanticChildRoot_firstHitViaChildAt_zero,
  `CollatzClassical.KL2003.F3Block0SemanticChildBaseHit.semanticChildRoot_mem_orderedFirstHitFiber0,
  `CollatzClassical.KL2003.F3Block0SemanticChildBaseHit.massDemand_le_orderedFirstHitFiber0_card_of_eq_one
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

  if explicitRoots.size != 3 then
    Lean.throwError
      m!"explicit semantic-child base-hit inventory has {explicitRoots.size} entries; expected 3"

  for root in explicitRoots do
    if ← auditDeclaration environment root "EXPLICIT" then
      failed := true
  Lean.logInfo m!"EXPLICIT_DECLARATION_COVERAGE={explicitRoots.size}/3"

  let namespacePrefix :=
    `CollatzClassical.KL2003.F3Block0SemanticChildBaseHit
  let declarations :=
    environment.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf
  if declarations.length != explicitRoots.size then
    Lean.logError
      m!"NAMESPACE_INVENTORY_MISMATCH\tactual={declarations.length}\texpected={explicitRoots.size}"
    failed := true
  for declaration in declarations do
    if ← auditDeclaration environment declaration "NAMESPACE" then
      failed := true
  Lean.logInfo
    m!"NAMESPACE_DECLARATION_COVERAGE={declarations.length}/{explicitRoots.size}"

  if failed then
    Lean.throwError "Block0 semantic-child base-hit trust audit failed"
  else
    Lean.logInfo "BLOCK0_SEMANTIC_CHILD_BASE_HIT_AUDIT_PASS"

end CollatzClassical.KL2003.F3Block0SemanticChildBaseHitAudit
