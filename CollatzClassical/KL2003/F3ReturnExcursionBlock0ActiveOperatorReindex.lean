import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveFormulaRow
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ActiveWeight

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Exact reindexing of the one-step forward operator through the active Block0
carrier.

The proof is finite and structural.  For an advanced formula edge, the roots
whose missing fine digit matches the edge tag form exactly one third of the
complete state fibre.  The compensation for that restriction enters only
through `activeMultiplicity`; it is not inserted into the matrix, the
carrier, or a semantic first-hit object.
-/

open scoped BigOperators

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveOperatorReindex

noncomputable section

open F3RealOperatorBridge
open F3ExactCoreMatrix
open F3CoreArithmeticCodecPilotRepair
open F3ForwardFormulaRightCertificate
open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0CarrierFiberCards
open F3Block0CarrierStateCards
open F3Block0OccurrenceCards
open F3Block0ActiveCarrier
open F3Block0ActiveFormulaRow
open F3Block0ActiveWeight

/-! ## Exact balance of the three missing fine digits -/

theorem stateFiber_card_eq_three_mul_fine
    (s : Fin 243) (ell : Fin 3) :
    (stateFiber s).card = 3 * (stateFineFiber s ell).card := by
  rw [stateFiber_card, stateFineFiber_card]
  by_cases h : s.1 % 3 = 0 <;> simp [h]

/-! ## Edge-first active root fibres -/

/-- Concrete roots compatible with one formula edge, including the missing
fine-digit condition for an advanced edge. -/
abbrev ActiveRootFibre (e : FormulaEdge) :=
  {i : Block0Root //
    formulaSource e = rootState i ∧ FormulaActiveAtRoot i e}

