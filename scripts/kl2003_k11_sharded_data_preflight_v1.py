#!/usr/bin/env python3
"""Test the budgeted 81-module k=11 synthetic data architecture."""

from __future__ import annotations

import csv
import hashlib
import json
import os
import shutil
import subprocess
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict, dataclass
from pathlib import Path

from kl2003_k11_preflight_architecture_gate_v1 import (
    AUXILIARY_SHARD_SIZE,
    DATA_CHUNK_SIZE,
    K11_AUXILIARY_COUNT,
    K11_PRINCIPAL_COUNT,
    MEMORY_FAIL_MIB,
    MEMORY_PASS_MIB,
    MIN_FREE_DISK_GIB,
    PRINCIPAL_SHARD_SIZE,
    REPO_ROOT,
    SHARD_COUNT,
    lean_rat,
    run_process,
    synthetic_value,
)


BUDGET_DOC = REPO_ROOT / "docs" / "KL2003_K11_HIERARCHICAL_PREFLIGHT_BUDGET_v1.md"
OUT_DIR = REPO_ROOT / "outputs" / "KL2003_K11_HIERARCHICAL_PREFLIGHT_v1"
SUMMARY_PATH = OUT_DIR / "preflight_summary.json"
MEASUREMENTS_PATH = OUT_DIR / "probe_measurements.csv"
DATA_SHARDS_PATH = OUT_DIR / "data_shard_measurements.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"


@dataclass
class Measurement:
    probe_id: str
    status: str
    elapsed_seconds: float
    peak_rss_mib: float | None
    exit_code: int
    source_bytes: int
    olean_bytes: int
    stdout_tail: str


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def local_match_def(name: str, start: int, count: int, family: int) -> str:
    definitions: list[str] = []
    chunk_count = (count + DATA_CHUNK_SIZE - 1) // DATA_CHUNK_SIZE
    for chunk in range(chunk_count):
        chunk_start = chunk * DATA_CHUNK_SIZE
        chunk_end = min(chunk_start + DATA_CHUNK_SIZE, count)
        equations = "\n".join(
            f"  | {local} => {lean_rat(synthetic_value(start + offset, family))}"
            for local, offset in enumerate(range(chunk_start, chunk_end))
        )
        definitions.append(
            f"def {name}Chunk{chunk} : Nat -> Rat\n"
            f"{equations}\n"
            "  | _ => 1"
        )
    router = "\n".join(
        f"  | {chunk} => {name}Chunk{chunk} (index % {DATA_CHUNK_SIZE})"
        for chunk in range(chunk_count)
    )
    definitions.append(
        f"def {name} (index : Nat) : Rat :=\n"
        f"  match index / {DATA_CHUNK_SIZE} with\n"
        f"{router}\n"
        "  | _ => 1"
    )
    return "\n\n".join(definitions)


def base_source() -> str:
    return f'''import Mathlib.Data.Rat.Defs

namespace KL2003K11ShardedDataPreflight

def K11RowValid (index : Nat) : Prop := index < {K11_PRINCIPAL_COUNT}
def K11AuxiliaryValid (index : Nat) : Prop := index < {K11_AUXILIARY_COUNT}

end KL2003K11ShardedDataPreflight
'''


def data_shard_source(shard: int) -> str:
    principal_start = shard * PRINCIPAL_SHARD_SIZE
    auxiliary_start = shard * AUXILIARY_SHARD_SIZE
    return f'''import KL2003K11ShardedDataPreflight.Base

namespace KL2003K11ShardedDataPreflight.DataShard{shard}

{local_match_def("principalAtLocal", principal_start, PRINCIPAL_SHARD_SIZE, 0)}

{local_match_def("auxiliaryAtLocal", auxiliary_start, AUXILIARY_SHARD_SIZE, 1)}

{local_match_def("rowSlackAtLocal", principal_start, PRINCIPAL_SHARD_SIZE, 2)}

end KL2003K11ShardedDataPreflight.DataShard{shard}
'''


