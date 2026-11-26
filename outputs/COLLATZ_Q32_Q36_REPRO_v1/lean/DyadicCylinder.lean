import A2Header

namespace CollatzCharacterBridge.DyadicCylinder

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

open A2Header (Physical)

/-- Lift a real physical prefix by its dyadic modulus. The proof
follows its existing edge/append tree and keeps every edge valuation. -/
theorem physical_shift {x j S y : Nat} (p : Physical x j S y) :
    ∀ m : Nat, Physical (x+2^(S+1)*m) j S (y+2*3^j*m) := by
  induction p with
  | refl x =>
    intro m
    exact Physical.refl (x+2*m)
  | @edge x a y hx hxo hy hyo ha hf =>
    intro m
    have hsrc : 2^(a+1)*m=2*(2^a*m) := by
      rw [Nat.pow_succ 2 a]
      ac_rfl
    have hfactor : 3*(x+2^(a+1)*m)+1=2^a*(y+2*3^1*m) := by
      calc
        _ = (3*x+1)+3*(2^(a+1)*m) := by simp only [Nat.mul_add]; ac_rfl
        _ = 2^a*y+3*(2^(a+1)*m) := by rw [hf]
        _ = _ := by rw [Nat.mul_add,Nat.pow_succ 2 a]; simp only [Nat.pow_one]; ac_rfl
    apply Physical.edge
    · omega
    · rw [hsrc]
      omega
    · omega
    · omega
    · exact ha
    · exact hfactor
  | @append x y z j S k R p q ihp ihq =>
    intro m
    have hp := ihp (2^R*m)
    have hq := ihq (3^j*m)
    have hmid : y+2*3^j*(2^R*m)=y+2^(R+1)*(3^j*m) := by
      rw [Nat.pow_succ 2 R]
      ac_rfl
    rw [hmid] at hp
    have hboth := Physical.append hp hq
    have hleft : x+2^(S+1)*(2^R*m)=x+2^(S+R+1)*m := by
      rw [show S+R+1=(S+1)+R by omega,Nat.pow_add 2 (S+1) R]
      ac_rfl
    have hright : z+2*3^k*(3^j*m)=z+2*3^(j+k)*m := by
      rw [Nat.pow_add 3 j k]
      ac_rfl
    rw [hleft,hright] at hboth
    exact hboth

/-- The lifted seed and endpoint preserve the exact original additive
numerator B; no new ledger is initialized at an intermediate state. -/
theorem lifted_book {x j S y B : Nat} (hbook : 2^S*y=3^j*x+B) (m : Nat) :
    2^S*(y+2*3^j*m)=3^j*(x+2^(S+1)*m)+B := by
  calc
    _ = 2^S*y+2^S*(2*3^j*m) := Nat.mul_add _ _ _
    _ = (3^j*x+B)+2^S*(2*3^j*m) := by rw [hbook]
    _ = _ := by rw [Nat.mul_add,Nat.pow_succ 2 S]; ac_rfl

theorem physical_and_book {x j S y B : Nat} (p : Physical x j S y)
    (hbook : 2^S*y=3^j*x+B) (m : Nat) :
    Physical (x+2^(S+1)*m) j S (y+2*3^j*m) ∧
    2^S*(y+2*3^j*m)=3^j*(x+2^(S+1)*m)+B :=
  ⟨physical_shift p m,lifted_book hbook m⟩

def seed (q : Nat) : Nat := 2^64*q-5
def cofactor (q0 P t : Nat) : Nat := q0+81*2^(40+P)*t

/-- The dyadic seed increment is exact because q0>0 keeps the -5
untruncated. Its modulus is the one for the supplied103 divisions. -/
theorem seed_shift_identity (q0 P t : Nat) (hq : 0<q0) :
    seed (cofactor q0 P t)=seed q0+2^104*(2^P*81*t) := by
  have h104 : (2:Nat)^104=2^64*2^40 := Nat.pow_add 2 64 40
  have he : 2^64*(q0+81*2^(40+P)*t)=
      2^64*q0+2^104*(2^P*81*t) := by
    rw [Nat.mul_add,Nat.pow_add 2 40 P,h104]
    ac_rfl
  have hm := Nat.mul_le_mul_left (2^64) (by omega : 1≤q0)
  have hb : 5≤2^64*q0 := by omega
  simp only [seed,cofactor]
  rw [he]
  omega

theorem seed_increment_formula (q0 P t : Nat) (hq : 0<q0) :
    seed (cofactor q0 P t)=seed q0+2^(104+P)*81*t := by
  rw [seed_shift_identity q0 P t hq,Nat.pow_add 2 104 P]
  ac_rfl

theorem endpoint_increment_identity (P t : Nat) :
    2*3^65*(2^P*81*t)=2^(P+1)*3^69*t := by
  have h69 : (3:Nat)^69=3^65*81 := Nat.pow_add 3 65 4
  rw [Nat.pow_succ 2 P,h69]
  ac_rfl

/-- Uniform physical stability of the supplied65/103 prefix. This
does not yet extend the prefix by W or certify maximal reserves. -/
theorem prefix_cylinder (q0 P t y0 : Nat) (hq : 0<q0)
    (p : Physical (seed q0) 65 103 y0) :
    Physical (seed (cofactor q0 P t)) 65 103 (y0+2^(P+1)*3^69*t) := by
  have hp := physical_shift p (2^P*81*t)
  rw [←seed_shift_identity q0 P t hq,endpoint_increment_identity P t] at hp
  exact hp

theorem prefix_cylinder_book (q0 P t y0 B : Nat) (hq : 0<q0)
    (hbook : 2^103*y0=3^65*seed q0+B) :
    2^103*(y0+2^(P+1)*3^69*t)=3^65*seed (cofactor q0 P t)+B := by
  have hb := lifted_book hbook (2^P*81*t)
  rw [←seed_shift_identity q0 P t hq,endpoint_increment_identity P t] at hb
  exact hb

theorem cylinder_with_book (q0 P t y0 B : Nat) (hq : 0<q0)
    (p : Physical (seed q0) 65 103 y0)
    (hbook : 2^103*y0=3^65*seed q0+B) :
    Physical (seed (cofactor q0 P t)) 65 103 (y0+2^(P+1)*3^69*t) ∧
    2^103*(y0+2^(P+1)*3^69*t)=3^65*seed (cofactor q0 P t)+B :=
  ⟨prefix_cylinder q0 P t y0 hq p,prefix_cylinder_book q0 P t y0 B hq hbook⟩

#print axioms physical_shift
#print axioms lifted_book
#print axioms physical_and_book
#print axioms seed_shift_identity
#print axioms seed_increment_formula
#print axioms endpoint_increment_identity
#print axioms prefix_cylinder
#print axioms prefix_cylinder_book
#print axioms cylinder_with_book

end CollatzCharacterBridge.DyadicCylinder
