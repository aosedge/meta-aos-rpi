SUMMARY = "Python client for Valkey, a Redis-compatible key-value store"
HOMEPAGE = "https://github.com/valkey-io/valkey-py"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=dc0a2eb1c9e4ca544bd4a04dd072df90"

PYPI_PACKAGE = "valkey"

inherit pypi setuptools3

SRC_URI[sha256sum] = "5880792990c6c2b5eb604a5ed5f98f300880b6dd92d123819b66ed54bb259731"

RDEPENDS:${PN} = " \
    python3-asyncio \
    python3-core \
    python3-json \
    python3-threading \
"
