import P5R3S5

namespace CollatzCharacterBridge.P5OddExit

set_option maxRecDepth 16000
set_option maxHeartbeats 1000000

open A2Header (Physical)
open StagedCylinder (Segment)
open P5R3S5 (actual_step_factor step_segment transport)

private theorem edge {x y d : Nat} (hx : 0 < x) (xo : x % 2 = 1)
    (hy : 0 < y) (yo : y % 2 = 1) (hd : 0 < d) (hf : 3*x+1=2^d*y) :
    Segment x y 1 d 1 := by
  refine ⟨Physical.edge hx xo hy yo hd hf, ?_⟩
  simpa using hf.symm

-- The parameter k is defined by h=5+8k.
def U (k : Nat) : Nat := 10629127 + 17006112*k
def A (k : Nat) : Nat := 382648565 + 612220032*k
def V (k : Nat) : Nat := 15943691 + 25509168*k
def P (k : Nat) : Nat := 23915537 + 38263752*k
def X (k : Nat) : Nat := 17936653 + 28697814*k
def W (k : Nat) : Nat := 35873303 + 57395628*k
def Z (k : Nat) : Nat := 53809955 + 86093442*k

theorem coordinates (k : Nat) :
    U k = 307+2125764*(5+8*k) ∧ A k+7=36*U k ∧
    16*X k=27*U k+19 ∧ Z k+4=3*X k := by
  simp only [U,A,X,Z]
  omega

theorem original_segment (k : Nat) : Segment (U k) (X k) 3 4 19 := by
  have uv : Segment (U k) (V k) 1 1 1 := by
    apply edge <;> (try simp only [U,V]) <;> omega
  have vp : Segment (V k) (P k) 1 1 1 := by
    apply edge <;> (try simp only [V,P]) <;> omega
  have px : Segment (P k) (X k) 1 2 1 := by
    apply edge <;> (try simp only [P,X]) <;> omega
  exact StagedCylinder.compose (StagedCylinder.compose uv vp) px

theorem source_segment (k : Nat) : Segment (A k) (Z k) 2 6 35 := by
  have aw : Segment (A k) (W k) 1 5 1 := by
    apply edge <;> (try simp only [A,W]) <;> omega
  have wz : Segment (W k) (Z k) 1 1 1 := by
    apply edge <;> (try simp only [W,Z]) <;> omega
  exact StagedCylinder.compose aw wz

theorem entered_histories {N w k jn sn bn jw sw bw : Nat}
    (hn : Segment N (U k) jn sn bn) (hw : Segment w (A k) jw sw bw) :
    Segment N (X k) (jn+3) (sn+4) (27*bn+19*2^sn) ∧
    Segment w (Z k) (jw+2) (sw+6) (9*bw+35*2^sw) := by
  exact ⟨transport hn (original_segment k), transport hw (source_segment k)⟩

-- h=5 (mod 32): the next original valuation is at least three.
def contractedSource (k : Nat) : Nat := 80714933 + 516560652*k

private theorem divided_power {d : Nat} (hd : 1 ≤ d) :
    2^d = 2*2^(d-1) := by
  have hs : d = d-1+1 := by omega
  calc
    2^d = 2^(d-1+1) := congrArg (fun n : Nat => 2^n) hs
    _ = 2*2^(d-1) := by rw [Nat.pow_succ, Nat.mul_comm]

