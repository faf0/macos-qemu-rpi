#!/usr/bin/env bash

set -euxo pipefail

readonly IMAGE_FILE='2019-09-26-raspbian-buster-lite.zip'
readonly IMAGE_URL="https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/${IMAGE_FILE}"
readonly KERNEL_URL='https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/c5a491c093604a71db2f01b8fab72bad0e96e2b5/kernel-qemu-4.19.50-buster?raw=true'
readonly PTB_URL='https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/ea19dc94bc7420675b505c81d2c262ee0eacbb0e/versatile-pb.dtb?raw=true'

readonly TMP_DIR="${HOME}/qemu_vms"
readonly RPI_KERNEL="${TMP_DIR}/kernel-qemu-4.19.50-buster"
readonly PTB_FILE="${TMP_DIR}/versatile-pb.dtb"

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
  command -v qemu-system-arm &> /dev/null || \
    brew install qemu
}

change_dir () {
  { mkdir -p "$TMP_DIR" && \
    cd "$TMP_DIR"; } || \
    exit 1
}

exctract_images () {
  [ -f "$RPI_KERNEL" ] || \
    curl -sSL "$KERNEL_URL" -o "$RPI_KERNEL"
  [ -f "$PTB_FILE" ] || \
    curl -sSL "$PTB_URL" -o "$PTB_FILE"
  [ -f "$IMAGE_FILE" ] || \
    curl -sSL "$IMAGE_URL" -o "$IMAGE_FILE"
  [ -f "${IMAGE_FILE%.*}.img" ] || \
    unzip "$IMAGE_FILE"
}

main () {
  check_commands
  install_qemu
  change_dir
  exctract_images
}

main

