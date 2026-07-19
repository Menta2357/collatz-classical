# KL2003 general-k self-similarity translation in Lean v1

## Scope

This checkpoint proves translation equivariance for source-faithful
general-`k` EL splits and arbitrary finite traces of explicitly matched raw
splits. A symbolic translation `delta`:

- preserves every mode and adds `delta` to each label shift;
- commutes with `frontierExpr` and `normalExpr`;
- translates evaluation from `y` to `y + delta.eval`;
- commutes with `ofExpr`, `splitTopExpr`, and `sourceSplitTree`.
- transports a dependent `TerminalPath` through an arbitrary tree context;
- commutes with `TerminalPath.splitAt` at the transported leaf;
- transports a dependent `Min3Path` and commutes with `reduceAt` for every
  fixed nonempty retention pattern;
- preserves deletion witnesses under a common translation whenever the source
  and translated leaves are both nonnegative;
- preserves `witnessRetention` and the resulting deletion for translated
  advanced configurations under those explicit nonnegativity hypotheses;
- proves full `sourceStep` translation equivariance for the D2 branch;
- transports the reflexive-transitive closure of raw localized source splits.

The main finite-trace theorem is `ELTree.rawSourceSplitSteps_translate`.

## Role in Theorem 3.1

KL2003 states that fully split subtrees rooted at recurrent copies of one mode
are identical after translating their arguments. This module now proves the
local algebra and its finite iteration whenever the corresponding terminal
paths are supplied explicitly.

This is deliberately weaker than global scheduler equivariance. Expandability
depends on the absolute condition `0 <= shift.eval`; translating every shift
does not preserve that condition without an additional bound. The geometry of
deletion and its witness policy now transport for corresponding advanced
configurations. For D1/D3 it remains to prove that the configurations built
around the translated split are themselves translations of the originals. The
scheduler also remains sign-sensitive. Therefore the module does not yet
identify recurrent full subtrees, derive one fixed increment between
successive recurrent shifts, or prove termination/order independence.

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKSelfSimilarity.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKSelfSimilarityAxiomAudit.lean
```

The algebraic translation theorems use only `propext`; the source-expression
theorems additionally report the existing `Classical.choice` and `Quot.sound`.

## Classification

```text
GENERAL_K_TREE_TRANSLATION_DEFINED
GENERAL_K_FRONTIER_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_NORMAL_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_SOURCE_SPLIT_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_TERMINAL_PATH_TRANSLATION_DEFINED
GENERAL_K_LOCALIZED_SPLIT_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_MIN3_PATH_TRANSLATION_DEFINED
GENERAL_K_FIXED_RETENTION_DELETION_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_DELETION_WITNESS_TRANSLATION_EQUIVARIANCE_PROVED_CONDITIONALLY
GENERAL_K_WITNESS_RETENTION_TRANSLATION_EQUIVARIANCE_PROVED_CONDITIONALLY
GENERAL_K_D2_SOURCE_STEP_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_FINITE_RAW_SPLIT_TRACE_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_LOCAL_SELF_SIMILARITY_STEP_PROVED
GENERAL_K_SELF_SIMILARITY_TRANSLATION_AXIOM_AUDIT_PASS
GENERAL_K_SIGN_SENSITIVE_SCHEDULER_TRANSLATION_NOT_CLAIMED
GENERAL_K_D1_D3_CONFIGURATION_TRANSLATION_NOT_YET_PROVED
THEOREM31_FULL_RECURRENT_SUBTREE_CORRESPONDENCE_NOT_YET_PROVED
GENERAL_K_FULL_EXPANSION_DELETION_TERMINATION_NOT_YET_PROVED
GENERAL_K_EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
SATISFIES_EL_NOT_YET_PROVED
NO_GLOBAL_COLLATZ_CLAIM
```
