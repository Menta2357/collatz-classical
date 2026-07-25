import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveCarrier

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Structural cardinality of the active formula-edge fibre over one Block0 root.
The three possible source residues contribute respectively two, one, and two
active formula constructors.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveCarrierCards

open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0OccurrenceCards
open F3Block0ActiveCarrier
open F3CoreArithmeticCodecPilotRepair

abbrev ActiveSourceFormulaEdge (i : Block0Root) :=
  {e : SourceFormulaEdge (rootState i) //
    FormulaActiveAtRoot i e.1}

abbrev Block0ActiveOccurrenceSigma :=
  Σ i : Block0Root, ActiveSourceFormulaEdge i

def active0OccurrenceSigmaEquiv :
    Active0Occurrence ≃ Block0ActiveOccurrenceSigma where
  toFun p :=
    ⟨occurrenceRoot p.1,
      ⟨⟨occurrenceFormulaEdge p.1, p.1.2⟩,
        (active0_iff_formulaActiveAtRoot p.1).mp p.2⟩⟩
  invFun p :=
    ⟨⟨(p.1, p.2.1.1), p.2.1.2⟩,
      (active0_iff_formulaActiveAtRoot
        ⟨(p.1, p.2.1.1), p.2.1.2⟩).mpr p.2.2⟩
  left_inv p := by
    rcases p with ⟨⟨⟨i, e⟩, hs⟩, ha⟩
    rfl
  right_inv p := by
    rcases p with ⟨i, ⟨⟨e, hs⟩, ha⟩⟩
    rfl

theorem active0Occurrence_card_eq_sum_sourceFibers :
    Fintype.card Active0Occurrence =
      ∑ i : Block0Root, Fintype.card (ActiveSourceFormulaEdge i) := by
  rw [Fintype.card_congr active0OccurrenceSigmaEquiv]
  exact Fintype.card_sigma

def activeSourceFormulaEdgeEquivQ0 (i : Block0Root)
    (h0 : ((rootState i).1 / 3) % 3 = 0) :
    ActiveSourceFormulaEdge i ≃ Bool where
  toFun e := by
    rcases e with ⟨⟨e, hs⟩, ha⟩
    cases e with
    | retarded s => exact false
    | advancedDirect s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have h2 : ((rootState i).1 / 3) % 3 = 2 := by
          rw [← hsource]
          exact s.2
        omega
    | advancedParityLift s ell => exact true
  invFun b := by
    cases b with
    | false =>
        exact ⟨⟨.retarded (rootState i), rfl⟩, trivial⟩
    | true =>
        exact
          ⟨⟨.advancedParityLift
              ⟨rootState i, h0⟩ (rootFineLift i), rfl⟩, rfl⟩
  left_inv e := by
    rcases e with ⟨⟨e, hs⟩, ha⟩
    cases e with
    | retarded s =>
        have hsource : s = rootState i := by
          simpa [formulaSource] using hs
        subst s
        rfl
    | advancedDirect s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have h2 : ((rootState i).1 / 3) % 3 = 2 := by
          rw [← hsource]
          exact s.2
        omega
    | advancedParityLift s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have hsEq : s = (⟨rootState i, h0⟩ : LiftSource) :=
          Subtype.ext hsource
        have hell : rootFineLift i = ell := by
          simpa [FormulaActiveAtRoot] using ha
        subst s
        subst ell
        rfl
  right_inv b := by
    cases b <;> rfl

def activeSourceFormulaEdgeEquivQ1 (i : Block0Root)
    (h1 : ((rootState i).1 / 3) % 3 = 1) :
    ActiveSourceFormulaEdge i ≃ Unit where
  toFun _ := ()
  invFun _ := ⟨⟨.retarded (rootState i), rfl⟩, trivial⟩
  left_inv e := by
    rcases e with ⟨⟨e, hs⟩, ha⟩
    cases e with
    | retarded s =>
        have hsource : s = rootState i := by
          simpa [formulaSource] using hs
        subst s
        rfl
    | advancedDirect s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have h2 : ((rootState i).1 / 3) % 3 = 2 := by
          rw [← hsource]
          exact s.2
        omega
    | advancedParityLift s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have h0 : ((rootState i).1 / 3) % 3 = 0 := by
          rw [← hsource]
          exact s.2
        omega
  right_inv u := by
    cases u
    rfl

def activeSourceFormulaEdgeEquivQ2 (i : Block0Root)
    (h2 : ((rootState i).1 / 3) % 3 = 2) :
    ActiveSourceFormulaEdge i ≃ Bool where
  toFun e := by
    rcases e with ⟨⟨e, hs⟩, ha⟩
    cases e with
    | retarded s => exact false
    | advancedDirect s ell => exact true
    | advancedParityLift s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have h0 : ((rootState i).1 / 3) % 3 = 0 := by
          rw [← hsource]
          exact s.2
        omega
  invFun b := by
    cases b with
    | false =>
        exact ⟨⟨.retarded (rootState i), rfl⟩, trivial⟩
    | true =>
        exact
          ⟨⟨.advancedDirect
              ⟨rootState i, h2⟩ (rootFineLift i), rfl⟩, rfl⟩
  left_inv e := by
    rcases e with ⟨⟨e, hs⟩, ha⟩
    cases e with
    | retarded s =>
        have hsource : s = rootState i := by
          simpa [formulaSource] using hs
        subst s
        rfl
    | advancedDirect s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have hsEq : s = (⟨rootState i, h2⟩ : DirectSource) :=
          Subtype.ext hsource
        have hell : rootFineLift i = ell := by
          simpa [FormulaActiveAtRoot] using ha
        subst s
        subst ell
        rfl
    | advancedParityLift s ell =>
        have hsource : s.1 = rootState i := by
          simpa [formulaSource] using hs
        have h0 : ((rootState i).1 / 3) % 3 = 0 := by
          rw [← hsource]
          exact s.2
        omega
  right_inv b := by
    cases b <;> rfl

theorem activeSourceFormulaEdge_card (i : Block0Root) :
    Fintype.card (ActiveSourceFormulaEdge i) =
      if ((rootState i).1 / 3) % 3 = 1 then 1 else 2 := by
  have hlt : ((rootState i).1 / 3) % 3 < 3 :=
    Nat.mod_lt _ (by omega)
  by_cases h0 : ((rootState i).1 / 3) % 3 = 0
  · rw [Fintype.card_congr (activeSourceFormulaEdgeEquivQ0 i h0)]
    simp [h0]
  · by_cases h2 : ((rootState i).1 / 3) % 3 = 2
    · rw [Fintype.card_congr (activeSourceFormulaEdgeEquivQ2 i h2)]
      simp [h2]
    · have h1 : ((rootState i).1 / 3) % 3 = 1 := by omega
      rw [Fintype.card_congr (activeSourceFormulaEdgeEquivQ1 i h1)]
      simp [h1]

end F3Block0ActiveCarrierCards
end KL2003
end CollatzClassical
