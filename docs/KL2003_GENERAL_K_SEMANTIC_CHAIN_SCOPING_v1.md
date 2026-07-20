# KL2003 general-k semantic chain scoping v1

Date: 2026-07-19

## Status and purpose

This note scopes the source-faithful formal chain that is still missing between
the verified flat `L_3^NT` certificate and a concrete `piStar` lower bound.
It replaces the inaccurate description of that work as one "general-k lemma"
with five separately reviewable Lean modules.

The first required consumer is `k=3`. The later `k=9` route remains
conditional on both this chain and a separate resource measurement. The
`k=11` route remains deferred.

No Lean theorem is claimed by this note.

## Primary source

Local source:

```text
/Users/MoiTam/Documents/Codex/2026-07-05/
  tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/
  kl2003_src/30apr02.tex
```

SHA256:

```text
04fa4d484fe89256f6771f5651338891219385f6e049ffaf41035541016232cd
```

Decisive source ranges:

```text
30apr02.tex:379-417    phi_k^m, P1/P2/P3, tracked classes
30apr02.tex:426-452    D1/D2/D3 and the three-way minimum
30apr02.tex:494-570    L_k^NT and its principal/auxiliary variables
30apr02.tex:584-597    Theorem 2.1, the final general-k contract
30apr02.tex:668-784    splitting and the parametric deletion rule
30apr02.tex:794-858    Theorem 3.1, termination and order independence
30apr02.tex:860-1019   Theorem 3.2, semantic preservation
30apr02.tex:967-1006   totally non-critical deletion argument
30apr02.tex:1022-1056  explicit EL growth statistics
30apr02.tex:1170-1195  equivalence of the initial LP presentations
30apr02.tex:1201-1301  Theorem 4.1, LNT-to-EL feasibility transfer
30apr02.tex:1335-1438  Theorem 5.1, retarded lower-bound induction
30apr02.tex:1440-1478  composition proving Theorem 2.1
```

The source contains known typographical/indexing defects. In particular, the
definition at line 382 says `3^j` where the surrounding definition requires
`3^k`, and the printed L4 offsets at lines 532 and 534 conflict with P3 and
with lines 558-561. Every normalization must be listed in a source-fidelity
table and tested by the `k=2` regression before it enters a theorem.

## Existing baseline

The repository already proves the complete `k=2` surrogate by a specialized
route:

- `K2PhiSystem` names exactly the classes `2`, `5`, and `8` modulo `9`;
- `I2ELAbstractRowsV3` contains the source-faithful `phi25` arm;
- `m0c_retarded_induction_bound_v3` proves the specialized induction;
- `concretePhi` uses a `Nat.ceil` window and padded shifts;
- `concretePhi_rowsV3` discharges the specialized seam; and
- `kl2003_k2_m1_surrogate_arbitrary_x_lower_bound` packages the result.

These theorems remain unchanged. They are regression oracles and reusable
lower-layer semantics, not definitions from which the general-k system may be
inferred.

The `k=3` pilot currently proves only certificate/data validity:

```lean
k3_pilot_certificate_verified : K3PilotCertificateVerified
```

It verifies nine `L_3^NT` rows, exact positive slacks, endpoint bounds, and
the generated EL data. It does not yet connect that data to `piStar`.

## Window-policy decision

The paper writes `pi_a^*(2^y a)`, where the counted integers satisfy a real
upper bound. The source-faithful Nat realization of that count is therefore:

```lean
noncomputable def sourceWindow (y : Real) (a : Nat) : Nat :=
  Nat.floor ((2 : Real) ^ y * (a : Real))
```

The new general-k chain uses this floor window. The dedicated Lean pilot
`KL2003GeneralKFloorWindow.lean` now proves the three required properties:

1. It matches the cardinal interpretation of `n <= 2^y * a`.
2. The D1/D2/D3 advanced-window comparisons should require no epsilon pad.
3. For natural `x` and `y = logb 2 (x/a)`, `sourceWindow y a = x`.

This is not a migration of the existing `concreteWindow`, which remains a
`Nat.ceil` definition and remains the honest window of the proved `k=2`
surrogate. The two realizations must have different names and no theorem may
silently rewrite one into the other.

The pilot proves the exact `4a` retarded identity, exact `2c` parity identity,
the D3 advanced comparison at `alpha - 1`, the D1 lifted comparison at
`alpha - 2`, and the natural-logb self-window identity. No rounding loss or
epsilon pad enters this policy. Module 1 must still prove the full member-wise
rows and P3; this traffic result alone is not a semantic seam.

