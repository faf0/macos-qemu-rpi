#!/usr/bin/env bash

set -euxo pipefail

readonly IMAGE_FOLDER='raspios_lite_armhf-2021-11-08'
readonly IMAGE='2021-10-30-raspios-bullseye-armhf-lite'
readonly KERNEL='kernel8.img'
readonly PTB='bcm2710-rpi-3-b-plus.dtb'

readonly TMP_DIR="${HOME}/qemu_vms_native"
readonly KERNEL_FILE="${TMP_DIR}/${KERNEL}"
readonly PTB_FILE="${TMP_DIR}/${PTB}"

# commit hash to use for the https://github.com/dhruvvyas90/qemu-rpi-kernel/ repo:
readonly COMMIT_HASH='c522bff346bb7401ad0b979778c23be52089618f'

readonly IMAGE_URL="https://downloads.raspberrypi.org/raspios_lite_armhf/images/${IMAGE_FOLDER}/${IMAGE}.zip"
readonly KERNEL_URL="https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/${COMMIT_HASH}/native-emulation/5.4.51%20kernels/${KERNEL}?raw=true"
readonly PTB_URL="https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/${COMMIT_HASH}/native-emulation/dtbs/${PTB}?raw=true"

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

extract_images () {
  [ -f "$KERNEL_FILE" ] || \
    curl -sSL "$KERNEL_URL" -o "$KERNEL_FILE"
  [ -f "$PTB_FILE" ] || \
    curl -sSL "$PTB_URL" -o "$PTB_FILE"
  [ -f "${IMAGE}.zip" ] || \
    curl -sSL "$IMAGE_URL" -o "${IMAGE}.zip"
  [ -f "${IMAGE}.img" ] || \
    unzip "${IMAGE}.zip"
  [ -f "${IMAGE}.img" ] && \
    qemu-img resize -f raw "${IMAGE}.img" 2G
}

main () {
  check_commands
  install_qemu
  change_dir
  extract_images
}

main

