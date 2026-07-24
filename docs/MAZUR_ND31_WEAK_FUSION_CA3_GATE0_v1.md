# Mazur ND31 weak-fusion Gate H1-0 v1

Status:

```text
PASS_WITH_CANONICAL_REPIN_TO_CA3
NO_F386_ATTRIBUTION_AUTHORIZED
GATE0_STATIC_SNAPSHOT_SUPERSEDED_BY_GATE2_BUILD_AND_AUDIT_PASS
```

## Remote custody anchors

At the final live check on 2026-07-24:

```text
origin/master = ccc561db3a6aa45006229ae15fef55e05fbb6ab0
origin/codex/mazur-density-fusion-custody =
  7f659eb482e5984a70b83fc7ab6e4548a3831596
```

`STATUS.md` en `master@ccc561d...` ya no contiene
`NO_K11_084_THEOREM_CLAIM`; la P1 K11 está cerrada en el remoto vivo.

## Source pin

The only recovered first-party source package is ProofAtlas commit
`ca3dd0d63920411213403092aecc6946619eb082`. Its local ZIP has SHA-256
`401a4674263112b81ff7e3c3eb43f3fca3d7eb320f418a39a5b606fb3b20bf09`.
All 604 manifest entries were checked: zero missing files and zero hash
mismatches.

No object, bundle, manifest or source package naming `f386357d...` was found.
This custody therefore records a discrepancy; it does not infer equality or
ancestry between `f386357d...` and `ca3dd0d...`.

## Custody topology

The 604-file source closure is not vendored into `CollatzClassical`. The
custodied artifact is instead:

1. one nine-file Lean payload: seven integration files plus two explicit
   compatibility files;
2. exact base and candidate hash manifests;
3. a toolchain/Mathlib pin;
4. a guarded reconstruction script for a clean `ca3dd0d...` extract;
5. a build/audit report which was pending at Gate 0 and is now superseded by
   the preserved Gate 2 build and axiom-audit PASS.

The guarded reconstruction script was run against a fresh ZIP extraction and
verified all eleven candidate source/environment hashes. It did not invoke
Lean or Lake.

The concrete extension retains its own `Erdos1135` namespace. The abstract
`CollatzClassical` contract is provenance documentation, not a replacement for
the source-facing theorem.

## Mathematical API prepared

The direct consumer takes a bound `q < 1/2` and proves the explicit eventual
lower bound

```text
delta = ((1/2 - q) / 2) > 0.
```

The separate ND31 adapter specializes `q` to the witness selected by
`ND31Bounds`. The weak route contains no `odd_to_all` obligation. This remains
a conditional fixed-target interface; it supplies no concrete `q`, `N0` or
finite certificate.

## Non-claims

- Gate 0 itself ran no reconstructed build; the later preserved Gate 2 run
  built all 2962 jobs and audited all 12 declarations.
- Gate 0 itself produced no axiom output; Gate 2 subsequently recorded exactly
  `propext`, `Classical.choice`, and `Quot.sound` for each audited declaration.
- No natural-density limit is claimed.
- No unconditional positive-density result is claimed.
- No global Collatz claim is made.
- No push or publication occurred at Gate 0; publication is governed by the
  later publication preflight and explicit authorization.
