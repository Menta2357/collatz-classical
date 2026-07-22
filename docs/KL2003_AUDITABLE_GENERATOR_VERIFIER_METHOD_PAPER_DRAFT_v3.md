# From Source Equations to Kernel-Checked Certificates

## An auditable generator-verifier pipeline for Collatz counting bounds

Method-paper doublet draft v3.

Date prepared: `2026-07-22`.

Status: `DRAFT_PENDING_HOSTILE_REVIEW`.

Submission status: `NOT_SUBMITTED`.

This paper is deliberately about the house: source fidelity, certificate
transport, kernel checking, and calibrated claims. It does not use the paper
to make a claim about the separate F3 candidate.

## Abstract

Computer-assisted arguments often have a small mathematical consumer and a
large, heuristic search program. We describe a pipeline developed while
formalizing the difference-inequality method of Krasikov and Lagarias for the
3x+1 problem. An untrusted generator derives finite data from source rules;
canonical JSON, generated Lean twins, a kernel verifier, and independent
member-wise hooks then expose the trust boundary. The development is anchored
by a manual `k=2` regression and a source-faithful `k=3` pilot. The resulting
ladder is `0.433 -> 0.611 -> 0.8168 -> 0.8418`: a proved `k=2` surrogate,
an exact rational `k=3` pilot, the custodied `k=9` arbitrary-x theorem lane,
and a kernel-proved `k=11` arbitrary-x theorem with a separate
checker-maintainability asterisk. A source
normalization error was found by comparing a formula, a figure, a deletion
rule, and a concrete hook. The paper presents the incident, the schema and
dispatch engineering, and the timeboxed high-k gate as methodological
results rather than as numerical claims about the unsolved problem.

## 1. Claim discipline and evidence map

Every claim in this draft has one of three statuses:

```text
PROVED       a Lean theorem or kernel audit is named;
MEASURED     a versioned output/manifest is named;
LIMITATION   a negative gate or missing bridge is named.
```

The primary custody pointers are:

```text
docs/KL2003_AUDITABLE_GENERATOR_VERIFIER_METHOD_PAPER_DRAFT_v1.md
docs/KL2003_AUDIT_READY_FIDELITY_PACKAGE_v1.md
docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md
docs/KL2003_F2_K9_KERNEL_INTEGRATION_BUDGET_AND_COST_LEDGER_v1.md
docs/KL2003_K11_PISTAR_THEOREM_FINAL_v1.md
docs/KL2003_K11_REAL_LEAN_CHECKER_RESULT_v1.md
CollatzClassical/KL2003/KL2003K11PiStarTheorem.lean
CollatzClassical/KL2003/KL2003K11ClassRootsAxiomAudit.lean
CollatzClassical/KL2003/KL2003K11LNTCertificateAxiomAudit.lean
CollatzClassical/KL2003/KL2003K11PiStarTheoremAxiomAudit.lean
outputs/KL2003_F2_K3_GENERATOR_REAL_v1/generation_summary.json
outputs/KL2003_F2_K9_LNT_MEASUREMENT_v1/generation_summary.json
outputs/KL2003_F2_K9_MATCH_DISPATCH_v1/generation_summary.json
outputs/KL2003_F2_K9_KERNEL_CHECKER_BENCHMARK_v1/kernel_checker_summary.json
outputs/KL2003_F2_K11_LNT_MEASUREMENT_v1/generation_summary.json
outputs/KL2003_K11_REAL_LEAN_CHECKER_v1/build_summary.json
```

This v3 is based on `origin/master` at `42e866b`, where the k=11 theorem and
its audits are present. The earlier v2 was drafted on an F3 branch whose
documentation predated that merge; v2 is retained as history, not as the
current program description.

The repository commit containing this draft is the final custody pointer for
the text itself. A claim without a row in the evidence table below is not a
submission claim.

## 2. The four-layer architecture

### 2.1 Untrusted source-derived generator

The generator reads the source-level rules, searches for finite data, and may
use ordinary Python, exact `Fraction` arithmetic, graph algorithms, or an SMT
solver. Successful execution is not evidence. The generator is explicitly
marked `generator_is_trusted = false` in the k=9 dispatch manifest.

### 2.2 Canonical twin artifacts

Each certificate has a canonical JSON representation and generated Lean data.
The manifest fixes reduced rational strings, provenance, hashes, and the
translator. Floating-point values may guide search, but they do not enter the
certificate evidence.

### 2.3 Kernel consumer

Lean rechecks the arithmetic, indexing, adjacency, deletion ancestry, row
slacks, and theorem-specific semantic bridge. Generated tables are candidate
accelerators until the checker validates them. The verifier, not the
generator, belongs to the mathematical chain.

### 2.4 Independent semantic hooks

Member-wise scripts compare generated branches with concrete predecessor sets.
They catch wrong residue maps, window directions, overlap assumptions, and
source normalizations before data is consumed by Lean. A hook pass is evidence
of a tested contract, not a replacement for a theorem.

