# meta-aos-rpi

This repository contains AodEdge Yocto layers for building Aos virtual machine.

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

Moulin is used to generate Ninja build file: `mouling aos-rpi.yaml`. This project provides number of additional
parameters. You can check them with`--help-config` command line option:

```sh
usage: moulin aos-rpi.yaml [--VIS_DATA_PROVIDER {renesassimulator,telemetryemulator}] [--DOMD_NODE_TYPE {main,secondary}] [--MACHINE {rpi5}] [--DOMD_ROOT {usb,nvme}]

Config file description: Raspberry 5 with xen dom0less

options:
  --VIS_DATA_PROVIDER {renesassimulator,telemetryemulator}
                        Specifies plugin for VIS automotive data (default: renesassimulator)
  --DOMD_NODE_TYPE {main,secondary}
                        Domd node type to build (default: main)
  --MACHINE {rpi5}      Raspberry Pi machines (default: rpi5)
  --DOMD_ROOT {usb,nvme}
                        Domd root device (default: usb)
```

* `DOMD_NODE_TYPE` specifies the DomD node type to build: `main` - main node, `secondary` -
secondary node. By default, main node is built.

* `VIS_DATA_PROVIDER` - specifies VIS data provider: `renesassimulator` - Renesas Car simulator, `telemetryemulator` -
telemetry emulator that reads data from the local file. By default, Renesas Car simulator is used.

After performing moulin command with desired configuration, it will generate `build.ninja` with all necessary build
targets.

The moulin yaml file contains two target for different block devices:

* `boot` - for SD-Card that contains boot partition and Dom0 zephyr partition;
* `rootfs` - for USB flash drive or nvme device (depends on `DOMD_ROOT` option) that contains rootfs partitions of DomD and other guest domains.

### Build boot image

Build boot image:

```sh
ninja boot.img
```

Build rootfs image:

```sh
ninja rootfs.img
```

You should have `boot.img` and `rootfs.img` files in the build folder.

### Flash boot image

To flash boot image on SD-card run below command:

```sh
sudo dd if=dom0.img of=/dev/<sd-dev> bs=4M status=progress conv=sparse
```

**NOTE:** Be sure to identify correctly <sd-dev> which is usually `sda`. For SD-card identification
Plug/unplug SD-card and check `/dev/` for devices added/removed.

**NOTE:** Ensure existing SD-card partitions unmounted if auto-mount is enabled.
s

### Flash rootfs image to the USB-flash

To flash USB-flash image run below command:

```sh
sudo dd if=rootfs.img of=/dev/<usb-dev> bs=4M status=progress conv=sparse
```

**NOTE:** Be sure to identify correctly <usb-dev> which could look like `sdc`.
For USB-flash identification Plug/unplug USB-flash and check `/dev/` for devices added/removed.

**NOTE:** Ensure existing USB-flash partitions unmounted if auto-mount is enabled.

### Flash rootfs rootfs image to the nvme storage

* Create SD-card with official Ubuntu from Raspberry foundation.
* Copy file `rootfs.img` to the USB-Flash dongle.
* Boot from SD-card with official RPI image. Plug USB-Flash dongle to your device.
* Flash `rootfs.img` image:

```sh
dd if=<usb-dev>/rootfs.img of=/dev/nvme0n1 bs=1M status=progress
```
