#!/usr/bin/env python3
"""Validate the distribution and rebuild its Lean proofs in a clean directory."""

import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess
import tempfile
import time


ROOT = Path(__file__).resolve().parents[1]
AUDIT_MODULES = (
    "AuditP5J131EarlyCapture",
    "AuditP5J131Residual",
    "AuditAB9T3Adapter",
    "AuditP5J131T35",
    "AuditP5U8Fold",
)
STANDARD_MODULES = {"Std"}
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
VERSION = "4.21.0"
AXIOM_REPORT = re.compile(r"'([^']+)' depends on axioms: \[([^\]]*)\]")


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_manifest():
    seen = set()
    for line in (ROOT / "SHA256SUMS").read_text(encoding="utf-8").splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})  (.+)", line)
        if not match:
            raise ValueError(f"Malformed SHA256SUMS entry: {line!r}")
        expected, name = match.groups()
        relative = PurePosixPath(name)
        if relative.is_absolute() or ".." in relative.parts or relative in seen:
            raise ValueError(f"Invalid or repeated manifest path: {name}")
        seen.add(relative)
        path = ROOT / relative
        if not path.is_file() or not path.resolve().is_relative_to(ROOT):
            raise ValueError(f"Missing file or invalid path: {name}")
        if sha256(path) != expected:
            raise ValueError(f"SHA-256 mismatch: {name}")
    if not seen:
        raise ValueError("Empty SHA256SUMS")
    return len(seen)


def imports(path):
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("import "):
            yield from line[7:].split("--", maxsplit=1)[0].split()


def source_closure():
    source_dir = ROOT / "lean"
    files = {file.stem: file for file in source_dir.glob("*.lean")}
    inventory = json.loads((ROOT / "provenance" / "lean_sources.json").read_text(encoding="utf-8"))
    entries = {entry["module"]: entry["sha256"] for entry in inventory}
    if set(files) != set(entries) or len(inventory) != len(files):
        raise ValueError("Source inventory does not match the Lean directory")
    for module, path in files.items():
        if sha256(path) != entries[module]:
            raise ValueError(f"Source provenance mismatch for {module}")

    order, marked, walking = [], set(), set()

    def visit(module):
        if module in marked or module in STANDARD_MODULES:
            return
        if module not in files or module in walking:
            raise ValueError(f"Missing or cyclic Lean import: {module}")
        walking.add(module)
        for dependency in imports(files[module]):
            visit(dependency)
        walking.remove(module)
        marked.add(module)
        order.append(module)

    for module in AUDIT_MODULES:
        visit(module)
    if marked != set(files):
        raise ValueError(f"Sources outside the published proof closure: {sorted(set(files) - marked)}")
    return order


def lean_build(executable, order):
    version = subprocess.run(
        [executable, "--version"], cwd=ROOT, capture_output=True, text=True, check=True
    ).stdout
    if not version.startswith(f"Lean (version {VERSION},"):
        raise ValueError(f"Use Lean {VERSION}. Detected {version.strip()}")

    results = {}
    expected = json.loads((ROOT / "provenance" / "axioms_expected.json").read_text(encoding="utf-8"))
    source = ROOT / "lean"
    with tempfile.TemporaryDirectory(prefix="collatz-lean-") as directory:
        objects = Path(directory)
        env = dict(os.environ, LEAN_PATH=str(objects))
        for module in order:
            start = time.monotonic()
            run = subprocess.run(
                [executable, "-j1", "-s65536", "-DwarningAsError=true",
                 "-o", str(objects / f"{module}.olean"), f"{module}.lean"],
                cwd=source, env=env, capture_output=True, text=True,
            )
            output = run.stdout + run.stderr
            if run.returncode != 0:
                raise ValueError(f"Lean compilation failed for {module}:\n{output}")
            seconds = round(time.monotonic() - start, 3)
            print(f"PASS {module} ({seconds:.3f} s)", flush=True)
            results[module] = seconds

            if module in expected:
                axioms = {
                    name.rsplit(".", maxsplit=1)[-1]: sorted(item.strip() for item in value.split(",") if item.strip())
                    for name, value in AXIOM_REPORT.findall(output)
                }
                want = {name: sorted(values) for name, values in expected[module].items()}
                if axioms != want or not all(set(values) <= ALLOWED_AXIOMS for values in axioms.values()):
                    raise ValueError(f"Axiom audit differs for {module}: {axioms}")
    return {"status": "PASS", "lean_version": version.strip(), "parallel_jobs": 1,
            "modules": results, "audits": expected}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lean", default="lean", help="Lean executable or alias (default: lean)")
    parser.add_argument("--hashes-only", action="store_true", help="verify SHA-256 and source closure without compiling")
    parser.add_argument("--checks-out", type=Path, help="write a portable Lean verification receipt to this path")
    options = parser.parse_args()
    if options.hashes_only and options.checks_out:
        parser.error("--checks-out requires the full build")
    if options.checks_out and options.checks_out.resolve().is_relative_to(ROOT):
        parser.error("write the verification receipt outside the distribution")
    executable = str(Path(options.lean).resolve()) if os.sep in options.lean else options.lean

    try:
        entries = verify_manifest()
        order = source_closure()
        print(f"PASS SHA-256 ({entries} files); minimal Lean closure ({len(order)} modules)", flush=True)
        if not options.hashes_only:
            receipt = lean_build(executable, order)
            if options.checks_out:
                options.checks_out.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"FAIL: {error}\n")


if __name__ == "__main__":
    main()
