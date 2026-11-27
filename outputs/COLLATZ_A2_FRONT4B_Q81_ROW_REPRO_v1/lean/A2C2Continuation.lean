import A2TwentySevenTerminal
import A2SecondOne

namespace CollatzCharacterBridge.A2C2Continuation

open A2Header (Physical)
open StagedCylinder (Segment)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

private def R0 : Nat := 1226964077841019054610873
private def P0 : Nat := 920223058380764290958155
private def Psl : Nat := 4307387926151115532621494
def P (v : Nat) : Nat := P0 + Psl*v
def tt (v : Nat) : Nat := 27+128*v
abbrev BP : Nat := 243*A2HalfAdaptive.beta46+251*2^72

private theorem t_eq (v : Nat) : A2TwentySevenTerminal.t (4*v)=tt v := by
  dsimp [A2TwentySevenTerminal.t,tt]
  omega

private theorem R_affine (v : Nat) :
    A2TwentySevenTerminal.R (4*v)=R0+5743183901534820710161992*v := by
  change 162 * (7573852332351969472906 + 8862938119652501095929 * (4*v)) + 101 =
    R0 + 5743183901534820710161992*v
  dsimp [R0]
  omega

private theorem P_affine (v : Nat) :
    3*A2TwentySevenTerminal.R (4*v)+1=4*P v := by
  rw [R_affine]
  dsimp [R0,P,P0,Psl]
  omega

private theorem R_phase (v : Nat) :
    A2TwentySevenTerminal.R (4*v)%8=1 := by
  rw [R_affine]
  dsimp [R0]
  omega

private theorem phase_two {r p c : Nat} (hr : r%8=1)
    (hp : p%2=1) (hc : 1≤c) (hf : 3*r+1=2^c*p) : c=2 := by
  by_cases h1 : c=1
  · rw [h1] at hf
    change 3*r+1=2*p at hf
    omega
  by_cases h2 : c=2
  · exact h2
  have hc3 : 3≤c := by omega
  rw [show c=3+(c-3) by omega, Nat.pow_add] at hf
  simp only [show (2:Nat)^3=8 by decide, Nat.mul_assoc] at hf
  omega

private theorem base_segment (v : Nat) :
    Segment (A2HalfAdaptive.seed (tt v)) (P v) 51 79
      (243*A2HalfAdaptive.beta46+251*2^72) := by
  obtain ⟨c,hc,hf,book⟩ := A2TwentySevenTerminal.historical_tail (4*v)
  have hc2 : c=2 := phase_two (R_phase v) (step_odd _) hc hf
  have hP := P_affine v
  rw [hc2] at hf
  have heq : step (A2TwentySevenTerminal.R (4*v))=P v := by
    change 3*A2TwentySevenTerminal.R (4*v)+1=4*step (A2TwentySevenTerminal.R (4*v)) at hf
    omega
  rw [hc2,heq,t_eq] at book
  simpa only [show 77+2=79 by decide] using book

private theorem local_segment (v : Nat) :
    Segment (A2TwentySevenTerminal.V (4*v)) (P v) 5 7 251 := by
  obtain ⟨c,hc,hf,tail⟩ := A2TwentySevenTerminal.physical_tail (4*v)
  have hc2 : c=2 := phase_two (R_phase v) (step_odd _) hc hf
  have hP := P_affine v
  rw [hc2] at hf
  have heq : step (A2TwentySevenTerminal.R (4*v))=P v := by
    change 3*A2TwentySevenTerminal.R (4*v)+1=4*step (A2TwentySevenTerminal.R (4*v)) at hf
    omega
  rw [hc2,heq] at tail
  simpa only [show 5+2=7 by decide] using tail

private theorem P_relation (v : Nat) :
    128*P v=243*A2TwentySevenTerminal.V (4*v)+251 := by
  change 128*(P0+Psl*v)=
    243*(64*(7573852332351969472906+8862938119652501095929*(4*v))+39)+251
  dsimp [P0,Psl]
  omega

private theorem V_eq (v : Nat) :
    A2HalfAdaptive.after.at (tt v)=A2TwentySevenTerminal.V (4*v) := by
  change 6127890809290987085857+17725876239305002191858*(tt v) =
    64*(7573852332351969472906+8862938119652501095929*(4*v))+39
  dsimp [tt]
  omega

private theorem P_height (v : Nat) : P v<4*A2HalfAdaptive.seed (tt v)+1 := by
  have hV := (A2HalfAdaptive.entry_bounds (tt v)).2.2
  rw [V_eq v] at hV
  have hrel := P_relation v
  dsimp [A2HalfAdaptive.seed,tt] at *
  omega

def two (x : Nat) : Nat := (3*x+1)/4

private theorem two_segment {x : Nat} (phase : x%8=1) :
    Segment x (two x) 1 2 1 := by
  have hx : 0<x := by omega
  have hodd : x%2=1 := by omega
  have hy : 0<two x := by dsimp [two]; omega
  have hyodd : (two x)%2=1 := by dsimp [two]; omega
  have factor : 3*x+1=2^2*two x := by
    dsimp [two]
    change 3*x+1=4*((3*x+1)/4)
    omega
  exact ⟨Physical.edge hx hodd hy hyodd (by decide) factor, factor.symm⟩

