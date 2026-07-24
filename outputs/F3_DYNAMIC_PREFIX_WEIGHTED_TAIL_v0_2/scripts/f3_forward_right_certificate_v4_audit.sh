#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
source "$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_forward_right_certificate_v4_common.sh"

result_dir="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_FORWARD_RIGHT_CERTIFICATE_V4"
compile_log="$result_dir/v4_compile_raw.txt"
test "$(unique_value F3_FORWARD_V4_C0 "$compile_log")" = 'PASS'
test "$(unique_value F3_FORWARD_V4_C0_LEAN_EXIT_STATUS "$compile_log")" = '0'
test "$(unique_value F3_FORWARD_V4_C0_WRAPPER_EXIT_STATUS "$compile_log")" = '0'
c0_head=$(unique_value F3_FORWARD_V4_C0_HEAD "$compile_log")
test "$c0_head" = "$(git -C "$repo" rev-parse HEAD)"
test "$c0_head" = "$(git -C "$repo" rev-parse public/codex/hilo2-f3-forward-right-certificate-v4)"
target_olean_hash=$(unique_value F3_FORWARD_V4_TARGET_OLEAN_SHA256 "$compile_log")
target_ilean_hash=$(unique_value F3_FORWARD_V4_TARGET_ILEAN_SHA256 "$compile_log")

verify_base_environment 210 1 211
test "$(file_hash "$target_olean")" = "$target_olean_hash"
test "$(file_hash "$target_ilean")" = "$target_ilean_hash"
expected_before=$(printf '%s\n%s\n' "$target_ilean" "$target_olean" | LC_ALL=C sort)
test "$(global_new_objects)" = "$expected_before"

/usr/bin/time -p env LC_ALL=C LANG=C LEAN_PATH="$lean_path" \
  "$lean_bin" "--root=$repo" \
  -o "$audit_olean" \
  -i "$audit_ilean" \
  "$audit_file"

test -f "$audit_olean"
test -f "$audit_ilean"
test ! -L "$audit_olean"
test ! -L "$audit_ilean"
test "$(file_hash "$target_olean")" = "$target_olean_hash"
test "$(file_hash "$target_ilean")" = "$target_ilean_hash"
verify_base_environment 211 2 213
expected_after=$(printf '%s\n%s\n%s\n%s\n' \
  "$audit_ilean" "$audit_olean" "$target_ilean" "$target_olean" | LC_ALL=C sort)
test "$(global_new_objects)" = "$expected_after"

printf '%s\n' \
  'F3_FORWARD_V4_A1=PASS' \
  'F3_FORWARD_V4_A1_LEAN_EXIT_STATUS=0'
printf 'F3_FORWARD_V4_A1_HEAD=%s\n' "$(git -C "$repo" rev-parse HEAD)"
printf 'F3_FORWARD_V4_AUDIT_OLEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$audit_olean" | awk '{print $1}')"
printf 'F3_FORWARD_V4_AUDIT_ILEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$audit_ilean" | awk '{print $1}')"
