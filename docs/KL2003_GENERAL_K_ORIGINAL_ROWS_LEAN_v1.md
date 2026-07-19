# KL2003 general-k original rows Lean v1

Date: 2026-07-19

## Scope

This note records the source-faithful original difference rows `D1`, `D2`,
and `D3` for the indexed `sourcePhiK` semantics. The implementation is
parametric in the level and uses the paper's `Nat.floor` window policy.

## Lean files

```text
CollatzClassical/KL2003/KL2003GeneralKOriginalRows.lean
CollatzClassical/KL2003/KL2003GeneralKOriginalRowsAxiomAudit.lean
```

## Rule-derived class operators

The module defines, without consulting a k=2 row as source data:

```lean
sourceAdvancedChild a = (2*a - 1) / 3
fourTrackedMode
d1LowerTrackedMode
d3LowerTrackedMode
```

The lower modes normalize the source expressions
`(4*m - 2)/3` and `(2*m - 1)/3` modulo `3^(k-1)`. Their membership proofs
cancel the common factor three in congruences modulo
`3 * 3^(k-1)`.

Concrete root constructors prove the corresponding semantic memberships:

```lean
retardedClassRootK
d1LiftedClassRootK
d3AdvancedClassRootK
```

The D1 constructor performs the parity lift from the direct child `c` to
`2*c`; D3 uses `c` directly. `NotInCycle` is inherited from the finite route
back to the parent root.

## Original rows

The three proved row families are:

```lean
sourcePhiK_D1
sourcePhiK_D2
sourcePhiK_D3
```

For a top level `p+1`, they assume `1 <= p`, non-emptiness of the top-level
root classes, and `2 <= y`. They conclude exactly the unpadded source rows:

```text
D1: phi_m(y) >= phi_4m(y-2) + phi_(4m-2)/3(y+alpha-2)
D2: phi_m(y) >= phi_4m(y-2)
D3: phi_m(y) >= phi_4m(y-2) + phi_(2m-1)/3(y+alpha-1)
```

The proof consumes the class-independent M0B core, exact retarded/parity
window identities, advanced floor-window bounds, and member-to-infimum
traffic. D1 uses the audited member-wise inequality
`piStar (2*c) <= piStar c`; it does not assume the unproved source equation
(200) as an equality of infima.

The rows are bundled by:

```lean
SatisfiesIk
sourcePhiK_satisfies_Ik
```

The first integration target is closed without external hypotheses:

```lean
sourcePhiK_three_satisfies_Ik
```

It combines the generic row theorem with the nine explicit `k=3` class-root
witnesses.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKOriginalRows
lake env lean CollatzClassical/KL2003/KL2003GeneralKOriginalRowsAxiomAudit.lean
git diff --check
```

The build and audit pass. Audited theorems use only:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `unsafe`, or `native_decide` is present.

## Boundary

This closes the source-semantics and original-row portion of Module 1 for
the `k=3` consumer. It does not prove EL termination, EL semantic
preservation, feasibility transfer, the k=3 `piStar` lower bound, k=9, k=11,
or global Collatz.

The exact parity identity printed as equation (200) remains a separately
named source-proof debt. It is not needed by `SatisfiesIk` because D1 is
realized member-wise through the parity child.

## Classification

```text
GENERAL_K_RULE_DERIVED_MODE_OPERATORS_PROVED
GENERAL_K_D1_SOURCE_ROW_PROVED
GENERAL_K_D2_SOURCE_ROW_PROVED
GENERAL_K_D3_SOURCE_ROW_PROVED
GENERAL_K_SATISFIES_IK_PROVED_CONDITIONALLY_ON_NONEMPTY_ROOTS
K3_SOURCE_SATISFIES_IK_PROVED
GENERAL_K_ORIGINAL_ROWS_AXIOM_AUDIT_PASS
SOURCE_EQUATION_200_EQUALITY_NOT_YET_PROVED
EL_TERMINATION_AND_FEASIBILITY_TRANSFER_NOT_YET_PROVED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
