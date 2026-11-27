import FixedSourceRun
import Arrival

namespace CollatzCharacterBridge.TwosCompression

set_option maxRecDepth 12000
set_option maxHeartbeats 800000

def Twos (x r : Nat) : Prop :=
  ∀ i : Nat, i<r → 3*orbit x i+1=4*orbit x (i+1)
def runStart (t A : Nat) : Nat := 1+2*4^t*A
def runEnd (t A : Nat) : Nat := 1+2*3^t*A
def count (k : Nat) : Nat := (k-1)/2
def seed (k H : Nat) : Nat := 1+2^k*H
def endpoint (k H : Nat) : Nat := 1+3^(count k)*2^(k-2*count k)*H

private theorem strip_pow (a y : Nat) : oddPart (2^a*y)=oddPart y := by
  induction a with
  | zero => simp
  | succ a ih =>
    rw [Nat.pow_succ]
    have he : 2^a*2*y=2*(2^a*y) := by ac_rfl
    rw [he,oddPart_double,ih]

private theorem physical_step {x a y : Nat} (ho : y%2=1)
    (hf : 3*x+1=2^a*y) : step x=y := by
  unfold step
  rw [hf,strip_pow,oddPart_of_odd ho]

private theorem odd_head (x i : Nat) : orbit x (i+1)=orbit (step x) i :=
  (congrArg (orbit x) (show i+1=1+i by omega)).trans (orbit_add x 1 i)

private theorem two_core (A : Nat) :
    step (1+8*A)=1+6*A ∧ 3*(1+8*A)+1=4*(1+6*A) := by
  exact ⟨physical_step (a:=2) (by omega) (by omega),by omega⟩

/-- A generic exact physical run; A may be even. Oddness of H will
subsequently determine which of the two maximal exits occurs. -/
theorem two_prefix (t A : Nat) :
    orbit (runStart t A) t=runEnd t A ∧ Twos (runStart t A) t := by
  induction t generalizing A with
  | zero =>
    constructor
    · simp only [orbit,runStart,runEnd,Nat.pow_zero]
    · intro i hi; omega
  | succ t ih =>
    have hin : runStart (t+1) A=1+8*(4^t*A) := by
      unfold runStart
      rw [Nat.pow_succ]
      change 1+2*(4^t*4)*A=1+(2*4)*(4^t*A)
      ac_rfl
    have hmid : runStart t (3*A)=1+6*(4^t*A) := by
      unfold runStart
      change 1+2*4^t*(3*A)=1+(2*3)*(4^t*A)
      ac_rfl
    have hcore := two_core (4^t*A)
    have hs : step (runStart (t+1) A)=runStart t (3*A) := by rw [hin,hmid]; exact hcore.1
    have hf : 3*runStart (t+1) A+1=4*runStart t (3*A) := by rw [hin,hmid]; exact hcore.2
    have hi := ih (3*A)
    constructor
    · rw [odd_head,hs,hi.1]
      unfold runEnd
      rw [Nat.pow_succ]
      ac_rfl
    · intro i hiBound
      cases i with
      | zero =>
        change 3*runStart (t+1) A+1=4*step (runStart (t+1) A)
        rw [hs]
        exact hf
      | succ i =>
        rw [odd_head (runStart (t+1) A) i,odd_head (runStart (t+1) A) (i+1),hs]
        exact hi.2 i (by omega)

theorem local_ledger (t A : Nat) :
    4^t*runEnd t A=3^t*runStart t A+(4^t-3^t) := by
  have hp : 3^t≤4^t := Nat.pow_le_pow_left (by decide) t
  have he : 4^t*(2*3^t*A)=3^t*(2*4^t*A) := by ac_rfl
  simp only [runStart,runEnd,Nat.mul_add,Nat.mul_one]
  rw [he]
  omega

theorem power_conversion (t : Nat) : 2^(2*t)=4^t := by
  simpa only [show (2:Nat)^2=4 by decide] using Nat.pow_mul 2 2 t

theorem odd_start (t H : Nat) : runStart t H=1+2^(2*t+1)*H := by
  rw [Nat.pow_add 2 (2*t) 1,power_conversion]
  unfold runStart
  simp only [Nat.pow_one]
  ac_rfl

theorem even_start (t H : Nat) : runStart t (2*H)=1+2^(2*t+2)*H := by
  rw [Nat.pow_add 2 (2*t) 2,power_conversion]
  unfold runStart
  change 1+2*4^t*(2*H)=1+(4^t*(2*2))*H
  ac_rfl

