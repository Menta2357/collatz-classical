import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Finite 243-source/729-edge identity for the frozen F3 core.

The only contact with the historical 729-entry literal is the positional
normalization below.  Every later result uses the symbolic decoder, the
formula-side Nodup theorem, and the generic saturation/permutation lemmas
already audited in the pilot module.  In particular, this module does not use
the historical native edge-count or channel-validity certificates.
-/

namespace CollatzClassical
namespace KL2003
namespace F3CoreArithmeticCodecFullCoreIdentity

open F3ExactCoreMatrix
open F3CoreArithmeticCodecPilotRepair
open F3CoreArithmeticCodecFullBlockDecoder

/-! ## Sole full-literal normalization -/

def corePositionRealize (j : Fin 729) : CoreEdge :=
  realize (corePositionUnrank j)

theorem coreEdges_position_normalization :
    coreEdges = List.ofFn corePositionRealize := by
  rfl

theorem coreEdges_length_kernel : coreEdges.length = 729 := by
  rw [coreEdges_position_normalization]
  exact List.length_ofFn

/-! ## Coverage and saturation -/

theorem core_position_at_formula (e : FormulaEdge) :
    corePositionRealize (frozenPos e) = realize e := by
  unfold corePositionRealize
  rw [corePositionUnrank_frozenPos]

theorem realize_mem_coreEdges (e : FormulaEdge) :
    realize e ∈ coreEdges := by
  rw [coreEdges_position_normalization, List.mem_ofFn']
  exact ⟨frozenPos e, core_position_at_formula e⟩

theorem formulaCoreList_subset_coreEdges : formulaCoreList ⊆ coreEdges := by
  intro edge hedge
  rw [formulaCoreList, List.mem_ofFn'] at hedge
  obtain ⟨j, rfl⟩ := hedge
  exact realize_mem_coreEdges (formulaUnrank j)

theorem coreEdges_perm_formulaCoreList : coreEdges.Perm formulaCoreList := by
  have hCard : coreEdges.length ≤ formulaCoreList.length := by
    rw [coreEdges_length_kernel, formulaCoreList_length]
  have hPerm := saturation_perm_of_subset_nodup_card
    formulaCoreList_nodup formulaCoreList_subset_coreEdges hCard
  exact hPerm.symm

/-! ## Matrix identity -/

noncomputable def fullFormulaMatrix (s t : Fin 243) : ℝ :=
  (formulaCoreList.filter (fun e => e.source = s ∧ e.target = t)).foldr
    (fun e acc => channelWeight e.channel + acc) 0

theorem coreMatrix_eq_fullFormulaMatrix (s t : Fin 243) :
    F3ExactCoreMatrix.coreMatrix s t = fullFormulaMatrix s t := by
  unfold F3ExactCoreMatrix.coreMatrix fullFormulaMatrix
  exact List.Perm.foldr_eq'
    (f := fun (e : CoreEdge) (acc : ℝ) =>
      channelWeight e.channel + acc)
    (coreEdges_perm_formulaCoreList.filter
      (fun e => e.source = s ∧ e.target = t))
    (fun x _ y _ z =>
      add_left_comm (channelWeight y.channel)
        (channelWeight x.channel) z)
    (0 : ℝ)

/-!
Scope: exact finite core identity only.  This module proves no first-hit
inequality, F3 exponent, density theorem, almost-everywhere statement, or
global Collatz conclusion.
-/

end F3CoreArithmeticCodecFullCoreIdentity
end KL2003
end CollatzClassical
