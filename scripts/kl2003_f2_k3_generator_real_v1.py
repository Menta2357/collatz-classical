#!/usr/bin/env python3
"""Generate the KL2003 F2 k=3 EL trees and an exact L_3^NT certificate.

The EL trees and the L_k^NT system are derived from the parametric rules in
KL2003.  Figure A1 and the manual k=2 artifacts are regression oracles only.
Z3 searches for a candidate; every emitted inequality is then recomputed with
Python Fraction before the artifact is accepted.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import subprocess
import sys
import time
from dataclasses import dataclass, field
from decimal import Decimal, getcontext
from fractions import Fraction
from pathlib import Path
from typing import Any

import z3


SCHEMA_VERSION = "KL2003_F2_HIGH_K_DATA_CERTIFICATE_FORMAT_v2_1"
GENERATOR_VERSION = "kl2003_f2_k3_generator_real_v1.py"
RUN_ID = "KL2003_F2_K3_GENERATOR_REAL_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
JSON_PATH = OUT_DIR / "kl2003_k3_certificate.json"
LEAN_PATH = OUT_DIR / "KL2003K3CertificateData.lean"
LEAN_SOURCE_PATH = (
    REPO_ROOT
    / "CollatzClassical"
    / "KL2003"
    / "KL2003K3CertificateDataGenerated.lean"
)
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
TREE_NODES_PATH = OUT_DIR / "el_tree_nodes.csv"
TREE_EDGES_PATH = OUT_DIR / "el_tree_edges.csv"
ROWS_PATH = OUT_DIR / "l3nt_rows.csv"
SLACKS_PATH = OUT_DIR / "exact_slacks.csv"
K2_DIFF_PATH = OUT_DIR / "k2_parametric_regression.csv"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

TEX_CANDIDATES = [
    REPO_ROOT / "sources" / "kl2003" / "30apr02.tex",
    Path(
        "/Users/MoiTam/Documents/Codex/2026-07-05/"
        "tarea-krasikov-m1-feasibility-reconstruction-v2/work/sources/"
        "kl2003_src/30apr02.tex"
    ),
]
FIGURE_K2_NODES = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K2_ROW28_DELETION_SATURATION_EXPERIMENT_v1"
    / "generated_nodes.csv"
)
K2_FULL_SUMMARY = (
    REPO_ROOT / "outputs" / "KL2003_F2_K2_GENERATOR_REGRESSION_v1" / "summary.json"
)

K = 3
MODULUS = 3**K
CLASS_STEP = 3 ** (K - 1)
TRACKED = list(range(2, MODULUS, 3))
AUXILIARY = list(range(2, CLASS_STEP, 3))
LAMBDA = Fraction(152759, 100000)
ALPHA_LOWER = Fraction(569, 359)
B_LOWER = Fraction(104843, 125000)
D_LOWER = LAMBDA * B_LOWER
A_COEFF = 1 / (LAMBDA**2)
ROW_EPSILON = Fraction(1, 10_000_000)
MAX_CANDIDATE_DENOMINATOR = 10_000
SOURCE_LAMBDA3 = Decimal("1.5275960")
SOURCE_GAMMA3 = Decimal("0.6112620")
SOURCE_CMAX3 = Decimal("3.4881908")

SHIFT_ZERO = (0, 0)
SHIFT_MINUS_TWO = (0, -2)
SHIFT_ALPHA_MINUS_ONE = (1, -1)
SHIFT_ALPHA_MINUS_TWO = (1, -2)


def repo_rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def source_commit() -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=REPO_ROOT, text=True
    ).strip()


def source_commit_time() -> str:
    return subprocess.check_output(
        ["git", "show", "-s", "--format=%cI", "HEAD"],
        cwd=REPO_ROOT,
        text=True,
    ).strip()


def find_tex_source() -> Path:
    for candidate in TEX_CANDIDATES:
        if candidate.exists():
            return candidate
    raise FileNotFoundError("BLOCKED_ON_KL2003_TEX_SOURCE")


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            encoded: dict[str, Any] = {}
            for field_name in fields:
                value = row.get(field_name, "")
                encoded[field_name] = (
                    json.dumps(value, sort_keys=True)
                    if isinstance(value, (dict, list, tuple))
                    else value
                )
            writer.writerow(encoded)


def fraction_text(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def z3_rat(value: Fraction) -> z3.RatNumRef:
    return z3.Q(value.numerator, value.denominator)


def shift_add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return (left[0] + right[0], left[1] + right[1])


def shift_sub(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return (left[0] - right[0], left[1] - right[1])


def shift_compare(left: tuple[int, int], right: tuple[int, int]) -> int:
    """Compare a*log_2(3)+b exactly using integer powers."""
    alpha_coeff, const = shift_sub(left, right)
    lhs = 3 ** max(alpha_coeff, 0) * 2 ** max(const, 0)
    rhs = 3 ** max(-alpha_coeff, 0) * 2 ** max(-const, 0)
    return (lhs > rhs) - (lhs < rhs)


def shift_text(shift: tuple[int, int]) -> str:
    alpha_coeff, const = shift
    if alpha_coeff == 0:
        return str(const)
    if alpha_coeff == 1:
        head = "alpha"
    elif alpha_coeff == -1:
        head = "-alpha"
    else:
        head = f"{alpha_coeff}*alpha"
    if const == 0:
        return head
    return f"{head}{'+' if const > 0 else '-'}{abs(const)}"


def row_kind(mode: int) -> str:
    return {2: "D1", 5: "D2", 8: "D3"}[mode % 9]


def tracked_lifts(base_mode: int, k: int) -> list[int]:
    modulus = 3**k
    step = 3 ** (k - 1)
    base = base_mode % step
    return [(base + index * step) % modulus for index in range(3)]


@dataclass
class TreeNode:
    node_id: str
    root_mode: int
    parent_id: str
    kind: str
    mode: int | None
    shift: tuple[int, int] | None
    graph_depth: int
    expansion_depth: int
    inverse_step: str
    inverse_word: list[str]
    status: str
    split_rule: str
    deletion_reason: str = ""


@dataclass
class TreeEdge:
    edge_id: str
    root_mode: int
    parent_id: str
    child_id: str
    inverse_step: str
    shift_delta: tuple[int, int] | None


@dataclass
class TreeState:
    k: int
    root_mode: int
    expand_d2: bool
    nodes: dict[str, TreeNode] = field(default_factory=dict)
    edges: list[TreeEdge] = field(default_factory=list)
    deletions: list[dict[str, str]] = field(default_factory=list)
    rounds: int = 0
    node_counter: int = 0
    edge_counter: int = 0

    @property
    def modulus(self) -> int:
        return 3**self.k

    def add_node(
        self,
        *,
        parent_id: str,
        kind: str,
        mode: int | None,
        shift: tuple[int, int] | None,
        graph_depth: int,
        expansion_depth: int,
        inverse_step: str,
        inverse_word: list[str],
        status: str,
        split_rule: str,
    ) -> TreeNode:
        node_id = f"k{self.k}m{self.root_mode}_G{self.node_counter:03d}"
        self.node_counter += 1
        node = TreeNode(
            node_id=node_id,
            root_mode=self.root_mode,
            parent_id=parent_id,
            kind=kind,
            mode=mode,
            shift=shift,
            graph_depth=graph_depth,
            expansion_depth=expansion_depth,
            inverse_step=inverse_step,
            inverse_word=inverse_word,
            status=status,
            split_rule=split_rule,
        )
        self.nodes[node_id] = node
        if parent_id:
            parent = self.nodes[parent_id]
            delta = (
                shift_sub(shift, parent.shift)
                if shift is not None and parent.shift is not None
                else None
            )
            self.edges.append(
                TreeEdge(
                    edge_id=f"k{self.k}m{self.root_mode}_E{self.edge_counter:03d}",
                    root_mode=self.root_mode,
                    parent_id=parent_id,
                    child_id=node_id,
                    inverse_step=inverse_step,
                    shift_delta=delta,
                )
            )
            self.edge_counter += 1
        return node


def p_ancestors(state: TreeState, node: TreeNode) -> list[TreeNode]:
    result: list[TreeNode] = []
    parent_id = node.parent_id
    while parent_id:
        parent = state.nodes[parent_id]
        if parent.kind == "p":
            result.append(parent)
        parent_id = parent.parent_id
    return result


def terminal_status(
    shift: tuple[int, int], mode: int, *, expand_d2: bool
) -> str:
    if shift_compare(shift, SHIFT_ZERO) < 0:
        return "terminal"
    if row_kind(mode) == "D2" and not expand_d2:
        return "terminal"
    return "active"


def apply_deletion(state: TreeState, leaves: list[TreeNode], round_index: int) -> None:
    for leaf in leaves:
        assert leaf.mode is not None and leaf.shift is not None
        if shift_compare(leaf.shift, SHIFT_ZERO) < 0:
            continue
        for ancestor in p_ancestors(state, leaf):
            if ancestor.mode != leaf.mode or ancestor.shift is None:
                continue
            if shift_compare(ancestor.shift, leaf.shift) < 0:
                leaf.status = "deleted"
                leaf.deletion_reason = (
                    f"same mode {leaf.mode}: ancestor {ancestor.node_id} at "
                    f"{shift_text(ancestor.shift)} < {shift_text(leaf.shift)}"
                )
                state.deletions.append(
                    {
                        "round": str(round_index),
                        "deleted_node_id": leaf.node_id,
                        "ancestor_node_id": ancestor.node_id,
                        "mode": str(leaf.mode),
                        "ancestor_shift": shift_text(ancestor.shift),
                        "deleted_shift": shift_text(leaf.shift),
                        "reason": leaf.deletion_reason,
                    }
                )
                break


def expand_leaf(state: TreeState, node: TreeNode, round_index: int) -> None:
    assert node.kind == "p" and node.mode is not None and node.shift is not None
    rule = row_kind(node.mode)
    node.status = "expanded"
    retarded_mode = (4 * node.mode) % state.modulus
    retarded_shift = shift_add(node.shift, SHIFT_MINUS_TWO)
    state.add_node(
        parent_id=node.node_id,
        kind="p",
        mode=retarded_mode,
        shift=retarded_shift,
        graph_depth=node.graph_depth + 1,
        expansion_depth=node.expansion_depth + 1,
        inverse_step=f"{rule}_retarded_4m",
        inverse_word=node.inverse_word + [f"{rule}:retarded"],
        status=terminal_status(
            retarded_shift, retarded_mode, expand_d2=state.expand_d2
        ),
        split_rule=rule,
    )
    if rule == "D2":
        return

    if rule == "D1":
        numerator = 4 * node.mode - 2
        advanced_delta = SHIFT_ALPHA_MINUS_TWO
    else:
        numerator = 2 * node.mode - 1
        advanced_delta = SHIFT_ALPHA_MINUS_ONE
    if numerator % 3:
        raise RuntimeError("BLOCKED_ON_PARAMETRIC_EL_EXPANSION_RULE")
    base_mode = numerator // 3
    advanced_shift = shift_add(node.shift, advanced_delta)
    min_node = state.add_node(
        parent_id=node.node_id,
        kind="m",
        mode=None,
        shift=None,
        graph_depth=node.graph_depth + 1,
        expansion_depth=node.expansion_depth + 1,
        inverse_step=f"{rule}_kminus1_min",
        inverse_word=node.inverse_word + [f"{rule}:min"],
        status="expanded",
        split_rule=rule,
    )
    new_leaves: list[TreeNode] = []
    for mode in tracked_lifts(base_mode, state.k):
        new_leaves.append(
            state.add_node(
                parent_id=min_node.node_id,
                kind="p",
                mode=mode,
                shift=advanced_shift,
                graph_depth=min_node.graph_depth + 1,
                expansion_depth=node.expansion_depth + 1,
                inverse_step=f"{rule}_advanced_min_class_{mode}",
                inverse_word=node.inverse_word
                + [f"{rule}:min", f"class:{mode}"],
                status=terminal_status(
                    advanced_shift, mode, expand_d2=state.expand_d2
                ),
                split_rule=rule,
            )
        )
    apply_deletion(state, new_leaves, round_index)


def generate_tree(k: int, root_mode: int, *, expand_d2: bool = True) -> TreeState:
    state = TreeState(k=k, root_mode=root_mode, expand_d2=expand_d2)
    state.add_node(
        parent_id="",
        kind="p",
        mode=root_mode,
        shift=SHIFT_ZERO,
        graph_depth=0,
        expansion_depth=0,
        inverse_step="root",
        inverse_word=[],
        status="active",
        split_rule="D3",
    )
    for round_index in range(1, 256):
        active = [
            node
            for node in state.nodes.values()
            if node.kind == "p" and node.status == "active"
        ]
        if not active:
            state.rounds = round_index - 1
            return state
        for node in active:
            expand_leaf(state, node, round_index)
        if len(state.nodes) > 1_000_000:
            raise RuntimeError("EL_TREE_SAFETY_NODE_LIMIT_HIT")
    raise RuntimeError("EL_TREE_SAFETY_ROUND_LIMIT_HIT")


def node_path_signature(state: TreeState, node: TreeNode) -> str:
    path: list[TreeNode] = []
    current = node
    while True:
        path.append(current)
        if not current.parent_id:
            break
        current = state.nodes[current.parent_id]
    labels: list[str] = []
    for item in reversed(path):
        if item.kind == "m":
            labels.append("M")
        else:
            assert item.mode is not None and item.shift is not None
            labels.append(f"p:{item.mode}:{shift_text(item.shift)}")
    return " -> ".join(labels)


def k2_regression(tex_source: Path) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    checks: list[dict[str, str]] = []
    mismatches: list[dict[str, str]] = []
    complete = generate_tree(2, 8, expand_d2=True)
    projection = generate_tree(2, 8, expand_d2=False)
    complete_p = [node for node in complete.nodes.values() if node.kind == "p"]
    complete_leaves = [node for node in complete_p if node.status == "terminal"]
    projection_signatures = {
        (node_path_signature(projection, node), node.status)
        for node in projection.nodes.values()
    }
    oracle_rows = read_csv(FIGURE_K2_NODES)
    oracle_signatures = {(row["path_signature"], row["status"]) for row in oracle_rows}
    expected = {
        "complete_kept_literals": (len(complete_leaves), 8),
        "complete_deleted": (len(complete.deletions), 2),
        "complete_depth": (
            max(node.expansion_depth for node in complete_p),
            3,
        ),
        "figure_projection_nodes": (len(projection.nodes), 16),
        "figure_projection_edges": (len(projection.edges), 15),
        "figure_projection_signatures": (
            len(projection_signatures.symmetric_difference(oracle_signatures)),
            0,
        ),
    }
    for check_id, (actual, wanted) in expected.items():
        status = "pass" if actual == wanted else "fail"
        row = {
            "check_id": check_id,
            "actual": str(actual),
            "expected": str(wanted),
            "status": status,
        }
        checks.append(row)
        if status == "fail":
            mismatches.append({"category": "k2_regression", **row})
    full_summary = read_json(K2_FULL_SUMMARY)
    full_verdict = full_summary.get("verdict")
    row = {
        "check_id": "manual_k2_full_regression_prerequisite",
        "actual": str(full_verdict),
        "expected": "K2_REGRESSION_PASS",
        "status": "pass" if full_verdict == "K2_REGRESSION_PASS" else "fail",
    }
    checks.append(row)
    if row["status"] == "fail":
        mismatches.append({"category": "k2_regression", **row})
    return checks, mismatches


def lnt_row_spec(k: int, mode: int) -> dict[str, Any]:
    modulus = 3**k
    kind = row_kind(mode)
    result: dict[str, Any] = {
        "mode": mode,
        "kind": kind,
        "retarded_mode": (4 * mode) % modulus,
    }
    if kind == "D1":
        result["auxiliary_mode"] = ((4 * mode - 2) // 3) % (3 ** (k - 1))
        result["advanced_coefficient"] = B_LOWER
    elif kind == "D3":
        result["auxiliary_mode"] = ((2 * mode - 1) // 3) % (3 ** (k - 1))
        result["advanced_coefficient"] = D_LOWER
    return result


def z3_fraction(model: z3.ModelRef, expression: z3.ArithRef) -> Fraction:
    value = model.eval(expression, model_completion=True)
    if not isinstance(value, z3.RatNumRef):
        raise RuntimeError(f"NON_RATIONAL_Z3_MODEL_VALUE:{value}")
    return Fraction(value.numerator_as_long(), value.denominator_as_long())


def exact_row_slacks(
    principal: dict[int, Fraction], auxiliary: dict[int, Fraction]
) -> dict[int, Fraction]:
    result: dict[int, Fraction] = {}
    for mode in TRACKED:
        spec = lnt_row_spec(K, mode)
        rhs = A_COEFF * principal[spec["retarded_mode"]]
        if "auxiliary_mode" in spec:
            rhs += spec["advanced_coefficient"] * auxiliary[spec["auxiliary_mode"]]
        result[mode] = rhs - principal[mode]
    return result


def certificate_valid(
    principal: dict[int, Fraction], auxiliary: dict[int, Fraction]
) -> bool:
    if any(value < 1 for value in principal.values()):
        return False
    if any(value < 1 for value in auxiliary.values()):
        return False
    for mode in AUXILIARY:
        if any(auxiliary[mode] > principal[mode + index * CLASS_STEP] for index in range(3)):
            return False
    return all(slack > 0 for slack in exact_row_slacks(principal, auxiliary).values())


def solve_certificate() -> dict[str, Any]:
    principal_vars = {mode: z3.Real(f"c3_{mode}") for mode in TRACKED}
    auxiliary_vars = {mode: z3.Real(f"c2_{mode}") for mode in AUXILIARY}
    cmax = z3.Real("c3_max")
    optimizer = z3.Optimize()
    for variable in principal_vars.values():
        optimizer.add(variable >= 1, variable <= cmax)
    for variable in auxiliary_vars.values():
        optimizer.add(variable >= 1)
    for mode in AUXILIARY:
        for index in range(3):
            optimizer.add(auxiliary_vars[mode] <= principal_vars[mode + index * CLASS_STEP])
    for mode in TRACKED:
        spec = lnt_row_spec(K, mode)
        rhs = z3_rat(A_COEFF) * principal_vars[spec["retarded_mode"]]
        if "auxiliary_mode" in spec:
            rhs += z3_rat(spec["advanced_coefficient"]) * auxiliary_vars[spec["auxiliary_mode"]]
        optimizer.add(rhs - principal_vars[mode] >= z3_rat(ROW_EPSILON))
    optimizer.minimize(cmax)
    if optimizer.check() != z3.sat:
        raise RuntimeError("K3_LNT_RATIONAL_CANDIDATE_UNSAT")
    model = optimizer.model()
    raw_principal = {
        mode: z3_fraction(model, variable) for mode, variable in principal_vars.items()
    }
    raw_auxiliary = {
        mode: z3_fraction(model, variable) for mode, variable in auxiliary_vars.items()
    }
    selected_denominator = 0
    principal: dict[int, Fraction] = {}
    auxiliary: dict[int, Fraction] = {}
    for denominator in [10_000, 100_000, 1_000_000]:
        candidate_principal = {
            mode: value.limit_denominator(denominator)
            for mode, value in raw_principal.items()
        }
        candidate_auxiliary = {
            mode: value.limit_denominator(denominator)
            for mode, value in raw_auxiliary.items()
        }
        if certificate_valid(candidate_principal, candidate_auxiliary):
            selected_denominator = denominator
            principal = candidate_principal
            auxiliary = candidate_auxiliary
            break
    if not selected_denominator:
        raise RuntimeError("K3_RATIONAL_RECONSTRUCTION_FAILED")
    slacks = exact_row_slacks(principal, auxiliary)
    l4_slacks = {
        f"L4_c2_{mode}_le_c3_{mode + index * CLASS_STEP}":
        principal[mode + index * CLASS_STEP] - auxiliary[mode]
        for mode in AUXILIARY
        for index in range(3)
    }
    return {
        "principal": principal,
        "auxiliary": auxiliary,
        "slacks": slacks,
        "l4_slacks": l4_slacks,
        "cmax": max(principal.values()),
        "selected_denominator": selected_denominator,
        "solver": f"z3-{z3.get_version_string()}",
    }


def decimal_diagnostics(certificate: dict[str, Any]) -> dict[str, str]:
    getcontext().prec = 60
    lambda_decimal = Decimal(LAMBDA.numerator) / Decimal(LAMBDA.denominator)
    gamma = lambda_decimal.ln() / Decimal(2).ln()
    cmax = Decimal(certificate["cmax"].numerator) / Decimal(
        certificate["cmax"].denominator
    )
    return {
        "lambda": str(lambda_decimal),
        "gamma": str(gamma),
        "cmax": str(cmax),
        "source_lambda3": str(SOURCE_LAMBDA3),
        "source_gamma3": str(SOURCE_GAMMA3),
        "source_cmax3": str(SOURCE_CMAX3),
        "lambda_abs_diff": str(abs(lambda_decimal - SOURCE_LAMBDA3)),
        "gamma_abs_diff": str(abs(gamma - SOURCE_GAMMA3)),
        "cmax_abs_diff": str(abs(cmax - SOURCE_CMAX3)),
    }


def source_witnesses() -> dict[str, Any]:
    alpha_witness = 3**ALPHA_LOWER.denominator > 2**ALPHA_LOWER.numerator
    endpoint_witness = D_LOWER**ALPHA_LOWER.denominator <= LAMBDA ** (
        ALPHA_LOWER.numerator - ALPHA_LOWER.denominator
    )
    if not alpha_witness or not endpoint_witness:
        raise RuntimeError("K3_TRANSCENDENTAL_ENDPOINT_WITNESS_FAILED")
    return {
        "alpha_lower": fraction_text(ALPHA_LOWER),
        "alpha_integer_witness": "3^359 > 2^569",
        "alpha_integer_witness_holds": alpha_witness,
        "B_lower": fraction_text(B_LOWER),
        "D_lower": fraction_text(D_LOWER),
        "D_power_witness": "D_lower^359 <= lambda^210",
        "D_power_witness_holds": endpoint_witness,
    }


def tree_children(state: TreeState) -> dict[str, list[TreeNode]]:
    result: dict[str, list[TreeNode]] = {node_id: [] for node_id in state.nodes}
    for edge in state.edges:
        result[edge.parent_id].append(state.nodes[edge.child_id])
    return result


def node_operand(node: TreeNode) -> dict[str, str]:
    if node.status == "expanded":
        return {"block_ref": f"expand_{node.node_id}"}
    return {"node_ref": node.node_id}


def tree_schema_parts(
    states: list[TreeState],
) -> tuple[
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
]:
    nodes: list[dict[str, Any]] = []
    blocks: list[dict[str, Any]] = []
    deletion_marks: list[dict[str, Any]] = []
    post_deletion_edges: list[dict[str, Any]] = []
    sibling_groups: list[dict[str, Any]] = []
    inverse_words: list[dict[str, Any]] = []
    for state in states:
        children = tree_children(state)
        for node in state.nodes.values():
            status = node.status
            nodes.append(
                {
                    "node_id": node.node_id,
                    "parent_node_id": node.parent_id,
                    "root_class": str(state.root_mode),
                    "node_kind": node.kind,
                    "class": str(node.mode) if node.mode is not None else "min",
                    "shift": shift_text(node.shift) if node.shift is not None else "0",
                    "node_status": status,
                    "contributes_to_cardinality": status == "terminal",
                    "graph_depth": str(node.graph_depth),
                    "expansion_depth": str(node.expansion_depth),
                    "inverse_step": node.inverse_step,
                }
            )
            if node.kind == "p" and status in {"terminal", "deleted"}:
                inverse_words.append(
                    {
                        "literal_id": f"literal_{node.node_id}",
                        "child_id": node.node_id,
                        "row_id": f"EL_root_{state.root_mode}",
                        "inverse_word": node.inverse_word,
                        "target_class": str(node.mode),
                        "shift": shift_text(node.shift or SHIFT_ZERO),
                        "window_policy": "source_EL_shift",
                        "fiber_parent": node.parent_id or node.node_id,
                        "deleted": status == "deleted",
                        "reason": node.deletion_reason or "terminal retarded EL literal",
                        "boundary_correction": "deletion_rule" if status == "deleted" else "none",
                    }
                )
            if node.status == "deleted":
                live_siblings = [
                    sibling.node_id
                    for sibling in children[node.parent_id]
                    if sibling.status != "deleted"
                ]
                deletion_marks.append(
                    {
                        "node_id": node.node_id,
                        "child_id": node.node_id,
                        "row_id": f"EL_root_{state.root_mode}",
                        "deleted": True,
                        "deletion_policy": "same_mode_earlier_path_smaller_shift",
                        "reason": node.deletion_reason,
                        "boundary_correction": "count_surviving_siblings_only",
                        "deletion_source_ref": "source_refs.deletion_rule",
                    }
                )
                post_deletion_edges.append(
                    {
                        "deleted_node_id": node.node_id,
                        "replacement_child_ids": live_siblings,
                        "reason": "deleted leaf omitted; surviving siblings remain in min block",
                    }
                )
        for node in state.nodes.values():
            if node.status != "expanded":
                continue
            live_children = [child for child in children[node.node_id] if child.status != "deleted"]
            if node.kind == "m":
                block_id = f"expand_{node.node_id}"
                blocks.append(
                    {
                        "block_id": block_id,
                        "block_kind": "min",
                        "children": [node_operand(child) for child in live_children],
                        "source_refs": ["source_refs.kminus1_min"],
                    }
                )
                sibling_groups.append(
                    {
                        "group_id": f"siblings_{node.node_id}",
                        "parent_fiber": node.node_id,
                        "member_node_ids": [child.node_id for child in live_children],
                    }
                )
            else:
                blocks.append(
                    {
                        "block_id": f"expand_{node.node_id}",
                        "block_kind": "row",
                        "children": [node_operand(child) for child in live_children],
                        "source_refs": [f"source_refs.{node.split_rule}"],
                    }
                )
    return (
        nodes,
        blocks,
        deletion_marks,
        post_deletion_edges,
        sibling_groups,
        inverse_words,
    )


def row_child(
    *, row_id: str, child_id: str, target: str, branch: str, shift: str
) -> dict[str, Any]:
    return {
        "child_id": child_id,
        "literal_id": child_id,
        "row_id": row_id,
        "inverse_word": [branch],
        "target_class": target,
        "shift": shift,
        "window_policy": "L_k_NT_coefficient_shift",
        "fiber_parent": row_id,
        "deleted": False,
        "reason": f"parametric {branch} term",
        "boundary_correction": "none",
    }


def rows_json(certificate: dict[str, Any]) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    for mode in TRACKED:
        spec = lnt_row_spec(K, mode)
        row_id = f"L3NT_{spec['kind']}_m{mode}"
        children = [
            row_child(
                row_id=row_id,
                child_id=f"{row_id}_retarded",
                target=str(spec["retarded_mode"]),
                branch="retarded_4m",
                shift="-2",
            )
        ]
        terms = [
            {
                "coefficient_id": "A_lambda_minus_2",
                "target": str(spec["retarded_mode"]),
                "value": fraction_text(A_COEFF),
            }
        ]
        if "auxiliary_mode" in spec:
            children.append(
                row_child(
                    row_id=row_id,
                    child_id=f"{row_id}_advanced",
                    target=f"c2_{spec['auxiliary_mode']}",
                    branch="advanced_kminus1",
                    shift="alpha-2" if spec["kind"] == "D1" else "alpha-1",
                )
            )
            terms.append(
                {
                    "coefficient_id": "B_lower" if spec["kind"] == "D1" else "D_lower",
                    "target": f"c2_{spec['auxiliary_mode']}",
                    "value": fraction_text(spec["advanced_coefficient"]),
                }
            )
        result.append(
            {
                "row_id": row_id,
                "source_class": str(mode),
                "row_kind": spec["kind"],
                "children": children,
                "deletion_policy": "not_applicable_L_k_NT_row",
                "coefficient_terms": terms,
                "target_bound": fraction_text(certificate["principal"][mode]),
                "slack_id": f"L3NT_{spec['kind']}_m{mode}_slack",
                "normalization_ref": "L0_min_principal_ge_one",
                "source_ref": f"30apr02.tex:L{spec['kind'][-1]}",
            }
        )
    return result


def slacks_json(certificate: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for mode, slack in certificate["slacks"].items():
        spec = lnt_row_spec(K, mode)
        target = certificate["principal"][mode]
        rhs = target + slack
        rows.append(
            {
                "slack_id": f"L3NT_{spec['kind']}_m{mode}_slack",
                "row_id": f"L3NT_{spec['kind']}_m{mode}",
                "lhs": fraction_text(target),
                "rhs": fraction_text(rhs),
                "slack": fraction_text(slack),
                "strictly_positive": True,
                "numerator_bits": str(slack.numerator.bit_length()),
                "denominator_bits": str(slack.denominator.bit_length()),
                "notes": "Recomputed exactly after bounded-denominator reconstruction.",
            }
        )
    return rows


def tracked_classes_json() -> list[dict[str, Any]]:
    return [
        {
            "class_id": f"c3_{mode}",
            "modulus": str(MODULUS),
            "representative": str(mode),
            "active": True,
            "pre_reduction_residues": [str(mode)],
            "source_rule": f"[3^k] classes congruent 2 mod 3; row {row_kind(mode)}",
            "notes": "principal L_3^NT class",
        }
        for mode in TRACKED
    ]


def artifact_json(
    *,
    commit: str,
    created_at: str,
    tex_source: Path,
    states: list[TreeState],
    certificate: dict[str, Any],
    diagnostics: dict[str, str],
    witnesses: dict[str, Any],
) -> dict[str, Any]:
    nodes, blocks, deletions, post_edges, sibling_groups, inverse_words = tree_schema_parts(states)
    generated_rows = rows_json(certificate)
    row_inverse_words = [
        dict(child)
        for row in generated_rows
        for child in row["children"]
    ]
    variables = {
        **{f"c3_{mode}": fraction_text(value) for mode, value in certificate["principal"].items()},
        **{f"c2_{mode}": fraction_text(value) for mode, value in certificate["auxiliary"].items()},
        "C3max": fraction_text(certificate["cmax"]),
    }
    coefficient_intervals = [
        {"coefficient_id": "A_lambda_minus_2", "lo": fraction_text(A_COEFF), "hi": fraction_text(A_COEFF)},
        {"coefficient_id": "B_lower", "lo": fraction_text(B_LOWER), "hi": fraction_text(B_LOWER)},
        {"coefficient_id": "D_lower", "lo": fraction_text(D_LOWER), "hi": fraction_text(D_LOWER)},
    ]
    return {
        "metadata": {
            "run_id": RUN_ID,
            "schema_version": SCHEMA_VERSION,
            "generator_version": GENERATOR_VERSION,
            "generator_mode": "k3_real_generator_pilot",
            "k": str(K),
            "tracked_class_count": str(len(TRACKED)),
            "pre_reduction_class_count": str(MODULUS),
            "created_at": created_at,
            "source_commit": commit,
            "scope": "k3_method_pilot_not_high_k_theorem",
            "mathematical_generation": True,
            "mathematical_content": "EL_trees_L3NT_rows_exact_rational_candidate",
            "proof_status": "generated_data_candidate_pending_lean_verifier",
            "no_theorem_claim": True,
            "artifact_links": {
                "json_artifact": repo_rel(JSON_PATH),
                "lean_data_artifact": repo_rel(LEAN_PATH),
                "lean_source_data_artifact": repo_rel(LEAN_SOURCE_PATH),
                "json_to_lean_generator": repo_rel(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "json_sha256": "RECORDED_IN_MANIFEST",
                "lean_data_sha256": "RECORDED_IN_MANIFEST",
                "json_to_lean_generator_sha256": sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION),
                "lean_import_policy": "The source-tree twin is imported only by the verifier; both twins must hash identically.",
            },
        },
        "tracked_classes": tracked_classes_json(),
        "rows": generated_rows,
        "inverse_words": row_inverse_words + inverse_words,
        "deletion_marks": deletions,
        "rational_certificate": {
            "lambda_interval": {"lo": fraction_text(LAMBDA), "hi": fraction_text(LAMBDA)},
            "coefficient_intervals": coefficient_intervals,
            "variables": variables,
            "row_equations": {
                f"L3NT_m{mode}": (
                    f"A*c3_{lnt_row_spec(K, mode)['retarded_mode']}"
                    + (
                        f"+{('B' if row_kind(mode) == 'D1' else 'D')}*c2_{lnt_row_spec(K, mode)['auxiliary_mode']}"
                        if "auxiliary_mode" in lnt_row_spec(K, mode)
                        else ""
                    )
                    + f"-c3_{mode}"
                )
                for mode in TRACKED
            },
            "l4_slacks": {key: fraction_text(value) for key, value in certificate["l4_slacks"].items()},
            "transcendental_endpoint_witnesses": witnesses,
            "float_diagnostics_as_strings": diagnostics,
            "solver_manifest": {
                "solver": certificate["solver"],
                "fixed_lambda": fraction_text(LAMBDA),
                "requested_row_epsilon": fraction_text(ROW_EPSILON),
                "bounded_denominator": str(certificate["selected_denominator"]),
                "exact_fraction_recheck": True,
                "lp_solved": True,
            },
        },
        "slacks": slacks_json(certificate),
        "nodes": nodes,
        "nested_blocks": blocks,
        "post_deletion_edges": post_edges,
        "sibling_disjointness_groups": sibling_groups,
        "overlap_guards": [
            {
                "guard_id": "global_no_parent_descendant_sum",
                "guard_kind": "no_parent_descendant_sum",
                "status": "required",
            }
        ],
        "source_refs": [
            {
                "source_ref_id": "D1",
                "source_kind": "primary_tex",
                "path": str(tex_source),
                "lines": "433-436",
                "trust_role": "generator_rule",
            },
            {
                "source_ref_id": "D2",
                "source_kind": "primary_tex",
                "path": str(tex_source),
                "lines": "438-441",
                "trust_role": "generator_rule",
            },
            {
                "source_ref_id": "D3",
                "source_kind": "primary_tex",
                "path": str(tex_source),
                "lines": "443-446",
                "trust_role": "generator_rule",
            },
            {
                "source_ref_id": "kminus1_min",
                "source_kind": "primary_tex",
                "path": str(tex_source),
                "lines": "448-451",
                "trust_role": "generator_rule",
            },
            {
                "source_ref_id": "deletion_rule",
                "source_kind": "primary_tex",
                "path": str(tex_source),
                "lines": "769-777",
                "trust_role": "generator_rule",
            },
            {
                "source_ref_id": "termination_theorem",
                "source_kind": "primary_tex",
                "path": str(tex_source),
                "lines": "794-858",
                "trust_role": "source_theorem_not_lean_proof",
            },
            {
                "source_ref_id": "figure_a1_oracle",
                "source_kind": "figure_a1",
                "path": repo_rel(FIGURE_K2_NODES),
                "trust_role": "regression_oracle",
            },
        ],
        "termination_policy": {
            "kind": "expand_until_deletion_saturation",
            "status": "source_theorem_run_witness_unverified_in_lean",
            "termination_rule_ref": "source_refs.termination_theorem",
            "run_fixed_points": {str(state.root_mode): str(state.rounds) for state in states},
        },
        "verification_targets": [
            {"target_id": "k2_regression", "required": True, "status": "PASS"},
            {"target_id": "EL_tree_well_formed", "required": True, "status": "PENDING_LEAN_VERIFIER"},
            {"target_id": "L3NT_certificate", "required": True, "status": "PENDING_LEAN_VERIFIER"},
            {"target_id": "transcendental_endpoints", "required": True, "status": "PENDING_LEAN_VERIFIER"},
        ],
        "guardrails": [
            "K3_METHOD_PILOT_ONLY",
            "GENERATED_DATA_NOT_A_PROOF",
            "FIGURE_A1_IS_K2_REGRESSION_ORACLE_ONLY",
            "NO_K9_GENERATION",
            "NO_K11_GENERATION",
            "NO_HIGH_K_THEOREM_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }


def lean_fraction(value: Fraction) -> str:
    return f"({value.numerator} / {value.denominator} : Rat)"


def emit_lean_data(certificate: dict[str, Any], states: list[TreeState]) -> str:
    principal = ",\n    ".join(
        f"({mode}, {lean_fraction(value)})" for mode, value in certificate["principal"].items()
    )
    auxiliary = ",\n    ".join(
        f"({mode}, {lean_fraction(value)})" for mode, value in certificate["auxiliary"].items()
    )
    slacks = ",\n    ".join(
        f"({mode}, {lean_fraction(value)})" for mode, value in certificate["slacks"].items()
    )
    tree_metrics = ",\n    ".join(
        f"({state.root_mode}, {sum(n.kind == 'p' and n.status == 'terminal' for n in state.nodes.values())}, "
        f"{len(state.deletions)}, {max(n.expansion_depth for n in state.nodes.values())})"
        for state in states
    )
    individual_principal = "\n".join(
        f"def c3_{mode} : Rat := {lean_fraction(value)}"
        for mode, value in certificate["principal"].items()
    )
    individual_auxiliary = "\n".join(
        f"def c2_{mode} : Rat := {lean_fraction(value)}"
        for mode, value in certificate["auxiliary"].items()
    )
    individual_slacks = "\n".join(
        f"def slack_m{mode} : Rat := {lean_fraction(value)}"
        for mode, value in certificate["slacks"].items()
    )
    tree_node_records: dict[int, list[str]] = {}
    status_code = {"expanded": 0, "terminal": 1, "deleted": 2, "active": 3}
    for state in states:
        tree_node_records[state.root_mode] = []
        deletion_ancestor = {
            row["deleted_node_id"]: row["ancestor_node_id"]
            for row in state.deletions
        }
        local_index = {
            node_id: index for index, node_id in enumerate(state.nodes)
        }
        child_indices: dict[str, list[int]] = {
            node_id: [] for node_id in state.nodes
        }
        for edge in state.edges:
            child_indices[edge.parent_id].append(local_index[edge.child_id])
        for index, node in enumerate(state.nodes.values()):
            parent_index = local_index[node.parent_id] if node.parent_id else 0
            ancestor_index = (
                local_index[deletion_ancestor[node.node_id]]
                if node.node_id in deletion_ancestor
                else 0
            )
            alpha_coeff, const = node.shift if node.shift is not None else (0, 0)
            children = ", ".join(str(value) for value in child_indices[node.node_id])
            tree_node_records[state.root_mode].append(
                "{ rootMode := "
                f"{state.root_mode}, nodeIndex := {index}, "
                f"isRoot := {str(not node.parent_id).lower()}, "
                f"parentIndex := {parent_index}, isMin := {str(node.kind == 'm').lower()}, "
                f"mode := {node.mode or 0}, alphaCoeff := {alpha_coeff}, const := {const}, "
                f"status := {status_code[node.status]}, expansionDepth := {node.expansion_depth}, "
                f"deletionAncestorIndex := {ancestor_index}, childIndices := [{children}] }}"
            )
    tree_arrays = "\n\n".join(
        f"def treeNodes{root_mode} : Array TreeNodeData := #[\n    "
        + ",\n    ".join(tree_node_records[root_mode])
        + "\n  ]"
        for root_mode in (8, 17, 26)
    )
    return f'''import Mathlib.Data.Rat.Defs

/- This file is generated by {GENERATOR_VERSION}.
It is data, not a theorem.  The verifier must recheck every property. -/

namespace CollatzClassical.KL2003.GeneratedK3

structure TreeNodeData where
  rootMode : Nat
  nodeIndex : Nat
  isRoot : Bool
  parentIndex : Nat
  isMin : Bool
  mode : Nat
  alphaCoeff : Int
  const : Int
  status : Nat
  expansionDepth : Nat
  deletionAncestorIndex : Nat
  childIndices : List Nat
deriving Repr, DecidableEq

def lambda : Rat := {lean_fraction(LAMBDA)}
def aCoeff : Rat := {lean_fraction(A_COEFF)}
def bLower : Rat := {lean_fraction(B_LOWER)}
def dLower : Rat := {lean_fraction(D_LOWER)}
def alphaLower : Rat := {lean_fraction(ALPHA_LOWER)}

{individual_principal}

{individual_auxiliary}

{individual_slacks}

def principal : List (Nat × Rat) := [
    {principal}
  ]

def auxiliary : List (Nat × Rat) := [
    {auxiliary}
  ]

def rowSlacks : List (Nat × Rat) := [
    {slacks}
  ]

def treeMetrics : List (Nat × Nat × Nat × Nat) := [
    {tree_metrics}
  ]

{tree_arrays}

def treeNodes : List TreeNodeData :=
  treeNodes8.toList ++ treeNodes17.toList ++ treeNodes26.toList

end CollatzClassical.KL2003.GeneratedK3
'''


def tree_node_rows(states: list[TreeState]) -> list[dict[str, Any]]:
    return [
        {
            "root_mode": state.root_mode,
            "node_id": node.node_id,
            "parent_id": node.parent_id,
            "kind": node.kind,
            "mode": "" if node.mode is None else node.mode,
            "shift": "" if node.shift is None else shift_text(node.shift),
            "graph_depth": node.graph_depth,
            "expansion_depth": node.expansion_depth,
            "status": node.status,
            "inverse_word": node.inverse_word,
            "deletion_reason": node.deletion_reason,
        }
        for state in states
        for node in state.nodes.values()
    ]


def tree_edge_rows(states: list[TreeState]) -> list[dict[str, Any]]:
    return [
        {
            "root_mode": state.root_mode,
            "edge_id": edge.edge_id,
            "parent_id": edge.parent_id,
            "child_id": edge.child_id,
            "inverse_step": edge.inverse_step,
            "shift_delta": "" if edge.shift_delta is None else shift_text(edge.shift_delta),
        }
        for state in states
        for edge in state.edges
    ]


def row_csv(certificate: dict[str, Any]) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    for mode in TRACKED:
        spec = lnt_row_spec(K, mode)
        result.append(
            {
                "mode": mode,
                "row_kind": spec["kind"],
                "retarded_mode": spec["retarded_mode"],
                "auxiliary_mode": spec.get("auxiliary_mode", ""),
                "A": fraction_text(A_COEFF),
                "advanced_coefficient": fraction_text(spec["advanced_coefficient"]) if "advanced_coefficient" in spec else "0",
                "target": fraction_text(certificate["principal"][mode]),
                "slack": fraction_text(certificate["slacks"][mode]),
            }
        )
    return result


def manifest_rows(paths: list[Path]) -> list[dict[str, str]]:
    return [
        {"path": repo_rel(path), "sha256": sha256(path)}
        for path in paths
        if path.exists()
    ]


def main() -> int:
    global OUT_DIR, JSON_PATH, LEAN_PATH, SUMMARY_PATH, TREE_NODES_PATH
    global TREE_EDGES_PATH, ROWS_PATH, SLACKS_PATH, K2_DIFF_PATH, MISMATCH_PATH, MANIFEST_PATH
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", type=Path, default=OUT_DIR)
    args = parser.parse_args()
    if args.out_dir != OUT_DIR:
        OUT_DIR = args.out_dir
        JSON_PATH = OUT_DIR / "kl2003_k3_certificate.json"
        LEAN_PATH = OUT_DIR / "KL2003K3CertificateData.lean"
        SUMMARY_PATH = OUT_DIR / "generation_summary.json"
        TREE_NODES_PATH = OUT_DIR / "el_tree_nodes.csv"
        TREE_EDGES_PATH = OUT_DIR / "el_tree_edges.csv"
        ROWS_PATH = OUT_DIR / "l3nt_rows.csv"
        SLACKS_PATH = OUT_DIR / "exact_slacks.csv"
        K2_DIFF_PATH = OUT_DIR / "k2_parametric_regression.csv"
        MISMATCH_PATH = OUT_DIR / "mismatch.csv"
        MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

    started = time.perf_counter()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    tex_source = find_tex_source()
    commit = source_commit()
    created_at = source_commit_time()
    k2_checks, mismatches = k2_regression(tex_source)
    if mismatches:
        raise RuntimeError("K2_PARAMETRIC_REGRESSION_FAIL")

    states = [generate_tree(K, root_mode, expand_d2=True) for root_mode in TRACKED if root_mode % 9 == 8]
    table_metrics = {
        "max_depth": max(max(node.expansion_depth for node in state.nodes.values()) for state in states),
        "max_literals": max(sum(node.kind == "p" and node.status == "terminal" for node in state.nodes.values()) for state in states),
    }
    if table_metrics != {"max_depth": 10, "max_literals": 84}:
        mismatches.append(
            {
                "category": "source_table_regression",
                "check_id": "k3_EL_table1_metrics",
                "actual": json.dumps(table_metrics, sort_keys=True),
                "expected": '{"max_depth": 10, "max_literals": 84}',
                "status": "fail",
            }
        )
        raise RuntimeError("K3_EL_TABLE1_REGRESSION_FAIL")

    certificate = solve_certificate()
    diagnostics = decimal_diagnostics(certificate)
    witnesses = source_witnesses()
    artifact = artifact_json(
        commit=commit,
        created_at=created_at,
        tex_source=tex_source,
        states=states,
        certificate=certificate,
        diagnostics=diagnostics,
        witnesses=witnesses,
    )
    write_json(JSON_PATH, artifact)
    lean_data = emit_lean_data(certificate, states)
    LEAN_PATH.write_text(lean_data, encoding="utf-8")
    LEAN_SOURCE_PATH.write_text(lean_data, encoding="utf-8")

    write_csv(
        TREE_NODES_PATH,
        tree_node_rows(states),
        ["root_mode", "node_id", "parent_id", "kind", "mode", "shift", "graph_depth", "expansion_depth", "status", "inverse_word", "deletion_reason"],
    )
    write_csv(
        TREE_EDGES_PATH,
        tree_edge_rows(states),
        ["root_mode", "edge_id", "parent_id", "child_id", "inverse_step", "shift_delta"],
    )
    write_csv(
        ROWS_PATH,
        row_csv(certificate),
        ["mode", "row_kind", "retarded_mode", "auxiliary_mode", "A", "advanced_coefficient", "target", "slack"],
    )
    write_csv(
        SLACKS_PATH,
        [
            {"slack_id": row["slack_id"], "row_id": row["row_id"], "slack": row["slack"], "strictly_positive": row["strictly_positive"]}
            for row in slacks_json(certificate)
        ],
        ["slack_id", "row_id", "slack", "strictly_positive"],
    )
    write_csv(K2_DIFF_PATH, k2_checks, ["check_id", "actual", "expected", "status"])
    write_csv(MISMATCH_PATH, mismatches, ["category", "check_id", "actual", "expected", "status"])

    all_fractions = [
        LAMBDA,
        A_COEFF,
        B_LOWER,
        D_LOWER,
        *certificate["principal"].values(),
        *certificate["auxiliary"].values(),
        *certificate["slacks"].values(),
    ]
    summary = {
        "run_id": RUN_ID,
        "verdict": "K3_REAL_GENERATOR_DATA_CANDIDATE_PASS",
        "k": K,
        "schema_version": SCHEMA_VERSION,
        "source_commit": commit,
        "source_path": str(tex_source),
        "source_sha256": sha256(tex_source),
        "k2_regression_pass": True,
        "tracked_class_count": len(TRACKED),
        "pre_reduction_class_count": MODULUS,
        "lnt_row_count": len(TRACKED),
        "el_tree_count": len(states),
        "el_tree_total_nodes": sum(len(state.nodes) for state in states),
        "el_tree_total_edges": sum(len(state.edges) for state in states),
        "el_tree_total_kept_literals": sum(sum(node.kind == "p" and node.status == "terminal" for node in state.nodes.values()) for state in states),
        "el_tree_total_deletions": sum(len(state.deletions) for state in states),
        "el_tree_max_depth": table_metrics["max_depth"],
        "el_tree_max_literals": table_metrics["max_literals"],
        "table1_k3_depth_match": table_metrics["max_depth"] == 10,
        "table1_k3_literals_match": table_metrics["max_literals"] == 84,
        "lambda": fraction_text(LAMBDA),
        "B_lower": fraction_text(B_LOWER),
        "D_lower": fraction_text(D_LOWER),
        "min_row_slack": fraction_text(min(certificate["slacks"].values())),
        "min_row_slack_mode": min(certificate["slacks"], key=certificate["slacks"].get),
        "cmax": fraction_text(certificate["cmax"]),
        "rational_numerator_max_digits": max(len(str(abs(value.numerator))) for value in all_fractions),
        "rational_denominator_max_digits": max(len(str(value.denominator)) for value in all_fractions),
        "bounded_denominator": certificate["selected_denominator"],
        "solver": certificate["solver"],
        "float_diagnostics_as_strings": diagnostics,
        "transcendental_endpoint_witnesses": witnesses,
        "generator_runtime_seconds": f"{time.perf_counter() - started:.6f}",
        "json_sha256": sha256(JSON_PATH),
        "lean_data_sha256": sha256(LEAN_PATH),
        "lean_source_data_sha256": sha256(LEAN_SOURCE_PATH),
        "lean_twin_hash_match": sha256(LEAN_PATH) == sha256(LEAN_SOURCE_PATH),
        "generator_sha256": sha256(REPO_ROOT / "scripts" / GENERATOR_VERSION),
        "mismatch_count": len(mismatches),
        "proof_status": "DATA_CANDIDATE_PENDING_LEAN_VERIFIER",
        "classification": [
            "K3_REAL_GENERATOR_EXECUTED",
            "K2_PARAMETRIC_REGRESSION_PASS",
            "K3_EL_TABLE1_METRICS_REPRODUCED",
            "K3_L3NT_EXACT_RATIONAL_CANDIDATE_FOUND",
            "DATA_CANDIDATE_PENDING_LEAN_VERIFIER",
            "NO_K9_GENERATION",
            "NO_K11_GENERATION",
            "NO_HIGH_K_THEOREM_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    manifest_inputs = [
        JSON_PATH,
        LEAN_PATH,
        LEAN_SOURCE_PATH,
        SUMMARY_PATH,
        TREE_NODES_PATH,
        TREE_EDGES_PATH,
        ROWS_PATH,
        SLACKS_PATH,
        K2_DIFF_PATH,
        MISMATCH_PATH,
        REPO_ROOT / "scripts" / GENERATOR_VERSION,
    ]
    write_csv(MANIFEST_PATH, manifest_rows(manifest_inputs), ["path", "sha256"])
    print(summary["verdict"])
    print(json.dumps({key: summary[key] for key in ["lnt_row_count", "el_tree_total_nodes", "el_tree_total_kept_literals", "el_tree_total_deletions", "el_tree_max_depth", "el_tree_max_literals", "min_row_slack", "cmax"]}, sort_keys=True))
    return 0


if __name__ == "__main__":
    sys.exit(main())
