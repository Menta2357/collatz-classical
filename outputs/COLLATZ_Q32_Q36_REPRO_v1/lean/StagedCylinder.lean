import DyadicCylinder
import CRTPhysicalBridge

namespace CollatzCharacterBridge.StagedCylinder

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

open A2Header (Physical)
open CRTPhysicalBridge (A)

/-- Physical history and its exact additive are a single interface. -/
structure Segment (x y j S B : Nat) : Prop where
  physical : Physical x j S y
  book : 2^S*y=3^j*x+B

/-- Only the outer additive sum is associated, over abstract states. -/
theorem compose {x y z j S k R B D : Nat} (s : Segment x y j S B)
    (r : Segment y z k R D) :
    Segment x z (j+k) (S+R) (3^k*B+2^S*D) := by
  exact {
    physical := Physical.append s.physical r.physical
    book := (FixedSourceRun.history_transport s.book r.book).trans (Nat.add_assoc _ _ _)
  }

theorem cast_segment {x y x' y' j S B : Nat} (s : Segment x y j S B)
    (hx : x=x') (hy : y=y') : Segment x' y' j S B := by
  cases hx
  cases hy
  exact s

def offset (x a b t : Nat) : Nat := x+2^a*3^b*t
def reserveP (ell L p : Nat) : Nat := 6*ell+5+6*L+p
def Yt (Y0 ell L p t : Nat) : Nat := offset Y0 (6*ell+6+6*L+p) 69 t
def Ut (U0 ell L p t : Nat) : Nat := offset U0 (6+6*L+p) (69+4*ell) t
def Zt (Z0 ell L p t : Nat) : Nat := offset Z0 (2+6*L+p) (72+4*ell) t
def Et (E0 ell L p t : Nat) : Nat := offset E0 (2+p) (72+4*ell+4*L) t
def ExactReserve (n x : Nat) : Prop := ∃ u : Nat, 0<u ∧ u%2=1 ∧ A x=2^n*u

theorem exponent_formulas (ell L p : Nat) :
    reserveP ell L p+1=6*ell+6+6*L+p ∧
    reserveP ell L p+1-6*ell=6+6*L+p ∧
    reserveP ell L p+1-6*ell-4=2+6*L+p ∧
    reserveP ell L p+1-6*ell-4-6*L=2+p := by simp only [reserveP]; omega

theorem offset_index_eq (x a a' b b' t : Nat) (ha : a=a') (hb : b=b') :
    offset x a b t=offset x a' b' t := by cases ha; cases hb; rfl

theorem shifted_segment {x y j S B : Nat} (s : Segment x y j S B) (a b t : Nat) :
    Segment (offset x (S+1+a) b t) (offset y (a+1) (b+j) t) j S B := by
  have h := DyadicCylinder.physical_and_book s.physical s.book (2^a*3^b*t)
  have hs : x+2^(S+1)*(2^a*3^b*t)=offset x (S+1+a) b t := by
    simp only [offset]
    rw [Nat.pow_add 2 (S+1) a]
    ac_rfl
  have ht : y+2*3^j*(2^a*3^b*t)=offset y (a+1) (b+j) t := by
    simp only [offset]
    rw [Nat.pow_succ 2 a,Nat.pow_add 3 b j]
    ac_rfl
  have raw : Segment (x+2^(S+1)*(2^a*3^b*t)) (y+2*3^j*(2^a*3^b*t)) j S B :=
    ⟨h.1,h.2⟩
  exact cast_segment raw hs ht

/-- All index transport is done in a generic lemma, before concrete
state exponents are instantiated. -/
theorem shifted_segment_as {x y j S B : Nat} (s : Segment x y j S B)
    (a b t sourceA sourceB targetA targetB : Nat)
    (hsA : S+1+a=sourceA) (hsB : b=sourceB)
    (htA : a+1=targetA) (htB : b+j=targetB) :
    Segment (offset x sourceA sourceB t) (offset y targetA targetB t) j S B :=
  cast_segment (shifted_segment s a b t)
    (offset_index_eq x (S+1+a) sourceA b sourceB t hsA hsB)
    (offset_index_eq y (a+1) targetA (b+j) targetB t htA htB)

