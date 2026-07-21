#!/usr/bin/env python3
"""F3 PHASE_B return-operator inventory v1.

This is a diagnostic inventory for the v0.2 recurrence orientation.  It builds
a fixed-depth rebasing return matrix.  It is not a rho certificate.
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


D0_DEFAULT = 5
RHO_STAR = Fraction(9, 5)
LAMBDA_11_OFFICIAL = Fraction(71689, 40000)
DEFAULT_OUTPUT_DIR = (
    Path(__file__).resolve().parents[1]
    / "results/F3_PHASE_B_RETURN_OPERATOR_INVENTORY_v1"
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


def states_at_depth(d: int) -> list[tuple[int, int, str, int]]:
    states: list[tuple[int, int, str, int]] = []
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


def advanced_child_distribution(
    state: tuple[int, int, str, int],
) -> list[tuple[tuple[int, int, str, int], Fraction]]:
    d, r, _p, _b = state
    if r % 3 != 2 or d <= 1:
        return []
    child_depth = d - 1
    child_residue = ((2 * r - 1) // 3) % (3**child_depth)
    counts: defaultdict[tuple[int, int, str, int], int] = defaultdict(int)
    for lift in range(3):
        a = representative(state, lift)
        c = (2 * a - 1) // 3
        child = (child_depth, child_residue, parity_value(c), nu2_bucket(c))
        counts[child] += 1
    return sorted(
        [(child, Fraction(count, 3)) for child, count in counts.items()],
        key=lambda item: state_label(item[0]),
    )


def rebase_to_depth(
    child: tuple[int, int, str, int], d0: int
) -> list[tuple[tuple[int, int, str, int], Fraction]]:
    d, r, p, b = child
    if d > d0:
        raise ValueError("cannot rebase from deeper state")
    lift_count = 3 ** (d0 - d)
    modulus = 3**d
    targets = [
        (d0, r + lift * modulus, p, b)
        for lift in range(lift_count)
    ]
    weight = Fraction(1, lift_count)
    return [(target, weight) for target in targets]


def power_iteration(
    state_count: int,
    edges: list[tuple[int, int, float]],
    iterations: int = 200,
) -> dict[str, float]:
    vector = [1.0 / state_count] * state_count
    estimate = 0.0
    for _ in range(iterations):
        nxt = [0.0] * state_count
        for source, target, weight in edges:
            nxt[target] += weight * vector[source]
        total = sum(nxt)
        if total == 0.0:
            return {"estimate": 0.0, "min_ratio": 0.0, "max_ratio": 0.0}
        estimate = total / sum(vector)
        vector = [value / total for value in nxt]
    nxt = [0.0] * state_count
    for source, target, weight in edges:
        nxt[target] += weight * vector[source]
    ratios = [
        nxt[i] / vector[i]
        for i in range(state_count)
        if vector[i] > 1e-18
    ]
    return {
        "estimate": estimate,
        "min_ratio": min(ratios),
        "max_ratio": max(ratios),
    }


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


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--d0", type=int, default=D0_DEFAULT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    d0 = args.d0
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    states = states_at_depth(d0)
    state_index = {state: index for index, state in enumerate(states)}
    alpha = math.log(3, 2)
    retarded_weight = Fraction(RHO_STAR.denominator**2, RHO_STAR.numerator**2)
    advanced_return_weight = 0.5 * (float(RHO_STAR) ** (alpha - 1.0))
    scalar_F_rho = float(retarded_weight) + advanced_return_weight
    scalar_F_lambda = float(LAMBDA_11_OFFICIAL) ** (-2.0) + 0.5 * (
        float(LAMBDA_11_OFFICIAL) ** (alpha - 1.0)
    )

    edge_rows: list[dict[str, Any]] = []
    matrix_edges: list[tuple[int, int, float]] = []
    outgoing: defaultdict[int, float] = defaultdict(float)
    advanced_sources = 0

    for source in states:
        source_id = state_index[source]
        r_target = retarded_state(source)
        r_target_id = state_index[r_target]
        r_weight = float(retarded_weight)
        outgoing[source_id] += r_weight
        matrix_edges.append((source_id, r_target_id, r_weight))
        edge_rows.append(
            {
                "source_id": source_id,
                "source": state_label(source),
                "branch": "retarded_return",
                "target_id": r_target_id,
                "target": state_label(r_target),
                "weight_decimal": f"{r_weight:.15f}",
                "weight_formula": "rho_star^(-2)",
                "multiplicity": "1",
                "rule_derived": "yes",
            }
        )
        child_distribution = advanced_child_distribution(source)
        if child_distribution:
            advanced_sources += 1
        for child, child_mult in child_distribution:
            for target, rebase_mult in rebase_to_depth(child, d0):
                target_id = state_index[target]
                weight = advanced_return_weight * float(child_mult) * float(rebase_mult)
                outgoing[source_id] += weight
                matrix_edges.append((source_id, target_id, weight))
                edge_rows.append(
                    {
                        "source_id": source_id,
                        "source": state_label(source),
                        "branch": "advanced_rebased_return",
                        "target_id": target_id,
                        "target": state_label(target),
                        "weight_decimal": f"{weight:.15f}",
                        "weight_formula": "0.5*rho_star^(alpha-1)*child_mult*rebase_mult",
                        "multiplicity": f"{child_mult}*{rebase_mult}",
                        "rule_derived": "yes",
                    }
                )

    power = power_iteration(len(states), matrix_edges)
    outgoing_values = [outgoing[index] for index in range(len(states))]
    summary = {
        "d0": d0,
        "state_count": len(states),
        "edge_count": len(edge_rows),
        "rho_star": "9/5",
        "lambda_11_official": "71689/40000",
        "retarded_weight": f"{retarded_weight.numerator}/{retarded_weight.denominator}",
        "retarded_weight_decimal": float(retarded_weight),
        "advanced_return_weight_formula": "0.5*rho_star^(log_2(3)-1)",
        "advanced_return_weight_decimal": advanced_return_weight,
        "scalar_F_rho_star": scalar_F_rho,
        "scalar_F_lambda_11": scalar_F_lambda,
        "advanced_source_states": advanced_sources,
        "min_outgoing_weight": min(outgoing_values),
        "max_outgoing_weight": max(outgoing_values),
        "power_iteration_estimate": power["estimate"],
        "collatz_wielandt_min_ratio": power["min_ratio"],
        "collatz_wielandt_max_ratio": power["max_ratio"],
        "inventory_status": "RETURN_INVENTORY_BUILT",
        "local_verdict": "STOP_REBASING_NOT_MEMBERWISE",
        "certificate_status": "NO_RHO_CERTIFICATE_MEMBERWISE_HOOKS_MISSING",
        "non_claims": {
            "no_lean_operator": True,
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
        },
    }

    edges_path = output_dir / "return_edges.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"
    write_csv(
        edges_path,
        edge_rows,
        [
            "source_id",
            "source",
            "branch",
            "target_id",
            "target",
            "weight_decimal",
            "weight_formula",
            "multiplicity",
            "rule_derived",
        ],
    )
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [{"path": path.name, "sha256": file_sha256(path)} for path in (edges_path, summary_path)],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
