import TerrasClock
import A2FirstCrossingFusion

namespace CollatzCharacterBridge.A2ShortcutClock

open A2Header (Physical)
open StagedCylinder (Segment)

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

private theorem halvePower (e y : Nat) :
    TerrasClock.shortcut (2^(e+1)*y)=2^e*y := by
  have scale : 2^(e+1)*y=2*(2^e*y) := by rw [Nat.pow_succ]; ac_rfl
  have parity : (2^(e+1)*y)%2=0 := by rw [scale]; omega
  have half := TerrasClock.shortcut_even parity
  rw [scale] at half ⊢
  omega

private theorem stripAt (e y i : Nat) (inside : i≤e) :
    TerrasClock.orbit (2^e*y) i=2^(e-i)*y := by
  induction i generalizing e with
  | zero => simp [TerrasClock.orbit]
  | succ i ih =>
    rw [TerrasClock.orbit_succ,ih e (by omega),
      show e-i=(e-(i+1))+1 by omega,halvePower]

private theorem stripEven (e y i : Nat) (inside : i<e) :
    TerrasClock.orbit (2^e*y) i%2=0 := by
  rw [stripAt e y i (Nat.le_of_lt inside),show e-i=(e-i-1)+1 by omega]
  have scale : 2^(e-i-1+1)*y=2*(2^(e-i-1)*y) := by rw [Nat.pow_succ]; ac_rfl
  rw [scale]
  omega

private theorem evenBook {x t : Nat} (even : ∀ i<t, TerrasClock.orbit x i%2=0) :
    TerrasClock.oddCount x t=0 ∧ TerrasClock.additive x t=0 := by
  induction t with
  | zero => exact ⟨rfl,rfl⟩
  | succ t ih =>
    have earlier := ih (fun i hi => even i (by omega))
    have parity := even t (Nat.lt_succ_self t)
    have no : ¬TerrasClock.orbit x t%2=1 := by omega
    simpa only [TerrasClock.oddCount,TerrasClock.additive,if_neg no,Nat.add_zero] using earlier

private theorem edgeShortcut {x y a : Nat} (odd : x%2=1) (positive : 0<a)
    (factor : 3*x+1=2^a*y) :
    TerrasClock.orbit x a=y ∧ TerrasClock.oddCount x a=1 := by
  cases a with
  | zero => omega
  | succ e =>
    have half : TerrasClock.orbit x 1=2^e*y := by
      have scale : 2^(e+1)*y=2*(2^e*y) := by rw [Nat.pow_succ]; ac_rfl
      have step := TerrasClock.shortcut_odd odd
      rw [factor,scale] at step
      change TerrasClock.shortcut x=2^e*y
      omega
    have zeros := evenBook (stripEven e y)
    rw [show e+1=1+e by omega,TerrasClock.orbit_add,TerrasClock.oddCount_add,half,zeros.1]
    have joined := stripAt e y e (Nat.le_refl _)
    simpa [TerrasClock.oddCount,TerrasClock.orbit,odd] using joined

/-- Replay a sealed odd history on the actual shortcut clock. -/
theorem physicalShortcut {x y j S : Nat} (history : Physical x j S y) :
    TerrasClock.orbit x S=y ∧ TerrasClock.oddCount x S=j := by
  induction history with
  | refl _ => exact ⟨rfl,rfl⟩
  | edge _ odd _ _ positive factor => exact edgeShortcut odd positive factor
  | append _ _ first second =>
    rw [TerrasClock.orbit_add,TerrasClock.oddCount_add,first.1,first.2,second.1,second.2]
    exact ⟨rfl,rfl⟩

/-- The additive of a physical segment is exactly the shortcut additive
at its own clock. -/
theorem segmentShortcut {x y j S B : Nat} (history : Segment x y j S B) :
    TerrasClock.orbit x S=y ∧ TerrasClock.oddCount x S=j ∧
      TerrasClock.additive x S=B := by
  obtain ⟨endpoint,count⟩ := physicalShortcut history.physical
  have affine := TerrasClock.exact_book x S
  rw [endpoint,count,history.book] at affine
  exact ⟨endpoint,count,by omega⟩

