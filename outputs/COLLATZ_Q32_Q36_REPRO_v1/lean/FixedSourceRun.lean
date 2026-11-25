import OddMap

namespace CollatzCharacterBridge.FixedSourceRun

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

def Ones (x r : Nat) : Prop :=
  ∀ i : Nat, i<r → 3*orbit x i+1=2*orbit x (i+1)

def initial (k u : Nat) : Nat := 2^(k+3)*u-1
def source (k u : Nat) : Nat := 3*2^(k+1)*u-1
def terminal (k u : Nat) : Nat := 2*3^(k+2)*u-1
def sourceCheckpoint (k u : Nat) : Nat := 2*3^(k+1)*u-1
def quarter (k u : Nat) : Nat := (terminal k u-1)/4

private theorem strip_pow (a y : Nat) : oddPart (2^a*y)=oddPart y := by
  induction a with
  | zero => simp
  | succ a ih =>
    rw [Nat.pow_succ]
    have he : 2^a*2*y=2*(2^a*y) := by ac_rfl
    rw [he,oddPart_double,ih]

private theorem physical_step {x a y : Nat} (ho : y%2=1)
    (hf : 3*x+1=2^a*y) : step x=y := by
  unfold step
  rw [hf,strip_pow,oddPart_of_odd ho]

private theorem odd_head (x i : Nat) : orbit x (i+1)=orbit (step x) i :=
  (congrArg (orbit x) (show i+1=1+i by omega)).trans (orbit_add x 1 i)

private theorem one_core (a : Nat) (ha : 0<a) :
    step (4*a-1)=6*a-1 ∧ 3*(4*a-1)+1=2*(6*a-1) := by
  exact ⟨physical_step (a:=1) (by omega) (by omega),by omega⟩

/-- Physical finite run, with no upper bound on r. Its terminal may have
further valuation-one steps when u is even. -/
theorem ones_prefix (r u : Nat) (hu : 0<u) :
    orbit (2^(r+1)*u-1) r=2*3^r*u-1 ∧ Ones (2^(r+1)*u-1) r := by
  induction r generalizing u with
  | zero =>
    constructor
    · simp only [orbit,Nat.pow_zero,Nat.pow_one,Nat.mul_one]
    · intro i hi; omega
  | succ r ih =>
    let a := 2^r*u
    have ha : 0<a := Nat.mul_pos (Nat.pow_pos (by decide)) hu
    have hx : 2^(r+1+1)*u=4*a := by
      rw [show r+1+1=r+2 by omega,Nat.pow_add 2 r 2]
      change (2^r*4)*u=4*(2^r*u)
      ac_rfl
    have hy : 2^(r+1)*(3*u)=6*a := by
      rw [Nat.pow_succ]
      change (2^r*2)*(3*u)=(2*3)*(2^r*u)
      ac_rfl
    have hf := one_core a ha
    have hstep : step (2^(r+1+1)*u-1)=2^(r+1)*(3*u)-1 := by
      rw [hx,hy]
      exact hf.1
    have hfactor : 3*(2^(r+1+1)*u-1)+1=2*(2^(r+1)*(3*u)-1) := by
      rw [hx,hy]
      exact hf.2
    have hi := ih (3*u) (by omega)
    constructor
    · rw [odd_head,hstep,hi.1]
      have hp : 2*3^r*(3*u)=2*3^(r+1)*u := by rw [Nat.pow_succ]; ac_rfl
      rw [hp]
    · intro i hb
      cases i with
      | zero =>
        change 3*(2^(r+1+1)*u-1)+1=2*step (2^(r+1+1)*u-1)
        rw [hstep]
        exact hfactor
      | succ i =>
        rw [odd_head (2^(r+1+1)*u-1) i,
          odd_head (2^(r+1+1)*u-1) (i+1),hstep]
        exact hi.2 i (by omega)