def data_router_source() -> str:
    imports = "\n".join(
        f"import KL2003K11ShardedDataPreflight.DataShard{shard}"
        for shard in range(SHARD_COUNT)
    )

    def router(name: str, size: int) -> str:
        cases = "\n".join(
            f"  | {shard} => DataShard{shard}.{name}Local (index % {size})"
            for shard in range(SHARD_COUNT)
        )
        return (
            f"def {name} (index : Nat) : Rat :=\n"
            f"  match index / {size} with\n"
            f"{cases}\n"
            "  | _ => 1"
        )

    return f'''{imports}

namespace KL2003K11ShardedDataPreflight

{router("principalAt", PRINCIPAL_SHARD_SIZE)}
{router("auxiliaryAt", AUXILIARY_SHARD_SIZE)}
{router("rowSlackAt", PRINCIPAL_SHARD_SIZE)}

end KL2003K11ShardedDataPreflight
'''


def consumer_source() -> str:
    expected_principal = lean_rat(synthetic_value(59048, 0))
    expected_auxiliary = lean_rat(synthetic_value(19682, 1))
    expected_slack = lean_rat(synthetic_value(59048, 2))
    return f'''import KL2003K11ShardedDataPreflight.DataRouter
import Mathlib.Tactic.NormNum

namespace KL2003K11ShardedDataPreflight

theorem principalLastLinked : principalAt 59048 = {expected_principal} := by
  norm_num [principalAt, DataShard80.principalAtLocal,
    DataShard80.principalAtLocalChunk26]

theorem auxiliaryLastLinked : auxiliaryAt 19682 = {expected_auxiliary} := by
  norm_num [auxiliaryAt, DataShard80.auxiliaryAtLocal,
    DataShard80.auxiliaryAtLocalChunk8]

theorem slackLastLinked : rowSlackAt 59048 = {expected_slack} := by
  norm_num [rowSlackAt, DataShard80.rowSlackAtLocal,
    DataShard80.rowSlackAtLocalChunk26]

end KL2003K11ShardedDataPreflight
'''


def interface_source(shard: int) -> str:
    row_start = shard * PRINCIPAL_SHARD_SIZE
    row_end = row_start + PRINCIPAL_SHARD_SIZE
    auxiliary_start = shard * AUXILIARY_SHARD_SIZE
    auxiliary_end = auxiliary_start + AUXILIARY_SHARD_SIZE
    return f'''import KL2003K11ShardedDataPreflight.Base

namespace KL2003K11ShardedDataPreflight

theorem rowsShard{shard} (index : Nat)
    (hlo : {row_start} <= index) (hhi : index < {row_end}) :
    K11RowValid index := by
  exact lt_of_lt_of_le hhi (by decide)

theorem auxiliaryShard{shard} (index : Nat)
    (hlo : {auxiliary_start} <= index) (hhi : index < {auxiliary_end}) :
    K11AuxiliaryValid index := by
  exact lt_of_lt_of_le hhi (by decide)

end KL2003K11ShardedDataPreflight
'''


def group_source(group: int) -> str:
    first = group * 9
    imports = "\n".join(
        f"import KL2003K11ShardedDataPreflight.Interface{shard}"
        for shard in range(first, first + 9)
    )
    row_lines: list[str] = []
    auxiliary_lines: list[str] = []
    for offset in range(8):
        shard = first + offset
        row_lower = "hlo" if offset == 0 else f"Nat.le_of_not_gt h{offset - 1}"
        auxiliary_lower = (
            "hlo" if offset == 0 else f"Nat.le_of_not_gt ha{offset - 1}"
        )
        row_lines.extend(
            [
                f"  by_cases h{offset} : index < {(shard + 1) * PRINCIPAL_SHARD_SIZE}",
                f"  · exact rowsShard{shard} index ({row_lower}) h{offset}",
            ]
        )
        auxiliary_lines.extend(
            [
                f"  by_cases ha{offset} : index < {(shard + 1) * AUXILIARY_SHARD_SIZE}",
                f"  · exact auxiliaryShard{shard} index ({auxiliary_lower}) ha{offset}",
            ]
        )
    last = first + 8
    row_start = first * PRINCIPAL_SHARD_SIZE
    row_end = (last + 1) * PRINCIPAL_SHARD_SIZE
    auxiliary_start = first * AUXILIARY_SHARD_SIZE
    auxiliary_end = (last + 1) * AUXILIARY_SHARD_SIZE
    return f'''{imports}

namespace KL2003K11ShardedDataPreflight

theorem rowsGroup{group} (index : Nat)
    (hlo : {row_start} <= index) (hhi : index < {row_end}) :
    K11RowValid index := by
{chr(10).join(row_lines)}
  exact rowsShard{last} index (Nat.le_of_not_gt h7) hhi

theorem auxiliaryGroup{group} (index : Nat)
    (hlo : {auxiliary_start} <= index) (hhi : index < {auxiliary_end}) :
    K11AuxiliaryValid index := by
{chr(10).join(auxiliary_lines)}
  exact auxiliaryShard{last} index (Nat.le_of_not_gt ha7) hhi

end KL2003K11ShardedDataPreflight
'''


