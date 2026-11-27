import OddMap

namespace CollatzCharacterBridge.ParametricCapture

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

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

/-- One exact physical pair, with its two exact exponents1 and2. -/
theorem pair_core (a : Nat) (ha : 0<a) :
    step (16*a-5)=24*a-7 ∧ step (24*a-7)=18*a-5 := by
  constructor
  · exact physical_step (a:=1) (by omega) (by omega)
  · exact physical_step (a:=2) (by omega) (by omega)

private theorem pair_reduce (r u : Nat) (hu : 0<u) :
    orbit (2^(3*(r+1)+1)*u-5) 2=2^(3*r+1)*(9*u)-5 := by
  let a := 2^(3*r)*u
  have ha : 0<a := Nat.mul_pos (Nat.pow_pos (by decide)) hu
  have hleft : 2^(3*(r+1)+1)*u=16*a := by
    rw [show 3*(r+1)+1=3*r+4 by omega,Nat.pow_add]
    simp only [show (2:Nat)^4=16 by decide,a]
    ac_rfl
  have hright : 2^(3*r+1)*(9*u)=18*a := by
    calc
      _ = (2*9)*a := by
        rw [Nat.pow_add]
        simp only [Nat.pow_one,a]
        ac_rfl
      _ = 18*a := by rfl
  have hp := pair_core a ha
  rw [hleft,hright]
  change step (step (16*a-5))=18*a-5
  rw [hp.1,hp.2]

/-- Arbitrarily many pairs, proved by induction rather than a list of
traces. The r=0 case allows truncation; every nonzero pair is physical. -/
theorem pair_prefix (r u : Nat) (hu : 0<u) :
    orbit (2^(3*r+1)*u-5) (2*r)=2*3^(2*r)*u-5 := by
  induction r generalizing u with
  | zero => rfl
  | succ r ih =>
    have htime :
        orbit (2^(3*(r+1)+1)*u-5) (2*(r+1))=
          orbit (orbit (2^(3*(r+1)+1)*u-5) 2) (2*r) :=
      (congrArg (orbit (2^(3*(r+1)+1)*u-5))
        (show 2*(r+1)=2+2*r by omega)).trans
        (orbit_add (2^(3*(r+1)+1)*u-5) 2 (2*r))
    calc
      _ = orbit (orbit (2^(3*(r+1)+1)*u-5) 2) (2*r) := htime
      _ = orbit (2^(3*r+1)*(9*u)-5) (2*r) := by rw [pair_reduce r u hu]
      _ = 2*3^(2*r)*(9*u)-5 := ih (9*u) (by omega)
      _ = _ := by
        have he : 2*3^(2*r)*(9*u)=2*3^(2*(r+1))*u := by
          rw [show 2*(r+1)=2*r+2 by omega,Nat.pow_add]
          simp only [show (3:Nat)^2=9 by decide]
          ac_rfl
        exact congrArg (fun n : Nat => n-5) he

def original (k q : Nat) : Nat := 2^(3*k+19)*q-5
def smaller (k q : Nat) : Nat := 2^(3*k+3)*3^10*q-5
def base (k q : Nat) : Nat := 2^(3*k)*q
def v (k q : Nat) : Nat := 3^(2*k+10)*q
def Condition (k q : Nat) : Prop := (3^(2*k+13)*q)%32=27
def X (k q : Nat) : Nat := 5+216*(v k q/32)
def Y (k q : Nat) : Nat := 1+54*(v k q/32)

private theorem base_pos (k q : Nat) (hq : 0<q) : 0<base k q := by
  exact Nat.mul_pos (Nat.pow_pos (by decide)) hq

private theorem original_product (k q : Nat) :
    2^(3*k+19)*q=524288*base k q := by
  rw [Nat.pow_add]
  simp only [show (2:Nat)^19=524288 by decide,base]
  ac_rfl

private theorem smaller_product (k q : Nat) :
    2^(3*k+3)*3^10*q=472392*base k q := by
  calc
    _ = (8*59049)*base k q := by
      rw [Nat.pow_add]
      simp only [show (2:Nat)^3=8 by decide,show (3:Nat)^10=59049 by decide,base]
      ac_rfl
    _ = 472392*base k q := by rfl

