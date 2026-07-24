#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf '%s\n' 'usage: phase-executor R0|S0|C0|A1|K1' >&2
  exit 2
fi

phase=$1
repo_root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
output_root="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2"
script_dir="$output_root/scripts"
result_dir="$output_root/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_v1"
result_report="$result_dir/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_RUN_REPORT_v1.md"
overlay_base="$repo_root/.lake/f3-full-core-identity-v2-overlay"

r0_log="$result_dir/v2_guard_regression_raw.txt"
s0_log="$result_dir/v2_overlay_stage_raw.txt"
c0_log="$result_dir/v2_compile_raw.txt"
a1_log="$result_dir/v2_axiom_audit_raw.txt"
k1_log="$result_dir/v2_axiom_log_checker.txt"

source_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.lean"
audit_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.lean"
inventory_file="$output_root/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_DECLARATION_INVENTORY_v1.tsv"
guard="$script_dir/f3_axiom_audit_log_guard_v2.sh"
guard_regression="$script_dir/f3_axiom_audit_log_guard_v2_regression.sh"
bad_fixture="$output_root/fixtures/F3_AXIOM_AUDIT_MULTILINE_FORBIDDEN_v1.txt"
overlay_stage="$script_dir/f3_full_core_identity_v2_overlay_stage_v1.sh"
compile_wrapper="$script_dir/f3_full_core_identity_v2_compile_phase_v1.sh"
audit_wrapper="$script_dir/f3_full_core_identity_v2_audit_phase_v1.sh"
inventory_checker="$script_dir/f3_full_core_identity_v2_inventory_check_v1.sh"

parent_result_dir="$output_root/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_v1"
parent_report="$parent_result_dir/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_RUN_REPORT_v1.md"
parent_r0_log="$parent_result_dir/v1_guard_regression_raw.txt"
parent_s0_log="$parent_result_dir/v1_overlay_stage_raw.txt"
parent_c0_log="$parent_result_dir/v1_compile_raw.txt"
r0_good_log="$output_root/results/F3_CORE_ARITHMETIC_CODEC_PILOT_REPAIR_V6_OVERLAY_AUDIT_v1/v6_axiom_audit_raw.txt"

decoder_source="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.lean"
repair_source="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.lean"
exact_source="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionExactCoreMatrix.lean"
first_hit_contract="$output_root/F3_SEMANTIC_FIRST_HIT_GATE_CONTRACT_v1.md"
donor_manifest='/Users/MoiTam/Documents/Codex/collatz-classical/lake-manifest.json'
toolchain_file="$repo_root/lean-toolchain"
donor_overlay="$repo_root/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003"

source_hash='6bfd513abedf81c980e818b20efff46fc720dafabb710031c0e5aba1d5abffad'
audit_hash='7a712c1844f799e43c4be26707b4ea71b5c424322c010098bdc48843ce4e2796'
inventory_hash='3cf3d62def66d381f609192ae44114afe6b43e455fa2b2ff11847618723aa7a4'
guard_hash='b064ecce31dd3d15b707b49b9ba3a0521d0070f8e46f138ac045499445e29b70'
guard_regression_hash='8f281c679fc06562be4b3a3608d99798e02492089811c0ad696533947fff56bc'
bad_fixture_hash='b8f9116a885f21db8cbc387b8d16ce8247312c5ad2c5726ec376e3059e99ef0c'
overlay_stage_hash='9cb0da0964be1528ef71a1232256719757ce84dd10b7a142260223c59198b7c7'
compile_wrapper_hash='7a7cb21807a188d51b5efadf711c9d765c1e0bb9d765da1f46b0382241282e3d'
audit_wrapper_hash='3dc1cfd4d673954ab5015f4eea2b1befa88f0040d1556ed7079faf949e5f3347'
inventory_checker_hash='b5e46c42b9b139b0ec203483283c2eb7e19b5bfa7075b7612b1b9cb5e21ca83a'

parent_report_hash='008f88f525e431717e6f4954c400c2de6ff47ca1e950ee8c14c3a27616e23e3a'
parent_r0_hash='6cc31ee430fb5a0c28032bdc5b6a91387f15a62f37653c3b7d4d1e23c5ab55f3'
parent_s0_hash='6cff016f93d41eb24ef8daae893c86ab1ec27bd76a20f1e3c2ab34b4e9de2963'
parent_c0_hash='fb0a2e3f780d65bdf2310fdf5916002797b76fb84a0408447c0afbd66a3cfa20'
r0_good_log_hash='76493a39a7e90e1eb833ba4c59112b9061204c66dcee8babee7f659ddde47ace'

