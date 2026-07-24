#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C
export LANG=C

repo='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
donor='/Users/MoiTam/Documents/Codex/collatz-classical'
donor_collatz="$donor/.lake/build/lib/lean/CollatzClassical"
identity_collatz="$repo/.lake/f3-full-core-identity-v2-overlay/lib/lean/CollatzClassical"
stage_parent="$repo/.lake/f3-forward-right-certificate-v3-overlay/lib/lean"
stage_collatz="$stage_parent/CollatzClassical"
expected_manifest="$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_FORWARD_RIGHT_CERTIFICATE_V3/F3_FORWARD_RIGHT_CERTIFICATE_V3_EXPECTED_STAGE_MANIFEST.sha256"

tree_hash() {
  (
    cd "$1"
    find . -type f -print0 |
      /opt/homebrew/bin/gsort -z |
      xargs -0 shasum -a 256 |
      shasum -a 256 |
      awk '{print $1}'
  )
}

file_hash() {
  shasum -a 256 "$1" | awk '{print $1}'
}

check_hash() {
  test "$(file_hash "$1")" = "$2"
}

check_package() {
  local name=$1
  local revision=$2
  local package="$donor/.lake/packages/$name"
  test -d "$package/.git"
  test "$(git -C "$package" rev-parse HEAD)" = "$revision"
  test -z "$(git -C "$package" status --porcelain)"
}

test ! -e "$repo/.lake/f3-forward-right-certificate-v3-overlay"
test -d "$donor_collatz"
test -d "$identity_collatz/KL2003"
test "$(git -C "$donor" rev-parse HEAD)" = \
  7b7a80efa6ceea6c977821e55bcc832d654551dc
git -C "$donor" diff --quiet
git -C "$donor" diff --cached --quiet
check_hash "$repo/CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.lean" \
  37932fd8198e045c436c479455a362afb9b2ef720b2138c1f3308f552e16a4ab
check_hash "$repo/CollatzClassical/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.lean" \
  fd9d431d4ce5657204e1b9fa98b8cfd2e8214454fee96bf4b042e0a8629432f2
check_hash "$repo/lake-manifest.json" \
  230bd08edad607d89724784995cfb8750cebce677ea4563098991e6a1504849b
check_hash "$repo/lean-toolchain" \
  d24fed434d3b13adfaab57724a0a7f270ea8bf1c818b5ae5cf25cbce24dd685c
check_hash "$repo/outputs/F3_DYNAMIC_PREFIX_WEIGHTED_TAIL_v0_2/results/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_v1/F3_CORE_ARITHMETIC_CODEC_FULL_CORE_IDENTITY_V2_RUN_REPORT_v1.md" \
  24998975be4123b07e8fa7c4100c057a6e9d15da20d6208dda6de6c50773aad3

test "$(find "$donor_collatz" -type f -name '*.olean' | wc -l | tr -d ' ')" = '206'
test "$(find "$donor_collatz" -type l | wc -l | tr -d ' ')" = '0'
donor_olean_hash=$(
  cd "$donor_collatz"
  find . -type f -name '*.olean' -print0 |
    /opt/homebrew/bin/gsort -z |
    xargs -0 shasum -a 256 |
    shasum -a 256 |
    awk '{print $1}'
)
test "$donor_olean_hash" = \
  '854f95f26e69ed5fa6aace21e165ef6f49d58798fe966969d449436a43f33e48'
check_hash "$expected_manifest" \
  38b665480af7b7596b53fedc1621343f30913b6f636e8ae6daf17654e094c5bf

check_package mathlib 308445d7985027f538e281e18df29ca16ede2ba3
check_package plausible c4aa78186d388e50a436e8362b947bae125a2933
check_package proofwidgets 6980f6ca164de593cb77cd03d8eac549cc444156
check_package batteries 8d2067bf518731a70a255d4a61b5c103922c772e
check_package Cli 7c6aef5f75a43ebbba763b44d535175a1b04c9e0
check_package aesop 8ff27701d003456fd59f13a9212431239d902aef
check_package importGraph d07bd64f1910f1cc5e4cc87b6b9c590080e7a457
check_package LeanSearchClient 6c62474116f525d2814f0157bb468bf3a4f9f120
check_package Qq e9c65db4823976353cd0bb03199a172719efbeb7

check_hash "$identity_collatz/KL2003/F3ReturnExcursionExactCoreMatrix.olean" \
  34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
