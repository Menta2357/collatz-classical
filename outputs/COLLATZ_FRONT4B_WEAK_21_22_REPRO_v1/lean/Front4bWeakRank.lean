import A2ShortcutClock

namespace CollatzCharacterBridge.Front4bWeakRank

open StagedCylinder (Segment compose)
open FixedSourceRun (Ones)

set_option maxRecDepth 10000
set_option maxHeartbeats 800000

/-- Lower bounds at all the actual odd checkpoints imply the same lower
bound at every shortcut state before the supplied odd endpoint. -/
theorem shortcutLowerOfOddLower {v J Z h S C : Nat} (odd : J%2=1)
    (path : Segment J Z h S C) (lower : ∀ i≤h, v≤orbit J i) :
    ∀ k≤S, v≤TerrasClock.orbit J k := by
  intro k hk
  obtain ⟨_,count⟩ := A2ShortcutClock.physicalShortcut path.physical
  have cumulative := TerrasClock.oddCount_add J k (S-k)
  rw [show k+(S-k)=S by omega,count] at cumulative
  have atOdd := lower (TerrasClock.oddCount J k) (by omega)
  obtain ⟨e,comp⟩ := A2ShortcutClock.completeShortcutPrefix (q:=k) odd
  have atLeast : 1≤(2:Nat)^e := Nat.pow_pos (by decide : 0<(2:Nat))
  have scaled := Nat.mul_le_mul_right (A2ShortcutClock.landing J k) atLeast
  rw [Nat.one_mul] at scaled
  rw [comp.factor]
  exact Nat.le_trans atOdd scaled

private theorem onesMono {J L : Nat} (run : Ones J L) {p q : Nat}
    (before : p≤q) (inside : q≤L) : orbit J p≤orbit J q := by
  induction q with
  | zero => have h : p=0 := by omega
            subst p
            exact Nat.le_refl _
  | succ q ih =>
    by_cases atEarlier : p≤q
    · have stepUp := run q (by omega)
      exact Nat.le_trans (ih atEarlier (by omega)) (by omega)
    · have eq : p=q+1 := by omega
      exact Nat.le_of_eq (congrArg (orbit J) eq)

private theorem edge {x y a : Nat} (xp : 0<x) (xo : x%2=1)
    (yp : 0<y) (yo : y%2=1) (positive : 0<a) (factor : 3*x+1=2^a*y) :
    Segment x y 1 a 1 :=
  ⟨A2Header.Physical.edge xp xo yp yo positive factor,factor.symm⟩

def weakCost (L : Nat) : Nat := 3*(3*(3^L-2^L)+2^L)+2^(L+2)

structure WeakRank (J L b : Nat) : Prop where
  firstAbove : J<orbit J (L+1)
  lastAbove : J<orbit J (L+2)
  history : Segment J (orbit J (L+2)) (L+2) (L+2+b) (weakCost L)
  oddLower : ∀ i≤L+2, J≤orbit J i
  shortcutLower : ∀ k≤L+2+b, J≤TerrasClock.orbit J k

/-- At least two ones followed by (2,1) or (2,2) leave both weak
checkpoints strictly above the same entry J. -/
theorem weakRank {J L b : Nat} (odd : J%2=1) (many : 2≤L)
    (weak : b=1 ∨ b=2) (run : Ones J L)
    (first : 3*orbit J L+1=4*orbit J (L+1))
    (last : 3*orbit J (L+1)+1=2^b*orbit J (L+2)) : WeakRank J L b := by
  have positive : 0<J := by omega
  have firstOne := run 0 (by omega)
  change 3*J+1=2*orbit J 1 at firstOne
  have secondOne := run 1 (by omega)
  change 3*orbit J 1+1=2*orbit J 2 at secondOne
  have along : orbit J 2≤orbit J L := onesMono run many (Nat.le_refl _)
  have rise : 9*J+5≤4*orbit J L := by omega
  have fAbove : J<orbit J (L+1) := by omega
  have zAbove : J<orbit J (L+2) := by
    have scale := Nat.mul_le_mul_right (orbit J (L+2))
      (Nat.pow_le_pow_right (by decide : 0<(2:Nat)) (show b≤2 by omega))
    rw [←last] at scale
    change 3*orbit J (L+1)+1≤4*orbit J (L+2) at scale
    omega
  have tail1 : Segment (orbit J L) (orbit J (L+1)) 1 2 1 :=
    edge (orbit_pos J positive _) (orbit_odd J odd _) (orbit_pos J positive _)
      (orbit_odd J odd _) (by decide) first
  have tail2 : Segment (orbit J (L+1)) (orbit J (L+2)) 1 b 1 :=
    edge (orbit_pos J positive _) (orbit_odd J odd _) (orbit_pos J positive _)
      (orbit_odd J odd _) (by omega) last
  have full : Segment J (orbit J (L+2)) (L+2) (L+2+b) (weakCost L) := by
    have h := compose (compose (A2HalfAdaptive.ones_segment J L positive odd run) tail1) tail2
    simp only [Nat.pow_one,Nat.mul_one,weakCost,show L+1+1=L+2 by omega] at h ⊢
    exact h
  have lower : ∀ i≤L+2, J≤orbit J i := by
    intro i hi
    by_cases inside : i≤L
    · exact onesMono run (Nat.zero_le i) inside
    · have cases : i=L+1 ∨ i=L+2 := by omega
      rcases cases with rfl | rfl
      · exact Nat.le_of_lt fAbove
      · exact Nat.le_of_lt zAbove
  exact ⟨fAbove,zAbove,full,lower,shortcutLowerOfOddLower odd full lower⟩

