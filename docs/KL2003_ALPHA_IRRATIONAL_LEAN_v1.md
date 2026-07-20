# KL2003 alpha irrationality and zero-walk exclusion in Lean v1

Date: 2026-07-20

## Scope

`KL2003AlphaIrrational.lean` proves the arithmetic input needed to turn the
nonincrease supplied by contextual deletion into strict decrease for a
nonempty source walk.

It does not prove contextual nonincrease, simple-cycle decomposition,
uniform epsilon, full EL termination, or order independence.

## Irrationality proof

The module proves:

```text
alpha_irrational : Irrational alpha
```

The proof uses the existing exact identity `2 ^ alpha = 3`. If `alpha` were
the cast of a rational `q`, positivity of `alpha` would make `q.num`
positive. Writing `q` with its positive denominator and raising

```text
2 ^ (q.num / q.den) = 3
```

to `q.den` gives an equality of natural powers. The power of two is even
because the numerator is positive, while every power of three is odd.

No transcendence theorem or numerical interval certificate is used.

## Source-walk consequences

For a symbolic shift with nonzero alpha coefficient, its evaluation is
irrational. If the alpha coefficient is zero and the constant coefficient is
negative, its evaluation is visibly nonzero. The existing source graph proves
that every nonempty source walk has strictly negative constant coefficient,
so the module obtains:

```text
weight_eval_ne_zero_of_length_pos
```

It also packages the exact consumer needed by the next module:

```text
weight_eval_neg_of_length_pos_of_nonpos
```

Thus any future contextual argument giving `walk.weight.eval <= 0` for a
nonempty repeated-mode segment may strengthen it to strict negativity without
assuming a uniform gap.

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003AlphaIrrational.lean
lake env lean CollatzClassical/KL2003/KL2003AlphaIrrationalAxiomAudit.lean
```

The audited theorems report only:

```text
[propext, Classical.choice, Quot.sound]
```

## Classification

```text
KL2003_ALPHA_IRRATIONAL_PROVED
GENERAL_K_SYMBOLIC_SHIFT_NONZERO_ALPHA_EVAL_IRRATIONAL_PROVED
GENERAL_K_NONEMPTY_SOURCE_WALK_ZERO_WEIGHT_EXCLUDED
GENERAL_K_NONPOSITIVE_NONEMPTY_SOURCE_WALK_STRICTLY_NEGATIVE_PROVED
GENERAL_K_ALPHA_IRRATIONAL_AXIOM_AUDIT_PASS
GENERAL_K_CONTEXTUAL_NONINCREASE_NOT_YET_PROVED
GENERAL_K_SIMPLE_CYCLE_DECOMPOSITION_NOT_YET_PROVED
GENERAL_K_UNIFORM_EPSILON_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
