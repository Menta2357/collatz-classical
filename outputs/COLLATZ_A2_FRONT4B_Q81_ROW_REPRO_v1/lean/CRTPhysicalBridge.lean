import A2Header
import FixedSourceRun

namespace CollatzCharacterBridge.CRTPhysicalBridge

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

open A2Header (Physical)

def A (x : Nat) : Nat := 17*x+73
def WStart (t : Nat) : Nat := 71+128*t
def W1 (t : Nat) : Nat := 107+192*t
def W2 (t : Nat) : Nat := 161+288*t
def W3 (t : Nat) : Nat := 121+216*t
def WEnd (t : Nat) : Nat := 91+162*t
def J1 (Y : Nat) : Nat := 11+48*(Y/32)
def J2 (Y : Nat) : Nat := 17+72*(Y/32)
def JEnd (Y : Nat) : Nat := 13+54*(Y/32)

/-- Prepending one W gives this exact natural source numerator. -/
def WCost : Nat → Nat
  | 0 => 0
  | k+1 => 64*WCost k+73*81^k

theorem W_exact (t : Nat) :
    Physical (WStart t) 4 6 (WEnd t) ∧
    64*WEnd t=81*WStart t+73 ∧ 64*A (WEnd t)=81*A (WStart t) ∧
    0<WEnd t ∧ WEnd t%2=1 := by
  have h1 : Physical (WStart t) 1 1 (W1 t) := by
    apply Physical.edge
    all_goals
      try simp only [WStart,W1]
      omega
  have h2 : Physical (W1 t) 1 1 (W2 t) := by
    apply Physical.edge
    all_goals
      try simp only [W1,W2]
      omega
  have h3 : Physical (W2 t) 1 2 (W3 t) := by
    apply Physical.edge
    all_goals
      try simp only [W2,W3]
      omega
  have h4 : Physical (W3 t) 1 2 (WEnd t) := by
    apply Physical.edge
    all_goals
      try simp only [W3,WEnd]
      omega
  refine ⟨Physical.append (Physical.append (Physical.append h1 h2) h3) h4,?_⟩
  simp only [WStart,WEnd,A]
  omega

private theorem reserve_representation (x q : Nat) (hA : A x=128*q) :
    x=WStart (x/128) := by
  simp only [A] at hA
  simp only [WStart]
  omega

theorem W_from_reserve (x q : Nat) (hA : A x=128*q) :
    ∃ y : Nat, Physical x 4 6 y ∧ 64*y=81*x+73 ∧ 64*A y=81*A x ∧
      0<y ∧ y%2=1 := by
  have hx := reserve_representation x q hA
  have hh := W_exact (x/128)
  rw [←hx] at hh
  exact ⟨WEnd (x/128),hh⟩

theorem power64 (k : Nat) : 2^(6*k)=64^k := by
  simpa only [show (2:Nat)^6=64 by decide] using Nat.pow_mul 2 6 k

theorem power81 (k : Nat) : 3^(4*k)=81^k := by
  simpa only [show (3:Nat)^4=81 by decide] using Nat.pow_mul 3 4 k

theorem reserve_terminal_phase (k V u : Nat) (hu : u%2=1)
    (hA : A V=2*81^k*u) : V%4=1 := by
  have hp : (81^k*u)%2=1 := by simp [Nat.mul_mod,Nat.pow_mod,hu]
  have he : 17*V+73=2*(81^k*u) := by
    change 17*V+73=2*81^k*u at hA
    exact hA.trans (by ac_rfl)
  omega

structure WRun (w k u V : Nat) : Prop where
  physical : Physical w (4*k) (6*k) V
  book : 64^k*V=81^k*w+WCost k
  reserve : A V=2*81^k*u
  positive : 0<V
  odd : V%2=1
  terminal_phase : V%4=1

