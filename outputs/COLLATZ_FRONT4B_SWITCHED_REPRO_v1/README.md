# Changes of weak Front4b episodes with growing cofactors

A weak episode is a physical block $1^L,2,b$, where $L\ge2$ and $b\in\{1,2\}$.
Its local book from $J$ to $Z$ is $(L+2,L+b+2,3^{L+2}-2^{L+1})$.
The starting bands are $u\equiv18\pmod{32}$ and $u\equiv10\pmod{128}$.

## Lean results

- **A fixed period has finitely many repetitions.** The period can be any
  nonempty fixed list of lengths and tail choices. If $(r,s,B)$ is its
  composed physical book, $2^{sn}$ divides the positive integer
  $(3^r-2^s)J_0+B$ after $n$ copies. This excludes an infinite ultimately
  periodic weak-block suffix for a fixed seed. The proof preserves the
  original physical book. [Periodic proof and example](paper/period.md)
- **Exact reserve at a switch.** When the old length is $P$ and the new
  one is $L\ne P$, the old reserve has exactly $\min(P,L)+1$ factors of
  two. At a tail change with $P=L$, it has exactly $L+3$. The physical
  history still starts at $N$. [Lean switch theorem](lean/Front4bSwitchReserve.lean)
- **Capture after either switch.** Both directions of tail change can
  reuse the earlier paid certificates with their actual price bounds.
  A further criterion applies when a physical checkpoint $X$ lies in
  $3N<X<4N$ and the next valuation is exactly 3. The odd source
  $(X-1)/4<N$ reaches the same terminal in one return. The terminal
  is above $N$. [Capture proof and realizations](paper/capture.md)
- **Finite switched itineraries.** Every finite legal schedule realizes
  in both bands. Arbitrarily long prefixes can change length and tail
  with strict cofactor growth. The proof records both clocks, the
  exact additive and height comparisons against the same original $N$.
  [Finite itineraries](paper/finite_itineraries.md)

The Front4b thread identified a price obstruction that is now verified
in Lean. Surviving weak episodes multiply the shifted height by at least
$81/64$. The initial $c=5$ half-source price window expires after two
such episodes, and the initial $c=3$ quarter-source window expires after
three. A later payment requires a newly priced source or a different
physical continuation.

## Remaining obligation

The new reserve at a real switch can grow arbitrarily large across the
starting seeds, even with strictly growing cofactors. The
[recharge calculation](paper/switch_reserve.md) derives this from finite
realization and periodic divisibility. The remaining obligation is to
force payment, descent or a common rank decrease on a genuinely
aperiodic continuation of one fixed seed. The finite constructions leave
that infinite behavior undecided.

## Reproduction

Use Lean 4.21.0 with Std. Keep the published row, guard and weak-tail
packages as siblings or pass their paths with --row, --guards and --weak.

    python3 scripts/verify.py --jobs 1
    python3 -B paper/check_capture.py
    python3 -B paper/check_switch.py

Set FRONT4B_ROW_PAPER if the capture verifier's row sources are outside
the default location.
