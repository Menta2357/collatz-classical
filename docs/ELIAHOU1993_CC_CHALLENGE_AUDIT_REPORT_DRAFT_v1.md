# Eliahou1993 CC Challenge audit report draft v1

Date prepared: `2026-07-19`.

Publication status: `DRAFT_NOT_PUBLISHED`.

SUPERSEDED_BY: `docs/ELIAHOU1993_CC_CHALLENGE_AUDIT_REPORT_DRAFT_v2.md`

Author-first decision time: `2026-07-21 01:21 CEST`.

## Audit target

Paper:

```text
Shalom Eliahou,
The 3x+1 problem: New Lower Bounds on Nontrivial Cycle Lengths,
Discrete Mathematics 118 (1993), 45-56.
```

Registered formalization:

```text
CC Challenge paper key: Eliahou1993
formalization id: 6
repository: https://github.com/tangentstorm/eliahou-collatz-bounds
audited commit: fdb0b2e1ac0d774f4e288ffa2106785efd351563
proof assistant: Lean 4
AI-assisted registration: Aristotle
```

## Human accountability

This report was prepared with AI assistance. The human submitter is
responsible for the source comparison, classifications, recommendation, and
all public claims. The report should not be registered until the author-first
protocol has been resolved at the absolute time recorded above.

## Executive verdict

The repository contains a substantial and mechanically successful
formalization of the lower-bound route used by Eliahou. Its central theorem is:

```lean
theorem eliahou_bound {L : Nat} (c : CollatzCycle L)
    (hmin : (2 : Nat) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 <= L
```

The current code does not formalize the full linear conclusion printed in
Theorem 1.1:

```text
Card Omega = 301994 a + 17087915 b + 85137581 c
```

with the associated conditions on `a`, `b`, and `c`. The honest scope is:

```text
partial formalization of the 17087915 lower-bound consequence
```

The mechanical audit passes. Statement fidelity needs explicit scope wording,
and a paper-facing theorem should discharge `hk` and make the exact-period /
orbit-cardinality interpretation explicit. The final recommendation is
therefore conditional:

```text
ACCEPT_AS_PARTIAL if the registered scope is changed to lower-bound
consequence and the paper-facing glue is supplied or explicitly documented.

CHANGES_REQUESTED if the entry continues to present itself as the full
Theorem 1.1 formalization.
```

## Mechanical audit

The audit used the exact commit shown above and left the external repository
clean.

```text
lake exe cache get    PASS
lake build            PASS (8030 jobs)
```

Text scans found no project occurrences of:

```text
sorry
admit
axiom
unsafe
```

The main structural results in `ProductFormula.lean` and `Sandwich.lean`
depend only on the usual Mathlib/classical foundations:

```text
[propext, Classical.choice, Quot.sound]
```

The central numerical theorem additionally inherits:

```text
[Lean.ofReduceBool, Lean.trustCompiler]
```

through closed facts proved with `native_decide` in
`ContinuedFractions.lean`. This is a disclosed trust boundary, not a project
`axiom` or a proof hole.

## Statement-fidelity table

| Source item | Lean coverage | Classification |
|---|---|---|
| Compressed Collatz map on positive cycle values | `collatzComp` plus positivity in `CollatzCycle` | MATCH |
| Product formula over odd entries | Product over odd indices of the indexed cycle | PARTIAL / multiplicity-aware |
| Sandwich inequalities used by the lower-bound route | Formalized in `Sandwich.lean` | SUBSTANTIAL MATCH |
| Continued-fraction numerical lower bound | `eliahou_bound` concludes `17087915 <= L` | MATCH FOR INDEXED CYCLES |
| Full Theorem 1.1 linear form | No corresponding theorem found | NOT FORMALIZED |
| `Card Omega` as exact orbit cardinality | `L` is an index length without injectivity/minimality | PAPER-FACING GLUE MISSING |
| Positivity of the odd count | Required as `hk` | EXTRA HYPOTHESIS, DERIVABLE IN PRINCIPLE |
| Large numerical certificates | Closed via `native_decide` | TRUST BOUNDARY DISCLOSED |

## Finding 1: consequence-only scope

The code proves the numerical consequence `17087915 <= L`. It does not expose
the source's coefficients `301994`, `17087915`, and `85137581` in a theorem
with existential parameters and printed side conditions. README and challenge
metadata should therefore use the phrase "lower-bound consequence of
Eliahou1993" rather than "Theorem 1.1" or "main results" without a qualifier.

