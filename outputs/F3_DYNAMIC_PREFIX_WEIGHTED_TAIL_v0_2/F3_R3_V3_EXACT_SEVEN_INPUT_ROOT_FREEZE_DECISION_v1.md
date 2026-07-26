# F3 R3 v3 exact-seven input root freeze decision v1

Date: 2026-07-26.

## Decision

```text
ROOT_FREEZE_VERDICT = FREEZE_EXACT_SEVEN_SOURCE_TUPLE
INDEPENDENT_AUDITS = PASS_2_OF_2
P1_RESIDUAL = 0
P2_RESIDUAL = 0
SOURCE_CONFORMANCE_ONLY
NO_BUILD_OR_RUNTIME_RESULT
B0_AUTHORITY = NONE
R0_AUTHORITY = NONE
PILOT_EXECUTION_OPENED = NO
```

Root accepts the two independent static audits on the same byte tuple and
freezes it for public custody.  This decision makes a separately authored and
separately reviewed B0 runbook eligible for consideration; it does not itself
authorize B0, Lean, Lake, reverse BFS, a generator, payload materialization,
or any later phase.

## Frozen seven inputs

| # | Path | Mode | Bytes | Lines | SHA-256 |
|---:|---|---:|---:|---:|---|
| 1 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotRowsV3.lean` | `100644` | 8862 | 202 | `1279be4863dc8fdbda04c6e763f010420e69328abb08450ce0ec27f565cec2b1` |
| 2 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotGenerateV3.lean` | `100644` | 3970 | 107 | `300060274c49a18bbbf34491490dfe9e22f428ce170e2e1ae634d8626cc6a6d9` |
| 3 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3.lean` | `100644` | 4824 | 134 | `74c402e7b906813eeb4127b4a46f7465ecd9e33b7f1e5463f951509d50799248` |
| 4 | `CollatzClassical/KL2003/F3ReturnExcursionBlock0ReverseBFSPilotV3AxiomAudit.lean` | `100644` | 13196 | 306 | `d6ac2625e0ac0961a3f0d6b40f3a7c65d9571273e1cd103cd981647bfbb9e569` |
| 5 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_executor.sh` | `100755` | 143474 | 818 | `6f20261d3c93bff4cc783bcfccfa542643d2da51efcfaeceff5534e1cf8a61c4` |
| 6 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_memory_guard.sh` | `100755` | 21796 | 497 | `cc894111363adf16e10a04fe1bc3b7157c831b71a84b64720768259bb85c844a` |
| 7 | `outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_r3_reverse_bfs_pilot_v3_materialize.sh` | `100755` | 6414 | 181 | `5f4c9b5469cc5312af54e7e1053046b752d16833f33213f94f23d78c1a8f7897` |

The generated payload path remains absent.  Every tuple member has terminal
LF and contains neither NUL nor CR.

## Frozen embedded identities

| Identifier | Bytes | SHA-256 |
|---|---:|---|
| `CONTROLLER_PROGRAM_V1` | 141981 | `10f4b37537b4ae4fe710e0f9e56fe002d80f05aede68ff6747c2538aff45f6f0` |
| `ENV_CAPTURE_AND_EXEC_V1` | 2819 | `5f6a90174279026a32a13a989988a1845104ca42cd7b3a99854f3f56a34b1048` |
| `SEQUENCE_PROGRAM_V1` | 8990 | `2012facea06be834e7930ca9ecea4c5cc0a60457d5c0a12ec3e141883a9364b0` |

## Audit closure and repair history

- Independent audit 1: PASS, 123 lines, SHA-256
  `6f557810c66c0f859a88a15bbc543595b9ab60b3977943efb3c128e89300d32c`,
  source conformance only, no build/runtime result.
- Independent audit 2: PASS, 109 lines, SHA-256
  `4c39817f45a3a8fc273f28faff245320b96dcf20ff444292bdd557de7872aa75`,
  source conformance only, no build/runtime result.
- Root physical check: exact hashes/modes/bytes/lines, regularity, LF, no
  NUL/CR, and absent generated payload all PASS.
- Root mandated sanitized static parse: PASS 3/3 using each absolute script
  path under the exact `env -i`/Bash argv.

Two pre-freeze P1 findings were repaired under explicit root acts and then
re-audited on the final tuple:

1. `ROOT_STATIC_PARSE_P1_REPAIR_ACT` added only a quoted Bash heredoc envelope
   around each original post-`exec perl -x` Perl tail in guard/materializer.
2. `ROOT_PHASE_BINDING_P1_REPAIR_ACT` required every schema carrying a
   `PHASE` field to agree with its fixed physical/caller phase, including
   historical and bundled evidence.

Both independent audits report no residual P1 or P2 after those repairs.

## Custody boundary

The next permitted action under this decision is source custody only:
persist these two audit files and this freeze with the exact seven inputs,
commit only that ten-path set, and push it to the declared public branch.
Unrelated dirty-worktree paths are outside scope and must remain untouched.

After public custody, a new root act may author the fixed
`F3_R3_V3_B0_EXECUTION_ROOT_AUTHORIZATION_AND_RUNBOOK_v1.md` and its typed
inputs.  No authority transfers automatically from this freeze.

## No-claim boundary

```text
NO_B0_RESULT
NO_R0_RESULT
NO_GENERATED_CERTIFICATE
NO_CHECKER_RESULT
NO_SIX_ROW_PASS_OR_STOP
NO_RESIDUAL_D2_RESULT
NO_RHO_CERTIFICATE
NO_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
