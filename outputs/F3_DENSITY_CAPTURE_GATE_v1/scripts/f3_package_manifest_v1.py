#!/usr/bin/env python3
"""Build a deterministic SHA-256 manifest for the F3 custody package."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


PACKAGE_ROOT = Path(__file__).resolve().parent.parent
OUTPUT = PACKAGE_ROOT / "PACKAGE_MANIFEST_v1.json"


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    files = sorted(
        path
        for path in PACKAGE_ROOT.rglob("*")
        if path.is_file() and path != OUTPUT and "__pycache__" not in path.parts
    )
    payload = {
        "status": "CUSTODY_MANIFEST",
        "package": PACKAGE_ROOT.name,
        "file_count": len(files),
        "files": [
            {
                "path": str(path.relative_to(PACKAGE_ROOT)),
                "bytes": path.stat().st_size,
                "sha256": file_sha256(path),
            }
            for path in files
        ],
    }
    OUTPUT.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print(f"wrote {OUTPUT}")
    print(f"files={len(files)}")


if __name__ == "__main__":
    main()
