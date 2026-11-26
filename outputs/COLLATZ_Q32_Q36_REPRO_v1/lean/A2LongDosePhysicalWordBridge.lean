import A2LongDoseStrictReentry
import A2HalfAdaptive
import A2SecondOne

namespace CollatzCharacterBridge.A2LongDosePhysicalWordBridge

open StagedCylinder (Segment compose)
open FixedSourceRun (Ones)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

/-- Exact ledger of an actually supplied run of valuation-two returns. -/
theorem twos_ledger_of_word {y K : Nat}
    (h2 : TwosCompression.Twos y K) :
    2^(2*K) * orbit y K = 3^K*y + (4^K - 3^K) := by
  induction K with
  | zero => simp [orbit]
  | succ K ih =>
      have hp : TwosCompression.Twos y K := fun i hi => h2 i (by omega)
      have hbook := ih hp
      have hedge := h2 K (by omega)
      have hpow : 3^K <= 4^K := Nat.pow_le_pow_left (by decide) K
      have hpow2 : 2^(2*K)=4^K := by
        simpa only [show (2:Nat)^2=4 by decide] using Nat.pow_mul 2 2 K
      calc
        2^(2*(K+1)) * orbit y (K+1)
            = 2^(2*K) * (4 * orbit y (K+1)) := by
                rw [show 2*(K+1)=2*K+2 by omega, Nat.pow_add,
                  show (2:Nat)^2=4 by decide]
                ac_rfl
        _ = 2^(2*K) * (3 * orbit y K + 1) := by rw [hedge]
        _ = 3 * (2^(2*K) * orbit y K) + 2^(2*K) := by
              simp only [Nat.mul_add, Nat.mul_one]
              ac_rfl
        _ = 3 * (3^K*y + (4^K-3^K)) + 4^K := by
              rw [hbook, hpow2]
        _ = 3^(K+1)*y + (4^(K+1)-3^(K+1)) := by
              rw [Nat.pow_succ, Nat.pow_succ]
              have hscaled : 3*3^K <= 4*4^K := by omega
              rw [Nat.mul_add, Nat.mul_sub_left_distrib]
              have hfront : 3*(3^K*y)=(3^K*3)*y := by ac_rfl
              rw [hfront]
              omega

/-- Generic physical `Segment` corresponding to a supplied `Twos` word. -/
theorem twos_segment_of_word {y K : Nat}
    (hy : 0<y) (hyo : y%2=1)
    (h2 : TwosCompression.Twos y K) :
    Segment y (orbit y K) K (2*K) (4^K-3^K) := by
  exact {
    physical := A2SecondOne.twos_physical hy hyo h2
    book := twos_ledger_of_word h2
  }

/-- The physical word `1^r 2^K` has exactly the additive consumed by the
    long-dose strict-reentry theorem. -/
theorem one_two_tail {x r K : Nat}
    (hx : 0<x) (hxo : x%2=1)
    (h1 : Ones x r)
    (h2 : TwosCompression.Twos (orbit x r) K) :
    Segment x (orbit x (r+K)) (r+K) (r+2*K)
      (A2LongDoseStrictReentry.localCost r K) := by
  have first := A2HalfAdaptive.ones_segment x r hx hxo h1
  have second := twos_segment_of_word (orbit_pos x hx r) (orbit_odd x hxo r) h2
  have both := compose first second
  simpa only [orbit_add, A2LongDoseStrictReentry.localCost,
    Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using both

/-- Convenience interface: build the physical long-dose tail from its
    supplied `Ones` and `Twos` witnesses, then reuse the historical consumer.
    It does not assert that either word occurs. -/
theorem consume_physical_long_doses
    {N x j s B r K : Nat}
    (Nbig : 39<=N) (Nx : N<=x) (xodd : x%2=1)
    (window : x<2*N+1) (fromN : Segment N x j s B)
    (h1 : Ones x r)
    (h2 : TwosCompression.Twos (orbit x r) K)
    (hr : 2<=r) (hceil : (3*r+1)/2<=K)
    (IH : forall w : Nat, 0<w -> w%2=1 -> w<N -> exists i, orbit w i=1) :
    Segment N (orbit x (r+K)) (j+(r+K)) (s+(r+2*K))
        (3^(r+K)*B + A2LongDoseStrictReentry.localCost r K*2^s) /\
      ((exists i, orbit N i=1) \/ A2BoundedReducer.RemainingBelow N x) := by
  have xpos : 0<x := by omega
  have tail := one_two_tail xpos xodd h1 h2
  exact A2LongDoseStrictReentry.consume_long_dose_tail_ceiling
    Nbig Nx xodd window fromN tail hr hceil IH

#print axioms twos_ledger_of_word
#print axioms twos_segment_of_word
#print axioms one_two_tail
#print axioms consume_physical_long_doses

end CollatzCharacterBridge.A2LongDosePhysicalWordBridge
