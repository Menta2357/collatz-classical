# Mazur ND31 Parametric Density-Fusion Algebra v1

Status: `PARAMETRIC_FUSION_COMPILED_IN_ISOLATED_WORKTREE_NOT_YET_CUSTODIED`

## Scope

`CollatzClassical.DensityFusionParametric` drafts the transport-only
inequality needed by the proposed fusion. Its core is generic over a linearly
ordered additive group; the concrete instantiation sets
`q := C_d * (log N0)^(-d)` in `Real`.

```text
badRatio <= C * (log N0)^(-d)
rho - badRatio <= goodRatio
rho - C * (log N0)^(-d) > 0
------------------------------------------------
Eventually goodRatio >= rho - C * (log N0)^(-d)
```

The main theorem also returns the strict positivity of the displayed lower
bound, rather than accepting it as an unused side hypothesis.

The module also provides `nd31_fusion_positive_eventual_ratio` and the
generic `eventually_ratio_lower_bound_of_odd_to_all_bridge`. The latter is
only a ratio-domination adapter: it does not prove the arithmetic
odd-to-all-natural bridge.

The theorem is parameterized by the bound `q` and `rho`; it fixes no
`C_d` or `N0`. The external adapter supplies the displayed `q` expression.
This is the correct first deliverable because the current
`collatz-classical` tree does not contain the external `Erdos1135.ND` namespace.

## Mazur Statement-Fidelity Gate

The module is intentionally not signed against the external ND31 theorem yet.
Before any compile result is promoted, an audit must compare the local adapter
interface against Mazur's `Statement.lean`: the semi-open `D_X` counting
convention, odd-input guards, and the exact ratio normalization must match
literally. A near-match is a blocker, not an integration detail.

Current repository status: the Mazur/ProofAtlas `Statement.lean` is not present
in this tree, so this correspondence audit is pending and no external ND31
claim is made.

The local source-surface adapter is now in
`CollatzClassical.MazurND31SurfaceAdapter`. It mirrors the quantified shape
and consumes an explicit endpoint bridge, but it deliberately parameterizes
the source bound and does not import or assert the ProofAtlas namespace.

## License boundary

ProofAtlas identifies the pinned first-party closure at commit
`ca3dd0d63920411213403092aecc6946619eb082`. Its `LICENSE` and `NOTICE` were
downloaded and inspected in the temporary audit environment: the closure is
Apache-2.0, with a separate Advameg notice preserving the licenses of Mathlib,
retained Formal Conjectures material, and cited papers. This is recorded as
`LICENSE_APACHE_2_VERIFIED_SOURCE_PINNED`. This module imports no
ProofAtlas/Mazur code or namespace and therefore does not copy the external
closure.

## Concrete integration contract

The Mazur/ProofAtlas adapter must later provide:

1. `hnd31`: the fixed-target `ND31Bounds d` estimate, instantiated at `N0`
   and exposed as an eventual ratio bound;
2. `hcover`: a proof that the finite base theorem and the
   Syracuse-to-Collatz bridge put the complement of the bad set inside the
   reaching-one set;
3. `hpositive`: the exact rational/real inequality
   `0 < rho - C * (log N0)^(-d)`;
4. an odd-to-all-natural bridge if the public conclusion is over all positive
   starts rather than odd starts.

The first adapter theorem is compiled and audited, but it remains an interface
theorem until a concrete `oddSyracuseBadRatio` and its endpoint bridge are
instantiated.

The intended named obligations are:

```text
base_below N0
syracuse_to_collatz N0
odd_to_all_natural
```

`base_below` is the finite theorem that every positive value below `N0`
reaches one. `syracuse_to_collatz` turns a bounded Syracuse hit into a
reaches-one witness using that finite theorem. `odd_to_all_natural` transfers
the odd-supported lower bound through the concrete 2-adic fibres. None of
these names is currently implemented as a theorem in this repository; they
are the required adapter boundary rather than hidden assumptions.

For the current ND31 definitions, `rho = 1 / 2` is the ambient mass of the
odd inputs. Therefore the first direct conclusion is an odd-supported
ambient lower bound, not automatically `1 - C*(log N0)^(-d)` over all
naturals.

## Explicit non-claims

- No explicit numerical `C_d` is extracted.
- No finite base theorem below a concrete `N0` is proved.
- No Syracuse-to-Collatz or odd-to-all-natural bridge is asserted.
- No positive-density theorem for starts reaching `1` is claimed.
- No global Collatz theorem is claimed.

## Verification

```text
lake build CollatzClassical.DensityFusionParametric
lake env lean CollatzClassical/DensityFusionParametricAxiomAudit.lean
```

The source and proof term compile in a clean detached worktree based on
`origin/master`, using the official Mathlib cache and the local Lean 4.21
toolchain. The audit reports `[propext, Quot.sound]` for the two audited
theorems. The renamed files remain uncommitted in the main worktree; this is a
compile result, not yet a custody or external-statement-fidelity claim.
