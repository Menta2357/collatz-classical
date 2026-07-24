# F3 full core identity static review v1

Status: `CONDITIONAL_STATIC_PASS / LITERAL_RFL_NOT_EXECUTED`

Date: 2026-07-24.

Base: `codex/hilo2-f3-full-block-decoder-v1@39904f70fdfa1ec241d964fb36cbfbb862960ef6`
(public draft PR #13).

## 1. Exact mathematical chain

The source contains nine declarations and one import.  Its only reduction of
the historical 729-entry object is

```lean
coreEdges = List.ofFn corePositionRealize := by
  rfl
```

The audited decoder already proves
`corePositionUnrank (frozenPos e) = e`.  Therefore the normalization gives a
position witness for every `realize e` in `coreEdges`.  Enumerating all
formula edges gives `formulaCoreList ⊆ coreEdges`.  The formula list is
structurally Nodup and has length 729; the normalization gives the frozen
list the same length without invoking the historical native edge-count
certificate.  The previously compiled saturation lemma then yields
`coreEdges.Perm formulaCoreList`, preserving multiplicity.  Filtering that
permutation by the identical source/target predicate and folding with
commutative addition gives the matrix equality.  There is no transpose or
ordered-list equality claim.

No right inverse for `corePositionUnrank`, new equivalence, assumption that
`coreEdges` is Nodup, or native finite theorem is used.  The chain is not
circular: the decoder and formula-side Nodup proof do not mention the full
literal.

## 2. Coverage and prohibited routes

Static name comparison passed exactly 9/9/9 for source, declaration inventory
and `#print axioms` commands.  Seven terminal theorems are designated.  The
source has exactly one literal-normalization statement with the required
generated RHS.  It contains no search, lookup table, array, CSV, `fin_cases`,
placeholder, new axiom, native finite evaluation, or reference to the three
historical native certificate theorems.

The audit enumerates every declaration in the new namespace.  The checker
accepts both Lean output forms, `depends on axioms: [...]` and
`does not depend on any axioms`, treats the latter as `[]`, handles multiline
profiles, and whitelists only `propext`, `Classical.choice` and `Quot.sound`
for all seven terminal theorems.  The independent whole-log guard rejects
`Lean.ofReduceBool` and `sorryAx` anywhere in the environmental output.

## 3. Custody and execution hardening

Two P1 classes were found and corrected before freeze:

1. the first checker draft rejected a genuinely empty axiom profile;
2. the first wrapper draft did not cryptographically bind C0, A1 and K1 or
   record an outer timeout/status in every phase log.

The corrected phase executor creates each log with `noclobber` before running
its phase precheck, so either a failed predecessor check or an attempted phase
cannot be invoked again through the executor without deleting its custody
log.  It pins the real 640-profile v6 audit log, applies the frozen timeout,
appends the outer exit status for normal exits and timeouts, and requires the
prior phase's unique PASS/zero markers.  C0 records source, upstream-object
and produced-object hashes.  A1
requires that C0 record and the same produced identity objects, then records
its source/audit and audit-object hashes.  K1 cross-checks both logs against
all seven current overlay objects, checks source/audit hashes again at the
end, and performs total profile coverage.  Source and audit wrappers also
rehash their inputs after Lean returns.

The new overlay stages exactly three regular `.olean` files, no `.ilean` or
audit object, and no symlink.  Later `LEAN_PATH` roots contain no
`CollatzClassical` directory.  This remains a local-artifact continuation,
not a fresh-clone reproduction.

## 4. Frozen draft hashes

```text
source = df1e2a1582e02c9c73c354ecb72705bd828a61ab53501bd88a7d2bf6e654937b
audit = 7a712c1844f799e43c4be26707b4ea71b5c424322c010098bdc48843ce4e2796
inventory = 3cf3d62def66d381f609192ae44114afe6b43e455fa2b2ff11847618723aa7a4
checker = 2da25a2ea0bae570057b7be8a5f4102694eeb681e49eb36988ffd95caec9456c
overlay stage = 1633ddeba4552e2b81e802b05454f9d2861efa3bac4fde6b169090e7dda0407e
compile wrapper = cfc6a1a353d830820cb42cf05ef6605eda15333cfa7a00eac681c4cfda2f3fbf
audit wrapper = 97f5fa1fd207ab1e59a534d1a11c903ee2384542add1d8ca69c7dedd61cd1b93
phase executor = e1c67e8d24851bb311f027c2d7ca11f51e437dad09c2fbf44f810bceb10b68ea
decoder-v6 audit log = 76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace
```

## 5. Remaining risk and scope

No Lean, Lake, runtime guard or phase executor was invoked in this review.
The full literal normalization is deliberately still unproved.  It can fail
because the literal order differs from the symbolic position formula or
because elaboration exceeds the predeclared resources.  Such a result is a
STOP for this normalization architecture, not a refutation of F3.

A PASS would establish only the exact finite 243-source/729-edge frozen core
identity and its matrix formulation.  It would authorize freezing the
already predeclared first-hit execution gate; it would not itself prove the
first-hit inequality, exponent 0.848, a density theorem, or Collatz.
