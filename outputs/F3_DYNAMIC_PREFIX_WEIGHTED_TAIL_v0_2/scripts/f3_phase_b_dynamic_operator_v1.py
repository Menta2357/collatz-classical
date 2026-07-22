#!/usr/bin/env python3
"""Rule-derived F3 PHASE_B dynamic operator v1.

This script builds the first finite operator from arithmetic rules only.  It
does not use pi-star data to define matrix entries.  The output is a sanity
gate: if the naive incidence operator is too weak, the next object must include
scale-aware window factors before any rho claim is possible.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import defaultdict
from fractions import Fraction
from pathlib import Path


K_DEFAULT = 5
LAMBDA_11 = Fraction(8961, 5000)  # 1.7922
DEFAULT_OUTPUT_DIR = (
    Path(__file__).resolve().parents[1]
    / "results/F3_PHASE_B_DYNAMIC_OPERATOR_v1"
)


def parity_value(n: int) -> str:
    return "odd" if n % 2 else "even"


def nu2_bucket(n: int) -> int:
    if n % 2:
        return 0
    if n % 4:
        return 1
    return 2


def state_label(state: tuple[int, int, str, int]) -> str:
    d, r, p, b = state
    return f"d{d}:r{r}:p{p}:b{b}"


def all_states(K: int) -> list[tuple[int, int, str, int]]:
    states: list[tuple[int, int, str, int]] = []
    for d in range(1, K + 1):
        for r in range(3**d):
            for b in (0, 1, 2):
                p = "odd" if b == 0 else "even"
                states.append((d, r, p, b))
    return states


def representative(state: tuple[int, int, str, int], lift: int = 0) -> int:
    d, r, p, b = state
    modulus = 3**d
    n = r + lift * modulus
    step = 3 * modulus
    while parity_value(n) != p or nu2_bucket(n) != b or n <= 0:
        n += step
    return n


def retarded_state(state: tuple[int, int, str, int]) -> tuple[int, int, str, int]:
    d, r, _p, _b = state
    return (d, (4 * r) % (3**d), "even", 2)


def advanced_destinations(
    state: tuple[int, int, str, int],
) -> tuple[str, list[tuple[tuple[int, int, str, int], int]]]:
    d, r, _p, _b = state
    if r % 3 != 2:
        return ("NO_ADVANCED_BRANCH", [])
    if d == 1:
        return ("TAIL_DEPTH_ZERO", [])

    child_depth = d - 1
    child_modulus = 3**child_depth
    child_residue = ((2 * r - 1) // 3) % child_modulus
    counts: defaultdict[tuple[int, int, str, int], int] = defaultdict(int)

    # Three lifts at the parent depth are enough to expose the possible child
    # parity/nu2 buckets after division by 3.
    for lift in range(3):
        a = representative(state, lift)
        c = (2 * a - 1) // 3
        child = (
            child_depth,
            child_residue,
            parity_value(c),
            nu2_bucket(c),
        )
        counts[child] += 1

    return ("VISIBLE", sorted(counts.items(), key=lambda item: state_label(item[0])))


def write_csv(path: Path, rows: list[dict[str, object]], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--K", type=int, default=K_DEFAULT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    K = args.K
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    states = all_states(K)
    state_index = {state: idx for idx, state in enumerate(states)}
    edge_rows: list[dict[str, object]] = []
    state_rows: list[dict[str, object]] = []
    column_sums: defaultdict[int, Fraction] = defaultdict(Fraction)
    tail_edges = 0
    visible_advanced_edges = 0

    for source in states:
        source_id = state_index[source]
        source_label = state_label(source)
        r_state = retarded_state(source)
        column_sums[source_id] += Fraction(1, 1)
        edge_rows.append(
            {
                "source_id": source_id,
                "source": source_label,
                "branch": "retarded",
                "target": state_label(r_state),
                "target_id": state_index[r_state],
                "multiplicity_fraction": "1",
                "route": "VISIBLE",
                "rule_derived": "yes",
            }
        )

        route, advanced = advanced_destinations(source)
        if route == "VISIBLE":
            visible_advanced_edges += 1
            for target, count in advanced:
                multiplicity = Fraction(count, 3)
                column_sums[source_id] += multiplicity
                edge_rows.append(
                    {
                        "source_id": source_id,
                        "source": source_label,
                        "branch": "advanced",
                        "target": state_label(target),
                        "target_id": state_index[target],
                        "multiplicity_fraction": f"{multiplicity.numerator}/{multiplicity.denominator}",
                        "route": "VISIBLE",
                        "rule_derived": "yes",
                    }
                )
        elif route == "TAIL_DEPTH_ZERO":
            tail_edges += 1
            edge_rows.append(
                {
                    "source_id": source_id,
                    "source": source_label,
                    "branch": "advanced",
                    "target": "Q_K:DEPTH_ZERO",
                    "target_id": "",
                    "multiplicity_fraction": "1",
                    "route": route,
                    "rule_derived": "yes",
                }
            )

        state_rows.append(
            {
                "state_id": source_id,
                "state": source_label,
                "depth": source[0],
                "residue": source[1],
                "parity": source[2],
                "nu2_bucket": source[3],
                "has_advanced_branch": "yes" if source[1] % 3 == 2 else "no",
                "naive_visible_column_sum": f"{column_sums[source_id].numerator}/{column_sums[source_id].denominator}",
            }
        )

    # The retarded submatrix is a deterministic map on each depth block.  The
    # advanced edges always lower depth or go to tail.  Therefore the visible
    # naive operator is block lower triangular with permutation diagonal
    # blocks, so its spectral radius is exactly 1.
    spectral_radius = Fraction(1, 1)
    max_visible_column_sum = max(column_sums.values())
    min_visible_column_sum = min(column_sums.values())
    feasible_rho_naive = spectral_radius > LAMBDA_11

    summary = {
        "K": K,
        "state_count": len(states),
        "edge_count": len(edge_rows),
        "tail_edges": tail_edges,
        "visible_advanced_source_states": visible_advanced_edges,
        "operator": "M_naive_rule_derived_incidence",
        "spectral_radius_fraction": f"{spectral_radius.numerator}/{spectral_radius.denominator}",
        "spectral_radius_decimal": float(spectral_radius),
        "lambda_11_fraction": f"{LAMBDA_11.numerator}/{LAMBDA_11.denominator}",
        "lambda_11_decimal": float(LAMBDA_11),
        "rho_greater_than_lambda_11": feasible_rho_naive,
        "min_visible_column_sum": f"{min_visible_column_sum.numerator}/{min_visible_column_sum.denominator}",
        "max_visible_column_sum": f"{max_visible_column_sum.numerator}/{max_visible_column_sum.denominator}",
        "local_verdict": (
            "STOP_NAIVE_OPERATOR_TOO_WEAK_SCALE_AWARE_OPERATOR_REQUIRED"
            if not feasible_rho_naive
            else "UNEXPECTED_NAIVE_OPERATOR_PASS_REVIEW_REQUIRED"
        ),
        "obligations_status": {
            "O1_rule_derived_M": "PASS",
            "O2_weights_frozen": "NOT_APPLICABLE_NO_WEIGHTS_SOLVED",
            "O3_tail_same_inequality": "PARTIAL_TAIL_EDGES_LISTED",
            "O4_y_uniformity": "FAIL_NOT_MODELED",
            "O5_memberwise_entry_inequality": "FAIL_NOT_PROVED",
        },
        "non_claims": {
            "no_lean": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
        },
    }

    states_path = output_dir / "states.csv"
    edges_path = output_dir / "rule_edges.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"

    write_csv(
        states_path,
        state_rows,
        [
            "state_id",
            "state",
            "depth",
            "residue",
            "parity",
            "nu2_bucket",
            "has_advanced_branch",
            "naive_visible_column_sum",
        ],
    )
    write_csv(
        edges_path,
        edge_rows,
        [
            "source_id",
            "source",
            "branch",
            "target",
            "target_id",
            "multiplicity_fraction",
            "route",
            "rule_derived",
        ],
    )
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    manifest_rows = [
        {"path": path.name, "sha256": file_sha256(path)}
        for path in (states_path, edges_path, summary_path)
    ]
    write_csv(manifest_path, manifest_rows, ["path", "sha256"])
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
