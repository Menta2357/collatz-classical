import CollatzClassical.KL2003.KL2003GeneralKCriticalStopSemantics

namespace CollatzClassical
namespace KL2003
namespace GeneralKLNTFeasibilityTransfer

/-!
Coefficient feasibility transfer from the source LNT inequalities to the
pointwise retarded witnesses produced by the critical general-k scheduler.

`LNTCertificate` states the source L1--L4 inequalities. Splitting a terminal
weakly increases the normalized coefficient expression, while source deletion
only replaces a minimum by retained branches and therefore also weakly
increases it. Iterating the actual scheduler and then selecting a critical
assignment yields a finite all-retarded expression whose coefficient value
dominates the principal root coefficient.

This module is deliberately pointwise. It does not prove a uniform lower bound
on the negative leaf shifts of witnesses chosen at different real arguments.
That finite-window statement remains necessary before the generic retarded
induction can consume the generated k=3 certificate.
-/

open GeneralKSourceGenealogy
open GeneralKSourceGenealogy.ProvenancedTree
open GeneralKProvenancedScheduler
open ELTree

structure LNTCertificate {p : Nat} (hp : 1 <= p) where
  lambda : Real
  principal : TrackedMode (p + 1) -> Real
  auxiliary : TrackedMode p -> Real
  lambda_pos : 0 < lambda
  principal_pos : forall mode, 0 < principal mode
  auxiliary_pos : forall mode, 0 < auxiliary mode
  auxiliary_le_lift : forall mode j,
    auxiliary mode <= principal (liftTrackedMode hp mode j)
  d1 : forall (mode : TrackedMode (p + 1))
      (hm : mode.1.1 % 9 = 2),
    principal mode <=
      principal (fourTrackedMode (by omega) mode) * lambda ^ (-2 : Real) +
        auxiliary (d1LowerTrackedMode hp mode hm) * lambda ^ (alpha - 2)
  d2 : forall (mode : TrackedMode (p + 1))
      (_hm : mode.1.1 % 9 = 5),
    principal mode <=
      principal (fourTrackedMode (by omega) mode) * lambda ^ (-2 : Real)
  d3 : forall (mode : TrackedMode (p + 1))
      (hm : mode.1.1 % 9 = 8),
    principal mode <=
      principal (fourTrackedMode (by omega) mode) * lambda ^ (-2 : Real) +
        auxiliary (d3LowerTrackedMode hp mode hm) * lambda ^ (alpha - 1)

noncomputable def LNTCertificate.coefficientValue
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp) :
    TrackedMode (p + 1) -> Real -> Real :=
  fun mode beta => certificate.principal mode * certificate.lambda ^ beta

theorem ELExpr.eval_coefficientValue_eq_scale
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (expr : ELExpr (p + 1)) (y : Real) :
    expr.eval certificate.coefficientValue y =
      certificate.lambda ^ y * expr.eval certificate.coefficientValue 0 := by
  induction expr with
  | leaf label =>
      simp only [ELExpr.eval, LNTCertificate.coefficientValue]
      rw [Real.rpow_add certificate.lambda_pos]
      ring
  | add left right ihLeft ihRight =>
      simp only [ELExpr.eval, ihLeft, ihRight]
      ring
  | min3 first second third ihFirst ihSecond ihThird =>
      simp only [ELExpr.eval, ihFirst, ihSecond, ihThird]
      rw [mul_min_of_nonneg _ _ (Real.rpow_nonneg certificate.lambda_pos.le y)]
      rw [mul_min_of_nonneg _ _ (Real.rpow_nonneg certificate.lambda_pos.le y)]

