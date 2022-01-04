#!/usr/bin/env bash

set -euxo pipefail

readonly IMAGE='2021-10-30-raspios-bullseye-armhf-lite'
readonly KERNEL='kernel8.img'
readonly DTB='bcm2710-rpi-3-b-plus.dtb'

readonly TMP_DIR="${HOME}/qemu_vms_native"
readonly IMAGE_FILE="${TMP_DIR}/${IMAGE}.img"
readonly KERNEL_FILE="${TMP_DIR}/${KERNEL}"
readonly DTB_FILE="${TMP_DIR}/${DTB}"

readonly QEMU_SYS='qemu-system-aarch64'

has_qemu () {
  command -v "$QEMU_SYS" &> /dev/null || \
    { echo 'Install QEMU'; exit 1; }
}

run_qemu () {
  "$QEMU_SYS" \
    -m 1G \
    -M raspi3b \
    -smp 4 \
    -usb \
    -device usb-mouse \
    -device usb-kbd \
    -device 'usb-net,netdev=net0' \
    -netdev 'user,id=net0,hostfwd=tcp::5022-:22' \
    -drive "file=${IMAGE_FILE},index=0,format=raw" \
    -dtb "$DTB_FILE" \
    -kernel "$KERNEL_FILE" \
    -append 'rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1' \
    -no-reboot \
    -nographic
} 

main () {
  has_qemu
  run_qemu
}

main
