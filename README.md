# cbc-msys2
MSYS2 shell scripts to compile COIN-OR CBC for Windows platforms

1. `download-prerequisites.sh`: Download CBC, swigwin, and OpenBLAS
2. `inflate-prerequisites.sh`: Extract and move prerequisites to separate source folder
3. `compile-openblas`: Compile OpenBLAS
4. `compile-cbc.sh`: Compile CBC (trunk or release) with or without OpenBLAS, in shared or static form. The former will produce DLLs
5. `compile-jcbc.sh`: Compile jCbc with or without OpenBLAS, needs a statically compiled CBC

`do-all-*.sh <src> <build> <deploydir>` can be used to compile OpenBLAS, compile CBC statically, compile jCBC, and compile CBC shared libraries (CBC trunk is not used). Assumes a Java 7 JDK present. Both 64 and 32 bit versions can be compiled (**important:** make sure to run under the correspondig MSYS2 shell for 32 or 64 bit compilation and to download and inflate the prequisites first to set up the source folder).

Make sure compiler tools are installed:

    pacman -S --needed \
      base-devel \
      mingw-w64-i686-toolchain mingw-w64-i686-cmake \
      mingw-w64-x86_64-toolchain mingw-w64-x86_64-cmake \
      unzip

More information:

- https://github.com/xianyi/OpenBLAS/wiki/Installation-Guide: OpenBLAS installation guide. MSYS2 users will need to modify a makefile to workaround a bug, see https://github.com/xianyi/OpenBLAS/wiki/How-to-use-OpenBLAS-in-Microsoft-Visual-Studio#2-gnu-mingw-abi
- https://github.com/JNICbc/jCbc: for jCbc installation guide. Note that the manual is outdated and uses older MinGW distribution
- https://github.com/nativelibs4java/JNAerator: to generate a JNA class to access the CBC C interface, as an alternative to jCbc. This requires a shared CBC compilation
- https://github.com/JuliaOpt/CbcBuilder/blob/master/build_tarballs.jl: for having the only clear instruction set on how to get CBC to compile a DLL
