#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/clean-ca3dd0d-source-extract" >&2
  exit 64
fi

target=$1
if [ ! -d "$target" ]; then
  echo "target is not a directory: $target" >&2
  exit 65
fi

target_abs=$(CDPATH= cd -- "$target" && pwd -P)
case "$target_abs" in
  /|"$HOME")
    echo "refusing broad target: $target_abs" >&2
    exit 66
    ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
payload="$script_dir/weak-fixed-target-fusion-7plus2.tar.gz"

verify_hash() {
  expected=$1
  relative=$2
  path="$target_abs/$relative"
  if [ ! -f "$path" ]; then
    echo "missing base file: $relative" >&2
    exit 67
  fi
  actual=$(shasum -a 256 "$path" | awk '{print $1}')
  if [ "$actual" != "$expected" ]; then
    echo "base hash mismatch: $relative" >&2
    echo "expected $expected" >&2
    echo "actual   $actual" >&2
    exit 68
  fi
}

verify_hash 452e5441401dc724d8ee6bd6cd2f4e5334dcc7b9713b0dfc6b21d7af7e44667c \
  proofatlas-source-manifest.json
verify_hash cf8f99310847c1e3aeb4019a1dee229e5c437f0619495ac2818f3af8139a9d99 \
  Erdos1135/Basic.lean
verify_hash b445785f23832013be47e9309f0a3bf599120d5fb762a389dbe0dad1846673e3 \
  Erdos1135/ND/Conventions.lean
verify_hash 963db56eac013f0319e6b32f32b8240a296c7d0f6f9ee83a594209a7f874c5d6 \
  Erdos1135/ND/Statement.lean
verify_hash cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30 \
  LICENSE
verify_hash 78d24afa82e943d2bd65af48accb0a802d1debc12043394e398899fdaacb3a3c \
  NOTICE

if ! grep -q '"packageCommit": "ca3dd0d63920411213403092aecc6946619eb082"' \
    "$target_abs/proofatlas-source-manifest.json"; then
  echo "manifest does not name the ca3dd0d source pin" >&2
  exit 69
fi

payload_hash=$(shasum -a 256 "$payload" | awk '{print $1}')
if [ "$payload_hash" != \
    "4ceeb087ec3faa9ec95566888b6487dbabbc6317714c0e080dc44fd3b4d45b25" ]; then
  echo "payload hash mismatch" >&2
  exit 70
fi

archive_paths=$(tar -tzf "$payload" | sed '/\/$/d')
expected_paths=$(cat "$script_dir/payload-archive-files.txt")
if [ "$archive_paths" != "$expected_paths" ]; then
  echo "payload path inventory mismatch" >&2
  exit 71
fi

tar -xzf "$payload" -C "$target_abs"
cp "$script_dir/environment/lakefile.lean" "$target_abs/lakefile.lean"
cp "$script_dir/environment/lean-toolchain" "$target_abs/lean-toolchain"

(cd "$target_abs" && shasum -a 256 -c "$script_dir/candidate-files.sha256")

echo "H1 payload applied and candidate hashes verified."
echo "No build was run."
