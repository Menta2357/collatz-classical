#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/extension-repo /path/to/output.tar.gz" >&2
  exit 64
fi

source_repo=$1
output=$2
source_commit=ef1a5a75d92f75c5550e2ba261726d7264005f4e
expected_hash=4ceeb087ec3faa9ec95566888b6487dbabbc6317714c0e080dc44fd3b4d45b25

if [ ! -d "$source_repo/.git" ]; then
  echo "source is not a Git repository: $source_repo" >&2
  exit 65
fi

if ! git -C "$source_repo" cat-file -e "$source_commit^{commit}"; then
  echo "missing source commit: $source_commit" >&2
  exit 66
fi

git -C "$source_repo" archive --format=tar.gz --output="$output" \
  "$source_commit" \
  LICENSE \
  NOTICE \
  Erdos1135/ND/CountingCore.lean \
  Erdos1135/ND/StatementCore.lean \
  Erdos1135/ND/FiniteBaseCertificate.lean \
  Erdos1135/ND/FusionParametric.lean \
  Erdos1135/ND/Conventions.lean \
  Erdos1135/ND/Statement.lean \
  FusionParametricAxiomAudit.lean \
  Erdos1135/Basic.lean \
  FormalConjectures/Wikipedia/CollatzStep.lean

actual_hash=$(shasum -a 256 "$output" | awk '{print $1}')
if [ "$actual_hash" != "$expected_hash" ]; then
  echo "reproducible payload hash mismatch" >&2
  echo "expected $expected_hash" >&2
  echo "actual   $actual_hash" >&2
  exit 67
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
archive_paths=$(tar -tzf "$output" | sed '/\/$/d')
expected_paths=$(cat "$script_dir/payload-archive-files.txt")
if [ "$archive_paths" != "$expected_paths" ]; then
  echo "payload path inventory mismatch" >&2
  exit 68
fi

echo "Rebuilt publication payload at $source_commit."
echo "SHA-256: $actual_hash"
