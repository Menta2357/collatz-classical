# F3 tilted supersolution certificate v1

Date: 2026-07-22.

Status:

```text
PASS_RATIONAL_SUPERSOLUTION
DIAGNOSTIC_RATIONAL_ENVELOPE
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Frozen parameters

```text
rho_prime = 2.5
lambda_prime = 49/50 = 0.98
1/(1+delta) = 100/101
lambda_prime < 100/101 = true
D = 1000000
core_state_count = 243
```

The vector is an integer vector divided by `D`, with each integer obtained by
rounding the positive numerical Perron vector upward.  The final inequalities
are rechecked exactly as `Fraction` inequalities after this rounding.

## 2. Rational upper envelope

The published edge decimals are rounded upward to denominator `10^24`.  The
scale factors are bounded above at denominator `10^18`:

```text
retarded                 = 324/625
advanced_direct_c2       = 605933751378193227 / 500000000000000000
advanced_parity_lift_c1  = 872544601984598247 / 1000000000000000000
```

This makes the audit inequality conservative relative to the published decimal
edge data.  A future formal certificate must replace these decimal envelopes
by proved enclosures for the underlying real scale constants.

## 3. 243 entry-wise checks

For every core source state `s`, the checker verifies exactly

```text
sum_t M_tilt_upper(s,t) * v_t <= (49/50) * v_s.
```

Results:

```text
bad_row_count = 0
max_lhs_over_rhs = 0.9771460555825788
min_lhs_over_rhs = 0.9771452773828146
min_slack_decimal = 22396.960000000054
vector_min_integer = 1000000
vector_max_integer = 308950868
```

The frozen rational vector file is
`results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/tilted_supersolution_v1.csv`,
sha256:

```text
55b2288824dccfe56fcb3a951bdfb47583ac7d4abd00576ed7c273448b2a777a
```

The summary checker is
`scripts/f3_tilted_supersolution_certificate_v1.py`.

## 4. Interpretation

This closes the finite rational supersolution hook for the declared envelope.
It does not yet prove the real operator inequality until the scale and edge
decimal enclosures are themselves certified.  It is therefore Lean-compatible
data and a complete checker contract, not a formal theorem.

