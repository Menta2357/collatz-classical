# KL2003 general-k critical triple-witness exclusion Lean v1

Date: 2026-07-20

## Result

`KL2003GeneralKCriticalTripleWitnessExclusion.lean` proves the semantic
no-triple-deletion statement at exactly the strength used by KL2003.

For an advanced `min3` that is globally critical at `Phi,y`, assume:

- `Phi` is positive and monotone;
- the complete tree satisfies `CriticalNodeBounds`, the formal equation-(305)
  invariant; and
- all arguments in the tree are nonnegative.

If one child has a syntactic deletion witness, the existing contextual
deletion theorem proves that child cannot lie on a global critical path.
Every real three-way minimum has at least one critical branch. Therefore all
three children cannot simultaneously have witnesses:

```lean
not_allThreeHaveWitness_of_targetCritical
```

Combining this with the exact retention audit gives:

```lean
witnessRetention_retainedBranchesWitnessFree_of_targetCritical
criticalWitnessRetention_retainedBranchesWitnessFree_of_targetCritical
```

Thus canonical witness retention keeps only witness-free branches whenever
the target minimum is globally critical. The Phi-sensitive
`criticalWitnessRetention` inherits the same result and keeps all branches
when the target is noncritical.

## Relation to the k=5 audit

The companion k=5 audit proves that a typed nonnegative source genealogy may
have three local syntactic witnesses. There is no contradiction: this module
uses the stronger global criticality and equation-(305) hypotheses. Together,
the modules identify the exact boundary:

```text
local source trace alone                         insufficient
critical target + source semantic invariant      sufficient
```

The remaining scheduler task is not another arithmetic exclusion. It must
either extract an infinite globally critical branch compatible with these
hypotheses or iterate the already defined Phi-sensitive
`criticalWitnessRetention`. The current Phi-independent source scheduler does
not yet supply that bridge.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKCriticalTripleWitnessExclusion
lake env lean CollatzClassical/KL2003/KL2003GeneralKCriticalTripleWitnessExclusionAxiomAudit.lean
git diff --check
```

## Classification

```text
CRITICAL_TARGET_TRIPLE_WITNESS_EXCLUSION_PROVED
CRITICAL_WITNESS_RETENTION_BRANCHES_WITNESS_FREE
EQUATION_305_SEMANTIC_INVARIANT_CONSUMED
K5_LOCAL_TRIPLE_WITNESS_AUDIT_RECONCILED
PHI_INDEPENDENT_SCHEDULER_BRIDGE_STILL_OPEN
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
