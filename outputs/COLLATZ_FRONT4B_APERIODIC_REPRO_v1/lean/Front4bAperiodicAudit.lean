import Front4bPeriodicWeakRepeat

namespace CollatzCharacterBridge.Front4bAperiodicAudit

open StagedCylinder (Segment compose)
open Front4bPeriodicWeakRepeat
  (Follows periodReturns periodDivisions periodCost composePeriod
   periodicPhysicalRepeat historyCost)

set_option maxRecDepth 14000
set_option maxHeartbeats 1600000

inductive Mode where
  | solo
  | switched
  deriving DecidableEq

def word : Mode → List (Nat × Nat)
  | .solo => [(2,2)]
  | .switched => [(2,1),(3,2)]

def gain : Mode → Nat
  | .solo => 1
  | .switched => 3

def reserveBits : Mode → Nat
  | .solo => 5
  | .switched => 15

abbrev Step (a : Mode) (x y : Nat) : Prop := Follows x y (word a)
abbrev oddClock (a : Mode) : Nat := periodReturns (word a)
abbrev shortcutClock (a : Mode) : Nat := periodDivisions (word a)
abbrev additive (a : Mode) : Nat := periodCost (word a)

def charge (a : Mode) (x : Nat) : Nat :=
  Front4bPeriodicWeakRepeat.reserve (oddClock a) (shortcutClock a) (additive a) x

/-- The two macros force distinct current residues in the physical J
coordinate. Both residues represent a current run of exactly two ones. -/
theorem modeResidue {a : Mode} {x y : Nat} (step : Step a x y) :
    x%64=match a with | .solo => 7 | .switched => 39 := by
  have book := (composePeriod step).1.book
  cases a with
  | solo =>
    change 64*y=81*x+73 at book
    change x%64=7
    have eq : 64*(49*y)=64*(62*x+55)+x+57 := by omega
    omega
  | switched =>
    change 4096*y=19683*x+25003 at book
    change x%64=39
    have eq : 64*(704*y)=64*(3383*x+4297)+x+25 := by omega
    omega

/-- When the next macro changes, the old affine charge has exactly five
factors of two. The longer macro has a different charge from either of
its individual weak episodes. -/
theorem chargeAtSwitch {a b : Mode} {x y : Nat} (changeMode : a≠b) (step : Step b x y) :
    ∃ u, u%2=1 ∧ charge a x=2^5*u := by
  have residue := modeResidue step
  have rem : charge a x%64=32 := by
    cases a <;> cases b
    · exact False.elim (changeMode rfl)
    · change x%64=39 at residue
      change (17*x+73)%64=32
      omega
    · change x%64=7 at residue
      change (15587*x+25003)%64=32
      omega
    · exact False.elim (changeMode rfl)
  exact ⟨charge a x/32,by omega,by omega⟩

private theorem stripOddScale {a x d u : Nat} (odd : a%2=1) (uOdd : u%2=1)
    (eq : a*x=2^d*u) : ∃ v, v%2=1 ∧ x=2^d*v := by
  induction d generalizing x with
  | zero =>
    refine ⟨x,?_,by simp⟩
    have parity := congrArg (fun t : Nat => t%2) eq
    change (a*x)%2=(2^0*u)%2 at parity
    simpa [Nat.mul_mod,odd,uOdd] using parity
  | succ d ih =>
    rw [Nat.pow_succ,show (2:Nat)^d*2*u=2*(2^d*u) by ac_rfl] at eq
    have parity := congrArg (fun t : Nat => t%2) eq
    change (a*x)%2=(2*(2^d*u))%2 at parity
    have even : x%2=0 := by simpa [Nat.mul_mod,odd] using parity
    have half : x=2*(x/2) := by omega
    have step : a*(x/2)=2^d*u := by
      apply Nat.eq_of_mul_eq_mul_left (by decide : 0<2)
      calc
        2*(a*(x/2))=a*(2*(x/2)) := by ac_rfl
        _=a*x := by rw [←half]
        _=2*(2^d*u) := eq
    obtain ⟨v,vo,hv⟩ := ih step
    refine ⟨v,vo,?_⟩
    calc
      x=2*(x/2) := half
      _=2*(2^d*v) := by rw [hv]
      _=2^(d+1)*v := by rw [Nat.pow_succ]; ac_rfl

