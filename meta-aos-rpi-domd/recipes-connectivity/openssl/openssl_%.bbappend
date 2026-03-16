HSM_MODULE_PATH = "${libdir}/libckteec.so.0"

do_install:append:class-target() {
    sed -i '/^pkcs11-module-token-pin/d' ${D}${sysconfdir}/ssl/openssl.cnf
}
