# Aperiodic Front4b restrictions and paid-source certificates

The domain is the two E1 bands $u\equiv18\pmod{32}$ and
$u\equiv10\pmod{128}$. A weak episode is a genuine odd-return block
$1^L,2,b$ with $L\ge2$ and $b\in\{1,2\}$. The certificates retain the
original $N$, the number of odd returns, the sum of exact valuations
and the additive term.

## Verified results

- **One bound for arbitrary changes.** For a physical concatenation
  with book $(r,d,B)$ from $J$ to $Z$, Lean proves
  $2^d(17Z+73)\le3^r(17J+73)$. The affine shift $73/17$ is the sharp
  shared shift for this local inequality. It bounds the product of
  the next odd cofactor and the dyadic factor of its new run, including
  the prefix from $N$. [Optimal envelope](paper/envelope.md)
- **Exclusion of some aperiodic schedules.** Take blocks
  $A=[(2,2)]$ and $B=[(2,1),(3,2)]$, where each pair denotes $(L,b)$.
  On a completed run of $n$ copies of one block before switching, the
  abandoned reserve starts with exactly $d_a n+5$ factors of two.
  Comparing it with the actual preceding growth budget excludes
  unbounded completed-run excess, for example successive homogeneous
  run lengths $1,2,4,8,\ldots$. [Exact switch charge and scope](paper/run_budget.md)
- **All sources using only valuations 1 and 2 are excluded.**
  The unique such backward chain from either initial E1 checkpoint
  stops at a positive multiple of three before reaching a source
  smaller than $N$. Lean transports this obstruction to every odd
  checkpoint of every physical weak prefix of that same $N$.
  A paid source must use an edge of valuation at least 3.
  [Lean proof](lean/Front4bSmallSource.lean)
- **A paid construction with one high valuation.** The affine
  construction is formalized in Lean. For each prescribed finite weak
  itinerary there is an infinite subprogression of its physical
  seed cylinder with a paid source of the form $1^h,a$ to its terminal.
  The construction can depend on the itinerary and its affine
  parameter. The [capture report](paper/capture.md) details which
  part is the Lean certificate and which part applies it to a dyadic
  cylinder.
- **Exact ternary labels.** After $b=1$ the new cofactor has precisely
  one factor of three. After $b=2$ it has zero. Lean computes the finer
  residues and verifies that a label drop can coincide with strict
  cofactor growth. [Ternary audit](paper/ternary.md)

- **Separated repeats at constant length two (paper).** A repeat
  of a long word requires a minimum gap between the two entry
  cofactors of the same trajectory. This excludes continuations of
  sufficiently low word complexity. [Proof and witness](paper/collisions.md)

## Remaining implication

The upper bounds still permit aperiodic switching with shorter runs.
Positive-density or finite-cylinder estimates are unnecessary for the
certificates here. The capture subprogressions leave open whether the
orbit of each particular fixed $N$ passes through one of them or an
alternative payment, descent or decreasing-rank condition.

## Reproduction

Use Lean 4.21.0 with Std. Keep the previous row, guard, weak-tail and
switched packages beside this one, or pass their directories as
--row, --guards, --weak and --switched.

    python3 scripts/verify.py --jobs 1
    python3 -B paper/check_envelope.py
    python3 -B paper/check_sources_and_ternary.py
    python3 -B paper/check_capture.py

[Clean build and verification receipt](provenance/reproduction.json).
