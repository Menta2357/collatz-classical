import CollatzClassical.KL2003.KL2003K9CertificateDataGenerated
import CollatzClassical.KL2003.KL2003GeneralKLNTFeasibilityTransfer
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

namespace CollatzClassical
namespace KL2003
namespace K9CertificateVerifier

open GeneratedK9

def principalChunkAt : Nat -> Array Rat
  | 0 => principalChunk0
  | 1 => principalChunk1
  | 2 => principalChunk2
  | 3 => principalChunk3
  | 4 => principalChunk4
  | 5 => principalChunk5
  | 6 => principalChunk6
  | 7 => principalChunk7
  | 8 => principalChunk8
  | 9 => principalChunk9
  | 10 => principalChunk10
  | 11 => principalChunk11
  | 12 => principalChunk12
  | 13 => principalChunk13
  | 14 => principalChunk14
  | 15 => principalChunk15
  | 16 => principalChunk16
  | 17 => principalChunk17
  | 18 => principalChunk18
  | 19 => principalChunk19
  | 20 => principalChunk20
  | 21 => principalChunk21
  | 22 => principalChunk22
  | 23 => principalChunk23
  | 24 => principalChunk24
  | 25 => principalChunk25
  | 26 => principalChunk26
  | 27 => principalChunk27
  | 28 => principalChunk28
  | 29 => principalChunk29
  | 30 => principalChunk30
  | 31 => principalChunk31
  | 32 => principalChunk32
  | 33 => principalChunk33
  | 34 => principalChunk34
  | 35 => principalChunk35
  | 36 => principalChunk36
  | 37 => principalChunk37
  | 38 => principalChunk38
  | 39 => principalChunk39
  | 40 => principalChunk40
  | 41 => principalChunk41
  | 42 => principalChunk42
  | 43 => principalChunk43
  | 44 => principalChunk44
  | 45 => principalChunk45
  | 46 => principalChunk46
  | 47 => principalChunk47
  | 48 => principalChunk48
  | 49 => principalChunk49
  | 50 => principalChunk50
  | 51 => principalChunk51
  | 52 => principalChunk52
  | 53 => principalChunk53
  | 54 => principalChunk54
  | 55 => principalChunk55
  | 56 => principalChunk56
  | 57 => principalChunk57
  | 58 => principalChunk58
  | 59 => principalChunk59
  | 60 => principalChunk60
  | 61 => principalChunk61
  | 62 => principalChunk62
  | 63 => principalChunk63
  | 64 => principalChunk64
  | 65 => principalChunk65
  | 66 => principalChunk66
  | 67 => principalChunk67
  | 68 => principalChunk68
  | 69 => principalChunk69
  | 70 => principalChunk70
  | 71 => principalChunk71
  | 72 => principalChunk72
  | 73 => principalChunk73
  | 74 => principalChunk74
  | 75 => principalChunk75
  | 76 => principalChunk76
  | 77 => principalChunk77
  | 78 => principalChunk78
  | 79 => principalChunk79
  | 80 => principalChunk80
  | _ => #[]

def auxiliaryChunkAt : Nat -> Array Rat
  | 0 => auxiliaryChunk0
  | 1 => auxiliaryChunk1
  | 2 => auxiliaryChunk2
  | 3 => auxiliaryChunk3
  | 4 => auxiliaryChunk4
  | 5 => auxiliaryChunk5
  | 6 => auxiliaryChunk6
  | 7 => auxiliaryChunk7
  | 8 => auxiliaryChunk8
  | 9 => auxiliaryChunk9
  | 10 => auxiliaryChunk10
  | 11 => auxiliaryChunk11
  | 12 => auxiliaryChunk12
  | 13 => auxiliaryChunk13
  | 14 => auxiliaryChunk14
  | 15 => auxiliaryChunk15
  | 16 => auxiliaryChunk16
  | 17 => auxiliaryChunk17
  | 18 => auxiliaryChunk18
  | 19 => auxiliaryChunk19
  | 20 => auxiliaryChunk20
  | 21 => auxiliaryChunk21
  | 22 => auxiliaryChunk22
  | 23 => auxiliaryChunk23
  | 24 => auxiliaryChunk24
  | 25 => auxiliaryChunk25
  | 26 => auxiliaryChunk26
  | _ => #[]

