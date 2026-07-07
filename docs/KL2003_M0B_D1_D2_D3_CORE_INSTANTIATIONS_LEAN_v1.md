# KL2003 M0B D1/D2/D3 Core Instantiations Lean v1

## Scope

This note records a Nat/combinatorial instantiation layer over
`two_branch_card_bound`.

No scaling, rounding ledger, LP row slack, `Real`, `alpha`, `lambda`, `rpow`,
M0c induction, M0 theorem, M1 theorem, or global Collatz claim is introduced.

## Lean artifacts

- `CollatzClassical/KL2003/KL2003M0BD123CoreInstantiations.lean`
- `CollatzClassical/KL2003/KL2003M0BD123CoreInstantiationsAxiomAudit.lean`

## Verification

Commands run:

```text
lake build CollatzClassical.KL2003.KL2003M0BD123CoreInstantiations
lake env lean CollatzClassical/KL2003/KL2003M0BD123CoreInstantiationsAxiomAudit.lean
```

Result:

- build passed;
- audit passed with the expected base dependencies from the existing Finset
  stack: `propext`, `Classical.choice`, and `Quot.sound`;
- residue-only arithmetic lemmas depend on `propext` and `Quot.sound`.

## Core rows

### D1 core instantiation

`d1_core_instantiation` is the class-free two-branch core:

```lean
(piStarFinset (4 * a) xRet).card + (piStarFinset c xAdv).card
  <= (piStarFinset a x).card
```

under:

- `1 <= a`;
- `NotInCycle a`;
- `3 * c + 1 = 2 * a`;
- `a <= x`;
- `xRet <= x`;
- `xAdv <= x`.

This is the immediate-child combinatorial core.  Any row-specific deeper source
or window scaling remains outside this module.

### D3 core instantiation

`d3_core_instantiation` has the same class-free core statement.  The D3
class-specific residue information is kept as separate Nat arithmetic lemmas.

### D2 single branch

`d2_single_branch_core_instantiation` uses `two_branch_card_bound` with
`xAdv := 0` and `piStar_zero_x` to discharge the advanced term:

```lean
(piStarFinset (4 * a) xRet).card <= (piStarFinset a x).card
```

For `a = 9*t + 5`, the formalized residue lemma
`d2_advanced_branch_residue_mod_three` gives `c % 3 = 0` for
`c = 6*t + 3`.  Thus the advanced branch exists combinatorially, but it is not
consumable by the current phi-ledger row.

## Residues

The D3 advanced residue split is formalized as:

- `t % 3 = 0 -> (6*t + 5) % 9 = 5`;
- `t % 3 = 1 -> (6*t + 5) % 9 = 2`;
- `t % 3 = 2 -> (6*t + 5) % 9 = 8`.

Retarded branch residue facts for roots `2`, `5`, and `8` modulo `9` are also
included.

## Classifications

- D1_CORE_INSTANTIATION_PROVED
- D2_SINGLE_BRANCH_INSTANTIATION_PROVED
- D2_ADVANCED_BRANCH_LEDGER_INCONSUMABLE_EXPLAINED
- D3_CORE_INSTANTIATION_PROVED
- D3_RESIDUE_SPLIT_LEMMAS_PROVED
- TWO_BRANCH_CORE_REUSED
- M0B_COMBINATORIAL_ROWS_ASSEMBLED
- NO_SCALING
- NO_ROUNDING_LEDGER
- NO_M0_THEOREM
- NO_M1_THEOREM
- NO_GLOBAL_COLLATZ_CLAIM
