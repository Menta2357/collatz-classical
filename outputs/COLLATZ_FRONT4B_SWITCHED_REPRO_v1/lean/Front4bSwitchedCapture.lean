import Front4bTail22
import Front4bQuarter21

namespace CollatzCharacterBridge.Front4bSwitchedCapture

open StagedCylinder (Segment compose)
open A2CertifiedLanding (PaidMeeting)

private theorem removeTwos (n Q : Nat) (divides : 3 ∣ 2^n*Q) : 3 ∣ Q := by
  induction n with
  | zero => simpa using divides
  | succ n ih =>
    apply ih
    obtain ⟨r,hr⟩ := divides
    rw [Nat.pow_succ] at hr
    have scaled : 2*(2^n*Q)=3*r := by rw [←hr]; ac_rfl
    exact ⟨r/2,by omega⟩

/-- The physical last one of the first weak pair lets the original start its
second run one return earlier. The shorter source consequently has price
(Z+1)/6-1, while the terminal phase still uses 3^H*Q. -/
theorem oneThenTwo {N F Z j S B H Q : Nat} (history : Segment N F j S B)
    (one : 3*F+1=2*Z) (window : F<4*N+1) (length : 1≤H) (positive : 0<Q)
    (reserve : Z+1=2^(H+1)*Q)
    (phase : (3^H*Q)%16384=7585 ∨ (3^H*Q)%65536=56225) : PaidMeeting N := by
  have factor : 3*(F+1)=2^(H+2)*Q := by
    have shift : 3*(F+1)=2*(Z+1) := by omega
    rw [shift,reserve]
    change 2*(2^(H+1)*Q)=(2^(H+1)*2)*Q
    ac_rfl
  have divisible := removeTwos (H+2) Q ⟨F+1,factor.symm⟩
  obtain ⟨q,hq⟩ := divisible
  have qPos : 0<q := by omega
  have balance : 3*(F+1)=3*(2^(H+2)*q) := by rw [factor,hq]; ac_rfl
  have newReserve := Nat.mul_left_cancel (by decide : 0<(3:Nat)) balance
  let k := H-1
  have k2 : k+2=H+1 := by dsimp only [k]; omega
  have k3 : k+3=H+2 := by dsimp only [k]; omega
  have newReserve' : F+1=2^(k+3)*q := by rw [k3]; exact newReserve
  have scale : 3^(k+2)*q=3^H*Q := by
    rw [k2,Nat.pow_succ,hq]
    ac_rfl
  rcases phase with short | deep
  · exact Front4bTail22.paysTwoTwoTen history window qPos newReserve' (by rwa [scale])
  · exact Front4bTail22.paysTwoTwoSixSix history window qPos newReserve' (by rwa [scale])

/-- The other switch starts its second run at the first double-two terminal.
The existing quarter-source proof consumes that terminal's original book. -/
theorem twoThenOneFixed {N J Z P j S B L H Q : Nat} {tail : Front4bQuarter21.Tail}
    (mode : Front4bQuarter21.adaptive tail=false) (history : Segment N J j S B)
    (first : Segment J Z (L+2) (L+4) (3^(L+2)-2^(L+1)))
    (window : Z<4*N+3) (length : 2≤H) (odd : Q%2=1) (reserve : Z+1=2^(H+1)*Q)
    (head : Front4bQuarter21.HeadBook tail (orbit Z H) P) : PaidMeeting N :=
  Front4bQuarter21.paidFixed mode length odd reserve window (compose history first) head

/-- After enough twos have moved the original into the priced band, an exact
three yields a physical one-return source while the meeting stays above N. -/
theorem captureAtThree {N X Z j S B : Nat} (history : Segment N X j S B)
    (lower : 3*N<X) (upper : X<4*N) (positive : 0<Z) (odd : Z%2=1)
    (three : 3*X+1=8*Z) : N<Z ∧ PaidMeeting N := by
  let w := (X-1)/4
  have xPos : 0<X := by omega
  have xOdd : X%2=1 := by omega
  have form : X=4*w+1 := by dsimp only [w]; omega
  have one : 3*w+1=2*Z := by omega
  have wPos : 0<w := by omega
  have wOdd : w%2=1 := by omega
  have price : w<N := by omega
  have original : Segment X Z 1 3 1 :=
    ⟨A2Header.Physical.edge xPos xOdd positive odd (by decide) (by simpa using three),
      by simpa using three.symm⟩
  have source : Segment w Z 1 1 1 :=
    ⟨A2Header.Physical.edge wPos wOdd positive odd (by decide) (by simpa using one),
      by simpa using one.symm⟩
  exact ⟨by omega,⟨w,Z,_,_,_,1,1,1,wPos,wOdd,price,positive,odd,compose history original,source⟩⟩

end CollatzCharacterBridge.Front4bSwitchedCapture

#print axioms CollatzCharacterBridge.Front4bSwitchedCapture.oneThenTwo
#print axioms CollatzCharacterBridge.Front4bSwitchedCapture.twoThenOneFixed
#print axioms CollatzCharacterBridge.Front4bSwitchedCapture.captureAtThree
