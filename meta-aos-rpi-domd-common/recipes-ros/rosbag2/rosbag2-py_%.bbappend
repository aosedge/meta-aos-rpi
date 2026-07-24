# rosbag2-py's CMakeLists.txt (patched upstream in meta-ros to add
# find_package(Python3 COMPONENTS Development Interpreter REQUIRED) so that
# pybind11's python3_add_library()/pybind11_add_module() works) does its own
# CMake Python3 Development detection instead of using the OE target Python3
# variables. Without python3targetconfig pre-seeding Python3_SOABI/
# Python3_EXECUTABLE for the target, CMake falls back to executing whatever
# python3 it can run during configure (the native/build interpreter) to
# compute the extension's EXT_SUFFIX, so the resulting .so is valid target
# (aarch64) code but gets stamped with the host's ABI tag
# (cpython-312-x86_64-linux-gnu instead of cpython-312-aarch64-linux-gnu),
# and Python's import machinery on target then fails with
# "No module named 'rosbag2_py._compression_options'" even though the file
# is present. rclpy hits the same pybind11/CMake issue upstream and fixes it
# the same way (see meta-ros2-jazzy/recipes-bbappends/rclpy/rclpy_%.bbappend).
inherit python3targetconfig
