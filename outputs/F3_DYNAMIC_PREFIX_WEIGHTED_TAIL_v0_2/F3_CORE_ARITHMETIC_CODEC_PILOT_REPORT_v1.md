# F3_CORE_ARITHMETIC_CODEC_PILOT_REPORT_v1

Status: `STOP_BEFORE_ELABORATION — ENV_READY_VERIFIED_FOR_PILOT — PILOT_EXECUTED=NO — HUMAN_REAUTHORIZATION_HOLD`

## Verdict

The reviewed 27-source arithmetic-codec source passed its static contract,
but the single authorized compile command was rejected before elaboration.
Lake required the input file to lie below the dependency worktree root; the
pilot source correctly remained in the isolated F3 worktree.  Exit code was
1 after 4.20 seconds.  No `.olean` or `.ilean` was produced.

The rejected command is recorded as a preflight invocation, not a Lean
elaboration attempt.  No second Lean command was run and the axiom audit was
not opened.  A coordinated review subsequently identified the direct Lean
route, and an isolated rebuild has now verified its frozen dependency byte
for byte.  Every fresh pilot attempt nevertheless remains on explicit
human-reauthorization HOLD.

```text
STATIC_SOURCE_CONTRACT = PASS
LEAN_ELABORATION = NOT_STARTED
PILOT_COMPILE = NOT_OPENED
PREFLIGHT_INVOCATION = STOP_BEFORE_ELABORATION
AXIOM_AUDIT = NOT_RUN
ARCHITECTURE_VERDICT = NOT_TESTED_BY_LEAN
ENV_READY_VERIFIED_FOR_PILOT = true
PILOT_EXECUTED = NO
```

## What is preserved

The uncompiled pilot source contains:

- the `Fin 243`/`CoreCode` arithmetic codec and two-sided inverses;
- `bucketCode`, `stateCode`, `n0`, `adjust`, `a`, and `c`;
- semantic direct/lift targets defined by `decode(stateCode(...))`;
- closed-form target lemmas and lift injectivity;
- constructive `FormulaEdge` rank/unrank and cardinality 729;
- a 27-source/81-edge pilot rank/unrank;
- a positional restriction of `frozenPos`, a public `List.get_mem` bridge,
  inclusion, generic saturation, `List.Perm`, prefix scope, and matrix
  equality by filtered `foldr` commutativity.

The sole historical reduction is private.  It is used to establish the
pointwise positional bridge; public comparison proceeds through membership,
subset, saturation, and permutation.

## Why this is not an architecture FAIL

Lean did not parse or elaborate the source.  Therefore this run supplies no
evidence for or against any theorem body.  The failure class is exclusively
the Lake root selected for the invocation.  It also reveals a missing part
of the environmental precheck, now recorded explicitly.

The environment defect is now closed independently: rebuilding only
`F3ReturnExcursionExactCoreMatrix` from source SHA-256 `58ab7b1a...` under
Lean 4.21.0 and Mathlib `308445d...` exited zero in 138.42 seconds and
produced a 1,967,392-byte `.olean` with SHA-256 `34a6f174...`, byte-identical
to the donor object.  A minimal import probe also passed in 116.75 seconds.
The earlier 300-second rebuild timeout remains recorded as an inconclusive
contention-era environmental attempt, not a mathematical failure.

## Next admissible gate

A new explicit authorization may permit one fresh attempt with the frozen
source hash, the verified direct-Lean root arrangement, the same
`maxHeartbeats=200000`, and the same 120-second wall ceiling.

It must not copy or edit the pilot inside `master`, increase resources, add
search/catalogue machinery, or treat this STOP as a Lean PASS.

## Frozen hashes

```text
pilot source sha256:
ce072461c6283044a651fd576df5342b0890981b26f776e3023413640d906230

axiom-audit source sha256:
c83c174b8e3ac61043f1054e0179b2e7b0dd936cea0c84b45e245f612ac03cf6

reviewed design sha256:
ff98f16d1d62963f4a38b957c0007be023254a590c7922b8ebc784b420ea9f8d
```

## Non-claims

```text
NO_LEAN_PASS
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_ALMOST_ALL
NO_GLOBAL_COLLATZ_CLAIM
```
