# KL2003 F2 High-k Schema v2.1 Nested EL Amendment v1

Date: 2026-07-19

Status: `HIGH_K_SCHEMA_V2_1_DEFINED`

## Purpose

This note promotes the high-k data-certificate format from:

```text
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
```

to the nested-EL-capable amendment:

```text
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1
```

The trigger is the row28 nested schema check, which concluded:

```text
SCHEMA_V2_REQUIRES_V21_FOR_ROW28_NESTED_EL
```

This note defines data-format fields only.  It does not implement the row28
microgenerator, does not open Lean, does not generate k=3 data, and does not
claim any high-k theorem.

## Compatibility

v2 remains valid for flat artifacts:

```text
k3 fixture v2
k2-regression baseline reemission v2
row25 v2
row22 v2
```

v2.1 is required for nested EL artifacts such as source-faithful row28 V3.
Historical v2 artifacts are not rewritten solely because v2.1 exists.

The schema validator must accept both versions:

```text
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2
KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1
```

## Required v2.1 Fields

Nested EL artifacts add these canonical sections and fields:

```text
nodes
nested_blocks
block_id
block_kind = min | sum | row | auxiliary
block_ref
children
post_deletion_edges
figure_node_id
node_status = counted | deleted | terminal | expanded
deletion_marks
deletion_source_ref
termination_policy
termination_rule_ref
sibling_disjointness_group
parent_descendant_overlap_forbidden
source_refs
```

The validator must also recognize `case_splits` for row28-style residue splits.

## Why These Fields Are Needed

`nested_blocks` / `block_id` / `block_ref`:
row28 V3 contains `M1V3` and `M2V3`.  They must be referenced as data, not as
free text.

`block_kind`:
the verifier needs to distinguish `min`, `sum`, row, and auxiliary blocks.

`post_deletion_edges`:
row28 counts post-deletion replacement branches and must not count deleted
parents.

`figure_node_id`:
Figure A1/root_paths is a k=2 regression oracle.  The generated row28 deletion
marks must diff against expected nodes `N04` and `N05`.

`node_status`:
deleted nodes must be explicitly non-counting.

`sibling_disjointness_group`:
row28 sums only between sibling populations whose entry fibers are disjoint.

`parent_descendant_overlap_forbidden`:
the old bad candidate pattern, where a proposed population `B` is already
inside `A`, must be schema-rejectable.

`source_refs`:
splitting, deletion, termination, and Figure A1 oracle references must not be
collapsed into unstructured notes.

`termination_policy`:
the current row28 gate records:

```text
kind = expand_until_deletion_saturation
status = hypothesis_untested
```

This is representability only.  It is not a proof of saturation.

## Validator Requirements

For v2.1 artifacts, the validator must reject:

```text
duplicate ids
unresolved block_ref
cyclic block graph
deleted node counted directly
sum over parent and descendant
unresolved sibling disjointness group
sum operands outside the declared sibling group
node-level sum without the parent-descendant guard enabled
M1V3 second arm = phi22
post_deletion_edges from invalid nodes
Figure A1 used as generator source rather than regression oracle
unresolved termination-rule source reference
```

It must accept:

```text
termination_policy.kind = expand_until_deletion_saturation
termination_policy.status = hypothesis_untested
```

with the warning:

```text
DELETION_SATURATION_HYPOTHESIS_RECORDED_NOT_TESTED
```

## Row28 Representation Target

The v2.1 proposal for row28 must materialize:

```text
row28 root
retarded branch 4*a -> class 5
advanced child c with c % 9 split in {5,2,8}
cPrime split in {2,5,8}
outer min block
M1V3 block
M2V3 block
M1V3 second arm phi25
deleted Figure A1 placeholders N04/N05
post-deletion edges
sibling disjointness groups
anti parent-descendant overlap guard
termination policy hypothesis_untested
```

## Validation Evidence

The validation suite is:

```text
scripts/kl2003_f2_high_k_schema_v2_1_validation_suite_v1.py
```

Its current result is:

```text
HIGH_K_SCHEMA_V2_1_VALIDATION_PASS
positive artifacts: 6/6
negative schema tests: 5/5
```

The positive matrix covers the four historical v2 artifacts, the nested v2.1
fixture, and the Row28 nested proposal.  The negative suite rejects the
historical `phi22` M1 arm, an unresolved block reference, a block cycle, a
counted deleted node, and a parent-plus-descendant sum.  The manifest warning
remains named as `EXTERNAL_MANIFEST_PRESENT_NOT_VALIDATED`.

## No Claims

This amendment does not:

```text
implement row28 generator
prove termination by deletion saturation
generate k=3 data
solve LP
open Lean
change k=2 theorems
claim high-k theorem
claim global Collatz
```

## Classification

```text
HIGH_K_SCHEMA_V2_1_DEFINED
NESTED_EL_SCHEMA_FIELDS_DEFINED
SCHEMA_V2_BACKWARD_COMPATIBILITY_PRESERVED
DELETION_SATURATION_HYPOTHESIS_RECORDED_NOT_TESTED
ROW28_GENERATOR_NOT_STARTED
NO_K3_GENERATION
NO_HIGH_K_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
