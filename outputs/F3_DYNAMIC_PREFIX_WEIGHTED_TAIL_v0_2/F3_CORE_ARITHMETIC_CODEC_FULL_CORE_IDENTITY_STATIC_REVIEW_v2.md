# F3 full core identity static review v2

Status: `STATIC_DESIGN_REVIEW_COMPLETE / BASH_N_5_OF_5_PASS / CHECKER_NOT_EXECUTED / LEAN_NOT_EXECUTED`

Date: 2026-07-24.

Base: `codex/hilo2-f3-full-core-identity-v1@9ae5027f8e828fc3d42b099e6740e6665bce1831`
(public draft PR #14).

## 1. Reason for the successor

The v1 C0 attempt stopped after 121.63 seconds with two elaboration errors.
The 729-entry literal normalization produced no diagnostic and was available
to the following declaration.  The failures were instead:

1. unrestricted `simp` exceeded its step limit while proving the length of
   `List.ofFn`; and
2. dot notation left the folding function of `List.Perm.foldr_eq'`
   under-instantiated, so the commutativity callback could not determine the
   intended real-valued operation.

The immutable parent evidence is:

```text
v1 terminal report = 008f88f525e431717e6f4954c400c2de6ff47ca1e950ee8c14c3a27616e23e3a
v1 R0 log = 6cc31ee430fb5a0c28032bdc5b6a91387f15a62f37653c3b7d4d1e23c5ab55f3
v1 S0 log = 6cff016f93d41eb24ef8daae893c86ab1ec27bd76a20f1e3c2ab34b4e9de2963
v1 C0 STOP log = fb0a2e3f780d65bdf2310fdf5916002797b76fb84a0408447c0afbd66a3cfa20
```

No v1 report, log, overlay object or result label is edited or reused as a
v2 runtime result.

## 2. Exact source delta

The source differs from the parent in exactly two proof bodies, with a Git
diff of `+9/-4`.  No statement, definition, data, import, namespace or
declaration name changes.

The length proof replaces the failed search by the exact core theorem:

```lean
theorem coreEdges_length_kernel : coreEdges.length = 729 := by
  rw [coreEdges_position_normalization]
  exact List.length_ofFn
```

The matrix proof makes every formerly ambiguous argument explicit:

```lean
exact List.Perm.foldr_eq'
  (f := fun (e : CoreEdge) (acc : ℝ) =>
    channelWeight e.channel + acc)
  (coreEdges_perm_formulaCoreList.filter
    (fun e => e.source = s ∧ e.target = t))
  (fun x _ y _ z =>
    add_left_comm (channelWeight y.channel)
      (channelWeight x.channel) z)
  (0 : ℝ)
```

The core signature of `List.Perm.foldr_eq'` asks for
`f y (f x z) = f x (f y z)`.  After fixing `f`, its callback is exactly
`add_left_comm (channelWeight y.channel) (channelWeight x.channel) z`.
No normalization tactic, finite decision procedure or hidden lookup is used.

The resulting source hash is:

```text
6bfd513abedf81c980e818b20efff46fc720dafabb710031c0e5aba1d5abffad
```

## 3. Mathematical scope remains unchanged

The proof chain remains:

1. the sole full-literal `rfl` identifies `coreEdges` with the positional
   decoder;
2. the compiled left inverse supplies a position witness for every formula
   edge;
3. formula-side Nodup, subset and the common length give a list permutation;
4. filtering the permutation by the same source/target predicate and folding
   by commutative real addition gives the matrix equality.

There is still no right inverse, ordered-list equality, assumption that the
historical literal is Nodup, native edge-count theorem, first-hit result,
exponent or density statement.

The audit source and declaration inventory remain byte-identical at 9/9/9:

```text
audit = 7a712c1844f799e43c4be26707b4ea71b5c424322c010098bdc48843ce4e2796
inventory = 3cf3d62def66d381f609192ae44114afe6b43e455fa2b2ff11847618723aa7a4
```

The new checker additionally requires the exact source hash, the direct
`List.length_ofFn` proof, the explicitly typed folding function,
`add_left_comm`, `(0 : ℝ)`, and zero occurrences of `ac_rfl`.

## 4. Independent overlay and environment

V2 uses a new overlay:

```text
.lake/f3-full-core-identity-v2-overlay/lib/lean
```

It is seeded directly from the terminal-PASS FullBlockDecoder overlay, not
from the v1 STOP overlay.  It copies exactly three regular `.olean` files:

```text
ExactCoreMatrix = 34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
PilotRepair = 480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
FullBlockDecoder = 225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
```

The compile and audit wrappers put only the v2 overlay before the nine
package roots and the Lean 4.21.0 toolchain.  They exclude the v1 overlay,
the donor decoder overlay and both local/donor project build roots.  Gate 0
must separately verify that no later root contains `CollatzClassical/`.

Expected overlay regular-file/symlink counts are 3/0 after S0, 5/0 after C0
and 7/0 after A1.  Every wrapper binds its predecessor log and hashes its
source and objects before and after the Lean invocation.

## 5. Execution and custody design

The new executor owns five fresh logs under a fresh result directory.  It
creates each log with `noclobber` before its precheck, validates all immutable
parent evidence and subordinate-script hashes, requires unique predecessor
markers and applies `gtimeout --kill-after=5` only after precheck PASS.

The executor intentionally does not contain its own hash: embedding it would
be self-referential.  Its hash is controlled externally by the contract and
pre-run report.  The public branch/HEAD equality is likewise a publication
Gate-0 fact because a tracked executor cannot embed the hash of the commit
that contains itself.

Frozen script hashes at this review stage are:

```text
overlay stage = 9cb0da0964be1528ef71a1232256719757ce84dd10b7a142260223c59198b7c7
compile wrapper = 7a7cb21807a188d51b5efadf711c9d765c1e0bb9d765da1f46b0382241282e3d
audit wrapper = 3dc1cfd4d673954ab5015f4eea2b1befa88f0040d1556ed7079faf949e5f3347
inventory checker = b5e46c42b9b139b0ec203483283c2eb7e19b5bfa7075b7612b1b9cb5e21ca83a
phase executor = 77e605f6ad947d91de9a9bf9a6f7e5d6ee704c47ab6f174493c1cedef6878ed2
```

The caps remain 60/120/600/450/60 seconds for R0/S0/C0/A1/K1.  The Lean
source retains 200000 heartbeats and recursion depth 100000.  There is no
resource increase relative to v1.

## 6. Static-review limitation

This document is a source-and-contract review only.  No Lean, Lake, phase,
wrapper, inventory checker, audit-log guard or guard regression command was
invoked while preparing it.  After the scripts were final, `bash -n` was
invoked exactly once on each of the five v2 scripts; all five returned zero.
File hashes were read, but no generated overlay, runtime log or Lean object
was created.

Consequently, the explicit repairs remain uncompiled and the new scripts
remain unexecuted.  Publication and a complete Gate 0 are mandatory before
R0.  A future PASS would establish only the finite 243-source/729-edge core
and matrix identity and would open only a separately frozen first-hit
execution contract.