private theorem odd_product (t H : Nat) (ho : H%2=1) : (3^t*H)%2=1 := by
  simp [Nat.mul_mod,Nat.pow_mod,ho]

theorem odd_exit (t H : Nat) (ho : H%2=1) :
    3*runEnd t H+1=2*step (runEnd t H) ∧
    3*runEnd t H+1≠4*step (runEnd t H) := by
  have hp := odd_product t H ho
  have he : runEnd t H=1+2*(3^t*H) := by unfold runEnd; ac_rfl
  have h4 : runEnd t H%4=3 := by rw [he]; omega
  have hf := step_mul_two h4
  have hz := step_pos (runEnd t H)
  constructor <;> omega

theorem even_phase (t H : Nat) (ho : H%2=1) : runEnd t (2*H)%8=5 := by
  have hp := odd_product t H ho
  have he : runEnd t (2*H)=1+4*(3^t*H) := by
    unfold runEnd
    change 1+2*3^t*(2*H)=1+(2*2)*(3^t*H)
    ac_rfl
  rw [he]
  omega

theorem real_strong_factor (z : Nat) (hz : z%8=5) :
    ∃ b : Nat, 3≤b ∧ 3*z+1=2^b*step z := by
  obtain ⟨b,hf⟩ := oddPart_factor (3*z+1) (by omega)
  change 3*z+1=2^b*step z at hf
  have ho := step_odd z
  have hb : 3≤b := by
    by_cases h : 3≤b
    · exact h
    · have hc : b=0 ∨ b=1 ∨ b=2 := by omega
      rcases hc with h0|h1|h2
      · rw [h0,Nat.pow_zero,Nat.one_mul] at hf; omega
      · rw [h1,Nat.pow_one] at hf; omega
      · rw [h2] at hf; omega
  exact ⟨b,hb,hf⟩

theorem no_two_at_phase (z : Nat) (hz : z%8=5) : 3*z+1≠4*step z := by
  have ho := step_odd z
  omega

theorem floor_partition (k : Nat) (hk : 1≤k) :
    k=2*count k+1 ∨ k=2*count k+2 := by simp only [count]; omega

private theorem cannot_extend {Y t F : Nat} (he : orbit Y t=F)
    (hn : 3*F+1≠4*step F) : ¬Twos Y (t+1) := by
  intro ht
  have hf := ht t (by omega)
  change 3*orbit Y t+1=4*step (orbit Y t) at hf
  rw [he] at hf
  exact hn hf

structure Compression (k H : Nat) : Prop where
  endpoint_eq : orbit (seed k H) (count k)=endpoint k H
  physical_twos : Twos (seed k H) (count k)
  maximal : ¬Twos (seed k H) (count k+1)
  ledger : 4^(count k)*endpoint k H=3^(count k)*seed k H+(4^(count k)-3^(count k))
  odd_branch : k%2=1 → 3*endpoint k H+1=2*step (endpoint k H)
  even_branch : k%2=0 → endpoint k H%8=5 ∧
    ∃ b : Nat, 3≤b ∧ 3*endpoint k H+1=2^b*step (endpoint k H)

private theorem from_coordinates (k H t A : Nat) (ht : count k=t)
    (hY : seed k H=runStart t A) (hF : endpoint k H=runEnd t A)
    (hn : 3*runEnd t A+1≠4*step (runEnd t A))
    (ho : k%2=1 → 3*endpoint k H+1=2*step (endpoint k H))
    (he : k%2=0 → endpoint k H%8=5 ∧
      ∃ b : Nat, 3≤b ∧ 3*endpoint k H+1=2^b*step (endpoint k H)) : Compression k H := by
  have hp := two_prefix t A
  have hEnd : orbit (seed k H) (count k)=endpoint k H := by rw [ht,hY,hF]; exact hp.1
  have hNo : 3*endpoint k H+1≠4*step (endpoint k H) := by rw [hF]; exact hn
  exact {
    endpoint_eq := hEnd
    physical_twos := by rw [ht,hY]; exact hp.2
    maximal := cannot_extend hEnd hNo
    ledger := by rw [ht,hY,hF]; exact local_ledger t A
    odd_branch := ho
    even_branch := he
  }

