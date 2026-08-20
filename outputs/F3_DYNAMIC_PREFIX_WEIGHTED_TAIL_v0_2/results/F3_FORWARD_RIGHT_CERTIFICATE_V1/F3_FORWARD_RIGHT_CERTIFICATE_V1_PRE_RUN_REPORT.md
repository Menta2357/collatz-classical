# F3 forward right certificate v1 — pre-run report

Status: `PRE_RUN_FROZEN — NO LEAN EXECUTION YET`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v1`.

Base commit:

```text
5a33c4ce9a58ce1b9526e12c16ab4a8e09b89470
```

Contract sha256:

```text
9e34d369b97f86d10a68d55219f159e7c0c2d5bacc5f7bd6b981a357790cef64
```

The contract freezes:

- the 81-entry positive integer vector and its expansion rule;
- both canonical vector hashes;
- the three rational lower channel coefficients;
- the exact Nat target `82500*v(s) <= lowerRow(s)`;
- the stronger Real growth factor `55/54`;
- forward orientation only;
- the two permitted source modules;
- budgets, one-attempt execution and STOP custody.

Static discovery, performed without reading or executing `Block0`, found:

```text
numeric spectral radius of exact forward matrix       1.039931099282271
numeric spectral radius of rational lower matrix      1.037641975309
candidate min / max / expanded sum                    21 / 484 / 30123
finite exact target                                   55/54
finite exact target stronger than                     101/100
```

These numerical values motivated the frozen certificate but are not theorem
inputs.  The theorem must follow from the Nat checker and the existing
kernel-clean channel bounds.

No new Lean source, generated certificate, build, audit, first-hit
enumeration or full-block computation existed when this report was frozen.

```text
NO_BUILD_RUN
NO_AUDIT_RUN
NO_BLOCK0_EXECUTION
NO_SEMANTIC_HOOK_PROVED
NO_F3_EXPONENT_THEOREM
```
