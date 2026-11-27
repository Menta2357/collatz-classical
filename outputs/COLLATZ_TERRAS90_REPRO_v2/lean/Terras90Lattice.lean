import Terras90LatticeData

namespace Terras90Lattice

private theorem splitInt (h j k d p q a b : Int) :
    (h*k+j*p)*a-(h*d+j*q)*b = h*(k*a-d*b)-j*(q*b-p*a) := by
  simp only [Int.add_mul,Int.mul_sub,Int.mul_assoc]
  omega

private theorem indexEq (k d p q a b : Int) :
    a*(q*k-p*d)=q*(k*a-d*b)+d*(q*b-p*a) := by
  simp only [Int.mul_sub]
  rw [show a*(q*k)=q*(k*a) by ac_rfl, show a*(p*d)=d*(p*a) by ac_rfl,
      show q*(d*b)=d*(q*b) by ac_rfl]
  omega

private theorem inverseIndices (k d p q v w : Int) (det : q*v-p*w=1) :
    (q*k-p*d)*v+(v*d-w*k)*p=k ∧ (q*k-p*d)*w+(v*d-w*k)*q=d := by
  constructor
  · calc
      _ = (q*v-p*w)*k := by
        simp only [Int.sub_mul]
        rw [show q*k*v=q*v*k by ac_rfl, show p*d*v=v*d*p by ac_rfl,
          show w*k*p=p*w*k by ac_rfl]
        omega
      _ = _ := by simp [det]
  · calc
      _ = (q*v-p*w)*d := by
        simp only [Int.sub_mul]
        rw [show q*k*w=w*k*q by ac_rfl, show p*d*w=p*w*d by ac_rfl,
          show v*d*q=q*v*d by ac_rfl]
        omega
      _ = _ := by simp [det]

private theorem basisLowEq : (basisLow:Int)=basisK*(log2Low:Int)-basisD*(log3High:Int) := by decide
private theorem basisHighEq : (basisHigh:Int)=basisK*(log2High:Int)-basisD*(log3Low:Int) := by decide
private theorem epsilonLowEq : (epsilonLow:Int)=otherD*(log3Low:Int)-otherK*(log2High:Int) := by decide
private theorem epsilonHighEq : (epsilonHigh:Int)=otherD*(log3High:Int)-otherK*(log2Low:Int) := by decide

theorem gapSplit (h j : Nat) :
    lowGap (toClock h j).1 (toClock h j).2 =
      (h:Int)*basisLow-(j:Int)*epsilonHigh ∧
    highGap (toClock h j).1 (toClock h j).2 =
      (h:Int)*basisHigh-(j:Int)*epsilonLow := by
  constructor
  · rw [basisLowEq,epsilonHighEq]
    simpa only [lowGap,toClock,Int.natCast_add,Int.natCast_mul] using
      splitInt h j basisK basisD otherK otherD log2Low log3High
  · rw [basisHighEq,epsilonLowEq]
    simpa only [highGap,toClock,Int.natCast_add,Int.natCast_mul] using
      splitInt h j basisK basisD otherK otherD log2High log3Low

