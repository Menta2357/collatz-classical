# KL2003 Row28 Mod8 EL Tree Member Injection Scoping v1

## Scope

This note scopes the non-circular member-wise proof needed to unblock:

```text
BLOCKED_ON_ROW28_M1V2_MEMBER_TRANSFER
BLOCKED_ON_ROW28_CIRCULARITY_GUARD
```

The target is the remaining concrete row28 case:

```lean
ht : (a.1 / 9) % 3 = 2
```

so the direct advanced child

```lean
c := row28AdvancedChild a.1
```

is again a class-8 root.  The missing Lean consumer is:

```lean
row28_outer_block_le_child_mod8
```

This pass writes no Lean and proves no new theorem.  It is a scoping page for
the finite EL-tree member-wise injection.

## Classification

```text
ROW28_MOD8_EL_TREE_SCOPED
T2_8_EL_TREE_TRANSCRIBED
EIGHT_LITERAL_MEMBERWISE_PLAN_DEFINED
FIBER_DISJOINTNESS_DAG_DEFINED
CIRCULARITY_GUARD_DAG_DEFINED
ROW28_OUTER_BLOCK_MOD8_LEAN_CONTRACT_DEFINED
EMPIRICAL_MEMBERWISE_HOOK_PLANNED
ROW28_MOD8_M1_TRANSFER_NOT_PROVED
ROW28_SEAM_PROVED = no
K2_INPUTS_V2_NOT_YET_PROVED
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

Guardrails:

```text
NO_NEW_LEAN
NO_ROW28_MOD8_M1_TRANSFER_PROOF
NO_ROW28_SEAM_PROOF
NO_K2_INPUTS_V2_PROOF
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Source Status

The EL tree below is not rederived here.  It is a transcription of the already
reconstructed `T_2^8(EL)` / `L_2^EL` table in
`docs/KRASIKOV_M1_FEASIBILITY_RECONSTRUCTION_REPORT_v1.md`.

The relevant normalized errata remain:

- the second arm of `M_1` is `phi_2^2(y+2*alpha-5)`;
- the table exponent typo `2 lambda - 3` is read as `2 alpha - 3`.

## T2_8(EL) Tree: 8 Literals

The normalized row is:

```text
phi_2^8(y) >=
  phi_2^5(y-2)
  + min[
      phi_2^8(y+alpha-3) + M_1(y),
      phi_2^2(y+alpha-3)
    ],

M_1(y) =
  min[
    phi_2^8(y+2alpha-5) + M_2(y),
    phi_2^2(y+2alpha-5)
  ],

M_2(y) =
  min[
    phi_2^2(y+3alpha-5),
    phi_2^5(y+3alpha-5),
    phi_2^8(y+3alpha-5)
  ].
```

Thus the eight literals are:

| id | term | class | EL depth | V2 shift / window |
|---:|---|---:|---:|---|
| L0 | `phi_2^5(y-2)` | 5 | retarded side | `y - 2`, exact retarded |
| L1 | `phi_2^8(y+alpha-3)` | 8 | 1 | `y + shiftAlphaMinus3Pad` |
| L2 | `phi_2^2(y+alpha-3)` | 2 | 1 | `y + shiftAlphaMinus3Pad` |
| L3 | `phi_2^8(y+2alpha-5)` | 8 | 2 | `y + shift2AlphaMinus5Pad2` |
| L4 | `phi_2^2(y+2alpha-5)` | 2 | 2 | `y + shift2AlphaMinus5Pad2` |
| L5 | `phi_2^2(y+3alpha-5)` | 2 | 3 | `y + shift3AlphaMinus5Pad3` |
| L6 | `phi_2^5(y+3alpha-5)` | 5 | 3 | `y + shift3AlphaMinus5Pad3` |
| L7 | `phi_2^8(y+3alpha-5)` | 8 | 3 | `y + shift3AlphaMinus5Pad3` |

