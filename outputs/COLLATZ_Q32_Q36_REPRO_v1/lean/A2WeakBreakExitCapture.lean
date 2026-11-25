import A2SecondSwitchWordCompiler

namespace CollatzCharacterBridge.A2WeakBreakExitCapture

open A2SecondSwitchWordCompiler (ValWord compile_word)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 1000000

private theorem valid_of_list {word : List Nat}
    (checked : word.all (fun a => decide (1≤a))=true) : ValWord word :=
  fun a ha => of_decide_eq_true ((List.all_eq_true.mp checked) a ha)

private theorem edge {x y a : Nat} (hx : 0<x) (hxo : x%2=1)
    (hyo : y%2=1) (ha : 0<a) (book : 3*x+1=2^a*y) :
    Segment x y 1 a 1 :=
  ⟨A2Header.Physical.edge hx hxo (by omega) hyo ha book, by simpa using book.symm⟩

private theorem original_exit {z A K e : Nat} (hz : 0<z) (zo : z%2=1)
    (ao : A%2=1) (ko : K%2=1) (he : 0<e)
    (apr : 256*A+29=81*z) (last : 3*A+1=2^e*K) :
    Segment (12*z-5) K 4 (10+e) 1081 := by
  have book : 1024*A=27*(12*z-5)+19 := by omega
  have wordSegment : Segment (12*z-5) A 3 10 19 :=
    compile_word [1,1,8] (by omega) (by omega) (by omega) ao
      (valid_of_list (by decide)) book
  exact compose wordSegment (edge (by omega) ao ko he last)

private theorem source_exit {W A K p Q C e : Nat}
    (history : Segment W (4*A+1) p Q C) (ko : K%2=1)
    (he : 0<e) (last : 3*A+1=2^e*K) :
    Segment W K (p+1) (Q+(e+2)) (3*C+2^Q) := by
  have fact : 3*(4*A+1)+1=2^(e+2)*K := by
    calc
      3*(4*A+1)+1=4*(3*A+1) := by omega
      _=2^(e+2)*K := by
        rw [last,Nat.pow_add]
        change 4*(2^e*K)=(2^e*4)*K
        ac_rfl
  have tail : Segment (4*A+1) K 1 (e+2) 1 :=
    edge (by omega) (by omega) ko (by omega) fact
  simpa only [Nat.pow_one,Nat.one_mul] using P5R3S5.transport history tail

/-- In phase one with zero macros, the prefix (1,1,8) matches
the source prefix (2,1,3,1) at the pair A and 4A+1. -/
theorem captures_phase_one_zero_macros {N w u A K j S B k Q C e : Nat}
    (orig : Segment N (12*u-5) j S B) (src : Segment w (2*u-1) k Q C)
    (paid : 0<w ∧ w%2=1 ∧ w<N) (uo : u%2=1)
    (ao : A%2=1) (ko : K%2=1) (he : 0<e)
    (apr : 256*A+29=81*u) (last : 3*A+1=2^e*K) :
    0<w ∧ w%2=1 ∧ w<N ∧
      Segment N K (j+4) (S+(10+e)) (81*B+1081*2^S) ∧
      Segment w K (k+5) (Q+(9+e)) (243*C+581*2^Q) := by
  have book : 128*(4*A+1)=81*(2*u-1)+151 := by omega
  have companion : Segment (2*u-1) (4*A+1) 4 7 151 :=
    compile_word [2,1,3,1] (by omega) (by omega) (by omega) (by omega)
      (valid_of_list (by decide)) book
  have auxiliary := source_exit companion ko he last
  rw [show 7+(e+2)=9+e by omega] at auxiliary
  exact ⟨paid.1,paid.2.1,paid.2.2,
    P5R3S5.transport orig (original_exit (by omega) uo ao ko he apr last),
    P5R3S5.transport src auxiliary⟩

/-- In phase one with one macro, the paid companion reaches 4A+1
by (1,1,1,3,3,1), retaining the same free final exponent. -/
theorem captures_phase_one_one_macro {N w u A K j S B k Q C e : Nat}
    (orig : Segment N (108*u-5) j S B) (src : Segment w (16*u-1) k Q C)
    (paid : 0<w ∧ w%2=1 ∧ w<N) (uo : u%2=1)
    (ao : A%2=1) (ko : K%2=1) (he : 0<e)
    (apr : 256*A+29=729*u) (last : 3*A+1=2^e*K) :
    0<w ∧ w%2=1 ∧ w<N ∧
      Segment N K (j+4) (S+(10+e)) (81*B+1081*2^S) ∧
      Segment w K (k+7) (Q+(12+e)) (2187*C+4891*2^Q) := by
  have book : 1024*(4*A+1)=729*(16*u-1)+1289 := by omega
  have companion : Segment (16*u-1) (4*A+1) 6 10 1289 :=
    compile_word [1,1,1,3,3,1] (by omega) (by omega) (by omega) (by omega)
      (valid_of_list (by decide)) book
  have auxiliary := source_exit companion ko he last
  rw [show 10+(e+2)=12+e by omega] at auxiliary
  have shape : 108*u-5=12*(9*u)-5 := by omega
  have orig' := StagedCylinder.cast_segment orig rfl shape
  have trig : 256*A+29=81*(9*u) := by omega
  exact ⟨paid.1,paid.2.1,paid.2.2,
    P5R3S5.transport orig' (original_exit (by omega) (by omega) ao ko he trig last),
    P5R3S5.transport src auxiliary⟩

/-- Phase two with no macro and physical exit (1,7). The last three
inverse ones give an independent source, charged to the original N. -/
theorem captures_phase_two_three_ones {N u Y j S B : Nat}
    (orig : Segment N (24*u-5) j S B) (uo : u%2=1)
    (yo : Y%2=1) (trig : 32*Y+5=27*u) (price : u+1<4*(N+1)) :
    let w := (u+1)/4-1
    0<w ∧ w%2=1 ∧ w<N ∧
      Segment N Y (j+2) (S+8) (9*B+5*2^S) ∧ Segment w Y 3 3 19 := by
  let w := (u+1)/4-1
  have paid : 0<w ∧ w%2=1 ∧ w<N := by dsimp only [w]; omega
  have start : 256*Y=9*(24*u-5)+5 := by omega
  have source : 8*Y=27*w+19 := by dsimp only [w]; omega
  have a : Segment (24*u-5) Y 2 8 5 :=
    compile_word [1,7] (by omega) (by omega) (by omega) yo
      (valid_of_list (by decide)) start
  have b : Segment w Y 3 3 19 :=
    compile_word [1,1,1] paid.1 paid.2.1 (by omega) yo
      (valid_of_list (by decide)) source
  exact ⟨paid.1,paid.2.1,paid.2.2,P5R3S5.transport orig a,b⟩

end CollatzCharacterBridge.A2WeakBreakExitCapture