theorem min3_lift_coefficient_lower
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (mode : TrackedMode p) (beta : Real) :
    certificate.auxiliary mode * certificate.lambda ^ beta <=
      min
        (certificate.principal (liftTrackedMode hp mode 0) *
          certificate.lambda ^ beta)
        (min
          (certificate.principal (liftTrackedMode hp mode 1) *
            certificate.lambda ^ beta)
          (certificate.principal (liftTrackedMode hp mode 2) *
            certificate.lambda ^ beta)) := by
  apply le_min
  · exact mul_le_mul_of_nonneg_right
      (certificate.auxiliary_le_lift mode 0)
      (Real.rpow_nonneg certificate.lambda_pos.le beta)
  · apply le_min
    · exact mul_le_mul_of_nonneg_right
        (certificate.auxiliary_le_lift mode 1)
        (Real.rpow_nonneg certificate.lambda_pos.le beta)
    · exact mul_le_mul_of_nonneg_right
        (certificate.auxiliary_le_lift mode 2)
        (Real.rpow_nonneg certificate.lambda_pos.le beta)

theorem d1TopExpr_coefficient_feasible
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (mode : TrackedMode (p + 1)) (hm : mode.1.1 % 9 = 2) :
    certificate.principal mode <=
      (d1TopExpr hp mode hm).eval certificate.coefficientValue 0 := by
  rw [d1TopExpr_eval]
  simp only [LNTCertificate.coefficientValue, zero_add]
  norm_num only [zero_sub]
  exact (certificate.d1 mode hm).trans
    (add_le_add_left
      (min3_lift_coefficient_lower certificate
        (d1LowerTrackedMode hp mode hm) (alpha - 2)) _)

theorem d2TopExpr_coefficient_feasible
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (mode : TrackedMode (p + 1)) (hm : mode.1.1 % 9 = 5) :
    certificate.principal mode <=
      (d2TopExpr hp mode).eval certificate.coefficientValue 0 := by
  rw [d2TopExpr_eval]
  simpa only [LNTCertificate.coefficientValue, zero_sub] using
    certificate.d2 mode hm

theorem d3TopExpr_coefficient_feasible
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (mode : TrackedMode (p + 1)) (hm : mode.1.1 % 9 = 8) :
    certificate.principal mode <=
      (d3TopExpr hp mode hm).eval certificate.coefficientValue 0 := by
  rw [d3TopExpr_eval]
  simp only [LNTCertificate.coefficientValue, zero_add]
  norm_num only [zero_sub]
  exact (certificate.d3 mode hm).trans
    (add_le_add_left
      (min3_lift_coefficient_lower certificate
        (d3LowerTrackedMode hp mode hm) (alpha - 1)) _)

theorem splitTopExpr_coefficient_feasible
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (label : ELLabel (p + 1)) :
    certificate.coefficientValue label.mode label.shift.eval <=
      (splitTopExpr hp label).eval certificate.coefficientValue 0 := by
  unfold splitTopExpr
  split
  next hm2 =>
    rw [ELExpr.shiftBy_eval]
    rw [ELExpr.eval_coefficientValue_eq_scale certificate]
    have h := mul_le_mul_of_nonneg_left
      (d1TopExpr_coefficient_feasible certificate label.mode hm2)
      (Real.rpow_nonneg certificate.lambda_pos.le label.shift.eval)
    simpa [LNTCertificate.coefficientValue, mul_comm] using h
  next hnot2 =>
    split
    next hm5 =>
      rw [ELExpr.shiftBy_eval]
      rw [ELExpr.eval_coefficientValue_eq_scale certificate]
      have h := mul_le_mul_of_nonneg_left
        (d2TopExpr_coefficient_feasible certificate label.mode hm5)
        (Real.rpow_nonneg certificate.lambda_pos.le label.shift.eval)
      simpa [LNTCertificate.coefficientValue, mul_comm] using h
    next hnot5 =>
      have hm8 : label.mode.1.1 % 9 = 8 := by
        rcases trackedMode_mod_nine_cases label.mode with h | h | h
        · exact False.elim (hnot2 h)
        · exact False.elim (hnot5 h)
        · exact h
      rw [ELExpr.shiftBy_eval]
      rw [ELExpr.eval_coefficientValue_eq_scale certificate]
      have h := mul_le_mul_of_nonneg_left
        (d3TopExpr_coefficient_feasible certificate label.mode hm8)
        (Real.rpow_nonneg certificate.lambda_pos.le label.shift.eval)
      simpa [LNTCertificate.coefficientValue, mul_comm] using h