theorem source_admissible (k q : Nat) (hq : 0<q) :
    0<original k q ∧ original k q%2=1 ∧
    0<smaller k q ∧ smaller k q%2=1 ∧ smaller k q<original k q := by
  have hb := base_pos k q hq
  simp only [original,smaller,original_product,smaller_product]
  omega

theorem source_margin (k q : Nat) (hq : 0<q) :
    original k q=smaller k q+2^(3*k+3)*(2^16-3^10)*q := by
  have hb := base_pos k q hq
  have hm : 2^(3*k+3)*(2^16-3^10)*q=51896*base k q := by
    calc
      _ = (8*6487)*base k q := by
        rw [Nat.pow_add]
        simp only [show (2:Nat)^3=8 by decide,
          show (2:Nat)^16-(3:Nat)^10=6487 by decide,base]
        ac_rfl
      _ = 51896*base k q := by rfl
  simp only [original,smaller,original_product,smaller_product,hm]
  omega

private theorem power_v (k q : Nat) : 3^(2*k+13)*q=27*v k q := by
  rw [show 2*k+13=(2*k+10)+3 by omega,Nat.pow_add]
  simp only [show (3:Nat)^3=27 by decide,v]
  ac_rfl

private theorem cancel_27_mod (a : Nat) (h : (27*a)%32=27) : a%32=1 := by
  have hh : (19*(27*a))%32=1 := calc
    _ = ((19%32)*((27*a)%32))%32 := Nat.mul_mod _ _ _
    _ = ((19%32)*27)%32 := by rw [h]
    _ = 1 := by decide
  have he : 19*(27*a)=513*a := by omega
  rw [he,Nat.mul_mod] at hh
  simpa only [show (513:Nat)%32=1 by decide,Nat.one_mul,Nat.mod_mod] using hh

theorem v_mod (k q : Nat) (hc : Condition k q) : v k q%32=1 := by
  change (3^(2*k+13)*q)%32=27 at hc
  rw [power_v] at hc
  exact cancel_27_mod _ hc

private theorem original_pairs (k q : Nat) (hq : 0<q) :
    orbit (original k q) (2*k+12)=18*v k q-5 := by
  have hh := pair_prefix (k+6) q hq
  have hin : 2^(3*(k+6)+1)*q-5=original k q := by
    unfold original
    rw [show 3*(k+6)+1=3*k+19 by omega]
  have hout : 2*3^(2*(k+6))*q-5=18*v k q-5 := by
    have he : 2*3^(2*(k+6))*q=18*v k q := by
      calc
        _ = (2*9)*v k q := by
          rw [show 2*(k+6)=(2*k+10)+2 by omega,Nat.pow_add]
          simp only [show (3:Nat)^2=9 by decide,v]
          ac_rfl
        _ = 18*v k q := by rfl
    exact congrArg (fun n : Nat => n-5) he
  rw [hin,hout] at hh
  simpa only [show 2*(k+6)=2*k+12 by omega] using hh

private theorem smaller_pairs (k q : Nat) (hq : 0<q) :
    orbit (smaller k q) (2*k)=8*v k q-5 := by
  have hu : 0<4*3^10*q := by change 0<236196*q; omega
  have hh := pair_prefix k (4*3^10*q) hu
  have hin : 2^(3*k+1)*(4*3^10*q)-5=smaller k q := by
    unfold smaller
    have he : 2^(3*k+1)*(4*3^10*q)=2^(3*k+3)*3^10*q := by
      rw [show 3*k+3=(3*k+1)+2 by omega,Nat.pow_add 2 (3*k+1) 2]
      simp only [show (2:Nat)^2=4 by decide]
      ac_rfl
    exact congrArg (fun n : Nat => n-5) he
  have hout : 2*3^(2*k)*(4*3^10*q)-5=8*v k q-5 := by
    have he : 2*3^(2*k)*(4*3^10*q)=8*v k q := by
      calc
        _ = (2*4)*v k q := by simp only [v,Nat.pow_add]; ac_rfl
        _ = 8*v k q := by rfl
    exact congrArg (fun n : Nat => n-5) he
  rw [hin,hout] at hh
  exact hh

