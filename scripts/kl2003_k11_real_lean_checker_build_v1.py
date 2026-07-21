#!/usr/bin/env python3
"""Build the generated k=11 checker with bounded concurrency."""

from __future__ import annotations

import csv
import hashlib
import json
import argparse
import os
import shutil
import signal
import subprocess
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict, dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
LEAN_BUILD_DIR = REPO_ROOT / ".lake" / "build" / "lib" / "lean" / "CollatzClassical" / "KL2003"
OUT_DIR = REPO_ROOT / "outputs" / "KL2003_K11_REAL_LEAN_CHECKER_v1"
SUMMARY_PATH = OUT_DIR / "build_summary.json"
SHARD_MEASUREMENTS_PATH = OUT_DIR / "checker_shard_measurements.csv"
POST_MEASUREMENTS_PATH = OUT_DIR / "post_checker_measurements.csv"
BUILD_MANIFEST_PATH = OUT_DIR / "build_artifact_manifest_sha256.csv"

SHARD_COUNT = 81
GROUP_COUNT = 9
DEFAULT_WORKERS = 1
DEFAULT_SHARD_TIMEOUT_SECONDS = 450
GROUP_TIMEOUT_SECONDS = 300
FINAL_TIMEOUT_SECONDS = 300
MIN_FREE_DISK_GIB = 12


@dataclass
class Measurement:
    target: str
    status: str
    elapsed_seconds: float
    exit_code: int
    output_tail: str
    preexisting: bool


def module_target(stem: str) -> str:
    return f"CollatzClassical.KL2003.{stem}"


def shard_stem(shard: int) -> str:
    return f"KL2003K11CertificateMatchShard{shard:02d}"


def group_stem(group: int) -> str:
    return f"KL2003K11CertificateMatchGroup{group}"


