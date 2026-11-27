import P5CompensationMeetings

namespace CollatzCharacterBridge.A2HalfAdaptive

open A2Header (Physical)
open StagedCylinder (Segment compose)
open FixedSourceRun (Ones)
open P5R3S5 (transport)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

private theorem ones_physical (x r : Nat) (hx : 0<x) (ho : x%2=1) (h : Ones x r) :
    Physical x r r (orbit x r) := by
  induction r with
  | zero => exact Physical.refl x
  | succ r ih =>
    have first := ih (fun i hi => h i (by omega))
    have last : Physical (orbit x r) 1 1 (orbit x (r+1)) :=
      Physical.edge (orbit_pos _ hx _) (orbit_odd _ ho _)
        (orbit_pos _ hx _) (orbit_odd _ ho _) (by decide) (h r (by omega))
    exact Physical.append first last

theorem ones_segment (x r : Nat) (hx : 0<x) (ho : x%2=1) (h : Ones x r) :
    Segment x (orbit x r) r r (3^r-2^r) := by
  refine ⟨ones_physical x r hx ho h, ?_⟩
  have book := FixedSourceRun.ones_balanced x r h
  rw [Nat.mul_add,Nat.mul_add,Nat.mul_one,Nat.mul_one] at book
  have bound : (2:Nat)^r≤3^r := Nat.pow_le_pow_left (by decide) r
  omega

private theorem edge {x y a : Nat} (hx : 0<x) (hxo : x%2=1)
    (hy : 0<y) (hyo : y%2=1) (ha : 0<a) (h : 3*x+1=2^a*y) :
    Segment x y 1 a 1 :=
  ⟨Physical.edge hx hxo hy hyo ha h, by simpa using h.symm⟩

def half (V : Nat) : Nat := (V-1)/2
def originalCost (k : Nat) : Nat := 3*(3^(k+1)-2^(k+1))+2^(k+1)
def sourceCost (k : Nat) : Nat := 3*(3*(3^k-2^k)+2^k)+2^(k+2)

theorem cost_formulas (k : Nat) :
    originalCost k=3^(k+2)-2^(k+2) ∧
      sourceCost k=3^(k+2)-2^(k+1) := by
  have h : (2:Nat)^k≤3^k := Nat.pow_le_pow_left (by decide) k
  simp only [originalCost,sourceCost,show k+2=(k+1)+1 by omega, Nat.pow_succ]
  omega

/-- The half source is fixed at entry. The actual run length and rupture
are parameters; all exponents in both books are physical. -/
theorem local_capture (N V k b : Nat) (hV : 0<V) (oddV : V%2=1)
    (height : V<2*N+1) (run : Ones V (k+1)) (hb : 3≤b)
    (factor : 3*orbit V (k+1)+1=2^b*orbit V (k+2)) :
    0<half V ∧ (half V)%2=1 ∧ half V<N ∧
      Segment V (orbit V (k+2)) (k+2) (k+1+b) (originalCost k) ∧
      Segment (half V) (orbit V (k+2)) (k+2) (k+b) (sourceCost k) := by
  let X := orbit V (k+1)
  let Z := orbit V (k+2)
  have phase : X%8=5 := FixedSourceRun.phase_from_real_break _ b _ hb factor
  obtain ⟨u,hu,_,start,finish⟩ := FixedSourceRun.real_run_parameters V (k+1) run phase
  have scale : 2^(k+2)*u=2*(2^(k+1)*u) := by
    rw [show k+2=(k+1)+1 by omega,Nat.pow_succ]
    ac_rfl
  have paidEq : half V=2^(k+1)*u-1 := by rw [scale] at start; unfold half; omega
  have even : 2^(k+1)*u=2*(2^k*u) := by rw [Nat.pow_succ]; ac_rfl
  have positive : 0<2^k*u := Nat.mul_pos (Nat.pow_pos (by decide)) hu
  have paid : 0<half V ∧ (half V)%2=1 ∧ half V<N := by
    rw [scale] at start
    rw [paidEq,even]
    omega
  have sw := FixedSourceRun.ones_prefix k u hu
  rw [←paidEq] at sw
  let F := orbit (half V) k
  have relate : X=3*F+2 := by
    change X+1=2*(3^(k+1)*u) at finish
    have hscale : 2*(3^(k+1)*u)=6*(3^k*u) := by
      rw [Nat.pow_succ]
      change 2*(3^k*3*u)=(2*3)*(3^k*u)
      ac_rfl
    rw [hscale] at finish
    have hp : 0<3^k*u := Nat.mul_pos (Nat.pow_pos (by decide)) hu
    have sw' : F=2*(3^k*u)-1 := by
      calc
        _ = 2*3^k*u-1 := sw.1
        _ = _ := by rw [Nat.mul_assoc]
    omega
  let Q := (X-1)/4
  have toQ : 3*F+1=4*Q := by dsimp only [Q]; omega
  have oddQ : Q%2=1 := by dsimp only [Q]; omega
  have posQ : 0<Q := by dsimp only [Q]; omega
  have scaleBreak : 2^b*Z=4*(2^(b-2)*Z) := by
    rw [show b=(b-2)+2 by omega,Nat.pow_add]
    change (2^(b-2)*4)*Z=4*(2^(b-2)*Z)
    ac_rfl
  have breakFactor : 3*Q+1=2^(b-2)*Z := by
    change 3*X+1=2^b*Z at factor
    rw [scaleBreak] at factor
    have hQ : X=4*Q+1 := by dsimp only [Q]; omega
    rw [hQ] at factor
    omega
  have orig := compose (ones_segment V (k+1) hV oddV run)
    (edge (orbit_pos _ hV _) (orbit_odd _ oddV _)
      (orbit_pos _ hV _) (orbit_odd _ oddV _) (by omega : 0<b) factor)
  have a : Segment F Q 1 2 1 := edge
    (orbit_pos _ paid.1 _) (orbit_odd _ paid.2.1 _) posQ oddQ (by decide) toQ
  have z : Segment Q Z 1 (b-2) 1 := edge posQ oddQ
    (orbit_pos V hV _) (orbit_odd V oddV _) (by omega) breakFactor
  have src := compose (compose (ones_segment _ k paid.1 paid.2.1 sw.2) a) z
  rw [show k+2+(b-2)=k+b by omega] at src
  refine ⟨paid.1,paid.2.1,paid.2.2,?_,?_⟩
  · simpa only [originalCost,Nat.pow_one,Nat.mul_one] using orig
  · simpa only [sourceCost,Nat.pow_one,Nat.mul_one] using src

