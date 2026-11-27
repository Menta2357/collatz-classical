import Terras90Q1Numeric

namespace Terras90FinalNumeric

open Terras88 (q0Clock q1Clock lastClock verifiedHeight)
open Terras90Q0Price (floor92 product shiftedProduct envelopeNumerator envelopeDenominator)

def addClock (a b : Nat × Nat) : Nat × Nat := (a.1+b.1,a.2+b.2)
def pClock : Nat × Nat := addClock q0Clock q1Clock
def threeQ1 : Nat × Nat := addClock (addClock q1Clock q1Clock) q1Clock
def fourQ1 : Nat × Nat := addClock (addClock q1Clock q1Clock) (addClock q1Clock q1Clock)
def jPlusQ1 : Nat × Nat := addClock lastClock q1Clock
def jPlusTwoQ1 : Nat × Nat := addClock jPlusQ1 q1Clock
def twiceJ : Nat × Nat := addClock lastClock lastClock

def rows : List ((Nat × Nat) × Nat) :=
  [(pClock,3),(threeQ1,1),(fourQ1,0),(lastClock,0),(jPlusQ1,0),(jPlusTwoQ1,0),(twiceJ,0)]

theorem rowsLiteral :
    rows=[((7984791619272937798,5037842608667313239),3),
      ((22064020121241819099,13920846777890779368),1),
      ((29418693494989092132,18561129037187705824),0),
      ((43497921996957973433,27444133206411171953),0),
      ((50852595370705246466,32084415465708098409),0),
      ((58207268744452519499,36724697725005024865),0),
      ((86995843993915946866,54888266412822343906),0)] := by decide

def floors (low : Nat) : List Nat :=
  List.replicate low verifiedHeight ++ List.replicate (89-low) floor92

theorem floorsLength {clock : Nat × Nat} {low : Nat} (row : (clock,low)∈rows) :
    (floors low).length=89 := by
  have small : low≤89 := by
    simp only [rows,List.mem_cons,List.not_mem_nil,or_false,Prod.mk.injEq] at row
    rcases row with p | q | r | j | a | b | c <;> omega
  simp [floors,Nat.add_sub_of_le small]

private def Pays (clock : Nat × Nat) (num den : Nat) : Prop :=
  3^clock.2*num<2^clock.1*den

private def Sheet (clock : Nat × Nat) (low : Nat) : Prop :=
  Pays clock (shiftedProduct (floors low)) (product (floors low))

private theorem multiplyPays {p q : Nat × Nat} {a b c d : Nat}
    (left : Pays p a b) (right : Pays q c d) :
    Pays (addClock p q) (a*c) (b*d) := by
  have pos : 0<2^p.1*b := Nat.lt_of_le_of_lt (Nat.zero_le _) left
  simp only [Pays,addClock,Nat.pow_add]
  calc
    _ = (3^p.2*a)*(3^q.2*c) := by ac_rfl
    _ ≤ (2^p.1*b)*(3^q.2*c) := Nat.mul_le_mul_right _ (Nat.le_of_lt left)
    _ < (2^p.1*b)*(2^q.1*d) := Nat.mul_lt_mul_of_pos_left right pos
    _ = _ := by ac_rfl

private theorem weakenPays {p : Nat × Nat} {oldNum oldDen num den : Nat}
    (old : Pays p oldNum oldDen)
    (bounded : num*oldDen≤den*oldNum) (denPos : 0<den) :
    Pays p num den := by
  unfold Pays at old ⊢
  apply Nat.lt_of_mul_lt_mul_left (a:=oldDen)
  calc
    _ = 3^p.2*(num*oldDen) := by ac_rfl
    _ ≤ 3^p.2*(den*oldNum) := Nat.mul_le_mul_left _ bounded
    _ = den*(3^p.2*oldNum) := by ac_rfl
    _ < den*(2^p.1*oldDen) := Nat.mul_lt_mul_of_pos_left old denPos
    _ = _ := by ac_rfl

private theorem q0Pays : Pays q0Clock envelopeNumerator envelopeDenominator :=
  Terras90Q0Price.q0ProductStrict

private theorem q1Pays : Pays q1Clock
    (shiftedProduct (Terras90Q1Numeric.priceEnvelope 200000000000000000000))
    (product (Terras90Q1Numeric.priceEnvelope 200000000000000000000)) :=
  Terras90Q1Numeric.q1RoundedPrice

private theorem q1Contracts : Pays q1Clock 1 1 :=
  weakenPays q1Pays (by decide) (by decide)

private theorem pPays : Sheet pClock 3 :=
  weakenPays (multiplyPays q0Pays q1Pays) (by decide) (by decide)

private theorem threeQ1Pays : Sheet threeQ1 1 :=
  weakenPays (multiplyPays (multiplyPays q1Pays q1Pays) q1Pays) (by decide) (by decide)

private theorem fourQ1Pays : Sheet fourQ1 0 :=
  weakenPays (multiplyPays (multiplyPays q1Pays q1Pays) (multiplyPays q1Pays q1Pays))
    (by decide) (by decide)

