# Scope of the low-exit certificates

## Exact two-block exit with the original seed

The physical prefix from the E1 checkpoint $J$ has book
$(10,13,84217)$. With next valuation $a$, the terminal $Y$ satisfies
$$2^{13+a}Y=177147J+260843.$$
Use the actual affine definitions of $J$ and $N$ in the two rows.
At $a=5$, $Y$ is strictly above $N$ and $2Y<3N+1$.
Reducing the real last edge modulo 3 gives $Y\equiv2\pmod3$.
Thus $0<w=(2Y-1)/3<N$ is odd and $3w+1=2Y$ gives a physical
one-return source. One original and one source book meet at $Y$.
At every $a\ge6$ strict descent follows by the exact affine price.
This closes every exit with $a\ge5$ for this word in both rows, including
the previously untreated valuation 5.
[Lean proof](../lean/Front4bShortExitFiveSix.lean)

## Lower exits and readmission

The length of a maximal run of twos from an odd state $Y>1$ with
$Y-1=2^kq$, $q$ odd, is $r=\lfloor(k-1)/2\rfloor$. Its endpoint
$U$ satisfies $4^r(U-1)=3^r(Y-1)$. If $k$ is odd the next valuation
is one. If $k$ is even it is at least three. The certified consumers
retain the history before the full run and carry the actual last clock.
The arithmetic price tests and the surviving short odd-reserve classes
are independently verified in [the low-exit audit](low_exit.md).

For $a=1$, the readmission cut is the state before its new ones run.
For $a=2$, it is the state after the edge of valuation two.
Both comparisons use the original odd cofactor of the length-three entry.
Reaching a suitable numerical phase is insufficient for an actual weak
episode. The maximal run must also be followed by the physical pair
$(2,b)$, with $b=1$ or $2$, and the full book must remain tied to $N$.
The directed witnesses exercise both larger and smaller cofactor cases.
[Readmission proof](../lean/Front4bShortReentry.lean)

## Joint binary and ternary filter

The ChatGPT thread “Collatz: sinergia UV93–Chang” proposed applying
a past ternary constraint and a future binary constraint to the same
intermediate cofactor. For two physical weak episodes with lengths
$L,H$ and tails $b,c$, followed by run length $K$, these constraints are
$$
q_1\equiv (2^{b+1}-1)2^{-(H+b+2)} \pmod{3^{L+2}},
$$
$$
q_1\equiv (2^{K+c+2}-(2^{c+1}-1))3^{-(H+2)} \pmod{2^{K+c+3}}.
$$
Both follow by reducing the exact books. The least positive representative
of their joint class must be below or equal to the allowable upper
cofactor from the height envelope. A physical witness with
$(L,b)=(2,1)$, $(H,c)=(3,2)$ and $K=2$ has
$q_1\equiv6051\pmod{10368}$. Its actual cofactor attains the integer upper
bound and both transitions increase the cofactor. Thus the filter can
reject a proposed phase but does not force an exit by itself.
[Exact same-seed replay](check_net_cofactor.py)

## Remaining implication

For each fixed original seed in the residual, the proof must supply an
actual paid encounter, strict descent, or an admitted sequence of rank
drops that cannot keep regenerating the rank. Low valuations and mixed
weak words may still evade the listed guards. The net comparator, even
with the full additive term, does not establish that every remaining
trajectory eventually activates it.