/-- Exact W-runs from the natural reserve. The k=0 branch is empty
and does not use a fictitious128-divisibility guard. -/
theorem w_run (k w u : Nat) (hwp : 0<w) (hwo : w%2=1) (hup : 0<u) (huo : u%2=1)
    (hA : A w=2^(6*k+1)*u) : ∃ V : Nat, WRun w k u V := by
  induction k generalizing w u with
  | zero =>
    have hres : A w=2*81^0*u := by simpa using hA
    refine ⟨w,?_⟩
    exact {
      physical := by simpa using Physical.refl w
      book := by simp [WCost]
      reserve := hres
      positive := hwp
      odd := hwo
      terminal_phase := reserve_terminal_phase 0 w u huo hres
    }
  | succ k ih =>
    have h128 : A w=128*(2^(6*k)*u) := by
      rw [hA,show 6*(k+1)+1=6*k+7 by omega,Nat.pow_add 2 (6*k) 7]
      change (2^(6*k)*128)*u=128*(2^(6*k)*u)
      ac_rfl
    obtain ⟨w1,hw1,hbook1,hcoord1,hpos1,hodd1⟩ := W_from_reserve w (2^(6*k)*u) h128
    have hscale : 81*A w=64*(2^(6*k+1)*(81*u)) := by
      rw [hA,show 6*(k+1)+1=(6*k+1)+6 by omega,Nat.pow_add 2 (6*k+1) 6]
      change 81*((2^(6*k+1)*64)*u)=64*(2^(6*k+1)*(81*u))
      ac_rfl
    have hnext : A w1=2^(6*k+1)*(81*u) :=
      Nat.mul_left_cancel (by decide : 0<64) (hcoord1.trans hscale)
    obtain ⟨V,hV⟩ := ih w1 (81*u) hpos1 hodd1 (by omega)
      (by simp [Nat.mul_mod,huo]) hnext
    have hphys := Physical.append hw1 hV.physical
    rw [show 4+4*k=4*(k+1) by omega,show 6+6*k=6*(k+1) by omega] at hphys
    have hres : A V=2*81^(k+1)*u := by
      rw [hV.reserve,Nat.pow_succ 81 k]
      ac_rfl
    have hbook : 64^(k+1)*V=81^(k+1)*w+WCost (k+1) := by
      calc
        _ = 64*(64^k*V) := by rw [Nat.pow_succ 64 k]; ac_rfl
        _ = 64*(81^k*w1+WCost k) := by rw [hV.book]
        _ = 81^k*(64*w1)+64*WCost k := by simp only [Nat.mul_add]; ac_rfl
        _ = 81^k*(81*w+73)+64*WCost k := by rw [hbook1]
        _ = _ := by rw [Nat.pow_succ 81 k]; simp only [WCost,Nat.mul_add]; ac_rfl
    refine ⟨V,?_⟩
    exact {
      physical := hphys
      book := hbook
      reserve := hres
      positive := hV.positive
      odd := hV.odd
      terminal_phase := reserve_terminal_phase (k+1) V u huo hres
    }

theorem w_run_to (k w u V : Nat) (hwp : 0<w) (hwo : w%2=1) (hup : 0<u) (huo : u%2=1)
    (hA : A w=2^(6*k+1)*u) (hV : A V=2*81^k*u) : WRun w k u V := by
  obtain ⟨x,hx⟩ := w_run k w u hwp hwo hup huo hA
  have he : x=V := by have hh := hx.reserve; simp only [A] at hh hV; omega
  rw [he] at hx
  exact hx

theorem no_further_W {w k u V : Nat} (hr : WRun w k u V) : 3*V+1≠2*step V := by
  have hp := hr.terminal_phase
  have ho := step_odd V
  omega

theorem WCost_balance (k : Nat) : 17*WCost k+73*64^k=73*81^k := by
  induction k with
  | zero => simp [WCost]
  | succ k ih =>
    calc
      _ = 64*(17*WCost k+73*64^k)+17*(73*81^k) := by
        rw [Nat.pow_succ 64 k]
        simp only [WCost,Nat.mul_add]
        ac_rfl
      _ = 64*(73*81^k)+17*(73*81^k) := by rw [ih]
      _ = 81*(73*81^k) := by omega
      _ = _ := by rw [Nat.pow_succ 81 k]; ac_rfl

theorem WCost_formula (k : Nat) : WCost k=73*(81^k-64^k)/17 := by
  have hh := WCost_balance k
  have he : 17*WCost k=73*(81^k-64^k) := by
    rw [Nat.mul_sub_left_distrib]
    omega
  rw [←he]
  omega

theorem J_factors (Y : Nat) (hY : Y%32=7) :
    3*Y+1=2*J1 Y ∧ 3*J1 Y+1=2*J2 Y ∧ 3*J2 Y+1=4*JEnd Y := by
  simp only [J1,J2,JEnd]
  omega

