# KL2003 F2 k=9 Lean integration artifact custody v1

Status: `K9_INTEGRATION_ARTIFACTS_CUSTODIED_WITH_MANIFEST`

This document records the generated k=9 integration artifacts without
upgrading the rejected checker architecture into a theorem claim. The
accepted k=9 theorem remains the match-dispatch package cited by
`docs/KL2003_K9_PISTAR_THEOREM_LEAN_v1.md`; these nine emitted verifier shards
are preserved as an auditable engineering experiment and are not silently
deleted.

## Manifest

```text
path   = outputs/KL2003_F2_K9_LEAN_INTEGRATION_v1/manifest_sha256.csv
sha256 = f117f445d955f2a39896aaa3024ee72d995447add573142a9e9b09a4a327812c
entries = 13
verification = PASS (13/13 paths present and hash-matching)
```

The manifest covers the generator script, promoted candidate data, verifier
base, and shards 0–8. It is the chain-of-evidence pointer for this artifact
set; no generated file is treated as a replacement for the kernel-checked
match-dispatch theorem.

## Classification

```text
K9_EXACT_CERTIFICATE_DATA_CUSTODIED
K9_INTEGRATION_SHARDS_HASH_VERIFIED
K9_CHECKER_ARCHITECTURE_EXPERIMENT_RETAINED
K9_MATCH_DISPATCH_THEOREM_REMAINS_PRIMARY
NO_K9_ARCHITECTURE_UPGRADE_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
