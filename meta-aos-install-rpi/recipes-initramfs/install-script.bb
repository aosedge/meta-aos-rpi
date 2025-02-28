SUMMARY = "Extremely basic live image init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
SRC_URI = "file://install_script.sh"

DEPENDS += "busybox e2fsprogs"

S = "${WORKDIR}"

do_install() {
        install -m 0755 ${WORKDIR}/install_script.sh ${D}/init

        # Create device nodes expected by some kernels in initramfs
        # before even executing /init.
        install -d ${D}/dev
        mknod -m 622 ${D}/dev/console c 5 1
}

inherit allarch

RDEPENDS:${PN} += "busybox e2fsprogs"
FILES:${PN} += "/init /dev/console"