theorem J_edges (Y : Nat) (hY : Y%32=7) :
    Physical Y 1 1 (J1 Y) ∧ Physical (J1 Y) 1 1 (J2 Y) ∧
    Physical (J2 Y) 1 2 (JEnd Y) := by
  constructor
  · apply Physical.edge
    all_goals
      try simp only [J1]
      omega
  · constructor
    · apply Physical.edge
      all_goals
        try simp only [J1,J2]
        omega
    · apply Physical.edge
      all_goals
        try simp only [J2,JEnd]
        omega

theorem J_physical (Y : Nat) (hY : Y%32=7) : Physical Y 3 4 (JEnd Y) := by
  have hh := J_edges Y hY
  exact Physical.append (Physical.append hh.1 hh.2.1) hh.2.2

theorem J_book (Y : Nat) (hY : Y%32=7) : 16*JEnd Y=27*Y+19 := by
  simp only [JEnd]
  omega

private theorem strip_pow (a y : Nat) : oddPart (2^a*y)=oddPart y := by
  induction a with
  | zero => simp
  | succ a ih =>
    rw [Nat.pow_succ]
    have he : 2^a*2*y=2*(2^a*y) := by ac_rfl
    rw [he,oddPart_double,ih]

theorem shared_first_image (V Y h : Nat) (hr : 3*V+1=2^h*(3*Y+1)) : step V=step Y := by
  unfold step
  rw [hr,strip_pow]

theorem shared_three_returns (V Y h : Nat) (hr : 3*V+1=2^h*(3*Y+1)) :
    orbit V 3=orbit Y 3 := by
  change step (step (step V))=step (step (step Y))
  rw [shared_first_image V Y h hr]

theorem source_tail (V Y h : Nat) (hVp : 0<V) (hVo : V%2=1) (hY : Y%32=7)
    (hr : 3*V+1=2^h*(3*Y+1)) : Physical V 3 (h+4) (JEnd Y) := by
  have hf := J_factors Y hY
  have hfirst : 3*V+1=2^(h+1)*J1 Y := by
    rw [hr,hf.1,Nat.pow_succ 2 h]
    ac_rfl
  have hp : Physical V 1 (h+1) (J1 Y) := by
    apply Physical.edge hVp hVo
    · simp only [J1]; omega
    · simp only [J1]; omega
    · omega
    · exact hfirst
  have hj := J_edges Y hY
  have hh := Physical.append (Physical.append hp hj.2.1) hj.2.2
  simpa only [Nat.add_assoc] using hh

theorem source_tail_book (V Y h : Nat) (hY : Y%32=7)
    (hr : 3*V+1=2^h*(3*Y+1)) :
    2^(h+4)*JEnd Y=27*V+9+5*2^(h+1) := by
  have hf := J_factors Y hY
  have hfirst : 2^(h+1)*J1 Y=3^1*V+1 := by
    rw [hr,hf.1,Nat.pow_succ 2 h]
    ac_rfl
  have hsecond : 2^1*J2 Y=3^1*J1 Y+1 := by simpa using hf.2.1.symm
  have hthird : 2^2*JEnd Y=3^1*J2 Y+1 := by simpa using hf.2.2.symm
  have htwo : 2^(h+2)*J2 Y=3^2*V+(3+2^(h+1)) := by
    simpa only [Nat.pow_one,Nat.mul_one,Nat.add_assoc] using
      FixedSourceRun.history_transport hfirst hsecond
  have hfull := FixedSourceRun.history_transport htwo hthird
  simp only [Nat.pow_one,Nat.mul_one] at hfull
  change 2^(h+4)*JEnd Y=27*V+3*(3+2^(h+1))+2^(h+2) at hfull
  have he : 2^(h+2)=2*2^(h+1) := by
    rw [show h+2=(h+1)+1 by omega,Nat.pow_succ 2 (h+1)]
    ac_rfl
  rw [he] at hfull
  omega

theorem original_history (N Y j S B : Nat) (hY : Y%32=7)
    (hbook : 2^S*Y=3^j*N+B) :
    2^(S+4)*JEnd Y=3^(j+3)*N+27*B+19*2^S := by
  have hl : 2^4*JEnd Y=3^3*Y+19 := J_book Y hY
  have hh := FixedSourceRun.history_transport hbook hl
  change 2^(S+4)*JEnd Y=3^(j+3)*N+27*B+2^S*19 at hh
  exact hh.trans (by ac_rfl)

