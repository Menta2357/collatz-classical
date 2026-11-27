import Front4bExitFour

namespace CollatzCharacterBridge.Front4bOneTwoRenewal

open StagedCylinder (Segment compose)
open A2CertifiedLanding (Descended)
open A2FirstCrossingFusion (Paid)
open Front4bExitFour (maxTwosExit ShortTwoRun)
open TwosCompression (Twos)
open Front4bRowEven (originalSeed originalCost originalSeedFormula)
open Front4bE1 (entry5 entry5History)
open Front4bGuardRun (entry3 entry3History)
open P5CompensationMeetings (Affine)

set_option maxRecDepth 14000
set_option maxHeartbeats 1400000

private theorem edge {U V a : Nat} (positive : 0<U) (odd : U%2=1)
    (next : V=step U) (count : 0<a) (real : 3*U+1=2^a*V) :
    Segment U V 1 a 1 :=
  ⟨A2Header.Physical.edge positive odd (next ▸ step_pos _) (next ▸ step_odd _) count real,
    real.symm⟩

private theorem laterTwos {Y r : Nat} (run : Twos Y r) :
    ∀ i≤r, orbit Y r≤orbit Y i := by
  induction r with
  | zero =>
    intro i h
    have : i=0 := by omega
    subst i
    exact Nat.le_refl _
  | succ r ih =>
    intro i h
    by_cases last : i=r+1
    · rw [last]; exact Nat.le_refl _
    · have previous : Twos Y r := fun j hj => run j (by omega)
      have next := run r (by omega)
      have order : orbit Y (r+1)≤orbit Y r := by omega
      exact Nat.le_trans order (ih previous _ (by omega))

/-- The exact cost of the first 1,2,2 gives strict height decrease.
An arbitrary surplus of real twos is non-increasing. -/
theorem heightDrop {U W r : Nat} (large : 5≤U)
    (one : 3*U+1=2*step U)
    (two : 3*step U+1=4*step (step U))
    (run : Twos (step (step U)) r) (nonempty : 0<r)
    (finish : orbit (step (step U)) r=W) :
    W<U := by
  have third := run 0 nonempty
  change 3*step (step U)+1=4*step (step (step U)) at third
  have discount : step (step (step U))<U := by omega
  have bound := laterTwos run 1 (by omega)
  rw [finish] at bound
  exact Nat.lt_of_le_of_lt bound discount

/-- A real prefix at which the 1 followed by at least two twos grammar
cannot produce another unpaid renewal. The starting 1 is admissible. -/
def ShortDetour (U : Nat) : Prop :=
  3*step U+1≠4*step (step U) ∨
    3*step (step U)+1=2*step (step (step U))

/-- Eliminate all continued renewals consisting of one 1 and at least
two twos. Strong exits in that grammar pay, and unpaid renewals have
strictly smaller height. The retained cut stores both exact histories. -/
theorem renewOrShort {N U j S B : Nat} (seed : 16≤N) (price : U<3*N)
    (phase : U%4=3) (history : Segment N U j S B) :
    Paid N ∨ ∃ V m d C, N≤V ∧ V≤U ∧ V%4=3 ∧ ShortDetour V ∧
      Segment U V m d C ∧ Segment N V (j+m) (S+d) (3^m*B+2^S*C) := by
  induction U using Nat.strongRecOn generalizing j S B with
  | ind U ih =>
    have up : 0<U := by omega
    have uo : U%2=1 := by omega
    by_cases lower : U<N
    · exact Or.inl (Or.inl ⟨U,j,S,B,up,uo,lower,history⟩)
    let X := step U
    let Y := step X
    have one : 3*U+1=2*X := by simpa only [X,Nat.mul_comm (step U) 2] using (step_mul_two phase).symm
    by_cases two : 3*X+1=4*Y
    · have first : Segment U X 1 1 1 := edge up uo rfl (by decide) one
      have second : Segment X Y 1 2 1 :=
        edge (step_pos _) (step_odd _) rfl (by decide) two
      have word : Segment U Y 2 3 5 := compose first second
      have orig := compose history word
      have large : 1<Y := by omega
      have quarter : Y<4*N+1 := by omega
      have spend : 3^5*(Y-1)<4^5*(N-1) := by omega
      rcases maxTwosExit orig large (step_odd _) quarter spend with paid|unpaid
      · exact Or.inl paid
      · obtain ⟨r,W,_,twos,_,exit,path,_⟩ := unpaid
        by_cases zero : r=0
        · subst r
          have same : W=Y := (A2Header.physical_endpoint path.physical).symm
          subst W
          refine Or.inr ⟨U,0,0,0,by omega,Nat.le_refl _,phase,Or.inr exit,?_,?_⟩
          · exact ⟨A2Header.Physical.refl _,by simp⟩
          · simpa using history
        · have realEnd : orbit Y r=W := A2Header.physical_endpoint path.physical
          have decrease : W<U := heightDrop (by omega) one two twos (by omega) realEnd
          have phaseW : W%4=3 := by have odd := step_odd W; omega
          have localPath := compose word path
          rcases ih W decrease (by omega) phaseW (compose history localPath) with
            paid|⟨V,m,d,C,safe,height,phaseV,short,tail,_⟩
          · exact Or.inl paid
          · have joined := compose localPath tail
            exact Or.inr ⟨V,_,_,_,safe,by omega,phaseV,short,joined,compose history joined⟩
    · refine Or.inr ⟨U,0,0,0,by omega,Nat.le_refl _,phase,Or.inl two,?_,?_⟩
      · exact ⟨A2Header.Physical.refl _,by simp⟩
      · simpa using history

