require include/aos-rpi-dt-names.inc

XEN_OVERLAYS:append = "${@bb.utils.contains('MACHINE_FEATURES', 'scmi', ' ${SCMI_XEN_DT_NAME}.dtbo', '', d)}"
XEN_OVERLAYS:append = "${@bb.utils.contains('MACHINE_FEATURES', 'domd_wifi', ' ${XEN_WIFI_PASSTHROUGH_DT_NAME}.dtbo', '', d)}"

DOMD_OVERLAYS:append = "${@bb.utils.contains('MACHINE_FEATURES', 'scmi', ' ${SCMI_DOMD_DT_NAME}.dtbo', '', d)}"
DOMD_OVERLAYS:append = "${@bb.utils.contains('MACHINE_FEATURES', 'scmi domd_nvme', ' ${SCMI_DOMD_PCIE1_DT_NAME}.dtbo', '', d)}"

# WiFi overlay uses SCMI pinctrl nodes, so it must be applied after SCMI overlays
DOMD_OVERLAYS:append = "${@bb.utils.contains('MACHINE_FEATURES', 'domd_wifi', ' ${DOMD_WIFI_DT_NAME}.dtbo', '', d)}"

python () {
    if bb.utils.contains('MACHINE_FEATURES', 'domd_wifi', True, False, d) and \
       not bb.utils.contains('MACHINE_FEATURES', 'scmi', True, False, d):
        bb.fatal("WiFi in DomD requires SCMI support: enable it with --ENABLE_SCMI yes")
}
