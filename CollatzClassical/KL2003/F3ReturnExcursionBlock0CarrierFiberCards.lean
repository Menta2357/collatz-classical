import CollatzClassical.KL2003.F3ReturnExcursionBlock0CarrierFibers

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Closed finite certificates for the formula-defined Block0 fibres.

The certificate below reduces only the arithmetic definitions of the fixed
root carrier, state codec, and sixth base-three digit.  It neither imports nor
executes a transition path, and it introduces no literal data table.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0CarrierFiberCards

open F3Block0CarrierFibers
open F3Block0Carrier
open scoped BigOperators

/-! ## Exact period coordinates -/

def rootCoordinate (i : Block0Root) : Fin 81 × Fin 12 :=
  (⟨i.1 % 81, Nat.mod_lt _ (by omega)⟩,
   ⟨i.1 / 81, by have hi := i.2; omega⟩)

def coordinateRoot (p : Fin 81 × Fin 12) : Block0Root :=
  ⟨p.1.1 + 81 * p.2.1, by
    have hr := p.1.2
    have ht := p.2.2
    omega⟩

theorem coordinateRoot_rootCoordinate (i : Block0Root) :
    coordinateRoot (rootCoordinate i) = i := by
  apply Fin.ext
  have hsplit := Nat.div_add_mod i.1 81
  simp only [coordinateRoot, rootCoordinate]
  omega

theorem rootCoordinate_coordinateRoot (p : Fin 81 × Fin 12) :
    rootCoordinate (coordinateRoot p) = p := by
  apply Prod.ext
  · apply Fin.ext
    have hr := p.1.2
    simp only [rootCoordinate, coordinateRoot]
    omega
  · apply Fin.ext
    have hr := p.1.2
    simp only [rootCoordinate, coordinateRoot]
    omega

def rootCoordinateEquiv : Block0Root ≃ Fin 81 × Fin 12 where
  toFun := rootCoordinate
  invFun := coordinateRoot
  left_inv := coordinateRoot_rootCoordinate
  right_inv := rootCoordinate_coordinateRoot

theorem rootFineLift_val_index (i : Block0Root) :
    (rootFineLift i).1 = ((i.1 + 1) / 81) % 3 := by
  simp only [rootFineLift, rootValue]
  omega

theorem rootState_div_three (i : Block0Root) :
    (rootState i).1 / 3 = (i.1 + 1) % 81 := by
  rw [rootState_val]
  have hb := F3CoreArithmeticCodecPilotRepair.bucketCode_lt_three (rootValue i)
  have hdiv : rootValue i / 3 = i.1 + 1 := by
    simp only [rootValue]
    omega
  rw [hdiv]
  omega

/-! ## The unique period column selected by a state -/

def stateResidue (s : Fin 243) : Fin 81 :=
  if h : s.1 / 3 = 0 then
    ⟨80, by omega⟩
  else
    ⟨s.1 / 3 - 1, by have hs := s.2; omega⟩

theorem stateResidue_successor_mod (s : Fin 243) :
    ((stateResidue s).1 + 1) % 81 = s.1 / 3 := by
  have hs := s.2
  by_cases hq : s.1 / 3 = 0
  · simp [stateResidue, hq]
  · have hpos : 1 ≤ s.1 / 3 := Nat.one_le_iff_ne_zero.mpr hq
    have hlt : s.1 / 3 < 81 := by omega
    simp only [stateResidue, hq, dite_false, Fin.val_mk]
    rw [Nat.sub_add_cancel hpos, Nat.mod_eq_of_lt hlt]

theorem residue_eq_stateResidue_of_successor_mod
    (r : Fin 81) (s : Fin 243)
    (h : (r.1 + 1) % 81 = s.1 / 3) :
    r = stateResidue s := by
  apply Fin.ext
  have hr := r.2
  have hs := s.2
  by_cases hq : s.1 / 3 = 0
  · simp only [stateResidue, hq, dite_true, Fin.val_mk]
    rw [hq] at h
    by_contra hr80
    have hrlt : r.1 + 1 < 81 := by omega
    rw [Nat.mod_eq_of_lt hrlt] at h
    omega
  · have hpos : 1 ≤ s.1 / 3 := Nat.one_le_iff_ne_zero.mpr hq
    simp only [stateResidue, hq, dite_false, Fin.val_mk]
    by_cases hr80 : r.1 = 80
    · rw [hr80] at h
      norm_num at h
      exact (hq h.symm).elim
    · have hrlt : r.1 + 1 < 81 := by omega
      rw [Nat.mod_eq_of_lt hrlt] at h
      omega

