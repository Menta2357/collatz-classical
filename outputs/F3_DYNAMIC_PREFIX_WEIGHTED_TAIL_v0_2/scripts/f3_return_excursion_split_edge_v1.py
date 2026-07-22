#!/usr/bin/env python3
"""F3 return-excursion split-edge v1.

Builds the split-edge operator that represents the advanced missing 3-adic
digit by exact multiplicity over the three depth-(d0+1) lifts.  It freezes a
core-supported rational vector only if the rationalized core inequality
re-verifies.  It does not open holdout.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from collections import Counter
from pathlib import Path
from typing import Any

import numpy as np


BASE = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_DIR = BASE / "results/F3_RETURN_EXCURSION_SPLIT_EDGE_v1"
D0 = 5
RHO_STAR = 9 / 5
DELTA = 0.01
D_DEFAULT = 1_000_000
LAMBDA_11_OFFICIAL = "71689/40000"


def parity_value(n: int) -> str:
    return "odd" if n % 2 else "even"


def nu2_bucket(n: int) -> int:
    if n % 2:
        return 0
    if n % 4:
        return 1
    return 2


def states_at_depth(d: int) -> list[tuple[int, int, str, int]]:
    return [
        (d, r, "odd" if b == 0 else "even", b)
        for r in range(3**d)
        for b in (0, 1, 2)
    ]


def state_label(state: tuple[int, int, str, int]) -> str:
    d, r, p, b = state
    return f"d{d}:r{r}:p{p}:b{b}"


def representative(state: tuple[int, int, str, int], lift: int = 0) -> int:
    d, r, p, b = state
    modulus = 3**d
    n = r + lift * modulus
    step = 3 * modulus
    while n <= 0 or parity_value(n) != p or nu2_bucket(n) != b:
        n += step
    return n


def retarded_state(state: tuple[int, int, str, int]) -> tuple[int, int, str, int]:
    d, r, _p, _b = state
    return (d, (4 * r) % (3**d), "even", 2)


def target_state_from_value(n: int, d0: int = D0) -> tuple[int, int, str, int]:
    return (d0, n % (3**d0), parity_value(n), nu2_bucket(n))


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def sccs(n: int, edges: list[tuple[int, int]]) -> list[list[int]]:
    adj = [[] for _ in range(n)]
    radj = [[] for _ in range(n)]
    for source, target in edges:
        adj[source].append(target)
        radj[target].append(source)
    seen = [False] * n
    order: list[int] = []
    for start in range(n):
        if seen[start]:
            continue
        stack = [(start, 0)]
        seen[start] = True
        while stack:
            node, index = stack[-1]
            if index < len(adj[node]):
                nxt = adj[node][index]
                stack[-1] = (node, index + 1)
                if not seen[nxt]:
                    seen[nxt] = True
                    stack.append((nxt, 0))
            else:
                order.append(node)
                stack.pop()
    comp = [-1] * n
    comps: list[list[int]] = []
    for start in reversed(order):
        if comp[start] >= 0:
            continue
        comp_id = len(comps)
        comps.append([])
        comp[start] = comp_id
        stack = [start]
        while stack:
            node = stack.pop()
            comps[comp_id].append(node)
            for nxt in radj[node]:
                if comp[nxt] < 0:
                    comp[nxt] = comp_id
                    stack.append(nxt)
    return comps


def spectral_radius(matrix: np.ndarray) -> float:
    if matrix.size == 0:
        return 0.0
    return float(np.max(np.abs(np.linalg.eigvals(matrix))))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--D", type=int, default=D_DEFAULT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    D = args.D
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    states = states_at_depth(D0)
    state_index = {state: index for index, state in enumerate(states)}
    alpha = math.log(3, 2)
    retarded_weight = RHO_STAR ** (-2)
    advanced_base_weight = RHO_STAR ** (alpha - 1)
    direct_weight = advanced_base_weight / 3
    parity_lift_weight = advanced_base_weight * (RHO_STAR ** (-1)) / 3
    sterile_tail_weight = advanced_base_weight / 3

    edge_rows: list[dict[str, Any]] = []
    tail_rows: list[dict[str, Any]] = []
    graph_edges: list[tuple[int, int]] = []
    matrix = np.zeros((len(states), len(states)), dtype=float)
    channel_counts: Counter[str] = Counter()
    split_counts_by_source: Counter[str] = Counter()

    def add_edge(source: tuple[int, int, str, int], target: tuple[int, int, str, int],
                 channel: str, weight: float, multiplicity: str, deep_lift: int | str) -> None:
        source_id = state_index[source]
        target_id = state_index[target]
        matrix[source_id, target_id] += weight
        graph_edges.append((source_id, target_id))
        channel_counts[channel] += 1
        edge_rows.append(
            {
                "source_id": source_id,
                "source": state_label(source),
                "deep_lift": deep_lift,
                "channel": channel,
                "target_id": target_id,
                "target": state_label(target),
                "weight_decimal": f"{weight:.18e}",
                "multiplicity": multiplicity,
            }
        )

    for source in states:
        add_edge(
            source,
            retarded_state(source),
            "retarded",
            retarded_weight,
            "1",
            "",
        )
        if source[1] % 3 != 2:
            continue
        seen_channels: Counter[str] = Counter()
        for deep_lift in range(3):
            a = representative(source, deep_lift)
            c = (2 * a - 1) // 3
            if c % 3 == 2:
                add_edge(
                    source,
                    target_state_from_value(c),
                    "advanced_direct_c2",
                    direct_weight,
                    "1/3",
                    deep_lift,
                )
                seen_channels["advanced_direct_c2"] += 1
            elif c % 3 == 1:
                add_edge(
                    source,
                    target_state_from_value(2 * c),
                    "advanced_parity_lift_c1",
                    parity_lift_weight,
                    "1/3",
                    deep_lift,
                )
                seen_channels["advanced_parity_lift_c1"] += 1
            else:
                source_id = state_index[source]
                channel_counts["advanced_sterile_tail_c0"] += 1
                seen_channels["advanced_sterile_tail_c0"] += 1
                tail_rows.append(
                    {
                        "source_id": source_id,
                        "source": state_label(source),
                        "deep_lift": deep_lift,
                        "channel": "advanced_sterile_tail_c0",
                        "tail_weight_decimal": f"{sterile_tail_weight:.18e}",
                        "multiplicity": "1/3",
                        "tail_name": "Q_boundary_or_sterile",
                    }
                )
        split_counts_by_source["|".join(f"{k}:{seen_channels[k]}" for k in sorted(seen_channels))] += 1

    global_rho = spectral_radius(matrix)
    comps = sccs(len(states), graph_edges)
    comp_rows: list[dict[str, Any]] = []
    best_index = -1
    best_rho = -1.0
    for comp_id, nodes in enumerate(comps):
        idx = np.array(sorted(nodes), dtype=int)
        sub = matrix[np.ix_(idx, idx)]
        rho = spectral_radius(sub)
        if rho > best_rho:
            best_index = comp_id
            best_rho = rho
        node_set = set(nodes)
        is_sink = all((s not in node_set or t in node_set) for s, t in graph_edges)
        comp_rows.append(
            {
                "component_id": comp_id,
                "size": len(nodes),
                "spectral_radius_decimal": f"{rho:.18e}",
                "is_sink": "yes" if is_sink else "no",
            }
        )

    core_ids = sorted(comps[best_index])
    core_matrix = matrix[np.ix_(core_ids, core_ids)]
    core_rho = spectral_radius(core_matrix)
    values, vectors = np.linalg.eig(core_matrix.T)
    eig_index = int(np.argmax(values.real))
    left_eigenvalue = float(values[eig_index].real)
    real_vector = vectors[:, eig_index].real
    if real_vector.sum() < 0:
        real_vector = -real_vector
    real_vector[np.abs(real_vector) < 1e-14] = 0
    real_vector = np.maximum(real_vector, 0)
    real_vector = real_vector / float(real_vector.sum())
    integer_weights = np.maximum(1, np.floor(real_vector * D).astype(int))
    rational_vector = integer_weights.astype(float) / float(D)
    lhs = rational_vector @ core_matrix
    rhs = (1 + DELTA) * rational_vector
    ratios = lhs / rhs
    bad_indices = np.nonzero(lhs + 1e-15 < rhs)[0]

    core_rows: list[dict[str, Any]] = []
    rmod9_counts: Counter[int] = Counter()
    bucket_counts: Counter[int] = Counter()
    for local_id, state_id in enumerate(core_ids):
        state = states[state_id]
        rmod9_counts[state[1] % 9] += 1
        bucket_counts[state[3]] += 1
        core_rows.append(
            {
                "core_local_id": local_id,
                "state_id": state_id,
                "state": state_label(state),
                "residue_mod_9": state[1] % 9,
                "bucket": state[3],
                "integer_weight_over_D": int(integer_weights[local_id]),
                "rational_weight_decimal": f"{rational_vector[local_id]:.18e}",
                "lhs_wM_decimal": f"{lhs[local_id]:.18e}",
                "rhs_1_plus_delta_w_decimal": f"{rhs[local_id]:.18e}",
                "ratio_lhs_over_rhs": f"{ratios[local_id]:.18e}",
                "passes": "yes" if lhs[local_id] + 1e-15 >= rhs[local_id] else "no",
            }
        )

    local_verdict = (
        "SPLIT_EDGE_FREEZE_PASS_HOLDOUT_READY"
        if len(bad_indices) == 0 and len(core_ids) > 0
        else "STOP_SPLIT_EDGE_REVERIFY_FAILED"
    )

    edge_path = output_dir / "split_edges.csv"
    tail_path = output_dir / "split_tail_Q.csv"
    components_path = output_dir / "scc_components.csv"
    frozen_path = output_dir / "frozen_w_split_core.csv"
    failures_path = output_dir / "core_reverify_failures.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"
    write_csv(edge_path, edge_rows, ["source_id", "source", "deep_lift", "channel", "target_id", "target", "weight_decimal", "multiplicity"])
    write_csv(tail_path, tail_rows, ["source_id", "source", "deep_lift", "channel", "tail_weight_decimal", "multiplicity", "tail_name"])
    write_csv(components_path, comp_rows, ["component_id", "size", "spectral_radius_decimal", "is_sink"])
    write_csv(frozen_path, core_rows, ["core_local_id", "state_id", "state", "residue_mod_9", "bucket", "integer_weight_over_D", "rational_weight_decimal", "lhs_wM_decimal", "rhs_1_plus_delta_w_decimal", "ratio_lhs_over_rhs", "passes"])
    write_csv(failures_path, [core_rows[i] for i in bad_indices], ["core_local_id", "state_id", "state", "residue_mod_9", "bucket", "integer_weight_over_D", "rational_weight_decimal", "lhs_wM_decimal", "rhs_1_plus_delta_w_decimal", "ratio_lhs_over_rhs", "passes"])

    summary = {
        "d0": D0,
        "rho_star": "9/5",
        "lambda_11_official": LAMBDA_11_OFFICIAL,
        "D": D,
        "delta": "1/100",
        "state_count": len(states),
        "edge_count": len(edge_rows),
        "tail_row_count": len(tail_rows),
        "channel_counts": dict(sorted(channel_counts.items())),
        "split_counts_by_source": dict(sorted(split_counts_by_source.items())),
        "global_scc_count": len(comps),
        "core_component_id": best_index,
        "core_state_count": len(core_ids),
        "excluded_state_count": len(states) - len(core_ids),
        "global_spectral_radius_decimal": global_rho,
        "core_spectral_radius_decimal": core_rho,
        "core_left_eigenvalue_decimal": left_eigenvalue,
        "core_bad_state_count": int(len(bad_indices)),
        "core_min_ratio_lhs_over_rhs": float(np.min(ratios)),
        "core_reverify_pass": len(bad_indices) == 0,
        "core_residue_mod_9_counts": {str(k): v for k, v in sorted(rmod9_counts.items())},
        "core_bucket_counts": {str(k): v for k, v in sorted(bucket_counts.items())},
        "frozen_w_split_core_sha256": file_sha256(frozen_path),
        "holdout_consumed": False,
        "next_holdout_range_predeclared_if_freeze_accepted": [41473, 82945],
        "burned_ranges": [[20737, 41473]],
        "local_verdict": local_verdict,
        "non_claims": {
            "no_holdout_result": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
            "no_lean_operator": True,
        },
    }
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [
            {"path": path.name, "sha256": file_sha256(path)}
            for path in (edge_path, tail_path, components_path, frozen_path, failures_path, summary_path)
        ],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