private theorem oddPath (x j : Nat) (odd : x%2=1) :
    ∃ S, Physical x j S (orbit x j) := by
  induction j with
  | zero => exact ⟨0,Physical.refl x⟩
  | succ j ih =>
    obtain ⟨S,path⟩ := ih
    have atOdd := orbit_odd x odd j
    obtain ⟨a,positive,factor⟩ := P5R3S5.actual_step_factor (orbit x j) atOdd
    have tail := P5R3S5.step_segment (orbit x j) a (orbit_pos x (by omega) j) atOdd positive factor
    exact ⟨S+a,Physical.append path tail.physical⟩

private theorem shortcutPositive {x : Nat} (positive : 0<x) : 0<TerrasClock.shortcut x := by
  rcases Nat.mod_two_eq_zero_or_one x with even | odd
  · have h := TerrasClock.shortcut_even even
    omega
  · have h := TerrasClock.shortcut_odd odd
    omega

private theorem shortcutOrbitPositive {x : Nat} (positive : 0<x) (t : Nat) :
    0<TerrasClock.orbit x t := by
  induction t with
  | zero => exact positive
  | succ t ih => exact shortcutPositive ih

private theorem oddCount_mono (x : Nat) {p q : Nat} (le : p≤q) :
    TerrasClock.oddCount x p≤TerrasClock.oddCount x q := by
  have count := TerrasClock.oddCount_add x p (q-p)
  rw [show p+(q-p)=q by omega] at count
  omega

private theorem oddCount_strict {x p q : Nat} (early : p<q)
    (odd : TerrasClock.orbit x p%2=1) :
    TerrasClock.oddCount x p<TerrasClock.oddCount x q := by
  have count := oddCount_mono x (show p+1≤q by omega)
  rw [show TerrasClock.oddCount x (p+1)=TerrasClock.oddCount x p+1 by
    simp only [TerrasClock.oddCount,if_pos odd]] at count
  omega

private theorem oddClockUnique {x p q : Nat} (atP : TerrasClock.orbit x p%2=1)
    (atQ : TerrasClock.orbit x q%2=1)
    (same : TerrasClock.oddCount x p=TerrasClock.oddCount x q) : p=q := by
  rcases Nat.lt_trichotomy p q with early | eq | late
  · exact (Nat.ne_of_lt (oddCount_strict early atP) same).elim
  · exact eq
  · exact (Nat.ne_of_lt (oddCount_strict late atQ) same.symm).elim

abbrev landing (V q : Nat) : Nat := orbit V (TerrasClock.oddCount V q)

/-- The extra shortcut steps form one even strip. Their only effect on the
book is to increase the shortcut time by the strip length. -/
structure OddCompletion (V q e : Nat) : Prop where
  endpoint : TerrasClock.orbit V (q+e)=landing V q
  factor : TerrasClock.orbit V q=2^e*landing V q
  evenStrip : ∀ i<e, TerrasClock.orbit V (q+i)%2=0
  oddClock : TerrasClock.oddCount V (q+e)=TerrasClock.oddCount V q
  additive : TerrasClock.additive V (q+e)=TerrasClock.additive V q
  segment : Segment V (landing V q) (TerrasClock.oddCount V q) (q+e) (TerrasClock.additive V q)

