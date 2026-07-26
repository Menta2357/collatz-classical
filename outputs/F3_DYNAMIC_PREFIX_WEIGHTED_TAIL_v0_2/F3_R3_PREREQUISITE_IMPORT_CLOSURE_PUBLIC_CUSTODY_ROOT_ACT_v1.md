# F3 R3 prerequisite import closure — public custody root act v1

## Status

`ROOT_AUTHORIZATION_FOR_EXACT_SOURCE_CUSTODY_ONLY`

This act authorizes one commit containing exactly this act and the eleven
pre-existing Lean sources listed below, without changing their bytes.

## Repository base

- branch: `codex/hilo2-f3-r3-reverse-first-hit-v1`
- public parent: `67cef401a6d8b93d87673e967542392d4c5e6129`
- remote ref: `public/codex/hilo2-f3-r3-reverse-first-hit-v1`
- tracked worktree diff: `0`
- index diff: `0`

## Static closure computation

The roots are the exact eight prerequisite sources pinned by registry v10 and
the pending static review. A read-only traversal recursively resolved every
line matching an exact local `import CollatzClassical...` module to its `.lean`
path. It found:

```text
ROOT_SOURCES = 8
LOCAL_IMPORT_CLOSURE_SOURCES = 57
TRACKED_AT_PARENT = 46
UNTRACKED_REGULAR_SOURCES = 11
MISSING_LOCAL_IMPORT_FILES = 0
LEAN_LAKE_BFS_GENERATOR_EXECUTED = NO
```

This is a textual import-closure inventory, not a Lean elaboration or build.

## Exact eleven-file closure delta

All paths are relative to `CollatzClassical/KL2003/`. Each file was rechecked
as a regular non-symlink mode-`100644` file. Table order is lexicographic by
full repository-relative path.

| # | Exact path | SHA-256 | Lines |
|---:|---|---:|---:|
| 1 | `F3ReturnExcursionBlock0ActiveChannelIntervals.lean` | `c112a67f71818da6c9738bfb9cad57bdb4d3e9ff86265e8f1cee47cef9734623` | 243 |
| 2 | `F3ReturnExcursionBlock0MassAtoms.lean` | `5389c6b8302561fe82504b02f7fc0539d30a9519d9a2f5f825c53a5a3ead34d6` | 86 |
| 3 | `F3ReturnExcursionBlock0MassDemandDirectShard.lean` | `a7cda49f233846c094d67e7939eb46188806f858b5f3037ccea3760e87a6f40f` | 254 |
| 4 | `F3ReturnExcursionBlock0MassDemandLiftShard.lean` | `652d9d442d5797b4060b6eb165c1efda141aea6f9917dae95f6c7b5408225500` | 255 |
| 5 | `F3ReturnExcursionBlock0MassDemandProfileCore.lean` | `64011393bfe1505aa43c7443f163ddc977bddf2c765d51f6fad8a0930a7196a7` | 177 |
| 6 | `F3ReturnExcursionBlock0MassDemandRetardedShard.lean` | `ad5c06066b9f7af41c2d82691a4c67befeb34afe710c03f15c92dc8eae4e5bdb` | 230 |
| 7 | `F3ReturnExcursionBlock0OrderedFirstHit.lean` | `a84a79389401e4d837cd6085d93864600dd1fc78549c51c44b440311ccac2d01` | 261 |
| 8 | `F3ReturnExcursionBlock0OrderedFirstHitBool.lean` | `c91ca09930ff5c79513fef27dd10276c8c13c135155e5c79093d7634c29ab455` | 110 |
| 9 | `F3ReturnExcursionBlock0ReverseBFSData.lean` | `02275794ecd3acd5bd17e2b542401f1db43922386c188b6c0ccc5c28eac2d256` | 161 |
| 10 | `F3ReturnExcursionBlock0ReverseBFSVerifier.lean` | `dcedbd42da9887d3a47d4877582cabe1fde8af995454048443c6ce2faaa899e3` | 294 |
| 11 | `F3ReturnExcursionBlock0ReversePredecessor.lean` | `3dc3a02c118e8d300c96947421da8bce0244b03257c10b65912e73d2b0912ffe` | 108 |

The table's raw lowercase SHA-256 values, one per line with a final LF and no
other byte, have:

```text
PIN_VECTOR_CODEC = RAW_SHA256_PLUS_LF_IN_TABLE_ORDER
PIN_VECTOR_PREIMAGE_BYTES = 715
PIN_VECTOR_COMMITMENT_SHA256 = efd479201e27bbc454e009f8d532dd2124812136b5e9344c3be7430173250b26
```

## Calibration

After this exact custody commit, all 57 source files in the static local import
closure of the current eight roots are present in public Git history. This does
not claim that they elaborate, compile, or share a permitted axiom profile.
Those questions remain for a separately authorized B0 and later audits.

The closure does not include the seven not-yet-authored PilotV3 inputs, their
future import closure, generated payloads, `.olean` objects, scripts, tools,
receipts, or runtime environment. Any such surface remains a later gate.

## Commit allowlist

The authorized commit contains exactly twelve additions:

1. this act;
2. the eleven exact sources in the table.

The two pending input-registry review documents, G11/G03/pack artifacts, all
other sources, scripts, results, objects, receipts, and every other untracked
path are excluded. No glob, `git add .`, or `git add -A` is authorized.

## Authority boundary

```text
SOURCE_CUSTODY_AUTHORITY = EXACT_11_PLUS_THIS_ACT
SEVEN_INPUT_WRITE_AUTHORITY = NONE
LEAN_AUTHORITY = NONE
LAKE_AUTHORITY = NONE
BFS_AUTHORITY = NONE
GENERATOR_AUTHORITY = NONE
B0_AUTHORITY = NONE
R0_AUTHORITY = NONE
P0_AUTHORITY = NONE
PILOT_EXECUTION_OPENED = NO
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
