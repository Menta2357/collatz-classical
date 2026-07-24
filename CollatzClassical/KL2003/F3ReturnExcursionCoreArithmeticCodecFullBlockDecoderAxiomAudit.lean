import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder
import Lean.Meta.Basic
import Lean.Util.CollectAxioms

/-!
Total explicit and environmental axiom audit for the symbolic full-block
decoder.  The source/inventory/audit checker requires exact 30/30/30 coverage;
the independent v2 whole-log guard rejects forbidden axioms even when an
environmental profile wraps across multiple lines.
-/

open CollatzClassical.KL2003.F3CoreArithmeticCodecFullBlockDecoder

#print axioms joinPosition
#print axioms positionBlock
#print axioms positionLocal
#print axioms positionBlock_join
#print axioms positionLocal_join
#print axioms fin27Shift
#print axioms fin9Shift
#print axioms fin243Block
#print axioms fin243Local
#print axioms fin81Block
#print axioms fin81Local
#print axioms fin27Shift_block_local
#print axioms fin9Shift_block_local
#print axioms liftPilotEdge
#print axioms edgeBlock
#print axioms edgeLocal
#print axioms liftPilotEdge_edgeBlock_edgeLocal
#print axioms fin9Shift_div3
#print axioms fin9Shift_mod3
#print axioms directSourceUnrank_shift
#print axioms liftSourceUnrank_shift
#print axioms formulaSource_liftPilotEdge
#print axioms rowStart_shift
#print axioms rowStart_formulaSource_liftPilotEdge
#print axioms frozenPos_liftPilotEdge
#print axioms frozenPos_eq_joinPosition
#print axioms corePositionUnrank
#print axioms corePositionToRank
#print axioms corePositionUnrank_frozenPos
#print axioms corePositionToRank_frozenPos

run_meta do
  let env ← Lean.getEnv
  let namespacePrefix :=
    `CollatzClassical.KL2003.F3CoreArithmeticCodecFullBlockDecoder
  let declarations := env.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf
  Lean.logInfo m!"NAMESPACE_DECLARATION_COUNT={declarations.length}"
  for declaration in declarations do
    let axioms ← Lean.collectAxioms declaration
    Lean.logInfo m!"AXIOM_PROFILE\t{declaration}\t{axioms.toList}"
