FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://optee-identity.conf \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/aos-cm.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/aos-cm.service.d/10-optee-identity.conf
}
