#!/usr/bin/env python3
"""Verify every file recorded in PACKAGE_MANIFEST_v1.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


PACKAGE_ROOT = Path(__file__).resolve().parent.parent
MANIFEST = PACKAGE_ROOT / "PACKAGE_MANIFEST_v1.json"


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    payload = json.loads(MANIFEST.read_text(encoding="utf-8"))
    failures: list[dict[str, object]] = []
    for record in payload["files"]:
        relative = Path(record["path"])
        path = PACKAGE_ROOT / relative
        if not path.is_file():
            failures.append({"path": str(relative), "reason": "missing"})
            continue
        actual_bytes = path.stat().st_size
        actual_hash = file_sha256(path)
        if actual_bytes != record["bytes"] or actual_hash != record["sha256"]:
            failures.append(
                {
                    "path": str(relative),
                    "reason": "content_mismatch",
                    "expected_bytes": record["bytes"],
                    "actual_bytes": actual_bytes,
                    "expected_sha256": record["sha256"],
                    "actual_sha256": actual_hash,
                }
            )

    result = {
        "status": "PASS" if not failures else "FAIL",
        "manifest": str(MANIFEST),
        "checked_files": len(payload["files"]),
        "failure_count": len(failures),
        "failures": failures,
    }
    print(json.dumps(result, indent=2, sort_keys=True))
    if failures:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