theorem height_kernel (k : Nat) :
    ∃ d : Nat, 3≤d ∧ Segment (X (4*k)) (step (X (4*k))) 1 d 1 ∧
      Segment (Z (4*k)) (contractedSource k) 1 1 1 ∧
      contractedSource k+7=3*2^(d-1)*step (X (4*k)) ∧
      128*step (X (4*k))≤81*U (4*k)+73 ∧ step (X (4*k))<U (4*k) := by
  have hx : 0<X (4*k) := by simp only [X] <;> omega
  have hxo : X (4*k)%2=1 := by simp only [X] <;> omega
  have hx8 : X (4*k)%8=5 := by simp only [X] <;> omega
  obtain ⟨d,hd,hf⟩ := actual_step_factor (X (4*k)) hxo
  have hyodd := step_odd (X (4*k))
  have hd3 : 3≤d := by
    by_cases enough : 3≤d
    · exact enough
    · have hcases : d=1 ∨ d=2 := by omega
      rcases hcases with h | h
      · have h1 : 3*X (4*k)+1=2*step (X (4*k)) := by simpa [h] using hf
        omega
      · have h2 : 3*X (4*k)+1=4*step (X (4*k)) := by simpa [h] using hf
        omega
  have hsource : Segment (Z (4*k)) (contractedSource k) 1 1 1 := by
    apply edge <;> (try simp only [contractedSource,Z]) <;> omega
  have hs : 2*(contractedSource k+7)=3*(3*X (4*k)+1) := by
    simp only [contractedSource,Z,X] <;> omega
  have he : 2*(contractedSource k+7)=2*(3*2^(d-1)*step (X (4*k))) := by
    rw [hs,hf,divided_power hd]
    ac_rfl
  have hrel : contractedSource k+7=3*2^(d-1)*step (X (4*k)) := by omega
  have hpow : 8≤2^d := by
    simpa using Nat.pow_le_pow_right (by decide : 0 < (2 : Nat)) hd3
  have hmul := Nat.mul_le_mul_right (step (X (4*k))) hpow
  have hbound : 128*step (X (4*k))≤81*U (4*k)+73 := by
    have hh := (coordinates (4*k)).2.2.1
    omega
  refine ⟨d,hd3,step_segment _ _ hx hxo hd hf,hsource,hrel,hbound,?_⟩
  have hu : 2<U (4*k) := by simp only [U] <;> omega
  omega

theorem height_histories {N w k jn sn bn jw sw bw : Nat}
    (hn : Segment N (X (4*k)) jn sn bn) (hw : Segment w (Z (4*k)) jw sw bw) :
    ∃ d : Nat, 3≤d ∧
      Segment N (step (X (4*k))) (jn+1) (sn+d) (3*bn+2^sn) ∧
      Segment w (contractedSource k) (jw+1) (sw+1) (3*bw+2^sw) ∧
      contractedSource k+7=3*2^(d-1)*step (X (4*k)) ∧ step (X (4*k))<U (4*k) := by
  obtain ⟨d,hd,tailN,tailW,hrel,_,hrank⟩ := height_kernel k
  refine ⟨d,hd,?_,?_,hrel,hrank⟩
  · simpa using transport hn tailN
  · simpa using transport hw tailW

-- h=29 (mod 32): two original ones lead to the next physical displacement 11.
def H (k : Nat) : Nat := 156045143 + 172186884*k
def L (k : Nat) : Nat := 234067715 + 258280326*k
def F (k : Nat) : Nat := 234067711 + 258280326*k

theorem frontier_kernel (k : Nat) :
    ∃ eta : Nat, 1≤eta ∧ Segment (X (4*k+3)) (L k) 2 2 5 ∧
      Segment (Z (4*k+3)) (step (F k)) 2 (2+eta) 7 ∧
      2^eta*step (F k)+11=3*L k ∧ X (4*k+3)<L k := by
  have xh : Segment (X (4*k+3)) (H k) 1 1 1 := by
    apply edge <;> (try simp only [H,X]) <;> omega
  have hl : Segment (H k) (L k) 1 1 1 := by
    apply edge <;> (try simp only [L,H,X]) <;> omega
  have zf : Segment (Z (4*k+3)) (F k) 1 2 1 := by
    apply edge <;> (try simp only [F,H,X,Z]) <;> omega
  have hfp : 0<F k := by simp only [F,H,X] <;> omega
  have hfo : F k%2=1 := by simp only [F,H,X] <;> omega
  obtain ⟨eta,he,hf⟩ := actual_step_factor (F k) hfo
  have fs := step_segment (F k) eta hfp hfo he hf
  refine ⟨eta,he,StagedCylinder.compose xh hl,StagedCylinder.compose zf fs,?_,?_⟩
  · rw [← hf]
    simp only [F,L,H,X] <;> omega
  · simp only [L,H,X] <;> omega

