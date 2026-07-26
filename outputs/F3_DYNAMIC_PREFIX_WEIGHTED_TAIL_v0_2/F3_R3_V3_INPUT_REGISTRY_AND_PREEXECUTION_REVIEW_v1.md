# F3 R3 v3 input registry and pre-execution review v1

## 1. Verdict and authority

```text
REVIEW_VERDICT = PASS_SPEC_READY_FOR_SEPARATE_SEVEN_INPUT_AUTHORING_AUTHORIZATION
STATIC_REVIEW = PASS
SEVEN_INPUTS_PRESENT = 0/7
PREREQUISITE_SOURCES_PRESENT_AND_PINNED = 8/8
PREREQUISITE_LOCAL_IMPORT_CLOSURE_PUBLIC = 57/57
PREREQUISITE_OLEANS_PRESENT = 0/8
GO_FOR_B0 = NO
GO_FOR_R0 = NO
GO_FOR_P0 = NO
STOP_BEFORE_B0
```

This is a static specification and state review. It was created under
`F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_ROOT_AUTHORING_AUTHORIZATION_v1.md`,
SHA-256 `0a71770dba428a023beeb83f5d31121f0629fd3605e614927372ef613b3bc6e5`,
134 lines.
It authorizes no source write, script write, Lean, Lake, BFS, generator, or
pilot phase. Its positive verdict means only that a later, separate root act
may authorize creation of exactly the seven inputs specified below.

## 2. Custody base and adoption evidence

| Item | Identity |
|---|---|
| public branch | `codex/hilo2-f3-r3-reverse-first-hit-v1` |
| public custody base | `3e3245373d51171603ab9849626d79f662e4f0cc` |
| prerequisite-closure parent | `67cef401a6d8b93d87673e967542392d4c5e6129` |
| historical-dependency parent | `fbc79fb58c8450f1e3f1342000470f34da32521f` |
| seven-postimage commit | `f27f9e1c2d39b7e2f5165b319b83e2d5e71f85dd` |
| pre-adoption parent | `8765d7083906e7b3e3b03951da6331fcf1427e1b` |
| `F3_R3_V6_ATOMIC_ADOPTION_ATTEMPT_02_POST_ADOPTION_FREEZE_v1.json` | `37c18cf34b55a0c471b0b22d01243d20592d8dae38d95e5192aa8f5d5a204aa1`, 113 lines |
| `F3_R3_V6_ATOMIC_ADOPTION_ATTEMPT_02_POST_ADOPTION_FREEZE_AUDIT_PASS_v1.md` | `2d28027dc51bf656119be1d4e069668a9ccba7f33e23a39440180a26beccf015`, 62 lines |
| `F3_R3_V6_ATOMIC_ADOPTION_ATTEMPT_02_TERMINAL_REPORT_v1.md` | `7864596b627d2688c67af0ec9e7e114e1ffcf9ca0b179a2fdf2b7fdb8b0534fc`, 71 lines |

The three evidence files are under
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/custody/F3_R3_V6_ATOMIC_ADOPTION_ATTEMPT_02/`.
The adoption verdict is `PASS_ATOMIC_ADOPTION_TEXTUAL_7_OF_7` with postwrite
audits `2/2`, `P1_RESIDUAL=0`, and `P2_RESIDUAL=0`. It did not run Lean,
Lake, BFS, or a generator and did not open execution.

## 3. Contract and registry pins

All paths in this table are relative to
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/`.

