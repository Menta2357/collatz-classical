import A2BoundedReducer

namespace CollatzCharacterBridge.A2LongDoseStrictReentry

open StagedCylinder (Segment)
open A2BoundedReducer

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

/-- Exact additive of a physical local word `1^r 2^K`.
    Here `K` includes the valuation-two edge that ends the run of ones. -/
def localCost (r K : Nat) : Nat :=
  3^K * (3^r - 2^r) + 2^r * (4^K - 3^K)

def RatioBound (r K : Nat) : Prop :=
  256 * 3^(r+K) <= 243 * 2^(r+2*K)

private theorem ratio_step_two_three {r K : Nat}
    (h : RatioBound r K) : RatioBound (r+2) (K+3) := by
  unfold RatioBound at h ⊢
  have e3 : 3^(r+2+(K+3))=3^(r+K)*243 := by
    rw [show r+2+(K+3)=r+K+5 by omega, Nat.pow_add,
      show (3:Nat)^5=243 by decide]
  have e2 : 2^(r+2+2*(K+3))=2^(r+2*K)*256 := by
    rw [show r+2+2*(K+3)=r+2*K+8 by omega, Nat.pow_add,
      show (2:Nat)^8=256 by decide]
  rw [e3,e2]
  have h1 : 243 * (256 * 3^(r+K)) <=
      243 * (243 * 2^(r+2*K)) := Nat.mul_le_mul_left 243 h
  have h2 : 243 * (243 * 2^(r+2*K)) <=
      256 * (243 * 2^(r+2*K)) :=
    Nat.mul_le_mul_right (243 * 2^(r+2*K)) (by decide : (243:Nat) <= 256)
  calc
    256 * (3^(r+K) * 243) = 243 * (256 * 3^(r+K)) := by ac_rfl
    _ <= 243 * (243 * 2^(r+2*K)) := h1
    _ <= 256 * (243 * 2^(r+2*K)) := h2
    _ = 243 * (2^(r+2*K) * 256) := by ac_rfl

private theorem ratio_step_K {r K : Nat}
    (h : RatioBound r K) : RatioBound r (K+1) := by
  unfold RatioBound at h ⊢
  have e3 : 3^(r+(K+1))=3^(r+K)*3 := by
    rw [show r+(K+1)=r+K+1 by omega, Nat.pow_succ]
  have e2 : 2^(r+2*(K+1))=2^(r+2*K)*4 := by
    rw [show r+2*(K+1)=r+2*K+2 by omega, Nat.pow_add,
      show (2:Nat)^2=4 by decide]
  rw [e3,e2]
  have h1 : 3 * (256 * 3^(r+K)) <=
      3 * (243 * 2^(r+2*K)) := Nat.mul_le_mul_left 3 h
  have h2 : 3 * (243 * 2^(r+2*K)) <=
      4 * (243 * 2^(r+2*K)) :=
    Nat.mul_le_mul_right (243 * 2^(r+2*K)) (by decide : (3:Nat) <= 4)
  calc
    256 * (3^(r+K) * 3) = 3 * (256 * 3^(r+K)) := by ac_rfl
    _ <= 3 * (243 * 2^(r+2*K)) := h1
    _ <= 4 * (243 * 2^(r+2*K)) := h2
    _ = 243 * (2^(r+2*K) * 4) := by ac_rfl

private theorem ratio_add_K (r K d : Nat) (h : RatioBound r K) :
    RatioBound r (K+d) := by
  induction d with
  | zero => simpa using h
  | succ d ih =>
      have hs := ratio_step_K ih
      simpa only [Nat.add_assoc, Nat.add_comm 1, Nat.add_left_comm] using hs

private theorem ratio_even_base (m : Nat) :
    RatioBound (2+2*m) (3+3*m) := by
  induction m with
  | zero => unfold RatioBound; decide
  | succ m ih =>
      have hs := ratio_step_two_three ih
      have er : 2+2*(m+1)=(2+2*m)+2 := by omega
      have ek : 3+3*(m+1)=(3+3*m)+3 := by omega
      rw [er,ek]
      exact hs

