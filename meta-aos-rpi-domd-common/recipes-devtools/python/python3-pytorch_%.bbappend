# shaderc/spirv-tools/mesa are only needed to build pytorch's Vulkan compute backend; the
# upstream recipe already gates vulkan-headers/vulkan-loader in the same DEPENDS:append:class-target
# line on 'vulkan' being in DISTRO_FEATURES, but left these three unconditional. This build's
# DISTRO_FEATURES removes both opengl and vulkan (conf/moulin.conf), so mesa has no buildable
# provider ("one of 'opengl vulkan' needs to be in DISTRO_FEATURES"), breaking any recipe that
# DEPENDS on python3-pytorch (e.g. aos-ml-layer -> python3-ultralytics). Drop the Vulkan-only
# deps to match the existing conditional and let pytorch build without the Vulkan backend.
DEPENDS:remove:class-target = "shaderc spirv-tools mesa"