## Module 1: general-k semantics and original rows

Proposed file:

```text
CollatzClassical/KL2003/KL2003GeneralKSemantics.lean
```

### Data model

The module should define an indexed system rather than a structure with one
field per residue:

```lean
def modulus (k : Nat) : Nat := 3 ^ k

def TrackedMode (k : Nat) :=
  {m : Fin (modulus k) // (m : Nat) % 3 = 2}

def AdmissibleMode (k : Nat) :=
  {m : Fin (modulus k) // (m : Nat) % 3 != 0}

structure GeneralKPhiSystem (k : Nat) where
  phi : TrackedMode k -> Real -> Real
```

Exact names may change, but residue reduction must be represented by types or
proved normalization lemmas, not by unchecked `%` expressions spread through
later proofs.

The concrete root domain should generalize `ClassRoots`:

```lean
def ClassRootsK (k : Nat) (m : AdmissibleMode k) :=
  {a : Nat // a % modulus k = m.1 /\ NotInCycle a /\ 1 <= a}
```

The implementation must separately prove non-emptiness or use a definition
whose behavior on an empty class cannot create false lower bounds. No
non-emptiness field may be assumed through a wrapper.

### Required semantic theorems

The module must prove:

- positivity P1 for `y >= 0`;
- monotonicity P2;
- the P3 three-way minimization between levels `k-1` and `k`;
- the parity normalization for modes congruent to `1 mod 3`;
- generic D1, D2, and D3 for all `k >= 2`; and
- the original-row contract `SatisfiesIk Phi` for the concrete system.

The expected top-level result is schematically:

```lean
theorem concretePhiK_satisfies_Ik
    (hk : 2 <= k) :
    SatisfiesIk (concretePhiK k)
```

The D1/D2/D3 proof should reuse the class-independent M0B reachability and
fiber machinery. The existing `k=2` row22 parity lift is a regression oracle
for the generic normalization, not a source for a hard-coded special case.

### Acceptance gate

Module 1 passes only if:

- all three row families are quantified over arbitrary tracked modes;
- the floor-window policy is proved compatible with every child window;
- P3 is an equality of concrete infima, not an assumed bridge;
- `k=2` specialization agrees with the V3 source contract at the unpadded
  mathematical level; and
- no generated certificate data is imported.

## Module 2: EL syntax, termination, and semantic preservation

Proposed file:

```text
CollatzClassical/KL2003/KL2003GeneralKElimination.lean
```

This module formalizes Theorems 3.1 and 3.2. It is the largest new
mathematical component.

### Syntax

Define a finite expression/tree language with:

- principal leaves carrying a mode and symbolic shift;
- addition nodes;
- three-way minimum nodes;
- root identity;
- active, retarded-terminal, and deleted status; and
- a path relation used by the deletion witness.

Symbolic shifts should be pairs of integer coefficients for
`alphaCoeff * alpha + const`. Their comparison must be a proved relation,
not a Boolean trusted from generated data.

### Splitting and deletion

Define one parametric split step from D1/D2/D3 and the source deletion rule:
a new leaf is deleted exactly when an earlier principal node on its path has
the same mode modulo `3^k` and a strictly smaller shift.

Required structural theorems:

```lean
theorem el_step_preserves_wellFormed ...
theorem deletion_never_removes_all_min_children ...
theorem el_expansion_terminates ...
theorem el_normal_form_unique ...
theorem el_normal_form_has_only_retarded_leaves ...
```

The source proof of termination uses an infinite-tree contradiction, Konig's
lemma, repetition of one of finitely many modes, and strict decrease of the
repeated symbolic shifts. Formalization may replace this with a finite-state
well-founded measure, but any replacement must prove the same parametric
claim and must explain why it is equivalent to the source argument.

