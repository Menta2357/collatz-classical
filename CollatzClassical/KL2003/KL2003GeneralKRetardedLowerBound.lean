import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace CollatzClassical
namespace KL2003

/-!
Generic lower-bound induction for finite expressions made from leaves,
addition, and minimum.  This module is independent of Collatz residue classes,
generated certificate data, and the value of `k`.
-/

inductive RetardedExpr (Index : Type*) where
  | leaf : Index -> Real -> RetardedExpr Index
  | add : RetardedExpr Index -> RetardedExpr Index -> RetardedExpr Index
  | minE : RetardedExpr Index -> RetardedExpr Index -> RetardedExpr Index

namespace RetardedExpr

def evalLeaves {Index : Type*}
    (value : Index -> Real -> Real) : RetardedExpr Index -> Real
  | leaf i beta => value i beta
  | add left right => evalLeaves value left + evalLeaves value right
  | minE left right => min (evalLeaves value left) (evalLeaves value right)

def evalAt {Index : Type*}
    (Phi : Index -> Real -> Real) (y : Real) (expr : RetardedExpr Index) : Real :=
  expr.evalLeaves fun i beta => Phi i (y + beta)

noncomputable def coeffEval {Index : Type*}
    (coeff : Index -> Real) (lambda : Real) (expr : RetardedExpr Index) : Real :=
  expr.evalLeaves fun i beta => coeff i * lambda ^ beta

def ShiftsWithin {Index : Type*}
    (mu nu : Real) : RetardedExpr Index -> Prop
  | leaf _ beta => -nu <= beta /\ beta <= -mu
  | add left right => ShiftsWithin mu nu left /\ ShiftsWithin mu nu right
  | minE left right => ShiftsWithin mu nu left /\ ShiftsWithin mu nu right

theorem evalLeaves_mono {Index : Type*}
    (expr : RetardedExpr Index)
    {lower upper : Index -> Real -> Real}
    (h : forall i beta, lower i beta <= upper i beta) :
    expr.evalLeaves lower <= expr.evalLeaves upper := by
  induction expr with
  | leaf i beta => exact h i beta
  | add left right ihLeft ihRight =>
      exact add_le_add ihLeft ihRight
  | minE left right ihLeft ihRight =>
      exact min_le_min ihLeft ihRight

theorem evalLeaves_scale {Index : Type*}
    (expr : RetardedExpr Index)
    (value : Index -> Real -> Real) {scale : Real}
    (hscale : 0 <= scale) :
    expr.evalLeaves (fun i beta => scale * value i beta) =
      scale * expr.evalLeaves value := by
  induction expr with
  | leaf i beta => rfl
  | add left right ihLeft ihRight =>
      simp only [evalLeaves, ihLeft, ihRight]
      ring
  | minE left right ihLeft ihRight =>
      simp only [evalLeaves, ihLeft, ihRight]
      symm
      exact mul_min_of_nonneg _ _ hscale

theorem scaled_coeffEval_le_evalAt {Index : Type*}
    (expr : RetardedExpr Index)
    {Phi : Index -> Real -> Real} {coeff : Index -> Real}
    {lambda mu nu scale y : Real}
    (hscale : 0 <= scale)
    (hshifts : expr.ShiftsWithin mu nu)
    (hleaf : forall i beta,
      -nu <= beta -> beta <= -mu ->
      scale * (coeff i * lambda ^ beta) <= Phi i (y + beta)) :
    scale * expr.coeffEval coeff lambda <= expr.evalAt Phi y := by
  induction expr with
  | leaf i beta =>
      exact hleaf i beta hshifts.1 hshifts.2
  | add left right ihLeft ihRight =>
      have hleft := ihLeft hshifts.1
      have hright := ihRight hshifts.2
      dsimp [coeffEval, evalAt, evalLeaves] at hleft hright ⊢
      calc
        scale *
            (evalLeaves (fun i beta => coeff i * lambda ^ beta) left +
              evalLeaves (fun i beta => coeff i * lambda ^ beta) right)
            = scale * evalLeaves (fun i beta => coeff i * lambda ^ beta) left +
                scale * evalLeaves (fun i beta => coeff i * lambda ^ beta) right := by
                  ring
        _ <= evalLeaves (fun i beta => Phi i (y + beta)) left +
              evalLeaves (fun i beta => Phi i (y + beta)) right :=
          add_le_add hleft hright
  | minE left right ihLeft ihRight =>
      have hleft := ihLeft hshifts.1
      have hright := ihRight hshifts.2
      dsimp [coeffEval, evalAt, evalLeaves] at hleft hright ⊢
      rw [mul_min_of_nonneg _ _ hscale]
      exact min_le_min hleft hright

end RetardedExpr

noncomputable def genericRetardedRank (mu y : Real) : Nat :=
  Nat.ceil (y / mu)

theorem genericRetardedRank_pos {mu y : Real}
    (hmu : 0 < mu) (hy : 0 < y) :
    0 < genericRetardedRank mu y := by
  unfold genericRetardedRank
  exact Nat.ceil_pos.2 (div_pos hy hmu)

