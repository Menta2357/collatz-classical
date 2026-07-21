#!/usr/bin/env python3
"""F3 return-excursion support repair v1.

Core restriction for the reducible v2 return-excursion operator.  This freezes
a candidate core-supported rational vector only if it re-verifies before any
holdout is opened.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter
from pathlib import Path
from typing import Any

import numpy as np


BASE = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_DIR = BASE / "results/F3_RETURN_EXCURSION_SUPPORT_REPAIR_v1"
V2_DIR = BASE / "results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2"
D_DEFAULT = 1_000_000
DELTA = 0.01
TOL = 1e-10


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


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


def parse_state(label: str) -> tuple[int, int, str, int]:
    parts = label.split(":")
    return (
        int(parts[0][1:]),
        int(parts[1][1:]),
        parts[2][1:],
        int(parts[3][1:]),
    )


def sccs(n: int, graph_edges: list[tuple[int, int]]) -> list[list[int]]:
    adj = [[] for _ in range(n)]
    radj = [[] for _ in range(n)]
    for source, target in graph_edges:
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

    v2_summary = json.loads((V2_DIR / "summary.json").read_text())
    edge_rows = read_csv(V2_DIR / "return_excursion_edges.csv")
    n = int(v2_summary["state_count"])
    matrix = np.zeros((n, n), dtype=float)
    labels: dict[int, str] = {}
    graph_edges: list[tuple[int, int]] = []
    for row in edge_rows:
        source = int(row["source_id"])
        target = int(row["target_id"])
        weight = float(row["weight_decimal"])
        matrix[source, target] += weight
        labels[source] = row["source"]
        labels[target] = row["target"]
        graph_edges.append((source, target))

    global_rho = spectral_radius(matrix)
    comps = sccs(n, graph_edges)
    comp_rows: list[dict[str, Any]] = []
    best_index = -1
    best_rho = -1.0
    for comp_id, nodes in enumerate(comps):
        core_idx = np.array(sorted(nodes), dtype=int)
        sub = matrix[np.ix_(core_idx, core_idx)]
        rho = spectral_radius(sub)
        is_sink = True
        node_set = set(nodes)
        for source, target in graph_edges:
            if source in node_set and target not in node_set:
                is_sink = False
                break
        comp_rows.append(
            {
                "component_id": comp_id,
                "size": len(nodes),
                "spectral_radius_decimal": f"{rho:.18e}",
                "is_sink": "yes" if is_sink else "no",
            }
        )
        if rho > best_rho:
            best_index = comp_id
            best_rho = rho

    core_ids = sorted(comps[best_index])
    core_pos = {state_id: index for index, state_id in enumerate(core_ids)}
    core_matrix = matrix[np.ix_(core_ids, core_ids)]
    core_rho = spectral_radius(core_matrix)
    values, vectors = np.linalg.eig(core_matrix.T)
    eig_index = int(np.argmax(values.real))
    left_eigenvalue = float(values[eig_index].real)
    real_vector = vectors[:, eig_index].real
    if real_vector.sum() < 0:
        real_vector = -real_vector
    real_vector[np.abs(real_vector) < 1e-14] = 0.0
    real_vector = np.maximum(real_vector, 0.0)
    real_vector = real_vector / float(real_vector.sum())

    integer_weights = np.maximum(1, np.floor(real_vector * D).astype(int))
    rational_vector = integer_weights.astype(float) / float(D)
    lhs = rational_vector @ core_matrix
    rhs = (1.0 + DELTA) * rational_vector
    ratios = lhs / rhs
    bad_indices = np.nonzero(lhs + 1e-15 < rhs)[0]
    reverify_pass = len(bad_indices) == 0

    core_state_rows: list[dict[str, Any]] = []
    rmod9_counts: Counter[int] = Counter()
    bucket_counts: Counter[int] = Counter()
    parity_counts: Counter[str] = Counter()
    for local_id, state_id in enumerate(core_ids):
        label = labels[state_id]
        d, r, parity, bucket = parse_state(label)
        rmod9_counts[r % 9] += 1
        bucket_counts[bucket] += 1
        parity_counts[parity] += 1
        core_state_rows.append(
            {
                "core_local_id": local_id,
                "state_id": state_id,
                "state": label,
                "residue_mod_9": r % 9,
                "parity": parity,
                "bucket": bucket,
                "integer_weight_over_D": int(integer_weights[local_id]),
                "rational_weight_decimal": f"{rational_vector[local_id]:.18e}",
                "lhs_wM_decimal": f"{lhs[local_id]:.18e}",
                "rhs_1_plus_delta_w_decimal": f"{rhs[local_id]:.18e}",
                "ratio_lhs_over_rhs": f"{ratios[local_id]:.18e}",
                "passes": "yes" if lhs[local_id] + 1e-15 >= rhs[local_id] else "no",
            }
        )

    failure_rows = [core_state_rows[i] for i in bad_indices]
    core_checks_pass = (
        len(core_ids) == 135
        and abs(core_rho - global_rho) <= TOL
        and np.min(real_vector) > 0
    )
    if not core_checks_pass:
        local_verdict = "STOP_SUPPORT_REPAIR_CORE_CHECK_FAILED"
    elif not reverify_pass:
        local_verdict = "STOP_CORE_RATIONAL_REVERIFY_FAILED"
    else:
        local_verdict = "CORE_RESTRICTION_FREEZE_PASS_HOLDOUT_READY"

    frozen_w_path = output_dir / "frozen_w_core.csv"
    core_states_path = output_dir / "core_states.csv"
    components_path = output_dir / "scc_components.csv"
    failures_path = output_dir / "core_reverify_failures.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"

    write_csv(
        frozen_w_path,
        core_state_rows,
        [
            "core_local_id",
            "state_id",
            "state",
            "residue_mod_9",
            "parity",
            "bucket",
            "integer_weight_over_D",
            "rational_weight_decimal",
            "lhs_wM_decimal",
            "rhs_1_plus_delta_w_decimal",
            "ratio_lhs_over_rhs",
            "passes",
        ],
    )
    write_csv(
        core_states_path,
        [
            {
                "core_local_id": row["core_local_id"],
                "state_id": row["state_id"],
                "state": row["state"],
                "residue_mod_9": row["residue_mod_9"],
                "parity": row["parity"],
                "bucket": row["bucket"],
            }
            for row in core_state_rows
        ],
        ["core_local_id", "state_id", "state", "residue_mod_9", "parity", "bucket"],
    )
    write_csv(components_path, comp_rows, ["component_id", "size", "spectral_radius_decimal", "is_sink"])
    write_csv(
        failures_path,
        failure_rows,
        [
            "core_local_id",
            "state_id",
            "state",
            "residue_mod_9",
            "parity",
            "bucket",
            "integer_weight_over_D",
            "rational_weight_decimal",
            "lhs_wM_decimal",
            "rhs_1_plus_delta_w_decimal",
            "ratio_lhs_over_rhs",
            "passes",
        ],
    )

    summary = {
        "D": D,
        "delta": "1/100",
        "d0": v2_summary["d0"],
        "rho_star": v2_summary["rho_star"],
        "lambda_11_official": v2_summary["lambda_11_official"],
        "global_state_count": n,
        "global_scc_count": len(comps),
        "core_component_id": best_index,
        "core_state_count": len(core_ids),
        "excluded_state_count": n - len(core_ids),
        "global_spectral_radius_decimal": global_rho,
        "core_spectral_radius_decimal": core_rho,
        "core_left_eigenvalue_decimal": left_eigenvalue,
        "core_min_real_weight_decimal": float(np.min(real_vector)),
        "core_max_real_weight_decimal": float(np.max(real_vector)),
        "core_integer_weight_sum": int(integer_weights.sum()),
        "core_min_ratio_lhs_over_rhs": float(np.min(ratios)),
        "core_bad_state_count": int(len(bad_indices)),
        "core_reverify_pass": bool(reverify_pass),
        "core_checks_pass": bool(core_checks_pass),
        "core_residue_mod_9_counts": {str(k): v for k, v in sorted(rmod9_counts.items())},
        "core_bucket_counts": {str(k): v for k, v in sorted(bucket_counts.items())},
        "core_parity_counts": dict(sorted(parity_counts.items())),
        "holdout_range_predeclared": [20737, 41473],
        "holdout_consumed": False,
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
    if not reverify_pass:
        summary["non_claims"]["no_frozen_w"] = True
    else:
        summary["frozen_w_sha256"] = file_sha256(frozen_w_path)

    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [
            {"path": path.name, "sha256": file_sha256(path)}
            for path in (frozen_w_path, core_states_path, components_path, failures_path, summary_path)
        ],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
