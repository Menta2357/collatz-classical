# F3 PHASE_B dynamic operator contract v1

Date: 2026-07-21.

Status:

```text
OPERATOR_GATE_OPEN
NO_RHO_CERTIFICATE_YET
NO_LEAN
NO_DENSITY_THEOREM
```

## 1. Rule-derived state space

For this first operator:

```text
K = 5
depths d = 1..5
residues r mod 3^d = all residues
nu2 bucket b in {0,1,2}, where 2 means >= 2
parity p derived from b: b=0 is odd, b=1 or b=2 is even
```

A state is:

```text
u = (d, r, p, b)
```

This gives:

```text
sum_{d=1}^5 3^d * 3 = 1089 valid states
```

## 2. Rule-derived transitions

The retarded branch is always:

```text
a -> 4a
d -> d
r -> 4r mod 3^d
p -> even
b -> 2
```

The advanced branch exists exactly when:

```text
r == 2 mod 3
```

and maps:

```text
a -> c(a) = (2a - 1) / 3
d -> d - 1
r -> (2r - 1) / 3 mod 3^(d-1), for d > 1
```

When `d = 1`, the advanced branch is routed to `Q_K:DEPTH_ZERO`.

Because parity and `nu2(c(a))` are not determined by `(d,r,p,b)` alone after
division by 3, the rule-derived operator splits that branch over the three
arithmetic lifts at depth `d+1` and records child type multiplicities. This is
still rule-derived: no empirical pi-star masses are used.

## 3. Naive incidence operator

The first matrix `M_naive` records branch incidence only:

```text
one retarded edge per state
one advanced edge, or tail, for states r == 2 mod 3
```

This operator intentionally ignores scale factors from window growth. It is a
sanity object, not expected to certify `rho > 1.7922`.

If `M_naive` has spectral radius at most 1, the correct conclusion is not that
PHASE_B fails. The conclusion is:

```text
SCALE_AWARE_OPERATOR_REQUIRED
```

## 4. Acceptance

`F3_PHASE_B_DYNAMIC_OPERATOR_v1` may only output:

```text
PASS_RULE_DERIVED_OPERATOR
STOP_NAIVE_OPERATOR_TOO_WEAK
SCALE_AWARE_OPERATOR_REQUIRED
BAD_RULE_HOOKS
```

Forbidden:

```text
RHO_CERTIFIED
LEAN_READY
DENSITY_THEOREM
```
