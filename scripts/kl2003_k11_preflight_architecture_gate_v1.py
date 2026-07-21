#!/usr/bin/env python3
"""Measure the three k=11 architecture probes fixed by the preflight budget."""

from __future__ import annotations

import csv
import hashlib
import json
import os
import shutil
import subprocess
import tempfile
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict, dataclass
from fractions import Fraction
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
BUDGET_DOC = (
    REPO_ROOT
    / "docs"
    / "KL2003_K11_PREFLIGHT_BUDGET_AND_ARCHITECTURE_GATE_v1.md"
)
OUT_DIR = REPO_ROOT / "outputs" / "KL2003_K11_PREFLIGHT_ARCHITECTURE_GATE_v1"
SUMMARY_PATH = OUT_DIR / "preflight_summary.json"
MEASUREMENTS_PATH = OUT_DIR / "probe_measurements.csv"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

K11_PRINCIPAL_COUNT = 3**10
K11_AUXILIARY_COUNT = 3**9
PRINCIPAL_SHARD_SIZE = 729
AUXILIARY_SHARD_SIZE = 243
DATA_CHUNK_SIZE = 27
SHARD_COUNT = 81

PREFLIGHT_TOTAL_PASS_SECONDS = 900.0
PREFLIGHT_TOTAL_FAIL_SECONDS = 1200.0
MEMORY_PASS_MIB = 4096.0
MEMORY_FAIL_MIB = 6144.0
MIN_FREE_DISK_GIB = 12.0


@dataclass(frozen=True)
class ProbeBudget:
    pass_seconds: float
    fail_seconds: float


@dataclass
class ProbeResult:
    probe_id: str
    status: str
    elapsed_seconds: float
    peak_rss_mib: float | None
    exit_code: int
    source_bytes: int
    olean_bytes: int
    stdout_tail: str


