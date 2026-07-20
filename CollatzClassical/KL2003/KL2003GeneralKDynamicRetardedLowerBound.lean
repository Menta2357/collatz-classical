import CollatzClassical.KL2003.KL2003GeneralKUniformRetardedWindow

namespace CollatzClassical
namespace KL2003

/-!
Generic retarded lower-bound induction for rows selected at the current real
argument. The static theorem remains unchanged; this variant only requires
row, shift, semantic, and coefficient obligations in the inductive region
`nu < y`, where the row is actually consumed.
-/

structure DynamicRetardedInputs (Index : Type*) where
  Phi : Index -> Real -> Real
  row : Index -> Real -> RetardedExpr Index
  coeff : Index -> Real
  lambda : Real
  mu : Real
  nu : Real
  Delta : Real
  lambda_pos : 0 < lambda
  mu_pos : 0 < mu
  mu_le_nu : mu <= nu
  Delta_nonneg : 0 <= Delta
  shifts : forall i y, nu < y -> (row i y).ShiftsWithin mu nu
  rows : forall i y, 0 <= y -> nu < y -> (row i y).evalAt Phi y <= Phi i y
  feasible : forall i y, nu < y -> coeff i <= (row i y).coeffEval coeff lambda
  base : forall i y, 0 <= y -> y <= nu ->
    Delta * coeff i * lambda ^ y <= Phi i y

theorem dynamic_retarded_lower_bound {Index : Type*}
    (inputs : DynamicRetardedInputs Index) :
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
                    (inputs.row i y).coeffEval inputs.coeff inputs.lambda <=
                  (inputs.row i y).evalAt inputs.Phi y := by
              apply RetardedExpr.scaled_coeffEval_le_evalAt
                (hscale := hscaleNonneg) (hshifts := inputs.shifts i y hynu)
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
                    (inputs.row i y).coeffEval inputs.coeff inputs.lambda :=
              mul_le_mul_of_nonneg_left (inputs.feasible i y hynu) hscaleNonneg
            have hrow := inputs.rows i y hy0 hynu
            have htarget :
                inputs.Delta * inputs.coeff i * inputs.lambda ^ y =
                  (inputs.Delta * inputs.lambda ^ y) * inputs.coeff i := by
              ring
            rw [htarget]
            exact hcoeff.trans (hleaves.trans hrow))
  intro i y hy0
  exact proveRank (genericRetardedRank inputs.mu y) i y rfl hy0

def GenericRetardedInputs.toDynamic {Index : Type*}
    (inputs : GenericRetardedInputs Index) : DynamicRetardedInputs Index where
  Phi := inputs.Phi
  row i _ := inputs.row i
  coeff := inputs.coeff
  lambda := inputs.lambda
  mu := inputs.mu
  nu := inputs.nu
  Delta := inputs.Delta
  lambda_pos := inputs.lambda_pos
  mu_pos := inputs.mu_pos
  mu_le_nu := inputs.mu_le_nu
  Delta_nonneg := inputs.Delta_nonneg
  shifts i _ _ := inputs.shifts i
  rows i y hy _ := inputs.rows i y hy
  feasible i _ _ := inputs.feasible i
  base := inputs.base

theorem dynamic_retarded_lower_bound_of_static {Index : Type*}
    (inputs : GenericRetardedInputs Index) :
    forall i y, 0 <= y ->
      inputs.Delta * inputs.coeff i * inputs.lambda ^ y <= inputs.Phi i y :=
  dynamic_retarded_lower_bound inputs.toDynamic

namespace GeneralKDynamicRetardedLowerBound

open GeneralKCriticalStopSemantics
open GeneralKUniformCriticalDepth
open GeneralKUniformRetardedWindow
open GeneralKLNTFeasibilityTransfer

theorem two_le_uniformNu {p : Nat} (hp : 1 <= p) (bound : Nat) :
    (2 : Real) <= uniformNu hp bound :=
  backwardShift_le_uniformNu_of_mem hp bound
    (two_mem_boundedNegativeBackwardShifts_succ hp bound)