private theorem twiceOne (U : Nat) (phase : U%4=3) : 3*U+1=2*step U := by
  simpa only [Nat.mul_comm (step U) 2] using (step_mul_two phase).symm

private theorem bookOneTwo {U X Y : Nat} (one : 3*U+1=2*X) (two : 3*X+1=4*Y) :
    8*Y=9*U+5 := by omega

private theorem bookOneTwoTwo {Y Z F V : Nat} (one : 3*Y+1=2*Z)
    (two : 3*Z+1=4*F) (another : 3*F+1=4*V) : 32*V=27*Y+23 := by omega

private theorem strictPairedBook {U V : Nat} (large : 25≤U)
    (book : 256*V=243*U+319) : V<U := by
  by_cases h : V<U
  · exact h
  · have floor := Nat.mul_le_mul_left 256 (show U≤V by omega)
    rw [book] at floor
    omega

private theorem pricedPair {U X Y Z F V : Nat} (large : 25≤U)
    (one : 3*U+1=2*X) (two : 3*X+1=4*Y) (again : 3*Y+1=2*Z)
    (second : 3*Z+1=4*F) (third : 3*F+1=4*V) :
    V<U := by
  have headBook := bookOneTwo one two
  have tailBook := bookOneTwoTwo again second third
  apply strictPairedBook large
  calc
    _ = 8*(32*V) := by rw [←Nat.mul_assoc]
    _ = 8*(27*Y+23) := congrArg (fun x => 8*x) tailBook
    _ = 27*(8*Y)+184 := by rw [Nat.mul_add,show 8*(27*Y)=27*(8*Y) by ac_rfl]
    _ = 27*(9*U+5)+184 := by rw [headBook]
    _ = _ := by rw [Nat.mul_add,←Nat.mul_assoc,Nat.add_assoc]

/-- The single-dose expansion can be amortized by the next renewal when
that renewal has two or more twos. The first five valuations are 1,2,1,2,2. -/
theorem isolatedSingleDrop {U W r : Nat} (large : 25≤U)
    (one : 3*U+1=2*step U)
    (two : 3*step U+1=4*orbit U 2)
    (again : 3*orbit U 2+1=2*orbit U 3)
    (second : 3*orbit U 3+1=4*orbit U 4)
    (run : Twos (orbit U 4) r) (nonempty : 0<r)
    (finish : orbit (orbit U 4) r=W) :
    W<U := by
  have third := run 0 nonempty
  change 3*orbit U 4+1=4*step (orbit U 4) at third
  have discount : step (orbit U 4)<U := pricedPair large one two again second third
  have bound := laterTwos run 1 (by omega)
  rw [finish] at bound
  exact Nat.lt_of_le_of_lt bound discount

/-- The actual first 1,2 detour remains untreated if its following
renewal does not begin 1,2 or if it too is a single-dose detour. -/
def PairedFrontier (U : Nat) : Prop :=
  3*step U+1≠4*orbit U 2 ∨
    (3*step U+1=4*orbit U 2 ∧ 3*orbit U 2+1=2*orbit U 3 ∧ ShortDetour (orbit U 2))

