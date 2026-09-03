# Manual build

## Requirements

1. Ubuntu 22.0+ or any other Linux distribution which is supported by Poky/OE.

2. Development packages for Yocto. Refer to [Yocto manual](<https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html#build-host-packages>).

3. Install `curl`:

   ```console
   sudo apt install curl
   ```

4. Some Linux distribution may require `lz4`: `sudo apt install lz4` on Ubuntu.

5. You need `Moulin` of version 0.21 or newer installed in your PC. Recommended way is to install it for your user only:

   ```console
   pip3 install --user git+https://github.com/xen-troops/moulin
   ```

   Make sure that your `PATH` environment variable includes `${HOME}/.local/bin`.

6. Ninja build system:

   ```console
   sudo apt install ninja-build
   ```

7. Zephyr SDK 0.17. Refer to
   [Zephyr SDK installation instructions](<https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html>).

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

usage: moulin aos-rpi.yaml [--MACHINE {rpi5}] [--DOMD_NODE_TYPE {single,main,secondary}] [--DOMD_CAN_TYPE {SEEED-FD,MCP2515}] [--DEBUG_TWEAKS {disabled,enabled}]
                           [--DOMD_ROOT {usb,nvme}] [--SELINUX {enabled,permissive,disabled}] [--DOM0_AOS {enabled,disabled}] [--WITH_BENCHMARK {yes,no}]
                           [--WITH_FASTDDS {yes,no}] [--CACHE_LOCATION {outside,inside}]

Config file description: AosCore build for Raspberry Pi 5

options:
  --MACHINE {rpi5}      Raspberry Pi machine (default: rpi5)
  --DOMD_NODE_TYPE {single,main,secondary}
                        Domd node type to build (default: single)
  --DOMD_CAN_TYPE {SEEED-FD,MCP2515}
                        Domd CAN chip type (default: SEEED-FD)
  --DEBUG_TWEAKS {disabled,enabled}
                        Allow configure build with debug-tweaks. (default: disabled)
  --DOMD_ROOT {usb,nvme}
                        Domd root device (default: usb)
  --SELINUX {enabled,permissive,disabled}
                        Enables SELinux (default: disabled)
  --DOM0_AOS {enabled,disabled}
                        Enable Aos in Dom0 (default: disabled)
  --WITH_BENCHMARK {yes,no}
                        Enable benchmark tools (default: no)
  --WITH_FASTDDS {yes,no}
                        Enable Fast DDS (default: no)
  --CACHE_LOCATION {outside,inside}
                        Indicated where cache and downloads are stored: inside build dir or outside. (default: outside)
```

* `MACHINE` - specifies Raspberry machine type. Currently only `rpi5` is supported;

* `DOMD_NODE_TYPE` - specifies the DomD node type to build: `single` - single node,
   `main` - main node, `secondary` - secondary node (`main` and `secondary` node types are used for multinode setup).
   By default, `single` node is built;

* `DOMD_CAN_TYPE` - specifies the DomD CAN device type. Currently supported `SEEED-FD` and `MCP2515`. By default,
  `SEEED-FD` is used;

* `DEBUG_TWEAKS` - allows to configure build with debug-tweaks. Also it enables user root without password. By default,
  it is disabled.

* `DOMD_ROOT` - specifies the DomD root device type: `usb` - USB device, `nvme` - NVMe device. By default, `usb`
  is used.

* `SELINUX` - enables SELinux security in DomD Linux. Currently, not fully implemented and disabled by default.

* `DOM0_AOS` - enables Aos in Dom0. By default, it is disabled.

* `WITH_BENCHMARK` - enables benchmark tools. By default, it is disabled.

* `WITH_FASTDDS` - specifies to include Fast DDS and the discovery server into the build. They are added on the main
node only.

* `CACHE_LOCATION` - indicated where cache and downloads are stored: inside build dir or outside.

After performing moulin command with desired configuration, it will generate `build.ninja` with all necessary build
targets.

The moulin yaml file contains two target for different block devices:

* `boot-%{DOMD_NODE_TYPE}-%{DOMD_ROOT}` - contains boot partition and Dom0 zephyr partition;
* `rootfs-%{DOMD_NODE_TYPE}-%{DOMD_ROOT}` - contains rootfs partitions of DomD and other guest domains.

The configuration depends on `DOMD_NODE_TYPE` and `DOMD_ROOT` options.

### Build install image for usb single node

```console
moulin aos-rpi.yaml --DOMD_NODE_TYPE=single --DOMD_ROOT=usb
ninja install-single-usb.img
```

### Build install image for NVMe single node

```console
moulin aos-rpi.yaml --DOMD_NODE_TYPE=single --DOMD_ROOT=nvme
ninja install-single-nvme.img
```

## Flash install image

```console
sudo dd if=install-single-usb.img of=/dev/<sd-dev> bs=4M status=progress
```

or

```console
sudo dd if=install-single-nvme.img of=/dev/<sd-dev> bs=4M status=progress
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
