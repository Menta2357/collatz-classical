# A2–Front4b first crossing and partial row coverage

This package proves a classification on the Front4b row \(u\equiv2\pmod8\). The original odd seed \(N\), the pivot \(V\), and the exact accumulated additive term are fixed throughout.

\[
\begin{aligned}
N &= 1156359581173680383779426258047+2^{100}u,\\
V &= 1392102202856011511751362094175+4\cdot3^{62}u,\\
V &= T^{62}(N),\\
2^{98}V &=3^{62}N+2417122598839266567112547605177.
\end{aligned}
\]

Here \(T\) counts one return from an odd integer to the next odd integer. A separate shortcut clock counts each division by two once. At any retained endpoint \(X\), the exact integer identity \(2^S X=3^jN+B\) recovers \(g_jX=N+C_j\) with \(g_j=2^S/3^j\) and \(C_j=B/3^j\). The A2 clock bridge converts a first strict shortcut crossing below the current pivot to the first strict odd crossing. It keeps the count of odd transitions, the exact terminal parity, and the additive term for the prefix from the original seed. The conditional consumer takes an actual first crossing as input. [A2 clock bridge](lean/A2ShortcutClock.lean)

| Class of \(u\) | Certified outcome |
| --- | --- |
| \(26\pmod{32}\), \(106\pmod{128}\), \(42\pmod{256}\) | Direct descent below \(N\) on the entire class, at odd return 66, 67, or 68, respectively. [Even and high bands](lean/Front4bRowEven.lean) |
| \(2\pmod{128}\), \(74\pmod{256}\), \(426\pmod{1024}\) | Direct descent below \(N\) at odd return 67, 68, or 69, respectively. The corresponding final valuations are only bounded below by 4, 3, and 3. [Strong odd bands](lean/Front4bRowOdd.lean) |
| \(66\pmod{128}\) | Physical coalescence at odd return 67 with a positive odd source \(w<N\) whose own clock records one odd return. Arrival at 1 follows under induction on the smaller source. [Capture](lean/Front4bRowOdd.lean) |
| \(170\pmod{256}\) | The word \((1,1,2,2,2)\) reaches \(X=(243V+283)/256\) with \(N<X<V\) and records the first strict crossing below \(V\), after five odd returns or eight shortcut steps. The A2 consumer gives a paid outcome or an admitted **ambient A2** pivot of strictly smaller rank \(x-N\), with an exact segment from \(N\). [First crossing at reserve 7](lean/Front4bRowC7.lean) |

The Lean classification covers all 128 residues of the row modulo 1024. The seven direct classes above comprise 65 residues. The reserve-7 branch contributes three further residues with the ambient A2 alternative. Four weak classes comprise the other 60 residues. [Exhaustive classification and counts](lean/Front4bRowCoverage.lean)

| Weak case | Outstanding class of \(u\) |
| --- | --- |
| \(c=3,e=1\) | \(18\pmod{32}\) |
| \(c=3,e=2\) | \(34\pmod{64}\) |
| \(c=5,e=1\) | \(10\pmod{128}\) |
| \(c=5,e=2\) | \(202\pmod{256}\) |

Whole-row termination remains open. The reserve-7 consumer supplies admission to the ambient A2 domain. Iterating the reduction would require showing that every produced unpaid pivot activates a further decreasing transition. The paper analysis of the four weak classes excludes smaller positive odd sources at depths 1–10 to their first weak terminals and leaves later terminals and deeper sources open. A separate family of varying seeds rules out a uniform finite horizon for direct descent across the entire row. [Paper derivation](paper/RESULTADO.md) · [Bounded inverse calculation](paper/INVERSAS.md)

## Reproduce

Use Python 3 and the Lean 4.21.0 toolchain through `elan`. The source bundle uses only Lean's standard library. The rebuild starts in an empty temporary directory and audits the exact signed declaration set, including the classification and the three counts. Each Lean invocation uses one thread.

```sh
python3 -B scripts/verify.py
python3 -B paper/verificar.py
python3 -BO paper/verificar.py
python3 -B paper/verificar_inversas.py
python3 -BO paper/verificar_inversas.py
```

The Lean verification checks all distributed hashes, rebuilds the 47 source modules reachable from the five audited roots, and compares the exact axiom sets for 29 declarations. Frozen parent and original object hashes supply provenance. The verification rebuilds its own objects from the bundled source. [Lean source manifest](provenance/manifest.json) · [Normalized source receipts](provenance/source_receipts.json) · [Expected axiom sets](provenance/axioms_expected.json) · [Clean rebuild and audit receipt](provenance/verification.json)
