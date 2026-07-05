# ELIAHOU1993_AUTHOR_FIRST_PACKAGE_DRAFT_v1

Fecha: 2026-07-06, Europe/Madrid.

Estado: paquete author-first listo para revision interna. No enviado a tangentstorm/maintainers. No Forum post. No issue upstream. No audit link. No claim oficial. No global Collatz claim.

## Base

Notas base:
- `docs/ELIAHOU1993_LOCAL_STATEMENT_FIDELITY_AUDIT_v1.md`
- `docs/ELIAHOU1993_L_VS_CARDOMEGA_BRIDGE_AUDIT_v1.md`
- `docs/ELIAHOU1993_LOCAL_MECHANICAL_AUDIT_RUN_v1.md`
- `docs/ELIaHOU1993_NATIVE_DECIDE_TO_NORM_NUM_PROBE_v1.md`
- `docs/ELIAHOU1993_DECIDE_KERNEL_GMP_PROBE_AND_CONTACT_PROTOCOL_LEDGER_v1.md`
- `docs/ELIAHOU1993_EXACT_PERIOD_GLUE_RECOMMENDATION_v1.md`

Repo auditado:
- `https://github.com/tangentstorm/eliahou-collatz-bounds`
- commit base auditado: `fdb0b2e1ac0d774f4e288ffa2106785efd351563`

Decision de protocolo:
- `AUTHOR_FIRST_PROTOCOL_SELECTED`.
- Contactar primero a tangentstorm/maintainers con paquete completo antes de Forum o issue.

## Guardarrailes

- NO_UPSTREAM_CONTACT_YET.
- NO_FORUM_POST.
- NO_AUDIT_LINK.
- NO_OFFICIAL_CLAIM.
- NO_GLOBAL_COLLATZ_CLAIM.

## Paquete de contacto

### Subject

```text
Private pre-audit notes on the Eliahou1993 CC Challenge formalisation
```

### Message draft

````markdown
Hi tangentstorm,

I have been doing a private pre-audit pass on the CC Challenge entry for
`Eliahou1993`, formalisation id 6. I have not posted on the Forum, opened an
audit link, or filed an upstream issue. I wanted to contact you first with the
full package, since most of the points below look like scope/glue questions
rather than problems with the core mathematical work.

First: thank you for putting this formalisation together. The local mechanical
audit was encouraging:

- I checked the registered commit `fdb0b2e1ac0d774f4e288ffa2106785efd351563`.
- `lake exe cache get` completed after the local disk issue was fixed.
- `lake build` completed successfully: `Build completed successfully (8030 jobs).`
- I found no `sorry`, `admit`, `axiom`, or `unsafe` in the Lean source.
- `#print axioms` for the central theorem was recorded.

My current read is that the repository formalises a useful lower-bound
consequence of Eliahou's Theorem 1.1:

```lean
theorem eliahou_bound {L : Nat} (c : CollatzCycle L)
    (hmin : (2 : Nat) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 <= L
```

I do not currently see a formalisation of the full linear-form conclusion from
Theorem 1.1,

```text
Card Omega = 301994 a + 17087915 b + 85137581 c
```

with the printed conditions on `a`, `b`, and `c`. So I wanted to ask whether the
intended registered scope is "the lower-bound consequence of Eliahou1993" rather
than the full linear-form theorem. That would be a perfectly reasonable partial
formalisation scope; I just want to avoid over-reading the entry during audit.

The main statement-glue point I found is the relationship between the paper's
`Card Omega` and Lean's parameter `L` in `CollatzCycle L`. In the paper, the
length is the cardinality/exact period of the orbit. In Lean, `CollatzCycle L`
is an indexed periodic sequence. I did not find a `Nodup`, `Function.Injective`,
minimal-period, or paper-cycle-to-exact-cycle bridge forcing `L` to be the orbit
cardinality. As far as I can tell, repeated traversal of the same cycle can
inflate `L` while still satisfying the current structure.