theorem sourceSplitTree_coefficient_feasible
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    (label : ELLabel (p + 1)) :
    (ELTree.terminal label).normalExpr.eval certificate.coefficientValue 0 <=
      (sourceSplitTree hp label).normalExpr.eval
        certificate.coefficientValue 0 := by
  simpa [ELTree.normalExpr, sourceSplitTree, ELTree.normalExpr_ofExpr,
    ELExpr.eval, LNTCertificate.coefficientValue] using
      splitTopExpr_coefficient_feasible certificate label

theorem ELTree.ExpandableOccurrence.split_coefficient_mono
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    {tree : ELTree (p + 1)} (occurrence : ELTree.ExpandableOccurrence tree) :
    tree.normalExpr.eval certificate.coefficientValue 0 <=
      (occurrence.split hp).normalExpr.eval certificate.coefficientValue 0 := by
  have hplug := occurrence.path.context.plug_normalExpr_eval_mono
    (.terminal occurrence.target) (sourceSplitTree hp occurrence.target)
    certificate.coefficientValue 0
    (sourceSplitTree_coefficient_feasible certificate occurrence.target)
  simpa [occurrence.path.context_plug_target,
    TerminalPath.context_plug_sourceSplitTree hp occurrence.path] using hplug

theorem ELTree.ExpandableOccurrence.sourceStep_coefficient_mono
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    {tree : ELTree (p + 1)} (occurrence : ELTree.ExpandableOccurrence tree) :
    tree.normalExpr.eval certificate.coefficientValue 0 <=
      (occurrence.sourceStep hp).normalExpr.eval
        certificate.coefficientValue 0 := by
  have hsplit :=
    GeneralKLNTFeasibilityTransfer.ELTree.ExpandableOccurrence.split_coefficient_mono
      certificate occurrence
  rcases trackedMode_mod_nine_cases occurrence.target.mode with hm2 | hm5 | hm8
  · rw [occurrence.sourceStep_eq_d1 hp hm2]
    exact hsplit.trans
      ((occurrence.d1Configuration hp hm2).minPath.normalExpr_eval_le_reduceAt
        (occurrence.d1Configuration hp hm2).witnessRetention
        certificate.coefficientValue 0)
  · rw [occurrence.sourceStep_eq_d2 hp hm5]
    exact hsplit
  · rw [occurrence.sourceStep_eq_d3 hp hm8]
    exact hsplit.trans
      ((occurrence.d3Configuration hp hm8).minPath.normalExpr_eval_le_reduceAt
        (occurrence.d3Configuration hp hm8).witnessRetention
        certificate.coefficientValue 0)

theorem criticalScheduledStep_coefficient_mono
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    {root : ELLabel (p + 1)}
    (tree : ProvenancedTree hp root) (y : Real) :
    tree.forget.normalExpr.eval certificate.coefficientValue 0 <=
      (GeneralKCriticalScheduler.criticalScheduledStep tree y).forget.normalExpr.eval
        certificate.coefficientValue 0 := by
  generalize hfind : GeneralKCriticalTerminalFinder.findCriticalExpandableOccurrence
      tree (fun mode z => sourcePhiK mode z) y = result
  cases result with
  | none =>
      simp [GeneralKCriticalScheduler.criticalScheduledStep, hfind]
  | some selected =>
      rw [GeneralKCriticalScheduler.criticalScheduledStep_eq_sourceStep_of_find_eq_some
        tree y selected hfind]
      rw [selected.occurrence.sourceStep_forget]
      exact
        GeneralKLNTFeasibilityTransfer.ELTree.ExpandableOccurrence.sourceStep_coefficient_mono
          certificate selected.occurrence.forgetOccurrence

theorem run_coefficient_mono
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    {root : ELLabel (p + 1)} (initial : ProvenancedTree hp root)
    (y : Real) : forall n,
    initial.forget.normalExpr.eval certificate.coefficientValue 0 <=
      (GeneralKCriticalScheduler.run initial y n).forget.normalExpr.eval
        certificate.coefficientValue 0 := by
  intro n
  induction n with
  | zero => exact le_rfl
  | succ n ih =>
      exact ih.trans
        (criticalScheduledStep_coefficient_mono certificate
          (GeneralKCriticalScheduler.run initial y n) y)