/-- Exact maximal two-run for all k>=1, with the cofactor held fixed.
Odd and even exits are physical valuations, not population assertions. -/
theorem compress (k H : Nat) (hk : 1≤k) (_hH : 0<H) (ho : H%2=1) : Compression k H := by
  let t := count k
  have ht : count k=t := rfl
  rcases floor_partition k hk with hOdd|hEven
  · have hY : seed k H=runStart t H := by
      unfold seed
      rw [hOdd]
      exact (odd_start t H).symm
    have hres : k-2*count k=1 := by omega
    have hF : endpoint k H=runEnd t H := by
      unfold endpoint runEnd
      rw [hres]
      simp only [Nat.pow_one]
      change 1+3^t*2*H=1+2*3^t*H
      ac_rfl
    have he := odd_exit t H ho
    apply from_coordinates k H t H ht hY hF he.2
    · intro _hpar
      rw [hF]
      exact he.1
    · intro hpar
      omega
  · have hY : seed k H=runStart t (2*H) := by
      unfold seed
      rw [hEven]
      exact (even_start t H).symm
    have hres : k-2*count k=2 := by omega
    have hF : endpoint k H=runEnd t (2*H) := by
      unfold endpoint runEnd
      rw [hres]
      change 1+3^t*(2*2)*H=1+2*3^t*(2*H)
      ac_rfl
    have he := even_phase t H ho
    apply from_coordinates k H t (2*H) ht hY hF (no_two_at_phase _ he)
    · intro hpar
      omega
    · intro _hpar
      rw [hF]
      exact ⟨he,real_strong_factor _ he⟩

/-- The history remains tied to the same original N and the actual
arrival at j. No local reset at the entrance to the two-run occurs. -/
theorem compress_history (N j S B k H : Nat) (hk : 1≤k) (hH : 0<H) (ho : H%2=1)
    (hp : orbit N j=seed k H) (hbook : 2^S*seed k H=3^j*N+B) :
    2^(S+2*count k)*orbit N (j+count k)=3^(j+count k)*N+
      3^(count k)*B+2^S*(4^(count k)-3^(count k)) := by
  have hc := compress k H hk hH ho
  have hl : 2^(2*count k)*endpoint k H=
      3^(count k)*seed k H+(4^(count k)-3^(count k)) := by
    rw [power_conversion]
    exact hc.ledger
  have hh := FixedSourceRun.history_transport hbook hl
  rw [orbit_add N j (count k),hp,hc.endpoint_eq]
  exact hh

private theorem quarter_factor (z w b R : Nat) (hz : 4*w+1=z) (hb : 3≤b)
    (hf : 3*z+1=2^b*R) : 3*w+1=2^(b-2)*R := by
  apply Nat.mul_left_cancel (by decide : 0<4)
  calc
    _ = 3*z+1 := by omega
    _ = 2^b*R := hf
    _ = _ := by
      rw [show b=(b-2)+2 by omega,Nat.pow_add 2 (b-2) 2]
      change (2^(b-2)*4)*R=4*(2^(b-2)*R)
      ac_rfl

theorem even_quarter_capture (N k H : Nat) (hk : 1≤k) (hH : 0<H) (ho : H%2=1)
    (heven : k%2=0) (hN : endpoint k H<4*N+1) :
    let F := endpoint k H
    let w := (F-1)/4
    0<w ∧ w%2=1 ∧ w<N ∧ step w=step F ∧
    ∃ b : Nat, 3≤b ∧ 3*F+1=2^b*step F ∧ 2^(b-2)*step w=3*w+1 := by
  have hc := compress k H hk hH ho
  obtain ⟨hphase,b,hb,hfactor⟩ := hc.even_branch heven
  have hpos : 1<endpoint k H := by omega
  have hlt : endpoint k H<4*N := by omega
  have hcap := capture (N:=N) hpos hlt hphase
  dsimp only at hcap ⊢
  have hz : 4*((endpoint k H-1)/4)+1=endpoint k H := by omega
  have hq := quarter_factor (endpoint k H) ((endpoint k H-1)/4) b
    (step (endpoint k H)) hz hb hfactor
  refine ⟨hcap.1,hcap.2.1,hcap.2.2.1,hcap.2.2.2,b,hb,hfactor,?_⟩
  rw [hcap.2.2.2]
  exact hq.symm

#print axioms strip_pow
#print axioms physical_step
#print axioms odd_head
#print axioms two_core
#print axioms two_prefix
#print axioms local_ledger
#print axioms power_conversion
#print axioms odd_start
#print axioms even_start
#print axioms odd_product
#print axioms odd_exit
#print axioms even_phase
#print axioms real_strong_factor
#print axioms no_two_at_phase
#print axioms floor_partition
#print axioms cannot_extend
#print axioms from_coordinates
#print axioms compress
#print axioms compress_history
#print axioms quarter_factor
#print axioms even_quarter_capture

end CollatzCharacterBridge.TwosCompression
