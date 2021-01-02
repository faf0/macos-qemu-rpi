#!/usr/bin/env bash

set -euxo pipefail

readonly IMAGE='2020-02-13-raspbian-buster-lite'
readonly KERNEL='kernel8.img'
readonly PTB='bcm2710-rpi-3-b-plus.dtb'

readonly TMP_DIR="${HOME}/qemu_vms_native"
readonly KERNEL_FILE="${TMP_DIR}/${KERNEL}"
readonly PTB_FILE="${TMP_DIR}/${PTB}"

# commit hash to use for the https://github.com/dhruvvyas90/qemu-rpi-kernel/ repo:
readonly COMMIT_HASH='061a3853cf2e2390046d163d90181bde1c4cd78f'

readonly IMAGE_URL="https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/${IMAGE}.zip"
readonly KERNEL_URL="https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/${COMMIT_HASH}/native-emuation/5.4.51%20kernels/${KERNEL}?raw=true"
readonly PTB_URL="https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/${COMMIT_HASH}/native-emuation/dtbs/${PTB}?raw=true"

check_commands () {
  [ "$(uname)" = 'Darwin' ] || \
    { echo 'Must be run on macOS'; exit 1; }
  
  command -v brew &> /dev/null || \
    { echo 'Install homebrew'; exit 1; }
  
  command -v curl &> /dev/null || \
    { echo 'Install curl'; exit 1; }
  
  command -v unzip &> /dev/null || \
    { echo 'Install unzip'; exit 1; }
}

install_qemu () {
  command -v qemu-system-aarch64 &> /dev/null || \
    brew install qemu
}

change_dir () {
  { mkdir -p "$TMP_DIR" && \
    cd "$TMP_DIR"; } || \
    exit 1
}

exctract_images () {
  [ -f "$KERNEL_FILE" ] || \
    curl -sSL "$KERNEL_URL" -o "$KERNEL_FILE"
  [ -f "$PTB_FILE" ] || \
    curl -sSL "$PTB_URL" -o "$PTB_FILE"
  [ -f "${IMAGE}.zip" ] || \
    curl -sSL "$IMAGE_URL" -o "${IMAGE}.zip"
  [ -f "${IMAGE}.img" ] || \
    unzip "${IMAGE}.zip"
  [ -f "${IMAGE}.img" ] || \
    qemu-img resize -f raw "${IMAGE}.img" 2G
}

main () {
  check_commands
  install_qemu
  change_dir
  exctract_images
}

main

