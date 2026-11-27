import A2LongDosePhysicalWordBridge

namespace CollatzCharacterBridge.A2ThreeWeakCommonLongRate

open StagedCylinder (Segment compose)
open FixedSourceRun (Ones)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

/-- Exact additive of the physical word `2^i 1^r 2^K` starting at `P`. -/
def afterPCost (i r K : Nat) : Nat :=
  3^(r+K) * (4^i - 3^i) +
    2^(2*i) * A2LongDoseStrictReentry.localCost r K

/-- Exact additive after prepending the fixed `V -> P` word with book
    `128 P = 243 V + 251`. -/
def commonCost (i r K : Nat) : Nat :=
  3^(i+r+K) * 251 + 2^7 * afterPCost i r K

def HalfRate (r q : Nat) : Prop :=
  2 * 3^(r+q) <= 2^(r+2*q)

private theorem halfRate_step_two_three {r q : Nat}
    (h : HalfRate r q) : HalfRate (r+2) (q+3) := by
  unfold HalfRate at h ⊢
  have e3 : 3^(r+2+(q+3))=3^(r+q)*243 := by
    rw [show r+2+(q+3)=r+q+5 by omega, Nat.pow_add,
      show (3:Nat)^5=243 by decide]
  have e2 : 2^(r+2+2*(q+3))=2^(r+2*q)*256 := by
    rw [show r+2+2*(q+3)=r+2*q+8 by omega, Nat.pow_add,
      show (2:Nat)^8=256 by decide]
  rw [e3,e2]
  have h1 : 243 * (2 * 3^(r+q)) <= 243 * 2^(r+2*q) :=
    Nat.mul_le_mul_left 243 h
  have h2 : 243 * 2^(r+2*q) <= 256 * 2^(r+2*q) :=
    Nat.mul_le_mul_right (2^(r+2*q)) (by decide : (243:Nat) <= 256)
  calc
    2 * (3^(r+q) * 243) = 243 * (2 * 3^(r+q)) := by ac_rfl
    _ <= 243 * 2^(r+2*q) := h1
    _ <= 256 * 2^(r+2*q) := h2
    _ = 2^(r+2*q) * 256 := by ac_rfl

private theorem halfRate_step_q {r q : Nat}
    (h : HalfRate r q) : HalfRate r (q+1) := by
  unfold HalfRate at h ⊢
  have e3 : 3^(r+(q+1))=3^(r+q)*3 := by
    rw [show r+(q+1)=r+q+1 by omega, Nat.pow_succ]
  have e2 : 2^(r+2*(q+1))=2^(r+2*q)*4 := by
    rw [show r+2*(q+1)=r+2*q+2 by omega, Nat.pow_add,
      show (2:Nat)^2=4 by decide]
  rw [e3,e2]
  have h1 : 3 * (2 * 3^(r+q)) <= 3 * 2^(r+2*q) :=
    Nat.mul_le_mul_left 3 h
  have h2 : 3 * 2^(r+2*q) <= 4 * 2^(r+2*q) :=
    Nat.mul_le_mul_right (2^(r+2*q)) (by decide : (3:Nat) <= 4)
  calc
    2 * (3^(r+q) * 3) = 3 * (2 * 3^(r+q)) := by ac_rfl
    _ <= 3 * 2^(r+2*q) := h1
    _ <= 4 * 2^(r+2*q) := h2
    _ = 2^(r+2*q) * 4 := by ac_rfl

private theorem halfRate_add_q (r q d : Nat) (h : HalfRate r q) :
    HalfRate r (q+d) := by
  induction d with
  | zero => simpa using h
  | succ d ih =>
      have hs := halfRate_step_q ih
      simpa only [Nat.add_assoc, Nat.add_comm 1, Nat.add_left_comm] using hs

private theorem halfRate_even_base (m : Nat) :
    HalfRate (2+2*m) (6+3*m) := by
  induction m with
  | zero => unfold HalfRate; decide
  | succ m ih =>
      have hs := halfRate_step_two_three ih
      have er : 2+2*(m+1)=(2+2*m)+2 := by omega
      have eq : 6+3*(m+1)=(6+3*m)+3 := by omega
      rw [er,eq]
      exact hs

