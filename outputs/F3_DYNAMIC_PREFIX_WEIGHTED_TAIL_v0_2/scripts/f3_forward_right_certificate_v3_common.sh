#!/usr/bin/env bash

export LC_ALL=C
export LANG=C

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
donor='/Users/MoiTam/Documents/Codex/collatz-classical'
overlay="$repo/.lake/f3-forward-right-certificate-v3-overlay/lib/lean"
collatz="$overlay/CollatzClassical"
package="$collatz/KL2003"
lean_bin='/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/bin/lean'
cli_root="$donor/.lake/packages/Cli/.lake/build/lib/lean"
batteries_root="$donor/.lake/packages/batteries/.lake/build/lib/lean"
qq_root="$donor/.lake/packages/Qq/.lake/build/lib/lean"
aesop_root="$donor/.lake/packages/aesop/.lake/build/lib/lean"
proofwidgets_root="$donor/.lake/packages/proofwidgets/.lake/build/lib/lean"
import_graph_root="$donor/.lake/packages/importGraph/.lake/build/lib/lean"
search_root="$donor/.lake/packages/LeanSearchClient/.lake/build/lib/lean"
plausible_root="$donor/.lake/packages/plausible/.lake/build/lib/lean"
mathlib_root="$donor/.lake/packages/mathlib/.lake/build/lib/lean"
toolchain_root='/Users/MoiTam/.elan/toolchains/leanprover--lean4---v4.21.0/lib/lean'
lean_path="$overlay:$cli_root:$batteries_root:$qq_root:$aesop_root:$proofwidgets_root:$import_graph_root:$search_root:$plausible_root:$mathlib_root:$toolchain_root"
expected_manifest="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_FORWARD_RIGHT_CERTIFICATE_V3/F3_FORWARD_RIGHT_CERTIFICATE_V3_EXPECTED_STAGE_MANIFEST.sha256"
source_file="$repo/CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.lean"
audit_file="$repo/CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.lean"
target_olean="$package/F3ReturnExcursionForwardFormulaRightCertificate.olean"
target_ilean="$package/F3ReturnExcursionForwardFormulaRightCertificate.ilean"
audit_olean="$package/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.olean"
audit_ilean="$package/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.ilean"

file_hash() {
  shasum -a 256 "$1" | awk '{print $1}'
}

check_hash() {
  test "$(file_hash "$1")" = "$2"
}

check_package() {
  local name=$1
  local revision=$2
  local package_dir="$donor/.lake/packages/$name"
  test -d "$package_dir/.git"
  test "$(git -C "$package_dir" rev-parse HEAD)" = "$revision"
  test -z "$(git -C "$package_dir" status --porcelain)"
}

verify_packages() {
  test "$(git -C "$donor" rev-parse HEAD)" = \
    7b7a80efa6ceea6c977821e55bcc832d654551dc
  git -C "$donor" diff --quiet
  git -C "$donor" diff --cached --quiet
  check_package mathlib 308445d7985027f538e281e18df29ca16ede2ba3
  check_package plausible c4aa78186d388e50a436e8362b947bae125a2933
  check_package proofwidgets 6980f6ca164de593cb77cd03d8eac549cc444156
  check_package batteries 8d2067bf518731a70a255d4a61b5c103922c772e
  check_package Cli 7c6aef5f75a43ebbba763b44d535175a1b04c9e0
  check_package aesop 8ff27701d003456fd59f13a9212431239d902aef
  check_package importGraph d07bd64f1910f1cc5e4cc87b6b9c590080e7a457
  check_package LeanSearchClient 6c62474116f525d2814f0157bb468bf3a4f9f120
  check_package Qq e9c65db4823976353cd0bb03199a172719efbeb7
}

verify_olean_root() {
  local root=$1
  local expected_count=$2
  local expected_digest=$3
  local actual_count
  local actual_digest
  actual_count=$(find "$root" -type f -name '*.olean' | wc -l | tr -d ' ')
  actual_digest=$(
    cd "$root"
    find . -type f -name '*.olean' -print0 |
      /opt/homebrew/bin/gsort -z |
      xargs -0 shasum -a 256 |
      shasum -a 256 |
      awk '{print $1}'
  )
  test "$actual_count" = "$expected_count"
  test "$actual_digest" = "$expected_digest"
}

