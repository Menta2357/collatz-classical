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
- preserves deletion witnesses under a common translation whenever source and
  translated leaf eligibility are equivalent, including the both-negative
  case;
- preserves `witnessRetention` and the resulting deletion for translated
  advanced configurations under those explicit eligibility hypotheses;
- transports dependent terminal/minimum paths through a source split and
  proves that the canonical D1/D3 advanced `minPath` is the translated
  canonical `minPath` after the source label is translated;
- identifies all three canonical D1/D3 branch paths after translation,
  transports their witness retention, and proves D1/D3 `sourceStep`
  equivariance whenever eligibility is equivalent for the three original and
  translated advanced labels;
- proves full `sourceStep` translation equivariance for the D2 branch;
- defines tree-wide terminal eligibility equivalence and proves that the exact
  deterministic left-to-right expandable-occurrence selector commutes with
  translation under that contract;
- proves conditional translation equivariance of `sourceScheduledStep` when
  tree-wide terminal eligibility and the selected D1/D3 branch eligibility are
  preserved;
- transports the reflexive-transitive closure of raw localized source splits.

The main finite-trace theorem is `ELTree.rawSourceSplitSteps_translate`; the
conditional deterministic-step theorem is `ELTree.sourceScheduledStep_translate`.

## Role in Theorem 3.1

KL2003 states that fully split subtrees rooted at recurrent copies of one mode
are identical after translating their arguments. This module now proves the
local algebra and its finite iteration whenever the corresponding terminal
paths are supplied explicitly.

This remains deliberately weaker than unconditional global scheduler
equivariance. Expandability depends on the absolute condition
`0 <= shift.eval`; translating every shift does not preserve that condition
without an additional bound. The geometry of deletion and its witness policy
now transport for corresponding advanced configurations whenever the relevant
sign tests agree. The dependent descent through an outer split, all four paths
of the canonical D1/D3 advanced configurations, `witnessRetention`, and the
resulting D1/D3 `sourceStep` commute under three branch eligibility
equivalences; D2 commutes unconditionally. At tree level,
`TerminalEligibilityEquivalent` is sufficient to transport the exact selector,
and together with `SourceStepEligibilityEquivalent` at the selected occurrence
it transports one deterministic scheduled step. This module does not prove
that the recurrent translations in Theorem 3.1 satisfy either eligibility
contract. Therefore it does not yet identify recurrent full subtrees, derive
one fixed increment between successive recurrent shifts, or prove
termination/order independence.

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
GENERAL_K_DEPENDENT_SOURCE_SPLIT_DESCENT_TRANSLATION_PROVED
GENERAL_K_D1_D3_CANONICAL_MIN_PATH_TRANSLATION_PROVED
GENERAL_K_D1_D3_BRANCH_PATH_TRANSLATION_PROVED
GENERAL_K_D1_D3_ADVANCED_CONFIGURATION_TRANSLATION_PROVED
GENERAL_K_D1_D3_WITNESS_RETENTION_TRANSLATION_PROVED_CONDITIONALLY
GENERAL_K_D1_D3_SOURCE_STEP_TRANSLATION_EQUIVARIANCE_PROVED_CONDITIONALLY
GENERAL_K_D2_SOURCE_STEP_TRANSLATION_EQUIVARIANCE_PROVED
GENERAL_K_TERMINAL_ELIGIBILITY_EQUIVALENCE_DEFINED
GENERAL_K_SOURCE_STEP_ELIGIBILITY_EQUIVALENCE_DEFINED
GENERAL_K_FIRST_EXPANDABLE_SELECTOR_TRANSLATION_PROVED_CONDITIONALLY
GENERAL_K_SOURCE_SCHEDULER_TRANSLATION_EQUIVARIANCE_PROVED_CONDITIONALLY
GENERAL_K_FINITE_RAW_SPLIT_TRACE_TRANSLATION_EQUIVARIANCE_PROVED
THEOREM31_LOCAL_SELF_SIMILARITY_STEP_PROVED
GENERAL_K_SELF_SIMILARITY_TRANSLATION_AXIOM_AUDIT_PASS
GENERAL_K_UNCONDITIONAL_SIGN_SENSITIVE_SCHEDULER_TRANSLATION_NOT_CLAIMED
THEOREM31_RECURRENT_ELIGIBILITY_EQUIVALENCE_NOT_YET_PROVED
THEOREM31_FULL_RECURRENT_SUBTREE_CORRESPONDENCE_NOT_YET_PROVED
GENERAL_K_FULL_EXPANSION_DELETION_TERMINATION_NOT_YET_PROVED
GENERAL_K_EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
SATISFIES_EL_NOT_YET_PROVED
NO_GLOBAL_COLLATZ_CLAIM
```
