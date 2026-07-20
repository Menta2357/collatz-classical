# KL2003 general-k extracted branch nonnegativity in Lean v1

Date: 2026-07-20

## Result

`KL2003GeneralKExtractedBranchNonnegative.lean` proves the nonnegativity half
of the semantic bridge from scheduler nontermination to the infinite-branch
descent consumer.  It does not assume that genealogy prefixes were selected:
it proves that fact operationally through the stronger invariant
`AllStrictPrefixesNonnegative`.

For every live provenanced node, each strict action prefix has nonnegative
absolute shift.  One source step preserves the invariant because old prefixes
are inherited and the one newly completed prefix is the terminal selected by
the scheduler, whose shift is nonnegative by construction.  The proof covers
D1 and D3 after arbitrary `witnessRetention`, and D2 through its exact source
split.

The invariant iterates over `run`.  A coherent code selected by Konig is a
prefix of an actual selected provenance; its shift is nonnegative either by
the strict-prefix invariant or by terminal eligibility when the prefix is the
whole provenance.  Consequently:

```lean
extractedInfiniteSourceWalk_shiftsNonnegative
    (hne : NeverStops (ProvenancedTree.initial hp root)) :
  InfiniteSourceWalk.ShiftsNonnegative
    (extractedInfiniteSourceWalk hne) root.shift.eval
```

## Remaining termination debt

Only contextual admissibility remains before the existing infinite-branch
contradiction can be applied.  The current `witnessRetention` deliberately
keeps one branch when all three advanced children have deletion witnesses.
Therefore admissibility cannot be inferred from retention alone; that triple
witness case must be excluded by a proved invariant or exposed as the exact
conditional contract.  This module does neither and makes no termination
claim.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKExtractedBranchNonnegative
lake env lean CollatzClassical/KL2003/KL2003GeneralKExtractedBranchNonnegativeAxiomAudit.lean
git diff --check
```

The expected audit profile is `[propext, Classical.choice, Quot.sound]`.

```text
EXTRACTED_BRANCH_STRICT_PREFIX_NONNEGATIVITY_INVARIANT_PROVED
SOURCE_STEP_PRESERVES_STRICT_PREFIX_NONNEGATIVITY
EXTRACTED_INFINITE_BRANCH_SHIFTS_NONNEGATIVE_PROVED
CONTEXTUAL_ADMISSIBILITY_NOT_YET_PROVED
TRIPLE_WITNESS_RETENTION_CASE_EXPLICITLY_OPEN
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
