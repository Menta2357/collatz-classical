import ParametricCapture

namespace CollatzCharacterBridge.A2Header

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

/-- A clock certified by exact positive odd physical edges. It carries
the number of odd returns and the sum of the real valuations. -/
inductive Physical : Nat → Nat → Nat → Nat → Prop where
  | refl (x : Nat) : Physical x 0 0 x
  | edge {x a y : Nat} (hx : 0<x) (hxo : x%2=1)
      (hy : 0<y) (hyo : y%2=1) (ha : 0<a) (hf : 3*x+1=2^a*y) :
      Physical x 1 a y
  | append {x y z k s l t : Nat}
      (p : Physical x k s y) (q : Physical y l t z) : Physical x (k+l) (s+t) z

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

theorem physical_endpoint {x k s y : Nat} (p : Physical x k s y) : orbit x k=y := by
  induction p with
  | refl _ => rfl
  | edge _ _ _ hyo _ hf => exact physical_step hyo hf
  | append _ _ ihp ihq =>
    rw [orbit_add,ihp]
    exact ihq

theorem physical_pair (a : Nat) (ha : 0<a) : Physical (16*a-5) 2 3 (18*a-5) := by
  have hp : Physical (16*a-5) 1 1 (24*a-7) :=
    Physical.edge (by omega) (by omega) (by omega) (by omega) (by decide) (by omega)
  have hq : Physical (24*a-7) 1 2 (18*a-5) :=
    Physical.edge (by omega) (by omega) (by omega) (by omega) (by decide) (by omega)
  exact Physical.append hp hq

/-- The physical 1,2 pairs are certified inductively; no list of 42
states or inference of a clock from a final affine equality is used. -/
theorem pairs_physical (r u : Nat) (hu : 0<u) :
    Physical (2^(3*r+1)*u-5) (2*r) (3*r) (2*3^(2*r)*u-5) := by
  induction r generalizing u with
  | zero =>
    simpa only [Nat.mul_zero,Nat.zero_add,Nat.pow_zero,Nat.pow_one,Nat.mul_one]
      using Physical.refl (2*u-5)
  | succ r ih =>
    let a := 2^(3*r)*u
    have ha : 0<a := Nat.mul_pos (Nat.pow_pos (by decide)) hu
    have hleft : 2^(3*(r+1)+1)*u=16*a := by
      rw [show 3*(r+1)+1=3*r+4 by omega,Nat.pow_add 2 (3*r) 4]
      change (2^(3*r)*16)*u=16*(2^(3*r)*u)
      ac_rfl
    have hmid : 18*a=2^(3*r+1)*(9*u) := by
      calc
        _ = (2*9)*a := by rfl
        _ = _ := by
          rw [Nat.pow_add 2 (3*r) 1]
          simp only [Nat.pow_one,a]
          ac_rfl
    have hout : 2*3^(2*r)*(9*u)=2*3^(2*(r+1))*u := by
      rw [show 2*(r+1)=2*r+2 by omega,Nat.pow_add 3 (2*r) 2]
      change 2*3^(2*r)*(9*u)=2*(3^(2*r)*9)*u
      ac_rfl
    have hp := physical_pair a ha
    rw [hmid] at hp
    have ht := Physical.append hp (ih (9*u) (by omega))
    rw [←hleft,hout,show 2+2*r=2*(r+1) by omega,
      show 3+3*r=3*(r+1) by omega] at ht
    exact ht

def cofactor (t : Nat) : Nat := 49+128*t
def seed (t : Nat) : Nat := 2^64*cofactor t-5
def X42 (t : Nat) : Nat := 2*3^42*cofactor t-5
def X43 (t : Nat) : Nat := (3^43*49-7)/4+32*3^43*t
def X44 (t : Nat) : Nat := (3^44*49-17)/16+8*3^44*t
def U (t : Nat) : Nat := (3^45*49-35)/64+2*3^45*t
def B45 : Nat := 14125927490174334186655

theorem cofactor_residue (t : Nat) : cofactor t%128=49 := by simp only [cofactor]; omega

theorem seed_admissible (t : Nat) : 21≤seed t ∧ seed t%2=1 := by
  simp only [seed,cofactor]
  omega

theorem endpoint_admissible (t : Nat) : 0<U t ∧ U t%2=1 := by simp only [U]; omega

theorem endpoint_formula (t : Nat) : U t=(3^45*cofactor t-35)/64 := by
  simp only [U,cofactor]
  omega

theorem exact_tail_factors (t : Nat) :
    3*X42 t+1=2^3*X43 t ∧ 3*X43 t+1=2^2*X44 t ∧
    3*X44 t+1=2^2*U t := by
  simp only [X42,X43,X44,U,cofactor]
  omega

