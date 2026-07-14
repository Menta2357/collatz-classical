# KL2003 Row28 V3 Mod8 Post-Deletion Constructor Lean v1

## Scope

This pass targeted the remaining source-faithful row28 V3 seam blocker:

```text
BLOCKED_ON_POST_DELETION_ROW28_CLASS8_BRANCH_REALIZATION
BLOCKED_ON_ROW28_V3_MOD8_MEMBERWISE_CONSTRUCTOR
```

The intended full closeout would have proved:

```lean
row28_outer_block_v3_le_child_mod8
row28_pointwise_seam_v3_mod8
concretePhi_row28_seam_v3
concretePhi_rowsV3 : I2ELAbstractRowsV3 concretePhi
```

No such theorem is claimed in this pass.

## Superseded Operational Blocker

Corrective update `KL2003_ROW28_V3_MOD8_CP_SPLIT_LEAN_v1` supersedes the
L1-L7 table recovery as the operative blocker.  The literal table remains
historical provenance for the pre-meta-errata path, but the V3 proof route now
uses the odd child `c'` split under the repeated class-8 child:

```text
3*c' + 1 = 2*c
```

The operative blocker is therefore reclassified from:

```text
BLOCKED_ON_MISSING_POST_DELETION_LITERAL_WORDS_FOR_V3_MOD8
```

to:

```text
ROW28_V3_MOD8_CP_SPLIT_REQUIRED
```

## Current Closed Base

The following V3 row28 pieces are already compiled:

```lean
row28_outer_block_v3_le_second
row28_outer_block_v3_le_child_mod2
row28_outer_block_v3_le_child_mod5
row28_pointwise_seam_v3_mod2
row28_pointwise_seam_v3_mod5
concretePhiRowsV3SeamObligation
```

They cover the direct advanced child cases where
`row28AdvancedChild a.1` lands in class `2` or class `5`.

## Exact Remaining Target

For the repeated class-8 case:

```lean
ht : (a.1 / 9) % 3 = 2
```

the missing theorem is:

```lean
row28_outer_block_v3_le_child_mod8 :
  14 <= y ->
  (a : ClassRoots 8) ->
  (a.1 / 9) % 3 = 2 ->
  min
    (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V3 concretePhi y)
    (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
  <=
  (piStar (row28AdvancedChild a.1)
    (concreteWindow (y + shiftAlphaMinus1Pad)
      (row28AdvancedChild a.1)) : Real)
```

Once this theorem is available, `row28_pointwise_seam_v3_mod8` follows by the
same `d3_core_instantiation` assembly already used for the mod2 and mod5
subcases.

## Rejected Shortcuts

The direct `ciInf` wrapper for the repeated class-8 child only gives:

```lean
concretePhi.phi28 (y + shiftAlphaMinus1Pad)
  <= piStar child (concreteWindow (y + shiftAlphaMinus1Pad) child)
```

It does not provide the additional `M1V3 concretePhi y` summand.

Using the second branch of the outer `min` would require a uniform transfer of:

```lean
concretePhi.phi22 (y + shiftAlphaMinus3Pad)
```

into the repeated class-8 child subtree.  The existing traffic lemmas do not
provide this: the child is in class `8`, not class `2`, and the required
post-deletion population is exactly the missing constructor.

Calling a future `concretePhi_row28_seam_v3` recursively on the repeated
class-8 child would be circular and violates the DAG guard.

Counting a crossed parent together with its descendants would violate the
KL2003 deletion rule.  The proof must use surviving post-deletion sibling
fibers only.

## Source/Data Blocker

Historical note after the corrective V3 pass: this section is retained as
custody of the pre-correction source/data path.  It is no longer the operative
Lean blocker for row28 V3.

The local addendum:

```text
docs/KL2003_ROW28_MOD8_EL_TREE_LITERAL_WORDS_ADDENDUM_v1_1.md
```

still records:

```text
BLOCKED_ON_MISSING_KL2003_LITERAL_WORD_TABLE
BLOCKED_ON_LITERAL_ROOT_FORMULA_L1
...
BLOCKED_ON_LITERAL_ROOT_FORMULA_L7
```

Therefore the constructor-only Lean proof is not currently source-backed.  The
available source-side material identifies the algebraic post-deletion labels,
but not the member-wise inverse words, Nat root formulas, parent tags, and
literal-specific boundary/deletion corrections needed to build the finite
`piStarFinset` subpopulations.

## Required Next Lean Input

The next successful Lean pass needs a finite, audited constructor layer for the
surviving row28/mod8 post-deletion literals.  A usable contract would provide,
for each literal `Li` in the repeated class-8 branch:

```text
literal id
root formula as Nat expression in the base child parameter
residue class in {2,5,8}
NotInCycle proof from the path to the parent
window comparison against the child window
PathWithin / ReachesWithin route into the repeated class-8 child
first-entry predecessor tag
sibling disjointness data
deletion-rule status proving that no crossed parent is counted
```

The proof should then build explicit `Finset Nat` populations inside:

```lean
piStarFinset (row28AdvancedChild a.1)
  (concreteWindow (y + shiftAlphaMinus1Pad)
    (row28AdvancedChild a.1))
```

and discharge the sum/min branches by existing traffic lemmas plus existing
fiber disjointness.

## Classification

```text
ROW28_V3_MOD8_CONSTRUCTOR_NOT_PROVED
ROW28_OUTER_BLOCK_V3_MOD8_CONTRACT_RESTATED
BLOCKED_ON_MISSING_POST_DELETION_LITERAL_WORDS_FOR_V3_MOD8
BLOCKED_ON_MEMBERWISE_FINSET_POPULATIONS_L1_L7
BLOCKED_ON_DELETION_RULE_LITERAL_BOUNDARIES_L1_L7
CONCRETEPHI_ROW28_SEAM_V3_NOT_PROVED
CONCRETEPHI_ROWS_V3_NOT_PROVED
K2_INPUTS_V3_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
