#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
source "$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/scripts/f3_forward_right_certificate_v4_common.sh"

result_dir="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_FORWARD_RIGHT_CERTIFICATE_V4"
compile_log="$result_dir/v4_compile_raw.txt"
audit_log="$result_dir/v4_audit_raw.txt"

test "$(unique_value F3_FORWARD_V4_C0 "$compile_log")" = 'PASS'
test "$(unique_value F3_FORWARD_V4_C0_LEAN_EXIT_STATUS "$compile_log")" = '0'
test "$(unique_value F3_FORWARD_V4_C0_WRAPPER_EXIT_STATUS "$compile_log")" = '0'
test "$(unique_value F3_FORWARD_V4_A1 "$audit_log")" = 'PASS'
test "$(unique_value F3_FORWARD_V4_A1_LEAN_EXIT_STATUS "$audit_log")" = '0'
test "$(unique_value F3_FORWARD_V4_A1_WRAPPER_EXIT_STATUS "$audit_log")" = '0'
c0_head=$(unique_value F3_FORWARD_V4_C0_HEAD "$compile_log")
a1_head=$(unique_value F3_FORWARD_V4_A1_HEAD "$audit_log")
test "$c0_head" = "$a1_head"
test "$c0_head" = "$(git -C "$repo" rev-parse HEAD)"
test "$c0_head" = "$(git -C "$repo" rev-parse public/codex/hilo2-f3-forward-right-certificate-v4)"

target_olean_hash=$(unique_value F3_FORWARD_V4_TARGET_OLEAN_SHA256 "$compile_log")
target_ilean_hash=$(unique_value F3_FORWARD_V4_TARGET_ILEAN_SHA256 "$compile_log")
audit_olean_hash=$(unique_value F3_FORWARD_V4_AUDIT_OLEAN_SHA256 "$audit_log")
audit_ilean_hash=$(unique_value F3_FORWARD_V4_AUDIT_ILEAN_SHA256 "$audit_log")

verify_base_environment 211 2 213
test "$(file_hash "$target_olean")" = "$target_olean_hash"
test "$(file_hash "$target_ilean")" = "$target_ilean_hash"
test "$(file_hash "$audit_olean")" = "$audit_olean_hash"
test "$(file_hash "$audit_ilean")" = "$audit_ilean_hash"
expected_objects=$(printf '%s\n%s\n%s\n%s\n' \
  "$audit_ilean" "$audit_olean" "$target_ilean" "$target_olean" | LC_ALL=C sort)
test "$(global_new_objects)" = "$expected_objects"

source_names=$(awk '
  $1 == "def" || $1 == "theorem" { print $2 }
' "$source_file")
audit_names=$(awk '
  $1 == "#print" && $2 == "axioms" { print $3 }
' "$audit_file")
test "$(printf '%s\n' "$source_names" | wc -l | tr -d ' ')" = '21'
test "$(printf '%s\n' "$audit_names" | wc -l | tr -d ' ')" = '21'
test "$source_names" = "$audit_names"

read -r count_line_count namespace_count profile_count unique_profile_count < <(
  awk -F '\t' '
    /NAMESPACE_DECLARATION_COUNT=[0-9]+/ {
      count_lines += 1
      value = $0
      sub(/^.*NAMESPACE_DECLARATION_COUNT=/, "", value)
      sub(/[^0-9].*$/, "", value)
      namespace_count = value + 0
    }
    /^AXIOM_PROFILE[[:space:]]/ {
      profiles += 1
      if (!seen[$2]++) unique_profiles += 1
    }
    END {
      print count_lines + 0, namespace_count + 0,
        profiles + 0, unique_profiles + 0
    }
  ' "$audit_log"
)
test "$count_line_count" = '1'
test "$namespace_count" -ge '21'
test "$profile_count" = "$namespace_count"
test "$unique_profile_count" = "$namespace_count"

awk '
  BEGIN {
    prefix = "CollatzClassical.KL2003.F3ForwardFormulaRightCertificate."
  }
  FNR == NR {
    if ($1 == "def" || $1 == "theorem") stable[prefix $2] = 1
    next
  }
  function strip_logical(text) {
    gsub(/propext/, "", text)
    gsub(/Classical[.]choice/, "", text)
    gsub(/Quot[.]sound/, "", text)
    gsub(/[\[\],[:space:]]/, "", text)
    return text
  }
  function finish_profile(remaining) {
    if (current == "") return
    remaining = strip_logical(profile)
    if (current in stable) {
      if (remaining != "") bad_stable = 1
      stable_seen[current] += 1
    } else {
      gsub(/lcProof/, "", remaining)
      if (remaining != "") bad_generated = 1
    }
    current = ""
    profile = ""
    active = 0
  }
  /^AXIOM_PROFILE\t/ {
    if (active) incomplete = 1
    finish_profile()
    split($0, fields, "\t")
    current = fields[2]
    profile = fields[3]
    active = index($0, "]") == 0
    if (!active) finish_profile()
    next
  }
  active {
    profile = profile " " $0
    if (index($0, "]") != 0) {
      active = 0
      finish_profile()
    }
  }
  END {
    if (active) incomplete = 1
    finish_profile()
    for (name in stable) {
      stable_count += 1
      if (stable_seen[name] != 1) bad_stable = 1
    }
    if (stable_count != 21 || bad_stable || bad_generated || incomplete) exit 1
  }
' "$source_file" "$audit_log"

if grep -Eq 'Lean[.]ofReduceBool|sorryAx|native_decide' \
    "$compile_log" "$audit_log"; then
  exit 1
fi
if grep -Eq 'native_decide|ofReduceBool|sorryAx|sorry|admit' "$source_file"; then
  exit 1
fi

printf '%s\n' \
  'F3_FORWARD_V4_K1=PASS' \
  'F3_FORWARD_V4_STABLE_DECLARATIONS=21' \
  'F3_FORWARD_V4_EXPLICIT_AXIOM_AUDITS=21' \
  "F3_FORWARD_V4_NAMESPACE_DECLARATIONS=$namespace_count" \
  "F3_FORWARD_V4_AXIOM_PROFILES=$profile_count" \
  "F3_FORWARD_V4_UNIQUE_PROFILE_NAMES=$unique_profile_count" \
  'F3_FORWARD_V4_STABLE_ALLOWED_AXIOM_SET_ONLY=PASS' \
  'F3_FORWARD_V4_GENERATED_ALLOWED_SET_PLUS_LCPROOF=PASS' \
  'F3_FORWARD_V4_FULL_LOG_FORBIDDEN_AXIOMS=ABSENT'
