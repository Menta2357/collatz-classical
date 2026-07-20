#!/usr/bin/env python3
"""Emit match-dispatched Lean checks for the exact k=9 certificate data."""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
SOURCE = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K9_LNT_MEASUREMENT_v1"
    / "kl2003_k9_lnt_certificate.candidate.json"
)
OUT_DIR = REPO_ROOT / "outputs" / "KL2003_F2_K9_MATCH_DISPATCH_v1"
SUMMARY_PATH = OUT_DIR / "generation_summary.json"
LEAN_DIR = REPO_ROOT / "CollatzClassical" / "KL2003"
DATA_PATH = LEAN_DIR / "KL2003K9CertificateMatchData.lean"
AGGREGATE_PATH = LEAN_DIR / "KL2003K9CertificateMatchAggregate.lean"

PRINCIPAL_SHARD_SIZE = 729
AUXILIARY_SHARD_SIZE = 243
DATA_CHUNK_SIZE = 27
MAX_PILOT_ROWS = 729


def rat(text: str) -> Fraction:
    return Fraction(text)


def lean_rat(value: Fraction) -> str:
    return f"({value.numerator} / {value.denominator} : Rat)"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def match_def(
    name: str, values: list[Fraction], shard_size: int, chunk_size: int
) -> str:
    definitions: list[str] = []
    chunk_count = (len(values) + chunk_size - 1) // chunk_size
    for chunk_index in range(chunk_count):
        start = chunk_index * chunk_size
        chunk = values[start : start + chunk_size]
        equations = "\n".join(
            f"  | {local} => {lean_rat(value)}"
            for local, value in enumerate(chunk)
        )
        definitions.append(
            f"def {name}Chunk{chunk_index} : Nat -> Rat\n"
            f"{equations}\n"
            "  | _ => 1"
        )
    shard_count = (len(values) + shard_size - 1) // shard_size
    chunks_per_shard = shard_size // chunk_size
    for shard in range(shard_count):
        first_chunk = shard * chunks_per_shard
        local_chunk_count = min(chunks_per_shard, chunk_count - first_chunk)
        router = "\n".join(
            f"  | {local} => {name}Chunk{first_chunk + local} "
            f"(index % {chunk_size})"
            for local in range(local_chunk_count)
        )
        definitions.append(
            f"def {name}Shard{shard} (index : Nat) : Rat :=\n"
            f"  match index / {chunk_size} with\n"
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


def principal_index(mode: int) -> int:
    return (mode - 2) // 3


def auxiliary_index(mode: int) -> int:
    return (mode - 2) // 3


def retarded_index(index: int) -> int:
    mode = 3 * index + 2
    return (((4 * mode) % 19683) - 2) // 3


def d1_auxiliary_index(index: int) -> int:
    mode = 3 * index + 2
    return (((((4 * mode) - 2) // 3) % 6561) - 2) // 3


def d3_auxiliary_index(index: int) -> int:
    mode = 3 * index + 2
    return (((((2 * mode) - 1) // 3) % 6561) - 2) // 3


def row_unfolding(index: int) -> str:
    def data_names(name: str, data_index: int, shard_size: int) -> list[str]:
        return [
            name,
            f"{name}Shard{data_index // shard_size}",
            f"{name}Chunk{data_index // DATA_CHUNK_SIZE}",
        ]

    target = retarded_index(index)
    names = [
        "K9RowValid",
        "rowRhs",
        "modeAt",
        "retardedIndex",
        "d1AuxiliaryIndex",
        "d3AuxiliaryIndex",
        "aCoeff",
        "bLower",
        "dLower",
    ]
    names.extend(data_names("principalAt", index, PRINCIPAL_SHARD_SIZE))
    names.extend(data_names("principalAt", target, PRINCIPAL_SHARD_SIZE))
    names.extend(data_names("rowSlackAt", index, PRINCIPAL_SHARD_SIZE))
    mode = 3 * index + 2
    if mode % 9 == 2:
        names.extend(
            data_names(
                "auxiliaryAt",
                d1_auxiliary_index(index),
                AUXILIARY_SHARD_SIZE,
            )
        )
    elif mode % 9 == 8:
        names.extend(
            data_names(
                "auxiliaryAt",
                d3_auxiliary_index(index),
                AUXILIARY_SHARD_SIZE,
            )
        )
    return ", ".join(dict.fromkeys(names))


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
        f"    {value} <= {lean_rat(principal[index + 2187])} /\\\n"
        f"    {value} <= {lean_rat(principal[index + 4374])}"
    )


def shard_path(shard: int) -> Path:
    return LEAN_DIR / f"KL2003K9CertificateMatchShard{shard}.lean"


def exact_dispatch(theorem_prefix: str, start: int, end: int) -> str:
    return "\n".join(
        f"  · exact {theorem_prefix}_{index}" for index in range(start, end)
    )


def shard_source(
    shard: int,
    row_start: int,
    row_end: int,
    auxiliary_start: int,
    auxiliary_end: int,
    principal: list[Fraction],
    auxiliary: list[Fraction],
    slacks: list[Fraction],
    a_coeff: Fraction,
    b_lower: Fraction,
    d_lower: Fraction,
) -> str:
    row_facts = "\n\n".join(
        "set_option maxRecDepth 100000 in\n"
        "set_option maxHeartbeats 0 in\n"
        f"theorem k9_row_valid_{index} : K9RowValid {index} := by\n"
        f"  change {row_literal_statement(index, principal, auxiliary, slacks, a_coeff, b_lower, d_lower)}\n"
        "  norm_num"
        for index in range(row_start, row_end)
    )
    auxiliary_facts = "\n\n".join(
        "set_option maxRecDepth 100000 in\n"
        "set_option maxHeartbeats 0 in\n"
        f"theorem k9_auxiliary_valid_{index} : K9AuxiliaryValid {index} := by\n"
        f"  change {auxiliary_literal_statement(index, principal, auxiliary)}\n"
        "  norm_num"
        for index in range(auxiliary_start, auxiliary_end)
    )
    return f'''import CollatzClassical.KL2003.KL2003K9CertificateMatchData
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

namespace CollatzClassical.KL2003.K9CertificateMatch

{row_facts}

theorem k9_rows_shard_{shard} (index : Nat)
    (hlo : {row_start} <= index) (hhi : index < {row_end}) : K9RowValid index := by
  interval_cases index
{exact_dispatch("k9_row_valid", row_start, row_end)}

{auxiliary_facts}

theorem k9_auxiliary_shard_{shard} (index : Nat)
    (hlo : {auxiliary_start} <= index) (hhi : index < {auxiliary_end}) :
    K9AuxiliaryValid index := by
  interval_cases index
{exact_dispatch("k9_auxiliary_valid", auxiliary_start, auxiliary_end)}

end CollatzClassical.KL2003.K9CertificateMatch
'''


def aggregate_source() -> str:
    imports = "\n".join(
        f"import CollatzClassical.KL2003.KL2003K9CertificateMatchShard{shard}"
        for shard in range(9)
    )
    row_cases = "\n".join(
        (
            f"  by_cases h{shard} : index < {(shard + 1) * PRINCIPAL_SHARD_SIZE}\n"
            f"  · exact k9_rows_shard_{shard} index (by omega) h{shard}"
        )
        for shard in range(8)
    )
    auxiliary_cases = "\n".join(
        (
            f"  by_cases h{shard} : index < {(shard + 1) * AUXILIARY_SHARD_SIZE}\n"
            f"  · exact k9_auxiliary_shard_{shard} index (by omega) h{shard}"
        )
        for shard in range(8)
    )
    return f'''{imports}

namespace CollatzClassical.KL2003.K9CertificateMatch

theorem k9_all_rows_valid (index : Nat) (hindex : index < 6561) :
    K9RowValid index := by
{row_cases}
  exact k9_rows_shard_8 index (by omega) hindex

theorem k9_all_auxiliary_valid (index : Nat) (hindex : index < 2187) :
    K9AuxiliaryValid index := by
{auxiliary_cases}
  exact k9_auxiliary_shard_8 index (by omega) hindex

end CollatzClassical.KL2003.K9CertificateMatch
'''


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--row-count", type=int, default=1)
    parser.add_argument("--all-shards", action="store_true")
    args = parser.parse_args()
    if not 1 <= args.row_count <= MAX_PILOT_ROWS:
        raise ValueError("row-count must be in [1, 729]")

    payload = json.loads(SOURCE.read_text(encoding="utf-8"))
    variables = payload["rational_certificate"]["variables"]
    rows = payload["rows"]
    slacks_by_row = {
        item["row_id"]: rat(item["slack"]) for item in payload["slacks"]
    }

    principal = [
        rat(variables[f"c9_{mode}"]) for mode in range(2, 3**9, 3)
    ]
    auxiliary = [
        rat(variables[f"c8_{mode}"]) for mode in range(2, 3**8, 3)
    ]
    slacks = [slacks_by_row[row["row_id"]] for row in rows]

    coefficient_intervals = payload["rational_certificate"][
        "coefficient_intervals"
    ]
    coefficient_by_id = {
        item["coefficient_id"]: rat(item["lo"])
        for item in coefficient_intervals
    }
    lambda_value = rat(payload["rational_certificate"]["lambda_interval"]["lo"])
    a_coeff = coefficient_by_id["A_lambda_minus_2"]
    b_lower = coefficient_by_id["B_lower"]
    d_lower = coefficient_by_id["D_lower"]

    data_source = f'''import Mathlib.Data.Rat.Defs

namespace CollatzClassical.KL2003.K9CertificateMatch

def lambda : Rat := {lean_rat(lambda_value)}
def aCoeff : Rat := {lean_rat(a_coeff)}
def bLower : Rat := {lean_rat(b_lower)}
def dLower : Rat := {lean_rat(d_lower)}

{match_def("principalAt", principal, PRINCIPAL_SHARD_SIZE, DATA_CHUNK_SIZE)}

{match_def("auxiliaryAt", auxiliary, AUXILIARY_SHARD_SIZE, DATA_CHUNK_SIZE)}

{match_def("rowSlackAt", slacks, PRINCIPAL_SHARD_SIZE, DATA_CHUNK_SIZE)}

def modeAt (index : Nat) : Nat := 3 * index + 2

def retardedIndex (index : Nat) : Nat :=
  (((4 * modeAt index) % 19683) - 2) / 3

def d1AuxiliaryIndex (index : Nat) : Nat :=
  (((((4 * modeAt index) - 2) / 3) % 6561) - 2) / 3

def d3AuxiliaryIndex (index : Nat) : Nat :=
  (((((2 * modeAt index) - 1) / 3) % 6561) - 2) / 3

def rowRhs (index : Nat) : Rat :=
  let retarded := aCoeff * principalAt (retardedIndex index)
  if modeAt index % 9 = 2 then
    retarded + bLower * auxiliaryAt (d1AuxiliaryIndex index)
  else if modeAt index % 9 = 5 then
    retarded
  else
    retarded + dLower * auxiliaryAt (d3AuxiliaryIndex index)

def K9RowValid (index : Nat) : Prop :=
  1 <= principalAt index /\\
    rowSlackAt index = rowRhs index - principalAt index /\\
    0 < rowSlackAt index

def K9AuxiliaryValid (index : Nat) : Prop :=
  1 <= auxiliaryAt index /\\
    auxiliaryAt index <= principalAt index /\\
    auxiliaryAt index <= principalAt (index + 2187) /\\
    auxiliaryAt index <= principalAt (index + 4374)

end CollatzClassical.KL2003.K9CertificateMatch
'''

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    DATA_PATH.write_text(data_source, encoding="utf-8")
    generated_shards: list[Path] = []
    shard_count = 9 if args.all_shards else 1
    for shard in range(shard_count):
        row_start = shard * PRINCIPAL_SHARD_SIZE
        row_end = (
            row_start + PRINCIPAL_SHARD_SIZE
            if args.all_shards
            else args.row_count
        )
        auxiliary_start = shard * AUXILIARY_SHARD_SIZE
        auxiliary_end = (
            auxiliary_start + AUXILIARY_SHARD_SIZE
            if args.all_shards
            else min(args.row_count, AUXILIARY_SHARD_SIZE)
        )
        path = shard_path(shard)
        path.write_text(
            shard_source(
                shard,
                row_start,
                row_end,
                auxiliary_start,
                auxiliary_end,
                principal,
                auxiliary,
                slacks,
                a_coeff,
                b_lower,
                d_lower,
            ),
            encoding="utf-8",
        )
        generated_shards.append(path)
    if args.all_shards:
        AGGREGATE_PATH.write_text(aggregate_source(), encoding="utf-8")
    summary = {
        "verdict": "K9_MATCH_DISPATCH_EMITTED",
        "row_count": len(principal) if args.all_shards else args.row_count,
        "principal_count": len(principal),
        "auxiliary_count": len(auxiliary),
        "source_sha256": sha256(SOURCE),
        "data_sha256": sha256(DATA_PATH),
        "all_shards": args.all_shards,
        "shard_count": shard_count,
        "shard_sha256": {path.name: sha256(path) for path in generated_shards},
        "aggregate_sha256": sha256(AGGREGATE_PATH) if args.all_shards else None,
        "generator_sha256": sha256(Path(__file__)),
        "generator_is_trusted": False,
        "lean_verification_required": True,
    }
    SUMMARY_PATH.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print(summary["verdict"])
    print(f"row_count={summary['row_count']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