theorem completeShortcutPrefix {V q : Nat} (odd : V%2=1) :
    ∃ e, OddCompletion V q e := by
  let x := TerrasClock.orbit V q
  let Z := oddPart x
  have positive : 0<x := shortcutOrbitPositive (by omega) q
  have zOdd : Z%2=1 := (oddPart_pos_and_odd x positive).2
  obtain ⟨e,factor⟩ := oddPart_factor x positive
  change x=2^e*Z at factor
  have endpoint : TerrasClock.orbit V (q+e)=Z := by
    rw [TerrasClock.orbit_add]
    change TerrasClock.orbit x e=Z
    rw [factor,stripAt e Z e (Nat.le_refl _)]
    simp
  have evenStrip : ∀ i<e, TerrasClock.orbit V (q+i)%2=0 := by
    intro i inside
    rw [TerrasClock.orbit_add]
    change TerrasClock.orbit x i%2=0
    rw [factor]
    exact stripEven e Z i inside
  have zeros : TerrasClock.oddCount x e=0 ∧ TerrasClock.additive x e=0 := by
    rw [factor]
    exact evenBook (stripEven e Z)
  have count : TerrasClock.oddCount V (q+e)=TerrasClock.oddCount V q := by
    rw [TerrasClock.oddCount_add]
    change TerrasClock.oddCount V q+TerrasClock.oddCount x e=TerrasClock.oddCount V q
    rw [zeros.1,Nat.add_zero]
  have cost : TerrasClock.additive V (q+e)=TerrasClock.additive V q := by
    rw [TerrasClock.additive_add]
    change 3^(TerrasClock.oddCount x e)*TerrasClock.additive V q+
      2^q*TerrasClock.additive x e=TerrasClock.additive V q
    simp only [zeros.1,zeros.2,Nat.pow_zero,Nat.one_mul,Nat.mul_zero,Nat.add_zero]
  obtain ⟨S,path⟩ := oddPath V (TerrasClock.oddCount V q) odd
  have lift := physicalShortcut path
  have sameClock : S=q+e := oddClockUnique
    (by rw [lift.1]; exact orbit_odd V odd _)
    (by rwa [endpoint]) (lift.2.trans count.symm)
  have state : Z=landing V q := endpoint.symm.trans (sameClock ▸ lift.1)
  have book := TerrasClock.exact_book V (q+e)
  rw [endpoint,state,count,cost] at book
  refine ⟨e,endpoint.trans state,?_,evenStrip,count,cost,?_⟩
  · exact factor.trans (congrArg (2^e*·) state)
  · exact ⟨sameClock ▸ path,book⟩

theorem OddCompletion.noExtraIffOdd {V q e : Nat} (completed : OddCompletion V q e)
    (pivotOdd : V%2=1) : e=0 ↔ TerrasClock.orbit V q%2=1 := by
  constructor
  · intro zero
    have reached := completed.endpoint
    rw [zero,Nat.add_zero] at reached
    rw [reached]
    exact orbit_odd V pivotOdd _
  · intro odd
    by_cases zero : e=0
    · exact zero
    have even := completed.evenStrip 0 (by omega)
    rw [Nat.add_zero] at even
    omega

def ShortcutFirstBelow (V q : Nat) : Prop :=
  TerrasClock.orbit V q<V ∧ ∀ t<q, V≤TerrasClock.orbit V t

theorem shortcutFirstOfContraction {V q : Nat} (first : TerrasClock.FirstContraction V q)
    (below : TerrasClock.orbit V q<V) : ShortcutFirstBelow V q :=
  ⟨below,fun _ before => TerrasClock.prior_no_descent first before⟩

/-- The same pivot and first crossing in both clocks. Each earlier odd
checkpoint precedes the shortcut crossing at q. -/
structure FirstOddBelow (V q e : Nat) : Prop where
  complete : OddCompletion V q e
  positive : 0<TerrasClock.oddCount V q
  below : landing V q<V
  oddPrior : ∀ i<TerrasClock.oddCount V q, V≤orbit V i
  shortcutOddPrior : ∀ t<q+e, TerrasClock.orbit V t%2=1 → V≤TerrasClock.orbit V t

