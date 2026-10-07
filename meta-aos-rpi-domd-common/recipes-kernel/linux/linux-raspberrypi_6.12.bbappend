require include/aos-rpi-dt-names.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://misc.cfg \
    file://network.cfg \
    file://optee.cfg \
    ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'file://selinux.cfg', '', d)} \
"

# SCMI

RPI_KERNEL_DEVICETREE:append = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'scmi', \
                          ' broadcom/${SCMI_XEN_DT_NAME}.dtbo \
                            broadcom/${SCMI_DOMD_DT_NAME}.dtbo \
                            broadcom/${SCMI_DOMD_PCIE1_DT_NAME}.dtbo ', '', d)} \
"

SRC_URI:append = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'scmi', \
    ' file://${SCMI_XEN_DT_NAME}.dtso;subdir=git/arch/${ARCH}/boot/dts/broadcom \
      file://${SCMI_DOMD_DT_NAME}.dtso;subdir=git/arch/${ARCH}/boot/dts/broadcom \
      file://${SCMI_DOMD_PCIE1_DT_NAME}.dtso;subdir=git/arch/${ARCH}/boot/dts/broadcom ', '', d)} \
"

# WiFi

RPI_KERNEL_DEVICETREE:append = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'domd_wifi', \
                          ' broadcom/${DOMD_WIFI_DT_NAME}.dtbo \
                            broadcom/${XEN_WIFI_PASSTHROUGH_DT_NAME}.dtbo ', '', d)} \
"

SRC_URI:append = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'domd_wifi', \
    ' file://${DOMD_WIFI_DT_NAME}.dtso;subdir=git/arch/${ARCH}/boot/dts/broadcom \
      file://${XEN_WIFI_PASSTHROUGH_DT_NAME}.dtso;subdir=git/arch/${ARCH}/boot/dts/broadcom ', '', d)} \
"
