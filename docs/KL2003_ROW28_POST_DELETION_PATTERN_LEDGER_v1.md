# KL2003 Row28 Post-Deletion Pattern Ledger v1

Date: 2026-07-13

Repository: `https://github.com/Menta2357/collatz-classical`

## Purpose

This note records the post-deletion row28/mod8 pattern needed for the remaining
`concretePhi_rowsV2` seam work.

It combines:

- the extracted Figure A1 graph;
- the deletion rule source audit;
- the final `T_2^8(EL)` formula and Table 4 coefficient ledger from
  `30apr02.tex`.

It is not a Lean proof and does not claim M1 or Collatz.

## Source Custody

TeX source:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
```

Hash:

```text
04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd  30apr02.tex
```

Line ranges:

```text
1760-1783: Figure A1 and final T_2^8(EL) nested inequality
1787-1845: Table 4 / L_2^EL coefficient ledger
```

Graph extraction:

```text
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/nodes.csv
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/edges.csv
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/root_paths.csv
```

## Normalized Final Row28 Formula

The final post-deletion row28 inequality has the following normalized shape:

```text
phi8(y) >= phi5(y - 2)
         + min( phi8(y + alpha - 3) + M1(y),
                phi2(y + alpha - 3) )

M1(y) := min( phi8(y + 2*alpha - 5) + M2(y),
              phi5(y + 2*alpha - 5) )

M2(y) := min( phi2(y + 3*alpha - 5),
              phi5(y + 3*alpha - 5),
              phi8(y + 3*alpha - 5) )
```

This is exactly the shape already represented in Lean by:

```text
M1V2 concretePhi y
M2V2 concretePhi y
I2ELAbstractRowsV2 concretePhi
```

with epsilon padding added at the seam-compatible V2 layer.

## Crossed Nodes And Deletion Meaning

From the extracted Figure A1 graph:

```text
N04 = (8, alpha - 1)      crossed yes
N05 = (8, 2*alpha - 3)    crossed yes
```

By the deletion rule, these nodes are not final leaves.  They are class-8
advanced nodes whose expanded descendants appear in the final post-deletion
tree.

Lean consequence:

```text
Do not prove row28/mod8 by adding parent population + descendant population.
Do prove it by following the post-deletion tree whose leaves are the surviving
terms in the normalized formula above.
```

This is the formal reason the direct-sum candidate was rejected.

## Normalized Table 4 Ledger For T_2^8(EL)

The row28 part of the `L_2^EL` ledger normalizes as follows.

Let:

```text
c22 = c_2^2
c25 = c_2^5
c28 = c_2^8
```

Auxiliary variables `a1`, `a2`, `a3` correspond to the post-deletion leaf
groups of Figure A1.

The normalized coefficient obligations are:

```text
row28_main:
  c28 <= c25 * lambda^(-2) + a1 * lambda^(alpha - 1)

row28_a1_to_class8:
  a1 * lambda^(alpha - 1)
    <= c28 * lambda^(alpha - 3) + a2 * lambda^(2*alpha - 3)

row28_a1_to_class2:
  a1 * lambda^(alpha - 1)
    <= c22 * lambda^(alpha - 3)

row28_a2_to_class8:
  a2 * lambda^(2*alpha - 3)
    <= c28 * lambda^(2*alpha - 5) + a3 * lambda^(3*alpha - 5)

row28_a2_to_class2:
  a2 * lambda^(2*alpha - 3)
    <= c22 * lambda^(2*alpha - 5)

row28_a3_to_class2:
  a3 * lambda^(3*alpha - 5)
    <= c22 * lambda^(3*alpha - 5)

row28_a3_to_class5:
  a3 * lambda^(3*alpha - 5)
    <= c25 * lambda^(3*alpha - 5)

row28_a3_to_class8:
  a3 * lambda^(3*alpha - 5)
    <= c28 * lambda^(3*alpha - 5)
```

Note: the TeX source has the known dimensional typo in the row labelled
`(8, 2*alpha - 5)`, writing an exponent with `lambda` where `alpha` is required.
The normalized ledger above uses `2*alpha - 3`, consistent with the surrounding
formula, the existing errata note, and the Lean V2 contract.

## Case-Tree Consequence For The Remaining Seam

The row28/mod8 seam should now be split as follows.

Already Lean-available or previously verified:

```text
s == 0: child class 2, direct monotonicity branch.
s == 1: parity-lift branch.
s == 2, next split class 5: single clean branch.
s == 2, next split class 2: sibling-sum branch.
```

Still requiring post-deletion member-wise realization:

```text
s == 2, repeated class-8 branch:
  follow the post-deletion tree from N04/N05 descendants,
  not the crossed parent nodes themselves.
```

The remaining member-wise constructor should therefore target the surviving
post-deletion leaves corresponding to:

```text
phi8(y + alpha - 3) + M1(y)
phi8(y + 2*alpha - 5) + M2(y)
M2(y) = min(phi2, phi5, phi8 at y + 3*alpha - 5)
```

and should use sibling/fiber disjointness only between surviving sibling
branches, never between a crossed parent and its descendant.

## Proposed Lean Blocker Name

```text
BLOCKED_ON_POST_DELETION_ROW28_CLASS8_BRANCH_REALIZATION
```

This replaces the broader:

```text
BLOCKED_ON_ROW28_M1V2_MEMBER_TRANSFER
```

because the source and graph now identify the exact missing construction.

## Status

```text
POST_DELETION_ROW28_FORMULA_NORMALIZED
TABLE4_ROW28_LEDGER_NORMALIZED
CROSSED_PARENT_CHILD_DIRECT_SUM_REJECTED
ROW28_REPEATED_CLASS8_BRANCH_IS_FINAL_BLOCKER
NO_LEAN_CHANGE
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