theorem ones_balanced (x r : Nat) (h : Ones x r) :
    2^r*(orbit x r+1)=3^r*(x+1) := by
  induction r with
  | zero => simp only [orbit,Nat.pow_zero,Nat.one_mul]
  | succ r ih =>
    have hi := ih (fun i hb => h i (by omega))
    have he := h r (by omega)
    have ht : 2*(orbit x (r+1)+1)=3*(orbit x r+1) := by omega
    calc
      _ = 2^r*(2*(orbit x (r+1)+1)) := by rw [Nat.pow_succ]; ac_rfl
      _ = 2^r*(3*(orbit x r+1)) := by rw [ht]
      _ = 3*(2^r*(orbit x r+1)) := by ac_rfl
      _ = 3*(3^r*(x+1)) := by rw [hi]
      _ = _ := by rw [Nat.pow_succ]; ac_rfl

private theorem cancel_three (r x v : Nat) (h : 3*x=2^r*v) :
    ∃ u : Nat, x=2^r*u := by
  induction r generalizing x v with
  | zero => exact ⟨x,by simp⟩
  | succ r ih =>
    have he : 3*x=2*(2^r*v) := by rw [h,Nat.pow_succ]; ac_rfl
    have hx : x=2*(x/2) := by omega
    have hh : 3*(x/2)=2^r*v := by
      apply Nat.mul_left_cancel (by decide : 0<2)
      calc
        _ = 3*(2*(x/2)) := by ac_rfl
        _ = 3*x := congrArg (fun q : Nat => 3*q) hx.symm
        _ = _ := he
    obtain ⟨u,hu⟩ := ih (x/2) v hh
    refine ⟨u,?_⟩
    rw [hx,hu,Nat.pow_succ]
    ac_rfl

private theorem cancel_three_power (r a x v : Nat) (h : 3^a*x=2^r*v) :
    ∃ u : Nat, x=2^r*u := by
  induction a generalizing x v with
  | zero => exact ⟨v,by simpa only [Nat.pow_zero,Nat.one_mul] using h⟩
  | succ a ih =>
    have he : 3*(3^a*x)=2^r*v := by
      calc
        _ = 3^(a+1)*x := by rw [Nat.pow_succ]; ac_rfl
        _ = _ := h
    obtain ⟨y,hy⟩ := cancel_three r (3^a*x) v he
    exact ih x y hy

/-- Reconstruction from the actual physical run and terminal phase.
The odd cofactor is derived, never assumed as a population hypothesis. -/
theorem real_run_parameters (x r : Nat) (h : Ones x r)
    (hp : orbit x r%8=5) :
    ∃ u : Nat, 0<u ∧ u%2=1 ∧ x+1=2^(r+1)*u ∧
      orbit x r+1=2*(3^r*u) := by
  have hb := ones_balanced x r h
  have hz : orbit x r+1=2*((orbit x r+1)/2) := by omega
  have hd : 3^r*(x+1)=2^(r+1)*((orbit x r+1)/2) := by
    calc
      _ = 2^r*(orbit x r+1) := hb.symm
      _ = 2^r*(2*((orbit x r+1)/2)) := congrArg (fun a : Nat => 2^r*a) hz
      _ = _ := by rw [Nat.pow_succ]; ac_rfl
  obtain ⟨u,hu⟩ := cancel_three_power (r+1) r (x+1) ((orbit x r+1)/2) hd
  have hup : 0<u := by
    by_cases hn : 0<u
    · exact hn
    · have he : u=0 := by omega
      rw [he,Nat.mul_zero] at hu
      omega
  have hze : orbit x r+1=2*(3^r*u) := by
    apply Nat.mul_left_cancel (Nat.pow_pos (by decide) : 0<2^r)
    calc
      _ = 3^r*(x+1) := hb
      _ = 3^r*(2^(r+1)*u) := by rw [hu]
      _ = _ := by rw [Nat.pow_succ]; ac_rfl
  have hoddProduct : (3^r*u)%2=1 := by omega
  have hoddPower : 3^r%2=1 := by simp [Nat.pow_mod]
  have hm := Nat.mul_mod (3^r) u 2
  rw [hoddPower] at hm
  have huo : u%2=1 := by simpa only [Nat.one_mul,Nat.mod_mod,hoddProduct] using hm.symm
  exact ⟨u,hup,huo,hu,hze⟩

