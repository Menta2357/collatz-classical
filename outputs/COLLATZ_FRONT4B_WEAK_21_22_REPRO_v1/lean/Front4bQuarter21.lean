import Front4bQuarterTail

namespace CollatzCharacterBridge.Front4bQuarter21

open P5CompensationMeetings (Affine Word endpoint divisions cost word_segment)
open StagedCylinder (Segment compose cast_segment)
open A2CertifiedLanding (PaidMeeting)

set_option maxRecDepth 16000
set_option maxHeartbeats 1500000

inductive Tail where
  | six | twoSix | threeSix | fourFour | oneEight | five | fourThree | twoFive
  deriving DecidableEq

def sourceStart : Tail → Affine
  | .six => ⟨393,1024⟩
  | .twoSix => ⟨2665,4096⟩
  | .threeSix => ⟨1353,8192⟩
  | .fourFour => ⟨777,4096⟩
  | .oneEight => ⟨2297,8192⟩
  | .five => ⟨137,512⟩
  | .fourThree => ⟨1801,2048⟩
  | .twoFive => ⟨1641,2048⟩

def originalWord : Tail → Word
  | .six => [(2,⟨2659,6912⟩),(1,⟨3989,10368⟩),(6,⟨187,486⟩)]
  | .twoSix => [(2,⟨17995,27648⟩),(1,⟨26993,41472⟩),(2,⟨20245,31104⟩),(6,⟨949,1458⟩)]
  | .threeSix => [(2,⟨9139,55296⟩),(1,⟨13709,82944⟩),(3,⟨5141,31104⟩),(6,⟨241,1458⟩)]
  | .fourFour => [(2,⟨5251,27648⟩),(1,⟨7877,41472⟩),(4,⟨1477,7776⟩),(4,⟨277,1458⟩)]
  | .oneEight => [(2,⟨15511,55296⟩),(1,⟨23267,82944⟩),(1,⟨34901,124416⟩),(8,⟨409,1458⟩)]
  | .five => [(2,⟨931,3456⟩),(1,⟨1397,5184⟩),(5,⟨131,486⟩)]
  | .fourThree => [(2,⟨12163,13824⟩),(1,⟨18245,20736⟩),(4,⟨3421,3888⟩),(3,⟨1283,1458⟩)]
  | .twoFive => [(2,⟨11083,13824⟩),(1,⟨16625,20736⟩),(2,⟨12469,15552⟩),(5,⟨1169,1458⟩)]

def sourceWord : Tail → Word
  | .six => [(2,⟨295,768⟩),(1,⟨443,1152⟩),(1,⟨665,1728⟩),(2,⟨499,1296⟩),(1,⟨749,1944⟩)]
  | .twoSix => [(2,⟨1999,3072⟩),(1,⟨2999,4608⟩),(1,⟨4499,6912⟩),(1,⟨6749,10368⟩),(3,⟨2531,3888⟩),(1,⟨3797,5832⟩)]
  | .threeSix => [(2,⟨1015,6144⟩),(1,⟨1523,9216⟩),(1,⟨2285,13824⟩),(3,⟨857,5184⟩),(2,⟨643,3888⟩),(1,⟨965,5832⟩)]
  | .fourFour => [(2,⟨583,3072⟩),(1,⟨875,4608⟩),(1,⟨1313,6912⟩),(2,⟨985,5184⟩),(2,⟨739,3888⟩),(1,⟨1109,5832⟩)]
  | .oneEight => [(2,⟨1723,6144⟩),(1,⟨2585,9216⟩),(2,⟨1939,6912⟩),(1,⟨2909,10368⟩),(3,⟨1091,3888⟩),(1,⟨1637,5832⟩)]
  | .five => [(2,⟨103,384⟩),(1,⟨155,576⟩),(1,⟨233,864⟩),(2,⟨175,648⟩)]
  | .fourThree => [(2,⟨1351,1536⟩),(1,⟨2027,2304⟩),(1,⟨3041,3456⟩),(2,⟨2281,2592⟩),(2,⟨1711,1944⟩)]
  | .twoFive => [(2,⟨1231,1536⟩),(1,⟨1847,2304⟩),(1,⟨2771,3456⟩),(1,⟨4157,5184⟩),(3,⟨1559,1944⟩)]

def adaptive : Tail → Bool
  | .five | .fourThree | .twoFive => true
  | _ => false

def originalStart (tail : Tail) : Affine :=
  ⟨9*(sourceStart tail).offset+8,9*(sourceStart tail).slope⟩

def originalEnd (tail : Tail) (t : Nat) : Nat :=
  (endpoint (originalStart tail) (originalWord tail)).at t

def sourceEnd (tail : Tail) (t : Nat) : Nat :=
  (endpoint (sourceStart tail) (sourceWord tail)).at t

