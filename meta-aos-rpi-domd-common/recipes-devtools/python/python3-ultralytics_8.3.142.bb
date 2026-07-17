SUMMARY = "Ultralytics YOLOv8 for SOTA object detection, multi-object tracking, instance segmentation, pose estimation and image classification."
LICENSE = "AGPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=eb1e647870add0502f8f010b19de32af"

DEPENDS = "python3-numpy-native"

inherit pypi python_setuptools_build_meta

SRC_URI[sha256sum] = "b68b49be22af128fff0fe6fa5a4471abac8c513bef9c43fc1394f5388b2c5be3"

# Yocto ships setuptools 69.1.1; relax the lower bound so the build backend check passes
do_configure:prepend() {
    sed -i 's/setuptools>=70\.0\.0/setuptools>=69.0.0/' ${S}/pyproject.toml
}

RDEPENDS:${PN} = " \
	bash \
	python3-matplotlib \
	python3-opencv \
	python3-pillow \
	python3-pyyaml \
	python3-requests \
	python3-scipy \
	python3-pytorch \
	python3-torchvision \
	python3-tqdm \
	python3-pandas \
	python3-psutil \
	python3-ultralytics-thop \
	python3-ipython \
	python3-dill \
	python3-py-cpuinfo \
"