theorem genericRetardedRank_drop {mu y beta : Real}
    (hmu : 0 < mu)
    (hbeta : beta <= -mu)
    (hpos : 0 < genericRetardedRank mu y) :
    genericRetardedRank mu (y + beta) < genericRetardedRank mu y := by
  unfold genericRetardedRank
  have hnum : y + beta <= y - mu := by linarith
  have hdiv0 : (y + beta) / mu <= (y - mu) / mu :=
    (div_le_div_iff_of_pos_right hmu).2 hnum
  have hdivEq : (y - mu) / mu = y / mu - 1 := by
    field_simp [hmu.ne']
  have hdiv : (y + beta) / mu <= y / mu - 1 := by
    simpa [hdivEq] using hdiv0
  have hceil :
      Nat.ceil ((y + beta) / mu) <= Nat.ceil (y / mu - 1) :=
    Nat.ceil_mono hdiv
  rw [Nat.ceil_sub_one] at hceil
  exact lt_of_le_of_lt hceil (Nat.sub_lt hpos (by norm_num))

structure GenericRetardedInputs (Index : Type*) where
  Phi : Index -> Real -> Real
  row : Index -> RetardedExpr Index
  coeff : Index -> Real
  lambda : Real
  mu : Real
  nu : Real
  Delta : Real
  lambda_pos : 0 < lambda
  mu_pos : 0 < mu
  mu_le_nu : mu <= nu
  Delta_nonneg : 0 <= Delta
  shifts : forall i, (row i).ShiftsWithin mu nu
  rows : forall i y, 0 <= y -> (row i).evalAt Phi y <= Phi i y
  feasible : forall i, coeff i <= (row i).coeffEval coeff lambda
  base : forall i y, 0 <= y -> y <= nu ->
    Delta * coeff i * lambda ^ y <= Phi i y

theorem generic_retarded_lower_bound {Index : Type*}
    (inputs : GenericRetardedInputs Index) :
    forall i y, 0 <= y ->
      inputs.Delta * inputs.coeff i * inputs.lambda ^ y <= inputs.Phi i y := by
  let proveRank :
      forall n, forall i y,
        genericRetardedRank inputs.mu y = n -> 0 <= y ->
          inputs.Delta * inputs.coeff i * inputs.lambda ^ y <= inputs.Phi i y :=
    fun n =>
      Nat.strongRecOn n (motive := fun n =>
        forall i y,
          genericRetardedRank inputs.mu y = n -> 0 <= y ->
            inputs.Delta * inputs.coeff i * inputs.lambda ^ y <= inputs.Phi i y)
        (fun n ih i y hrank hy0 => by
          by_cases hbase : y <= inputs.nu
          · exact inputs.base i y hy0 hbase
          · have hynu : inputs.nu < y := lt_of_not_ge hbase
            have hnuPos : 0 < inputs.nu :=
              lt_of_lt_of_le inputs.mu_pos inputs.mu_le_nu
            have hyPos : 0 < y := hnuPos.trans hynu
            have hrankPos : 0 < genericRetardedRank inputs.mu y :=
              genericRetardedRank_pos inputs.mu_pos hyPos
            have hscaleNonneg :
                0 <= inputs.Delta * inputs.lambda ^ y :=
              mul_nonneg inputs.Delta_nonneg
                (Real.rpow_nonneg inputs.lambda_pos.le y)
            have hleaves :
                (inputs.Delta * inputs.lambda ^ y) *
                    (inputs.row i).coeffEval inputs.coeff inputs.lambda <=
                  (inputs.row i).evalAt inputs.Phi y := by
              apply RetardedExpr.scaled_coeffEval_le_evalAt
                (hscale := hscaleNonneg) (hshifts := inputs.shifts i)
              intro j beta hbetaLow hbetaHigh
              have hyShift0 : 0 <= y + beta := by
                linarith
              have hdrop :
                  genericRetardedRank inputs.mu (y + beta) <
                    genericRetardedRank inputs.mu y :=
                genericRetardedRank_drop inputs.mu_pos hbetaHigh hrankPos
              have hdropN :
                  genericRetardedRank inputs.mu (y + beta) < n := by
                simpa [hrank] using hdrop
              have hih := ih
                (genericRetardedRank inputs.mu (y + beta)) hdropN
                j (y + beta) rfl hyShift0
              have hrpow :
                  inputs.lambda ^ (y + beta) =
                    inputs.lambda ^ y * inputs.lambda ^ beta := by
                exact Real.rpow_add inputs.lambda_pos y beta
              rw [hrpow] at hih
              nlinarith
            have hcoeff :
                (inputs.Delta * inputs.lambda ^ y) * inputs.coeff i <=
                  (inputs.Delta * inputs.lambda ^ y) *
                    (inputs.row i).coeffEval inputs.coeff inputs.lambda :=
              mul_le_mul_of_nonneg_left (inputs.feasible i) hscaleNonneg
            have hrow := inputs.rows i y hy0
            have htarget :
                inputs.Delta * inputs.coeff i * inputs.lambda ^ y =
                  (inputs.Delta * inputs.lambda ^ y) * inputs.coeff i := by
              ring
            rw [htarget]
            exact hcoeff.trans (hleaves.trans hrow))
  intro i y hy0
  exact proveRank (genericRetardedRank inputs.mu y) i y rfl hy0

end KL2003
end CollatzClassical
