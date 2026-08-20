# F3 forward right certificate v1 — contract clarification

Status: `PRE_RUN_CLARIFICATION — NO EXECUTION YET`

Date: 2026-07-24.

Frozen contract sha256:

```text
9e34d369b97f86d10a68d55219f159e7c0c2d5bacc5f7bd6b981a357790cef64
```

The static preflight found that implementation guards 1 and 5 used `/3` in
two different senses.  Guard 1 requires the Nat quotient `s.val / 3` to map
243 state indices to the frozen 81-entry vector.  Guard 5 says that `/3`
occurs only in the two advanced channel weights.

The binding interpretation, fixed before any Lean execution, is:

```text
The Nat index quotient s.val / 3 is required and permitted.

Apart from that Nat quotient, the new module introduces no additional Real
division by 3 in an edge contribution.  The only Real advanced-channel /3
normalization is the one already present in imported channelWeight 1 and 2.
```

No vector entry, coefficient, theorem target, source allowance, budget or
STOP rule changes.  The historical contract remains byte-identical and this
clarification travels with it.

```text
NO_BUILD_RUN
NO_BLOCK0_EXECUTION
```
