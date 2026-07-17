# Fix QA file-rdeps errors: shared libraries installed by this package link to
# these runtime libs, so they must appear in RDEPENDS.
ROS_EXEC_DEPENDS += " \
    fastcdr \
    libpython3 \
    rcutils \
    rosidl-runtime-c \
    rosidl-typesupport-c \
    rosidl-typesupport-cpp \
    rosidl-typesupport-fastrtps-c \
    rosidl-typesupport-fastrtps-cpp \
    rosidl-typesupport-introspection-c \
    rosidl-typesupport-introspection-cpp \
"

# do_compile links the generated *__rosidl_generator_c.so (and the other typesupport
# libs) against these at build time. CMake's AMENT_PREFIX_PATH resolves find_package()
# against both the target and native sysroots; if these aren't staged in the target
# sysroot too, it silently falls back to the native (x86_64) .so and the target linker
# fails with "file in wrong format". So they must also be build (DEPENDS), not just
# runtime (RDEPENDS), dependencies.
ROS_BUILD_DEPENDS += " \
    fastcdr \
    python3 \
    rcutils \
    rosidl-runtime-c \
    rosidl-typesupport-c \
    rosidl-typesupport-cpp \
    rosidl-typesupport-fastrtps-c \
    rosidl-typesupport-fastrtps-cpp \
    rosidl-typesupport-introspection-c \
    rosidl-typesupport-introspection-cpp \
"
