import Front4bLowExit

namespace CollatzCharacterBridge.Front4bShortR2Three

open StagedCylinder (Segment compose)
open P5CompensationMeetings (Affine affine_admissible)
open Front4bRowEven (originalSeed originalSeedFormula pivot)
open Front4bS29Landing (history62 landing)
open A2CertifiedLanding (PaidMeeting Descended Landing)
open FixedSourceRun (Ones)

set_option maxRecDepth 14000
set_option maxHeartbeats 500000

def row (k : Nat) : Nat := 3733266+33554432*k

def seed (k : Nat) : Nat := originalSeed (row k)

def checkpoint : Affine :=
  ⟨7308983964186331826684671241969942827,65692813073042632584925871202837021156⟩

def firstOne : Affine :=
  ⟨10963475946279497740027006862954914241,98539219609563948877388806804255531734⟩

def prefixCost : Nat := 3^16*2417122598839266567112547605177+2^98*82533593

private def tail : List Nat := [1,1,2,1,1,1,2,2,1,1,1,2,1,4,2,2]

/-- The exact cylinder, stopped immediately before its compulsory 1. -/
theorem history (k : Nat) :
    Segment (pivot (row k)) (checkpoint.at k) 16 25 82533593 ∧
      Segment (seed k) (checkpoint.at k) 78 123 prefixCost ∧
      Segment (checkpoint.at k) (firstOne.at k) 1 1 1 := by
  have p := affine_admissible (f:=landing) (by decide) (row k)
  have q := affine_admissible (f:=checkpoint) (by decide) k
  have b : 33554432*checkpoint.at k=43046721*pivot (row k)+82533593 := by
    simp only [row,checkpoint,pivot,landing,Affine.at,Nat.mul_add,←Nat.mul_assoc]
    omega
  have seg : Segment (pivot (row k)) (checkpoint.at k) 16 25 82533593 :=
    A2SecondSwitchWordCompiler.compile_word tail p.1 p.2 q.1 q.2
      (by intro a ha; simp [tail] at ha; omega) b
  have one : Segment (checkpoint.at k) (firstOne.at k) 1 1 1 :=
    P5CompensationMeetings.affine_edge (by decide) k
  exact ⟨seg,compose (history62 (row k)) seg,one⟩

