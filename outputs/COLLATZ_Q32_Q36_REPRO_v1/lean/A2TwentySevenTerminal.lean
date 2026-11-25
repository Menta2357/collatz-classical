import A2BoundedReducer

namespace CollatzCharacterBridge.A2TwentySevenTerminal

open A2Header (Physical)
open StagedCylinder (Segment)
open A2BoundedReducer (RemainingBelow consume_strict_tail)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

private def m0 : Nat := 7573852332351969472906
private def slope : Nat := 8862938119652501095929
private def M (u : Nat) : Nat := m0+slope*u
def V (u : Nat) : Nat := 64*M u+39
private def A (u : Nat) : Nat := 96*M u+59
private def B (u : Nat) : Nat := 144*M u+89
private def E (u : Nat) : Nat := 108*M u+67
def R (u : Nat) : Nat := 162*M u+101
def t (u : Nat) : Nat := 27+32*u

private theorem V_eq (u : Nat) : A2HalfAdaptive.after.at (t u)=V u := by
  simp only [A2HalfAdaptive.after, P5CompensationMeetings.Affine.at,
    t, V, M, m0, slope]
  omega

private theorem opening (u : Nat) : Segment (V u) (R u) 4 5 73 := by
  have e1 : Physical (V u) 1 1 (A u) :=
    Physical.edge (by dsimp [V]; omega) (by dsimp [V]; omega)
      (by dsimp [A]; omega) (by dsimp [A]; omega)
      (by decide) (by dsimp [V,A]; omega)
  have e2 : Physical (A u) 1 1 (B u) :=
    Physical.edge (by dsimp [A]; omega) (by dsimp [A]; omega)
      (by dsimp [B]; omega) (by dsimp [B]; omega)
      (by decide) (by dsimp [A,B]; omega)
  have e3 : Physical (B u) 1 2 (E u) :=
    Physical.edge (by dsimp [B]; omega) (by dsimp [B]; omega)
      (by dsimp [E]; omega) (by dsimp [E]; omega)
      (by decide) (by dsimp [B,E]; omega)
  have e4 : Physical (E u) 1 1 (R u) :=
    Physical.edge (by dsimp [E]; omega) (by dsimp [E]; omega)
      (by dsimp [R]; omega) (by dsimp [E,R]; omega)
      (by decide) (by dsimp [E,R]; omega)
  have ph : Physical (V u) 4 5 (R u) := by
    simpa only [Nat.reduceAdd] using
      (Physical.append e1 (Physical.append e2 (Physical.append e3 e4)))
  refine ⟨ph, ?_⟩
  change 32*R u=81*V u+73
  dsimp [R,V]
  omega

private theorem R_odd (u : Nat) : R u % 2=1 := by dsimp [R]; omega
private theorem R_pos (u : Nat) : 0<R u := by dsimp [R]; omega
private theorem R_relation (u : Nat) : 32*R u=81*V u+73 := by
  dsimp [R,V]
  omega

/-- The last valuation is obtained from the physical odd map; it is not
fixed by the first four edges. -/
theorem physical_tail (u : Nat) :
    ∃ c : Nat, 1≤c ∧ 3*R u+1=2^c*step (R u) ∧
      Segment (V u) (step (R u)) 5 (5+c) 251 := by
  obtain ⟨c,hc,hf⟩ := P5R3S5.actual_step_factor (R u) (R_odd u)
  have last := P5R3S5.step_segment (R u) c (R_pos u) (R_odd u) hc hf
  have whole := P5R3S5.transport (opening u) last
  refine ⟨c,hc,hf,?_⟩
  simpa only [show 4+1=5 by decide,
    show (3:Nat)^1*73+1*2^5=251 by decide] using whole