| Artifact | SHA-256 | Lines |
|---|---:|---:|
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v1.md` | `6054894fcadd6898e01f1c4c4ace61b6ec86a257f418610bd369b40ec3164316` | 285 |
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v2.md` | `0378df70dc1dc0d67460299562a7c12034fa5598378aaed1e8a0887f6e6725cb` | 362 |
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v3.md` | `620f15497644be361f7a06ef4fa31362f325f94eda37b02de145450712fe30d6` | 353 |
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v4.md` | `9c6954e5985559b7a977064f21bf631199e265674ed5dc326175dfb5cfa8109c` | 268 |
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v5.md` | `7e2616e2a9d7be82e445cae30b8465cc39cff11bdee08ce45d117cb79c864369` | 196 |
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v6.md` | `b4f67e108938b66e93c15948bd8d2aa48fdcb6fd267f6ce75ad48c122ee08e6f` | 399 |
| `F3_R3_EXECUTION_REGISTRY_v7.md` | `97e63232e354030d46bd50a58b9b83d1d705e7f37a4a203020c26fac2639b0c7` | 313 |
| `F3_R3_EXECUTION_REGISTRY_v10.md` | `41b697b3d2cbe4561f5b9e0ab4fc84a895a23e9dd66e0bbcbad8ebf37d6510f6` | 376 |
| `templates/F3_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md` | `a5074cb91027233f0d4c15eff477d1765c79c9f9bcf785a4d24475ab9f63face` | 216 |
| `templates/INVALID_R3_REVERSE_BFS_PILOT_V3_RUN_REPORT.template.md` | `c8f3a8e389c7ef26f6ac966c92e6ce8b973a4ee56b925cba6381a0d47f2246c5` | 177 |
| `F3_R3_V6_POST_ADOPTION_EXTERNAL_CUSTODY_IMPORT_ROOT_ACT_v1.md` | `51360320e2929e9796e35ec4ca6dcfce0d52864b3c5c0733cc744272e987e9e1` | 85 |
| `F3_R3_HISTORICAL_NORMATIVE_CORPUS_PUBLIC_CUSTODY_ROOT_ACT_v1.md` | `85c48b61a71ac22eb06bf22de4d0503fe4be66ed9f9b2a526c3ffcc8225dc19a` | 96 |
| `F3_R3_PREREQUISITE_IMPORT_CLOSURE_PUBLIC_CUSTODY_ROOT_ACT_v1.md` | `093fff4b1b9162877f2efb805a2e82a7e45202d815bcc79ba65d6c9f27809116` | 104 |

The historical contract corpus and five previously local prerequisite sources
entered public custody only at commit `67cef401a6d8b93d87673e967542392d4c5e6129`.
This is later custody of local historical inputs, not evidence that they were
already tracked by the seven-postimage commit `f27f9e1c...`.

Custody Split v5 (`95240ae594507ba3bfa4083caad3e804f59f68a90aa12636c54a768166f9eaba`,
263 lines) and Custody Commands v5
(`0c59afd374ac69aa471008798a6b47d58009324e73bea1ec656a296f0858b36b`,
589 lines) are historical custody surfaces only. Their Batch B lane is not an
execution authority for the adopted v6/v10 state.

## 4. Normative resolution of the build-order conflict

The frozen documents contain one deadlocking schedule conflict:

- contract v6 Section 6 says build/audit `6/6` precedes creation or freezing
  of PilotV3 sources;
- contract v6 Section 8 then places prerequisite recompilation at step 3,
  input creation at step 4, and B0 at step 7;
- contract v3 Section 4.1 defines B0 as the one authorized cold prerequisite
  build;
- registry v7 Section 3 orders seven-input creation and static preaudit before
  B0 and defines B0 as the producer of the cold-prerequisite receipts.
- registry v7 Section 4 also contains historical chronological arrows and
  `exact next gate` phrases that put prerequisite builds before seven-input
  authoring; those phrases conflict with its own Section 3 phase semantics.
- contract v6 Section 9 requires compiled/audited final acceptance before P0,
  while contract v3 Sections 4.2 and 4.4 freeze that source before P0 but
  compile and audit it only after S0/P1 in V0 and A0.

For this successor lane, the controlling non-permutable order is:

```text
AUTHOR_EXACTLY_SEVEN_INPUTS
  -> STATIC_AND_ADVERSARIAL_AUDIT
  -> FREEZE_EXACTLY_SEVEN_INPUTS
  -> B0  [the sole cold prerequisite build and audit phase]
  -> R0  [typed rows and exact untrusted generator surface]
  -> P0  [receipt revalidation and pre-generation seal]
  -> G01 -> G02 -> G03 -> G04 -> G05 -> G06
  -> S0 -> P1 -> V0 -> A0 -> F0
```

This review narrowly supersedes the timing phrases in v6 Sections 6 and 8
that would require a second or pre-input prerequisite build. V6 Section 8.3
and the fresh-object portion of Section 8.6 are discharged exactly once by
B0, not by a separate command before B0.

It also narrowly supersedes only the chronological arrows and `exact next
gate` phrases of registry v7 Section 4 that place builds before authoring/B0.
Registry v7's still-applicable dependency conditions, fail-closed status,
receipt requirements, and every no-authority statement remain binding only as
amended by v6/v10. Its obsolete monolithic `24/24` audit count and
ordinary-decision `2/2` inventory are replaced together; Completeness `4/4`
is also explicitly superseded. The adopted sharded route requires:

