#!/bin/bash

: ${1?"Usage: $0 <src dirname> <build dirname> <options>"}
: ${2?"Usage: $0 <src dirname> <build dirname> <options>"}

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SRCDIR=$1
BUILDDIR=$2

CBCCOPYPATH=$BUILDDIR/cbcsrc
CBCBUILDDIR=$BUILDDIR/cbcbuild
CBCORIGPATH=$SRCDIR/Cbc-*

mkdir $BUILDDIR
rm -R $CBCCOPYPATH
rm -R $CBCBUILDDIR
mkdir $CBCBUILDDIR

THIRTYTWOBIT=0
OPENBLAS=0
SHARED=0
THREADSAFE=0
PARALLEL=1
OPENBLAS_LIB_PATH=$BUILDDIR/openblasbuild/lib
OPENBLAS_INC_PATH=$BUILDDIR/openblasbuild/include

for i in "$@"
do
case $i in
    --32)
    THIRTYTWOBIT=1
    ;;
    --use-trunk)
    CBCORIGPATH=$SRCDIR/trunk-cbc
    ;;
    --openblas)
    OPENBLAS=1
    ;;
    --openblas-lib=*)
    OPENBLAS_LIB_PATH="${i#*=}"
    ;;
    --openblas-inc=*)
    OPENBLAS_INC_PATH="${i#*=}"
    ;;
    --shared)
    SHARED=1
    ;;
    --nopar)
    PARALLEL=0
    ;;
    --threadsafe)
    THREADSAFE=1
    ;;
    *)
    # Ignored
    ;;
esac
done

echo 
echo Building CBC with the following settings:
echo 
echo THIRTYTWOBIT = ${THIRTYTWOBIT}
echo SRCDIR = ${SRCDIR}
echo BUILDDIR = ${BUILDDIR}
echo CBCBUILDDIR = ${CBCBUILDDIR}
echo CBCORIGPATH = ${CBCORIGPATH}
echo CBCCOPYPATH = ${CBCCOPYPATH}
echo OPENBLAS = ${OPENBLAS}
echo OPENBLAS_LIB_PATH = ${OPENBLAS_LIB_PATH}
echo OPENBLAS_INC_PATH = ${OPENBLAS_INC_PATH}
echo SHARED = ${SHARED}
echo PARALLEL = ${PARALLEL}
echo THREADSAFE = ${THREADSAFE}
echo 

cp -R $CBCORIGPATH $CBCCOPYPATH

echo 
echo Obtaining third party libs
echo

cd ${CBCCOPYPATH}/ThirdParty/Mumps
./get.Mumps
cd ${CBCCOPYPATH}/ThirdParty/Metis
./get.Metis

if [ $OPENBLAS == 0 ] 
then
cd ${CBCCOPYPATH}/ThirdParty/Blas
./get.Blas
cd ${CBCCOPYPATH}/ThirdParty/Lapack
./get.Lapack
fi

CONFIGURATION=$'./configure \
  --prefix='"${CBCBUILDDIR}"' \'

if [ $PARALLEL == 1 ] 
then
	CONFIGURATION=$"${CONFIGURATION}"'
  --enable-cbc-parallel \'
fi

if [ $SHARED == 1 ] 
then
if [ $THIRTYTWOBIT == 1 ]
then
	CONFIGURATION=$"${CONFIGURATION}"'
  --build=i686-w64-mingw32 --host=i686-w64-mingw32 --enable-shared --disable-static \
  --enable-dependency-linking lt_cv_deplibs_check_method=pass_all \
  --with-pic \'
else
	CONFIGURATION=$"${CONFIGURATION}"'
  --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --enable-shared --disable-static \
  --enable-dependency-linking lt_cv_deplibs_check_method=pass_all \
  --with-pic \'
fi
fi

if [ $OPENBLAS == 1 ] 
then
	CONFIGURATION=$"${CONFIGURATION}"'
  --with-blas-lib="-L'"${OPENBLAS_LIB_PATH}"' -lopenblas" \
  --with-lapack-lib="-L'"${OPENBLAS_LIB_PATH}"' -lopenblas" \
  --with-blas-incdir="'"${OPENBLAS_INC_PATH}"'" \
  --with-lapack-incdir="'"${OPENBLAS_INC_PATH}"'" \'
fi

if [ $THREADSAFE == 1 ] 
then
	CONFIGURATION=$"${CONFIGURATION}"'
  CDEFS="-DCBC_THREAD_SAFE -DCBC_NO_INTERRUPT -DHAVE_STRUCT_TIMESPEC" \
  CXXDEFS="-DCBC_THREAD_SAFE -DCBC_NO_INTERRUPT -DHAVE_STRUCT_TIMESPEC" \'
fi

if [ $THIRTYTWOBIT == 1 ]
then
	CONFIGURATION=$"${CONFIGURATION}"'
  LDFLAGS="-Wl,--large-address-aware" \'
fi

CONFIGURATION=$"${CONFIGURATION}"'
  '

echo 
echo Using configuration invocation:
echo 
echo "${CONFIGURATION}"
echo 

cd ${CBCCOPYPATH}

eval "$CONFIGURATION"
make -j 2
make install

cd $SCRIPTPATH