theorem source_history {w k u V : Nat} (hRun : WRun w k u V) (Y h : Nat)
    (hY : Y%32=7) (hr : 3*V+1=2^h*(3*Y+1)) :
    2^(6*k+h+4)*JEnd Y=3^(4*k+3)*w+27*WCost k+
      (9+5*2^(h+1))*2^(6*k) := by
  have hw : 2^(6*k)*V=3^(4*k)*w+WCost k := by rw [power64,power81]; exact hRun.book
  have ht : 2^(h+4)*JEnd Y=3^3*V+(9+5*2^(h+1)) := by
    have hh := source_tail_book V Y h hY hr
    simpa only [Nat.add_assoc] using hh
  have hh := FixedSourceRun.history_transport hw ht
  have hn : 6*k+(h+4)=6*k+h+4 := by omega
  rw [hn] at hh
  change 2^(6*k+h+4)*JEnd Y=3^(4*k+3)*w+27*WCost k+2^(6*k)*(9+5*2^(h+1)) at hh
  exact hh.trans (by ac_rfl)

structure Certificate (N Y w V k u h j S B : Nat) : Prop where
  run : WRun w k u V
  source_positive : 0<w
  source_odd : w%2=1
  source_smaller : w<N
  shared_first : step V=step Y
  original_checkpoint : orbit N j=Y
  source_physical : Physical w (4*k+3) (6*k+h+4) (JEnd Y)
  original_physical : Physical N (j+3) (S+4) (JEnd Y)
  meeting : orbit w (4*k+3)=orbit N (j+3)
  original_book : 2^(S+4)*JEnd Y=3^(j+3)*N+27*B+19*2^S
  source_book : 2^(6*k+h+4)*JEnd Y=3^(4*k+3)*w+27*WCost k+
    (9+5*2^(h+1))*2^(6*k)

/-- Conditional physical bridge. The coordinate equations, real
original prefix, both original book and strict w<N are supplied. -/
theorem capture_from_coordinates (N Y w V k u h j S B : Nat)
    (hwp : 0<w) (hwo : w%2=1) (hwN : w<N) (hup : 0<u) (huo : u%2=1)
    (hAw : A w=2^(6*k+1)*u) (hAV : A V=2*81^k*u)
    (hY : Y%32=7) (hrel : 3*V+1=2^h*(3*Y+1))
    (hOriginal : Physical N j S Y) (hBook : 2^S*Y=3^j*N+B) :
    Certificate N Y w V k u h j S B := by
  have hRun := w_run_to k w u V hwp hwo hup huo hAw hAV
  have hTail := source_tail V Y h hRun.positive hRun.odd hY hrel
  have hSource := Physical.append hRun.physical hTail
  rw [show 6*k+(h+4)=6*k+h+4 by omega] at hSource
  have hTarget := Physical.append hOriginal (J_physical Y hY)
  have hm : orbit w (4*k+3)=orbit N (j+3) :=
    (A2Header.physical_endpoint hSource).trans (A2Header.physical_endpoint hTarget).symm
  exact {
    run := hRun
    source_positive := hwp
    source_odd := hwo
    source_smaller := hwN
    shared_first := shared_first_image V Y h hrel
    original_checkpoint := A2Header.physical_endpoint hOriginal
    source_physical := hSource
    original_physical := hTarget
    meeting := hm
    original_book := original_history N Y j S B hY hBook
    source_book := source_history hRun Y h hY hrel
  }

#print axioms W_exact
#print axioms reserve_representation
#print axioms W_from_reserve
#print axioms power64
#print axioms power81
#print axioms reserve_terminal_phase
#print axioms w_run
#print axioms w_run_to
#print axioms no_further_W
#print axioms WCost_balance
#print axioms WCost_formula
#print axioms J_factors
#print axioms J_edges
#print axioms J_physical
#print axioms J_book
#print axioms strip_pow
#print axioms shared_first_image
#print axioms shared_three_returns
#print axioms source_tail
#print axioms source_tail_book
#print axioms original_history
#print axioms source_history
#print axioms capture_from_coordinates

end CollatzCharacterBridge.CRTPhysicalBridge
