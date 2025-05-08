IMAGE_NAME = "initramfs-${XT_DOM_NAME}"
IMAGE_NAME_SUFFIX = ""

AOS_INITRAMFS_SCRIPTS += "\
    initramfs-module-lvm \
    initramfs-module-nfsrootfs \
    initramfs-module-opendisk \
    initramfs-module-rundir \
    optee-os-ta \
    optee-client \
    lvm2 \
"

python () {
    if 'selinux' in d.getVar('DISTRO_FEATURES').split():
        d.setVar('INITRAMFS_MAXSIZE', '262144')
}
