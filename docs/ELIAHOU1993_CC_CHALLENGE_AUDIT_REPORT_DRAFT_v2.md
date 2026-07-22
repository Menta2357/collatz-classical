# Eliahou1993 CC Challenge audit report draft v2

Date prepared: `2026-07-22`.

Publication status: `DRAFT_PENDING_HOSTILE_REVIEW`.

Governance status: `HUMAN_DECISION_HOLD`.

This document is the audit-report half of the doublet. It is a consolidated
draft, not a Forum post and not an audit registration. The author-first hold
is deliberately carried forward.

## Audit target and custody

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

Local evidence is pinned by the following documents:

```text
docs/ELIAHOU1993_LOCAL_STATEMENT_FIDELITY_AUDIT_v1.md
docs/ELIAHOU1993_L_VS_CARDOMEGA_BRIDGE_AUDIT_v1.md
docs/ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_RUN_v1.md
docs/ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1.md
```

## Executive verdict

`eliahou_bound` is a substantial, mechanically successful formalization of a
lower-bound consequence of the Eliahou route:

```lean
theorem eliahou_bound {L : Nat} (c : CollatzCycle L)
    (hmin : (2 : Nat) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 <= L
```

The repository does **not** currently formalize the full linear statement
printed as Theorem 1.1:

```text
Card Omega = 301994 a + 17087915 b + 85137581 c.
```

The honest classification is therefore:

```text
ACCEPT_AS_PARTIAL_AFTER_SCOPE_CLARIFICATION
```

It must be described as a partial formalization of the `17087915` lower-bound
consequence, not as a formalization of all of Theorem 1.1. A full-theorem
claim remains `CHANGES_REQUESTED` until the missing linear-form and exact-cycle
bridges are present.

## Mechanical audit receipt

At the audited upstream commit, the local audit recorded:

```text
lake exe cache get    PASS
lake build            PASS (8030 jobs)
text scan             no project occurrences of sorry/admit/axiom/unsafe
external repository   left clean
```

The numerical endpoint uses closed facts proved through `native_decide`. The
reported axiom profile includes `Lean.ofReduceBool` and `Lean.trustCompiler`
through the continued-fraction numerical files. This is a disclosed trust
boundary, not a project `axiom` or proof hole. Evidence:
`docs/ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_RUN_v1.md`.

## Scope and fidelity ledger

| Claim or source component | Custodied evidence | Verdict |
|---|---|---|
| Compressed map on positive cycle values | `ProductFormula.lean`, `CollatzCycle` | MATCH |
| Product/sandwich lower-bound route | `ProductFormula.lean`, `Sandwich.lean` | SUBSTANTIAL MATCH |
| Numerical consequence `17087915 <= L` | `eliahou_bound` at audited commit | MATCH FOR INDEXED CYCLES |
| Full coefficients `301994`, `17087915`, `85137581` | No corresponding theorem found | NOT FORMALIZED |
| `Card Omega` as exact orbit cardinality | `CollatzCycle L` has indexed length but no injectivity/minimality bridge | PAPER-FACING GAP |
| Positivity of odd count | Exposed as `hk : 0 < c.numOdd` | EXTRA HYPOTHESIS; DERIVABLE IN PRINCIPLE |
| Large numerical certificates | `native_decide` dependency recorded | TRUST BOUNDARY DISCLOSED |

Each row is either a source pointer or an explicit negative finding. No row is
an inference from the existence of a successful build.

## Findings that must remain visible

### Consequence-only scope

The public wording must say “lower-bound consequence of Eliahou1993”. The
coefficients and existential parameters of the printed linear formula are not
present in the Lean theorem. This is a scope calibration, not a rejection of
the partial formalization.

### Indexed length versus exact period

`CollatzCycle L` supplies a `Fin L` sequence and one-step periodicity, but does
not require injectivity, no repeated values, minimal period, first return, or
`card(image seq) = L`. Consequently the paper-facing conversion from `L` to
`Card Omega` remains outside the current kernel artifact. The recommended
repair is the exact-cycle structure or an explicit injectivity hypothesis,
as recorded in `docs/ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1.md`.

### The `hk` hypothesis

The central theorem asks for `0 < c.numOdd`. A paper-facing theorem should
derive this from positivity and the compressed-cycle equations, or name it as
an intentionally separate glue lemma. It must not disappear silently in a
summary.

### Numerical trust boundary

The remaining `native_decide` boundary is documented. Replacing it with a
proof-producing intermediate certificate is useful hardening, but it is not a
reason to relabel the current theorem as a proof hole.

## Author-first hold and publication gate

The author-first package and issue are already prepared. The latest custodied
hold record is:

```text
docs/ELIAHOU1993_AUTHOR_FIRST_WINDOW_STATUS_2026_07_20_v1.md
issue: https://github.com/tangentstorm/eliahou-collatz-bounds/issues/1
upstream response visible in the recorded check: none
Forum post: not published
audit link: not created
```

The current decision is intentionally still:

```text
HUMAN_DECISION_HOLD
```

The hold exits only when an upstream response becomes visible or the user
explicitly instructs the project to resume/publicize. Passage of the old
clock deadline is not an automatic authorization. Before any public action,
the issue must be refreshed and the response summarized. No credentials,
Forum form, or external repository were mutated by this draft.

## Hostile-review checklist

Before publication, an adversarial pass must confirm:

1. every public sentence uses the consequence-only scope;
2. the exact-period/cardinality gap is visible in the abstract and verdict;
3. `hk` is not silently discharged;
4. the `native_decide` trust boundary is named; and
5. the author-first hold block remains unchanged unless the user records a new
   decision.

## Draft classification

```text
DOUBLET_PIECE_1_READY
ELIAHOU_SCOPE_CONSEQUENCE_ONLY
MECHANICAL_AUDIT_PASS
STATEMENT_FIDELITY_PARTIAL
AUTHOR_FIRST_HUMAN_DECISION_HOLD
NO_FORUM_POST
NO_AUDIT_LINK
NO_GLOBAL_COLLATZ_CLAIM
DRAFT_PENDING_HOSTILE_REVIEW
```
