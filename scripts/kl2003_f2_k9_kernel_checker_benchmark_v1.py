#!/usr/bin/env python3
"""Run every generated k=9 arithmetic checker shard under Lean.

The generated shards contain only exact ``Rat`` statements discharged by
``norm_num``.  Passing this benchmark verifies the emitted certificate data;
it does not prove the semantic k=9 lower-bound theorem.
"""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Any


RUN_ID = "KL2003_F2_K9_KERNEL_CHECKER_BENCHMARK_v1"
REPO_ROOT = Path(__file__).resolve().parents[1]
MEASUREMENT_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K9_LNT_MEASUREMENT_v1"
DATA_PATH = MEASUREMENT_DIR / "KL2003K9LNTCertificateDataCandidate.lean"
SHARD_DIR = MEASUREMENT_DIR / "lean_checker_shards"
OUT_DIR = REPO_ROOT / "outputs" / RUN_ID
SUMMARY_PATH = OUT_DIR / "kernel_checker_summary.json"
SHARDS_PATH = OUT_DIR / "shard_benchmarks.csv"
MISMATCH_PATH = OUT_DIR / "mismatch.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"
MAX_WORKERS = 3
PER_FILE_TIMEOUT_SECONDS = 900


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


def write_json(path: Path, payload: Any) -> None:
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
            writer.writerow({field: row.get(field, "") for field in fields})


def run_lean(path: Path, kind: str, shard_index: int | None) -> dict[str, Any]:
    start = time.perf_counter()
    try:
        result = subprocess.run(
            ["lake", "env", "lean", str(path)],
            cwd=REPO_ROOT,
            text=True,
            capture_output=True,
            timeout=PER_FILE_TIMEOUT_SECONDS,
            check=False,
        )
        status = "pass" if result.returncode == 0 else "fail"
        return_code: int | str = result.returncode
        stdout_tail = result.stdout[-1000:]
        stderr_tail = result.stderr[-1000:]
    except subprocess.TimeoutExpired as error:
        status = "timeout"
        return_code = "timeout"
        stdout_tail = (error.stdout or "")[-1000:]
        stderr_tail = (error.stderr or "")[-1000:]
    return {
        "kind": kind,
        "shard_index": "" if shard_index is None else shard_index,
        "path": repo_rel(path),
        "sha256": sha256(path),
        "bytes": path.stat().st_size,
        "status": status,
        "return_code": return_code,
        "wall_seconds": f"{time.perf_counter() - start:.6f}",
        "stdout_tail": stdout_tail.replace("\n", "\\n"),
        "stderr_tail": stderr_tail.replace("\n", "\\n"),
    }


def main() -> int:
    shard_paths = sorted(SHARD_DIR.glob("KL2003K9LNTCertificateCheckerShard*.lean"))
    if len(shard_paths) != 9:
        raise RuntimeError(f"EXPECTED_9_CHECKER_SHARDS_FOUND_{len(shard_paths)}")
    total_start = time.perf_counter()
    data_result = run_lean(DATA_PATH, "generated_data_elaboration", None)
    shard_results: list[dict[str, Any]] = []
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {
            executor.submit(run_lean, path, "arithmetic_checker", index): index
            for index, path in enumerate(shard_paths)
        }
        for future in as_completed(futures):
            shard_results.append(future.result())
    shard_results.sort(key=lambda row: int(row["shard_index"]))
    all_results = [data_result, *shard_results]
    failures = [row for row in all_results if row["status"] != "pass"]
    verdict = (
        "K9_KERNEL_CERTIFICATE_CHECKER_BENCHMARK_PASS"
        if not failures
        else "K9_KERNEL_CERTIFICATE_CHECKER_BENCHMARK_FAIL"
    )
    write_csv(
        SHARDS_PATH,
        all_results,
        [
            "kind",
            "shard_index",
            "path",
            "sha256",
            "bytes",
            "status",
            "return_code",
            "wall_seconds",
            "stdout_tail",
            "stderr_tail",
        ],
    )
    write_csv(
        MISMATCH_PATH,
        failures,
        ["kind", "shard_index", "path", "status", "return_code", "stderr_tail"],
    )
    total_wall = time.perf_counter() - total_start
    shard_seconds = [float(row["wall_seconds"]) for row in shard_results]
    summary = {
        "run_id": RUN_ID,
        "verdict": verdict,
        "max_workers": MAX_WORKERS,
        "per_file_timeout_seconds": PER_FILE_TIMEOUT_SECONDS,
        "generated_data_elaboration_status": data_result["status"],
        "generated_data_elaboration_seconds": data_result["wall_seconds"],
        "checker_shard_count": len(shard_results),
        "checker_shards_passed": sum(row["status"] == "pass" for row in shard_results),
        "checker_shards_failed": sum(row["status"] == "fail" for row in shard_results),
        "checker_shards_timed_out": sum(row["status"] == "timeout" for row in shard_results),
        "row_equation_count": 6561,
        "auxiliary_box_group_count": 2187,
        "all_certificate_rows_kernel_rechecked": not failures,
        "minimum_shard_seconds": f"{min(shard_seconds):.6f}",
        "maximum_shard_seconds": f"{max(shard_seconds):.6f}",
        "sum_shard_seconds": f"{sum(shard_seconds):.6f}",
        "total_wall_seconds": f"{total_wall:.6f}",
        "semantic_k9_theorem_status": "NOT_PROVED",
        "classification": [
            "K9_EXACT_CERTIFICATE_ARITHMETIC_KERNEL_RECHECK_ATTEMPTED",
            "K9_MEASUREMENT_ONLY",
            "NO_K9_LOWER_BOUND_THEOREM_CLAIM",
            "K11_DEFERRED",
            "NO_GLOBAL_COLLATZ_CLAIM",
        ],
    }
    write_json(SUMMARY_PATH, summary)
    manifest_inputs = [
        SUMMARY_PATH,
        SHARDS_PATH,
        MISMATCH_PATH,
        REPO_ROOT / "scripts" / Path(__file__).name,
        DATA_PATH,
        *shard_paths,
    ]
    write_csv(
        MANIFEST_PATH,
        [{"path": repo_rel(path), "sha256": sha256(path)} for path in manifest_inputs],
        ["path", "sha256"],
    )
    print(json.dumps(summary, sort_keys=True))
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
