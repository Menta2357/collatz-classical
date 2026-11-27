# Separated repeats at constant run length two

This is a paper result from the ChatGPT thread “Collatz: escape sin descenso”.
The directed witness below was independently replayed. In this subchannel
each initial and following one-run has length two, so $J_i=8Q_i-1$
with $Q_i$ odd. For each actual episode $(1,1,2,b)$,
$$2^{4+b}Q_{i+1}=81Q_i+c_b,\qquad c_1=3,\quad c_2=7.$$
Consequently $Q_i$ strictly increases.

If the same word $w$ of $k$ episodes occurs at $i<j$, let $E(w)$
be the sum of the episode valuation totals $4+b$. Subtract the two
exact affine identities. Their common additive term cancels, and the
difference of their terminal cofactors is even. This gives
$$2^{E(w)+1}\mid Q_j-Q_i,\qquad Q_j-Q_i\ge 2^{E(w)+1}.$$
Only the two occurrences in the same trajectory enter this comparison.
For $E_{i,j}$ the actual sum between the occurrences, the affine
envelope gives
$$2^{E(w)+1}\le
\bigl(81^{j-i}2^{-E_{i,j}}-1\bigr)(Q_i+7/17).$$
Indeed $c_b\le(81-2^{4+b})(7/17)$ at both values of $b$.

In an infinite continuation of this particular subchannel,
$Q_j+7/17\le(81/32)^j(Q_0+7/17)$. Since $(81/32)^7<2^{10}$,
for every sufficiently large $k$ and
$j\le\lfloor7k/2\rfloor$ one has $Q_j-Q_0<2^{5k+1}$.
But $E(w)\ge5k$. Hence the words of length $k$ starting at
positions $0,\ldots,\lfloor7k/2\rfloor$ are all distinct. Such a
continuation must have at least $\lfloor7k/2\rfloor+1$ distinct
words of length $k$ for large $k$, with the threshold depending on
the original entry cofactor. This necessary condition excludes
low-complexity aperiodicity in the constant-length subchannel.
Higher complexity and changing lengths remain possible under this
bound.

The exact arithmetic witness uses $u=18+32\cdot175094053$ and
$b=(1,2,1,1,2)$. The two occurrences of $(1,2)$ start at positions
0 and 3. The test checks $\nu_2(Q_3-Q_0)=13\ge12$, the exact
physical episode lengths and valuations, and the original book
$(85,129,278494448288432869329185530758089506552883)$.
