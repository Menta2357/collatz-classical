# F3 semantic lower-hook gap v1

Status: `OPEN_SEMANTIC_LOWER_HOOK`; no theorem claim.

This note records the exact direction mismatch between the currently verified
finite semantic facts and the hypothesis required by the conditional renewal
bridge.

## Already proved

For a finite family of first-hit fibres, Lean proves

```text
sum_i card(firstHitSource_i) <= card(piStarFinset a x)
```

and its aggregate version over a root block.  This is the correct
no-double-counting/inclusion direction.

## Still required

The conditional Real bridge requires, at each iteration level `n`,

```text
weightedMass w (iteratePush M initial n)
  <= sum_a sum_i card(firstHitSource n a i)
```

This is a lower bound on retained first-hit mass.  It does not follow from
the inclusion theorem: empty fibres satisfy all inclusion and disjointness
hypotheses.  It requires the scale/multiplicity accounting and the uniform
leakage estimate.

## Why the existing holdout is not this hook

The split-edge holdout reports

```text
lhs_total / rhs_total,
rhs_total = sum_i complete_core_row_count_i * (1+delta) * w_i.
```

Those are frozen-row/root-count quantities.  They do not enumerate or lower
bound the first-hit fibre sum.  Therefore the holdout pass cannot be cited as
evidence for `operator_to_fibres` without an additional semantic counting
lemma.

## Next gate

1. Fix a finite block and define every first-hit fibre with its exact channel
   multiplicity.
2. Prove the one-level lower inequality above, including boundary leakage.
3. Generalize the same inequality uniformly in `y`.
4. Only then instantiate `exponential_piStar_mass_lower_bound`.

If step 2 fails even for a finite block, the F3 theorem route stops while the
kernel-checked operator and empirical reports remain valid.  NO claims of a
rho certificate, density, almost-all statement, or global Collatz theorem are
made here.