```text
SHARDED_PROFILE_EXPLICIT_DECLARATION_COVERAGE = 86/86
SHARDED_PROFILE_ORDINARY_DECIDE_KERNEL_CLEAN_COVERAGE = 7/7
  = CORE 1/1 + SHARDS 6/6
SHARDED_PROFILE_NAMESPACE_SWEEP = FAIL_HARD_ALL_DECLARATIONS
REVERSE_BFS_AXIOM_AUDIT = 42/42
SEMANTIC_CHILD_BASE_HIT_AXIOM_AUDIT = 3/3
COMPLETENESS_AXIOM_AUDIT = 6/6
```

The namespace sweep requires every declared successor namespace to be
nonempty and audits every declaration in each such namespace. None of these
static source requirements becomes an executed PASS until its future phase
succeeds.

The pre-P0 bullets of contract v6 Section 9 are reconciled as follows:

- `PilotRowsV3.lean` and the payload-independent typed-row/generator surface
  are compiled in R0 after B0;
- the final payload-dependent acceptance source `PilotV3.lean` and its axiom
  audit source are prewritten, statically reviewed, and frozen before P0;
- P0 seals those exact source bytes but does not compile them;
- V0 alone compiles the final acceptance against the frozen payload and checks
  the six rows after S0/P1;
- A0 alone performs the exhaustive public declaration/cone audit;
- F0 alone seals the final artifacts and terminal verdict.

No semantic acceptance condition is weakened. Before P0, B0 must still
establish fresh prerequisite builds and audits, completeness `6/6`, the exact
fiber-cardinal and node-length equalities, and all other pinned prerequisite
checks; R0 must build its exact payload-independent surface. Before a terminal
PASS or scoped STOP, V0 and A0 must establish final kernel verification and
the required exhaustive public axiom inventories. Source presence never
counts as build PASS, and generation never counts as verification.

## 5. Exact seven-input registry

All seven paths were tested without following symlinks and are absent `7/7`.

| # | Required prewritten input | Live state |
|---:|---|---|
| 1 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean` | `ABSENT` |
| 2 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean` | `ABSENT` |
| 3 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean` | `ABSENT` |
| 4 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean` | `ABSENT` |
| 5 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh` | `ABSENT` |
| 6 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh` | `ABSENT` |
| 7 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_materialize.sh` | `ABSENT` |

`F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3.lean` is not an eighth
prewritten input. It is a later `S0` output and must remain absent before S0.

## 6. Exact eight-source prerequisite registry

All eight sources are regular non-symlink files and match registry v10. All
eight expected `.olean` objects are absent.

| # | Source | SHA-256 | Lines | Exact expected object and live state |
|---:|---|---:|---:|---|
| 1 | `F3ReturnExcursionBlock0MassDemandProfileSharded.lean` | `5e8b39840d5c520a55cc7a4cfa511f45fc5eb82d1d1eacd872dbd01c7643d34e` | 278 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0MassDemandProfileSharded.olean` — `ABSENT` |
| 2 | `F3ReturnExcursionBlock0MassDemandProfileShardedAxiomAudit.lean` | `05114f25a680cb85a43c78c09a4301ebe74f3ab94252869ec3ce5f9b2c33821a` | 348 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0MassDemandProfileShardedAxiomAudit.olean` — `ABSENT` |
| 3 | `F3ReturnExcursionBlock0ReverseBFSMassIntegration.lean` | `d1299e61e8074af271f2a4c4eef1baf2eedede950a8c1a6b9a753f504729eb7b` | 85 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSMassIntegration.olean` — `ABSENT` |
| 4 | `F3ReturnExcursionBlock0ReverseBFSAxiomAudit.lean` | `b8d8f5f7f8dc246de600885f56c4e65ef966ca944086a89827c5f0e1a4c02f7e` | 186 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSAxiomAudit.olean` — `ABSENT` |
| 5 | `F3ReturnExcursionBlock0SemanticChildBaseHit.lean` | `014873cbcae6a35eda427aeb5943ef72b7f41eaee69998b8ff455fc294bfcf37` | 156 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0SemanticChildBaseHit.olean` — `ABSENT` |
| 6 | `F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit.lean` | `bede0aabe2da7d0b99f717133d0fbdbc016e01ff088ad5294070145df581b916` | 92 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0SemanticChildBaseHitAxiomAudit.olean` — `ABSENT` |
| 7 | `F3ReturnExcursionBlock0ReverseBFSCompleteness.lean` | `9a5b885a7b27f54b9e1a6044fa956fc688f5dfb23c100d7ab6cefbf10a3e5eec` | 162 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSCompleteness.olean` — `ABSENT` |
| 8 | `F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit.lean` | `eb5f04aa57a9c690d0cbbb10b9e457746a9cfca31a85d31effb17576924d7f7e` | 97 | `.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSCompletenessAxiomAudit.olean` — `ABSENT` |

