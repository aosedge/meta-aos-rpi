FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS:append = " efivar"

SRC_URI += "\
    file://optee-identity.conf \
    file://grpc-dns-resolver.conf \
    file://resources.cfg \
"

# Base layer for services
RDEPENDS:${PN} += "\
    python3 \
    python3-core \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/aos-sm.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/aos-sm.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/grpc-dns-resolver.conf ${D}${sysconfdir}/systemd/system/aos-sm.service.d/20-grpc-dns-resolver.conf

    install -d ${D}${sysconfdir}/aos
    install -m 0644 ${WORKDIR}/resources.cfg ${D}${sysconfdir}/aos
}