private theorem consumeSingle {N U j S B : Nat} (seed : 32≤N)
    (above : N≤U) (limit : U<3*N) (phase : U%4=3)
    (history : Segment N U j S B)
    (two : 3*step U+1=4*orbit U 2) (again : 3*orbit U 2+1=2*orbit U 3) :
    let Y := orbit U 2
    Paid N ∨ ShortDetour Y ∨ ∃ W r d C, W<U ∧ W%4=3 ∧ Segment U W r d C := by
  let X := step U
  let Y := orbit U 2
  let Z := orbit U 3
  let F := orbit U 4
  change Paid N ∨ ShortDetour Y ∨ ∃ W r d C, W<U ∧ W%4=3 ∧ Segment U W r d C
  by_cases second : 3*Z+1=4*F
  · have startOne := twiceOne U phase
    have p₁ : Segment U X 1 1 1 := edge (by omega) (by omega) rfl (by decide) startOne
    have p₂ : Segment X Y 1 2 1 := edge (step_pos _) (step_odd _) rfl (by decide) two
    have p₃ : Segment Y Z 1 1 1 := edge (step_pos _) (step_odd _) rfl (by decide) again
    have p₄ : Segment Z F 1 2 1 := edge (step_pos _) (step_odd _) rfl (by decide) second
    have block : Segment U F 4 6 85 := compose (compose p₁ p₂) (compose p₃ p₄)
    have full := compose history block
    have balance : 64*F=81*U+85 := block.book
    have large : 1<F := by omega
    have quarter : F<4*N+1 := by omega
    have spend : 3^5*(F-1)<4^5*(N-1) := by omega
    rcases maxTwosExit full large (step_odd _) quarter spend with paid|unpaid
    · exact Or.inl paid
    · obtain ⟨r,W,_,twos,_,exit,path,_⟩ := unpaid
      by_cases empty : r=0
      · subst r
        have same : W=F := (A2Header.physical_endpoint path.physical).symm
        subst W
        exact Or.inr (Or.inl (Or.inr exit))
      · have last := A2Header.physical_endpoint path.physical
        have below : W<U := isolatedSingleDrop (by omega) startOne two again second twos (by omega) last
        have phaseW : W%4=3 := by have odd := step_odd W; omega
        exact Or.inr (Or.inr ⟨W,_,_,_,below,phaseW,compose block path⟩)
  · exact Or.inr (Or.inl (Or.inl second))

/-- Pay or leave a precise frontier after arbitrarily mixing contracting
renewals and single-dose expansions that are followed by a contraction.
The well-founded rank is actual height at the renewal cuts. -/
theorem renewIncludingIsolated {N U j S B : Nat} (seed : 32≤N) (price : U<3*N)
    (phase : U%4=3) (history : Segment N U j S B) :
    Paid N ∨ ∃ V m d C, N≤V ∧ V≤U ∧ V%4=3 ∧ PairedFrontier V ∧
      Segment U V m d C ∧ Segment N V (j+m) (S+d) (3^m*B+2^S*C) := by
  induction U using Nat.strongRecOn generalizing j S B with
  | ind U ih =>
    rcases renewOrShort (by omega) price phase history with
      paid|⟨V,m,d,C,above,below,phaseV,frontier,segment,past⟩
    · exact Or.inl paid
    · rcases frontier with noTwo|again
      · exact Or.inr ⟨V,m,d,C,above,below,phaseV,Or.inl noTwo,segment,past⟩
      · by_cases two : 3*step V+1=4*orbit V 2
        · have one : 3*orbit V 2+1=2*orbit V 3 := again
          rcases consumeSingle seed above (by omega) phaseV past two one with
            paid|left|⟨W,r,e,D,drop,phaseW,more⟩
          · exact Or.inl paid
          · exact Or.inr ⟨V,m,d,C,above,below,phaseV,Or.inr ⟨two,one,left⟩,segment,past⟩
          · have joined := compose segment more
            rcases ih W (by omega) (by omega) phaseW (compose history joined) with
              paid|⟨Z,k,l,F,up,down,phaseZ,stop,next,_⟩
            · exact Or.inl paid
            · have full := compose joined next
              exact Or.inr ⟨Z,_,_,_,up,by omega,phaseZ,stop,full,compose history full⟩
        · exact Or.inr ⟨V,m,d,C,above,below,phaseV,Or.inl two,segment,past⟩

private theorem fourthBook {J X Y : Nat}
    (head : Segment J X 10 13 84217) (four : Segment X Y 1 4 1) :
    Segment J Y 11 17 260843 := by
  simpa only [Nat.pow_one,Nat.mul_one] using compose head four

private theorem seedSize (u : Nat) : 32≤originalSeed u := by
  rw [originalSeedFormula]
  omega