private def precision : Nat := 2^256

private structure Mantissa where
  oddExp : Nat
  dyadicExp : Nat
  bound : Nat
  deriving DecidableEq

private def Mantissa.valid (x : Mantissa) : Prop :=
  precision*3^x.oddExp≤x.bound*2^x.dyadicExp

private def advance (x : Mantissa) (digit : Nat × Nat) : Mantissa :=
  let (bit,shift) := digit
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
  have denom : 0<precision*2^shift := Nat.mul_pos (by decide) (Nat.pow_pos (by decide))
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

private def jTrace : List (Nat × Nat) :=
  [(1,1),(0,1),(1,1),(1,3),(1,2),(1,2),(1,2),(0,1),(0,0),(1,2),
   (1,1),(0,1),(1,3),(1,1),(1,3),(0,0),(1,3),(0,0),(0,1),(1,3),
   (0,0),(0,0),(1,1),(0,1),(1,2),(1,2),(0,0),(1,3),(1,2),(1,1),
   (1,2),(1,3),(0,0),(1,2),(1,3),(1,2),(1,1),(1,2),(0,1),(0,1),
   (0,1),(1,2),(0,0),(1,2),(0,0),(0,1),(0,1),(1,2),(1,3),(1,1),
   (1,3),(0,0),(1,2),(1,3),(0,0),(0,1),(0,1),(0,0),(1,1),(1,2),
   (1,3),(0,0),(0,1),(0,1),(1,2)]

private def jBound : Nat :=
  231584178474632390844797340063162145390515363094143551145185481156771856807639

set_option maxRecDepth 4000 in
private theorem trace_result :
    jTrace.foldl advance ⟨0,0,precision⟩=⟨lastClock.2,lastClock.1-1,jBound⟩ := by decide

private theorem jRatioUpper :
    precision*3^lastClock.2≤jBound*2^(lastClock.1-1) := by
  have transfer (x : Mantissa) (valid : x.valid) (n : x.oddExp=lastClock.2)
      (k : x.dyadicExp=lastClock.1-1) (upper : x.bound=jBound) :
      precision*3^lastClock.2≤jBound*2^(lastClock.1-1) := by
    rw [← n,← k,← upper]
    exact valid
  have start : (Mantissa.mk 0 0 precision).valid := by simp [Mantissa.valid]
  apply transfer _ (fold_valid jTrace _ start)
  all_goals rw [trace_result]

private theorem jEnvelope {a b : Nat} (positive : 0<b)
    (bound : precision*a≤jBound*b) :
    a*shiftedProduct (floors 0)<(2*b)*product (floors 0) := by
  have strict : jBound*shiftedProduct (floors 0)<(2*precision)*product (floors 0) := by decide
  apply Nat.lt_of_mul_lt_mul_left (a:=precision)
  calc
    _ = (precision*a)*shiftedProduct (floors 0) := by ac_rfl
    _ ≤ (jBound*b)*shiftedProduct (floors 0) := Nat.mul_le_mul_right _ bound
    _ = (jBound*shiftedProduct (floors 0))*b := by ac_rfl
    _ < ((2*precision)*product (floors 0))*b := Nat.mul_lt_mul_of_pos_right strict positive
    _ = _ := by ac_rfl

private theorem jPays : Sheet lastClock 0 := by
  have pow : 2^lastClock.1=2*2^(lastClock.1-1) := by
    have shift : lastClock.1=(lastClock.1-1)+1 := by decide
    conv => lhs; rw [shift]
    rw [Nat.pow_succ,Nat.mul_comm]
  unfold Sheet Pays
  rw [pow]
  exact jEnvelope (Nat.pow_pos (by decide)) jRatioUpper

private theorem jContracts : Pays lastClock 1 1 :=
  weakenPays jPays (by decide) (by decide)

private theorem jPlusQ1Pays : Sheet jPlusQ1 0 := by
  have pay := multiplyPays jPays q1Contracts
  rw [Nat.mul_one,Nat.mul_one] at pay
  exact pay

private theorem jPlusTwoQ1Pays : Sheet jPlusTwoQ1 0 := by
  have pay := multiplyPays jPlusQ1Pays q1Contracts
  rw [Nat.mul_one,Nat.mul_one] at pay
  exact pay

private theorem twiceJPays : Sheet twiceJ 0 := by
  have pay := multiplyPays jPays jContracts
  rw [Nat.mul_one,Nat.mul_one] at pay
  exact pay

theorem productStrict {clock : Nat × Nat} {low : Nat} (row : (clock,low)∈rows) :
    3^clock.2*shiftedProduct (floors low)<2^clock.1*product (floors low) := by
  change Sheet clock low
  simp only [rows,List.mem_cons,List.not_mem_nil,or_false,Prod.mk.injEq] at row
  rcases row with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact pPays
  · exact threeQ1Pays
  · exact fourQ1Pays
  · exact jPays
  · exact jPlusQ1Pays
  · exact jPlusTwoQ1Pays
  · exact twiceJPays

end Terras90FinalNumeric
