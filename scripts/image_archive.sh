#!/bin/bash

BOOT_INPUT_FILE="../boot-$1.img"
BOOT_OUTPUT_FILE="../boot-$1.img.gz"

ROOTFS_INPUT_FILE="../rootfs-$1.img"
ROOTFS_OUTPUT_FILE="../rootfs-$1.img.gz"

if [ ! -f "$BOOT_INPUT_FILE" ]; then
    echo "File $BOOT_INPUT_FILE is not found."
    exit 1
fi

if [ ! -f "$ROOTFS_INPUT_FILE" ]; then
    echo "File $ROOTFS_INPUT_FILE is not found."
    exit 1
fi

gzip -c "$BOOT_INPUT_FILE" > "$BOOT_OUTPUT_FILE"
gzip -c "$ROOTFS_INPUT_FILE" > "$ROOTFS_OUTPUT_FILE"