theorem tail_physical (t : Nat) : Physical (X42 t) 3 7 (U t) := by
  have h1 : Physical (X42 t) 1 3 (X43 t) := by
    apply Physical.edge
    all_goals
      try simp only [X42,X43,cofactor]
      omega
  have h2 : Physical (X43 t) 1 2 (X44 t) := by
    apply Physical.edge
    all_goals
      try simp only [X43,X44]
      omega
  have h3 : Physical (X44 t) 1 2 (U t) := by
    apply Physical.edge
    all_goals
      try simp only [X44,U]
      omega
  exact Physical.append (Physical.append h1 h2) h3

theorem prefix42 (t : Nat) : orbit (seed t) 42=X42 t := by
  exact ParametricCapture.pair_prefix 21 (cofactor t) (by simp only [cofactor]; omega)

theorem prefix45 (t : Nat) : orbit (seed t) 45=U t := by
  rw [show (45:Nat)=42+3 by decide,orbit_add (seed t) 42 3,prefix42]
  exact physical_endpoint (tail_physical t)

theorem tail_actual_factors (t : Nat) :
    3*orbit (seed t) 42+1=2^3*orbit (seed t) 43 ∧
    3*orbit (seed t) 43+1=2^2*orbit (seed t) 44 ∧
    3*orbit (seed t) 44+1=2^2*orbit (seed t) 45 := by
  have hf := exact_tail_factors t
  have h1 : step (X42 t)=X43 t :=
    physical_step (a:=3) (by simp only [X43]; omega) hf.1
  have h2 : step (X43 t)=X44 t :=
    physical_step (a:=2) (by simp only [X44]; omega) hf.2.1
  have h43 : orbit (seed t) 43=X43 t := by
    change step (orbit (seed t) 42)=X43 t
    rw [prefix42,h1]
  have h44 : orbit (seed t) 44=X44 t := by
    change step (orbit (seed t) 43)=X44 t
    rw [h43,h2]
  rw [prefix42,h43,h44,prefix45]
  exact hf

theorem header_physical (t : Nat) : Physical (seed t) 45 70 (U t) := by
  have hp := pairs_physical 21 (cofactor t) (by simp only [cofactor]; omega)
  exact Physical.append hp (tail_physical t)

theorem cost_formula :
    B45=5*3^45-35*2^64 ∧ 35*2^64≤5*3^45 := by decide

theorem original_ledger (t : Nat) : 2^70*U t=3^45*seed t+B45 := by
  simp only [U,seed,cofactor,B45]
  omega

theorem sharp_bounds (t : Nat) :
    5*(seed t-1)<2*(U t-1) ∧ 100*(U t-1)<251*(seed t-1) := by
  simp only [U,seed,cofactor]
  omega

theorem coarse_upper (t : Nat) : 3*(U t-1)<8*(seed t-1) := by
  simp only [U,seed,cofactor]
  omega

theorem header_contract (t : Nat) :
    21≤seed t ∧ seed t%2=1 ∧ 0<U t ∧ U t%2=1 ∧
    Physical (seed t) 45 70 (U t) ∧ orbit (seed t) 45=U t ∧
    2^70*U t=3^45*seed t+B45 ∧
    5*(seed t-1)<2*(U t-1) ∧ 100*(U t-1)<251*(seed t-1) := by
  have hn := seed_admissible t
  have hu := endpoint_admissible t
  exact ⟨hn.1,hn.2,hu.1,hu.2,header_physical t,prefix45 t,original_ledger t,
    (sharp_bounds t).1,(sharp_bounds t).2⟩

theorem residue_header (q : Nat) (hq : q%128=49) :
    let N := 2^64*q-5
    let Y := (3^45*q-35)/64
    21≤N ∧ N%2=1 ∧ 0<Y ∧ Y%2=1 ∧ Physical N 45 70 Y ∧ orbit N 45=Y ∧
    2^70*Y=3^45*N+B45 ∧ 5*(N-1)<2*(Y-1) ∧ 100*(Y-1)<251*(N-1) := by
  have hrep : cofactor (q/128)=q := by simp only [cofactor]; omega
  have hn : seed (q/128)=2^64*q-5 := by simp only [seed,hrep]
  have hy := endpoint_formula (q/128)
  rw [hrep] at hy
  have hh := header_contract (q/128)
  rw [hn,hy] at hh
  exact hh

#print axioms strip_pow
#print axioms physical_step
#print axioms physical_endpoint
#print axioms physical_pair
#print axioms pairs_physical
#print axioms cofactor_residue
#print axioms seed_admissible
#print axioms endpoint_admissible
#print axioms endpoint_formula
#print axioms exact_tail_factors
#print axioms tail_physical
#print axioms prefix42
#print axioms prefix45
#print axioms tail_actual_factors
#print axioms header_physical
#print axioms cost_formula
#print axioms original_ledger
#print axioms sharp_bounds
#print axioms coarse_upper
#print axioms header_contract
#print axioms residue_header

end CollatzCharacterBridge.A2Header
