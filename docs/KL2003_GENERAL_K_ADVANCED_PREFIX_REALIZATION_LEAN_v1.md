# KL2003 general-k advanced-prefix realization Lean v1

## Result

`KL2003GeneralKAdvancedPrefixRealization.lean` states the remaining scheduler
obligation as concrete data and proves its complete arithmetic consumer.

`WitnessFreeAdvancedPrefixRealization` contains an actual finite scheduler
time, a provenanced terminal and path, equality of its typed action code with
the selected coherent prefix, equality of its target mode with the advanced
arrival, and absence of a raw deletion witness. It does not contain the shift
inequality to be proved.

The module proves that `AllAdvancedPrefixesWitnessFree` implies
`AdvancedArrivalsNonincreasing`. Combined with the already proved
nonnegativity and recurrence theorems, this yields an infinite recurrent
advanced-target subsequence whose accumulated shifts decrease strictly.

## Boundary

The contract is not yet constructed from the concrete retention policy. Its
remaining obstruction is exact: `witnessRetention` keeps one branch when all
three advanced leaves have witnesses. Excluding that case, and transporting
retained child terminals into the coherent prefix family, will discharge the
contract. Fixed recurrent decrement and the final termination contradiction
remain subsequent work.

## Verification

```text
lake build CollatzClassical.KL2003.KL2003GeneralKAdvancedPrefixRealization
lake env lean CollatzClassical/KL2003/KL2003GeneralKAdvancedPrefixRealizationAxiomAudit.lean
```

## Classification

```text
ADVANCED_PREFIX_REALIZATION_CONTRACT_DEFINED
PACKED_PREFIX_LABELS_CONNECTED_TO_BRANCH_BETA
WITNESS_FREE_REALIZATIONS_IMPLY_ADVANCED_ARRIVALS_NONINCREASING
EXTRACTED_RECURRENT_ADVANCED_SHIFTS_STRICTLY_DECREASE_UNDER_CONCRETE_CONTRACT
CONCRETE_RETENTION_TO_REALIZATION_BRIDGE_OPEN
TRIPLE_WITNESS_EXCLUSION_STILL_OPEN
FIXED_RECURRENT_INCREMENT_NOT_YET_PROVED
NO_K3_PISTAR_THEOREM_YET
NO_K9_FORMALIZATION
NO_GLOBAL_COLLATZ_CLAIM
```
