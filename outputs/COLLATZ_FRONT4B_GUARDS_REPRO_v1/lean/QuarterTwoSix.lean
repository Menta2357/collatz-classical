import P5R3S5

namespace CollatzCharacterBridge.QuarterTwoSix

open A2Header (Physical)
open StagedCylinder (Segment)
open FixedSourceRun (Ones)

set_option maxRecDepth 16000
set_option maxHeartbeats 1200000

def source (k d : Nat) : Nat := 2^(k+1)*d-1
def sourceRunEnd (k d : Nat) : Nat := 2*3^k*d-1
def originalRunEnd (k d : Nat) : Nat := 2*3^(k+2)*d-1
def S (t : Nat) : Nat := 73+128*t
def A (t : Nat) : Nat := 55+96*t
def D (t : Nat) : Nat := 83+144*t
def W (t : Nat) : Nat := 125+216*t
def Y (t : Nat) : Nat := 661+1152*t
def Z (t : Nat) : Nat := 31+54*t
def endpoint (t : Nat) : Nat := step (Z t)
def originalCost (k : Nat) : Nat := 3^(k+5)+1000*2^k
def sourceCost (k : Nat) : Nat := 3^(k+5)+250*2^k

/-- r=k+2 is an unbounded run. The odd cofactor makes its length exact.
The S-coordinate is the physical quarter-source endpoint; its phase
encodes original rupture two followed by original valuation six. -/
structure Entry (N V k d t : Nat) : Prop where
  cofactor_positive : 0<d
  cofactor_odd : d%2=1
  origin_factor : V+1=2^(k+3)*d
  source_checkpoint : 3^(k+1)*d=2*S t+1
  paid_window : V<2*N+1

theorem ones_physical {x m : Nat} (hx : 0<x) (hxo : x%2=1)
    (h : Ones x m) : Physical x m m (orbit x m) := by
  induction m with
  | zero => exact Physical.refl x
  | succ m ih =>
    have hp : Ones x m := fun i hi => h i (by omega)
    have he : Physical (orbit x m) 1 1 (orbit x (m+1)) :=
      Physical.edge (orbit_pos x hx m) (orbit_odd x hxo m)
        (orbit_pos x hx (m+1)) (orbit_odd x hxo (m+1)) (by decide) (h m (by omega))
    exact Physical.append (ih hp) he

theorem ones_segment {x m : Nat} (hx : 0<x) (hxo : x%2=1)
    (h : Ones x m) : Segment x (orbit x m) m m (3^m-2^m) := by
  refine ⟨ones_physical hx hxo h,?_⟩
  have hb := FixedSourceRun.ones_balanced x m h
  have hl : 2^m≤3^m := Nat.pow_le_pow_left (by decide) m
  simp only [Nat.mul_add,Nat.mul_one] at hb
  omega

theorem entry_admissible {N V k d t : Nat} (e : Entry N V k d t) :
    0<V ∧ V%2=1 ∧ 0<source k d ∧ source k d%2=1 ∧
    4*source k d+3=V ∧ source k d=(V-3)/4 ∧ source k d<N := by
  have ha : 0<2^k*d := Nat.mul_pos (Nat.pow_pos (by decide)) e.cofactor_positive
  have hv : 2^(k+3)*d=8*(2^k*d) := by
    rw [Nat.pow_add 2 k 3]
    change (2^k*8)*d=8*(2^k*d)
    ac_rfl
  have hw : 2^(k+1)*d=2*(2^k*d) := by rw [Nat.pow_succ]; ac_rfl
  have hf := e.origin_factor
  have hpaid := e.paid_window
  rw [hv] at hf
  simp only [source,hw]
  omega

theorem fixed_relations (t : Nat) :
    Y t=9*S t+4 ∧ W t=4*Z t+1 ∧
    3*Y t+1=2^6*Z t ∧ 3*S t+1=2^2*A t ∧
    3*A t+1=2*D t ∧ 3*D t+1=2*W t := by
  simp only [Y,S,W,Z,A,D]
  omega

theorem fixed_heads (t : Nat) :
    Segment (Y t) (Z t) 1 6 1 ∧ Segment (S t) (A t) 1 2 1 ∧
    Segment (A t) (D t) 1 1 1 ∧ Segment (D t) (W t) 1 1 1 := by
  refine ⟨?_,?_,?_,?_⟩
  all_goals
    constructor
    · apply Physical.edge
      all_goals try simp only [Y,S,W,Z,A,D]
      all_goals omega
    · simp only [Y,S,W,Z,A,D]
      omega

