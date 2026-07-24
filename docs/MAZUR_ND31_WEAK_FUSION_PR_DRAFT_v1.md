# Draft PR — Add audited weak fixed-target density-fusion interface

Target branch: `codex/mazur-density-fusion-custody`

Proposed head: `agent/mazur-weak-fixed-target-fusion-ca3`

## What changed

This change prepares a reproducible nine-file Lean integration payload over
the ProofAtlas package commit
`ca3dd0d63920411213403092aecc6946619eb082`. It adds a parametric weak
positive-lower-density API, a decidable finite-base certificate interface,
source-surface compatibility modules, guarded reconstruction, and captured
build/axiom evidence.

The source closure is not vendored. The PR contains only the compact payload,
hash manifests, reconstruction tooling, audit logs, provenance documentation,
and the exact upstream attribution material required for redistribution.

## Why

The direct theorem isolates the exact fixed-target implication: a uniform bad
ratio bound `q < 1/2`, together with a finite base, yields the explicit ambient
eventual lower bound `(1/2 - q)/2`. The separate ND31 adapter exposes where a
future quantitative witness would enter without asserting that witness.

## Boundaries

- This is a conditional theorem; its quantitative and finite-base hypotheses
  are not discharged here.
- It does not prove existence of a natural-density limit.
- It does not prove density one or the Collatz conjecture.
- It makes no claim about `f386357d...`; that identifier has no recovered
  upstream provenance receipt.
- The only supported source wording is “ProofAtlas package commit for the
  reviewed commit-pinned public-source route” at `ca3dd0d...`.

## Validation checklist

- [x] Live remote base verified at
  `7f659eb482e5984a70b83fc7ab6e4548a3831596` on 2026-07-24.
- [x] Base is the exact merge-base of the reviewed candidate `58981ff...`.
- [x] Original frozen gate: 11/11 reconstruction hashes passed.
- [x] Original frozen gate: `lake update` exited 0.
- [x] Original frozen gate: official Mathlib post-update cache hook completed.
- [x] Original frozen gate: target build exited 0 with 2962 jobs.
- [x] Original frozen gate: 12/12 axiom surfaces contained only `propext`,
  `Classical.choice`, and `Quot.sound`, with no `sorryAx` or
  `Lean.ofReduceBool`.
- [x] Exact Advameg NOTICE and upstream Apache-2.0 license copies are now
  custodied.
- [x] Restore Formal Conjectures header and all modified-file notices.
- [x] Regenerate tar and hash manifests without overwriting historical
  evidence.
- [x] Confirm the publication tar itself contains exact `LICENSE`/`NOTICE`.
- [x] Fresh publication reconstruction and 13/13 candidate hashes passed.
- [x] Preserve the first environmental STOP without cleanup or retry.
- [x] Independent Gate 2 rebuilt the immutable publication tar after capacity
  was restored: 2962 jobs completed successfully.
- [x] Gate 2 audited 12/12 declarations; each profile is exactly `propext`,
  `Classical.choice`, and `Quot.sound`, with no `sorryAx` or
  `Lean.ofReduceBool`.
- [x] `git diff --check` on the final publication head, with one path-scoped
  whitespace exception for the immutable hashed environmental STOP log.
- [x] Verify final diff contains no `.lake`, `.olean`, dependency checkout, or
  unrelated work.
- [x] Re-authenticate `gh`; confirm `Menta2357` has repository-admin access,
  reconfirm remote/base/scope, and pass a write-path `git push --dry-run`.

## Reviewer focus

Please check endpoint conventions, the `q < 1/2` strictness, the explicit
delta, the finite-base boundary, the Syracuse-to-raw-Collatz bridge, exact
axiom profiles, and the license/NOTICE custody. Review this as a conditional
interface and reproducibility contribution, not as an unconditional density
or Collatz result.
