# Rhin-anchored H1 successor gate v2 static review

Status: `STATIC_PASS / PHASES_NOT_EXECUTED`

Date: 2026-07-24.

The gate is a new warm-aware execution contract over the byte-identical v1
candidate. It makes no Lean source change.

```text
LEAN_SOURCE_DIFF_FROM_V1 = EMPTY
THEOREM_HASH = a7f3bef1c7184b514c3cc6833da03a3eefd5f41b3bea58bf4062885d7bfab7b1
AUDIT_HASH = 4c75fd87933592842a70a4f861f29fa685c73ea81a62ed359437b8170506f688
V1_STOP_MUTATION = NONE
```

The phase split is deliberate:

- F0 checks custody, environment, disk and absence of later evidence;
- D1 builds only the two dependency roots under a separately calibrated cap;
- P1 elaborates only the candidate;
- A1 prints axioms for both producer and consumer.

Each phase has one invocation and STOP semantics. Later phases are forbidden
after any failure. PASS or STOP must be published. Existing caches are
permitted but are not accepted as evidence without Lake validation.

F0 also requires custody HEAD to equal its published upstream and verifies the
actual clean Mathlib checkout, rather than trusting the manifest text alone.

Static inspection confirms that the corollary removes only `h31`; `hN0`,
`hsmall` and `FiniteBaseVerified` remain explicit. No theorem or kernel-clean
claim is made before P1 and A1 both pass.