theorem phase_from_real_break (z b R : Nat) (hb : 3≤b)
    (hf : 3*z+1=2^b*R) : z%8=5 := by
  have he : 2^b*R=8*(2^(b-3)*R) := by
    rw [show b=(b-3)+3 by omega,Nat.pow_add 2 (b-3) 3]
    change (2^(b-3)*8)*R=8*(2^(b-3)*R)
    ac_rfl
  rw [he] at hf
  omega

private theorem initial_scale (k u : Nat) : 2^(k+3)*u=8*(2^k*u) := by
  rw [Nat.pow_add 2 k 3]
  change (2^k*8)*u=8*(2^k*u)
  ac_rfl

private theorem source_scale (k u : Nat) : 3*2^(k+1)*u=6*(2^k*u) := by
  rw [Nat.pow_succ]
  change 3*(2^k*2)*u=(3*2)*(2^k*u)
  ac_rfl

theorem fixed_source (k u : Nat) (hu : 0<u) :
    0<initial k u ∧ initial k u%2=1 ∧
    0<source k u ∧ source k u%2=1 ∧
    4*source k u+1=3*initial k u ∧
    source k u=(3*initial k u-1)/4 := by
  have ha : 0<2^k*u := Nat.mul_pos (Nat.pow_pos (by decide)) hu
  simp only [initial,source,initial_scale,source_scale]
  omega

theorem source_paid (N k u : Nat) (hu : 0<u)
    (hN : 3*initial k u-1<4*N) : source k u<N := by
  have hh := fixed_source k u hu
  have he := hh.2.2.2.2.1
  omega

theorem original_run (k u : Nat) (hu : 0<u) :
    orbit (initial k u) (k+2)=terminal k u ∧ Ones (initial k u) (k+2) := by
  have hh := ones_prefix (k+2) u hu
  simpa only [show k+2+1=k+3 by omega,initial,terminal] using hh

theorem source_run (k u : Nat) (hu : 0<u) :
    orbit (source k u) k=sourceCheckpoint k u ∧ Ones (source k u) k := by
  have hh := ones_prefix k (3*u) (by omega)
  have hin : 2^(k+1)*(3*u)-1=source k u := by
    unfold source
    congr 1
    ac_rfl
  have hout : 2*3^k*(3*u)-1=sourceCheckpoint k u := by
    unfold sourceCheckpoint
    congr 1
    rw [Nat.pow_succ]
    ac_rfl
  rw [hin,hout] at hh
  exact hh

theorem checkpoint_relation (k u : Nat) (hu : 0<u) :
    terminal k u=3*sourceCheckpoint k u+2 := by
  have hp : 0<3^(k+1)*u := Nat.mul_pos (Nat.pow_pos (by decide)) hu
  have he : 2*3^(k+2)*u=3*(2*3^(k+1)*u) := by
    rw [show k+2=(k+1)+1 by omega,Nat.pow_succ]
    ac_rfl
  let a := 3^(k+1)*u
  have ha : 0<a := hp
  have h1 : 2*3^(k+2)*u=6*a := by
    calc
      _ = 3*(2*3^(k+1)*u) := he
      _ = (3*2)*(3^(k+1)*u) := by ac_rfl
      _ = _ := by rfl
  have h2 : 2*3^(k+1)*u=2*a := by dsimp only [a]; ac_rfl
  simp only [terminal,sourceCheckpoint,h1,h2]
  omega

