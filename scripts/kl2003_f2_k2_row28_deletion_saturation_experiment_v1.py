#!/usr/bin/env python3
"""Run the KL2003 k=2 row28 deletion-saturation experiment.

This is a diagnostic experiment only.  It derives the row28 expansion tree
from the parametric D1/D2/D3 and deletion-rule text, then compares the result
against Figure A1/root_paths as a regression oracle.  It does not implement
the row28 generator, generate k=3 data, solve an LP, open Lean, or claim any
high-k/global theorem.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
import subprocess
from dataclasses import dataclass, field
from datetime import datetime, timezone
from fractions import Fraction
from pathlib import Path
from typing import Any
from zoneinfo import ZoneInfo


RUN_ID = "KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT_PATH = Path(__file__).resolve()
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID

SUMMARY_PATH = OUT_DIR / "generation_summary.json"
GENERATED_NODES_PATH = OUT_DIR / "generated_nodes.csv"
GENERATED_EDGES_PATH = OUT_DIR / "generated_edges.csv"
DELETION_TRACE_PATH = OUT_DIR / "deletion_trace.csv"
SATURATION_TRACE_PATH = OUT_DIR / "saturation_trace.csv"
FIGURE_DIFF_PATH = OUT_DIR / "figure_a1_oracle_diff.csv"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

ROOT_PATHS = REPO_ROOT / "outputs" / "KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1" / "root_paths.csv"
ORACLE_NODES = REPO_ROOT / "outputs" / "KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1" / "nodes.csv"
ORACLE_EDGES = REPO_ROOT / "outputs" / "KL2003_FIGURE_A1_GRAPH_TRANSCRIPTION_v1" / "edges.csv"

TEX_CANDIDATES = [
    REPO_ROOT / "work" / "sources" / "kl2003_src" / "30apr02.tex",
    REPO_ROOT.parent
    / "2026-07-05"
    / "tarea-krasikov-m1-feasibility-reconstruction-v2"
    / "work"
    / "sources"
    / "kl2003_src"
    / "30apr02.tex",
    Path("/Users/MoiTam/Documents/Codex/2026-07-05/tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/kl2003_src/30apr02.tex"),
]

ALPHA_LOWER = Fraction(19, 12)
ALPHA_UPPER = Fraction(8, 5)
K = 2
MODULUS = 3**K
CLASS_STEP = 3 ** (K - 1)
ROOT_MODE = 8
SAFETY_ROUND_LIMIT = 32
SAFETY_NODE_LIMIT = 10000
MADRID_TZ = ZoneInfo("Europe/Madrid")


@dataclass(frozen=True, order=True)
class Shift:
    alpha_coeff: int = 0
    const: int = 0

    def __add__(self, other: "Shift") -> "Shift":
        return Shift(self.alpha_coeff + other.alpha_coeff, self.const + other.const)

    def __sub__(self, other: "Shift") -> "Shift":
        return Shift(self.alpha_coeff - other.alpha_coeff, self.const - other.const)

    def lower(self) -> Fraction:
        coeff = self.alpha_coeff
        alpha_value = ALPHA_LOWER if coeff >= 0 else ALPHA_UPPER
        return coeff * alpha_value + self.const

    def upper(self) -> Fraction:
        coeff = self.alpha_coeff
        alpha_value = ALPHA_UPPER if coeff >= 0 else ALPHA_LOWER
        return coeff * alpha_value + self.const

    def sign_ge_zero(self) -> bool | None:
        if self.lower() >= 0:
            return True
        if self.upper() < 0:
            return False
        return None

    def lt(self, other: "Shift") -> bool | None:
        diff = other - self
        if diff.lower() > 0:
            return True
        if diff.upper() <= 0:
            return False
        return None

    def canonical(self) -> str:
        a = self.alpha_coeff
        b = self.const
        if a == 0:
            return str(b)
        if a == 1:
            head = "alpha"
        elif a == -1:
            head = "-alpha"
        else:
            head = f"{a}*alpha"
        if b == 0:
            return head
        sign = "+" if b > 0 else "-"
        return f"{head}{sign}{abs(b)}"

    def approx(self) -> float:
        return float((self.lower() + self.upper()) / 2)


SHIFT_ZERO = Shift(0, 0)
SHIFT_MINUS_TWO = Shift(0, -2)
SHIFT_ALPHA_MINUS_ONE = Shift(1, -1)
SHIFT_ALPHA_MINUS_TWO = Shift(1, -2)


@dataclass
class Node:
    node_id: str
    parent_id: str
    kind: str
    mode: int | None
    shift: Shift | None
    graph_depth: int
    expansion_depth: int
    inverse_step: str
    inverse_word: list[str]
    status: str
    deletion_reason: str = ""
    derivation_source_ref: str = ""
    split_rule: str = ""
    generated_order: int = 0


@dataclass
class Edge:
    edge_id: str
    parent_id: str
    child_id: str
    inverse_step: str
    shift_delta: Shift | None
    derivation_source_ref: str


@dataclass
class ExperimentState:
    nodes: dict[str, Node] = field(default_factory=dict)
    edges: list[Edge] = field(default_factory=list)
    deletion_trace: list[dict[str, Any]] = field(default_factory=list)
    saturation_trace: list[dict[str, Any]] = field(default_factory=list)
    node_counter: int = 0
    edge_counter: int = 0
    blocked_reason: str = ""

    def next_node_id(self) -> str:
        node_id = f"G{self.node_counter:02d}"
        self.node_counter += 1
        return node_id

    def next_edge_id(self) -> str:
        edge_id = f"GE{self.edge_counter:02d}"
        self.edge_counter += 1
        return edge_id


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def source_commit() -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            cwd=REPO_ROOT,
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return "UNKNOWN_UNCOMMITTED"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            encoded: dict[str, Any] = {}
            for field in fieldnames:
                value = row.get(field, "")
                if isinstance(value, (list, dict, tuple)):
                    encoded[field] = json.dumps(value, sort_keys=True)
                else:
                    encoded[field] = value
            writer.writerow(encoded)


def find_tex_source() -> Path | None:
    for candidate in TEX_CANDIDATES:
        if candidate.exists():
            return candidate
    return None


def read_source_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8", errors="replace").splitlines()


def source_ref(path: Path, line_range: str, role: str) -> str:
    return f"{repo_rel(path)}:{line_range}:{role}"


def source_checks(lines: list[str]) -> dict[str, bool]:
    text = "\n".join(lines)
    return {
        "D1_formula_present": "If $m \\equiv 2" in text and "(4m - 2)/3" in text,
        "D2_formula_present": "If $m \\equiv 5" in text and "\\phi_k^{4m}(y-2)" in text,
        "D3_formula_present": "If $m \\equiv 8" in text and "(2m - 1)/3" in text,
        "kminus1_min_present": "\\phi_{k-1}^m(y) := \\min" in text,
        "splitting_step_present": "A step from $\\sT_k^m (l)$" in text,
        "deletion_rule_present": "Deletion Rule" in text and "m' \\equiv m''" in text,
        "termination_theorem_present": "halts after a finite number of steps" in text,
    }


def row_kind(mode: int) -> str:
    residue = mode % 9
    if residue == 2:
        return "D1"
    if residue == 5:
        return "D2"
    if residue == 8:
        return "D3"
    return "UNTRACKED"


def normalize_mode(mode: int) -> int:
    return mode % MODULUS


def tracked_min_modes(base_mode: int) -> list[int]:
    return [normalize_mode(base_mode + offset * CLASS_STEP) for offset in range(3)]


def terminal_status_for(mode: int, shift: Shift, state: ExperimentState) -> str:
    sign = shift.sign_ge_zero()
    if sign is None:
        state.blocked_reason = "BLOCKED_ON_MODE_OR_SHIFT_CANONICALIZATION"
        return "active"
    if sign and row_kind(mode) in {"D1", "D3"}:
        return "active"
    return "terminal"


def add_node(
    state: ExperimentState,
    *,
    parent_id: str,
    kind: str,
    mode: int | None,
    shift: Shift | None,
    graph_depth: int,
    expansion_depth: int,
    inverse_step: str,
    inverse_word: list[str],
    status: str,
    derivation_source_ref: str,
    split_rule: str = "",
) -> Node:
    node_id = state.next_node_id()
    node = Node(
        node_id=node_id,
        parent_id=parent_id,
        kind=kind,
        mode=mode,
        shift=shift,
        graph_depth=graph_depth,
        expansion_depth=expansion_depth,
        inverse_step=inverse_step,
        inverse_word=inverse_word,
        status=status,
        derivation_source_ref=derivation_source_ref,
        split_rule=split_rule,
        generated_order=state.node_counter - 1,
    )
    state.nodes[node_id] = node
    if parent_id:
        parent = state.nodes[parent_id]
        shift_delta = (shift - parent.shift) if shift is not None and parent.shift is not None else None
        edge = Edge(
            edge_id=state.next_edge_id(),
            parent_id=parent_id,
            child_id=node_id,
            inverse_step=inverse_step,
            shift_delta=shift_delta,
            derivation_source_ref=derivation_source_ref,
        )
        state.edges.append(edge)
    return node


def p_ancestors(state: ExperimentState, node_id: str) -> list[Node]:
    ancestors: list[Node] = []
    current_id = state.nodes[node_id].parent_id
    while current_id:
        node = state.nodes[current_id]
        if node.kind == "p":
            ancestors.append(node)
        current_id = node.parent_id
    ancestors.reverse()
    return ancestors


def apply_deletion_rule(
    state: ExperimentState,
    *,
    round_index: int,
    new_min_leaves: list[Node],
    deletion_source_ref: str,
) -> None:
    for leaf in new_min_leaves:
        assert leaf.shift is not None
        sign = leaf.shift.sign_ge_zero()
        if sign is None:
            state.blocked_reason = "BLOCKED_ON_MODE_OR_SHIFT_CANONICALIZATION"
            continue
        if not sign:
            continue
        assert leaf.mode is not None
        for ancestor in p_ancestors(state, leaf.node_id):
            if ancestor.mode != leaf.mode or ancestor.shift is None:
                continue
            comparison = ancestor.shift.lt(leaf.shift)
            if comparison is None:
                state.blocked_reason = "BLOCKED_ON_MODE_OR_SHIFT_CANONICALIZATION"
                continue
            if comparison:
                leaf.status = "deleted"
                leaf.deletion_reason = (
                    f"same mode {leaf.mode} ancestor {ancestor.node_id} has "
                    f"{ancestor.shift.canonical()} < {leaf.shift.canonical()}"
                )
                state.deletion_trace.append(
                    {
                        "round": round_index,
                        "deleted_node": leaf.node_id,
                        "deleted_mode": leaf.mode,
                        "earlier_matching_mode_ancestor": ancestor.node_id,
                        "ancestor_shift": ancestor.shift.canonical(),
                        "deleted_shift": leaf.shift.canonical(),
                        "comparison_exact": f"{ancestor.shift.canonical()} < {leaf.shift.canonical()}",
                        "source_ref": deletion_source_ref,
                        "deletion_reason": leaf.deletion_reason,
                    }
                )
                break


def expand_leaf(
    state: ExperimentState,
    *,
    node: Node,
    round_index: int,
    tex_source: Path,
) -> None:
    if node.kind != "p" or node.mode is None or node.shift is None:
        return
    rule = row_kind(node.mode)
    if rule not in {"D1", "D3"}:
        node.status = "terminal"
        return
    node.status = "expanded"
    rule_source = source_ref(tex_source, "433-445", f"{rule}_formula")
    min_source = source_ref(tex_source, "450-451", "phi_kminus1_min")
    deletion_source = source_ref(tex_source, "763-779", "deletion_rule")

    retarded_shift = node.shift + SHIFT_MINUS_TWO
    retarded_mode = normalize_mode(4 * node.mode)
    retarded_status = terminal_status_for(retarded_mode, retarded_shift, state)
    add_node(
        state,
        parent_id=node.node_id,
        kind="p",
        mode=retarded_mode,
        shift=retarded_shift,
        graph_depth=node.graph_depth + 1,
        expansion_depth=node.expansion_depth + 1,
        inverse_step=f"{rule}_retarded_4m",
        inverse_word=node.inverse_word + [f"{rule}:retarded"],
        status=retarded_status,
        derivation_source_ref=rule_source,
        split_rule=rule,
    )

    if rule == "D1":
        numerator = 4 * node.mode - 2
        if numerator % 3 != 0:
            state.blocked_reason = "BLOCKED_ON_PARAMETRIC_EL_EXPANSION_RULE_SOURCE"
            return
        base_mode = numerator // 3
        advanced_shift = node.shift + SHIFT_ALPHA_MINUS_TWO
        advanced_source = source_ref(tex_source, "433-437", "D1_advanced_min")
    else:
        numerator = 2 * node.mode - 1
        if numerator % 3 != 0:
            state.blocked_reason = "BLOCKED_ON_PARAMETRIC_EL_EXPANSION_RULE_SOURCE"
            return
        base_mode = numerator // 3
        advanced_shift = node.shift + SHIFT_ALPHA_MINUS_ONE
        advanced_source = source_ref(tex_source, "443-445", "D3_advanced_min")

    min_node = add_node(
        state,
        parent_id=node.node_id,
        kind="m",
        mode=None,
        shift=None,
        graph_depth=node.graph_depth + 1,
        expansion_depth=node.expansion_depth + 1,
        inverse_step=f"{rule}_kminus1_min",
        inverse_word=node.inverse_word + [f"{rule}:min"],
        status="expanded",
        derivation_source_ref=min_source,
        split_rule=rule,
    )

    new_min_leaves: list[Node] = []
    for mode in tracked_min_modes(base_mode):
        status = terminal_status_for(mode, advanced_shift, state)
        leaf = add_node(
            state,
            parent_id=min_node.node_id,
            kind="p",
            mode=mode,
            shift=advanced_shift,
            graph_depth=min_node.graph_depth + 1,
            expansion_depth=node.expansion_depth + 1,
            inverse_step=f"{rule}_advanced_min_class_{mode}",
            inverse_word=node.inverse_word + [f"{rule}:min", f"class:{mode}"],
            status=status,
            derivation_source_ref=advanced_source,
            split_rule=rule,
        )
        new_min_leaves.append(leaf)

    apply_deletion_rule(
        state,
        round_index=round_index,
        new_min_leaves=new_min_leaves,
        deletion_source_ref=deletion_source,
    )


def run_experiment(tex_source: Path) -> ExperimentState:
    state = ExperimentState()
    root_ref = source_ref(tex_source, "680-683", "row28_D3_root_initialization")
    add_node(
        state,
        parent_id="",
        kind="p",
        mode=ROOT_MODE,
        shift=SHIFT_ZERO,
        graph_depth=0,
        expansion_depth=0,
        inverse_step="root",
        inverse_word=[],
        status="active",
        derivation_source_ref=root_ref,
        split_rule="D3",
    )

    for round_index in range(1, SAFETY_ROUND_LIMIT + 1):
        active_before = sorted(
            node.node_id
            for node in state.nodes.values()
            if node.status == "active" and node.kind == "p"
        )
        expansible = [
            state.nodes[node_id]
            for node_id in active_before
            if state.nodes[node_id].mode is not None
            and row_kind(state.nodes[node_id].mode or -1) in {"D1", "D3"}
        ]
        before_node_count = len(state.nodes)
        before_deleted_count = sum(1 for node in state.nodes.values() if node.status == "deleted")
        if not expansible:
            state.saturation_trace.append(
                {
                    "round": round_index,
                    "active_leaves_before": active_before,
                    "expanded_leaves": [],
                    "new_nodes": 0,
                    "deleted_nodes": 0,
                    "terminal_leaves": sorted(
                        node.node_id for node in state.nodes.values() if node.kind == "p" and node.status == "terminal"
                    ),
                    "active_leaves_after": [],
                    "fixed_point_reached": True,
                }
            )
            return state

        expanded_ids = [node.node_id for node in expansible]
        for node in expansible:
            expand_leaf(state, node=node, round_index=round_index, tex_source=tex_source)
            if state.blocked_reason:
                return state
            if len(state.nodes) > SAFETY_NODE_LIMIT:
                state.blocked_reason = "ROW28_DELETION_SATURATION_SAFETY_LIMIT_HIT"
                return state

        active_after = sorted(
            node.node_id
            for node in state.nodes.values()
            if node.status == "active" and node.kind == "p"
        )
        state.saturation_trace.append(
            {
                "round": round_index,
                "active_leaves_before": active_before,
                "expanded_leaves": expanded_ids,
                "new_nodes": len(state.nodes) - before_node_count,
                "deleted_nodes": sum(1 for node in state.nodes.values() if node.status == "deleted") - before_deleted_count,
                "terminal_leaves": sorted(
                    node.node_id for node in state.nodes.values() if node.kind == "p" and node.status == "terminal"
                ),
                "active_leaves_after": active_after,
                "fixed_point_reached": not active_after,
            }
        )
        if not active_after:
            return state

    state.blocked_reason = "ROW28_DELETION_SATURATION_SAFETY_LIMIT_HIT"
    return state


def shift_from_label(text: str) -> Shift:
    expr = (
        text.replace("\\alpha", "alpha")
        .replace(" ", "")
        .replace("~", "")
        .replace("{", "")
        .replace("}", "")
    )
    if expr in {"0", "+0"}:
        return Shift(0, 0)
    if expr == "-2":
        return Shift(0, -2)
    if "alpha" not in expr:
        return Shift(0, int(expr))
    expr = expr.replace("\\", "")
    match = re.fullmatch(r"(?:(-?\d*)\*?alpha)([+-]\d+)?", expr)
    if not match:
        raise ValueError(f"cannot parse shift label: {text!r}")
    coeff_text = match.group(1)
    if coeff_text in {"", "+"}:
        coeff = 1
    elif coeff_text == "-":
        coeff = -1
    else:
        coeff = int(coeff_text)
    const = int(match.group(2) or "0")
    return Shift(coeff, const)


def parse_oracle_label(label: str) -> tuple[str, int | None, Shift | None]:
    if not label:
        return ("m", None, None)
    if "\\phi" in label:
        match = re.search(r"\\equiv\s*\((\d+),\s*([^)]+)\)", label)
    else:
        match = re.search(r"\((\d+),\s*([^)]+)\)", label)
    if not match:
        raise ValueError(f"cannot parse oracle label: {label!r}")
    mode = int(match.group(1)) % MODULUS
    shift = shift_from_label(match.group(2))
    return ("p", mode, shift)


def node_label(kind: str, mode: int | None, shift: Shift | None) -> str:
    if kind == "m":
        return "M"
    assert mode is not None and shift is not None
    return f"p:{mode}:{shift.canonical()}"


def generated_path(state: ExperimentState, node_id: str) -> list[str]:
    ids: list[str] = []
    current = node_id
    while current:
        ids.append(current)
        current = state.nodes[current].parent_id
    return list(reversed(ids))


def generated_signature(state: ExperimentState, node_id: str) -> str:
    return " -> ".join(
        node_label(state.nodes[item].kind, state.nodes[item].mode, state.nodes[item].shift)
        for item in generated_path(state, node_id)
    )


def oracle_signatures() -> tuple[set[tuple[str, str]], set[tuple[str, str]], dict[str, Any]]:
    node_rows = read_csv(ORACLE_NODES)
    edge_rows = read_csv(ORACLE_EDGES)
    root_path_rows = read_csv(ROOT_PATHS)
    outgoing = {row["src"] for row in edge_rows}
    node_info: dict[str, dict[str, Any]] = {}
    for row in node_rows:
        kind, mode, shift = parse_oracle_label(row.get("label", ""))
        if row.get("crossed") == "yes":
            status = "deleted"
        elif row["node_id"] in outgoing:
            status = "expanded"
        else:
            status = "terminal"
        node_info[row["node_id"]] = {
            "kind": kind,
            "mode": mode,
            "shift": shift,
            "status": status,
            "label": node_label(kind, mode, shift),
        }
    path_by_node = {row["node_id"]: row["path_node_ids"].split() for row in root_path_rows}
    node_sigs = {
        (" -> ".join(node_info[item]["label"] for item in path_by_node[node_id]), node_info[node_id]["status"])
        for node_id in path_by_node
    }
    edge_sigs = set()
    for row in edge_rows:
        src = row["src"]
        dst = row["dst"]
        edge_sigs.add(
            (
                " -> ".join(node_info[item]["label"] for item in path_by_node[src]),
                " -> ".join(node_info[item]["label"] for item in path_by_node[dst]),
            )
        )
    stats = {
        "node_count": len(node_rows),
        "edge_count": len(edge_rows),
        "graph_max_path_length": max(int(row["path_length"]) for row in root_path_rows),
        "deleted_count": sum(1 for row in node_rows if row.get("crossed") == "yes"),
        "deleted_oracle_nodes": sorted(row["node_id"] for row in node_rows if row.get("crossed") == "yes"),
    }
    return node_sigs, edge_sigs, stats


def generated_signatures(state: ExperimentState) -> tuple[set[tuple[str, str]], set[tuple[str, str]]]:
    node_sigs = {
        (generated_signature(state, node_id), node.status)
        for node_id, node in state.nodes.items()
    }
    edge_sigs = {
        (generated_signature(state, edge.parent_id), generated_signature(state, edge.child_id))
        for edge in state.edges
    }
    return node_sigs, edge_sigs


def compare_to_oracle(state: ExperimentState) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    generated_nodes, generated_edges = generated_signatures(state)
    oracle_nodes, oracle_edges, oracle_stats = oracle_signatures()
    diff_rows: list[dict[str, Any]] = []
    mismatch_rows: list[dict[str, Any]] = []

    def add_diff(kind: str, direction: str, signature: Any) -> None:
        row = {
            "diff_kind": kind,
            "direction": direction,
            "signature": signature,
            "status": "mismatch",
        }
        diff_rows.append(row)
        mismatch_rows.append(row)

    for signature in sorted(generated_nodes - oracle_nodes):
        add_diff("node_signature", "generated_extra", signature)
    for signature in sorted(oracle_nodes - generated_nodes):
        add_diff("node_signature", "oracle_missing_from_generated", signature)
    for signature in sorted(generated_edges - oracle_edges):
        add_diff("edge_signature", "generated_extra", signature)
    for signature in sorted(oracle_edges - generated_edges):
        add_diff("edge_signature", "oracle_missing_from_generated", signature)

    count_checks = {
        "node_count": (len(state.nodes), oracle_stats["node_count"]),
        "edge_count": (len(state.edges), oracle_stats["edge_count"]),
        "deleted_count": (sum(1 for node in state.nodes.values() if node.status == "deleted"), oracle_stats["deleted_count"]),
    }
    for name, (generated_value, oracle_value) in count_checks.items():
        status = "match" if generated_value == oracle_value else "mismatch"
        diff_rows.append(
            {
                "diff_kind": name,
                "direction": "count_compare",
                "signature": f"generated={generated_value}; oracle={oracle_value}",
                "status": status,
            }
        )
        if status == "mismatch":
            mismatch_rows.append(diff_rows[-1])

    diff_stats = {
        "mismatch_count": len(mismatch_rows),
        "oracle_node_count": oracle_stats["node_count"],
        "oracle_edge_count": oracle_stats["edge_count"],
        "oracle_deleted_count": oracle_stats["deleted_count"],
        "oracle_graph_max_path_length": oracle_stats["graph_max_path_length"],
        "oracle_deleted_nodes": oracle_stats["deleted_oracle_nodes"],
    }
    return diff_rows, mismatch_rows, diff_stats


def generated_node_rows(state: ExperimentState) -> list[dict[str, Any]]:
    rows = []
    for node in sorted(state.nodes.values(), key=lambda item: item.generated_order):
        rows.append(
            {
                "generated_node_id": node.node_id,
                "parent_generated_node_id": node.parent_id,
                "node_kind": node.kind,
                "mode_class": "" if node.mode is None else node.mode,
                "shift": "" if node.shift is None else node.shift.canonical(),
                "shift_interval_lower": "" if node.shift is None else str(node.shift.lower()),
                "shift_interval_upper": "" if node.shift is None else str(node.shift.upper()),
                "graph_depth": node.graph_depth,
                "expansion_depth": node.expansion_depth,
                "inverse_step": node.inverse_step,
                "inverse_word": " ".join(node.inverse_word),
                "status": node.status,
                "deletion_reason": node.deletion_reason,
                "derivation_source_ref": node.derivation_source_ref,
                "path_signature": generated_signature(state, node.node_id),
            }
        )
    return rows


def generated_edge_rows(state: ExperimentState) -> list[dict[str, Any]]:
    return [
        {
            "edge_id": edge.edge_id,
            "parent": edge.parent_id,
            "child": edge.child_id,
            "inverse_step": edge.inverse_step,
            "shift_delta": "" if edge.shift_delta is None else edge.shift_delta.canonical(),
            "derivation_source_ref": edge.derivation_source_ref,
        }
        for edge in state.edges
    ]


def write_manifest(paths: list[Path], source_paths: list[Path]) -> None:
    rows = []
    for path in paths + source_paths:
        if not path.exists():
            continue
        rows.append(
            {
                "path": repo_rel(path),
                "sha256": sha256(path),
                "artifact_kind": "output" if path in paths else "input_source_or_oracle",
            }
        )
    write_csv(MANIFEST_PATH, rows, ["path", "sha256", "artifact_kind"])


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    checked_at = datetime.now(timezone.utc).astimezone(MADRID_TZ).isoformat()
    tex_source = find_tex_source()
    missing_inputs = [path for path in [ROOT_PATHS, ORACLE_NODES, ORACLE_EDGES] if not path.exists()]
    if tex_source is None:
        missing_inputs.append(TEX_CANDIDATES[0])

    if missing_inputs:
        summary = {
            "run_id": RUN_ID,
            "created_at": datetime.now(timezone.utc).isoformat(),
            "session_clock_europe_madrid": checked_at,
            "verdict": "BLOCKED_ON_PARAMETRIC_EL_EXPANSION_RULE_SOURCE",
            "missing_inputs": [repo_rel(path) for path in missing_inputs],
            "guardrails": [
                "ROW28_GENERATOR_NOT_STARTED",
                "NO_K3_GENERATION",
                "NO_HIGH_K_CLAIM",
                "NO_GLOBAL_COLLATZ_CLAIM",
            ],
        }
        write_json(SUMMARY_PATH, summary)
        write_csv(MISMATCH_PATH, [{"mismatch": "missing_input", "paths": summary["missing_inputs"]}], ["mismatch", "paths"])
        write_manifest([SUMMARY_PATH, MISMATCH_PATH], [])
        print(json.dumps({"verdict": summary["verdict"], "out_dir": repo_rel(OUT_DIR)}, sort_keys=True))
        return 0

    assert tex_source is not None
    source_lines = read_source_lines(tex_source)
    checks = source_checks(source_lines)
    if not all(checks.values()):
        summary = {
            "run_id": RUN_ID,
            "created_at": datetime.now(timezone.utc).isoformat(),
            "session_clock_europe_madrid": checked_at,
            "source_path": repo_rel(tex_source),
            "source_sha256": sha256(tex_source),
            "source_checks": checks,
            "verdict": "BLOCKED_ON_PARAMETRIC_EL_EXPANSION_RULE_SOURCE",
            "guardrails": [
                "ROW28_GENERATOR_NOT_STARTED",
                "NO_K3_GENERATION",
                "NO_HIGH_K_CLAIM",
                "NO_GLOBAL_COLLATZ_CLAIM",
            ],
        }
        write_json(SUMMARY_PATH, summary)
        write_csv(MISMATCH_PATH, [{"mismatch": key, "paths": "source_check_false"} for key, ok in checks.items() if not ok], ["mismatch", "paths"])
        write_manifest([SUMMARY_PATH, MISMATCH_PATH], [tex_source, ROOT_PATHS, ORACLE_NODES, ORACLE_EDGES])
        print(json.dumps({"verdict": summary["verdict"], "out_dir": repo_rel(OUT_DIR)}, sort_keys=True))
        return 0

    state = run_experiment(tex_source)
    saturation_reached = not state.blocked_reason and not any(
        node.status == "active" for node in state.nodes.values() if node.kind == "p"
    )
    safety_limit_hit = state.blocked_reason == "ROW28_DELETION_SATURATION_SAFETY_LIMIT_HIT"
    diff_rows, mismatch_rows, diff_stats = compare_to_oracle(state)

    if state.blocked_reason:
        verdict = state.blocked_reason
    elif saturation_reached and diff_stats["mismatch_count"] == 0:
        verdict = "ROW28_DELETION_SATURATION_FIGURE_A1_PASS"
    elif saturation_reached:
        verdict = "ROW28_DELETION_SATURATION_ORACLE_DIFF_FAIL"
    elif safety_limit_hit:
        verdict = "ROW28_DELETION_SATURATION_SAFETY_LIMIT_HIT"
    else:
        verdict = "ROW28_DELETION_SATURATION_CONTINUES_BEYOND_FIGURE_A1"

    generated_max_depth = max((node.expansion_depth for node in state.nodes.values() if node.kind == "p"), default=0)
    graph_max_path_length = max((node.graph_depth for node in state.nodes.values()), default=0)
    active_terminal_count = sum(1 for node in state.nodes.values() if node.status == "terminal")
    deleted_node_count = sum(1 for node in state.nodes.values() if node.status == "deleted")
    summary = {
        "run_id": RUN_ID,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "session_clock_europe_madrid": checked_at,
        "source_commit": source_commit(),
        "verdict": verdict,
        "rounds": len(state.saturation_trace),
        "generated_node_count": len(state.nodes),
        "generated_edge_count": len(state.edges),
        "generated_max_depth": generated_max_depth,
        "generated_graph_max_path_length": graph_max_path_length,
        "deleted_node_count": deleted_node_count,
        "active_terminal_count": active_terminal_count,
        "saturation_reached": saturation_reached,
        "safety_limit_hit": safety_limit_hit,
        "safety_round_limit": SAFETY_ROUND_LIMIT,
        "safety_node_limit": SAFETY_NODE_LIMIT,
        "blocked_reason": state.blocked_reason,
        "figure_a1_mismatch_count": diff_stats["mismatch_count"],
        "figure_a1_oracle_node_count": diff_stats["oracle_node_count"],
        "figure_a1_oracle_edge_count": diff_stats["oracle_edge_count"],
        "figure_a1_oracle_deleted_count": diff_stats["oracle_deleted_count"],
        "figure_a1_oracle_deleted_nodes": diff_stats["oracle_deleted_nodes"],
        "source_path": repo_rel(tex_source),
        "source_sha256": sha256(tex_source),
        "source_ranges": {
            "D1_D2_D3": "433-445",
            "phi_kminus1_min": "450-451",
            "back_substitution_setup": "680-703",
            "splitting_tree_step": "752-761",
            "deletion_rule": "763-779",
            "termination_theorem": "794-801",
        },
        "source_checks": checks,
        "oracle_policy": "Figure A1/root_paths read only after generation, for regression diff.",
        "classification": [
            "ROW28_DELETION_SATURATION_EXPERIMENT_CREATED",
            "PARAMETRIC_DELETION_RULE_EXECUTED",
            "FIGURE_A1_USED_AS_REGRESSION_ORACLE_ONLY",
            "ROW28_DELETION_SATURATION_FIGURE_A1_PASS"
            if verdict == "ROW28_DELETION_SATURATION_FIGURE_A1_PASS"
            else verdict,
            "K2_DELETION_SATURATION_ORACLE_VALIDATED"
            if verdict == "ROW28_DELETION_SATURATION_FIGURE_A1_PASS"
            else "K2_DELETION_SATURATION_ORACLE_NOT_VALIDATED",
            "GENERAL_K_DELETION_SATURATION_UNPROVED",
            "ROW28_GENERATOR_NOT_STARTED",
            "NO_K3_GENERATION",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "guardrails": [
            "NO_FIGURE_A1_AS_GENERATOR_SOURCE",
            "NO_HARDCODED_DEPTH_OR_NODE_COUNT_IN_GENERATOR_LOGIC",
            "NO_ROW28_GENERATOR_IMPLEMENTATION",
            "NO_K3_GENERATION",
            "NO_LP",
            "NO_LEAN_BUILD",
            "NO_THEOREM_CHANGE",
            "NO_HIGH_K_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
        "outputs": {
            "generated_nodes": repo_rel(GENERATED_NODES_PATH),
            "generated_edges": repo_rel(GENERATED_EDGES_PATH),
            "deletion_trace": repo_rel(DELETION_TRACE_PATH),
            "saturation_trace": repo_rel(SATURATION_TRACE_PATH),
            "figure_a1_oracle_diff": repo_rel(FIGURE_DIFF_PATH),
            "mismatch": repo_rel(MISMATCH_PATH),
            "manifest": repo_rel(MANIFEST_PATH),
        },
    }

    write_json(SUMMARY_PATH, summary)
    write_csv(
        GENERATED_NODES_PATH,
        generated_node_rows(state),
        [
            "generated_node_id",
            "parent_generated_node_id",
            "node_kind",
            "mode_class",
            "shift",
            "shift_interval_lower",
            "shift_interval_upper",
            "graph_depth",
            "expansion_depth",
            "inverse_step",
            "inverse_word",
            "status",
            "deletion_reason",
            "derivation_source_ref",
            "path_signature",
        ],
    )
    write_csv(
        GENERATED_EDGES_PATH,
        generated_edge_rows(state),
        ["edge_id", "parent", "child", "inverse_step", "shift_delta", "derivation_source_ref"],
    )
    write_csv(
        DELETION_TRACE_PATH,
        state.deletion_trace,
        [
            "round",
            "deleted_node",
            "deleted_mode",
            "earlier_matching_mode_ancestor",
            "ancestor_shift",
            "deleted_shift",
            "comparison_exact",
            "source_ref",
            "deletion_reason",
        ],
    )
    write_csv(
        SATURATION_TRACE_PATH,
        state.saturation_trace,
        [
            "round",
            "active_leaves_before",
            "expanded_leaves",
            "new_nodes",
            "deleted_nodes",
            "terminal_leaves",
            "active_leaves_after",
            "fixed_point_reached",
        ],
    )
    write_csv(FIGURE_DIFF_PATH, diff_rows, ["diff_kind", "direction", "signature", "status"])
    write_csv(MISMATCH_PATH, mismatch_rows, ["diff_kind", "direction", "signature", "status"])
    write_manifest(
        [
            SUMMARY_PATH,
            GENERATED_NODES_PATH,
            GENERATED_EDGES_PATH,
            DELETION_TRACE_PATH,
            SATURATION_TRACE_PATH,
            FIGURE_DIFF_PATH,
            MISMATCH_PATH,
        ],
        [SCRIPT_PATH, tex_source, ROOT_PATHS, ORACLE_NODES, ORACLE_EDGES],
    )

    print(json.dumps({"verdict": verdict, "out_dir": repo_rel(OUT_DIR)}, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
