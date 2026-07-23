# Mazur ND31 Parametric Density-Fusion Fidelity Audit v1

Status: `FIDELITY_AUDIT_ADAPTER_COMPILED_BRIDGES_PENDING`

## Scope and source pin

This audit compares the generic transport module
`CollatzClassical.DensityFusionParametric` with the source-facing ND31
definitions published by ProofAtlas at commit
`ca3dd0d63920411213403092aecc6946619eb082`.

Source endpoint:
`https://www.proofatlas.ai/sources/natural-density-log-time-collatz/`

The comparison target is `Erdos1135/ND/Statement.lean`, not the surrounding
proof closure. The source defines `ND31Bounds c` using
`oddSyracuseBadRatio N0 x`, with guards `2 <= N0` and `2 <= x`, and the bound
`C * Real.rpow (Real.log (N0 : ℝ)) (-c)`.

## Checklist

| Item | Result | Evidence | Consequence |
| --- | --- | --- | --- |
| (a) ND31 hypothesis is literal | `SURFACE_MIRROR_COMPILED_NOT_LITERAL` | `MazurND31SurfaceAdapter` mirrors the quantified guards and endpoint shape, but keeps the source bound and ratio abstract. It does not define `oddSyracuseBadRatio` or import `ND31Bounds`. | Instantiate the concrete source ratio and prove the endpoint equivalence before composition. |
| (b) Natural-density conclusion on all naturals | `NOT_PRESENT` | Local conclusion is `EventuallyRatioLowerBound goodRatio delta` over an arbitrary `R`; it is not `Terras.HasNatDensity` and has no all-natural domain. | Add a density-counting bridge and an odd-to-all bridge. |
| (c) Dynamics/reaches-one alignment | `NOT_PRESENT` | The module intentionally has no Syracuse, Collatz, or `reaches_one` definition. | Supply the concrete Syracuse-to-Collatz and finite-base hypotheses at the adapter boundary. |
| (d) Explicit delta | `PARAMETRIC_ONLY` | The local theorem returns `rho - q`; `q` and `rho` are parameters. | Instantiate `q := C * (log N0)^(-d)` and prove positivity separately. |
| (e) No-claims calibration | `PASS` | Module comments and the companion note explicitly deny external ND31, bridge, positive-density, and global-Collatz claims. | Preserve these labels until the adapter and bridges compile. |

## Exact interface verdict

The module is mathematically valid as a generic eventual-ratio subtraction
lemma, but it is **not** a literal restatement of Mazur's `ND31Bounds` and it
does not yet produce a natural-density or reaches-one theorem. The correct
classification is therefore:

```text
COMPILED_KERNEL_CLEAN
FIDELITY_AUDIT_REQUIRES_ADAPTER_AND_BRIDGES
NO_EXTERNAL_ND31_CLAIM
NO_POSITIVE_DENSITY_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```

## Required next interfaces

1. A source-facing adapter from `ND31Bounds d` to the local eventual bound,
   preserving the semi-open/inclusive endpoint convention and odd guard.
2. A concrete definition of the good set, including `reaches_one`, with the
   Syracuse-to-Collatz and finite-base assumptions exposed as hypotheses.
3. A counting theorem connecting the eventual ratio to `Terras.HasNatDensity`
   or an explicitly stated liminf, first on odd inputs and then on all positive
   inputs.
4. A positivity theorem for the instantiated value
   `rho - C * (log N0)^(-d)`.

No implementation of these interfaces is included in this custody commit.

The surface adapter theorem is now compiled and audited; the four concrete
obligations above remain open by design.

## License boundary

The pinned ProofAtlas `LICENSE` and `NOTICE` were downloaded and inspected in
the temporary audit environment. The source closure is Apache-2.0, with the
Advameg notice preserving the licenses of Mathlib, retained Formal Conjectures
material, and cited papers. The local status is
`LICENSE_APACHE_2_VERIFIED_SOURCE_PINNED`. This module imports no ProofAtlas
source or namespace.
