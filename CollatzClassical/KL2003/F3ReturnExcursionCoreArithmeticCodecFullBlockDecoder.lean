import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecPilotRepair

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
Symbolic 81-by-9 block decoder for the full F3 core.

This gate contains no reference to the 729-entry historical literal.  It
reuses the audited 27-source/81-edge pilot decoder and proves that translating
a pilot edge through any of nine source blocks preserves both arithmetic edge
identity and frozen position.  A later, separately authorized module may use
this decoder for the sole full-literal normalization.
-/

namespace CollatzClassical
namespace KL2003
namespace F3CoreArithmeticCodecFullBlockDecoder

open F3CoreArithmeticCodecPilotRepair

/-! ## Finite block coordinates -/

def joinPosition (g : Fin 9) (p : Fin 81) : Fin 729 :=
  ⟨81 * g.1 + p.1, by omega⟩

def positionBlock (j : Fin 729) : Fin 9 :=
  ⟨j.1 / 81, by omega⟩

def positionLocal (j : Fin 729) : Fin 81 :=
  ⟨j.1 % 81, Nat.mod_lt _ (by omega)⟩

@[simp] theorem positionBlock_join (g : Fin 9) (p : Fin 81) :
    positionBlock (joinPosition g p) = g := by
  apply Fin.ext
  change (81 * g.1 + p.1) / 81 = g.1
  calc
    _ = (p.1 + 81 * g.1) / 81 := by omega
    _ = p.1 / 81 + g.1 :=
      Nat.add_mul_div_left _ _ (by omega)
    _ = g.1 := by rw [Nat.div_eq_of_lt p.2]; omega

@[simp] theorem positionLocal_join (g : Fin 9) (p : Fin 81) :
    positionLocal (joinPosition g p) = p := by
  apply Fin.ext
  change (81 * g.1 + p.1) % 81 = p.1
  calc
    _ = (p.1 + 81 * g.1) % 81 := by omega
    _ = p.1 % 81 := Nat.add_mul_mod_self_left _ _ _
    _ = p.1 := Nat.mod_eq_of_lt p.2

def fin27Shift (g : Fin 9) (i : Fin 27) : Fin 243 :=
  ⟨27 * g.1 + i.1, by omega⟩

def fin9Shift (g : Fin 9) (k : Fin 9) : Fin 81 :=
  ⟨9 * g.1 + k.1, by omega⟩

def fin243Block (i : Fin 243) : Fin 9 :=
  ⟨i.1 / 27, by omega⟩

def fin243Local (i : Fin 243) : Fin 27 :=
  ⟨i.1 % 27, Nat.mod_lt _ (by omega)⟩

def fin81Block (i : Fin 81) : Fin 9 :=
  ⟨i.1 / 9, by omega⟩

def fin81Local (i : Fin 81) : Fin 9 :=
  ⟨i.1 % 9, Nat.mod_lt _ (by omega)⟩

@[simp] theorem fin27Shift_block_local (i : Fin 243) :
    fin27Shift (fin243Block i) (fin243Local i) = i := by
  apply Fin.ext
  simpa [fin27Shift, fin243Block, fin243Local, Nat.mul_comm] using
    Nat.div_add_mod i.1 27

@[simp] theorem fin9Shift_block_local (i : Fin 81) :
    fin9Shift (fin81Block i) (fin81Local i) = i := by
  apply Fin.ext
  simpa [fin9Shift, fin81Block, fin81Local, Nat.mul_comm] using
    Nat.div_add_mod i.1 9

/-! ## Edge block decomposition -/

def liftPilotEdge (g : Fin 9) : PilotFormulaEdge → FormulaEdge
  | .retarded i => .retarded (fin27Shift g i)
  | .advancedDirect k ell =>
      .advancedDirect (directSourceUnrank (fin9Shift g k)) ell
  | .advancedParityLift k ell =>
      .advancedParityLift (liftSourceUnrank (fin9Shift g k)) ell

def edgeBlock : FormulaEdge → Fin 9
  | .retarded i => fin243Block i
  | .advancedDirect i _ => fin81Block (directSourceRank i)
  | .advancedParityLift i _ => fin81Block (liftSourceRank i)