theorem history_capture {N V j s cost k b : Nat} (h : Segment N V j s cost)
    (hV : 0<V) (oddV : V%2=1) (height : V<2*N+1)
    (run : Ones V (k+1)) (hb : 3≤b)
    (factor : 3*orbit V (k+1)+1=2^b*orbit V (k+2)) :
    0<half V ∧ (half V)%2=1 ∧ half V<N ∧
      Segment N (orbit V (k+2)) (j+(k+2)) (s+(k+1+b))
        (3^(k+2)*cost+originalCost k*2^s) ∧
      Segment (half V) (orbit V (k+2)) (k+2) (k+b) (sourceCost k) := by
  obtain ⟨hp,ho,hl,ns,ws⟩ := local_capture N V k b hV oddV height run hb factor
  exact ⟨hp,ho,hl,transport h ns,ws⟩

open P5CompensationMeetings (Affine affine_edge affine_admissible)

def seed (t : Nat) : Nat := 2^64*(177+512*t)-5
private def before : Affine := ⟨8170521079054649447809,23634501652406669589144⟩
def after : Affine := ⟨6127890809290987085857,17725876239305002191858⟩
def beta46 : Nat := 3*A2Header.B45+2^70

theorem entry (t : Nat) : Segment (seed t) (after.at t) 46 72 beta46 := by
  have hseed : A2Header.seed (1+4*t)=seed t := by
    simp only [A2Header.seed,A2Header.cofactor,seed]; omega
  have hbefore : A2Header.U (1+4*t)=before.at t := by
    simp only [A2Header.U,before,Affine.at]; omega
  have header : Segment (A2Header.seed (1+4*t)) (A2Header.U (1+4*t)) 45 70 A2Header.B45 :=
    ⟨A2Header.header_physical _,A2Header.original_ledger _⟩
  rw [hseed,hbefore] at header
  have tail : Segment (before.at t) (after.at t) 1 2 1 := affine_edge (by decide) t
  exact compose header tail

theorem entry_bounds (t : Nat) : 0<after.at t ∧ (after.at t)%2=1 ∧ after.at t<2*seed t+1 := by
  have h := affine_admissible (f := after) (by decide) t
  refine ⟨h.1,h.2,?_⟩
  simp only [after,Affine.at,seed]
  omega

theorem q177_capture (t k b : Nat) (run : Ones (after.at t) (k+1)) (hb : 3≤b)
    (factor : 3*orbit (after.at t) (k+1)+1=2^b*orbit (after.at t) (k+2)) :
    let V := after.at t
    let N := seed t
    let Z := orbit V (k+2)
    0<half V ∧ (half V)%2=1 ∧ half V<N ∧
      Segment N Z (46+(k+2)) (72+(k+1+b)) (3^(k+2)*beta46+originalCost k*2^72) ∧
      Segment (half V) Z (k+2) (k+b) (sourceCost k) := by
  obtain ⟨h,o,hh⟩ := entry_bounds t
  exact history_capture (entry t) h o hh run hb factor

private theorem orbit_one (i : Nat) : orbit 1 i=1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i)=1
    rw [ih]
    change oddPart 4=1
    exact (oddPart_quadruple 1).trans (oddPart_of_odd (by decide))