private theorem two_le (x : Nat) : two x≤x := by
  dsimp [two]
  omega

private theorem append_two {N X j S B : Nat}
    (hist : Segment N X j S B) (phase : X%8=1) :
    Segment N (two X) (j+1) (S+2) (3*B+2^S) := by
  have whole := P5R3S5.transport hist (two_segment phase)
  simpa only [show (3:Nat)^1=3 by decide, Nat.one_mul] using whole

private theorem high_phase {x e p : Nat} (phase : x%8=5)
    (oddp : p%2=1) (he : 1≤e) (factor : 3*x+1=2^e*p) : 3≤e := by
  by_cases h1 : e=1
  · rw [h1] at factor
    change 3*x+1=2*p at factor
    omega
  by_cases h2 : e=2
  · rw [h2] at factor
    change 3*x+1=4*p at factor
    omega
  omega

def HighCertificate (N X j S B : Nat) : Prop :=
    ∃ e : Nat, 3≤e ∧
      let w := (X-1)/4
      0<w ∧ w%2=1 ∧ w<N ∧
      Segment N (step X) (j+1) (S+e) (3*B+2^S) ∧
      Segment w (step X) 1 (e-2) 1 ∧
      orbit N (j+1)=orbit w 1 ∧
      ∃ i, orbit N i=1

/-- Generic consumer for any of the three high-valued exits. Both the
original and independent quarter-source books are returned. -/
theorem high_exit {N X j S B : Nat}
    (hist : Segment N X j S B) (height : X<4*N+1)
    (phase : X%8=5)
    (IH : ∀ w : Nat, 0<w → w%2=1 → w<N → ∃ i, orbit w i=1) :
    HighCertificate N X j S B := by
  obtain ⟨e,he,hf⟩ := P5R3S5.actual_step_factor X (by omega)
  have he3 := high_phase phase (step_odd X) he hf
  obtain ⟨hp,ho,hl,book,source,meet⟩ :=
    A2SecondOne.quarter_capture hist height he3 hf
  have done := A2SecondOne.quarter_closes_under_IH hist height he3 hf IH
  exact ⟨e,he3,hp,ho,hl,book,source,meet,done⟩

private theorem phase_411 (k : Nat) : P (3+4*k)%8=5 := by
  dsimp [P,P0,Psl]
  omega

private theorem phase_1179 (k : Nat) : P (9+16*k)%32=17 := by
  dsimp [P,P0,Psl]
  omega

private theorem phase_4251 (k : Nat) : P (33+64*k)%128=65 := by
  dsimp [P,P0,Psl]
  omega

private theorem phase_155 (k : Nat) : P (1+64*k)%128=1 := by
  dsimp [P,P0,Psl]
  omega

private theorem phase_two_of_17 {x : Nat} (h : x%32=17) : (two x)%8=5 := by
  dsimp [two]
  omega

private theorem phase_two_of_65 {x : Nat} (h : x%128=65) : (two x)%32=17 := by
  dsimp [two]
  omega

private theorem phase_two_of_1_128 {x : Nat} (h : x%128=1) : (two x)%32=1 := by
  dsimp [two]
  omega

private theorem phase_two_of_1_32 {x : Nat} (h : x%32=1) : (two x)%8=1 := by
  dsimp [two]
  omega

/-- The first high exit, with no leading valuation-two return from P. -/
theorem q177_411_capture (k : Nat)
    (IH : ∀ w : Nat, 0<w → w%2=1 →
      w<A2HalfAdaptive.seed (411+512*k) → ∃ i, orbit w i=1) :
    HighCertificate (A2HalfAdaptive.seed (411+512*k))
      (P (3+4*k)) 51 79 BP := by
  have ht : tt (3+4*k)=411+512*k := by dsimp [tt]; omega
  have hist := base_segment (3+4*k)
  rw [ht] at hist
  have height := P_height (3+4*k)
  rw [ht] at height
  exact high_exit hist height (phase_411 k) IH

/-- One physical valuation-two return precedes the first high exit. -/
theorem q177_1179_capture (k : Nat)
    (IH : ∀ w : Nat, 0<w → w%2=1 →
      w<A2HalfAdaptive.seed (1179+2048*k) → ∃ i, orbit w i=1) :
    HighCertificate (A2HalfAdaptive.seed (1179+2048*k))
      (two (P (9+16*k))) 52 81 (3*BP+2^79) := by
  have ht : tt (9+16*k)=1179+2048*k := by dsimp [tt]; omega
  have hist0 := base_segment (9+16*k)
  rw [ht] at hist0
  have phase0 : P (9+16*k)%8=1 := by
    have h := phase_1179 k
    omega
  have hist1 := append_two hist0 phase0
  have hist : Segment (A2HalfAdaptive.seed (1179+2048*k))
      (two (P (9+16*k))) 52 81 (3*BP+2^79) := by
    simpa only [Nat.reduceAdd] using hist1
  have height0 := P_height (9+16*k)
  rw [ht] at height0
  have hle := two_le (P (9+16*k))
  have height : two (P (9+16*k))<4*A2HalfAdaptive.seed (1179+2048*k)+1 :=
    by omega
  exact high_exit hist height (phase_two_of_17 (phase_1179 k)) IH

