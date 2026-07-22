# F3 uniform Q counting bounds v1

Date: 2026-07-22.

Status:

```text
PASS_UNIFORM_COUNTING_LEMMAS
FINITE_ARITHMETIC_COUNTING_AUDIT
NO_FORMAL_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_LEAN_OPERATOR
```

## 1. Sterile duplication ray

For `c ≡ 0 (mod 3)`, the exact number of pure duplications in the window is

```text
floor(log2(3*2^(y-1))) + 1 = y + 1.
```

For `y >= 8`, the normalized count decreases because

```text
((y+2)/(y+1))/rho_star < 1
```

(equivalently `5(y+2)<9(y+1)`).  Therefore the uniform maximum is attained at
`y=8`:

```text
count = 9
count / (9/5)^8 = 0.08166998364405036.
```

The audit checked the exact formula through `y=128`; the inequality above is
the all-`y` proof step.

## 2. Fine-block boundary fragments

The fine period is `4*3^6 = 2916`.  For any fixed core state, the three fine
lift classes are residue classes modulo this period.  Their counts in an
interval differ by at most one.  If `q=min(count_0,count_1,count_2)`, removing
`3q` complete roots leaves

```text
boundary_roots = count_0 + count_1 + count_2 - 3q <= 2.
```

This is a deterministic block-counting lemma, not an equidistribution
assumption.  The calibration interval `[3,10369)` has maximum boundary count 1
per state; the consumed holdout `[41473,82945)` has maximum 2 per state.  Both
pass the universal bound.

## 3. Reproducibility

Script:

```text
scripts/f3_uniform_q_bounds_v1.py
```

Output:

```text
results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1/uniform_q_bounds_v1.json
```

The output records the exact sterile formula, the monotonicity check, the
boundary formula, and the two interval audits.  It is a counting input to the
uniform form of Lemma B; it is not itself a density theorem.