private theorem original_tail (a : Nat) (ha : a%32=1) :
    step (18*a-5)=5+216*(a/32) := by
  have hr : a=1+32*(a/32) := by omega
  exact physical_step (a:=3) (by omega) (by omega)

private theorem smaller_tail (a : Nat) (ha : a%32=1) :
    orbit (8*a-5) 3=1+54*(a/32) := by
  have hr : a=1+32*(a/32) := by omega
  have h1 : step (8*a-5)=5+384*(a/32) :=
    physical_step (a:=1) (by omega) (by omega)
  have h2 : step (5+384*(a/32))=1+72*(a/32) :=
    physical_step (a:=4) (by omega) (by omega)
  have h3 : step (1+72*(a/32))=1+54*(a/32) :=
    physical_step (a:=2) (by omega) (by omega)
  change step (step (step (8*a-5)))=1+54*(a/32)
  rw [h1,h2,h3]

theorem original_prefix (k q : Nat) (hq : 0<q) (hc : Condition k q) :
    orbit (original k q) (2*k+13)=X k q := by
  change step (orbit (original k q) (2*k+12))=X k q
  rw [original_pairs k q hq]
  exact original_tail _ (v_mod k q hc)

theorem smaller_prefix (k q : Nat) (hq : 0<q) (hc : Condition k q) :
    orbit (smaller k q) (2*k+3)=Y k q := by
  rw [orbit_add (smaller k q) (2*k) 3,smaller_pairs k q hq]
  exact smaller_tail _ (v_mod k q hc)

theorem endpoint_relation (k q : Nat) : X k q=4*Y k q+1 := by
  simp only [X,Y]
  omega

theorem endpoint_quotients (k q : Nat) (hc : Condition k q) :
    4*X k q+7=3^(2*k+13)*q ∧ 16*Y k q+11=3^(2*k+13)*q := by
  have hm := v_mod k q hc
  have hr : v k q=1+32*(v k q/32) := by omega
  have hp := power_v k q
  simp only [X,Y]
  omega

private theorem affine_meeting {x y : Nat} (hx : x=4*y+1) : step x=step y := by
  unfold step
  have hf : 3*x+1=4*(3*y+1) := by omega
  rw [hf,oddPart_quadruple]

theorem family_meeting (k q : Nat) (hq : 0<q) (hc : Condition k q) :
    orbit (original k q) (2*k+14)=orbit (smaller k q) (2*k+4) := by
  change step (orbit (original k q) (2*k+13))=step (orbit (smaller k q) (2*k+3))
  rw [original_prefix k q hq hc,smaller_prefix k q hq hc]
  exact affine_meeting (endpoint_relation k q)

private theorem original_unshifted (k q : Nat) (hq : 0<q) :
    original k q+5=2^(3*k+19)*q := by
  have hb := base_pos k q hq
  have hbound : 5≤2^(3*k+19)*q := by rw [original_product]; omega
  exact Nat.sub_add_cancel hbound

private theorem smaller_unshifted (k q : Nat) (hq : 0<q) :
    smaller k q+5=2^(3*k+3)*(3^10*q) := by
  have hb := base_pos k q hq
  have hbound : 5≤2^(3*k+3)*3^10*q := by rw [smaller_product]; omega
  have hh : smaller k q+5=2^(3*k+3)*3^10*q := Nat.sub_add_cancel hbound
  exact hh.trans (by ac_rfl)

private theorem balanced_book {n x a d p c q : Nat}
    (hn : n+5=a*q) (hx : p*x+c=d*q) :
    (a*p)*x+a*c=d*n+5*d := by
  calc
    _ = a*(p*x+c) := by simp only [Nat.mul_add]; ac_rfl
    _ = a*(d*q) := by rw [hx]
    _ = d*(a*q) := by ac_rfl
    _ = d*(n+5) := by rw [←hn]
    _ = _ := by simp only [Nat.mul_add]; ac_rfl

private theorem growth_budget (k A B : Nat) (h : B≤A) :
    B*2^(3*k)≤A*3^(2*k) := by
  have hh := Nat.mul_le_mul h (Nat.pow_le_pow_left (by decide : (8:Nat)≤9) k)
  simpa only [Nat.pow_mul,show (2:Nat)^3=8 by decide,
    show (3:Nat)^2=9 by decide] using hh

