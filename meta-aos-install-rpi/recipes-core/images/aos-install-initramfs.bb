DESCRIPTION = "Image for installing boot.img and rootfs.img."
 
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

# Don't allow the initramfs to contain a kernel
PACKAGE_EXCLUDE = "kernel-image-*"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""
 
IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_NAME_SUFFIX = ""
 
IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|aarch64.*)-(linux.*)' 
PACKAGE_INSTALL = "${VIRTUAL-RUNTIME_base-utils} initramfs-aos-install"

inherit image