For the current blocker `row28_outer_block_le_child_mod8`, L0 is already
outside the blocker and is handled by `row28_retarded_le_piStar_source`.  The
member-wise EL transfer for the class-8 advanced child must realize L1-L7
inside the bounded subtree of `c := row28AdvancedChild a.1`.

## Concrete Target

Current compiled theorem target still missing:

```lean
row28_outer_block_le_child_mod8 :
  14 <= y ->
  (a : ClassRoots 8) ->
  (a.1 / 9) % 3 = 2 ->
  min
    (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
    (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
  <=
  (piStar (row28AdvancedChild a.1)
    (concreteWindow (y + shiftAlphaMinus1Pad)
      (row28AdvancedChild a.1)) : Real)
```

Once this closes, `row28_pointwise_seam_mod8` follows by the already compiled
same-shape D3 core assembly used for `row28_pointwise_seam_mod2` and
`row28_pointwise_seam_mod5`.

## Literal Populations

Let:

```lean
c0 := row28AdvancedChild a.1
x0 := concreteWindow (y + shiftAlphaMinus1Pad) c0
```

The future Lean proof should introduce finite, member-wise populations:

| id | proposed population name | root contract | target fiber |
|---:|---|---|---|
| L1 | `row28_mod8_L1_phi8_pop` | `ClassRoots 8`, shift `shiftAlphaMinus3Pad` | first-entry fiber under `c0` for the outer first arm |
| L2 | `row28_mod8_L2_phi2_pop` | `ClassRoots 2`, shift `shiftAlphaMinus3Pad` | first-entry fiber under `c0` for the outer second arm |
| L3 | `row28_mod8_L3_phi8_pop` | `ClassRoots 8`, shift `shift2AlphaMinus5Pad2` | nested M1 first-arm fiber |
| L4 | `row28_mod8_L4_phi2_pop` | `ClassRoots 2`, shift `shift2AlphaMinus5Pad2` | nested M1 second-arm fiber |
| L5 | `row28_mod8_L5_phi2_pop` | `ClassRoots 2`, shift `shift3AlphaMinus5Pad3` | nested M2 class-2 fiber |
| L6 | `row28_mod8_L6_phi5_pop` | `ClassRoots 5`, shift `shift3AlphaMinus5Pad3` | nested M2 class-5 fiber |
| L7 | `row28_mod8_L7_phi8_pop` | `ClassRoots 8`, shift `shift3AlphaMinus5Pad3` | nested M2 class-8 fiber |

Each population should be a `Finset Nat` or a subtype over
`piStarFinset c0 x0`, not a new abstract cardinal.  The intended shape is:

```lean
row28_mod8_Li_pop a y ht : Finset Nat
row28_mod8_Li_pop_subset_target :
  row28_mod8_Li_pop a y ht ⊆ piStarFinset c0 x0
```

The link to concrete Phi is then via the existing ciInf wrappers:

```lean
concretePhiComponent_le_piStar_of_classRoot
le_concretePhiComponent_of_forall
concretePhiComponent_mono_y
```

## Root Materialization Contract

The existing notes transcribe the class/shift labels, but do not yet provide
Nat formulas for every literal root.  The next Lean pass should not guess them
inside a proof term.  It should introduce a small audited contract:

```lean
structure Row28Mod8ELLiteralRoot
    (a : ClassRoots 8) (ht : (a.1 / 9) % 3 = 2)
    (literal : Nat) where
  root : Nat
  residue_ok : root % 9 = row28_mod8_literal_residue literal
  notInCycle_root : NotInCycle root
  one_le_root : 1 <= root
  window_le_target :
    concreteWindow (row28_mod8_literal_shift y literal) root
      <= concreteWindow (y + shiftAlphaMinus1Pad) (row28AdvancedChild a.1)
  reaches_target :
    PathWithin root (row28AdvancedChild a.1)
      (concreteWindow (y + shiftAlphaMinus1Pad) (row28AdvancedChild a.1))
      (row28_mod8_literal_path_len literal)
```

This is not an axiom proposal.  It is the exact local interface that the next
module should prove from the finite inverse words of `T_2^8(EL)`.

