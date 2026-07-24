# F3 arithmetic-codec pilot repair v2 contract v1

Status: `EXECUTION_NOT_AUTHORIZED_PENDING_HUMAN_GATE`

Date: 2026-07-24.

This is a new static gate prepared after the immutable v1 STOP.  It does not
authorize Lean, Lake, compilation, audit execution, retry, or publication.

## 1. Separate custody

The v2 branch forks exactly from the final v1 custody commit:

```text
branch = codex/hilo2-f3-pilot-repair-v2
parent = ef6513aec7899ad0ab7ac896abc595e57eedb616
```

The v1 evidence remains untouched:

```text
v1 run report sha256 =
23a2a24ceda2790b8631a5d79a2fa27e63c249b9e6d90c869b3e5599d956bef4

v1 raw compile log sha256 =
619fd7361557309f4f5519f22cba5fe304ac1c00409da62f5c170446290fcfc2
```

No v1 report, log, result label, or attempt ledger may be rewritten by this
gate.

## 2. Frozen v2 inputs

```text
v1 stopped repair source sha256 =
567d48c19b2b5bd2321e6a46b5a39dd9b54b8714adac7f6636a46405393bbf4d

v2 static repair source sha256 =
80be816012ebc0da09b1e86bfaa5c4eb482ccb5dbd7f4b4913d117ce9c1f408c

unchanged axiom audit sha256 =
a8e05246e9726afb79c25e206a90f86b12a50a0803251c50cf8b856eae40e0f1

unchanged explicit inventory sha256 =
611bfc53a028e224c71ceb9287a01dd3587e9300e889c7facbb21fb5183ce74f

unchanged checker sha256 =
18d2e368b5e73519ec5d701cee59177982bc1f6a750b1b5546d8568866761e9e

ExactCoreMatrix source sha256 =
58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5

donor ExactCoreMatrix olean sha256 =
34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
```

## 3. Exactly two proof mechanisms

Statements, definitions, data, channel formulae, ranks, lists and matrix
construction are byte-identical to v1.  The source diff contains exactly two
proof hunks.

### 3.1 Reuse the proved encoder congruence

The failed v1 proof asked `omega` to rediscover a theorem through subtype
projections.  Each of the three disjunction branches now reuses the existing
theorem directly:

```lean
Or.inl (by simpa [h0] using encodeNat_mod9 i)
Or.inr (Or.inl (by simpa [h1] using encodeNat_mod9 i))
Or.inr (Or.inr (by simpa [h2] using encodeNat_mod9 i))
```

This changes no proposition or computation.

### 3.2 Use the definitional retarded-position identity

The retarded branch of `pilotFrozenPos_agrees` compares two definitions with
the same position expression.  Its former solver block is replaced by:

```lean
| retarded i => rfl
```

No `change` was inserted in the static source.  Whether elaboration accepts
the definitional equality remains deliberately unclaimed until a separately
authorized gate.

## 4. Static invariants

The v1-to-v2 source diff is `+4/-13` and contains no other hunk.  In
particular:

- declaration names and count remain 151;
- the audit still has 151 matching `#print axioms` commands;
- all 12 designated final public theorems remain present;
- the environmental namespace enumerator remains present and unexecuted;
- there is no `native_decide`, `Lean.ofReduceBool`, `sorry`, `admit`, explicit
  `axiom`, table, lookup, `find?`, `HashMap`, array/CSV lookup, source case
  catalogue, or literal expected RHS;
- v1 result artifacts are outside the diff.

## 5. Resource envelope for a possible future gate

If a human later authorizes execution, the resource envelope remains:

```text
maxHeartbeats = 200000
total wall ceiling including import = 300 s
processes = 1
compile attempts = 1
audit attempts = 1 iff compile PASS
retry/resource escalation = forbidden
raw combined logs = mandatory
```

`F3_CORE_ARITHMETIC_CODEC_PILOT_BUDGET_v2.md` supplies only those resource
figures.  Its spent v1 source hashes and attempt authorization do not transfer
to this branch.  A new human gate and a new literal run report would be
required.

## 6. Future decision rule

Any nonzero compile, timeout, heartbeat exhaustion, source/hash mismatch,
missing artifact, incomplete explicit audit, environmental count mismatch,
or profile containing `Lean.ofReduceBool` or `sorryAx` is STOP without retry.
A future PASS would close only the 27-source pilot.

```text
NO_V2_LEAN_INVOCATION
NO_V2_COMPILE_PASS
NO_V2_AXIOM_AUDIT
NO_243_SOURCE_EXTENSION
NO_FULL_CORE_IDENTITY
NO_RHO_CERTIFICATE
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
