FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend:aos-main-node := "${THISDIR}/files/main-node:"
FILESEXTRAPATHS:prepend:aos-secondary-node := "${THISDIR}/files/secondary-node:"

SRC_URI:append = " \
    file://optee-identity.conf \
    file://grpc-dns-resolver.conf \
    file://remove-deprovision.conf \
"

AOS_IAM_IDENT_MODULES:aos-main-node = "\
    identhandler/modules/visidentifier \
"

AOS_IAM_CERT_MODULES = "\
    certhandler/modules/pkcs11module \
"

RDEPENDS:${PN} += "\
    aos-setupdisk \
    optee-client \
    optee-os-ta \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/${PN}.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/grpc-dns-resolver.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-grpc-dns-resolver.conf

    install -d ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/grpc-dns-resolver.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-grpc-dns-resolver.conf
    install -m 0644 ${WORKDIR}/remove-deprovision.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-remove-deprovision.conf
}

# Do not install headers files
# This is temporary solution and should be removed when switching to new repo approach
do_install:append() {
    rm -rf ${D}${includedir}
}