theorem left_stage {ell L p t Y0 U0 B1 : Nat}
    (s : Segment Y0 U0 (4*ell) (6*ell) B1) :
    Segment (Yt Y0 ell L p t) (Ut U0 ell L p t) (4*ell) (6*ell) B1 :=
  shifted_segment_as s (5+6*L+p) 69 t (6*ell+6+6*L+p) 69
    (6+6*L+p) (69+4*ell) (by omega) rfl (by omega) rfl

theorem middle_stage {ell L p t U0 Z0 B2 : Nat} (s : Segment U0 Z0 3 4 B2) :
    Segment (Ut U0 ell L p t) (Zt Z0 ell L p t) 3 4 B2 :=
  shifted_segment_as s (1+6*L+p) (69+4*ell) t (6+6*L+p) (69+4*ell)
    (2+6*L+p) (72+4*ell) (by omega) rfl (by omega) (by omega)

theorem right_stage {ell L p t Z0 E0 B3 : Nat}
    (s : Segment Z0 E0 (4*L) (6*L) B3) :
    Segment (Zt Z0 ell L p t) (Et E0 ell L p t) (4*L) (6*L) B3 :=
  shifted_segment_as s (1+p) (72+4*ell) t (2+6*L+p) (72+4*ell)
    (2+p) (72+4*ell+4*L) (by omega) rfl (by omega) rfl

theorem exact_reserve_semantic {n x : Nat} (r : ExactReserve n x) :
    2^n ∣ A x ∧ ¬2^(n+1) ∣ A x := by
  obtain ⟨u,_,hu,hA⟩ := r
  refine ⟨⟨u,hA⟩,?_⟩
  intro hd
  obtain ⟨q,hq⟩ := hd
  have he : 2^n*u=2^n*(2*q) := by
    calc
      _ = A x := hA.symm
      _ = 2^(n+1)*q := hq
      _ = _ := by rw [Nat.pow_succ 2 n]; ac_rfl
  have hq' : u=2*q := Nat.mul_left_cancel (Nat.pow_pos (by decide : 0<2)) he
  omega

theorem A_offset (x a b t : Nat) : A (offset x a b t)=A x+17*(2^a*3^b*t) := by
  simp only [A,offset,Nat.mul_add]
  ac_rfl

theorem reserve_offset (x n a b t u : Nat) (hA : A x=2^n*u) (hu : u%2=1) :
    ExactReserve n (offset x (n+1+a) b t) := by
  refine ⟨u+2*(17*2^a*3^b*t),by omega,by omega,?_⟩
  calc
    _ = A x+17*(2^(n+1+a)*3^b*t) := A_offset x (n+1+a) b t
    _ = 2^n*u+17*(2^(n+1+a)*3^b*t) := by rw [hA]
    _ = _ := by
      rw [Nat.mul_add,show n+1+a=n+(1+a) by omega,
        Nat.pow_add 2 n (1+a),Nat.pow_add 2 1 a]
      simp only [Nat.pow_one]
      ac_rfl

theorem reserve_offset_as (x n a b t u targetA : Nat)
    (hA : A x=2^n*u) (hu : u%2=1) (hindex : n+1+a=targetA) :
    ExactReserve n (offset x targetA b t) := by
  have h := reserve_offset x n a b t u hA hu
  rw [hindex] at h
  exact h

theorem preserved_reserves (ell L p t Y0 Z0 u0 v0 : Nat)
    (hY : A Y0=2^(6*ell+5)*u0) (hu : u0%2=1)
    (hZ : A Z0=2^(6*L+1)*v0) (hv : v0%2=1) :
    ExactReserve (6*ell+5) (Yt Y0 ell L p t) ∧
    ExactReserve (6*L+1) (Zt Z0 ell L p t) :=
  ⟨reserve_offset_as Y0 (6*ell+5) (6*L+p) 69 t u0 (6*ell+6+6*L+p) hY hu (by omega),
    reserve_offset_as Z0 (6*L+1) p (72+4*ell) t v0 (2+6*L+p) hZ hv (by omega)⟩