abbrev HeadBook (tail : Tail) (R Z : Nat) : Prop :=
  Segment R Z (originalWord tail).length (divisions (originalWord tail)) (cost (originalWord tail))

/-- The original book and physical odd landing determine the auxiliary phase. -/
theorem phaseOfHead {tail : Tail} {U Z : Nat} (head : HeadBook tail (9*U+8) Z) :
    ∃ t, U=(sourceStart tail).at t ∧ Z=originalEnd tail t := by
  have long : 0<(originalWord tail).length := by cases tail <;> decide
  have odd : Z%2=1 := by
    rw [← A2Header.physical_endpoint head.physical,
      show (originalWord tail).length=(originalWord tail).length-1+1 by omega]
    exact step_odd _
  have book := head.book
  cases tail with
  | six =>
    change 512*Z=27*(9*U+8)+29 at book
    refine ⟨U/1024,?_⟩
    change U=393+1024*(U/1024) ∧ Z=187+486*(U/1024)
    omega
  | twoSix =>
    change 2048*Z=81*(9*U+8)+119 at book
    refine ⟨U/4096,?_⟩
    change U=2665+4096*(U/4096) ∧ Z=949+1458*(U/4096)
    omega
  | threeSix =>
    change 4096*Z=81*(9*U+8)+151 at book
    refine ⟨U/8192,?_⟩
    change U=1353+8192*(U/8192) ∧ Z=241+1458*(U/8192)
    omega
  | fourFour =>
    change 2048*Z=81*(9*U+8)+215 at book
    refine ⟨U/4096,?_⟩
    change U=777+4096*(U/4096) ∧ Z=277+1458*(U/4096)
    omega
  | oneEight =>
    change 4096*Z=81*(9*U+8)+103 at book
    refine ⟨U/8192,?_⟩
    change U=2297+8192*(U/8192) ∧ Z=409+1458*(U/8192)
    omega
  | five =>
    change 256*Z=27*(9*U+8)+29 at book
    refine ⟨U/512,?_⟩
    change U=137+512*(U/512) ∧ Z=131+486*(U/512)
    omega
  | fourThree =>
    change 1024*Z=81*(9*U+8)+215 at book
    refine ⟨U/2048,?_⟩
    change U=1801+2048*(U/2048) ∧ Z=1283+1458*(U/2048)
    omega
  | twoFive =>
    change 1024*Z=81*(9*U+8)+119 at book
    refine ⟨U/2048,?_⟩
    change U=1641+2048*(U/2048) ∧ Z=1169+1458*(U/2048)
    omega

private theorem pairedHead {tail : Tail} {U P : Nat} (head : HeadBook tail (9*U+8) P) :
    ∃ A, 0<P ∧ P%2=1 ∧ 0<A ∧ A%2=1 ∧
      (if adaptive tail then 3*(A+1)=4*(P+1) else A=4*P+1) ∧
      Segment U A (sourceWord tail).length (divisions (sourceWord tail)) (cost (sourceWord tail)) := by
  obtain ⟨t,fromU,toP⟩ := phaseOfHead head
  have fromSource := word_segment t (sourceStart tail) (sourceWord tail) (by cases tail <;> decide)
  rw [← fromU] at fromSource
  refine ⟨sourceEnd tail t,?_⟩
  rw [toP]
  refine ⟨?_,?_,?_,?_,?_,fromSource⟩
  all_goals cases tail <;> simp only [adaptive,originalEnd,sourceEnd,endpoint,originalWord,sourceWord,
    originalStart,sourceStart,Affine.at,if_true,if_false,Bool.true_eq, Bool.false_eq_true] <;> omega

def runEnd (r q : Nat) : Nat := 2*3^r*q-1

private theorem exactRun {X r q : Nat} (pos : 0<q) (factor : X+1=2^(r+1)*q) :
    Segment X (runEnd r q) r r (3^r-2^r) := by
  have factorTwo : 2^(r+1)*q=2*(2^r*q) := by rw [Nat.pow_succ]; ac_rfl
  have ge : 0<2^r*q := Nat.mul_pos (Nat.pow_pos (by decide)) pos
  have xpos : 0<X := by rw [factorTwo] at factor; omega
  have xodd : X%2=1 := by rw [factorTwo] at factor; omega
  have eq : X=2^(r+1)*q-1 := by omega
  obtain ⟨finish,ones⟩ := FixedSourceRun.ones_prefix r q pos
  rw [← eq] at finish ones
  have result := QuarterTwoSix.ones_segment xpos xodd ones
  rw [finish] at result
  exact result