## Window And Pad Plan

The already compiled direct window lemma is:

```lean
row28_advanced_window_le_target :
  concreteWindow (y + shiftAlphaMinus1Pad) (row28AdvancedChild a.1)
    <= concreteWindow y a.1
```

For the blocker, the target window is `x0`, not the original root window.  The
EL literal windows must be compared against `x0`.

Needed window statements:

```lean
row28_mod8_depth1_window_le_child :
  concreteWindow (y + shiftAlphaMinus3Pad) root1
    <= concreteWindow (y + shiftAlphaMinus1Pad) c0

row28_mod8_depth2_window_le_child :
  concreteWindow (y + shift2AlphaMinus5Pad2) root2
    <= concreteWindow (y + shiftAlphaMinus1Pad) c0

row28_mod8_depth3_window_le_child :
  concreteWindow (y + shift3AlphaMinus5Pad3) root3
    <= concreteWindow (y + shiftAlphaMinus1Pad) c0
```

The old name suggestions `row28_depth2_window_le_target` and
`row28_depth3_window_le_target` are still needed, but they should target the
class-8 child window `x0` in this blocker.  Depth 1 also needs an explicit
statement because `row28_advanced_window_le_target` compares child-to-original,
not EL-literal-to-child.

## Fiber Realization

Each literal should be realized as a first-entry-predecessor fiber, not as a
plain cardinal inequality.

The intended cascade:

1. The outer class-8 child subtree `piStarFinset c0 x0` is partitioned by
   first entry into the EL alternatives for L1/L2.
2. The L1 first arm contains a disjoint sum: L1 plus an `M1V2` nested block.
3. The `M1V2` nested block is partitioned into L3/L4 alternatives.
4. The L3 first arm contains a disjoint sum: L3 plus an `M2V2` nested block.
5. The `M2V2` nested block is partitioned into L5/L6/L7 alternatives.

The proof should reuse the existing M0B fiber machinery:

```lean
FirstHitsAt
NotInCycle
entry_pred_eq_of_reaches_child
inverse_children_disjoint_descendants
```

No new disjointness theory should be invented.  Each node in the EL tree should
provide:

```lean
entry_predecessor_tag : Nat
tag_maps_to_parent : T tag = parentRoot
tag_distinct_from_siblings : ...
```

Then sibling fibers are disjoint by the existing entry-predecessor layer.

## Parity-Lift Reuse

Some child classes in the EL cascade may be untracked before an even lift,
exactly as in row22.  The row22 pattern to reuse is:

```lean
row22_parity_lift_maps_to_child
row22_lifted_child_notInCycle
row22_lifted_child_classRoot_mod2
row22_lifted_child_classRoot_mod5
row22_lifted_child_classRoot_mod8
row22_parity_concreteWindow
row22_parity_piStar_transfer
```

The next pass should create row28-local parity-lift wrappers rather than
duplicating arithmetic inline.  Proposed names:

```lean
row28_mod8_Li_parity_lift_root
row28_mod8_Li_parity_window_exact
row28_mod8_Li_parity_piStar_transfer
```

Only literals whose finite inverse word lands outside `{2,5,8}` should use
this lift.  If a literal root is already in class `{2,5,8}`, no parity lift is
needed.

## Non-Circular DAG

Allowed dependencies:

```text
traffic lemmas:
  piStar_window_mono
  concreteWindow_mono_y
  concretePhiComponent_le_piStar_of_classRoot
  le_concretePhiComponent_of_forall
  concretePhiComponent_mono_y

row25:
  concretePhi_row25_seam

row22:
  row22 parity-lift lemmas
  concretePhi_row22_seam

M0B:
  d1_core_instantiation
  d2_single_branch_core_instantiation
  d3_core_instantiation
  entry-predecessor disjointness

row28 already closed:
  row28_advanced_child_classRoot_mod8
  row28_advanced_window_le_target
  row28_piStar_sum_le_target
  row28_pointwise_seam_mod2
  row28_pointwise_seam_mod5
```

