# rosidl_default_generators exports rosidl_core_generators as a cmake dependency.
# CMake find_package() resolves it in the target sysroot, so rosidl-core-generators
# must be staged there as a build dependency (not just as a native tool).
ROS_BUILD_DEPENDS += " \
    rosidl-core-generators \
"

# rosidl-default-generators is a code generator (build tool), not a target library.
ROS_BUILDTOOL_DEPENDS += " \
    rosidl-default-generators-native \
"

ROS_BUILD_DEPENDS:remove = " \
    rosidl-default-generators \
"