private theorem original_budget (k : Nat) :
    7*2^(3*k+19)≤5*3^(2*k+13) := by
  have hh := growth_budget k (5*3^13) (7*2^19) (by decide)
  calc
    _ = (7*2^19)*2^(3*k) := by rw [Nat.pow_add]; ac_rfl
    _ ≤ (5*3^13)*3^(2*k) := hh
    _ = _ := by rw [Nat.pow_add]; ac_rfl

private theorem smaller_budget (k : Nat) :
    11*2^(3*k+3)≤5*3^(2*k+3) := by
  have hh := growth_budget k (5*3^3) (11*2^3) (by decide)
  calc
    _ = (11*2^3)*2^(3*k) := by rw [Nat.pow_add]; ac_rfl
    _ ≤ (5*3^3)*3^(2*k) := hh
    _ = _ := by rw [Nat.pow_add]; ac_rfl

def originalCost (k : Nat) : Nat := 5*3^(2*k+13)-7*2^(3*k+19)
def smallerCost (k : Nat) : Nat := 5*3^(2*k+3)-11*2^(3*k+3)

theorem original_ledger (k q : Nat) (hq : 0<q) (hc : Condition k q) :
    2^(3*k+21)*X k q=3^(2*k+13)*original k q+originalCost k := by
  have hh := balanced_book (original_unshifted k q hq) (endpoint_quotients k q hc).1
  have hcoef : (2:Nat)^(3*k+19)*4=2^(3*k+21) := by
    rw [show 3*k+21=(3*k+19)+2 by omega,Nat.pow_add 2 (3*k+19) 2]
  rw [hcoef] at hh
  have hb := original_budget k
  unfold originalCost
  omega

theorem smaller_ledger (k q : Nat) (hq : 0<q) (hc : Condition k q) :
    2^(3*k+7)*Y k q=3^(2*k+3)*smaller k q+smallerCost k := by
  have hy : 16*Y k q+11=3^(2*k+3)*(3^10*q) := by
    have hh := (endpoint_quotients k q hc).2
    rw [show 2*k+13=(2*k+3)+10 by omega,Nat.pow_add] at hh
    exact hh.trans (by ac_rfl)
  have hh := balanced_book (smaller_unshifted k q hq) hy
  have hcoef : (2:Nat)^(3*k+3)*16=2^(3*k+7) := by
    rw [show 3*k+7=(3*k+3)+4 by omega,Nat.pow_add 2 (3*k+3) 4]
  rw [hcoef] at hh
  have hb := smaller_budget k
  unfold smallerCost
  omega

theorem capture_contract (k q : Nat) (hq : 0<q) (hc : Condition k q) :
    0<original k q ∧ original k q%2=1 ∧
    0<smaller k q ∧ smaller k q%2=1 ∧ smaller k q<original k q ∧
    orbit (original k q) (2*k+13)=X k q ∧
    orbit (smaller k q) (2*k+3)=Y k q ∧ X k q=4*Y k q+1 ∧
    orbit (original k q) (2*k+14)=orbit (smaller k q) (2*k+4) ∧
    2^(3*k+21)*X k q=3^(2*k+13)*original k q+originalCost k ∧
    2^(3*k+7)*Y k q=3^(2*k+3)*smaller k q+smallerCost k := by
  have ha := source_admissible k q hq
  exact ⟨ha.1,ha.2.1,ha.2.2.1,ha.2.2.2.1,ha.2.2.2.2,
    original_prefix k q hq hc,smaller_prefix k q hq hc,endpoint_relation k q,
    family_meeting k q hq hc,original_ledger k q hq hc,smaller_ledger k q hq hc⟩

private theorem one_orbit (j : Nat) : orbit 1 j=1 := by
  induction j with
  | zero => rfl
  | succ j ih =>
    change step (orbit 1 j)=1
    rw [ih]
    exact physical_step (a:=2) (by decide) (by decide)