theorem offset_mod_power (x a b t n : Nat) (hna : n≤a) :
    offset x a b t%2^n=x%2^n := by
  have hd : 2^n ∣ 2^a*3^b*t := Nat.dvd_mul_right_of_dvd
    (Nat.dvd_mul_right_of_dvd (Nat.pow_dvd_pow 2 hna) (3^b)) t
  simp only [offset]
  rw [Nat.add_mod,Nat.mod_eq_zero_of_dvd hd,Nat.add_zero,Nat.mod_mod]

theorem preserved_phase (ell L p t U0 : Nat) (hU : U0%32=7) : Ut U0 ell L p t%32=7 :=
  (offset_mod_power U0 (6+6*L+p) (69+4*ell) t 5 (by omega)).trans hU

theorem increment_balance (ell a b t targetA : Nat) (hindex : 6*ell+a=targetA) :
    64^ell*(17*(2^a*3^(b+4*ell)*t))=
      81^ell*(17*(2^targetA*3^b*t)) := by
  have h : 64^ell*(17*(2^a*3^(b+4*ell)*t))=
      81^ell*(17*(2^(6*ell+a)*3^b*t)) := by
    rw [Nat.pow_add 3 b (4*ell),CRTPhysicalBridge.power81,
      Nat.pow_add 2 (6*ell) a,CRTPhysicalBridge.power64]
    ac_rfl
  rw [hindex] at h
  exact h

theorem affine_offset_balance (ell a b t targetA Y0 U0 : Nat)
    (hindex : 6*ell+a=targetA) (hbase : 64^ell*A U0=81^ell*A Y0) :
    64^ell*A (offset U0 a (b+4*ell) t)=81^ell*A (offset Y0 targetA b t) := by
  have hd := increment_balance ell a b t targetA hindex
  calc
    _ = 64^ell*(A U0+17*(2^a*3^(b+4*ell)*t)) :=
      congrArg (fun z : Nat => 64^ell*z) (A_offset U0 a (b+4*ell) t)
    _ = 64^ell*A U0+64^ell*(17*(2^a*3^(b+4*ell)*t)) := Nat.mul_add _ _ _
    _ = 81^ell*A Y0+81^ell*(17*(2^targetA*3^b*t)) := by rw [hbase,hd]
    _ = 81^ell*(A Y0+17*(2^targetA*3^b*t)) := (Nat.mul_add _ _ _).symm
    _ = _ := congrArg (fun z : Nat => 81^ell*z) (A_offset Y0 targetA b t).symm

theorem preserved_affine (ell L p t Y0 U0 : Nat)
    (hbase : 64^ell*A U0=81^ell*A Y0) :
    64^ell*A (Ut U0 ell L p t)=81^ell*A (Yt Y0 ell L p t) :=
  affine_offset_balance ell (6+6*L+p) 69 t (6*ell+6+6*L+p) Y0 U0 (by omega) hbase

theorem terminal_of_segment {U Z B : Nat} (s : Segment U Z 3 4 B) (hU : U%32=7) :
    Z=CRTPhysicalBridge.JEnd U :=
  (A2Header.physical_endpoint s.physical).symm.trans
    (A2Header.physical_endpoint (CRTPhysicalBridge.J_physical U hU))

structure Stages (ell L p t Y0 U0 Z0 E0 B1 B2 B3 : Nat) : Prop where
  ell_positive : 0<ell
  L_positive : 0<L
  left : Segment (Yt Y0 ell L p t) (Ut U0 ell L p t) (4*ell) (6*ell) B1
  connector : Segment (Ut U0 ell L p t) (Zt Z0 ell L p t) 3 4 B2
  right : Segment (Zt Z0 ell L p t) (Et E0 ell L p t) (4*L) (6*L) B3
  Y_reserve : ExactReserve (6*ell+5) (Yt Y0 ell L p t)
  Z_reserve : ExactReserve (6*L+1) (Zt Z0 ell L p t)
  U_phase : Ut U0 ell L p t%32=7
  affine_left : 64^ell*A (Ut U0 ell L p t)=81^ell*A (Yt Y0 ell L p t)
  terminal : Zt Z0 ell L p t=CRTPhysicalBridge.JEnd (Ut U0 ell L p t)

