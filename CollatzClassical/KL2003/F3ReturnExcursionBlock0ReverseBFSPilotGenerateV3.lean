import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSPilotRowsV3
import CollatzClassical.KL2003.F3ReturnExcursionBlock0ReverseBFSData

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

/-!
# Untrusted serializer for the six fixed reverse-BFS pilot rows

Generation supplies data only.  The emitted certificate is accepted nowhere
in this module and remains subject to the separate typed kernel verifier.
-/

namespace CollatzClassical
namespace KL2003
namespace F3Block0ReverseBFSPilotGenerateV3

open F3CoreArithmeticCodecPilotRepair
open F3Block0CarrierFibers
open F3Block0MassDemandProfile
open F3Block0ReverseBFSData
open F3Block0ReverseBFSPilotRowsV3

private def serializeNat (n : Nat) : String :=
  toString n

private def serializeList {alpha : Type} (encode : alpha → String) :
    List alpha → String
  | [] => "[]"
  | first :: rest =>
      "[" ++ encode first ++
        rest.foldl (fun acc item => acc ++ ", " ++ encode item) "" ++ "]"

private def serializeNatList (values : List Nat) : String :=
  serializeList serializeNat values

private def serializeNode (node : ReverseBFSNode) : String :=
  "{ value := " ++ serializeNat node.value ++
    ", depth := " ++ serializeNat node.depth ++
    ", parentIndex := " ++ serializeNat node.parentIndex ++ " }"

private def serializeNodes (nodes : List ReverseBFSNode) : String :=
  serializeList serializeNode nodes

private def serializeClosureRow (row : ReverseBFSClosureRow) : String :=
  "{ value := " ++ serializeNat row.value ++
    ", predecessors := " ++ serializeNatList row.predecessors ++ " }"

private def serializeClosureRows
    (rows : List ReverseBFSClosureRow) : String :=
  serializeList serializeClosureRow rows

private def serializeKind : ReverseBFSCertificateKind → String
  | .saturated => ".saturated"
  | .deficient => ".deficient"

private def serializeCertificate (certificate : ReverseBFSCertificate) :
    String :=
  "{ claimedDemand := " ++ serializeNat certificate.claimedDemand ++
    ",\n    kind := " ++ serializeKind certificate.kind ++
    ",\n    nodes := " ++ serializeNodes certificate.nodes ++
    ",\n    closureRows := " ++
      serializeClosureRows certificate.closureRows ++ " }"

private def serializeFragment
    (declarationName : String) (certificate : ReverseBFSCertificate) : String :=
  "def " ++ declarationName ++
    " : F3Block0ReverseBFSData.ReverseBFSCertificate :=\n  " ++
    serializeCertificate certificate ++ "\n"

private def certificateFor (row : FixedPilotRowV3) : ReverseBFSCertificate :=
  generateReverseBFSCertificate
    (configOfOccurrence row.occurrence
      (massDemandShadow (occurrenceFormulaEdge row.occurrence.1)))

private def emit (declarationName : String) (row : FixedPilotRowV3) : IO Unit :=
  IO.print (serializeFragment declarationName (certificateFor row))

private def badArguments (message : String) : IO Unit :=
  throw (IO.userError message)

def run (args : List String) : IO Unit :=
  match args with
  | [canonicalId] =>
      if canonicalId = "FIXED_ROW_01_RET_D2" then
        emit "fixedRow01Certificate" fixedRow01
      else if canonicalId = "FIXED_ROW_02_RET_D1" then
        emit "fixedRow02Certificate" fixedRow02
      else if canonicalId = "FIXED_ROW_03_DIRECT_D2" then
        emit "fixedRow03Certificate" fixedRow03
      else if canonicalId = "FIXED_ROW_04_DIRECT_D1" then
        emit "fixedRow04Certificate" fixedRow04
      else if canonicalId = "FIXED_ROW_05_LIFT_D2" then
        emit "fixedRow05Certificate" fixedRow05
      else if canonicalId = "FIXED_ROW_06_LIFT_D1" then
        emit "fixedRow06Certificate" fixedRow06
      else
        badArguments ("unknown canonical row ID: " ++ canonicalId)
  | _ => badArguments "expected exactly one complete canonical row ID"

end F3Block0ReverseBFSPilotGenerateV3
end KL2003
end CollatzClassical

def main : IO Unit := do
  let args ← IO.getArgs
  CollatzClassical.KL2003.F3Block0ReverseBFSPilotGenerateV3.run args
