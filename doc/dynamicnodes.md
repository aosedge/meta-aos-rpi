# Dynamic nodes set up

## Hardware requirements

The same hardware requirements described in the [README.md](../README.md#hardware-prerequisites).
But you should have at least 2 Raspberry Pi 5 boards to test dynamic nodes setup.

## Network configuration

Your network configuration (router settings for example) should match the below requirements:

* Main node has static IP: `10.0.0.100`.
* Secondary nodes obtain IP addresses via DHCP. IP addresses must be in the same subnetwork as the main node.
* Secondary nodes use the main node IP address as their DNS server.
* Default gateway IP address is `10.0.0.1`.

The main node's static address is configured during yocto build.
You can change the IP address and build main/secondary images yourself: update static IP
and gateway IP in [yaml](../aos-rpi.yaml) file.

## Flash AosCore install image to SD card using Raspberry Pi Imager

This example uses 2 Raspberry Pi 5 board with nVME. Follow the steps described in
the [README.md](../README.md#flash-aoscore-install-image-to-sd-card-using-raspberry-pi-imager)
to prepare SD cards for the main and secondary nodes:

1. `AosCore main node for NVMe drive` - for the Raspberry Pi 5 board that will be main (SD card #1)
2. `AosCore secondary node for NVMe drive` - for the Raspberry Pi 5 board that will be secondary (SD card #2)

## Verify nodes have correct IP addresses

After flashing the nodes, perform the next checks:

* the main node has the static IP address and internet access

    ```console
    (XEN) main:~# ip r
    (XEN) default via 10.0.0.1 dev eth0 proto static
    (XEN) 10.0.0.0/24 dev eth0 proto kernel scope link src 10.0.0.100

    (XEN) main:~# ping google.com
    (XEN) PING google.com (172.217.16.14): 56 data bytes
    (XEN) 64 bytes from 172.217.16.14: seq=0 ttl=118 time=16.508 ms
    ```

* the secondary node resolves main node correctly

    ```console
    (XEN) secondary:~# ip r
    (XEN) default via 10.0.0.1 dev eth0 proto dhcp src 10.0.0.6 metric 1024
    (XEN) 10.0.0.0/24 dev eth0 proto kernel scope link src 10.0.0.6 metric 1024
    (XEN) 10.0.0.1 dev eth0 proto dhcp scope link src 10.0.0.6 metric 1024

    (XEN) secondary:~# ping google.com
    (XEN) PING google.com (172.217.16.14): 56 data bytes
    ```

* the secondary node resolves main node correctly:

    ```console
    (XEN) secondary:~# ping main
    (XEN) PING main (10.0.0.100): 56 data bytes
    (XEN) 64 bytes from 10.0.0.100: seq=0 ttl=64 time=0.255 ms
    (XEN) 64 bytes from 10.0.0.100: seq=1 ttl=64 time=0.221 ms
    ```

## Provision unit

Execute provisioning script on your host PC and pass obtained IP address as parameter

```console
aos-prov provision -u 10.0.0.100 --nodes 4
```

The resulting unit is expected to contain 4 nodes:

* Raspberry Pi 5 board with main node image contains: main-dom0, main-domd nodes;
* Raspberry Pi 5 board with secondary node image contains: secondary-dom0, secondary-domd nodes;

*Note*: dynamic nodes provisioning requires less steps compared to [README.md](../README.md#provision-device-with-aoscloud),
 because our `main` node is configured with static ip.

## Known issues

* `Zephyr RTOS` Dom0 freezes in rare cases after provisioning.
  Node works fine after rebooting Raspberry Pi 5 board with the frozen Dom0 node.
