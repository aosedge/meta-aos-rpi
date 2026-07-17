# Disable AMDGPU offloading plugin and DeviceRTL — old AMD GPU targets
# (gfx7xx/gfx8xx) fail to compile DeviceRTL with __MEMORY_SCOPE_DEVICE
# undeclared and __builtin_amdgcn_s_sendmsg_rtnl missing in clang 18.
# No GPU hardware on this VM target.
EXTRA_OECMAKE += "-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=OFF -DLIBOMPTARGET_BUILD_DEVICERTL_BCLIB=FALSE"
