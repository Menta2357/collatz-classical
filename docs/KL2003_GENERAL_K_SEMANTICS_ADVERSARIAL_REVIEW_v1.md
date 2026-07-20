# KL2003 general-k semantics adversarial review v1

Date: 2026-07-20

## Verdict

```text
GENERAL_K_SEMANTICS_REVIEW_PASS_WITH_SCOPE_NOTES
NO_MATHEMATICAL_BLOCKER_FOUND
```

The reviewed module implements the source envelope needed by the tracked
general-k chain. Its P1, P2, and P3 statements agree with the corresponding
KL2003 properties on their common domain. Two deliberate scope choices are
stronger or narrower than the literal source presentation and must remain
visible: only modes congruent to `2 mod 3` are represented, and the function
is extended by zero to negative real arguments.

## Reviewed artifacts

```text
CollatzClassical/KL2003/KL2003GeneralKSemantics.lean
CollatzClassical/KL2003/KL2003GeneralKSemanticsAxiomAudit.lean
CollatzClassical/KL2003/KL2003GeneralKFloorWindow.lean
CollatzClassical/KL2003/KL2003GeneralKOriginalRows.lean
docs/KL2003_GENERAL_K_SEMANTICS_P1_P2_P3_LEAN_v1.md
30apr02.tex, lines 366-416 and 426-453
```

## Source-to-Lean correspondence

| Source item | Lean realization | Review |
|---|---|---|
| modulus `3^k` | `generalKModulus k` | exact |
| tracked set `[3^k]`, modes `m = 2 mod 3` | `TrackedMode k` | exact after equation (200) normalization |
| roots `a = m mod 3^k`, not in a cycle | `ClassRootsK k m` | exact, with explicit `1 <= a` |
| real bound `2^y a` | `sourceWindow y a = floor (2^y a)` | exact Nat representation |
| source infimum | `sourcePhiK` on `y >= 0` | exact on tracked modes |
| P1 positivity | `sourcePhiK_one_le` | exact, conditional on class non-emptiness |
| P2 monotonicity | `sourcePhiK_mono_y` | exact on `y >= 0`; Lean proves the zero-extension version globally |
| P3 minimization | `sourcePhiK_P3` | exact partition into the three lifts |

The `3^j` printed in the defining set at source line 382 conflicts with the
surrounding definition and the following well-definedness sentence, both of
which use `3^k`. The implementation follows `3^k`, as already recorded in the
general-k semantic-chain scoping.

## Scope notes

### Tracked modes only

KL2003 first defines the source functions for every mode not divisible by
three, then uses equation (200) to reduce the working system to modes
congruent to `2 mod 3`. `sourcePhiK` directly indexes that reduced system.
It therefore does not itself formalize equation (200) or the untracked
`1 mod 3` source family. This is a calibrated restriction, not an equality
claim about the omitted family.

### Negative arguments

The paper defines the source functions on `y >= 0`. Lean sets `sourcePhiK` to
zero when `y < 0`. This extension is used to give the function a total real
domain; it is not attributed to KL2003. The source rows do not exploit it:
`sourcePhiK_D1`, `sourcePhiK_D2`, and `sourcePhiK_D3` require `2 <= y` and
prove non-negativity of every shifted argument before invoking infimum
traffic. The final lower bounds likewise quantify over `0 <= y`.

### Non-emptiness

The paper states that every relevant class contains a root not in a cycle.
Lean makes this dependency explicit through
`GeneralKClassRootsNonempty k`. The module constructs it at `k = 3` using
powers of two, while the k=9 checkpoint discharges it separately. P1 and the
lower-bound chain do not silently assume an inhabited infimum.

## Adversarial checks

1. The Nat window counts exactly the integers below the real source bound by
   flooring `2^y a`; it does not inherit the older concrete `ceil` window.
2. `piStar` excludes zero and includes the root itself at path length zero,
   so P1 follows once `a <= sourceWindow y a`.
3. P3 is proved in both directions by an actual partition of roots. It is not
   a wrapper or assumed bridge.
4. The P3 child modes are `m + j * 3^k` for `j = 0,1,2`, matching source
   property P3 after the Lean index shift from level `k` to `k + 1`.
5. The k=3 witnesses prove `NotInCycle` for powers of two rather than relying
   on computation or an axiom.
6. Downstream source rows require `y >= 2`, matching Proposition 2.1, and do
   not obtain a stronger row by evaluating the zero extension.

## Documentation correction

The module header previously said that P3 remained an explicit consumer even
though `sourcePhiK_P3` and its k=2-to-k=3 specialization are proved in the
same file. The header was corrected; no theorem statement or proof changed.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKSemantics
lake env lean CollatzClassical/KL2003/KL2003GeneralKSemanticsAxiomAudit.lean
git diff --check
```

Expected axiom profile:

```text
[propext, Classical.choice, Quot.sound]
```

## Classification

```text
GENERAL_K_SOURCE_ENVELOPE_SOURCE_FAITHFUL_ON_TRACKED_NONNEGATIVE_DOMAIN
GENERAL_K_P1_REVIEWED
GENERAL_K_P2_REVIEWED
GENERAL_K_P3_REVIEWED
K3_CLASS_ROOTS_NONEMPTY_REVIEWED
NEGATIVE_ZERO_EXTENSION_EXPLICIT_AND_NOT_USED_TO_STRENGTHEN_SOURCE_ROWS
EQUATION_200_UNTRACKED_MODE_EQUALITY_NOT_CLAIMED
GENERAL_K_SEMANTICS_HEADER_STALENESS_FIXED
GENERAL_K_SEMANTICS_REVIEW_PASS_WITH_SCOPE_NOTES
NO_GLOBAL_COLLATZ_CLAIM
```
