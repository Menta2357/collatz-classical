import CollatzClassical.KL2003.F3ReturnExcursionBlock0Carrier
import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecPilotRepair

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
State and formula-occurrence fibres over the fixed Block0 root carrier.

The definitions below preserve the root tag and, for advanced edges, the
fine-lift tag.  They do not execute a transition path and do not define a
semantic boundary or a retained population.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0CarrierFibers

open F3Block0Carrier
open F3CoreArithmeticCodecPilotRepair
open F3ExactCoreMatrix

/-! ## State and fine-lift fibres -/

def rootState (i : Block0Root) : Fin 243 :=
  decode (stateCode (rootValue i) (rootValue_mod3 i))

theorem rootState_val (i : Block0Root) :
    (rootState i).1 =
      3 * ((((rootValue i) / 3) % 81)) + bucketCode (rootValue i) := by
  have hroot : rootValue i = 3 * ((rootValue i) / 3) + 2 := by
    have hmod := rootValue_mod3 i
    have hsplit := Nat.div_add_mod (rootValue i) 3
    omega
  exact decode_stateCode_affine_val
    (rootValue i) ((rootValue i) / 3) (bucketCode (rootValue i))
    hroot rfl (bucketCode_lt_three (rootValue i)) (rootValue_mod3 i)

/-- The sixth base-three digit not retained by the `Fin 243` state. -/
def rootFineLift (i : Block0Root) : Fin 3 :=
  ⟨((rootValue i) / 243) % 3, Nat.mod_lt _ (by omega)⟩

def stateFiber (s : Fin 243) : Finset Block0Root :=
  Finset.univ.filter (fun i => rootState i = s)

def stateFineFiber (s : Fin 243) (ell : Fin 3) : Finset Block0Root :=
  (stateFiber s).filter (fun i => rootFineLift i = ell)

def initialBlockNat (s : Fin 243) : Nat :=
  (stateFiber s).card

theorem mem_stateFiber_iff (i : Block0Root) (s : Fin 243) :
    i ∈ stateFiber s ↔ rootState i = s := by
  simp [stateFiber]

theorem mem_stateFineFiber_iff
    (i : Block0Root) (s : Fin 243) (ell : Fin 3) :
    i ∈ stateFineFiber s ell ↔ rootState i = s ∧ rootFineLift i = ell := by
  simp [stateFineFiber, stateFiber]

/-! ## Formula occurrences, with every tag retained -/

/-- Advanced formula edges carry a fine-lift tag; retarded edges do not. -/
def formulaFineLift : FormulaEdge → Option (Fin 3)
  | .retarded _ => none
  | .advancedDirect _ ell => some ell
  | .advancedParityLift _ ell => some ell

/-- A valid occurrence is a root together with a formula edge sourced at its
decoded state.  It is not merely an untagged matrix edge. -/
abbrev Block0Occurrence :=
  {p : Block0Root × FormulaEdge // formulaSource p.2 = rootState p.1}

def occurrenceRoot (p : Block0Occurrence) : Block0Root :=
  p.1.1

def occurrenceFormulaEdge (p : Block0Occurrence) : FormulaEdge :=
  p.1.2

def occurrenceFineLift (p : Block0Occurrence) : Option (Fin 3) :=
  formulaFineLift (occurrenceFormulaEdge p)

def formulaFiber (i : Block0Root) : Finset FormulaEdge :=
  Finset.univ.filter (fun e => formulaSource e = rootState i)

def block0OccurrenceCarrier : Finset (Block0Root × FormulaEdge) :=
  Finset.univ.filter (fun p => formulaSource p.2 = rootState p.1)

theorem mem_block0OccurrenceCarrier_iff
    (p : Block0Root × FormulaEdge) :
    p ∈ block0OccurrenceCarrier ↔ formulaSource p.2 = rootState p.1 := by
  simp [block0OccurrenceCarrier]

/-- The row representation keeps its root tag, preventing different roots
with the same matrix row from being identified. -/
def occurrenceRow (p : Block0Occurrence) : Block0Root × CoreEdge :=
  (occurrenceRoot p, realize (occurrenceFormulaEdge p))

theorem occurrenceRow_injective : Function.Injective occurrenceRow := by
  rintro ⟨⟨pr, pe⟩, hp⟩ ⟨⟨qr, qe⟩, hq⟩ hpq
  simp only [occurrenceRow, occurrenceRoot, occurrenceFormulaEdge] at hpq ⊢
  have hroot : pr = qr :=
    congrArg (fun z : Block0Root × CoreEdge => z.1) hpq
  have hedge : realize pe = realize qe :=
    congrArg (fun z : Block0Root × CoreEdge => z.2) hpq
  have hformula : pe = qe := realize_injective hedge
  cases hroot
  cases hformula
  rfl

/-!
The next gate proves exact fibre sizes and then the cardinality of
`block0OccurrenceCarrier`.  No ratio is attached to either carrier here.
-/

end F3Block0CarrierFibers
end KL2003
end CollatzClassical
