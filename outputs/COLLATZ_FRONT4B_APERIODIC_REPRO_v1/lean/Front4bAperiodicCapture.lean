import Front4bWeakPriceExit
import P5R0DepthObstruction
import TernaryLift
import AffineTernaryLift

namespace CollatzCharacterBridge.Front4bAperiodicCapture

open StagedCylinder (Segment compose)
open A2CertifiedLanding (PaidMeeting)
open FixedSourceRun (Ones ones_balanced)
open Front4bSwitchedRealization (Trace)

set_option maxRecDepth 16000
set_option maxHeartbeats 1500000

/-- Exact necessary price for any paid source at an actual weak trace endpoint.
It uses the source's own physical height bound and the original episode count. -/
theorem sourceDepth {J L q X m d C N w h s B : Nat} {xs : List (Nat × Nat)}
    (history : Trace J L q xs X m d C) (height : N≤J) (price : w<N)
    (source : Segment w X h s B) :
    2^h*(81^xs.length*(J+1))≤3^h*(64^xs.length*N) ∧
    2^h*81^xs.length<3^h*64^xs.length := by
  have growth := Front4bWeakPriceExit.gainOfTrace history
  have sourceBound := P5R0DepthObstruction.source_height price (Nat.le_refl h) source
  have book : 2^h*(81^xs.length*(J+1))≤3^h*(64^xs.length*N) := calc
    _ ≤ 2^h*(64^xs.length*(X+1)) := Nat.mul_le_mul_left _ growth
    _ = 64^xs.length*(2^h*(X+1)) := by ac_rfl
    _ ≤ 64^xs.length*(3^h*N) := Nat.mul_le_mul_left _ sourceBound
    _ = _ := by ac_rfl
  have lower := Nat.mul_lt_mul_of_pos_left (by omega : N<J+1)
    (Nat.mul_pos (Nat.pow_pos (by decide)) (Nat.pow_pos (by decide)) :
      0<2^h*81^xs.length)
  have strict : (2^h*81^xs.length)*N<(3^h*64^xs.length)*N := by
    simpa only [Nat.mul_assoc] using Nat.lt_of_lt_of_le lower
      (show (2^h*81^xs.length)*(J+1)≤(3^h*64^xs.length)*N by
        simpa only [Nat.mul_assoc] using book)
  exact ⟨book,Nat.lt_of_mul_lt_mul_right strict⟩

private theorem onesSuffix {x n k r : Nat} (history : Ones x n) (length : k+r≤n) :
    Ones (orbit x k) r := by
  intro i hi
  rw [←orbit_add,←orbit_add,show k+(i+1)=k+i+1 by omega]
  exact history (k+i) (by omega)

private theorem sameOnesStart {x y r : Nat} (first : Ones x r) (second : Ones y r)
    (meet : orbit x r=orbit y r) : x=y := by
  have a := ones_balanced x r first
  have b := ones_balanced y r second
  rw [meet,b] at a
  have eq := Nat.mul_left_cancel (Nat.pow_pos (by decide) : 0<(3:Nat)^r) a
  omega

/-- Any string of ones ending on the same point as the original run from a
two has length at most that run and cannot start below its entry. -/
theorem noOnlyOnesAfterTwo {N P U w i h : Nat}
    (two : 3*P+1=4*U) (height : N≤U)
    (original : Ones U i) (source : Ones w h) (meet : orbit U i=orbit w h) :
    h≤i ∧ N≤w := by
  by_cases longer : h≤i
  · let k := i-h
    have sum : k+h=i := by dsimp only [k]; omega
    have suffix := onesSuffix original (k:=k) (r:=h) (by omega)
    have start : orbit U k=w := sameOnesStart suffix source (by rw [←orbit_add,sum,meet])
    have initial : Ones U k := by intro r hr; exact original r (by dsimp [k] at hr; omega)
    have rise := ones_balanced U k initial
    have pwr : (2:Nat)^k≤3^k := Nat.pow_le_pow_left (by decide) k
    have lower : 2^k*(U+1)≤2^k*(w+1) := by
      rw [←start,rise]
      exact Nat.mul_le_mul_right _ pwr
    have compare := Nat.le_of_mul_le_mul_left lower (Nat.pow_pos (by decide))
    exact ⟨longer,by omega⟩
  · let k := h-i
    have kp : 0<k := by dsimp only [k]; omega
    have sum : k+i=h := by dsimp only [k]; omega
    have suffix := onesSuffix source (k:=k) (r:=i) (by omega)
    have start : orbit w k=U := sameOnesStart suffix original (by rw [←orbit_add,sum,meet])
    have last := source (k-1) (by dsimp [k]; omega)
    rw [show k-1+1=k by omega,start] at last
    omega