/-- Two physical valuation-two returns precede the high exit. -/
theorem q177_4251_capture (k : Nat)
    (IH : ∀ w : Nat, 0<w → w%2=1 →
      w<A2HalfAdaptive.seed (4251+8192*k) → ∃ i, orbit w i=1) :
    HighCertificate (A2HalfAdaptive.seed (4251+8192*k))
      (two (two (P (33+64*k)))) 53 83
      (3*(3*BP+2^79)+2^81) := by
  have ht : tt (33+64*k)=4251+8192*k := by dsimp [tt]; omega
  have hist0 := base_segment (33+64*k)
  rw [ht] at hist0
  have phase0 : P (33+64*k)%8=1 := by
    have h := phase_4251 k
    omega
  have hist1 := append_two hist0 phase0
  have phase1_32 := phase_two_of_65 (phase_4251 k)
  have phase1 : (two (P (33+64*k)))%8=1 := by omega
  have hist2 := append_two hist1 phase1
  have hist : Segment (A2HalfAdaptive.seed (4251+8192*k))
      (two (two (P (33+64*k)))) 53 83
      (3*(3*BP+2^79)+2^81) := by
    simpa only [Nat.reduceAdd] using hist2
  have height0 := P_height (33+64*k)
  rw [ht] at height0
  have hle1 := two_le (P (33+64*k))
  have hle2 := two_le (two (P (33+64*k)))
  have height : two (two (P (33+64*k)))<
      4*A2HalfAdaptive.seed (4251+8192*k)+1 :=
    by omega
  exact high_exit hist height (phase_two_of_17 phase1_32) IH

/-- Three physical valuation-two returns yield a strict bounded reentry.
This consumer returns a smaller residual pivot, not automatic convergence. -/
theorem q177_155_reentry (k : Nat)
    (IH : ∀ w : Nat, 0<w → w%2=1 →
      w<A2HalfAdaptive.seed (155+8192*k) → ∃ i, orbit w i=1) :
    let v := 1+64*k
    let X := two (two (two (P v)))
    let N := A2HalfAdaptive.seed (155+8192*k)
    let V0 := A2TwentySevenTerminal.V (4*v)
    Segment N X 54 85 (6561*A2HalfAdaptive.beta46+11513*2^72) ∧
    X<V0 ∧
    ((∃ i, orbit N i=1) ∨ A2BoundedReducer.RemainingBelow N V0) := by
  dsimp only
  let v := 1+64*k
  let X := two (two (two (P v)))
  let N := A2HalfAdaptive.seed (155+8192*k)
  let V0 := A2TwentySevenTerminal.V (4*v)
  have ht : tt v=155+8192*k := by dsimp [tt,v]; omega
  have phase0 := phase_155 k
  have hP8 : P v%8=1 := by
    change P (1+64*k)%8=1
    omega
  have phase1_32 := phase_two_of_1_128 phase0
  have phase1 : (two (P v))%8=1 := by
    change (two (P (1+64*k)))%8=1
    omega
  have phase2 := phase_two_of_1_32 phase1_32
  have tail0 : Segment V0 (P v) 5 7 251 := local_segment v
  have tail1 := append_two tail0 hP8
  have tail2 := append_two tail1 phase1
  have tail3 := append_two tail2 phase2
  have tail : Segment V0 X 8 13 11513 := by
    dsimp [X]
    simpa only [Nat.reduceAdd,
      show 3*(3*(3*251+2^7)+2^9)+2^11=11513 by decide] using tail3
  have book : 8192*X=6561*V0+11513 := by
    simpa only [show (2:Nat)^13=8192 by decide,
      show (3:Nat)^8=6561 by decide] using tail.book
  have Vbig : 8<V0 := by dsimp [V0,A2TwentySevenTerminal.V]; omega
  have small : X<V0 := by omega
  have heq : A2HalfAdaptive.after.at (155+8192*k)=V0 := by
    rw [←ht]
    exact V_eq v
  have fromN : Segment N V0 46 72 A2HalfAdaptive.beta46 := by
    have hentry := A2HalfAdaptive.entry (155+8192*k)
    rw [heq] at hentry
    exact hentry
  have bnd := A2HalfAdaptive.entry_bounds (155+8192*k)
  have Nbig : 1<N := by dsimp [N,A2HalfAdaptive.seed]; omega
  have consumer := A2BoundedReducer.consume_strict_tail Nbig fromN
    (by rw [←heq]; exact bnd.1) (by rw [←heq]; exact bnd.2.1)
    (by rw [←heq]; exact bnd.2.2) tail small IH
  refine ⟨?_,small,consumer.2⟩
  simpa only [show 46+8=54 by decide, show 72+13=85 by decide,
    show (3:Nat)^8=6561 by decide] using consumer.1

end CollatzCharacterBridge.A2C2Continuation
