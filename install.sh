#!/usr/bin/env bash

# Source:
# https://gist.github.com/hfreire/5846b7aa4ac9209699ba#gistcomment-3075728

set -euxo pipefail

readonly IMAGE_FILE='2019-09-26-raspbian-buster-lite.zip'
readonly IMAGE="https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/${IMAGE_FILE}"

readonly TMP_DIR="${HOME}/qemu_vms"
readonly RPI_KERNEL="${TMP_DIR}/kernel-qemu-4.14.79-stretch"
readonly PTB_FILE="${TMP_DIR}/versatile-pb.dtb"

( mkdir -p "$TMP_DIR" && \
  cd "$TMP_DIR" ) || \
  exit 1

[[ -f "$RPI_KERNEL" ]] || curl -sSL 'https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/master/kernel-qemu-4.14.79-stretch?raw=true' -o "$RPI_KERNEL"
[[ -f "$PTB_FILE" ]] || curl -sSL 'https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/versatile-pb.dtb' -o "$PTB_FILE"
[[ -f "$IMAGE_FILE" ]] || curl -sSL "$IMAGE" -o "$IMAGE_FILE"
[[ -f "${IMAGE_FILE%.*}.img" ]] || unzip "$IMAGE_FILE"

command -v qemu-system-arm &> /dev/null || brew install qemu
