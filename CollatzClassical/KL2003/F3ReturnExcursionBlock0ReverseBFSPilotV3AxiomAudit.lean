import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotV3
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

/-!
# Exhaustive trust audit for the six-row branch-complete pilot

The stable inventory is closed in both directions across RowsV3, the generated
PayloadsV3 module, and PilotV3.  Compiler-generated internal details are not
named ahead of elaboration, but every one must descend from an expected stable
declaration and is included in the `Lean.collectAxioms` sweep.

Public/stable declarations permit only `propext`, `Classical.choice`, and
`Quot.sound`.  Internal details may additionally use the frozen compiler
implementation axiom `lcProof`.  No profile permits `Lean.ofReduceBool`,
`Lean.trustCompiler`, or `sorryAx`.
-/

namespace CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3

#print axioms FixedPilotRowV3
#print axioms fixedRow01
#print axioms fixedRow02
#print axioms fixedRow03
#print axioms fixedRow04
#print axioms fixedRow05
#print axioms fixedRow06
#print axioms fixedRow01_coordinates
#print axioms fixedRow02_coordinates
#print axioms fixedRow03_coordinates
#print axioms fixedRow04_coordinates
#print axioms fixedRow05_coordinates
#print axioms fixedRow06_coordinates

end CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3

namespace CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3

#print axioms fixedRow01Certificate
#print axioms fixedRow02Certificate
#print axioms fixedRow03Certificate
#print axioms fixedRow04Certificate
#print axioms fixedRow05Certificate
#print axioms fixedRow06Certificate

end CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3

namespace CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3

#print axioms VerifiedTypedReverseBFSOutcome
#print axioms verifiedTypedReverseBFSOutcome_of_check
#print axioms fixedRow01_check
#print axioms fixedRow02_check
#print axioms fixedRow03_check
#print axioms fixedRow04_check
#print axioms fixedRow05_check
#print axioms fixedRow06_check
#print axioms fixedRow01_outcome
#print axioms fixedRow02_outcome
#print axioms fixedRow03_outcome
#print axioms fixedRow04_outcome
#print axioms fixedRow05_outcome
#print axioms fixedRow06_outcome

end CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3

namespace CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3Audit

private def rowsSourceDeclarations : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow01,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow02,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow03,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow04,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow05,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow06,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow01_coordinates,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow02_coordinates,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow03_coordinates,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow04_coordinates,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow05_coordinates,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.fixedRow06_coordinates
]

private def payloadSourceDeclarations : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3.fixedRow01Certificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3.fixedRow02Certificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3.fixedRow03Certificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3.fixedRow04Certificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3.fixedRow05Certificate,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3.fixedRow06Certificate
]

private def pilotSourceDeclarations : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.VerifiedTypedReverseBFSOutcome,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.verifiedTypedReverseBFSOutcome_of_check,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow01_check,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow02_check,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow03_check,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow04_check,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow05_check,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow06_check,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow01_outcome,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow02_outcome,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow03_outcome,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow04_outcome,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow05_outcome,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.fixedRow06_outcome
]

private def publicSourceDeclarations : Array Lean.Name :=
  rowsSourceDeclarations ++ payloadSourceDeclarations ++ pilotSourceDeclarations

private def structureGeneratedDeclarations : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.mk,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.order,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.canonicalId,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.legacyRowId,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.occurrence,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.rec,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.recOn,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.casesOn,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.noConfusionType.withCtorType,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.noConfusionType.withCtor,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.noConfusionType,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.noConfusion,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.mk.inj,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.mk.injEq,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3.FixedPilotRowV3.mk.sizeOf_spec
]

private def outcomeGeneratedDeclarations : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.VerifiedTypedReverseBFSOutcome.saturated,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.VerifiedTypedReverseBFSOutcome.deficient,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.VerifiedTypedReverseBFSOutcome.rec,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.VerifiedTypedReverseBFSOutcome.recOn,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3.VerifiedTypedReverseBFSOutcome.casesOn
]

private def stableGeneratedDeclarations : Array Lean.Name :=
  structureGeneratedDeclarations ++ outcomeGeneratedDeclarations

private def expectedStableDeclarations : Array Lean.Name :=
  publicSourceDeclarations ++ stableGeneratedDeclarations

private def namespacePrefixes : Array Lean.Name := #[
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotRowsV3,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotPayloadsV3,
  `CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3
]

private def publicAllowedAxiomNames : Lean.NameSet :=
  ({} : Lean.NameSet)
    |>.insert `propext
    |>.insert `Classical.choice
    |>.insert `Quot.sound

private def internalAllowedAxiomNames : Lean.NameSet :=
  publicAllowedAxiomNames.insert `lcProof

private def forbiddenAxiomNames : Lean.NameSet :=
  ({} : Lean.NameSet)
    |>.insert `Lean.ofReduceBool
    |>.insert `Lean.trustCompiler
    |>.insert `sorryAx

private def hasDuplicateNames : List Lean.Name → Bool
  | [] => false
  | name :: rest => rest.contains name || hasDuplicateNames rest

private def hasExpectedStableAncestor (name : Lean.Name) : Bool :=
  expectedStableDeclarations.any fun stable =>
    stable != name && stable.isPrefixOf name

private def checkInventory
    (label : String) (names : Array Lean.Name) (expectedSize : Nat) :
    Lean.MetaM Bool := do
  let mut failed := false
  if names.size != expectedSize then
    Lean.logError
      m!"{label}_INVENTORY_SIZE_MISMATCH\tactual={names.size}\texpected={expectedSize}"
    failed := true
  if names.isEmpty then
    Lean.logError m!"{label}_INVENTORY_EMPTY"
    failed := true
  if hasDuplicateNames names.toList then
    Lean.logError m!"{label}_INVENTORY_DUPLICATE"
    failed := true
  return failed

