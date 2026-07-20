# KL2003 general-k retention/admissibility audit v1

Date: 2026-07-20

## Purpose

This note audits whether the implemented `witnessRetention` policy is enough
by itself to make every surviving source genealogy context-admissible.  It is
not a termination proof and does not challenge the semantic soundness of
deleting the branches that the policy actually removes.

## Exact Lean result

The new audit module defines `RetainedBranchesWitnessFree` by enumerating the
branches retained by each `Min3Retention`.  Lean proves the exact boundary:

```lean
witnessRetention_retainedBranchesWitnessFree_iff :
  RetainedBranchesWitnessFree configuration
      configuration.witnessRetention <->
    Not (AllThreeHaveWitness configuration)
```

If all three advanced leaves have deletion witnesses, the maximal nonempty
policy chooses `keepFirst`.  The retained first branch still has a witness:

```lean
allThreeHaveWitness_keeps_a_witnessed_branch
```

Thus a proof that every retained advanced branch is witness-free must first
exclude the triple-witness configuration.  This is a mathematical invariant
to prove, not a simplification of the retention definition.

## Retarded endpoint gap

There is a second, independent boundary.  D2 and the retarded summand of D1/D3
are created outside the advanced `min3`; they do not pass through
`witnessRetention`.  The printed proof of Theorem 3.1 informally invokes the
deletion rule for every later repeated `p`-node, but the printed rule at
`30apr02.tex:763-779` applies only to the three new leaves in an `m`-term.

Consequently, the remaining context-admissibility proof has two explicit
obligations:

1. exclude `AllThreeHaveWitness` for source configurations that can lie on the
   surviving scheduler branch, or replace the syntactic scheduler by a proved
   critical-guided construction;
2. prove negative weight for new repeated-mode factors ending in a retarded
   edge, using source-graph arithmetic and nested-return admissibility rather
   than deletion.

The already proved irrationality theorem will strengthen nonpositive weights
to strict negativity once these nonpositivity obligations are established.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKRetentionAdmissibilityAudit
lake env lean CollatzClassical/KL2003/KL2003GeneralKRetentionAdmissibilityAuditAxiomAudit.lean
git diff --check
```

```text
WITNESS_RETENTION_FREE_IFF_NO_TRIPLE_WITNESS_PROVED
TRIPLE_WITNESS_RETAINED_BRANCH_OBSTRUCTION_PROVED
RETARDED_ENDPOINT_DELETION_GAP_RECORDED
EXTRACTED_BRANCH_CONTEXT_ADMISSIBILITY_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
K11_DEFERRED
NO_GLOBAL_COLLATZ_CLAIM
```
