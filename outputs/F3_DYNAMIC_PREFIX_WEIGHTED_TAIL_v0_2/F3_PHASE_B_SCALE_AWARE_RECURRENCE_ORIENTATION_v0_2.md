# F3 PHASE_B scale-aware recurrence orientation v0.2

Date: 2026-07-21.

Status:

```text
RECURRENCE_ORIENTATION_PAGE
RETURN_OPERATOR_CANDIDATE
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Retraction of the old margin

The previously quoted `14.5%` slack came from the convention:

```text
rho^(-2) + rho^(alpha-2)
```

That convention omits the multiplicity normalization between parent roots and
advanced children. It agrees at the critical point `rho = 2`, but not away
from it. The margin is therefore convention-dependent and is withdrawn.

## 2. Normalization obligation

New obligation:

```text
O6 multiplicity normalization fixed member-wise before fitting weights
```

For the PHASE_B renewal shadow, the scalar characteristic is:

```text
F(rho) = rho^(-2) + (1/2) * rho^(alpha-1)
```

where:

```text
alpha = log_2 3
```

The factor `1/2` records the parent/child lattice normalization: advanced
parents are `a == 2 mod 3`, while advanced children are odd. This normalization
must be represented row-wise in any matrix, not patched in as an aggregate.

At the critical point:

```text
F(2) = 2^(-2) + (1/2) * 2^(alpha-1)
     = 1/4 + (1/2) * (3/2)
     = 1/4 + 3/4
     = 1
```

At the official Lean threshold:

```text
lambda_11 = 71689/40000
F(lambda_11) is only about 1.5% above 1
```

Thus the true slack budget is narrow.

## 3. Why one-step orientation fails

The parent-to-child matrix fails because it is triangular by 3-adic depth:

```text
retarded: depth d -> d
advanced: depth d -> d-1
```

The child-to-parent mirror also fails as a simple one-step causal story,
because the two branches are causal in opposite notions of time:

```text
size/window time:
  retarded has lag +2
  advanced has lag -(alpha-1)

root-size time:
  advanced c < a
  retarded 4a > a
```

Therefore the growth object is not a simple Perron transition. It is a renewal
or return operator.

## 4. Candidate return operator

Fix:

```text
d0 = 5
rho_star = 9/5
visible states = all residues modulo 3^d0 with nu2 bucket b in {0,1,2}
```

The candidate return operator works at the fixed reference depth `d0`.

Rules:

```text
retarded return:
  state at d0 -> state at d0
  weight = rho_star^(-2) = 25/81

advanced excursion:
  state at d0 with r == 2 mod 3
  -> child prefix at d0-1
  -> rebase child prefix back to all d0 lifts
  total branch weight = (1/2) * rho_star^(alpha-1)
```

The rebasing lift is not a theorem yet. It is the first candidate mechanism
for turning the two-sided renewal into a finite operator. Every rebased entry
must later be backed by a member-wise inequality.

## 5. Acceptance before LP

Before solving for weights `w`, the return inventory must report:

```text
state count
edge count
total outgoing weights by source state
tail mass from depth-zero or unrebased excursions
Perron diagnostic only
```

Allowed verdicts:

```text
RETURN_INVENTORY_BUILT
STOP_RETURN_NORMALIZATION_BAD
STOP_RETURN_OPERATOR_TOO_WEAK
STOP_REBASING_NOT_MEMBERWISE
```

Forbidden:

```text
RHO_CERTIFIED
LEAN_READY
DENSITY_THEOREM
```

## 6. Next computational object

```text
F3_PHASE_B_RETURN_OPERATOR_INVENTORY_v1
```

It may count the finite return matrix and estimate its Perron value as a
diagnostic. It may not freeze `w` or claim a certificate until the entry-wise
member hooks are specified.

