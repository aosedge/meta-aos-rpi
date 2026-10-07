# Use xen-troops TF-A with SCMI server support (includes OP-TEE support for RPI5)
include ${@bb.utils.contains('MACHINE_FEATURES', 'scmi', 'trusted-firmware-a-scmi.inc', '', d)}