/-- Each repeated macro uses its exact shortcut clock in the dyadic
charge. An observed subsequent switch fixes the terminal remainder. -/
theorem chargeOfCompletedRun {a b : Mode} (changeMode : a≠b) (J : Nat → Nat)
    {n : Nat} (copies : ∀ i<n, Step a (J i) (J (i+1)))
    (next : Step b (J n) (J (n+1))) :
    ∃ u, u%2=1 ∧ charge a (J 0)=2^(shortcutClock a*n+5)*u := by
  induction n generalizing J with
  | zero =>
    simpa only [Nat.mul_zero,Nat.zero_add] using chargeAtSwitch changeMode next
  | succ n ih =>
    obtain ⟨u,uo,rest⟩ := ih (fun i => J (i+1))
      (fun i hi => copies (i+1) (by omega)) next
    have book := composePeriod (copies 0 (by omega))
    have h := Front4bPeriodicWeakRepeat.reserveStep book.2 book.1
    change 2^shortcutClock a*charge a (J 1)=3^oddClock a*charge a (J 0) at h
    change charge a (J 1)=2^(shortcutClock a*n+5)*u at rest
    rw [rest,←Nat.mul_assoc,←Nat.pow_add] at h
    have pow : (3:Nat)^oddClock a%2=1 := by cases a <;> decide
    rw [show shortcutClock a+(shortcutClock a*n+5)=shortcutClock a*(n+1)+5 by
      rw [Nat.mul_succ]; omega] at h
    exact stripOddScale pow uo h.symm

private theorem advances {a : Mode} {x y : Nat} (high : 7≤x) (step : Step a x y) :
    x≤y ∧ y≤2^gain a*x := by
  have balance := (composePeriod step).1.book
  cases a with
  | solo =>
    change 64*y=81*x+73 at balance
    change x≤y ∧ y≤2*x
    omega
  | switched =>
    change 4096*y=19683*x+25003 at balance
    change x≤y ∧ y≤8*x
    omega

private theorem chargeEnvelope (a : Mode) {x : Nat} (high : 7≤x) :
    charge a x≤2^reserveBits a*x := by
  cases a with
  | solo => change 17*x+73≤32*x; omega
  | switched => change 15587*x+25003≤32768*x; omega

structure Ledger where
  odd : Nat
  shortcut : Nat
  cost : Nat
  growth : Nat

/-- Fold the actual prefix in renewal order, preserving the additive and
starting from the original absolute clocks. -/
def ledger (labels : Nat → Mode) (j S C : Nat) : Nat → Ledger
  | 0 => ⟨j,S,C,0⟩
  | k+1 =>
    let before := ledger labels j S C k
    let a := labels k
    ⟨before.odd+oddClock a,before.shortcut+shortcutClock a,
      3^oddClock a*before.cost+2^before.shortcut*additive a,
      before.growth+gain a⟩

theorem prefixBound {N j S C k : Nat} (labels : Nat → Mode) (J : Nat → Nat)
    (origin : Segment N (J 0) j S C) (high : 7≤J 0)
    (prefixSteps : ∀ i<k, Step (labels i) (J i) (J (i+1))) :
    let L := ledger labels j S C k
    Segment N (J k) L.odd L.shortcut L.cost ∧
      7≤J k ∧ J k≤2^L.growth*J 0 := by
  induction k with
  | zero => exact ⟨origin,high,by simp [ledger]⟩
  | succ k ih =>
    obtain ⟨start,lo,upper⟩ := ih (fun i hi => prefixSteps i (by omega))
    have step := prefixSteps k (by omega)
    obtain ⟨inc,cap⟩ := advances lo step
    refine ⟨compose start (composePeriod step).1,by omega,?_⟩
    change J (k+1)≤2^((ledger labels j S C k).growth+gain (labels k))*J 0
    calc
      _≤2^gain (labels k)*J k := cap
      _≤2^gain (labels k)*(2^(ledger labels j S C k).growth*J 0) :=
        Nat.mul_le_mul_left _ upper
      _=_ := by rw [Nat.pow_add]; ac_rfl