theorem q177_closes_under_IH (t k b : Nat) (run : Ones (after.at t) (k+1)) (hb : 3≤b)
    (factor : 3*orbit (after.at t) (k+1)+1=2^b*orbit (after.at t) (k+2))
    (IH : ∀ x : Nat, 0<x → x%2=1 → x<seed t → ∃ i, orbit x i=1) :
    ∃ i, orbit (seed t) i=1 := by
  obtain ⟨h0,ho,hl,ns,ws⟩ := q177_capture t k b run hb factor
  obtain ⟨i,h⟩ := IH (half (after.at t)) h0 ho hl
  have meet := (A2Header.physical_endpoint ns.physical).trans
    (A2Header.physical_endpoint ws.physical).symm
  refine ⟨(46+(k+2))+i,?_⟩
  rw [orbit_add,meet,←orbit_add,Nat.add_comm (k+2) i,orbit_add,h,orbit_one]

theorem first_break (V : Nat) (odd : V%2=1) :
    ∃ r b, Ones V r ∧ 2≤b ∧
      3*orbit V r+1=2^b*orbit V (r+1) := by
  let u := oddPart (V+1)
  have ⟨hu,uo⟩ := oddPart_pos_and_odd (V+1) (by omega)
  change 0<u at hu
  change u%2=1 at uo
  obtain ⟨a,ha⟩ := oddPart_factor (V+1) (by omega)
  change V+1=2^a*u at ha
  have apos : 1≤a := by
    by_cases z : a=0
    · rw [z,Nat.pow_zero,Nat.one_mul] at ha; omega
    · omega
  let r := a-1
  have ar : a=r+1 := by dsimp only [r]; omega
  have form : V=2^(r+1)*u-1 := by rw [ar] at ha; omega
  have runData : orbit V r=2*3^r*u-1 ∧ Ones V r := by
    rw [form]
    exact FixedSourceRun.ones_prefix r u hu
  have h3 : (3:Nat)^r%2=1 := by simp [Nat.pow_mod]
  have productOdd : (3^r*u)%2=1 := by rw [Nat.mul_mod,h3,uo]
  have productPos : 0<3^r*u := Nat.mul_pos (Nat.pow_pos (by decide)) hu
  have phase : orbit V r%4=1 := by
    rw [runData.1,Nat.mul_assoc]
    omega
  obtain ⟨b,hb,factor⟩ := P5R3S5.actual_step_factor (orbit V r) (orbit_odd V odd r)
  have hstep : step (orbit V r)=orbit V (r+1) := rfl
  rw [hstep] at factor
  have htwo : 2≤b := by
    by_cases one : b=1
    · rw [one,Nat.pow_one] at factor
      have oddLast := orbit_odd V odd (r+1)
      omega
    · omega
  exact ⟨r,b,runData.2,htwo,factor⟩

/-- Covers the whole first-rupture branch with valuation at least three,
including an empty opening run. -/
theorem cut (t r b : Nat) (run : Ones (after.at t) r) (hb : 3≤b)
    (factor : 3*orbit (after.at t) r+1=2^b*orbit (after.at t) (r+1))
    (IH : ∀ x : Nat, 0<x → x%2=1 → x<seed t → ∃ i, orbit x i=1) :
    ∃ i, orbit (seed t) i=1 := by
  cases r with
  | zero =>
    obtain ⟨h,o,ht⟩ := entry_bounds t
    have Npos : 0<seed t := by unfold seed; omega
    change 3*after.at t+1=2^b*step (after.at t) at factor
    have power : (8:Nat)≤2^b := Nat.pow_le_pow_right (by decide : 0<(2:Nat)) hb
    have bound := Nat.mul_le_mul_right (step (after.at t)) power
    rw [←factor] at bound
    have lesser : step (after.at t)<seed t := by omega
    have next := P5R3S5.step_segment (after.at t) b h o (by omega) factor
    have history := transport (entry t) next
    obtain ⟨j,hj⟩ := IH _ (step_pos _) (step_odd _) lesser
    refine ⟨47+j,?_⟩
    rw [orbit_add,A2Header.physical_endpoint history.physical,hj]
  | succ r => exact q177_closes_under_IH t r b run hb factor IH

theorem closes_or_rupture_two (t : Nat)
    (IH : ∀ x : Nat, 0<x → x%2=1 → x<seed t → ∃ i, orbit x i=1) :
    (∃ i, orbit (seed t) i=1) ∨
      ∃ r, Ones (after.at t) r ∧ 3*orbit (after.at t) r+1=4*orbit (after.at t) (r+1) := by
  obtain ⟨r,b,run,hb,factor⟩ := first_break (after.at t) (entry_bounds t).2.1
  by_cases eq : b=2
  · rw [eq] at factor
    exact Or.inr ⟨r,run,factor⟩
  · exact Or.inl (cut t r b run (by omega) factor IH)

end CollatzCharacterBridge.A2HalfAdaptive
