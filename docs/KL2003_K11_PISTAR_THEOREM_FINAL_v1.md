# KL2003 k=11 piStar theorem final v1

Date: 2026-07-21

## Result

The k=11 high-k path is closed as a Lean theorem:

```lean
exists_k11_piStar_arbitrary_x_lower_bound
```

Location:

```text
CollatzClassical/KL2003/KL2003K11PiStarTheorem.lean
```

The theorem states that there exists `Delta > 0` such that for every tracked
mode modulo `3^11`, every admissible root in `ClassRootsK 11 mode`, and every
`x >= a`, the lower bound

```text
Delta * ((x : Real) / (a : Real))^gammaK11 <= piStar a x
```

holds.

The exponent is:

```lean
gammaK11 := Real.logb 2 lambdaR11
lambdaR11 = 71689 / 40000
```

and Lean proves the named comparison:

```lean
gammaK11_gt_twenty_one_twenty_fifths : (21 / 25 : Real) < gammaK11
```

This exceeds the `0.84` mark from the KL2003 table. It is not a global Collatz
claim and is not presented as a statement about `k > 11`.

## Main components

- `KL2003K11CertificateMatchAggregate`: 59049 row checks and 19683 auxiliary checks.
- `KL2003K11EndpointBounds`: endpoint inequalities for `lambdaR11`.
- `KL2003K11LNTCertificate`: construction of the k=11 `LNTCertificate`.
- `KL2003K11ClassRoots`: non-emptiness of tracked classes, using powers of 2 and a direct order/parity proof for `2` modulo `3^11`.
- `KL2003K11PiStarTheorem`: sourcePhiK, source-window, and arbitrary-x statements.

## ClassRoots note

The first direct port of the k=9 proof combined the orders of `-1` and `-2`
with `orderOf_mul_eq_mul_orderOf_of_coprime`; at k=11 that proof term triggered
kernel deep-recursion. The final proof avoids the large combinator and proves
minimality of `2` directly:

- `orderOf (-2) = 3^10`;
- `(-2)^m = (-1)^m * 2^m`;
- even and odd exponents are discharged by divisibility/parity;
- therefore `orderOf 2 = 2 * 3^10`.

This keeps `ClassRootsK 11` non-emptiness source-faithful without generated
residue witness tables.

## Axiom audit

Audits added:

```text
CollatzClassical/KL2003/KL2003K11ClassRootsAxiomAudit.lean
CollatzClassical/KL2003/KL2003K11LNTCertificateAxiomAudit.lean
CollatzClassical/KL2003/KL2003K11PiStarTheoremAxiomAudit.lean
```

All audited k=11 theorems report:

```text
[propext, Classical.choice, Quot.sound]
```

## Resource calibration

The theorem is kernel-proved. Separately, the real k=11 checker remains a
resource-budget architecture failure relative to the predeclared
maintainability target:

```text
controlled_recovery_total_seconds = 5286.696696
PASS <= 1320 s
FAIL > 1800 s
```

So the mathematical result is closed, while checker maintainability remains an
engineering improvement target.

## Guardrails

```text
K11_PISTAR_ARBITRARY_X_THEOREM_PROVED
GAMMA_K11_GT_TWENTY_ONE_TWENTY_FIFTHS_PROVED
K11_RESOURCE_BUDGET_ARCHITECTURE_FAIL
NO_GLOBAL_COLLATZ_CLAIM
NO_K_GREATER_THAN_11_CLAIM
```