/-- An arbitrarily switched prefix can pay for only a limited number of
copies of the next homogeneous macro before its completed switch. -/
theorem completedRunBound {N j S C k n H : Nat} {a b : Mode} (labels : Nat → Mode)
    (J : Nat → Nat) (origin : Segment N (J 0) j S C)
    (high : 7≤J 0) (height : J 0<2^H)
    (prefixSteps : ∀ i<k, Step (labels i) (J i) (J (i+1)))
    (copies : ∀ i<n, Step a (J (k+i)) (J (k+i+1)))
    (switch : a≠b) (next : Step b (J (k+n)) (J (k+n+1))) :
    let L := ledger labels j S C k
    shortcutClock a*n+5<H+L.growth+reserveBits a ∧
      Segment N (J (k+n)) (L.odd+oddClock a*n) (L.shortcut+shortcutClock a*n)
        (historyCost (oddClock a) (shortcutClock a) (additive a) L.shortcut L.cost n) := by
  obtain ⟨book,lo,upper⟩ := prefixBound labels J origin high prefixSteps
  have starts : k+0=k := Nat.add_zero k
  have inputs (i : Nat) (hi : i<n) :
      Step a ((fun x => J (k+x)) i) ((fun x => J (k+x)) (i+1)) := by
    simpa only [←Nat.add_assoc] using copies i hi
  have next' : Step b ((fun x => J (k+x)) n) ((fun x => J (k+x)) (n+1)) := by
    simpa only [←Nat.add_assoc] using next
  obtain ⟨u,uo,exactCharge⟩ := chargeOfCompletedRun switch (fun x => J (k+x)) inputs next'
  rw [starts] at exactCharge
  have atLeast : (2:Nat)^(shortcutClock a*n+5)≤charge a (J k) := by
    rw [exactCharge]
    simpa only [Nat.mul_one] using Nat.mul_le_mul_left (2^(shortcutClock a*n+5))
      (show 1≤u by omega)
  let L := ledger labels j S C k
  have sharp : (2:Nat)^(shortcutClock a*n+5)<2^(H+L.growth+reserveBits a) := by
    calc
      _≤charge a (J k) := atLeast
      _≤2^reserveBits a*J k := chargeEnvelope a lo
      _≤(2^reserveBits a*2^L.growth)*J 0 := by
        rw [Nat.mul_assoc]
        exact Nat.mul_le_mul_left _ upper
      _<(2^reserveBits a*2^L.growth)*2^H :=
        Nat.mul_lt_mul_of_pos_left height (Nat.mul_pos (Nat.pow_pos (by decide)) (Nat.pow_pos (by decide)))
      _=_ := by rw [Nat.pow_add 2 (H+L.growth) (reserveBits a),Nat.pow_add 2 H L.growth]; ac_rfl
  have anchored : Segment N ((fun x => J (k+x)) 0) L.odd L.shortcut L.cost := by
    simpa only [Nat.add_zero] using book
  have wordPositive : word a≠[] := by cases a <;> decide
  have full := (periodicPhysicalRepeat wordPositive (fun x => J (k+x)) anchored inputs).2.2
  exact ⟨(Nat.pow_lt_pow_iff_right (by decide : (1:Nat)<2)).1 sharp,full⟩

/-- An infinite itinerary cannot have completed runs whose bit use
exceeds the preceding weighted bit growth by an unbounded amount. -/
theorem noUnboundedExcess {N j S C H : Nat} (labels : Nat → Mode) (J : Nat → Nat)
    (origin : Segment N (J 0) j S C)
    (high : 7≤J 0) (height : J 0<2^H)
    (walk : ∀ i, Step (labels i) (J i) (J (i+1)))
    (overflow : ∀ R, ∃ k n a b, a≠b ∧
      (∀ i<n, labels (k+i)=a) ∧ labels (k+n)=b ∧
      (ledger labels j S C k).growth+R≤shortcutClock a*n) : False := by
  obtain ⟨k,n,a,b,different,run,ending,large⟩ := overflow (H+15)
  have copies (i : Nat) (hi : i<n) : Step a (J (k+i)) (J (k+i+1)) := by
    simpa only [run i hi] using walk (k+i)
  have next : Step b (J (k+n)) (J (k+n+1)) := by
    simpa only [ending] using walk (k+n)
  have bound := (completedRunBound labels J origin high height
    (fun i _ => walk i) copies different next).1
  have cap : reserveBits a≤15 := by cases a <;> decide
  omega

