import A2CertifiedLanding
import A2SecondSwitchWordCompiler

namespace CollatzCharacterBridge.Front4bTail22

open StagedCylinder (Segment compose)
open A2CertifiedLanding (PaidMeeting)
open A2SecondSwitchWordCompiler (ValWord total cost compile_word)

set_option maxHeartbeats 1000000
set_option maxRecDepth 16000

private theorem quarterPrefix {N J k Q : Nat} (positive : 0<Q)
    (reserve : J+1=2^(k+3)*Q) (window : J<4*N+1) :
    let w := 2^(k+1)*Q-1
    let R := orbit J (k+2)
    let U := orbit w k
    (0<J ∧ J%2=1) ∧ (0<w ∧ w%2=1 ∧ w<N) ∧ R=9*U+8 ∧
    R=2*3^(k+2)*Q-1 ∧ Segment J R (k+2) (k+2) (3^(k+2)-2^(k+2)) ∧
    Segment w U k k (3^k-2^k) := by
  let w := 2^(k+1)*Q-1
  have mpos : 0<2^k*Q := Nat.mul_pos (Nat.pow_pos (by decide)) positive
  have qsmall : 2^(k+1)*Q=2*(2^k*Q) := by rw [Nat.pow_succ]; ac_rfl
  have qlarge : 2^(k+3)*Q=8*(2^k*Q) := by
    rw [Nat.pow_add]
    change (2^k*8)*Q=8*(2^k*Q)
    ac_rfl
  have reserve' : J+1=8*(2^k*Q) := reserve.trans qlarge
  have wshape : w=2*(2^k*Q)-1 := by dsimp only [w]; rw [qsmall]
  have jGood : 0<J ∧ J%2=1 := by omega
  have wGood : 0<w ∧ w%2=1 ∧ w<N := by omega
  have base : J=2^(k+2+1)*Q-1 := by
    rw [show k+2+1=k+3 by omega,←reserve]
    omega
  have orig := FixedSourceRun.ones_prefix (k+2) Q positive
  rw [←base] at orig
  have aux := FixedSourceRun.ones_prefix k Q positive
  change orbit w k=2*3^k*Q-1 ∧ FixedSourceRun.Ones w k at aux
  have power : 2*3^(k+2)*Q=9*(2*3^k*Q) := by
    rw [Nat.pow_add]
    change 2*(3^k*9)*Q=9*(2*3^k*Q)
    ac_rfl
  have powpos : 0<2*3^k*Q := Nat.mul_pos (Nat.mul_pos (by decide)
    (Nat.pow_pos (by decide))) positive
  have align : orbit J (k+2)=9*orbit w k+8 := by rw [orig.1,aux.1,power]; omega
  exact ⟨jGood,wGood,align,orig.1,A2HalfAdaptive.ones_segment _ _ jGood.1 jGood.2 orig.2,
    A2HalfAdaptive.ones_segment _ _ wGood.1 wGood.2.1 aux.2⟩

private theorem meet {N w Z j S B r s C : Nat} (original : Segment N Z j S B)
    (source : Segment w (4*Z+1) r s C) (wp : 0<w) (wo : w%2=1) (price : w<N)
    (zp : 0<Z) (zo : Z%2=1) : PaidMeeting N := by
  obtain ⟨g,positive,factor⟩ := P5R3S5.actual_step_factor Z zo
  have balance : 3*(4*Z+1)+1=2^(g+2)*step Z := by
    rw [show 3*(4*Z+1)+1=4*(3*Z+1) by omega,factor,Nat.pow_add]
    change 4*(2^g*step Z)=(2^g*4)*step Z
    ac_rfl
  have orig := compose original (P5R3S5.step_segment Z g zp zo positive factor)
  have auxStep : Segment (4*Z+1) (step Z) 1 (g+2) 1 :=
    ⟨A2Header.Physical.edge (by omega) (by omega) (step_pos Z) (step_odd Z)
      (by omega) balance,balance.symm⟩
  exact ⟨w,step Z,_,_,_,_,_,_,wp,wo,price,step_pos Z,step_odd Z,orig,compose source auxStep⟩