private theorem quarterTracks {tail : Tail} {N J L Q j s B P : Nat} (length : 2≤L)
    (cofactor : Q%2=1) (factor : J+1=2^(L+1)*Q) (height : J<4*N+3)
    (history : Segment N J j s B) (head : HeadBook tail (orbit J L) P) :
    ∃ w A j₁ s₁ B₁ j₂ s₂ B₂, w=(J-3)/4 ∧ 0<w ∧ w%2=1 ∧ w<N ∧
      0<P ∧ P%2=1 ∧ 0<A ∧ A%2=1 ∧
      (if adaptive tail then 3*(A+1)=4*(P+1) else A=4*P+1) ∧
      Segment N P j₁ s₁ B₁ ∧ Segment w A j₂ s₂ B₂ := by
  let k := L-2
  let w := 2^(k+1)*Q-1
  have hq : 0<Q := by omega
  have hp : 0<2^k*Q := Nat.mul_pos (Nat.pow_pos (by decide)) hq
  have hs : 2^(k+1)*Q=2*(2^k*Q) := by rw [Nat.pow_succ]; ac_rfl
  have hw : w+1=2^(k+1)*Q := by unfold w; rw [hs]; omega
  have shift : L=k+2 := by unfold k; omega
  have factorFour : J+1=4*(w+1) := by
    rw [factor,hw,show L+1=(k+1)+2 by omega,Nat.pow_add]
    change (2^(k+1)*4)*Q=4*(2^(k+1)*Q)
    ac_rfl
  have price : w=(J-3)/4 ∧ 0<w ∧ w%2=1 ∧ w<N := by rw [hs] at hw; omega
  have first := exactRun hq factor
  have second := exactRun hq hw
  have relation : runEnd L Q=9*runEnd k Q+8 := by
    have mul : 2*3^L*Q=9*(2*3^k*Q) := by
      rw [shift,Nat.pow_add]
      change 2*(3^k*9)*Q=9*(2*3^k*Q)
      ac_rfl
    have positive : 0<2*3^k*Q := Nat.mul_pos (Nat.mul_pos (by decide) (Nat.pow_pos (by decide))) hq
    simp only [runEnd,mul]
    omega
  rw [A2Header.physical_endpoint first.physical,relation] at head
  obtain ⟨A,pPos,pOdd,aPos,aOdd,rel,aux⟩ := pairedHead head
  rw [relation] at first
  exact ⟨w,A,_,_,_,_,_,_,price.1,price.2.1,price.2.2.1,price.2.2.2,
    pPos,pOdd,aPos,aOdd,rel,compose (compose history first) head,compose second aux⟩

/-- The actual next valuation may be arbitrarily large. Its copy on the
auxiliary trajectory is exactly two higher. -/
theorem payFromFour {N w Z A j₁ s₁ B₁ j₂ s₂ B₂ : Nat}
    (pos : 0<w) (odd : w%2=1) (small : w<N) (zPos : 0<Z) (zOdd : Z%2=1)
    (rel : A=4*Z+1) (original : Segment N Z j₁ s₁ B₁) (auxiliary : Segment w A j₂ s₂ B₂) :
    PaidMeeting N := by
  obtain ⟨g,gPos,actual⟩ := P5R3S5.actual_step_factor Z zOdd
  have addTwo : 2^(g+2)*step Z=4*(2^g*step Z) := by
    rw [Nat.pow_add]
    change 2^g*4*step Z=4*(2^g*step Z)
    ac_rfl
  have next : 3*A+1=2^(g+2)*step Z := by rw [addTwo,← actual,rel]; omega
  have finalPos : 0<step Z := step_pos _
  have finalOdd : step Z%2=1 := step_odd _
  have first := P5R3S5.step_segment Z g zPos zOdd gPos actual
  have second : Segment A (step Z) 1 (g+2) 1 :=
    ⟨A2Header.Physical.edge (by omega) (by omega) finalPos finalOdd (by omega) next,next.symm⟩
  exact ⟨w,step Z,_,_,_,_,_,_,pos,odd,small,finalPos,finalOdd,
    compose original first,compose auxiliary second⟩

/-- All five fixed physical subcases after (2,1) followed by the actual gamma. -/
theorem paidFixed {tail : Tail} {N J L Q j s B P : Nat} (mode : adaptive tail=false)
    (length : 2≤L) (cofactor : Q%2=1) (factor : J+1=2^(L+1)*Q) (height : J<4*N+3)
    (history : Segment N J j s B) (head : HeadBook tail (orbit J L) P) : PaidMeeting N := by
  obtain ⟨w,A,_,_,_,_,_,_,_,pos,odd,small,pPos,pOdd,_,_,rel,orig,aux⟩ :=
    quarterTracks length cofactor factor height history head
  rw [mode] at rel
  exact payFromFour pos odd small pPos pOdd rel orig aux

