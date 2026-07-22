#!/usr/bin/env python3
"""Build a versioned manifest for the F3 update without overwriting v1."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[3]
OUTPUT = REPO_ROOT / "outputs/F3_DENSITY_CAPTURE_GATE_v1/F3_UPDATE_MANIFEST_v2.json"
PACKAGE_ROOTS = (
    REPO_ROOT / "outputs/F3_DENSITY_CAPTURE_GATE_v1",
    REPO_ROOT / "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def iter_files() -> list[Path]:
    files: list[Path] = []
    for root in PACKAGE_ROOTS:
        for path in root.rglob("*"):
            if not path.is_file():
                continue
            if path == OUTPUT or "__pycache__" in path.parts or path.suffix == ".pyc":
                continue
            files.append(path)
    return sorted(set(files), key=lambda path: str(path.relative_to(REPO_ROOT)))


def main() -> None:
    records = [
        {
            "path": str(path.relative_to(REPO_ROOT)),
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        }
        for path in iter_files()
    ]
    manifest = {
        "manifest_version": "F3_UPDATE_MANIFEST_v2",
        "scope": [
            "outputs/F3_DENSITY_CAPTURE_GATE_v1",
            "outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2",
        ],
        "historical_manifest_preserved": "outputs/F3_DENSITY_CAPTURE_GATE_v1/PACKAGE_MANIFEST_v1.json",
        "excluded": ["__pycache__", "*.pyc", "outputs/KL2003_*", "scripts/kl2003_*"],
        "files": records,
    }
    OUTPUT.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({"manifest": str(OUTPUT), "file_count": len(records)}, indent=2))


if __name__ == "__main__":
    main()