private theorem powerTwoUnit (n : Nat) : (2:Nat)^n%3≠0 := by
  induction n with
  | zero => decide
  | succ n ih =>
    rw [Nat.pow_succ,Nat.mul_mod]
    change (2^n%3*2)%3≠0
    have bound := Nat.mod_lt ((2:Nat)^n) (by decide : 0<3)
    omega

private theorem exponentForTernary {X K : Nat} (level : 1≤K) (unit : X%3≠0) :
    ∃ a : Nat, 2≤a ∧ 3^K∣2^a*X+2 := by
  by_cases one : X%3=1
  · obtain ⟨e,he,divides⟩ := ternary_exponent_lift 1 K X 1 (by decide) level
      (by simpa only [Nat.pow_one] using one)
    refine ⟨e+1,by omega,?_⟩
    have factor : 2^(e+1)*X+2=2*(X*2^e+1) := by rw [Nat.pow_succ,Nat.mul_add]; ac_rfl
    rw [factor,Nat.mul_comm]
    exact Nat.dvd_mul_right_of_dvd divides 2
  · have normalized : (2*X)%3^1=1 := by
      have h := Nat.mod_lt X (by decide : 0<3)
      simp only [Nat.pow_one,Nat.mul_mod 2 X 3]
      omega
    obtain ⟨e,_,divides⟩ := ternary_exponent_lift 1 K (2*X) 0 (by decide) level normalized
    refine ⟨e+2,by omega,?_⟩
    have factor : 2^(e+2)*X+2=2*((2*X)*2^e+1) := by
      rw [Nat.pow_add,Nat.mul_add]
      change (2^e*(2*2))*X+2=2*((2*X)*2^e)+2
      ac_rfl
    rw [factor,Nat.mul_comm]
    exact Nat.dvd_mul_right_of_dvd divides 2

/-- A source with h ones and then one valuation a. Its compact exact book
includes every one and the terminal additive. -/
def OneBreakSource (N X h a : Nat) : Prop :=
  ∃ w, 0<w ∧ w%2=1 ∧ w<N ∧ Segment w X (h+1) (h+a) (3^(h+1)-2^(h+1))

