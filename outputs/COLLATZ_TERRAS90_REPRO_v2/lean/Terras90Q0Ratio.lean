import Terras90Q0Price

namespace Terras90Q0Price

open Terras88 (q0Clock q0Price verifiedHeight)

private def precision : Nat := 2^256

private structure Mantissa where
  oddExp : Nat
  dyadicExp : Nat
  bound : Nat
  deriving DecidableEq

private def Mantissa.valid (x : Mantissa) : Prop :=
  precision * 3^x.oddExp ≤ x.bound * 2^x.dyadicExp

private def advance (x : Mantissa) (digit : Nat × Nat) : Mantissa :=
  let (bit, shift) := digit
  ⟨x.oddExp+x.oddExp+bit, x.dyadicExp+x.dyadicExp+shift,
    (x.bound*x.bound*3^bit)/(precision*2^shift)+1⟩

private theorem rounding (n d : Nat) (pos : 0<d) : n ≤ (n/d+1)*d := by
  have rem := Nat.mod_lt n pos
  have decomp := Nat.mod_add_div n d
  rw [Nat.add_mul, Nat.one_mul, Nat.mul_comm (n/d)]
  omega

private theorem advance_valid (x : Mantissa) (digit : Nat × Nat) (old : x.valid) :
    (advance x digit).valid := by
  rcases digit with ⟨bit, shift⟩
  let u := x.bound
  let n := x.oddExp
  let k := x.dyadicExp
  let next := (u*u*3^bit)/(precision*2^shift)+1
  change precision*3^n ≤ u*2^k at old
  change precision*3^(n+n+bit) ≤ next*2^(k+k+shift)
  have denom : 0<precision*2^shift :=
    Nat.mul_pos (by decide) (Nat.pow_pos (by decide))
  have round := rounding (u*u*3^bit) (precision*2^shift) denom
  have upper : precision*(precision*3^(n+n+bit)) ≤
      precision*(next*2^(k+k+shift)) := by
    calc
      _ = ((precision*3^n)*(precision*3^n))*3^bit := by
        rw [Nat.pow_add 3 (n+n), Nat.pow_add 3 n n]
        ac_rfl
      _ ≤ ((u*2^k)*(u*2^k))*3^bit :=
        Nat.mul_le_mul_right _ (Nat.mul_le_mul old old)
      _ = (u*u*3^bit)*2^(k+k) := by rw [Nat.pow_add 2 k k]; ac_rfl
      _ ≤ (next*(precision*2^shift))*2^(k+k) := Nat.mul_le_mul_right _ round
      _ = _ := by rw [Nat.pow_add 2 (k+k)]; ac_rfl
  exact Nat.le_of_mul_le_mul_left upper (by decide)

private theorem fold_valid (trace : List (Nat × Nat)) (x : Mantissa) (valid : x.valid) :
    (trace.foldl advance x).valid := by
  induction trace generalizing x with
  | nil => exact valid
  | cons digit trail ih => exact ih _ (advance_valid x digit valid)

private def q0Trace : List (Nat × Nat) :=
  [(1,1),(0,1),(1,1),(1,3),(0,0),(0,1),(0,1),(0,0),(1,3),(0,0),
   (0,1),(0,1),(1,3),(1,2),(0,0),(1,3),(0,1),(1,1),(1,3),(0,0),
   (0,0),(0,1),(0,0),(1,2),(0,1),(0,0),(0,0),(0,1),(0,0),(0,1),
   (0,0),(1,1),(0,1),(0,0),(1,3),(0,0),(0,0),(0,0),(0,0),(0,1),
   (0,0),(0,1),(0,1),(1,3),(0,0),(0,1),(0,0),(1,2),(0,0),(0,0),
   (1,3),(0,0),(1,3),(0,0),(1,2),(1,2),(1,2),(1,1),(1,2)]

private def q0Bound : Nat :=
  231584178474632390812013746185900457482287177433654454766238353994714311608509

set_option maxRecDepth 4000 in
private theorem trace_result :
    q0Trace.foldl advance ⟨0,0,precision⟩ = ⟨q0Clock.2,q0Clock.1-1,q0Bound⟩ := by
  decide

private theorem q0_ratio_upper :
    precision * 3^q0Clock.2 ≤ q0Bound * 2^(q0Clock.1-1) := by
  have transfer (x : Mantissa) (valid : x.valid) (n : x.oddExp = q0Clock.2)
      (k : x.dyadicExp = q0Clock.1-1) (upper : x.bound = q0Bound) :
      precision * 3^q0Clock.2 ≤ q0Bound * 2^(q0Clock.1-1) := by
    rw [← n, ← k, ← upper]
    exact valid
  have start : (Mantissa.mk 0 0 precision).valid := by
    simp [Mantissa.valid]
  apply transfer _ (fold_valid q0Trace _ start)
  all_goals rw [trace_result]

