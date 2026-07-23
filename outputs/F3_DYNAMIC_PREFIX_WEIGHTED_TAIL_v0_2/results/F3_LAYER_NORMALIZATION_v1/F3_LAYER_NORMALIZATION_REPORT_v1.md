# F3 layer-normalization brick v1

Status: `REAL_MEMBERWISE_SUM_NORMALIZATION_PASS`.

This brick isolates the denominator distinction that remains in the F3
semantic lower hook.  It is deliberately a small Real-valued accounting
lemma, not an instantiation of the F3 operator and not a density result.

## Formal content

`sum_contribution_le_sum_fibre_card` proves, member by member, that a finite
sum of Real contributions is bounded by the corresponding sum of finite
fibre cardinalities.  `sum_fibre_card_cast_eq` proves the coercion identity
between the Nat total and the Real sum of cardinals.  Together they keep the
fibre denominator explicit instead of silently replacing it by a root-count
denominator.

The source is
`CollatzClassical/KL2003/F3ReturnExcursionLayerNormalization.lean` and its
audit companion is
`CollatzClassical/KL2003/F3ReturnExcursionLayerNormalizationAxiomAudit.lean`.
Both compile successfully.  The audit reports only
`propext`, `Classical.choice`, and `Quot.sound`.

## Scope and remaining obligation

This is a normalization/accounting brick only.  It does not prove the
missing semantic lower hook, does not instantiate the frozen 243-state
operator, and makes no rho, density, almost-all, or global-Collatz claim.
The remaining F3 blocker is still a *lower* bound from the concrete stopped
operator contribution to first-hit fibre mass, uniformly in the required
window parameter.  The finite diagnostic is encouraging but is not that
uniform theorem.
