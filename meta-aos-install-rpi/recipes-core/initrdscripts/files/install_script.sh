#!/bin/sh

echo "Welcome to AOS RPI!"
echo "Setting up your system for a smooth experience..."

echo "Initializing the file system..."

PATH=/sbin:/bin:/usr/sbin:/usr/bin

mkdir -p /proc /sys /dev
mount -t proc proc /proc || echo "Failed to mount /proc"
mount -t sysfs sysfs /sys || echo "Failed to mount /sys"
mount -t devtmpfs dev /dev || echo "Failed to mount /dev"

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=$(cat /proc/cmdline)
    for arg in $CMDLINE; do
        case $arg in
        aos_disk=*)
            BLOCK_DEVICE="${arg#*=}"
            ;;
        esac
    done
}

wait_for_block_device() {
    device=/dev/$1
    c=0
    delay=1
    timeout=5

    echo "Waiting for device $device to be ready..."

    while [ ! -b "$device" ]; do
        if [ $((c * delay)) -gt $timeout ]; then
            echo "Device $device is not available after $timeout seconds."
            return 1
        fi

        echo "Device $device is not available yet. Retrying in $delay sec..."

        sleep $delay
        c=$((c + 1))
    done

    echo "Device $device is ready."

    return 0
}

read_args

if [ "$BLOCK_DEVICE" = "sda" ]; then
    BLOCK_DEVICE_PARTITION="sda3"
elif [ "$BLOCK_DEVICE" = "nvme0n1p" ]; then
    BLOCK_DEVICE_PARTITION="nvme0n1p3"
else
    echo "Error: Unsupported BLOCK_DEVICE ($BLOCK_DEVICE)"
    exit 1
fi

echo "Preparing the SD card..."

mkdir -p /flash /sd
mount -t auto /dev/mmcblk0p2 /sd

echo "Flashing the flash drive..."

wait_for_block_device "$BLOCK_DEVICE"

gunzip -c /sd/rootfs.img.gz | dd of="/dev/$BLOCK_DEVICE" bs=8096 || echo "Failed to write rootfs.img"
mkfs.ext4 -F -E lazy_journal_init=1 "/dev/$BLOCK_DEVICE_PARTITION" || echo "Failed to format /dev/$BLOCK_DEVICE_PARTITION"

mount -t auto /dev/$BLOCK_DEVICE_PARTITION /flash || echo "Failed to remount /dev/$BLOCK_DEVICE_PARTITION"

echo "Flashing the SD card..."

mkdir -p /flash/tmp
cp -v /sd/boot.img.gz /flash/tmp || echo "Failed to copy boot.img to tmp"
umount /sd
gunzip -c /flash/tmp/boot.img.gz | dd of=/dev/mmcblk0 bs=8096 || echo "Failed to copy boot.img to tmp"

rm /flash/tmp/boot.img.gz

exec reboot -f