noncomputable def selectedSourceWitness
    {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (mode : TrackedMode (p + 1)) (y : Real) (hy : 2 <= y) :
    SourceELRetardedWitness hp (zeroRootLabel mode) y :=
  Classical.choice (sourcePhiK_satisfiesEL roots mode y hy)

noncomputable def sourceDynamicRow
    {p : Nat} (hp : 1 <= p)
    (roots : GeneralKClassRootsNonempty (p + 1))
    (mode : TrackedMode (p + 1)) (y : Real) :
    RetardedExpr (TrackedMode (p + 1)) :=
  if hy : 2 <= y then
    (selectedSourceWitness hp roots mode y hy).assignment.selectedExpr.toRetardedExpr
  else
    .leaf mode (-2)

theorem sourceDynamicRow_shiftsWithin
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {bound : Nat} (hbound : CriticalSelectedDepthBound hp bound)
    (mode : TrackedMode (p + 1)) (y : Real)
    (hynu : uniformNu hp bound < y) :
    (sourceDynamicRow hp roots mode y).ShiftsWithin
      (uniformMu hp bound) (uniformNu hp bound) := by
  have hy : 2 <= y := (two_le_uniformNu hp bound).trans hynu.le
  rw [sourceDynamicRow, dif_pos hy]
  exact sourceELRetardedWitness_selectedExpr_shiftsWithin hbound hy
    (selectedSourceWitness hp roots mode y hy)

theorem sourceDynamicRow_evalAt_le
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    {bound : Nat} (mode : TrackedMode (p + 1)) (y : Real)
    (hynu : uniformNu hp bound < y) :
    (sourceDynamicRow hp roots mode y).evalAt sourcePhiK y <= sourcePhiK mode y := by
  have hy : 2 <= y := (two_le_uniformNu hp bound).trans hynu.le
  rw [sourceDynamicRow, dif_pos hy]
  rw [ELExpr.toRetardedExpr_evalAt]
  simpa [zeroRootLabel, SymbolicShift.eval_zero] using
    (selectedSourceWitness hp roots mode y hy).row_le

theorem ELExpr.toRetardedExpr_coeffEval_eq
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (expr : ELExpr (p + 1)) :
    expr.toRetardedExpr.coeffEval certificate.principal certificate.lambda =
      expr.eval certificate.coefficientValue 0 := by
  rw [← ELExpr.toRetardedExpr_evalAt expr certificate.coefficientValue 0]
  unfold RetardedExpr.evalAt RetardedExpr.coeffEval
  congr 1
  funext mode beta
  simp [LNTCertificate.coefficientValue]

theorem sourceDynamicRow_coefficient_feasible
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp)
    {bound : Nat} (mode : TrackedMode (p + 1)) (y : Real)
    (hynu : uniformNu hp bound < y) :
    certificate.principal mode <=
      (sourceDynamicRow hp roots mode y).coeffEval
        certificate.principal certificate.lambda := by
  have hy : 2 <= y := (two_le_uniformNu hp bound).trans hynu.le
  have hfeasible := sourceELRetardedWitness_coefficient_feasible certificate
    (selectedSourceWitness hp roots mode y hy)
  rw [sourceDynamicRow, dif_pos hy]
  rw [ELExpr.toRetardedExpr_coeffEval_eq]
  simpa [RetardedExpr.evalAt, RetardedExpr.coeffEval,
    LNTCertificate.coefficientValue, zeroRootLabel,
    SymbolicShift.eval_zero] using hfeasible

noncomputable def principalSum
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp) : Real :=
  ∑ mode : TrackedMode (p + 1), certificate.principal mode

theorem principal_pos_le_sum
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (mode : TrackedMode (p + 1)) :
    certificate.principal mode <= principalSum certificate := by
  classical
  simpa only [principalSum] using
    (Finset.single_le_sum
      (fun index _ => (certificate.principal_pos index).le)
      (Finset.mem_univ mode))

theorem principalSum_pos
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp) :
    0 < principalSum certificate := by
  classical
  unfold principalSum
  exact Finset.sum_pos
    (fun mode _ => certificate.principal_pos mode)
    ⟨modeTwo hp, Finset.mem_univ _⟩

noncomputable def sourceDynamicDelta
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (bound : Nat) : Real :=
  1 / (principalSum certificate * certificate.lambda ^ uniformNu hp bound)

theorem sourceDynamicDelta_pos
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (bound : Nat) :
    0 < sourceDynamicDelta certificate bound := by
  apply one_div_pos.mpr
  exact mul_pos (principalSum_pos certificate)
    (Real.rpow_pos_of_pos certificate.lambda_pos _)

