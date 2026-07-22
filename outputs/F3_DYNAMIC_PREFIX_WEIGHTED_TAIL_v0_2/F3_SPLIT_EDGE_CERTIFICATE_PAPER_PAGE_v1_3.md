# F3 split-edge certificate — paper page v1.3 (three hooks)

Date: 2026-07-22.

Status:

```text
PAPER_HOOKS_PASS
CHERNOFF_ROUTE_READY_FOR_COMBINED_LEDGER
CANDIDATE_CERTIFICATE_EMPIRICAL
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

This page consolidates the three computational obligations requested after the
tilted Chernoff draft.  It does not silently turn a rational envelope or a
finite table into a theorem about the underlying real operator.

## 1. Supersolution hook

At `rho_prime=2.5`, choose

```text
lambda_prime = 49/50 = 0.98 < 100/101 = 1/(1+delta)
D = 1000000
```

The checker rounds the positive right Perron vector upward and verifies the
243 inequalities

```text
M_tilt_upper * v <= lambda_prime * v
```

entry by entry, using upward rational envelopes for the published edge decimals
and scale factors.  Results:

```text
bad_row_count = 0
max_lhs_over_rhs = 0.9771460555825788
min_lhs_over_rhs = 0.9771452773828146
```

The exact rational rows are in
`results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/tilted_supersolution_v1.csv`.
The checker is
`scripts/f3_tilted_supersolution_certificate_v1.py`.

This is a complete certificate for the declared rational envelope.  A formal
real-operator proof still needs certified enclosures for the scale constants
and the published decimal edge weights.

## 2. Base hook

For `[3,10369)` and `y_base=8`, every one of the 243 core states has at least
10 explicit root witnesses, and every state reaches the fixed target
`d5:r2:podd:b0` in at most six split-core edges:

```text
root_count_total = 3455
root_count_min = 10
root_count_max = 22
zero_witness_states = 0
unreachable_states = 0
distance_max = 6
weighted_base_mass_min = 0.031
```

The witnesses are roots themselves in `piStar(a,2^8*a)`, so positivity is
literal finite membership, not an asymptotic assumption.  Full table:
`results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/base_segment_table_v1.csv`.

## 3. Uniform Q hooks

The sterile ray has the exact count

```text
Q_sterile(y) = y+1,
Q_sterile(y)/(9/5)^y <= 9/(9/5)^8
              = 0.08166998364405036       for y>=8.
```

The inequality is one-line arithmetic monotonicity.  For fine period `2916`,
the three lift counts in any interval differ by at most one; after removing
complete triples, the boundary remainder is at most two roots per core state.
The calibration and holdout intervals realize maxima 1 and 2 respectively.

Checker: `scripts/f3_uniform_q_bounds_v1.py`.
Output: `results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/uniform_q_bounds_v1.json`.

## 4. Combined-paper gate

The three hooks now pass as finite objects:

```text
SUPERSOLUTION = PASS_RATIONAL_ENVELOPE
BASE_SEGMENT = PASS_FINITE_BASE_SEGMENT
UNIFORM_Q = PASS_UNIFORM_COUNTING_LEMMAS
```

The next paper action is to combine their constants into the single remainder
inequality required by Chernoff Lemma B, namely an explicit

```text
E_y <= eta * C_I * rho_star^(y-y_base),  eta < 1.
```

The page may advance to a formal candidate only after this combination and the
real-operator enclosure bridge are reviewed.  The Lean decision remains after
that paper review, with a written M0 budget.

## 5. Non-claims

```text
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
NO_LEAN_OPERATOR
```