private theorem beforeOne {N J X Y U W r j S B : Nat} (entryBound : 8*J≤17*N)
    (history : Segment N J j S B) (head : Segment J X 10 13 84217)
    (four : Segment X Y 1 4 1) (twos : Segment Y U r (2*r) (4^r-3^r))
    (one : Segment U W 1 1 1) :
    U<3*N ∧ U%4=3 ∧ Segment N U ((j+11)+r) ((S+17)+2*r)
      (3^r*(177147*B+2^S*260843)+2^(S+17)*(4^r-3^r)) := by
  have startWord := fourthBook head four
  have equation : 131072*Y=177147*J+260843 := startWord.book
  have pay : Y<3*N := by omega
  have yp : 0<Y := (A2Header.physical_endpoint four.physical) ▸ step_pos X
  have p : (3:Nat)^r≤4^r := Nat.pow_le_pow_left (by decide) r
  have led := twos.book
  rw [TwosCompression.power_conversion] at led
  have bound : 4^r*U≤4^r*Y := calc
    _ = 3^r*Y+(4^r-3^r) := led
    _ ≤ 3^r*Y+(4^r-3^r)*Y := by
      have q := Nat.mul_le_mul_left (4^r-3^r) yp
      rw [Nat.mul_one] at q
      omega
    _ = _ := by rw [←Nat.add_mul,Nat.add_sub_of_le p]
  have hU := Nat.le_of_mul_le_mul_left bound (Nat.pow_pos (by decide))
  have last : 2*W=3*U+1 := one.book
  have odd : W%2=1 := (A2Header.physical_endpoint one.physical) ▸ step_odd U
  exact ⟨by omega,by omega,compose (compose history startWord) twos⟩

/-- A same-N consumer for any actual r twos and a subsequent real one
in E1 row 3. In particular it applies to the three short classes. -/
theorem rowThree {t X Y U W r : Nat}
    (head : Segment (entry3.at t) X 10 13 84217) (four : Segment X Y 1 4 1)
    (twos : Segment Y U r (2*r) (4^r-3^r)) (one : Segment U W 1 1 1) :
    let N := originalSeed (18+32*t)
    Paid N ∨ ∃ V m d C, N≤V ∧ V≤U ∧ V%4=3 ∧ PairedFrontier V ∧
      Segment U V m d C ∧ Segment N V (76+r+m) (119+2*r+d)
        (3^m*(3^r*(177147*originalCost 3 19+2^102*260843)+2^119*(4^r-3^r))+
          2^(119+2*r)*C) := by
  let N := originalSeed (18+32*t)
  have limit : 8*entry3.at t≤17*N := by
    simp only [N,entry3,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have large := seedSize (18+32*t)
  obtain ⟨height,phase,history⟩ := beforeOne limit (entry3History t).1 head four twos one
  exact renewIncludingIsolated large height phase history

/-- The same consumer in E1 row 5, including both remaining short classes. -/
theorem rowFive {t X Y U W r : Nat}
    (head : Segment (entry5.at t) X 10 13 84217) (four : Segment X Y 1 4 1)
    (twos : Segment Y U r (2*r) (4^r-3^r)) (one : Segment U W 1 1 1) :
    let N := originalSeed (10+128*t)
    Paid N ∨ ∃ V m d C, N≤V ∧ V≤U ∧ V%4=3 ∧ PairedFrontier V ∧
      Segment U V m d C ∧ Segment N V (77+r+m) (121+2*r+d)
        (3^m*(3^r*(177147*originalCost 4 73+2^104*260843)+2^121*(4^r-3^r))+
          2^(121+2*r)*C) := by
  let N := originalSeed (10+128*t)
  have limit : 8*entry5.at t≤17*N := by
    simp only [N,entry5,Affine.at,originalSeedFormula,Nat.mul_add,←Nat.mul_assoc]
    omega
  have large := seedSize (10+128*t)
  obtain ⟨height,phase,history⟩ := beforeOne limit (entry5History t).1 head four twos one
  exact renewIncludingIsolated large height phase history

end CollatzCharacterBridge.Front4bOneTwoRenewal

#print axioms CollatzCharacterBridge.Front4bOneTwoRenewal.heightDrop
#print axioms CollatzCharacterBridge.Front4bOneTwoRenewal.isolatedSingleDrop
#print axioms CollatzCharacterBridge.Front4bOneTwoRenewal.renewIncludingIsolated
#print axioms CollatzCharacterBridge.Front4bOneTwoRenewal.renewOrShort
#print axioms CollatzCharacterBridge.Front4bOneTwoRenewal.rowThree
#print axioms CollatzCharacterBridge.Front4bOneTwoRenewal.rowFive
