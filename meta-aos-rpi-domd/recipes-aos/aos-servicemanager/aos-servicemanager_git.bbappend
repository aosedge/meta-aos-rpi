FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://optee-identity.conf \
"

FILES:${PN} += " \
    ${sysconfdir} \
"

# Base layer for services
RDEPENDS:${PN} += " \
    python3 \
    python3-core \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/${PN}.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-optee-identity.conf
}
