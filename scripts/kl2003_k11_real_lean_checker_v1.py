#!/usr/bin/env python3
"""Emit the 81-shard Lean checker for the exact k=11 LNT candidate."""

from __future__ import annotations

import csv
import hashlib
import json
import subprocess
from fractions import Fraction
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
LEAN_DIR = REPO_ROOT / "CollatzClassical" / "KL2003"
SOURCE = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K11_LNT_MEASUREMENT_v1"
    / "kl2003_k11_lnt_certificate.candidate.json"
)
BUDGET_DOC = REPO_ROOT / "docs" / "KL2003_K11_REAL_LEAN_CHECKER_BUDGET_v1.md"
OUT_DIR = REPO_ROOT / "outputs" / "KL2003_K11_REAL_LEAN_CHECKER_v1"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
MANIFEST_PATH = OUT_DIR / "manifest_sha256.csv"

K = 11
MODULUS = 3**K
AUXILIARY_MODULUS = 3 ** (K - 1)
PRINCIPAL_COUNT = 3 ** (K - 1)
AUXILIARY_COUNT = 3 ** (K - 2)
SHARD_COUNT = 81
GROUP_COUNT = 9
PRINCIPAL_SHARD_SIZE = 729
AUXILIARY_SHARD_SIZE = 243
DATA_CHUNK_SIZE = 27


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def repo_rel(path: Path) -> str:
    return str(path.resolve().relative_to(REPO_ROOT))


def rat(text: str) -> Fraction:
    return Fraction(text)


def lean_rat(value: Fraction) -> str:
    return f"({value.numerator} / {value.denominator} : Rat)"


def data_shard_path(shard: int) -> Path:
    return LEAN_DIR / f"KL2003K11CertificateDataShard{shard:02d}.lean"


def checker_shard_path(shard: int) -> Path:
    return LEAN_DIR / f"KL2003K11CertificateMatchShard{shard:02d}.lean"


def group_path(group: int) -> Path:
    return LEAN_DIR / f"KL2003K11CertificateMatchGroup{group}.lean"


ROUTER_PATH = LEAN_DIR / "KL2003K11CertificateDataRouter.lean"
AGGREGATE_PATH = LEAN_DIR / "KL2003K11CertificateMatchAggregate.lean"
AUDIT_PATH = LEAN_DIR / "KL2003K11CertificateMatchAggregateAxiomAudit.lean"


def local_match_def(name: str, values: list[Fraction]) -> str:
    definitions: list[str] = []
    chunk_count = (len(values) + DATA_CHUNK_SIZE - 1) // DATA_CHUNK_SIZE
    for chunk_index in range(chunk_count):
        start = chunk_index * DATA_CHUNK_SIZE
        chunk = values[start : start + DATA_CHUNK_SIZE]
        equations = "\n".join(
            f"  | {local} => {lean_rat(value)}"
            for local, value in enumerate(chunk)
        )
        definitions.append(
            f"def {name}Chunk{chunk_index} : Nat -> Rat\n"
            f"{equations}\n"
            "  | _ => 1"
        )
    router = "\n".join(
        f"  | {chunk} => {name}Chunk{chunk} (index % {DATA_CHUNK_SIZE})"
        for chunk in range(chunk_count)
    )
    definitions.append(
        f"def {name}Local (index : Nat) : Rat :=\n"
        f"  match index / {DATA_CHUNK_SIZE} with\n"
        f"{router}\n"
        "  | _ => 1"
    )
    return "\n\n".join(definitions)


def data_shard_source(
    shard: int,
    principal: list[Fraction],
    auxiliary: list[Fraction],
    slacks: list[Fraction],
) -> str:
    principal_start = shard * PRINCIPAL_SHARD_SIZE
    auxiliary_start = shard * AUXILIARY_SHARD_SIZE
    principal_local = principal[principal_start : principal_start + PRINCIPAL_SHARD_SIZE]
    auxiliary_local = auxiliary[auxiliary_start : auxiliary_start + AUXILIARY_SHARD_SIZE]
    slacks_local = slacks[principal_start : principal_start + PRINCIPAL_SHARD_SIZE]
    namespace = f"CollatzClassical.KL2003.K11CertificateMatch.DataShard{shard:02d}"
    return f'''import Mathlib.Data.Rat.Defs

namespace {namespace}

{local_match_def("principalAt", principal_local)}

{local_match_def("auxiliaryAt", auxiliary_local)}

{local_match_def("rowSlackAt", slacks_local)}

end {namespace}
'''