private theorem ratio_odd_base (m : Nat) :
    RatioBound (3+2*m) (5+3*m) := by
  induction m with
  | zero => unfold RatioBound; decide
  | succ m ih =>
      have hs := ratio_step_two_three ih
      have er : 3+2*(m+1)=(3+2*m)+2 := by omega
      have ek : 5+3*(m+1)=(5+3*m)+3 := by omega
      rw [er,ek]
      exact hs

/-- Integer form of
    `(3/2)^r * (3/4)^K <= 243/256` under
    `K >= ceil(3r/2)`. -/
theorem ratio_bound {r K : Nat} (hr : 2 <= r) (hcut : 3*r <= 2*K) :
    RatioBound r K := by
  have parity := Nat.mod_two_eq_zero_or_one r
  rcases parity with he | ho
  · let m := (r-2)/2
    have er : r=2+2*m := by dsimp only [m]; omega
    have hk : 3+3*m <= K := by omega
    let d := K-(3+3*m)
    have ek : K=(3+3*m)+d := by dsimp only [d]; omega
    rw [er,ek]
    exact ratio_add_K (2+2*m) (3+3*m) d (ratio_even_base m)
  · let m := (r-3)/2
    have er : r=3+2*m := by dsimp only [m]; omega
    have hk : 5+3*m <= K := by omega
    let d := K-(5+3*m)
    have ek : K=(5+3*m)+d := by dsimp only [d]; omega
    rw [er,ek]
    exact ratio_add_K (3+2*m) (5+3*m) d (ratio_odd_base m)

theorem cutoff_iff (r K : Nat) :
    (3*r+1)/2 <= K <-> 3*r <= 2*K := by omega

theorem ratio_bound_ceiling {r K : Nat} (hr : 2 <= r)
    (hceil : (3*r+1)/2 <= K) : RatioBound r K :=
  ratio_bound hr ((cutoff_iff r K).mp hceil)

theorem localCost_le (r K : Nat) :
    localCost r K <= 3^(r+K) + 2^(r+2*K) := by
  unfold localCost
  have h32 : 2^r <= 3^r := Nat.pow_le_pow_left (by decide) r
  have h34 : 3^K <= 4^K := Nat.pow_le_pow_left (by decide) K
  have h1 : 3^K * (3^r - 2^r) <= 3^K * 3^r :=
    Nat.mul_le_mul_left _ (Nat.sub_le _ _)
  have h2 : 2^r * (4^K - 3^K) <= 2^r * 4^K :=
    Nat.mul_le_mul_left _ (Nat.sub_le _ _)
  calc
    3^K * (3^r - 2^r) + 2^r * (4^K - 3^K)
        <= 3^K * 3^r + 2^r * 4^K := Nat.add_le_add h1 h2
    _ = 3^(r+K) + 2^(r+2*K) := by
      rw [Nat.pow_add, Nat.pow_add, show (2:Nat)^(2*K)=4^K by
        simpa only [show (2:Nat)^2=4 by decide] using Nat.pow_mul 2 2 K]
      ac_rfl

/-- The exact local book and the ratio cutoff force strict decrease of
    the physical endpoint. -/
