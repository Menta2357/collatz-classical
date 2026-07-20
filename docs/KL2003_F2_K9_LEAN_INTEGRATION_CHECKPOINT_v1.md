# KL2003 F2 k=9 Lean Integration Checkpoint v1

## Closed in this checkpoint

`KL2003K9ClassRoots.lean` proves `GeneralKClassRootsNonempty 9` without
enumerating 6561 witnesses.  The proof shows that `2` has order `13122` in
the units of `ZMod (3^9)`, obtains every tracked residue as a power of `2`,
and shifts the exponent by one full period so that `notInCycle_two_pow`
applies.

`KL2003K9ClassRootsAxiomAudit.lean` reports only:

```text
[propext, Classical.choice, Quot.sound]
```

The exact rational candidate has also been promoted to a generated source
data module.  The promotion changes no rational literal and records SHA256
provenance in `outputs/KL2003_F2_K9_LEAN_INTEGRATION_v1/manifest_sha256.csv`.

## Checker experiment

`kl2003_f2_k9_lean_integration_v1.py` emits a verifier base and nine proposed
source-tree shards.  The current emitted shards are an architecture
experiment, not a completed checker:

- whole-table unfolding exceeded eight minutes for one shard and was
  rejected;
- an outer-array table link exceeded 76 seconds for one row and was rejected;
- a generated chunk router checks a linked row but still costs about 87
  seconds per row and therefore cannot be used independently 6561 times;
- the previously custodied direct-literal checker remains the arithmetic
  baseline: all nine shards passed in 437.152929 seconds wall time with three
  workers.

The accepted next design separates direct literal arithmetic facts from a
finite dependent dispatcher.  It must meet the budget fixed in
`KL2003_F2_K9_KERNEL_INTEGRATION_BUDGET_AND_COST_LEDGER_v1.md`.

## Environmental incident

The filesystem reached 23 MB free while Lake attempted to rebuild broad
Mathlib IR.  Only reconstructible `.lake/build/ir` directories were removed;
no source or versioned artifact was deleted.  Subsequent checks use
`lake env lean` and emit only the required project `.olean` files.

## Verification performed

```text
python3 -m py_compile scripts/kl2003_f2_k9_lean_integration_v1.py
python3 scripts/kl2003_f2_k9_lean_integration_v1.py
lake env lean CollatzClassical/KL2003/KL2003K9ClassRoots.lean
lake env lean CollatzClassical/KL2003/KL2003K9ClassRootsAxiomAudit.lean
lake env lean CollatzClassical/KL2003/KL2003K9CertificateVerifierBase.lean
git diff --check
```

## Classification

`K9_CLASSROOTS_NONEMPTY_PROVED`

`K9_CLASSROOTS_AXIOM_AUDIT_PASS`

`K9_EXACT_CERTIFICATE_DATA_PROMOTED`

`K9_KERNEL_INTEGRATION_BUDGET_FIXED`

`K9_CHECKER_ARCHITECTURE_IN_PROGRESS`

`K9_ALL_SOURCE_SHARDS_NOT_YET_PROVED`

`K9_DISPATCHER_NOT_YET_PROVED`

`K9_LNT_CERTIFICATE_NOT_YET_PROVED`

`NO_K9_LOWER_BOUND_THEOREM_CLAIM`

`K11_DEFERRED`

`NO_GLOBAL_COLLATZ_CLAIM`