def global_router(name: str, local_name: str, shard_size: int) -> str:
    cases = "\n".join(
        f"  | {shard} => DataShard{shard:02d}.{local_name} (index % {shard_size})"
        for shard in range(SHARD_COUNT)
    )
    return (
        f"def {name} (index : Nat) : Rat :=\n"
        f"  match index / {shard_size} with\n"
        f"{cases}\n"
        "  | _ => 1"
    )


def router_source(
    lambda_value: Fraction,
    a_coeff: Fraction,
    b_lower: Fraction,
    d_lower: Fraction,
) -> str:
    imports = "\n".join(
        f"import CollatzClassical.KL2003.KL2003K11CertificateDataShard{shard:02d}"
        for shard in range(SHARD_COUNT)
    )
    return f'''{imports}

namespace CollatzClassical.KL2003.K11CertificateMatch

def lambda : Rat := {lean_rat(lambda_value)}
def aCoeff : Rat := {lean_rat(a_coeff)}
def bLower : Rat := {lean_rat(b_lower)}
def dLower : Rat := {lean_rat(d_lower)}

{global_router("principalAt", "principalAtLocal", PRINCIPAL_SHARD_SIZE)}

{global_router("auxiliaryAt", "auxiliaryAtLocal", AUXILIARY_SHARD_SIZE)}

{global_router("rowSlackAt", "rowSlackAtLocal", PRINCIPAL_SHARD_SIZE)}

def modeAt (index : Nat) : Nat := 3 * index + 2

def retardedIndex (index : Nat) : Nat :=
  (((4 * modeAt index) % {MODULUS}) - 2) / 3

def d1AuxiliaryIndex (index : Nat) : Nat :=
  (((((4 * modeAt index) - 2) / 3) % {AUXILIARY_MODULUS}) - 2) / 3

def d3AuxiliaryIndex (index : Nat) : Nat :=
  (((((2 * modeAt index) - 1) / 3) % {AUXILIARY_MODULUS}) - 2) / 3

def rowRhs (index : Nat) : Rat :=
  let retarded := aCoeff * principalAt (retardedIndex index)
  if modeAt index % 9 = 2 then
    retarded + bLower * auxiliaryAt (d1AuxiliaryIndex index)
  else if modeAt index % 9 = 5 then
    retarded
  else
    retarded + dLower * auxiliaryAt (d3AuxiliaryIndex index)

def K11RowValid (index : Nat) : Prop :=
  1 <= principalAt index /\\
    rowSlackAt index = rowRhs index - principalAt index /\\
    0 < rowSlackAt index

def K11AuxiliaryValid (index : Nat) : Prop :=
  1 <= auxiliaryAt index /\\
    auxiliaryAt index <= principalAt index /\\
    auxiliaryAt index <= principalAt (index + {AUXILIARY_COUNT}) /\\
    auxiliaryAt index <= principalAt (index + {2 * AUXILIARY_COUNT})

end CollatzClassical.KL2003.K11CertificateMatch
'''


def retarded_index(index: int) -> int:
    mode = 3 * index + 2
    return (((4 * mode) % MODULUS) - 2) // 3


