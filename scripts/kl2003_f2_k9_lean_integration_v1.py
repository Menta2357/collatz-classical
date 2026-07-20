#!/usr/bin/env python3
"""Emit the source-tree Lean data and kernel-check shards for k=9.

The numerical search remains outside the trusted base.  This script promotes
the already-custodied exact rational candidate and emits propositions that
Lean rechecks with ``norm_num``.  It never emits a k=9 lower-bound theorem;
that theorem is assembled separately from the checked certificate.
"""

from __future__ import annotations

import hashlib
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
SOURCE_DATA = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K9_LNT_MEASUREMENT_v1"
    / "KL2003K9LNTCertificateDataCandidate.lean"
)
LEAN_DIR = REPO_ROOT / "CollatzClassical" / "KL2003"
DATA_PATH = LEAN_DIR / "KL2003K9CertificateDataGenerated.lean"
BASE_PATH = LEAN_DIR / "KL2003K9CertificateVerifierBase.lean"
SHARD_PATHS = [
    LEAN_DIR / f"KL2003K9CertificateVerifierShard{index}.lean"
    for index in range(9)
]
MANIFEST_PATH = (
    REPO_ROOT
    / "outputs"
    / "KL2003_F2_K9_LEAN_INTEGRATION_v1"
    / "manifest_sha256.csv"
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def promoted_data() -> str:
    text = SOURCE_DATA.read_text(encoding="utf-8")
    text = text.replace(
        "/- Generated measurement data only.  This file is not imported by the project\n"
        "and contains no k=9 theorem.  A separate kernel checker remains required. -/",
        "/- Generated exact rational k=9 certificate data.  This file is data, not a\n"
        "theorem; the verifier shards recheck every imported inequality in the kernel. -/",
    )
    return text.replace("GeneratedK9Measurement", "GeneratedK9")


def base_module() -> str:
    principal_router = "\n".join(
        f"  | {index} => principalChunk{index}" for index in range(81)
    )
    auxiliary_router = "\n".join(
        f"  | {index} => auxiliaryChunk{index}" for index in range(27)
    )
    slack_router = "\n".join(
        f"  | {index} => rowSlacksChunk{index}" for index in range(81)
    )
    return f'''import CollatzClassical.KL2003.KL2003K9CertificateDataGenerated
import CollatzClassical.KL2003.KL2003GeneralKLNTFeasibilityTransfer
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

namespace CollatzClassical
namespace KL2003
namespace K9CertificateVerifier

open GeneratedK9

def principalChunkAt : Nat -> Array Rat
{principal_router}
  | _ => #[]

def auxiliaryChunkAt : Nat -> Array Rat
{auxiliary_router}
  | _ => #[]

def rowSlackChunkAt : Nat -> Array Rat
{slack_router}
  | _ => #[]

def principalAt (index : Nat) : Rat :=
  (principalChunkAt (index / 81))[index % 81]!

def auxiliaryAt (index : Nat) : Rat :=
  (auxiliaryChunkAt (index / 81))[index % 81]!

def rowSlackAt (index : Nat) : Rat :=
  (rowSlackChunkAt (index / 81))[index % 81]!

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

end K9CertificateVerifier
end KL2003
end CollatzClassical
'''


def row_unfolding_names(index: int) -> str:
    mode = 3 * index + 2
    retarded = (((4 * mode) % 19683) - 2) // 3
    names = [
        "K9RowValid",
        "rowRhs",
        "modeAt",
        "retardedIndex",
        "d1AuxiliaryIndex",
        "d3AuxiliaryIndex",
        "principalAt",
        "auxiliaryAt",
        "rowSlackAt",
        "principalChunkAt",
        "auxiliaryChunkAt",
        "rowSlackChunkAt",
        "GeneratedK9.aCoeff",
        "GeneratedK9.bLower",
        "GeneratedK9.dLower",
        f"GeneratedK9.principalChunk{index // 81}",
        f"GeneratedK9.principalChunk{retarded // 81}",
        f"GeneratedK9.rowSlacksChunk{index // 81}",
    ]
    if mode % 9 == 2:
        auxiliary = (((((4 * mode) - 2) // 3) % 6561) - 2) // 3
        names.extend(
            [
                f"GeneratedK9.auxiliaryChunk{auxiliary // 81}",
            ]
        )
    elif mode % 9 == 8:
        auxiliary = (((((2 * mode) - 1) // 3) % 6561) - 2) // 3
        names.extend(
            [
                f"GeneratedK9.auxiliaryChunk{auxiliary // 81}",
            ]
        )
    return ", ".join(dict.fromkeys(names))


def auxiliary_unfolding_names(index: int) -> str:
    names = [
        "K9AuxiliaryValid",
        "principalAt",
        "auxiliaryAt",
        "principalChunkAt",
        "auxiliaryChunkAt",
        f"GeneratedK9.auxiliaryChunk{index // 81}",
        f"GeneratedK9.principalChunk{index // 81}",
        f"GeneratedK9.principalChunk{(index + 2187) // 81}",
        f"GeneratedK9.principalChunk{(index + 4374) // 81}",
    ]
    return ", ".join(dict.fromkeys(names))


def shard_module(shard : int) -> str:
    row_start = shard * 729
    row_end = row_start + 729
    auxiliary_start = shard * 243
    auxiliary_end = auxiliary_start + 243
    row_facts = "\n\n".join(
        f'''set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k9_row_valid_{index} : K9RowValid {index} := by
  norm_num [{row_unfolding_names(index)}]'''
        for index in range(row_start, row_end)
    )
    auxiliary_facts = "\n\n".join(
        f'''set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem k9_auxiliary_valid_{index} : K9AuxiliaryValid {index} := by
  norm_num [{auxiliary_unfolding_names(index)}]'''
        for index in range(auxiliary_start, auxiliary_end)
    )
    row_dispatch = "\n".join(
        f"  | {local}, _ => k9_row_valid_{row_start + local}"
        for local in range(729)
    )
    auxiliary_dispatch = "\n".join(
        f"  | {local}, _ => k9_auxiliary_valid_{auxiliary_start + local}"
        for local in range(243)
    )
    return f'''import CollatzClassical.KL2003.KL2003K9CertificateVerifierBase

namespace CollatzClassical
namespace KL2003
namespace K9CertificateVerifier

open GeneratedK9

{row_facts}

{auxiliary_facts}

set_option maxRecDepth 100000 in
theorem k9_row_valid_shard{shard}_nat :
    ∀ index, index < 729 -> K9RowValid ({shard} * 729 + index)
{row_dispatch}
  | index, hindex => by omega

theorem k9_row_valid_shard{shard} (index : Fin 729) :
    K9RowValid ({shard} * 729 + index.1) :=
  k9_row_valid_shard{shard}_nat index.1 index.2

set_option maxRecDepth 100000 in
theorem k9_auxiliary_valid_shard{shard}_nat :
    ∀ index, index < 243 -> K9AuxiliaryValid ({shard} * 243 + index)
{auxiliary_dispatch}
  | index, hindex => by omega

theorem k9_auxiliary_valid_shard{shard} (index : Fin 243) :
    K9AuxiliaryValid ({shard} * 243 + index.1) :=
  k9_auxiliary_valid_shard{shard}_nat index.1 index.2

end K9CertificateVerifier
end KL2003
end CollatzClassical
'''


def main() -> int:
    if not SOURCE_DATA.exists():
        raise FileNotFoundError(SOURCE_DATA)
    DATA_PATH.write_text(promoted_data(), encoding="utf-8")
    BASE_PATH.write_text(base_module(), encoding="utf-8")
    for shard, path in enumerate(SHARD_PATHS):
        path.write_text(shard_module(shard), encoding="utf-8")

    MANIFEST_PATH.parent.mkdir(parents=True, exist_ok=True)
    paths = [Path(__file__), SOURCE_DATA, DATA_PATH, BASE_PATH, *SHARD_PATHS]
    lines = ["path,sha256"]
    lines.extend(
        f"{path.resolve().relative_to(REPO_ROOT)},{sha256(path)}"
        for path in paths
    )
    MANIFEST_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("K9_LEAN_INTEGRATION_SHARDS_EMITTED")
    print(f"data_bytes={DATA_PATH.stat().st_size}")
    print(f"shard_count={len(SHARD_PATHS)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
