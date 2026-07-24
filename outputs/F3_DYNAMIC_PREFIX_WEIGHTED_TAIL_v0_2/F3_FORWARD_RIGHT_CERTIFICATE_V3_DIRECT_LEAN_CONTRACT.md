# F3 forward right certificate v3 — isolated direct-Lean contract

Status: `PRE_RUN_FROZEN — ISOLATED_ENVIRONMENT_AND_ONE_EXECUTION_AUTHORIZED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v3`.

## 1. Succession and reason

V3 succeeds the terminal v2 environment STOP:

```text
v2 terminal commit          0dc5c5bd43c3f9f347b1db3a59edd4f028a1249f
v2 terminal-report sha256   438c2e3c4e575a2ad295097e4b774abf5cc990b659ce22bfde3124ac3187ffbc
```

V1 stopped before Lean because dependencies were absent.  V2 stopped before
Lean because `tar` could not establish its default locale while installing
`leantar`.  Neither attempt elaborated the certificate.  V3 changes no
mathematical source or proof resource.  It removes Lake, network, cache
installation and `tar` from the execution path.

The partially populated local `.lake/packages` from v2 is preserved as
evidence but is excluded from every v3 path.

## 2. Frozen mathematical state

```text
certificate source sha256   37932fd8198e045c436c479455a362afb9b2ef720b2138c1f3308f552e16a4ab
total audit sha256           fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2
lake-manifest sha256         230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
lakefile sha256              e31ac41ac108fbd7e30db1bc982a065949d359146e110ee04212378645e54fca
lean-toolchain sha256        d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
FullCoreIdentity report      24998975be4123b07e8fa7c4100c057a6e9d15da20d6208dda6de6c50773aad3
maxHeartbeats                2000000
maxRecDepth                  100000
```

The vector, coefficients, Nat certificate, orientation and theorem targets
remain byte-identical to v1/v2.

## 3. Binary-snapshot provenance

V3 is explicitly:

```text
LOCAL_ARTIFACT_CONTINUATION
NOT_FRESH_CLONE_REPRODUCTION
```

The base Collatz object snapshot comes from donor HEAD
`7b7a80efa6ceea6c977821e55bcc832d654551dc`.  Its tracked state is clean;
untracked source files exist and are not inputs.  The 206 regular donor
`.olean` files are frozen individually by path and hash:

```text
donor manifest count         206
donor manifest sha256        854f95f26e69ed5fa6aace21e165ef6f49d58798fe966969d449436a43f33e48
```

The nine package checkouts are clean and at the exact revisions in
`lake-manifest.json`.  The absolute Lean 4.21.0 binary is frozen at:

```text
c89073b8a577a5914ead7b740d2ad996af1ad5ad5b4bfc2825e0bce2f01b6aa4
```

S0 overlays four previously custodied F3 objects inside the same package
root; `ExactCoreMatrix` replaces a byte-identical donor object and the other
three are new to that snapshot:

```text
ExactCoreMatrix              34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
PilotRepair                  480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
FullBlockDecoder             225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
FullCoreIdentity             b97217ba7cd34ce4d1d5b2c4dc76a31537d6be1693eb51eda523256df6597a18
```

The exact post-stage manifest contains 209 `.olean`, zero `.ilean` and zero
symlinks:

```text
expected-stage manifest sha256
38b665480af7b7596b53fedc1621343f30913b6f636e8ae6daf17654e094c5bf
```

## 4. Frozen executors

```text
common       8f36d9c732d72a6dda198453e83b82967b771779ec35f90668fab91ba6efd6e0
stage        44c020e272f0f4f4433186bf5e6c8a5a436c0aefd4ff35585cce625b98a81f86
probe        3231ce136b1bfd274e235f4dbd5a50faaba561032a10c016d6b41f3901082960
compile      50ce7e52636e3c6b0d19be1650fc1b1b3ee0b79e51d933303ba3031aa5c14ebe
audit        adc677d113b578412eb5dc7cda2e4ec78c58ce4c9068b9c0cadcbd45047d096c
K1           5d352266b266e608416df0b24fd8593d2aa74bb93bcd0c4b6fbbfb03c1ad13a8
executor     8f49cac681463e47d0cd9d92a412619965e02a1af60534e0749243887b1c094e
```

These hashes are binding.  Any correction requires a new public contract.

## 5. Single-root environment

The only `LEAN_PATH` root containing `CollatzClassical/` is:

```text
.lake/f3-forward-right-certificate-v3-overlay/lib/lean
```

