import Std

namespace Terras90Lattice

def logScale : Nat := 10^60
def budgetScale : Nat := 10^55
def log2Low : Nat := 693147180559945309417232121458176568075500134360255254120680
def log2High : Nat := 693147180559945309417232121458176568075500134360255254120681
def log3Low : Nat := 1098612288668109691395245236922525704647490557822749451734694
def log3High : Nat := 1098612288668109691395245236922525704647490557822749451734695

def basisK : Nat := 206745572560704147
def basisD : Nat := 130441933147714940
def otherK : Nat := 423372672964960618
def otherD : Nat := 267118416222671843
def maxOdds : Nat := 2^71
def maxIndex : Nat := 5593
def globalGap : Nat := 3214285714285714285714285714285714285714286

def lowGap (k d : Nat) : Int := (k:Int)*log2Low-(d:Int)*log3High
def highGap (k d : Nat) : Int := (k:Int)*log2High-(d:Int)*log3Low

def epsilonLow : Nat := otherD*log3Low-otherK*log2High
def epsilonHigh : Nat := otherD*log3High-otherK*log2Low
def basisLow : Nat := basisK*log2Low-basisD*log3High
def basisHigh : Nat := basisK*log2High-basisD*log3Low

def jLower (h : Nat) : Nat :=
  if globalGap≤h*basisLow then (h*basisLow-globalGap)/epsilonHigh+1 else 0
def jUpper (h : Nat) : Nat := (h*basisHigh-1)/epsilonLow

def toClock (h j : Nat) : Nat × Nat :=
  (h*basisK+j*otherK, h*basisD+j*otherD)

theorem basisDeterminant : otherD*basisK=otherK*basisD+1 := by decide

end Terras90Lattice
