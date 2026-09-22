#!/usr/bin/env bash
set -euo pipefail

mkdir -p objdir-clone

python3 .github/boringcache-time.py unified \
  ./scripts/run_in_build_env.sh \
  "./scripts/build/build_examples.py \
    --target linux-x64-bridge-${BUILD_VARIANT}-unified \
    --target linux-x64-lock-${BUILD_VARIANT}-unified \
    --target linux-x64-microwave-oven-${BUILD_VARIANT}-unified \
    --target linux-x64-rvc-${BUILD_VARIANT}-unified \
    --target linux-x64-ota-provider-${BUILD_VARIANT}-unified \
    --pw-command-launcher=ccache \
    build \
    --copy-artifacts-to objdir-clone"

rm -rf out/

python3 .github/boringcache-time.py remaining-part-1 \
  ./scripts/run_in_build_env.sh \
  "./scripts/build/build_examples.py \
    --target linux-x64-chip-tool${CHIP_TOOL_VARIANT}-${BUILD_VARIANT} \
    --target linux-x64-all-clusters-${BUILD_VARIANT} \
    --target linux-x64-all-clusters-no-wifi-openthread-endpoint-${BUILD_VARIANT} \
    --target linux-x64-all-clusters-no-wifi-no-ble-openthread-endpoint-${BUILD_VARIANT} \
    --target linux-x64-ota-requestor-${BUILD_VARIANT} \
    --target linux-x64-tv-app-${BUILD_VARIANT} \
    --pw-command-launcher=ccache \
    build \
    --copy-artifacts-to objdir-clone"

rm -rf out/

python3 .github/boringcache-time.py remaining-part-2 \
  ./scripts/run_in_build_env.sh \
  "./scripts/build/build_examples.py \
    --target linux-x64-lit-icd-${BUILD_VARIANT} \
    --target linux-x64-network-manager-${BUILD_VARIANT} \
    --target linux-x64-energy-gateway-${BUILD_VARIANT} \
    --target linux-x64-all-devices-${BUILD_VARIANT} \
    --target linux-x64-evse-${BUILD_VARIANT} \
    --target linux-x64-water-heater-${BUILD_VARIANT} \
    --pw-command-launcher=ccache \
    build \
    --copy-artifacts-to objdir-clone"

find objdir-clone -type f -print0 \
  | sort -z \
  | xargs -0 sha256sum \
  > "$RUNNER_TEMP/validation/outputs.sha256"
