# Use system qhull to avoid downloading from qhull.org during do_compile.
# The base recipe's do_compile:prepend writes mplsetup.cfg and then expands
# ${ENABLELTO} at the end. On x86_64/GCC, ENABLELTO is empty (the base only
# sets it for toolchain-clang on riscv/mips). We set it here so the base
# prepend appends system_qhull=True after writing freetype — avoiding the
# ordering issue where a bbappend prepend runs before the base prepend.
DEPENDS:append = " qhull"

ENABLELTO = "echo system_qhull = True >> ${S}/mplsetup.cfg"
