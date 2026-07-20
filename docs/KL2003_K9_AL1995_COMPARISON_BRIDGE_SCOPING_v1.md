# KL2003 k=9 to AL1995 comparison bridge scoping v1

## Status

The Lean theorem `exists_k9_piStar_arbitrary_x_lower_bound` proves a k=9
lower bound with exact exponent

```text
gammaK9 = logb 2 (70461/40000) > 81/100.
```

Applegate--Lagarias 1995 published the exponent benchmark `0.81`.  The current
repository therefore has an exact exponent comparison.  It does not yet have
a Lean theorem translating the repository's `ClassRootsK` and bounded-path
`piStar` statement into the literal counting statement of that paper.

Primary references:

```text
https://doi.org/10.1090/S0025-5718-1995-1270613-2
https://arxiv.org/abs/math/0205002
```

## Bridge A: positive root-8 statement

The smallest useful formal bridge stays inside the repository's positive-Nat
semantics:

1. Construct mode `8 : TrackedMode 9` and `8 : ClassRootsK 9 mode`.
2. Instantiate `exists_k9_piStar_arbitrary_x_lower_bound` at root `8`.
3. Prove that every bounded path reaching `8` extends through
   `8 -> 4 -> 2 -> 1` without leaving the same window when `8 <= x`.
4. Deduce `piStar 8 x <= piStar 1 x`.
5. Absorb the fixed factor `8 ^ (-gammaK9)` into a new positive constant.

Target shape:

```lean
exists Delta : Real, 0 < Delta /\
  forall x : Nat, 8 <= x ->
    Delta * (x : Real) ^ gammaK9 <= (piStar 1 x : Real)
```

Planning estimate: one Lean module plus one axiom-audit file, approximately
100--250 proof lines and 0.5--1.5 focused engineering days.  This is an
estimate, not a completion claim.

## Bridge B: literal AL1995 statement fidelity

A literal comparison is larger.  It must first fix the intended published
domain (`Nat` versus integers with `|n| <= x`), define or connect the standard
unbounded-orbit counting function, and prove the inclusion from the bounded
path counter.  To reproduce the coefficient-free `x^(81/100)` presentation,
it must also convert

```text
Delta * x^gammaK9
```

with `gammaK9 > 81/100` into an eventual lower bound by choosing an explicit
threshold depending on `Delta`.

Planning estimate: two to four Lean modules, approximately 300--800 proof
lines and 2--5 focused engineering days.  Source-statement inspection may
change this estimate.

## Priority audit

No world-first claim is authorized by the theorem or by a general web search.
If a priority adjective is ever desired, run and publish a separate protocol:

1. search formalization catalogs and the major Lean, Coq, Isabelle and HOL
   repositories for Collatz counting bounds and KL2003;
2. search papers and archived project pages for machine-checked versions;
3. record queries, dates, repositories and negative results;
4. report only `no prior formalization found under this protocol`, never an
   absolute first unless independent evidence supports it.

Planning estimate: 0.5--1 day for a reproducible initial audit, followed by
external review if a priority claim is contemplated.

## Trust wording

The four k=9 audit files report the axiom profile

```text
[propext, Classical.choice, Quot.sound]
```

This list is not the whole trusted computing base; Lean's kernel is trusted.
The measured `343.02` seconds are total Lean build/checking wall time, not
kernel-only time.

## Classification

```text
K9_AL1995_EXPONENT_BENCHMARK_COMPARISON_PROVED
K9_AL1995_POSITIVE_ROOT8_BRIDGE_SCOPED
K9_AL1995_LITERAL_STATEMENT_BRIDGE_SCOPED
K9_AL1995_LITERAL_STATEMENT_BRIDGE_NOT_YET_PROVED
K9_WORLD_FIRST_PRIORITY_AUDIT_SCOPED
K9_WORLD_FIRST_PRIORITY_NOT_CLAIMED
NO_K11_THEOREM_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