def edgeLocal : FormulaEdge → PilotFormulaEdge
  | .retarded i => .retarded (fin243Local i)
  | .advancedDirect i ell =>
      .advancedDirect (fin81Local (directSourceRank i)) ell
  | .advancedParityLift i ell =>
      .advancedParityLift (fin81Local (liftSourceRank i)) ell

theorem liftPilotEdge_edgeBlock_edgeLocal (e : FormulaEdge) :
    liftPilotEdge (edgeBlock e) (edgeLocal e) = e := by
  cases e with
  | retarded i =>
      simp [liftPilotEdge, edgeBlock, edgeLocal]
  | advancedDirect i ell =>
      simp [liftPilotEdge, edgeBlock, edgeLocal]
  | advancedParityLift i ell =>
      simp [liftPilotEdge, edgeBlock, edgeLocal]

/-! ## Arithmetic source and row shifts -/

theorem fin9Shift_div3 (g : Fin 9) (k : Fin 9) :
    (fin9Shift g k).1 / 3 = 3 * g.1 + k.1 / 3 := by
  change (9 * g.1 + k.1) / 3 = 3 * g.1 + k.1 / 3
  calc
    _ = (k.1 + 3 * (3 * g.1)) / 3 := by omega
    _ = k.1 / 3 + 3 * g.1 :=
      Nat.add_mul_div_left _ _ (by omega)
    _ = _ := by omega

theorem fin9Shift_mod3 (g : Fin 9) (k : Fin 9) :
    (fin9Shift g k).1 % 3 = k.1 % 3 := by
  change (9 * g.1 + k.1) % 3 = k.1 % 3
  calc
    _ = (k.1 + 3 * (3 * g.1)) % 3 := by omega
    _ = _ := Nat.add_mul_mod_self_left _ _ _

theorem directSourceUnrank_shift (g : Fin 9) (k : Fin 9) :
    (directSourceUnrank (fin9Shift g k)).1.1 =
      27 * g.1 + (directSourceUnrank (fin9To81 k)).1.1 := by
  simp only [directSourceUnrank, directSourceUnrankNat, fin9To81]
  rw [fin9Shift_div3, fin9Shift_mod3]
  omega

theorem liftSourceUnrank_shift (g : Fin 9) (k : Fin 9) :
    (liftSourceUnrank (fin9Shift g k)).1.1 =
      27 * g.1 + (liftSourceUnrank (fin9To81 k)).1.1 := by
  simp only [liftSourceUnrank, liftSourceUnrankNat, fin9To81]
  rw [fin9Shift_div3, fin9Shift_mod3]
  omega

theorem formulaSource_liftPilotEdge (g : Fin 9) (p : PilotFormulaEdge) :
    (formulaSource (liftPilotEdge g p)).1 =
      27 * g.1 + (formulaSource (pilotEmbed p)).1 := by
  cases p with
  | retarded i =>
      simp [formulaSource, liftPilotEdge, pilotEmbed, fin27Shift, fin27To243]
  | advancedDirect k ell =>
      simpa [formulaSource, liftPilotEdge, pilotEmbed] using
        directSourceUnrank_shift g k
  | advancedParityLift k ell =>
      simpa [formulaSource, liftPilotEdge, pilotEmbed] using
        liftSourceUnrank_shift g k

