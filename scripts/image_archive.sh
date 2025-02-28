#!/bin/bash

BOOT_INPUT_FILE="../boot.img"
BOOT_OUTPUT_FILE="../boot.img.gz"

ROOTFS_INPUT_FILE="../rootfs.img"
ROOTFS_OUTPUT_FILE="../rootfs.img.gz"

# Проверяем, существует ли файл
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
