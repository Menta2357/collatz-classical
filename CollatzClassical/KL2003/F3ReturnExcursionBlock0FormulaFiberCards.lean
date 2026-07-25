import CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceCards

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Cardinality of the formula-edge fibre over one state, proved by constructor
equivalences.  The three possible quotient residues give 4, 1, and 4 edges.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0FormulaFiberCards

open F3CoreArithmeticCodecPilotRepair
open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0OccurrenceCards

def sourceFormulaEdgeEquivQ0 (s : Fin 243)
    (h0 : (s.1 / 3) % 3 = 0) :
    SourceFormulaEdge s ≃ Unit ⊕ Fin 3 where
  toFun e := by
    rcases e with ⟨e, he⟩
    cases e with
    | retarded r => exact Sum.inl ()
    | advancedDirect d ell =>
        have hds : d.1 = s := by simpa [formulaSource] using he
        have hd : (s.1 / 3) % 3 = 2 := by
          rw [← hds]
          exact d.2
        omega
    | advancedParityLift l ell => exact Sum.inr ell
  invFun e := by
    rcases e with u | ell
    · exact ⟨.retarded s, rfl⟩
    · exact ⟨.advancedParityLift ⟨s, h0⟩ ell, rfl⟩
  left_inv e := by
    rcases e with ⟨e, he⟩
    cases e with
    | retarded r =>
        have hrs : r = s := by simpa [formulaSource] using he
        subst r
        rfl
    | advancedDirect d ell =>
        have hds : d.1 = s := by simpa [formulaSource] using he
        have hd : (s.1 / 3) % 3 = 2 := by
          rw [← hds]
          exact d.2
        omega
    | advancedParityLift l ell =>
        have hls : l.1 = s := by simpa [formulaSource] using he
        have hl : l = (⟨s, h0⟩ : LiftSource) := Subtype.ext hls
        subst l
        rfl
  right_inv e := by
    rcases e with u | ell
    · cases u
      rfl
    · rfl

def sourceFormulaEdgeEquivQ1 (s : Fin 243)
    (h1 : (s.1 / 3) % 3 = 1) :
    SourceFormulaEdge s ≃ Unit where
  toFun _ := ()
  invFun _ := ⟨.retarded s, rfl⟩
  left_inv e := by
    rcases e with ⟨e, he⟩
    cases e with
    | retarded r =>
        have hrs : r = s := by simpa [formulaSource] using he
        subst r
        rfl
    | advancedDirect d ell =>
        have hds : d.1 = s := by simpa [formulaSource] using he
        have hd : (s.1 / 3) % 3 = 2 := by
          rw [← hds]
          exact d.2
        omega
    | advancedParityLift l ell =>
        have hls : l.1 = s := by simpa [formulaSource] using he
        have hl : (s.1 / 3) % 3 = 0 := by
          rw [← hls]
          exact l.2
        omega
  right_inv u := by
    cases u
    rfl

def sourceFormulaEdgeEquivQ2 (s : Fin 243)
    (h2 : (s.1 / 3) % 3 = 2) :
    SourceFormulaEdge s ≃ Unit ⊕ Fin 3 where
  toFun e := by
    rcases e with ⟨e, he⟩
    cases e with
    | retarded r => exact Sum.inl ()
    | advancedDirect d ell => exact Sum.inr ell
    | advancedParityLift l ell =>
        have hls : l.1 = s := by simpa [formulaSource] using he
        have hl : (s.1 / 3) % 3 = 0 := by
          rw [← hls]
          exact l.2
        omega
  invFun e := by
    rcases e with u | ell
    · exact ⟨.retarded s, rfl⟩
    · exact ⟨.advancedDirect ⟨s, h2⟩ ell, rfl⟩
  left_inv e := by
    rcases e with ⟨e, he⟩
    cases e with
    | retarded r =>
        have hrs : r = s := by simpa [formulaSource] using he
        subst r
        rfl
    | advancedDirect d ell =>
        have hds : d.1 = s := by simpa [formulaSource] using he
        have hd : d = (⟨s, h2⟩ : DirectSource) := Subtype.ext hds
        subst d
        rfl
    | advancedParityLift l ell =>
        have hls : l.1 = s := by simpa [formulaSource] using he
        have hl : (s.1 / 3) % 3 = 0 := by
          rw [← hls]
          exact l.2
        omega
  right_inv e := by
    rcases e with u | ell
    · cases u
      rfl
    · rfl

theorem sourceFormulaEdge_card (s : Fin 243) :
    Fintype.card (SourceFormulaEdge s) =
      if (s.1 / 3) % 3 = 0 ∨ (s.1 / 3) % 3 = 2 then 4 else 1 := by
  have hlt : (s.1 / 3) % 3 < 3 := Nat.mod_lt _ (by omega)
  by_cases h0 : (s.1 / 3) % 3 = 0
  · calc
      Fintype.card (SourceFormulaEdge s) = Fintype.card (Unit ⊕ Fin 3) :=
        Fintype.card_congr (sourceFormulaEdgeEquivQ0 s h0)
      _ = 4 := by simp
      _ = if (s.1 / 3) % 3 = 0 ∨ (s.1 / 3) % 3 = 2 then 4 else 1 := by
        simp [h0]
  · by_cases h2 : (s.1 / 3) % 3 = 2
    · calc
        Fintype.card (SourceFormulaEdge s) = Fintype.card (Unit ⊕ Fin 3) :=
          Fintype.card_congr (sourceFormulaEdgeEquivQ2 s h2)
        _ = 4 := by simp
        _ = if (s.1 / 3) % 3 = 0 ∨ (s.1 / 3) % 3 = 2 then 4 else 1 := by
          simp [h0, h2]
    · have h1 : (s.1 / 3) % 3 = 1 := by omega
      calc
        Fintype.card (SourceFormulaEdge s) = Fintype.card Unit :=
          Fintype.card_congr (sourceFormulaEdgeEquivQ1 s h1)
        _ = 1 := by simp
        _ = if (s.1 / 3) % 3 = 0 ∨ (s.1 / 3) % 3 = 2 then 4 else 1 := by
          simp [h0, h2]

theorem formulaFiber_card (i : Block0Root) :
    (formulaFiber i).card =
      if ((rootState i).1 / 3) % 3 = 0 ∨
          ((rootState i).1 / 3) % 3 = 2 then 4 else 1 := by
  calc
    (formulaFiber i).card = Fintype.card (SourceFormulaEdge (rootState i)) := by
      symm
      simpa [formulaFiber] using
        (Fintype.card_subtype
          (fun e : FormulaEdge => formulaSource e = rootState i))
    _ = if ((rootState i).1 / 3) % 3 = 0 ∨
          ((rootState i).1 / 3) % 3 = 2 then 4 else 1 :=
      sourceFormulaEdge_card (rootState i)

end F3Block0FormulaFiberCards
end KL2003
end CollatzClassical