theorem firstOddOfShortcutFirst {V q : Nat} (odd : V%2=1)
    (first : ShortcutFirstBelow V q) : ∃ e, FirstOddBelow V q e := by
  obtain ⟨e,completed⟩ := completeShortcutPrefix (q:=q) odd
  have qpos : 0<q := by
    cases q with
    | zero => exact (Nat.lt_irrefl V first.1).elim
    | succ q => exact Nat.succ_pos _
  have one := oddCount_strict (x:=V) (p:=0) qpos odd
  have power : 1≤(2:Nat)^e := Nat.pow_pos (by decide : 0<(2:Nat))
  have le : landing V q≤TerrasClock.orbit V q := by
    rw [completed.factor]
    simpa only [Nat.one_mul] using Nat.mul_le_mul_right (landing V q) power
  refine ⟨e,completed,one,Nat.lt_of_le_of_lt le first.1,?_,?_⟩
  · intro i before
    obtain ⟨s,path⟩ := oddPath V i odd
    have atClock := physicalShortcut path
    have prior : s<q := by
      by_cases early : s<q
      · exact early
      have count := oddCount_mono V (show q≤s by omega)
      rw [atClock.2] at count
      omega
    rw [←atClock.1]
    exact first.2 _ prior
  · intro t before atOdd
    by_cases early : t<q
    · exact first.2 _ early
    have even := completed.evenStrip (t-q) (by omega)
    rw [show q+(t-q)=t by omega] at even
    omega

/-- Retain the original seed's affine book at the shortcut crossing and
at its odd completion. The time q and the extra halving time stay explicit. -/
theorem firstUnderPivot {N V j S B q : Nat} (origin : Segment N V j S B)
    (odd : V%2=1) (first : ShortcutFirstBelow V q) :
    ∃ e, FirstOddBelow V q e ∧
      Segment N (landing V q) (j+TerrasClock.oddCount V q) (S+(q+e))
        (3^(TerrasClock.oddCount V q)*B+2^S*TerrasClock.additive V q) ∧
      TerrasClock.orbit N (S+q)<V ∧
      (∀ t<q, V≤TerrasClock.orbit N (S+t)) ∧
      TerrasClock.additive N (S+q)=
        3^(TerrasClock.oddCount V q)*B+2^S*TerrasClock.additive V q := by
  obtain ⟨e,atOdd⟩ := firstOddOfShortcutFirst odd first
  have history := segmentShortcut origin
  refine ⟨e,atOdd,StagedCylinder.compose origin atOdd.complete.segment,?_,?_,?_⟩
  · rw [TerrasClock.orbit_add,history.1]
    exact first.1
  · intro t before
    rw [TerrasClock.orbit_add,history.1]
    exact first.2 _ before
  · rw [TerrasClock.additive_add,history.1,history.2.2]

/-- The ordinary first descent below V supplies precisely the sealed A2
first-crossing interface, with the local valuation sum and additive fixed. -/
theorem reduceFirstShortcutCrossing {N V j S B q : Nat} (big : 1<N)
    (odd : V%2=1) (window : V<2*N+1) (origin : Segment N V j S B)
    (first : ShortcutFirstBelow V q) :
    ∃ e, FirstOddBelow V q e ∧
      A2FirstCrossingFusion.FirstCrossing N V (landing V q) j S B
        (TerrasClock.oddCount V q) (q+e) (TerrasClock.additive V q) := by
  obtain ⟨e,atOdd⟩ := firstOddOfShortcutFirst odd first
  exact ⟨e,atOdd,A2FirstCrossingFusion.reduce_first_crossing big odd window origin
    atOdd.complete.segment ⟨_,Nat.le_refl _,atOdd.below⟩⟩

end CollatzCharacterBridge.A2ShortcutClock

#print axioms CollatzCharacterBridge.A2ShortcutClock.physicalShortcut
#print axioms CollatzCharacterBridge.A2ShortcutClock.segmentShortcut
#print axioms CollatzCharacterBridge.A2ShortcutClock.completeShortcutPrefix
#print axioms CollatzCharacterBridge.A2ShortcutClock.OddCompletion.noExtraIffOdd
#print axioms CollatzCharacterBridge.A2ShortcutClock.shortcutFirstOfContraction
#print axioms CollatzCharacterBridge.A2ShortcutClock.firstOddOfShortcutFirst
#print axioms CollatzCharacterBridge.A2ShortcutClock.firstUnderPivot
#print axioms CollatzCharacterBridge.A2ShortcutClock.reduceFirstShortcutCrossing
