# KL2003 general-k source transition graph in Lean v1

Date: 2026-07-20

## Scope

`KL2003GeneralKSourceTransitionGraph.lean` formalizes the finite weighted
transition layer underlying source-faithful D1/D2/D3 expansion for arbitrary
`k = p + 1` with `1 <= p`.

The module does not encode generated EL trees or duplicate row data. Every
action target and weight reduces to the existing source definitions in
`KL2003GeneralKEliminationContext.lean`.

## Typed actions

`SourceBranch` has the finite branch alphabet:

```text
retarded
d1Advanced (index : Fin 3)
d3Advanced (index : Fin 3)
```

`SourceAction mode` is the subtype of branches valid for the source mode.
Consequently:

- the retarded action exists at every tracked mode;
- D1 advanced actions require `mode % 9 = 2`;
- D3 advanced actions require `mode % 9 = 8`;
- invalid advanced branches cannot be constructed without proving a false
  residue equality.

The target and weight functions agree with the existing definitions:

```text
retarded -> fourTrackedMode, retardedTwo
D1 index -> liftTrackedMode (d1LowerTrackedMode ...), d1Advanced
D3 index -> liftTrackedMode (d3LowerTrackedMode ...), d3Advanced
```

The theorems `childLabel_retarded`, `childLabel_d1Advanced`, and
`childLabel_d3Advanced` identify the generated child labels with
`ELTree.retardedSplitLabel`, `ELTree.d1AdvancedSplitLabel`, and
`ELTree.d3AdvancedSplitLabel` exactly.

## Dependent walks

`SourceWalk hp source target` is a dependent finite walk. Each next action is
typed at the target mode of the preceding action, so endpoint compatibility is
enforced by construction.

The module proves:

- concatenation preserves endpoints;
- lengths add under concatenation;
- symbolic weights add under concatenation;
- every accumulated alpha coefficient is nonnegative;
- every accumulated constant coefficient is nonpositive;
- the constant coefficient is strictly negative for every nonempty walk;
- `finalLabel` accumulates exactly the walk weight;
- evaluated final shift equals initial shift plus evaluated walk weight.

These are the inputs required by the finite-cycle descent scoping. The
downstream module `KL2003AlphaIrrational.lean` now excludes zero evaluated
weight for every nonempty source walk.

## Verification

```text
lake env lean CollatzClassical/KL2003/KL2003GeneralKSourceTransitionGraph.lean
lake env lean CollatzClassical/KL2003/KL2003GeneralKSourceTransitionGraphAxiomAudit.lean
```

The audited theorems report only:

```text
[propext, Classical.choice, Quot.sound]
```

## Classification

```text
GENERAL_K_SOURCE_BRANCH_FINITE_TYPE_DEFINED
GENERAL_K_SOURCE_ACTION_VALIDITY_INDEXED_BY_MODE
GENERAL_K_SOURCE_ACTION_TARGETS_PROVED_SOURCE_FAITHFUL
GENERAL_K_SOURCE_ACTION_WEIGHTS_PROVED_SOURCE_FAITHFUL
GENERAL_K_SOURCE_WALK_DEFINED
GENERAL_K_SOURCE_WALK_APPEND_WEIGHT_PROVED
GENERAL_K_NONEMPTY_SOURCE_WALK_CONST_COEFF_NEGATIVE_PROVED
GENERAL_K_SOURCE_WALK_FINAL_LABEL_SHIFT_PROVED
GENERAL_K_SOURCE_TRANSITION_GRAPH_AXIOM_AUDIT_PASS
GENERAL_K_ZERO_EVALUATED_WALK_WEIGHT_EXCLUDED_DOWNSTREAM
GENERAL_K_SIMPLE_CYCLE_DECOMPOSITION_NOT_YET_PROVED
EL_TERMINATION_NOT_YET_PROVED
EL_ORDER_INDEPENDENCE_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_CLAIM
NO_K9_FORMALISATION_AUTHORIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
