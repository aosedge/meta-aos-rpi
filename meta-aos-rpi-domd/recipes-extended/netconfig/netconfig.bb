SUMMARY = "Network configuration files"
DESCRIPTION = "Network configuration files for DomD Linux for Raspberry Pi devices"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += "\
    file://wired.network \
"

FILES:${PN} += "\
    ${sysconfdir}/systemd/network/20-wired.network \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/wired.network ${D}${sysconfdir}/systemd/network/20-wired.network

    if [ ${AOS_USE_DHCP} = "1" ]; then
        echo "DHCP=yes" >> ${D}${sysconfdir}/systemd/network/20-wired.network
        echo "Address=${AOS_NODE_IP}" >> ${D}${sysconfdir}/systemd/network/20-wired.network
    else
        echo "Address=${AOS_NODE_IP}" >> ${D}${sysconfdir}/systemd/network/20-wired.network
        echo "Gateway=${AOS_NODE_GW_IP}" >> ${D}${sysconfdir}/systemd/network/20-wired.network
        echo "DNS=${AOS_NODE_GW_IP}" >> ${D}${sysconfdir}/systemd/network/20-wired.network
    fi
}