theorem oneBreakGuard {N X h a : Nat} (xp : 0<X) (xo : X%2=1) (ap : 0<a)
    (congruent : 3^(h+1)∣2^a*X+2) (price : 2^h*(2^a*X+2)<3^(h+1)*(N+1)) :
    OneBreakSource N X h a := by
  obtain ⟨v,factor⟩ := congruent
  have even : (2^a*X+2)%2=0 := by
    cases a with
    | zero => omega
    | succ a =>
      rw [Nat.pow_succ,show 2^a*2*X=2*(2^a*X) by ac_rfl]
      omega
  have vEven : v%2=0 := by
    rw [factor,Nat.mul_mod,show (3:Nat)^(h+1)%2=1 by simp [Nat.pow_mod],Nat.one_mul,Nat.mod_mod] at even
    exact even
  let q := v/2
  let w := 2^(h+1)*q-1
  let A := 2*3^h*q-1
  have hq : v=2*q := by dsimp only [q]; omega
  have vPos : 0<v := by
    by_cases zero : v=0
    · rw [zero,Nat.mul_zero] at factor
      omega
    · omega
  have qPos : 0<q := by omega
  have liveW : 0<2^h*q := Nat.mul_pos (Nat.pow_pos (by decide)) qPos
  have liveA : 0<3^h*q := Nat.mul_pos (Nat.pow_pos (by decide)) qPos
  have wp : 0<w ∧ w%2=1 := by
    simp only [w,Nat.pow_succ,show 2^h*2*q=2*(2^h*q) by ac_rfl]
    omega
  have ap' : 0<A ∧ A%2=1 := by
    simp only [A,show 2*3^h*q=2*(3^h*q) by ac_rfl]
    omega
  have edgeFactor : 3*A+1=2^a*X := by
    have reorder : 3^h*3*(2*q)=2*3*(3^h*q) := by ac_rfl
    rw [hq,Nat.pow_succ,reorder,show (2:Nat)*3=6 by decide] at factor
    simp only [A,show 2*3^h*q=2*(3^h*q) by ac_rfl]
    omega
  have scale : 2^h*(2^a*X+2)=3^(h+1)*(2^(h+1)*q) := by
    rw [factor,hq,Nat.pow_succ 2 h]
    ac_rfl
  have wSmall : w<N := by
    rw [scale] at price
    have h := Nat.lt_of_mul_lt_mul_left price
    dsimp only [w]
    omega
  obtain ⟨ends,run⟩ := FixedSourceRun.ones_prefix h q qPos
  have firstRun := A2HalfAdaptive.ones_segment w h wp.1 wp.2 run
  rw [show orbit w h=A from ends] at firstRun
  have last : Segment A X 1 a 1 :=
    ⟨A2Header.Physical.edge ap'.1 ap'.2 xp xo ap edgeFactor,edgeFactor.symm⟩
  have combined := compose firstRun last
  have cost : 3*(3^h-2^h)+2^h=3^(h+1)-2^(h+1) := by
    have comparison : (2:Nat)^h≤3^h := Nat.pow_le_pow_left (by decide) h
    rw [Nat.pow_succ 3 h,Nat.pow_succ 2 h]
    omega
  refine ⟨w,wp.1,wp.2,wSmall,?_⟩
  simpa only [Nat.pow_one,Nat.mul_one,cost] using combined

private theorem slopeBound (K a e : Nat) :
    let h := 2*(a+e+2*K+1)
    2^h*(2^a*(2^e*3^K))+1≤3^(h+1) := by
  let r := a+e+2*K+1
  let h := 2*r
  change 2^h*(2^a*(2^e*3^K))+1≤3^(h+1)
  have threeSmall : (3:Nat)^K≤2^(2*K) := by
    rw [Nat.pow_mul]
    exact Nat.pow_le_pow_left (by decide) _
  have coeff : 2^a*(2^e*3^K)≤2^r := calc
    _ ≤ 2^a*(2^e*2^(2*K)) := Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ threeSmall)
    _ = 2^(a+e+2*K) := by rw [Nat.pow_add 2 (a+e),Nat.pow_add 2 a e]; ac_rfl
    _ ≤ _ := Nat.pow_le_pow_right (by decide) (by dsimp [r]; omega)
  have compare : (2:Nat)^(h+r)≤3^h := by
    rw [show h+r=3*r by dsimp [h]; omega,show h=2*r from rfl,Nat.pow_mul,Nat.pow_mul]
    exact Nat.pow_le_pow_left (by decide) _
  have bound : 2^h*(2^a*(2^e*3^K))≤3^h := calc
    _ ≤ 2^h*2^r := Nat.mul_le_mul_left _ coeff
    _ = 2^(h+r) := by rw [Nat.pow_add 2 h r]
    _ ≤ _ := compare
  have positive : 0<(3:Nat)^h := Nat.pow_pos (by decide)
  rw [Nat.pow_succ]
  omega