Forbidden dependency:

```text
concretePhi_row28_seam
```

The next proof may prove `row28_outer_block_le_child_mod8` first, then
`row28_pointwise_seam_mod8`, and only after that assemble
`concretePhi_row28_seam`.

## Lean Contract For The Blocker

Recommended theorem names:

```lean
row28_mod8_M2_member_transfer :
  14 <= y ->
  (a : ClassRoots 8) ->
  (ht : (a.1 / 9) % 3 = 2) ->
  M2V2 concretePhi y
    <= (piStar (row28_mod8_M2_target_root a ht)
          (concreteWindow (y + shift2AlphaMinus5Pad2)
            (row28_mod8_M2_target_root a ht)) : Real)

row28_mod8_M1_member_transfer :
  14 <= y ->
  (a : ClassRoots 8) ->
  (ht : (a.1 / 9) % 3 = 2) ->
  M1V2 concretePhi y
    <= (piStar (row28_mod8_M1_target_root a ht)
          (concreteWindow (y + shiftAlphaMinus3Pad)
            (row28_mod8_M1_target_root a ht)) : Real)

row28_outer_block_le_child_mod8 :
  14 <= y ->
  (a : ClassRoots 8) ->
  (ht : (a.1 / 9) % 3 = 2) ->
  min
    (concretePhi.phi28 (y + shiftAlphaMinus3Pad) + M1V2 concretePhi y)
    (concretePhi.phi22 (y + shiftAlphaMinus3Pad))
  <=
  (piStar (row28AdvancedChild a.1)
    (concreteWindow (y + shiftAlphaMinus1Pad)
      (row28AdvancedChild a.1)) : Real)
```

The exact target roots for `M1` and `M2` should be replaced by the audited
literal roots once the finite inverse words are materialized.

## Empirical Hook

Proposed script:

```text
scripts/kl2003_row28_mod8_el_tree_memberwise_empirical_v1.py
```

Proposed outputs:

```text
outputs/KL2003_ROW28_MOD8_EL_TREE_MEMBERWISE_EMPIRICAL_v1/summary.json
outputs/KL2003_ROW28_MOD8_EL_TREE_MEMBERWISE_EMPIRICAL_v1/literals.csv
outputs/KL2003_ROW28_MOD8_EL_TREE_MEMBERWISE_EMPIRICAL_v1/fibers.csv
outputs/KL2003_ROW28_MOD8_EL_TREE_MEMBERWISE_EMPIRICAL_v1/mismatch.csv
outputs/KL2003_ROW28_MOD8_EL_TREE_MEMBERWISE_EMPIRICAL_v1/manifest_sha256.csv
```

Grid:

```text
a in [1, 500]
a % 9 = 8
(a / 9) % 3 = 2
x in [a, min(10000, 32*a)]
```

Checks:

1. materialize the eight literal roots from the finite EL inverse-word table;
2. verify each root residue and route to the parent node;
3. compute member sets, not just cardinalities;
4. verify each literal population is contained in `piStar(c0,x0)`;
5. verify sibling disjointness by entry-predecessor tag;
6. verify the union cardinal matches the nested expression chosen by the EL
   min branches;
7. report all mismatches with root, literal id, path, window, and first-entry
   predecessor.

This empirical hook is diagnostic only.  It should not be cited as a Lean
proof.

## Next Lean Step

The next Lean task should be narrow:

```text
KL2003_ROW28_MOD8_EL_LITERAL_ROOTS_AND_FIBERS_LEAN_v1
```

Expected deliverables:

- literal-root data/functions for L1-L7;
- residue and `NotInCycle` closure for each literal root;
- depth 1/2/3 window lemmas into the child window;
- first-entry fiber inclusion and disjointness;
- `row28_outer_block_le_child_mod8`;
- no `concretePhi_row28_seam` until `row28_outer_block_le_child_mod8` is
  compiled.

No M1 theorem and no global Collatz claim.
