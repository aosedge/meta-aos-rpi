FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS:append = " efivar"

SRC_URI += "\
    file://optee-identity.conf \
    file://grpc-dns-resolver.conf \
    file://resources.cfg \
    file://resources-benchmark.cfg \
"

FILES:${PN} += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'benchmark', '/var/aos/common-data', '', d)} \
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
    # resources-benchmark.cfg additionally adds a victoria-metrics resource (only VictoriaMetrics
    # runs on the main node - see meta-aos's aos-image.inc).
    install -m 0644 ${WORKDIR}/${@bb.utils.contains('DISTRO_FEATURES', 'benchmark', 'resources-benchmark.cfg', 'resources.cfg', d)} \
        ${D}${sysconfdir}/aos/resources.cfg

    if ${@bb.utils.contains('DISTRO_FEATURES', 'benchmark', 'true', 'false', d)}; then
        install -d -m 1777 ${D}/var/aos/common-data
    fi
}