theorem exact_changed_edges (k u b R : Nat) (hu : 0<u) (hb : 3≤b)
    (hR : R%2=1) (hf : 3*terminal k u+1=2^b*R) :
    0<quarter k u ∧ quarter k u%2=1 ∧
    3*sourceCheckpoint k u+1=2^2*quarter k u ∧
    3*quarter k u+1=2^(b-2)*R ∧
    step (sourceCheckpoint k u)=quarter k u ∧ step (quarter k u)=R := by
  have hp := phase_from_real_break (terminal k u) b R hb hf
  have hz := checkpoint_relation k u hu
  have hq : 0<quarter k u ∧ quarter k u%2=1 ∧
      3*sourceCheckpoint k u+1=4*quarter k u := by
    simp only [quarter]
    omega
  have he : 2^b*R=4*(2^(b-2)*R) := by
    rw [show b=(b-2)+2 by omega,Nat.pow_add 2 (b-2) 2]
    change (2^(b-2)*4)*R=4*(2^(b-2)*R)
    ac_rfl
  have hlast : 3*quarter k u+1=2^(b-2)*R := by
    apply Nat.mul_left_cancel (by decide : 0<4)
    have hquarter : 4*quarter k u=terminal k u-1 := by simp only [quarter]; omega
    calc
      _ = 3*terminal k u+1 := by omega
      _ = 2^b*R := hf
      _ = _ := he
  exact ⟨hq.1,hq.2.1,hq.2.2,hlast,
    physical_step (a:=2) hq.2.1 hq.2.2,physical_step hR hlast⟩

theorem parameter_meeting (k u b R : Nat) (hu : 0<u) (hb : 3≤b)
    (hR : R%2=1) (hf : 3*terminal k u+1=2^b*R) :
    orbit (initial k u) (k+3)=R ∧ orbit (source k u) (k+2)=R := by
  have he := exact_changed_edges k u b R hu hb hR hf
  constructor
  · change step (orbit (initial k u) (k+2))=R
    rw [(original_run k u hu).1]
    exact physical_step hR hf
  · rw [orbit_add (source k u) k 2,(source_run k u hu).1]
    change step (step (sourceCheckpoint k u))=R
    rw [he.2.2.2.2.1,he.2.2.2.2.2]

private theorem append_break_balanced {a d z x e R : Nat}
    (hb : a*(z+1)=d*(x+1)) (hf : 3*z+1=e*R) :
    (a*e)*R+2*a=(3*d)*(x+1) := by
  have hfirst : (a*e)*R=a*(3*z+1) := by rw [hf]; ac_rfl
  have hmiddle : a*(3*z+1)+2*a=3*(a*(z+1)) := by
    simp only [Nat.mul_add,Nat.mul_one]
    have hm : a*(3*z)=3*(a*z) := by ac_rfl
    rw [hm]
    omega
  calc
    _ = a*(3*z+1)+2*a := by rw [hfirst]
    _ = 3*(a*(z+1)) := hmiddle
    _ = 3*(d*(x+1)) := by rw [hb]
    _ = _ := by ac_rfl

theorem original_ledger (k u b R : Nat) (hu : 0<u)
    (hf : 3*terminal k u+1=2^b*R) :
    2^(k+2+b)*R=3^(k+3)*initial k u+(3^(k+3)-2^(k+3)) := by
  have hr := original_run k u hu
  have hb := ones_balanced (initial k u) (k+2) hr.2
  rw [hr.1] at hb
  have hh := append_break_balanced hb hf
  have h2 : 2^(k+2)*2^b=2^(k+2+b) := (Nat.pow_add 2 (k+2) b).symm
  have h3 : 3*3^(k+2)=3^(k+3) := by
    calc
      _ = 3^(k+2)*3 := Nat.mul_comm _ _
      _ = 3^((k+2)+1) := (Nat.pow_succ 3 (k+2)).symm
      _ = _ := by rw [show (k+2)+1=k+3 by omega]
  have h22 : 2*2^(k+2)=2^(k+3) := by
    calc
      _ = 2^(k+2)*2 := Nat.mul_comm _ _
      _ = 2^((k+2)+1) := (Nat.pow_succ 2 (k+2)).symm
      _ = _ := by rw [show (k+2)+1=k+3 by omega]
  rw [h2,h3,h22] at hh
  have hle : 2^(k+3)≤3^(k+3) := Nat.pow_le_pow_left (by decide) (k+3)
  simp only [Nat.mul_add,Nat.mul_one] at hh
  omega

