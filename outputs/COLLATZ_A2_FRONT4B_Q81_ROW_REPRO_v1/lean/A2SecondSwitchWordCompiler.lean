import P5R3S5

namespace CollatzCharacterBridge.A2SecondSwitchWordCompiler

open A2Header (Physical)
open StagedCylinder (Segment)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

def total : List Nat → Nat
  | [] => 0
  | a::w => a+total w

def cost : List Nat → Nat
  | [] => 0
  | a::w => 3^w.length+2^a*cost w

def ValWord (w : List Nat) : Prop := ∀ a ∈ w, 1≤a

theorem total_snoc (w : List Nat) (a : Nat) : total (w++[a])=total w+a := by
  induction w with
  | nil => simp [total]
  | cons b w ih => simp [total,ih,Nat.add_assoc]

theorem cost_snoc (w : List Nat) (a : Nat) : cost (w++[a])=3*cost w+2^total w := by
  induction w with
  | nil => simp [cost,total]
  | cons b w ih =>
    simp only [List.cons_append,cost,List.length_append,List.length_singleton,
      ih,total,Nat.pow_succ,Nat.pow_add,Nat.mul_add,Nat.add_mul]
    ac_rfl

private theorem two_mod_three (n : Nat) : 2^n%3=1 ∨ 2^n%3=2 := by
  induction n with
  | zero => exact Or.inl rfl
  | succ n ih =>
    rw [Nat.pow_succ,Nat.mul_mod]
    omega

/-- Removing the final edge uses modulo 3 and positive odd endpoints;
the predecessor is constructed as an integer, not postulated. -/
private theorem peel {x Z S L C a : Nat}
    (hZ : 0<Z) (oddZ : Z%2=1) (ha : 1≤a)
    (book : 2^(S+a)*Z=3^(L+1)*x+(3*C+2^S)) :
    ∃ z : Nat, 0<z ∧ z%2=1 ∧ 3*z+1=2^a*Z ∧ 2^S*z=3^L*x+C := by
  have expanded : 2^S*(2^a*Z)=3*(3^L*x+C)+2^S := by
    rw [Nat.pow_add,Nat.pow_succ] at book
    simpa only [Nat.mul_assoc,Nat.mul_add,Nat.add_assoc,Nat.mul_comm (3^L) 3] using book
  have modular : (2^S%3)*((2^a*Z)%3)%3=2^S%3 := by
    rw [←Nat.mul_mod,expanded]
    omega
  have hp := two_mod_three S
  have residue : (2^a*Z)%3=1 := by
    cases hp with
    | inl hp => rw [hp] at modular; omega
    | inr hp => rw [hp] at modular; omega
  let z := (2^a*Z)/3
  have factor : 3*z+1=2^a*Z := by dsimp [z]; omega
  have powEven : (2:Nat)^a=2*2^(a-1) := by
    calc
      (2:Nat)^a=2^((a-1)+1) := congrArg (fun n : Nat => (2:Nat)^n) (by omega)
      _ = 2^(a-1)*2 := Nat.pow_succ 2 (a-1)
      _ = 2*2^(a-1) := Nat.mul_comm _ _
  have even : 2^a*Z=2*(2^(a-1)*Z) := by rw [powEven]; ac_rfl
  have hpower : (2:Nat)≤2^a := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) ha
  have bound := Nat.mul_le_mul hpower (by omega : 1≤Z)
  have zp : 0<z := by omega
  have zo : z%2=1 := by omega
  rw [←factor,Nat.mul_add,Nat.mul_one] at expanded
  have rearrange : 2^S*(3*z)=3*(2^S*z) := by ac_rfl
  rw [rearrange] at expanded
  have tail : 2^S*z=3^L*x+C := by omega
  exact ⟨z,zp,zo,factor,tail⟩

private theorem compile_reverse (v : List Nat) :
    ∀ x Z : Nat, 0<x → x%2=1 → 0<Z → Z%2=1 → ValWord v.reverse →
    2^total v.reverse*Z=3^v.reverse.length*x+cost v.reverse →
      Segment x Z v.reverse.length (total v.reverse) (cost v.reverse) := by
  induction v with
  | nil =>
    intro x Z hx hxo hZ hZo valid book
    simp only [List.reverse_nil,total,cost,List.length_nil,Nat.pow_zero,Nat.one_mul,Nat.add_zero] at book ⊢
    subst Z
    exact ⟨Physical.refl x,by simp⟩
  | cons a v ih =>
    intro x Z hx hxo hZ hZo valid book
    rw [List.reverse_cons] at valid book ⊢
    have ha : 1≤a := valid a (by simp)
    have hv : ValWord v.reverse := by
      intro b hb
      exact valid b (by simp [hb])
    rw [total_snoc,cost_snoc,List.length_append,List.length_singleton] at book
    obtain ⟨z,hz,hzo,factor,tail⟩ := peel hZ hZo ha book
    have initial := ih x z hx hxo hz hzo hv tail
    have last : Physical z 1 a Z := Physical.edge hz hzo hZ hZo (by omega) factor
    refine ⟨?_,?_⟩
    · simpa only [List.length_append,List.length_singleton,total_snoc] using
        Physical.append initial.physical last
    · simpa only [total_snoc,cost_snoc,List.length_append,List.length_singleton] using book

/-- A valid word and its exact affine book between positive odd endpoints
certify every physical edge. No intermediate integrality is assumed. -/
theorem compile_word (word : List Nat) {x Z : Nat}
    (hx : 0<x) (oddx : x%2=1) (hZ : 0<Z) (oddZ : Z%2=1)
    (valid : ValWord word) (book : 2^total word*Z=3^word.length*x+cost word) :
    Segment x Z word.length (total word) (cost word) := by
  have h := compile_reverse word.reverse x Z hx oddx hZ oddZ
  simp only [List.reverse_reverse] at h
  exact h valid book

/-- Equality of slopes and the exact cost identity compile both current
states. This includes (s,D)=(0,40) and (2,251), without asserting a guard. -/
theorem aligned_capture (original source : List Nat) {X U Z s D : Nat}
    (positiveX : 0<X) (oddX : X%2=1) (positiveU : 0<U) (oddU : U%2=1)
    (positiveZ : 0<Z) (oddZ : Z%2=1)
    (validO : ValWord original) (validS : ValWord source)
    (relation : 2^s*X=27*U+D)
    (lengths : source.length=original.length+3)
    (clocks : total source=total original+s)
    (costs : cost source=3^original.length*D+2^s*cost original)
    (book : 2^total original*Z=3^original.length*X+cost original) :
    Segment X Z original.length (total original) (cost original) ∧
      Segment U Z source.length (total source) (cost source) := by
  have srcbook : 2^total source*Z=3^source.length*U+cost source := by
    rw [clocks,lengths,costs,Nat.pow_add,Nat.pow_add]
    have rearrange : (2^total original*2^s)*Z=2^s*(2^total original*Z) := by ac_rfl
    rw [rearrange,book,Nat.mul_add]
    have rearrange2 : 2^s*(3^original.length*X)=3^original.length*(2^s*X) := by ac_rfl
    rw [rearrange2,relation,Nat.mul_add]
    simp only [show (3:Nat)^3=27 by decide,Nat.mul_assoc,Nat.add_assoc]
  exact ⟨compile_word original positiveX oddX positiveZ oddZ validO book,
    compile_word source positiveU oddU positiveZ oddZ validS srcbook⟩

end CollatzCharacterBridge.A2SecondSwitchWordCompiler