theorem rootCoordinate_fst_eq_stateResidue_of_state
    (i : Block0Root) (s : Fin 243) (hstate : rootState i = s) :
    (rootCoordinate i).1 = stateResidue s := by
  apply residue_eq_stateResidue_of_successor_mod
  have hq : (i.1 + 1) % 81 = s.1 / 3 := by
    rw [← rootState_div_three i, hstate]
  simp only [rootCoordinate]
  simpa [Nat.add_mod] using hq

def statePeriodRoot (s : Fin 243) (t : Fin 12) : Block0Root :=
  coordinateRoot (stateResidue s, t)

theorem statePeriodRoot_rootCoordinate_snd_of_state
    (i : Block0Root) (s : Fin 243) (hstate : rootState i = s) :
    statePeriodRoot s (rootCoordinate i).2 = i := by
  apply Fin.ext
  have hr := congrArg Fin.val
    (rootCoordinate_fst_eq_stateResidue_of_state i s hstate)
  have hsplit := Nat.div_add_mod i.1 81
  simp only [statePeriodRoot, coordinateRoot, rootCoordinate] at hr ⊢
  omega

theorem rootCoordinate_snd_statePeriodRoot (s : Fin 243) (t : Fin 12) :
    (rootCoordinate (statePeriodRoot s t)).2 = t := by
  unfold statePeriodRoot
  rw [rootCoordinate_coordinateRoot]

/-! ## Reduction of each fine fibre to one explicit period of length twelve -/

def periodFineFiber (s : Fin 243) (ell : Fin 3) : Finset (Fin 12) :=
  Finset.univ.filter (fun t =>
    rootState (statePeriodRoot s t) = s ∧
    rootFineLift (statePeriodRoot s t) = ell)

theorem stateFineFiber_card_eq_periodFineFiber
    (s : Fin 243) (ell : Fin 3) :
    (stateFineFiber s ell).card = (periodFineFiber s ell).card := by
  classical
  apply Finset.card_bij (fun i _ => (rootCoordinate i).2)
  · intro i hi
    rw [mem_stateFineFiber_iff] at hi
    simp only [periodFineFiber, Finset.mem_filter, Finset.mem_univ, true_and]
    rw [statePeriodRoot_rootCoordinate_snd_of_state i s hi.1]
    exact hi
  · intro i hi j hj ht
    rw [mem_stateFineFiber_iff] at hi hj
    rw [← statePeriodRoot_rootCoordinate_snd_of_state i s hi.1,
        ← statePeriodRoot_rootCoordinate_snd_of_state j s hj.1,
        ht]
  · intro t ht
    simp only [periodFineFiber, Finset.mem_filter, Finset.mem_univ,
      true_and] at ht
    refine ⟨statePeriodRoot s t, ?_, ?_⟩
    · rw [mem_stateFineFiber_iff]
      exact ht
    · exact rootCoordinate_snd_statePeriodRoot s t

/-!
This is the only computational certificate in the module: it checks the
explicit period of length twelve obtained above, not the 972-root carrier.
-/

theorem periodFineFiber_card_all :
    ∀ s : Fin 243, ∀ ell : Fin 3,
      (periodFineFiber s ell).card =
        if s.1 % 3 = 0 then 2 else 1 := by
  decide

theorem stateFineFiber_card (s : Fin 243) (ell : Fin 3) :
    (stateFineFiber s ell).card =
      if s.1 % 3 = 0 then 2 else 1 := by
  rw [stateFineFiber_card_eq_periodFineFiber]
  exact periodFineFiber_card_all s ell

end F3Block0CarrierFiberCards
end KL2003
end CollatzClassical
