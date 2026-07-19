# Liu 2025 Counting Collatz Numbers source audit v1

Date: `2026-07-19`.

## Scope

This note audits the version history and proof surface of:

```text
Chunlei Liu, Counting Collatz Numbers, arXiv:2512.13760.
```

Primary sources:

- v1 PDF: <https://arxiv.org/pdf/2512.13760v1>
- v2 PDF: <https://arxiv.org/pdf/2512.13760v2>
- current abstract page: <https://arxiv.org/abs/2512.13760>

The source audit is reproduced by:

```text
python3 scripts/liu2025_counting_collatz_numbers_audit_v1.py
```

Outputs:

```text
outputs/LIU2025_COUNTING_COLLATZ_NUMBERS_SOURCE_AUDIT_v1/
```

This is a proof audit, not a proof that the current theorem is false.

## Version correction

The `x^0.946` claim belongs only to arXiv v1, submitted on `2025-12-15`.
The author replaced it in v2 on `2025-12-17` with `x^0.3227` and changed the
underlying congruence equation and parameterization.

| Version | Headline claim | Current status |
|---|---:|---|
| v1 | `pi(x) >= x^0.946` | Superseded by v2 |
| v2 | `pi(x) >= x^0.3227` | Current arXiv version; proof not validated by this audit |

The numerical formulas themselves evaluate on the safe side of the displayed
rounded exponents:

```text
v1 entropy formula = 0.949955527188 > 0.946
v2 entropy formula = 0.322756403360 > 0.3227
```

The issue is not decimal rounding. It is the chain that is supposed to create
and count the Collatz numbers.

## Source custody

The official TeX sources were downloaded from the arXiv e-print endpoints.
The full source is not copied into this repository; its hashes and relevant
line ranges are recorded here.

```text
v1 collaz.tex SHA256:
83ee3067889f9a78aaf8a7c7e3782ab53f417d73ba562c1908358f73dcba1004

v2 collaz.tex SHA256:
9d45249899c2f50b5b3b70ba4f822fba0ec449c01d9d7583ec7beee6a6f53faa
```

## Findings

### F1 - v1 all-tuples parameterization fails

The v1 lemma at TeX lines `100-130` claims exactly one level-`l` solution for
every tuple `u`. At `l=2`, `u=(3,1)`, exhaustive enumeration of the candidates
allowed by

```text
floor((v_j + 1) / 2) = u_j
```

finds no solution to the level-2 congruence. The v1 claim is therefore not
available as a historical `0.946` theorem after its supersession.

### F2 - v2 ternary-digit choice is impossible as written

At v2 TeX lines `182-190`, `r_l` is chosen so that

```text
2^r_l = a (mod 3).
```

For either nonzero residue `a mod 3`, this implies

```text
4^w * 2^r_l * a = 1 (mod 3)
```

for every ternary digit `w`. The next instruction asks for a `w_l` making
that residue different from `1 mod 3`; no such digit exists. A modulus `9`
may have been intended, but the published proof does not say that.

### F3 - v2 uniqueness has a small counterexample

The v2 lemma at lines `166-203` assumes every `u_j` is coprime to `3` and
claims a unique solution with

```text
floor((v_j + 1) / 6) = u_j - 1.
```

For `l=2`, `u=(2,2)`, four pairs satisfy both the floor conditions and the
exact level-2 congruence (divisible by `3^2` but not `3^3`):

```text
(8,6), (8,8), (10,5), (10,7).
```

Because `2` is both prime and coprime to `3`, this counterexample is
independent of how the phrase "numbers prime to 3" is parsed.

### F4 - the partition domain does not satisfy the lemma domain

The v2 parameterization at lines `166-169` requires each `u_j` to be coprime
to `3`. The counter `omega` at lines `217-220` counts all positive tuples,
and the Partition Bound applies the parameterization to those unrestricted
tuples at lines `225-229`. This domain mismatch affects exponentially many
tuples because `l` grows with `log x`; it is not a finite-boundary omission.

### F5 - the displayed size bound is false in the base case

At lines `230-231`, v2 uses

```text
B(v) <= 192^(-l) * 4^(3 * sum u_j).
```

For the paper's own level-1 construction with `u_1=2`, one has `v_1=8` and

```text
B(8) = (2^8 - 1) / 3 = 85,
192^(-1) * 4^6 = 64/3.
```

Thus `85 <= 64/3` is false. This independently blocks the claimed window in
the Partition Bound.

### F6 - the final omega/binomial comparison changes scale

The theorem proof defines `n` using the larger Partition-Bound window, then
replaces that window by `(1/3) log_4 x` before comparing `omega` with
`binomial(n,l)` at lines `238-247`. The binomial count belongs to the larger
window, not the smaller one displayed in the preceding line. The written
inequality chain does not justify that step.

### F7 - the Stirling remainder is not O(1)

The lemma at lines `207-212` states

```text
log_2 binomial(n,l) = n H_2(l/n) + O(1)
```

when `l` is proportional to `n`. Already at `l=n/2`, the remainder diverges
like `-(1/2) log_2 n`, so the correct generic error is `O(log n)`. This also
means that the displayed multiplicative form `(1+o(1)) x^gamma` is not what
the stated Stirling argument yields. A weaker `x^(gamma-o(1))` form could be
compatible with Stirling, but the earlier blockers remain.

### F8 - independent internal inconsistencies

The v2 TeX also contains several index or modulus conflicts:

- `v_l=6u_1-...` where the induction requires dependence on `u_l`;
- `2^v_1 a` where the surrounding construction uses `v_l`;
- a prefix called a level-`l` solution where level `l-1` is required;
- the final noncongruence written modulo `3^l` instead of `3^(l+1)`.

Correcting these likely typographical errors does not repair F3-F6.

## Verdict

```text
V1_0946_WITHDRAWN
V2_CURRENT_CLAIM_03227
V2_PROOF_AS_WRITTEN_NOT_VALIDATED
NO_CLAIM_THAT_V2_THEOREM_IS_FALSE
NO_UPWARD_STATE_OF_ART_RECALIBRATION_FROM_2512_13760
KL2003_084_HISTORICAL_RECORD_NOT_DISPLACED_BY_CURRENT_V2
NO_GLOBAL_COLLATZ_CLAIM
```

The strategic consequence is precise:

1. Do not cite `0.946` as a current result; it was withdrawn in v2.
2. Do not cite `0.3227` as established on the basis of the current proof.
3. Keep `0.841756` as the endpoint of the KL2003 computed table and as the
   historical counting benchmark relevant to this project.
4. Do not reprioritize the KL2003 general-`k` program because of this preprint.
5. A future author contact should present the small counterexamples first and
   separate likely TeX errors from the independent counting blockers.

## Reproduction

```text
python3 -m py_compile scripts/liu2025_counting_collatz_numbers_audit_v1.py
python3 scripts/liu2025_counting_collatz_numbers_audit_v1.py
git diff --check
```

Expected verdict:

```text
V1_0946_WITHDRAWN_V2_03227_PROOF_NOT_VALIDATED
blockers=6
counterexample_failures=4
```
