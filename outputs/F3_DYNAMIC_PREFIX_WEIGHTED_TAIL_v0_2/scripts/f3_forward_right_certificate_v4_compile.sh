#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
source "$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_forward_right_certificate_v4_common.sh"

result_dir="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_FORWARD_RIGHT_CERTIFICATE_V4"
probe_log="$result_dir/v4_probe_raw.txt"
test "$(unique_value F3_FORWARD_V4_IMPORT_PROBE "$probe_log")" = 'PASS'
test "$(unique_value F3_FORWARD_V4_D0_WRAPPER_EXIT_STATUS "$probe_log")" = '0'
verify_base_environment 209 0 209
test -z "$(global_new_objects)"

/usr/bin/time -p env LC_ALL=C LANG=C LEAN_PATH="$lean_path" \
  "$lean_bin" "--root=$repo" \
  -o "$target_olean" \
  -i "$target_ilean" \
  "$source_file"

test -f "$target_olean"
test -f "$target_ilean"
test ! -L "$target_olean"
test ! -L "$target_ilean"
verify_base_environment 210 1 211
expected_objects=$(printf '%s\n%s\n' "$target_ilean" "$target_olean" | LC_ALL=C sort)
test "$(global_new_objects)" = "$expected_objects"

printf '%s\n' \
  'F3_FORWARD_V4_C0=PASS' \
  'F3_FORWARD_V4_C0_LEAN_EXIT_STATUS=0'
printf 'F3_FORWARD_V4_C0_HEAD=%s\n' "$(git -C "$repo" rev-parse HEAD)"
printf 'F3_FORWARD_V4_TARGET_OLEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$target_olean" | awk '{print $1}')"
printf 'F3_FORWARD_V4_TARGET_ILEAN_SHA256=%s\n' \
  "$(shasum -a 256 "$target_ilean" | awk '{print $1}')"
