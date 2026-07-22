# F3 advanced phase replacement v0.1

Date: 2026-07-21.

Status:

```text
LOCAL_PREDECLARATION
CLAUDE_UNAVAILABLE
PHASE_A_SELECTED
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
```

## Choice

The first dynamic weighted-tail pilot uses:

```text
PHASE_A
```

That means every advanced branch replaces:

```text
P(c(a), x_a)
```

by the monotone lower substitute:

```text
P(c(a), 2^y c(a))
```

where:

```text
x_a = 2^y a
c(a) = (2a - 1) / 3
```

Since `c(a) < a` for `a > 1`, this gives:

```text
2^y c(a) < x_a
P(c(a), 2^y c(a)) subset P(c(a), x_a)
```

so the replacement has the correct lower-bound direction.

## Ledger consequence

For each parent root, the phase loss is:

```text
phase_loss(a,y) = pi*(c(a), x_a) - pi*(c(a), 2^y c(a))
```

This loss must be charged to the same denominator:

```text
W_K(y) = sum_u w_u V_u(y) + tau Q_K(y)
```

## First-pilot constants

```text
K = 5
weights = option A
w_u = 1 for every visible type
tau = 1
y = {8,9,10}
calibration parent roots = 1 <= a < 10369, a == 2 mod 3
holdout parent roots = 10369 <= a < 20737, a == 2 mod 3
finite base exception = a = 2, because c(a)=1 enters the 1 <-> 2 cycle
```

## Acceptance

This pilot cannot certify `rho`. It may only return:

```text
PASS_HOOKS_ONLY
STOP_PHASE_A_TAIL_TOO_LARGE
STOP_BAD_PARTITION
STOP_BAD_DENOMINATOR
```

The useful diagnostic is the same-denominator visible capture:

```text
capture_A = (retarded_full + advanced_phase_A) / target
tail_A    = 1 - capture_A
```

computed both member-wise and in aggregate.

## Non-claims

```text
NO_LEAN
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