def aggregate_source() -> str:
    imports = ["import KL2003K11ShardedDataPreflight.DataRouter"]
    imports.extend(
        f"import KL2003K11ShardedDataPreflight.Group{group}"
        for group in range(9)
    )
    row_lines: list[str] = []
    auxiliary_lines: list[str] = []
    for group in range(8):
        row_lower = "Nat.zero_le index" if group == 0 else f"Nat.le_of_not_gt h{group - 1}"
        auxiliary_lower = (
            "Nat.zero_le index" if group == 0 else f"Nat.le_of_not_gt ha{group - 1}"
        )
        row_lines.extend(
            [
                f"  by_cases h{group} : index < {(group + 1) * 9 * PRINCIPAL_SHARD_SIZE}",
                f"  · exact rowsGroup{group} index ({row_lower}) h{group}",
            ]
        )
        auxiliary_lines.extend(
            [
                f"  by_cases ha{group} : index < {(group + 1) * 9 * AUXILIARY_SHARD_SIZE}",
                f"  · exact auxiliaryGroup{group} index ({auxiliary_lower}) ha{group}",
            ]
        )
    return f'''{chr(10).join(imports)}

namespace KL2003K11ShardedDataPreflight

theorem allRowsValid (index : Nat) (hindex : index < {K11_PRINCIPAL_COUNT}) :
    K11RowValid index := by
{chr(10).join(row_lines)}
  exact rowsGroup8 index (Nat.le_of_not_gt h7) hindex

theorem allAuxiliaryValid (index : Nat)
    (hindex : index < {K11_AUXILIARY_COUNT}) :
    K11AuxiliaryValid index := by
{chr(10).join(auxiliary_lines)}
  exact auxiliaryGroup8 index (Nat.le_of_not_gt ha7) hindex

end KL2003K11ShardedDataPreflight
'''


def classify(
    code: int,
    elapsed: float,
    peak_mib: float | None,
    pass_seconds: float,
    fail_seconds: float,
) -> str:
    if code != 0 or elapsed > fail_seconds:
        return "ARCHITECTURE_FAIL"
    if peak_mib is not None and peak_mib > MEMORY_FAIL_MIB:
        return "ARCHITECTURE_FAIL"
    if elapsed > pass_seconds:
        return "OPTIMIZATION_REQUIRED"
    if peak_mib is not None and peak_mib > MEMORY_PASS_MIB:
        return "OPTIMIZATION_REQUIRED"
    return "PASS"