theorem historical_tail (u : Nat) :
    ∃ c : Nat, 1≤c ∧ 3*R u+1=2^c*step (R u) ∧
      Segment (A2HalfAdaptive.seed (t u)) (step (R u)) 51 (77+c)
        (243*A2HalfAdaptive.beta46+251*2^72) := by
  obtain ⟨c,hc,hf,tail⟩ := physical_tail u
  have fromN : Segment (A2HalfAdaptive.seed (t u)) (V u) 46 72
      A2HalfAdaptive.beta46 := by
    rw [←V_eq u]
    exact A2HalfAdaptive.entry (t u)
  have whole := P5R3S5.transport fromN tail
  refine ⟨c,hc,hf,?_⟩
  simpa only [show 46+5=51 by decide, show 72+(5+c)=77+c by omega,
    show (3:Nat)^5=243 by decide] using whole

private theorem R_phase_91 (k : Nat) : R (2+8*k)%16=13 := by
  dsimp [R,M,m0,slope]
  omega

private theorem R_phase_219 (k : Nat) : R (6+8*k)%16=5 := by
  dsimp [R,M,m0,slope]
  omega

private theorem phase_ge3 {r p c : Nat} (phase : r%16=13)
    (oddp : p%2=1) (hc : 1≤c) (hf : 3*r+1=2^c*p) : 3≤c := by
  by_cases h1 : c=1
  · rw [h1] at hf
    change 3*r+1=2*p at hf
    omega
  by_cases h2 : c=2
  · rw [h2] at hf
    change 3*r+1=4*p at hf
    omega
  omega

private theorem phase_ge4 {r p c : Nat} (phase : r%16=5)
    (oddp : p%2=1) (hc : 1≤c) (hf : 3*r+1=2^c*p) : 4≤c := by
  by_cases h1 : c=1
  · rw [h1] at hf
    change 3*r+1=2*p at hf
    omega
  by_cases h2 : c=2
  · rw [h2] at hf
    change 3*r+1=4*p at hf
    omega
  by_cases h3 : c=3
  · rw [h3] at hf
    change 3*r+1=8*p at hf
    omega
  omega

private theorem t91_eq (k : Nat) : 91+256*k=t (2+8*k) := by
  dsimp [t]
  omega

private theorem t219_eq (k : Nat) : 219+256*k=t (6+8*k) := by
  dsimp [t]
  omega

/-- The t≡219 mod256 branch descends below the same original N. -/
theorem q177_219_certificate (k : Nat)
    (IH : ∀ w : Nat, 0<w → w%2=1 →
      w<A2HalfAdaptive.seed (219+256*k) → ∃ i, orbit w i=1) :
    ∃ c : Nat, 4≤c ∧
      Segment (A2HalfAdaptive.seed (219+256*k)) (step (R (6+8*k)))
        51 (77+c) (243*A2HalfAdaptive.beta46+251*2^72) ∧
      step (R (6+8*k))<A2HalfAdaptive.seed (219+256*k) ∧
      ∃ i, orbit (A2HalfAdaptive.seed (219+256*k)) i=1 := by
  let u := 6+8*k
  let N := A2HalfAdaptive.seed (219+256*k)
  let p := step (R u)
  obtain ⟨c,hc,hf,book⟩ := historical_tail u
  have ht : 219+256*k=t u := t219_eq k
  have book' : Segment N p 51 (77+c)
      (243*A2HalfAdaptive.beta46+251*2^72) := by
    dsimp [N,p]
    rw [ht]
    exact book
  have hpodd : p%2=1 := step_odd _
  have hphase : R u%16=5 := R_phase_219 k
  change 3*R u+1=2^c*p at hf
  have hc4 : 4≤c := phase_ge4 hphase hpodd hc hf
  have hpow : (16:Nat)≤2^c := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) hc4
  have hmul := Nat.mul_le_mul_right p hpow
  have hR := R_relation u
  have hV : V u=A2HalfAdaptive.after.at (t u) := (V_eq u).symm
  have hwindow := (A2HalfAdaptive.entry_bounds (t u)).2.2
  have hbound : 512*p≤243*V u+251 := by omega
  have hsmall : p<N := by
    rw [←hV] at hwindow
    dsimp [N]
    rw [ht]
    have big : 10<A2HalfAdaptive.seed (t u) := by
      dsimp [A2HalfAdaptive.seed,t]
      omega
    omega
  obtain ⟨j,hj⟩ := IH p (step_pos _) hpodd (by simpa [N,p] using hsmall)
  have endpoint : orbit N 51=p := A2Header.physical_endpoint book'.physical
  refine ⟨c,hc4,book',hsmall,51+j,?_⟩
  rw [orbit_add,endpoint,hj]

