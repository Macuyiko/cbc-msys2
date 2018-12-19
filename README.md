# cbc-msys2
MSYS2 shell scripts to compile COIN-OR CBC for Windows platforms

- `download-prerequisites.sh`: Download CBC 2.9.9, swigwin, jCbc and conda-forge OpenBLAS binaries
- `inflate-prerequisites.sh`: Extract prerequisites to separate folder
- `compile-cbc.sh`: Compile CBC with or without OpenBLAS, in shared or static form. The former will produce DLLs
- `compile-jcbc.sh`: Compile jCbc with or without OpenBLAS, needs a static CBC

By default, OpenBLAS binaries from conda-forge are used, though a self-compiled OpenBLAS can be used as well (recommended).

More information:

- https://github.com/xianyi/OpenBLAS/wiki/Installation-Guide: OpenBLAS installation guide. MSYS2 users will need to modify a makefile to workaround a bug, see https://github.com/xianyi/OpenBLAS/wiki/How-to-use-OpenBLAS-in-Microsoft-Visual-Studio#2-gnu-mingw-abi
- https://github.com/JNICbc/jCbc: for jCbc installation guide. Note that the manual is outdated and uses older MinGW distribution
- https://github.com/nativelibs4java/JNAerator: to generate a JNA class to access the CBC C interface, as an alternative to jCbc. This requires a shared CBC compilation
- https://github.com/JuliaOpt/CbcBuilder/blob/master/build_tarballs.jl: for having the only clear instruction set on how to get CBC to compile a DLL
