SUMMARY = "Aos RPI install image script"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://install_script.sh"

S = "${WORKDIR}"

do_install() {
        install -m 0755 ${WORKDIR}/install_script.sh ${D}/init

        # Create device nodes expected by some kernels in initramfs
        # before even executing /init.
        install -d ${D}/dev
        mknod -m 622 ${D}/dev/console c 5 1
}

inherit allarch

FILES:${PN} += "/init /dev/console"

RDEPENDS:${PN} += "busybox e2fsprogs"

