#!/bin/sh

sleep 1

echo
echo "********************************************************************************"
echo "Welcome to AosCore install script!"
echo "********************************************************************************"
echo
echo "Setting up your system for a smooth experience."

sleep 1

PATH=/sbin:/bin:/usr/sbin:/usr/bin

mkdir -p /proc /sys /dev
mount -t proc proc /proc || echo "Failed to mount /proc"
mount -t sysfs sysfs /sys || echo "Failed to mount /sys"
mount -t devtmpfs dev /dev || echo "Failed to mount /dev"

echo "Initializing the file system..."

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

BLOCK_DEVICE_PARTITION="${BLOCK_DEVICE}3"
BLOCK_DEVICE="${BLOCK_DEVICE%p}"

wait_for_block_device "$BLOCK_DEVICE"

echo "Preparing the SD card..."

mkdir -p /flash /sd
mount -t auto /dev/mmcblk0p2 /sd

echo "Flashing root device..."

gunzip -c /sd/rootfs.img.gz | dd of="/dev/$BLOCK_DEVICE" bs=8096 || echo "Failed to write rootfs.img"
mkfs.ext4 -F -E lazy_journal_init=1 "/dev/$BLOCK_DEVICE_PARTITION" || echo "Failed to format /dev/$BLOCK_DEVICE_PARTITION"

mount -t auto "/dev/$BLOCK_DEVICE_PARTITION" /flash || echo "Failed to mount /dev/$BLOCK_DEVICE_PARTITION"

echo "Flashing SD card..."

cp /sd/boot.img.gz /flash || echo "Failed to copy boot.img"
umount /sd
gunzip -c /flash/boot.img.gz | dd of=/dev/mmcblk0 bs=8096 || echo "Failed to write boot.img"

rm /flash/boot.img.gz

echo
echo "********************************************************************************"
echo "AosCore image successfully installed!"
echo "********************************************************************************"
echo
echo "Rebooting the system..."

sleep 5

exec reboot -f
