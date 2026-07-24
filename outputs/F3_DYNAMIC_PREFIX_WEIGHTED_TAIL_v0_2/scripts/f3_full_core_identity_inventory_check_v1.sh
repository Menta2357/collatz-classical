#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/../../.." && pwd)

source_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.lean"
audit_file="$repo_root/CollatzClassical/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.lean"
inventory_file="$repo_root/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_DECLARATION_INVENTORY_v1.tsv"
guard="$script_dir/f3_axiom_audit_log_guard_v2.sh"
overlay_package="$repo_root/.lake/f3-full-core-identity-overlay/lib/lean/CollatzClassical/KL2003"
expected_count=9
c0_log_path=''
audit_log_path=''
terminal_theorems=(
  coreEdges_position_normalization
  coreEdges_length_kernel
  core_position_at_formula
  realize_mem_coreEdges
  formulaCoreList_subset_coreEdges
  coreEdges_perm_formulaCoreList
  coreMatrix_eq_fullFormulaMatrix
)

if [[ $# -ne 0 ]]; then
  if [[ $# -ne 4 || "$1" != '--c0-log' || "$3" != '--audit-log' ]]; then
    printf '%s\n' 'usage: checker [--c0-log PATH --audit-log PATH]' >&2
    exit 2
  fi
  c0_log_path=$2
  audit_log_path=$4
  test -r "$c0_log_path"
  test -r "$audit_log_path"
fi

unique_value() {
  local key=$1
  local file=$2
  awk -F '=' -v key="$key" '
    $1 == key { count += 1; value = substr($0, index($0, "=") + 1) }
    END { if (count != 1) exit 1; print value }
  ' "$file"
}

source_names() {
  sed -nE \
    's/^(@\[[^]]+\] )?(noncomputable )?(def|theorem|instance|abbrev|inductive) ([A-Za-z0-9_]+).*/\4/p' \
    "$source_file"
}

inventory_names() {
  awk -F '\t' '!/^#/ && $1 ~ /^[0-9]+$/ {print $3}' "$inventory_file"
}

audit_names() {
  sed -nE 's/^#print axioms ([A-Za-z0-9_]+)$/\1/p' "$audit_file"
}

source_count=$(source_names | wc -l | tr -d ' ')
inventory_count=$(inventory_names | wc -l | tr -d ' ')
audit_count=$(audit_names | wc -l | tr -d ' ')

test "$source_count" -eq "$expected_count"
test "$inventory_count" -eq "$expected_count"
test "$audit_count" -eq "$expected_count"

awk -F '\t' '
  !/^#/ && $1 ~ /^[0-9]+$/ {
    expected += 1
    if ($1 != expected) exit 1
  }
  END { if (expected != 9) exit 1 }
' "$inventory_file"

test -z "$(source_names | sort | uniq -d)"
test -z "$(inventory_names | sort | uniq -d)"
test -z "$(audit_names | sort | uniq -d)"

diff -u <(source_names) <(inventory_names)
diff -u <(inventory_names) <(audit_names)

test "$(grep -c '^import ' "$source_file")" -eq 1
grep -Fxq \
  'import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder' \
  "$source_file"
grep -Fxq \
  'import CollatzClassical.KL2003.F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity' \
  "$audit_file"
grep -Fq 'env.constants.toList.map Prod.fst |>.filter namespacePrefix.isPrefixOf' \
  "$audit_file"

test "$(grep -Fc '    coreEdges = List.ofFn corePositionRealize := by' "$source_file")" -eq 1
awk '
  $0 == "    coreEdges = List.ofFn corePositionRealize := by" {
    if ((getline nextLine) <= 0 || nextLine != "  rfl") exit 1
    found += 1
  }
  END { if (found != 1) exit 1 }
' "$source_file"

for theorem_name in "${terminal_theorems[@]}"; do
  grep -Fxq "#print axioms $theorem_name" "$audit_file"
done

if grep -Eq \
  '^private\b|\b(native_decide|Lean\.ofReduceBool|sorry|admit|find\?|HashMap|Array|CSV|fin_cases|core_edge_count|core_edges_have_valid_channels|frozen_weight_count)\b|^[[:space:]]*axiom\b' \
  "$source_file"; then
  exit 1
fi

printf '%s\n' \
  'FULL_CORE_IDENTITY_SOURCE_DECLARATIONS=9' \
  'FULL_CORE_IDENTITY_INVENTORY_DECLARATIONS=9' \
  'FULL_CORE_IDENTITY_AUDIT_COMMANDS=9' \
  'FULL_CORE_IDENTITY_SOURCE_INVENTORY_DIFF=EMPTY' \
  'FULL_CORE_IDENTITY_INVENTORY_AUDIT_DIFF=EMPTY' \
  'FULL_CORE_IDENTITY_DUPLICATES=NONE' \
  'FULL_CORE_IDENTITY_TERMINAL_THEOREMS=7_OF_7' \
  'FULL_CORE_IDENTITY_LITERAL_NORMALIZATION=UNIQUE_AND_EXACT' \
  'FULL_CORE_IDENTITY_FORBIDDEN_SOURCE_SYNTAX=ABSENT' \
  'FULL_CORE_IDENTITY_STATIC_INVENTORY_CHECK=PASS'

if [[ -n "$audit_log_path" ]]; then
  source_hash=$(shasum -a 256 "$source_file" | awk '{print $1}')
  audit_hash=$(shasum -a 256 "$audit_file" | awk '{print $1}')
  identity_olean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean"
  identity_ilean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.ilean"
  audit_olean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.olean"
  audit_ilean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentityAxiomAudit.ilean"
  exact_olean="$overlay_package/F3ReturnExcursionExactCoreMatrix.olean"
  repair_olean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean"
  decoder_olean="$overlay_package/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean"

  test "$(unique_value FULL_CORE_IDENTITY_C0 "$c0_log_path")" = 'PASS'
  test "$(unique_value FULL_CORE_IDENTITY_C0_LEAN_EXIT_STATUS "$c0_log_path")" = '0'
  test "$(unique_value FULL_CORE_IDENTITY_C0_WRAPPER_EXIT_STATUS "$c0_log_path")" = '0'
  test "$(unique_value FULL_CORE_IDENTITY_C0_SOURCE_SHA256 "$c0_log_path")" = "$source_hash"
  test "$(unique_value FULL_CORE_IDENTITY_A1 "$audit_log_path")" = 'PASS'
  test "$(unique_value FULL_CORE_IDENTITY_A1_LEAN_EXIT_STATUS "$audit_log_path")" = '0'
  test "$(unique_value FULL_CORE_IDENTITY_A1_WRAPPER_EXIT_STATUS "$audit_log_path")" = '0'
  test "$(unique_value FULL_CORE_IDENTITY_A1_SOURCE_SHA256 "$audit_log_path")" = "$source_hash"
  test "$(unique_value FULL_CORE_IDENTITY_A1_AUDIT_SOURCE_SHA256 "$audit_log_path")" = "$audit_hash"

  c0_identity_olean_hash=$(unique_value FULL_CORE_IDENTITY_OLEAN_SHA256 "$c0_log_path")
  c0_identity_ilean_hash=$(unique_value FULL_CORE_IDENTITY_ILEAN_SHA256 "$c0_log_path")
  test "$(shasum -a 256 "$exact_olean" | awk '{print $1}')" = \
    "$(unique_value FULL_CORE_IDENTITY_C0_EXACT_CORE_SHA256 "$c0_log_path")"
  test "$(shasum -a 256 "$repair_olean" | awk '{print $1}')" = \
    "$(unique_value FULL_CORE_IDENTITY_C0_REPAIR_SHA256 "$c0_log_path")"
  test "$(shasum -a 256 "$decoder_olean" | awk '{print $1}')" = \
    "$(unique_value FULL_CORE_IDENTITY_C0_DECODER_SHA256 "$c0_log_path")"
  test "$(unique_value FULL_CORE_IDENTITY_INPUT_OLEAN_SHA256 "$audit_log_path")" = "$c0_identity_olean_hash"
  test "$(unique_value FULL_CORE_IDENTITY_INPUT_ILEAN_SHA256 "$audit_log_path")" = "$c0_identity_ilean_hash"
  test "$(shasum -a 256 "$identity_olean" | awk '{print $1}')" = "$c0_identity_olean_hash"
  test "$(shasum -a 256 "$identity_ilean" | awk '{print $1}')" = "$c0_identity_ilean_hash"
  test "$(shasum -a 256 "$audit_olean" | awk '{print $1}')" = \
    "$(unique_value FULL_CORE_IDENTITY_AUDIT_OLEAN_SHA256 "$audit_log_path")"
  test "$(shasum -a 256 "$audit_ilean" | awk '{print $1}')" = \
    "$(unique_value FULL_CORE_IDENTITY_AUDIT_ILEAN_SHA256 "$audit_log_path")"
  test "$(find "$repo_root/.lake/f3-full-core-identity-overlay/lib/lean" -type f | wc -l | tr -d ' ')" = '7'
  test "$(find "$repo_root/.lake/f3-full-core-identity-overlay/lib/lean" -type l | wc -l | tr -d ' ')" = '0'

  bash "$guard" --audit-log "$audit_log_path"

  namespace='CollatzClassical.KL2003.F3CoreArithmeticCodecFullCoreIdentity'
  for theorem_name in "${terminal_theorems[@]}"; do
    profile_prefix="'${namespace}.${theorem_name}'"
    test "$(grep -Fc "$profile_prefix" "$audit_log_path")" -eq 1
    profile_header=$(grep -F "$profile_prefix" "$audit_log_path")
    case "$profile_header" in
      *' does not depend on any axioms')
        axioms=''
        ;;
      *' depends on axioms:'*)
        profile=$(
          awk -v start="${profile_prefix} depends on axioms:" '
            index($0, start) == 1 { capture = 1 }
            capture { print }
            capture && /]$/ { exit }
          ' "$audit_log_path"
        )
        test -n "$profile"
        axioms=$(
          printf '%s\n' "$profile" |
            tr -d '[:space:]' |
            sed -E 's/^.*dependsonaxioms:\[//; s/\]$//'
        )
        ;;
      *)
        printf 'TERMINAL_PROFILE_UNRECOGNIZED\t%s\n' "$theorem_name" >&2
        exit 1
        ;;
    esac
    IFS=',' read -r -a axiom_array <<< "$axioms"
    for axiom_name in "${axiom_array[@]}"; do
      case "$axiom_name" in
        ''|propext|Classical.choice|Quot.sound) ;;
        *)
          printf 'TERMINAL_PROFILE_FORBIDDEN\t%s\t%s\n' \
            "$theorem_name" "$axiom_name" >&2
          exit 1
          ;;
      esac
    done
    printf 'TERMINAL_PROFILE_ALLOWED\t%s\t[%s]\n' \
      "$theorem_name" "$axioms"
  done

  test "$(shasum -a 256 "$source_file" | awk '{print $1}')" = "$source_hash"
  test "$(shasum -a 256 "$audit_file" | awk '{print $1}')" = "$audit_hash"

  printf '%s\n' \
    'FULL_CORE_IDENTITY_TERMINAL_PROFILES=7_OF_7_ALLOWED' \
    'FULL_CORE_IDENTITY_CONDITIONAL_AUDIT_LOG_CHECK=PASS'
fi
