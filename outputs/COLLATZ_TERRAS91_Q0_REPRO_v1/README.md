# First descent at the Q0 clock with 91 odd runs

The Lean theorem [`Terras91Q0.firstDescentAtQ0`](lean/Terras91Q0.lean) concerns the shortcut Collatz map. For a seed \(N\ge2\), suppose its first strict coefficient contraction occurs at the Q0 clock

\[
(k,d)=(630118245525664765,397560349370386783)
\]

with exactly 91 maximal odd runs. Under the source inputs below, the theorem gives strict descent at that step, the absence of any earlier strict descent, and the exact additive identity for the original seed and prefix. This is a proof for the indicated clock. Extending the theorem to all 91-run clocks requires a separate sieve and their exclusions.

The key transfer uses an ordinary first-hit delay of at most 2480 for every seed through \(L=46645791847966786687\). Compression gives an earlier shortcut hit for any such seed. Since the Q0 clock is much later, every valley in its first-crossing prefix exceeds \(L\). If the seventh sorted valley were at least Weaver's price \(P=453027402666008300866\), the product remaining after one discount would be bounded using 5 factors at \(L+1\), 4 at \(P\), 1 at \(2^{92}-1\), and 80 at \(2^{146}-1\). The exact comparison contradicts a positive displacement. The seventh valley therefore lies below \(P\). All chronology is recovered from the real valley dates before applying Weaver's existing five-block exclusion. Equality at the endpoint is handled by Hercher's cycle theorem.

## Source inputs

- The confirmed ordinary delay record is an input on the entire stated seed interval. The local literal replay reproduced 2480 ordinary steps for the record seed itself. [Weaver 224, Section 3](https://rstation.ai/problems/collatz/papers/224) · [Roosendaal's confirmation rule](https://www.ericr.nl/wondrous/delrecs.html) · [Record list](https://www.ericr.nl/wondrous/delays.txt)
- The Q0 five-block window exclusion is the same one consumed by the Terras 90 package. [Weaver 143, Sections 5–6](https://rstation.ai/problems/collatz/papers/143/v1)
- The equality case consumes the corrected exclusion of nontrivial cycles with at most 91 local minima. [Hercher 2023](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/hercher5.html) · [Corrigendum](https://cs.uwaterloo.ca/journals/JIS/VOL26/Hercher/corrigendum.pdf)
- The height floors use the same six-run capacities H92 and H146 as Terras 90. The inputs are Freelan Lab's universal rows and the guarded H146 finite replay documented in the base package. [Freelan Lab](https://rstation.ai/problems/collatz/papers/206)

## Reproduction

From this directory run `python3 scripts/verify.py`. It expects the pinned `COLLATZ_TERRAS90_REPRO_v2` directory next to it. Pass `--base /path/to/COLLATZ_TERRAS90_REPRO_v2` if located elsewhere. It rebuilds 21 project modules from source in an empty temporary directory with Lean v4.21.0 and the Lean standard library. It checks the dependency hashes and audits the 11 declarations in the four Q0 modules. Each Lean build uses one thread. Use `--jobs 1` for sequential reproducibility.

[Source manifest](provenance/manifest.json) · [Axiom expectations](provenance/axioms_expected.json) · [Fresh build receipt](provenance/verification.json) · [Independent arithmetic receipt](provenance/arithmetic.json)
