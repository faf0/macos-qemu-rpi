#!/usr/bin/env bash

set -euxo pipefail

readonly IMAGE='2020-02-13-raspbian-buster-lite'
readonly KERNEL='kernel-qemu-5.4.51-buster'
readonly PTB='versatile-pb-buster-5.4.51.dtb'

readonly TMP_DIR="${HOME}/qemu_vms"
readonly IMAGE_FILE="${TMP_DIR}/${IMAGE}.img"
readonly KERNEL_FILE="${TMP_DIR}/${KERNEL}"
readonly PTB_FILE="${TMP_DIR}/${PTB}"

readonly QEMU_SYS='qemu-system-arm'

has_qemu () {
  command -v "$QEMU_SYS" &> /dev/null || \
    { echo 'Install QEMU'; exit 1; }
}

run_qemu () {
  "$QEMU_SYS" \
    -cpu arm1176 \
    -m 256 \
    -M versatilepb \
    -drive "file=${IMAGE_FILE},if=none,index=0,media=disk,format=raw,id=disk0" \
    -device 'virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off' \
    -net 'user,hostfwd=tcp::5022-:22' \
    -net nic \
    -dtb "$PTB_FILE" \
    -kernel "$KERNEL_FILE" \
    -append 'root=/dev/vda2 panic=1' \
    -no-reboot \
    -nographic
}

main () {
  has_qemu
  run_qemu
}

main
