# F3 R3 v3 exact-seven input independent static audit 2 — PASS

Date: 2026-07-26.

## Verdict

```text
AUDITOR_ID = exact7_final_aggregate
AUDIT_VERDICT = PASS
P1_RESIDUAL = 0
P2_RESIDUAL = 0
SOURCE_CONFORMANCE_ONLY
NO_BUILD_OR_RUNTIME_RESULT
```
This second audit independently re-aggregated the final seven-file tuple,
embedded byte strings, command recipes, phase topology, and custody closure.
It did not execute Lean, Lake, reverse BFS, a generator, the payload
materializer, the memory guard, or the public executor.

## Byte tuple independently reproduced

| Short name | Mode | Bytes | Lines | SHA-256 |
|---|---:|---:|---:|---|
| RowsV3 | `100644` | 8862 | 202 | `1279be4863dc8fdbda04c6e763f010420e69328abb08450ce0ec27f565cec2b1` |
| GenerateV3 | `100644` | 3970 | 107 | `300060274c49a18bbbf34491490dfe9e22f428ce170e2e1ae634d8626cc6a6d9` |
| PilotV3 | `100644` | 4824 | 134 | `74c402e7b906813eeb4127b4a46f7465ecd9e33b7f1e5463f951509d50799248` |
| PilotV3AxiomAudit | `100644` | 13196 | 306 | `d6ac2625e0ac0961a3f0d6b40f3a7c65d9571273e1cd103cd981647bfbb9e569` |
| executor | `100755` | 143474 | 818 | `6f20261d3c93bff4cc783bcfccfa542643d2da51efcfaeceff5534e1cf8a61c4` |
| memory guard | `100755` | 21796 | 497 | `cc894111363adf16e10a04fe1bc3b7157c831b71a84b64720768259bb85c844a` |
| materializer | `100755` | 6414 | 181 | `5f4c9b5469cc5312af54e7e1053046b752d16833f33213f94f23d78c1a8f7897` |

Regularity, modes, LF, NUL/CR absence, and generated-payload absence all
match audit 1 without relying on its conclusion.

## Embedded-program reproduction

| Program | Bytes | SHA-256 |
|---|---:|---|
| controller | 141981 | `10f4b37537b4ae4fe710e0f9e56fe002d80f05aede68ff6747c2538aff45f6f0` |
| environment capture | 2819 | `5f6a90174279026a32a13a989988a1845104ca42cd7b3a99854f3f56a34b1048` |
| sequence | 8990 | `2012facea06be834e7930ca9ecea4c5cc0a60457d5c0a12ec3e141883a9364b0` |

The controller's canonical command-recipe framing is
`uint32be(argc)` followed by `uint32be(byte_length) || bytes` for every argv
member.  The independently reproduced fixed recipe frames are:

| Phase | argc | Frame bytes | SHA-256 |
|---|---:|---:|---|
| B0 | 3 | 195 | `4508f9d1ad79900ac449d8495f96759ac7a414c826dccfbd5d2640b775932ccf` |
| R0 | 3 | 195 | `f532748fa4ada338280d06a32e791dcb9b44e50700ae10cad59c19850594a9d2` |
| G01 | 3 | 196 | `3f6e27a48af7a1bf52bd46fca8d978234b0bedb4d7f0dc314b86b750f1a3603b` |
| G02 | 3 | 196 | `5ed2fec71a5e2ca9e4547db3dc51c337d7c15bf7b043b8c06f8c22507b01a5d3` |
| G03 | 3 | 196 | `192fdcd8de6e192ad789be27497e8cd3d4390c0382c3e75cd5f477b5ecf0f692` |
| G04 | 3 | 196 | `64f3085ccff6d82d7f02dec9fc1c66be2498a45263f41805fffead7a8704446a` |
| G05 | 3 | 196 | `0a21e86b3d15a68c5ae6a5062ac1857586dd3cae1989b599f2c4391ac58f3e7b` |
| G06 | 3 | 196 | `a35832afd136b076cb49678bf5ac06d0824b26cdb78825973c89d5b32f81a9fe` |
| V0 | 3 | 195 | `1bf7c0cab7ea0438893d7104ea3106c7adc43551d6504a54264f0d4c0a5a6212` |
| A0 | 3 | 195 | `f959d2f16306b5cc7507445734fee7a6ab5fd96534e2f3d9b8873eda936c30dd` |
| P0 | 2 | 46 | `87fef13ebe3966ca2613520c808f8b1a37bc9321be88ba396a8686e249219b3d` |
| P1 | 2 | 46 | `965435f8d6de5dd8262a007e9667e000506a8583c7603d740556d11b7d815e94` |
| F0 | 2 | 46 | `e19e11addfd714a4bfccebf85734d78b9bb4eaf14e294f0c3b99fd771045ecb4` |
| C0 | 2 | 43 | `41ce4c53a5ab0cc30863261e0d2d13e29ea6a8b6930a2ffcad610d1b8942b1f9` |

The documentary S0 placeholder recipe is 7 arguments, 328 bytes, SHA-256
`93b7110b2bb6b64e7c5fc3085151bb3beecd1f603b8bd99062e06fecb419c480`.
At runtime S0 and guard child frames bind the literal positive
`seconds_remaining`; their effective runtime hash is deliberately not
replaced by a symbolic value in this source audit.

## Independent semantic closure

1. The six row constructors, raw/reduced coordinate pairs, demands, children,
   and windows agree with registry v10.  The generator has no checker import
   or hidden expected result.  PilotV3 exposes exactly twelve public row
   check/outcome declarations.
2. The audit source enumerates the stable namespaces in both directions,
   accounts for generated internal details by stable ancestry, and sends the
   complete actual set to `collectAxioms`; actual profiles are deferred to A0.
3. Phase adjacency, one-attempt leases, ceilings, memory receipts, typed
   evidence, Lake7/object deltas, failure census, terminal receipts, F0 report
   custody, and C0 invalid custody form a closed source topology.
4. Every evidence consumer whose schema contains `PHASE` binds the declared
   phase to the fixed caller/physical phase.  This includes nested
   environment, loaded-object and delta evidence; terminal, output and
   failure evidence; exact payload/F0 paths; bundles; and report/custody
   revalidation.  Remaining generic calls are only for schemas without
   `PHASE`.
5. Guard and materializer pass the mandated sanitized static parser after the
   minimal heredoc-envelope P1 repair.  The materializer still joins exactly
   fragments 01 through 06 between byte-exact wrappers.
6. No generic command channel, retry, reset, resume, cleanup, resource
   expansion, target overwrite, or undocumented publication path was found.

The exact absolute-path sanitized `bash -n` construction returned zero for
all three scripts.  Static source inspection found no write outside the seven
authorized targets.

```text
SANITIZED_BASH_N = PASS_3_OF_3
P1_RESIDUAL = 0
P2_RESIDUAL = 0
PAYLOAD_SOURCE = ABSENT
LEAN_EXECUTED = NO
LAKE_EXECUTED = NO
REVERSE_BFS_EXECUTED = NO
GENERATOR_EXECUTED = NO
SOURCE_CONFORMANCE_ONLY
NO_BUILD_OR_RUNTIME_RESULT
```
