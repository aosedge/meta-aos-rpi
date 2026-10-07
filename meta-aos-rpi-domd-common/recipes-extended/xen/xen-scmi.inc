XEN_URL = "git://github.com/xen-troops/xen.git;protocol=https;branch=rpi5_dev"
XEN_REV = "2214507e72c2c2217b3234478912be6581324fbf"

# These patches are already present in rpi5_dev branch
SRC_URI:remove = " \
    file://0001-xen-arm-dom0less-build-Alloc-magic-pages-for-Dom0les.patch \
    file://0002-xen-arm-tools-Add-a-new-HVM_PARAM_MAGIC_BASE_PFN-key.patch \
    file://0003-tools-init-dom0less-Avoid-hardcoding-GUEST_MAGIC_BAS.patch \
    file://0004-arm-dom0less-add-TEE-support.patch \
"

SRC_URI:append = " file://xen-scmi.cfg"
