import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecPilotRepair

/-!
Total axiom surface for the repaired 27-source arithmetic-codec pilot.

The corresponding frozen inventory is
`F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_DECLARATION_INVENTORY_v1.tsv`.
Every explicit public `def`, `theorem`, named `instance`, `abbrev`, and
`inductive` in the source has exactly one command below.  The static checker
compares this command list against the source inventory before execution.
This file is run only after the repaired module compiles within its fixed
single-attempt gate.
-/

open CollatzClassical.KL2003.F3CoreArithmeticCodecPilotRepair

#print axioms encodeNat
#print axioms encodeNat_lt_729
#print axioms encodeNat_mod9
#print axioms CoreCode
#print axioms encode
#print axioms encode_mem_coreCode
#print axioms decodeNat
#print axioms decodeNat_lt_243
#print axioms decode
#print axioms decode_encode
#print axioms encode_decode
#print axioms encode_injective
#print axioms decode_injective
#print axioms coreCodeEquiv
#print axioms coreCodeFintype
#print axioms coreCode_card
#print axioms bucketCode
#print axioms bucketCode_lt_three
#print axioms stateCodeNat
#print axioms stateCodeNat_lt_729
#print axioms stateCodeNat_mod9
#print axioms stateCode
#print axioms decode_stateCode_affine_val
#print axioms n0
#print axioms adjust
#print axioms a
#print axioms c
#print axioms adjust_zero_spec
#print axioms adjust_one_spec
#print axioms adjust_two_spec
#print axioms a_bucketCode
#print axioms c_expanded
#print axioms c_mod2
#print axioms DirectSource
#print axioms LiftSource
#print axioms directSource_mod9
#print axioms liftSource_mod9
#print axioms directSourceRankNat
#print axioms directSourceRankNat_lt_81
#print axioms directSourceRank
#print axioms directSourceUnrankNat
#print axioms directSourceUnrankNat_lt_243
#print axioms directSourceUnrank_eligible
#print axioms directSourceUnrank
#print axioms directSource_rank_unrank
#print axioms directSource_unrank_rank
#print axioms directSourceEquiv
#print axioms directSourceRank_injective
#print axioms liftSourceRankNat
#print axioms liftSourceRankNat_lt_81
#print axioms liftSourceRank
#print axioms liftSourceUnrankNat
#print axioms liftSourceUnrankNat_lt_243
#print axioms liftSourceUnrank_eligible
#print axioms liftSourceUnrank
#print axioms liftSource_rank_unrank
#print axioms liftSource_unrank_rank
#print axioms liftSourceEquiv
#print axioms liftSourceRank_injective
#print axioms FormulaEdge
#print axioms retardedTarget
#print axioms directOffset
#print axioms direct_c_mod3
#print axioms lift_c_mod3
#print axioms lift_twice_c_mod3
#print axioms direct_c_bucket
#print axioms lift_twice_c_bucket
#print axioms directStateCode
#print axioms liftStateCode
#print axioms directTarget
#print axioms liftTarget
#print axioms directK
#print axioms direct_c_affine
#print axioms liftK
#print axioms lift_twice_c_affine
#print axioms directTargetClosed
#print axioms liftTargetClosed
#print axioms directK_mod81
#print axioms liftK_mod81
#print axioms directTarget_closed_form
#print axioms liftTarget_closed_form
#print axioms formulaSource
#print axioms formulaTarget
#print axioms formulaChannelNat
#print axioms realize
#print axioms directTarget_ell_injective
#print axioms liftTarget_ell_injective
#print axioms realize_injective
#print axioms formulaRank
#print axioms formulaUnrank
#print axioms formulaRank_unrank
#print axioms formulaRank_injective_raw
#print axioms formulaUnrank_rank
#print axioms formulaEdgeEquivFin729
#print axioms formulaRank_injective
#print axioms formulaEdge_card
#print axioms formulaCoreList
#print axioms formulaCoreList_length
#print axioms formulaCoreList_nodup
#print axioms formula_channel_cardinality
#print axioms PilotFormulaEdge
#print axioms fin27To243
#print axioms fin9To81
#print axioms pilotEmbed
#print axioms pilotRank
#print axioms pilotUnrank
#print axioms pilotRank_unrank
#print axioms pilotRank_injective_raw
#print axioms pilotUnrank_rank
#print axioms pilotEdgeEquivFin81
#print axioms pilotRank_injective
#print axioms pilotFormulaEdge_card
#print axioms pilot_channel_cardinality
#print axioms pilotEmbed_injective
#print axioms pilotRealize
#print axioms pilotRealize_injective
#print axioms pilotFormulaList
#print axioms pilotFormulaList_length
#print axioms pilotFormulaList_nodup
#print axioms rowStart
#print axioms frozenPosNat
#print axioms frozenPosNat_lt_729
#print axioms frozenPos
#print axioms pilotFrozenPos_lt_81
#print axioms pilotFrozenPos
#print axioms pilotFrozenPos_agrees
#print axioms pilotFrozen
#print axioms pilotPositionToRank
#print axioms pilotPositionUnrank
#print axioms pilotPositionToRank_frozenPos
#print axioms pilotPositionUnrank_frozenPos
#print axioms pilotFrozenPos_injective
#print axioms pilotPositionRealize
#print axioms pilotFrozen_position_normalization
#print axioms pilotFrozen_length
#print axioms pilot_position_at_formula
#print axioms pilot_frozen_at_formula
#print axioms pilotRealize_mem_frozen
#print axioms pilotFormulaList_subset_frozen
#print axioms saturation_perm_of_subset_nodup_card
#print axioms pilotFrozen_perm_formula
#print axioms pilotFrozen_nodup
#print axioms pilotFrozen_toFinset_eq_formula
#print axioms pilotEmbed_source_lt_27
#print axioms pilot_frozen_scope
#print axioms edgeMatches
#print axioms matrixOf
#print axioms matrixOf_eq_of_perm
#print axioms pilotFrozenMatrix
#print axioms pilotFormulaMatrix
#print axioms pilot_matrix_eq_formulaMatrix
