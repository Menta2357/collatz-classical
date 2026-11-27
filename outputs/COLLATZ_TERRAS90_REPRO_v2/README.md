# Terras 90 Lean reproduction

This package reproduces a conditional first-descent criterion for the shortcut Collatz map. The map sends odd `x` to `(3*x+1)/2` and even `x` to `x/2`. The Lean definitions count odd source states and starts of odd runs before time `k`, including a run whose start is in the prefix and whose end is beyond it. A first contraction at `k` is the first time `3^d < 2^k`, where `d` is the number of odd source states before `k`.

## Checked results

| Lean result | Scope |
| --- | --- |
| `Terras90Physical.admissionWithRhin` | A physical first contraction above `28,000,000,000,000,000,000` with exactly 90 odd runs and a positive endpoint displacement satisfies the scaled integer admission bounds, given `RhinBound`. |
| `Terras90Physical.sevenClocksWithRhin` | The exact clock pair `(k,d)` belongs to a seven-element list after the Q0, Q1, 2Q1 and 2Q0 exclusions. The exact affine identity `2^k * orbit N k = 3^d * N + additive N k` uses the same seed and prefix. The result also takes the six-run capacities at heights 92 and 146 and the Q0 Weaver no-window premise. |
| `Terras90Final.excludesResidual` | For a physical first contraction above the same height, exactly 90 odd runs, and the six-run capacity at height 92, each of the seven remaining clock pairs excludes positive endpoint displacement. |
| `Terras90Final.noPositiveShift90` | With the premises of the physical seven-clock certificate, a first contraction above the height and with exactly 90 odd runs has `orbit N k ≤ N`. |
| `Terras90Final.firstDescentAtMost90` | With the inputs below, if `N ≥ 2` has a first contraction with at most 90 odd runs, its endpoint is strictly below `N` and every earlier value in the same orbit is at least `N`. |
| `Terras90SourceBridge.firstDescentAtExactly90` | For `N ≥ 2`, if a first contraction has exactly 90 odd runs, the source-level inputs below give strict descent there, no earlier descent, and the exact affine book. |
| `Terras90SourceBridge.firstDescentAtMost90` | The same conclusions hold through 90 runs when coverage through 89 is supplied separately. |
| `TerrasUniformFirstDescent.firstDescentAtMost90FromWeaver` | With the source-level inputs below and Weaver's theorem through 86 odd runs, the same conclusions hold for every first contraction with `N ≥ 2` and at most 90 odd runs. |

The [seven explicit rows](lean/Terras90FinalNumeric.lean) are Q0+Q1, 3Q1, 4Q1, J, J+Q1, J+2Q1, and 2J, where J is the last clock defined in [Terras88](lean/Terras88.lean). The package checks the complete chain from physical admission to these rows and their exclusions. This includes the ordinary local and sorted-rank bounds, logarithm brackets, reciprocal budget, lattice enumeration, the earlier price and rank comparisons, and the seven final strict products. The ordinary bounds and logarithm brackets are proved inside the package.

## Source-level inputs for exactly 90 odd runs

`Terras90SourceBridge.firstDescentAtExactly90` uses the seven statements in
[`Terras90SourceBridge.Inputs`](lean/Terras90SourceBridge.lean). The proof
splits at the verified height. It uses finite-range agreement up to that
height and derives the needed logarithmic, cycle, capacity and no-window
interfaces for the larger seeds.

