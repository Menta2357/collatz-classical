# Repeated weak pairs can increase the cofactor

This paper argument uses the same initial `J = 8(A+a t)-1` in either
Front4b row, with `a` odd. Fix `b` in {1,2} and impose the physical block
`(1,1,2,b)` repeatedly. Write `D = 2^(b+4)` and `c = 2^(b+1)-1`.
At successive starts `J_i = 8 Q_i - 1`, the exact rule is

[
D Q_{i+1}=81Q_i+c.
]

Conversely, positive odd (Q_i,Q_{i+1}) satisfying the equation give the
specified physical block by `Front4bWeakRealization.weakRankOfFactors).
In particular, each new one-run has length exactly two.

For any finite (nge1), let (C_0=0) and (C_{i+1}=81C_i+cD^i).
Set (Q_0=A+a t). Choose (tge0) by the congruence
[
81^n Q_0+C_nequiv D^n pmod{2D^n}.
]
The coefficient (81^n a) is odd, so the congruence is solvable.
Define (Q_i=(81^i Q_0+C_i)/D^i).
For every (ile n), the identity
(C_n=81^{n-i}C_i+D^i C_{n-i}) shows that
(D^i) divides (81^{n-i}(81^i Q_0+C_i)).
Since (81) is odd, (Q_i) is an integer. It is positive.
The recurrence gives oddness for (i<n) because (D) is even and
(c) is odd. The defining congruence gives oddness at (i=n).

As (81>D), each (Q_{i+1}>Q_i). The certified physical block stays at
or above (J_i), so no one of these (4n) odd returns is below the
original (J_0). These are realizations of arbitrarily long finite
prefixes on the specified row. The seed may depend on (n), and this
argument places no restriction on captures from a separate source.

## Fixed seed and the cost of repeating the block

The Lean theorem `fixedPhysicalRepeat` derives the opposite quantifier
direction for any one chosen seed. Let (M_i=(81-D)Q_i+c). The same
episode gives (D M_{i+1}=81 M_i), hence
(D^n M_n=81^n M_0). Because (81) is odd and (D) is a power of two,
(D^n) divides (M_0). This is a finite bound on repetitions from the
specified seed. With absolute initial book ((j,S,C)), each repeat
adds (4) odd returns, (4+b) shortcut steps, and local additive (73).
The new absolute additive after repeat (i+1) is
(81 C_i+2^{S+(4+b)i}73). The theorem leaves the later change of block
or length open. [Lean proof](../lean/Front4bFixedWeakRepeat.lean)
