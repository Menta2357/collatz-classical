# KL2003 Deletion Rule Source Audit v1

Date: 2026-07-13

Repository: `https://github.com/Menta2357/collatz-classical`

## Purpose

This note records the exact local source location and formalization consequence
of the KL2003 deletion rule relevant to the remaining row28/mod8 seam blocker.

It is a source audit note, not a Lean proof.  It does not claim
`concretePhi_row28_seam`, `K2RetardedInductionInputsV2 concretePhi`, M1, or
Collatz.

## Source

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex
```

Hash:

```text
04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd  30apr02.tex
```

Relevant line ranges:

```text
lines 763-779: deletion rule definition
lines 896-907: deletion-step proof setup
lines 967-1006: totally-non-critical justification
lines 1760-1783: Figure A1 / T_2^8(EL) final inequality
lines 1787-1845: Table 4 / L_2^EL coefficient ledger
```

Short source anchors:

```text
line 763: apply the deletion rule
line 775: The leaf node ... is deleted
line 1760: Nodes marked otimes are deleted nodes
```

These anchors are intentionally short; the full local TeX source is referenced
by path, line range, and hash above.

## Deletion Rule Reading

After a split creates a new minimization node, KL2003 allows a subset of the
three new leaves to be removed.

For a candidate leaf at shift `beta_new`, inspect the directed path from the
root to that leaf.  If an earlier internal `p`-node has the same mode modulo
`3^k` and a strictly smaller shift, then the leaf is deleted.

In formula-independent words:

```text
same mode earlier on path + smaller shift => delete current leaf
```

The proof section then justifies this deletion by showing that removed vertices
are totally non-critical for positive monotone systems.  This is the formal
reason the row28/mod8 seam must not count both a deleted parent node and its
expanded descendants.

## Figure A1 Consequence

The Figure A1 graph transcription has already identified the crossed nodes:

```text
N04: (8, alpha - 1)      crossed yes
N05: (8, 2 alpha - 3)    crossed yes
```

These are class-8 advanced nodes on the `T_2^8(EL)` graph.  By the deletion
rule, they are not leaves of the final EL inequality.  Instead, their expanded
post-deletion descendants are the populations that remain visible in the final
`M1/M2` expression.

This matches the Appendix A1 final inequality:

```text
phi_2^8(y) >= phi_2^5(y-2) + min[ phi_2^8(y+alpha-3) + M1(y),
                                  phi_2^2(y+alpha-3) ]
```

with nested `M1` and `M2` as described immediately after Figure A1.

## Formalization Consequence

The direct-sum candidate for the row28/mod8 nested branch is unsound if it
counts both a crossed class-8 parent population and its deeper descendants as
disjoint populations.

The Lean seam should instead follow the post-deletion tree:

1. do not introduce populations for crossed nodes `N04` and `N05` as leaves;
2. use their descendant subtrees as the final EL populations;
3. obtain disjointness from sibling/fiber disjointness in the post-deletion
   tree, not from a false disjointness between parent and child populations;
4. keep the DAG guard: do not depend on `concretePhi_row28_seam`.

This reframes the last blocker:

```text
OLD: BLOCKED_ON_MISSING_KL2003_LITERAL_WORD_TABLE
OLD: BLOCKED_ON_ROW28_M1V2_MEMBER_TRANSFER

NEW: BLOCKED_ON_POST_DELETION_TREE_MEMBERWISE_REALIZATION
```

The Figure A1 graph is now extracted, and the deletion rule source is located.
The remaining task is to turn the post-deletion graph paths into constructor-only
member populations for the surviving A1 leaves.

## Status

```text
DELETION_RULE_SOURCE_LOCATED
DELETION_RULE_LINE_RANGES_RECORDED
CROSSED_CLASS8_NODES_MATCH_DELETION_RULE
DIRECT_SUM_PARENT_CHILD_COUNT_REJECTED
POST_DELETION_TREE_REALIZATION_REQUIRED
NO_LEAN_CHANGE
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