private def auditDeclaration
    (environment : Lean.Environment) (declaration : Lean.Name) :
    Lean.MetaM Bool := do
  if (environment.checked.get.find? declaration).isNone then
    Lean.logError m!"ACTUAL_DECLARATION_MISSING\t{declaration}"
    return true
  let axioms ← Lean.collectAxioms declaration
  let isInternal := declaration.isInternalDetail
  let allowed :=
    if isInternal then internalAllowedAxiomNames
    else publicAllowedAxiomNames
  let unexpected := axioms.filter fun axiomName =>
    !allowed.contains axiomName
  let forbidden := axioms.filter forbiddenAxiomNames.contains
  if isInternal then
    Lean.logInfo
      m!"INTERNAL_DETAIL_AXIOM_PROFILE\t{declaration}\t{axioms.toList}"
  else
    Lean.logInfo
      m!"PUBLIC_STABLE_AXIOM_PROFILE\t{declaration}\t{axioms.toList}"
  let mut failed := false
  if !forbidden.isEmpty then
    Lean.logError
      m!"ABSOLUTELY_FORBIDDEN_AXIOM\troot={declaration}\thits={forbidden.toList}"
    failed := true
  if !unexpected.isEmpty then
    Lean.logError
      m!"UNEXPECTED_AXIOM_PROFILE\troot={declaration}\tinternal={isInternal}\thits={unexpected.toList}"
    failed := true
  return failed

run_meta do
  let environment ← Lean.getEnv
  let mut failed := false

  if ← checkInventory "ROWS_SOURCE" rowsSourceDeclarations 13 then
    failed := true
  if ← checkInventory "PAYLOAD_SOURCE" payloadSourceDeclarations 6 then
    failed := true
  if ← checkInventory "PILOT_SOURCE" pilotSourceDeclarations 14 then
    failed := true
  if ← checkInventory "PUBLIC_SOURCE" publicSourceDeclarations 33 then
    failed := true
  if ← checkInventory "STRUCTURE_GENERATED" structureGeneratedDeclarations 15 then
    failed := true
  if ← checkInventory "OUTCOME_GENERATED" outcomeGeneratedDeclarations 5 then
    failed := true
  if ← checkInventory "STABLE_GENERATED" stableGeneratedDeclarations 20 then
    failed := true
  if ← checkInventory "EXPECTED_STABLE" expectedStableDeclarations 53 then
    failed := true
  if ← checkInventory "NAMESPACE_PREFIX" namespacePrefixes 3 then
    failed := true

  let actual :=
    environment.constants.toList.map Prod.fst |>.filter fun declaration =>
      namespacePrefixes.any fun namespacePrefix =>
        namespacePrefix.isPrefixOf declaration
  if actual.isEmpty then
    Lean.logError "ACTUAL_NAMESPACE_INVENTORY_EMPTY"
    failed := true

  for namespacePrefix in namespacePrefixes do
    let declarations := actual.filter namespacePrefix.isPrefixOf
    if declarations.isEmpty then
      Lean.logError m!"NAMESPACE_INVENTORY_EMPTY\t{namespacePrefix}"
      failed := true
    Lean.logInfo
      m!"NAMESPACE_DECLARATION_COUNT\t{namespacePrefix}\t{declarations.length}"

  let actualStable := actual.filter fun declaration =>
    !declaration.isInternalDetail
  let actualInternal := actual.filter Lean.Name.isInternalDetail

  if actualStable.isEmpty then
    Lean.logError "ACTUAL_STABLE_INVENTORY_EMPTY"
    failed := true

  for expected in expectedStableDeclarations do
    if !actualStable.contains expected then
      Lean.logError m!"EXPECTED_STABLE_DECLARATION_MISSING\t{expected}"
      failed := true
  for declaration in actualStable do
    if !expectedStableDeclarations.contains declaration then
      Lean.logError m!"UNEXPECTED_STABLE_DECLARATION\t{declaration}"
      failed := true

  for declaration in actualInternal do
    if !hasExpectedStableAncestor declaration then
      Lean.logError m!"ORPHANED_INTERNAL_DETAIL\t{declaration}"
      failed := true

  for declaration in actual do
    if ← auditDeclaration environment declaration then
      failed := true

  Lean.logInfo
    m!"PUBLIC_SOURCE_DECLARATION_COVERAGE={publicSourceDeclarations.size}/33"
  Lean.logInfo
    m!"STABLE_GENERATED_DECLARATION_COVERAGE={stableGeneratedDeclarations.size}/20"
  Lean.logInfo
    m!"EXPECTED_STABLE_DECLARATION_COVERAGE={actualStable.length}/{expectedStableDeclarations.size}"
  Lean.logInfo
    m!"INTERNAL_DETAIL_DECLARATION_COVERAGE={actualInternal.length}/{actualInternal.length}"
  Lean.logInfo m!"COMPLETE_ACTUAL_DECLARATION_COVERAGE={actual.length}/{actual.length}"

  if failed then
    Lean.throwError
      "PilotV3 exhaustive trust audit failed; inspect the inventory or axiom profile"
  else
    Lean.logInfo "F3_R3_REVERSE_BFS_PILOT_V3_AXIOM_AUDIT_PASS"

end CollatzClassical.KL2003.F3Block0ReverseBFSPilotV3Audit