theorem staged_witness (ell L p t Y0 U0 Z0 E0 B1 B2 B3 u0 v0 : Nat)
    (hell : 1≤ell) (hL : 1≤L)
    (s1 : Segment Y0 U0 (4*ell) (6*ell) B1) (s2 : Segment U0 Z0 3 4 B2)
    (s3 : Segment Z0 E0 (4*L) (6*L) B3)
    (hY : A Y0=2^(6*ell+5)*u0) (hu : u0%2=1)
    (hZ : A Z0=2^(6*L+1)*v0) (hv : v0%2=1)
    (hU : U0%32=7) (hAffine : 64^ell*A U0=81^ell*A Y0) :
    Stages ell L p t Y0 U0 Z0 E0 B1 B2 B3 := by
  have sl : Segment (Yt Y0 ell L p t) (Ut U0 ell L p t) (4*ell) (6*ell) B1 := left_stage s1
  have sm : Segment (Ut U0 ell L p t) (Zt Z0 ell L p t) 3 4 B2 := middle_stage s2
  have sr : Segment (Zt Z0 ell L p t) (Et E0 ell L p t) (4*L) (6*L) B3 := right_stage s3
  have hr := preserved_reserves ell L p t Y0 Z0 u0 v0 hY hu hZ hv
  have hp := preserved_phase ell L p t U0 hU
  exact {
    ell_positive := by omega
    L_positive := by omega
    left := sl
    connector := sm
    right := sr
    Y_reserve := hr.1
    Z_reserve := hr.2
    U_phase := hp
    affine_left := preserved_affine ell L p t Y0 U0 hAffine
    terminal := terminal_of_segment sm hp
  }

/-- The consumer needs origin+left, not a monolithic Y-to-E book. -/
theorem origin_to_U {ell L p t Y0 U0 Z0 E0 B1 B2 B3 N j S B : Nat}
    (c : Stages ell L p t Y0 U0 Z0 E0 B1 B2 B3)
    (origin : Segment N (Yt Y0 ell L p t) j S B) :
    Segment N (Ut U0 ell L p t) (j+4*ell) (S+6*ell) (3^(4*ell)*B+2^S*B1) :=
  compose origin c.left

theorem consumer_premises {ell L p t Y0 U0 Z0 E0 B1 B2 B3 N j S B : Nat}
    (c : Stages ell L p t Y0 U0 Z0 E0 B1 B2 B3)
    (origin : Segment N (Yt Y0 ell L p t) j S B) :
    Physical N (j+4*ell) (S+6*ell) (Ut U0 ell L p t) ∧
    2^(S+6*ell)*Ut U0 ell L p t=3^(j+4*ell)*N+(3^(4*ell)*B+2^S*B1) ∧
    Ut U0 ell L p t%32=7 ∧
    64^ell*A (Ut U0 ell L p t)=81^ell*A (Yt Y0 ell L p t) ∧
    Zt Z0 ell L p t=CRTPhysicalBridge.JEnd (Ut U0 ell L p t) := by
  have s := origin_to_U c origin
  exact ⟨s.physical,s.book,c.U_phase,c.affine_left,c.terminal⟩

#print axioms compose
#print axioms cast_segment
#print axioms exponent_formulas
#print axioms offset_index_eq
#print axioms shifted_segment
#print axioms shifted_segment_as
#print axioms left_stage
#print axioms middle_stage
#print axioms right_stage
#print axioms exact_reserve_semantic
#print axioms A_offset
#print axioms reserve_offset
#print axioms reserve_offset_as
#print axioms preserved_reserves
#print axioms offset_mod_power
#print axioms preserved_phase
#print axioms increment_balance
#print axioms affine_offset_balance
#print axioms preserved_affine
#print axioms terminal_of_segment
#print axioms staged_witness
#print axioms origin_to_U
#print axioms consumer_premises

end CollatzCharacterBridge.StagedCylinder
