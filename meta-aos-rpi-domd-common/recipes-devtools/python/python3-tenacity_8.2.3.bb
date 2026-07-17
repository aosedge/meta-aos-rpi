SUMMARY = "Retry library for Python"
HOMEPAGE = "https://github.com/jd/tenacity"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"

PYPI_PACKAGE = "tenacity"

inherit pypi setuptools3

SRC_URI[sha256sum] = "5398ef0d78e63f40007c1fb4c0bff96e1911394d2fa8d194f77619c05ff6cc8a"

DEPENDS += "python3-setuptools-scm-native"

RDEPENDS:${PN} = "python3-core"

BBCLASSEXTEND = "native nativesdk"
