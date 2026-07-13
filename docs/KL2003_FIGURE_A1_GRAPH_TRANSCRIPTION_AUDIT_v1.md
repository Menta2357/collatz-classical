# KL2003 Figure A1 Graph Transcription Audit v1

Date: 2026-07-13

Repository: `https://github.com/Menta2357/collatz-classical`

## Purpose

This note follows up the PSTeX source audit for the row28/mod8 EL-tree blocker.
The previous audit correctly found that the readable labels live in
`kafgA1.pstex_t`, but it did not exploit the companion geometry file
`kafgA1.pstex`.

Claude's observation is correct: labels plus edges are the tree.  This pass
therefore treats Figure A1 as a graph source:

```text
kafgA1.pstex_t = labels
kafgA1.pstex   = nodes + directed edges + cross/deletion marks
```

## Source Files

```text
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafgA1.pstex
/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/kafgA1.pstex_t
```

Source hashes:

```text
1f4b4218099af1d34588749cdeb5933cb80eeba48cb94f8537a3a6ccdce802b1  kafgA1.pstex
a89f731f78050d5891069c54aefe6f052b5faa82fad6bad2ba46c7b9a9330ceb  kafgA1.pstex_t
```

## Script

Created:

```text
scripts/kl2003_figure_a1_graph_transcription_v1.py
```

The script parses:

- ellipse nodes from `kafgA1.pstex`;
- arrow polylines from `kafgA1.pstex`;
- cross marks from non-arrow polylines;
- overlay labels from `kafgA1.pstex_t`;
- root-to-node paths in the directed graph.

The script does **not** infer inverse Collatz words or Nat root formulas.  It
only transcribes the graph and pairs it with labels.

## Outputs

Generated under:

```text
outputs/KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1/
```

Files:

```text
nodes.csv
edges.csv
cross_marks.csv
labels.csv
root_paths.csv
summary.json
manifest_sha256.csv
```

Run:

```text
python3 -m py_compile scripts/kl2003_figure_a1_graph_transcription_v1.py
python3 scripts/kl2003_figure_a1_graph_transcription_v1.py
```

Result:

```text
status=PASS_GRAPH_EXTRACTED
node_count=16
edge_count=15
cross_mark_count=4
label_count=13
```

## Graph Findings

The geometry contains a directed graph:

- `16` ellipse nodes;
- `15` directed arrow edges;
- `4` cross-mark polylines;
- all `16` nodes reachable from the root node.

The overlay labels are paired to graph nodes using the exact y-coordinate
conversion:

```text
pstex_y = -overlay_y + 764
```

This maps all `13` labels to graph nodes.  Three intermediate nodes are
unlabelled in the overlay and are retained as graph nodes:

```text
N13, N14, N15
```

They appear on the main directed chain and are therefore not discarded.

## Cross Marks

The four cross-mark polylines land exactly on two labelled nodes:

```text
N04  (8, alpha - 1)      crossed yes
N05  (8, 2 alpha - 3)    crossed yes
```

This is important for the row28/mod8 EL-tree blocker: Figure A1 is not merely a
label source.  It also records graph structure and deletion/cross markers.

## Root Paths

The root is:

```text
N09  phi_2^8(y) == (8,0)
```

The script extracts paths from this root to every node.  Examples:

```text
N09 -> N13 -> (2, alpha - 1)
N09 -> N13 -> (2, alpha - 1) -> N14 -> (2, 2 alpha - 3)
N09 -> N13 -> (2, alpha - 1) -> N14 -> (2, 2 alpha - 3) -> N15 -> (2, 3 alpha - 5)
N09 -> N13 -> (2, alpha - 1) -> N14 -> (2, 2 alpha - 3) -> N15 -> (5, 3 alpha - 5)
N09 -> N13 -> (2, alpha - 1) -> N14 -> (2, 2 alpha - 3) -> N15 -> (8, 3 alpha - 5)
```

The root paths are now a concrete source for the next inverse-word
transcription pass.

## Current Classification

```text
FIGURE_A1_GEOMETRY_CONTAINS_DIRECTED_GRAPH
FIGURE_A1_LABELS_PAIRED_WITH_GRAPH_NODES
FIGURE_A1_ROOT_PATHS_EXTRACTED
CROSSED_NODES_IDENTIFIED
INVERSE_WORDS_NOT_INFERRED_YET
HOOK_MEMBERWISE_NOT_RUN_YET
NO_LEAN_CHANGE
NO_M1_THEOREM
NO_GLOBAL_COLLATZ_CLAIM
```

## Consequence

The blocker should be refined.

Old phrasing:

```text
BLOCKED_ON_MISSING_KL2003_LITERAL_WORD_TABLE
```

Refined phrasing:

```text
BLOCKED_ON_EDGE_SEMANTICS_TO_INVERSE_WORD_TRANSCRIPTION
```

Reason: Figure A1 provides a directed graph with labels and deletion/cross
marks.  What remains is not locating the graph, but assigning the inverse-step
semantics to its edges and validating the resulting literal words.

## Next Step

The next source-level pass should convert graph paths to inverse words:

1. assign each edge a finite inverse-step semantic label;
2. derive the Nat root formula for each terminal literal;
3. verify that each path's computed shift matches the overlay label;
4. verify that crossed/deleted nodes match the deletion rule;
5. run the member-wise piStar hook only after the literal formulas exist.

The sum-free row28 subcases remain separately authorized by the previous
scoping, but this note does not implement them in Lean.