theorem rowStart_shift (g : Fin 9) (i : Fin 243) (hi : i.1 < 27) :
    rowStart ⟨27 * g.1 + i.1, by omega⟩ =
      81 * g.1 + rowStart i := by
  have hdiv27 : (27 * g.1 + i.1) / 3 = 9 * g.1 + i.1 / 3 := by
    calc
      _ = (i.1 + 3 * (9 * g.1)) / 3 := by omega
      _ = i.1 / 3 + 9 * g.1 :=
        Nat.add_mul_div_left _ _ (by omega)
      _ = _ := by omega
  have hmod27 : (27 * g.1 + i.1) % 3 = i.1 % 3 := by
    calc
      _ = (i.1 + 3 * (9 * g.1)) % 3 := by omega
      _ = _ := Nat.add_mul_mod_self_left _ _ _
  have hdiv9 :
      (9 * g.1 + i.1 / 3) / 3 =
        3 * g.1 + (i.1 / 3) / 3 := by
    calc
      _ = (i.1 / 3 + 3 * (3 * g.1)) / 3 := by omega
      _ = (i.1 / 3) / 3 + 3 * g.1 :=
        Nat.add_mul_div_left _ _ (by omega)
      _ = _ := by omega
  have hmod9 :
      (9 * g.1 + i.1 / 3) % 3 = (i.1 / 3) % 3 := by
    calc
      _ = (i.1 / 3 + 3 * (3 * g.1)) % 3 := by omega
      _ = _ := Nat.add_mul_mod_self_left _ _ _
  simp only [rowStart]
  rw [hdiv27, hmod27, hdiv9, hmod9]
  by_cases h0 : (i.1 / 3) % 3 = 0
  · simp [h0]
    omega
  · by_cases h1 : (i.1 / 3) % 3 = 1
    · simp [h0, h1]
      omega
    · simp [h0, h1]
      omega

theorem rowStart_formulaSource_liftPilotEdge
    (g : Fin 9) (p : PilotFormulaEdge) :
    rowStart (formulaSource (liftPilotEdge g p)) =
      81 * g.1 + rowStart (formulaSource (pilotEmbed p)) := by
  have hsource : formulaSource (liftPilotEdge g p) =
      (⟨27 * g.1 + (formulaSource (pilotEmbed p)).1, by
        have hlt := pilotEmbed_source_lt_27 p
        omega⟩ : Fin 243) := by
    apply Fin.ext
    exact formulaSource_liftPilotEdge g p
  rw [hsource]
  exact rowStart_shift g (formulaSource (pilotEmbed p))
    (pilotEmbed_source_lt_27 p)

theorem frozenPos_liftPilotEdge (g : Fin 9) (p : PilotFormulaEdge) :
    frozenPos (liftPilotEdge g p) =
      joinPosition g (pilotFrozenPos p) := by
  apply Fin.ext
  have hrow := rowStart_formulaSource_liftPilotEdge g p
  have hagree := pilotFrozenPos_agrees p
  cases p <;>
    simp only [frozenPos, frozenPosNat, liftPilotEdge, pilotEmbed,
      formulaSource, joinPosition] at hrow hagree ⊢ <;>
    omega

theorem frozenPos_eq_joinPosition (e : FormulaEdge) :
    frozenPos e =
      joinPosition (edgeBlock e) (pilotFrozenPos (edgeLocal e)) := by
  calc
    frozenPos e =
        frozenPos (liftPilotEdge (edgeBlock e) (edgeLocal e)) :=
      congrArg frozenPos (liftPilotEdge_edgeBlock_edgeLocal e).symm
    _ = joinPosition (edgeBlock e) (pilotFrozenPos (edgeLocal e)) :=
      frozenPos_liftPilotEdge (edgeBlock e) (edgeLocal e)

/-! ## Full decoder, now reduced to audited pilot inverses -/

def corePositionUnrank (j : Fin 729) : FormulaEdge :=
  liftPilotEdge (positionBlock j)
    (pilotPositionUnrank (positionLocal j))

def corePositionToRank (j : Fin 729) : Fin 729 :=
  formulaRank (corePositionUnrank j)

theorem corePositionUnrank_frozenPos (e : FormulaEdge) :
    corePositionUnrank (frozenPos e) = e := by
  rw [frozenPos_eq_joinPosition]
  simp only [corePositionUnrank, positionBlock_join, positionLocal_join]
  rw [pilotPositionUnrank_frozenPos]
  exact liftPilotEdge_edgeBlock_edgeLocal e

theorem corePositionToRank_frozenPos (e : FormulaEdge) :
    corePositionToRank (frozenPos e) = formulaRank e := by
  simp only [corePositionToRank, corePositionUnrank_frozenPos]

/-!
Scope: symbolic decoder only.  This module does not mention `coreEdges`, prove
the 729-edge literal normalization, instantiate first-hit, or assert rho or
density.
-/

end F3CoreArithmeticCodecFullBlockDecoder
end KL2003
end CollatzClassical