private theorem growthCeiling (labels : Nat → Mode) (j S C k : Nat) :
    (ledger labels j S C k).growth≤3*k := by
  induction k with
  | zero => simp [ledger]
  | succ k ih =>
    have spend : gain (labels k)≤3 := by cases labels k <;> decide
    simp only [ledger,Nat.mul_succ]
    omega

/-- A convenient purely combinatorial sufficient condition for the
exclusion. The earlier letters can switch arbitrarily. -/
theorem noOverlongCompletedRuns {N j S C H : Nat} (labels : Nat → Mode) (J : Nat → Nat)
    (origin : Segment N (J 0) j S C)
    (high : 7≤J 0) (height : J 0<2^H)
    (walk : ∀ i, Step (labels i) (J i) (J (i+1)))
    (runs : ∀ R, ∃ k n a b, a≠b ∧
      (∀ i<n, labels (k+i)=a) ∧ labels (k+n)=b ∧ k+R≤2*n) : False := by
  apply noUnboundedExcess labels J origin high height walk
  intro R
  obtain ⟨k,n,a,b,switch,block,ending,large⟩ := runs R
  have needed : 6≤shortcutClock a := by cases a <;> decide
  have least := Nat.mul_le_mul_right n needed
  have prior := growthCeiling labels j S C k
  exact ⟨k,n,a,b,switch,block,ending,by omega⟩

/-- The affine shift in the physical checkpoint cannot be chosen once
for both exact homogeneous laws. The positive linear slope is essential. -/
theorem noCommonAffineCharge {s c x y z w : Nat} (positive : 0<s)
    (solo : Step .solo x y) (switched : Step .switched z w)
    (first : 64*(s*y+c)=81*(s*x+c))
    (second : 4096*(s*w+c)=19683*(s*z+c)) : False := by
  have left := (composePeriod solo).1.book
  have right := (composePeriod switched).1.book
  change 64*y=81*x+73 at left
  change 4096*w=19683*z+25003 at right
  have firstScaled : 64*(s*y)=81*(s*x)+73*s := by
    calc
      _=s*(64*y) := by ac_rfl
      _=s*(81*x+73) := congrArg (fun n : Nat => s*n) left
      _=_ := by rw [Nat.mul_add]; ac_rfl
  have secondScaled : 4096*(s*w)=19683*(s*z)+25003*s := by
    calc
      _=s*(4096*w) := by ac_rfl
      _=s*(19683*z+25003) := congrArg (fun n : Nat => s*n) right
      _=_ := by rw [Nat.mul_add]; ac_rfl
  simp only [Nat.mul_add,firstScaled,secondScaled,Nat.add_assoc] at first second
  have a := Nat.add_left_cancel first
  have b := Nat.add_left_cancel second
  rw [show (81:Nat)=17+64 by decide,Nat.add_mul] at a
  rw [show (19683:Nat)=15587+4096 by decide,Nat.add_mul] at b
  have a' := Nat.add_right_cancel a
  have b' := Nat.add_right_cancel b
  have equal : (73*15587)*s=(25003*17)*s := by
    calc
      _=15587*(73*s) := by ac_rfl
      _=15587*(17*c) := by rw [a']
      _=17*(15587*c) := by ac_rfl
      _=17*(25003*s) := by rw [←b']
      _=_ := by ac_rfl
  exact (by decide : (73*15587:Nat)≠25003*17) (Nat.eq_of_mul_eq_mul_right positive equal)

end CollatzCharacterBridge.Front4bAperiodicAudit

#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.modeResidue
#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.chargeAtSwitch
#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.chargeOfCompletedRun
#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.prefixBound
#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.completedRunBound
#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.noUnboundedExcess
#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.noOverlongCompletedRuns
#print axioms CollatzCharacterBridge.Front4bAperiodicAudit.noCommonAffineCharge
