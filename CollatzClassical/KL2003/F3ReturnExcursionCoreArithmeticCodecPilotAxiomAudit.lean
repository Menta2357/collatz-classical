import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecPilot

/-!
Axiom surface for the reviewed 27-source arithmetic-codec pilot.
This file is run only after the pilot module compiles within its fixed gate.
-/

open CollatzClassical.KL2003.F3CoreArithmeticCodecPilot

#print axioms decode_encode
#print axioms encode_decode
#print axioms encode_mem_coreCode
#print axioms coreCode_card
#print axioms stateCodeNat_mod9
#print axioms decode_stateCode_affine_val
#print axioms a_bucketCode
#print axioms c_expanded
#print axioms directTarget_closed_form
#print axioms liftTarget_closed_form
#print axioms realize_injective
#print axioms formulaRank_unrank
#print axioms formulaUnrank_rank
#print axioms formulaEdge_card
#print axioms formulaCoreList_nodup
#print axioms pilotRank_unrank
#print axioms pilotUnrank_rank
#print axioms pilotFormulaEdge_card
#print axioms pilotFormulaList_nodup
#print axioms pilotPositionUnrank_frozenPos
#print axioms pilotFrozen_length
#print axioms pilot_frozen_at_formula
#print axioms pilotFrozen_perm_formula
#print axioms pilot_frozen_scope
#print axioms pilot_matrix_eq_formulaMatrix
