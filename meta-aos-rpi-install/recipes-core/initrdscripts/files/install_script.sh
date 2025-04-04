#!/bin/sh

set -e

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
mount -t proc proc /proc || { echo "Failed to mount /proc"; exit 1; }
mount -t sysfs sysfs /sys || { echo "Failed to mount /sys"; exit 1; }
mount -t devtmpfs dev /dev || { echo "Failed to mount /dev"; exit 1; }

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


add_user() {
    mkdir -p /sd1 /flash1
    mount -t auto /dev/mmcblk0p1 /sd1/

    if [ -f /sd1/firstrun.sh ]; then
        echo "Adding user provided by Raspberry Pi Imager..."

        mount -t auto "/dev/${BLOCK_DEVICE_ROOTFS_PARTITION}" /flash1/ || { echo "Failed to mount /dev/${BLOCK_DEVICE_ROOTFS_PARTITION}"; exit 1; }
        output=$(sed -n "s/.*userconf '\(.*\)' '\(.*\)'.*/\1 \2/p" /sd1/firstrun.sh)
        user=$(echo "$output" | awk '{print $1}')
        
        if [ -n "$user" ]; then
            password=$(echo "$output" | awk '{print $2}')
            
            echo "$user:x:1000:1000:$user,,,:/home/$user:/bin/sh" >> /flash1/etc/passwd
            echo "$user:x:1000:" >> /flash1/etc/group
            echo "$user:$password:19000:0:99999:7:::" >> /flash1/etc/shadow

            sed -i "/^sudo:/s/$/$user/" /flash1/etc/group
            echo "%sudo   ALL=(ALL:ALL) ALL" >> /flash1/etc/sudoers

            mkdir -p "/flash1/home/$user"
            chown 1000:1000 "/flash1/home/$user"
            chmod 700 "/flash1/home/$user"
        else
            echo "No valid user found"
        fi
        umount /flash1
    fi
    umount /sd1
}

read_args

BLOCK_DEVICE_ROOTFS_PARTITION="${BLOCK_DEVICE}1"
BLOCK_DEVICE_PARTITION="${BLOCK_DEVICE}3"
BLOCK_DEVICE="${BLOCK_DEVICE%p}"

wait_for_block_device "$BLOCK_DEVICE"

echo "Preparing the SD card..."

mkdir -p /sd2 /flash3
mount -t auto /dev/mmcblk0p2 /sd2

echo "Flashing root device..."

gunzip -c /sd2/rootfs.img.gz | dd of="/dev/$BLOCK_DEVICE" bs=8096 || { echo "Failed to write rootfs.img"; exit 1; }
mkfs.ext4 -F -E lazy_journal_init=1 "/dev/$BLOCK_DEVICE_PARTITION" || { echo "Failed to format /dev/$BLOCK_DEVICE_PARTITION"; exit 1; }

mount -t auto "/dev/$BLOCK_DEVICE_PARTITION" /flash3 || { echo "Failed to mount /dev/$BLOCK_DEVICE_PARTITION"; exit 1; }

add_user

echo "Flashing SD card..."

cp /sd2/boot.img.gz /flash3 || { echo "Failed to copy boot.img"; exit 1; } 
umount /sd2
gunzip -c /flash3/boot.img.gz | dd of=/dev/mmcblk0 bs=8096 || { echo "Failed to write boot.img"; exit 1; }
rm /flash3/boot.img.gz

echo
echo "********************************************************************************"
echo "AosCore image successfully installed!"
echo "********************************************************************************"
echo
echo "Rebooting the system..."

sleep 5

exec reboot -f