/-- Every clock in the rounded strip has unique nonnegative coordinates
in the unimodular basis and an index in the finite checked interval. -/
theorem admitCoordinates {k d : Nat}
    (small : d<maxOdds) (lower : lowGap k d<globalGap) (upper : 0<highGap k d) :
    ∃ h j, 1≤h ∧ h≤maxIndex ∧ jLower h≤j ∧ j≤jUpper h ∧ toClock h j=(k,d) := by
  let x : Int := (otherD:Int)*k-(otherK:Int)*d
  let y : Int := (basisK:Int)*d-(basisD:Int)*k
  have xHigh := indexEq k d otherK otherD log2High log3Low
  change (log2High:Int)*x = (otherD:Int)*highGap k d+
    d*((otherD:Int)*log3Low-(otherK:Int)*log2High) at xHigh
  rw [← epsilonLowEq] at xHigh
  have xLow := indexEq k d otherK otherD log2Low log3High
  change (log2Low:Int)*x = (otherD:Int)*lowGap k d+
    d*((otherD:Int)*log3High-(otherK:Int)*log2Low) at xLow
  rw [← epsilonHighEq] at xLow
  have xPos : 0<x := by
    have positive := Int.mul_pos (by decide : 0<(otherD:Int)) upper
    have added := Int.mul_nonneg (Int.natCast_nonneg d) (by decide : 0≤(epsilonLow:Int))
    have productPositive : 0<(log2High:Int)*x := by rw [xHigh]; omega
    exact Int.lt_of_mul_lt_mul_left (by simpa using productPositive)
      (by decide : 0≤(log2High:Int))
  have xMax : x≤maxIndex := by
    have lo := Int.mul_lt_mul_of_pos_left lower (by decide : 0<(otherD:Int))
    have hi := Int.mul_le_mul_of_nonneg_right (Int.ofNat_le.mpr (Nat.le_of_lt small))
      (by decide : 0≤(epsilonHigh:Int))
    have threshold : (otherD:Int)*globalGap+(maxOdds:Int)*epsilonHigh < log2Low*((maxIndex:Int)+1) := by decide
    have productBound : (log2Low:Int)*x < log2Low*((maxIndex:Int)+1) := by rw [xLow]; omega
    have idx := Int.lt_of_mul_lt_mul_left productBound (by decide : 0≤(log2Low:Int))
    omega
  have inv : x*basisK+y*otherK = k ∧ x*basisD+y*otherD = d :=
    inverseIndices k d otherK otherD basisK basisD (by decide)
  have lowSplit : lowGap k d = x*basisLow-y*epsilonHigh := by
    rw [basisLowEq,epsilonHighEq]
    have split := splitInt x y basisK basisD otherK otherD log2Low log3High
    rw [inv.1,inv.2] at split
    exact split
  have yPos : 0≤y := by
    by_cases nonnegative : 0≤y
    · exact nonnegative
    · have severity : y≤-1 := by omega
      have xpart := Int.mul_le_mul_of_nonneg_right (by omega : (1:Int)≤x)
        (by decide : 0≤(basisLow:Int))
      have ypart := Int.mul_le_mul_of_nonneg_right severity
        (by decide : 0≤(epsilonHigh:Int))
      have threshold : (globalGap:Int)<(basisLow:Int)+epsilonHigh := by decide
      simp only [Int.one_mul,Int.neg_mul,Int.neg_one_mul] at xpart ypart
      omega
  let h := x.toNat
  let j := y.toNat
  have hValue : (h:Int)=x := Int.toNat_of_nonneg (Int.le_of_lt xPos)
  have jValue : (j:Int)=y := Int.toNat_of_nonneg yPos
  have clocks : toClock h j=(k,d) := by
    obtain ⟨first,next⟩ := inv
    rw [← hValue,← jValue] at first next
    exact Prod.ext
      (Int.ofNat_inj.mp (by simpa only [toClock,Int.natCast_mul,Int.natCast_add] using first))
      (Int.ofNat_inj.mp (by simpa only [toClock,Int.natCast_mul,Int.natCast_add] using next))
  have lower' : (h:Int)*basisLow-(j:Int)*epsilonHigh < globalGap := by
    rw [← (gapSplit h j).1,clocks]
    exact lower
  have upper' : 0 < (h:Int)*basisHigh-(j:Int)*epsilonLow := by
    rw [← (gapSplit h j).2,clocks]
    exact upper
  have loNat : h*basisLow < j*epsilonHigh+globalGap := by omega
  have hiNat : j*epsilonLow < h*basisHigh := by omega
  refine ⟨h,j,by omega,by omega,?_,?_,clocks⟩
  · unfold jLower
    split
    · apply Nat.succ_le_of_lt
      apply (Nat.div_lt_iff_lt_mul (by decide : 0<epsilonHigh)).2
      omega
    · exact Nat.zero_le _
  · unfold jUpper
    apply (Nat.le_div_iff_mul_le (by decide : 0<epsilonLow)).2
    omega

end Terras90Lattice
