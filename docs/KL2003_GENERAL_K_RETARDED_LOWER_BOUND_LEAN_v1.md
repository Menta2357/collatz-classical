# KL2003 general-k retarded lower-bound Lean v1

Date: 2026-07-19

## Scope

This note records the completed k-independent induction core corresponding to
the reusable content of KL2003 Theorem 5.1.

Lean files:

```text
CollatzClassical/KL2003/KL2003GeneralKRetardedLowerBound.lean
CollatzClassical/KL2003/KL2003GeneralKRetardedLowerBoundAxiomAudit.lean
```

The module contains no residue classes, Collatz-specific rows, generated
certificate data, or explicit value of `k`.

## Expression language

`RetardedExpr Index` is a finite AST with three constructors:

```text
leaf index shift
add left right
minE left right
```

Its two evaluations are:

- `evalAt Phi y`, substituting `Phi i (y + beta)` at each leaf; and
- `coeffEval coeff lambda`, substituting `coeff i * lambda^beta`.

The module proves monotonicity under pointwise leaf bounds and homogeneity
under multiplication by a nonnegative scalar. The latter includes the
nontrivial fact that nonnegative scaling commutes with `min`.

## Retarded contract

`ShiftsWithin mu nu` requires every leaf shift `beta` to satisfy:

```text
-nu <= beta <= -mu
```

with `0 < mu <= nu`. The generic rank is:

```lean
genericRetardedRank mu y = Nat.ceil (y / mu)
```

and `genericRetardedRank_drop` proves strict descent for every
`beta <= -mu`.

## Main theorem

`GenericRetardedInputs` packages constructed data and proved obligations:

- the indexed functions and one nested row per index;
- coefficients, `lambda`, `mu`, `nu`, and `Delta`;
- positivity of `lambda` and `mu`;
- nonnegativity of `Delta`;
- retarded shift bounds;
- semantic row inequalities;
- coefficient feasibility; and
- the lower bound on the base interval `0 <= y <= nu`.

The main theorem is:

```lean
generic_retarded_lower_bound
```

It proves the exponential lower bound for every index and every `y >= 0` by
strong induction on `genericRetardedRank`. At an inductive point `y > nu`,
all leaf arguments lie in `[0,y)` and have smaller rank. The nested row is
then closed by AST monotonicity, nonnegative scaling, and coefficient
feasibility.

The theorem deliberately accepts the base inequality as a proved field. The
later KL2003 composition module must construct it from P1 and the explicit
source constant

```text
Delta = lambda^(-nu) * min(Phi_i(0)) / max(coeff_i).
```

No formula for `Delta` is hidden in this generic module.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKRetardedLowerBound
lake env lean CollatzClassical/KL2003/KL2003GeneralKRetardedLowerBoundAxiomAudit.lean
git diff --check
```

Build and audit pass. Every audited theorem reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `unsafe`, or `native_decide` is used.

## Remaining consumers

The result still needs:

1. a general-k concrete `Phi` and its original rows;
2. EL termination and semantic preservation;
3. LNT-to-EL feasibility transfer; and
4. the concrete base/Delta constructor.

Only after those are built may the verified k=3 certificate instantiate this
theorem.

## Classification

```text
GENERIC_RETARDED_EXPR_AST_DEFINED
GENERIC_NESTED_SUM_MIN_MONOTONICITY_PROVED
GENERIC_NESTED_SUM_MIN_SCALING_PROVED
GENERIC_RETARDED_RANK_DROP_PROVED
GENERIC_RETARDED_LOWER_BOUND_PROVED
KL2003_THEOREM_5_1_CORE_PROVED
GENERIC_RETARDED_LOWER_BOUND_AXIOM_AUDIT_PASS
NO_K_SPECIFIC_DATA_CONSUMED
K3_PISTAR_THEOREM_NOT_YET_PROVED
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
