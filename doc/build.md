# Manual build

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

```console
curl -O https://raw.githubusercontent.com/aosedge/meta-aos-rpi/main/aos-rpi.yaml
```

## Build

Moulin is used to generate Ninja build file: `moulin aos-rpi.yaml`. This project provides number of additional
parameters. You can check them with`--help-config` command line option:

```console
moulin aos-rpi.yaml --help-config

usage: moulin aos-rpi.yaml [--DOMD_NODE_TYPE {single,main,secondary}] [--MACHINE {rpi5}] [--CACHE_LOCATION {outside,inside}]
                           [--DOMD_ROOT {usb,nvme}] [--SELINUX {enabled,permissive,disabled}]
                           [--USE_DHCP {yes,no}]

Config file description: AosCore build for Raspberry Pi 5

options:
  --DOMD_NODE_TYPE {single,main,secondary}
                        Domd node type to build (default: single)
  --MACHINE {rpi5}      Raspberry Pi machine (default: rpi5)
  --CACHE_LOCATION {outside,inside}
                        Indicated where cache and downloads are stored: inside build dir or outside. (default: outside)
  --DOMD_ROOT {usb,nvme}
                        Domd root device (default: usb)
  --SELINUX {enabled,permissive,disabled}
                        Enables SELinux (default: disabled)
  --USE_DHCP {yes,no}   Use DHCP for network configuration
```

* `DOMD_NODE_TYPE` - specifies the DomD node type to build: `single` - single node,
   `main` - main node, `secondary` - secondary node (`main` and `secondary` node types are used for multinode setup).
   By default, `single` node is built;

* `MACHINE` - specifies Raspberry machine type. Currently only `rpi5` is supported;

* `SELINUX` - enables SELinux security in DomD Linux. Currently, not fully implemented and disabled by default.

* `CACHE_LOCATION` - indicated where cache and downloads are stored: inside build dir or outside.

* `USE_DHCP` - determines whether the system should use DHCP to automatically obtain network settings.

After performing moulin command with desired configuration, it will generate `build.ninja` with all necessary build
targets.

The moulin yaml file contains two target for different block devices:

* `boot-usb` - for SD-Card that contains boot partition and Dom0 zephyr partition;
* `rootfs-usb` - for USB flash drive  that contains rootfs partitions of DomD and other guest domains.

or

* `boot-nvme` - for SD-Card that contains boot partition and Dom0 zephyr partition;
* `rootfs-usb` - for NVMe device that contains rootfs partitions of DomD and other guest domains.

The configuration depends on `DOMD_ROOT` option.

### Build install image for usb

```console
moulin aos-rpi.yaml --DOMD_ROOT=usb
ninja install-usb.img
```

### Build install image for NVMe

```console
moulin aos-rpi.yaml --DOMD_ROOT=nvme
ninja install-nvme.img
```

## Flash install image

```console
sudo dd if=install-usb.img of=/dev/<sd-dev> bs=4M status=progress
```

or

```console
sudo dd if=install-nvme.img of=/dev/<sd-dev> bs=4M status=progress
```

**NOTE:** Be sure to identify correctly `<sd-dev>` which is usually `sda`. For SD-card identification
Plug/unplug SD-card and check `/dev/` for devices added/removed.

**NOTE:** Ensure existing SD-card partitions unmounted if auto-mount is enabled.

## Build layers

To build example Aos layers use the following command:

```console
ninja layers
```

Aos layers will be located in `output/layers` folder.

## Build FOTA

To build FOTA input the next commands depends on FOTA type:

For full rootfs update:

```console
ninja fota-full
```

For incremental rootfs update:

```console
ninja fota-incremental
```

FOTA bundles will be located in `output/fota` folder.
