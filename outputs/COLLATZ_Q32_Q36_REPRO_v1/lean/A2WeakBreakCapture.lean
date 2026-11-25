import A2HalfAdaptive

namespace CollatzCharacterBridge.A2WeakBreakCapture

open StagedCylinder (Segment compose)
open A2HalfAdaptive (half ones_segment)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

private theorem edge {x y a : Nat} (hx : 0<x) (hxo : x%2=1)
    (hy : y%2=1) (ha : 0<a) (hf : 3*x+1=2^a*y) :
    Segment x y 1 a 1 :=
  ⟨A2Header.Physical.edge hx hxo (by omega) hy ha hf, by simpa using hf.symm⟩

private theorem opening {N P k v : Nat} (hv : 0<v)
    (hP : P+1=2^(k+2)*v) (height : P<2*N+1) :
    let F := 2*3^k*v-1
    let X := 2*3^(k+1)*v-1
    0<half P ∧ half P%2=1 ∧ half P<N ∧
      0<F ∧ F%2=1 ∧ 0<X ∧ X%2=1 ∧ X=3*F+2 ∧
      Segment P X (k+1) (k+1) (3^(k+1)-2^(k+1)) ∧
      Segment (half P) F k k (3^k-2^k) := by
  dsimp only
  have ht : 0<2^k*v := Nat.mul_pos (Nat.pow_pos (by decide)) hv
  have hq : 0<3^k*v := Nat.mul_pos (Nat.pow_pos (by decide)) hv
  have scale : 2^(k+1)*v=2*(2^k*v) := by rw [Nat.pow_succ]; ac_rfl
  have scale' : 2^(k+2)*v=2*(2^(k+1)*v) := by rw [Nat.pow_succ]; ac_rfl
  have trip : 3^(k+1)*v=3*(3^k*v) := by rw [Nat.pow_succ]; ac_rfl
  have Pform : P=2^(k+2)*v-1 := by omega
  have Wform : half P=2^(k+1)*v-1 := by unfold half; omega
  have ppos : 0<P := by omega
  have po : P%2=1 := by omega
  have wpos : 0<half P := by omega
  have wo : half P%2=1 := by omega
  obtain ⟨xeq,xrun⟩ := FixedSourceRun.ones_prefix (k+1) v hv
  obtain ⟨feq,frun⟩ := FixedSourceRun.ones_prefix k v hv
  rw [←Pform] at xeq xrun
  rw [←Wform] at feq frun
  have xs := ones_segment P (k+1) ppos po xrun
  have fs := ones_segment (half P) k wpos wo frun
  rw [xeq] at xs
  rw [feq] at fs
  have lin : 2*3^(k+1)*v=6*(3^k*v) := by rw [Nat.mul_assoc,trip]; omega
  have lin' : 2*3^k*v=2*(3^k*v) := by ac_rfl
  refine ⟨wpos,wo,by omega,by omega,by omega,by omega,by omega,by omega,xs,fs⟩

/-- The shifted auxiliary state takes the same final real edge, with two
additional powers of two. Both clocks keep that last exponent free. -/
private theorem join_edge {A K e : Nat} (ho : K%2=1) (he : 0<e)
    (h : 3*A+1=2^e*K) : Segment (4*A+1) K 1 (e+2) 1 := by
  apply edge (by omega) (by omega) ho (by omega)
  calc
    3*(4*A+1)+1=4*(3*A+1) := by omega
    _=2^(e+2)*K := by
      rw [h,Nat.pow_add]
      change 4*(2^e*K)=(2^e*4)*K
      ac_rfl

private theorem source_six_start {F V U : Nat} (hf : 9*F+7=4*V)
    (d : 3*V+1=64*U) (uo : U%2=1) :
    let Y := (3*F+1)/16
    3*F+1=16*Y ∧ 0<Y ∧ Y%8=7 ∧ 9*Y+1=16*U := by
  dsimp only
  omega

private theorem source_six_end {Y U : Nat} (ys : Y%8=7) (hy : 9*Y+1=16*U) :
    let L := (3*Y+1)/2
    3*Y+1=2*L ∧ 0<L ∧ L%2=1 ∧ 3*L+1=2*(4*U+1) := by
  dsimp only
  omega

private theorem source_one_six_start {F V U A : Nat} (hf : 9*F+7=4*V)
    (d : 3*V+1=2*U) (six : 3*U+1=64*A) :
    let Y := (3*F+1)/8
    3*F+1=8*Y ∧ 0<Y ∧ Y%16=11 ∧ 27*Y+7=64*A := by
  dsimp only
  omega

private theorem source_one_six_end {Y A : Nat} (ys : Y%16=11) (hy : 27*Y+7=64*A) :
    let L := (3*Y+1)/2
    let M := (3*L+1)/4
    (3*Y+1=2*L ∧ 0<L ∧ L%2=1) ∧
      (3*L+1=4*M ∧ 0<M ∧ M%2=1 ∧ 3*M+1=2*(4*A+1)) := by
  dsimp only
  omega

