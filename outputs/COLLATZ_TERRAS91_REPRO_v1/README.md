# First descent at a coefficient crossing with at most 91 odd runs

`TerrasUniform91.firstDescentAtExactly91` proves that the actual first coefficient
crossing is the first strict descent below the original seed when its physical
prefix consists of exactly 91 maximal runs of odd steps, under the inputs
listed below. `firstDescentAtMost91FromWeaver` combines this with the verified
87–90 extension and Weaver's theorem through 86.

Both statements retain the original seed `N`, all earlier times and the exact book
`2^k * orbit N k = 3^(oddCount N k) * N + additive N k`. The hypothesis
`FirstContraction N k` supplies existence of the first coefficient crossing.
The result does not assert existence of such a crossing for every seed or
that its run count is at most 91.

## Proof

1. Exclude equality at the crossing by the cycle theorem, and consume the explicit
   finite verification for small seeds.
2. A positive displacement on the original prefix yields a one-factor discount
   in the valley product and bounds the same physical clocks `k` and `oddCount N k`.
   Integer outward rounding and the Farey-neighbor argument reduce the
   22,145 admissible strip pairs to 18 candidates.
3. Rank the real valleys chronologically for the window argument and by height
   for the product comparison. The first rank is discounted once.
   Fifteen candidates contradict an exact product bound at the lower height
   `2^92-1`. For Q1 and 2Q1 the lower height is `2^146-1`, and the product
   bound forces an actual Weaver window. The last candidate Q0 reuses the
   separately certified 91-run Q0 proof.

## Source premises

The hypotheses of `Terras90SourceBridge.Inputs` remain explicit. They include the
Rozier–Terracol finite verification, Rhin's lower bound for linear forms,
Hercher's corrected cycle bound, Weaver's window exclusion and the three
numerical inputs to the six-run capacity bounds. The 2480-step universal finite
delay ceiling through `46645791847966786687` is an additional explicit premise
supplied to the Q0 certificate. See the adjacent Terras 90 and 91 Q0 packages
for the source references, reproduced record endpoint and finite audits.
Weaver's result through 86 is an additional explicit hypothesis of the
combined statement.

## Reproduction

Keep the pinned `COLLATZ_TERRAS90_REPRO_v2` and `COLLATZ_TERRAS91_Q0_REPRO_v1`
directories beside this one or provide `--base` and `--q0`. Use Lean 4.21.0.
Prepare the pinned Mathlib dependency cache with `lake exe cache get`.
Alternatively, point `--packages` at an existing cache with the identical
dependency revisions. From this directory run

```sh
python3 scripts/check_numeric.py
python3 scripts/verify.py --jobs 1
```

The first command enumerates the full strip independently and audits the 17 new
comparisons via rational logarithm bounds. The second rebuilds this theorem's
source dependencies in an empty directory and audits every new public
declaration listed in `provenance/axioms_expected.json`.
