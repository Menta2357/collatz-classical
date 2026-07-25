import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveCarrier
import CollatzClassical.KL2003.F3ReturnExcursionForwardFormulaRightCertificate

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Formula-edge reindexing of one row of the exact forward F3 operator.

This module only replaces the `CoreEdge` list representation of a matrix row
by the typed fibre of `FormulaEdge`s with that source.  It does not select the
active carrier, introduce the advanced factor three, or state an operator-to-
semantic identity.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveFormulaRow

noncomputable section

open F3ExactCoreMatrix
open F3CoreArithmeticCodecPilotRepair
open F3ForwardFormulaRightCertificate
open F3Block0OccurrenceCards

private def formulaEdgeRowTerm
    (w : Fin 243 → ℝ) (e : FormulaEdge) : ℝ :=
  channelWeight (formulaChannelNat e) * w (formulaTarget e)

private theorem sum_ofFn_eq_fintype_sum
    {n : Nat} (f : Fin n → ℝ) :
    (List.ofFn f).sum = ∑ i : Fin n, f i := by
  rw [List.ofFn_eq_map]
  rw [← List.sum_toFinset f (List.nodup_finRange n)]
  rw [List.toFinset_finRange]

private theorem listRowAction_eq_sum_map_ite
    (edges : List CoreEdge) (s : Fin 243) (w : Fin 243 → ℝ) :
    listRowAction edges s w =
      (edges.map fun e =>
        if e.source = s then channelWeight e.channel * w e.target else 0).sum := by
  induction edges with
  | nil =>
      simp [listRowAction]
  | cons e es ih =>
      by_cases hs : e.source = s
      · calc
          listRowAction (e :: es) s w =
              channelWeight e.channel * w e.target +
                listRowAction es s w := by
            simp [listRowAction, hs]
          _ = channelWeight e.channel * w e.target +
                (es.map fun e =>
                  if e.source = s then
                    channelWeight e.channel * w e.target else 0).sum := by
            rw [ih]
          _ = ((e :: es).map fun e =>
                if e.source = s then
                  channelWeight e.channel * w e.target else 0).sum := by
            simp [hs]
      · calc
          listRowAction (e :: es) s w = listRowAction es s w := by
            simp [listRowAction, hs]
          _ = (es.map fun e =>
                if e.source = s then
                  channelWeight e.channel * w e.target else 0).sum := ih
          _ = ((e :: es).map fun e =>
                if e.source = s then
                  channelWeight e.channel * w e.target else 0).sum := by
            simp [hs]

private theorem listRowAction_formulaCoreList_eq_formulaEdge_sum
    (s : Fin 243) (w : Fin 243 → ℝ) :
    listRowAction formulaCoreList s w =
      ∑ e : FormulaEdge,
        if formulaSource e = s then formulaEdgeRowTerm w e else 0 := by
  rw [listRowAction_eq_sum_map_ite]
  unfold formulaCoreList
  rw [List.map_ofFn]
  rw [sum_ofFn_eq_fintype_sum]
  let g : FormulaEdge → ℝ := fun e =>
    if formulaSource e = s then formulaEdgeRowTerm w e else 0
  have h := formulaEdgeEquivFin729.symm.sum_comp g
  change
    (∑ j : Fin 729, g (formulaUnrank j)) =
      ∑ e : FormulaEdge, g e at h
  simpa only [g, formulaEdgeRowTerm, Function.comp_apply, realize] using h

private theorem formulaEdge_sum_ite_eq_sourceFormulaEdge_sum
    (s : Fin 243) (w : Fin 243 → ℝ) :
    (∑ e : FormulaEdge,
      if formulaSource e = s then formulaEdgeRowTerm w e else 0) =
      ∑ e : SourceFormulaEdge s, formulaEdgeRowTerm w e.1 := by
  classical
  calc
    (∑ e : FormulaEdge,
        if formulaSource e = s then formulaEdgeRowTerm w e else 0) =
        ∑ e in Finset.univ.filter
            (fun e : FormulaEdge => formulaSource e = s),
          formulaEdgeRowTerm w e := by
            rw [Finset.sum_filter]
    _ = ∑ e : SourceFormulaEdge s, formulaEdgeRowTerm w e.1 := by
      simpa using
        (Finset.sum_subtype
          (p := fun e : FormulaEdge => formulaSource e = s)
          (Finset.univ.filter
            (fun e : FormulaEdge => formulaSource e = s))
          (by simp)
          (formulaEdgeRowTerm w))

theorem formulaForwardMatrix_row_eq_sourceFormulaEdge_sum
    (s : Fin 243) (w : Fin 243 → ℝ) :
    (∑ t : Fin 243, formulaForwardMatrix s t * w t) =
      ∑ e : SourceFormulaEdge s,
        channelWeight (formulaChannelNat e.1) * w (formulaTarget e.1) := by
  rw [← formulaForwardMatrix_row_action_identity s w]
  rw [listRowAction_formulaCoreList_eq_formulaEdge_sum]
  simpa only [formulaEdgeRowTerm] using
    formulaEdge_sum_ite_eq_sourceFormulaEdge_sum s w

/-!
Scope: exact structural row reindexing only.  No active-carrier count,
advanced multiplicity factor, semantic fibre, exponent, or density statement
is proved here.
-/

end

end F3Block0ActiveFormulaRow
end KL2003
end CollatzClassical