def rowSlackChunkAt : Nat -> Array Rat
  | 0 => rowSlacksChunk0
  | 1 => rowSlacksChunk1
  | 2 => rowSlacksChunk2
  | 3 => rowSlacksChunk3
  | 4 => rowSlacksChunk4
  | 5 => rowSlacksChunk5
  | 6 => rowSlacksChunk6
  | 7 => rowSlacksChunk7
  | 8 => rowSlacksChunk8
  | 9 => rowSlacksChunk9
  | 10 => rowSlacksChunk10
  | 11 => rowSlacksChunk11
  | 12 => rowSlacksChunk12
  | 13 => rowSlacksChunk13
  | 14 => rowSlacksChunk14
  | 15 => rowSlacksChunk15
  | 16 => rowSlacksChunk16
  | 17 => rowSlacksChunk17
  | 18 => rowSlacksChunk18
  | 19 => rowSlacksChunk19
  | 20 => rowSlacksChunk20
  | 21 => rowSlacksChunk21
  | 22 => rowSlacksChunk22
  | 23 => rowSlacksChunk23
  | 24 => rowSlacksChunk24
  | 25 => rowSlacksChunk25
  | 26 => rowSlacksChunk26
  | 27 => rowSlacksChunk27
  | 28 => rowSlacksChunk28
  | 29 => rowSlacksChunk29
  | 30 => rowSlacksChunk30
  | 31 => rowSlacksChunk31
  | 32 => rowSlacksChunk32
  | 33 => rowSlacksChunk33
  | 34 => rowSlacksChunk34
  | 35 => rowSlacksChunk35
  | 36 => rowSlacksChunk36
  | 37 => rowSlacksChunk37
  | 38 => rowSlacksChunk38
  | 39 => rowSlacksChunk39
  | 40 => rowSlacksChunk40
  | 41 => rowSlacksChunk41
  | 42 => rowSlacksChunk42
  | 43 => rowSlacksChunk43
  | 44 => rowSlacksChunk44
  | 45 => rowSlacksChunk45
  | 46 => rowSlacksChunk46
  | 47 => rowSlacksChunk47
  | 48 => rowSlacksChunk48
  | 49 => rowSlacksChunk49
  | 50 => rowSlacksChunk50
  | 51 => rowSlacksChunk51
  | 52 => rowSlacksChunk52
  | 53 => rowSlacksChunk53
  | 54 => rowSlacksChunk54
  | 55 => rowSlacksChunk55
  | 56 => rowSlacksChunk56
  | 57 => rowSlacksChunk57
  | 58 => rowSlacksChunk58
  | 59 => rowSlacksChunk59
  | 60 => rowSlacksChunk60
  | 61 => rowSlacksChunk61
  | 62 => rowSlacksChunk62
  | 63 => rowSlacksChunk63
  | 64 => rowSlacksChunk64
  | 65 => rowSlacksChunk65
  | 66 => rowSlacksChunk66
  | 67 => rowSlacksChunk67
  | 68 => rowSlacksChunk68
  | 69 => rowSlacksChunk69
  | 70 => rowSlacksChunk70
  | 71 => rowSlacksChunk71
  | 72 => rowSlacksChunk72
  | 73 => rowSlacksChunk73
  | 74 => rowSlacksChunk74
  | 75 => rowSlacksChunk75
  | 76 => rowSlacksChunk76
  | 77 => rowSlacksChunk77
  | 78 => rowSlacksChunk78
  | 79 => rowSlacksChunk79
  | 80 => rowSlacksChunk80
  | _ => #[]

def principalAt (index : Nat) : Rat :=
  (principalChunkAt (index / 81))[index % 81]!

def auxiliaryAt (index : Nat) : Rat :=
  (auxiliaryChunkAt (index / 81))[index % 81]!

def rowSlackAt (index : Nat) : Rat :=
  (rowSlackChunkAt (index / 81))[index % 81]!

def modeAt (index : Nat) : Nat := 3 * index + 2

def retardedIndex (index : Nat) : Nat :=
  (((4 * modeAt index) % 19683) - 2) / 3

def d1AuxiliaryIndex (index : Nat) : Nat :=
  (((((4 * modeAt index) - 2) / 3) % 6561) - 2) / 3

def d3AuxiliaryIndex (index : Nat) : Nat :=
  (((((2 * modeAt index) - 1) / 3) % 6561) - 2) / 3

def rowRhs (index : Nat) : Rat :=
  let retarded := aCoeff * principalAt (retardedIndex index)
  if modeAt index % 9 = 2 then
    retarded + bLower * auxiliaryAt (d1AuxiliaryIndex index)
  else if modeAt index % 9 = 5 then
    retarded
  else
    retarded + dLower * auxiliaryAt (d3AuxiliaryIndex index)

def K9RowValid (index : Nat) : Prop :=
  1 <= principalAt index /\
    rowSlackAt index = rowRhs index - principalAt index /\
    0 < rowSlackAt index

def K9AuxiliaryValid (index : Nat) : Prop :=
  1 <= auxiliaryAt index /\
    auxiliaryAt index <= principalAt index /\
    auxiliaryAt index <= principalAt (index + 2187) /\
    auxiliaryAt index <= principalAt (index + 4374)

end K9CertificateVerifier
end KL2003
end CollatzClassical
