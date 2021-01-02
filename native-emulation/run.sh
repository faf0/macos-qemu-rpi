#!/usr/bin/env bash

set -euxo pipefail

readonly IMAGE='2020-02-13-raspbian-buster-lite'
readonly KERNEL='kernel8.img'
readonly PTB='bcm2710-rpi-3-b-plus.dtb'

readonly TMP_DIR="${HOME}/qemu_vms_native"
readonly IMAGE_FILE="${TMP_DIR}/${IMAGE}.img"
readonly KERNEL_FILE="${TMP_DIR}/${KERNEL}"
readonly PTB_FILE="${TMP_DIR}/${PTB}"

readonly QEMU_SYS='qemu-system-aarch64'

has_qemu () {
  command -v "$QEMU_SYS" &> /dev/null || \
    { echo 'Install QEMU'; exit 1; }
}

run_qemu () {
  "$QEMU_SYS" \
    -m 1G \
    -M raspi3 \
    -smp 4 \
    -serial stdio \
    -usb \
    -device usb-mouse \
    -device usb-kbd \
    -sd "$IMAGE_FILE" \
    -net 'user,hostfwd=tcp::5022-:22' \
    -net nic \
    -dtb "$PTB_FILE" \
    -kernel "$KERNEL_FILE" \
    -append 'rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1' \
    -no-reboot
} 

main () {
  has_qemu
  run_qemu
}

main
