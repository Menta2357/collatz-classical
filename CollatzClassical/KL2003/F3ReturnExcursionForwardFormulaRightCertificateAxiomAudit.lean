import CollatzClassical.KL2003.F3ReturnExcursionForwardFormulaRightCertificate
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

namespace CollatzClassical
namespace KL2003

open F3ForwardFormulaRightCertificate

/-!
Total explicit and environmental axiom audit for the forward right
certificate module.  Every stable declaration is listed with
`#print axioms`; the namespace scan also covers generated declarations.
-/

#print axioms forwardRightWeights81
#print axioms forwardRightBlock
#print axioms forwardRightWeightNat
#print axioms forwardRightWeight
#print axioms lowerChannelCoeff
#print axioms lowerForwardRowNat
#print axioms forwardRightNatCertificate
#print axioms forwardRightNatCertificate_proved
#print axioms lowerChannelCoeff_le_channelWeight
#print axioms forwardRightWeight_nonneg
#print axioms listRowAction
#print axioms listMatrix
#print axioms listRowAction_eq_matrix_sum
#print axioms lowerListRow_le_actual
#print axioms forward_target_le_lower_row
#print axioms formulaForwardMatrix
#print axioms coreMatrix_eq_formulaForwardMatrix
#print axioms formulaForwardMatrix_nonneg
#print axioms formulaForwardMatrix_row_action_identity
#print axioms forwardFormula_row_certificate
#print axioms forward_weighted_mass_step

run_meta do
  let env ← Lean.getEnv
  let namespacePrefix :=
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate
  let declarations := env.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf
  Lean.logInfo m!"NAMESPACE_DECLARATION_COUNT={declarations.length}"
  for declaration in declarations do
    let axioms ← Lean.collectAxioms declaration
    Lean.logInfo m!"AXIOM_PROFILE\t{declaration}\t{axioms.toList}"

end KL2003
end CollatzClassical
