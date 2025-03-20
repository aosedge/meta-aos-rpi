# meta-aos-rpi

This repository contains AodEdge Yocto layers for building Aos example image for Raspberry 5.

## Prerequisites

This demo build requires two separate block devices: one contains Raspberry boot partitions and partition for Dom0
while another block device contains DomD rootfs. The build system builds two separate images for boot device and rootfs
device respectively. In order to run this demo, the following hardware is required:

1. Raspberry 5 board
2. SD-Card 2 GB minimum
3. USB flash drive 16 GB minimum
or
4. Raspberry Pi M.2 HAT+ extension board + NVMe drive 16 GB minimum.

## Requirements

1. Ubuntu 18.0+ or any other Linux distribution which is supported by Poky/OE

2. Development packages for Yocto. Refer to [Yocto manual]
   (<https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html#build-host-packages>).

3. You need `Moulin` of version 0.20 or newer installed in your PC. Recommended way is to install it for your user only:
   `pip3 install --user git+https://github.com/xen-troops/moulin`. Make sure that your `PATH` environment variable
    includes `${HOME}/.local/bin`.

4. Ninja build system: `sudo apt install ninja-build` on Ubuntu

## Fetch

You can fetch/clone this whole repository, but you actually only need one file from it: `aos-rpi.yaml`.
During the build `moulin` will fetch this repository again into `yocto/` directory. So, to reduce possible confuse,
we recommend to download only `aos-rpi.yaml`:

```sh
curl -O https://raw.githubusercontent.com/aosedge/meta-aos-rpi/main/aos-rpi.yaml
```

## Build

Moulin is used to generate Ninja build file: `moulin aos-rpi.yaml`. This project provides number of additional
parameters. You can check them with`--help-config` command line option:

```sh
moulin aos-rpi.yaml --help-config

usage: moulin aos-rpi.yaml [--VIS_DATA_PROVIDER {renesassimulator,telemetryemulator}] [--DOMD_NODE_TYPE {main,secondary}] [--MACHINE {rpi5}] [--CACHE_LOCATION {outside,inside}]
                           [--DOMD_ROOT {usb,nvme}] [--SELINUX {enabled,permissive,disabled}]

Config file description: AosCore build for Raspberry Pi 5

options:
  --VIS_DATA_PROVIDER {renesassimulator,telemetryemulator}
                        Specifies plugin for VIS automotive data (default: renesassimulator)
  --DOMD_NODE_TYPE {main,secondary}
                        Domd node type to build (default: main)
  --MACHINE {rpi5}      Raspberry Pi machine (default: rpi5)
  --CACHE_LOCATION {outside,inside}
                        Indicated where cache and downloads are stored: inside build dir or outside. (default: outside)
  --DOMD_ROOT {usb,nvme}
                        Domd root device (default: usb)
  --SELINUX {enabled,permissive,disabled}
                        Enables SELinux (default: disabled)
```

* `VIS_DATA_PROVIDER` - specifies VIS data provider: `renesassimulator` - Renesas Car simulator, `telemetryemulator` -
telemetry emulator that reads data from the local file. By default, Renesas Car simulator is used;

* `DOMD_NODE_TYPE` - specifies the DomD node type to build: `main` - main node, `secondary` - secondary node. By default,
main node is built;

* `MACHINE` - specifies Raspberry machine type. Currently only `rpi5` is supported;

* `SELINUX` - enables SELinux security in DomD Linux. Currently, not fully implemented and disabled by default.

* `CACHE_LOCATION` - indicated where cache and downloads are stored: inside build dir or outside.

After performing moulin command with desired configuration, it will generate `build.ninja` with all necessary build
targets.

The moulin yaml file contains two target for different block devices:

* `boot-usb` - for SD-Card that contains boot partition and Dom0 zephyr partition;
* `rootfs-usb` - for USB flash drive  that contains rootfs partitions of DomD and other guest domains.

or

* `boot-nvme` - for SD-Card that contains boot partition and Dom0 zephyr partition;
* `rootfs-usb` - for nvme device that contains rootfs partitions of DomD and other guest domains.

The configuration depends on `DOMD_ROOT` option.

### Build boot image for usb

```sh
ninja boot-usb.img
```

### Build rootfs image for usb

```sh
ninja rootfs-usb.img
```

You should have `boot-usb.img` and `rootfs-usb.img` files in the build folder.

### Build boot image for nvme

```sh
ninja boot-nvme.img
```

### Build rootfs image for nvme

```sh
ninja rootfs-nvme.img
```

You should have `boot-nvme.img` and `rootfs-nvme.img` files in the build folder.

### Build Boot Image and RootFS Image in Docker

You can build both images inside a Docker container by simply running the following command:

```sh
cd ./docker
./build.sh
```

You can also pass the following arguments:

| Argument             | Description |Mandatory|
|----------------------|-------------|---------|
| `--ARTIFACTS_DIR`       | Path to the directory where the build results will be stored. |NO|
| `--VIS_DATA_PROVIDER`   | Same value as described in the **Build** section. |NO|
| `--DOMD_NODE_TYPE`      | Same value as described in the **Build** section. |NO|
| `--MACHINE`             | Same value as described in the **Build** section. |NO|
| `--DOMD_ROOT`           | Same value as described in the **Build** section. |NO|
| `--SELINUX`             | Same value as described in the **Build** section. |NO|
| `--CACHE_LOCATION`      | Same value as described in the **Build** section. |NO|

Example command:

```sh
cd ./docker
./build.sh
```

or

```sh
cd ./docker
./build.sh --ARTIFACTS_DIR ~/aos_artifacts --MACHINE rpi5 --DOMD_ROOT usb
```

## Flash images

AosCore image requires two different block devices. It could be either SD card and USB flash or SD card and NVME drive.

### Flash boot image

To flash boot image on SD-card run below command:

```sh
sudo dd if=boot-usb.img of=/dev/<sd-dev> bs=4M status=progress conv=sparse
```

**NOTE:** Be sure to identify correctly `<sd-dev>` which is usually `sda`. For SD-card identification
Plug/unplug SD-card and check `/dev/` for devices added/removed.

**NOTE:** Ensure existing SD-card partitions unmounted if auto-mount is enabled.
s

### Flash rootfs image to the USB-flash

To flash USB-flash image run below command:

```sh
sudo dd if=rootfs-usb.img of=/dev/<usb-dev> bs=4M status=progress conv=sparse
```

**NOTE:** Be sure to identify correctly `<usb-dev>` which could look like `sdc`.
For USB-flash identification Plug/unplug USB-flash and check `/dev/` for devices added/removed.

**NOTE:** Ensure existing USB-flash partitions unmounted if auto-mount is enabled.

### Flash rootfs image to the nvme storage

* Create SD-card with official Ubuntu from Raspberry foundation.
* Copy file `rootfs.img` to the USB-Flash dongle.
* Boot from SD-card with official RPI image. Plug USB-Flash dongle to your device.
* Flash `rootfs.img` image:

```sh
dd if=<usb-dev>/rootfs.img of=/dev/nvme0n1 bs=1M status=progress
```