This is not a rejection of partial formalization. It is a scope-calibration
requirement.

## Finding 2: indexed length versus Card Omega

`CollatzCycle L` contains a function `Fin L -> Nat`, positivity, and the
one-step periodicity equation. It does not require:

```text
Function.Injective c.seq
Nodup
minimal period
first return at L
card(image c.seq) = L
```

Thus a cycle can be traversed repeatedly and represented with an inflated
index length. The trivial orbit can be represented by both `[1,2]` and
`[1,2,1,2]` while preserving the current structure fields.

This does not make `eliahou_bound` false. Exact paper cycles form the intended
subclass, and the theorem applies once an exact enumeration is supplied. The
formalization currently leaves that semantic conversion outside Lean.

Recommended minimal repair:

```lean
structure ExactCollatzCycle (L : Nat) extends CollatzCycle L where
  injective_seq : Function.Injective toCollatzCycle.seq
```

or a paper-facing theorem carrying `hexact : Function.Injective c.seq` and
rewriting `L` as `(Finset.univ.image c.seq).card`.

## Finding 3: the hk hypothesis

The central theorem assumes:

```lean
hk : 0 < c.numOdd
```

The paper-facing cycle statement does not need to expose this hypothesis. It
is mathematically derivable for any positive compressed cycle: if every entry
were even, applying the map to a minimum entry would produce a smaller
positive cycle entry.

Recommended lemma:

```lean
theorem CollatzCycle.numOdd_pos {L : Nat} (c : CollatzCycle L) :
    0 < c.numOdd
```

This is a small statement-fidelity improvement rather than a challenge to the
main argument.

## Finding 4: native computation boundary

Small closed arithmetic facts can be moved from `native_decide` to
proof-producing tactics. The audit confirmed that the Farey identity

```text
301994 * 10781274 - 17087915 * 190537 = 1
```

closes with `norm_num`.

Direct `norm_num` and `by decide` probes for the very large power inequality
did not yield a practical replacement under the tested settings. Removing the
remaining trust boundary likely requires an intermediate certificate rather
than monolithic evaluation. This is recommended hardening, not a prerequisite
for recognizing the mathematical scope of the existing theorem.

## Required changes for an unqualified acceptance

1. Change public scope wording to "lower-bound consequence" unless the full
   linear form is added.
2. Add or document the exact-period/orbit-cardinality bridge.
3. Discharge `hk` in a paper-facing theorem or document it as a derived lemma
   still missing from the repository.
4. State the `native_decide` trust boundary in the audit metadata.
5. Keep the full Theorem 1.1 linear form classified as not formalized.

## Reproduction record

Detailed evidence is stored in:

```text
docs/ELIAHOU1993_LOCAL_STATEMENT_FIDELITY_AUDIT_v1.md
docs/ELIAHOU1993_L_VS_CARDOMEGA_BRIDGE_AUDIT_v1.md
docs/ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_RUN_v1.md
docs/ELIAHOU1993_DECIDE_KERNEL_GMP_PROBE_AND_CONTACT_PROTOCOL_LEDGER_v1.md
docs/ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1.md
```

## Author-first resolution block

This block must be completed using external state observed at or after
`2026-07-21 01:21 CEST`.

```text
UPSTREAM_RESPONSE = [TO FILL]
FORUM_POST_URL = [TO FILL OR NONE]
AUDIT_REPORT_URL = [TO FILL OR NONE]
AUTHOR_FIRST_PROTOCOL_RESOLVED = false
```

If an upstream response is visible, incorporate it before publishing this
report. If no response is visible, publish the prepared Forum coordination
post noting the prior contact; do not silently convert this draft into an
official audit link without the separate human publication decision.

## Calibrated classifications

```text
ELIAHOU_BUILD_PASS
NO_SORRY_ADMIT_AXIOM_UNSAFE
LOWER_BOUND_CONSEQUENCE_FORMALIZED
FULL_THEOREM_1_1_LINEAR_FORM_NOT_FORMALIZED
EXACT_PERIOD_CARDINALITY_GLUE_MISSING
NUMODD_POS_LEMMA_MISSING_BUT_DERIVABLE
NATIVE_DECIDE_TRUST_BOUNDARY_DISCLOSED
ACCEPT_AS_PARTIAL_AFTER_SCOPE_AND_GLUE_CLARIFICATION
DRAFT_NOT_PUBLISHED
NO_AUDIT_LINK_YET
NO_GLOBAL_COLLATZ_CLAIM
```