Current formal progress has crossed the compactness boundary of that argument.
The source scheduler has an exact provenanced simulation and finite run; under
`NeverStops`, a quaternary-capacity fuel proves that selected typed source
walks have unbounded length. The inverse-system form of Konig's lemma now
extracts one coherent typed infinite branch whose finite prefix codes all come
from actual selected provenances. The remaining termination subproblem is to
prove that all branch segments inherit contextual admissibility. Accumulated
shift nonnegativity is now closed by a tree-wide strict-prefix invariant: each
new child inherits all old prefixes, and the new full parent prefix is the
nonnegative terminal selected by the scheduler. This invariant is preserved
by D1/D2/D3, finite runs, and transferred to the coherent Konig branch. The
remaining admissibility proof must explicitly handle the case in which all
three advanced children have deletion witnesses, because `witnessRetention`
keeps one branch to maintain a nonempty minimum. Lean now proves the exact
biconditional: all retained branches are witness-free if and only if the three
branches do not all have witnesses. A second source boundary is independent:
the retarded child is outside the advanced minimum and never passes through
`witnessRetention`, so repeated-mode factors ending in a retarded edge need a
separate nested-return arithmetic proof. No infinite branch or admissibility
hook is assumed as an input contract.

### Semantic preservation

Theorem 3.2 requires more than local tree validity. The module must define the
evaluation of nested `sum/min` expressions and formalize enough of the
critical-assignment argument to prove that deleted vertices are totally
non-critical for positive monotone `Phi`.

Expected contract:

```lean
theorem satisfies_EL_of_satisfies_Ik
    (hpos : PositivePhi Phi)
    (hmono : MonotonePhi Phi)
    (hrows : SatisfiesIk Phi) :
    SatisfiesEL Phi (elNormalForm k)
```

The generated `k=2` and `k=3` trees may be used only as finite regression
tests of `elNormalForm`; they are not imported into this theorem and the
theorem must not materialize the high-k normal form.

### Acceptance gate

Module 2 passes only if:

- termination is proved for arbitrary `k >= 2`;
- order independence or canonical normalization is proved;
- semantic preservation includes the deletion step;
- the theorem does not assume a prebuilt EL tree;
- the `k=2` normal form reproduces the Figure A1 oracle; and
- the `k=3` normal form reproduces Table 1 metrics as a test, not as proof.

## Module 3: LNT-to-EL feasibility transfer

Proposed file:

```text
CollatzClassical/KL2003/KL2003GeneralKFeasibilityTransfer.lean
```

This module formalizes Theorem 4.1. It separates certificate arithmetic from
the semantic elimination theorem.

### Certificate contracts

Define a general flat `LNTCertificate k lambda` with:

- one positive principal coefficient for each tracked mode;
- the level-`k-1` auxiliary coefficients;
- L0/L4 box constraints;
- L1/L2/L3 row feasibility; and
- exact rational endpoint witnesses when `lambda` is represented through a
  rational bound.

The existing v2.1 JSON/Lean data format remains an untrusted serialization.
A generated data structure becomes a certificate only after a Lean verifier
constructs every field of `LNTCertificate`.

Define the EL feasibility predicate over symbolic nested expressions without
requiring an explicit array of all leaves at high `k`.

Expected theorem:

```lean
theorem el_feasible_of_lnt_feasible
    (hk : 2 <= k)
    (hlambda : 1 <= lambda /\ lambda <= 2)
    (hcert : LNTCertificate k lambda) :
    ELFeasible k lambda (elNormalForm k) hcert.principal
```

The proof follows the source induction over split/delete steps:

- splitting a class `5 mod 9` uses L2;
- splitting a class `2 mod 9` introduces the P3 minimum and uses L1/L4;
- splitting a class `8 mod 9` uses L3/L4; and
- deletion removes LP constraints and therefore preserves feasibility.

### Acceptance gate

Module 3 passes only if:

- the principal coefficients are preserved literally;
- all introduced auxiliary coefficients are constructed;
- no positivity field is assumed without proof;
- the theorem consumes the already-verified `k=3` flat certificate; and
- high-k use does not require generated EL literals.

## Module 4: generic retarded lower-bound induction

Implemented file:

```text
CollatzClassical/KL2003/KL2003GeneralKRetardedLowerBound.lean
```

This module now proves the k-independent induction core of Theorem 5.1 for any
finite nested `sum/min` system whose leaf shifts lie in `[-nu, -mu]` with
`0 < mu`.

The theorem must not mention Collatz residues. Its inputs are:

- a finite family of positive nondecreasing functions;
- a retarded nested inequality system;
- a positive feasible coefficient assignment;
- bounds `0 < mu <= nu` on all leaf shifts; and
- a positive base value.

Proved result:

```lean
theorem generic_retarded_lower_bound
    (inputs : GenericRetardedInputs Index) :
    forall i y, 0 <= y ->
      inputs.Delta * inputs.coeff i * inputs.lambda ^ y <= inputs.Phi i y
```

