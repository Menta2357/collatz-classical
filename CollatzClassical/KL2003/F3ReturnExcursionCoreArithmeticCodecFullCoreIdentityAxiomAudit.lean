import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

/-!
Total explicit and environmental axiom audit for the finite 243/729 F3 core
identity.  The external inventory checker requires exact declaration
coverage, and the independent whole-log guard scans multiline profiles.
-/

open CollatzClassical.KL2003.F3CoreArithmeticCodecFullCoreIdentity

#print axioms corePositionRealize
#print axioms coreEdges_position_normalization
#print axioms coreEdges_length_kernel
#print axioms core_position_at_formula
#print axioms realize_mem_coreEdges
#print axioms formulaCoreList_subset_coreEdges
#print axioms coreEdges_perm_formulaCoreList
#print axioms fullFormulaMatrix
#print axioms coreMatrix_eq_fullFormulaMatrix

run_meta do
  let env ← Lean.getEnv
  let namespacePrefix :=
    `CollatzClassical.KL2003.F3CoreArithmeticCodecFullCoreIdentity
  let declarations := env.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf
  Lean.logInfo m!"NAMESPACE_DECLARATION_COUNT={declarations.length}"
  for declaration in declarations do
    let axioms ← Lean.collectAxioms declaration
    Lean.logInfo m!"AXIOM_PROFILE\t{declaration}\t{axioms.toList}"
