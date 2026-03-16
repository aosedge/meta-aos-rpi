inherit useradd

USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM:${PN} = "--system gpio"
