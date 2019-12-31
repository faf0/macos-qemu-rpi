#!/usr/bin/env bash

set -euxo pipefail

readonly QEMU_SYS='qemu-system-arm'
readonly TMP_DIR="${HOME}/qemu_vms"
readonly RPI_KERNEL="${TMP_DIR}/kernel-qemu-4.19.50-buster"
readonly RPI_FS="${TMP_DIR}/2019-09-26-raspbian-buster-lite.img"
readonly PTB_FILE="${TMP_DIR}/versatile-pb.dtb"

has_qemu () {
  command -v "$QEMU_SYS" &> /dev/null || \
    { echo 'Install QEMU'; exit 1; }
}

run_qemu () {
  "$QEMU_SYS" -kernel "$RPI_KERNEL" \
    -cpu arm1176 -m 256 -M versatilepb \
    -dtb "$PTB_FILE" -no-reboot \
    -serial stdio -append 'root=/dev/sda2 panic=1 rootfstype=ext4 rw' \
    -drive "file=${RPI_FS},index=0,media=disk,format=raw" \
    -net user,hostfwd=tcp::5022-:22 -net nic
}

main () {
  has_qemu
  run_qemu
}

main