decoder_source_hash='1715e45e2395f25bf4d4ac0e27c6ae9cc0dff3fc651e67e1e666be1684541ed1'
repair_source_hash='e5683405008b438d8a7c00747e4e81384962d95ced0d759d42c18f05ff62219c'
exact_source_hash='58ab7b1acdb7bc6d69fffa04c4baa7ae29ac31e24e80834387974113b70d2ba5'
first_hit_contract_hash='b5f022271bbd696df2a1b2e9205a36d8ad134e058fe29adbf5b1565f167c44fa'
manifest_hash='230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b'
toolchain_hash='d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c'
exact_olean_hash='34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798'
repair_olean_hash='480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372'
decoder_olean_hash='225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec'

sha256_of() {
  shasum -a 256 "$1" | awk '{print $1}'
}

require_regular_hash() {
  local file=$1
  local expected=$2
  test -f "$file"
  test ! -L "$file"
  test "$(sha256_of "$file")" = "$expected"
}

unique_value() {
  local key=$1
  local file=$2
  awk -F '=' -v key="$key" '
    $1 == key { count += 1; value = substr($0, index($0, "=") + 1) }
    END { if (count != 1) exit 1; print value }
  ' "$file"
}

expect_value() {
  local key=$1
  local file=$2
  local expected=$3
  local actual
  actual=$(unique_value "$key" "$file") || return 1
  test "$actual" = "$expected"
}

expect_result_file_count() {
  local expected=$1
  test "$(find "$result_dir" -type f | wc -l | tr -d ' ')" = "$expected"
  test "$(find "$result_dir" -type l | wc -l | tr -d ' ')" = '0'
}

common_precheck() {
  require_regular_hash "$source_file" "$source_hash" || return 1
  require_regular_hash "$audit_file" "$audit_hash" || return 1
  require_regular_hash "$inventory_file" "$inventory_hash" || return 1
  require_regular_hash "$guard" "$guard_hash" || return 1
  require_regular_hash "$guard_regression" "$guard_regression_hash" || return 1
  require_regular_hash "$bad_fixture" "$bad_fixture_hash" || return 1
  require_regular_hash "$overlay_stage" "$overlay_stage_hash" || return 1
  require_regular_hash "$compile_wrapper" "$compile_wrapper_hash" || return 1
  require_regular_hash "$audit_wrapper" "$audit_wrapper_hash" || return 1
  require_regular_hash "$inventory_checker" "$inventory_checker_hash" || return 1

  require_regular_hash "$parent_report" "$parent_report_hash" || return 1
  require_regular_hash "$parent_r0_log" "$parent_r0_hash" || return 1
  require_regular_hash "$parent_s0_log" "$parent_s0_hash" || return 1
  require_regular_hash "$parent_c0_log" "$parent_c0_hash" || return 1
  require_regular_hash "$r0_good_log" "$r0_good_log_hash" || return 1

  require_regular_hash "$decoder_source" "$decoder_source_hash" || return 1
  require_regular_hash "$repair_source" "$repair_source_hash" || return 1
  require_regular_hash "$exact_source" "$exact_source_hash" || return 1
  require_regular_hash "$first_hit_contract" "$first_hit_contract_hash" || return 1
  require_regular_hash "$donor_manifest" "$manifest_hash" || return 1
  require_regular_hash "$toolchain_file" "$toolchain_hash" || return 1
  require_regular_hash "$donor_overlay/F3ReturnExcursionExactCoreMatrix.olean" "$exact_olean_hash" || return 1
  require_regular_hash "$donor_overlay/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean" "$repair_olean_hash" || return 1
  require_regular_hash "$donor_overlay/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean" "$decoder_olean_hash" || return 1

  test -d "$result_dir" || return 1
  test ! -L "$result_dir" || return 1
  test -f "$result_report" || return 1
  test ! -L "$result_report" || return 1
}

