# F3 forward right certificate v1 — R0 report

Status: `R0_STATIC_PREFLIGHT_PASS — C0 NOT YET EXECUTED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v1`.

Custodied source commit before R0:

```text
bf8802b
```

## Frozen-input verification

All five input hashes and the contract hash match the frozen values:

```text
FullCoreIdentity.lean       6bfd513abedf81c980e818b20efff46fc720dafabb710031c0e5aba1d5abffad
PilotRepair.lean            e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c
ChannelBounds.lean          30f1bed5a415b6b725476997c44ef853d05d9cefce26e9965c7c0eaaa19f0e04
RealOperatorBridge.lean     77685f002ed26b73d6028d1d77b345f5e0460a90a2bc94cfc6e045ad3fad6c3c
core_edge_identity.csv      45a4297196e3f1ea767b0f4cfef8ebbbcf70f31547469fe22768cda9d971e35a
contract                    9e34d369b97f86d10a68d55219f159e7c0c2d5bacc5f7bd6b981a357790cef64
```

The new source hashes at R0 are:

```text
certificate source          37932fd8198e045c436c479455a362afb9b2ef720b2138c1f3308f552e16a4ab
total axiom audit            fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2
```

## Literal-vector verification

```text
entry count                 81
minimum                     21
maximum                     484
expanded 243-entry sum      30123
81-entry CSV sha256         3e72754815937816ad6465022f2fe90fee605f261ef8e3bd785902836e840ac1
243-entry CSV sha256        4d063bbb1b2bbfca70f1e1a149ceec3668334788913e3b7ad62c1a3d8b7483a4
```

## Static guards

- 21 stable declarations and 21/21 explicit `#print axioms` entries;
- namespace-wide environmental inventory via `Lean.collectAxioms`;
- only the authorized Nat occurrence `s.1 / 3` appears in the new source;
- no `native_decide`, `ofReduceBool`, `sorryAx`, `sorry`, or `admit`;
- two independent static reviewers found no remaining mathematical,
  orientation, multiplicity, syntactic, or tactic-level blocker.

No Lean compilation and no `Block0` computation occurred during R0.

```text
R0_STATIC_PREFLIGHT_PASS
NO_BUILD_RUN
NO_BLOCK0_EXECUTION
```
