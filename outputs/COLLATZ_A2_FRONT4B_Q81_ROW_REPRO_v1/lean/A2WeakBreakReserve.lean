import A2HalfAdaptive

namespace CollatzCharacterBridge.A2WeakBreakReserve

open A2Header (Physical)
open StagedCylinder (Segment compose)

set_option maxRecDepth 16000
set_option maxHeartbeats 400000

/-- Add the exact book to the sealed physical proof of an arbitrary
    number of macros of valuations (1,2). -/
theorem macro_segment (m t : Nat) (large : 3≤t) :
    Segment (2^(3*m+1)*t-5) (2*3^(2*m)*t-5) (2*m) (3*m)
      (5*(3^(2*m)-2^(3*m))) := by
  have power_order : (2:Nat)^(3*m)≤3^(2*m) := by
    rw [Nat.pow_mul 2 3 m,Nat.pow_mul 3 2 m]
    exact Nat.pow_le_pow_left (by decide) m
  have p_pos : 1≤(2:Nat)^(3*m) := Nat.pow_pos (by decide)
  have q_pos : 1≤(3:Nat)^(2*m) := Nat.pow_pos (by decide)
  have p_floor : 5≤2^(3*m+1)*t := by
    have bound := Nat.mul_le_mul_right t p_pos
    rw [Nat.one_mul] at bound
    rw [Nat.pow_succ]
    have rearrange : ((2:Nat)^(3*m)*2)*t=2*(2^(3*m)*t) := by ac_rfl
    rw [rearrange]
    omega
  have q_floor : 5≤2*3^(2*m)*t := by
    have bound := Nat.mul_le_mul_right t q_pos
    rw [Nat.one_mul] at bound
    rw [Nat.mul_assoc]
    omega
  have scaled :
      2^(3*m)*(2*3^(2*m)*t-5)+5*2^(3*m)=
        3^(2*m)*(2^(3*m+1)*t-5)+5*3^(2*m) := by
    calc
      _ = 2^(3*m)*((2*3^(2*m)*t-5)+5) := by rw [Nat.mul_add]; ac_rfl
      _ = 2^(3*m)*(2*3^(2*m)*t) := by rw [Nat.sub_add_cancel q_floor]
      _ = 3^(2*m)*(2^(3*m+1)*t) := by rw [Nat.pow_succ 2 (3*m)]; ac_rfl
      _ = 3^(2*m)*((2^(3*m+1)*t-5)+5) := by rw [Nat.sub_add_cancel p_floor]
      _ = _ := by rw [Nat.mul_add]; ac_rfl
  have additive :
      5*(3^(2*m)-2^(3*m))+5*2^(3*m)=5*3^(2*m) := by
    rw [←Nat.mul_add,Nat.sub_add_cancel power_order]
  exact ⟨A2Header.pairs_physical m t (by omega),by omega⟩

/-- The two tracks are kept distinct. The odd cofactor certifies that
    D is the exact reserve at their input. -/
theorem reserve_segments {D u V W : Nat}
    (depth : 1≤D) (positive : 0<u) (odd : u%2=1)
    (reserve : W+1=2^D*u) (link : V+5=6*(W+1)) :
    let m := D/3
    let s := D%3
    let X := 2^(s+1)*3^(2*m+1)*u-5
    let Y := 2*3^(D-1)*u-1
    Segment V X (2*m) (3*m) (5*(3^(2*m)-2^(3*m))) ∧
      Segment W Y (D-1) (D-1) (3^(D-1)-2^(D-1)) ∧
      2^D ∣ W+1 ∧ ¬2^(D+1) ∣ W+1 := by
  let m := D/3
  let s := D%3
  let t := 3*2^s*u
  have decomposition : D=3*m+s := by dsimp only [m,s]; omega
  have power : 2^(3*m+1)*t=6*(2^D*u) := by
    simp only [t]
    rw [decomposition,Nat.pow_add 2 (3*m) s,Nat.pow_succ 2 (3*m),show (6:Nat)=2*3 by decide]
    ac_rfl
  have start_V : V=2^(3*m+1)*t-5 := by rw [power,←reserve,←link]; omega
  have end_V : 2*3^(2*m)*t-5=2^(s+1)*3^(2*m+1)*u-5 := by
    rw [Nat.pow_succ 2 s,Nat.pow_succ 3 (2*m)]
    simp only [t]
    congr 1
    ac_rfl
  have t_pos : 3≤t := by
    have scaled : 0<2^s*u := Nat.mul_pos (Nat.pow_pos (by decide)) positive
    have coordinate : t=3*(2^s*u) := by simp only [t,Nat.mul_assoc]
    omega
  have original := macro_segment m t t_pos
  rw [←start_V,end_V] at original
  have index : D-1+1=D := by omega
  have twice : W+1=2*(2^(D-1)*u) := by
    calc
      _ = 2^D*u := reserve
      _ = 2^(D-1+1)*u := congrArg (fun n : Nat => 2^n*u) index.symm
      _ = _ := by rw [Nat.pow_succ]; ac_rfl
  have W_eq : W=2^(D-1+1)*u-1 := by rw [index]; omega
  have scaled : 0<2^(D-1)*u := Nat.mul_pos (Nat.pow_pos (by decide)) positive
  have W_pos : 0<W := by omega
  have W_odd : W%2=1 := by omega
  have run := FixedSourceRun.ones_prefix (D-1) u positive
  rw [←W_eq] at run
  have auxiliary := A2HalfAdaptive.ones_segment W (D-1) W_pos W_odd run.2
  rw [run.1] at auxiliary
  exact ⟨original,auxiliary,P5R3S5.exact_reserve odd reserve⟩

/-- Compose both independent incoming books from the same respective
    origins. The parameters D and the number of pairs are unbounded. -/
theorem paired_histories {N V w W j S B k Q C D u : Nat}
    (original_history : Segment N V j S B)
    (source_history : Segment w W k Q C)
    (depth : 1≤D) (positive : 0<u) (odd : u%2=1)
    (reserve : W+1=2^D*u) (link : V+5=6*(W+1)) :
    let m := D/3
    let s := D%3
    let X := 2^(s+1)*3^(2*m+1)*u-5
    let Y := 2*3^(D-1)*u-1
    Segment N X (j+2*m) (S+3*m) (3^(2*m)*B+2^S*(5*(3^(2*m)-2^(3*m)))) ∧
      Segment w Y (k+(D-1)) (Q+(D-1))
        (3^(D-1)*C+2^Q*(3^(D-1)-2^(D-1))) := by
  obtain ⟨original,auxiliary,_⟩ := reserve_segments depth positive odd reserve link
  exact ⟨compose original_history original,compose source_history auxiliary⟩

end CollatzCharacterBridge.A2WeakBreakReserve
