# F3 semantic first-hit gate v1 — reconciliation

Status: `P1_RECONCILED — V1_EXECUTION_NOT_AUTHORIZED`

Date: 2026-07-24.

This note preserves the historical gate file byte-for-byte and records the
facts that were discovered after the terminal PASS of FullCoreIdentity v2.
It supersedes the execution authorization of the historical gate; it does
not rewrite its hash or its chronology.

## 1. Custody receipts

The relevant public-history base and artifacts are:

```text
FullCoreIdentity v2 terminal commit:
d7a587eb7ec1a1b5383e775a081e7ba07cbe12a0

FullCoreIdentity v2 terminal report sha256:
24998975be4123b07e8fa7c4100c057a6e9d15da20d6208dda6de6c50773aad3

Historical first-hit gate commit:
9e2ad616ee51974310ae44ab3b9c19e88e309b2e

Historical first-hit gate sha256:
b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa

Earlier finite first-hit diagnostic commit:
defac7c1e94186f97e79538f6a0a29ebdf450719
```

Git verifies that `defac7c1e...` is an ancestor of `9e2ad616...`.
The earlier diagnostic inspected the interval `[3,128)` at `y=8`.  Its
custody hashes are:

```text
script    73c4f48b6aad988cba0c7df550c253d0364205c41d2b25e6375bfbab4a2db914
report    275b19e1649b5a99df932416aa6e32bbea8e7604ba4ccb9e3da67dc22ba16185
summary   93db01001163f80e1ff0f1fbb3cef0d86a1b23d461f35662ecb383490f014f95
rows      870e40c513dabc0669f08a8efc98386a2aaef4c7c4793ec25d7d6fae67b2faf1
```

The diagnostic contains 41 admissible roots, all of which belong to the
later `Block0`.  Consequently, the historical declaration

```text
NO_BLOCK0_DATA_INSPECTION_BEFORE_FREEZE = true
```

is false in its literal form and is withdrawn.  What remains true is only
that the complete block `[3,2919)` was not executed by that diagnostic.  Any
future use must report the already observed and previously unobserved parts
separately:

```text
A_seen  = Block0 intersect [3,128)      -- 41 roots
A_fresh = Block0 intersect [128,2919)   -- 931 roots
```

The endpoint `2919`, the window `y=8`, and the complete-block size are not
changed in response to this discovery.  The block is confirmatory, not a
blind holdout.

## 2. The historical statement is not executable

The names below occur only as pseudocode in the gate and do not denote Lean
declarations:

```text
formulaCoreTransition
initialBlock
retainedIndex
firstHitFiber
```

An executable successor would additionally have to fix, before inspecting
the full block:

1. the exact root subtype and the map from a root to its arithmetic state;
2. the fine-lift attached to each root and the corresponding formula edge;
3. an orientation theorem connecting the matrix used for growth to the
   direction of the semantic fibres (this is not currently available);
4. the retarded, advanced-direct, parity-lift and sterile alternatives;
5. every child window and first-entry predicate;
6. a computable Boolean checker proved equivalent to the Prop-level
   first-hit predicate;
7. a definition of the boundary carrier and its exact denominator;
8. the contribution attached to each tagged occurrence, including the
   formula-edge multiplicity;
9. the equality identifying the sum of those contributions with the stated
   operator mass.

The existing `firstHitSource` is insufficient as an executable checker: it
uses a classically decided existential predicate, covers only the advanced
source kinds, and does not encode a full tagged path or first omission.

Two interface mismatches are also explicit.  The existing aggregate bridge
uses one common window, whereas the gate declares `window0(a)=256*a`; and the
existing operator witness expects undiscounted mass, whereas the gate places
`241/443` outside the mass.  Neither mismatch may be hidden by renaming a
discounted population as `initialBlock`.

There is a stronger orientation mismatch.  `fullFormulaMatrix s t` is built
from formula edges whose arithmetic source is `s` and arithmetic target is
`t`.  Those are the forward parent-to-child edges realized by the existing
`piStar` injections.  The frozen numeric vector, however, passed the left
certificate, and the bridge turned that into growth by defining

