import Terras90Q0Ratio

namespace Terras90Q1Numeric

open Terras88 (q1Clock twiceQ1Clock q0Price)
open Terras90Q0Price (floor146 product shiftedProduct)

def priceEnvelope (price : Nat) : List Nat :=
  List.replicate 5 price ++ List.replicate 84 floor146

theorem priceEnvelopeLength (price : Nat) : (priceEnvelope price).length=89 := by
  simp [priceEnvelope]

private def precision : Nat := 2^256

private structure Mantissa where
  oddExp : Nat
  dyadicExp : Nat
  bound : Nat
  deriving DecidableEq

private def Mantissa.valid (x : Mantissa) : Prop :=
  precision*3^x.oddExp ≤ x.bound*2^x.dyadicExp

private def advance (x : Mantissa) (digit : Nat × Nat) : Mantissa :=
  let (bit, shift) := digit
  ⟨x.oddExp+x.oddExp+bit,x.dyadicExp+x.dyadicExp+shift,
    (x.bound*x.bound*3^bit)/(precision*2^shift)+1⟩

private theorem rounding (n d : Nat) (pos : 0<d) : n≤(n/d+1)*d := by
  have rem := Nat.mod_lt n pos
  have decomp := Nat.mod_add_div n d
  rw [Nat.add_mul,Nat.one_mul,Nat.mul_comm (n/d)]
  omega

private theorem advance_valid (x : Mantissa) (digit : Nat × Nat) (old : x.valid) :
    (advance x digit).valid := by
  rcases digit with ⟨bit,shift⟩
  let u := x.bound
  let n := x.oddExp
  let k := x.dyadicExp
  let next := (u*u*3^bit)/(precision*2^shift)+1
  change precision*3^n≤u*2^k at old
  change precision*3^(n+n+bit)≤next*2^(k+k+shift)
  have denom : 0<precision*2^shift :=
    Nat.mul_pos (by decide) (Nat.pow_pos (by decide))
  have round := rounding (u*u*3^bit) (precision*2^shift) denom
  have upper : precision*(precision*3^(n+n+bit))≤precision*(next*2^(k+k+shift)) := by
    calc
      _ = ((precision*3^n)*(precision*3^n))*3^bit := by
        rw [Nat.pow_add 3 (n+n),Nat.pow_add 3 n n]
        ac_rfl
      _ ≤ ((u*2^k)*(u*2^k))*3^bit := Nat.mul_le_mul_right _ (Nat.mul_le_mul old old)
      _ = (u*u*3^bit)*2^(k+k) := by rw [Nat.pow_add 2 k k]; ac_rfl
      _ ≤ (next*(precision*2^shift))*2^(k+k) := Nat.mul_le_mul_right _ round
      _ = _ := by rw [Nat.pow_add 2 (k+k)]; ac_rfl
  exact Nat.le_of_mul_le_mul_left upper (by decide)

private theorem fold_valid (trace : List (Nat × Nat)) (x : Mantissa) (valid : x.valid) :
    (trace.foldl advance x).valid := by
  induction trace generalizing x with
  | nil => exact valid
  | cons digit trail ih => exact ih _ (advance_valid x digit valid)

private def q1Trace : List (Nat × Nat) :=
  [(1,1),(0,1),(0,0),(0,0),(0,1),(0,0),(0,1),(0,0),(1,3),(1,2),
   (0,0),(0,1),(1,1),(0,1),(1,2),(1,1),(0,1),(0,1),(1,1),(1,3),
   (0,1),(0,0),(0,0),(0,0),(0,1),(1,1),(0,1),(0,0),(0,1),(0,0),
   (1,3),(0,0),(0,0),(1,3),(0,0),(1,2),(0,1),(1,1),(0,1),(1,3),
   (1,1),(1,3),(1,1),(0,1),(0,0),(0,0),(0,1),(1,2),(0,1),(1,3),
   (1,2),(1,3),(0,0),(1,1),(0,1),(1,3),(1,1),(1,3),(1,1),(1,3),
   (0,0),(0,0),(0,0)]

private def q1Bound : Nat :=
  231584178474632390840896494386427644282798600192204562678198591999653491402874

set_option maxRecDepth 4000 in
private theorem trace_result :
    q1Trace.foldl advance ⟨0,0,precision⟩=⟨q1Clock.2,q1Clock.1-1,q1Bound⟩ := by
  decide

