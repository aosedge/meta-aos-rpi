# The upstream recipe passes -DProtobuf_LIBRARIES=${STAGING_LIBDIR}, i.e. just a directory.
# That isn't a variable CMake's FindProtobuf module actually reads for its result (the real
# one is the singular Protobuf_LIBRARY, a full path to the .so) so find_package(Protobuf)
# ignores it and CMake falls back to resolving "protobuf" via its own search / the ambient
# linker path. Building the onnx_cpp2py_export Python extension then links against whichever
# libprotobuf.so is found first, which turns out to be the native (x86_64) one from
# recipe-sysroot-native, not the target (aarch64) one from recipe-sysroot -- so the final
# link fails with "error adding symbols: file in wrong format". Point CMake at the actual
# staged target .so via the correct cache variable name so it resolves deterministically.
export CMAKE_ARGS = "-DCMAKE_TOOLCHAIN_FILE=${WORKDIR}/toolchain.cmake \
	-DONNX_USE_PROTOBUF_SHARED_LIBS=ON \
	-DProtobuf_INCLUDE_DIR=${STAGING_INCDIR} \
	-DProtobuf_LIBRARY=${STAGING_LIBDIR}/libprotobuf.so \
	-DPYTHON_INCLUDE_DIR=${STAGING_INCDIR}/${PYTHON_DIR} \
"
