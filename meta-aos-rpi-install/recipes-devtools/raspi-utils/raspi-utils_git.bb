SUMMARY = "A collection of scripts and simple applications"
DESCRIPTION = "Provided by Raspberry Pi"
HOMEPAGE = "https://github.com/raspberrypi"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENCE;md5=4c01239e5c3a3d133858dedacdbca63c"

DEPENDS:append = " dtc"

PV = "1.0+git"

SRC_URI = "git://github.com/raspberrypi/utils;protocol=https;branch=master"

SRCREV = "b9c63214c535d7df2b0fa6743b7b3e508363c25a"

S = "${UNPACKDIR}/git"

# https://stackoverflow.com/questions/49748528/yocto-files-directories-were-installed-but-not-shipped-in-any-package
# INSANE_SKIP:${PN} += "installed-vs-shipped"

RDEPENDS:${PN} = "perl bash"

inherit cmake
