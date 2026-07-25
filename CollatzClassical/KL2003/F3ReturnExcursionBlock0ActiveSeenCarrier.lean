import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveCarrierTotalCards

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-! Structural carriers and equivalences for the 41-root inspected prefix. -/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveCarrierCards

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0CarrierFiberCards
open F3Block0OccurrenceTripleWeights
open F3Block0ActiveCarrier

abbrev SeenActive0Occurrence :=
  {p : Active0Occurrence //
    rootValue (occurrenceRoot p.1) < 128}

abbrev SeenBlock0ActiveOccurrenceSigma :=
  Σ j : Block0SeenIndex, ActiveSourceFormulaEdge (seenRoot j)

def seenIndexOfRoot (i : Block0Root) (h : rootValue i < 128) :
    Block0SeenIndex :=
  ⟨i.1, (rootValue_lt_128_iff i).mp h⟩

theorem seenRoot_seenIndexOfRoot
    (i : Block0Root) (h : rootValue i < 128) :
    seenRoot (seenIndexOfRoot i h) = i := by
  apply Fin.ext
  rfl

theorem seenIndexOfRoot_seenRoot (j : Block0SeenIndex) :
    seenIndexOfRoot (seenRoot j) (seenRoot_value_lt j) = j := by
  apply Fin.ext
  rfl

/-- The 41 seen indices are thirteen complete residue triples followed by
the two indices 39 and 40. -/
def seenIndexSplitEquiv :
    (Fin 13 × Fin 3) ⊕ Fin 2 ≃ Block0SeenIndex :=
  (Equiv.sumCongr finProdFinEquiv (Equiv.refl (Fin 2))).trans
    finSumFinEquiv

theorem rootState_quotient_mod_three_seenSplit_left
    (k : Fin 13) (r : Fin 3) :
    ((rootState (seenRoot (seenIndexSplitEquiv (Sum.inl (k, r))))).1 / 3) % 3 =
      (r.1 + 1) % 3 := by
  rw [rootState_quotient_mod_three]
  change (r.1 + 3 * k.1 + 1) % 3 = (r.1 + 1) % 3
  omega

theorem rootState_quotient_mod_three_seenSplit_right (u : Fin 2) :
    ((rootState (seenRoot (seenIndexSplitEquiv (Sum.inr u)))).1 / 3) % 3 =
      (u.1 + 1) % 3 := by
  rw [rootState_quotient_mod_three]
  change (39 + u.1 + 1) % 3 = (u.1 + 1) % 3
  omega

def seenActive0OccurrenceSigmaEquiv :
    SeenActive0Occurrence ≃ SeenBlock0ActiveOccurrenceSigma where
  toFun p := by
    let j := seenIndexOfRoot (occurrenceRoot p.1.1) p.2
    have hj : seenRoot j = occurrenceRoot p.1.1 :=
      seenRoot_seenIndexOfRoot (occurrenceRoot p.1.1) p.2
    exact
      ⟨j,
        ⟨⟨occurrenceFormulaEdge p.1.1, by
            rw [hj]
            exact p.1.1.2⟩,
          by
            change FormulaActiveAtRoot (seenRoot j)
              (occurrenceFormulaEdge p.1.1)
            rw [hj]
            exact (active0_iff_formulaActiveAtRoot p.1.1).mp p.1.2⟩⟩
  invFun p :=
    ⟨⟨⟨(seenRoot p.1, p.2.1.1), p.2.1.2⟩,
        (active0_iff_formulaActiveAtRoot
          ⟨(seenRoot p.1, p.2.1.1), p.2.1.2⟩).mpr p.2.2⟩,
      seenRoot_value_lt p.1⟩
  left_inv p := by
    apply Subtype.ext
    apply Subtype.ext
    apply Subtype.ext
    apply Prod.ext
    · exact seenRoot_seenIndexOfRoot (occurrenceRoot p.1.1) p.2
    · rfl
  right_inv p := by
    rcases p with ⟨j, ⟨⟨e, hs⟩, ha⟩⟩
    have hj := seenIndexOfRoot_seenRoot j
    cases hj
    rfl

end F3Block0ActiveCarrierCards
end KL2003
end CollatzClassical