phase_precheck() {
  common_precheck || return 1
  case "$phase" in
    R0)
      test ! -e "$overlay_base" || return 1
      test ! -e "$s0_log" || return 1
      test ! -e "$c0_log" || return 1
      test ! -e "$a1_log" || return 1
      test ! -e "$k1_log" || return 1
      expect_result_file_count 2 || return 1
      ;;
    S0)
      expect_value V2_GUARD_REGRESSION "$r0_log" PASS || return 1
      expect_value V2_V6_GOOD_LOG "$r0_log" PASS || return 1
      expect_value V2_WRAPPED_FORBIDDEN_FIXTURE "$r0_log" REJECTED || return 1
      expect_value V2_NAMESPACE_DECLARATIONS "$r0_log" 640 || return 1
      expect_value V2_AXIOM_PROFILES "$r0_log" 640 || return 1
      expect_value V2_UNIQUE_PROFILE_NAMES "$r0_log" 640 || return 1
      expect_value V2_FULL_LOG_FORBIDDEN_AXIOMS "$r0_log" ABSENT || return 1
      expect_value FULL_CORE_IDENTITY_V2_R0_WRAPPER_EXIT_STATUS "$r0_log" 0 || return 1
      test ! -e "$overlay_base" || return 1
      test ! -e "$c0_log" || return 1
      test ! -e "$a1_log" || return 1
      test ! -e "$k1_log" || return 1
      expect_result_file_count 3 || return 1
      ;;
    C0)
      expect_value FULL_CORE_IDENTITY_V2_OVERLAY_STAGE "$s0_log" PASS || return 1
      expect_value FULL_CORE_IDENTITY_V2_S0_WRAPPER_EXIT_STATUS "$s0_log" 0 || return 1
      test ! -e "$a1_log" || return 1
      test ! -e "$k1_log" || return 1
      expect_result_file_count 4 || return 1
      ;;
    A1)
      expect_value FULL_CORE_IDENTITY_V2_C0 "$c0_log" PASS || return 1
      expect_value FULL_CORE_IDENTITY_V2_C0_LEAN_EXIT_STATUS "$c0_log" 0 || return 1
      expect_value FULL_CORE_IDENTITY_V2_C0_WRAPPER_EXIT_STATUS "$c0_log" 0 || return 1
      test ! -e "$k1_log" || return 1
      expect_result_file_count 5 || return 1
      ;;
    K1)
      expect_value FULL_CORE_IDENTITY_V2_A1 "$a1_log" PASS || return 1
      expect_value FULL_CORE_IDENTITY_V2_A1_LEAN_EXIT_STATUS "$a1_log" 0 || return 1
      expect_value FULL_CORE_IDENTITY_V2_A1_WRAPPER_EXIT_STATUS "$a1_log" 0 || return 1
      expect_result_file_count 6 || return 1
      ;;
  esac
}

case "$phase" in
  R0)
    cap=60
    log_path=$r0_log
    command=(/usr/bin/time -p bash "$guard_regression")
    ;;
  S0)
    cap=120
    log_path=$s0_log
    command=(/usr/bin/time -p bash "$overlay_stage")
    ;;
  C0)
    cap=600
    log_path=$c0_log
    command=(bash "$compile_wrapper")
    ;;
  A1)
    cap=450
    log_path=$a1_log
    command=(bash "$audit_wrapper")
    ;;
  K1)
    cap=60
    log_path=$k1_log
    command=(/usr/bin/time -p bash "$inventory_checker" --c0-log "$c0_log" --audit-log "$a1_log")
    ;;
  *)
    printf 'unknown phase: %s\n' "$phase" >&2
    exit 2
    ;;
esac

test -d "$result_dir"
test ! -L "$result_dir"
test ! -e "$log_path"
(set -o noclobber; : > "$log_path") 2>/dev/null

set +e
phase_precheck >> "$log_path" 2>&1
precheck_status=$?
set -e
printf 'FULL_CORE_IDENTITY_V2_%s_PRECHECK_STATUS=%s\n' \
  "$phase" "$precheck_status" >> "$log_path"
if [[ "$precheck_status" -ne 0 ]]; then
  printf 'FULL_CORE_IDENTITY_V2_%s_WRAPPER_EXIT_STATUS=%s\n' \
    "$phase" "$precheck_status" >> "$log_path"
  exit "$precheck_status"
fi

set +e
/opt/homebrew/bin/gtimeout --kill-after=5 "$cap" "${command[@]}" >> "$log_path" 2>&1
phase_status=$?
set -e

printf 'FULL_CORE_IDENTITY_V2_%s_WRAPPER_EXIT_STATUS=%s\n' \
  "$phase" "$phase_status" >> "$log_path"
exit "$phase_status"