theorem closes_under_IH (k q : Nat) (hq : 0<q) (hc : Condition k q)
    (IH : ∀ w : Nat, 0<w → w%2=1 → w<original k q → ∃ j, orbit w j=1) :
    ∃ j, orbit (original k q) j=1 := by
  have ha := source_admissible k q hq
  obtain ⟨j,hj⟩ := IH (smaller k q) ha.2.2.1 ha.2.2.2.1 ha.2.2.2.2
  refine ⟨(2*k+14)+j,?_⟩
  rw [orbit_add (original k q) (2*k+14) j,family_meeting k q hq hc,
    ←orbit_add (smaller k q) (2*k+4) j,show (2*k+4)+j=j+(2*k+4) by omega,
    orbit_add (smaller k q) j (2*k+4),hj,one_orbit]

/-- Public M formulation; all subtraction side conditions are discharged
by M>=6 through k=M-6. -/
theorem m_capture (M q : Nat) (hM : 6≤M) (hq : 0<q)
    (hc : (3^(2*M+1)*q)%32=27) :
    let N := 2^(3*M+1)*q-5
    let w := 2^(3*M-15)*3^10*q-5
    0<w ∧ w%2=1 ∧ w<N ∧ orbit N (2*M+2)=orbit w (2*M-8) := by
  let k := M-6
  have hk : M=k+6 := by dsimp only [k]; omega
  have hcond : Condition k q := by
    unfold Condition
    rw [show 2*k+13=2*M+1 by omega]
    exact hc
  have ha := source_admissible k q hq
  have hm := family_meeting k q hq hcond
  have hn : original k q=2^(3*M+1)*q-5 := by
    unfold original
    rw [show 3*k+19=3*M+1 by omega]
  have hw : smaller k q=2^(3*M-15)*3^10*q-5 := by
    unfold smaller
    rw [show 3*k+3=3*M-15 by omega]
  rw [hn,hw] at ha hm
  rw [show 2*k+14=2*M+2 by omega,show 2*k+4=2*M-8 by omega] at hm
  exact ⟨ha.2.2.1,ha.2.2.2.1,ha.2.2.2.2,hm⟩

theorem m_closes_under_IH (M q : Nat) (hM : 6≤M) (hq : 0<q)
    (hc : (3^(2*M+1)*q)%32=27)
    (IH : ∀ w : Nat, 0<w → w%2=1 → w<2^(3*M+1)*q-5 → ∃ j, orbit w j=1) :
    ∃ j, orbit (2^(3*M+1)*q-5) j=1 := by
  let k := M-6
  have hk : M=k+6 := by dsimp only [k]; omega
  have hn : original k q=2^(3*M+1)*q-5 := by
    unfold original
    rw [show 3*k+19=3*M+1 by omega]
  have hcond : Condition k q := by
    unfold Condition
    rw [show 2*k+13=2*M+1 by omega]
    exact hc
  have hi : ∀ w : Nat, 0<w → w%2=1 → w<original k q → ∃ j, orbit w j=1 := by
    rw [hn]
    exact IH
  have hh := closes_under_IH k q hq hcond hi
  rw [hn] at hh
  exact hh


#print axioms strip_pow
#print axioms physical_step
#print axioms pair_core
#print axioms pair_reduce
#print axioms pair_prefix
#print axioms base_pos
#print axioms original_product
#print axioms smaller_product
#print axioms source_admissible
#print axioms source_margin
#print axioms power_v
#print axioms cancel_27_mod
#print axioms v_mod
#print axioms original_pairs
#print axioms smaller_pairs
#print axioms original_tail
#print axioms smaller_tail
#print axioms original_prefix
#print axioms smaller_prefix
#print axioms endpoint_relation
#print axioms endpoint_quotients
#print axioms affine_meeting
#print axioms family_meeting
#print axioms original_unshifted
#print axioms smaller_unshifted
#print axioms balanced_book
#print axioms growth_budget
#print axioms original_budget
#print axioms smaller_budget
#print axioms original_ledger
#print axioms smaller_ledger
#print axioms capture_contract
#print axioms one_orbit
#print axioms closes_under_IH
#print axioms m_capture
#print axioms m_closes_under_IH

end CollatzCharacterBridge.ParametricCapture