def envelopeDenominator : Nat :=
  verifiedHeight^4 * q0Price^4 * floor92 * floor146^80

def envelopeNumerator : Nat :=
  (verifiedHeight+1)^4 * (q0Price+1)^4 * (floor92+1) * (floor146+1)^80

private theorem compareEnvelope {a b : Nat} (positive : 0<b)
    (bound : precision*a ≤ q0Bound*b) :
    a*envelopeNumerator < (2*b)*envelopeDenominator := by
  have small : q0Bound*envelopeNumerator < (2*precision)*envelopeDenominator := by
    decide
  apply Nat.lt_of_mul_lt_mul_left (a := precision)
  calc
    _ = (precision*a)*envelopeNumerator := by ac_rfl
    _ ≤ (q0Bound*b)*envelopeNumerator := Nat.mul_le_mul_right _ bound
    _ = (q0Bound*envelopeNumerator)*b := by ac_rfl
    _ < ((2*precision)*envelopeDenominator)*b := Nat.mul_lt_mul_of_pos_right small positive
    _ = _ := by ac_rfl

/-- The normalized dyadic ratio times the coarse rational envelope is less
than one. The proof never evaluates a power at either large clock. -/
theorem q0ProductStrict :
    3^q0Clock.2 * envelopeNumerator < 2^q0Clock.1 * envelopeDenominator := by
  have pow : 2^q0Clock.1 = 2*2^(q0Clock.1-1) := by
    have shift : q0Clock.1 = (q0Clock.1-1)+1 := by decide
    conv => lhs; rw [shift]
    rw [Nat.pow_succ, Nat.mul_comm]
  rw [pow]
  exact compareEnvelope (Nat.pow_pos (by decide)) q0_ratio_upper

def product : List Nat → Nat
  | [] => 1
  | x::xs => x*product xs

def shiftedProduct (xs : List Nat) : Nat := product (xs.map (·+1))

theorem product_append (xs ys : List Nat) :
    product (xs++ys) = product xs*product ys := by
  induction xs with
  | nil => simp [product]
  | cons x xs ih => simp [product, ih, Nat.mul_assoc]

theorem shiftedProduct_append (xs ys : List Nat) :
    shiftedProduct (xs++ys) = shiftedProduct xs*shiftedProduct ys := by
  simp [shiftedProduct,List.map_append,product_append]

theorem product_perm {xs ys : List Nat} (p : xs.Perm ys) :
    product xs=product ys := by
  induction p with
  | nil => rfl
  | cons v p ih => simp [product,ih]
  | swap x y xs =>
    simp only [product]
    ac_rfl
  | trans p q ihp ihq => exact ihp.trans ihq

theorem shiftedProduct_perm {xs ys : List Nat} (p : xs.Perm ys) :
    shiftedProduct xs=shiftedProduct ys := product_perm (p.map (·+1))

private theorem product_positive (xs : List Nat) (pos : ∀ x ∈ xs, 0<x) :
    0<product xs := by
  induction xs with
  | nil => decide
  | cons x xs ih =>
    exact Nat.mul_pos (pos x (by simp)) (ih (fun y hy => pos y (List.mem_cons_of_mem _ hy)))

private theorem bucket (l : List Nat) (floor : Nat) (bound : ∀ x ∈ l, floor≤x) :
    shiftedProduct l*floor^l.length ≤ product l*(floor+1)^l.length := by
  induction l with
  | nil => simp [shiftedProduct,product]
  | cons x xs ih =>
    have tail := ih (fun y hy => bound y (List.mem_cons_of_mem _ hy))
    have localOrder := bound x (by simp)
    have item : (x+1)*floor≤x*(floor+1) := by
      simp only [Nat.add_mul,Nat.mul_add,Nat.mul_one,Nat.one_mul]
      exact Nat.add_le_add_left localOrder _
    calc
      _ = ((x+1)*floor)*(shiftedProduct xs*floor^xs.length) := by
        simp only [shiftedProduct,List.map_cons,product,List.length_cons,Nat.pow_succ]
        ac_rfl
      _ ≤ (x*(floor+1))*(product xs*(floor+1)^xs.length) := Nat.mul_le_mul item tail
      _ = _ := by
        simp only [List.length_cons,Nat.pow_succ,product]
        ac_rfl

