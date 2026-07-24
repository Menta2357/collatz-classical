#!/usr/bin/env bash
set -euo pipefail

repo_root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
donor_root='/Users/MoiTam/Documents/Codex/collatz-classical'
overlay_base="$repo_root/.lake/f3-full-block-decoder-overlay"
overlay_root="$overlay_base/lib/lean"
overlay_package="$overlay_root/CollatzClassical/KL2003"

repair_source="$repo_root/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean"
exact_source="$donor_root/.lake/build/lib/lean/CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.olean"
repair_target="$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean"
exact_target="$overlay_package/F3ReturnExcursionExactCoreMatrix.olean"

repair_hash='480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372'
exact_hash='34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798'

test ! -e "$overlay_base"
test "$(shasum -a 256 "$repair_source" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$exact_source" | awk '{print $1}')" = "$exact_hash"

mkdir -p "$overlay_package"
/bin/cp -p "$repair_source" "$repair_target"
/bin/cp -p "$exact_source" "$exact_target"

test "$(shasum -a 256 "$repair_target" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$exact_target" | awk '{print $1}')" = "$exact_hash"
test "$(find "$overlay_root" -type f | wc -l | tr -d ' ')" = '2'
test "$(find "$overlay_root" -type l | wc -l | tr -d ' ')" = '0'

printf '%s\n' \
  'FULL_BLOCK_OVERLAY_STAGE=PASS' \
  "FULL_BLOCK_OVERLAY_ROOT=$overlay_root" \
  "FULL_BLOCK_REPAIR_SHA256=$repair_hash" \
  "FULL_BLOCK_EXACT_CORE_SHA256=$exact_hash" \
  'FULL_BLOCK_OVERLAY_FILE_COUNT=2' \
  'FULL_BLOCK_OVERLAY_SYMLINK_COUNT=0'