The implementation uses the equivalent well-founded rank
`ceil (y / mu)`. It proves monotonicity and nonnegative homogeneity of the
nested AST once, then applies them to every row.

This module supersedes neither `m0c_retarded_induction_bound_v3` nor its
specialized padded arithmetic. The k=2 theorem remains an independent,
already-audited route.

### Acceptance gate: PASS

Module 4 passes only if:

- it is independent of `k`, residue classes, and generated data;
- nested minimization is handled by one generic monotonicity theorem;
- the base constant is explicit and positive;
- no advanced leaf can enter through a malformed system; and
- its specialization matches the form of KL2003 Theorem 5.1.

Build and axiom audit pass. The concrete source formula for `Delta` remains a
Module 5 construction; Module 4 accepts the base inequality explicitly.

## Module 5: composition and concrete piStar bounds

Proposed file:

```text
CollatzClassical/KL2003/KL2003GeneralKConcreteBound.lean
```

This module composes Modules 1-4 and corresponds to the proof of Theorem 2.1
at source lines 1440-1478.

First generic theorem:

```lean
theorem kl2003_general_k_phi_lower_bound
    (hk : 2 <= k)
    (hcert : LNTCertificate k lambda)
    (hlambda : 1 < lambda /\ lambda <= 2) :
    forall m y, 0 <= y ->
      Delta1 hcert * hcert.coeff m * lambda ^ y <=
        concretePhiK k m y
```

Then transfer from the infimum to each admissible root and choose
`y = logb 2 (x/a)`:

```lean
theorem kl2003_general_k_piStar_lower_bound
    (hk : 2 <= k)
    (hcert : LNTCertificate k lambda)
    (a : ClassRootsK k m)
    (hx : threshold k a <= x) :
    Delta1 hcert * hcert.coeff m *
        ((x : Real) / (a : Real)) ^ Real.logb 2 lambda <=
      piStar a.1 x
```

The first named consumer must be calibrated as:

```lean
theorem kl2003_k3_piStar_lower_bound ...
```

It may consume `k3_pilot_certificate_verified` only after a constructor turns
that verification result into the general `LNTCertificate 3 lambda` contract.
It should use the safe rational `lambda = 152759/100000`, giving an exponent
approximately `0.61125738`, below the published `0.6112620` as required by
the downward rational truncation. It must not claim to certify the published
optimum.

### Acceptance gate

Module 5 passes only if:

- the theorem is member-wise over actual `piStar`;
- the floor-window/logb identity is proved exactly;
- all ClassRootsK side conditions are explicit or discharged by a named
  concrete instance;
- the axiom audit is recorded;
- no explicit k=3 EL tree is a theorem hypothesis; and
- no k=9 statement is introduced.

## Dependency DAG

```text
M0A/M0B piStar and fiber semantics
             |
             v
Module 1: general-k concrete Phi + I_k rows
             |
             v
Module 2: EL termination + semantic preservation
             |
             +-----------------------------+
             |                             |
             v                             v
Module 3: LNT -> EL feasibility     Module 4: retarded induction
             |                             |
             +--------------+--------------+
                            |
                            v
Module 5: composition -> concrete piStar
                            |
                            v
               k=3 theorem as first consumer
                            |
                            v
             separate k=9 measurement gate
```

Generated data enters only through verified certificate constructors in
Module 3/5. It never enters Module 1, 2, or 4.

## Reuse map

Directly reusable:

- `piStar`, `piStarFinset`, and reachability equivalences;
- window monotonicity and root-count lower bounds;
- two-branch fiber/cardinality core;
- parity-lift arithmetic pattern;
- exact rational certificate methodology;
- alpha/endpoint power-witness methodology;
- schema v2.1 and the generated-data trust boundary; and
- the k=2/k=3 regression oracles.

Reusable only as a proof pattern, not as a generic theorem:

- `K2PhiSystem` and `concretePhi`;
- `I2ELAbstractRowsV3`;
- the explicit row28 `cPrime` split;
- `M0CInductionQ` and the padded rank descent; and
- `RetardedLowerBoundConclusion`.

Must be new:

- finite indexed mode types for arbitrary `k`;
- concrete P3 across levels;
- parametric EL syntax and normalization;
- termination/order independence;
- critical assignments and total non-criticality;
- abstract LNT-to-EL feasibility transfer;
- generic nested-expression induction; and
- the floor-window concrete composition.