verify_external_olean_roots() {
  verify_olean_root "$batteries_root" 166 \
    a42cce539747cd563e1508d92f0034326f6ebe2166c274711988563edc208b71
  verify_olean_root "$qq_root" 13 \
    a95375382efac5c6b9f12e0f2e9fb473e5544fa087f8a4e25afb0594837015cc
  verify_olean_root "$aesop_root" 130 \
    7232c728ec3a22797745f7b3e7cecacd5c9cd1edcd1a77e2c426527d29852c5d
  verify_olean_root "$proofwidgets_root" 12 \
    3407ea51e182c0b9aa85c4be6ff78eb5358cb73621a62721030e39772df1d981
  verify_olean_root "$import_graph_root" 2 \
    10261c7dac2b52e338bf5469824dfc1194da14479516c324356ecbe2ee348f7c
  verify_olean_root "$search_root" 4 \
    fabc5729cbc4890522c7ce1de09180b04d79a97d554ceac5855e54f433215b7c
  verify_olean_root "$plausible_root" 8 \
    c664c6075910c564885089d3aefafb2e7605c02de4a3763697f7d6db08f5cdfe
  verify_olean_root "$mathlib_root" 6560 \
    a058894144c9d8cb7a69ae1ac74538f3e5acb8b0bf6e2d20a4e9396797dee2cf
  verify_olean_root "$toolchain_root" 1613 \
    f0c8b62e3f1a404c0a818635f8c64c010cdc64c7c5747f56547494b3447a0495
}

verify_roots() {
  test -d "$overlay"
  test ! -e "$cli_root"
  local roots=(
    "$overlay"
    "$batteries_root"
    "$qq_root"
    "$aesop_root"
    "$proofwidgets_root"
    "$import_graph_root"
    "$search_root"
    "$plausible_root"
    "$mathlib_root"
    "$toolchain_root"
  )
  local canonical=''
  local root
  for root in "${roots[@]}"; do
    test -d "$root"
    canonical+="$(/bin/realpath "$root")"$'\n'
  done
  test "$(printf '%s' "$canonical" | wc -l | tr -d ' ')" = '10'
  test "$(printf '%s' "$canonical" | LC_ALL=C sort -u | wc -l | tr -d ' ')" = '10'
  for root in "${roots[@]:1}"; do
    test ! -e "$root/CollatzClassical"
  done
  case "$lean_path" in
    *"$repo/.lake/packages"*) return 1 ;;
  esac
  case "$lean_path" in
    *"$donor/.lake/build/lib/lean"*) return 1 ;;
  esac
}

verify_base_environment() {
  local expected_olean_count=$1
  local expected_ilean_count=$2
  local expected_total_count=$3

  check_hash "$lean_bin" c89073b8a577a5914ead7b740d2ad996af1ad5ad5b4bfc2825e0bce2f01b6aa4
  check_hash /opt/homebrew/bin/gsort 3e2705341516948679e48b245297318a2e79086639d02f8878404e3a9cb30b97
  check_hash "$source_file" 37932fd8198e045c436c479455a362afb9b2ef720b2138c1f3308f552e16a4ab
  check_hash "$audit_file" fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2
  check_hash "$expected_manifest" 38b665480af7b7596b53fedc1621343f30913b6f636e8ae6daf17654e094c5bf
  check_hash "$repo/lake-manifest.json" 230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
  check_hash "$repo/lakefile.lean" e31ac41ac108fbd7e30db1bc982a065949d359146e110ee04212378645e54fca
  check_hash "$repo/lean-toolchain" d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
  check_hash "$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_v1/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_RUN_REPORT_v1.md" \
    24998975be4123b07e8fa7c4100c057a6e9d15da20d6208dda6de6c50773aad3
  verify_packages
  verify_roots
  verify_external_olean_roots
  test "$(find "$collatz" -type f -name '*.olean' | wc -l | tr -d ' ')" = \
    "$expected_olean_count"
  test "$(find "$collatz" -type f -name '*.ilean' | wc -l | tr -d ' ')" = \
    "$expected_ilean_count"
  test "$(find "$collatz" -type f | wc -l | tr -d ' ')" = "$expected_total_count"
  test "$(find "$collatz" -type l | wc -l | tr -d ' ')" = '0'
  (cd "$collatz" && shasum -a 256 -c "$expected_manifest" >/dev/null)
  git -C "$repo" diff --quiet
  git -C "$repo" diff --cached --quiet
}

global_new_objects() {
  find \
    "$repo/CollatzClassical" \
    "$repo/.lake" \
    "$donor/.lake/build/lib/lean" \
    "$donor/.lake/packages" \
    -type f \( \
      -name 'F3ReturnExcursionForwardFormulaRightCertificate.olean' -o \
      -name 'F3ReturnExcursionForwardFormulaRightCertificate.ilean' -o \
      -name 'F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.olean' -o \
      -name 'F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.ilean' \
    \) -print | LC_ALL=C sort
}

unique_value() {
  local key=$1
  local file=$2
  awk -F '=' -v key="$key" '
    $1 == key { count += 1; value = substr($0, index($0, "=") + 1) }
    END { if (count != 1) exit 1; print value }
  ' "$file"
}
