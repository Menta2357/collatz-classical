# KL2003 Meta-Errata: M1 Phi5 Reinstatement v1

Date: 2026-07-13

Repository: `https://github.com/Menta2357/collatz-classical`

## Purpose

This note records a project-side meta-errata discovered during the row28/mod8
seam audit.

It does not introduce a Lean theorem, does not claim M1, and does not claim
Collatz.

## Summary

Earlier project notes treated the KL2003 Appendix `k=2` formula for `M_1` as
containing an erratum:

```text
TeX/source arm:      phi_2^5(y + 2*alpha - 5)
project-normalized: phi_2^2(y + 2*alpha - 5)
```

This project normalization is now revoked.

The correct source-aligned arm is:

```text
phi_2^5(y + 2*alpha - 5)
```

## Evidence

The reversal is supported by four independent checks:

1. `30apr02.tex` lines 1760-1783 print the final `T_2^8(EL)` formula with
   the `phi_2^5(y + 2*alpha - 5)` branch in `M_1`.
2. Figure A1 graph extraction identifies the crossed/deleted class-8 advanced
   nodes and the surviving post-deletion leaf structure.
3. The deletion rule source audit explains why a crossed class-8 parent node
   must not be counted together with its descendants.
4. The member-wise seam hook reports that the `phi_2^2` branch is not uniformly
   realizable in the repeated class-8 subcase, while the `phi_2^5` branch is
   realized by the simple `4 * node` single-chain pattern.

## Consequence

The existing Lean M0C abstract induction layer is still a valid theorem about
the abstract V2 row system it states, but that V2 row system is no longer the
source-faithful target for KL2003 row28.

The project should migrate to a V3 row contract:

```text
M2V3(Phi,y) =
  min3
    Phi.phi22(y + 3*alpha - 5 - pad3)
    Phi.phi25(y + 3*alpha - 5 - pad3)
    Phi.phi28(y + 3*alpha - 5 - pad3)

M1V3(Phi,y) =
  min
    (Phi.phi28(y + 2*alpha - 5 - pad2) + M2V3(Phi,y))
    Phi.phi25(y + 2*alpha - 5 - pad2)
```

Everything outside the row28 nested arm is expected to survive:

- M0A semantics;
- M0B core/fiber machinery;
- row22 seam;
- row25 seam;
- root-count/base bridge;
- retarded-rank descent lemmas;
- row22 and row25 assemblies.

The row28 arithmetic and induction consumer must be rechecked under V3.

## Process Lesson

A source normalization is a mathematical claim.  It must carry proof debt.

This meta-errata demonstrates that plausible source-normalization by local
consistency is not enough.  Future source normalizations should be validated by
the same member-wise hook used for row/seam validation at the time the
normalization is introduced.

## Status

```text
META_ERRATA_M1_PHI5_REINSTATED
PREVIOUS_M1_PHI5_TO_PHI2_NORMALIZATION_REVOKED
M0C_V2_ABSTRACT_THEOREM_STILL_VALID_AS_ABSTRACT
M0C_V2_NO_LONGER_SOURCE_FAITHFUL_FOR_KL2003_ROW28
V3_ROW_CONTRACT_REQUIRED_BEFORE_NEXT_LEAN_ROW28_PASS
NO_LEAN_CHANGE
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
