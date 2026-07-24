#!/usr/bin/env bash
set -euo pipefail

repo_root='/Users/MoiTam/Documents/New project/coordinated/hilo2-f3'
prior_overlay="$repo_root/.lake/f3-full-block-decoder-overlay/lib/lean/CollatzClassical/KL2003"
overlay_base="$repo_root/.lake/f3-full-core-identity-overlay"
overlay_root="$overlay_base/lib/lean"
overlay_package="$overlay_root/CollatzClassical/KL2003"

exact_name='F3ReturnExcursionExactCoreMatrix.olean'
repair_name='F3ReturnExcursionCoreArithmeticCodecPilotRepair.olean'
decoder_name='F3ReturnExcursionCoreArithmeticCodecFullBlockDecoder.olean'

exact_hash='34a6f1745a11dcfaaaf0bc72516c7f485711773531023979e237a4d3dfd46798'
repair_hash='480e605a5e3db74a1edf9ecce7f535b8f8c057965498ac5f73e787322c144372'
decoder_hash='225e7cbca64ec5d9ad7e609fdc08bcf60401cbd356f2d4bd20d74b51662bc8ec'

test ! -e "$overlay_base"
test -f "$prior_overlay/$exact_name"
test ! -L "$prior_overlay/$exact_name"
test -f "$prior_overlay/$repair_name"
test ! -L "$prior_overlay/$repair_name"
test -f "$prior_overlay/$decoder_name"
test ! -L "$prior_overlay/$decoder_name"
test "$(shasum -a 256 "$prior_overlay/$exact_name" | awk '{print $1}')" = "$exact_hash"
test "$(shasum -a 256 "$prior_overlay/$repair_name" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$prior_overlay/$decoder_name" | awk '{print $1}')" = "$decoder_hash"

mkdir -p "$overlay_package"
/bin/cp -p "$prior_overlay/$exact_name" "$overlay_package/$exact_name"
/bin/cp -p "$prior_overlay/$repair_name" "$overlay_package/$repair_name"
/bin/cp -p "$prior_overlay/$decoder_name" "$overlay_package/$decoder_name"

test -f "$overlay_package/$exact_name"
test ! -L "$overlay_package/$exact_name"
test -f "$overlay_package/$repair_name"
test ! -L "$overlay_package/$repair_name"
test -f "$overlay_package/$decoder_name"
test ! -L "$overlay_package/$decoder_name"
test "$(shasum -a 256 "$overlay_package/$exact_name" | awk '{print $1}')" = "$exact_hash"
test "$(shasum -a 256 "$overlay_package/$repair_name" | awk '{print $1}')" = "$repair_hash"
test "$(shasum -a 256 "$overlay_package/$decoder_name" | awk '{print $1}')" = "$decoder_hash"
test "$(find "$overlay_root" -type f | wc -l | tr -d ' ')" = '3'
test "$(find "$overlay_root" -type l | wc -l | tr -d ' ')" = '0'

printf '%s\n' \
  'FULL_CORE_IDENTITY_OVERLAY_STAGE=PASS' \
  "FULL_CORE_IDENTITY_OVERLAY_ROOT=$overlay_root" \
  "FULL_CORE_IDENTITY_EXACT_CORE_SHA256=$exact_hash" \
  "FULL_CORE_IDENTITY_REPAIR_SHA256=$repair_hash" \
  "FULL_CORE_IDENTITY_DECODER_SHA256=$decoder_hash" \
  'FULL_CORE_IDENTITY_OVERLAY_FILE_COUNT=3' \
  'FULL_CORE_IDENTITY_OVERLAY_SYMLINK_COUNT=0'
