FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend:aos-main-node := "${THISDIR}/files/main-node:"
FILESEXTRAPATHS:prepend:aos-secondary-node := "${THISDIR}/files/secondary-node:"

SRC_URI:append:aos-main-node = " \
    file://aos-vis-service.conf \
    file://optee-identity.conf \
    file://grpc-dns-resolver.conf \
    file://remove-deprovision.conf \
"

AOS_IAM_IDENT_MODULES:aos-main-node = " \
    identhandler/modules/visidentifier \
"

AOS_IAM_CERT_MODULES = " \
    certhandler/modules/pkcs11module \
"

FILES:${PN} += " \
    ${sysconfdir} \
"

RDEPENDS:${PN} += " \
    optee-os-ta \
    optee-client \
    aos-setupdisk \
"

do_install:append:aos-main-node() {
    install -d ${D}${sysconfdir}/systemd/system/${PN}.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/aos-vis-service.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/10-aos-vis-service.conf
    install -m 0644 ${WORKDIR}/grpc-dns-resolver.conf ${D}${sysconfdir}/systemd/system/${PN}.service.d/20-grpc-dns-resolver.conf

    install -d ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d
    install -m 0644 ${WORKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-optee-identity.conf
    install -m 0644 ${WORKDIR}/grpc-dns-resolver.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-grpc-dns-resolver.conf
    install -m 0644 ${WORKDIR}/remove-deprovision.conf ${D}${sysconfdir}/systemd/system/${PN}-provisioning.service.d/20-remove-deprovision.conf
}