theorem terminal_factors (t : Nat) :
    ∃ β : Nat, 1≤β ∧ 3*Z t+1=2^β*endpoint t ∧
      3*W t+1=2^(β+2)*endpoint t := by
  have hz : Z t%2=1 := by simp only [Z]; omega
  obtain ⟨β,hβ,hf⟩ := P5R3S5.actual_step_factor (Z t) hz
  change 3*Z t+1=2^β*endpoint t at hf
  refine ⟨β,hβ,hf,?_⟩
  have hpow : 2^(β+2)*endpoint t=4*(2^β*endpoint t) := by
    rw [Nat.pow_add 2 β 2]
    change (2^β*4)*endpoint t=4*(2^β*endpoint t)
    ac_rfl
  rw [hpow,←hf]
  simp only [W,Z]
  omega

theorem terminal_segments {t β : Nat} (hβ : 1≤β)
    (hf : 3*Z t+1=2^β*endpoint t)
    (hg : 3*W t+1=2^(β+2)*endpoint t) :
    Segment (Z t) (endpoint t) 1 β 1 ∧
    Segment (W t) (endpoint t) 1 (β+2) 1 := by
  have hp : 0<endpoint t := step_pos _
  have ho : endpoint t%2=1 := step_odd _
  constructor
  · exact ⟨Physical.edge (by simp only [Z]; omega) (by simp only [Z]; omega)
      hp ho (by omega) hf,hf.symm⟩
  · exact ⟨Physical.edge (by simp only [W]; omega) (by simp only [W]; omega)
      hp ho (by omega) hg,hg.symm⟩

theorem local_tails {t β : Nat} (hβ : 1≤β)
    (hf : 3*Z t+1=2^β*endpoint t)
    (hg : 3*W t+1=2^(β+2)*endpoint t) :
    Segment (Y t) (endpoint t) 2 (6+β) 67 ∧
    Segment (S t) (endpoint t) 4 (6+β) 103 := by
  have hh := fixed_heads t
  have he := terminal_segments hβ hf hg
  constructor
  · exact StagedCylinder.compose hh.1 he.1
  · have p2 := StagedCylinder.compose hh.2.1 hh.2.2.1
    have p3 := StagedCylinder.compose p2 hh.2.2.2
    have p4 := StagedCylinder.compose p3 he.2
    rw [show (2+1+1)+(β+2)=6+β by omega] at p4
    exact p4

theorem prefix_runs {N V k d t : Nat} (e : Entry N V k d t) :
    Segment V (originalRunEnd k d) (k+2) (k+2) (3^(k+2)-2^(k+2)) ∧
    Segment (source k d) (sourceRunEnd k d) k k (3^k-2^k) ∧
    Ones V (k+2) ∧ Ones (source k d) k := by
  have ha := entry_admissible e
  have hv : V=2^(k+2+1)*d-1 := by
    rw [show k+2+1=k+3 by omega]
    have hf := e.origin_factor
    omega
  have po := FixedSourceRun.ones_prefix (k+2) d e.cofactor_positive
  have ps := FixedSourceRun.ones_prefix k d e.cofactor_positive
  rw [←hv] at po
  change orbit V (k+2)=originalRunEnd k d ∧ Ones V (k+2) at po
  change orbit (source k d) k=sourceRunEnd k d ∧ Ones (source k d) k at ps
  have so := ones_segment ha.1 ha.2.1 po.2
  have ss := ones_segment ha.2.2.1 ha.2.2.2.1 ps.2
  rw [po.1] at so
  rw [ps.1] at ss
  exact ⟨so,ss,po.2,ps.2⟩

theorem exact_two_breaks {N V k d t : Nat} (e : Entry N V k d t) :
    Segment (originalRunEnd k d) (Y t) 1 2 1 ∧
    Segment (sourceRunEnd k d) (S t) 1 2 1 := by
  have ha : 0<3^k*d := Nat.mul_pos (Nat.pow_pos (by decide)) e.cofactor_positive
  have h3 : 3^(k+1)*d=3*(3^k*d) := by rw [Nat.pow_succ]; ac_rfl
  have h2 : 2*3^k*d=2*(3^k*d) := by ac_rfl
  have h9 : 2*3^(k+2)*d=18*(3^k*d) := by
    rw [Nat.pow_add 3 k 2]
    change 2*(3^k*9)*d=(2*9)*(3^k*d)
    ac_rfl
  have hs := e.source_checkpoint
  rw [h3] at hs
  simp only [S] at hs
  constructor
  · constructor
    · apply Physical.edge
      all_goals try simp only [originalRunEnd,h9,Y,S]
      all_goals omega
    · simp only [originalRunEnd,h9,Y,S] at *
      omega
  · constructor
    · apply Physical.edge
      all_goals try simp only [sourceRunEnd,h2,S]
      all_goals omega
    · simp only [sourceRunEnd,h2,S] at *
      omega