## 3. The regression ladder

The numerical labels are waypoints with distinct evidentiary status, not a
single theorem statement.

| Waypoint | What is actually in custody | Pointer and status |
|---:|---|---|
| `0.433` | `gammaK2 = log_2(27/20) = 0.432959...`; the Lean theorem proves `gammaK2 > 3/7` and the `k=2` surrogate lower-bound chain | `CollatzClassical/KL2003/KL2003M1Surrogate.lean`; PROVED IN ITS STATED DOMAIN |
| `0.611` | `k=3` source benchmark `0.6112620`; generator witness `152759/100000` gives `0.611257380848...` on the safe side | `outputs/KL2003_F2_K3_GENERATOR_REAL_v1/generation_summary.json`; exact rational and kernel recheck documented in `docs/KL2003_K3_LNT_CERTIFICATE_AND_PISTAR_LEAN_v1.md` |
| `0.8168` | source `gamma_9 = 0.8168300`; diagnostic `0.816824950064...`; the repo's semantic k=9 arbitrary-x theorem is separately named and audited | `outputs/KL2003_F2_K9_LNT_MEASUREMENT_v1/generation_summary.json`; `CollatzClassical/KL2003/KL2003K9PiStarTheorem.lean`; PROVED ONLY FOR THE STATED REPO THEOREM, NOT SOURCE-OPTIMUM EQUALITY |
| `0.8418` | source `gamma_11 = 0.8417560`; Lean proves `exists_k11_piStar_arbitrary_x_lower_bound` and `gammaK11 > 21/25`; checker maintainability remains over budget | `CollatzClassical/KL2003/KL2003K11PiStarTheorem.lean`, its axiom audit, and `docs/KL2003_K11_PISTAR_THEOREM_FINAL_v1.md`; THEOREM PROVED WITH RESOURCE ASTERISK |

The ladder is therefore a map of increasing formal and engineering load, not
a claim that every printed source exponent has been formalized.

## 4. Manual `k=2` baseline and regression oracle

The general generator was not trusted until it reproduced a manually proved
baseline. The regression checks row25, row22, row28, Figure A1, and the full
schema twins. The row22 case is important because it detects the parity lift
`c -> 2c`; row28 tests nested min/sum expressions, deletion, and the post-
deletion `c/c'` split. The manual artifacts are an oracle, never an input
source: rules first, generated rows second, comparison third.

The source-faithful regression package and its trace are named in
`docs/KL2003_F2_K2_FULL_GENERATOR_REGRESSION_v1.md` and
`outputs/KL2003_F2_K2_FULL_GENERATOR_REGRESSION_v1/`.

## 5. The meta-erratum case study

An early normalization changed the source arm

```text
phi_2^5(y + 2 alpha - 5)
```

to `phi_2^2`. The abstract induction over the altered rows remained
consistent, but the concrete seam failed on the repeated class-8 case. Four
independent checks reversed the normalization:

```text
the source TeX formula
Figure A1
the deletion rule
a member-wise concrete hook
```

The source-faithful `phi_2^5` branch is realized by the `4 * node` chain; the
substituted branch is not uniform. The row contract was migrated to V3 and
rechecked. The incident is documented in
`docs/KL2003_META_ERRATA_M1_PHI5_REINSTATEMENT_v1.md`.

Method rule:

```text
A source normalization is a mathematical claim and carries proof debt.
Test it when introduced, not when a downstream seam fails.
```

## 6. Schema evolution and match dispatch

Flat rows were sufficient for the first baseline. Nested row28 data forced a
schema extension with explicit min/sum nodes, M1V3/M2V3 references, deletion
status, sibling groups, ancestry constraints, and source references. Negative
fixtures reject malformed nested data, dangling references, cycles,
deleted-but-counted nodes, and parent-descendant sums.

For k=9 the generated dispatch package covers 6,561 principal rows and 2,187
auxiliary groups in nine Lean shards. Its manifest records:

```text
generator_is_trusted = false
all_shards = true
shard_count = 9
verdict = K9_MATCH_DISPATCH_EMITTED
```

Pointer:
`outputs/KL2003_F2_K9_MATCH_DISPATCH_v1/generation_summary.json`.

The versioned k=9 engineering comparison is the one the paper can defend:
the discarded array-expansion design hit a deterministic timeout at
`732.35 s` for one shard, while the accepted match-dispatch design completed
the nine-shard build plus dependencies in `343.02 s`. Both numbers and the
design decision are recorded in `docs/KL2003_K9_PISTAR_THEOREM_LEAN_v1.md`.
No unpinned dispatch pair is included in the evidentiary text.

## 7. `k=3` pilot and kernel boundary

The k=3 generator derives nine rows from the rules, finds the exact rational
witness `152759/100000`, and records positive row slacks. The generated Lean
data and verifier consume that witness; the theorem is named as a pilot
certificate, not as an unqualified high-k theorem. The source-safe direction
is deliberate: the generated exponent is below the printed decimal.