private theorem q1RatioUpper :
    precision*3^q1Clock.2≤q1Bound*2^(q1Clock.1-1) := by
  have transfer (x : Mantissa) (valid : x.valid) (n : x.oddExp=q1Clock.2)
      (k : x.dyadicExp=q1Clock.1-1) (upper : x.bound=q1Bound) :
      precision*3^q1Clock.2≤q1Bound*2^(q1Clock.1-1) := by
    rw [← n,← k,← upper]
    exact valid
  have start : (Mantissa.mk 0 0 precision).valid := by simp [Mantissa.valid]
  apply transfer _ (fold_valid q1Trace _ start)
  all_goals rw [trace_result]

private theorem fullRatio :
    (2*precision)*3^q1Clock.2≤q1Bound*2^q1Clock.1 := by
  have pow : 2^q1Clock.1=2*2^(q1Clock.1-1) := by
    have shift : q1Clock.1=(q1Clock.1-1)+1 := by decide
    conv => lhs; rw [shift]
    rw [Nat.pow_succ,Nat.mul_comm]
  have move (a b : Nat) (base : precision*a≤q1Bound*b) :
      (2*precision)*a≤q1Bound*(2*b) := by
    calc
      _ = 2*(precision*a) := by ac_rfl
      _ ≤ 2*(q1Bound*b) := Nat.mul_le_mul_left _ base
      _ = _ := by ac_rfl
  rw [pow]
  exact move _ _ q1RatioUpper

private theorem ratioOfDouble {d k m u : Nat} (bound : m*3^d≤u*2^k) :
    (m*m)*3^(d+d)≤(u*u)*2^(k+k) := by
  rw [Nat.pow_add,Nat.pow_add]
  calc
    _ = (m*3^d)*(m*3^d) := by ac_rfl
    _ ≤ (u*2^k)*(u*2^k) := Nat.mul_le_mul bound bound
    _ = _ := by ac_rfl

private theorem fullRatioDouble :
    ((2*precision)*(2*precision))*3^twiceQ1Clock.2≤(q1Bound*q1Bound)*2^twiceQ1Clock.1 := by
  have oddEq : twiceQ1Clock.2=q1Clock.2+q1Clock.2 := by decide
  have stepEq : twiceQ1Clock.1=q1Clock.1+q1Clock.1 := by decide
  rw [oddEq,stepEq]
  exact ratioOfDouble fullRatio

private theorem compareEnvelope {m u a b price : Nat} (positive : 0<b)
    (bound : m*a≤u*b)
    (closed : u*shiftedProduct (priceEnvelope price)<m*product (priceEnvelope price)) :
    a*shiftedProduct (priceEnvelope price)<b*product (priceEnvelope price) := by
  apply Nat.lt_of_mul_lt_mul_left (a:=m)
  calc
    _ = (m*a)*shiftedProduct (priceEnvelope price) := by ac_rfl
    _ ≤ (u*b)*shiftedProduct (priceEnvelope price) := Nat.mul_le_mul_right _ bound
    _ = (u*shiftedProduct (priceEnvelope price))*b := by ac_rfl
    _ < (m*product (priceEnvelope price))*b := Nat.mul_lt_mul_of_pos_right closed positive
    _ = _ := by ac_rfl

theorem q1ProductStrict :
    3^q1Clock.2*shiftedProduct (priceEnvelope q0Price)<
      2^q1Clock.1*product (priceEnvelope q0Price) :=
  compareEnvelope (Nat.pow_pos (by decide)) fullRatio (by decide)

theorem twiceQ1ProductStrict :
    3^twiceQ1Clock.2*shiftedProduct (priceEnvelope q0Price)<
      2^twiceQ1Clock.1*product (priceEnvelope q0Price) :=
  compareEnvelope (Nat.pow_pos (by decide)) fullRatioDouble (by decide)

theorem q1RoundedPrice :
    3^q1Clock.2*shiftedProduct (priceEnvelope 200000000000000000000)<
      2^q1Clock.1*product (priceEnvelope 200000000000000000000) :=
  compareEnvelope (Nat.pow_pos (by decide)) fullRatio (by decide)

theorem twiceQ1RoundedPrice :
    3^twiceQ1Clock.2*shiftedProduct (priceEnvelope 100000000000000000000)<
      2^twiceQ1Clock.1*product (priceEnvelope 100000000000000000000) :=
  compareEnvelope (Nat.pow_pos (by decide)) fullRatioDouble (by decide)

end Terras90Q1Numeric
