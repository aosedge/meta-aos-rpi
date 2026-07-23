do_install:append() {
    sed -i 's/^bind 127.0.0.1$/bind 127.0.0.1 10.0.0.100/' ${D}${sysconfdir}/redis/redis.conf
    sed -i 's/^# requirepass foobared$/requirepass mypassword/' ${D}${sysconfdir}/redis/redis.conf
    sed -i 's/^save/#save/' ${D}${sysconfdir}/redis/redis.conf
    sed -i '/^stop-writes-on-bgsave-error/s/yes/no/' ${D}${sysconfdir}/redis/redis.conf

    # Drop the User=/Group=redis privilege split: systemd defaults to root
    # when unset. Runs unprivileged otherwise, but stale root-owned files
    # under /var/lib/redis (e.g. from a manual root redis-server run, or
    # left over across reflashes) then break the service with
    # "Permission denied" on the AOF/pidfile.
    sed -i '/^User=redis$/d;/^Group=redis$/d' ${D}${systemd_system_unitdir}/redis.service

    # redis.conf binds to the static 10.0.0.100 address on eth0, which is a
    # Xen paravirtualized (xen-netfront) interface brought up by the driver
    # domain and can appear after network.target is reached. Ordering on
    # network-online.target (satisfied by the eth0-scoped
    # systemd-networkd-wait-online override) avoids racing the address
    # assignment and failing to bind.
    sed -i 's/^After=network.target$/After=network-online.target\nWants=network-online.target/' \
        ${D}${systemd_system_unitdir}/redis.service
}
