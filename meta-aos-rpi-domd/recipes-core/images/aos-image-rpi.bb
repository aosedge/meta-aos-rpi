SUMMARY = "Aos image for Raspberry Pi devices"

require recipes-core/image/rpi5-image-xt-domd.bb
require recipes-core/images/aos-image.inc


IMAGE_INSTALL:append = " \
    packagegroup-core-ssh-openssh \
    tzdata \
"

IMAGE_INSTALL:append = " \
    aos-messageproxy \
"

# Set fixed rootfs size
IMAGE_ROOTFS_SIZE ?= "1048576"
IMAGE_OVERHEAD_FACTOR ?= "1.0"
IMAGE_ROOTFS_EXTRA_SPACE ?= "524288"