The semantic consumer and its axiom audit are listed in the k=3 evidence
package. The generator remains outside the trusted base.

## 8. k=9 measured route and theorem boundary

The k=9 source-derived package has 6,561 tracked classes and 2,187 auxiliary
groups. Its measurement manifest reports zero row mismatches and positive
exact rational slacks. The literal checker benchmark reports:

```text
all certificate rows kernel rechecked = true
checker shards passed = 9
checker shards failed = 0
total wall = 437.152929 s
maximum shard = 153.850506 s
sum shards = 1244.451968 s
```

Pointer:
`outputs/KL2003_F2_K9_KERNEL_CHECKER_BENCHMARK_v1/kernel_checker_summary.json`.

The formal claim remains the exact theorem named in
`CollatzClassical/KL2003/KL2003K9PiStarTheorem.lean`. The benchmark is not a
claim that the source optimum, a current-record priority, or a global Collatz
statement has been proved.

## 9. The k=11 theorem and its asterisk

The current master branch contains the theorem:

```lean
exists_k11_piStar_arbitrary_x_lower_bound
```

Its exponent is defined by `gammaK11 := logb 2 (71689/40000)`, and Lean proves
the named comparison:

```lean
gammaK11_gt_twenty_one_twenty_fifths : (21 / 25 : Real) < gammaK11
```

The theorem has three dedicated axiom-audit artifacts, all reporting the
expected `[propext, Classical.choice, Quot.sound]` profile. The source-derived
k=11 package has 59,049 tracked classes and 19,683 auxiliary groups, with
zero mismatches and positive exact rational slacks in its generation summary.
Pointers:

```text
CollatzClassical/KL2003/KL2003K11PiStarTheorem.lean
CollatzClassical/KL2003/KL2003K11ClassRootsAxiomAudit.lean
CollatzClassical/KL2003/KL2003K11LNTCertificateAxiomAudit.lean
CollatzClassical/KL2003/KL2003K11PiStarTheoremAxiomAudit.lean
docs/KL2003_K11_PISTAR_THEOREM_FINAL_v1.md
outputs/KL2003_F2_K11_LNT_MEASUREMENT_v1/generation_summary.json
```

The asterisk is engineering, not mathematics. The real checker recorded a
controlled recovery total of `5286.696696 s`; the predeclared maintainability
budget was PASS at `<=1320 s` and architecture failure above `1800 s`.
The checker is kernel-correct, but its current resource curve is not yet a
maintainable high-k pipeline under that budget. The run was not a pristine
cold run, so the exact resource claim is reported as a controlled-recovery
measurement, not as a clean-cold benchmark. Evidence:

```text
docs/KL2003_K11_REAL_LEAN_CHECKER_RESULT_v1.md
outputs/KL2003_K11_REAL_LEAN_CHECKER_v1/build_summary.json
```

The method claim is therefore the joint statement: theorem proved, audits
pass, resource maintainability fails the predeclared target. The asterisk is
part of the result, not a footnote that erases it.

## 10. Reproducibility and trust boundary

The reproducibility commands and generated artifacts are listed in v1 of this
paper and remain valid for the k=2/k=3/k=9 lanes. The k=11 theorem, theorem
audits, generated certificate, and controlled checker result are pinned in
§9. The essential invariant is:

```text
source rules -> untrusted generator -> canonical JSON/Lean twin
             -> kernel verifier -> independent semantic hooks
```

No generated certificate is accepted merely because its generator ran. No
floating-point witness is accepted as a rational proof. A theorem name is not
promoted until its data, dispatcher, semantic bridge, and axiom audit satisfy
the corresponding gate.

## 11. Future work

F3 scale-aware return-excursion candidate remains future work under its own
paper and Lean gates.

## 12. No-claims ledger

```text
NO_FULL_KL2003_HIGH_K_THEOREM_CLAIM
K11_PISTAR_ARBITRARY_X_THEOREM_PROVED
GAMMA_K11_GT_21_25_PROVED
K11_RESOURCE_BUDGET_ARCHITECTURE_FAIL
NO_SOURCE_K11_OPTIMUM_EQUALITY_CLAIM
NO_SOURCE_OPTIMUM_EQUALITY_CLAIM
NO_CURRENT_RECORD_OR_WORLD_FIRST_PRIORITY_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
GENERATOR_NOT_TRUSTED
732_35_TO_343_02_K9_ENGINEERING_COMPARISON_PINNED
F3_NUMBERS_EXCLUDED_FROM_THIS_METHOD_PAPER
```

## Draft classification

```text
DOUBLET_PIECE_2_READY
METHOD_PIPELINE_DOCUMENTED
LADDER_POINTERS_ATTACHED
META_ERRATUM_CASE_STUDY_ATTACHED
K11_TIMEBOX_AND_ASTERISK_ATTACHED
F3_SINGLE_FUTURE_WORK_LINE_ONLY
DRAFT_PENDING_HOSTILE_REVIEW
NOT_SUBMITTED
```