def compile_module(
    probe_id: str,
    lean: str,
    source: Path,
    olean: Path,
    root: Path,
    env: dict[str, str],
    pass_seconds: float,
    fail_seconds: float,
) -> Measurement:
    olean.parent.mkdir(parents=True, exist_ok=True)
    code, elapsed, peak_mib, output = run_process(
        [lean, f"--root={root}", "-o", str(olean), str(source)],
        env=env,
        timeout_seconds=fail_seconds,
    )
    return Measurement(
        probe_id=probe_id,
        status=classify(code, elapsed, peak_mib, pass_seconds, fail_seconds),
        elapsed_seconds=round(elapsed, 6),
        peak_rss_mib=None if peak_mib is None else round(peak_mib, 3),
        exit_code=code,
        source_bytes=source.stat().st_size,
        olean_bytes=olean.stat().st_size if olean.exists() else 0,
        stdout_tail=output[-2000:],
    )


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    disk = shutil.disk_usage(REPO_ROOT)
    free_disk_gib = disk.free / (1024**3)
    if free_disk_gib < MIN_FREE_DISK_GIB:
        raise RuntimeError(f"only {free_disk_gib:.2f} GiB free")

    lean = subprocess.run(
        ["lake", "env", "which", "lean"], cwd=REPO_ROOT, check=True,
        capture_output=True, text=True,
    ).stdout.strip()
    lean_path = subprocess.run(
        ["lake", "env", "printenv", "LEAN_PATH"], cwd=REPO_ROOT, check=True,
        capture_output=True, text=True,
    ).stdout.strip()

    started = time.monotonic()
    measurements: list[Measurement] = []
    shard_rows: list[dict[str, object]] = []
    source_hashes: dict[str, str] = {}
    generated_source_bytes = 0
    generated_olean_bytes = 0

    with tempfile.TemporaryDirectory(prefix="kl2003_k11_sharded_", dir="/tmp") as temp:
        root = Path(temp)
        source_root = root / "lean_src"
        build_root = root / "lean_build"
        source_modules = source_root / "KL2003K11ShardedDataPreflight"
        build_modules = build_root / "KL2003K11ShardedDataPreflight"
        source_modules.mkdir(parents=True)
        build_modules.mkdir(parents=True)
        env = os.environ.copy()
        env["LEAN_PATH"] = f"{build_root}:{lean_path}"

        base = source_modules / "Base.lean"
        base.write_text(base_source(), encoding="utf-8")
        source_hashes[base.name] = sha256(base)
        base_result = compile_module(
            "K11_SHARDED_DATA_BASE", lean, base, build_modules / "Base.olean",
            source_root, env, 60.0, 120.0,
        )
        measurements.append(base_result)
        if base_result.exit_code != 0:
            raise RuntimeError(base_result.stdout_tail)

        data_sources: list[Path] = []
        for shard in range(SHARD_COUNT):
            path = source_modules / f"DataShard{shard}.lean"
            path.write_text(data_shard_source(shard), encoding="utf-8")
            source_hashes[path.name] = sha256(path)
            data_sources.append(path)

        shard_started = time.monotonic()
        with ThreadPoolExecutor(max_workers=3) as executor:
            futures = {
                executor.submit(
                    compile_module,
                    f"DATA_SHARD_{shard}", lean, path,
                    build_modules / f"DataShard{shard}.olean", source_root, env,
                    120.0, 180.0,
                ): shard
                for shard, path in enumerate(data_sources)
            }
            for future in as_completed(futures):
                shard = futures[future]
                result = future.result()
                shard_rows.append({"shard": shard, **asdict(result)})
                if result.exit_code != 0:
                    print(f"DATA_SHARD_{shard}=FAIL", flush=True)
        data_shards_elapsed = time.monotonic() - shard_started
        shard_rows.sort(key=lambda row: int(row["shard"]))
        data_shards_failed = any(int(row["exit_code"]) != 0 for row in shard_rows)
        slowest_shard = max(float(row["elapsed_seconds"]) for row in shard_rows)
        max_shard_rss = max(
            (float(row["peak_rss_mib"]) for row in shard_rows if row["peak_rss_mib"] is not None),
            default=None,
        )
        data_shards_status = classify(
            1 if data_shards_failed else 0,
            data_shards_elapsed,
            max_shard_rss,
            600.0,
            900.0,
        )
        if slowest_shard > 180.0:
            data_shards_status = "ARCHITECTURE_FAIL"
        elif slowest_shard > 120.0 and data_shards_status == "PASS":
            data_shards_status = "OPTIMIZATION_REQUIRED"
        data_shards_measurement = Measurement(
            probe_id="K11_81_DATA_SHARDS",
            status=data_shards_status,
            elapsed_seconds=round(data_shards_elapsed, 6),
            peak_rss_mib=None if max_shard_rss is None else round(max_shard_rss, 3),
            exit_code=1 if data_shards_failed else 0,
            source_bytes=sum(path.stat().st_size for path in data_sources),
            olean_bytes=sum(
                (build_modules / f"DataShard{shard}.olean").stat().st_size
                for shard in range(SHARD_COUNT)
                if (build_modules / f"DataShard{shard}.olean").exists()
            ),
            stdout_tail=f"slowest_shard_seconds={slowest_shard:.6f}",
        )
        measurements.append(data_shards_measurement)
        print(
            f"K11_81_DATA_SHARDS={data_shards_status} "
            f"elapsed={data_shards_elapsed:.3f}s slowest={slowest_shard:.3f}s",
            flush=True,
        )

        if data_shards_failed:
            raise RuntimeError("one or more data shards failed")

        router = source_modules / "DataRouter.lean"
        router.write_text(data_router_source(), encoding="utf-8")
        source_hashes[router.name] = sha256(router)
        router_result = compile_module(
            "K11_GLOBAL_DATA_ROUTER", lean, router,
            build_modules / "DataRouter.olean", source_root, env, 180.0, 300.0,
        )
        measurements.append(router_result)
        print(
            f"{router_result.probe_id}={router_result.status} "
            f"elapsed={router_result.elapsed_seconds}s",
            flush=True,
        )
        if router_result.exit_code != 0:
            raise RuntimeError(router_result.stdout_tail)

        consumer = source_modules / "Consumer.lean"
        consumer.write_text(consumer_source(), encoding="utf-8")
        source_hashes[consumer.name] = sha256(consumer)
        consumer_result = compile_module(
            "K11_ROUTER_IMPORT_CONSUMER", lean, consumer,
            build_modules / "Consumer.olean", source_root, env, 180.0, 300.0,
        )
        measurements.append(consumer_result)
        print(
            f"{consumer_result.probe_id}={consumer_result.status} "
            f"elapsed={consumer_result.elapsed_seconds}s",
            flush=True,
        )
        if consumer_result.exit_code != 0:
            raise RuntimeError(consumer_result.stdout_tail)

        interface_sources: list[Path] = []
        for shard in range(SHARD_COUNT):
            path = source_modules / f"Interface{shard}.lean"
            path.write_text(interface_source(shard), encoding="utf-8")
            source_hashes[path.name] = sha256(path)
            interface_sources.append(path)
        interface_started = time.monotonic()
        with ThreadPoolExecutor(max_workers=3) as executor:
            futures = [
                executor.submit(
                    compile_module,
                    f"INTERFACE_{shard}", lean, path,
                    build_modules / f"Interface{shard}.olean", source_root, env,
                    60.0, 120.0,
                )
                for shard, path in enumerate(interface_sources)
            ]
            interface_results = [future.result() for future in as_completed(futures)]
        interface_elapsed = time.monotonic() - interface_started
        interface_failures = [
            result for result in interface_results if result.exit_code != 0
        ]
        if interface_failures:
            details = " | ".join(
                f"{result.probe_id}: {result.stdout_tail}"
                for result in interface_failures[:3]
            )
            raise RuntimeError("one or more interface modules failed: " + details)
        interface_peak = max(
            (
                result.peak_rss_mib
                for result in interface_results
                if result.peak_rss_mib is not None
            ),
            default=None,
        )
        interface_measurement = Measurement(
            probe_id="K11_81_CHECKER_INTERFACES",
            status=classify(0, interface_elapsed, interface_peak, 300.0, 450.0),
            elapsed_seconds=round(interface_elapsed, 6),
            peak_rss_mib=interface_peak,
            exit_code=0,
            source_bytes=sum(path.stat().st_size for path in interface_sources),
            olean_bytes=sum(
                (build_modules / f"Interface{shard}.olean").stat().st_size
                for shard in range(SHARD_COUNT)
            ),
            stdout_tail="",
        )
        measurements.append(interface_measurement)
        print(
            f"{interface_measurement.probe_id}={interface_measurement.status} "
            f"elapsed={interface_measurement.elapsed_seconds}s",
            flush=True,
        )

        group_sources: list[Path] = []
        for group in range(9):
            path = source_modules / f"Group{group}.lean"
            path.write_text(group_source(group), encoding="utf-8")
            source_hashes[path.name] = sha256(path)
            group_sources.append(path)
        group_started = time.monotonic()
        with ThreadPoolExecutor(max_workers=3) as executor:
            futures = [
                executor.submit(
                    compile_module,
                    f"GROUP_{group}", lean, path,
                    build_modules / f"Group{group}.olean", source_root, env,
                    60.0, 120.0,
                )
                for group, path in enumerate(group_sources)
            ]
            group_results = [future.result() for future in as_completed(futures)]
        group_elapsed = time.monotonic() - group_started
        group_failures = [result for result in group_results if result.exit_code != 0]
        if group_failures:
            details = " | ".join(
                f"{result.probe_id}: {result.stdout_tail}"
                for result in group_failures[:3]
            )
            raise RuntimeError("one or more group modules failed: " + details)
        group_peak = max(
            (
                result.peak_rss_mib
                for result in group_results
                if result.peak_rss_mib is not None
            ),
            default=None,
        )
        group_measurement = Measurement(
            probe_id="K11_NINE_GROUP_DISPATCHERS",
            status=classify(0, group_elapsed, group_peak, 180.0, 300.0),
            elapsed_seconds=round(group_elapsed, 6),
            peak_rss_mib=group_peak,
            exit_code=0,
            source_bytes=sum(path.stat().st_size for path in group_sources),
            olean_bytes=sum(
                (build_modules / f"Group{group}.olean").stat().st_size
                for group in range(9)
            ),
            stdout_tail="",
        )
        measurements.append(group_measurement)
        print(
            f"{group_measurement.probe_id}={group_measurement.status} "
            f"elapsed={group_measurement.elapsed_seconds}s",
            flush=True,
        )

        aggregate = source_modules / "Aggregate.lean"
        aggregate.write_text(aggregate_source(), encoding="utf-8")
        source_hashes[aggregate.name] = sha256(aggregate)
        aggregate_result = compile_module(
            "K11_TOP_NINE_GROUP_AGGREGATE", lean, aggregate,
            build_modules / "Aggregate.olean", source_root, env, 180.0, 300.0,
        )
        measurements.append(aggregate_result)
        print(
            f"{aggregate_result.probe_id}={aggregate_result.status} "
            f"elapsed={aggregate_result.elapsed_seconds}s",
            flush=True,
        )

        generated_source_bytes = sum(path.stat().st_size for path in source_root.rglob("*.lean"))
        generated_olean_bytes = sum(path.stat().st_size for path in build_root.rglob("*.olean"))

    total_elapsed = time.monotonic() - started
    statuses = {measurement.status for measurement in measurements}
    if "ARCHITECTURE_FAIL" in statuses or total_elapsed > 1500.0:
        verdict = "K11_HIERARCHICAL_PREFLIGHT_ARCHITECTURE_FAIL"
    elif "OPTIMIZATION_REQUIRED" in statuses or total_elapsed > 1200.0:
        verdict = "K11_HIERARCHICAL_PREFLIGHT_OPTIMIZATION_REQUIRED"
    else:
        verdict = "K11_HIERARCHICAL_PREFLIGHT_PASS"

    write_csv(
        MEASUREMENTS_PATH,
        [asdict(measurement) for measurement in measurements],
        list(asdict(measurements[0]).keys()),
    )
    write_csv(
        DATA_SHARDS_PATH,
        shard_rows,
        list(shard_rows[0].keys()),
    )
    summary = {
        "verdict": verdict,
        "budget_doc": str(BUDGET_DOC.relative_to(REPO_ROOT)),
        "budget_doc_sha256": sha256(BUDGET_DOC),
        "git_head": subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=REPO_ROOT, check=True,
            capture_output=True, text=True,
        ).stdout.strip(),
        "architecture": {
            "data_shard_count": SHARD_COUNT,
            "principal_per_shard": PRINCIPAL_SHARD_SIZE,
            "auxiliary_per_shard": AUXILIARY_SHARD_SIZE,
            "slacks_per_shard": PRINCIPAL_SHARD_SIZE,
            "chunk_size": DATA_CHUNK_SIZE,
        },
        "measurements": [asdict(measurement) for measurement in measurements],
        "slowest_data_shard_seconds": slowest_shard,
        "total_elapsed_seconds": round(total_elapsed, 6),
        "free_disk_gib_at_start": round(free_disk_gib, 3),
        "temporary_source_bytes": generated_source_bytes,
        "temporary_olean_bytes": generated_olean_bytes,
        "source_sha256": source_hashes,
        "synthetic_sources_retained": False,
        "real_k11_certificate_generated": False,
        "k11_theorem_claimed": False,
        "global_collatz_claimed": False,
    }
    SUMMARY_PATH.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")

    manifest_paths = [BUDGET_DOC, Path(__file__), SUMMARY_PATH, MEASUREMENTS_PATH, DATA_SHARDS_PATH]
    write_csv(
        MANIFEST_PATH,
        [
            {
                "path": str(path.relative_to(REPO_ROOT)),
                "sha256": sha256(path),
                "bytes": path.stat().st_size,
            }
            for path in sorted(manifest_paths)
        ],
        ["path", "sha256", "bytes"],
    )
    print(verdict)
    print(f"total_elapsed_seconds={total_elapsed:.6f}")
    return 0 if verdict == "K11_HIERARCHICAL_PREFLIGHT_PASS" else 2


if __name__ == "__main__":
    raise SystemExit(main())
