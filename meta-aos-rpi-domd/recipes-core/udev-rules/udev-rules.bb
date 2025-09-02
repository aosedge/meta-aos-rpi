SUMMARY = "Udev rules for domd"
DESCRIPTION = "Udev rules for domd"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://gpio.rules"

do_install:append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/gpio.rules ${D}${sysconfdir}/udev/rules.d/60-gpio.rules
}
