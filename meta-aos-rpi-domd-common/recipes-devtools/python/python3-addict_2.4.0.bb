SUMMARY = "Addict is a Python module that gives you dictionaries whose values are gettable and settable using attributes"
HOMEPAGE = "https://github.com/mewwts/addict"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=068bc3fbaaf54a0fd7d3c7f47b7df5fa"

PYPI_PACKAGE = "addict"

inherit pypi setuptools3

SRC_URI[sha256sum] = "b3b2210e0e067a281f5646c8c5db92e99b7231ea8b0eb5f74dbdf9e259d4e494"

RDEPENDS:${PN} = "python3-core"
