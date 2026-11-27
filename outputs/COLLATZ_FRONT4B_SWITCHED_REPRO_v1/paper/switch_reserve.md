# Exact reserve of an abandoned mode and unbounded recharge

Write $D=2^{L+b+2}$, $A=3^{L+2}$ and $c_b=2^{b+1}-1$.
The reserve $F_{L,b}(J)=(A-D)(J+1)+2^{L+1}c_b$ equals
$(A-D)J+B$, where $B=A-2^{L+1}$ is the physical local additive.

At the actual new run, $J+1=2^{L+1}Q$ with $Q$ odd. For an abandoned
length $P\ne L$, the summands in $F_{P,\mathrm{old}}(J)$ have unequal
exact powers of two. Their minimum is $\min(P,L)+1$. If the lengths
agree and the tail changes, dividing the abandoned reserve by $2^{L+1}$
leaves a number congruent to $c_{\mathrm{old}}-c_{\mathrm{new}}\equiv4
\pmod8$ by the new weak pair's cofactor equation. The abandoned
reserve has exactly $L+3$ factors. [Lean proof](../lean/Front4bSwitchReserve.lean)

Prescribe an initial mode $(2,1)$ followed by $n$ copies of $(2,2)$
and a final length of two. At the first switch, the old reserve has
exactly five factors of two while the new reserve is divisible by
$2^{6n}$. Cofactors grow at every transition. Alternatively use an
initial $(2,1)$ and $n$ copies of $(3,2)$, finishing with length three.
The first switch leaves three factors in the old reserve, with at
least $7n$ in the new reserve. The transition $2\to3$ with $b=1$
satisfies $64<81$ and subsequent $3\to3$ transitions with $b=2$
satisfy $128<243$, so the cofactor grows here as well.

These constructions hold for each finite $n$ in each original band.
The starting seed has a finite divisibility budget for any fixed
period. Across the starting seeds, an upper bound on the abandoned
reserve alone gives no uniform bound on the new one.