This looks fixable with a small exact-period/cardinality bridge. A lightweight
option would be a theorem or wrapper with

```lean
hexact : Function.Injective c.seq
```

and then a conclusion phrased in terms of

```lean
(Finset.univ.image c.seq).card
```

Alternatively, an `ExactCollatzCycle` wrapper or a `PaperCycle -> CollatzCycle`
bridge would make the paper correspondence explicit.

There is also the extra hypothesis

```lean
hk : 0 < c.numOdd
```

in `eliahou_bound`. I do not see a lemma deriving it in the repo. Mathematically
it seems likely derivable for any positive compressed Collatz cycle: if every
entry were even, taking a minimum element and applying the compressed map would
produce a smaller positive element in the cycle. A lemma such as

```lean
theorem CollatzCycle.numOdd_pos {L : Nat} (c : CollatzCycle L) :
    0 < c.numOdd
```

would remove this statement mismatch, or at least discharge the hypothesis
inside a paper-facing theorem.

On the trusted-computation side, I found that the central theorem currently
inherits `Lean.ofReduceBool` and `Lean.trustCompiler` through numerical facts in
`ContinuedFractions.lean`, because several large closed arithmetic facts use
`native_decide`.

One small replacement works locally:

```diff
 theorem farey_13_15 : 301994 * 10781274 - 17087915 * 190537 = 1 := by
-  native_decide +revert
+  norm_num
```

With that local one-line patch, `lake build` still passes, and

```text
#print axioms farey_13_15
```

reports only `[propext]`.

For the large power inequality

```lean
(3 : Nat) ^ 10781274 < 2 ^ 17087915
```

I tried direct `norm_num` and direct `by decide` in scratch files. Under the
tested settings, neither gave a practical replacement:

- direct `norm_num` was still running after about 2.5 minutes and I aborted it;
- direct `by decide` eventually failed with an exponentiation threshold warning
  and `maximum recursion depth has been reached`.

Important limitation: I did not exhaust variants involving larger
`maxRecDepth`, larger `maxHeartbeats`, larger `exponentiation.threshold`, or
alternative `Nat.pow`/certificate-based formulations. So I would not claim that
the large numerical facts cannot be made proof-producing; only that the naive
direct replacements I tested did not remove the trust boundary.

My suggested improvements, if they match your intended scope, would be:

1. Clarify README/metadata wording to say that the repo formalises the
   lower-bound consequence of Eliahou1993, not currently the full linear-form
   Theorem 1.1.
2. Add a `CollatzCycle.numOdd_pos` lemma or a paper-facing theorem that
   discharges `hk`.
3. Add exact-period/cardinality glue: either an `ExactCollatzCycle`, a
   `PaperCycle.exists_exact_collatzCycle` bridge, or a theorem with
   `hexact : Function.Injective c.seq`.
4. Optionally replace the small `farey_13_15` `native_decide` with `norm_num`.
5. Decide whether the remaining `native_decide` trust boundary is acceptable for
   the intended challenge scope, or whether you would prefer a later
   proof-producing certificate strategy for the large numerical facts.

Would you prefer the entry to be audited as "lower-bound consequence only" for
now? And would you be open to the small glue lemmas / README clarification above
before I post anything publicly or create an audit report link?

I am not making any global Collatz claim here, and I am treating this as a
private scope-and-audit coordination note rather than a public verdict.
````

## Separacion de hallazgos

### Build / mechanical PASS

MECHANICAL_PASS_REPORTED: yes.

- `lake exe cache get`: PASS after local disk space recovery and network-enabled cache fetch.
- `lake build`: PASS, `Build completed successfully (8030 jobs)`.
- `rg` scans: no `sorry`, `admit`, `axiom`, `unsafe`.
- `#print axioms` recorded for `eliahou_bound` and auxiliaries.

### Scope consequence-only