theorem ELExpr.CriticalAssignment.eval_le_selectedExpr
    {k : Nat} {expr : ELExpr k}
    (assignment : ELExpr.CriticalAssignment expr)
    (Phi : TrackedMode k -> Real -> Real) (y : Real) :
    expr.eval Phi y <= assignment.selectedExpr.eval Phi y := by
  induction assignment with
  | leaf => exact le_rfl
  | add left right leftChoice rightChoice ihLeft ihRight =>
      exact add_le_add ihLeft ihRight
  | minFirst first second third choice ih =>
      exact (min_le_left _ _).trans ih
  | minSecond first second third choice ih =>
      exact (min_le_right _ _).trans ((min_le_left _ _).trans ih)
  | minThird first second third choice ih =>
      exact (min_le_right _ _).trans ((min_le_right _ _).trans ih)

theorem sourceELRetardedWitness_coefficient_feasible
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    {root : ELLabel (p + 1)} {y : Real}
    (witness : GeneralKCriticalStopSemantics.SourceELRetardedWitness hp root y) :
    certificate.coefficientValue root.mode root.shift.eval <=
      witness.assignment.selectedExpr.eval certificate.coefficientValue 0 := by
  have hrun := run_coefficient_mono certificate
    (ProvenancedTree.initial hp root) y witness.steps
  have hselected :=
    GeneralKLNTFeasibilityTransfer.ELExpr.CriticalAssignment.eval_le_selectedExpr
      witness.assignment certificate.coefficientValue 0
  have hroot :
      certificate.coefficientValue root.mode root.shift.eval <=
        (GeneralKCriticalScheduler.run
          (ProvenancedTree.initial hp root) y witness.steps).forget.normalExpr.eval
            certificate.coefficientValue 0 := by
    simpa [ProvenancedTree.forget_initial, ELTree.normalExpr, ELExpr.eval]
      using hrun
  exact hroot.trans hselected

theorem satisfiesELAt_coefficient_feasible
    {p : Nat} {hp : 1 <= p} (certificate : LNTCertificate hp)
    {root : ELLabel (p + 1)} {y : Real}
    (hsatisfies : GeneralKCriticalStopSemantics.SatisfiesELAt
      (hp := hp) root y) :
    exists witness : GeneralKCriticalStopSemantics.SourceELRetardedWitness hp root y,
      certificate.coefficientValue root.mode root.shift.eval <=
        witness.assignment.selectedExpr.eval certificate.coefficientValue 0 := by
  rcases hsatisfies with ⟨witness⟩
  exact ⟨witness, sourceELRetardedWitness_coefficient_feasible certificate witness⟩

def PointwiseELCoefficientFeasible
    {p : Nat} (hp : 1 <= p) (certificate : LNTCertificate hp) : Prop :=
  forall mode y, 2 <= y ->
    exists witness : GeneralKCriticalStopSemantics.SourceELRetardedWitness hp
        (GeneralKCriticalStopSemantics.zeroRootLabel mode) y,
      certificate.principal mode <=
        witness.assignment.selectedExpr.eval certificate.coefficientValue 0

theorem sourcePhiK_pointwise_coefficient_feasible
    {p : Nat} {hp : 1 <= p}
    (roots : GeneralKClassRootsNonempty (p + 1))
    (certificate : LNTCertificate hp) :
    PointwiseELCoefficientFeasible hp certificate := by
  intro mode y hy
  obtain ⟨witness, hfeasible⟩ := satisfiesELAt_coefficient_feasible certificate
    (GeneralKCriticalStopSemantics.sourcePhiK_satisfiesEL roots mode y hy)
  refine ⟨witness, ?_⟩
  simpa [LNTCertificate.coefficientValue,
    GeneralKCriticalStopSemantics.zeroRootLabel,
    SymbolicShift.eval_zero] using hfeasible

end GeneralKLNTFeasibilityTransfer
end KL2003
end CollatzClassical
