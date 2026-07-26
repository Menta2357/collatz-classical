# F3 R3 v3 input registry and pre-execution review — root authoring authorization v1

## Status

`ROOT_AUTHORIZATION_FOR_ONE_STATIC_REVIEW_ONLY`

This act authorizes creation of exactly one static review at:

`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_R3_V3_INPUT_REGISTRY_AND_PREEXECUTION_REVIEW_v1.md`

No other path is authorized by this act.

## Public custody base

- repository branch: `codex/hilo2-f3-r3-reverse-first-hit-v1`
- public base commit: `3e3245373d51171603ab9849626d79f662e4f0cc`
- prerequisite-closure parent: `67cef401a6d8b93d87673e967542392d4c5e6129`
- historical-dependency parent: `fbc79fb58c8450f1e3f1342000470f34da32521f`
- seven-postimage commit: `f27f9e1c2d39b7e2f5165b319b83e2d5e71f85dd`
- pre-adoption parent: `8765d7083906e7b3e3b03951da6331fcf1427e1b`
- remote ref at authorization:
  `public/codex/hilo2-f3-r3-reverse-first-hit-v1`

The externally audited atomic textual adoption is closed. It did not execute
Lean, Lake, BFS, or a generator and did not open the pilot.

## Mandatory review pins

The review must identify by exact path, SHA-256, and line count at least:

