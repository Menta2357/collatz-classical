#!/usr/bin/env bash
set -euo pipefail

repo_root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
overlay_root="$repo_root/.lake/f3-full-core-identity-v2-overlay/lib/lean"
overlay_package="$overlay_root/CollatzClassical/KL2003"
source_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.lean"
audit_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.lean"
result_dir="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_v1"
c0_log="$result_dir/v2_compile_raw.txt"
identity_olean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean"
identity_ilean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.ilean"
audit_olean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.olean"
audit_ilean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.ilean"
lean_bin='/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean'
lean_path="$overlay_root:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Cli/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/batteries/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/Qq/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/aesop/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/proofwidgets/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/importGraph/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/plausible/.lake/build/lib/lean:/Users/MoiTam/Documents/Codex/collatz-classical/.lake/packages/mathlib/.lake/build/lib/lean:/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean"

source_hash='6bfd513abedf81c980e818b20efff46fc720dafabb710031c0e5aba1d5abffad'
audit_hash='7a712c1844f799e43c4be26707b4ea71b5c424322c010098bdc48843ce4e2796'
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

test "$(unique_value FULL_CORE_IDENTITY_V2_C0 "$c0_log")" = 'PASS'
test "$(unique_value FULL_CORE_IDENTITY_V2_C0_LEAN_EXIT_STATUS "$c0_log")" = '0'
test "$(unique_value FULL_CORE_IDENTITY_V2_C0_WRAPPER_EXIT_STATUS "$c0_log")" = '0'
test "$(unique_value FULL_CORE_IDENTITY_V2_C0_SOURCE_SHA256 "$c0_log")" = "$source_hash"
test "$(unique_value FULL_CORE_IDENTITY_V2_C0_EXACT_CORE_SHA256 "$c0_log")" = "$exact_hash"
test "$(unique_value FULL_CORE_IDENTITY_V2_C0_REPAIR_SHA256 "$c0_log")" = "$repair_hash"
test "$(unique_value FULL_CORE_IDENTITY_V2_C0_DECODER_SHA256 "$c0_log")" = "$decoder_hash"
c0_identity_olean_hash=$(unique_value FULL_CORE_IDENTITY_V2_OLEAN_SHA256 "$c0_log")
c0_identity_ilean_hash=$(unique_value FULL_CORE_IDENTITY_V2_ILEAN_SHA256 "$c0_log")

test -f "$source_file"
test ! -L "$source_file"
test -f "$audit_file"
test ! -L "$audit_file"
test "$(shasum -a 256 "$source_file" | awk '{print $1}')" = "$source_hash"
test "$(shasum -a 256 "$audit_file" | awk '{print $1}')" = "$audit_hash"
test -f "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean"
test ! -L "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean"
test -f "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean"
test ! -L "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean"
test -f "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean"
test ! -L "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean" | awk '{print $1}')" = "$exact_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean" | awk '{print $1}')" = "$decoder_hash"
test -f "$identity_olean"
test ! -L "$identity_olean"
test -f "$identity_ilean"
test ! -L "$identity_ilean"
test "$(shasum -a 256 "$identity_olean" | awk '{print $1}')" = "$c0_identity_olean_hash"
test "$(shasum -a 256 "$identity_ilean" | awk '{print $1}')" = "$c0_identity_ilean_hash"
test "$(find "$overlay_root" -type f | wc -l | tr -d ' ')" = '5'
test "$(find "$overlay_root" -type l | wc -l | tr -d ' ')" = '0'
test ! -e "$audit_olean"
test ! -e "$audit_ilean"

identity_olean_hash=$(shasum -a 256 "$identity_olean" | awk '{print $1}')
identity_ilean_hash=$(shasum -a 256 "$identity_ilean" | awk '{print $1}')

printf '%s\n' 'FULL_CORE_IDENTITY_V2_A1_PREFLIGHT=PASS'
printf 'FULL_CORE_IDENTITY_V2_A1_SOURCE_SHA256=%s\n' "$source_hash"
printf 'FULL_CORE_IDENTITY_V2_A1_AUDIT_SOURCE_SHA256=%s\n' "$audit_hash"
printf 'FULL_CORE_IDENTITY_V2_INPUT_OLEAN_SHA256=%s\n' "$identity_olean_hash"
printf 'FULL_CORE_IDENTITY_V2_INPUT_ILEAN_SHA256=%s\n' "$identity_ilean_hash"

set +e
/usr/bin/time -p env LEAN_PATH="$lean_path" "$lean_bin" \
  --root="$repo_root" \
  -o "$audit_olean" \
  -i "$audit_ilean" \
  "$audit_file"
lean_status=$?
set -e

printf 'FULL_CORE_IDENTITY_V2_A1_LEAN_EXIT_STATUS=%s\n' "$lean_status"
if [[ "$lean_status" -ne 0 ]]; then
  exit "$lean_status"
fi

test -f "$audit_olean"
test ! -L "$audit_olean"
test -f "$audit_ilean"
test ! -L "$audit_ilean"
test "$(find "$overlay_root" -type f | wc -l | tr -d ' ')" = '7'
test "$(find "$overlay_root" -type l | wc -l | tr -d ' ')" = '0'
test "$(shasum -a 256 "$identity_olean" | awk '{print $1}')" = "$identity_olean_hash"
test "$(shasum -a 256 "$identity_ilean" | awk '{print $1}')" = "$identity_ilean_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionExactCoreMatrix.olean" | awk '{print $1}')" = "$exact_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean" | awk '{print $1}')" = "$decoder_hash"
test "$(shasum -a 256 "$source_file" | awk '{print $1}')" = "$source_hash"
test "$(shasum -a 256 "$audit_file" | awk '{print $1}')" = "$audit_hash"

printf '%s\n' \
  'FULL_CORE_IDENTITY_V2_A1=PASS' \
  'FULL_CORE_IDENTITY_V2_OVERLAY_FILE_COUNT_AFTER_A1=7' \
  'FULL_CORE_IDENTITY_V2_OVERLAY_SYMLINK_COUNT_AFTER_A1=0'
printf 'FULL_CORE_IDENTITY_V2_AUDIT_OLEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$audit_olean" | awk '{print $1}')"
printf 'FULL_CORE_IDENTITY_V2_AUDIT_ILEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$audit_ilean" | awk '{print $1}')"