def retardedActiveRootFibreEquiv (s : Fin 243) :
    ActiveRootFibre (.retarded s) ≃ {i : Block0Root // i ∈ stateFiber s} where
  toFun i :=
    ⟨i.1, mem_stateFiber_iff i.1 s |>.2 i.2.1.symm⟩
  invFun i :=
    ⟨i.1, ⟨(mem_stateFiber_iff i.1 s |>.1 i.2).symm, trivial⟩⟩
  left_inv i := by
    apply Subtype.ext
    rfl
  right_inv i := by
    apply Subtype.ext
    rfl

def advancedDirectActiveRootFibreEquiv
    (s : DirectSource) (ell : Fin 3) :
    ActiveRootFibre (.advancedDirect s ell) ≃
      {i : Block0Root // i ∈ stateFineFiber s.1 ell} where
  toFun i :=
    ⟨i.1, (mem_stateFineFiber_iff i.1 s.1 ell).2
      ⟨i.2.1.symm, i.2.2⟩⟩
  invFun i :=
    ⟨i.1, by
      have hi := (mem_stateFineFiber_iff i.1 s.1 ell).1 i.2
      exact ⟨hi.1.symm, hi.2⟩⟩
  left_inv i := by
    apply Subtype.ext
    rfl
  right_inv i := by
    apply Subtype.ext
    rfl

def advancedParityLiftActiveRootFibreEquiv
    (s : LiftSource) (ell : Fin 3) :
    ActiveRootFibre (.advancedParityLift s ell) ≃
      {i : Block0Root // i ∈ stateFineFiber s.1 ell} where
  toFun i :=
    ⟨i.1, (mem_stateFineFiber_iff i.1 s.1 ell).2
      ⟨i.2.1.symm, i.2.2⟩⟩
  invFun i :=
    ⟨i.1, by
      have hi := (mem_stateFineFiber_iff i.1 s.1 ell).1 i.2
      exact ⟨hi.1.symm, hi.2⟩⟩
  left_inv i := by
    apply Subtype.ext
    rfl
  right_inv i := by
    apply Subtype.ext
    rfl

theorem activeRootFibre_card (e : FormulaEdge) :
    Fintype.card (ActiveRootFibre e) =
      match e with
      | .retarded s => (stateFiber s).card
      | .advancedDirect s ell => (stateFineFiber s.1 ell).card
      | .advancedParityLift s ell => (stateFineFiber s.1 ell).card := by
  cases e with
  | retarded s =>
      rw [Fintype.card_congr (retardedActiveRootFibreEquiv s)]
      exact Fintype.card_coe (stateFiber s)
  | advancedDirect s ell =>
      rw [Fintype.card_congr (advancedDirectActiveRootFibreEquiv s ell)]
      exact Fintype.card_coe (stateFineFiber s.1 ell)
  | advancedParityLift s ell =>
      rw [Fintype.card_congr
        (advancedParityLiftActiveRootFibreEquiv s ell)]
      exact Fintype.card_coe (stateFineFiber s.1 ell)

/-- The matching roots, counted with the audited active multiplicity, recover
the complete state fibre. -/
theorem activeRootFibre_card_mul_activeMultiplicity (e : FormulaEdge) :
    (Fintype.card (ActiveRootFibre e) : ℝ) * activeMultiplicity e =
      ((stateFiber (formulaSource e)).card : ℝ) := by
  cases e with
  | retarded s =>
      simp [activeRootFibre_card, activeMultiplicity, formulaSource]
  | advancedDirect s ell =>
      rw [activeRootFibre_card]
      simp only [formulaSource, activeMultiplicity]
      exact_mod_cast (by
        simpa [mul_comm] using
          (stateFiber_card_eq_three_mul_fine s.1 ell).symm)
  | advancedParityLift s ell =>
      rw [activeRootFibre_card]
      simp only [formulaSource, activeMultiplicity]
      exact_mod_cast (by
        simpa [mul_comm] using
          (stateFiber_card_eq_three_mul_fine s.1 ell).symm)

/-- Constant-summand form of the fine-digit balance. -/
theorem matchingFine_sum (e : FormulaEdge) (x : ℝ) :
    (∑ _i : ActiveRootFibre e, activeMultiplicity e * x) =
      ((stateFiber (formulaSource e)).card : ℝ) * x := by
  rw [Finset.sum_const, Finset.card_univ]
  simp only [nsmul_eq_mul]
  calc
    (Fintype.card (ActiveRootFibre e) : ℝ) *
        (activeMultiplicity e * x) =
      ((Fintype.card (ActiveRootFibre e) : ℝ) *
        activeMultiplicity e) * x := by ring
    _ = ((stateFiber (formulaSource e)).card : ℝ) * x := by
      rw [activeRootFibre_card_mul_activeMultiplicity]

/-- The row summand attached to one formula edge, before selecting roots. -/
def formulaEdgeNormalizedContribution (e : FormulaEdge) : ℝ :=
  channelWeight (formulaChannelNat e) *
      forwardRightWeight (formulaTarget e) /
      forwardRightWeight (formulaSource e)

theorem active_root_fibre_reindex (e : FormulaEdge) :
    (∑ _i : ActiveRootFibre e,
      activeMultiplicity e * formulaEdgeNormalizedContribution e) =
      ((stateFiber (formulaSource e)).card : ℝ) *
        formulaEdgeNormalizedContribution e := by
  exact matchingFine_sum e (formulaEdgeNormalizedContribution e)

/-! ## Active occurrences as an edge-first sigma type -/

abbrev Block0ActiveOccurrenceEdgeSigma :=
  Σ e : FormulaEdge, ActiveRootFibre e

def active0OccurrenceEdgeSigmaEquiv :
    Active0Occurrence ≃ Block0ActiveOccurrenceEdgeSigma where
  toFun p :=
    ⟨occurrenceFormulaEdge p.1,
      ⟨occurrenceRoot p.1,
        ⟨p.1.2,
          (active0_iff_formulaActiveAtRoot p.1).1 p.2⟩⟩⟩
  invFun p :=
    ⟨⟨(p.2.1, p.1), p.2.2.1⟩,
      (active0_iff_formulaActiveAtRoot
        ⟨(p.2.1, p.1), p.2.2.1⟩).2 p.2.2.2⟩
  left_inv p := by
    rcases p with ⟨⟨⟨i, e⟩, hs⟩, ha⟩
    rfl
  right_inv p := by
    rcases p with ⟨e, ⟨i, hs, ha⟩⟩
    rfl

theorem activeContribution_eq_normalized (p : Active0Occurrence) :
    activeContribution p =
      activeMultiplicity (occurrenceFormulaEdge p.1) *
        formulaEdgeNormalizedContribution (occurrenceFormulaEdge p.1) := by
  unfold activeContribution formulaEdgeNormalizedContribution
  ring

theorem active0Carrier_sum_edge_first :
    (∑ p in active0Carrier, activeContribution p) =
      ∑ e : FormulaEdge, ∑ _i : ActiveRootFibre e,
        activeMultiplicity e * formulaEdgeNormalizedContribution e := by
  change (∑ p : Active0Occurrence, activeContribution p) = _
  have h :=
    active0OccurrenceEdgeSigmaEquiv.symm.sum_comp activeContribution
  rw [Fintype.sum_sigma] at h
  simpa only [activeContribution_eq_normalized] using h.symm

theorem active0Carrier_sum_eq_formulaEdge_sum :
    (∑ p in active0Carrier, activeContribution p) =
      ∑ e : FormulaEdge,
        ((stateFiber (formulaSource e)).card : ℝ) *
          formulaEdgeNormalizedContribution e := by
  rw [active0Carrier_sum_edge_first]
  apply Finset.sum_congr rfl
  intro e he
  exact active_root_fibre_reindex e

/-! ## Formula rows as an edge-first sigma type -/

abbrev SourceFormulaEdgeSigma :=
  Σ s : Fin 243, SourceFormulaEdge s

def sourceFormulaEdgeSigmaEquiv : SourceFormulaEdgeSigma ≃ FormulaEdge where
  toFun p := p.2.1
  invFun e := ⟨formulaSource e, ⟨e, rfl⟩⟩
  left_inv p := by
    rcases p with ⟨s, ⟨e, hs⟩⟩
    have hsource : formulaSource e = s := hs
    subst s
    rfl
  right_inv e := rfl

theorem formulaEdge_sigma_reindex (f : FormulaEdge → ℝ) :
    (∑ s : Fin 243, ∑ e : SourceFormulaEdge s, f e.1) =
      ∑ e : FormulaEdge, f e := by
  have h := sourceFormulaEdgeSigmaEquiv.sum_comp f
  rw [Fintype.sum_sigma] at h
  exact h

theorem block0_operator_formulaEdge_reindex :
    weightedMass forwardRightWeight
        (push formulaForwardMatrix initialUnitMass) =
      ∑ e : FormulaEdge,
        ((stateFiber (formulaSource e)).card : ℝ) *
          formulaEdgeNormalizedContribution e := by
  rw [weighted_mass_push_identity]
  simp_rw [formulaForwardMatrix_row_eq_sourceFormulaEdge_sum]
  calc
    (∑ s : Fin 243,
      initialUnitMass s *
        ∑ e : SourceFormulaEdge s,
          channelWeight (formulaChannelNat e.1) *
            forwardRightWeight (formulaTarget e.1)) =
        ∑ s : Fin 243, ∑ e : SourceFormulaEdge s,
          ((stateFiber (formulaSource e.1)).card : ℝ) *
            formulaEdgeNormalizedContribution e.1 := by
      apply Finset.sum_congr rfl
      intro s hs
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro e he
      unfold initialUnitMass formulaEdgeNormalizedContribution
      rw [e.2]
      ring
    _ = ∑ e : FormulaEdge,
          ((stateFiber (formulaSource e)).card : ℝ) *
            formulaEdgeNormalizedContribution e := by
      exact formulaEdge_sigma_reindex (fun e =>
        ((stateFiber (formulaSource e)).card : ℝ) *
          formulaEdgeNormalizedContribution e)

/-- Exact one-layer operator-to-active-carrier identity. -/
theorem block0_operator_active_reindex :
    weightedMass forwardRightWeight
        (push formulaForwardMatrix initialUnitMass) =
      ∑ p in active0Carrier, activeContribution p := by
  rw [block0_operator_formulaEdge_reindex]
  exact active0Carrier_sum_eq_formulaEdge_sum.symm

end

/-!
Scope: exact finite reindexing only.  No transition orbit, first-hit fibre,
boundary inequality, exponent, or density theorem is introduced here.
-/

end F3Block0ActiveOperatorReindex
end KL2003
end CollatzClassical
