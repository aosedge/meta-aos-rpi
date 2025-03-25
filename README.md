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
