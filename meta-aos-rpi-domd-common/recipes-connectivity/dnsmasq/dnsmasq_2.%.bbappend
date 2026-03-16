do_install:append() {
    echo "bind-dynamic" >> ${D}${sysconfdir}/dnsmasq.conf
}
