require optee.inc

EXTRA_OEMAKE += "\
    CFG_NS_VIRTUALIZATION=y \
    CFG_VIRT_GUEST_COUNT=3 \
    CFG_PKCS11_TA_HEAP_SIZE="(256 * 1024)" \
"

TA_PKCS11_UUID = "fd02c9da-306c-48c7-a49c-bbd827ae86ee"

do_deploy:append(){
    install -d ${DEPLOYDIR}

    install -d ${DEPLOYDIR}/aos/ta
    install -m 0644 ${B}/ta/pkcs11/${TA_PKCS11_UUID}.ta ${DEPLOYDIR}/aos/ta
}