It is followed by the nine declared donor package paths and the Lean 4.21.0
toolchain root.  `Cli` has no build root and its exact absent path is retained
as a declared empty entry.  All eight existing package roots and the
toolchain are canonicalized and proved distinct; none contains
`CollatzClassical/`.

Every external `.olean` root actually used by Lean is also frozen by count
and relative-path aggregate hash:

```text
batteries          166  a42cce539747cd563e1508d92f0034326f6ebe2166c274711988563edc208b71
Qq                  13  a95375382efac5c6b9f12e0f2e9fb473e5544fa087f8a4e25afb0594837015cc
aesop              130  7232c728ec3a22797745f7b3e7cecacd5c9cd1edcd1a77e2c426527d29852c5d
proofwidgets        12  3407ea51e182c0b9aa85c4be6ff78eb5358cb73621a62721030e39772df1d981
importGraph          2  10261c7dac2b52e338bf5469824dfc1194da14479516c324356ecbe2ee348f7c
LeanSearchClient     4  fabc5729cbc4890522c7ce1de09180b04d79a97d554ceac5855e54f433215b7c
plausible            8  c664c6075910c564885089d3aefafb2e7605c02de4a3763697f7d6db08f5cdfe
mathlib           6560  a058894144c9d8cb7a69ae1ac74538f3e5acb8b0bf6e2d20a4e9396797dee2cf
toolchain         1613  f0c8b62e3f1a404c0a818635f8c64c010cdc64c7c5747f56547494b3447a0495
```

Forbidden operational inputs include the local build root, donor project
build root, every older overlay as a separate root, and the partial v2 local
packages.  All phases use `LC_ALL=C`, `LANG=C`, the absolute Lean binary and
`--root` equal to this worktree.

## 6. Phases

Every phase is invoked only through the frozen executor.  Logs are created
with `noclobber`; predecessor markers and hashes are mandatory.

### S0 — isolated stage, 600 seconds

Create the root once by clone-on-write copying only the 206 inventoried
donor `.olean`, then overlay exactly the four objects in section 3.  PASS is
209/0 objects, zero symlinks, full manifest verification, and global absence
of target/audit objects.

### D0 — import and resolution probe, 600 seconds

Use direct Lean `--stdin` to import the three direct inputs and `#check` their
key producer theorems.  It creates no object.  It repeats package, manifest,
binary, anti-shadowing and global-freshness checks.

### G0 — mandatory public gate

After S0 and D0 PASS, their immutable raw logs and a report containing both
log hashes are committed and pushed.  C0 requires local HEAD to equal the
public remote-tracking branch and verifies the report/log binding.

### C0 — certificate, 1800 seconds

One direct-Lean invocation writes exactly the certificate `.olean/.ilean`
inside the composite root.  It repeats the complete environment gate before
and after Lean.  PASS changes the counts to 210 `.olean`, 1 `.ilean`, 211
regular files and globally unique target objects.

### A1 — total audit, 1200 seconds

Only after C0 PASS.  The audit must consume the exact two target hashes
printed by C0, then create exactly its `.olean/.ilean`.  PASS changes counts
to 211/2/213 and preserves every input and target hash.

### K1 — coverage and cone audit, 120 seconds

PASS requires:

- exact 21/21 source declarations and explicit `#print axioms` entries;
- one namespace count and the same number of uniquely named profiles;
- every one of the 21 stable profiles contained in
  `[propext, Classical.choice, Quot.sound]`;
- generated compiler auxiliaries separately contained in that set plus the
  nonlogical compilation marker `lcProof`;
- whole-log absence of `Lean.ofReduceBool`, `sorryAx` and `native_decide`;
- source absence of `native_decide`, `ofReduceBool`, `sorryAx`, `sorry` and
  `admit`;
- cryptographic C0 → A1 → K1 linkage and uniqueness of all four new objects.

## 7. STOP and scope

There is one attempt per phase and no retry, cleanup or resource increase
under v3.  Failure is custodied and pushed.  V3 is the final environmental
rerouting: an actual C0 elaboration, tactic, heartbeat or certificate failure
must be treated as proof evidence, not as another environment excuse.

A terminal PASS proves only the forward row-growth certificate and its
generic weighted-mass step.  It does not prove the semantic
operator-to-fibres bridge, first-hit inequality, F3 exponent, density theorem
or Collatz conjecture.

```text
NO_LAKE
NO_TAR
NO_NETWORK
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_OPERATOR_TO_FIBRES
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
