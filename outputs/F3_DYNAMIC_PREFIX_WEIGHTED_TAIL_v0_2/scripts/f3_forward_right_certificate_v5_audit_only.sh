#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
output_root="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2"
source "$output_root/scripts/f3_forward_right_certificate_v4_common.sh"

v4_result="$output_root/results/F3_FORWARD_RIGHT_CERTIFICATE_V4"
compile_log="$v4_result/v4_compile_raw.txt"
audit_log="$v4_result/v4_audit_raw.txt"
k1_log="$v4_result/v4_k1_raw.txt"
terminal_report="$v4_result/F3_FORWARD_RIGHT_CERTIFICATE_V4_TERMINAL_REPORT.md"
probe_source="$output_root/scripts/f3_forward_right_certificate_v5_unsafe_codegen_probe.lean"
producer_head='727e43fe3e739c8fbec428c30ada322415f1e1fb'

check_hash "$probe_source" \
  4efe62b76345aba575a880c23033ae28f7add1a54812e4f7827f3976d73afc72
check_hash "$terminal_report" \
  91c9b48f076b890cf24db3aa332bf1a592721b10432229ee7d8523c24b428507
check_hash "$compile_log" \
  ea398caeb54181bc601d6b638755f0e703cdf7f40e5fdfef07f2d0db8248b431
check_hash "$audit_log" \
  43a34ed395e89ac837adcc3df2cecfeb8efb017cb7ad82bce1d21805878e51f1
check_hash "$k1_log" \
  0e82877bc975f99f535096d2eb6c01c884c03b9f9b2bb7fcb9b4122b08a56d38

test "$(unique_value F3_FORWARD_V4_C0 "$compile_log")" = 'PASS'
test "$(unique_value F3_FORWARD_V4_C0_LEAN_EXIT_STATUS "$compile_log")" = '0'
test "$(unique_value F3_FORWARD_V4_C0_WRAPPER_EXIT_STATUS "$compile_log")" = '0'
test "$(unique_value F3_FORWARD_V4_C0_HEAD "$compile_log")" = "$producer_head"
test "$(unique_value F3_FORWARD_V4_A1 "$audit_log")" = 'PASS'
test "$(unique_value F3_FORWARD_V4_A1_LEAN_EXIT_STATUS "$audit_log")" = '0'
test "$(unique_value F3_FORWARD_V4_A1_WRAPPER_EXIT_STATUS "$audit_log")" = '0'
test "$(unique_value F3_FORWARD_V4_A1_HEAD "$audit_log")" = "$producer_head"
test "$(unique_value F3_FORWARD_V4_K1_PRECHECK_STATUS "$k1_log")" = '0'
test "$(unique_value F3_FORWARD_V4_K1_WRAPPER_EXIT_STATUS "$k1_log")" = '1'
if grep -Eq '^F3_FORWARD_V4_K1=PASS$' "$k1_log"; then
  exit 1
fi

verify_base_environment 211 2 213
check_hash "$target_olean" \
  376390a3f8fc72d2058a19c2b0028d08280a210a074ec88fd60a942781f017af
check_hash "$target_ilean" \
  9a479f85f00eb0bafb48a8ccdb52ef044ab2188ca39a4b8c5451d2777089ef57
check_hash "$audit_olean" \
  ca63fc1f43ae8da04347f2add16c8f42997cbd0bfdc6c39f886f067092148bba
check_hash "$audit_ilean" \
  55c10ae0d582ee52215ba5ae0ba26402466a3fccc32e2f82872903729f69aa31
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
test "$namespace_count" = '129'
test "$profile_count" = '129'
test "$unique_profile_count" = '129'

read -r stable_count generated_count list_filter_count list_fold_count \
    nat_cast_count lcproof_count < <(
  awk '
    BEGIN {
      prefix = "CollatzClassical.KL2003.F3ForwardFormulaRightCertificate."
      listOwner = prefix "lowerForwardRowNat._cstage2"
      castOwner = prefix "forwardRightWeight._cstage2"
      listFilter = "List[.]filterTR[.]loop[.]_at[.]CollatzClassical[.]KL2003[.]F3ForwardFormulaRightCertificate[.]lowerForwardRowNat[.]_spec_1"
      listFold = "List[.]foldrTR[.]_at[.]CollatzClassical[.]KL2003[.]F3ForwardFormulaRightCertificate[.]lowerForwardRowNat[.]_spec_2"
      natCast = "Nat[.]cast[.]_at[.]Real[.]instNatCast[.]_spec_2"
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
        generated_count += 1
        lcproof_count += gsub(/lcProof/, "", remaining)
        if (current == listOwner) {
          list_filter_count += gsub(listFilter, "", remaining)
          list_fold_count += gsub(listFold, "", remaining)
        } else if (current == castOwner) {
          nat_cast_count += gsub(natCast, "", remaining)
        }
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
      if (stable_count != 21 || generated_count != 108 ||
          list_filter_count != 1 || list_fold_count != 1 ||
          nat_cast_count != 1 || lcproof_count != 3 ||
          bad_stable || bad_generated || incomplete) exit 1
      print stable_count, generated_count, list_filter_count,
        list_fold_count, nat_cast_count, lcproof_count
    }
  ' "$source_file" "$audit_log"
)

if grep -Eq 'Lean[.]ofReduceBool|sorryAx|native_decide' \
    "$compile_log" "$audit_log"; then
  exit 1
fi
if grep -Eq 'native_decide|ofReduceBool|sorryAx|sorry|admit' \
    "$source_file" "$audit_file"; then
  exit 1
fi

/usr/bin/time -p env LC_ALL=C LANG=C LEAN_PATH="$lean_path" \
  "$lean_bin" "--root=$repo" --stdin < "$probe_source"

verify_base_environment 211 2 213
check_hash "$target_olean" \
  376390a3f8fc72d2058a19c2b0028d08280a210a074ec88fd60a942781f017af
check_hash "$target_ilean" \
  9a479f85f00eb0bafb48a8ccdb52ef044ab2188ca39a4b8c5451d2777089ef57
check_hash "$audit_olean" \
  ca63fc1f43ae8da04347f2add16c8f42997cbd0bfdc6c39f886f067092148bba
check_hash "$audit_ilean" \
  55c10ae0d582ee52215ba5ae0ba26402466a3fccc32e2f82872903729f69aa31
test "$(global_new_objects)" = "$expected_objects"

printf '%s\n' \
  'F3_FORWARD_V5_AUDIT_ONLY=PASS_WITH_EXPLICIT_CODEGEN_SPEC_EXCEPTIONS' \
  "F3_FORWARD_V5_STABLE_DECLARATIONS=$stable_count" \
  "F3_FORWARD_V5_GENERATED_DECLARATIONS=$generated_count" \
  "F3_FORWARD_V5_NAMESPACE_PROFILES=$profile_count" \
  'F3_FORWARD_V5_EXACT_UNSAFE_SPEC_AXIOMS=3' \
  'F3_FORWARD_V5_EXACT_UNSAFE_CODEGEN_OWNERS=2' \
  "F3_FORWARD_V5_LCPROOF_OCCURRENCES=$lcproof_count" \
  'F3_FORWARD_V5_STABLE_CODEGEN_AXIOMS=0' \
  'F3_FORWARD_V5_FORBIDDEN_AXIOMS=ABSENT' \
  'F3_FORWARD_V5_OBJECTS_UNCHANGED=PASS'