def d1_auxiliary_index(index: int) -> int:
    mode = 3 * index + 2
    return (((((4 * mode) - 2) // 3) % AUXILIARY_MODULUS) - 2) // 3


def d3_auxiliary_index(index: int) -> int:
    mode = 3 * index + 2
    return (((((2 * mode) - 1) // 3) % AUXILIARY_MODULUS) - 2) // 3


def row_literal_statement(
    index: int,
    principal: list[Fraction],
    auxiliary: list[Fraction],
    slacks: list[Fraction],
    a_coeff: Fraction,
    b_lower: Fraction,
    d_lower: Fraction,
) -> str:
    lhs = lean_rat(principal[index])
    slack = lean_rat(slacks[index])
    rhs = f"{lean_rat(a_coeff)} * {lean_rat(principal[retarded_index(index)])}"
    mode = 3 * index + 2
    if mode % 9 == 2:
        rhs += (
            f" + {lean_rat(b_lower)} * "
            f"{lean_rat(auxiliary[d1_auxiliary_index(index)])}"
        )
    elif mode % 9 == 8:
        rhs += (
            f" + {lean_rat(d_lower)} * "
            f"{lean_rat(auxiliary[d3_auxiliary_index(index)])}"
        )
    return (
        f"(1 : Rat) <= {lhs} /\\\n"
        f"    {slack} = {rhs} - {lhs} /\\\n"
        f"    (0 : Rat) < {slack}"
    )


def auxiliary_literal_statement(
    index: int,
    principal: list[Fraction],
    auxiliary: list[Fraction],
) -> str:
    value = lean_rat(auxiliary[index])
    return (
        f"(1 : Rat) <= {value} /\\\n"
        f"    {value} <= {lean_rat(principal[index])} /\\\n"
        f"    {value} <= {lean_rat(principal[index + AUXILIARY_COUNT])} /\\\n"
        f"    {value} <= {lean_rat(principal[index + 2 * AUXILIARY_COUNT])}"
    )


def exact_dispatch(theorem_prefix: str, start: int, end: int) -> str:
    return "\n".join(
        f"  · exact {theorem_prefix}_{index}" for index in range(start, end)
    )


def checker_shard_source(
    shard: int,
    principal: list[Fraction],
    auxiliary: list[Fraction],
    slacks: list[Fraction],
    a_coeff: Fraction,
    b_lower: Fraction,
    d_lower: Fraction,
) -> str:
    row_start = shard * PRINCIPAL_SHARD_SIZE
    row_end = row_start + PRINCIPAL_SHARD_SIZE
    auxiliary_start = shard * AUXILIARY_SHARD_SIZE
    auxiliary_end = auxiliary_start + AUXILIARY_SHARD_SIZE
    row_facts = "\n\n".join(
        "set_option maxRecDepth 100000 in\n"
        "set_option maxHeartbeats 0 in\n"
        f"theorem k11_row_valid_{index} : K11RowValid {index} := by\n"
        f"  change {row_literal_statement(index, principal, auxiliary, slacks, a_coeff, b_lower, d_lower)}\n"
        "  norm_num1\n"
        "  simp"
        for index in range(row_start, row_end)
    )
    auxiliary_facts = "\n\n".join(
        "set_option maxRecDepth 100000 in\n"
        "set_option maxHeartbeats 0 in\n"
        f"theorem k11_auxiliary_valid_{index} : K11AuxiliaryValid {index} := by\n"
        f"  change {auxiliary_literal_statement(index, principal, auxiliary)}\n"
        "  norm_num1\n"
        "  simp"
        for index in range(auxiliary_start, auxiliary_end)
    )
    return f'''import CollatzClassical.KL2003.KL2003K11CertificateDataRouter
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

namespace CollatzClassical.KL2003.K11CertificateMatch

{row_facts}

theorem k11_rows_shard_{shard} (index : Nat)
    (hlo : {row_start} <= index) (hhi : index < {row_end}) :
    K11RowValid index := by
  interval_cases index
{exact_dispatch("k11_row_valid", row_start, row_end)}

{auxiliary_facts}

theorem k11_auxiliary_shard_{shard} (index : Nat)
    (hlo : {auxiliary_start} <= index) (hhi : index < {auxiliary_end}) :
    K11AuxiliaryValid index := by
  interval_cases index
{exact_dispatch("k11_auxiliary_valid", auxiliary_start, auxiliary_end)}

end CollatzClassical.KL2003.K11CertificateMatch
'''


def group_source(group: int) -> str:
    first = group * 9
    imports = "\n".join(
        f"import CollatzClassical.KL2003.KL2003K11CertificateMatchShard{shard:02d}"
        for shard in range(first, first + 9)
    )
    row_lines: list[str] = []
    auxiliary_lines: list[str] = []
    for offset in range(8):
        shard = first + offset
        row_lower = "hlo" if offset == 0 else f"Nat.le_of_not_gt h{offset - 1}"
        aux_lower = "hlo" if offset == 0 else f"Nat.le_of_not_gt ha{offset - 1}"
        row_lines.extend(
            [
                f"  by_cases h{offset} : index < {(shard + 1) * PRINCIPAL_SHARD_SIZE}",
                f"  · exact k11_rows_shard_{shard} index ({row_lower}) h{offset}",
            ]
        )
        auxiliary_lines.extend(
            [
                f"  by_cases ha{offset} : index < {(shard + 1) * AUXILIARY_SHARD_SIZE}",
                f"  · exact k11_auxiliary_shard_{shard} index ({aux_lower}) ha{offset}",
            ]
        )
    last = first + 8
    return f'''{imports}

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_rows_group_{group} (index : Nat)
    (hlo : {first * PRINCIPAL_SHARD_SIZE} <= index)
    (hhi : index < {(last + 1) * PRINCIPAL_SHARD_SIZE}) : K11RowValid index := by
{chr(10).join(row_lines)}
  exact k11_rows_shard_{last} index (Nat.le_of_not_gt h7) hhi

theorem k11_auxiliary_group_{group} (index : Nat)
    (hlo : {first * AUXILIARY_SHARD_SIZE} <= index)
    (hhi : index < {(last + 1) * AUXILIARY_SHARD_SIZE}) :
    K11AuxiliaryValid index := by
{chr(10).join(auxiliary_lines)}
  exact k11_auxiliary_shard_{last} index (Nat.le_of_not_gt ha7) hhi

end CollatzClassical.KL2003.K11CertificateMatch
'''


def aggregate_source() -> str:
    imports = "\n".join(
        f"import CollatzClassical.KL2003.KL2003K11CertificateMatchGroup{group}"
        for group in range(GROUP_COUNT)
    )
    row_lines: list[str] = []
    auxiliary_lines: list[str] = []
    for group in range(8):
        row_lower = "Nat.zero_le index" if group == 0 else f"Nat.le_of_not_gt h{group - 1}"
        aux_lower = "Nat.zero_le index" if group == 0 else f"Nat.le_of_not_gt ha{group - 1}"
        row_lines.extend(
            [
                f"  by_cases h{group} : index < {(group + 1) * 9 * PRINCIPAL_SHARD_SIZE}",
                f"  · exact k11_rows_group_{group} index ({row_lower}) h{group}",
            ]
        )
        auxiliary_lines.extend(
            [
                f"  by_cases ha{group} : index < {(group + 1) * 9 * AUXILIARY_SHARD_SIZE}",
                f"  · exact k11_auxiliary_group_{group} index ({aux_lower}) ha{group}",
            ]
        )
    return f'''{imports}

namespace CollatzClassical.KL2003.K11CertificateMatch

theorem k11_all_rows_valid (index : Nat) (hindex : index < {PRINCIPAL_COUNT}) :
    K11RowValid index := by
{chr(10).join(row_lines)}
  exact k11_rows_group_8 index (Nat.le_of_not_gt h7) hindex

theorem k11_all_auxiliary_valid (index : Nat)
    (hindex : index < {AUXILIARY_COUNT}) : K11AuxiliaryValid index := by
{chr(10).join(auxiliary_lines)}
  exact k11_auxiliary_group_8 index (Nat.le_of_not_gt ha7) hindex

end CollatzClassical.KL2003.K11CertificateMatch
'''


def audit_source() -> str:
    return '''import CollatzClassical.KL2003.KL2003K11CertificateMatchAggregate

#print axioms CollatzClassical.KL2003.K11CertificateMatch.k11_all_rows_valid
#print axioms CollatzClassical.KL2003.K11CertificateMatch.k11_all_auxiliary_valid
'''


def write_manifest(paths: list[Path]) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with MANIFEST_PATH.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["path", "sha256", "bytes"])
        writer.writeheader()
        for path in paths:
            writer.writerow(
                {
                    "path": repo_rel(path),
                    "sha256": sha256(path),
                    "bytes": path.stat().st_size,
                }
            )


def main() -> int:
    if not SOURCE.exists():
        raise FileNotFoundError(SOURCE)
    if not BUDGET_DOC.exists():
        raise FileNotFoundError(BUDGET_DOC)
    payload = json.loads(SOURCE.read_text(encoding="utf-8"))
    if payload["metadata"]["k"] != K:
        raise ValueError("K11_SOURCE_K_MISMATCH")
    if not all(payload["exact_checks"].values()):
        raise ValueError("K11_SOURCE_EXACT_CHECKS_NOT_ALL_TRUE")

    principal = [rat(row["target"]) for row in payload["rows"]]
    slacks = [rat(row["slack"]) for row in payload["rows"]]
    auxiliary = [rat(row["value"]) for row in payload["auxiliary"]]
    if len(principal) != PRINCIPAL_COUNT or len(slacks) != PRINCIPAL_COUNT:
        raise ValueError("K11_PRINCIPAL_DIMENSION_MISMATCH")
    if len(auxiliary) != AUXILIARY_COUNT:
        raise ValueError("K11_AUXILIARY_DIMENSION_MISMATCH")

    constants = payload["constants"]
    lambda_value = rat(constants["lambda"])
    a_coeff = rat(constants["A_lambda_minus_2"])
    b_lower = rat(constants["B_lower"])
    d_lower = rat(constants["D_lower"])

    data_paths: list[Path] = []
    for shard in range(SHARD_COUNT):
        path = data_shard_path(shard)
        path.write_text(
            data_shard_source(shard, principal, auxiliary, slacks),
            encoding="utf-8",
        )
        data_paths.append(path)

    ROUTER_PATH.write_text(
        router_source(lambda_value, a_coeff, b_lower, d_lower),
        encoding="utf-8",
    )

    checker_paths: list[Path] = []
    for shard in range(SHARD_COUNT):
        path = checker_shard_path(shard)
        path.write_text(
            checker_shard_source(
                shard,
                principal,
                auxiliary,
                slacks,
                a_coeff,
                b_lower,
                d_lower,
            ),
            encoding="utf-8",
        )
        checker_paths.append(path)

    group_paths: list[Path] = []
    for group in range(GROUP_COUNT):
        path = group_path(group)
        path.write_text(group_source(group), encoding="utf-8")
        group_paths.append(path)

    AGGREGATE_PATH.write_text(aggregate_source(), encoding="utf-8")
    AUDIT_PATH.write_text(audit_source(), encoding="utf-8")

    generated_paths = [
        *data_paths,
        ROUTER_PATH,
        *checker_paths,
        *group_paths,
        AGGREGATE_PATH,
        AUDIT_PATH,
    ]
    source_bytes = sum(path.stat().st_size for path in generated_paths)
    summary: dict[str, Any] = {
        "verdict": "K11_REAL_LEAN_CHECKER_SOURCES_EMITTED",
        "source_commit": subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=REPO_ROOT,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip(),
        "source_candidate": repo_rel(SOURCE),
        "source_candidate_sha256": sha256(SOURCE),
        "budget_doc": repo_rel(BUDGET_DOC),
        "budget_doc_sha256": sha256(BUDGET_DOC),
        "data_shard_count": len(data_paths),
        "checker_shard_count": len(checker_paths),
        "group_count": len(group_paths),
        "principal_count": len(principal),
        "auxiliary_count": len(auxiliary),
        "generated_lean_file_count": len(generated_paths),
        "generated_lean_source_bytes": source_bytes,
        "lean_build_status": "NOT_RUN",
        "lnt_certificate_declared": False,
        "k11_theorem_claimed": False,
        "global_collatz_claimed": False,
    }
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    SUMMARY_PATH.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    write_manifest([BUDGET_DOC, Path(__file__), SOURCE, *generated_paths, SUMMARY_PATH])
    print(json.dumps(summary, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
