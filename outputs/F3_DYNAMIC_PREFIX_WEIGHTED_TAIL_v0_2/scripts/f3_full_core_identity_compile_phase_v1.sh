#!/usr/bin/env bash
set -euo pipefail

repo_root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
overlay_root="$repo_root/.lake/f3-full-core-identity-overlay/lib/lean"
overlay_package="$overlay_root/CollatzClassical/KL2003"
source_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.lean"
result_dir="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_v1"
s0_log="$result_dir/v1_overlay_stage_raw.txt"
target_olean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean"
target_ilean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.ilean"
lean_bin='/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean'
lean_path="$overlay_root:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean"

source_hash='df1e2a1582e02c9c73c354ecb72705bd828a61ab53501bd88a7d2bf6e654937b'
exact_hash='34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798'
repair_hash='480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372'
decoder_hash='225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec'

unique_value() {
  local key=$1
  local file=$2
  awk -F '=' -v key="$key" '
    $1 == key { count += 1; value = substr($0, index($0, "=") + 1) }
    END { if (count != 1) exit 1; print value }
  ' "$file"
}

test "$(unique_value FULL_CORE_IDENTITY_OVERLAY_STAGE "$s0_log")" = 'PASS'
test "$(unique_value FULL_CORE_IDENTITY_S0_WRAPPER_EXIT_STATUS "$s0_log")" = '0'

test "$(shasum -a 256 "$source_file" | awk '{print $1}')" = "$source_hash"
test -f "$source_file"
test ! -L "$source_file"
test -f "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean"
test ! -L "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean"
test -f "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean"
test ! -L "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean"
test -f "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean"
test ! -L "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean" | awk '{print $1}')" = "$exact_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean" | awk '{print $1}')" = "$decoder_hash"
test "$(shasum -a 256 "$source_file" | awk '{print $1}')" = "$source_hash"
test "$(find "$overlay_root" -type f | wc -l | tr -d ' ')" = '3'
test "$(find "$overlay_root" -type l | wc -l | tr -d ' ')" = '0'
test ! -e "$target_olean"
test ! -e "$target_ilean"

printf '%s\n' 'FULL_CORE_IDENTITY_C0_PREFLIGHT=PASS'
printf 'FULL_CORE_IDENTITY_C0_SOURCE_SHA256=%s\n' "$source_hash"
printf 'FULL_CORE_IDENTITY_C0_EXACT_CORE_SHA256=%s\n' "$exact_hash"
printf 'FULL_CORE_IDENTITY_C0_REPAIR_SHA256=%s\n' "$repair_hash"
printf 'FULL_CORE_IDENTITY_C0_DECODER_SHA256=%s\n' "$decoder_hash"

set +e
/usr/bin/time -p env LEAN_PATH="$lean_path" "$lean_bin" \
  --root="$repo_root" \
  -o "$target_olean" \
  -i "$target_ilean" \
  "$source_file"
lean_status=$?
set -e

printf 'FULL_CORE_IDENTITY_C0_LEAN_EXIT_STATUS=%s\n' "$lean_status"
if [[ "$lean_status" -ne 0 ]]; then
  exit "$lean_status"
fi

test -f "$target_olean"
test -f "$target_ilean"
test "$(find "$overlay_root" -type f | wc -l | tr -d ' ')" = '5'
test "$(find "$overlay_root" -type l | wc -l | tr -d ' ')" = '0'
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean" | awk '{print $1}')" = "$exact_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean" | awk '{print $1}')" = "$decoder_hash"
test "$(shasum -a 256 "$source_file" | awk '{print $1}')" = "$source_hash"

printf '%s\n' \
  'FULL_CORE_IDENTITY_C0=PASS' \
  'FULL_CORE_IDENTITY_OVERLAY_FILE_COUNT_AFTER_C0=5' \
  'FULL_CORE_IDENTITY_OVERLAY_SYMLINK_COUNT_AFTER_C0=0'
printf 'FULL_CORE_IDENTITY_OLEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$target_olean" | awk '{print $1}')"
printf 'FULL_CORE_IDENTITY_ILEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$target_ilean" | awk '{print $1}')"