/-- Physical words are (1^(k+1),2,6,e) from P and
(1^k,4,1,1,e+2) from the paid source. -/
theorem history_two_six {N P j S B k v V U K e : Nat}
    (history : Segment N P j S B) (hv : 0<v)
    (hP : P+1=2^(k+2)*v) (height : P<2*N+1)
    (vo : V%2=1) (uo : U%2=1) (ko : K%2=1) (he : 0<e)
    (b : 3*(2*3^(k+1)*v-1)+1=4*V)
    (d : 3*V+1=64*U) (last : 3*U+1=2^e*K) :
    0<half P ∧ half P%2=1 ∧ half P<N ∧
      Segment N K (j+(k+4)) (S+(k+9+e))
        (3^(k+4)*B+(27*(3^(k+1)-2^(k+1))+2^(k+1)*277)*2^S) ∧
      Segment (half P) K (k+4) (k+8+e) (81*(3^k-2^k)+2^k*331) := by
  let F := 2*3^k*v-1
  let X := 2*3^(k+1)*v-1
  obtain ⟨wp,wo,paid,fp,fo,xp,xo,rel,xs,fs⟩ := opening hv hP height
  change X=3*F+2 at rel
  change 3*X+1=4*V at b
  have hf : 9*F+7=4*V := by omega
  let Y := (3*F+1)/16
  have yh := source_six_start hf d uo
  let L := (3*Y+1)/2
  have l := source_six_end yh.2.2.1 yh.2.2.2
  have o1 : Segment X V 1 2 1 := edge xp xo vo (by decide) b
  have o2 : Segment V U 1 6 1 := edge (by omega) vo uo (by decide) d
  have o3 : Segment U K 1 e 1 := edge (by omega) uo ko he last
  have a1 : Segment F Y 1 4 1 := edge fp fo (by omega) (by decide) yh.1
  have a2 : Segment Y L 1 1 1 := edge yh.2.1 (by omega) l.2.2.1 (by decide) l.1
  have a3 : Segment L (4*U+1) 1 1 1 :=
    edge l.2.1 l.2.2.1 (by omega) (by decide) l.2.2.2
  have orig : Segment X K 3 (8+e) 277 := compose (compose o1 o2) o3
  have src : Segment F K 4 (8+e) 331 := by
    have h := compose (compose (compose a1 a2) a3) (join_edge ko he last)
    rw [show 4+1+1+(e+2)=8+e by omega] at h
    exact h
  have p := compose xs orig
  have w := compose fs src
  change Segment P K (k+1+3) (k+1+(8+e))
    (27*(3^(k+1)-2^(k+1))+2^(k+1)*277) at p
  rw [show k+1+3=k+4 by omega, show k+1+(8+e)=k+9+e by omega] at p
  have ew : k+(8+e)=k+8+e := by omega
  rw [ew] at w
  exact ⟨wp,wo,paid,P5R3S5.transport history p,w⟩

/-- Physical words are (1^(k+1),2,1,6,e) from P and
(1^k,3,1,2,1,e+2) from the paid source. -/
theorem history_two_one_six {N P j S B k v V U A K e : Nat}
    (history : Segment N P j S B) (hv : 0<v)
    (hP : P+1=2^(k+2)*v) (height : P<2*N+1)
    (vo : V%2=1) (uo : U%2=1) (ao : A%2=1) (ko : K%2=1) (he : 0<e)
    (b : 3*(2*3^(k+1)*v-1)+1=4*V)
    (d : 3*V+1=2*U) (six : 3*U+1=64*A) (last : 3*A+1=2^e*K) :
    0<half P ∧ half P%2=1 ∧ half P<N ∧
      Segment N K (j+(k+5)) (S+(k+10+e))
        (3^(k+5)*B+(81*(3^(k+1)-2^(k+1))+2^(k+1)*599)*2^S) ∧
      Segment (half P) K (k+5) (k+9+e) (243*(3^k-2^k)+2^k*761) := by
  let F := 2*3^k*v-1
  let X := 2*3^(k+1)*v-1
  obtain ⟨wp,wo,paid,fp,fo,xp,xo,rel,xs,fs⟩ := opening hv hP height
  change X=3*F+2 at rel
  change 3*X+1=4*V at b
  have hf : 9*F+7=4*V := by omega
  let Y := (3*F+1)/8
  have yh := source_one_six_start hf d six
  let L := (3*Y+1)/2
  let M := (3*L+1)/4
  obtain ⟨l,m⟩ := source_one_six_end yh.2.2.1 yh.2.2.2
  have o1 : Segment X V 1 2 1 := edge xp xo vo (by decide) b
  have o2 : Segment V U 1 1 1 := edge (by omega) vo uo (by decide) d
  have o3 : Segment U A 1 6 1 := edge (by omega) uo ao (by decide) six
  have o4 : Segment A K 1 e 1 := edge (by omega) ao ko he last
  have a1 : Segment F Y 1 3 1 := edge fp fo (by omega) (by decide) yh.1
  have a2 : Segment Y L 1 1 1 := edge yh.2.1 (by omega) l.2.2 (by decide) l.1
  have a3 : Segment L M 1 2 1 := edge l.2.1 l.2.2 m.2.2.1 (by decide) m.1
  have a4 : Segment M (4*A+1) 1 1 1 :=
    edge m.2.1 m.2.2.1 (by omega) (by decide) m.2.2.2
  have orig : Segment X K 4 (9+e) 599 := compose (compose (compose o1 o2) o3) o4
  have src : Segment F K 5 (9+e) 761 := by
    have h := compose (compose (compose (compose a1 a2) a3) a4) (join_edge ko he last)
    rw [show 3+1+2+1+(e+2)=9+e by omega] at h
    exact h
  have p := compose xs orig
  have w := compose fs src
  change Segment P K (k+1+4) (k+1+(9+e))
    (81*(3^(k+1)-2^(k+1))+2^(k+1)*599) at p
  rw [show k+1+4=k+5 by omega, show k+1+(9+e)=k+10+e by omega] at p
  have ew : k+(9+e)=k+9+e := by omega
  rw [ew] at w
  exact ⟨wp,wo,paid,P5R3S5.transport history p,w⟩

end CollatzCharacterBridge.A2WeakBreakCapture
