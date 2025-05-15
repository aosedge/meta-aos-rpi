FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend:aos-main-node := "${THISDIR}/files/main-node:"
FILESEXTRAPATHS:prepend:aos-secondary-node := "${THISDIR}/files/secondary-node:"

SRC_URI += "\
    file://optee-identity.conf \
    file://reboot-on-failure.conf \
    file://aos-reboot.service \
"

FILES:${PN} += "\
    ${systemd_system_unitdir} \
"

AOS_UM_UPDATE_MODULES = "\
    updatemodules/overlayxenstore \
    updatemodules/ubootdualpart \
"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/aos-reboot.service ${D}${systemd_system_unitdir}/aos-reboot.service

    install -d ${D}${sysconfdir}/systemd/system/${PN}.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/reboot-on-failure.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-reboot-on-failure.conf
}