theorem original_cost_identity (k : Nat) :
    3^3*(3^(k+2)-2^(k+2))+277*2^(k+2)=originalCost k := by
  have hl : 2^(k+2)≤3^(k+2) := Nat.pow_le_pow_left (by decide) (k+2)
  have hp2 : 2^(k+2)=4*2^k := by
    rw [Nat.pow_add 2 k 2]
    change 2^k*4=4*2^k
    ac_rfl
  have hp3 : 3^(k+5)=27*3^(k+2) := by
    rw [show k+5=(k+2)+3 by omega,Nat.pow_add 3 (k+2) 3]
    change 3^(k+2)*27=27*3^(k+2)
    ac_rfl
  change 27*(3^(k+2)-2^(k+2))+277*2^(k+2)=3^(k+5)+1000*2^k
  omega

theorem source_cost_identity (k : Nat) :
    3^5*(3^k-2^k)+493*2^k=sourceCost k := by
  have hl : 2^k≤3^k := Nat.pow_le_pow_left (by decide) k
  have hp3 : 3^(k+5)=243*3^k := by
    rw [Nat.pow_add 3 k 5]
    change 3^k*243=243*3^k
    ac_rfl
  change 243*(3^k-2^k)+493*2^k=3^(k+5)+250*2^k
  omega

structure Certificate (N V k d t β : Nat) : Prop where
  entry : Entry N V k d t
  beta_positive : 1≤β
  actual_original_last : 3*Z t+1=2^β*endpoint t
  actual_source_last : 3*W t+1=2^(β+2)*endpoint t
  source_positive : 0<source k d
  source_odd : source k d%2=1
  source_smaller : source k d<N
  source_formula : source k d=(V-3)/4
  original : Segment V (endpoint t) (k+5) (k+10+β) (originalCost k)
  smaller : Segment (source k d) (endpoint t) (k+5) (k+8+β) (sourceCost k)

theorem certificate {N V k d t : Nat} (e : Entry N V k d t) :
    ∃ β : Nat, Certificate N V k d t β := by
  obtain ⟨β,hβ,hf,hg⟩ := terminal_factors t
  have hp := prefix_runs e
  have hb := exact_two_breaks e
  have ht := local_tails hβ hf hg
  have ot := StagedCylinder.compose hb.1 ht.1
  have st := StagedCylinder.compose hb.2 ht.2
  rw [show 2+(6+β)=8+β by omega] at ot st
  have original := P5R3S5.transport hp.1 ot
  have smaller := P5R3S5.transport hp.2.1 st
  rw [show (k+2)+3=k+5 by omega,show (k+2)+(8+β)=k+10+β by omega,
    original_cost_identity k] at original
  rw [show k+(8+β)=k+8+β by omega,
    source_cost_identity k] at smaller
  have ha := entry_admissible e
  exact ⟨β,e,hβ,hf,hg,ha.2.2.1,ha.2.2.2.1,ha.2.2.2.2.2.2,
    ha.2.2.2.2.2.1,original,smaller⟩

theorem original_history {N V k d t β j σ B : Nat}
    (c : Certificate N V k d t β) (history : Segment N V j σ B) :
    Segment N (endpoint t) (j+k+5) (σ+k+10+β)
      (3^(k+5)*B+originalCost k*2^σ) := by
  have hh := P5R3S5.transport history c.original
  simpa only [Nat.add_assoc] using hh

theorem orbit_meeting {N V k d t β j σ B : Nat}
    (c : Certificate N V k d t β) (history : Segment N V j σ B) :
    orbit N (j+k+5)=orbit (source k d) (k+5) := by
  exact (A2Header.physical_endpoint (original_history c history).physical).trans
    (A2Header.physical_endpoint c.smaller.physical).symm

private theorem one_orbit (i : Nat) : orbit 1 i=1 := by
  induction i with
  | zero => rfl
  | succ i ih =>
    change step (orbit 1 i)=1
    rw [ih]
    change oddPart 4=1
    exact (oddPart_quadruple 1).trans (oddPart_of_odd (by decide))

theorem closes_under_IH {N V k d t β j σ B : Nat}
    (c : Certificate N V k d t β) (history : Segment N V j σ B)
    (IH : ∀ n : Nat, 0<n → n%2=1 → n<N → ∃ i, orbit n i=1) :
    ∃ i, orbit N i=1 := by
  obtain ⟨i,hi⟩ := IH (source k d) c.source_positive c.source_odd c.source_smaller
  have hm := orbit_meeting c history
  refine ⟨(j+k+5)+i,?_⟩
  rw [orbit_add,hm,←orbit_add,Nat.add_comm (k+5) i,orbit_add,hi,one_orbit]

#print axioms ones_physical
#print axioms ones_segment
#print axioms entry_admissible
#print axioms fixed_relations
#print axioms fixed_heads
#print axioms terminal_factors
#print axioms terminal_segments
#print axioms local_tails
#print axioms prefix_runs
#print axioms exact_two_breaks
#print axioms original_cost_identity
#print axioms source_cost_identity
#print axioms certificate
#print axioms original_history
#print axioms orbit_meeting
#print axioms one_orbit
#print axioms closes_under_IH

end CollatzCharacterBridge.QuarterTwoSix
