#!/usr/bin/env python3
"""F3 return-excursion freeze-w attempt v1.

This script implements the predeclared left-Perron + rational floor rule and
stops before holdout unless the rationalized vector re-verifies.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from pathlib import Path
from typing import Any

import numpy as np


BASE = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT_DIR = BASE / "results/F3_RETURN_EXCURSION_FREEZE_W_v1"
V2_DIR = BASE / "results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2"
D_DEFAULT = 1_000_000
DELTA_NUM = 1
DELTA_DEN = 100


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


def strongly_connected_components(n: int, edges: list[tuple[int, int]]) -> dict[str, Any]:
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

    has_out = [False] * len(comps)
    for source, target in edges:
        if comp[source] != comp[target]:
            has_out[comp[source]] = True
    sink_sizes = sorted((len(comps[i]) for i, out in enumerate(has_out) if not out), reverse=True)
    return {
        "scc_count": len(comps),
        "largest_scc": max(len(c) for c in comps),
        "sink_scc_count": len(sink_sizes),
        "sink_scc_sizes_desc": sink_sizes,
    }


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
    graph_edges: list[tuple[int, int]] = []
    for row in edge_rows:
        source = int(row["source_id"])
        target = int(row["target_id"])
        weight = float(row["weight_decimal"])
        matrix[source, target] += weight
        graph_edges.append((source, target))

    values, vectors = np.linalg.eig(matrix.T)
    index = int(np.argmax(values.real))
    eigenvalue = float(values[index].real)
    real_vector = vectors[:, index].real
    if real_vector.sum() < 0:
        real_vector = -real_vector
    real_vector[np.abs(real_vector) < 1e-14] = 0.0
    real_vector = np.maximum(real_vector, 0.0)
    if float(real_vector.sum()) == 0.0:
        raise SystemExit("left Perron vector collapsed to zero")
    real_vector = real_vector / float(real_vector.sum())

    integer_weights = np.maximum(1, np.floor(real_vector * D).astype(int))
    rational_vector = integer_weights.astype(float) / float(D)
    lhs = rational_vector @ matrix
    rhs = (1.0 + DELTA_NUM / DELTA_DEN) * rational_vector
    ratios = np.divide(lhs, rhs, out=np.zeros_like(lhs), where=rhs != 0)
    bad_indices = np.nonzero(lhs + 1e-15 < rhs)[0]
    zero_real_support = int(np.sum(real_vector == 0.0))
    scc = strongly_connected_components(n, graph_edges)

    candidate_rows = [
        {
            "state_id": i,
            "real_weight_decimal": f"{real_vector[i]:.18e}",
            "integer_weight_over_D": int(integer_weights[i]),
            "rational_weight_decimal": f"{rational_vector[i]:.18e}",
            "lhs_wM_decimal": f"{lhs[i]:.18e}",
            "rhs_1_plus_delta_w_decimal": f"{rhs[i]:.18e}",
            "ratio_lhs_over_rhs": f"{ratios[i]:.18e}",
            "passes": "yes" if lhs[i] + 1e-15 >= rhs[i] else "no",
        }
        for i in range(n)
    ]
    failure_rows = [candidate_rows[i] for i in bad_indices]

    reverify_pass = len(bad_indices) == 0
    if reverify_pass:
        local_verdict = "FREEZE_W_PASS_READY_FOR_HOLDOUT"
    elif zero_real_support:
        local_verdict = "STOP_FREEZE_W_SUPPORT_REDUCIBLE"
    else:
        local_verdict = "STOP_FREEZE_W_REVERIFY_FAILED"

    summary = {
        "D": D,
        "delta": "1/100",
        "rho_star": v2_summary["rho_star"],
        "lambda_11_official": v2_summary["lambda_11_official"],
        "d0": v2_summary["d0"],
        "state_count": n,
        "matrix_edge_count": len(edge_rows),
        "left_perron_eigenvalue_decimal": eigenvalue,
        "left_perron_zero_real_support_count": zero_real_support,
        "integer_weight_sum": int(integer_weights.sum()),
        "rational_min_ratio_lhs_over_rhs": float(ratios.min()),
        "rational_bad_state_count": int(len(bad_indices)),
        "rational_reverify_pass": reverify_pass,
        "graph_scc": scc,
        "holdout_range_predeclared": [20737, 41473],
        "holdout_consumed": False,
        "local_verdict": local_verdict,
        "non_claims": {
            "no_holdout_result": True,
            "no_frozen_w": not reverify_pass,
            "no_lean_operator": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
        },
    }

    candidate_path = output_dir / "candidate_w_not_frozen.csv"
    failures_path = output_dir / "freeze_reverify_failures.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"
    write_csv(
        candidate_path,
        candidate_rows,
        [
            "state_id",
            "real_weight_decimal",
            "integer_weight_over_D",
            "rational_weight_decimal",
            "lhs_wM_decimal",
            "rhs_1_plus_delta_w_decimal",
            "ratio_lhs_over_rhs",
            "passes",
        ],
    )
    write_csv(
        failures_path,
        failure_rows,
        [
            "state_id",
            "real_weight_decimal",
            "integer_weight_over_D",
            "rational_weight_decimal",
            "lhs_wM_decimal",
            "rhs_1_plus_delta_w_decimal",
            "ratio_lhs_over_rhs",
            "passes",
        ],
    )
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [
            {"path": path.name, "sha256": file_sha256(path)}
            for path in (candidate_path, failures_path, summary_path)
        ],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
