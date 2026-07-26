import CollatzClassical.KL2003.F3ReturnExcursionBlock0MassDemandProfileSharded
import CollatzClassical.KL2003.F3ReturnExcursionBlock0OrderedFirstHit

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

/-!
# Six fixed rows for the Block0 reverse-BFS pilot

The occurrence in every row is reconstructed from its root index through the
public constructor API.  The historical labels are metadata only.

ROW_SELECTION_CLASSIFICATION = SIX_FIXED_PREDECLARED_ROWS
FINITE_MAXIMUM_SELECTION_CERTIFIED = NO
NO_EXTREMALITY_INFERENCE_FROM_LEGACY_ROW_ID
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSPilotRowsV3

open F3CoreArithmeticCodecPilotRepair
open F3Block0Carrier
open F3Block0CarrierFibers
open F3Block0ActiveCarrier
open F3Block0MassDemandProfile
open F3Block0MassDemandRetardedShard
open F3Block0MassDemandDirectShard
open F3Block0MassDemandLiftShard
open F3Block0OrderedFirstHit

/-- One predeclared pilot owner, with its typed active occurrence retained. -/
structure FixedPilotRowV3 where
  order : Nat
  canonicalId : String
  legacyRowId : String
  occurrence : Active0Occurrence

def fixedRow01 : FixedPilotRowV3 where
  order := 1
  canonicalId := "FIXED_ROW_01_RET_D2"
  legacyRowId := "RET_D2_MAX"
  occurrence := retardedActiveOccurrenceDirect ⟨24, by omega⟩

def fixedRow02 : FixedPilotRowV3 where
  order := 2
  canonicalId := "FIXED_ROW_02_RET_D1"
  legacyRowId := "RET_D1_CONTROL"
  occurrence := retardedActiveOccurrenceDirect ⟨11, by omega⟩

def fixedRow03 : FixedPilotRowV3 where
  order := 3
  canonicalId := "FIXED_ROW_03_DIRECT_D2"
  legacyRowId := "DIRECT_D2_MAX"
  occurrence := directActiveOccurrenceDirect
    ⟨⟨52, by omega⟩, by decide⟩

def fixedRow04 : FixedPilotRowV3 where
  order := 4
  canonicalId := "FIXED_ROW_04_DIRECT_D1"
  legacyRowId := "DIRECT_D1_CONTROL"
  occurrence := directActiveOccurrenceDirect
    ⟨⟨76, by omega⟩, by decide⟩

def fixedRow05 : FixedPilotRowV3 where
  order := 5
  canonicalId := "FIXED_ROW_05_LIFT_D2"
  legacyRowId := "LIFT_D2_MAX"
  occurrence := liftActiveOccurrenceDirect
    ⟨⟨44, by omega⟩, by decide⟩

def fixedRow06 : FixedPilotRowV3 where
  order := 6
  canonicalId := "FIXED_ROW_06_LIFT_D1"
  legacyRowId := "LIFT_D1_CONTROL"
  occurrence := liftActiveOccurrenceDirect
    ⟨⟨224, by omega⟩, by decide⟩

/-!
Each theorem below checks the complete public coordinate: order, both IDs,
root index/value, constructor and source/fine tag, formula target, raw qHi
pair, mass demand, semantic child and child window.  The final conjunct is the
cross-product equality between the raw API pair and the reduced contract pair.
-/

theorem fixedRow01_coordinates :
    fixedRow01.order = 1 ∧
    fixedRow01.canonicalId = "FIXED_ROW_01_RET_D2" ∧
    fixedRow01.legacyRowId = "RET_D2_MAX" ∧
    (occurrenceRoot fixedRow01.occurrence.1).1 = 24 ∧
    rootValue (occurrenceRoot fixedRow01.occurrence.1) = 77 ∧
    (match occurrenceFormulaEdge fixedRow01.occurrence.1 with
      | .retarded source => source.1 = 75
      | _ => False) ∧
    (formulaTarget (occurrenceFormulaEdge fixedRow01.occurrence.1)).1 = 65 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow01.occurrence.1) = 2625 ∧
    qHiDenominator (occurrenceFormulaEdge fixedRow01.occurrence.1) = 2511 ∧
    massDemandShadow (occurrenceFormulaEdge fixedRow01.occurrence.1) = 2 ∧
    semanticChildRoot fixedRow01.occurrence = 308 ∧
    childWindow0 fixedRow01.occurrence = 19712 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow01.occurrence.1) * 837 =
      875 * qHiDenominator (occurrenceFormulaEdge fixedRow01.occurrence.1) := by
  decide

theorem fixedRow02_coordinates :
    fixedRow02.order = 2 ∧
    fixedRow02.canonicalId = "FIXED_ROW_02_RET_D1" ∧
    fixedRow02.legacyRowId = "RET_D1_CONTROL" ∧
    (occurrenceRoot fixedRow02.occurrence.1).1 = 11 ∧
    rootValue (occurrenceRoot fixedRow02.occurrence.1) = 38 ∧
    (match occurrenceFormulaEdge fixedRow02.occurrence.1 with
      | .retarded source => source.1 = 37
      | _ => False) ∧
    (formulaTarget (occurrenceFormulaEdge fixedRow02.occurrence.1)).1 = 152 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow02.occurrence.1) = 10300 ∧
    qHiDenominator (occurrenceFormulaEdge fixedRow02.occurrence.1) = 11907 ∧
    massDemandShadow (occurrenceFormulaEdge fixedRow02.occurrence.1) = 1 ∧
    semanticChildRoot fixedRow02.occurrence = 152 ∧
    childWindow0 fixedRow02.occurrence = 9728 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow02.occurrence.1) * 11907 =
      10300 * qHiDenominator (occurrenceFormulaEdge fixedRow02.occurrence.1) := by
  decide

