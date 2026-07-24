# F3 forward-right certificate v4 — one-line proof-repair contract

Status: `PRE_RUN_FROZEN — ONE_TACTICAL_REPAIR_AND_ONE_EXECUTION_AUTHORIZED`

Date: 2026-07-24.

Branch: `codex/hilo2-f3-forward-right-certificate-v4`.

## 1. Succession and classification

V4 succeeds the publicly custodied v3 proof STOP:

```text
v3 terminal commit          07f245e7bd617cf48a1207a9640d4091554d3510
v3 terminal-report sha256   bdff3671b045db3cf7895e4fd0d5a09d6d73e856eb0a0c07760330bbc214811c
v3 C0 raw-log sha256        6f6bfb1e59e822d58c53d8f3ca8bec090c8ec42c308cfd6122c2a947436fc009
```

V3 passed S0, D0, G0 and the C0 precheck.  Direct Lean then stopped at line
68 because `decide` could not synthesize
`Decidable forwardRightNatCertificate` while the quantified proposition was
still hidden behind its named definition.  This was a tactical/elaboration
STOP: not environmental, not a timeout and not a mathematical
counterexample.

## 2. Sole authorized source repair

The only mathematical-source change from the v3 terminal commit is the
following added tactic line:

```lean
theorem forwardRightNatCertificate_proved : forwardRightNatCertificate := by
  unfold forwardRightNatCertificate
  decide
```

The `unfold` exposes a universally quantified Nat inequality over `Fin 243`,
allowing the constructive `Nat.decidableForallFin` instance and decidability
of `Nat.le` to be synthesized.  All definitions, data, theorem statements,
the remaining proofs and the total-audit source are byte-identical to v3.

Forbidden repairs include `native_decide`, `Lean.ofReduceBool`,
`ofReduceBool`, new lookup tables, generated row witnesses, a classical
proposition-decider, statement weakening and any resource increase.

```text
v4 certificate source sha256
75fb6b9b4f89f65df7e67b0b87704b17f0814950f17418d067ac1881bddc9f88

unchanged total audit sha256
fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2

maxHeartbeats  2000000
maxRecDepth    100000
```

## 3. Fresh isolated environment

V4 is a local-artifact continuation using the same frozen donor and package
snapshot as v3, but it creates a new overlay:

```text
.lake/f3-forward-right-certificate-v4-overlay/lib/lean
```

The v3 overlay is preserved as evidence and is never copied, read through
`LEAN_PATH`, or accepted as a v4 input.  S0 must create the v4 overlay from
the 206 individually frozen donor `.olean` files and the four separately
custodied objects.  The expected fresh stage is 209 `.olean`, zero `.ilean`,
209 regular files and zero symlinks.

```text
donor HEAD                    7b7a80efa6ceea6c977821e55bcc832d654551dc
donor manifest sha256         854f95f26e69ed5fa6aace21e165ef6f49d58798fe966969d449436a43f33e48
expected-stage manifest       38b665480af7b7596b53fedc1621343f30913b6f636e8ae6daf17654e094c5bf
Lean 4.21.0 binary sha256     c89073b8a577a5914ead7b740d2ad996af1ad5ad5b4bfc2825e0bce2f01b6aa4
gtimeout sha256               1ce578c938781a82c5bf7fd3fb2a1b9515f4f2486eb3c6511d0b2b4ec822bb1e
gsort sha256                  3e2705341516948679e48b245297318a2e79086639d02f8878404e3a9cb30b97
```

The package revisions, external object-root counts and hashes, repository
configuration hashes, anti-shadowing checks and single-Collatz-root
requirements are identical to the v3 contract and are rechecked by the
frozen v4 scripts.  Lake, network access, cache installation and `tar` remain
outside the execution path.

## 4. Frozen executors

```text
common       5e3d1cd4094dfb5bbd5c42c13a31ed22987fb9cafe65696b97c37c3d7ce66e4e
stage        72ebfc1f90be660964ef8432d8f2387e8826f9072e84e8bbf0d53407c7974470
probe        9a6af2caf54bc54622cc00c2bd64d4ba360f310dcce0254c8fdbb9a2a688ba44
compile      42835dd270775069f01e05a23265dc10d6967ca6513f248f11f7d1f2abd73a7d
audit        e12d52ed0b1591472155706855a4ad8f76e468a7e87ac214291630cf74d527b4
K1           0ea9abd958623fad8c869e587327c6a5ab1954ceef3c755ae2b6fc535bd5ce24
executor     11a3c8c0b7f6d0755ccc0123e5cd31bd2c422519b6c5653170bedfb6e8a472d7
```

These hashes, the two manifests and the source/audit hashes are binding.
Any correction after public freeze requires a successor contract.

## 5. Authorized phases

Every phase is invoked only through the v4 executor.  Each log is created
with `noclobber`; there is exactly one attempt per phase.

### S0 — fresh isolated stage, 600 seconds

Requires the v4 overlay to be absent.  It creates and verifies the exact
209/0/209 stage and proves global absence of target/audit objects.

### D0 — direct import probe, 600 seconds

Imports the three direct dependencies and checks their three required
producer theorems.  It creates no target object.

### G0 — mandatory public gate

After S0 and D0 PASS, both immutable logs and a report binding their hashes
are committed and pushed.  C0 requires local HEAD to equal the public v4
remote-tracking branch.

### C0 — certificate compile, 1,800 seconds

One direct-Lean invocation, with the unchanged heartbeat and recursion
limits, may create exactly the target `.olean/.ilean`.  PASS is
210 `.olean`, one `.ilean`, 211 regular files and global target uniqueness.

### A1 — total axiom audit, 1,200 seconds

Only after C0 PASS.  It binds the exact target hashes and may create exactly
the two audit objects.  PASS is 211 `.olean`, two `.ilean` and 213 regular
files.

### K1 — coverage and cone audit, 120 seconds

Only after A1 PASS.  It requires 21/21 stable declarations and complete
namespace-profile coverage; stable profiles may contain only
`[propext, Classical.choice, Quot.sound]`.  Generated auxiliaries are checked
separately against that trio plus `lcProof`.  Complete source and log scans
reject `Lean.ofReduceBool`, `ofReduceBool`, `sorryAx`, `sorry`, `admit` and
`native_decide` as applicable, and C0/A1/K1 object hashes and HEADs must link
cryptographically.

## 6. STOP and scope

There is no retry, cleanup, warm-overlay reuse, fallback tactic or resource
increase under v4.  A false reduction, heartbeat exhaustion, timeout,
elaboration error, audit mismatch or precheck failure is terminal evidence
and must be custodied and pushed before any successor is considered.

A terminal PASS proves only the finite forward row-growth certificate and
its generic weighted-mass step.  It does not prove the semantic
operator-to-fibres bridge, first-hit inequality, F3 exponent, density theorem
or Collatz conjecture.

```text
NO_LAKE
NO_TAR
NO_NETWORK
NO_V3_OVERLAY_REUSE
NO_BLOCK0_EXECUTION
NO_FIRST_HIT_GATE
NO_OPERATOR_TO_FIBRES
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
