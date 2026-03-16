FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://dnsmasq.conf.in"
FILES:${PN} += "/var/aos/dns/* /etc/aos/addnhosts"

python do_addnhosts() {
    import os

    hosts_string = d.getVar('AOS_HOSTS') or ""
    destdir = d.getVar('D')
    addnhosts_content = []

    if hosts_string:
        entries = hosts_string.split()

        for entry in entries:
            entry = entry.strip()
            if not entry:
                continue

            parts = entry.split('=')
            if len(parts) >= 2:
                ip = parts[0]
                hostnames = ' '.join(parts[1:])
                addnhosts_content.append(f"{ip} {hostnames}")

    addnhosts_file = os.path.join(destdir, 'etc/aos/addnhosts')
    with open(addnhosts_file, 'w') as f:
        f.write('\n'.join(addnhosts_content))
        if addnhosts_content:
            f.write('\n')
}

do_configure:append() {
    sed -e "s|@LISTEN_IP@|${AOS_DNS_IP}|" \
        -e "s|@ADDNHOSTS_PATH@|/var/aos/dns|" \
        -e "s|@PERSISTENT_ADDNHOSTS_PATH@|/etc/aos|" \
        ${WORKDIR}/dnsmasq.conf.in > ${WORKDIR}/dnsmasq.conf
}

do_install:append() {
    if [ -f ${D}${systemd_system_unitdir}/dnsmasq.service ]; then
        sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/dnsmasq -C /var/aos/dns/dnsmasq.conf|' \
            ${D}${systemd_system_unitdir}/dnsmasq.service

        sed -i '/^PIDFile=/d' ${D}${systemd_system_unitdir}/dnsmasq.service
    fi

    install -d ${D}/var/aos/dns
    install -d ${D}/etc/aos
    install -m 0644 ${WORKDIR}/dnsmasq.conf ${D}/var/aos/dns/dnsmasq.conf

    touch ${D}/var/aos/dns/addnhosts
    touch ${D}/etc/aos/addnhosts
}

addtask addnhosts after do_install before do_package
