SUMMARY = "Aos image for Raspberry Pi devices"
DESCRIPTION = "AosCore image for DomD Linux for Raspberry Pi devices"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

require recipes-core/images/rpi5-image-xt-domd.bb
require recipes-core/images/aos-image.inc

inherit extrausers

CAN_PACKAGES = " \
    iproute2 \
    can-utils \
"

IMAGE_INSTALL:append = " \
    packagegroup-core-ssh-openssh \
    netconfig \
    tzdata \
    sudo \
    ${@bb.utils.contains("MACHINE_FEATURES", "domd_can", "${CAN_PACKAGES}", "" ,d)} \
    udev-rules-rpi \
    v4l-utils \
"

IMAGE_INSTALL:append = " \
    aos-messageproxy \
"

PACKAGE_INSTALL:append = " \
    kernel-modules \
"

EXTRA_USERS_PARAMS = " \
    useradd aos; \
    usermod -a -G sudo aos; \
"

enable_sudo_group() {
    # Uncomment the following line from sudoers:
    #   %sudo   ALL=(ALL:ALL) ALL
    sed -i 's/^#\s*\(%sudo\s*ALL=(ALL:ALL)\s*ALL\)/\1/'  ${IMAGE_ROOTFS}/etc/sudoers
}

update_user_profile() {
    echo 'PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin' >> ${IMAGE_ROOTFS}/home/aos/.profile
}

ROOTFS_POSTPROCESS_COMMAND:append = " \
    enable_sudo_group; \
    update_user_profile; \
"

# Set fixed rootfs size
IMAGE_ROOTFS_SIZE ?= "1048576"
IMAGE_OVERHEAD_FACTOR ?= "1.0"
IMAGE_ROOTFS_EXTRA_SPACE ?= "524288"