| Artifact | SHA-256 | Lines |
|---|---:|---:|
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v3.md` | `620f15497644be361f7a06ef4fa31362f325f94eda37b02de145450712fe30d6` | 353 |
| `F3_R3_REVERSE_BFS_PILOT_CONTRACT_v6.md` | `b4f67e108938b66e93c15948bd8d2aa48fdcb6fd267f6ce75ad48c122ee08e6f` | 399 |
| `F3_R3_EXECUTION_REGISTRY_v7.md` | `97e63232e354030d46bd50a58b9b83d1d705e7f37a4a203020c26fac2639b0c7` | 313 |
| `F3_R3_EXECUTION_REGISTRY_v10.md` | `41b697b3d2cbe4561f5b9e0ab4fc84a895a23e9dd66e0bbcbad8ebf37d6510f6` | 376 |
| `F3_R3_CUSTODY_SPLIT_v5.md` | `95240ae594507ba3bfa4083caad3e804f59f68a90aa12636c54a768166f9eaba` | 263 |
| `F3_R3_CUSTODY_COMMANDS_v5.md` | `0c59afd374ac69aa471008798a6b47d58009324e73bea1ec656a296f0858b36b` | 589 |
| `F3_R3_V6_POST_ADOPTION_EXTERNAL_CUSTODY_IMPORT_ROOT_ACT_v1.md` | `51360320e2929e9796e35ec4ca6dcfce0d52864b3c5c0733cc744272e987e9e1` | 85 |
| `F3_R3_HISTORICAL_NORMATIVE_CORPUS_PUBLIC_CUSTODY_ROOT_ACT_v1.md` | `85c48b61a71ac22eb06bf22de4d0503fe4be66ed9f9b2a526c3ffcc8225dc19a` | 96 |
| `F3_R3_PREREQUISITE_IMPORT_CLOSURE_PUBLIC_CUSTODY_ROOT_ACT_v1.md` | `093fff4b1b9162877f2efb805a2e82a7e45202d815bcc79ba65d6c9f27809116` | 104 |

All paths in the table are relative to
`outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/`.

## Required findings

The review must be deterministic and fail closed. It must:

1. enumerate exactly the seven required prewritten PilotV3 inputs;
2. verify their live presence/absence without following symlinks;
3. enumerate exactly the eight required prerequisite Lean sources and their
   expected `.olean` objects;
4. rehash the eight sources and report live `.olean` presence/absence;
5. verify and pin the complete 57-source public local-import closure of those
   eight roots, with no private or absent local dependency remaining;
6. record that the payload module is an `S0` output, not an eighth input;
7. resolve the timing conflict between contract v6 Sections 6 and 8 and the
   phase semantics in contract v3 Section 4.1 / registry v7 Section 3;
8. supersede only the chronological arrows and `exact next gate` phrases of
   registry v7 Section 4 that place prerequisite builds before seven-input
   authoring, while preserving its dependency and audit conditions;
9. resolve the separate conflict between contract v6 Section 9, which places
   compiled/audited final acceptance before P0, and contract v3 Sections 4.2
   and 4.4, which freeze that source before P0 but compile and audit it only
   after payload materialization in V0 and A0;
10. reconcile exactly the obsolete registry-v7 acceptance counts: replace the
    monolithic Profile pair `24/24 + ordinary-decision 2/2` by the adopted
    sharded requirements `86/86 explicit + ordinary-decision 7/7 + fail-hard
    namespace sweep`, and replace Completeness `4/4` by `6/6`; preserve
    ReverseBFS `42/42`, SemanticChildBaseHit `3/3`, freshness, receipts, and
    every no-authority condition;
11. state normatively that any future prerequisite compilation occurs exactly
   once inside `B0`, after all seven inputs are written and statically frozen;
12. forbid a separate pre-`B0` recompilation and forbid treating source-only
   state as build/audit PASS;
13. record that Custody Split v5 and Custody Commands v5 do not authorize the
   old Batch B or any current execution;
14. enumerate the three exact adoption-evidence paths and all eight exact
    `.olean` paths rather than relying on inferred basenames;
15. preserve the inherited absolute public-cone prohibition and permitted
    axiom profile without weakening either;
16. define the exact next static authoring/audit/freeze gates;
17. preserve `B0 -> R0 -> P0 -> G01 -> ... -> F0` as non-permutable;
18. leave `GO_FOR_B0=NO`, `GO_FOR_R0=NO`, and `GO_FOR_P0=NO`.

The review may determine whether a later, separate root act is eligible to
authorize authoring exactly the seven inputs. The review itself may not create
those inputs and may not grant execution authority.

## Conflict and count reconciliation boundary

The review is authorized to supersede only two contradictory timing surfaces
and one exact obsolete-count surface:

1. language that would require a prerequisite build both before the seven
   inputs exist and inside the sole `B0` cold build, including only the
   conflicting chronological phrases of registry v7 Section 4; and
2. language that would require the final payload-dependent acceptance source
   to be compiled/audited before P0 even though contract v3 reserves that
   compilation and audit for V0/A0 after S0/P1; and
3. registry v7's monolithic `24/24 + 2/2` Profile acceptance pair and
   Completeness `4/4`, replaced only by sharded `86/86 + 7/7 + fail-hard
   namespace sweep` and Completeness `6/6`. ReverseBFS `42/42` and
   SemanticChildBaseHit `3/3` are not changed.

The corrected second surface must require the final acceptance and audit
sources to be prewritten, statically reviewed, and frozen before P0; compile
the payload-independent typed-row/generator surface in R0; and compile the
final acceptance in V0 and audit its public cones in A0. It must not move V0
or A0 earlier and must not permit generation to count as verification.

Every semantic acceptance condition remains: fresh prerequisite builds and
audits, six public completeness roots, exact fiber/node cardinal equalities,
the complete pre-generation seal, final six-row kernel verification, and the
exhaustive public-cone audit are still required at their corrected phases
before a terminal PASS or scoped STOP.

## Prohibitions

```text
LEAN_AUTHORITY = NONE
LAKE_AUTHORITY = NONE
BFS_AUTHORITY = NONE
GENERATOR_AUTHORITY = NONE
B0_AUTHORITY = NONE
R0_AUTHORITY = NONE
P0_AUTHORITY = NONE
SEVEN_INPUT_WRITE_AUTHORITY = NONE
PILOT_EXECUTION_OPENED = NO
```

No rho certificate, density theorem, almost-all result, or global Collatz claim
may be inferred from this act or its authorized review.