CONSEQUENCE_ONLY_SCOPE_REPORTED: yes.

Current central theorem:

```lean
theorem eliahou_bound {L : Nat} (c : CollatzCycle L)
    (hmin : (2 : Nat) ^ 40 < c.minElem)
    (hk : 0 < c.numOdd) :
    17087915 <= L
```

Current local read:
- useful lower-bound consequence formalised;
- full Theorem 1.1 linear form not found:

```text
Card Omega = 301994 a + 17087915 b + 85137581 c
```

### Exact-period / Card Omega glue

EXACT_PERIOD_GLUE_RECOMMENDED: yes.

Issue:
- paper length is `Card Omega`;
- Lean theorem concludes about indexed parameter `L`;
- `CollatzCycle L` does not currently enforce no duplicates, injectivity, minimal period, or exact orbit cardinality.

Recommended options:
- `ExactCollatzCycle`;
- `PaperCycle.exists_exact_collatzCycle`;
- theorem variant with `hexact : Function.Injective c.seq` and conclusion over `(Finset.univ.image c.seq).card`.

### `hk : 0 < c.numOdd`

Recommended lemma:

```lean
theorem CollatzCycle.numOdd_pos {L : Nat} (c : CollatzCycle L) :
    0 < c.numOdd
```

Reason:
- `hk` is an additional Lean hypothesis compared with the paper-facing statement;
- it appears mathematically derivable for positive compressed cycles.

### Native decide trust boundary

TRUST_BOUNDARY_REPORTED_WITH_LIMITS: yes.

Recorded axiom boundary:

```text
'eliahou_bound' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound]
```

Interpretation:
- remaining `native_decide` facts make the theorem depend on native evaluation/compiler trust;
- this is not an `axiom` declared by the repo;
- it is still a relevant audit boundary.

Limits:
- did not exhaust `maxRecDepth`;
- did not exhaust `maxHeartbeats`;
- did not exhaust `exponentiation.threshold`;
- did not test all possible `Nat.pow` direct variants;
- did not design certificate-based replacements.

### Small `norm_num` replacement

Confirmed local patch:

```diff
 theorem farey_13_15 : 301994 * 10781274 - 17087915 * 190537 = 1 := by
-  native_decide +revert
+  norm_num
```

Result:
- `lake build`: PASS.
- `#print axioms farey_13_15`: `[propext]`.

### Large `norm_num` / `decide` probes

Tested fact:

```lean
example : (3 : Nat) ^ 10781274 < 2 ^ 17087915 := by
  norm_num
```

Result:
- no result after about 2.5 minutes;
- aborted manually;
- classified as too slow for direct `norm_num` probe.

Tested fact:

```lean
example : (3 : Nat) ^ 10781274 < 2 ^ 17087915 := by
  decide
```

Result:

```text
warning: exponent 10781274 exceeds the threshold 256, exponentiation operation was not evaluated
error: maximum recursion depth has been reached
```

Interpretation:
- direct large replacements failed under tested settings;
- trust boundary remains.

## Do not send checklist

Before sending any author-first contact:
- confirm whether to send as GitHub issue, email, or Discussion comment;
- decide whether to include the optional `farey_13_15` diff inline;
- decide whether to attach local notes or summarize only;
- ensure no Forum post is made first;
- ensure no audit link is created first.

## Classifications

- AUTHOR_FIRST_PACKAGE_READY_FOR_REVIEW: yes.
- MECHANICAL_PASS_REPORTED: yes.
- CONSEQUENCE_ONLY_SCOPE_REPORTED: yes.
- EXACT_PERIOD_GLUE_RECOMMENDED: yes.
- TRUST_BOUNDARY_REPORTED_WITH_LIMITS: yes.
- NO_UPSTREAM_CONTACT_YET: yes.
- NO_AUDIT_LINK: yes.
- NO_GLOBAL_COLLATZ_CLAIM: yes.