theorem sourceDynamicBase
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp) (hlambda : 1 <= certificate.lambda)
    (bound : Nat) (mode : TrackedMode (p + 1)) (y : Real)
    (hy0 : 0 <= y) (hynu : y <= uniformNu hp bound) :
    sourceDynamicDelta certificate bound * certificate.principal mode *
        certificate.lambda ^ y <= sourcePhiK mode y := by
  have hcoeff := principal_pos_le_sum certificate mode
  have hrpow := Real.rpow_le_rpow_of_exponent_le hlambda hynu
  have hproduct :
      certificate.principal mode * certificate.lambda ^ y <=
        principalSum certificate * certificate.lambda ^ uniformNu hp bound :=
    mul_le_mul hcoeff hrpow
      (Real.rpow_nonneg certificate.lambda_pos.le y)
      (principalSum_pos certificate).le
  have hDeltaNonneg := (sourceDynamicDelta_pos certificate bound).le
  have hnormalize :
      sourceDynamicDelta certificate bound *
          (principalSum certificate * certificate.lambda ^ uniformNu hp bound) = 1 := by
    unfold sourceDynamicDelta
    have hdenom : principalSum certificate *
        certificate.lambda ^ uniformNu hp bound ≠ 0 :=
      (mul_pos (principalSum_pos certificate)
        (Real.rpow_pos_of_pos certificate.lambda_pos _)).ne'
    field_simp
  calc
    sourceDynamicDelta certificate bound * certificate.principal mode *
          certificate.lambda ^ y =
        sourceDynamicDelta certificate bound *
          (certificate.principal mode * certificate.lambda ^ y) := by ring
    _ <= sourceDynamicDelta certificate bound *
          (principalSum certificate * certificate.lambda ^ uniformNu hp bound) :=
      mul_le_mul_of_nonneg_left hproduct hDeltaNonneg
    _ = 1 := hnormalize
    _ <= sourcePhiK mode y := sourcePhiK_one_le roots hy0

noncomputable def sourceDynamicRetardedInputs
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp) (hlambda : 1 <= certificate.lambda)
    (bound : Nat) (hbound : CriticalSelectedDepthBound hp bound) :
    DynamicRetardedInputs (TrackedMode (p + 1)) where
  Phi := sourcePhiK
  row := sourceDynamicRow hp roots
  coeff := certificate.principal
  lambda := certificate.lambda
  mu := uniformMu hp bound
  nu := uniformNu hp bound
  Delta := sourceDynamicDelta certificate bound
  lambda_pos := certificate.lambda_pos
  mu_pos := uniformMu_pos hp bound
  mu_le_nu := uniformMu_le_uniformNu hp bound
  Delta_nonneg := (sourceDynamicDelta_pos certificate bound).le
  shifts mode y hynu := sourceDynamicRow_shiftsWithin roots hbound mode y hynu
  rows mode y _hy0 hynu := sourceDynamicRow_evalAt_le roots mode y hynu
  feasible mode y hynu :=
    sourceDynamicRow_coefficient_feasible roots certificate mode y hynu
  base mode y hy0 hynu :=
    sourceDynamicBase roots certificate hlambda bound mode y hy0 hynu

theorem sourcePhiK_retarded_lower_bound_for_depthBound
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp) (hlambda : 1 <= certificate.lambda)
    (bound : Nat) (hbound : CriticalSelectedDepthBound hp bound) :
    forall mode y, 0 <= y ->
      sourceDynamicDelta certificate bound * certificate.principal mode *
        certificate.lambda ^ y <= sourcePhiK mode y :=
  dynamic_retarded_lower_bound
    (sourceDynamicRetardedInputs roots certificate hlambda bound hbound)

theorem exists_sourcePhiK_retarded_lower_bound
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp) (hlambda : 1 <= certificate.lambda) :
    exists Delta : Real, 0 < Delta /\
      forall mode y, 0 <= y ->
        Delta * certificate.principal mode * certificate.lambda ^ y <=
          sourcePhiK mode y := by
  obtain ⟨bound, hbound⟩ := exists_uniform_criticalSelectedDepthBound roots
  exact ⟨sourceDynamicDelta certificate bound,
    sourceDynamicDelta_pos certificate bound,
    sourcePhiK_retarded_lower_bound_for_depthBound
      roots certificate hlambda bound hbound⟩

end GeneralKDynamicRetardedLowerBound

end KL2003
end CollatzClassical