BUDGETS = {
    "K11_CHUNKED_DATA_PROBE": ProbeBudget(300.0, 450.0),
    "K11_REPRESENTATIVE_SHARD_PROBE": ProbeBudget(450.0, 600.0),
    "K11_81_SHARD_AGGREGATE_PROBE": ProbeBudget(180.0, 300.0),
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def lean_rat(value: Fraction) -> str:
    return f"({value.numerator} / {value.denominator} : Rat)"


def synthetic_value(index: int, family: int) -> Fraction:
    if family == 2:
        numerator = 10**22 + 104729 * index + 7919
        denominator = 10**30 + 13007 * index + 104723
    else:
        numerator = 10**7 + 1009 * index + 97 * family
        denominator = 10**8 + 1013 * index + 193 * family
    return Fraction(numerator, denominator)


def match_def(
    name: str,
    count: int,
    shard_size: int,
    family: int,
) -> str:
    definitions: list[str] = []
    chunk_count = (count + DATA_CHUNK_SIZE - 1) // DATA_CHUNK_SIZE
    for chunk_index in range(chunk_count):
        start = chunk_index * DATA_CHUNK_SIZE
        end = min(start + DATA_CHUNK_SIZE, count)
        equations = "\n".join(
            f"  | {local} => {lean_rat(synthetic_value(index, family))}"
            for local, index in enumerate(range(start, end))
        )
        definitions.append(
            f"def {name}Chunk{chunk_index} : Nat -> Rat\n"
            f"{equations}\n"
            "  | _ => 1"
        )

    chunks_per_shard = shard_size // DATA_CHUNK_SIZE
    shard_count = (count + shard_size - 1) // shard_size
    for shard in range(shard_count):
        first_chunk = shard * chunks_per_shard
        local_chunk_count = min(chunks_per_shard, chunk_count - first_chunk)
        router = "\n".join(
            f"  | {local} => {name}Chunk{first_chunk + local} "
            f"(index % {DATA_CHUNK_SIZE})"
            for local in range(local_chunk_count)
        )
        definitions.append(
            f"def {name}Shard{shard} (index : Nat) : Rat :=\n"
            f"  match index / {DATA_CHUNK_SIZE} with\n"
            f"{router}\n"
            "  | _ => 1"
        )

    router = "\n".join(
        f"  | {shard} => {name}Shard{shard} (index % {shard_size})"
        for shard in range(shard_count)
    )
    definitions.append(
        f"def {name} (index : Nat) : Rat :=\n"
        f"  match index / {shard_size} with\n"
        f"{router}\n"
        "  | _ => 1"
    )
    return "\n\n".join(definitions)


def data_source() -> str:
    return f'''import Mathlib.Data.Rat.Defs

namespace KL2003K11Preflight

{match_def("principalAt", K11_PRINCIPAL_COUNT, PRINCIPAL_SHARD_SIZE, 0)}

{match_def("auxiliaryAt", K11_AUXILIARY_COUNT, AUXILIARY_SHARD_SIZE, 1)}

{match_def("rowSlackAt", K11_PRINCIPAL_COUNT, PRINCIPAL_SHARD_SIZE, 2)}

def K11RowValid (index : Nat) : Prop := index < {K11_PRINCIPAL_COUNT}
def K11AuxiliaryValid (index : Nat) : Prop := index < {K11_AUXILIARY_COUNT}

end KL2003K11Preflight
'''


def shard_source(shard: int) -> str:
    row_start = shard * PRINCIPAL_SHARD_SIZE
    row_end = row_start + PRINCIPAL_SHARD_SIZE
    auxiliary_start = shard * AUXILIARY_SHARD_SIZE
    auxiliary_end = auxiliary_start + AUXILIARY_SHARD_SIZE
    return f'''import KL2003K11Preflight.Data
import Mathlib.Tactic.Omega

namespace KL2003K11Preflight

theorem rowsShard{shard} (index : Nat)
    (hlo : {row_start} <= index) (hhi : index < {row_end}) :
    K11RowValid index := by
  exact lt_of_lt_of_le hhi (by omega)

theorem auxiliaryShard{shard} (index : Nat)
    (hlo : {auxiliary_start} <= index) (hhi : index < {auxiliary_end}) :
    K11AuxiliaryValid index := by
  exact lt_of_lt_of_le hhi (by omega)

end KL2003K11Preflight
'''


def aggregate_source() -> str:
    imports = "\n".join(
        f"import KL2003K11Preflight.Shard{shard}"
        for shard in range(SHARD_COUNT)
    )
    row_cases = "\n".join(
        f"  by_cases h{shard} : index < {(shard + 1) * PRINCIPAL_SHARD_SIZE}\n"
        f"  · exact rowsShard{shard} index (by omega) h{shard}"
        for shard in range(SHARD_COUNT - 1)
    )
    auxiliary_cases = "\n".join(
        f"  by_cases h{shard} : index < {(shard + 1) * AUXILIARY_SHARD_SIZE}\n"
        f"  · exact auxiliaryShard{shard} index (by omega) h{shard}"
        for shard in range(SHARD_COUNT - 1)
    )
    return f'''{imports}

namespace KL2003K11Preflight

theorem allRowsValid (index : Nat) (hindex : index < {K11_PRINCIPAL_COUNT}) :
    K11RowValid index := by
{row_cases}
  exact rowsShard80 index (by omega) hindex

theorem allAuxiliaryValid (index : Nat)
    (hindex : index < {K11_AUXILIARY_COUNT}) :
    K11AuxiliaryValid index := by
{auxiliary_cases}
  exact auxiliaryShard80 index (by omega) hindex

end KL2003K11Preflight
'''


def peak_rss_kib(pid: int) -> int | None:
    try:
        result = subprocess.run(
            ["ps", "-o", "rss=", "-p", str(pid)],
            check=False,
            capture_output=True,
            text=True,
        )
        text = result.stdout.strip()
        return int(text) if text else None
    except (OSError, ValueError):
        return None


def run_process(
    command: list[str],
    *,
    env: dict[str, str],
    timeout_seconds: float,
) -> tuple[int, float, float | None, str]:
    started = time.monotonic()
    process = subprocess.Popen(
        command,
        cwd=REPO_ROOT,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    peak_kib: int | None = None
    timed_out = False
    while process.poll() is None:
        sample = peak_rss_kib(process.pid)
        if sample is not None:
            peak_kib = sample if peak_kib is None else max(peak_kib, sample)
        if time.monotonic() - started > timeout_seconds:
            timed_out = True
            process.kill()
            break
        time.sleep(0.2)
    output, _ = process.communicate()
    elapsed = time.monotonic() - started
    code = 124 if timed_out else process.returncode
    peak_mib = None if peak_kib is None else peak_kib / 1024.0
    return code, elapsed, peak_mib, output


def classify(probe_id: str, code: int, elapsed: float, peak_mib: float | None) -> str:
    if code != 0:
        return "ARCHITECTURE_FAIL"
    budget = BUDGETS[probe_id]
    if elapsed > budget.fail_seconds:
        return "ARCHITECTURE_FAIL"
    if peak_mib is not None and peak_mib > MEMORY_FAIL_MIB:
        return "ARCHITECTURE_FAIL"
    if elapsed > budget.pass_seconds:
        return "OPTIMIZATION_REQUIRED"
    if peak_mib is not None and peak_mib > MEMORY_PASS_MIB:
        return "OPTIMIZATION_REQUIRED"
    return "PASS"


def compile_probe(
    probe_id: str,
    lean: str,
    source: Path,
    olean: Path,
    root: Path,
    env: dict[str, str],
) -> ProbeResult:
    olean.parent.mkdir(parents=True, exist_ok=True)
    budget = BUDGETS[probe_id]
    code, elapsed, peak_mib, output = run_process(
        [lean, f"--root={root}", "-o", str(olean), str(source)],
        env=env,
        timeout_seconds=budget.fail_seconds,
    )
    status = classify(probe_id, code, elapsed, peak_mib)
    return ProbeResult(
        probe_id=probe_id,
        status=status,
        elapsed_seconds=round(elapsed, 6),
        peak_rss_mib=None if peak_mib is None else round(peak_mib, 3),
        exit_code=code,
        source_bytes=source.stat().st_size,
        olean_bytes=olean.stat().st_size if olean.exists() else 0,
        stdout_tail=output[-2000:],
    )


def compile_stub(
    lean: str,
    source: Path,
    olean: Path,
    root: Path,
    env: dict[str, str],
) -> tuple[int, float, float | None, str]:
    olean.parent.mkdir(parents=True, exist_ok=True)
    return run_process(
        [lean, f"--root={root}", "-o", str(olean), str(source)],
        env=env,
        timeout_seconds=180.0,
    )


def write_manifest(paths: list[Path]) -> None:
    with MANIFEST_PATH.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256", "bytes"])
        writer.writeheader()
        for path in sorted(paths):
            writer.writerow(
                {
                    "path": str(path.relative_to(REPO_ROOT)),
                    "sha256": sha256(path),
                    "bytes": path.stat().st_size,
                }
            )


def blocked_result(probe_id: str, reason: str) -> ProbeResult:
    return ProbeResult(
        probe_id=probe_id,
        status="BLOCKED_BY_DEPENDENCY",
        elapsed_seconds=0.0,
        peak_rss_mib=None,
        exit_code=-2,
        source_bytes=0,
        olean_bytes=0,
        stdout_tail=reason,
    )


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    disk = shutil.disk_usage(REPO_ROOT)
    free_disk_gib = disk.free / (1024**3)
    if free_disk_gib < MIN_FREE_DISK_GIB:
        raise RuntimeError(
            f"preflight requires {MIN_FREE_DISK_GIB} GiB free; found {free_disk_gib:.2f}"
        )

    lean = subprocess.run(
        ["lake", "env", "which", "lean"],
        cwd=REPO_ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    lean_path = subprocess.run(
        ["lake", "env", "printenv", "LEAN_PATH"],
        cwd=REPO_ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()

    started = time.monotonic()
    results: list[ProbeResult] = []
    setup_elapsed = 0.0
    setup_peak_mib: float | None = None
    generated_source_bytes = 0
    generated_olean_bytes = 0
    source_hashes: dict[str, str] = {}

    with tempfile.TemporaryDirectory(prefix="kl2003_k11_preflight_", dir="/tmp") as temp:
        temp_root = Path(temp)
        source_root = temp_root / "lean_src"
        build_root = temp_root / "lean_build"
        module_source = source_root / "KL2003K11Preflight"
        module_build = build_root / "KL2003K11Preflight"
        module_source.mkdir(parents=True)
        module_build.mkdir(parents=True)

        data_path = module_source / "Data.lean"
        data_path.write_text(data_source(), encoding="utf-8")
        source_hashes["Data.lean"] = sha256(data_path)

        generated_env = os.environ.copy()
        generated_env["LEAN_PATH"] = f"{build_root}:{lean_path}"
        data_result = compile_probe(
            "K11_CHUNKED_DATA_PROBE",
            lean,
            data_path,
            module_build / "Data.olean",
            source_root,
            generated_env,
        )
        results.append(data_result)
        print(
            f"{data_result.probe_id}={data_result.status} "
            f"elapsed={data_result.elapsed_seconds}s "
            f"peak_rss_mib={data_result.peak_rss_mib} "
            f"exit_code={data_result.exit_code}",
            flush=True,
        )

        actual_shard = (
            REPO_ROOT
            / "CollatzClassical"
            / "KL2003"
            / "KL2003K9CertificateMatchShard0.lean"
        )
        actual_env = os.environ.copy()
        actual_env["LEAN_PATH"] = lean_path
        shard_result = compile_probe(
            "K11_REPRESENTATIVE_SHARD_PROBE",
            lean,
            actual_shard,
            temp_root / "K9RepresentativeShard.olean",
            REPO_ROOT,
            actual_env,
        )
        results.append(shard_result)
        print(
            f"{shard_result.probe_id}={shard_result.status} "
            f"elapsed={shard_result.elapsed_seconds}s "
            f"peak_rss_mib={shard_result.peak_rss_mib} "
            f"exit_code={shard_result.exit_code}",
            flush=True,
        )

        if data_result.exit_code == 0:
            shard_sources: list[Path] = []
            for shard in range(SHARD_COUNT):
                path = module_source / f"Shard{shard}.lean"
                path.write_text(shard_source(shard), encoding="utf-8")
                source_hashes[path.name] = sha256(path)
                shard_sources.append(path)

            setup_started = time.monotonic()
            setup_lock = threading.Lock()
            setup_errors: list[str] = []
            with ThreadPoolExecutor(max_workers=3) as executor:
                futures = {
                    executor.submit(
                        compile_stub,
                        lean,
                        path,
                        module_build / f"Shard{shard}.olean",
                        source_root,
                        generated_env,
                    ): shard
                    for shard, path in enumerate(shard_sources)
                }
                for future in as_completed(futures):
                    shard = futures[future]
                    code, _, peak_mib, output = future.result()
                    with setup_lock:
                        if peak_mib is not None:
                            setup_peak_mib = (
                                peak_mib
                                if setup_peak_mib is None
                                else max(setup_peak_mib, peak_mib)
                            )
                        if code != 0:
                            setup_errors.append(f"Shard{shard}: {output[-1000:]}")
            setup_elapsed = time.monotonic() - setup_started

            if setup_errors:
                aggregate_result = blocked_result(
                    "K11_81_SHARD_AGGREGATE_PROBE",
                    "stub shard setup failed: " + " | ".join(setup_errors),
                )
            else:
                aggregate_path = module_source / "Aggregate.lean"
                aggregate_path.write_text(aggregate_source(), encoding="utf-8")
                source_hashes["Aggregate.lean"] = sha256(aggregate_path)
                aggregate_result = compile_probe(
                    "K11_81_SHARD_AGGREGATE_PROBE",
                    lean,
                    aggregate_path,
                    module_build / "Aggregate.olean",
                    source_root,
                    generated_env,
                )
        else:
            aggregate_result = blocked_result(
                "K11_81_SHARD_AGGREGATE_PROBE",
                "k=11-scale chunked data module did not compile",
            )
        results.append(aggregate_result)
        print(
            f"{aggregate_result.probe_id}={aggregate_result.status} "
            f"elapsed={aggregate_result.elapsed_seconds}s "
            f"peak_rss_mib={aggregate_result.peak_rss_mib} "
            f"exit_code={aggregate_result.exit_code}",
            flush=True,
        )

        generated_source_bytes = sum(path.stat().st_size for path in source_root.rglob("*.lean"))
        generated_olean_bytes = sum(path.stat().st_size for path in build_root.rglob("*.olean"))

    total_elapsed = time.monotonic() - started
    statuses = {result.status for result in results}
    if (
        "ARCHITECTURE_FAIL" in statuses
        or "BLOCKED_BY_DEPENDENCY" in statuses
        or total_elapsed > PREFLIGHT_TOTAL_FAIL_SECONDS
    ):
        verdict = "K11_PREFLIGHT_ARCHITECTURE_FAIL"
    elif "OPTIMIZATION_REQUIRED" in statuses or total_elapsed > PREFLIGHT_TOTAL_PASS_SECONDS:
        verdict = "K11_PREFLIGHT_OPTIMIZATION_REQUIRED"
    else:
        verdict = "K11_PREFLIGHT_ARCHITECTURE_PASS"

    with MEASUREMENTS_PATH.open("w", newline="", encoding="utf-8") as handle:
        fieldnames = list(asdict(results[0]).keys())
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for result in results:
            writer.writerow(asdict(result))

    summary = {
        "verdict": verdict,
        "budget_doc": str(BUDGET_DOC.relative_to(REPO_ROOT)),
        "budget_doc_sha256": sha256(BUDGET_DOC),
        "git_head": subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=REPO_ROOT,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip(),
        "architecture": {
            "principal_count": K11_PRINCIPAL_COUNT,
            "auxiliary_count": K11_AUXILIARY_COUNT,
            "shard_count": SHARD_COUNT,
            "principal_rows_per_shard": PRINCIPAL_SHARD_SIZE,
            "auxiliary_groups_per_shard": AUXILIARY_SHARD_SIZE,
            "data_chunk_size": DATA_CHUNK_SIZE,
            "monolithic_59049_match_generated": False,
        },
        "measurements": [asdict(result) for result in results],
        "aggregate_setup": {
            "stub_shard_count": SHARD_COUNT,
            "workers": 3,
            "elapsed_seconds": round(setup_elapsed, 6),
            "peak_single_process_rss_mib": (
                None if setup_peak_mib is None else round(setup_peak_mib, 3)
            ),
        },
        "total_elapsed_seconds": round(total_elapsed, 6),
        "free_disk_gib_at_start": round(free_disk_gib, 3),
        "generated_temporary_source_bytes": generated_source_bytes,
        "generated_temporary_olean_bytes": generated_olean_bytes,
        "generated_source_sha256": source_hashes,
        "synthetic_sources_retained": False,
        "real_k11_certificate_generated": False,
        "k11_theorem_claimed": False,
        "global_collatz_claimed": False,
    }
    SUMMARY_PATH.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    write_manifest([BUDGET_DOC, Path(__file__), SUMMARY_PATH, MEASUREMENTS_PATH])
    print(verdict)
    for result in results:
        print(
            f"{result.probe_id}={result.status} "
            f"elapsed={result.elapsed_seconds}s peak_rss_mib={result.peak_rss_mib}"
        )
    print(f"total_elapsed_seconds={summary['total_elapsed_seconds']}")
    return 0 if verdict == "K11_PREFLIGHT_ARCHITECTURE_PASS" else 2


if __name__ == "__main__":
    raise SystemExit(main())
