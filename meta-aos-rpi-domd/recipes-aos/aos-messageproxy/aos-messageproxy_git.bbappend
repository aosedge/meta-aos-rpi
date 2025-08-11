FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://optee-identity.conf \
    file://grpc-dns-resolver.conf \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/${PN}.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/grpc-dns-resolver.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-grpc-dns-resolver.conf

    install -d ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/grpc-dns-resolver.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-grpc-dns-resolver.conf
}

# Do not install headers files
# This is temporary solution and should be removed when switching to new repo approach
do_install:append() {
    rm -rf ${D}${includedir}
}