## Named blockers

```text
BLOCKED_ON_GENERAL_K_MODE_INDEX_NORMALIZATION
BLOCKED_ON_CLASSROOTSK_NONEMPTY
BLOCKED_ON_EL_TERMINATION_FORMALIZATION
BLOCKED_ON_EL_ORDER_INDEPENDENCE
BLOCKED_ON_CRITICAL_ASSIGNMENT_SEMANTICS
BLOCKED_ON_TOTALLY_NONCRITICAL_DELETION_PROOF
BLOCKED_ON_SYMBOLIC_EL_FEASIBILITY_WITHOUT_MATERIALIZATION
BLOCKED_ON_GENERIC_NESTED_MIN_INDUCTION
BLOCKED_ON_K3_CERTIFICATE_TO_GENERAL_CONTRACT
```

These are not assumptions to place in a bundle. Each must be discharged by a
theorem or remain an explicit project blocker.

## Implementation order

The recommended order is deliberately not the numeric module order:

1. Prove indexed residue arithmetic and ClassRootsK traffic; the floor-window
   pilot is complete.
2. Module 4, the k-independent retarded induction, is complete.
3. Implement Module 1 and obtain concrete general-k rows.
4. Implement Module 2 termination before semantic preservation.
5. Implement Module 3 feasibility transfer.
6. Implement Module 5 and instantiate the `k=3` theorem.
7. Run the separate k=9 flat-certificate resource benchmark.

This order front-loads the smallest reusable theorem and isolates the two
high-risk mathematical components, Modules 2 and 3, before any k=9 cost is
accepted.

## k=3 acceptance verdict

The `k=3` pilot becomes a proved `piStar` result only when all of the following
are true:

```text
GENERAL_K_SEMANTICS_PROVED
EL_TERMINATION_AND_SEMANTIC_PRESERVATION_PROVED
LNT_TO_EL_FEASIBILITY_TRANSFER_PROVED
GENERIC_RETARDED_LOWER_BOUND_PROVED
K3_CERTIFICATE_CONSTRUCTS_GENERAL_CONTRACT
K3_PISTAR_LOWER_BOUND_PROVED
K3_AXIOM_AUDIT_PASS
```

Until then the correct status remains:

```text
K3_PILOT_CERTIFICATE_VERIFIED
K3_PISTAR_THEOREM_NOT_YET_PROVED
```

## High-k gate after k=3

Success at `k=3` authorizes measurement, not formalization, at `k=9`.
The `k=9` gate must report at least:

- 6561-row generation time;
- generated JSON and Lean-data sizes;
- maximum numerator/denominator digits;
- minimum exact positive slack near a rational below `1.7615320`;
- checker runtime and peak memory; and
- an explicit resource budget for kernel rechecking.

Only a passing measurement may change the status to
`K9_FORMALIZATION_AUTHORIZED`. The `k=11` target remains deferred until a
complete `k=9` pipeline has passed.

## Guardrails

- Do not modify the proved k=2 V3 theorem to obtain generality.
- Do not assume generated EL trees at high k.
- Do not treat generated JSON or Lean data as proof.
- Do not call the five-module chain one lemma.
- Do not claim the published k=3 optimum from the safe truncated lambda.
- Do not claim k=9 or k=11 bounds before their gates.
- Do not claim full M1 or global Collatz.

## Classification

```text
GENERAL_K_SEMANTIC_CHAIN_SCOPED
GENERAL_K_CHAIN_SPLIT_INTO_FIVE_MODULES
SOURCE_FAITHFUL_FLOOR_WINDOW_POLICY_PROVED
K2_CEIL_THEOREM_RETAINED_UNCHANGED
THEOREM_3_1_TERMINATION_CONTRACT_IDENTIFIED
THEOREM_3_2_SEMANTIC_PRESERVATION_CONTRACT_IDENTIFIED
THEOREM_4_1_FEASIBILITY_TRANSFER_CONTRACT_IDENTIFIED
THEOREM_5_1_RETARDED_INDUCTION_CONTRACT_IDENTIFIED
THEOREM_5_1_GENERIC_CORE_PROVED
K3_FIRST_CONSUMER_DEFINED
K3_PISTAR_THEOREM_NOT_YET_PROVED
K9_MEASUREMENT_REQUIRED
K11_DEFERRED
NO_FULL_M1_THEOREM_CLAIM
NO_GLOBAL_COLLATZ_CLAIM
```
