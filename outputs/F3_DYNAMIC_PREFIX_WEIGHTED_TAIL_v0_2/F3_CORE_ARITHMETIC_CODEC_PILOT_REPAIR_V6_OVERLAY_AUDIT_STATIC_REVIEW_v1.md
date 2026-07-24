# F3 arithmetic-codec pilot repair v6 overlay-audit static review

Status: `STATIC_PASS / OVERLAY_NOT_STAGED / AUDIT_NOT_EXECUTED`

Date: 2026-07-24.

V6 changes no Lean source, audit, inventory or checker. Its new mechanism is a
single isolated `CollatzClassical` package root containing the exact repair and
ExactCoreMatrix `.olean` objects. This removes the confirmed split-root
shadowing by construction.

The tracked stage script requires the overlay to be absent, verifies both
source hashes, copies exactly two files, re-verifies both target hashes and
requires a two-file inventory. S0, A1 and C1 each have one conditional
invocation and fail closed.

The audit path excludes both fragmentary project roots. ExactCoreMatrix imports
only Mathlib. The audit also imports `Lean.Meta.Basic` and
`Lean.Util.CollectAxioms` directly; those resolve from the pinned toolchain. The
closed graph is therefore:

```text
audit -> repair -> ExactCoreMatrix -> Mathlib
audit -> Lean.Meta.Basic -> toolchain
audit -> Lean.Util.CollectAxioms -> toolchain
```

The stage script, donor manifest and toolchain pins are frozen in the contract.
Preflight must record that none of the ten roots following the overlay contains
a `CollatzClassical/` package directory. No compile, Lake invocation,
regeneration, extension or first-hit is allowed.

This remains explicitly dependent on local ignored objects and is not a
fresh-clone reproduction. PASS or STOP must receive public terminal custody.
