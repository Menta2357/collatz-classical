#!/usr/bin/env python3
"""F3 PHASE_B scale-aware operator orientation audit v1.

This script is deliberately diagnostic.  It attaches the PHASE_B scale weights
to the rule-derived edges, but it does not claim a rho certificate.  Its main
job is to expose whether the finite-depth parent->child operator has the right
orientation for a Perron lower-bound certificate.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from collections import defaultdict
from fractions import Fraction
from pathlib import Path
from typing import Any


K_DEFAULT = 5
RHO_STAR = Fraction(9, 5)
LAMBDA_11_OFFICIAL = Fraction(71689, 40000)
DEFAULT_OUTPUT_DIR = (
    Path(__file__).resolve().parents[1]
    / "results/F3_PHASE_B_SCALE_AWARE_OPERATOR_v1"
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
                states.append((d, r, "odd" if b == 0 else "even", b))
    return states


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


def advanced_destinations(
    state: tuple[int, int, str, int],
) -> tuple[str, list[tuple[tuple[int, int, str, int], Fraction]]]:
    d, r, _p, _b = state
    if r % 3 != 2:
        return ("NO_ADVANCED_BRANCH", [])
    if d == 1:
        return ("TAIL_DEPTH_ZERO", [])

    child_depth = d - 1
    child_modulus = 3**child_depth
    child_residue = ((2 * r - 1) // 3) % child_modulus
    counts: defaultdict[tuple[int, int, str, int], int] = defaultdict(int)
    for lift in range(3):
        a = representative(state, lift)
        c = (2 * a - 1) // 3
        child = (child_depth, child_residue, parity_value(c), nu2_bucket(c))
        counts[child] += 1
    return (
        "VISIBLE",
        sorted(
            [(target, Fraction(count, 3)) for target, count in counts.items()],
            key=lambda item: state_label(item[0]),
        ),
    )


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--K", type=int, default=K_DEFAULT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    states = all_states(args.K)
    state_index = {state: idx for idx, state in enumerate(states)}

    retarded_weight = Fraction(RHO_STAR.denominator**2, RHO_STAR.numerator**2)
    alpha = math.log(3, 2)
    advanced_weight_float = float(RHO_STAR) ** (alpha - 2.0)
    critical_sum_float = float(retarded_weight) + advanced_weight_float
    lambda_sum_float = float(LAMBDA_11_OFFICIAL) ** (-2.0) + float(
        LAMBDA_11_OFFICIAL
    ) ** (alpha - 2.0)

    edge_rows: list[dict[str, Any]] = []
    state_rows: list[dict[str, Any]] = []
    column_sum_float: defaultdict[int, float] = defaultdict(float)
    has_same_depth_retarded_cycle = False
    visible_advanced_sources = 0
    tail_edges = 0

    for source in states:
        source_id = state_index[source]
        source_label = state_label(source)
        r_state = retarded_state(source)
        if r_state[0] == source[0]:
            has_same_depth_retarded_cycle = True
        column_sum_float[source_id] += float(retarded_weight)
        edge_rows.append(
            {
                "source_id": source_id,
                "source": source_label,
                "branch": "retarded",
                "target_id": state_index[r_state],
                "target": state_label(r_state),
                "route": "VISIBLE",
                "multiplicity": "1",
                "scale_weight": f"{retarded_weight.numerator}/{retarded_weight.denominator}",
                "scale_weight_decimal": f"{float(retarded_weight):.15f}",
                "rule_derived": "yes",
            }
        )

        route, advanced = advanced_destinations(source)
        if route == "VISIBLE":
            visible_advanced_sources += 1
            for target, multiplicity in advanced:
                weighted = float(multiplicity) * advanced_weight_float
                column_sum_float[source_id] += weighted
                edge_rows.append(
                    {
                        "source_id": source_id,
                        "source": source_label,
                        "branch": "advanced",
                        "target_id": state_index[target],
                        "target": state_label(target),
                        "route": "VISIBLE",
                        "multiplicity": f"{multiplicity.numerator}/{multiplicity.denominator}",
                        "scale_weight": "rho_star^(alpha-2)",
                        "scale_weight_decimal": f"{advanced_weight_float:.15f}",
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
                    "target_id": "",
                    "target": "Q_K:DEPTH_ZERO",
                    "route": route,
                    "multiplicity": "1",
                    "scale_weight": "rho_star^(alpha-2)",
                    "scale_weight_decimal": f"{advanced_weight_float:.15f}",
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
                "weighted_out_sum_decimal": f"{column_sum_float[source_id]:.15f}",
            }
        )

    # In the parent->child orientation, advanced edges strictly lower depth
    # and retarded edges preserve depth.  Thus the finite visible matrix is
    # block triangular by depth, and the only diagonal-block weight is the
    # retarded coefficient.
    parent_to_child_spectral_radius = retarded_weight
    orientation_certifies_growth = parent_to_child_spectral_radius > 1

    summary = {
        "K": args.K,
        "operator": "scale_aware_parent_to_child_orientation_audit",
        "rho_star": "9/5",
        "rho_star_decimal": float(RHO_STAR),
        "lambda_11_official": "71689/40000",
        "lambda_11_official_decimal": float(LAMBDA_11_OFFICIAL),
        "rho_star_gt_lambda_11_official": RHO_STAR > LAMBDA_11_OFFICIAL,
        "state_count": len(states),
        "edge_count": len(edge_rows),
        "visible_advanced_source_states": visible_advanced_sources,
        "tail_edges": tail_edges,
        "retarded_weight": f"{retarded_weight.numerator}/{retarded_weight.denominator}",
        "retarded_weight_decimal": float(retarded_weight),
        "advanced_weight_formula": "rho_star^(log_2(3)-2)",
        "advanced_weight_decimal": advanced_weight_float,
        "branch_sum_for_advanced_states_decimal": critical_sum_float,
        "lambda_11_branch_sum_decimal": lambda_sum_float,
        "parent_to_child_spectral_radius": f"{parent_to_child_spectral_radius.numerator}/{parent_to_child_spectral_radius.denominator}",
        "parent_to_child_spectral_radius_decimal": float(
            parent_to_child_spectral_radius
        ),
        "parent_to_child_orientation_certifies_growth": orientation_certifies_growth,
        "local_verdict": "STOP_PARENT_TO_CHILD_ORIENTATION_REFORMULATE_RECURRENCE",
        "next_required_object": "F3_PHASE_B_SCALE_AWARE_RECURRENCE_ORIENTATION_v0_2",
        "non_claims": {
            "no_lean_operator": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
        },
    }

    states_path = output_dir / "states.csv"
    edges_path = output_dir / "scale_edges.csv"
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
            "weighted_out_sum_decimal",
        ],
    )
    write_csv(
        edges_path,
        edge_rows,
        [
            "source_id",
            "source",
            "branch",
            "target_id",
            "target",
            "route",
            "multiplicity",
            "scale_weight",
            "scale_weight_decimal",
            "rule_derived",
        ],
    )
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [{"path": path.name, "sha256": file_sha256(path)} for path in (states_path, edges_path, summary_path)],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