def olean_path(stem: str) -> Path:
    return LEAN_BUILD_DIR / f"{stem}.olean"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def run_target(stem: str, timeout_seconds: int, preexisting: bool) -> Measurement:
    target = module_target(stem)
    started = time.monotonic()
    process: subprocess.Popen[str] | None = None
    try:
        process = subprocess.Popen(
            ["lake", "build", target],
            cwd=REPO_ROOT,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            start_new_session=True,
        )
        stdout, stderr = process.communicate(timeout=timeout_seconds)
        elapsed = time.monotonic() - started
        output = stdout + stderr
        status = "PASS" if process.returncode == 0 else "FAIL"
        return Measurement(
            target=target,
            status=status,
            elapsed_seconds=round(elapsed, 6),
            exit_code=process.returncode,
            output_tail=output[-2000:],
            preexisting=preexisting,
        )
    except subprocess.TimeoutExpired as error:
        if process is not None:
            try:
                os.killpg(process.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
            stdout, stderr = process.communicate()
        else:
            stdout = error.stdout or ""
            stderr = error.stderr or ""
        elapsed = time.monotonic() - started
        output = (stdout or "") + (stderr or "")
        return Measurement(
            target=target,
            status="TIMEOUT",
            elapsed_seconds=round(elapsed, 6),
            exit_code=124,
            output_tail=output[-2000:],
            preexisting=preexisting,
        )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build generated k=11 checker modules with bounded concurrency."
    )
    parser.add_argument("--workers", type=int, default=DEFAULT_WORKERS)
    parser.add_argument("--shard-timeout", type=int, default=DEFAULT_SHARD_TIMEOUT_SECONDS)
    parser.add_argument(
        "--max-shards",
        type=int,
        default=None,
        help="Attempt at most this many missing shards; useful for resource pilots.",
    )
    parser.add_argument(
        "--start-shard",
        type=int,
        default=0,
        help="First shard index eligible for attempted shard builds.",
    )
    parser.add_argument(
        "--attempt-all",
        action="store_true",
        help="Attempt eligible shards even if an .olean exists; useful after regenerating sources.",
    )
    parser.add_argument(
        "--skip-post",
        action="store_true",
        help="Skip group, aggregate, and audit builds after shard measurements.",
    )
    return parser.parse_args()


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    fields = [
        "target",
        "status",
        "elapsed_seconds",
        "exit_code",
        "preexisting",
        "output_tail",
    ]
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    args = parse_args()
    if args.workers < 1:
        raise RuntimeError("K11_BUILD_WORKERS_MUST_BE_POSITIVE")
    if args.shard_timeout < 1:
        raise RuntimeError("K11_BUILD_SHARD_TIMEOUT_MUST_BE_POSITIVE")
    if not (0 <= args.start_shard <= SHARD_COUNT):
        raise RuntimeError("K11_BUILD_START_SHARD_OUT_OF_RANGE")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    free_disk_gib = shutil.disk_usage(REPO_ROOT).free / (1024**3)
    if free_disk_gib < MIN_FREE_DISK_GIB:
        raise RuntimeError(f"K11_BUILD_FREE_DISK_FAIL: {free_disk_gib:.3f} GiB")

    overall_started = time.monotonic()
    preexisting_shards = {
        shard
        for shard in range(SHARD_COUNT)
        if not args.attempt_all and olean_path(shard_stem(shard)).exists()
    }
    missing_shards = [
        shard
        for shard in range(args.start_shard, SHARD_COUNT)
        if shard not in preexisting_shards
    ]
    if args.max_shards is not None:
        if args.max_shards < 0:
            raise RuntimeError("K11_BUILD_MAX_SHARDS_MUST_BE_NONNEGATIVE")
        missing_shards = missing_shards[: args.max_shards]
    shard_measurements: list[Measurement] = []
    for shard in sorted(preexisting_shards):
        shard_measurements.append(
            Measurement(
                target=module_target(shard_stem(shard)),
                status="PASS_PREEXISTING",
                elapsed_seconds=0.0,
                exit_code=0,
                output_tail="",
                preexisting=True,
            )
        )

    shard_started = time.monotonic()
    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = {
            executor.submit(
                run_target,
                shard_stem(shard),
                args.shard_timeout,
                False,
            ): shard
            for shard in missing_shards
        }
        for future in as_completed(futures):
            shard = futures[future]
            result = future.result()
            shard_measurements.append(result)
            print(
                f"CHECKER_SHARD_{shard:02d}={result.status} "
                f"elapsed={result.elapsed_seconds:.3f}s",
                flush=True,
            )
    checker_elapsed = time.monotonic() - shard_started
    shard_measurements.sort(key=lambda item: item.target)
    write_csv(SHARD_MEASUREMENTS_PATH, [asdict(item) for item in shard_measurements])
    failed_shards = [item for item in shard_measurements if item.exit_code != 0]
    if failed_shards:
        summary = {
            "verdict": "K11_REAL_LEAN_CHECKER_SHARD_BUILD_FAIL",
            "workers": args.workers,
            "max_shards": args.max_shards,
            "start_shard": args.start_shard,
            "attempt_all": args.attempt_all,
            "shard_timeout_seconds": args.shard_timeout,
            "preexisting_shard_count": len(preexisting_shards),
            "attempted_shard_count": len(missing_shards),
            "failed_shard_count": len(failed_shards),
            "checker_recovery_elapsed_seconds": round(checker_elapsed, 6),
            "free_disk_gib_at_start": round(free_disk_gib, 3),
        }
        SUMMARY_PATH.write_text(
            json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
        )
        print(json.dumps(summary, sort_keys=True))
        return 2

    if args.skip_post:
        summary = {
            "verdict": "K11_REAL_LEAN_CHECKER_SHARD_PILOT_PASS",
            "workers": args.workers,
            "max_shards": args.max_shards,
            "start_shard": args.start_shard,
            "attempt_all": args.attempt_all,
            "shard_timeout_seconds": args.shard_timeout,
            "preexisting_shard_count": len(preexisting_shards),
            "attempted_shard_count": len(missing_shards),
            "failed_shard_count": 0,
            "checker_recovery_elapsed_seconds": round(checker_elapsed, 6),
            "free_disk_gib_at_start": round(free_disk_gib, 3),
            "post_build_skipped": True,
            "lnt_certificate_declared": False,
            "k11_theorem_claimed": False,
            "global_collatz_claimed": False,
        }
        SUMMARY_PATH.write_text(
            json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
        )
        print(json.dumps(summary, sort_keys=True))
        return 0

    post_measurements: list[Measurement] = []
    group_started = time.monotonic()
    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = {
            executor.submit(
                run_target,
                group_stem(group),
                GROUP_TIMEOUT_SECONDS,
                olean_path(group_stem(group)).exists(),
            ): group
            for group in range(GROUP_COUNT)
        }
        for future in as_completed(futures):
            group = futures[future]
            result = future.result()
            post_measurements.append(result)
            print(
                f"GROUP_{group}={result.status} elapsed={result.elapsed_seconds:.3f}s",
                flush=True,
            )
    group_elapsed = time.monotonic() - group_started

    aggregate = run_target(
        "KL2003K11CertificateMatchAggregate",
        FINAL_TIMEOUT_SECONDS,
        olean_path("KL2003K11CertificateMatchAggregate").exists(),
    )
    post_measurements.append(aggregate)
    print(f"AGGREGATE={aggregate.status} elapsed={aggregate.elapsed_seconds:.3f}s", flush=True)
    audit = run_target(
        "KL2003K11CertificateMatchAggregateAxiomAudit",
        FINAL_TIMEOUT_SECONDS,
        olean_path("KL2003K11CertificateMatchAggregateAxiomAudit").exists(),
    )
    post_measurements.append(audit)
    print(f"AUDIT={audit.status} elapsed={audit.elapsed_seconds:.3f}s", flush=True)
    write_csv(POST_MEASUREMENTS_PATH, [asdict(item) for item in post_measurements])

    post_failures = [item for item in post_measurements if item.exit_code != 0]
    generated_oleans = sorted(LEAN_BUILD_DIR.glob("KL2003K11Certificate*.olean"))
    olean_bytes = sum(path.stat().st_size for path in generated_oleans)
    overall_elapsed = time.monotonic() - overall_started
    attempted_times = [
        item.elapsed_seconds for item in shard_measurements if not item.preexisting
    ]
    verdict = (
        "K11_REAL_LEAN_CHECKER_KERNEL_PASS_RESOURCE_COLD_RERUN_REQUIRED"
        if not post_failures
        else "K11_REAL_LEAN_CHECKER_POST_BUILD_FAIL"
    )
    summary = {
        "verdict": verdict,
        "workers": args.workers,
        "max_shards": args.max_shards,
        "start_shard": args.start_shard,
        "attempt_all": args.attempt_all,
        "shard_timeout_seconds": args.shard_timeout,
        "preexisting_shard_count": len(preexisting_shards),
        "attempted_shard_count": len(missing_shards),
        "checker_shard_pass_count": sum(
            item.exit_code == 0 for item in shard_measurements
        ),
        "failed_shard_count": len(failed_shards),
        "checker_recovery_elapsed_seconds": round(checker_elapsed, 6),
        "slowest_attempted_checker_seconds": max(attempted_times, default=0.0),
        "group_elapsed_seconds": round(group_elapsed, 6),
        "aggregate_elapsed_seconds": aggregate.elapsed_seconds,
        "audit_elapsed_seconds": audit.elapsed_seconds,
        "post_failure_count": len(post_failures),
        "controlled_recovery_total_seconds": round(overall_elapsed, 6),
        "generated_olean_count": len(generated_oleans),
        "generated_olean_bytes": olean_bytes,
        "free_disk_gib_at_start": round(free_disk_gib, 3),
        "rss_measurement": "UNAVAILABLE_IN_SANDBOX",
        "cold_resource_budget_status": "REQUIRES_CLEAN_CONTROLLED_RERUN",
        "all_rows_kernel_checked": not post_failures,
        "all_auxiliary_kernel_checked": not post_failures,
        "lnt_certificate_declared": False,
        "k11_theorem_claimed": False,
        "global_collatz_claimed": False,
    }
    SUMMARY_PATH.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    manifest_paths = [
        *generated_oleans,
        SHARD_MEASUREMENTS_PATH,
        POST_MEASUREMENTS_PATH,
        SUMMARY_PATH,
    ]
    with BUILD_MANIFEST_PATH.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256", "bytes"])
        writer.writeheader()
        for path in manifest_paths:
            writer.writerow(
                {
                    "path": str(path.resolve().relative_to(REPO_ROOT)),
                    "sha256": sha256(path),
                    "bytes": path.stat().st_size,
                }
            )
    print(json.dumps(summary, sort_keys=True))
    return 0 if not post_failures else 2


if __name__ == "__main__":
    raise SystemExit(main())
