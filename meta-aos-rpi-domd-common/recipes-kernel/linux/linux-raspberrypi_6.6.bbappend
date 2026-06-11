FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://misc.cfg \
    file://network.cfg \
    file://optee.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'file://selinux.cfg', '', d)} \
"