/-- In every affine family of physical histories with the indicated endpoint
slope, a complete ternary subprogression has paid one-break sources. -/
theorem affinePaidSubprogression {N₀ n X₀ e K j S B : Nat} (nPos : 0<n)
    (xPos : 0<X₀) (xOdd : X₀%2=1) (evenSlope : 0<e) (level : 1≤K) (unit : X₀%3≠0)
    (history : ∀ t, Segment (N₀+n*t) (X₀+2^e*3^K*t) j S B) :
    ∃ a h t₀, 2≤a ∧ K≤h+1 ∧ ∀ u,
      let t := t₀+3^(h+1-K)*u
      OneBreakSource (N₀+n*t) (X₀+2^e*3^K*t) h a ∧ PaidMeeting (N₀+n*t) := by
  obtain ⟨a,ap,c,constant⟩ := exponentForTernary level unit
  let h := 2*(a+e+2*K+1)
  let threshold := 2^h*(2^a*X₀+2)+1
  have enough : K≤h+1 := by dsimp only [h]; omega
  obtain ⟨t₀,tlarge,_,residue⟩ := AffineTernaryLift.affine_congruence_above c
    (2^(a+e)) (h+1-K) threshold (powerTwoUnit _)
  refine ⟨a,h,t₀,ap,enough,?_⟩
  intro u
  let t := t₀+3^(h+1-K)*u
  have large : threshold≤t := by dsimp only [t]; omega
  let N := N₀+n*t
  let X := X₀+2^e*3^K*t
  have slopeEven : 2^e*3^K*t=2*(2^(e-1)*3^K*t) := by
    have power : (2:Nat)^e=2^(e-1)*2 := calc
      _ = 2^((e-1)+1) := congrArg (fun i : Nat => (2:Nat)^i) (by omega)
      _ = _ := Nat.pow_succ 2 (e-1)
    rw [power]
    ac_rfl
  have terminal : 0<X ∧ X%2=1 := by
    simp only [X,slopeEven]
    omega
  have affine : 2^a*X+2=3^K*(c+2^(a+e)*t) := by
    calc
      _ = (2^a*X₀+2)+3^K*(2^(a+e)*t) := by
        simp only [X,Nat.mul_add,Nat.pow_add 2 a e]
        ac_rfl
      _ = _ := by rw [constant,←Nat.mul_add]
  have congruent : 3^(h+1)∣2^a*X+2 := by
    obtain ⟨v,factor⟩ := residue u
    change c+2^(a+e)*t=3^(h+1-K)*v at factor
    refine ⟨v,?_⟩
    rw [affine,factor,←Nat.mul_assoc,←Nat.pow_add,show K+(h+1-K)=h+1 by omega]
  have stable : 2^h*(2^a*(2^e*3^K))+1≤3^(h+1) := slopeBound K a e
  have coefficient : t≤n*t := by
    simpa only [Nat.one_mul] using Nat.mul_le_mul_right t (by omega : 1≤n)
  have price : 2^h*(2^a*X+2)<3^(h+1)*(N+1) := calc
    _ = 2^h*(2^a*X₀+2)+(2^h*(2^a*(2^e*3^K)))*t := by
      simp only [X,Nat.mul_add]
      ac_rfl
    _ < t+(2^h*(2^a*(2^e*3^K)))*t := Nat.add_lt_add_right (by dsimp [threshold] at large; omega) _
    _ = (2^h*(2^a*(2^e*3^K))+1)*t := by rw [Nat.add_mul,Nat.one_mul,Nat.add_comm]
    _ ≤ 3^(h+1)*t := Nat.mul_le_mul_right t stable
    _ ≤ _ := Nat.mul_le_mul_left _ (by dsimp only [N]; omega)
  have source := oneBreakGuard terminal.1 terminal.2 (by omega : 0<a) congruent price
  refine ⟨source,?_⟩
  obtain ⟨w,wp,wo,ws,track⟩ := source
  exact ⟨w,X,j,S,B,h+1,h+a,_,wp,wo,ws,terminal.1,terminal.2,history t,track⟩

end CollatzCharacterBridge.Front4bAperiodicCapture

#print axioms CollatzCharacterBridge.Front4bAperiodicCapture.sourceDepth
#print axioms CollatzCharacterBridge.Front4bAperiodicCapture.noOnlyOnesAfterTwo
#print axioms CollatzCharacterBridge.Front4bAperiodicCapture.oneBreakGuard
#print axioms CollatzCharacterBridge.Front4bAperiodicCapture.affinePaidSubprogression