private theorem halfRate_odd_base (m : Nat) :
    HalfRate (1+2*m) (5+3*m) := by
  induction m with
  | zero => unfold HalfRate; decide
  | succ m ih =>
      have hs := halfRate_step_two_three ih
      have er : 1+2*(m+1)=(1+2*m)+2 := by omega
      have eq : 5+3*(m+1)=(5+3*m)+3 := by omega
      rw [er,eq]
      exact hs

/-- Three doses beyond the `ceil(3r/2)` cutoff make the multiplicative
    coefficient at most one half. -/
theorem half_rate_total {r q : Nat} (hr : 1<=r)
    (hcut : (3*r+1)/2+3 <= q) : HalfRate r q := by
  have parity := Nat.mod_two_eq_zero_or_one r
  rcases parity with he | ho
  · let m := (r-2)/2
    have er : r=2+2*m := by dsimp only [m]; omega
    have hq : 6+3*m <= q := by omega
    let d := q-(6+3*m)
    have eq : q=(6+3*m)+d := by dsimp only [d]; omega
    rw [er,eq]
    exact halfRate_add_q (2+2*m) (6+3*m) d (halfRate_even_base m)
  · let m := (r-1)/2
    have er : r=1+2*m := by dsimp only [m]; omega
    have hq : 5+3*m <= q := by omega
    let d := q-(5+3*m)
    have eq : q=(5+3*m)+d := by dsimp only [d]; omega
    rw [er,eq]
    exact halfRate_add_q (1+2*m) (5+3*m) d (halfRate_odd_base m)

theorem half_rate {i r K : Nat} (hr : 1<=r)
    (hcut : (3*r+1)/2+3 <= i+K) :
    2 * 3^(i+r+K) <= 2^(2*i+r+2*K) := by
  have h := half_rate_total (r:=r) (q:=i+K) hr hcut
  unfold HalfRate at h
  simpa only [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm,
    Nat.mul_add, Nat.mul_one] using h

private theorem four_pow_le_two_three_pow {i : Nat} (hi : i<=2) :
    4^i <= 2*3^i := by
  have cases : i=0 ∨ i=1 ∨ i=2 := by omega
  rcases cases with h|h|h <;> subst i <;> decide

/-- Uniform cost bound for the three possible initial dose counts. -/
theorem afterPCost_le {i r K : Nat} (hi : i<=2) (hr : 1<=r)
    (hcut : (3*r+1)/2+3 <= i+K) :
    afterPCost i r K <= 3 * 2^(2*i+r+2*K) := by
  have hrate := half_rate (i:=i) (r:=r) (K:=K) hr hcut
  have hlocal := A2LongDoseStrictReentry.localCost_le r K
  have h4 := four_pow_le_two_three_pow hi
  have hpow4 : 2^(2*i)=4^i := by
    simpa only [show (2:Nat)^2=4 by decide] using Nat.pow_mul 2 2 i
  have hfirst : 4^i * 3^(r+K) <= 2 * 3^(i+r+K) := by
    calc
      4^i * 3^(r+K) <= (2*3^i) * 3^(r+K) :=
        Nat.mul_le_mul_right (3^(r+K)) h4
      _ = 2 * (3^i * 3^(r+K)) := by ac_rfl
      _ = 2 * 3^(i+r+K) := by
        rw [show i+r+K=i+(r+K) by omega, ←Nat.pow_add]
  have hfirstD : 4^i * 3^(r+K) <= 2^(2*i+r+2*K) :=
    Nat.le_trans hfirst hrate
  unfold afterPCost
  have hsub : 3^(r+K) * (4^i-3^i) <= 3^(r+K)*4^i :=
    Nat.mul_le_mul_left _ (Nat.sub_le _ _)
  have htail : 2^(2*i) * A2LongDoseStrictReentry.localCost r K <=
      4^i * (3^(r+K)+2^(r+2*K)) := by
    rw [hpow4]
    exact Nat.mul_le_mul_left _ hlocal
  calc
    3^(r+K) * (4^i-3^i) +
        2^(2*i) * A2LongDoseStrictReentry.localCost r K
      <= 3^(r+K)*4^i + 4^i*(3^(r+K)+2^(r+2*K)) :=
        Nat.add_le_add hsub htail
    _ = 2*(4^i*3^(r+K)) + 2^(2*i+r+2*K) := by
      rw [Nat.mul_add]
      have hprod : 4^i*2^(r+2*K)=2^(2*i+r+2*K) := by
        calc
          4^i*2^(r+2*K) = 2^(2*i)*2^(r+2*K) := by rw [hpow4]
          _ = 2^(2*i+(r+2*K)) := (Nat.pow_add 2 (2*i) (r+2*K)).symm
          _ = 2^(2*i+r+2*K) := by
            rw [show 2*i+(r+2*K)=2*i+r+2*K by omega]
      rw [hprod]
      have hcomm : 3^(r+K)*4^i=4^i*3^(r+K) := Nat.mul_comm _ _
      rw [hcomm]
      omega
    _ <= 2*2^(2*i+r+2*K) + 2^(2*i+r+2*K) :=
      Nat.add_le_add_right (Nat.mul_le_mul_left 2 hfirstD) _
    _ = 3*2^(2*i+r+2*K) := by omega

