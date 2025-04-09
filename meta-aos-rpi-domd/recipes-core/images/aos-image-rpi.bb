SUMMARY = "Aos image for Raspberry Pi devices"

require recipes-core/images/rpi5-image-xt-domd.bb
require recipes-core/images/aos-image.inc

inherit extrausers

IMAGE_INSTALL:append = " \
    packagegroup-core-ssh-openssh \
    tzdata \
    sudo \
"

IMAGE_INSTALL:append = " \
    aos-messageproxy \
"

EXTRA_USERS_PARAMS = " \
    useradd aos; \
    usermod -a -G sudo aos; \
"

do_install:append() {
    sed -i 's/^#\s*\(%sudo\s*ALL=(ALL:ALL)\s*ALL\)/\1/'  ${D}/${sysconfdir}/sudoers
}

# Set fixed rootfs size
IMAGE_ROOTFS_SIZE ?= "1048576"
IMAGE_OVERHEAD_FACTOR ?= "1.0"
IMAGE_ROOTFS_EXTRA_SPACE ?= "524288"