theorem source_ledger (k u b R : Nat) (hu : 0<u)
    (hf : 3*terminal k u+1=2^b*R) :
    2^(k+b)*R=3^(k+2)*source k u+(3^(k+2)-2^(k+1)) := by
  have hr := source_run k u hu
  have hb := ones_balanced (source k u) k hr.2
  rw [hr.1] at hb
  have hz := checkpoint_relation k u hu
  have ht : 2^b*R+2=9*(sourceCheckpoint k u+1) := by omega
  have hh : 2^(k+b)*R+2^(k+1)=3^(k+2)*(source k u+1) := by
    calc
      _ = 2^k*(2^b*R+2) := by
        rw [Nat.pow_add 2 k b,Nat.pow_succ]
        simp only [Nat.mul_add]
        ac_rfl
      _ = 2^k*(9*(sourceCheckpoint k u+1)) := by rw [ht]
      _ = 9*(2^k*(sourceCheckpoint k u+1)) := by ac_rfl
      _ = 9*(3^k*(source k u+1)) := by rw [hb]
      _ = _ := by
        rw [Nat.pow_add 3 k 2]
        change 9*(3^k*(source k u+1))=(3^k*9)*(source k u+1)
        ac_rfl
  have hle : 2^(k+1)≤3^(k+2) := Nat.le_trans
    (Nat.pow_le_pow_left (by decide) (k+1))
    (Nat.pow_le_pow_right (by decide : 0<3) (by omega : k+1≤k+2))
  simp only [Nat.mul_add,Nat.mul_one] at hh
  omega

/-- Exact composition with arbitrary prior history; the source book is
not substituted for the original N book. -/
theorem history_transport {N x R S j L a B D : Nat}
    (hN : 2^S*x=3^j*N+B) (hx : 2^L*R=3^a*x+D) :
    2^(S+L)*R=3^(j+a)*N+3^a*B+2^S*D := by
  calc
    _ = 2^S*(2^L*R) := by rw [Nat.pow_add 2 S L]; ac_rfl
    _ = 2^S*(3^a*x+D) := by rw [hx]
    _ = 3^a*(2^S*x)+2^S*D := by simp only [Nat.mul_add]; ac_rfl
    _ = 3^a*(3^j*N+B)+2^S*D := by rw [hN]
    _ = _ := by rw [Nat.pow_add 3 j a]; simp only [Nat.mul_add]; ac_rfl

theorem parameter_history (N k u b R S j B : Nat) (hu : 0<u)
    (hN : 2^S*initial k u=3^j*N+B)
    (hf : 3*terminal k u+1=2^b*R) :
    2^(S+(k+2)+b)*R=3^(j+k+3)*N+
      3^(k+3)*B+2^S*(3^(k+3)-2^(k+3)) := by
  have hh := history_transport hN (original_ledger k u b R hu hf)
  simpa only [Nat.add_assoc] using hh

/-- The adaptive capture consumes a real run and a real rupture on the
same orbit. There is no fixed maximum for k or assumed future suffix. -/
theorem adaptive_capture (N x j k b : Nat) (_hx : 0<x) (hodd : x%2=1)
    (hp : orbit N j=x) (hr : Ones x (k+2)) (hb : 3≤b)
    (hf : 3*orbit x (k+2)+1=2^b*orbit x (k+3))
    (hN : 3*x-1<4*N) :
    let w := (3*x-1)/4
    let R := orbit N (j+k+3)
    0<w ∧ w%2=1 ∧ w<N ∧ orbit w (k+2)=R ∧
    2^(k+2+b)*R=3^(k+3)*x+(3^(k+3)-2^(k+3)) ∧
    2^(k+b)*R=3^(k+2)*w+(3^(k+2)-2^(k+1)) := by
  have hphase := phase_from_real_break _ b _ hb hf
  obtain ⟨u,hu,_huodd,hxu,_hzu⟩ := real_run_parameters x (k+2) hr hphase
  have hxi : x=initial k u := by
    unfold initial
    rw [show k+2+1=k+3 by omega] at hxu
    omega
  have hzt : orbit x (k+2)=terminal k u := by rw [hxi]; exact (original_run k u hu).1
  have hfixed := fixed_source k u hu
  have hw : source k u=(3*x-1)/4 := by rw [hxi]; exact hfixed.2.2.2.2.2
  have hpaid : source k u<N := source_paid N k u hu (by rw [←hxi]; exact hN)
  have hR : orbit x (k+3)%2=1 := orbit_odd x hodd (k+3)
  have hfb : 3*terminal k u+1=2^b*orbit x (k+3) := by rw [←hzt]; exact hf
  have hm := parameter_meeting k u b (orbit x (k+3)) hu hb hR hfb
  have htime : orbit N (j+k+3)=orbit x (k+3) := by
    rw [show j+k+3=j+(k+3) by omega,orbit_add N j (k+3),hp]
  have hol := original_ledger k u b (orbit x (k+3)) hu hfb
  have hwl := source_ledger k u b (orbit x (k+3)) hu hfb
  rw [←hxi] at hol
  rw [hw] at hm hwl hpaid
  dsimp only
  rw [htime]
  exact ⟨by rw [←hw]; exact hfixed.2.2.1,
    by rw [←hw]; exact hfixed.2.2.2.1,hpaid,hm.2,hol,hwl⟩

