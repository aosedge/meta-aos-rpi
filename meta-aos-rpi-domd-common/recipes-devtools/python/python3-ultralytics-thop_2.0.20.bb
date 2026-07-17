SUMMARY = "Ultralytics THOP package for fast computation of PyTorch model FLOPs and parameters."
LICENSE = "AGPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4ae09d45eac4aa08d013b5f2e01c67f6"

DEPENDS = "python3-numpy-native"

inherit pypi python_setuptools_build_meta

PYPI_PACKAGE = "ultralytics_thop"
SRC_URI[sha256sum] = "f3595e0d8c6fd0b9f62fc2cd9be921755e2649a05c34f1fabaea0bff7295d641"

# Yocto ships setuptools 69.1.1; relax the lower bound so the build backend check passes
do_configure:prepend() {
    sed -i 's/setuptools>=70\.0\.0/setuptools>=69.0.0/' ${S}/pyproject.toml
}

RDEPENDS:${PN} = " \
	python3-numpy \
	python3-pytorch \
"

RPROVIDES:${PN} = "python3-pytorch-opcounter"
