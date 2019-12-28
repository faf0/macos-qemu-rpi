#!/usr/bin/env bash

# Source:
# https://gist.github.com/hfreire/5846b7aa4ac9209699ba#gistcomment-3075728

set -euxo pipefail

readonly QEMU=$(which qemu-system-arm)

[[ -z "$QEMU" ]] && \
  ( echo 'Install qemu' ; exit 1 )

readonly TMP_DIR="${HOME}/qemu_vms"
readonly RPI_KERNEL="${TMP_DIR}/kernel-qemu-4.14.79-stretch"
readonly RPI_FS="${TMP_DIR}/2019-09-26-raspbian-buster-lite.img"
readonly PTB_FILE="${TMP_DIR}/versatile-pb.dtb"

"$QEMU" -kernel "$RPI_KERNEL" \
  -cpu arm1176 -m 256 -M versatilepb \
  -dtb "$PTB_FILE" -no-reboot \
  -serial stdio -append 'root=/dev/sda2 panic=1 rootfstype=ext4 rw' \
  -drive "file=${RPI_FS},index=0,media=disk,format=raw" \
  -net user,hostfwd=tcp::5022-:22 -net nic
