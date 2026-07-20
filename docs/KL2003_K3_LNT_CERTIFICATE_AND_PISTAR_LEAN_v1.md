# KL2003 k=3 LNT certificate and piStar lower bound in Lean

Date: 2026-07-20

## Scope

This module is the first semantic consumer of the generated-and-verified k=3
pilot. It converts the nine principal and three auxiliary rational values into
the source-faithful `LNTCertificate` required by the general-k induction.

The construction is exhaustive over the tracked residue classes modulo 27.
For each source row, Lean rechecks the exact rational inequality. The verified
endpoint theorems `bReal3_lower` and `dReal3_lower` then replace the rational
lower factors by the true powers `lambda^(alpha-2)` and
`lambda^(alpha-1)`. The auxiliary-to-lift box constraints are likewise checked
for every one of the nine lifts. The generator is not trusted.

The resulting certificate has

```text
lambda = 152759 / 100000
gammaK3 = logb 2 lambda
gammaK3 > 3/5.
```

Applying the dynamic general-k lower-bound theorem gives a positive, possibly
non-explicit constant `Delta`. The source envelope then transfers the bound to
each concrete class root. Finally, setting
`y = logb 2 (x/a)` makes the source-faithful floor window exactly equal to the
natural number `x`.

The public arbitrary-x theorem is:

```lean
exists_k3_piStar_arbitrary_x_lower_bound :
    exists Delta : Real, 0 < Delta /\
      forall (mode : TrackedMode 3) (a : ClassRootsK 3 mode) (x : Nat),
        a.1 <= x ->
        Delta * (((x : Real) / (a.1 : Real)) ^ gammaK3) <=
          (piStar a.1 x : Real)
```

Thus the theorem is uniform over all nine tracked classes modulo 27 and all
admissible roots in those classes. The only lower threshold is the natural
condition `x >= a`.

## Fidelity and non-claims

- This is the k=3 LNT lower-bound consumer, not the k=9 or k=11 theorem.
- The exponent is certified only by the convenient exact lower bound
  `gammaK3 > 3/5`; the generated rational lambda lies safely below the
  published k=3 optimum associated with approximately `0.6112620`.
- `Delta` is proved positive but is not exposed as a compact numerical
  constant.
- No claim about all Collatz trajectories or the global Collatz conjecture is
  made.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003K3LNTCertificate
lake env lean CollatzClassical/KL2003/KL2003K3LNTCertificateAxiomAudit.lean
```

Classifications:

```text
K3_LNT_CERTIFICATE_CONSTRUCTED
K3_NINE_MODE_ROWS_RECHECKED_IN_KERNEL
K3_AUXILIARY_LIFT_BOX_RECHECKED
GAMMA_K3_GT_THREE_FIFTHS_PROVED
K3_SOURCEPHIK_LOWER_BOUND_PROVED
K3_PISTAR_SOURCE_WINDOW_LOWER_BOUND_PROVED
K3_PISTAR_ARBITRARY_X_LOWER_BOUND_PROVED
K3_FIRST_SEMANTIC_CONSUMER_COMPLETE
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
