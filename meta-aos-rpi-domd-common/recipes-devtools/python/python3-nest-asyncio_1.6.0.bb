SUMMARY = "Patch asyncio to allow nested event loops"
HOMEPAGE = "https://github.com/erdewit/nest_asyncio"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=767eeb0122cccaf224035860df064532"

PYPI_PACKAGE = "nest_asyncio"

inherit pypi setuptools3

SRC_URI[sha256sum] = "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"

DEPENDS += "python3-setuptools-scm-native"

RDEPENDS:${PN} = "python3-core"