The sources are under `CollatzClassical/KL2003/`; the objects, when B0 is
separately authorized, must be under
`.lake/build/lib/lean/CollatzClassical/KL2003/`. Static source inventories of
axiom-print declarations are not executed PASS receipts.

A robust read-only recursive parse of all local `import CollatzClassical...`
edges from these eight roots yields exactly 57 physical local sources, with no
missing local import file. At commit `67cef401...`, 46 were already tracked and
11 were local-only. Commit `3e3245373d51171603ab9849626d79f662e4f0cc`
custodies the exact 11-file delta under
`F3_R3_PREREQUISITE_IMPORT_CLOSURE_PUBLIC_CUSTODY_ROOT_ACT_v1.md`.

```text
ROOT_SOURCES = 8
LOCAL_IMPORT_CLOSURE_SOURCES = 57
PUBLIC_TRACKED_CLOSURE_SOURCES = 57/57
PRIVATE_OR_ABSENT_LOCAL_IMPORT_SOURCES = 0
DELTA_VECTOR_SHA256 = efd479201e27bbc454e009f8d532dd2124812136b5e9344c3be7430173250b26
```

This is public source custody only. It is not elaboration, build, object,
axiom-profile, or B0 evidence.

## 7. Seven-input acceptance surface

A later authoring act must preserve all of the following:

1. exactly six fixed rows in the registry-v10 order;
2. `ROW_SELECTION_CLASSIFICATION=SIX_FIXED_PREDECLARED_ROWS`;
3. `FINITE_MAXIMUM_SELECTION_CERTIFIED=NO` and no extremality inference from
   any legacy row ID;
4. a typed branch-complete wrapper with saturated and deficient outcomes;
5. twelve public row declarations, `fixedRow01_check` through
   `fixedRow06_check` and `fixedRow01_outcome` through `fixedRow06_outcome`;
6. deficient means a valid checker-accepted deficient row and only the scoped
   full-capacity subroute STOP, never an F3-wide mathematical STOP;
7. the generator is untrusted and may not import or duplicate the checker,
   acceptance theorem, expected outcomes, or hidden lookup tables;
8. the axiom audit enumerates every public declaration in its declared module
   surface and audits all twelve row declarations;
9. every public theorem cone absolutely forbids `native_decide`,
   `Lean.ofReduceBool`, `Lean.trustCompiler`, `sorryAx`, `axiom`, `admit`, and
   `sorry`; the only permitted axiom profile is `propext`,
   `Classical.choice`, and `Quot.sound`;
10. the executor contains exactly the fourteen normal phases plus custody-only
    C0, preserves their order, and exposes no direct internal-command bypass;
11. the memory guard implements the frozen sampled process-group policy;
12. the materializer combines exactly six canonical fragments without semantic
    rewriting and creates the payload only at S0.

The three scripts must be regular executable files only after a later freeze
records their exact mode, SHA-256, lines, command expansion, tool identities,
environment, resource ceilings, and Git base. No glob or `PENDING` may occur
in that final input freeze.

## 8. Next gates

The only eligible successor is a separate root authorization to author exactly
the seven paths in Section 5. It must be followed by independent static and
adversarial audits of the same seven-byte tuple and a root freeze decision.

Only a successful seven-input freeze may make a later B0 runbook authorization
eligible. That future act must pin exact commands, environment, tool hashes,
resource limits, worktree snapshot, receipts, and a single B0 attempt. Neither
this review nor seven-input authorship authorizes B0.

```text
NEXT_GATE = SEPARATE_SEVEN_INPUT_AUTHORING_AUTHORIZATION
LEAN_AUTHORITY = NONE
LAKE_AUTHORITY = NONE
BFS_AUTHORITY = NONE
GENERATOR_AUTHORITY = NONE
PILOT_EXECUTION_OPENED = NO
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