| Input | Source and scope |
| --- | --- |
| `finiteRange` | Coefficient stopping time agrees with first descent for `2 ≤ N ≤ 28,000,000,000,000,000,000`. [Rozier–Terracol v5, Corollary 5.4](https://arxiv.org/pdf/2502.00948v5#page=17) |
| `linearForms` | Rhin's estimate with height `max (abs u₁) (abs u₂)`, exponent `−13.3` and factor one. The Lean adapter specializes to `u₀=0, u₁=k, u₂=−d`. [Rozier–Terracol v5, Proposition 6.3](https://arxiv.org/pdf/2502.00948v5#page=19) |
| `hercher` | Theorem 23 excludes nontrivial shortcut Collatz cycles with at most 91 strict local minima. The Lean bridge proves that equality at first contraction gives the least physical period, with exactly as many local minima as odd runs. [Hercher, Theorem 23](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/hercher5.pdf) · [June 2026 corrigendum](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/corrigendum.pdf) |
| `weaver` | Query 1 excludes a valley segment from an odd source strictly above the verified height and at most `453027402666008300865`, ending at or above `2^146−1` within five complete blocks and staying at or above its own source at intervening valleys. The Lean transfer uses the occurrences in the original prefix. [Weaver v1, Sections 5–6](https://rstation.ai/problems/collatz/papers/143) |
| `sevenRuns`, `fiveRuns` | The universal completed-run bounds `B₇(100) ≤ 156` and `B₅(229) ≤ 254`. The Lean adapter extends a truncated prefix to the next valley and transfers the bounds to the original prefix. [Freelan Lab v1](https://rstation.ai/problems/collatz/papers/206/v1) · [Computation supplement](https://rstation.ai/api/v1/papers/collatz_206/versions/1/supplement) |
| `guardedH146` | The six-complete-run bound `d ≤ 166` for seeds `2^124*u−1` with `1 ≤ u < 2^22`. The local exhaustive runs checked 4,194,303 cofactors and agreed on maximum 166, first attained at `u=3798656`. [Formal domain and adapter](lean/Terras90PublishedCapacity.lean) |

These source and computational statements remain theorem arguments. Lean checks their
transfer to the exact first-crossing statement. The earlier v1 theorem in
[`Terras90Final`](lean/Terras90Final.lean) retains its explicit inputs for the cases
through 89 runs. The source-level wrapper `Terras90SourceBridge.firstDescentAtMost90`
takes separate coverage through 89, while the exactly-90 result uses only the seven
inputs displayed above.

## Uniform extension through 90 odd runs

`TerrasUniformFirstDescent.firstDescentAtMost90FromWeaver` uses the same seven
source-level inputs and Weaver's exact first-descent statement through 86 odd
runs. The Lean uniform extension treats 87–90 runs on the original physical
prefix. Padding weakens the reciprocal and product comparisons to the
90-run arithmetic envelopes. Each rank used for a window is transferred
back to the original occurrence before the chronological extraction.
[Weaver v1, Theorem 1](https://rstation.ai/problems/collatz/papers/143)


## Rebuild

Install Elan, Git, and Python 3. From this directory run:

```sh
lake exe cache get
python3 scripts/verify.py
python3 scripts/check_numeric.py
```

The toolchain is Lean v4.21.0. The Lake lockfile pins Mathlib v4.21.0 at commit `308445d7985027f538e281e18df29ca16ede2ba3` and pins its transitive dependencies. The verifier checks the source hashes and dependency revisions, builds all bundled Lean modules in an empty temporary directory, and compares Lean's axiom reports with [the declared expectations](provenance/axioms_expected.json). To use an already downloaded cache prepared for the same lockfile, supply `--packages /path/to/.lake/packages`. Use `--jobs 1` for a sequential build.

The second Python command independently replays the three binary normalizations and all seven strict
product comparisons with exact rational arithmetic. It reads the shipped Lean sources directly and
needs only the Python standard library.

### Optional H146 replay

The two original exhaustive drivers use only the Python 3.9+ standard library.
Run them from the package directory:

```sh
python3 -B evidence/h146/check.py
python3 -B evidence/h146/check_independent.py
```

Both print JSON. The first enumerates cofactors directly. The second enumerates
exact first-run strata and checks its result against the first driver's expected receipt.
Each checks 4,194,303 cofactors and records maximum 166, first attained at cofactor 3,798,656.
The package checksums pin both drivers and their expected outputs.
[First receipt](evidence/h146/RECIBO.json) · [Independent receipt](evidence/h146/RECIBO_INDEPENDIENTE.json)


The package works independently of the rest of the repository. [Source manifest](provenance/lean_sources.json) · [Build and numeric receipt](provenance/verification.json) · [Checksums](SHA256SUMS)