/-- An exact physical capture in phase (2,2,10), with the following valuation free. -/
theorem paysTwoTwoTen {N J j S B k Q : Nat} (history : Segment N J j S B)
    (window : J<4*N+1) (positive : 0<Q) (reserve : J+1=2^(k+3)*Q)
    (phase : (3^(k+2)*Q)%16384=7585) : PaidMeeting N := by
  let w := 2^(k+1)*Q-1
  let M := 3^(k+2)*Q
  let R := orbit J (k+2)
  let U := orbit w k
  let Z := 25+54*(M/16384)
  obtain ⟨jGood,wGood,align,origShape,origPrefix,auxPrefix⟩ :=
    quarterPrefix positive reserve window
  have originalBook : 16384*Z=27*R+37 := by
    have decomp := Nat.mod_add_div M 16384
    change M%16384=7585 at phase
    have shape : R=2*M-1 := by simpa only [R,M,Nat.mul_assoc] using origShape
    rw [phase] at decomp
    dsimp only [Z]
    omega
  have sourceBook : 4096*(4*Z+1)=243*U+4349 := by
    change R=9*U+8 at align
    omega
  have zp : 0<Z := by dsimp only [Z]; omega
  have zo : Z%2=1 := by dsimp only [Z]; omega
  have origTail : Segment R Z 3 14 37 :=
    compile_word [2,2,10] (orbit_pos _ jGood.1 _) (orbit_odd _ jGood.2 _) zp zo
      (by intro a ha; simp at ha; omega) originalBook
  have auxTail : Segment U (4*Z+1) 5 12 4349 :=
    compile_word [2,4,3,2,1] (orbit_pos _ wGood.1 _) (orbit_odd _ wGood.2.1 _)
      (by omega) (by omega) (by intro a ha; simp at ha; omega) sourceBook
  exact meet (compose (compose history origPrefix) origTail) (compose auxPrefix auxTail)
    wGood.1 wGood.2.1 wGood.2.2 zp zo

/-- An exact physical capture in phase (2,2,6,6), with the following valuation free. -/
theorem paysTwoTwoSixSix {N J j S B k Q : Nat} (history : Segment N J j S B)
    (window : J<4*N+1) (positive : 0<Q) (reserve : J+1=2^(k+3)*Q)
    (phase : (3^(k+2)*Q)%65536=56225) : PaidMeeting N := by
  let w := 2^(k+1)*Q-1
  let M := 3^(k+2)*Q
  let R := orbit J (k+2)
  let U := orbit w k
  let Z := 139+162*(M/65536)
  obtain ⟨jGood,wGood,align,origShape,origPrefix,auxPrefix⟩ :=
    quarterPrefix positive reserve window
  have originalBook : 65536*Z=81*R+1135 := by
    have decomp := Nat.mod_add_div M 65536
    change M%65536=56225 at phase
    have shape : R=2*M-1 := by simpa only [R,M,Nat.mul_assoc] using origShape
    rw [phase] at decomp
    dsimp only [Z]
    omega
  have sourceBook : 16384*(4*Z+1)=729*U+18167 := by
    change R=9*U+8 at align
    omega
  have zp : 0<Z := by dsimp only [Z]; omega
  have zo : Z%2=1 := by dsimp only [Z]; omega
  have origTail : Segment R Z 4 16 1135 :=
    compile_word [2,2,6,6] (orbit_pos _ jGood.1 _) (orbit_odd _ jGood.2 _) zp zo
      (by intro a ha; simp at ha; omega) originalBook
  have auxTail : Segment U (4*Z+1) 6 14 18167 :=
    compile_word [2,4,3,1,3,1] (orbit_pos _ wGood.1 _) (orbit_odd _ wGood.2.1 _)
      (by omega) (by omega) (by intro a ha; simp at ha; omega) sourceBook
  exact meet (compose (compose history origPrefix) origTail) (compose auxPrefix auxTail)
    wGood.1 wGood.2.1 wGood.2.2 zp zo

end CollatzCharacterBridge.Front4bTail22

#print axioms CollatzCharacterBridge.Front4bTail22.paysTwoTwoTen
#print axioms CollatzCharacterBridge.Front4bTail22.paysTwoTwoSixSix
