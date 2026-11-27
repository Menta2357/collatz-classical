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

The [seven explicit rows](lean/Terras90FinalNumeric.lean) are Q0+Q1, 3Q1, 4Q1, J, J+Q1, J+2Q1, and 2J, where J is the last clock defined in [Terras88](lean/Terras88.lean). The package checks the complete chain from physical admission to these rows and their exclusions. This includes the ordinary local and sorted-rank bounds, logarithm brackets, reciprocal budget, lattice enumeration, the earlier price and rank comparisons, and the seven final strict products. The ordinary bounds and logarithm brackets are proved inside the package.

## External premises

- `Terras90Physical.RhinBound` supplies the uniform bound `k^(-13.3) ≤ k log(2) − d log(3)` for natural `2 ≤ k`, `d ≤ k`, and positive logarithmic difference. The exponent and factor one are part of the Lean definition. [Cutoff and exact premise](lean/Terras90PhysicalCutoff.lean)
- The five-run and six-run capacities at heights 92 and 146 bound `2^d ≤ 6^height` for positive odd starts `x` with `x+1 < 2^height` and the specified number of odd runs in a physical prefix. The final theorem takes the two five-run capacities for the earlier 89-run branch and the two six-run capacities for the 90-run branch. [Five-run definition](lean/Terras89.lean) · [Six-run definition](lean/Terras90.lean)
- `Terras88.Inputs` supplies descent through the finite verified height and through 87 runs, plus the 88-run equality, clock, rank, exclusion and no-window facts. `Terras89.Inputs89` supplies the separate 89-run reduction and rank input. The standalone 90-run theorem uses a Q0 Weaver no-window premise for the same `N,k`, at height `2^146-1` and span 5. The at-most-90 theorem draws that premise from `Terras88.Inputs.noWeaverQ0`. [Earlier 88-run inputs and window definition](lean/Terras88.lean) · [Earlier 89-run inputs](lean/Terras89.lean)
- `Terras90Final.NoEqual90` supplies `orbit N k ≠ N` at first contractions above the verified height with exactly 90 odd runs, for the same `N,k`. This separate premise turns the weak endpoint bound into strict descent. [Final theorem and equality premise](lean/Terras90Final.lean)

All these external premises remain arguments of Lean theorems. The certificate takes the physical first contraction and the odd-run bound as hypotheses.

## Sources for the external premises

- The finite-source statement through `28,000,000,000,000,000,000` comes from Rozier and Terracol, Corollary 5.4. Their Proposition 6.3 records Rhin's logarithmic-form estimate. [Rozier–Terracol, v5, Corollary 5.4](https://arxiv.org/pdf/2502.00948v5#page=17) · [Proposition 6.3](https://arxiv.org/pdf/2502.00948v5#page=19)
- Weaver's ranked-path argument and exhaustive window queries give the context and the computational evidence for the earlier no-window inputs. The Q0 window corresponds to the first query. [Weaver, v1, Sections 5–6](https://rstation.ai/problems/collatz/papers/143)
- Freelan Lab reports universal five- and seven-run bounds relevant to the height capacities. The Lean theorem uses the stated capacity propositions. [Freelan Lab, v1](https://rstation.ai/problems/collatz/papers/206) · [Version 1 computation supplement](https://rstation.ai/api/v1/papers/collatz_206/versions/1/supplement)
- Hercher's nontrivial-cycle exclusion through 91 local minima, with its published correction, is relevant to the same-seed equality premise. The package keeps the application to a return at first contraction explicit as `NoEqual90`. [Hercher, article 23.3.5](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/hercher5.html) · [Corrigendum](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/corrigendum.pdf)

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

The package works independently of the rest of the repository. [Source manifest](provenance/lean_sources.json) · [Build and numeric receipt](provenance/verification.json) · [Checksums](SHA256SUMS)
