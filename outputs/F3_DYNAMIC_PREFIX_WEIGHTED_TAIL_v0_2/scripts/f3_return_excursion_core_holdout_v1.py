#!/usr/bin/env python3
"""F3 return-excursion core holdout v1.

Consumes the one-use holdout range [20737, 41473) using the frozen core vector.
This is empirical/audit-grade only: no rho theorem, no density theorem.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import platform
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


BASE = Path(__file__).resolve().parents[1]
PACKAGE_ROOT = Path(__file__).resolve().parents[2] / "F3_DENSITY_CAPTURE_GATE_v1"
sys.path.insert(0, str(PACKAGE_ROOT / "scripts"))

from f3_e5_memberwise_gap_audit_v1 import pi_star_members  # noqa: E402


DEFAULT_OUTPUT_DIR = BASE / "results/F3_RETURN_EXCURSION_CORE_HOLDOUT_v1"
V2_DIR = BASE / "results/F3_PHASE_B_RETURN_EXCURSION_OPERATOR_v2"
CORE_DIR = BASE / "results/F3_RETURN_EXCURSION_SUPPORT_REPAIR_v1"
EXPECTED_W_SHA256 = "ad4c4627f575f60911f3b943c92cd3937686f9924592dbf33f6e988d7a9dbb53"
HOLDOUT_INTERVAL = (20_737, 41_473)
K = 5
Y_VALUES = (8, 9, 10)
DELTA = 0.01


def T(n: int) -> int:
    return n // 2 if n % 2 == 0 else (3 * n + 1) // 2


def parity(n: int) -> str:
    return "odd" if n % 2 else "even"


def clipped_nu2(n: int) -> int:
    if n % 2:
        return 0
    if n % 4:
        return 1
    return 2


def type_label(n: int, depth: int = K) -> str:
    return f"d{depth}:r{n % (3**depth)}:p{parity(n)}:b{clipped_nu2(n)}"


def parse_state(label: str) -> tuple[int, int, str, int]:
    parts = label.split(":")
    return (
        int(parts[0][1:]),
        int(parts[1][1:]),
        parts[2][1:],
        int(parts[3][1:]),
    )


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def phase_b_bound(a: int, c: int, y: int) -> int:
    return (2**y) * a - 2 ** (y - 1)


def pure_duplication_tail_count(c: int, y: int) -> int:
    window = 3 * (2 ** (y - 1)) * c
    return (window // c).bit_length()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_dir: Path = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    started = time.perf_counter()

    frozen_w_path = CORE_DIR / "frozen_w_core.csv"
    frozen_w_sha = file_sha256(frozen_w_path)
    if frozen_w_sha != EXPECTED_W_SHA256:
        raise SystemExit(f"frozen_w hash mismatch: {frozen_w_sha}")

    core_rows = read_csv(frozen_w_path)
    core_by_state = {row["state"]: row for row in core_rows}
    core_states = set(core_by_state)

    # Load frozen per-state lhs/rhs from the support-repair freeze.
    lhs_by_state = {row["state"]: float(row["lhs_wM_decimal"]) for row in core_rows}
    rhs_by_state = {
        row["state"]: float(row["rhs_1_plus_delta_w_decimal"]) for row in core_rows
    }
    weight_by_state = {row["state"]: float(row["rational_weight_decimal"]) for row in core_rows}

    # Edge map restricted to the frozen core.
    edge_rows = read_csv(V2_DIR / "return_excursion_edges.csv")
    edge_key_counts: Counter[tuple[str, str]] = Counter()
    for row in edge_rows:
        if row["source"] in core_states:
            edge_key_counts[(row["source"], row["channel"])] += 1

    roots = [a for a in range(*HOLDOUT_INTERVAL) if a > 2 and a % 3 == 2]
    member_cache: dict[tuple[int, int], set[int]] = {}

    def members(root: int, bound: int) -> set[int]:
        key = (root, bound)
        cached = member_cache.get(key)
        if cached is None:
            cached = pi_star_members(root, bound)
            member_cache[key] = cached
        return cached

    totals = {
        "target": 0,
        "retarded_visible": 0,
        "advanced_full": 0,
        "advanced_phase_b": 0,
        "atom_tail": 0,
        "phase_loss_tail": 0,
        "q_total": 0,
        "visible_total": 0,
    }
    core_state_counts: Counter[str] = Counter()
    channel_counts: Counter[str] = Counter()
    partition_mismatches: list[dict[str, Any]] = []
    core_mismatches: list[dict[str, Any]] = []
    core_audit_rows: list[dict[str, Any]] = []
    excluded_source_rows = 0

    for a in roots:
        c_num = 2 * a - 1
        if c_num % 3 != 0:
            raise AssertionError(f"nonintegral advanced child for a={a}")
        c = c_num // 3
        source = type_label(a)
        source_in_core = source in core_states
        if not source_in_core:
            excluded_source_rows += len(Y_VALUES)

        if c % 3 == 2:
            channel = "advanced_direct_c2"
            channel_target = type_label(c)
        elif c % 3 == 1:
            channel = "advanced_parity_lift_c1"
            channel_target = type_label(2 * c)
        else:
            channel = "advanced_sterile_tail_c0"
            channel_target = "Q"

        core_channel_pass = True
        core_channel_detail = ""
        if source_in_core:
            channel_counts[channel] += len(Y_VALUES)
            core_state_counts[source] += len(Y_VALUES)
            if channel == "advanced_sterile_tail_c0":
                core_channel_pass = c % 3 == 0
                core_channel_detail = "sterile_Q"
            else:
                core_channel_pass = (
                    channel_target in core_states
                    and edge_key_counts[(source, channel)] == 1
                )
                core_channel_detail = f"target={channel_target}"

        for y in Y_VALUES:
            x = (2**y) * a
            x_phase_b = phase_b_bound(a, c, y)
            target = members(a, x)
            retarded = members(4 * a, x)
            advanced_full = members(c, x)
            advanced_phase_b = members(c, x_phase_b)

            atom_count = 2
            target_count = len(target)
            retarded_count = len(retarded)
            advanced_full_count = len(advanced_full)
            advanced_phase_b_count = len(advanced_phase_b)
            phase_loss_count = advanced_full_count - advanced_phase_b_count
            visible_total = retarded_count + advanced_phase_b_count
            q_total = atom_count + phase_loss_count

            reconstructed = {a, 2 * a} | retarded | advanced_full
            partition_pass = target == reconstructed
            disjoint_pass = (
                {a, 2 * a}.isdisjoint(retarded)
                and {a, 2 * a}.isdisjoint(advanced_full)
                and retarded.isdisjoint(advanced_full)
            )
            phase_subset_pass = advanced_phase_b <= advanced_full
            route_pass = T(4 * a) == 2 * a and T(2 * a) == a and T(c) == a
            denominator_pass = visible_total + q_total == target_count
            bound_pass = x_phase_b <= x
            all_partition_hooks_pass = all(
                [
                    partition_pass,
                    disjoint_pass,
                    phase_subset_pass,
                    route_pass,
                    denominator_pass,
                    bound_pass,
                ]
            )

            totals["target"] += target_count
            totals["retarded_visible"] += retarded_count
            totals["advanced_full"] += advanced_full_count
            totals["advanced_phase_b"] += advanced_phase_b_count
            totals["atom_tail"] += atom_count
            totals["phase_loss_tail"] += phase_loss_count
            totals["q_total"] += q_total
            totals["visible_total"] += visible_total

            common = {
                "a": a,
                "y": y,
                "source": source,
                "source_in_core": "yes" if source_in_core else "no",
                "channel": channel,
                "channel_target": channel_target,
                "target_count": target_count,
                "visible_total": visible_total,
                "q_total": q_total,
                "partition_pass": "yes" if partition_pass else "no",
                "disjoint_pass": "yes" if disjoint_pass else "no",
                "phase_subset_pass": "yes" if phase_subset_pass else "no",
                "route_pass": "yes" if route_pass else "no",
                "denominator_pass": "yes" if denominator_pass else "no",
                "all_partition_hooks_pass": "yes" if all_partition_hooks_pass else "no",
            }
            if not all_partition_hooks_pass:
                partition_mismatches.append(common)

            if source_in_core:
                q_exact_pass = True
                if channel == "advanced_sterile_tail_c0":
                    q_exact_pass = pure_duplication_tail_count(c, y) == y + 1
                core_pass = core_channel_pass and q_exact_pass
                core_row = {
                    **common,
                    "core_channel_pass": "yes" if core_channel_pass else "no",
                    "q_exact_pass": "yes" if q_exact_pass else "no",
                    "core_pass": "yes" if core_pass else "no",
                    "core_channel_detail": core_channel_detail,
                }
                core_audit_rows.append(core_row)
                if not core_pass:
                    core_mismatches.append(core_row)

    lhs_total = sum(core_state_counts[state] * lhs_by_state[state] for state in core_state_counts)
    rhs_total = sum(core_state_counts[state] * rhs_by_state[state] for state in core_state_counts)
    ratio = lhs_total / rhs_total if rhs_total else 0.0
    weighted_pass = ratio >= 1.0
    hook_pass = not partition_mismatches and not core_mismatches
    if hook_pass and weighted_pass:
        local_verdict = "CANDIDATE_CERTIFICATE_EMPIRICAL"
    elif not hook_pass:
        local_verdict = "HOLDOUT_FAIL_HOOK_MISMATCH"
    else:
        local_verdict = "HOLDOUT_FAIL_WEIGHTED_INEQUALITY"

    state_rows = []
    for state in sorted(core_states, key=lambda s: int(core_by_state[s]["core_local_id"])):
        count = core_state_counts[state]
        state_rows.append(
            {
                "state": state,
                "holdout_core_count": count,
                "rational_weight_decimal": f"{weight_by_state[state]:.18e}",
                "lhs_component_decimal": f"{lhs_by_state[state]:.18e}",
                "rhs_component_decimal": f"{rhs_by_state[state]:.18e}",
                "lhs_weighted_total_decimal": f"{count * lhs_by_state[state]:.18e}",
                "rhs_weighted_total_decimal": f"{count * rhs_by_state[state]:.18e}",
            }
        )

    target_total = totals["target"]
    summary = {
        "interval_half_open": list(HOLDOUT_INTERVAL),
        "unique_parent_roots": len(roots),
        "root_rows": len(roots) * len(Y_VALUES),
        "core_source_rows": sum(core_state_counts.values()),
        "excluded_source_rows": excluded_source_rows,
        "y_values": list(Y_VALUES),
        "frozen_w_core_sha256": frozen_w_sha,
        "ratio_definition": "lhs_total / rhs_total, where rhs_total = sum_i count_i * (1+delta) * w_i",
        "lhs_total_decimal": lhs_total,
        "rhs_total_decimal": rhs_total,
        "weighted_ratio_lhs_over_rhs": ratio,
        "weighted_pass_ratio_ge_1": weighted_pass,
        "delta": "1/100",
        "partition_mismatch_count": len(partition_mismatches),
        "core_mismatch_count": len(core_mismatches),
        "channel_counts_core_rows": dict(sorted(channel_counts.items())),
        "core_state_support_touched": len(core_state_counts),
        "totals": totals,
        "visible_capture_fraction": totals["visible_total"] / target_total if target_total else 0.0,
        "q_fraction": totals["q_total"] / target_total if target_total else 0.0,
        "phase_loss_fraction": totals["phase_loss_tail"] / target_total if target_total else 0.0,
        "atom_tail_fraction": totals["atom_tail"] / target_total if target_total else 0.0,
        "elapsed_seconds": time.perf_counter() - started,
        "python": sys.version,
        "platform": platform.platform(),
        "local_verdict": local_verdict,
        "holdout_consumed": True,
        "non_claims": {
            "no_rho_certificate": True,
            "no_density_theorem": True,
            "no_almost_all": True,
            "no_global_collatz_claim": True,
            "no_lean_operator": True,
        },
    }

    core_rows_path = output_dir / "core_holdout_rows.csv"
    partition_mismatches_path = output_dir / "partition_mismatches.csv"
    core_mismatches_path = output_dir / "core_mismatches.csv"
    state_summary_path = output_dir / "weighted_state_summary.csv"
    summary_path = output_dir / "summary.json"
    manifest_path = output_dir / "manifest_sha256.csv"

    core_fields = list(core_audit_rows[0].keys()) if core_audit_rows else [
        "a",
        "y",
        "source",
        "source_in_core",
        "channel",
        "channel_target",
        "target_count",
        "visible_total",
        "q_total",
        "partition_pass",
        "disjoint_pass",
        "phase_subset_pass",
        "route_pass",
        "denominator_pass",
        "all_partition_hooks_pass",
        "core_channel_pass",
        "q_exact_pass",
        "core_pass",
        "core_channel_detail",
    ]
    write_csv(core_rows_path, core_audit_rows, core_fields)
    write_csv(partition_mismatches_path, partition_mismatches, list(partition_mismatches[0].keys()) if partition_mismatches else core_fields[:15])
    write_csv(core_mismatches_path, core_mismatches, core_fields)
    write_csv(
        state_summary_path,
        state_rows,
        [
            "state",
            "holdout_core_count",
            "rational_weight_decimal",
            "lhs_component_decimal",
            "rhs_component_decimal",
            "lhs_weighted_total_decimal",
            "rhs_weighted_total_decimal",
        ],
    )
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(
        manifest_path,
        [
            {"path": path.name, "sha256": file_sha256(path)}
            for path in (
                core_rows_path,
                partition_mismatches_path,
                core_mismatches_path,
                state_summary_path,
                summary_path,
            )
        ],
        ["path", "sha256"],
    )
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