/-- The t≡91 mod256 branch has a strictly decreasing bounded-reentry
consumer. This is not a proof that all later pivots are covered. -/
theorem q177_91_certificate (k : Nat)
    (IH : ∀ w : Nat, 0<w → w%2=1 →
      w<A2HalfAdaptive.seed (91+256*k) → ∃ i, orbit w i=1) :
    ∃ c : Nat, 3≤c ∧
      Segment (A2HalfAdaptive.seed (91+256*k)) (step (R (2+8*k)))
        51 (77+c) (243*A2HalfAdaptive.beta46+251*2^72) ∧
      step (R (2+8*k))<A2HalfAdaptive.after.at (91+256*k) ∧
      ((∃ i, orbit (A2HalfAdaptive.seed (91+256*k)) i=1) ∨
        RemainingBelow (A2HalfAdaptive.seed (91+256*k))
          (A2HalfAdaptive.after.at (91+256*k))) := by
  let u := 2+8*k
  let N := A2HalfAdaptive.seed (91+256*k)
  let p := step (R u)
  obtain ⟨c,hc,hf,tail0⟩ := physical_tail u
  have ht : 91+256*k=t u := t91_eq k
  have fromN0 : Segment (A2HalfAdaptive.seed (t u)) (V u) 46 72
      A2HalfAdaptive.beta46 := by
    rw [←V_eq u]
    exact A2HalfAdaptive.entry (t u)
  have book0 := P5R3S5.transport fromN0 tail0
  have book' : Segment N p 51 (77+c)
      (243*A2HalfAdaptive.beta46+251*2^72) := by
    dsimp [N,p]
    rw [ht]
    simpa only [show 46+5=51 by decide, show 72+(5+c)=77+c by omega,
      show (3:Nat)^5=243 by decide] using book0
  have hpodd : p%2=1 := step_odd _
  have hphase : R u%16=13 := R_phase_91 k
  change 3*R u+1=2^c*p at hf
  have hc3 : 3≤c := phase_ge3 hphase hpodd hc hf
  have hpow : (8:Nat)≤2^c := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) hc3
  have hmul := Nat.mul_le_mul_right p hpow
  have hR := R_relation u
  have hvbig : 20<V u := by dsimp [V,M,m0,slope]; omega
  have hbound : 256*p≤243*V u+251 := by omega
  have hsmall : p<V u := by omega
  have hvEq : A2HalfAdaptive.after.at (91+256*k)=V u := by
    rw [ht]
    exact V_eq u
  have hsmall' : p<A2HalfAdaptive.after.at (91+256*k) := by
    rw [hvEq]
    exact hsmall
  have fromN : Segment N (A2HalfAdaptive.after.at (91+256*k)) 46 72
      A2HalfAdaptive.beta46 := A2HalfAdaptive.entry (91+256*k)
  have bnd := A2HalfAdaptive.entry_bounds (91+256*k)
  have tail : Segment (A2HalfAdaptive.after.at (91+256*k)) p 5 (5+c) 251 := by
    rw [hvEq]
    exact tail0
  have consumed := consume_strict_tail (by dsimp [N,A2HalfAdaptive.seed]; omega)
    fromN bnd.1 bnd.2.1 bnd.2.2 tail hsmall' IH
  refine ⟨c,hc3,book',hsmall',consumed.2⟩

end CollatzCharacterBridge.A2TwentySevenTerminal
