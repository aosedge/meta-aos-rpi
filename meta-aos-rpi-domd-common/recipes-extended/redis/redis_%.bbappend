do_install:append() {
    sed -i 's/^bind 127.0.0.1$/bind 127.0.0.1 10.0.0.100/' ${D}${sysconfdir}/redis/redis.conf
    sed -i 's/^# requirepass foobared$/requirepass mypassword/' ${D}${sysconfdir}/redis/redis.conf
    sed -i 's/^save/#save/' ${D}${sysconfdir}/redis/redis.conf
    sed -i '/^stop-writes-on-bgsave-error/s/yes/no/' ${D}${sysconfdir}/redis/redis.conf
}