private theorem stripTwoAtThree {a q : Nat} (h : (2^a*q)%3=0) : q%3=0 := by
  induction a with
  | zero => simpa using h
  | succ n ih =>
    apply ih
    rw [Nat.pow_succ,show 2^n*2*q=2*(2^n*q) by ac_rfl,Nat.mul_mod 2 (2^n*q) 3] at h
    have bound := Nat.mod_lt (2^n*q) (by decide : 0<3)
    omega

/-- A physical run with r ones and rupture 2 transfers to r+2 ones on
an auxiliary track satisfying 3(A+1)=4(P+1). The next return meets. -/
theorem payAfterAdaptiveRun {N w P A r q Z j₁ s₁ B₁ j₂ s₂ B₂ : Nat}
    (pos : 0<w) (odd : w%2=1) (small : w<N) (qOdd : q%2=1)
    (rel : 3*(A+1)=4*(P+1)) (factor : P+1=2^(r+1)*q)
    (original : Segment N P j₁ s₁ B₁) (auxiliary : Segment w A j₂ s₂ B₂)
    (last : Segment (orbit P r) Z 1 2 1) : PaidMeeting N := by
  have qpos : 0<q := by omega
  have scaled : 3*(A+1)=2^((r+2)+1)*q := by
    rw [rel,factor,show r+2+1=(r+1)+2 by omega,Nat.pow_add 2 (r+1) 2]
    change 4*(2^(r+1)*q)=(2^(r+1)*4)*q
    ac_rfl
  have divisible : q%3=0 := stripTwoAtThree (by rw [← scaled]; omega)
  let q' := q/3
  have fq : q=3*q' := by unfold q'; omega
  have qpos' : 0<q' := by omega
  have auxFactor : A+1=2^((r+2)+1)*q' := by
    apply Nat.mul_left_cancel (by decide : 0<3)
    calc
      _ = 2^((r+2)+1)*q := scaled
      _ = _ := by rw [fq]; ac_rfl
  have first := exactRun qpos factor
  have second := exactRun qpos' auxFactor
  rw [A2Header.physical_endpoint first.physical] at last
  have tripleEnd : runEnd (r+2) q'=3*runEnd r q+2 := by
    have scale : 3^(r+2)*q'=3*(3^r*q) := by rw [Nat.pow_add,fq]; change (3^r*(3*3))*q'=3*(3^r*(3*q')); ac_rfl
    have positive : 0<2*3^r*q := Nat.mul_pos (Nat.mul_pos (by decide) (Nat.pow_pos (by decide))) qpos
    have all : 2*3^(r+2)*q'=3*(2*3^r*q) := by
      calc
        _ = 2*(3^(r+2)*q') := by ac_rfl
        _ = 2*(3*(3^r*q)) := by rw [scale]
        _ = _ := by ac_rfl
    rw [runEnd,runEnd,all]
    omega
  have atZ := last.book
  change 4*Z=3*runEnd r q+1 at atZ
  have meetRelation : runEnd (r+2) q'=4*Z+1 := by omega
  have zState := A2Header.physical_endpoint last.physical
  have zPos : 0<Z := by rw [← zState]; exact step_pos _
  have zOdd : Z%2=1 := by rw [← zState]; exact step_odd _
  exact payFromFour pos odd small zPos zOdd meetRelation
    (compose (compose original first) last) (compose auxiliary second)

/-- Three distinct heads share the entire second-run capture mechanism. -/
theorem paidAdaptive {tail : Tail} {N J L Q j s B P r q Z : Nat} (mode : adaptive tail=true)
    (length : 2≤L) (cofactor : Q%2=1) (factor : J+1=2^(L+1)*Q) (height : J<4*N+3)
    (history : Segment N J j s B) (head : HeadBook tail (orbit J L) P)
    (qOdd : q%2=1) (pPlus : P+1=2^(r+1)*q) (last : Segment (orbit P r) Z 1 2 1) :
    PaidMeeting N := by
  obtain ⟨w,A,_,_,_,_,_,_,_,pos,odd,small,_,_,_,_,rel,orig,aux⟩ :=
    quarterTracks length cofactor factor height history head
  rw [mode] at rel
  exact payAfterAdaptiveRun pos odd small qOdd rel pPlus orig aux last

end CollatzCharacterBridge.Front4bQuarter21

#print axioms CollatzCharacterBridge.Front4bQuarter21.phaseOfHead
#print axioms CollatzCharacterBridge.Front4bQuarter21.payFromFour
#print axioms CollatzCharacterBridge.Front4bQuarter21.paidFixed
#print axioms CollatzCharacterBridge.Front4bQuarter21.payAfterAdaptiveRun
#print axioms CollatzCharacterBridge.Front4bQuarter21.paidAdaptive
