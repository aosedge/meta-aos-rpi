SUMMARY = "A Python framework for building analytical web applications"
HOMEPAGE = "https://plotly.com/dash"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4679a5b14bd13ac3519492a641576090"

PYPI_PACKAGE = "dash"

inherit pypi setuptools3

SRC_URI[sha256sum] = "ee2d9c319de5dcc1314085710b72cd5fa63ff994d913bf72979b7130daeea28e"

do_install:append() {
    # Remove bundled Jupyter/browser assets not needed on the VM
    rm -rf ${D}${datadir}/jupyter || true
    rm -rf ${D}${prefix}/etc/jupyter || true
    rmdir --ignore-fail-on-non-empty ${D}${datadir} ${D}${prefix}/etc || true
}

RDEPENDS:${PN} = " \
    python3-core \
    python3-flask \
    python3-werkzeug \
    python3-plotly \
    python3-requests \
    python3-ansi2html \
    python3-retrying \
    python3-nest-asyncio \
    python3-importlib-metadata \
"

ALLOW_EMPTY:${PN}-dev = "1"