check_hash "$identity_collatz/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean" \
  480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
check_hash "$identity_collatz/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean" \
  225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
check_hash "$identity_collatz/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean" \
  b97217ba7cd34ce4d1d5b2c4dc76a31537d6be1693eb51eda523256df6597a18
check_hash "$donor_collatz/KL2003/F3ReturnExcursionExactCoreMatrixChannelBounds.olean" \
  2dc4e0ec3fc81d8856e0f44c12ee6d0fd2aaeb68d6f43e7d6ec94c3233730390
check_hash "$donor_collatz/KL2003/F3ReturnExcursionRealOperatorBridge.olean" \
  7242f1181bfbf577cbe318c4cd86d7c2c429b684c432c5ea0420cc332774e3ae

for suffix in olean ilean; do
  test ! -e "$donor_collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.$suffix"
  test ! -e "$donor_collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.$suffix"
  test ! -e "$identity_collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.$suffix"
  test ! -e "$identity_collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.$suffix"
done
test -z "$(find "$repo/CollatzClassical" "$repo/.lake" \
  "$donor/.lake/build/lib/lean" "$donor/.lake/packages" \
  -type f \( \
    -name 'F3ReturnExcursionForwardFormulaRightCertificate.olean' -o \
    -name 'F3ReturnExcursionForwardFormulaRightCertificate.ilean' -o \
    -name 'F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.olean' -o \
    -name 'F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.ilean' \
  \) -print)"

/bin/mkdir -p "$stage_parent"
while IFS= read -r -d '' source_object; do
  relative_object=${source_object#"$donor_collatz/"}
  destination_object="$stage_collatz/$relative_object"
  /bin/mkdir -p "$(dirname "$destination_object")"
  /bin/cp -c "$source_object" "$destination_object"
done < <(find "$donor_collatz" -type f -name '*.olean' -print0)

for file in \
  F3ReturnExcursionExactCoreMatrix.olean \
  F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean \
  F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean \
  F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean
do
  /bin/cp -c "$identity_collatz/KL2003/$file" "$stage_collatz/KL2003/$file"
done

test "$(find "$stage_collatz" -type f | wc -l | tr -d ' ')" = '209'
test "$(find "$stage_collatz" -type f -name '*.olean' | wc -l | tr -d ' ')" = '209'
test "$(find "$stage_collatz" -type f -name '*.ilean' | wc -l | tr -d ' ')" = '0'
test "$(find "$stage_collatz" -type l | wc -l | tr -d ' ')" = '0'

for suffix in olean ilean; do
  test ! -e "$stage_collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificate.$suffix"
  test ! -e "$stage_collatz/KL2003/F3ReturnExcursionForwardFormulaRightCertificateAxiomAudit.$suffix"
done

check_hash "$stage_collatz/KL2003/F3ReturnExcursionExactCoreMatrixChannelBounds.olean" \
  2dc4e0ec3fc81d8856e0f44c12ee6d0fd2aaeb68d6f43e7d6ec94c3233730390
check_hash "$stage_collatz/KL2003/F3ReturnExcursionRealOperatorBridge.olean" \
  7242f1181bfbf577cbe318c4cd86d7c2c429b684c432c5ea0420cc332774e3ae
check_hash "$stage_collatz/KL2003/F3ReturnExcursionCoreArithmeticCodecFullCoreIdentity.olean" \
  b97217ba7cd34ce4d1d5b2c4dc76a31537d6be1693eb51eda523256df6597a18
check_hash "$stage_collatz/KL2003/F3ReturnExcursionExactCoreMatrix.olean" \
  34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798
check_hash "$stage_collatz/KL2003/F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean" \
  480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372
check_hash "$stage_collatz/KL2003/F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean" \
  225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec
(cd "$stage_collatz" && shasum -a 256 -c "$expected_manifest" >/dev/null)

printf '%s\n' \
  'F3_FORWARD_V3_STAGE=PASS' \
  'F3_FORWARD_V3_STAGE_FILE_COUNT=209' \
  'F3_FORWARD_V3_STAGE_OLEAN_COUNT=209' \
  'F3_FORWARD_V3_STAGE_ILEAN_COUNT=0' \
  'F3_FORWARD_V3_STAGE_SYMLINK_COUNT=0'
printf 'F3_FORWARD_V3_STAGE_TREE_SHA256=%s\n' "$(tree_hash "$stage_collatz")"