/-- Build the physical word `2^i 1^r 2^K` from supplied witnesses. -/
theorem afterP_segment {P i r K : Nat}
    (Ppos : 0<P) (Podd : P%2=1)
    (preTwos : TwosCompression.Twos P i)
    (ones : Ones (orbit P i) r)
    (postTwos : TwosCompression.Twos (orbit P (i+r)) K) :
    Segment P (orbit P (i+r+K)) (i+r+K) (2*i+r+2*K)
      (afterPCost i r K) := by
  have pre := A2LongDosePhysicalWordBridge.twos_segment_of_word Ppos Podd preTwos
  have postTwos' := postTwos
  rw [orbit_add] at postTwos'
  have middle := A2LongDosePhysicalWordBridge.one_two_tail
    (orbit_pos P Ppos i) (orbit_odd P Podd i) ones postTwos'
  have both := compose pre middle
  simpa only [afterPCost, orbit_add, Nat.add_assoc, Nat.add_comm,
    Nat.add_left_comm] using both

/-- Prepend the fixed `V -> P` word. -/
theorem common_tail {V P i r K : Nat}
    (Vpos : 0<V) (Vodd : V%2=1)
    (fixedPrefix : Segment V P 5 7 251)
    (preTwos : TwosCompression.Twos P i)
    (ones : Ones (orbit P i) r)
    (postTwos : TwosCompression.Twos (orbit P (i+r)) K) :
    Segment V (orbit P (i+r+K)) (5+i+r+K) (7+2*i+r+2*K)
      (commonCost i r K) := by
  have endpoint := A2Header.physical_endpoint fixedPrefix.physical
  have Ppos : 0<P := by rw [←endpoint]; exact orbit_pos V Vpos 5
  have Podd : P%2=1 := by rw [←endpoint]; exact orbit_odd V Vodd 5
  have localTail := afterP_segment Ppos Podd preTwos ones postTwos
  have both := compose fixedPrefix localTail
  simpa only [commonCost, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using both

/-- The common long-rate cutoff forces return below the historical pivot `V`. -/
theorem common_strict {V Z i r K : Nat}
    (hV : 79<=V) (hi : i<=2) (hr : 1<=r)
    (hcut : (3*r+1)/2+3 <= i+K)
    (tail : Segment V Z (5+i+r+K) (7+2*i+r+2*K)
      (commonCost i r K)) : Z<V := by
  have hrate := half_rate (i:=i) (r:=r) (K:=K) hr hcut
  have hcost := afterPCost_le (i:=i) (r:=r) (K:=K) hi hr hcut
  let a := 3^(i+r+K)
  let d := 2^(2*i+r+2*K)
  let C := afterPCost i r K
  have hdpos : 0<d := by dsimp only [d]; exact Nat.pow_pos (by decide)
  have hrate' : 2*a<=d := by exact hrate
  have hcost' : C<=3*d := by exact hcost
  have hfull : 2*(251*a+128*C) <= 1019*d := by
    have h1 : 502*a <= 251*d := by
      calc
        502*a = 251*(2*a) := by omega
        _ <= 251*d := Nat.mul_le_mul_left 251 hrate'
    have h2 : 256*C <= 768*d := by
      calc
        256*C <= 256*(3*d) := Nat.mul_le_mul_left 256 hcost'
        _ = 768*d := by omega
    omega
  have hcoef : 486*a*V <= 243*d*V := by
    have h := Nat.mul_le_mul_left 243 hrate'
    have hbase : 486*a<=243*d := by
      calc
        486*a = 243*(2*a) := by omega
        _ <= 243*d := h
    exact Nat.mul_le_mul_right V hbase
  have hgap : 1019*d < 13*d*V := by
    calc
      1019*d < 1027*d :=
        (Nat.mul_lt_mul_right hdpos).mpr (by decide : (1019:Nat)<1027)
      _ = (13*d)*79 := by omega
      _ <= (13*d)*V := Nat.mul_le_mul_left (13*d) hV
      _ = 13*d*V := by ac_rfl
  have hmain : 243*a*V+(251*a+128*C) < 128*d*V := by
    have doubled : 2*(243*a*V+(251*a+128*C)) < 2*(128*d*V) := by
      calc
        2*(243*a*V+(251*a+128*C)) =
            2*(243*a*V)+2*(251*a+128*C) := Nat.mul_add _ _ _
        _ = 486*a*V+2*(251*a+128*C) := by
          rw [show (486:Nat)=2*243 by decide]
          ac_rfl
        _ <= 243*d*V+1019*d := Nat.add_le_add hcoef hfull
        _ < 243*d*V+13*d*V := Nat.add_lt_add_left hgap _
        _ = 243*(d*V)+13*(d*V) := by ac_rfl
        _ = (243+13)*(d*V) := (Nat.add_mul 243 13 (d*V)).symm
        _ = (243+13)*d*V := by ac_rfl
        _ = 2*(128*d*V) := by
          rw [show (243+13:Nat)=2*128 by decide]
          ac_rfl
    exact Nat.lt_of_mul_lt_mul_left doubled
  have hbook := tail.book
  have hbook' : 128*d*Z=243*a*V+(251*a+128*C) := by
    have h2pow : 2^(7+2*i+r+2*K)=128*d := by
      dsimp only [d]
      rw [show 7+2*i+r+2*K=7+(2*i+r+2*K) by omega]
      rw [Nat.pow_add, show (2:Nat)^7=128 by decide]
    have h3pow : 3^(5+i+r+K)=243*a := by
      dsimp only [a]
      rw [show 5+i+r+K=5+(i+r+K) by omega]
      rw [Nat.pow_add, show (3:Nat)^5=243 by decide]
    rw [h2pow,h3pow] at hbook
    change 128*d*Z=243*a*V+(a*251+128*C) at hbook
    calc
      128*d*Z = 243*a*V+(a*251+128*C) := hbook
      _ = 243*a*V+(251*a+128*C) := by ac_rfl
  have hmul : 128*d*Z < 128*d*V := by rw [hbook']; exact hmain
  exact Nat.lt_of_mul_lt_mul_left hmul

/-- Historical consumer. Appearance of the physical word remains an explicit
    hypothesis; the same original `N`, clock and additive are retained. -/
theorem consume_common_long_rule
    {N V P j s B i r K : Nat}
    (Nbig : 1<N) (Vodd : V%2=1) (window : V<2*N+1)
    (fromN : Segment N V j s B)
    (fixedPrefix : Segment V P 5 7 251)
    (preTwos : TwosCompression.Twos P i)
    (ones : Ones (orbit P i) r)
    (postTwos : TwosCompression.Twos (orbit P (i+r)) K)
    (hV : 79<=V) (hi : i<=2) (hr : 1<=r)
    (hcut : (3*r+1)/2+3 <= i+K)
    (IH : forall w : Nat, 0<w -> w%2=1 -> w<N -> exists n, orbit w n=1) :
    Segment N (orbit P (i+r+K)) (j+(5+i+r+K))
        (s+(7+2*i+r+2*K))
        (3^(5+i+r+K)*B + commonCost i r K*2^s) /\
      ((exists n, orbit N n=1) \/ A2BoundedReducer.RemainingBelow N V) := by
  have Vpos : 0<V := by omega
  have tail := common_tail Vpos Vodd fixedPrefix preTwos ones postTwos
  have small := common_strict hV hi hr hcut tail
  exact A2BoundedReducer.consume_strict_tail Nbig fromN Vpos Vodd window tail small IH

end CollatzCharacterBridge.A2ThreeWeakCommonLongRate
