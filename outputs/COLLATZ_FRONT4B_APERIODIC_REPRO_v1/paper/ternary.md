# Ternary labels and the audit of the proposed activation rule

A review in the ChatGPT thread «Collatz: sinergia UV93–Chang» supplied
the following normalized residues. If $Q'$ is the cofactor after a
genuine weak episode and $H$ its next run length, then

- for $b=1$, $Q'/3$ is not divisible by three and
  $2^{H+3}(Q'/3)\equiv1\pmod{3^{L+1}}$;
- for $b=2$, $Q'$ is not divisible by three and
  $2^{H+4}Q'\equiv7\pmod{3^{L+2}}$.

These follow from the exact equation
$2^{H+b+2}Q'=3^{L+2}Q+2^{b+1}-1$. The Lean module verifies both
residues and retains the physical original book. [Lean](../lean/Front4bTernarySwitch.lean)

The reported example at $u=1599250$ does certify a growing $1\to0$
label change in its second block. Its fourth cofactor is smaller than
the third because the final length is three. The arithmetic checker
replays that example and separately constructs a schedule in each
actual E1 band with four successive cofactor increases and labels
$1,0,1,0$. The Lean theorem changeCanGrow handles the exact two-block
pattern $(L,b)=(2,1),(2,2)$ with next length two. This pattern is
physically realizable in both bands by the previous finite-schedule
theorem. These results refute a decreasing ternary-label rule at the
specified switch and leave open an invariant with additional history.

## Sources restricted to valuations 1 and 2

Given an odd target $Z$, the congruence $2^aZ\equiv1\pmod3$ permits
at most one of $a=1,2$. For the original entries the reverse sequences
are $(2,1,1,2,2,2)$ and $(2,2,1,1,2,2,2)$. Each prefix predecessor is
above the same $N$ across its entire affine band. The last predecessor
is a multiple of three, so the chain has no further edge. The kernel
proof verifies both lists and extends the obstruction through arbitrary
weak episodes, including interior odd checkpoints.
[Lean](../lean/Front4bSmallSource.lean)