private theorem heights (k : Nat) :
    1<seed k ∧ pivot (row k)<checkpoint.at k ∧ checkpoint.at k<2*seed k+1 ∧
      3*firstOne.at k+1<8*seed k := by
  simp only [seed,row,checkpoint,firstOne,pivot,landing,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
  omega

private theorem descentOfEdge {N X Y j S B a floor : Nat} (hist : Segment N X j S B)
    (edge : Segment X Y 1 a 1) (pow : floor≤2^a) (price : 3*X+1<floor*N) : Descended N := by
  have book := edge.book
  simp only [Nat.pow_one] at book
  have bound := Nat.mul_le_mul_right N pow
  have strict : 2^a*Y<2^a*N := by omega
  have endState := A2Header.physical_endpoint edge.physical
  have pos : 0<Y := by rw [←endState]; exact step_pos X
  have odd : Y%2=1 := by rw [←endState]; exact step_odd X
  exact ⟨Y,_,_,_,pos,odd,Nat.lt_of_mul_lt_mul_left strict,compose hist edge⟩

/-- A strong return immediately after that 1 descends with its true clock. -/
theorem immediateStrong {k Y a : Nat} (strong : 3≤a)
    (edge : Segment (firstOne.at k) Y 1 a 1) : Descended (seed k) :=
  descentOfEdge (compose (history k).2.1 (history k).2.2) edge
    (Nat.pow_le_pow_right (by decide) strong) (heights k).2.2.2

/-- The entire real one-run can be consumed. If it ends with a strong
break the half source pays. The weak branch retains the actual book. -/
theorem halfPaidOrWeak (k : Nat) : PaidMeeting (seed k) ∨
    ∃ L, 1≤L ∧ Ones (checkpoint.at k) L ∧
      3*orbit (checkpoint.at k) L+1=4*orbit (checkpoint.at k) (L+1) ∧
      Segment (seed k) (orbit (checkpoint.at k) (L+1)) (78+(L+1)) (123+(L+2))
        (3^(L+1)*prefixCost+2^123*(3^(L+1)-2^(L+1))) := by
  let U := checkpoint.at k
  have admissible := affine_admissible (f:=checkpoint) (by decide) k
  obtain ⟨L,b,run,hb,breakFactor⟩ := A2HalfAdaptive.first_break U admissible.2
  have one := (history k).2.2
  have oneLanding := A2Header.physical_endpoint one.physical
  have first : 3*U+1=2*orbit U 1 := by rw [oneLanding]; exact one.book.symm
  have long : 1≤L := by
    by_cases zero : L=0
    · rw [zero] at breakFactor
      change 3*U+1=2^b*orbit U 1 at breakFactor
      have pow : (2:Nat)^2≤2^b := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) hb
      have upper := Nat.mul_le_mul_right (orbit U 1) pow
      have pos : 0<orbit U 1 := orbit_pos _ admissible.1 _
      omega
    · omega
  by_cases weak : b=2
  · rw [weak] at breakFactor
    change 3*orbit U L+1=4*orbit U (L+1) at breakFactor
    have ones := A2HalfAdaptive.ones_segment U L admissible.1 admissible.2 run
    have edge : Segment (orbit U L) (orbit U (L+1)) 1 2 1 :=
      ⟨A2Header.Physical.edge (orbit_pos _ admissible.1 _) (orbit_odd _ admissible.2 _)
        (orbit_pos _ admissible.1 _) (orbit_odd _ admissible.2 _) (by decide) breakFactor,
        breakFactor.symm⟩
    have localPath := compose ones edge
    have exp : 3*(3^L-2^L)+2^L=3^(L+1)-2^(L+1) := by
      have cap : 2^L≤3^L := Nat.pow_le_pow_left (by decide) _
      rw [Nat.pow_succ 3 L,Nat.pow_succ 2 L]
      omega
    simp only [Nat.pow_one,Nat.mul_one,exp] at localPath
    exact Or.inr ⟨L,long,run,breakFactor,compose (history k).2.1 localPath⟩
  · let m := L-1
    have hL : L=m+1 := by unfold m; omega
    rw [hL] at run breakFactor
    have f : 3*orbit U (m+1)+1=2^b*orbit U (m+2) := by simpa only [Nat.add_assoc] using breakFactor
    obtain ⟨positive,odd,paid,original,source⟩ :=
      A2HalfAdaptive.history_capture (history k).2.1 admissible.1 admissible.2
        (heights k).2.2.1 run (by omega : 3≤b) f
    exact Or.inl ⟨A2HalfAdaptive.half U,orbit U (m+2),_,_,_,_,_,_,positive,odd,paid,
      orbit_pos _ admissible.1 _,orbit_odd _ admissible.2 _,original,source⟩

/-- A genuine 2 immediately after the 1 returns within the ambient A2
height window. This supplies an admitted cut or payment at that price. -/
theorem afterOneTwoLanding {k Y : Nat} (edge : Segment (firstOne.at k) Y 1 2 1) :
    Landing (seed k) Y := by
  have book := edge.book
  change 4*Y=3*firstOne.at k+1 at book
  have p : Y<2*seed k+1 := by
    have price := (heights k).2.2.2
    omega
  have endState := A2Header.physical_endpoint edge.physical
  have pos : 0<Y := by rw [←endState]; exact step_pos _
  have odd : Y%2=1 := by rw [←endState]; exact step_odd _
  exact A2CertifiedLanding.reduce_window_certified (heights k).1
    (compose (compose (history k).2.1 (history k).2.2) edge) pos odd p

private theorem cheapOne {N Y j S B : Nat} (hist : Segment N Y j S B)
    (odd : Y%2=1) (modulo : Y%3=2) (price : 2*Y<3*N+1) : PaidMeeting N := by
  let w := (2*Y-1)/3
  have book : 3*w+1=2*Y := by unfold w; omega
  have pos : 0<w := by omega
  have sourceOdd : w%2=1 := by omega
  have small : w<N := by omega
  have yPos : 0<Y := by omega
  exact ⟨w,Y,j,S,B,1,1,1,pos,sourceOdd,small,yPos,odd,hist,
    ⟨A2Header.Physical.edge pos sourceOdd yPos odd (by decide) book,book.symm⟩⟩

