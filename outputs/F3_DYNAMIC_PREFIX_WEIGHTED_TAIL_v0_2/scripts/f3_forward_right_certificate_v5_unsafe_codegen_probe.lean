import CollatzClassical.KL2003.F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

open Lean

run_meta do
  let env ← Lean.getEnv
  let stableNames : Array Name := #[
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeights81,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightBlock,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeightNat,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeight,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerChannelCoeff,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightNatCertificate,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightNatCertificate_proved,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerChannelCoeff_le_channelWeight,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeight_nonneg,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.listRowAction,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.listMatrix,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.listRowAction_eq_matrix_sum,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerListRow_le_actual,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forward_target_le_lower_row,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.formulaForwardMatrix,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.coreMatrix_eq_formulaForwardMatrix,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.formulaForwardMatrix_nonneg,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.formulaForwardMatrix_row_action_identity,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardFormula_row_certificate,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forward_weighted_mass_step
  ]
  let specialAxioms : Array Name := #[
    `List.filterTR.loop._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_1,
    `List.foldrTR._at.CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._spec_2,
    `Nat.cast._at.Real.instNatCast._spec_2
  ]
  let allowedStableAxioms : Array Name := #[
    `propext,
    `Classical.choice,
    `Quot.sound
  ]
  let generatedOwners : Array Name := #[
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.lowerForwardRowNat._cstage2,
    `CollatzClassical.KL2003.F3ForwardFormulaRightCertificate.forwardRightWeight._cstage2
  ]

  unless stableNames.size == 21 do
    throwError "stable-name inventory is not 21"
  unless specialAxioms.size == 3 do
    throwError "special-axiom inventory is not 3"
  unless allowedStableAxioms.size == 3 do
    throwError "stable-axiom allowlist is not 3"
  unless generatedOwners.size == 2 do
    throwError "generated-owner inventory is not 2"

  for special in specialAxioms do
    match env.checked.get.find? special with
    | some (.axiomInfo info) =>
        unless info.isUnsafe do
          throwError m!"codegen specialization is not unsafe: {special}"
        Lean.logInfo m!"F3_FORWARD_V5_UNSAFE_AXIOM={special}"
    | some _ =>
        throwError m!"codegen specialization is not axiomInfo: {special}"
    | none =>
        throwError m!"missing codegen specialization: {special}"

  for owner in generatedOwners do
    match env.checked.get.find? owner with
    | some info =>
        unless info.isUnsafe do
          throwError m!"generated owner is not unsafe: {owner}"
        Lean.logInfo m!"F3_FORWARD_V5_UNSAFE_OWNER={owner}"
    | none =>
        throwError m!"missing generated owner: {owner}"

  for stable in stableNames do
    match env.checked.get.find? stable with
    | some info =>
        if info.isUnsafe then
          throwError m!"stable declaration is unsafe: {stable}"
    | none =>
        throwError m!"missing stable declaration: {stable}"
    let axioms ← Lean.collectAxioms stable
    for axiomName in axioms do
      unless allowedStableAxioms.contains axiomName do
        throwError m!"nonlogical axiom reached stable cone: {stable} -> {axiomName}"
    for special in specialAxioms do
      if axioms.contains special then
        throwError m!"codegen specialization reached stable cone: {stable} -> {special}"

  Lean.logInfo m!"F3_FORWARD_V5_STABLE_NAMES={stableNames.size}"
  Lean.logInfo "F3_FORWARD_V5_STABLE_ALLOWED_AXIOM_SET_ONLY=PASS"
  Lean.logInfo "F3_FORWARD_V5_STABLE_SPECIAL_AXIOMS=0"
  Lean.logInfo "F3_FORWARD_V5_UNSAFE_CODEGEN_PROBE=PASS"
