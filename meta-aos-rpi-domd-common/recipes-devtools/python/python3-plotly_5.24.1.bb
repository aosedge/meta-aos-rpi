SUMMARY = "An open-source, interactive data visualization library for Python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=c7b311a6fbf8f1e2f22c16e2ad556f98"

PYPI_PACKAGE = "plotly"

inherit pypi setuptools3

SRC_URI[sha256sum] = "dbc8ac8339d248a4bcc36e08a5659bacfe1b079390b8953533f4eb22169b4bae"

do_install:append() {
    rm -rf ${D}${datadir}/jupyter
    rm -rf ${D}${prefix}/etc/jupyter
    # remove empty parent dirs to avoid installed-vs-shipped QA errors
    rmdir --ignore-fail-on-non-empty ${D}${datadir} ${D}${prefix}/etc || true
}

RDEPENDS:${PN} = " \
    python3-core \
    python3-tenacity \
"

ALLOW_EMPTY:${PN}-dev = "1"
