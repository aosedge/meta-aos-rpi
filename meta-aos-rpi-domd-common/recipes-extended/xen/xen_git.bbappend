FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Use xen-troops Xen with SCMI mediator support
include ${@bb.utils.contains('MACHINE_FEATURES', 'scmi', 'xen-scmi.inc', '', d)}
