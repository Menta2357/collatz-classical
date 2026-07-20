# KL2003 general-k transfer, uniformity, and k=3 adversarial review v1

Date: 2026-07-20

## Verdict

```text
GENERAL_K_TRANSFER_AND_UNIFORMITY_REVIEW_PASS_WITH_SCOPE_NOTES
K3_END_TO_END_CONSUMER_REVIEW_PASS
NO_MATHEMATICAL_BLOCKER_FOUND
```

## Reviewed load-bearing modules

```text
KL2003GeneralKLNTFeasibilityTransfer
KL2003GeneralKUniformCriticalDepth
KL2003GeneralKUniformRetardedWindow
KL2003GeneralKDynamicRetardedLowerBound
KL2003K3LNTCertificate
```

Their role is to turn a pointwise critical scheduler witness into a uniform
retarded induction input without constructing the canonical EL normal form.

## LNT feasibility transfer

`LNTCertificate` represents the homogeneous L1-L4 feasibility core:
positive principal and auxiliary values, the D1/D2/D3 inequalities, and the
three auxiliary-to-lift inequalities. It deliberately omits the L0
normalization `1 <= c_k^m` and `Cmax`, which do not participate in the
homogeneous transfer. This scope is now stated at the structure definition.

The omission is not hidden at the public consumer. The generated k=3 verifier
proves the box inequalities, and `one_le_k3Principal` is explicitly used when
the final source-envelope theorem drops the class coefficient from its left
side.

The transfer has the required inequality directions:

1. each L1-L3 row proves root coefficient `<=` expanded coefficient value;
2. replacing an auxiliary by the minimum of its three lifts preserves that
   direction using L4;
3. source splitting weakly increases coefficient value;
4. deletion removes minimum branches and therefore weakly increases the
   minimum;
5. selecting a source-critical branch need not be coefficient-critical, so
   Lean correctly uses `full coefficient expression <= selected expression`.

This yields coefficient feasibility for the exact pointwise witness produced
by the source scheduler, not for an assumed arbitrary retarded row.

## Uniform depth and retarded window

Pointwise termination alone does not imply a uniform shift gap. The code does
not make that invalid inference.

`UniformCriticalDepth` argues by contradiction. Unbounded selected depths give
nonempty finite prefix types at every depth. The inverse-limit form of Konig's
lemma extracts one coherent infinite packed source walk. Every finite prefix
comes from an actual selected source provenance, so it carries both
nonnegative accumulated shift and advanced-arrival dominance. The recurrent
drop theorem excludes the resulting infinite walk.

`UniformRetardedWindow` then:

- bounds all terminal walks by one more edge than the selected expansion
  depth;
- transports exact provenance through normalization and critical selection;
- enumerates the finite family of all negative packed shifts of bounded
  length; and
- defines `uniformMu` and `uniformNu` as its exact positive minimum and
  maximum backward shifts.

The finite family intentionally contains more packed codes than the coherent
source walks. This only makes the interval more conservative; every selected
leaf is still represented, and positivity of `uniformMu` follows from taking
the minimum of a finite nonempty set of strictly positive backward shifts.

## Dynamic retarded induction

`dynamic_retarded_lower_bound` is a genuine strong induction on
`genericRetardedRank`. In the inductive region `nu < y`, `ShiftsWithin`
provides both facts needed at every leaf:

```text
y + beta >= 0
rank (y + beta) < rank y
```

The row, semantic inequality, and coefficient inequality may depend on the
current mode and real argument. This is exactly what allows the pointwise
critical witness to replace a canonical global EL tree.

The source instantiation chooses

```text
Delta = 1 / (sum_m c_m * lambda^nu).
```

This is generally more conservative than the paper's expression based on
`min phi_m(0) / max c_m`, but P1 proves it is positive and sufficient. The
formal theorem preserves the exponent and does not claim the paper's numerical
constant.

## k=3 end-to-end consumer

The k=3 module closes every hypothesis used by the generic chain:

- nine tracked classes are inhabited by explicit non-cycle roots;
- the generated rational certificate is rechecked row by row in Lean;
- endpoint lower bounds connect rational row factors to the true real powers;
- every principal coefficient is at least one;
- `lambda = 152759 / 100000 > 1`;
- `gammaK3 > 3/5`;
- the floor window becomes exactly `x` at
  `y = logb 2 (x/a)`.

The terminal theorem is uniform over all tracked modes, all admissible roots,
and every natural `x >= a`. It is a k=3 counting lower bound, not a k=9,
k=11, full M1, or global Collatz theorem.

## Scope differences from the printed route

```text
L0_NORMALIZATION_NOT_A_FIELD_OF_GENERIC_LNTCERTIFICATE
LAMBDA_UPPER_BOUND_TWO_NOT_NEEDED_BY_FORMAL_TRANSFER
CANONICAL_L_EL_PROGRAM_NOT_CONSTRUCTED
DYNAMIC_POINTWISE_ROWS_USED_INSTEAD
DELTA_MORE_CONSERVATIVE_THAN_PRINTED_CONSTANT
```

Each difference either has a named concrete discharge or weakens only the
constant, not the exponent or theorem direction.

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKLNTFeasibilityTransferAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKUniformCriticalDepthAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKUniformRetardedWindowAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKDynamicRetardedLowerBoundAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003K3LNTCertificateAxiomAudit.lean
git diff --check
```

Expected terminal audit profile:

```text
[propext, Classical.choice, Quot.sound]
```

## Classification

```text
LNT_L1_L4_HOMOGENEOUS_CORE_REVIEWED
L0_NORMALIZATION_SCOPE_EXPLICIT
POINTWISE_COEFFICIENT_TRANSFER_REVIEWED
UNIFORM_CRITICAL_DEPTH_REVIEWED
UNIFORM_RETARDED_WINDOW_REVIEWED
DYNAMIC_RETARDED_INDUCTION_REVIEWED
K3_CERTIFICATE_CONSUMER_REVIEWED_END_TO_END
GENERAL_K_TRANSFER_AND_UNIFORMITY_REVIEW_PASS_WITH_SCOPE_NOTES
K3_END_TO_END_CONSUMER_REVIEW_PASS
NO_GLOBAL_COLLATZ_CLAIM
```
