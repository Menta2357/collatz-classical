import Terras90LatticeData

namespace Terras90IntegerFloors

open Terras90Lattice

def precision : Nat := 10^64

def denominator (b i : Nat) : Nat :=
  (2*i+1)*b^(2*i+1)

def floorTerm (b i : Nat) : Nat :=
  (2*precision)/denominator b i

def floorSum (b : Nat) : Nat → Nat
  | 0 => 0
  | n+1 => floorSum b n + floorTerm b n

theorem floorTwoLow : 10000*log2Low≤floorSum 3 65 := by decide
theorem floorTwoHigh : floorSum 3 65+65+100≤10000*log2High := by decide
theorem floorThreeLow : 10000*log3Low≤floorSum 2 110 := by decide
theorem floorThreeHigh : floorSum 2 110+110+100≤10000*log3High := by decide

end Terras90IntegerFloors
