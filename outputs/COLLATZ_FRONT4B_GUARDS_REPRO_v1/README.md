# Refinements of the four weak Front4b guards

The exact row remains `s = 29+32u`, `u ≡ 2 (mod 8)`. The original seed
is `N = 1156359581173680383779426258047 + 2^100 u` and its pivot is the
same 62nd odd return `V`. All extensions compose the verified prefix
from `N`. Positive odd sources strictly smaller than `N` have independent
physical paths to the same terminal, with their own clocks and additive
corrections. Such a meeting is a payment certificate for induction on
smaller seeds.

| Residue of `u` | Certified refinement | Remaining obligation |
|---|---|---|
| `18 mod 32` | A two-return source for the affine `(2,5)` example and terminal ternary payment criterion | General strong exits and the weak continuations beyond the first two |
| `10 mod 128` | All strong first ruptures of the initial one-run pay by the half-source. A two-return source also covers the certified `(2,5)` family | The first rupture 2 outside the paid tails |
| `34 mod 64` | Direct descent, a quarter-source meeting, or a smaller ambient pivot below the immediate terminal `Z`; uncovered prefixes restricted to `(1,1)` and `(1,2,1)` | Continuation of the weak prefixes and reiteration of a compatible rank rule |
| `202 mod 256` | Payment, a smaller ambient pivot below `Z`, or genuine admission at `Z` with a positive one-run and first rupture 2 | Reiteration of the rank rule after that weak exit |

The `c=7` branch is also checked by the same local inequalities. Its earlier
lower-pivot result already belonged to the row package.

Both `e=1` guards now also have three adaptive quarter-source certificates.
For every length `L ≥ 2` of the exact one-run from the fixed checkpoint `J`,
these certificates pay when the following head is `(2,4,4)`, `(2,5,2)`
or `(2,6)`. The final valuation is free. The source `w = (J-3)/4 < N` takes
`L-2` initial ones, and its last valuation is exactly two higher than the
last valuation of the original path. The `(2,5,2)` and `(2,6)` words
reuse known tails and widen their application to these guards. See the
[arithmetic and separate books](paper/quarter_tail.md).

A next valuation 2 in either `e=2` weak guard may cross below `Z` while
its immediate endpoint is strictly **above** the original pivot `V`.
The classifier's local decrease therefore cannot be identified with a
decrease under the earlier row pivot. The four guards and the full row
remain open.

The [E1 audit](paper/E1.md) explains why a uniform inverse depth at the
first weak-two terminal fails when the preceding one-run varies.
The [E2 audit](paper/E2.md) lists the two weak prefixes with exact clocks.
The bounded `e2_diagnostic.py` screen is exploratory and the Lean proof
uses physical valuations and arithmetic margins.

## Reproduction

Keep the pinned `COLLATZ_A2_FRONT4B_Q81_ROW_REPRO_v1` directory beside
this package or pass its location using `--base`. Using Lean 4.21.0
with Std only, from this directory run

```sh
python3 scripts/verify.py --jobs 1
python3 -B paper/verificar_e1.py
python3 -B paper/check_quarter_tail.py
```

For the second command, set `FRONT4B_ROW_PAPER` to the base package's
`paper` directory if it is located elsewhere. The Lean verifier rebuilds
the pinned dependency graph into an empty directory and audits the
exported conclusions.
