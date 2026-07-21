#!/usr/bin/env python3
"""KL2003 F2 k=11 preflight budget from custodied k=9 measurements.

This is not a k=11 certificate generator.  It records the scale, source
status, and cold-rerun obligations that must be satisfied before k=11 can
compete with the F3 branch for engineering attention.
"""

from __future__ import annotations

import csv
import hashlib
import json
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K11_PREFLIGHT_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
K9_GATE = REPO_ROOT / "outputs/KL2003_F2_K9_MEASUREMENT_GATE_v1/final_gate_summary.json"
K9_KERNEL = (
    REPO_ROOT
    / "outputs/KL2003_F2_K9_KERNEL_CHECKER_BENCHMARK_v1/kernel_checker_summary.json"
)
HIGH_K_SOURCE_REVIEW = REPO_ROOT / "docs/KL2003_F2_HIGH_K_SOURCE_REVIEW_AND_GENERATOR_PATH_v1.md"
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
SUMMARY_PATH = OUT_DIR / "summary.json"
BUDGET_PATH = OUT_DIR / "budget_projection.csv"
CONDITIONS_PATH = OUT_DIR / "condition_status.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def repo_rel(path: Path) -> str:
    return str(path.resolve().relative_to(REPO_ROOT))


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text())


def main() -> int:
    k9_gate = load_json(K9_GATE)
    k9_kernel = load_json(K9_KERNEL)
    k9_rows = int(k9_kernel["row_equation_count"])
    k9_aux = int(k9_kernel["auxiliary_box_group_count"])
    k9_wall = float(k9_kernel["total_wall_seconds"])
    k9_sum_shards = float(k9_kernel["sum_shard_seconds"])
    k9_max_shard = float(k9_kernel["maximum_shard_seconds"])

    k11_rows = 3 ** 10
    k11_aux = 3 ** 9
    scale_from_k9 = k11_rows / k9_rows

    projection_rows = [
        {
            "metric": "tracked_class_count",
            "k9_measured": k9_rows,
            "k11_projected": k11_rows,
            "scale_from_k9": f"{scale_from_k9:.6f}",
            "status": "source_scale_exact",
        },
        {
            "metric": "auxiliary_box_group_count",
            "k9_measured": k9_aux,
            "k11_projected": k11_aux,
            "scale_from_k9": f"{k11_aux / k9_aux:.6f}",
            "status": "source_scale_exact",
        },
        {
            "metric": "kernel_wall_seconds_linear_same_workers",
            "k9_measured": f"{k9_wall:.6f}",
            "k11_projected": f"{k9_wall * scale_from_k9:.6f}",
            "scale_from_k9": f"{scale_from_k9:.6f}",
            "status": "projection_not_measurement",
        },
        {
            "metric": "kernel_sum_shard_seconds_linear",
            "k9_measured": f"{k9_sum_shards:.6f}",
            "k11_projected": f"{k9_sum_shards * scale_from_k9:.6f}",
            "scale_from_k9": f"{scale_from_k9:.6f}",
            "status": "projection_not_measurement",
        },
        {
            "metric": "maximum_shard_seconds_linear",
            "k9_measured": f"{k9_max_shard:.6f}",
            "k11_projected": f"{k9_max_shard * scale_from_k9:.6f}",
            "scale_from_k9": f"{scale_from_k9:.6f}",
            "status": "projection_not_measurement",
        },
    ]

    conditions = [
        {
            "condition": "source_target_recorded",
            "status": "PASS",
            "evidence": "k=11 gamma_11=0.8417560 lambda_11=1.7922310 recorded in high-k source review",
        },
        {
            "condition": "printed_k11_structural_data",
            "status": "FAIL",
            "evidence": "source review classifies printed_k11_084_data as MISSING_PRINTED_STRUCTURAL",
        },
        {
            "condition": "k11_generator_exists",
            "status": "FAIL",
            "evidence": "no k=11 generator or certificate output is present in this repo",
        },
        {
            "condition": "k11_cold_rerun_available",
            "status": "FAIL",
            "evidence": "cold rerun requires generator output; only budget projection is possible now",
        },
        {
            "condition": "k9_baseline_custodied",
            "status": "PASS",
            "evidence": f"k=9 gate verdict {k9_gate['verdict']}; kernel wall {k9_wall:.6f}s",
        },
    ]
    failure_count = sum(row["status"] != "PASS" for row in conditions)
    summary = {
        "run_id": RUN_ID,
        "verdict": "K11_PREFLIGHT_BLOCKED_GENERATOR_REQUIRED",
        "k11_status": "NOT_CUSTODIED_AS_CERTIFICATE",
        "k11_source_target": {
            "gamma_11": "0.8417560",
            "lambda_11": "1.7922310",
            "tracked_class_count": k11_rows,
            "auxiliary_box_group_count": k11_aux,
        },
        "k9_baseline": {
            "verdict": k9_gate["verdict"],
            "tracked_class_count": k9_rows,
            "kernel_wall_seconds": k9_kernel["total_wall_seconds"],
            "maximum_shard_seconds": k9_kernel["maximum_shard_seconds"],
            "sum_shard_seconds": k9_kernel["sum_shard_seconds"],
        },
        "linear_projection_from_k9": {
            "scale_factor": scale_from_k9,
            "kernel_wall_seconds": k9_wall * scale_from_k9,
            "kernel_sum_shard_seconds": k9_sum_shards * scale_from_k9,
            "maximum_shard_seconds": k9_max_shard * scale_from_k9,
        },
        "conditions_total": len(conditions),
        "conditions_failed": failure_count,
        "next_required_artifacts": [
            "source-faithful k=11 generator",
            "k=11 certificate JSON/CSV with manifests",
            "independent schema verifier",
            "cold kernel checker benchmark",
            "budget ledger with PASS/OPTIMIZATION_REQUIRED/ARCHITECTURE_FAIL",
        ],
        "priority": "K11_PREFLIGHT_BEFORE_NEXT_F3_EXPERIMENT",
        "non_claims": [
            "NO_K11_THEOREM_CLAIM",
            "NO_084_EXPONENT_CLAIM",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }

    write_csv(
        BUDGET_PATH,
        projection_rows,
        ["metric", "k9_measured", "k11_projected", "scale_from_k9", "status"],
    )
    write_csv(CONDITIONS_PATH, conditions, ["condition", "status", "evidence"])
    write_json(SUMMARY_PATH, summary)
    manifest_inputs = [
        SUMMARY_PATH,
        BUDGET_PATH,
        CONDITIONS_PATH,
        REPO_ROOT / "scripts" / Path(__file__).name,
        K9_GATE,
        K9_KERNEL,
        HIGH_K_SOURCE_REVIEW,
    ]
    write_csv(
        MANIFEST_PATH,
        [{"path": repo_rel(path), "sha256": sha256(path)} for path in manifest_inputs],
        ["path", "sha256"],
    )
    print(json.dumps(summary, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