/-- Three ones, then (2,3), pay at the terminal by a single return. -/
theorem threeOnesTwoThree {k Y : Nat} (word : Segment (checkpoint.at k) Y 5 8 227) :
    PaidMeeting (seed k) := by
  have book := word.book
  change 256*Y=243*checkpoint.at k+227 at book
  have price : 2*Y<3*seed k+1 := by
    suffices 2*(243*checkpoint.at k+227)<256*(3*seed k+1) by omega
    simp only [checkpoint,seed,row,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have odd : Y%2=1 := by rw [←A2Header.physical_endpoint word.physical]; exact step_odd _
  exact cheapOne (compose (history k).2.1 word) odd (by omega) price

/-- Four ones followed by (2,4) cross the old T62 pivot, preserving the
history to the first strict crossing chosen by the A2 consumer. -/
theorem fourOnesTwoFourCrossing {k Y : Nat} (word : Segment (checkpoint.at k) Y 6 10 697) :
    seed k<Y ∧ Y<pivot (row k) ∧
      A2FirstCrossingFusion.FirstCrossing (seed k) (pivot (row k)) Y
        62 98 2417122598839266567112547605177 22 35 (729*82533593+2^25*697) := by
  have book := word.book
  change 1024*Y=729*checkpoint.at k+697 at book
  have margin : seed k<Y ∧ Y<pivot (row k) := by
    have pay : 1024*seed k<729*checkpoint.at k+697 ∧
        729*checkpoint.at k+697<1024*pivot (row k) := by
      simp only [seed,row,checkpoint,pivot,landing,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
      omega
    omega
  have tailPath := compose (history k).1 word
  have pOdd := (affine_admissible (f:=landing) (by decide) (row k)).2
  have pWindow : pivot (row k)<2*seed k+1 := by
    simp only [seed,row,pivot,landing,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have hit : A2FirstCrossingFusion.HitsBelow (pivot (row k)) (pivot (row k)) 22 :=
    ⟨22,by decide,by rw [A2Header.physical_endpoint tailPath.physical]; exact margin.2⟩
  exact ⟨margin.1,margin.2,A2FirstCrossingFusion.reduce_first_crossing (heights k).1 pOdd pWindow
    (history62 (row k)) tailPath hit⟩

/-- The physical (1^6,2,5) continuation pays via one return. -/
theorem sixOnesTwoFive {k Y : Nat} (word : Segment (checkpoint.at k) Y 8 13 6433) :
    PaidMeeting (seed k) := by
  have book := word.book
  change 8192*Y=6561*checkpoint.at k+6433 at book
  have price : 2*Y<3*seed k+1 := by
    suffices 2*(6561*checkpoint.at k+6433)<8192*(3*seed k+1) by omega
    simp only [checkpoint,seed,row,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have odd : Y%2=1 := by rw [←A2Header.physical_endpoint word.physical]; exact step_odd _
  have residue := congrArg (fun x : Nat => x%3) book
  change (8192*Y)%3=(6561*checkpoint.at k+6433)%3 at residue
  rw [Nat.mul_mod 8192 Y 3,Nat.add_mod,Nat.mul_mod 6561 (checkpoint.at k) 3] at residue
  simp only [show 8192%3=2 by decide,show 6561%3=0 by decide,
    show 6433%3=1 by decide,Nat.zero_mul,Nat.zero_mod,Nat.zero_add,Nat.mod_mod] at residue
  have y3 := Nat.mod_lt Y (by decide : 0<3)
  exact cheapOne (compose (history k).2.1 word) odd (by clear book; omega) price

/-- Two ones suffice for the alternative source of (1^7,2,5). -/
theorem sevenOnesTwoFive {k Y : Nat} (word : Segment (checkpoint.at k) Y 9 14 19427) :
    PaidMeeting (seed k) := by
  have book := word.book
  change 16384*Y=19683*checkpoint.at k+19427 at book
  have price : 4*(Y+1)<9*(seed k+1) := by
    suffices 4*(19683*checkpoint.at k+19427+16384)<16384*(9*(seed k+1)) by omega
    simp only [checkpoint,seed,row,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have odd : Y%2=1 := by rw [←A2Header.physical_endpoint word.physical]; exact step_odd _
  have residue := congrArg (fun x : Nat => x%9) book
  change (16384*Y)%9=(19683*checkpoint.at k+19427)%9 at residue
  rw [Nat.mul_mod 16384 Y 9,Nat.add_mod,Nat.mul_mod 19683 (checkpoint.at k) 9] at residue
  simp only [show 16384%9=4 by decide,show 19683%9=0 by decide,
    show 19427%9=5 by decide,Nat.zero_mul,Nat.zero_mod,Nat.zero_add,Nat.mod_mod] at residue
  have bound := Nat.mod_lt Y (by decide : 0<9)
  have mod9 : Y%9=8 := by clear book; omega
  clear book residue bound
  let q := (Y+1)/18
  have factor : Y+1=2*3^2*q := by unfold q; omega
  have positive : 0<q := by omega
  exact Front4bE1.terminalOnesPaid (h:=2) (compose (history k).2.1 word)
    positive factor price

/-- A strong return after the physical (1,2) landing descends directly. -/
theorem afterOneTwoStrong {k X Y a : Nat} (word : Segment (checkpoint.at k) X 2 3 5)
    (edge : Segment X Y 1 a 1) (strong : 3≤a) : Descended (seed k) := by
  have book := word.book
  change 8*X=9*checkpoint.at k+5 at book
  have price : 3*X+1<8*seed k := by
    suffices 27*checkpoint.at k+23<64*seed k by omega
    simp only [checkpoint,seed,row,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  exact descentOfEdge (compose (history k).2.1 word) edge
    (Nat.pow_le_pow_right (by decide) strong) price

/-- The (1,2,2) case crosses the newer checkpoint U. The certificate
uses the same N, but the lower ambient pivot is measured from U, not T62. -/
theorem oneTwoTwoCrossing {k Y : Nat} (word : Segment (checkpoint.at k) Y 3 5 23) :
    seed k<Y ∧ Y<checkpoint.at k ∧
      A2FirstCrossingFusion.FirstCrossing (seed k) (checkpoint.at k) Y 78 123 prefixCost 3 5 23 := by
  have book := word.book
  change 32*Y=27*checkpoint.at k+23 at book
  have prices : 32*seed k<27*checkpoint.at k+23 ∧ 5<checkpoint.at k := by
    simp only [checkpoint,seed,row,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have margin : seed k<Y ∧ Y<checkpoint.at k := by omega
  have odd := (affine_admissible (f:=checkpoint) (by decide) k).2
  have hit : A2FirstCrossingFusion.HitsBelow (checkpoint.at k) (checkpoint.at k) 3 :=
    ⟨3,by decide,by rw [A2Header.physical_endpoint word.physical]; exact margin.2⟩
  exact ⟨margin.1,margin.2,A2FirstCrossingFusion.reduce_first_crossing (heights k).1 odd
    (heights k).2.2.1 (history k).2.1 word hit⟩

end CollatzCharacterBridge.Front4bShortR2Three

#print axioms CollatzCharacterBridge.Front4bShortR2Three.history
#print axioms CollatzCharacterBridge.Front4bShortR2Three.immediateStrong
#print axioms CollatzCharacterBridge.Front4bShortR2Three.halfPaidOrWeak
#print axioms CollatzCharacterBridge.Front4bShortR2Three.afterOneTwoLanding
#print axioms CollatzCharacterBridge.Front4bShortR2Three.threeOnesTwoThree
#print axioms CollatzCharacterBridge.Front4bShortR2Three.fourOnesTwoFourCrossing
#print axioms CollatzCharacterBridge.Front4bShortR2Three.sixOnesTwoFive
#print axioms CollatzCharacterBridge.Front4bShortR2Three.sevenOnesTwoFive
#print axioms CollatzCharacterBridge.Front4bShortR2Three.afterOneTwoStrong
#print axioms CollatzCharacterBridge.Front4bShortR2Three.oneTwoTwoCrossing