/-- A subsequent run of H ones also stays above J. Both local clocks and
the composed affine additive refer to this same continuation. -/
theorem attachOnes {J L b H : Nat} (odd : J%2=1) (weak : WeakRank J L b)
    (more : Ones (orbit J (L+2)) H) :
    let cost := 3^H*weakCost L+2^(L+2+b)*(3^H-2^H)
    Segment J (orbit J (L+2+H)) (L+2+H) (L+2+b+H) cost ∧
      (∀ i≤L+2+H, J≤orbit J i) ∧
      (∀ k≤L+2+b+H, J≤TerrasClock.orbit J k) := by
  let Z := orbit J (L+2)
  have positive : 0<J := by omega
  have long := compose weak.history (A2HalfAdaptive.ones_segment Z H
    (orbit_pos J positive _) (orbit_odd J odd _) more)
  rw [←orbit_add] at long
  have lower : ∀ i≤L+2+H, J≤orbit J i := by
    intro i hi
    by_cases earlier : i≤L+2
    · exact weak.oddLower i earlier
    · rw [show i=L+2+(i-(L+2)) by omega,orbit_add]
      exact Nat.le_trans (Nat.le_of_lt weak.lastAbove)
        (onesMono more (Nat.zero_le _) (by omega))
  exact ⟨long,lower,shortcutLowerOfOddLower odd long lower⟩

/-- Compose the original N book and compare both physical clocks from
its actual occurrence of J. -/
theorem attachOrigin {N J Z j S C m d D lower : Nat}
    (origin : Segment N J j S C) (odd : J%2=1)
    (suffix : Segment J Z m d D) (oddLower : ∀ i≤m, lower≤orbit J i) :
    Segment N Z (j+m) (S+d) (3^m*C+2^S*D) ∧
      (∀ i≤m, lower≤orbit N (j+i)) ∧
      (∀ i≤d, lower≤TerrasClock.orbit N (S+i)) := by
  refine ⟨compose origin suffix,?_,?_⟩
  · intro i hi
    rw [orbit_add,A2Header.physical_endpoint origin.physical]
    exact oddLower i hi
  · intro i hi
    rw [TerrasClock.orbit_add,(A2ShortcutClock.segmentShortcut origin).1]
    exact shortcutLowerOfOddLower odd suffix oddLower i hi

/-- An odd affine slope reaches every specified dyadic lift. The witness
quotient stays nonnegative, including at modulus one. -/
theorem oddAffineLift {a : Nat} (odd : a%2=1) (b target K : Nat) :
    ∃ t q, b+a*t=target+2^K*q := by
  have apo : 1≤a := by omega
  induction K with
  | zero =>
    have bound : target≤b+a*target := by
      have prod := Nat.mul_le_mul_right target apo
      simp only [Nat.one_mul] at prod
      omega
    exact ⟨target,b+a*target-target,by simp only [Nat.pow_zero,Nat.one_mul]; omega⟩
  | succ K ih =>
    obtain ⟨t,q,eq⟩ := ih
    by_cases even : q%2=0
    · refine ⟨t,q/2,?_⟩
      have half : q=2*(q/2) := by omega
      calc
        b+a*t=target+2^K*q := eq
        _=target+2^K*(2*(q/2)) := congrArg (fun x : Nat => target+2^K*x) half
        _=target+2^(K+1)*(q/2) := by rw [Nat.pow_succ,Nat.mul_assoc]
    · have half : q+a=2*((q+a)/2) := by omega
      refine ⟨t+2^K,(q+a)/2,?_⟩
      calc
        _= (b+a*t)+2^K*a := by simp only [Nat.mul_add]; ac_rfl
        _=target+2^K*(q+a) := by rw [eq,Nat.mul_add,Nat.add_assoc]
        _=target+2^K*(2*((q+a)/2)) := congrArg (fun x : Nat => target+2^K*x) half
        _=target+2^(K+1)*((q+a)/2) := by rw [Nat.pow_succ,Nat.mul_assoc]

end CollatzCharacterBridge.Front4bWeakRank

#print axioms CollatzCharacterBridge.Front4bWeakRank.shortcutLowerOfOddLower
#print axioms CollatzCharacterBridge.Front4bWeakRank.weakRank
#print axioms CollatzCharacterBridge.Front4bWeakRank.attachOnes
#print axioms CollatzCharacterBridge.Front4bWeakRank.attachOrigin
#print axioms CollatzCharacterBridge.Front4bWeakRank.oddAffineLift