```text
coreTransition s t = coreMatrix t s.
```

This transition follows incoming formula edges.  The existing first-hit
fibres do not realize it.  Conversely, using the forward matrix preserves the
semantic edge direction but the historical audit records 135 failed rows for
the same frozen vector.  Transposition is therefore not a harmless API
choice: a successor needs either a newly certified forward vector or a new
semantic realization of the reverse transition.  Neither exists in the
current dependency cone.

## 3. The one-layer inequality is not the semantic hook

Let

```text
W(mu) = sum_s mu(s) * w(s),
(P mu)(t) = sum_s mu(s) * M(s,t).
```

The actual open hook needed by the existing conditional bridge has the form

```text
for every n,
  W(P^n mu0) <= sum_{a,i} card(F(n,a,i)).
```

The historical gate asks only for

```text
(241/443) * W(P mu0) <= sum_{a,i} card(F(1,a,i))
```

on one finite block.  A PASS would therefore not prove preservation in
`n`, uniformity in `y`, global disjointness between depths, or that an
element is never reused by two stopped paths.

The claimed constants must also remain separated:

```text
epsilon             = 2/243
local retention     = 1-epsilon = 241/243
q                   = (241/243)*(100/101) = 24100/24543
global debt         = epsilon/(1-q) = 202/443
global retained part= 1-202/443 = 241/443
```

The equalities defining `q` and `202/443` are kernel-clean Real arithmetic,
but their F3 denominator is not established.  The script that introduced
`N_block=243` counts 243 representatives in each fine lift only after
aggregating one representative from each of the 243 states.  In the same run
it records three representatives per individual state.  It then divides the
claimed boundary of at most two roots *per state* by the global cross-state
count 243.  The numerator and denominator therefore belong to different
carriers.  The separate uniform-Q script also filters only the residue modulo
243 and does not enforce the parity/bucket part of a core state.
Consequently, `epsilon=2/243` and `eta=202/443` are not F3 bounds in the
current chain.

Even after a denominator repair, `241/443` would be the result of the uniform
debt telescoping, not a local one-step retention fraction.  It may not be used
to justify the same telescoping from which it was obtained.  The sentence in
paper versions v3.0 and v3.1 saying that a step "retains at most
`1-epsilon`" is reversed: a boundary loss of at most `epsilon` yields
retention of at least `1-epsilon`.  The historical paper files remain
unchanged; this note is the erratum of record for this branch.

A one-state sanity model makes the insufficiency concrete.  Take `P=1.01`
and reuse the same singleton as the fibre at every depth.  The one-layer
test passes because `(241/443)*1.01 < 1`, but
`(241/443)*1.01^n > 1` from a finite depth onward.  Member-wise checks inside
one layer do not prevent this reuse.

## 4. Correct scope and decision

The historical v1 gate is reclassified as:

```text
N1_FINITE_DIAGNOSTIC_NOT_EXECUTABLE_AS_WRITTEN
```

Once its objects are defined exactly and a valid denominator is supplied, a
failure could falsify that concrete one-layer realization.  With the current
mixed denominator, even that execution is unauthorized.  A PASS of the old
numeric target would be a finite inequality only; it would not close
`operator_to_fibres`, Lema A, the F3 exponent or a density theorem.

No full-Block0 computation was executed after FullCoreIdentity v2 while
preparing this reconciliation.  The next authorized work is definition-first
and data-free: first choose and certify a forward semantic operator, then
build and audit the tagged path ledger, root-dependent window bridge,
multiplicity-preserving operator identification, first-omission partition,
and a boundary estimate on one explicitly shared carrier.  Only a later,
separately frozen contract may authorize a finite computation.

```text
NO_FULL_BLOCK_EXECUTION
NO_SEMANTIC_HOOK_PROVED
NO_F3_EXPONENT_THEOREM
NO_DENSITY_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```