theorem frontier_histories {N w k jn sn bn jw sw bw : Nat}
    (hn : Segment N (X (4*k+3)) jn sn bn) (hw : Segment w (Z (4*k+3)) jw sw bw) :
    ∃ eta : Nat, 1≤eta ∧
      Segment N (L k) (jn+2) (sn+2) (9*bn+5*2^sn) ∧
      Segment w (step (F k)) (jw+2) (sw+(2+eta)) (9*bw+7*2^sw) ∧
      2^eta*step (F k)+11=3*L k := by
  obtain ⟨eta,he,tailN,tailW,hrel,_⟩ := frontier_kernel k
  exact ⟨eta,he,transport hn tailN,transport hw tailW,hrel⟩

-- A physical renewal through the displacement 11, valid at every x=55 mod 64.
def renewStart (k : Nat) : Nat := 55 + 64*k
def renewEnd (k : Nat) : Nat := 47 + 54*k

theorem renewal_segments (k : Nat) :
    Segment (renewStart k) (renewEnd k) 3 5 19 ∧
    Segment (3*renewStart k-4) (3*renewEnd k-4) 3 5 37 ∧
    renewEnd k < renewStart k := by
  have n1 : Segment (renewStart k) (83+96*k) 1 1 1 := by
    apply edge <;> (try simp only [renewStart]) <;> omega
  have n2 : Segment (83+96*k) (125+144*k) 1 1 1 := by
    apply edge <;> omega
  have n3 : Segment (125+144*k) (renewEnd k) 1 3 1 := by
    apply edge <;> (try simp only [renewEnd]) <;> omega
  have w1 : Segment (3*renewStart k-4) (121+144*k) 1 2 1 := by
    apply edge <;> (try simp only [renewStart]) <;> omega
  have w2 : Segment (121+144*k) (91+108*k) 1 2 1 := by
    apply edge <;> omega
  have w3 : Segment (91+108*k) (3*renewEnd k-4) 1 1 1 := by
    apply edge <;> (try simp only [renewEnd]) <;> omega
  refine ⟨StagedCylinder.compose (StagedCylinder.compose n1 n2) n3,
    StagedCylinder.compose (StagedCylinder.compose w1 w2) w3,?_⟩
  simp only [renewStart,renewEnd]
  omega

theorem renewal_measure (k : Nat) :
    (5*renewStart k-19)%64=0 ∧
    32*(5*renewEnd k-19)=27*(5*renewStart k-19) := by
  simp only [renewStart,renewEnd]
  omega

theorem renewal_reserve {k b r : Nat} (hb : 5≤b) (hr : r%2=1)
    (hf : 5*renewStart k-19=2^b*r) :
    5*renewEnd k-19=2^(b-5)*(27*r) ∧
      2^(b-5) ∣ 5*renewEnd k-19 ∧ ¬2^(b-5+1) ∣ 5*renewEnd k-19 := by
  have hs : b = b-5+5 := by omega
  have hp : 2^b = 2^(b-5)*32 := by
    calc
      2^b = 2^(b-5+5) := congrArg (fun n : Nat => 2^n) hs
      _ = 2^(b-5)*32 := by rw [Nat.pow_add]
  have hm := (renewal_measure k).2
  have he : 32*(5*renewEnd k-19) = 32*(2^(b-5)*(27*r)) := by
    rw [hm,hf,hp]
    ac_rfl
  have out := Nat.mul_left_cancel (by decide : 0 < (32 : Nat)) he
  exact ⟨out,P5R3S5.exact_reserve (by omega : (27*r)%2=1) out⟩

theorem realized_renewal (k : Nat) : X (31+32*k) = renewStart (14180763+14348907*k) := by
  simp only [X,renewStart]
  omega

theorem renewal_histories {N w k jn sn bn jw sw bw : Nat}
    (hn : Segment N (renewStart k) jn sn bn) (hw : Segment w (3*renewStart k-4) jw sw bw) :
    Segment N (renewEnd k) (jn+3) (sn+5) (27*bn+19*2^sn) ∧
    Segment w (3*renewEnd k-4) (jw+3) (sw+5) (27*bw+37*2^sw) ∧
    renewEnd k < renewStart k := by
  obtain ⟨ns,ws,hr⟩ := renewal_segments k
  exact ⟨transport hn ns,transport hw ws,hr⟩

end CollatzCharacterBridge.P5OddExit
