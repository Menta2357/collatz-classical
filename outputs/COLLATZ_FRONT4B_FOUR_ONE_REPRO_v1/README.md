# Front4b after valuation four, a short run of twos and a one

The physical tail from the E1 entry starts with the two weak blocks
$(L,b)=(3,2),(3,1)$, then $4,2^r,1$. The five residual classes are
$r=0,1,2$ in E1 row 3 and $r=0,1$ in row 5. In every theorem, the
original seed is $N$. The first state of the final valuation-one edge
is $U$. Theorems concerning captures retain a separate physical source
and independent book for $w<N$.

## One repeatable rule in all five classes

Both row theorems have $U<3N$ and return a paid outcome or a reachable
cut $V\le U$ outside the supported renewal pattern. The supported
segments are one valuation one followed by at least two twos, with
optional single-dose $(1,2)$ expansions immediately before such a
segment. Each complete unpaid segment lowers actual height. Strong
exits and sufficiently long runs of twos pay. Strict height reduction
and the exact original history support well-founded recursion. If the
renewal pattern persists, it must pay. [Lean](lean/Front4bOneTwoRenewal.lean) · [Proof and replays](paper/renewal.md)

The two-block comparison is exact. The valuations $(1,2,1,2,2)$ give
$256Z=243U+319$. By contrast, two standalone $(1,2)$ expansions can occur
in all five cylinders and increase height. A frontier cut records
these changes of pattern, including when its first two valuations
differ from $(1,2)$.

## Other certified outcomes

| Domain | Results |
| --- | --- |
| Row 3, $r=0,1$ | A real run of $H$ ones and a terminal valuation $a$ forces payment or a smaller admitted A2 pivot under the proved price condition $3\cdot3^{H+1}\le2\cdot2^{H+a}$. This covers $H=1,a\ge3$. Three physical continuation families have smaller pivots or payment. [Exact domains](paper/row3_r01.md) |
| Row 3, $r=2$ | Every real maximal run of ones from $U$ with terminal valuation $\ge3$ admits a paid half-source. Several longer exits after rupture 2 pay or cross below the indicated old or new pivot. [Exact domains](paper/row3_r2.md) |
| Row 5, $r=0,1$ | With exactly one new valuation one, the subsequent strong edge descends or crosses below the old pivot. Readmission through an actual weak pair gives a lower **cofactor** iff its new ones run has length at least 4. [Exact domains](paper/row5.md) |

## Height obstruction for a different weak pattern

After the first known one, the state $R$ satisfies $R>2N+1$ in all five
classes. While it continues in the weak pattern $1^L,2,b$, with
$L\ge2$, $b=1,2$, all odd checkpoints stay above that window.
This applies even when their cofactors decrease. The ChatGPT audit
motivated the barrier. The exact replay verifies its physical examples,
and Lean certifies the inequality for all five classes and every
physical weak continuation. [Lean barrier](lean/Front4bAfterOneBarrier.lean)

The full five-cylinder closure remains open. Consecutive standalone
$(1,2)$ expansions, strictly weak continuations outside the height
window, and other valuations at the renewal frontier require another
payment or a producer that continues a certified decreasing rank. An
A2 readmission is recorded against its actual pivot and is not used as
a decrease of the weak cofactor.

## Reproduction

Use Lean 4.21.0 and keep the seven earlier Front4b packages beside this
directory. The verifier accepts overrides for each directory.

    python3 scripts/verify.py --jobs 2
    python3 -B paper/check_renewals.py
    python3 -B paper/check_row3_r01.py
    python3 -B paper/check_row3_r2.py
    python3 -B paper/check_row5.py

[Clean reproduction receipt](provenance/reproduction.json).
