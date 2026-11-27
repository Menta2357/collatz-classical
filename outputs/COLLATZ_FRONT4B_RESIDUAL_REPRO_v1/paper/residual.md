# Bounds and physical obstructions in the aperiodic residue

## A fixed count of breaks has a finite horizon

If $x$ follows $r$ exact valuations one and ends at $y$, then
$2^r(y+1)=3^r(x+1)$. Since $3^r$ is odd, $2^r$ divides $x+1$.
It follows that $y+1\le2^r(x+1)\le(x+1)^2$.
A real edge of valuation at least two does not increase the shifted height.
Divide a source with $h$ breaks into its $h+1$ runs of ones, including
empty runs when necessary. Its terminal satisfies $X+1\le(w+1)^{2^{h+1}}$,
independently of the positions and magnitudes of those breaks. A paid
source has $w+1\le N$. The weak height bound from the same $J$ gives
$(81/64)^k(J+1)\le X+1$ after $k$ episodes. Combining these inequalities
and $N\le J$ yields the stated price. For any fixed $N$ and a growing
terminal index, this rules out a fixed bound on the number of source
breaks. It does not guarantee that a source with more breaks exists.

## A finite threshold for the number of distinct words

In the constant-length-two subchannel use $R(Q)=17Q+7$.
If $R(Q_0)<2^h$, the Lean interval envelope gives
$R(Q_j)<2^{11\lfloor j/8\rfloor+2(j\bmod8)+h}$, since eight
steps multiply $R$ by less than $2^{11}$ and each step by less than $4$.
For $k\ge16(h+14)$ and $j\le\lfloor7k/2\rfloor$ this is below
or equal to $2^{5k}$, whereas a repetition of a word of length $k$
requires a cofactor gap at least $2^{5k+1}$. Thus all the words of
length $k$ beginning at these first $\lfloor7k/2\rfloor+1$ positions
are distinct, provided the trajectory remains in this subchannel long
enough to read them. The threshold is a paper consequence of the Lean
inequality. The independent [replay](check_separation.py) verifies
sharp witnesses in both equal and unequal ending lengths from the
same original seed in each witness.

## Why reserve minus logarithmic debt fails

Use $u=74930$ in the original $c=3$ E1 band and define
$\delta_j=(2^{S_j}/3^j)(J_j-N)$. On a physical weak edge or block with
multiplicative factors $A=3^r$, $D=2^d$ and additive $B$, one has
$\delta_{j+r}-\delta_j=(2^{S_j}/3^j)(B+N(A-D))/A$.
For weak episodes this is strictly positive.

The exact transitions $(L,b)=(2,1),(2,2)$ both reenter with next run
length two. On the first transition the cofactor grows, the valuation
$\nu_2(17J_j+73)$ increases from 5 to 10 and both debts lie strictly
between $N/2$ and $N$. The proposed rank
$\nu_2(17J_j+73)-\lfloor\log_2(\delta_j/N)\rfloor$ increases by five.
The original clocks are $(65,102)$ and $(69,107)$ and the additive
is composed across the transition.

## Different words can impose an offset congruence

Consider two windows with the same initial clocks $(r,d)$ but different
additives $C_1,C_2$, followed by a shared physical suffix with clocks
$(R,D)$ and a common additive. If the starting checkpoints are $J_i,J_j$,
then
$$
2^{d+D}(X_j-X_i)=3^R\bigl(3^r(J_j-J_i)+C_2-C_1\bigr).
$$
The terminals are odd, so the expression in parentheses is divisible by
$2^{d+D+1}$. This is a paper extension of the exact-repeat test.
For the $c=3$ parameter $t=1023237697126061829$, the two successive
prefixes are $((2,1),(3,2))$ and $((2,2),(3,1))$, in $(L,b)$ notation.
They have clocks $(9,12)$ and costs $25003,32267$. Each is followed by
$((2,2),(4,1),(3,1))$, which spends 19 divisions. The gap between the
starting checkpoints is congruent to $3414720480$ modulo $2^{32}$.
The shifted expression has valuation 36. These claims and both absolute
physical books are replayed by [the exact checker](check_witnesses.py).
No result here guarantees that such windows must recur on every
fixed trajectory.

## Ternary refinement

The ChatGPT thread “Collatz: sinergia UV93–Chang” proposed transporting
the full ternary residue through a word. The physical book directly
gives $2^d X\equiv C\pmod{3^r}$. The sharp shifted bound provides the
height test used in Lean. Since $2^d$ is a unit modulo $3^r$, a physical
terminal passing the height test is the unique residue in $[0,3^r)$.
For a fixed entry, the clock condition holds for all sufficiently long
weak words that occur, since each episode contributes at least five
divisions. The refinement has no pointwise activation implication
without a further estimate on the residues or a new capture.

## A short weak exit with a paid descent

The Codex thread “Front4b” identified the short itinerary
$(1,1,1,2,2,1,1,1,2,1)$, whose local book is $(10,13,84217)$.
The full local book after a real next valuation $c$ is
$(11,13+c,260843)$. For a start $J$ in the c=5 E1 row,
$J<2N+1$ and $N\ge2$, so $2^{13+c}N>177147J+260843$
as soon as $c\ge6$. For the c=3 row, the inherited bound
$J<4N+3$ still gives the strict inequality for $c\ge7$
because $N\ge2$. In either case, the same original $N$
is the descent threshold.

The explicit c=5 progression with $t=42784+2^{18}h$ in that
row realizes the itinerary and the exit $c=7$. In Lean, compiling
the word at $h=0$ and translating its exact valuation cylinder
prove the histories on the whole progression. At return 71 the
cofactor has grown, the length-three reserve is exact again, and
the state is above $2N+1$. At return 77 the state is below the
original $N$. This closes that progression, with the two independent
original prefixes verified at clocks $(71,111)$ and $(77,124)$.
Which valuation occurs after the two blocks on an arbitrary fixed
seed remains a separate question.

## The reduced denominator of the accumulated centre

The ChatGPT thread “Collatz: escape sin descenso” proposed measuring
the denominator of the rational centre of the complete word. For a
nonempty physical weak word with book $(r,d,B)$, write $A=3^r$ and
$D=2^d$. Each weak episode has numerator factor larger than denominator
factor, so $A>D$, and the exact additive $B$ and $A-D$ are odd and
positive. The optimal local envelope gives $17B\le73(A-D)$ for the
whole word by substituting $DX=AJ+B$.

Write $B/(A-D)=a/q$ in lowest terms. Both $a$ and $q$ are positive and
odd. The exact book gives $D(qX+a)=A(qJ+a)$. Since $qX+a$ is even and
$A$ is odd, $2^{d+1}$ divides the positive integer $qJ+a$. Thus
$$17\cdot2^{d+1}\le q(17J+73).$$
This is a necessary lower bound, for the same entry $J$ and physical
clock, even when the word does not repeat. A hypothetical infinite
weak tail from fixed $J$ requires exponential denominator growth.
This does not give an upper bound on $q$.

The [checker](check_witnesses.py) replays eight weak blocks on the
original $c=3$ seed parameter $t=213485686413061$ with strictly
growing cofactors. The measured denominator is $2\,723\,875\,642\,187\,063$,
larger than the least common multiple $17\,147\,305$ of the four
local denominators for $L=2,3$ and $b=1,2$. This refutes using that
least common multiple as an upper bound on the accumulated denominator.
The exact global book in the witness ends at odd return 101, with
150 divisions and the additive carried from the same $N$.