theorem adaptive_history (N x j k b S B : Nat) (hx : 0<x) (hodd : x%2=1)
    (hp : orbit N j=x) (hr : Ones x (k+2)) (hb : 3≤b)
    (hf : 3*orbit x (k+2)+1=2^b*orbit x (k+3))
    (hN : 3*x-1<4*N) (hbook : 2^S*x=3^j*N+B) :
    2^(S+(k+2)+b)*orbit N (j+k+3)=3^(j+k+3)*N+
      3^(k+3)*B+2^S*(3^(k+3)-2^(k+3)) := by
  have hc := adaptive_capture N x j k b hx hodd hp hr hb hf hN
  have hh := history_transport hbook hc.2.2.2.2.1
  simpa only [Nat.add_assoc] using hh

private theorem one_orbit (i : Nat) : orbit 1 i=1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i)=1
    rw [ih]
    exact physical_step (a:=2) (by decide) (by decide)

theorem closes_under_IH (N x j k b : Nat) (hx : 0<x) (hodd : x%2=1)
    (hp : orbit N j=x) (hr : Ones x (k+2)) (hb : 3≤b)
    (hf : 3*orbit x (k+2)+1=2^b*orbit x (k+3))
    (hN : 3*x-1<4*N)
    (IH : ∀ w : Nat, 0<w → w%2=1 → w<N → ∃ i, orbit w i=1) :
    ∃ i, orbit N i=1 := by
  have hc := adaptive_capture N x j k b hx hodd hp hr hb hf hN
  obtain ⟨i,hi⟩ := IH ((3*x-1)/4) hc.1 hc.2.1 hc.2.2.1
  refine ⟨(j+k+3)+i,?_⟩
  rw [orbit_add N (j+k+3) i,←hc.2.2.2.1,
    ←orbit_add ((3*x-1)/4) (k+2) i,
    show (k+2)+i=i+(k+2) by omega,
    orbit_add ((3*x-1)/4) i (k+2),hi,one_orbit]

#print axioms strip_pow
#print axioms physical_step
#print axioms odd_head
#print axioms one_core
#print axioms ones_prefix
#print axioms ones_balanced
#print axioms cancel_three
#print axioms cancel_three_power
#print axioms real_run_parameters
#print axioms phase_from_real_break
#print axioms initial_scale
#print axioms source_scale
#print axioms fixed_source
#print axioms source_paid
#print axioms original_run
#print axioms source_run
#print axioms checkpoint_relation
#print axioms exact_changed_edges
#print axioms parameter_meeting
#print axioms append_break_balanced
#print axioms original_ledger
#print axioms source_ledger
#print axioms history_transport
#print axioms parameter_history
#print axioms adaptive_capture
#print axioms adaptive_history
#print axioms one_orbit
#print axioms closes_under_IH

end CollatzCharacterBridge.FixedSourceRun
