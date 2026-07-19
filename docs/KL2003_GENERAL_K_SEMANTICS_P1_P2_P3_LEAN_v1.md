# KL2003 general-k semantics P1/P2/P3 Lean v1

Date: 2026-07-19

## Scope

This note records the indexed source semantics and the first three semantic
properties from KL2003. It does not claim that Module 1 of the general-k chain
is complete: parity normalization and the generic D1/D2/D3 rows remain open.

## Lean files

```text
CollatzClassical/KL2003/KL2003GeneralKSemantics.lean
CollatzClassical/KL2003/KL2003GeneralKSemanticsAxiomAudit.lean
```

The shared window-monotonicity theorem was moved to its semantic home:

```text
CollatzClassical/KL2003/KL2003M0BReachabilityAPI.lean
```

`KL2003ConcretePhiRealization.lean` now consumes that lower-layer theorem
instead of maintaining a duplicate.

The same API now owns the route-closure and parity-root transfer used by the
generic D1 normalization:

```lean
notInCycle_of_iterate_maps_to_notInCycle
piStar_two_mul_root_transfer_nat
```

The latter proves the source-safe member-wise direction
`piStar (2*c) xLift <= piStar c x` whenever `xLift <= x`.

## Indexed semantics

The module defines:

```lean
generalKModulus k = 3 ^ k
TrackedMode k
ClassRootsK k m
GeneralKClassRootsNonempty k
sourcePhiK m y
```

For nonnegative `y`, `sourcePhiK` is the `iInf` of the real casts of
`piStar a (sourceWindow y a)` over roots in one tracked residue class. For
negative `y`, it is zero.

The traffic API proves nonnegativity, member-to-infimum transfer,
infimum-to-member transfer, P1, and P2:

```lean
sourcePhiK_nonneg
sourcePhiK_le_piStar
le_sourcePhiK_of_forall_mode
le_sourcePhiK_of_forall
sourcePhiK_one_le
sourcePhiK_mono_y
```

## Non-emptiness at k=3

The module does not assume a wrapper asserting that all `k=3` classes are
inhabited. It constructs explicit witnesses from powers of two and proves
that such powers are not in a cycle:

```lean
generalK_iterate_T_two_pow_of_le
notInCycle_two_pow
k3_classRoots_nonempty
```

The nine tracked residues modulo 27 use exponents
`19, 5, 3, 13, 17, 15, 7, 11, 9`, respectively. This closes P1 and P2 for
the concrete `k=3` source system without an external non-emptiness premise:

```lean
sourcePhiK_three_one_le
sourcePhiK_three_mono_y
```

Generic non-emptiness for arbitrary `k` remains open and is not inferred from
the finite `k=3` construction.

## P3 minimization

P3 is proved from a concrete partition rather than introduced as a bridge
hypothesis. The module defines the three lifted modes at level `k + 1`, maps
every lifted root back to its parent class, and assigns every parent root to
the unique lift selected by the next ternary digit:

```lean
liftTrackedMode
classRootOfLift
classRootLiftIndex
classRoot_parent_residue_at_lift
classRootAtLift
```

The two inclusions between these root populations yield the exact equality
of infima:

```lean
sourcePhiK_P3
```

The generic theorem assumes non-emptiness of the child level because a lower
bound for an indexed infimum needs an inhabited index type. Its first planned
consumer is already unconditional:

```lean
sourcePhiK_P3_two_to_three
```

This specializes P3 from modulus 9 to modulus 27 using
`k3_classRoots_nonempty`.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKSemantics
lake env lean CollatzClassical/KL2003/KL2003GeneralKSemanticsAxiomAudit.lean
lake build CollatzClassical.KL2003.KL2003M0BReachabilityAPI
lake build CollatzClassical.KL2003.KL2003ConcretePhiRealization
lake env lean CollatzClassical/KL2003/KL2003M0BReachabilityAPIAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003ConcretePhiRealizationAxiomAudit.lean
git diff --check
```

All builds and audits pass. The audited semantic theorems use only the
expected profile:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `unsafe`, or `native_decide` is used.

## Remaining Module 1 work

```text
GENERAL_K_PARITY_NORMALIZATION
GENERAL_K_D1_D2_D3_SOURCE_ROWS
GENERAL_K_SATISFIES_IK_CONTRACT
K2_V3_UNPADDED_REGRESSION
```

The member-wise parity transfer required by D1 is proved. The exact infimum
identity printed as equation (200), which starts from a mode congruent to
`1 mod 3`, is not yet claimed: the current indexed `sourcePhiK` deliberately
contains only tracked modes congruent to `2 mod 3`. Its reverse inequality
must be derived before the index type is widened or an equality theorem is
introduced.

## Classification

```text
GENERAL_K_INDEXED_SOURCE_PHI_DEFINED
GENERAL_K_P1_PROVED_CONDITIONALLY_ON_NONEMPTY_ROOTS
GENERAL_K_P2_PROVED_CONDITIONALLY_ON_NONEMPTY_ROOTS
K3_CLASS_ROOTS_NONEMPTY_PROVED_BY_EXPLICIT_WITNESSES
K3_SOURCE_P1_PROVED
K3_SOURCE_P2_PROVED
GENERAL_K_P3_PARTITION_PROVED
K2_TO_K3_P3_PROVED
GENERAL_K_PARITY_MEMBER_TRANSFER_PROVED
SOURCE_EQUATION_200_EQUALITY_NOT_YET_PROVED
GENERAL_K_SEMANTICS_AXIOM_AUDIT_PASS
GENERAL_K_MODULE_1_NOT_YET_COMPLETE
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_FORMALISATION_NOT_AUTHORIZED
NO_GLOBAL_COLLATZ_CLAIM
```