theorem fixedRow03_coordinates :
    fixedRow03.order = 3 ∧
    fixedRow03.canonicalId = "FIXED_ROW_03_DIRECT_D2" ∧
    fixedRow03.legacyRowId = "DIRECT_D2_MAX" ∧
    (occurrenceRoot fixedRow03.occurrence.1).1 = 52 ∧
    rootValue (occurrenceRoot fixedRow03.occurrence.1) = 161 ∧
    (match occurrenceFormulaEdge fixedRow03.occurrence.1 with
      | .advancedDirect source ell => source.1.1 = 159 ∧ ell.1 = 0
      | _ => False) ∧
    (formulaTarget (occurrenceFormulaEdge fixedRow03.occurrence.1)).1 = 105 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow03.occurrence.1) = 580743 ∧
    qHiDenominator (occurrenceFormulaEdge fixedRow03.occurrence.1) = 404000 ∧
    massDemandShadow (occurrenceFormulaEdge fixedRow03.occurrence.1) = 2 ∧
    semanticChildRoot fixedRow03.occurrence = 107 ∧
    childWindow0 fixedRow03.occurrence = 41088 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow03.occurrence.1) * 404000 =
      580743 * qHiDenominator (occurrenceFormulaEdge fixedRow03.occurrence.1) := by
  decide

theorem fixedRow04_coordinates :
    fixedRow04.order = 4 ∧
    fixedRow04.canonicalId = "FIXED_ROW_04_DIRECT_D1" ∧
    fixedRow04.legacyRowId = "DIRECT_D1_CONTROL" ∧
    (occurrenceRoot fixedRow04.occurrence.1).1 = 76 ∧
    rootValue (occurrenceRoot fixedRow04.occurrence.1) = 233 ∧
    (match occurrenceFormulaEdge fixedRow04.occurrence.1 with
      | .advancedDirect source ell => source.1.1 = 231 ∧ ell.1 = 0
      | _ => False) ∧
    (formulaTarget (occurrenceFormulaEdge fixedRow04.occurrence.1)).1 = 153 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow04.occurrence.1) = 268470 ∧
    qHiDenominator (occurrenceFormulaEdge fixedRow04.occurrence.1) = 270000 ∧
    massDemandShadow (occurrenceFormulaEdge fixedRow04.occurrence.1) = 1 ∧
    semanticChildRoot fixedRow04.occurrence = 155 ∧
    childWindow0 fixedRow04.occurrence = 59520 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow04.occurrence.1) * 3000 =
      2983 * qHiDenominator (occurrenceFormulaEdge fixedRow04.occurrence.1) := by
  decide

theorem fixedRow05_coordinates :
    fixedRow05.order = 5 ∧
    fixedRow05.canonicalId = "FIXED_ROW_05_LIFT_D2" ∧
    fixedRow05.legacyRowId = "LIFT_D2_MAX" ∧
    (occurrenceRoot fixedRow05.occurrence.1).1 = 44 ∧
    rootValue (occurrenceRoot fixedRow05.occurrence.1) = 137 ∧
    (match occurrenceFormulaEdge fixedRow05.occurrence.1 with
      | .advancedParityLift source ell => source.1.1 = 135 ∧ ell.1 = 0
      | _ => False) ∧
    (formulaTarget (occurrenceFormulaEdge fixedRow05.occurrence.1)).1 = 181 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow05.occurrence.1) = 64056 ∧
    qHiDenominator (occurrenceFormulaEdge fixedRow05.occurrence.1) = 48800 ∧
    massDemandShadow (occurrenceFormulaEdge fixedRow05.occurrence.1) = 2 ∧
    semanticChildRoot fixedRow05.occurrence = 182 ∧
    childWindow0 fixedRow05.occurrence = 34944 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow05.occurrence.1) * 6100 =
      8007 * qHiDenominator (occurrenceFormulaEdge fixedRow05.occurrence.1) := by
  decide

theorem fixedRow06_coordinates :
    fixedRow06.order = 6 ∧
    fixedRow06.canonicalId = "FIXED_ROW_06_LIFT_D1" ∧
    fixedRow06.legacyRowId = "LIFT_D1_CONTROL" ∧
    (occurrenceRoot fixedRow06.occurrence.1).1 = 224 ∧
    rootValue (occurrenceRoot fixedRow06.occurrence.1) = 677 ∧
    (match occurrenceFormulaEdge fixedRow06.occurrence.1 with
      | .advancedParityLift source ell => source.1.1 = 189 ∧ ell.1 = 2
      | _ => False) ∧
    (formulaTarget (occurrenceFormulaEdge fixedRow06.occurrence.1)).1 = 172 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow06.occurrence.1) = 15700 ∧
    qHiDenominator (occurrenceFormulaEdge fixedRow06.occurrence.1) = 16200 ∧
    massDemandShadow (occurrenceFormulaEdge fixedRow06.occurrence.1) = 1 ∧
    semanticChildRoot fixedRow06.occurrence = 902 ∧
    childWindow0 fixedRow06.occurrence = 173184 ∧
    qHiNumerator (occurrenceFormulaEdge fixedRow06.occurrence.1) * 162 =
      157 * qHiDenominator (occurrenceFormulaEdge fixedRow06.occurrence.1) := by
  decide

end F3Block0ReverseBFSPilotRowsV3
end KL2003
end CollatzClassical
