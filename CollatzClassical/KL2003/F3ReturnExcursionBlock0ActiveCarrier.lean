import CollatzClassical.KL2003.F3ReturnExcursionBlock0OccurrenceTotal

set_option maxHeartbeats 200000
set_option maxRecDepth 100000

/-!
The active one-layer Block0 occurrence carrier for the F3 semantic gate.

The complete R2 carrier contains all three fine-lift tags on every advanced
formula row.  A concrete Block0 root supplies exactly one of those tags.  The
predicate below performs only that root/formula compatibility selection.  It
does not inspect a transition orbit, a first-hit fibre, or a boundary.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ActiveCarrier

open F3Block0Carrier
open F3Block0CarrierFibers
open F3CoreArithmeticCodecPilotRepair

/-- A formula occurrence is active when its advanced fine-lift tag agrees
with the sixth base-three digit carried by its concrete root.  Retarded
occurrences carry no such tag and are always active. -/
def Active0 (p : Block0Occurrence) : Prop :=
  match occurrenceFormulaEdge p with
  | .retarded _ => True
  | .advancedDirect _ ell => rootFineLift (occurrenceRoot p) = ell
  | .advancedParityLift _ ell => rootFineLift (occurrenceRoot p) = ell

instance active0Decidable (p : Block0Occurrence) : Decidable (Active0 p) := by
  unfold Active0
  split <;> infer_instance

abbrev Active0Occurrence :=
  {p : Block0Occurrence // Active0 p}

/-- The typed active carrier.  Keeping the subtype, rather than projecting to
a matrix edge, preserves both the Block0 root and the formula constructor. -/
def active0Carrier : Finset Active0Occurrence :=
  Finset.univ

/-- The active occurrences whose roots lie in the previously inspected
prefix. -/
def active0SeenCarrier : Finset Active0Occurrence :=
  active0Carrier.filter (fun p => rootValue (occurrenceRoot p.1) < 128)

/-- The active occurrences in the complementary fresh suffix. -/
def active0FreshCarrier : Finset Active0Occurrence :=
  active0Carrier.filter (fun p => 128 ≤ rootValue (occurrenceRoot p.1))

/-- Row partition of the active carrier. -/
def active0Row (s : Fin 243) : Finset Active0Occurrence :=
  active0Carrier.filter (fun p =>
    formulaSource (occurrenceFormulaEdge p.1) = s)

/-- Root-indexed version of the same activity predicate, convenient for
reindexing a fixed formula edge through its concrete roots. -/
def FormulaActiveAtRoot (i : Block0Root) : FormulaEdge → Prop
  | .retarded _ => True
  | .advancedDirect _ ell => rootFineLift i = ell
  | .advancedParityLift _ ell => rootFineLift i = ell

instance formulaActiveAtRootDecidable
    (i : Block0Root) (e : FormulaEdge) :
    Decidable (FormulaActiveAtRoot i e) := by
  unfold FormulaActiveAtRoot
  split <;> infer_instance

theorem active0_iff_formulaActiveAtRoot (p : Block0Occurrence) :
    Active0 p ↔
      FormulaActiveAtRoot (occurrenceRoot p) (occurrenceFormulaEdge p) := by
  cases h : occurrenceFormulaEdge p <;>
    simp [Active0, FormulaActiveAtRoot, h]

theorem mem_active0Carrier (p : Active0Occurrence) :
    p ∈ active0Carrier := by
  simp [active0Carrier]

theorem mem_active0SeenCarrier_iff (p : Active0Occurrence) :
    p ∈ active0SeenCarrier ↔
      rootValue (occurrenceRoot p.1) < 128 := by
  simp [active0SeenCarrier, active0Carrier]

theorem mem_active0FreshCarrier_iff (p : Active0Occurrence) :
    p ∈ active0FreshCarrier ↔
      128 ≤ rootValue (occurrenceRoot p.1) := by
  simp [active0FreshCarrier, active0Carrier]

theorem mem_active0Row_iff (p : Active0Occurrence) (s : Fin 243) :
    p ∈ active0Row s ↔
      formulaSource (occurrenceFormulaEdge p.1) = s := by
  simp [active0Row, active0Carrier]

/-!
No cardinality, operator identity, first-hit statement, exponent, or density
claim is made in this definition module.
-/

end F3Block0ActiveCarrier
end KL2003
end CollatzClassical
