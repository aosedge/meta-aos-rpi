SRC_URI_TRUSTED_FIRMWARE_A = "git://github.com/xen-troops/arm-trusted-firmware.git;protocol=https"

SRCREV_tfa = "9446cc4ea01d22155959b1df7f98f0ef3627e505"
SRCBRANCH = "rpi5_dev"

EXTRA_OEMAKE += "SCMI_SERVER_SUPPORT=1"

# OP-TEE support is already present in rpi5_dev branch
SRC_URI:remove = " \
    file://0001-rpi5-add-OP-TEE-support.patch \
"