theorem strict_of_segment {x P r K : Nat}
    (hbig : 499 < 13*x) (hr : 2 <= r) (hcut : 3*r <= 2*K)
    (tail : Segment x P (r+K) (r+2*K) (localCost r K)) : P < x := by
  have hratio := ratio_bound hr hcut
  unfold RatioBound at hratio
  have hcost := localCost_le r K
  have hpow : 0 < 2^(r+2*K) := Nat.pow_pos (by decide)
  have hC : 256 * localCost r K <= 499 * 2^(r+2*K) := by
    calc
      256 * localCost r K <=
          256 * (3^(r+K) + 2^(r+2*K)) := Nat.mul_le_mul_left 256 hcost
      _ = 256 * 3^(r+K) + 256 * 2^(r+2*K) := Nat.mul_add _ _ _
      _ <= 243 * 2^(r+2*K) + 256 * 2^(r+2*K) :=
        Nat.add_le_add_right hratio _
      _ = 499 * 2^(r+2*K) := by omega
  have hCx : 256 * localCost r K < 13*x * 2^(r+2*K) := by
    exact Nat.lt_of_le_of_lt hC ((Nat.mul_lt_mul_right hpow).mpr hbig)
  have hA : 256 * (3^(r+K)*x) <=
      243 * (2^(r+2*K)*x) := by
    simpa only [Nat.mul_assoc] using Nat.mul_le_mul_right x hratio
  have hbook := tail.book
  have hmul : 256 * 2^(r+2*K) * P < 256 * 2^(r+2*K) * x := by
    calc
      256 * 2^(r+2*K) * P = 256 * (2^(r+2*K)*P) := by ac_rfl
      _ = 256 * (3^(r+K)*x + localCost r K) :=
        congrArg (fun z : Nat => 256*z) hbook
      _ = 256 * (3^(r+K)*x) + 256 * localCost r K := Nat.mul_add _ _ _
      _ <= 243 * (2^(r+2*K)*x) + 256 * localCost r K :=
        Nat.add_le_add_right hA _
      _ < 243 * (2^(r+2*K)*x) + 13*x*2^(r+2*K) :=
        Nat.add_lt_add_left hCx _
      _ = 243 * (2^(r+2*K)*x) + 13 * (2^(r+2*K)*x) := by ac_rfl
      _ = (243+13) * (2^(r+2*K)*x) :=
        (Nat.add_mul 243 13 (2^(r+2*K)*x)).symm
      _ = 256 * (2^(r+2*K)*x) := by rw [show 243+13=256 by decide]
      _ = 256 * 2^(r+2*K) * x := by ac_rfl
  exact Nat.lt_of_mul_lt_mul_left hmul

/-- Generic historical consumer for the long-dose cutoff. The caller
    supplies the physical local `Segment`; this theorem neither invents a
    word nor resets the original additive. -/
theorem consume_long_dose_tail {N x P j s B r K : Nat}
    (Nbig : 39 <= N) (Nx : N <= x) (xodd : x%2=1)
    (window : x < 2*N+1) (fromN : Segment N x j s B)
    (tail : Segment x P (r+K) (r+2*K) (localCost r K))
    (hr : 2 <= r) (hcut : 3*r <= 2*K)
    (IH : forall w : Nat, 0<w -> w%2=1 -> w<N -> exists i, orbit w i=1) :
    Segment N P (j+(r+K)) (s+(r+2*K))
        (3^(r+K)*B + localCost r K*2^s) /\
      ((exists i, orbit N i=1) \/ RemainingBelow N x) := by
  have xpos : 0 < x := by omega
  have hsmall : P < x := strict_of_segment (by omega) hr hcut tail
  exact consume_strict_tail (by omega) fromN xpos xodd window tail hsmall IH

theorem consume_long_dose_tail_ceiling {N x P j s B r K : Nat}
    (Nbig : 39 <= N) (Nx : N <= x) (xodd : x%2=1)
    (window : x < 2*N+1) (fromN : Segment N x j s B)
    (tail : Segment x P (r+K) (r+2*K) (localCost r K))
    (hr : 2 <= r) (hceil : (3*r+1)/2 <= K)
    (IH : forall w : Nat, 0<w -> w%2=1 -> w<N -> exists i, orbit w i=1) :
    Segment N P (j+(r+K)) (s+(r+2*K))
        (3^(r+K)*B + localCost r K*2^s) /\
      ((exists i, orbit N i=1) \/ RemainingBelow N x) :=
  consume_long_dose_tail Nbig Nx xodd window fromN tail hr
    ((cutoff_iff r K).mp hceil) IH

#print axioms ratio_bound
#print axioms ratio_bound_ceiling
#print axioms strict_of_segment
#print axioms consume_long_dose_tail
#print axioms consume_long_dose_tail_ceiling

end CollatzCharacterBridge.A2LongDoseStrictReentry