private theorem envelope {xs : List Nat} (len : xs.length=90)
    (ordered : xs.Pairwise (· ≤ ·))
    (above : ∀ x ∈ xs, verifiedHeight≤x)
    (at6 : q0Price≤xs[5]'(by omega))
    (at10 : floor92≤xs[9]'(by omega)) (at11 : floor146≤xs[10]'(by omega)) :
    shiftedProduct (xs.drop 1)*envelopeDenominator ≤ product (xs.drop 1)*envelopeNumerator := by
  have small := bucket ((xs.drop 1).take 4) verifiedHeight
    (fun x hit => above x (List.mem_of_mem_drop (List.mem_of_mem_take hit)))
  have half := bucket ((xs.drop 5).take 4) q0Price
    (fun x hit => floor_tail ordered (by omega) at6 x (List.mem_of_mem_take hit))
  have tenth := bucket ((xs.drop 9).take 1) floor92
    (fun x hit => floor_tail ordered (by omega) at10 x (List.mem_of_mem_take hit))
  have large := bucket (xs.drop 10) floor146 (floor_tail ordered (by omega) at11)
  simp only [List.length_take,List.length_drop,len,Nat.reduceSub,
    Nat.min_eq_left (by decide : 4≤89),Nat.min_eq_left (by decide : 4≤85),
    Nat.min_eq_left (by decide : 1≤81),Nat.pow_one] at small half tenth large
  have split1 := List.take_append_drop 4 (xs.drop 1)
  have split5 := List.take_append_drop 4 (xs.drop 5)
  have split9 := List.take_append_drop 1 (xs.drop 9)
  simp only [List.drop_drop,Nat.reduceAdd] at split1 split5 split9
  conv => lhs; rw [← split1,shiftedProduct_append]
  conv => rhs; rw [← split1,product_append]
  rw [← split5,shiftedProduct_append,product_append,
      ← split9,shiftedProduct_append,product_append]
  unfold envelopeDenominator envelopeNumerator
  calc
    _ = ((shiftedProduct ((xs.drop 1).take 4)*verifiedHeight^4)*
          (shiftedProduct ((xs.drop 5).take 4)*q0Price^4))*
        ((shiftedProduct ((xs.drop 9).take 1)*floor92)*
          (shiftedProduct (xs.drop 10)*floor146^80)) := by ac_rfl
    _ ≤ _ := Nat.mul_le_mul (Nat.mul_le_mul small half) (Nat.mul_le_mul tenth large)
    _ = _ := by ac_rfl

private theorem contradictBudget {a b n d : Nat} (positive : 0<d)
    (clock : a*envelopeNumerator<b*envelopeDenominator)
    (budget : b*d≤a*n)
    (env : n*envelopeDenominator≤d*envelopeNumerator) : False := by
  have closes : (b*d)*envelopeDenominator < (b*d)*envelopeDenominator := by
    calc
      _ ≤ (a*n)*envelopeDenominator := Nat.mul_le_mul_right _ budget
      _ = a*(n*envelopeDenominator) := by ac_rfl
      _ ≤ a*(d*envelopeNumerator) := Nat.mul_le_mul_left _ env
      _ = (a*envelopeNumerator)*d := by ac_rfl
      _ < (b*envelopeDenominator)*d := Nat.mul_lt_mul_of_pos_right clock positive
      _ = _ := by ac_rfl
  exact Nat.lt_irrefl _ closes

/-- Log-free strict price with the integer product budget of the same physical history. -/
theorem sixth_lt_price_product (xs : List Nat) (len : xs.length=90)
    (ordered : xs.Pairwise (· ≤ ·))
    (above : ∀ x ∈ xs, verifiedHeight≤x)
    (at10 : floor92≤xs[9]'(by omega)) (at11 : floor146≤xs[10]'(by omega))
    (budget : 2^q0Clock.1*product (xs.drop 1) ≤
      3^q0Clock.2*shiftedProduct (xs.drop 1)) :
    xs[5]'(by omega)<q0Price := by
  by_cases paid : xs[5]'(by omega)<q0Price
  · exact paid
  · have lower : q0Price≤xs[5]'(by omega) := Nat.le_of_not_gt paid
    have pos := product_positive (xs.drop 1) (fun x hx =>
      Nat.lt_of_lt_of_le (by decide : 0<verifiedHeight) (above x (List.mem_of_mem_drop hx)))
    exact (contradictBudget pos q0ProductStrict budget (envelope len ordered above lower at10 at11)).elim

end Terras90Q0Price
