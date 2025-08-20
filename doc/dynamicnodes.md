# Dynamic nodes set up

### Hardware requirements

The same hardware requirements described in the `README.md`

### Network configuration

1. Main node has static IP: ```10.0.0.100```.
2. Secondary nodes obtain IP addresses via DHCP. IP addresses must be in the same subnetwork as the main node.
3. Secondary nodes use the main node as their DNS server.

The main node's static address is configured during yocto build.
You can change the IP address and build main/secondary images yourself.

### Flash AosCore install image to SD card using Raspberry Pi Imager

Follow the steps described in the `README.md` to prepare SD cards for the main
and secondary nodes. In this example 2 RPI5 with nVME are used, so the next images are used:

1. `AosCore for NMVe drive main node` - for the RPI board that will be main (SD card #1)
2. `AosCore for NMVe drive secondary node` - for the RPI board that will be secondary (SD card #2)
