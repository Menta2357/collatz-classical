import A2HalfAdaptive
import A2CertifiedLanding

namespace CollatzCharacterBridge.A2WeakBreakDescent

open A2CertifiedLanding (Descended)
open FixedSourceRun (Ones)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

/-- The compressed local ledger uses the actual valuation after the
    weak break. The equivalent identity retains a positive correction. -/
theorem weak_two_local_book {P R a : Nat}
    (positive : 0<P) (odd : P%2=1) (ones : Ones P R)
    (weak : 3*orbit P R+1=4*orbit P (R+1))
    (a_pos : 1≤a) (next : 3*orbit P (R+1)+1=2^a*orbit P (R+2)) :
    Segment P (orbit P (R+2)) (R+2) (R+2+a) (3^(R+2)-2^(R+1)) ∧
      2^(R+2+a)*orbit P (R+2)+2^(R+1)=3^(R+2)*(P+1) := by
  have lead := A2HalfAdaptive.ones_segment P R positive odd ones
  have weak_edge : Segment (orbit P R) (orbit P (R+1)) 1 2 1 :=
    P5R3S5.step_segment (orbit P R) 2 (orbit_pos P positive R) (orbit_odd P odd R)
      (by decide) weak
  have next_edge : Segment (orbit P (R+1)) (orbit P (R+2)) 1 a 1 :=
    P5R3S5.step_segment (orbit P (R+1)) a (orbit_pos P positive (R+1))
      (orbit_odd P odd (R+1)) a_pos next
  have pow2le : (2:Nat)^R≤3^R := Nat.pow_le_pow_left (by decide) R
  have cost_eq :
      3*(3*(3^R-2^R)+2^R)+2^(R+2)=3^(R+2)-2^(R+1) := by
    simp only [show R+2=(R+1)+1 by omega,Nat.pow_succ]
    omega
  have local_book : Segment P (orbit P (R+2)) (R+2) (R+2+a) (3^(R+2)-2^(R+1)) := by
    simpa only [Nat.pow_one,Nat.mul_one,cost_eq] using compose (compose lead weak_edge) next_edge
  have powle : (2:Nat)^(R+1)≤3^(R+2) :=
    Nat.le_trans (Nat.pow_le_pow_left (by decide) _) (Nat.pow_le_pow_right (by decide) (by omega))
  refine ⟨local_book,?_⟩
  calc
    _ = 3^(R+2)*P+(3^(R+2)-2^(R+1)+2^(R+1)) := by rw [local_book.book,Nat.add_assoc]
    _ = _ := by rw [Nat.sub_add_cancel powle,Nat.mul_add,Nat.mul_one]

/-- A certified rational height bound on P+1 converts the compressed
    ratio into strict descent on the same original seed. -/
theorem descends_after_weak_two {N P j S B R a A D : Nat}
    (history : Segment N P j S B)
    (positive : 0<P) (odd : P%2=1) (ones : Ones P R)
    (weak : 3*orbit P R+1=4*orbit P (R+1))
    (a_pos : 1≤a) (next : 3*orbit P (R+1)+1=2^a*orbit P (R+2))
    (denominator_pos : 0<D) (price : D*(P+1)≤A*N)
    (budget : A*3^(R+2)≤D*2^(R+2+a)) :
    orbit N (j+(R+2))<N ∧
      Segment N (orbit N (j+(R+2))) (j+(R+2)) (S+(R+2+a))
        (3^(R+2)*B+2^S*(3^(R+2)-2^(R+1))) ∧ Descended N := by
  obtain ⟨tail,identity⟩ := weak_two_local_book positive odd ones weak a_pos next
  let U := orbit P (R+2)
  have compare :
      D*(2^(R+2+a)*U+2^(R+1))≤D*(2^(R+2+a)*N) := by
    change D*(2^(R+2+a)*orbit P (R+2)+2^(R+1))≤D*(2^(R+2+a)*N)
    calc
      _ = 3^(R+2)*(D*(P+1)) := by rw [identity]; ac_rfl
      _ ≤ 3^(R+2)*(A*N) := Nat.mul_le_mul_left _ price
      _ = (A*3^(R+2))*N := by ac_rfl
      _ ≤ (D*2^(R+2+a))*N := Nat.mul_le_mul_right _ budget
      _ = D*(2^(R+2+a)*N) := by ac_rfl
  have unscaled := Nat.le_of_mul_le_mul_left compare denominator_pos
  have correction : 0<(2:Nat)^(R+1) := Nat.pow_pos (by decide)
  have scaled_less : 2^(R+2+a)*U<2^(R+2+a)*N := by omega
  have less : U<N := Nat.lt_of_mul_lt_mul_left scaled_less
  have combined := compose history tail
  have paid : Descended N :=
    ⟨U,j+(R+2),S+(R+2+a),3^(R+2)*B+2^S*(3^(R+2)-2^(R+1)),
      orbit_pos P positive _,orbit_odd P odd _,less,combined⟩
  rw [A2Header.physical_endpoint combined.physical]
  exact ⟨less,combined,paid⟩

end CollatzCharacterBridge.A2WeakBreakDescent
