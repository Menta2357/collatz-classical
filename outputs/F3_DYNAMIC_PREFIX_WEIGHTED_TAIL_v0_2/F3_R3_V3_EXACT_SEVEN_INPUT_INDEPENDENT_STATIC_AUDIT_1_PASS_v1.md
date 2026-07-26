# F3 R3 v3 exact-seven input independent static audit 1 — PASS

Date: 2026-07-26.

## Verdict and scope

```text
AUDITOR_ID = exact7_full_independent
AUDIT_VERDICT = PASS
P1_RESIDUAL = 0
P2_RESIDUAL = 0
SOURCE_CONFORMANCE_ONLY
NO_BUILD_OR_RUNTIME_RESULT
```

This audit is a read-only source-conformance review under
`F3_R3_V3_EXACT_SEVEN_INPUT_AUTHORING_ROOT_AUTHORIZATION_v1.md`.  It covers
the same exact seven-byte tuple frozen below.  It does not certify elaborated
Lean declarations, an axiom cone, a generated payload, a reverse-BFS result,
or any mathematical branch.

## Exact tuple

| # | Path | Mode | Bytes | Lines | SHA-256 |
|---:|---|---:|---:|---:|---|
| 1 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean` | `100644` | 8862 | 202 | `1279be4863dc8fdbda04c6e763f010420e69328abb08450ce0ec27f565cec2b1` |
| 2 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean` | `100644` | 3970 | 107 | `300060274c49a18bbbf34491490dfe9e22f428ce170e2e1ae634d8626cc6a6d9` |
| 3 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean` | `100644` | 4824 | 134 | `74c402e7b906813eeb4127b4a46f7465ecd9e33b7f1e5463f951509d50799248` |
| 4 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean` | `100644` | 13196 | 306 | `d6ac2625e0ac0961a3f0d6b40f3a7c65d9571273e1cd103cd981647bfbb9e569` |
| 5 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh` | `100755` | 143474 | 818 | `6f20261d3c93bff4cc783bcfccfa542643d2da51efcfaeceff5534e1cf8a61c4` |
| 6 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh` | `100755` | 21796 | 497 | `cc894111363adf16e10a04fe1bc3b7157c831b71a84b64720768259bb85c844a` |
| 7 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_materialize.sh` | `100755` | 6414 | 181 | `5f4c9b5469cc5312af54e7e1053046b752d16833f33213f94f23d78c1a8f7897` |

All seven are regular non-symlink files with regular directory ancestry,
terminal LF, no NUL, and no CR.  The generated
`F3ReturnExcursionBlock0ReverseBFSPilotPayloadsV3.lean` is absent.

## Lean-source review

- `PilotRowsV3` imports only the sharded demand profile and ordered-first-hit
  layer.  Its six rows are reconstructed through typed constructors in the
  registry-v10 order.  The six coordinate theorems state both raw API pairs
  and their reduced contractual equalities; legacy IDs remain metadata.
- `PilotGenerateV3` imports only RowsV3 and ReverseBFSData.  Its accepted CLI
  language is exactly the six complete canonical IDs.  It invokes
  `generateReverseBFSCertificate`, uses an explicit deterministic serializer,
  and contains neither expected outcomes nor checker acceptance logic.
- `PilotV3` has exactly six `fixedRow0i_check` and six
  `fixedRow0i_outcome` declarations.  The branch-complete interface separates
  saturated capacity from deficient fibre equality, cardinal equality, and
  strict shortfall.
- `PilotV3AxiomAudit` imports only PilotV3 plus `Lean.Meta.Basic` and
  `Lean.Util.CollectAxioms`.  Its stable inventory is compared in both
  directions, internal declarations must have a stable ancestor, and the
  complete actual inventory is passed to `collectAxioms`.  The source
  allowlists no `native_decide`, `Lean.ofReduceBool`, `Lean.trustCompiler`,
  `sorryAx`, user axiom, `admit`, or `sorry` path.

These are source findings only.  The generated payload and actual A0 profiles
remain future runtime evidence.

## Executor, evidence, and custody review

- The normal grammar is exactly
  `B0 R0 P0 G01 G02 G03 G04 G05 G06 S0 P1 V0 A0 F0`; `C0` is custody-only.
- Each phase has one literal ceiling and one attempt.  No reset, resume,
  cleanup, retry, resource escalation, caller command, shell `eval`, shell
  `source`, overwrite, glob-selected target, or environment-selected program
  is exposed.
- Commands, result allowlists, typed evidence schemas, memory receipts,
  dependency traces, Lake deltas, candidate paths, leases, and terminal
  precedence are closed by literal registries.  INVALID dominates incomplete
  or malformed custody and does not manufacture a normal terminal receipt.
- The memory guard list-execs a closed phase table under the remaining outer
  deadline.  The materializer accepts no arguments and reconstructs the
  payload from exactly six canonical fragments between fixed byte-preserving
  wrapper segments.
- F0 custody is acyclic.  A residual active lease or malformed historical
  evidence routes to the sole C0 custody attempt rather than a false COMPLETE
  state.

The final phase-binding repair was reviewed at every live and historical
consumer: evidence with a `PHASE` field is accepted only when its type, fixed
physical/caller phase, and `META PHASE` agree.  The generic validators that
remain are limited to schemas without a `PHASE` key.  A transposed evidence
bundle therefore cannot satisfy COMPLETE.

## Repairs reviewed

1. `ROOT_STATIC_PARSE_P1_REPAIR_ACT`: guard and materializer received only a
   quoted Bash heredoc envelope around their original post-`exec perl -x`
   Perl tails.  Removing the three envelope lines recovers the pre-repair
   bodies byte-for-byte.  This made the mandated sanitized `bash -n` check
   meaningful without changing the Perl program.
2. `ROOT_PHASE_BINDING_P1_REPAIR_ACT`: the executor added fixed-phase evidence
   validation and applied it exhaustively to live, nested, terminal, failure,
   F0, and C0 paths.

Both repairs precede this final audit tuple.  No residual P1 or P2 was found.

## Embedded programs

| Program | Bytes | SHA-256 |
|---|---:|---|
| `CONTROLLER_PROGRAM_V1` | 141981 | `10f4b37537b4ae4fe710e0f9e56fe002d80f05aede68ff6747c2538aff45f6f0` |
| `ENV_CAPTURE_AND_EXEC_V1` | 2819 | `5f6a90174279026a32a13a989988a1845104ca42cd7b3a99854f3f56a34b1048` |
| `SEQUENCE_PROGRAM_V1` | 8990 | `2012facea06be834e7930ca9ecea4c5cc0a60457d5c0a12ec3e141883a9364b0` |

## Static parse receipt

The authorization's exact sanitized argv was applied to each of the three
absolute script paths.  All three returned status zero.  No script body and
no target phase was executed.

```text
SANITIZED_BASH_N = PASS_3_OF_3
PAYLOAD_SOURCE = ABSENT
WRITE_OUTSIDE_EXACT_SEVEN = 0
LEAN_EXECUTED = NO
LAKE_EXECUTED = NO
REVERSE_BFS_EXECUTED = NO
GENERATOR_EXECUTED = NO
```
